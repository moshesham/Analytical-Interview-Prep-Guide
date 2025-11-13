# Advanced Statistics for Expert-Level Interviews

This section covers advanced statistical concepts that frequently appear in senior data scientist and analytics interviews. These topics build upon fundamental statistics and are essential for sophisticated data analysis.

---

## 1. Advanced Probability Distributions

### Exponential Distribution
- **Definition**: Models the time between events in a Poisson process
- **Parameters**: λ (rate parameter)
- **PDF**: f(x) = λe^(-λx) for x ≥ 0
- **Use Cases**: 
  - Time until next user action
  - Equipment failure times
  - Customer service response times
- **Properties**: Memoryless property - future behavior doesn't depend on past

**Product Analytics Example**: Model time between user sessions to identify engagement patterns.

### Geometric Distribution
- **Definition**: Number of trials until the first success
- **Parameters**: p (probability of success)
- **PMF**: P(X = k) = (1-p)^(k-1) * p
- **Use Cases**:
  - Number of ads shown before a click
  - Attempts until conversion
  - Failed login attempts before success

### Negative Binomial Distribution
- **Definition**: Number of trials until r successes
- **Parameters**: r (number of successes), p (probability of success per trial)
- **Use Cases**:
  - Number of impressions until multiple conversions
  - Over-dispersed count data (when variance > mean, unlike Poisson)

### Beta Distribution
- **Definition**: Continuous distribution on [0,1], often used for probabilities
- **Parameters**: α, β (shape parameters)
- **Use Cases**:
  - Bayesian prior for conversion rates
  - Modeling proportions and percentages
  - A/B test Bayesian analysis

**Expert Tip**: The Beta distribution is conjugate prior to the Binomial distribution, making Bayesian updating computationally efficient.

---

## 2. Statistical Inference Deep Dive

### Maximum Likelihood Estimation (MLE)
- **Concept**: Find parameter values that maximize the probability of observing the data
- **Method**: 
  1. Write likelihood function L(θ|data)
  2. Take log-likelihood: ℓ(θ) = log L(θ)
  3. Differentiate and set to zero: dℓ/dθ = 0
  4. Solve for θ

**Interview Question**: "How would you estimate the parameter of an exponential distribution from data?"
- Answer: MLE for exponential is θ̂ = 1/x̄ (inverse of sample mean)

### Bayesian Inference
- **Bayes' Theorem**: P(θ|data) = P(data|θ) * P(θ) / P(data)
  - Prior: P(θ) - beliefs before seeing data
  - Likelihood: P(data|θ) - probability of data given parameters
  - Posterior: P(θ|data) - updated beliefs after seeing data

**Product Analytics Application**: 
- Use Bayesian A/B testing when you need results early
- Update conversion rate estimates as new data arrives
- Incorporate prior knowledge from similar experiments

### Bootstrap Methods
- **Concept**: Resample your data with replacement to estimate sampling distribution
- **Process**:
  1. Take B bootstrap samples (typically 1000-10000)
  2. Calculate statistic of interest for each sample
  3. Use distribution of bootstrap statistics for inference

**Use Cases**:
- Estimate confidence intervals for complex statistics
- When theoretical distribution is unknown
- Non-parametric inference

**Code Example**:
```python
import numpy as np
# Bootstrap confidence interval for median
data = np.array([...])  # your data
bootstrap_medians = [np.median(np.random.choice(data, size=len(data), replace=True)) 
                     for _ in range(10000)]
ci_lower = np.percentile(bootstrap_medians, 2.5)
ci_upper = np.percentile(bootstrap_medians, 97.5)
```

---

## 3. Multiple Testing Correction

### The Multiple Testing Problem
When conducting many hypothesis tests simultaneously, the probability of at least one false positive increases dramatically.
- Example: 20 independent tests at α=0.05 → P(at least 1 false positive) ≈ 64%

### Correction Methods

**Bonferroni Correction**
- Adjusted α = α / m (where m = number of tests)
- Conservative but simple
- Use when: Tests are independent, you want strong family-wise error rate control

