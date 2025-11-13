# A/B Testing Analysis: A Comprehensive Guide

## Introduction
A/B testing (also called split testing or randomized controlled experiments) is the gold standard for measuring causal impact in product development. This guide covers how to analyze A/B tests rigorously, interpret results correctly, and make data-driven decisions.

---

## 1. Key Metrics Framework

### Primary Metric
- **Definition**: The main success metric you're trying to move
- **Characteristics**: 
  - Directly tied to business objectives
  - Sensitive to changes (not too noisy)
  - Measurable quickly (within test duration)
- **Examples**: 
  - Conversion rate
  - Revenue per user
  - Engagement rate
  - Click-through rate (CTR)

### Secondary Metrics
- **Purpose**: Understand broader impact and trade-offs
- **Examples**:
  - Time on site
  - Pages per session
  - Feature adoption
  - Content creation

### Guardrail Metrics
- **Purpose**: Ensure changes don't harm critical aspects of the product
- **Examples**:
  - Page load time
  - Error rates
  - User satisfaction (NPS)
  - Revenue (if not primary metric)

**Best Practice**: Define all metrics before the test starts (pre-registration).

---

## 2. Statistical Analysis Framework

### Step 1: Check Randomization (Sanity Checks)

Before analyzing primary metrics, verify randomization worked:

```python
import pandas as pd
from scipy import stats

# Check if groups are balanced
print("Sample sizes:")
print(df.groupby('variant').size())

# Chi-square test for balance
observed = df.groupby('variant').size()
expected = [len(df)/2, len(df)/2]
chi2, p_value = stats.chisquare(observed, expected)
print(f"Balance test p-value: {p_value:.4f}")

# Check baseline metrics are similar
baseline_metrics = ['age', 'prior_purchases', 'signup_date']
for metric in baseline_metrics:
    control = df[df['variant'] == 'control'][metric]
    treatment = df[df['variant'] == 'treatment'][metric]
    t_stat, p_value = stats.ttest_ind(treatment, control)
    print(f"{metric} - p-value: {p_value:.4f}")
```

**Red flags**:
- Significantly unbalanced group sizes
- Pre-experiment metrics differ between groups
- Sample Ratio Mismatch (SRM)

---

### Step 2: Calculate Primary Metric

#### For Proportions (e.g., Conversion Rate)

```python
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep
import numpy as np

# Calculate conversion rates
control_df = df[df['variant'] == 'control']
treatment_df = df[df['variant'] == 'treatment']

control_conv = control_df['converted'].sum()
control_users = len(control_df)
treatment_conv = treatment_df['converted'].sum()
treatment_users = len(treatment_df)

control_rate = control_conv / control_users
treatment_rate = treatment_conv / treatment_users

print(f"Control conversion rate: {control_rate:.4%}")
print(f"Treatment conversion rate: {treatment_rate:.4%}")
print(f"Absolute lift: {(treatment_rate - control_rate):.4%}")
print(f"Relative lift: {((treatment_rate / control_rate - 1)):.2%}")
```

#### For Continuous Metrics (e.g., Revenue Per User)

```python
control_revenue = control_df['revenue'].values
treatment_revenue = treatment_df['revenue'].values

print(f"Control mean: ${control_revenue.mean():.2f}")
print(f"Treatment mean: ${treatment_revenue.mean():.2f}")
print(f"Absolute difference: ${treatment_revenue.mean() - control_revenue.mean():.2f}")
print(f"Relative lift: {((treatment_revenue.mean() / control_revenue.mean() - 1)):.2%}")
```

---

### Step 3: Statistical Significance Testing

#### For Proportions: Z-test

```python
# Two-proportion z-test
counts = np.array([treatment_conv, control_conv])
nobs = np.array([treatment_users, control_users])

z_stat, p_value = proportions_ztest(counts, nobs, alternative='two-sided')

print(f"\nStatistical Test Results:")
print(f"Z-statistic: {z_stat:.4f}")
print(f"P-value: {p_value:.4f}")

if p_value < 0.05:
    print("✓ Statistically significant at α=0.05")
else:
    print("✗ Not statistically significant at α=0.05")
```

#### For Continuous Metrics: t-test

```python
from scipy import stats

t_stat, p_value = stats.ttest_ind(treatment_revenue, control_revenue)

print(f"T-statistic: {t_stat:.4f}")
print(f"P-value: {p_value:.4f}")
```

