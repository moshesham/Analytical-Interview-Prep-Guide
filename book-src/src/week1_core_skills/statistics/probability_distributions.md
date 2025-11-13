# Probability Distributions in Statistics

## Overview

Probability distributions are fundamental concepts in statistics that describe how the probabilities of a random variable are distributed. Understanding these distributions is crucial for data analysis, hypothesis testing, and making informed decisions based on data.

Distributions help us:
- Model real-world phenomena
- Make predictions and forecasts
- Conduct hypothesis tests
- Understand variability and uncertainty

---

## Key Probability Distributions

### 1. Normal (Gaussian) Distribution

- **Definition**: The Normal distribution is a continuous, symmetric, bell-shaped distribution that is ubiquitous in statistics
- **Parameters**:
  - μ (mu): Mean (center of distribution)
  - σ (sigma): Standard deviation (spread)
- **Properties**:
  - Symmetric around the mean
  - 68% of data within 1σ of μ
  - 95% within 2σ, 99.7% within 3σ (Empirical Rule)
  - Many natural phenomena follow normal distribution (heights, test scores, measurement errors)
- **Use Cases**: 
  - Modeling continuous measurements (heights, weights, test scores)
  - Foundation for many statistical tests (t-tests, ANOVA, regression)
  - Central Limit Theorem: sample means approach normal distribution

**Product Analytics Example**: Session duration often approximates normal distribution for active users.

**Python Code**:
```python
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt

# Generate normal distribution
mu, sigma = 100, 15
data = stats.norm.rvs(loc=mu, scale=sigma, size=1000)

# Plot
plt.hist(data, bins=30, density=True, alpha=0.7)
x = np.linspace(50, 150, 100)
plt.plot(x, stats.norm.pdf(x, mu, sigma), 'r-', lw=2)
plt.xlabel('Value')
plt.ylabel('Density')
plt.title('Normal Distribution (μ=100, σ=15)')
plt.show()
```

---

### 2. Binomial Distribution

- **Definition**: The Binomial distribution models the number of successes in a fixed number of independent Bernoulli trials (experiments with two possible outcomes: success or failure)
- **Parameters**:
  - n: Number of trials
  - p: Probability of success on each trial
- **Formula**: 
  - P(X = k) = (n choose k) * p^k * (1-p)^(n-k)
- **Mean**: μ = n * p
- **Variance**: σ² = n * p * (1-p)
- **Use Cases**: 
  - Quality control (defective items in a batch)
  - A/B testing (number of conversions out of n users)
  - Survey analysis (yes/no responses)
  - Click-through rates

**Product Analytics Example**: Out of 1000 users shown a feature, how many will adopt it if the adoption rate is 15%?

**Python Code**:
```python
from scipy import stats

n = 1000  # number of trials
p = 0.15  # probability of success

# Probability of exactly 140 adoptions
prob_140 = stats.binom.pmf(140, n, p)
print(f"P(X=140) = {prob_140:.4f}")

# Probability of at least 160 adoptions
prob_at_least_160 = 1 - stats.binom.cdf(159, n, p)
print(f"P(X>=160) = {prob_at_least_160:.4f}")

# Mean and standard deviation
mean = n * p
std = np.sqrt(n * p * (1-p))
print(f"Expected adoptions: {mean:.0f} ± {std:.0f}")
```

---

### 3. Poisson Distribution

- **Definition**: The Poisson distribution models the number of events occurring in a fixed interval of time or space, given that these events happen with a known constant mean rate and independently of the time since the last event
- **Parameters**:
  - λ (lambda): Average number of events in the interval
- **Formula**: 
  - P(X = k) = (λ^k * e^(-λ)) / k!
- **Mean**: μ = λ
- **Variance**: σ² = λ
- **Use Cases**: 
  - Web traffic (page views per hour)
  - Call center arrivals (calls per hour)
  - Rare events (server crashes per month)
  - Email arrivals, support tickets

**Product Analytics Example**: Number of customer support tickets received per hour (average λ=5).

**Python Code**:
```python
from scipy import stats

lambda_param = 5  # average events per interval

# Probability of exactly 3 tickets
prob_3 = stats.poisson.pmf(3, lambda_param)
print(f"P(X=3) = {prob_3:.4f}")

# Probability of 8 or more tickets (need extra staffing)
prob_8_or_more = 1 - stats.poisson.cdf(7, lambda_param)
print(f"P(X>=8) = {prob_8_or_more:.4f}")
```

---

### 4. Exponential Distribution

- **Definition**: Models the time between events in a Poisson process (continuous analog of geometric distribution)
- **Parameters**:
  - λ (lambda): Rate parameter (events per unit time)
- **Formula**: 
  - f(x) = λ * e^(-λx) for x ≥ 0
- **Mean**: μ = 1/λ
- **Variance**: σ² = 1/λ²
- **Properties**: Memoryless - future behavior doesn't depend on past
- **Use Cases**:
  - Time between user actions
  - Service times
  - Equipment lifetime
  - Time until next purchase

**Product Analytics Example**: Time between app opens for an active user.

