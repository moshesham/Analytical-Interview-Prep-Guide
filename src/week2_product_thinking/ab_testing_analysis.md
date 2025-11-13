# A/B Testing Analysis

## Introduction
Once your A/B test has run for the planned duration and collected sufficient data, it's time to analyze the results. This document provides a comprehensive framework for analyzing A/B test results with statistical rigor, interpreting findings accurately, and making data-informed decisions.

Good analysis goes beyond "Did the treatment win?" to answer:
- How confident are we in the results?
- What's the size of the impact?
- Are there unexpected effects in other metrics?
- How do different user segments respond?
- Should we ship this change?

## Overview: The Analysis Process

```
1. Data Quality Checks → 2. Statistical Analysis → 3. Segmentation → 4. Interpretation → 5. Decision
```

## Step 1: Data Quality Checks

Before diving into statistical analysis, verify your data is trustworthy.

### 1.1 Sample Ratio Mismatch (SRM) Check

Verify the actual split matches your intended split (e.g., 50/50).

```sql
-- Check if assignment ratios match expectations
SELECT 
    variant,
    COUNT(DISTINCT user_id) as user_count,
    ROUND(100.0 * COUNT(DISTINCT user_id) / 
          SUM(COUNT(DISTINCT user_id)) OVER (), 2) as actual_pct,
    50.00 as expected_pct,
    ROUND(100.0 * COUNT(DISTINCT user_id) / 
          SUM(COUNT(DISTINCT user_id)) OVER () - 50.00, 2) as difference
FROM experiment_results
WHERE experiment_name = 'checkout_redesign'
GROUP BY variant;
```

**Expected Output:**
```
variant   | user_count | actual_pct | expected_pct | difference
----------|------------|------------|--------------|------------
control   | 10,123     | 49.87      | 50.00        | -0.13
treatment | 10,181     | 50.13      | 50.00        | +0.13
```

**Interpretation:**
- Difference < 1%: ✅ Good
- Difference 1-2%: ⚠️ Investigate but probably OK
- Difference > 2%: 🚨 Likely SRM issue—don't trust results

**Python SRM Test:**
```python
from scipy import stats

def test_sample_ratio_mismatch(control_count, treatment_count, expected_ratio=0.5):
    """
    Test for Sample Ratio Mismatch using chi-square test
    """
    total = control_count + treatment_count
    expected_control = total * expected_ratio
    expected_treatment = total * (1 - expected_ratio)
    
    observed = [control_count, treatment_count]
    expected = [expected_control, expected_treatment]
    
    chi2, p_value = stats.chisquare(observed, expected)
    
    return {
        'chi_square': chi2,
        'p_value': p_value,
        'srm_detected': p_value < 0.001,  # Strict threshold
        'message': 'SRM DETECTED - Invalid results' if p_value < 0.001 
                   else 'No SRM - Randomization OK'
    }

result = test_sample_ratio_mismatch(10123, 10181)
print(f"P-value: {result['p_value']:.4f}")
print(f"Result: {result['message']}")
```

### 1.2 Assignment Balance Check

Ensure randomization worked correctly—groups should be similar on observable characteristics.

```sql
-- Verify balance across user characteristics
SELECT 
    variant,
    COUNT(DISTINCT user_id) as users,
    -- Demographics
    ROUND(AVG(CASE WHEN country = 'US' THEN 1 ELSE 0 END) * 100, 2) as pct_us,
    ROUND(AVG(CASE WHEN platform = 'iOS' THEN 1 ELSE 0 END) * 100, 2) as pct_ios,
    ROUND(AVG(CASE WHEN is_premium = TRUE THEN 1 ELSE 0 END) * 100, 2) as pct_premium,
    -- Pre-experiment behavior
    ROUND(AVG(days_since_signup), 1) as avg_days_since_signup,
    ROUND(AVG(sessions_last_30d), 1) as avg_sessions_pre_exp,
    ROUND(AVG(purchases_last_90d), 2) as avg_purchases_pre_exp
FROM experiment_results er
JOIN users u ON er.user_id = u.user_id
WHERE er.experiment_name = 'checkout_redesign'
GROUP BY variant;
```

**What to Look For:**
- All metrics should be within 2-3% across variants
- Large imbalances suggest randomization failure

### 1.3 Data Completeness Check