**Benjamini-Hochberg (False Discovery Rate)**
- Controls expected proportion of false discoveries
- Less conservative than Bonferroni
- Process:
  1. Order p-values: p₁ ≤ p₂ ≤ ... ≤ pₘ
  2. Find largest i where pᵢ ≤ (i/m) * α
  3. Reject all H₀ with p-values ≤ pᵢ

**Product Analytics Example**: Testing 50 features for impact on engagement
- Use Bonferroni if you need strong guarantees
- Use FDR if you're exploring and can tolerate some false positives

---

## 4. Causal Inference Fundamentals

### Correlation vs. Causation
- **Correlation**: Variables move together
- **Causation**: One variable directly influences another
- **Confounders**: Variables that affect both treatment and outcome

### Randomized Controlled Trials (RCTs)
- Gold standard for causal inference
- Random assignment eliminates confounding
- A/B tests are RCTs

### Observational Studies: Challenges
When randomization isn't possible:

**Selection Bias**: Groups differ in ways other than treatment
- Solution: Matching, propensity scores, regression adjustment

**Difference-in-Differences (DiD)**
- Compare changes over time between treatment and control groups
- Assumption: Parallel trends (groups would have changed similarly without treatment)
- Formula: (Y_treated,after - Y_treated,before) - (Y_control,after - Y_control,before)

**Regression Discontinuity**
- Use sharp cutoff in treatment assignment
- Compare units just above vs. just below cutoff
- Example: Age-based eligibility for programs

**Instrumental Variables**
- Find a variable that affects treatment but not outcome (except through treatment)
- Example: Geographic distance as instrument for hospital choice

---

## 5. Power Analysis and Sample Size Calculation

### Statistical Power
- **Definition**: Probability of detecting an effect when it exists (1 - β)
- **Typical target**: 80% power (β = 0.20)

### Factors Affecting Power
1. **Effect Size**: Larger effects are easier to detect
2. **Sample Size**: More data increases power
3. **Significance Level (α)**: Higher α increases power but also Type I error
4. **Variance**: Lower variance increases power

### Sample Size Formula (Two-Sample t-test)
n ≈ 2 * (z_(1-α/2) + z_(1-β))² * σ² / δ²

Where:
- δ = effect size (difference in means)
- σ = standard deviation
- α = significance level
- β = Type II error rate

**Product Analytics Example**: 
"How many users do we need for our A/B test?"
1. Specify minimum detectable effect (e.g., 2% relative increase in conversion)
2. Choose α (typically 0.05) and power (typically 0.80)
3. Estimate current variance from historical data
4. Calculate required sample size per group

**Python Code**:
```python
from statsmodels.stats.power import tt_ind_solve_power
# Calculate sample size
n = tt_ind_solve_power(effect_size=0.2,  # Cohen's d
                        alpha=0.05,
                        power=0.8,
                        alternative='two-sided')
print(f"Sample size needed per group: {n:.0f}")
```

---

## 6. Advanced Regression Topics

### Multicollinearity
- **Problem**: Predictors are highly correlated
- **Diagnosis**: 
  - High R² but few significant coefficients
  - VIF (Variance Inflation Factor) > 10
- **Solutions**:
  - Remove redundant predictors
  - Use ridge regression (L2 regularization)
  - Principal Component Regression

### Heteroscedasticity
- **Problem**: Error variance is not constant across observations
- **Diagnosis**: 
  - Plot residuals vs. fitted values
  - Breusch-Pagan test
- **Solutions**:
  - Transform variables (log, sqrt)
  - Use robust standard errors
  - Weighted least squares

### Regularization (Ridge, Lasso, Elastic Net)

**Ridge Regression (L2)**
- Penalty: λ Σ β²
- Shrinks coefficients toward zero
- Keeps all variables

**Lasso Regression (L1)**
- Penalty: λ Σ |β|
- Can set coefficients exactly to zero
- Performs variable selection

**Elastic Net**
- Combines L1 and L2 penalties
- Best of both worlds

