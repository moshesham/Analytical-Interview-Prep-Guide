# Week 1 Review & Synthesis

Congratulations on completing Week 1! You've built a solid foundation in SQL, Python, and Statistics—the core technical skills for any data analyst or data scientist role. This section helps you synthesize what you've learned and prepare for Week 2.

---

## Learning Objectives Recap

By the end of Week 1, you should be able to:

### SQL
- ✓ Write complex queries using JOINs, subqueries, and CTEs
- ✓ Use window functions for advanced analytics (ROW_NUMBER, RANK, LAG, LEAD)
- ✓ Understand database design and normalization principles
- ✓ Apply SQL to real product analytics problems

### Python
- ✓ Clean and transform data using pandas
- ✓ Create compelling visualizations with matplotlib and seaborn
- ✓ Perform time series analysis and forecasting
- ✓ Apply statistical methods using scipy and statsmodels

### Statistics
- ✓ Understand key probability distributions (Normal, Binomial, Poisson, Exponential, Beta)
- ✓ Conduct hypothesis testing and interpret p-values correctly
- ✓ Calculate confidence intervals and perform power analysis
- ✓ Apply statistical concepts to product analytics scenarios
- ✓ Understand advanced topics like causal inference and multiple testing correction

---

## Key Concepts to Master

### 1. SQL: Analytical Thinking
- **Window Functions**: The most powerful tool for analytics queries
  - Running totals: `SUM(sales) OVER (ORDER BY date)`
  - Rankings: `RANK() OVER (PARTITION BY category ORDER BY revenue DESC)`
  - Period-over-period comparisons: `LAG(metric, 1) OVER (ORDER BY date)`

**Practice Question**: Write a query to calculate 7-day rolling average of daily active users.

### 2. Python: End-to-End Workflows
- **Data Pipeline**: Load → Clean → Transform → Analyze → Visualize
- **Best Practices**:
  - Always check data types and missing values first
  - Use method chaining for readable transformations
  - Validate results at each step
  - Document assumptions and decisions

**Practice Challenge**: Take a messy dataset, clean it, and create a dashboard-ready visualization.

### 3. Statistics: Decision-Making Under Uncertainty
- **Core Principle**: Statistics helps you quantify uncertainty and make informed decisions
- **Key Insight**: Statistical significance ≠ Practical significance
  - A 0.1% increase in conversion might be statistically significant with millions of users but not worth implementing

**Practice Question**: You run an A/B test and get p=0.03. The treatment group converted 10.1% vs. 10.0% in control. What do you recommend?

---

## Integration Exercise: Bringing It All Together

### Scenario: User Retention Analysis

You're analyzing user retention for a mobile app. Use SQL, Python, and statistics together:

**Step 1 - SQL**: Extract user cohort data
```sql
WITH first_login AS (
  SELECT 
    user_id,
    MIN(DATE(login_timestamp)) AS cohort_date
  FROM user_activity
  GROUP BY user_id
),
activity AS (
  SELECT 
    user_id,
    DATE(login_timestamp) AS activity_date
  FROM user_activity
)
SELECT 
  f.cohort_date,
  a.activity_date,
  DATE_DIFF(a.activity_date, f.cohort_date, DAY) AS days_since_first,
  COUNT(DISTINCT a.user_id) AS active_users
FROM first_login f
JOIN activity a ON f.user_id = a.user_id
GROUP BY 1, 2, 3
ORDER BY 1, 3;
```

**Step 2 - Python**: Calculate and visualize retention curves
```python
import pandas as pd
import matplotlib.pyplot as plt

# Calculate retention rate
cohort_size = df.groupby('cohort_date')['active_users'].first()
df['retention_rate'] = df.groupby('cohort_date').apply(
    lambda x: x['active_users'] / cohort_size[x.name]
).reset_index(level=0, drop=True)

# Visualize
plt.figure(figsize=(12, 6))
for cohort in df['cohort_date'].unique()[:5]:
    cohort_data = df[df['cohort_date'] == cohort]
    plt.plot(cohort_data['days_since_first'], 
             cohort_data['retention_rate'], 
             label=cohort)
plt.xlabel('Days Since First Login')
plt.ylabel('Retention Rate')
plt.title('User Retention Curves by Cohort')
plt.legend()
plt.show()
```