```sql
-- Check for missing data
SELECT 
    variant,
    COUNT(DISTINCT user_id) as total_users,
    COUNT(DISTINCT CASE WHEN primary_metric IS NOT NULL THEN user_id END) as users_with_metric,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN primary_metric IS NOT NULL THEN user_id END) / 
          COUNT(DISTINCT user_id), 2) as pct_complete
FROM experiment_results
WHERE experiment_name = 'checkout_redesign'
GROUP BY variant;
```

**Expected:** > 95% completion rate, similar across variants

## Step 2: Statistical Analysis

### 2.1 Calculate Basic Statistics

```sql
-- Core metrics comparison
WITH variant_metrics AS (
    SELECT 
        variant,
        COUNT(DISTINCT user_id) as sample_size,
        -- Primary metric (e.g., conversion)
        COUNT(DISTINCT CASE WHEN converted = TRUE THEN user_id END) as conversions,
        ROUND(100.0 * COUNT(DISTINCT CASE WHEN converted = TRUE THEN user_id END) / 
              COUNT(DISTINCT user_id), 4) as conversion_rate,
        -- Secondary metrics
        ROUND(AVG(session_duration_minutes), 2) as avg_session_duration,
        ROUND(AVG(pages_viewed), 1) as avg_pages_viewed,
        -- Guardrail metrics
        ROUND(AVG(revenue), 2) as avg_revenue_per_user
    FROM experiment_results
    WHERE experiment_name = 'checkout_redesign'
    GROUP BY variant
)
SELECT 
    *,
    -- Calculate lift vs. control (assumes control is first)
    conversion_rate - FIRST_VALUE(conversion_rate) 
        OVER (ORDER BY variant DESC) as absolute_lift,
    ROUND(100.0 * (conversion_rate - FIRST_VALUE(conversion_rate) 
        OVER (ORDER BY variant DESC)) / 
        FIRST_VALUE(conversion_rate) OVER (ORDER BY variant DESC), 2) as relative_lift_pct
FROM variant_metrics
ORDER BY variant DESC;
```

### 2.2 Statistical Significance Testing

**For Proportions (e.g., Conversion Rate):**

Use Z-test for two proportions:

```python
import numpy as np
from scipy import stats

def z_test_proportions(control_conversions, control_total, 
                       treatment_conversions, treatment_total,
                       alpha=0.05):
    """
    Two-proportion Z-test
    
    Returns: Statistical significance and confidence intervals
    """
    # Calculate proportions
    p1 = control_conversions / control_total
    p2 = treatment_conversions / treatment_total
    
    # Calculate pooled proportion
    p_pool = (control_conversions + treatment_conversions) / (control_total + treatment_total)
    
    # Calculate standard error
    se = np.sqrt(p_pool * (1 - p_pool) * (1/control_total + 1/treatment_total))
    
    # Calculate z-statistic
    z_stat = (p2 - p1) / se
    
    # Calculate p-value (two-tailed)
    p_value = 2 * (1 - stats.norm.cdf(abs(z_stat)))
    
    # Calculate confidence interval for difference
    se_diff = np.sqrt(p1 * (1 - p1) / control_total + p2 * (1 - p2) / treatment_total)
    z_critical = stats.norm.ppf(1 - alpha/2)
    ci_lower = (p2 - p1) - z_critical * se_diff
    ci_upper = (p2 - p1) + z_critical * se_diff
    
    # Effect size
    absolute_lift = p2 - p1
    relative_lift = (p2 - p1) / p1 if p1 > 0 else None
    
    return {
        'control_rate': p1,
        'treatment_rate': p2,
        'absolute_lift': absolute_lift,
        'relative_lift_pct': relative_lift * 100 if relative_lift else None,
        'z_statistic': z_stat,
        'p_value': p_value,
        'is_significant': p_value < alpha,
        'ci_95_lower': ci_lower,
        'ci_95_upper': ci_upper,
        'interpretation': f"{'Significant' if p_value < alpha else 'Not significant'} at α={alpha}"
    }

# Example usage
result = z_test_proportions(
    control_conversions=1250,
    control_total=10000,
    treatment_conversions=1450,
    treatment_total=10000,
    alpha=0.05
)

print(f"Control Rate: {result['control_rate']:.4%}")
print(f"Treatment Rate: {result['treatment_rate']:.4%}")
print(f"Absolute Lift: {result['absolute_lift']:.4%}")
print(f"Relative Lift: {result['relative_lift_pct']:.2f}%")
print(f"P-value: {result['p_value']:.6f}")
print(f"95% CI: [{result['ci_95_lower']:.4%}, {result['ci_95_upper']:.4%}]")
print(f"Result: {result['interpretation']}")
```

