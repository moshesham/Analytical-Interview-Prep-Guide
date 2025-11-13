# Mock Technical Interview Framework

## Overview

Technical interviews for product analytics roles differ from pure software engineering interviews. While you need solid coding skills, the focus is on **data manipulation, SQL proficiency, and analytical problem-solving** rather than algorithms and data structures. This guide prepares you for realistic technical interviews tailored to product analytics positions.

**Key Insight:** Product analytics technical interviews test your ability to extract insights from data, not your ability to implement a red-black tree. Focus on SQL, pandas, and analytical thinking.

## Technical Interview Types

### 1. Live SQL Coding (Most Common)
**Duration:** 30-45 minutes  
**Format:** Write SQL queries to answer business questions  
**Difficulty:** Medium to hard queries involving JOINs, window functions, CTEs

### 2. Python/Pandas Data Analysis (Common)
**Duration:** 30-45 minutes  
**Format:** Analyze a dataset and extract insights using Python  
**Difficulty:** Data manipulation, aggregation, visualization

### 3. Take-Home Assignment (Variable)
**Duration:** 2-4 hours (on your own time)  
**Format:** Complete analysis with a dataset, create report  
**Difficulty:** End-to-end analysis mimicking real work

### 4. System Design/Data Pipeline (Less Common for Junior Roles)
**Duration:** 45-60 minutes  
**Format:** Design a data pipeline or analytics system  
**Difficulty:** Architecture, scalability, trade-offs

## Mock Interview Structure

Use this structure for your mock technical interviews:

### Phase 1: Problem Introduction (5 minutes)

**Interviewer Presents:**
- Business context and scenario
- Data schema/structure
- Question or objective

**Candidate Should:**
- Take notes on key details
- Ask clarifying questions
- Confirm understanding before starting

**Example Clarifying Questions:**
- "What date range should I consider?"
- "Should I exclude test accounts?"
- "How should I handle NULL values?"
- "Do you want results aggregated by day, week, or month?"

### Phase 2: Solution Planning (5-10 minutes)

**Candidate Should:**
- Verbalize your thought process
- Break down the problem into steps
- Sketch out your approach (pseudocode or outline)
- Identify which tables/columns you'll need

**Example Approach Outline (SQL):**
```
"Okay, to find monthly active users by cohort:
1. First, I'll identify user signup months
2. Then, calculate active users per month
3. Join these to create cohort-month combinations
4. Calculate retention percentages
5. Pivot if needed for readability"
```

### Phase 3: Implementation (20-25 minutes)

**Candidate Should:**
- Write clean, well-commented code
- Test incrementally (run partial queries/code)
- Think out loud as you code
- Handle edge cases as you go

**SQL Best Practices:**
- Use CTEs for complex queries
- Add comments explaining each CTE's purpose
- Format for readability (line breaks, indentation)
- Test subqueries independently

**Python Best Practices:**
- Import necessary libraries at the top
- Use descriptive variable names
- Add comments for complex logic
- Print intermediate results to verify

### Phase 4: Testing & Validation (5-10 minutes)

**Candidate Should:**
- Test with sample data
- Check edge cases (NULLs, empty sets, boundary dates)
- Verify output format matches requirements
- Explain how you'd validate results in production

**Example Validation Checks:**
- "I would verify row counts against expected values"
- "I'd check if the date range is complete with no gaps"
- "I'd compare against existing reports to sanity-check"

### Phase 5: Optimization & Discussion (5-10 minutes)

**Candidate Should:**
- Discuss time/space complexity
- Suggest optimizations (indexes, query structure)
- Explain trade-offs in your approach
- Be open to alternative solutions

**Example Discussion:**
"This query uses a self-join which could be slow on large tables. If performance is an issue, I'd consider:
1. Adding an index on user_id and activity_date
2. Materializing intermediate results as a temp table
3. Using window functions instead of subqueries"

### Phase 6: Feedback & Debrief (5-10 minutes)

**Interviewer Provides:**
- Feedback on problem-solving approach
- Comments on code quality
- Discussion of alternative solutions
- Suggestions for improvement

**Candidate Should:**
- Take notes on feedback
- Ask questions about preferred approaches
- Request resources for improvement areas

## Common Problem Types & Patterns

### 1. User Engagement Metrics