**Step 3 - Statistics**: Test if a product change improved retention
```python
from scipy import stats

# Compare Day 7 retention before and after change
before = df[df['cohort_date'] < '2024-01-01']['day_7_retention']
after = df[df['cohort_date'] >= '2024-01-01']['day_7_retention']

# Two-sample t-test
t_stat, p_value = stats.ttest_ind(after, before)
print(f"P-value: {p_value:.4f}")
print(f"Improvement: {(after.mean() - before.mean()):.2%}")
```

---

## Self-Assessment Checklist

Rate yourself on each skill (1=Need Practice, 5=Confident):

### SQL Skills
- [ ] Writing JOINs and handling NULL values
- [ ] Using subqueries and CTEs for complex logic
- [ ] Implementing window functions (RANK, LAG, etc.)
- [ ] Translating business questions into SQL

### Python Skills
- [ ] Data cleaning and handling missing values
- [ ] Pandas operations (groupby, merge, pivot)
- [ ] Creating effective visualizations
- [ ] Time series analysis
- [ ] Writing modular, reusable code

### Statistics Skills
- [ ] Choosing the right probability distribution
- [ ] Setting up and interpreting hypothesis tests
- [ ] Calculating confidence intervals and power
- [ ] Understanding Type I and Type II errors
- [ ] Connecting statistics to business impact

---

## Common Pitfalls to Avoid

### SQL
1. **Forgetting about NULLs**: Always consider how NULLs affect JOINs and aggregations
2. **Cartesian products**: Ensure join conditions are correct
3. **ORDER BY in subqueries**: Usually unnecessary and can hurt performance

### Python
1. **Modifying data in place**: Use `.copy()` when needed
2. **Ignoring data types**: Convert strings to datetime, numbers to categories
3. **Not validating transformations**: Always check output

### Statistics
1. **Misinterpreting p-values**: p-value is not the probability that H0 is true
2. **Ignoring practical significance**: Statistical significance doesn't mean business importance
3. **Multiple testing without correction**: More tests = higher false positive rate

---

## Practice Problems

### Problem 1: SQL Window Functions
Write a query to find each customer's 3rd purchase date and revenue.

### Problem 2: Python Data Cleaning
Clean a DataFrame with messy dates, revenue (with $ and commas), and inconsistent categories.

### Problem 3: Statistical Inference
Test if 520 clicks out of 1000 users is significantly different from 50% at α=0.05.

---

## Looking Ahead to Week 2

Week 2 focuses on **Product Thinking & A/B Testing**:
- Defining metrics that matter
- Designing rigorous experiments
- Analyzing A/B test results
- Tackling product case studies

**How Week 1 prepares you**:
- **SQL**: Extract data for A/B test analysis
- **Python**: Calculate metrics, visualize results
- **Statistics**: Hypothesis testing, power analysis

---

## Resources for Continued Learning

### Practice Platforms
- **SQL**: [LeetCode Database](https://leetcode.com/problemset/database/), [HackerRank SQL](https://www.hackerrank.com/domains/sql)
- **Python**: [Kaggle Learn](https://www.kaggle.com/learn), [Real Python](https://realpython.com/)
- **Statistics**: [Seeing Theory](https://seeing-theory.brown.edu/), [Khan Academy](https://www.khanacademy.org/math/statistics-probability)

### Recommended Books
- *Practical Statistics for Data Scientists* by Bruce & Bruce
- *Python for Data Analysis* by Wes McKinney
- *SQL Performance Explained* by Markus Winand

---

## Reflection Questions

Before moving to Week 2:

1. What was the most challenging concept this week?
2. How would you explain hypothesis testing to a non-technical stakeholder?
3. What real-world problem could you solve with Week 1 skills?

---

## Final Thoughts

Week 1 builds the foundation. Being a great analyst requires:
- Asking the right questions
- Communicating insights clearly
- Understanding business context
- Driving decisions with data

**Keep practicing, stay curious, and remember: every expert was once a beginner.**

Ready for Week 2? Let's dive into product thinking! 🚀