**Output:**
```
Control Rate: 12.5000%
Treatment Rate: 14.5000%
Absolute Lift: 2.0000%
Relative Lift: 16.00%
P-value: 0.000032
95% CI: [1.09%, 2.91%]
Result: Significant at α=0.05
```

**For Continuous Metrics (e.g., Revenue, Session Duration):**

Use T-test:

```python
def t_test_continuous(control_values, treatment_values, alpha=0.05):
    """
    Two-sample t-test for continuous metrics
    
    Parameters:
    - control_values: Array of values for control group
    - treatment_values: Array of values for treatment group
    """
    # Calculate means and standard deviations
    control_mean = np.mean(control_values)
    treatment_mean = np.mean(treatment_values)
    control_std = np.std(control_values, ddof=1)
    treatment_std = np.std(treatment_values, ddof=1)
    
    # Perform t-test (Welch's t-test, doesn't assume equal variances)
    t_stat, p_value = stats.ttest_ind(treatment_values, control_values, equal_var=False)
    
    # Calculate confidence interval
    se = np.sqrt(control_std**2 / len(control_values) + 
                 treatment_std**2 / len(treatment_values))
    df = len(control_values) + len(treatment_values) - 2
    t_critical = stats.t.ppf(1 - alpha/2, df)
    
    diff = treatment_mean - control_mean
    ci_lower = diff - t_critical * se
    ci_upper = diff + t_critical * se
    
    # Effect size (Cohen's d)
    pooled_std = np.sqrt((control_std**2 + treatment_std**2) / 2)
    cohens_d = diff / pooled_std
    
    return {
        'control_mean': control_mean,
        'treatment_mean': treatment_mean,
        'absolute_lift': diff,
        'relative_lift_pct': (diff / control_mean * 100) if control_mean != 0 else None,
        't_statistic': t_stat,
        'p_value': p_value,
        'is_significant': p_value < alpha,
        'ci_95_lower': ci_lower,
        'ci_95_upper': ci_upper,
        'cohens_d': cohens_d,
        'effect_size': 'small' if abs(cohens_d) < 0.5 else 'medium' if abs(cohens_d) < 0.8 else 'large'
    }

# Example usage
np.random.seed(42)
control_revenue = np.random.normal(50, 20, 10000)
treatment_revenue = np.random.normal(53, 20, 10000)  # +$3 lift

result = t_test_continuous(control_revenue, treatment_revenue)
print(f"Control Mean: ${result['control_mean']:.2f}")
print(f"Treatment Mean: ${result['treatment_mean']:.2f}")
print(f"Lift: ${result['absolute_lift']:.2f} ({result['relative_lift_pct']:.2f}%)")
print(f"P-value: {result['p_value']:.6f}")
print(f"Effect Size: {result['effect_size']} (Cohen's d = {result['cohens_d']:.3f})")
```

### 2.3 Practical Significance vs. Statistical Significance

**Statistical significance** (p < 0.05) means the result is unlikely due to chance.
**Practical significance** means the result matters for the business.

```python
def evaluate_significance(p_value, effect_size_pct, 
                         min_worthwhile_effect_pct=5.0,
                         alpha=0.05):
    """
    Evaluate both statistical and practical significance
    """
    statistically_significant = p_value < alpha
    practically_significant = abs(effect_size_pct) >= min_worthwhile_effect_pct
    
    if statistically_significant and practically_significant:
        decision = "SHIP IT ✅"
        reason = "Both statistically and practically significant"
    elif statistically_significant and not practically_significant:
        decision = "DON'T SHIP ❌"
        reason = "Significant but effect too small to matter"
    elif not statistically_significant and practically_significant:
        decision = "INCONCLUSIVE ⚠️"
        reason = "Large effect but not statistically significant - consider running longer"
    else:
        decision = "DON'T SHIP ❌"
        reason = "Neither statistically nor practically significant"
    
    return {
        'decision': decision,
        'reason': reason,
        'stat_sig': statistically_significant,
        'pract_sig': practically_significant,
        'p_value': p_value,
        'effect_size_pct': effect_size_pct
    }

# Example
result = evaluate_significance(p_value=0.03, effect_size_pct=2.5, min_worthwhile_effect_pct=5.0)
print(f"Decision: {result['decision']}")
print(f"Reason: {result['reason']}")
```

