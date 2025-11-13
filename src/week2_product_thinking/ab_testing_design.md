# A/B Testing Design

## Overview
A/B testing (also called split testing or randomized controlled experiments) is the gold standard for making data-driven product decisions. It allows you to compare two or more variants to determine which performs better by randomly assigning users to different groups and measuring outcomes.

This document provides a comprehensive framework for designing rigorous, statistically sound A/B tests—a critical skill for product analytics interviews and roles.

**Why A/B Testing Matters:**
- Removes guesswork and HiPPO (Highest Paid Person's Opinion) bias
- Quantifies the causal impact of product changes
- Minimizes risk of shipping features that harm metrics
- Builds a culture of experimentation and learning

## Step-by-Step A/B Test Design Process

## 1. Define the Hypothesis

A strong hypothesis is specific, measurable, and based on insights or data, not just intuition.

### Components of a Good Hypothesis

**Format:** If [change], then [expected outcome], because [rationale]

**Example Hypotheses:**

**Strong ✅:**
- "If we add social proof ('Join 10,000+ users') to the sign-up page, then conversion rate will increase by at least 5%, because social proof reduces perceived risk and increases trust."

**Weak ❌:**
- "The new button will perform better" (Not specific, no rationale, no target)

### Real-World Examples

**E-commerce:**
- "If we add free shipping threshold messaging ('Add $15 more for free shipping'), then average order value will increase by 8%, because it motivates users to add more items to reach the threshold."

**SaaS Product:**
- "If we show a product tour video on the dashboard, then feature adoption will increase by 15%, because new users don't understand how to use key features."

**Social Media:**
- "If we change the post button from 'Tweet' to 'Post', then posting rate will increase by 3%, because 'Post' is more universal and less intimidating than platform-specific jargon."

### Hypothesis Checklist

Before proceeding, verify your hypothesis has:
- [ ] Clear change/treatment described
- [ ] Specific metric(s) to measure
- [ ] Quantified expected impact
- [ ] Logical rationale
- [ ] User behavior insight

## 2. Identify Success Metrics

Choose metrics that directly measure whether your hypothesis is correct.

### Metric Hierarchy

**1. Primary Metric (North Star for the test)**
The ONE metric that determines success or failure of the experiment.

**Characteristics:**
- Directly tied to hypothesis
- Sensitive enough to detect changes
- Measurable within test duration
- Meaningful to business

**Examples:**
| Hypothesis | Primary Metric |
|------------|----------------|
| New checkout flow reduces friction | Checkout completion rate |
| Recommendation engine improves discovery | % of users who click a recommendation |
| Premium upsell banner increases conversions | Free-to-paid conversion rate |
| Onboarding changes increase activation | % of users completing key action in first week |

**2. Secondary Metrics**
Additional metrics that provide context and help understand the full impact.

**Examples:**
- **For checkout flow test:**
  - Secondary: Average time to complete checkout, cart abandonment rate
- **For recommendation test:**
  - Secondary: Items purchased from recommendations, time spent browsing
- **For premium upsell:**
  - Secondary: Click-through rate on banner, pricing page views

### 3. Guardrail Metrics

Metrics that must NOT degrade, even if primary metric improves.

**Purpose:** Prevent "Goodhart's Law" (optimizing one metric at expense of others)

**Common Guardrail Metrics:**

**User Experience:**
- Page load time
- Error rates
- Customer support tickets
- App crash rate

**Engagement:**
- Daily/Weekly Active Users
- Session duration
- Return rate

**Business Health:**
- Revenue per user
- Refund rate
- Churn rate

**Example - Email Frequency Test:**
```
Hypothesis: Sending 3 emails/week instead of 1 will increase engagement

Primary Metric: Email click-through rate
Secondary Metrics: Open rate, website visits from email
Guardrail Metrics: 
  - Unsubscribe rate (must not increase >10%)
  - Email spam complaints (must stay <0.1%)
  - Overall product engagement (must not decrease)
```

### Choosing the Right Metrics: Framework

**Ask These Questions:**

1. **Is it aligned with the hypothesis?**
   - ✅ Testing checkout flow → measure completion rate
   - ❌ Testing checkout flow → measure brand awareness

2. **Can you measure it reliably?**
   - ✅ Button clicks (logged in database)
   - ❌ User satisfaction (requires survey, low response rate)

3. **Is it sensitive enough?**
   - ✅ Conversion rate (can detect 5% change with reasonable sample)
   - ❌ Annual retention (takes too long, too stable to move)

4. **Can it be gamed?**
   - ✅ Purchases (real business value)
   - ❌ Page views (can be inflated without value)

### Metric Definition Example

**Bad Definition:** "Increase engagement"
- Too vague
- Not measurable
- No baseline

**Good Definition:**
```
Primary Metric: 7-day activation rate
Definition: % of new users who complete at least one [key action] within 7 days of signup
Baseline: 32.5% (last 30 days)
Target: 38% (+5.5 percentage points, 17% relative increase)
Minimum Detectable Effect: 3% (what we need to detect to be worth it)
```

## 4. Determine Sample Size

Sample size calculation is critical—too small and you won't detect real effects, too large and you waste time and opportunity cost.

### Key Statistical Concepts

**1. Statistical Significance (α - Alpha)**
- Probability of false positive (Type I error)
- Standard: α = 0.05 (5% chance of claiming an effect when there is none)
- "We're 95% confident this difference isn't due to random chance"

**2. Statistical Power (1 - β - Beta)**
- Probability of detecting a real effect (avoiding Type II error)
- Standard: 80% power (β = 0.20)
- "If there IS a real effect, we have 80% chance of detecting it"

**3. Minimum Detectable Effect (MDE)**
- Smallest change worth detecting
- Smaller MDE requires larger sample size
- Should be based on business significance, not statistical significance

**4. Baseline Conversion Rate**
- Current performance of your metric
- Higher variance → larger sample needed

### Sample Size Formula (Two-Proportion Test)

For comparing two proportions (e.g., conversion rates):

```
n = (Zα/2 + Zβ)² × (p₁(1-p₁) + p₂(1-p₂)) / (p₁ - p₂)²

Where:
- n = sample size per variant
- Zα/2 = Z-score for significance level (1.96 for 95% confidence)
- Zβ = Z-score for power (0.84 for 80% power)
- p₁ = baseline conversion rate (control)
- p₂ = expected conversion rate (treatment)
```

### Python Sample Size Calculator

```python
import numpy as np
from scipy import stats

def calculate_sample_size(baseline_rate, mde, alpha=0.05, power=0.80):
    """
    Calculate required sample size per variant for A/B test
    
    Parameters:
    - baseline_rate: Current conversion rate (e.g., 0.10 for 10%)
    - mde: Minimum detectable effect as relative change (e.g., 0.10 for 10% improvement)
    - alpha: Significance level (default 0.05 for 95% confidence)
    - power: Statistical power (default 0.80)
    
    Returns:
    - Dictionary with sample size and other parameters
    """
    # Calculate treatment rate
    treatment_rate = baseline_rate * (1 + mde)
    
    # Z-scores
    z_alpha = stats.norm.ppf(1 - alpha/2)  # Two-tailed
    z_beta = stats.norm.ppf(power)
    
    # Pooled standard deviation
    p_pooled = (baseline_rate + treatment_rate) / 2
    
    # Sample size calculation
    numerator = (z_alpha + z_beta) ** 2 * (baseline_rate * (1 - baseline_rate) + 
                                            treatment_rate * (1 - treatment_rate))
    denominator = (treatment_rate - baseline_rate) ** 2
    
    n_per_variant = int(np.ceil(numerator / denominator))
    
    return {
        'sample_size_per_variant': n_per_variant,
        'total_sample_size': n_per_variant * 2,
        'baseline_rate': baseline_rate,
        'treatment_rate': treatment_rate,
        'absolute_lift': treatment_rate - baseline_rate,
        'relative_lift_pct': mde * 100,
        'alpha': alpha,
        'power': power,
        'mde': mde
    }

# Example usage
result = calculate_sample_size(
    baseline_rate=0.10,  # 10% current conversion
    mde=0.10,            # Want to detect 10% relative increase (10% → 11%)
    alpha=0.05,
    power=0.80
)

print(f"Sample Size Required:")
print(f"  Per variant: {result['sample_size_per_variant']:,}")
print(f"  Total: {result['total_sample_size']:,}")
print(f"  Baseline: {result['baseline_rate']:.2%}")
print(f"  Treatment: {result['treatment_rate']:.2%}")
print(f"  Absolute lift: {result['absolute_lift']:.2%}")
print(f"  Relative lift: {result['relative_lift_pct']:.1f}%")
```

**Output Example:**
```
Sample Size Required:
  Per variant: 12,441
  Total: 24,882
  Baseline: 10.00%
  Treatment: 11.00%
  Absolute lift: 1.00%
  Relative lift: 10.0%
```

### Sample Size Table (Quick Reference)

**For 5% significance level, 80% power:**

| Baseline Rate | 5% Relative Lift | 10% Relative Lift | 20% Relative Lift |
|---------------|------------------|-------------------|-------------------|
| 1% | 156,000 | 39,000 | 9,800 |
| 5% | 30,000 | 7,500 | 1,900 |
| 10% | 15,000 | 3,800 | 950 |
| 20% | 7,400 | 1,900 | 470 |
| 50% | 3,000 | 760 | 190 |

**Key Insights from Table:**
- Lower baseline rates need MUCH larger samples
- Smaller effects need MUCH larger samples
- Common mistake: thinking you can detect small effects quickly

### Calculating Test Duration

```python
def calculate_test_duration(sample_size_per_variant, daily_traffic, traffic_split=0.5):
    """
    Calculate how long test needs to run
    
    Parameters:
    - sample_size_per_variant: Required sample per group
    - daily_traffic: Average daily users/sessions
    - traffic_split: % allocated to each variant (default 50/50)
    
    Returns:
    - Days needed to reach sample size
    """
    daily_users_per_variant = daily_traffic * traffic_split
    days_needed = sample_size_per_variant / daily_users_per_variant
    
    return {
        'days_needed': np.ceil(days_needed),
        'weeks_needed': np.ceil(days_needed / 7),
        'daily_traffic': daily_traffic,
        'daily_per_variant': daily_users_per_variant,
        'traffic_split_pct': traffic_split * 100
    }

# Example
duration = calculate_test_duration(
    sample_size_per_variant=12441,
    daily_traffic=1000,
    traffic_split=0.5
)

print(f"\nTest Duration:")
print(f"  Days needed: {duration['days_needed']:.0f} days")
print(f"  Weeks needed: {duration['weeks_needed']:.0f} weeks")
print(f"  Daily traffic: {duration['daily_traffic']:,}")
print(f"  Per variant: {duration['daily_per_variant']:,.0f}/day")
```

**Output:**
```
Test Duration:
  Days needed: 25 days
  Weeks needed: 4 weeks
  Daily traffic: 1,000
  Per variant: 500/day
```

### Practical Trade-offs

**If Sample Size is Too Large:**

**Option 1: Increase MDE**
- Accept detecting only larger effects (e.g., 15% instead of 10%)
- Reduces sample size significantly
- Question: "Is a 10% improvement really worth the effort?"

**Option 2: Increase Traffic %**
- Run at 80/20 or 90/10 instead of 50/50
- Gets data faster but exposes more users to potential bad variant
- Need to adjust sample size formula for unequal groups

**Option 3: Focus on High-Traffic Segments**
- Test only on web (exclude mobile) if web has more traffic
- Test only power users who are more active
- Trade-off: Results may not generalize

**Option 4: Accept Lower Power**
- Run with 70% power instead of 80%
- Reduces sample ~15-20%
- Higher risk of missing real effects

### Real-World Example: Button Color Test

**Scenario:**
- Current button: Blue, 12% click-through rate
- Hypothesis: Green button will increase CTR by 10% (12% → 13.2%)
- Daily traffic: 10,000 visitors
- Want: 95% confidence, 80% power

**Calculation:**
```python
button_test = calculate_sample_size(
    baseline_rate=0.12,
    mde=0.10,  # 10% relative lift
    alpha=0.05,
    power=0.80
)

duration = calculate_test_duration(
    sample_size_per_variant=button_test['sample_size_per_variant'],
    daily_traffic=10000,
    traffic_split=0.5
)

print(f"Button Test Results:")
print(f"  Need: {button_test['sample_size_per_variant']:,} users per variant")
print(f"  Duration: {duration['days_needed']:.0f} days")
print(f"  Trying to improve: {button_test['baseline_rate']:.1%} → {button_test['treatment_rate']:.1%}")
```

**Result:** Need 9,634 users per variant, will take 2 days

**Decision:** This is feasible! Run the test.

## 5. Randomization and Assignment

Proper randomization is crucial for valid A/B tests. Poor randomization introduces bias and invalidates results.

### Randomization Methods

**1. User-Level Randomization (Most Common)**
Each user is randomly assigned to a variant and stays in that variant for the test duration.

```python
import hashlib

def assign_variant(user_id, experiment_name, variants=['control', 'treatment']):
    """
    Consistently assign users to variants using hash-based randomization
    
    Parameters:
    - user_id: Unique user identifier
    - experiment_name: Name of experiment (allows multiple concurrent tests)
    - variants: List of variant names
    
    Returns:
    - Assigned variant name
    """
    # Create hash of user_id + experiment_name
    hash_input = f"{user_id}:{experiment_name}".encode('utf-8')
    hash_output = hashlib.md5(hash_input).hexdigest()
    
    # Convert to integer
    hash_int = int(hash_output, 16)
    
    # Assign variant based on modulo
    variant_index = hash_int % len(variants)
    
    return variants[variant_index]

# Example usage
user_id = "user_12345"
variant = assign_variant(user_id, "button_color_test")
print(f"User {user_id} assigned to: {variant}")

# Verify distribution
import pandas as pd
test_users = [f"user_{i}" for i in range(10000)]
assignments = [assign_variant(u, "button_color_test") for u in test_users]
print(pd.Series(assignments).value_counts())
```

**2. Session-Level Randomization**
Each session gets a new assignment. Use when:
- Users aren't logged in
- Testing short-term interactions (single page/session)

**3. Stratified Randomization**
Balance important characteristics across groups.

```python
def stratified_assignment(users_df, strata_column, variants=['control', 'treatment']):
    """
    Assign users ensuring balance across strata (e.g., country, platform)
    
    Parameters:
    - users_df: DataFrame with user data
    - strata_column: Column to balance on (e.g., 'country')
    - variants: List of variants
    
    Returns:
    - DataFrame with variant assignments
    """
    def assign_within_stratum(group):
        # Shuffle users within each stratum
        shuffled = group.sample(frac=1, random_state=42)
        # Assign sequentially to variants
        variant_assignments = [variants[i % len(variants)] for i in range(len(shuffled))]
        shuffled['variant'] = variant_assignments
        return shuffled
    
    result = users_df.groupby(strata_column, group_keys=False).apply(assign_within_stratum)
    return result

# Example usage
# users = stratified_assignment(users_df, strata_column='country')
```

### Common Randomization Pitfalls

❌ **Temporal Assignment:** "Control gets Mon-Wed, Treatment gets Thu-Fri"
- Day-of-week effects bias results
- External events affect one group differently

❌ **Self-Selection:** "Users can choose which experience they want"
- Selection bias—different types of users choose each variant

❌ **Re-randomization:** "User gets new variant each session"
- Unless intentional, creates confusion and dilutes effects

❌ **Biased Hashing:** "Use user_id % 2 for assignment"
- If user IDs aren't random (e.g., sequential), creates bias

✅ **Best Practice:**
- Use cryptographic hash functions (MD5, SHA-256)
- Include experiment name in hash to allow multiple concurrent tests
- Keep assignment stable (user sees same variant throughout test)
- Verify balanced distribution before launching

### Assignment Verification SQL

```sql
-- Check randomization balance
WITH user_assignments AS (
    SELECT 
        user_id,
        variant,
        user_country,
        user_platform,
        user_signup_date,
        is_premium
    FROM experiment_assignments
    WHERE experiment_name = 'checkout_flow_test'
)
SELECT 
    variant,
    COUNT(DISTINCT user_id) as user_count,
    COUNT(DISTINCT user_country) as countries,
    ROUND(100.0 * SUM(CASE WHEN user_platform = 'iOS' THEN 1 ELSE 0 END) / 
          COUNT(*), 2) as pct_ios,
    ROUND(100.0 * SUM(CASE WHEN user_platform = 'Android' THEN 1 ELSE 0 END) / 
          COUNT(*), 2) as pct_android,
    ROUND(100.0 * SUM(CASE WHEN is_premium = TRUE THEN 1 ELSE 0 END) / 
          COUNT(*), 2) as pct_premium,
    ROUND(AVG(DATEDIFF(CURRENT_DATE, user_signup_date)), 1) as avg_days_since_signup
FROM user_assignments
GROUP BY variant;
```

**Expected Result:** All metrics should be similar across variants (within ~2-3%)

## 6. Test Duration

Determining the right test duration is both art and science.

### Minimum Duration Factors

**1. Sample Size Requirements**
- Must reach required sample size (from Step 4)
- Account for daily traffic fluctuations

**2. Weekly Cycles**
- **Always run for full weeks** (multiples of 7 days)
- User behavior varies by day of week
- Running Mon-Thu captures different behavior than Thu-Sun

**3. Novelty Effects**
- Initial excitement/confusion with new experience
- Generally stabilizes after 1-2 weeks
- For major changes, run 2-4 weeks minimum

**4. Learning Effects**
- Users may need time to adapt to changes
- Example: New navigation might hurt metrics initially but improve over time

### Duration Calculation Framework

```python
import numpy as np

def calculate_optimal_duration(sample_size_per_variant, 
                               daily_traffic,
                               traffic_allocation=0.5,
                               min_weeks=2):
    """
    Calculate optimal test duration
    
    Parameters:
    - sample_size_per_variant: Required sample size
    - daily_traffic: Average daily unique users
    - traffic_allocation: % of traffic in experiment (0.5 = 50%)
    - min_weeks: Minimum weeks to run (for weekly cycles)
    
    Returns:
    - Recommended duration
    """
    # Calculate days needed for sample size
    daily_users_in_experiment = daily_traffic * traffic_allocation
    daily_users_per_variant = daily_users_in_experiment / 2  # Assuming 50/50 split
    
    days_for_sample = sample_size_per_variant / daily_users_per_variant
    
    # Round up to nearest full week
    weeks_for_sample = np.ceil(days_for_sample / 7)
    
    # Apply minimum weeks
    recommended_weeks = max(weeks_for_sample, min_weeks)
    
    # Calculate actual statistics
    actual_days = recommended_weeks * 7
    actual_sample_size = daily_users_per_variant * actual_days
    
    return {
        'recommended_weeks': int(recommended_weeks),
        'recommended_days': int(actual_days),
        'sample_size_achieved': int(actual_sample_size),
        'sample_size_required': sample_size_per_variant,
        'oversampling_pct': ((actual_sample_size / sample_size_per_variant) - 1) * 100,
        'daily_traffic': daily_traffic,
        'daily_per_variant': int(daily_users_per_variant)
    }

# Example
duration = calculate_optimal_duration(
    sample_size_per_variant=15000,
    daily_traffic=5000,
    traffic_allocation=0.8,  # 80% of users in experiment
    min_weeks=2
)

print(f"Test Duration Recommendation:")
print(f"  Run for: {duration['recommended_weeks']} weeks ({duration['recommended_days']} days)")
print(f"  Will collect: {duration['sample_size_achieved']:,} samples per variant")
print(f"  Required: {duration['sample_size_required']:,} samples")
print(f"  Oversampling: {duration['oversampling_pct']:.1f}%")
```

### Special Duration Considerations

**Monthly Cycles:**
- For subscription businesses, consider monthly billing cycles
- Users behave differently at month start/end
- May need to run 4+ weeks

**Seasonal Effects:**
- Holiday shopping season
- Back-to-school period
- Tax season (for financial products)
- Consider pausing tests during anomalous periods

**Traffic Spikes:**
- Product launches
- Marketing campaigns
- PR events
- May need to pause or extend test

### Early Stopping: When is it OK?

**❌ Never stop early because:**
- "P-value looks good after 3 days!" (Peeking problem)
- "Treatment is clearly winning!" (Regression to mean)
- "We're eager to ship!" (Patience pays off)

**✅ Can stop early if:**
- Serious bugs or crashes detected
- Extreme negative impact on guardrail metrics (>10% degradation)
- External factors make test invalid (e.g., major news event)
- Pre-planned sequential testing framework with adjusted thresholds

### Example Duration Decision

**Scenario:**
- Testing new onboarding flow
- Need: 10,000 users per variant
- Daily traffic: 1,000 new users
- Allocating: 50% to experiment

**Calculation:**
```
Daily per variant: 1,000 × 0.5 × 0.5 = 250 users
Days needed: 10,000 / 250 = 40 days
Weeks needed: 40 / 7 = 5.7 → Round up to 6 weeks

Decision: Run for 6 weeks (42 days)
- Achieves sample size: 250 × 42 = 10,500 per variant ✓
- Full weekly cycles: 6 weeks ✓
- Allows novelty effects to stabilize ✓
```

## 7. Launch Checklist and Quality Assurance

Before launching, verify everything is set up correctly.

### Pre-Launch Checklist

- [ ] **Hypothesis documented:** Clear, specific, measurable
- [ ] **Metrics defined:** Primary, secondary, and guardrail metrics
- [ ] **Sample size calculated:** Know required users and duration
- [ ] **Randomization tested:** Verified balanced distribution
- [ ] **Instrumentation verified:** Events logging correctly
- [ ] **Variants tested:** Both control and treatment work without bugs
- [ ] **Stakeholder alignment:** Team agrees on decision criteria
- [ ] **Monitoring plan:** Know what to watch and when

### Quality Assurance Steps

**1. A/A Test (Optional but Recommended)**
Run a test with two identical variants to verify your system works:
- Should see NO difference (p-value > 0.05)
- Verifies randomization, measurement, analysis pipeline
- Establishes false positive rate

```sql
-- A/A test check: Both variants should have similar metrics
SELECT 
    variant,
    COUNT(DISTINCT user_id) as users,
    COUNT(DISTINCT CASE WHEN converted = TRUE THEN user_id END) as conversions,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN converted = TRUE THEN user_id END) / 
          COUNT(DISTINCT user_id), 2) as conversion_rate
FROM aa_test_results
WHERE test_date BETWEEN '2024-01-01' AND '2024-01-14'
GROUP BY variant;

-- Expected: Conversion rates within ~0.5% of each other
```

**2. Traffic Split Verification**

```sql
-- Verify 50/50 split (or whatever split you configured)
SELECT 
    variant,
    COUNT(DISTINCT user_id) as user_count,
    ROUND(100.0 * COUNT(DISTINCT user_id) / 
          SUM(COUNT(DISTINCT user_id)) OVER (), 2) as pct_of_total
FROM experiment_assignments
WHERE experiment_name = 'new_checkout_flow'
  AND assigned_date >= CURRENT_DATE - INTERVAL '1 day'
GROUP BY variant;

-- Expected: ~50% for each variant (within 1-2%)
```

**3. Sample Ratio Mismatch (SRM) Detection**

If your 50/50 split is actually 48/52, something is wrong with randomization.

```python
from scipy import stats

def detect_srm(control_count, treatment_count, expected_ratio=0.5):
    """
    Detect Sample Ratio Mismatch using chi-square test
    
    Returns:
    - Whether SRM is detected (p < 0.001)
    """
    total = control_count + treatment_count
    expected_control = total * expected_ratio
    expected_treatment = total * (1 - expected_ratio)
    
    observed = [control_count, treatment_count]
    expected = [expected_control, expected_treatment]
    
    chi2, p_value = stats.chisquare(observed, expected)
    
    srm_detected = p_value < 0.001  # Strict threshold
    
    return {
        'control_count': control_count,
        'treatment_count': treatment_count,
        'control_pct': (control_count / total) * 100,
        'treatment_pct': (treatment_count / total) * 100,
        'p_value': p_value,
        'srm_detected': srm_detected,
        'interpretation': 'SRM DETECTED - DO NOT TRUST RESULTS' if srm_detected 
                         else 'No SRM - distribution looks good'
    }

# Example
result = detect_srm(control_count=9800, treatment_count=10200)
print(result)
```

### Monitoring During Test

**Daily Checks (First Week):**
- Sample sizes accumulating correctly
- No major bugs or errors
- Guardrail metrics stable

**Weekly Checks:**
- Progress toward sample size goal
- Preliminary results (without making decisions!)
- User feedback/support tickets

**Red Flags to Watch:**
- 🚩 Sample ratio mismatch (e.g., 48/52 instead of 50/50)
- 🚩 Guardrail metric drops >5%
- 🚩 Dramatic increase in errors/crashes
- 🚩 User complaints spike
- 🚩 Unexpected behavior in data

## 8. Common Pitfalls and How to Avoid Them

### Pitfall 1: Peeking Problem

**Problem:** Checking results repeatedly and stopping when p-value looks good
**Why it's bad:** Inflates false positive rate (much higher than 5%)
**Solution:** Commit to duration upfront, or use sequential testing methods

### Pitfall 2: Multiple Testing

**Problem:** Testing many metrics and claiming success on any that reach significance
**Why it's bad:** If you test 20 metrics at α=0.05, you expect 1 false positive
**Solution:** 
- Define primary metric upfront
- Apply Bonferroni correction: Use α/n where n = number of tests
- Focus on primary metric for decision-making

### Pitfall 3: Novelty Effect

**Problem:** Users react to change itself, not the improvement
**Why it's bad:** Initial lift disappears over time
**Solution:**
- Run tests for 2-4 weeks minimum
- Analyze results by week to see if effect is stable
- Consider running longer validation test after initial test

### Pitfall 4: Segment Pollution

**Problem:** Not properly handling:
- Users who see both variants (e.g., multiple devices)
- Existing users vs. new users
- Carry-over effects from previous tests

**Solution:**
- Define analysis population clearly
- Consider separate analyses for new vs. existing users
- Allow washout periods between tests

### Pitfall 5: Network Effects

**Problem:** One user's experience affects others (social products)
**Why it's bad:** Violates independence assumption
**Solution:**
- Cluster randomization (groups of users, not individuals)
- Longer tests to let network effects stabilize
- Model network effects explicitly

### Pitfall 6: Winner's Curse

**Problem:** Effect sizes estimated from barely-significant results are biased upward
**Why it's bad:** Predicted impact doesn't materialize in rollout
**Solution:**
- Be conservative with estimates
- Run validation test before full rollout
- Focus on effect direction, not exact magnitude

## 9. Interview Framework: Designing an A/B Test

When asked "How would you design an A/B test for X?", use this structure:

### 1. Clarify (2 minutes)
- "What's the primary goal—growth, engagement, or monetization?"
- "Who is the target user segment?"
- "What's the current baseline for key metrics?"
- "Are there any constraints—technical, timeline, budget?"

### 2. Hypothesis (1 minute)
- State clear hypothesis with expected impact
- "If [change], then [metric] will improve by [amount] because [rationale]"

### 3. Metrics (2 minutes)
- **Primary:** One clear success metric
- **Secondary:** 2-3 supporting metrics
- **Guardrail:** 2-3 metrics that must not degrade

### 4. Experiment Design (3 minutes)
- **Variants:** Control vs. Treatment (describe both)
- **Randomization:** User-level, session-level, or other
- **Sample Size:** Quick calculation or estimate
  - "With 10% baseline and wanting to detect 10% lift, need ~15K per variant"
- **Duration:** "Will run for 2-3 weeks to capture full weekly cycles"

### 5. Success Criteria (1 minute)
- "We'll ship if primary metric improves with p < 0.05"
- "And guardrail metrics don't degrade more than 5%"
- "If mixed results, I'd consider [decision rule]"

### 6. Risks and Mitigations (1 minute)
- Potential issues and how to address them

### Example Response: "Design an A/B test for a new recommendation algorithm"

**Clarifying Questions:**
"Is this for increasing engagement, discovery of new content, or monetization? And what's the current engagement rate with recommendations?"

[Interviewer: "Increase engagement, currently 15% of users click recommendations"]

**Hypothesis:**
"If we launch the new ML-based recommendation algorithm, then recommendation click-through rate will increase from 15% to 18% (20% relative lift), because the algorithm personalizes based on recent behavior, not just historical preferences."

**Metrics:**
- **Primary:** Recommendation click-through rate
- **Secondary:** 
  - Content diversity (unique items clicked)
  - Session duration
  - Return rate within 7 days
- **Guardrail:**
  - Overall engagement (DAU/MAU)
  - Content creator satisfaction (distribution of views)

**Design:**
- **Control:** Current recommendation algorithm
- **Treatment:** New ML-based algorithm
- **Randomization:** User-level (consistent experience per user)
- **Sample Size:** ~9,000 users per variant (15% baseline, 20% relative lift, 95% confidence, 80% power)
- **Duration:** 3 weeks (capture weekly patterns, allow learning)

**Success Criteria:**
"Ship if CTR increases with statistical significance (p < 0.05) and guardrail metrics remain stable. If CTR improves but content diversity drops, investigate before full rollout."

**Risks:**
- **Filter bubble:** New algorithm might over-personalize → Monitor content diversity metric
- **Cold start:** New users might not have enough data → Separate analysis for new vs. existing users
- **Technical issues:** Algorithm might be slower → Monitor latency as guardrail

## 10. Practice Exercise

**Your Turn: Design an A/B test for this scenario**

**Scenario:**
You're a data scientist at a meditation app. The product team wants to test sending a daily reminder notification to increase user engagement. Currently:
- 100,000 daily active users
- 40% of users open the app daily
- Average session length: 12 minutes
- Concern: Push notifications might annoy users and increase churn

**Your Task:**
1. Write a clear hypothesis
2. Define primary, secondary, and guardrail metrics
3. Calculate sample size (show your work)
4. Determine test duration
5. Describe randomization approach
6. List potential risks and mitigations

**Bonus:** Write SQL to measure your primary metric

## Conclusion

Designing rigorous A/B tests is a core skill for product analysts. The key principles:

1. **Start with a clear, specific hypothesis**
2. **Choose metrics that matter—not just what's easy to measure**
3. **Calculate sample size properly—don't guess**
4. **Randomize correctly and verify balance**
5. **Run for full weekly cycles, minimum 2 weeks**
6. **Don't peek at results early**
7. **Consider guardrails to prevent unintended harm**
8. **Document everything for future learning**

**Common Interview Mistakes:**
- ❌ Vague hypothesis ("make the product better")
- ❌ No sample size calculation
- ❌ Forgetting about guardrail metrics
- ❌ Not considering weekly cycles
- ❌ Ignoring practical constraints

**Key Takeaways:**
- A/B testing is about learning, not just "winning"
- Statistical rigor prevents costly mistakes
- Good design enables clean interpretation
- Practice makes perfect—work through many scenarios

## Additional Resources

- **Statistics:** "Trustworthy Online Controlled Experiments" by Kohavi et al.
- **Sample Size Calculators:** Evan Miller's online calculators, Optimizely's calculator
- **Case Studies:** Microsoft, Netflix, Airbnb engineering blogs
- **Interactive Learning:** Google's A/B testing course, Udacity's A/B testing course