---

### Step 4: Calculate Confidence Intervals

Confidence intervals provide a range of plausible effect sizes.

#### For Proportions

```python
# 95% CI for difference in proportions
ci_low, ci_high = confint_proportions_2indep(
    control_conv, control_users,
    treatment_conv, treatment_users,
    method='wald'
)

print(f"\n95% Confidence Interval for difference:")
print(f"[{ci_low:.4%}, {ci_high:.4%}]")

# Does the CI include 0?
if ci_low > 0:
    print("✓ Entire CI is positive - clear improvement")
elif ci_high < 0:
    print("✗ Entire CI is negative - clear degradation")
else:
    print("⚠ CI includes 0 - effect is uncertain")
```

#### For Continuous Metrics

```python
from scipy import stats

# Calculate standard error
se = np.sqrt(
    treatment_revenue.var() / len(treatment_revenue) + 
    control_revenue.var() / len(control_revenue)
)

# 95% CI
diff = treatment_revenue.mean() - control_revenue.mean()
margin = 1.96 * se  # 1.96 for 95% CI

ci_low = diff - margin
ci_high = diff + margin

print(f"95% CI: [${ci_low:.2f}, ${ci_high:.2f}]")
```

---

### Step 5: Effect Size and Practical Significance

Statistical significance ≠ Practical significance

```python
# Calculate effect size (Cohen's d for continuous metrics)
pooled_std = np.sqrt(
    ((len(control_revenue) - 1) * control_revenue.var() + 
     (len(treatment_revenue) - 1) * treatment_revenue.var()) /
    (len(control_revenue) + len(treatment_revenue) - 2)
)

cohens_d = (treatment_revenue.mean() - control_revenue.mean()) / pooled_std

print(f"\nEffect Size (Cohen's d): {cohens_d:.3f}")
print("Interpretation:")
if abs(cohens_d) < 0.2:
    print("  Small effect")
elif abs(cohens_d) < 0.5:
    print("  Medium effect")
else:
    print("  Large effect")

# Business impact
annual_impact = (treatment_rate - control_rate) * total_annual_users * revenue_per_conversion
print(f"\nEstimated annual impact: ${annual_impact:,.0f}")
```

---

## 3. Analyzing Secondary and Guardrail Metrics

```python
# Analyze all metrics
metrics_to_check = {
    'engagement': 'mean',
    'session_length': 'mean',
    'page_views': 'mean',
    'error_rate': 'mean',
    'load_time': 'mean'
}

results = []
for metric, agg in metrics_to_check.items():
    control_val = control_df[metric].agg(agg)
    treatment_val = treatment_df[metric].agg(agg)
    
    # Statistical test
    t_stat, p_val = stats.ttest_ind(
        treatment_df[metric], 
        control_df[metric]
    )
    
    results.append({
        'metric': metric,
        'control': control_val,
        'treatment': treatment_val,
        'change': treatment_val - control_val,
        'change_pct': (treatment_val / control_val - 1) * 100,
        'p_value': p_val,
        'significant': p_val < 0.05
    })

results_df = pd.DataFrame(results)
print(results_df)

# Flag concerning changes
concerns = results_df[
    (results_df['significant']) & 
    (results_df['metric'].isin(['error_rate', 'load_time'])) &
    (results_df['change'] > 0)
]

if len(concerns) > 0:
    print("\n⚠ WARNING: Guardrail metrics degraded:")
    print(concerns[['metric', 'change_pct', 'p_value']])
```

---

## 4. Segmentation Analysis

Understanding if effects differ across user segments:

```python
# Analyze by segment
segments = ['new_user', 'country', 'device_type']

for segment in segments:
    print(f"\n--- Analysis by {segment} ---")
    
    for seg_value in df[segment].unique():
        seg_df = df[df[segment] == seg_value]
        
        control_seg = seg_df[seg_df['variant'] == 'control']['converted'].mean()
        treatment_seg = seg_df[seg_df['variant'] == 'treatment']['converted'].mean()
        
        lift = (treatment_seg / control_seg - 1) * 100 if control_seg > 0 else 0
        
        print(f"{seg_value}: Control={control_seg:.2%}, "
              f"Treatment={treatment_seg:.2%}, Lift={lift:+.1f}%")
```