## Step 3: Analyze Secondary and Guardrail Metrics

Never look at just one metric in isolation.

```sql
-- Comprehensive metrics scorecard
WITH metrics_by_variant AS (
    SELECT 
        variant,
        -- Sample size
        COUNT(DISTINCT user_id) as users,
        
        -- PRIMARY METRIC
        ROUND(AVG(CASE WHEN converted = TRUE THEN 1 ELSE 0 END) * 100, 2) as conversion_rate,
        
        -- SECONDARY METRICS
        ROUND(AVG(cart_additions), 2) as avg_cart_additions,
        ROUND(AVG(time_to_purchase_minutes), 1) as avg_time_to_purchase,
        ROUND(AVG(CASE WHEN completed_onboarding = TRUE THEN 1 ELSE 0 END) * 100, 2) as onboarding_completion,
        
        -- GUARDRAIL METRICS
        ROUND(AVG(revenue), 2) as avg_revenue_per_user,
        ROUND(AVG(CASE WHEN returned_7d = TRUE THEN 1 ELSE 0 END) * 100, 2) as day7_retention,
        ROUND(AVG(support_tickets), 3) as avg_support_tickets,
        ROUND(AVG(page_load_time_ms), 0) as avg_page_load_ms
    FROM experiment_results
    WHERE experiment_name = 'checkout_redesign'
    GROUP BY variant
)
SELECT 
    'Primary' as metric_type,
    'Conversion Rate' as metric_name,
    conversion_rate as value,
    LAG(conversion_rate) OVER (ORDER BY variant DESC) as control_value,
    conversion_rate - LAG(conversion_rate) OVER (ORDER BY variant DESC) as absolute_change,
    ROUND(100.0 * (conversion_rate - LAG(conversion_rate) OVER (ORDER BY variant DESC)) / 
          NULLIF(LAG(conversion_rate) OVER (ORDER BY variant DESC), 0), 2) as pct_change
FROM metrics_by_variant

UNION ALL

SELECT 'Secondary', 'Avg Cart Additions', avg_cart_additions, 
       LAG(avg_cart_additions) OVER (ORDER BY variant DESC),
       avg_cart_additions - LAG(avg_cart_additions) OVER (ORDER BY variant DESC),
       ROUND(100.0 * (avg_cart_additions - LAG(avg_cart_additions) OVER (ORDER BY variant DESC)) / 
             NULLIF(LAG(avg_cart_additions) OVER (ORDER BY variant DESC), 0), 2)
FROM metrics_by_variant

-- Add more metrics...

ORDER BY metric_type, metric_name;
```

### Interpreting Mixed Results

**Scenario 1: Primary ✅, Guardrails ❌**
```
Primary: Conversion rate +10% (p=0.01) ✅
Guardrail: Revenue per user -5% (p=0.04) ❌

Interpretation: More conversions but lower quality
Decision: DON'T SHIP - attracting wrong users or cannibalizing higher-value conversions
```

**Scenario 2: Primary ✅, Some Secondaries ❌**
```
Primary: Sign-ups +15% (p<0.001) ✅
Secondary: Activation rate -3% (p=0.08) ⚠️
Secondary: Time to first action +20% (p=0.02) ❌

Interpretation: More sign-ups but worse onboarding experience
Decision: INVESTIGATE - maybe new users need better onboarding
```

## Step 4: Segment Analysis

Aggregate results can hide important patterns. Always segment your analysis.

### Common Segmentations