**Use Cases**:
- High-dimensional data (many predictors)
- Prevent overfitting
- Feature selection with Lasso

---

## 7. Time Series Analysis - Advanced Concepts

### ARIMA Models
- **AR (AutoRegressive)**: Use past values to predict current
- **I (Integrated)**: Differencing to achieve stationarity
- **MA (Moving Average)**: Use past errors to predict current

**ARIMA(p,d,q) notation:**
- p = order of AR term
- d = degree of differencing
- q = order of MA term

### Seasonality: SARIMA
- Extends ARIMA with seasonal components
- SARIMA(p,d,q)(P,D,Q)s
- Example: Monthly data with yearly seasonality → s=12

### Autocorrelation
- **ACF (Autocorrelation Function)**: Correlation with lagged values
- **PACF (Partial ACF)**: Correlation after removing effects of intermediate lags
- Use ACF/PACF plots to identify ARIMA parameters

---

## 8. Non-Parametric Tests

When assumptions of parametric tests fail (normality, equal variances):

### Mann-Whitney U Test
- Non-parametric alternative to independent t-test
- Compares medians of two groups
- Use when: Data is ordinal or not normally distributed

### Wilcoxon Signed-Rank Test
- Non-parametric alternative to paired t-test
- Use when: Paired data, not normally distributed

### Kruskal-Wallis Test
- Non-parametric alternative to one-way ANOVA
- Compares medians of three or more groups

### Chi-Square Tests
- **Goodness of Fit**: Test if observed frequencies match expected
- **Independence**: Test if two categorical variables are independent
- **Homogeneity**: Test if distributions are the same across groups

---

## 9. Survival Analysis

### Concepts
- **Survival Function S(t)**: Probability of surviving beyond time t
- **Hazard Function h(t)**: Instantaneous rate of event occurrence
- **Censoring**: When exact event time is unknown

### Kaplan-Meier Estimator
- Non-parametric estimator of survival function
- Handles censored data
- Used in: Customer churn analysis, feature adoption

### Cox Proportional Hazards Model
- Semi-parametric model for time-to-event data
- Estimates effect of covariates on hazard rate
- No assumption about baseline hazard function

**Product Analytics Application**:
- Model time until user churn
- Analyze factors affecting feature adoption time
- Predict customer lifetime based on early behaviors

---

## 10. Interview Preparation Tips

### Common Questions
1. "Explain the Central Limit Theorem and why it matters"
   - Answer: Sample means converge to normal distribution regardless of original distribution; enables use of normal-based inference for large samples

2. "How would you detect if your A/B test results are biased?"
   - Check randomization: Compare baseline metrics between groups
   - Check for novelty effects: Extend test duration
   - Check for sample ratio mismatch
   - Analyze by segments to identify heterogeneous treatment effects

3. "When would you use logistic regression vs. decision trees?"
   - Logistic: Interpretable coefficients, good for inference, assumes linear relationship
   - Trees: Handle non-linearity automatically, interactions, less interpretable

4. "How do you handle imbalanced classes?"
   - Resampling: Oversample minority or undersample majority
   - Use appropriate metrics: precision, recall, F1, not just accuracy
   - Adjust decision threshold
   - Use algorithms designed for imbalance (e.g., cost-sensitive learning)

### Study Strategy
- **Connect to business**: Always tie statistical concepts to product impact
- **Practice computation**: Be ready to calculate power, sample size, confidence intervals
- **Explain assumptions**: Know when methods apply and when they break down
- **Real examples**: Prepare stories of how you've used these techniques

---

## Conclusion

Mastering advanced statistics requires both theoretical understanding and practical application. The key is not just knowing the formulas, but understanding when to apply each method, what assumptions matter, and how to interpret results in a business context.

**Remember**: 
- Statistics is a tool for decision-making under uncertainty
- Always validate assumptions before applying methods
- Communicate uncertainty clearly to stakeholders
- Practical significance matters more than statistical significance

Keep practicing, stay curious, and always connect your analysis to real-world impact!
