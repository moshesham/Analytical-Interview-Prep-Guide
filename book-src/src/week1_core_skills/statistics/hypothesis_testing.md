# Hypothesis Testing: A Comprehensive Guide

## Overview
Hypothesis testing is a statistical method that allows us to make inferences or draw conclusions about a population based on sample data. It's the foundation of A/B testing, experimental analysis, and evidence-based decision making in data science and analytics.

---

## Key Concepts

### Null and Alternative Hypotheses
- **Null Hypothesis (H0)**: The hypothesis of "no effect" or "no difference." It represents the status quo or baseline.
  - Example: "The new feature has no effect on user engagement"
  
- **Alternative Hypothesis (H1 or Ha)**: The hypothesis that there is an effect or difference. This represents what you want to prove.
  - Example: "The new feature increases user engagement"

**Types of Alternative Hypotheses**:
- **Two-sided**: H1: μ ≠ μ0 (different from)
- **One-sided (upper)**: H1: μ > μ0 (greater than)
- **One-sided (lower)**: H1: μ < μ0 (less than)

---

### P-Value: Understanding the Evidence

- **Definition**: The p-value is the probability of obtaining results at least as extreme as observed, assuming H0 is true.
- **Interpretation**: 
  - A **small p-value** (< α) suggests the data is inconsistent with H0
  - A **large p-value** (≥ α) suggests the data is consistent with H0
  
**IMPORTANT**: The p-value is NOT:
- ❌ The probability that H0 is true
- ❌ The probability of making a mistake
- ❌ The importance or size of the effect

**What p-value tells you**:
- ✓ How compatible your data is with H0
- ✓ How "surprising" your results are under H0

**Example**: p = 0.03 means "if H0 were true, we'd see results this extreme only 3% of the time"

---

### Significance Level (α)

- **Definition**: The threshold for rejecting H0, set before collecting data
- **Common values**: α = 0.05 (5%), 0.01 (1%), 0.10 (10%)
- **Decision rule**: 
  - If p-value ≤ α → Reject H0
  - If p-value > α → Fail to reject H0

**Choosing α**:
- α = 0.05: Standard for most applications
- α = 0.01: When false positives are very costly
- α = 0.10: When you're exploring or false negatives are costly

---

### Type I and Type II Errors

|                    | **H0 is True**        | **H0 is False**       |
|--------------------|-----------------------|-----------------------|
| **Reject H0**      | Type I Error (α)      | Correct Decision (Power) |
| **Fail to Reject** | Correct Decision (1-α) | Type II Error (β)    |

- **Type I Error (α)**: False Positive - Rejecting H0 when it's actually true
  - Example: Launching a feature that doesn't actually improve metrics
  
- **Type II Error (β)**: False Negative - Failing to reject H0 when it's actually false
  - Example: Not launching a feature that would have improved metrics

---

### Statistical Power

- **Definition**: Power = 1 - β = Probability of correctly rejecting a false H0
- **Typical target**: 80% power (β = 0.20)
- **Factors affecting power**:
  1. **Sample size** ↑ → Power ↑
  2. **Effect size** ↑ → Power ↑
  3. **Significance level (α)** ↑ → Power ↑
  4. **Variance** ↓ → Power ↑

**Why power matters**: 
- Low power means you might miss real effects
- Underpowered studies waste resources
- Always calculate required sample size before running experiments

---

### Confidence Intervals

- **Definition**: A range of plausible values for the population parameter
- **Interpretation of 95% CI**: "If we repeated this study many times, 95% of confidence intervals would contain the true parameter"

**95% CI = Estimate ± (Critical value × Standard Error)**

**Relationship to hypothesis testing**:
- If the 95% CI doesn't include the null value (e.g., 0 for differences), reject H0 at α = 0.05
- CIs provide more information than p-values: they show effect size and precision

**Example**: 95% CI for difference in conversion rates: [0.5%, 2.3%]
- Interpretation: We're 95% confident the true difference is between 0.5% and 2.3%
- Since 0 is not in this interval, the difference is statistically significant
- The CI also tells us the effect size is modest (< 2.5%)

---

## Steps in Hypothesis Testing

### 1. State the Hypotheses
Define H0 and H1 clearly before collecting data.

**Example**: Testing if new checkout flow improves conversion
- H0: μ_new = μ_old (no difference)
- H1: μ_new > μ_old (new is better)

### 2. Choose Significance Level (α)
Decide your threshold (typically α = 0.05).

### 3. Calculate Required Sample Size
Use power analysis to determine n before collecting data.

```python
from statsmodels.stats.power import tt_ind_solve_power

n_per_group = tt_ind_solve_power(
    effect_size=0.2,  # Cohen's d
    alpha=0.05,
    power=0.8,
    alternative='two-sided'
)
print(f"Need {n_per_group:.0f} users per group")
```