```sql
-- Segment by user characteristics
WITH segmented_results AS (
    SELECT 
        variant,
        -- Segmentation dimensions
        platform,
        user_country,
        user_tenure_bucket,
        
        -- Metrics
        COUNT(DISTINCT user_id) as users,
        ROUND(AVG(CASE WHEN converted = TRUE THEN 1 ELSE 0 END) * 100, 2) as conversion_rate
    FROM experiment_results er
    JOIN users u ON er.user_id = u.user_id
    WHERE er.experiment_name = 'checkout_redesign'
      AND u.user_tenure_bucket IN ('new', 'returning', 'power')
    GROUP BY variant, platform, user_country, user_tenure_bucket
)
SELECT 
    platform,
    user_country,
    user_tenure_bucket,
    MAX(CASE WHEN variant = 'control' THEN conversion_rate END) as control_rate,
    MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END) as treatment_rate,
    MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END) - 
        MAX(CASE WHEN variant = 'control' THEN conversion_rate END) as absolute_lift,
    ROUND(100.0 * (MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END) - 
                    MAX(CASE WHEN variant = 'control' THEN conversion_rate END)) / 
          NULLIF(MAX(CASE WHEN variant = 'control' THEN conversion_rate END), 0), 2) as relative_lift_pct
FROM segmented_results
GROUP BY platform, user_country, user_tenure_bucket
HAVING SUM(users) >= 100  -- Only segments with sufficient sample
ORDER BY ABS(relative_lift_pct) DESC;
```

### Identifying Winning/Losing Segments

**Example Output:**
```
platform | country | tenure  | control_rate | treatment_rate | absolute_lift | relative_lift_pct
---------|---------|---------|--------------|----------------|---------------|------------------
iOS      | US      | new     | 10.5%        | 13.2%          | +2.7%         | +25.7%  ✅
Android  | US      | new     | 11.2%        | 12.8%          | +1.6%         | +14.3%  ✅
iOS      | US      | power   | 18.3%        | 17.1%          | -1.2%         | -6.6%   ❌
Android  | UK      | return  | 12.8%        | 13.1%          | +0.3%         | +2.3%   ~
```

**Interpretation:**
- Treatment wins for new users (+15-26%) ✅
- Treatment loses for power users (-6.6%) ❌
- Mixed/small effects for returning users

**Possible Actions:**
1. Ship for new users only
2. Investigate why power users dislike the change
3. Consider different version for different segments

### Simpson's Paradox

**Warning:** Sometimes treatment can win in every segment but lose overall (or vice versa).

**Example:**
```
Segment A: Control 10/100 (10%), Treatment 20/150 (13.3%) → Treatment wins +3.3%
Segment B: Control 80/900 (8.9%), Treatment 40/750 (5.3%) → Treatment wins... wait, loses -3.6%

Overall: Control 90/1000 (9%), Treatment 60/900 (6.7%) → Treatment LOSES -2.3%
```

**Always look at both aggregate AND segmented results.**

## Step 5: Making the Decision

### Decision Framework

```python
def make_experiment_decision(primary_metric_result, 
                            guardrail_results,
                            segment_results,
                            min_effect_worthwhile=5.0):
    """
    Structured decision framework for experiment results
    """
    decision_factors = {
        'primary_significant': primary_metric_result['is_significant'],
        'primary_positive': primary_metric_result['lift_pct'] > 0,
        'primary_meaningful': abs(primary_metric_result['lift_pct']) >= min_effect_worthwhile,
        'guardrails_ok': all(g['degradation_pct'] < 5 for g in guardrail_results),
        'segments_consistent': segment_results['max_lift'] * segment_results['min_lift'] > 0
    }
    
    if (decision_factors['primary_significant'] and 
        decision_factors['primary_positive'] and 
        decision_factors['primary_meaningful'] and
        decision_factors['guardrails_ok']):
        
        if decision_factors['segments_consistent']:
            return {
                'decision': 'SHIP TO 100%',
                'confidence': 'HIGH',
                'reasoning': 'Strong, consistent positive results across all metrics'
            }
        else:
            return {
                'decision': 'SHIP TO WINNING SEGMENTS',
                'confidence': 'MEDIUM',
                'reasoning': 'Positive overall but some segments respond differently'
            }
    
    elif (decision_factors['primary_significant'] and 
          decision_factors['primary_positive'] and
          not decision_factors['guardrails_ok']):
        return {
            'decision': 'DO NOT SHIP',
            'confidence': 'HIGH',
            'reasoning': 'Primary improved but guardrails degraded - unacceptable trade-off'
        }
    
    elif not decision_factors['primary_significant']:
        if decision_factors['primary_meaningful']:
            return {
                'decision': 'RUN LONGER / INCREASE SAMPLE',
                'confidence': 'LOW',
                'reasoning': 'Effect size is meaningful but not yet statistically significant'
            }
        else:
            return {
                'decision': 'DO NOT SHIP',
                'confidence': 'HIGH',
                'reasoning': 'No significant effect detected'
            }
    
    else:
        return {
            'decision': 'INVESTIGATE FURTHER',
            'confidence': 'LOW',
            'reasoning': 'Results are ambiguous - need more analysis'
        }
```