**Typical Questions:**
- Calculate DAU, WAU, MAU
- Find active users by cohort
- Identify power users based on activity threshold

**Key SQL Patterns:**
```sql
-- DAU calculation with date range
SELECT 
    DATE(activity_timestamp) as activity_date,
    COUNT(DISTINCT user_id) as dau
FROM user_events
WHERE activity_timestamp >= '2023-01-01'
GROUP BY DATE(activity_timestamp)
ORDER BY activity_date;

-- WAU using date functions
SELECT 
    DATE_TRUNC('week', activity_timestamp) as week_start,
    COUNT(DISTINCT user_id) as wau
FROM user_events
GROUP BY DATE_TRUNC('week', activity_timestamp);
```

**Python Pattern:**
```python
# DAU calculation with pandas
dau = df.groupby(df['timestamp'].dt.date)['user_id'].nunique()
```

### 2. Funnel Analysis

**Typical Questions:**
- Calculate conversion rates through a multi-step funnel
- Identify drop-off points
- Time between funnel steps

**Key SQL Pattern:**
```sql
WITH funnel_steps AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) as viewed,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) as added_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) as purchased
    FROM events
    WHERE event_date = '2023-05-01'
    GROUP BY user_id
)
SELECT 
    SUM(viewed) as step1_users,
    SUM(added_cart) as step2_users,
    SUM(purchased) as step3_users,
    ROUND(100.0 * SUM(added_cart) / NULLIF(SUM(viewed), 0), 2) as step1_to_2_pct,
    ROUND(100.0 * SUM(purchased) / NULLIF(SUM(added_cart), 0), 2) as step2_to_3_pct
FROM funnel_steps;
```

### 3. Cohort & Retention Analysis

**Typical Questions:**
- Calculate retention by signup cohort
- N-day retention rates
- Cohort lifetime value

**Key SQL Pattern (using window functions):**
```sql
WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', signup_date) as cohort_month
    FROM users
),
user_activity AS (
    SELECT 
        uc.cohort_month,
        uc.user_id,
        DATE_TRUNC('month', e.activity_date) as activity_month,
        DATEDIFF('month', uc.cohort_month, DATE_TRUNC('month', e.activity_date)) as months_since_signup
    FROM user_cohorts uc
    LEFT JOIN events e ON uc.user_id = e.user_id
)
SELECT 
    cohort_month,
    months_since_signup,
    COUNT(DISTINCT user_id) as active_users
FROM user_activity
GROUP BY cohort_month, months_since_signup
ORDER BY cohort_month, months_since_signup;
```

### 4. A/B Test Analysis

**Typical Questions:**
- Calculate conversion rates for test variants
- Statistical significance testing
- Segment analysis (variant performance by user type)

**Key SQL Pattern:**
```sql
SELECT 
    variant,
    COUNT(DISTINCT user_id) as users,
    SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) as conversions,
    ROUND(100.0 * SUM(CASE WHEN converted = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT user_id), 2) as conversion_rate
FROM experiment_users
WHERE experiment_id = 'checkout_test_v2'
GROUP BY variant;
```

**Python Pattern (with statistical test):**
```python
from scipy.stats import chi2_contingency

# Create contingency table
contingency = pd.crosstab(df['variant'], df['converted'])

# Chi-square test
chi2, p_value, dof, expected = chi2_contingency(contingency)

print(f"Chi-square statistic: {chi2:.4f}")
print(f"P-value: {p_value:.4f}")
print(f"Significant at α=0.05: {p_value < 0.05}")
```

### 5. Revenue & Business Metrics

**Typical Questions:**
- Calculate average revenue per user (ARPU)
- Customer lifetime value (CLV)
- Revenue by cohort or segment

**Key SQL Pattern:**
```sql
SELECT 
    u.user_segment,
    COUNT(DISTINCT u.user_id) as users,
    SUM(o.order_amount) as total_revenue,
    ROUND(SUM(o.order_amount) / COUNT(DISTINCT u.user_id), 2) as arpu
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
    AND o.order_date >= '2023-01-01'
    AND o.order_date < '2024-01-01'
GROUP BY u.user_segment;
```

### 6. Time-Based Analysis

**Typical Questions:**
- Moving averages
- Year-over-year growth
- Seasonality analysis