### 4. Collect Data
Gather sample data via randomized experiment or observational study.

### 5. Calculate Test Statistic
Choose appropriate test based on data type and assumptions:
- **t-test**: Compare means (small samples or unknown σ)
- **z-test**: Compare means (large samples, known σ)
- **χ² test**: Compare proportions or test independence
- **Mann-Whitney U**: Compare medians (non-parametric)

### 6. Calculate P-Value
Determine the p-value from the test statistic.

### 7. Make Decision
- If p ≤ α: Reject H0 (statistically significant)
- If p > α: Fail to reject H0 (not statistically significant)

### 8. Interpret Results in Context
Consider:
- **Statistical significance**: Is p < α?
- **Practical significance**: Is the effect size meaningful?
- **Confidence interval**: What's the range of plausible effects?
- **Business impact**: Is it worth implementing?

---

## Common Statistical Tests

### Two-Sample t-Test (Independent Samples)
**Use when**: Comparing means of two independent groups

**Assumptions**:
- Continuous data
- Independent samples
- Approximately normal distribution (or large n)
- Equal variances (or use Welch's t-test)

**Example**: Does the new UI increase average session time?

```python
from scipy import stats

# Group A: control, Group B: treatment
control = [12, 15, 14, 10, 13, 16, 11, 14]
treatment = [16, 18, 17, 19, 15, 20, 18, 17]

# Perform two-sample t-test
t_stat, p_value = stats.ttest_ind(treatment, control)
print(f"t-statistic: {t_stat:.4f}")
print(f"p-value: {p_value:.4f}")

if p_value < 0.05:
    print("Reject H0: Significant difference exists")
else:
    print("Fail to reject H0: No significant difference")
```

### Paired t-Test
**Use when**: Comparing means of two related groups (same subjects measured twice)

**Example**: User engagement before vs. after feature update (same users)

```python
before = [20, 22, 19, 24, 21, 23, 20, 22]
after = [24, 25, 23, 27, 24, 26, 23, 25]

t_stat, p_value = stats.ttest_rel(after, before)
print(f"Paired t-test p-value: {p_value:.4f}")
```

### Proportion Test (z-test for proportions)
**Use when**: Comparing conversion rates, click-through rates, etc.

**Example**: Does variant B have higher conversion than variant A?

```python
from statsmodels.stats.proportion import proportions_ztest

# Variant A: 100 conversions out of 1000 users
# Variant B: 120 conversions out of 1000 users
conversions = [100, 120]
total_users = [1000, 1000]

z_stat, p_value = proportions_ztest(conversions, total_users)
print(f"z-statistic: {z_stat:.4f}")
print(f"p-value: {p_value:.4f}")

# Calculate confidence interval for difference
from statsmodels.stats.proportion import confint_proportions_2indep

ci_low, ci_high = confint_proportions_2indep(
    conversions[0], total_users[0],
    conversions[1], total_users[1],
    method='wald'
)
print(f"95% CI for difference: [{ci_low:.4f}, {ci_high:.4f}]")
```

### Chi-Square Test
**Use when**: Testing independence between categorical variables

**Example**: Is device type (mobile/desktop) related to purchase behavior?

```python
import numpy as np
from scipy.stats import chi2_contingency

# Contingency table: rows=device, columns=purchase(yes/no)
observed = np.array([
    [50, 150],  # Mobile: 50 purchased, 150 didn't
    [80, 120]   # Desktop: 80 purchased, 120 didn't
])

chi2, p_value, dof, expected = chi2_contingency(observed)
print(f"Chi-square statistic: {chi2:.4f}")
print(f"p-value: {p_value:.4f}")
```

### ANOVA (Analysis of Variance)
**Use when**: Comparing means of three or more groups

**Example**: Compare average engagement across multiple feature variants

```python
from scipy import stats

group1 = [23, 25, 22, 24, 26]
group2 = [28, 30, 27, 29, 31]
group3 = [20, 22, 19, 21, 23]

f_stat, p_value = stats.f_oneway(group1, group2, group3)
print(f"F-statistic: {f_stat:.4f}")
print(f"p-value: {p_value:.4f}")
```

---

## Real-World Example: A/B Test Analysis

### Scenario
You're testing a new recommendation algorithm. Over 2 weeks:
- **Control (A)**: 5,000 users, 500 clicked on recommendations (10% CTR)
- **Treatment (B)**: 5,000 users, 575 clicked on recommendations (11.5% CTR)

Should you launch the new algorithm?

### Analysis

```python
import numpy as np
from scipy import stats
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep

# Data
clicks = np.array([500, 575])
users = np.array([5000, 5000])

# Test
z_stat, p_value = proportions_ztest(clicks, users)

# Confidence interval for difference
ci = confint_proportions_2indep(clicks[0], users[0], clicks[1], users[1])

# Results
print(f"Control CTR: {clicks[0]/users[0]:.2%}")
print(f"Treatment CTR: {clicks[1]/users[1]:.2%}")
print(f"Absolute difference: {(clicks[1]/users[1] - clicks[0]/users[0]):.2%}")
print(f"Relative lift: {((clicks[1]/users[1])/(clicks[0]/users[0]) - 1):.1%}")
print(f"\nz-statistic: {z_stat:.4f}")
print(f"p-value: {p_value:.4f}")
print(f"95% CI: [{ci[0]:.4f}, {ci[1]:.4f}]")

# Decision
if p_value < 0.05:
    print("\n✓ Statistically significant at α=0.05")
    print(f"✓ The new algorithm increases CTR by {((clicks[1]/users[1])/(clicks[0]/users[0]) - 1):.1%}")
else:
    print("\n✗ Not statistically significant")
```

**Output**:
```
Control CTR: 10.00%
Treatment CTR: 11.50%
Absolute difference: 1.50%
Relative lift: 15.0%

z-statistic: 2.51
p-value: 0.0121

95% CI: [0.0033, 0.0267]

✓ Statistically significant at α=0.05
✓ The new algorithm increases CTR by 15.0%
```

**Business Decision**: 
- Statistically significant (p < 0.05)
- Practically significant (15% relative lift)
- Confidence interval doesn't include 0
- **Recommendation**: Launch the new algorithm

---

## Common Pitfalls and Best Practices

### Pitfalls to Avoid

1. **P-hacking**: Testing multiple hypotheses and only reporting significant results
   - **Solution**: Pre-register hypotheses, use multiple testing corrections

2. **Stopping tests early when significant**: Peeking at p-values inflates Type I error
   - **Solution**: Set sample size upfront, use sequential testing methods

3. **Confusing statistical and practical significance**
   - **Solution**: Always report effect size and confidence intervals

4. **Assuming causation from correlation**
   - **Solution**: Use randomized experiments when possible

5. **Ignoring assumptions**: Using parametric tests on non-normal data
   - **Solution**: Check assumptions, use non-parametric tests when needed

### Best Practices

1. ✓ **Pre-register your analysis**: Define hypotheses, sample size, and analysis plan before collecting data
2. ✓ **Report effect sizes and CIs**: Not just p-values
3. ✓ **Consider practical significance**: A statistically significant 0.1% lift may not be worth implementing
4. ✓ **Use appropriate corrections**: Bonferroni or FDR for multiple testing
5. ✓ **Check assumptions**: Normality, independence, equal variance
6. ✓ **Calculate power**: Don't waste resources on underpowered studies
7. ✓ **Visualize your data**: Plots reveal patterns p-values don't

---

## Interview Preparation

### Common Questions

**Q1**: "Explain p-value to a non-technical stakeholder."
- **Answer**: "The p-value tells us how surprising our results would be if there were actually no real effect. A p-value of 0.03 means that if the new feature had no real impact, we'd only see results this strong 3% of the time by chance alone. Since that's rare, we conclude the effect is likely real."

**Q2**: "Your A/B test has p=0.04. Should you launch?"
- **Answer**: "Statistical significance is just one factor. I'd also consider: (1) What's the effect size and confidence interval? (2) Is the improvement practically meaningful? (3) What are the implementation costs? (4) Are there any risks or guardrail metrics that worsened? Statistical significance alone isn't enough to make a business decision."

**Q3**: "How would you handle multiple comparisons?"
- **Answer**: "When testing multiple hypotheses, I'd use Bonferroni correction (divide α by number of tests) if I need strong family-wise error control, or False Discovery Rate (Benjamini-Hochberg) if I'm more exploratory and can tolerate some false positives. I'd also distinguish between primary metrics (pre-specified) and secondary metrics (exploratory)."

**Q4**: "What's the difference between Type I and Type II errors in business context?"
- **Answer**: "Type I error (false positive) means launching a feature that doesn't actually work—we waste development resources. Type II error (false negative) means not launching a feature that would have worked—we miss an opportunity. The relative costs depend on the business context."

---

## Conclusion

Hypothesis testing is the foundation of data-driven decision making. Key takeaways:

- Always define hypotheses before analyzing data
- P-values measure evidence against H0, not truth of hypotheses
- Report effect sizes and confidence intervals, not just p-values
- Consider both statistical and practical significance
- Understand the assumptions and limitations of your tests
- Context matters: connect statistical findings to business impact

**Remember**: Statistics is a tool to reduce uncertainty, not eliminate it. Good analysis combines statistical rigor with business judgment.