**Python Code**:
```python
from scipy import stats

lambda_rate = 0.5  # events per hour (or 1 event every 2 hours on average)

# Probability that next event occurs within 1 hour
prob_within_1_hour = stats.expon.cdf(1, scale=1/lambda_rate)
print(f"P(T<=1 hour) = {prob_within_1_hour:.4f}")

# Mean time between events
mean_time = 1 / lambda_rate
print(f"Average time between events: {mean_time} hours")
```

---

### 5. Uniform Distribution

- **Definition**: All outcomes in a range are equally likely
- **Parameters**:
  - a: Minimum value
  - b: Maximum value
- **Mean**: μ = (a + b) / 2
- **Variance**: σ² = (b - a)² / 12
- **Use Cases**:
  - Random number generation
  - A/B test random assignment
  - Modeling complete uncertainty

---

### 6. Beta Distribution

- **Definition**: Continuous distribution on [0,1], often used for modeling probabilities and proportions
- **Parameters**:
  - α (alpha): Shape parameter
  - β (beta): Shape parameter
- **Use Cases**:
  - Bayesian prior for conversion rates
  - Modeling probabilities and percentages
  - A/B test Bayesian analysis

**Product Analytics Example**: Model uncertainty about a feature's true conversion rate.

---

## Choosing the Right Distribution

| **Data Type** | **Characteristics** | **Distribution** |
|---------------|---------------------|------------------|
| Count of events in fixed interval | λ known | Poisson |
| Count of successes in n trials | n fixed, p known | Binomial |
| Time between events | Memoryless | Exponential |
| Continuous measurements | Symmetric, bell-shaped | Normal |
| Proportions/probabilities | Value in [0,1] | Beta |
| Binary outcome (single trial) | One trial | Bernoulli |

---

## Visualizing Distributions

### Probability Mass Function (PMF) - Discrete Distributions
Shows the probability of each discrete outcome (e.g., Binomial, Poisson).

### Probability Density Function (PDF) - Continuous Distributions
Shows the relative likelihood of values (e.g., Normal, Exponential). Area under curve = probability.

### Cumulative Distribution Function (CDF)
P(X ≤ x) - cumulative probability up to a value. Works for both discrete and continuous distributions.

**Python Visualization**:
```python
import matplotlib.pyplot as plt
from scipy import stats
import numpy as np

fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Binomial
n, p = 20, 0.3
x = np.arange(0, n+1)
axes[0,0].bar(x, stats.binom.pmf(x, n, p))
axes[0,0].set_title('Binomial(n=20, p=0.3)')
axes[0,0].set_xlabel('Number of successes')

# Poisson
lam = 5
x = np.arange(0, 15)
axes[0,1].bar(x, stats.poisson.pmf(x, lam))
axes[0,1].set_title('Poisson(λ=5)')
axes[0,1].set_xlabel('Number of events')

# Normal
mu, sigma = 0, 1
x = np.linspace(-4, 4, 100)
axes[1,0].plot(x, stats.norm.pdf(x, mu, sigma))
axes[1,0].set_title('Normal(μ=0, σ=1)')
axes[1,0].set_xlabel('Value')

# Exponential
lam = 1
x = np.linspace(0, 5, 100)
axes[1,1].plot(x, stats.expon.pdf(x, scale=1/lam))
axes[1,1].set_title('Exponential(λ=1)')
axes[1,1].set_xlabel('Time')

plt.tight_layout()
plt.show()
```

---

## Interview Tips

### Common Questions

1. **"Which distribution would you use to model..."**
   - Count of events in fixed time? → Poisson
   - Success rate from n trials? → Binomial
   - Time between arrivals? → Exponential
   - Continuous measurements? → Normal (if symmetric)

2. **"What's the difference between Binomial and Poisson?"**
   - Binomial: Fixed n trials, counting successes
   - Poisson: Fixed time/space interval, counting events
   - When n is large and p is small, Binomial ≈ Poisson

3. **"When can you approximate Binomial with Normal?"**
   - When n*p ≥ 5 and n*(1-p) ≥ 5
   - Use continuity correction for better approximation

### Key Insights
- **Central Limit Theorem**: Sample means tend toward normal distribution regardless of original distribution (with large enough n)
- **Memoryless Property**: Only Exponential (continuous) and Geometric (discrete) have this property
- **Conjugate Priors**: Beta is conjugate to Binomial (useful for Bayesian A/B testing)

---

## Practical Applications in Product Analytics

### 1. A/B Testing
- Use Binomial distribution to model conversions
- Use Normal approximation for large samples
- Use Beta-Binomial for Bayesian approach

### 2. User Engagement
- Poisson: Model number of daily sessions
- Exponential: Model time between sessions
- Normal: Model session duration for active users

### 3. Forecasting
- Historical patterns often follow known distributions
- Use distribution parameters to predict future behavior

### 4. Anomaly Detection
- Events far from expected distribution (e.g., >3σ for Normal) may indicate anomalies
- P-value approach: flag events with p < 0.01

---

## Conclusion

Understanding probability distributions is essential for:
- Modeling real-world data
- Making statistical inferences
- Designing and analyzing experiments
- Communicating uncertainty

**Practice**: For every dataset you analyze, ask:
- What distribution best describes this data?
- What are the parameters?
- Are there outliers or departures from the assumed distribution?

Mastery of distributions will make you a more effective analyst and improve your statistical intuition!