### Decision Matrix

| Primary Metric | Guardrail Metrics | Decision | Action |
|----------------|-------------------|----------|--------|
| ✅ Significant improvement | ✅ All stable | **SHIP IT** | Full rollout |
| ✅ Significant improvement | ⚠️ One slightly worse | **INVESTIGATE** | Analyze trade-offs |
| ✅ Significant improvement | ❌ Multiple worse | **DON'T SHIP** | Redesign |
| ~ Small improvement | ✅ All stable | **DON'T SHIP** | Not worth complexity |
| ❌ No effect | ✅ All stable | **DON'T SHIP** | Learn and iterate |
| ❌ Negative effect | — | **DON'T SHIP** | Major red flag |

## Step 6: Reporting Results

### Executive Summary Template

```markdown
# A/B Test Results: [Experiment Name]

## 🎯 Recommendation: [SHIP / DON'T SHIP / INVESTIGATE]

## Key Findings
- **Primary Metric:** [Metric Name] increased by [X]% ([baseline] → [new rate])
  - Statistically significant (p = [value], 95% CI: [range])
  - Practically significant (exceeds [Y]% threshold)
- **User Impact:** [X,XXX] users affected, [X]% improvement in [key behavior]
- **Guardrail Metrics:** All stable (no degradation > 2%)

## Results Summary

| Metric | Control | Treatment | Absolute Lift | Relative Lift | P-value | Significant? |
|--------|---------|-----------|---------------|---------------|---------|--------------|
| **Conversion Rate** | 12.5% | 14.5% | +2.0 pp | +16.0% | <0.001 | ✅ Yes |
| Cart Additions | 2.3 | 2.5 | +0.2 | +8.7% | 0.02 | ✅ Yes |
| Revenue per User | $45.20 | $46.80 | +$1.60 | +3.5% | 0.12 | ❌ No |
| **Day 7 Retention** | 68% | 67% | -1 pp | -1.5% | 0.35 | ❌ No |

## Segment Analysis
- **New users:** +25% conversion (strong win) ✅
- **Returning users:** +8% conversion (moderate win) ✅
- **Power users:** -3% conversion (slight loss) ⚠️

## Recommendation
**SHIP to new and returning users (90% of user base).**
Continue monitoring power user experience and consider follow-up test.

## Next Steps
1. Roll out to 100% of new/returning users (Week 1)
2. Design specialized experience for power users (Week 2-3)
3. Monitor metrics for 2 weeks post-launch
4. Document learnings for future tests
```

### Visualization Examples

```python
import matplotlib.pyplot as plt
import seaborn as sns

def plot_experiment_results(control_rate, treatment_rate, 
                           ci_lower, ci_upper,
                           metric_name='Conversion Rate'):
    """
    Create publication-quality visualization of A/B test results
    """
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))
    
    # Plot 1: Conversion rates with confidence intervals
    variants = ['Control', 'Treatment']
    rates = [control_rate, treatment_rate]
    errors = [0, (ci_upper - ci_lower) / 2]  # Simplified for visualization
    
    ax1.bar(variants, rates, color=['#3498db', '#2ecc71'], alpha=0.7, width=0.6)
    ax1.errorbar(variants, rates, yerr=errors, fmt='none', ecolor='black', capsize=10, linewidth=2)
    ax1.set_ylabel(metric_name, fontsize=12)
    ax1.set_title(f'{metric_name} by Variant', fontsize=14, fontweight='bold')
    ax1.grid(axis='y', alpha=0.3)
    
    for i, (variant, rate) in enumerate(zip(variants, rates)):
        ax1.text(i, rate + 0.005, f'{rate:.2%}', ha='center', fontweight='bold')
    
    # Plot 2: Lift visualization
    lift = treatment_rate - control_rate
    lift_pct = (lift / control_rate) * 100
    
    ax2.barh(['Lift'], [lift_pct], color='#2ecc71' if lift > 0 else '#e74c3c', height=0.4)
    ax2.axvline(0, color='black', linestyle='--', linewidth=1)
    ax2.set_xlabel('Relative Lift (%)', fontsize=12)
    ax2.set_title('Treatment Effect Size', fontsize=14, fontweight='bold')
    ax2.grid(axis='x', alpha=0.3)
    ax2.text(lift_pct + (1 if lift > 0 else -1), 0, f'{lift_pct:+.1f}%', 
             va='center', fontweight='bold', fontsize=14)
    
    plt.tight_layout()
    return fig

# Example usage
# fig = plot_experiment_results(0.125, 0.145, 0.130, 0.160)
# plt.savefig('experiment_results.png', dpi=300, bbox_inches='tight')
```