**Key SQL Pattern (7-day moving average):**
```sql
WITH daily_metrics AS (
    SELECT 
        DATE(event_timestamp) as event_date,
        COUNT(*) as daily_events
    FROM events
    GROUP BY DATE(event_timestamp)
)
SELECT 
    event_date,
    daily_events,
    AVG(daily_events) OVER (
        ORDER BY event_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as moving_avg_7day
FROM daily_metrics
ORDER BY event_date;
```

## Sample Mock Interview Problems

### Problem 1: User Retention Analysis (Medium)

**Scenario:** You work at a streaming service. Your PM wants to understand user retention patterns.

**Tables:**
```sql
users (user_id, signup_date, subscription_type)
streams (stream_id, user_id, stream_date, duration_minutes)
```

**Question:** Calculate 30-day retention rate for each monthly cohort from Q1 2023. 30-day retention means users who had at least one stream between day 23-37 after signup.

**What Interviewer Is Looking For:**
- Understanding of retention definition
- Proper date arithmetic
- Handling of edge cases (users who signed up recently)
- Clear result format

### Problem 2: Feature Usage Analysis (Medium-Hard)

**Scenario:** Your company launched a new feature "Quick Share" 90 days ago.

**Tables:**
```sql
users (user_id, signup_date, user_segment)
feature_usage (user_id, feature_name, usage_date, usage_count)
```

**Question:** 
1. What percent of users have tried Quick Share at least once?
2. Of users who tried it, what percent use it weekly?
3. Is adoption different across user segments?

**What Interviewer Is Looking For:**
- Multiple metrics in one query (or broken into clear CTEs)
- Definition of "weekly user"
- Proper segmentation analysis
- Business communication of insights

### Problem 3: Debugging a Metric (Hard)

**Scenario:** The dashboard shows DAU dropped 15% yesterday, but the product team says no changes were deployed.

**Tables:**
```sql
events (event_id, user_id, event_type, event_timestamp, platform)
users (user_id, signup_date, country)
```

**Question:** Investigate the DAU drop. What queries would you run? What hypotheses would you test?

**What Interviewer Is Looking For:**
- Structured debugging approach
- Thoughtful hypotheses (data quality, seasonality, specific segments)
- Checking for anomalies (missing data, duplicates)
- Communication of findings and next steps

### Problem 4: Python Data Analysis (Medium)

**Scenario:** Given a CSV with user activity data, analyze engagement patterns.

**Dataset:** `user_activity.csv` with columns: user_id, date, sessions, minutes_spent, actions_taken

**Questions:**
1. Calculate average daily sessions per user
2. Identify the top 10% most engaged users (by minutes_spent)
3. Create a visualization showing engagement trends over time

**What Interviewer Is Looking For:**
- Efficient pandas operations
- Proper handling of data types (dates)
- Thoughtful definition of "engagement"
- Clear, informative visualization

## Mock Interview Best Practices

### For Interviewers (If Practicing with a Peer)

**Do:**
- ✅ Give realistic business context
- ✅ Provide clear schema information
- ✅ Allow time for clarifying questions
- ✅ Give hints if candidate is stuck (but let them struggle a bit first)
- ✅ Focus feedback on problem-solving approach, not just correct answer
- ✅ Ask "why" questions to test understanding

**Don't:**
- ❌ Make the problem intentionally trick or ambiguous
- ❌ Rush the candidate or pressure them excessively
- ❌ Expect perfect syntax in a whiteboard setting
- ❌ Focus only on one "right" answer (multiple approaches are valid)

### For Candidates

**Do:**
- ✅ Think out loud constantly
- ✅ Ask clarifying questions early
- ✅ Start with a simple solution, then optimize
- ✅ Test your code/query with examples
- ✅ Admit when you don't know something
- ✅ Discuss trade-offs in your approach

**Don't:**
- ❌ Code in silence
- ❌ Panic if you get stuck
- ❌ Try to memorize solutions (understand patterns instead)
- ❌ Give up on testing your solution
- ❌ Argue defensively about feedback

## Common Pitfalls & How to Avoid Them

### Pitfall 1: Not Clarifying Requirements
**Problem:** Jumping into coding without understanding the ask  
**Solution:** Always ask: "Just to confirm, you want X, right?"

### Pitfall 2: Poor Time Management
**Problem:** Spending 30 minutes on data cleaning, rushing the analysis  
**Solution:** Set mental time checkpoints (10 min for planning, 20 for coding, 10 for testing)