**Insights to look for**:
- Is the effect consistent across segments?
- Are there segments where the treatment performs worse?
- Should we launch to all users or just certain segments?

---

## 5. Time-Based Analysis

Check for novelty effects and time trends:

```python
import matplotlib.pyplot as plt

# Daily conversion rates
daily_metrics = df.groupby(['date', 'variant'])['converted'].mean().reset_index()

plt.figure(figsize=(12, 6))
for variant in ['control', 'treatment']:
    data = daily_metrics[daily_metrics['variant'] == variant]
    plt.plot(data['date'], data['converted'], label=variant, marker='o')

plt.xlabel('Date')
plt.ylabel('Conversion Rate')
plt.title('Conversion Rate Over Time')
plt.legend()
plt.xticks(rotation=45)
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()

# Test for novelty effect (compare first week vs. rest)
first_week = df[df['date'] <= df['date'].min() + pd.Timedelta(days=7)]
rest = df[df['date'] > df['date'].min() + pd.Timedelta(days=7)]

print("\nFirst week lift:", 
      (first_week[first_week['variant']=='treatment']['converted'].mean() /
       first_week[first_week['variant']=='control']['converted'].mean() - 1))

print("Subsequent weeks lift:",
      (rest[rest['variant']=='treatment']['converted'].mean() /
       rest[rest['variant']=='control']['converted'].mean() - 1))
```

---

## 6. Complete Analysis Report Template

```python
def generate_ab_test_report(df, primary_metric, test_name):
    """
    Generate comprehensive A/B test analysis report
    """
    print(f"{'='*60}")
    print(f"A/B Test Analysis Report: {test_name}")
    print(f"{'='*60}\n")
    
    # 1. Sample sizes
    print("1. SAMPLE SIZES")
    print(df.groupby('variant').size())
    print()
    
    # 2. Primary metric
    print(f"2. PRIMARY METRIC: {primary_metric}")
    control = df[df['variant'] == 'control'][primary_metric]
    treatment = df[df['variant'] == 'treatment'][primary_metric]
    
    control_mean = control.mean()
    treatment_mean = treatment.mean()
    
    print(f"Control: {control_mean:.4f}")
    print(f"Treatment: {treatment_mean:.4f}")
    print(f"Absolute lift: {treatment_mean - control_mean:.4f}")
    print(f"Relative lift: {(treatment_mean / control_mean - 1) * 100:.2f}%")
    
    # 3. Statistical test
    print("\n3. STATISTICAL SIGNIFICANCE")
    t_stat, p_value = stats.ttest_ind(treatment, control)
    print(f"P-value: {p_value:.4f}")
    print(f"Significant at α=0.05: {'Yes ✓' if p_value < 0.05 else 'No ✗'}")
    
    # 4. Confidence interval
    print("\n4. CONFIDENCE INTERVAL (95%)")
    se = np.sqrt(treatment.var()/len(treatment) + control.var()/len(control))
    margin = 1.96 * se
    print(f"[{treatment_mean - control_mean - margin:.4f}, "
          f"{treatment_mean - control_mean + margin:.4f}]")
    
    # 5. Recommendation
    print("\n5. RECOMMENDATION")
    if p_value < 0.05 and treatment_mean > control_mean:
        print("✓ LAUNCH: Treatment shows statistically significant improvement")
    elif p_value < 0.05 and treatment_mean < control_mean:
        print("✗ DO NOT LAUNCH: Treatment shows statistically significant degradation")
    else:
        print("⚠ INCONCLUSIVE: No statistically significant difference detected")
    
    print(f"\n{'='*60}\n")

# Usage
generate_ab_test_report(df, 'converted', 'New Checkout Flow Test')
```

---

## 7. Common Pitfalls and How to Avoid Them

### Pitfall 1: Peeking at Results
**Problem**: Checking p-values multiple times inflates Type I error

**Solution**: 
- Pre-specify sample size and test duration
- Use sequential testing methods if you must peek
- Apply alpha spending functions

### Pitfall 2: Multiple Testing
**Problem**: Testing many metrics increases false positives

**Solution**:
- Distinguish primary vs. secondary metrics
- Apply Bonferroni or FDR correction for secondary metrics
- Pre-register which metrics you'll test