## Common Pitfalls in Analysis

### 1. P-Hacking / Data Dredging
❌ **Wrong:** "Let me check 50 different segments until I find one that's significant"
✅ **Right:** Pre-define segments of interest before looking at results

### 2. Ignoring Multiple Testing
❌ **Wrong:** Test 20 metrics, claim victory on the 1 that's significant
✅ **Right:** Apply Bonferroni correction or focus on pre-specified primary metric

### 3. Confusing Statistical and Practical Significance
❌ **Wrong:** "P-value is 0.001, let's ship!" (but effect is only +0.5%)
✅ **Right:** "Statistically significant but effect too small to matter"

### 4. Stopping Early (Peeking)
❌ **Wrong:** Check every day and stop when significant
✅ **Right:** Wait for planned duration, or use sequential testing methods

### 5. Ignoring Novelty Effects
❌ **Wrong:** Week 1 shows +30%, ship immediately
✅ **Right:** Run for 3-4 weeks to see if effect persists

### 6. Not Checking Guardrails
❌ **Wrong:** "Engagement is up 20%, ship it!" (Revenue is down 15%)
✅ **Right:** "Engagement up but revenue down - need to understand why"

## Interview Framework: Analyzing A/B Test Results

**Q: "An A/B test shows conversion rate increased by 2% (10% → 12%), with p-value = 0.04. What do you do?"**

**Strong Answer Structure:**

"Before making a recommendation, I'd want to understand several things:

**1. Verify Data Quality:**
- Check for sample ratio mismatch
- Verify randomization balance
- Look for data quality issues

**2. Assess Significance:**
- P=0.04 is statistically significant at α=0.05 ✅
- But is a 2 percentage point (20% relative lift) meaningful for the business?
- Need to know: What's the minimum effect worth the implementation cost?

**3. Check Other Metrics:**
- What happened to guardrail metrics (revenue, retention)?
- Are secondary metrics aligned or conflicting?

**4. Segment Analysis:**
- Does the 2% lift hold across all user segments?
- Or is it driven by one segment while hurting others?

**5. Confidence Interval:**
- What's the 95% CI? Is it [0.5%, 3.5%] or [0.1%, 3.9%]?
- Narrow CI = more confident in estimate

**My Recommendation:**
- **If** guardrails are stable AND effect is consistent across segments AND business considers 20% lift meaningful:
  - **SHIP IT** with monitoring plan
- **If** guardrails degraded OR very inconsistent across segments:
  - **INVESTIGATE FURTHER** before shipping
- **If** effect is at lower end of CI:
  - Consider **running longer** to reduce uncertainty"

## Conclusion

Effective A/B test analysis requires:
1. **Rigor:** Proper statistical methods and quality checks
2. **Comprehensiveness:** Look beyond primary metric
3. **Nuance:** Segment analysis and edge case consideration
4. **Judgment:** Balance statistical and practical significance
5. **Communication:** Clear recommendations with supporting evidence

**Key Takeaways:**
- Always check data quality before analysis (SRM, balance)
- Use appropriate statistical tests for your metric type
- Consider both statistical and practical significance
- Analyze segments—aggregate results can be misleading
- Look at guardrail metrics—don't optimize one metric at expense of others
- Make clear, defensible recommendations
- Document everything for future learning

## Additional Resources

- **Statistical Methods:** "Trustworthy Online Controlled Experiments" (Kohavi et al.)
- **Pitfalls:** Microsoft's "Seven Rules of Thumb for A/B Testing"
- **Tools:** Python scipy.stats, R, SQL for analysis
- **Case Studies:** Booking.com, Netflix, Airbnb experiment blogs