### Pitfall 3: Silent Coding
**Problem:** Writing code without explaining your thinking  
**Solution:** Narrate: "I'm joining these tables because..." "Now I'll filter for..."

### Pitfall 4: Ignoring Edge Cases
**Problem:** Solution works for happy path but breaks on NULLs or empty sets  
**Solution:** Explicitly mention: "I need to handle NULL values here with COALESCE"

### Pitfall 5: Not Testing
**Problem:** Writing code and saying "done" without running it  
**Solution:** Always test with sample data and verbalize what you expect to see

### Pitfall 6: Over-Complicating
**Problem:** Using advanced techniques when simple solutions work  
**Solution:** Start simple. Optimize only if needed.

## Practice Plan

### Week 3 Technical Preparation

**Day 1-2: SQL Pattern Practice**
- Complete 5-10 SQL problems on LeetCode (Medium difficulty)
- Focus on: JOINs, window functions, CTEs, date arithmetic
- Time yourself: 20-30 minutes per problem

**Day 3: Python/Pandas Practice**
- Analyze 2-3 datasets from Kaggle
- Practice: groupby, pivot, merge, datetime operations
- Create at least one visualization per dataset

**Day 4: Full Mock Interview #1**
- Find a peer or use Pramp/Interviewing.io
- Do a complete 45-minute mock (SQL or Python)
- Record feedback and identify 2-3 improvement areas

**Day 5: Targeted Practice**
- Focus on areas identified in mock feedback
- Redo problems where you struggled
- Review SQL optimization techniques

**Day 6: Full Mock Interview #2**
- Second complete mock interview
- Try the opposite type (Python if you did SQL first)
- Compare feedback to first mock—are you improving?

**Day 7: Review & Rest**
- Light review of common patterns
- Skim through your notes
- Rest and prepare mentally

## Technical Interview Checklist

### Before the Interview
- [ ] Test your environment (internet, video, audio)
- [ ] Have SQL editor or Python notebook ready
- [ ] Pen and paper for notes nearby
- [ ] Review common SQL functions and pandas methods
- [ ] Practice talking through your thought process

### During the Interview
- [ ] Take notes on the problem statement
- [ ] Ask clarifying questions
- [ ] Outline your approach before coding
- [ ] Think out loud as you code
- [ ] Test your solution with examples
- [ ] Discuss alternative approaches and trade-offs
- [ ] Ask interviewer if they have questions

### After the Interview
- [ ] Send a thank-you note
- [ ] Document the problems you were asked
- [ ] Note areas where you struggled
- [ ] Review any concepts you were shaky on
- [ ] Update your practice plan based on performance

## Resources for Practice

### SQL Practice Platforms
- **LeetCode Database Problems:** 150+ SQL problems, easy to hard
- **HackerRank SQL:** Structured learning path with problems
- **Mode Analytics SQL School:** Real datasets, product analytics focus
- **SQLZoo:** Interactive SQL tutorials
- **Strata Scratch:** Real interview questions from companies

### Python/Pandas Practice
- **Kaggle Learn:** Free Pandas course with exercises
- **Real Python:** In-depth tutorials on data analysis
- **DataCamp:** Interactive pandas courses
- **Pandas documentation:** Official tutorials and examples

### Mock Interview Platforms
- **Pramp:** Free peer-to-peer mock interviews
- **Interviewing.io:** Mock interviews with experienced interviewers (paid)
- **Exponent:** PM and analytics interview prep (paid)

### Books
- "SQL Queries for Mere Mortals" - Practical SQL patterns
- "Python for Data Analysis" by Wes McKinney - Pandas creator's guide
- "Ace the Data Science Interview" - 201 real interview questions

## Key Takeaways

1. **Product analytics technical interviews focus on SQL and pandas**, not algorithms
2. **Communication is as important as code** - think out loud
3. **Start simple, then optimize** - get something working first
4. **Practice under time constraints** to build interview stamina
5. **Learn patterns, not memorized solutions** - understand the approach
6. **Test your code** - always validate with examples
7. **Mock interviews are essential** - you can't simulate pressure alone

**Remember:** Technical interviews are as much about demonstrating your problem-solving process as getting the right answer. Clear communication, structured thinking, and testing your solution are just as important as writing correct code.

Good luck with your technical mock interviews!