```python
from statsmodels.stats.multitest import multipletests

# Multiple metrics tested
p_values = [0.03, 0.15, 0.08, 0.45, 0.02]
metrics = ['conversion', 'engagement', 'revenue', 'time_on_site', 'retention']

# Bonferroni correction
reject, p_adjusted, _, _ = multipletests(p_values, method='bonferroni')

results = pd.DataFrame({
    'metric': metrics,
    'p_value': p_values,
    'p_adjusted': p_adjusted,
    'significant': reject
})
print(results)
```

### Pitfall 3: Ignoring Sample Ratio Mismatch (SRM)
**Problem**: Unequal group sizes suggest implementation issues

**Solution**: Always check group sizes match expected ratio

### Pitfall 4: Stopping Early When Significant
**Problem**: Leads to inflated effect size estimates

**Solution**: Commit to duration/sample size upfront

### Pitfall 5: Confusing Statistical and Practical Significance
**Problem**: Statistically significant doesn't mean worth implementing

**Solution**: Always evaluate business impact and cost

---

## 8. Advanced Topics

### Bayesian A/B Testing
Alternative approach that provides probability of superiority:

```python
import numpy as np
from scipy import stats as sp_stats

# Beta-Binomial model for conversion rates
alpha_prior, beta_prior = 1, 1  # Uniform prior

# Posterior distributions
control_posterior = sp_stats.beta(
    alpha_prior + control_conv,
    beta_prior + control_users - control_conv
)

treatment_posterior = sp_stats.beta(
    alpha_prior + treatment_conv,
    beta_prior + treatment_users - treatment_conv
)

# Monte Carlo simulation to calculate P(treatment > control)
n_samples = 100000
control_samples = control_posterior.rvs(n_samples)
treatment_samples = treatment_posterior.rvs(n_samples)

prob_treatment_better = (treatment_samples > control_samples).mean()

print(f"P(Treatment > Control): {prob_treatment_better:.2%}")
print(f"P(Control > Treatment): {1 - prob_treatment_better:.2%}")
```

### Variance Reduction Techniques
- CUPED (Controlled-experiment Using Pre-Experiment Data)
- Stratification
- Regression adjustment

---

## 9. Interview Questions

**Q1: How do you determine sample size for an A/B test?**
- Answer: Use power analysis. Specify: (1) minimum detectable effect, (2) significance level (α), (3) desired power (1-β), (4) baseline metric variance. Calculate n using statistical formulas or tools like statsmodels.

**Q2: The treatment group has 15% higher conversion (p=0.04). Should you launch?**
- Answer: Statistical significance is necessary but not sufficient. Consider: (1) Is 15% lift practically meaningful? (2) What's the confidence interval? (3) How do guardrail metrics look? (4) Is the effect consistent across segments? (5) What are implementation costs and risks?

**Q3: How do you handle multiple metrics in A/B tests?**
- Answer: Designate one primary metric (no correction needed), apply multiple testing corrections (Bonferroni/FDR) to secondary metrics, treat guardrail metrics separately with stricter thresholds.

**Q4: You see results are significant in week 1 but not week 2. What happened?**
- Answer: Likely novelty effect—users initially react to the change but behavior normalizes. This is why we run tests for at least 1-2 business cycles and look at time trends.

---

## 10. Checklist for A/B Test Analysis

- [ ] Verify randomization (sanity checks on sample sizes and baseline metrics)
- [ ] Calculate primary metric for both variants
- [ ] Perform appropriate statistical test (z-test, t-test, etc.)
- [ ] Calculate confidence intervals
- [ ] Assess practical significance, not just statistical
- [ ] Check secondary and guardrail metrics
- [ ] Analyze by segments (new vs. returning, device, geography)
- [ ] Examine time trends for novelty effects
- [ ] Apply multiple testing corrections if needed
- [ ] Document methodology, results, and recommendation
- [ ] Consider implementation costs and risks

---

## Conclusion

Rigorous A/B test analysis requires:
- **Statistical rigor**: Proper hypothesis testing, significance, confidence intervals
- **Business judgment**: Practical significance, costs, risks
- **Comprehensive view**: Secondary metrics, segments, time trends
- **Clear communication**: Report results accessibly to stakeholders

Remember: The goal isn't just to find statistical significance, but to make informed decisions that improve the product and business outcomes.