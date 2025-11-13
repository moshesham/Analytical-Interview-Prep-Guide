# Timed SQL and Python Challenge

## Overview
This timed challenge simulates a real technical interview environment where you must solve problems efficiently under pressure. The problems are designed to reflect common product analytics scenarios you'll encounter in actual interviews.

**Goal:** Build confidence in your ability to solve technical problems within time constraints while demonstrating your thought process.

## Challenge Format

**Total Duration:** 60 minutes (adjusted for realistic completion)
- **SQL Problem:** 30 minutes
- **Python/Pandas Problem:** 30 minutes

**Setup Instructions:**
1. Set up your environment (SQL database or online SQL editor, Python/Jupyter notebook)
2. Set a timer
3. Work through problems in order
4. Document your approach as you go
5. If you finish early, optimize and review your solutions

## SQL Challenge: User Engagement Analysis

### Scenario
You're a product analyst at a social media platform. Your product manager wants to understand user engagement patterns to inform feature development priorities.

### Database Schema

```sql
-- Table: users
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    signup_date DATE,
    country VARCHAR(50)
);

-- Table: posts
CREATE TABLE posts (
    post_id INT PRIMARY KEY,
    user_id INT,
    post_date TIMESTAMP,
    post_type VARCHAR(20), -- 'text', 'image', 'video'
    likes_count INT,
    comments_count INT
);

-- Table: user_sessions
CREATE TABLE user_sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    session_start TIMESTAMP,
    session_end TIMESTAMP,
    pages_viewed INT
);
```

### Problem

Write a SQL query to identify **"power users"** based on the following criteria:
- Users who have been active for at least 30 days (time between signup and last activity)
- Posted at least 10 posts in the last 30 days
- Average session length of at least 15 minutes
- Return: user_id, username, total_posts_last_30_days, avg_session_minutes, days_since_signup

**Additional Requirements:**
1. Exclude users from test accounts (username starts with 'test_')
2. Order results by total posts in descending order
3. Limit to top 20 users
4. Use current date as reference point (use a variable or CURRENT_DATE)

### Starter Template

```sql
-- Define reference date for analysis
WITH analysis_date AS (
    SELECT CURRENT_DATE as ref_date
),

-- Your CTEs here
recent_posts AS (
    -- Calculate posts in last 30 days per user
),

session_stats AS (
    -- Calculate average session length per user
),

user_activity AS (
    -- Calculate days since signup and combine metrics
)

-- Final query here
SELECT 
    -- Your columns here
FROM user_activity
WHERE -- Your conditions
ORDER BY -- Your ordering
LIMIT 20;
```

### Expected Approach
1. **CTEs for clarity:** Break problem into logical steps
2. **Date filtering:** Use appropriate date functions (DATE_ADD, DATEDIFF, INTERVAL)
3. **Aggregations:** Use GROUP BY with COUNT, AVG functions
4. **Joins:** Combine data from multiple tables
5. **Filtering:** Apply WHERE conditions efficiently

### Sample Output

| user_id | username | total_posts_last_30_days | avg_session_minutes | days_since_signup |
|---------|----------|-------------------------|---------------------|-------------------|
| 1523 | sarah_analytics | 45 | 28.5 | 245 |
| 2891 | data_enthusiast | 38 | 22.3 | 312 |
| 4072 | product_fan | 35 | 31.2 | 178 |

---

## Python/Pandas Challenge: Cohort Retention Analysis

### Scenario
You're analyzing user retention for a subscription product. Your team wants to understand how different user cohorts (grouped by signup month) are retaining over time.

### Dataset

You have a DataFrame with the following structure:

```python
import pandas as pd
import numpy as np

# Sample data structure
data = {
    'user_id': [1, 1, 1, 2, 2, 3, 3, 3, 4, 5],
    'signup_date': ['2023-01-15', '2023-01-15', '2023-01-15', 
                    '2023-01-22', '2023-01-22', '2023-02-05',
                    '2023-02-05', '2023-02-05', '2023-02-14', '2023-03-01'],
    'activity_date': ['2023-01-15', '2023-02-10', '2023-03-12',
                      '2023-01-22', '2023-02-18', '2023-02-05',
                      '2023-03-08', '2023-04-15', '2023-02-14', '2023-03-01'],
    'revenue': [29.99, 29.99, 29.99, 49.99, 49.99, 29.99, 29.99, 29.99, 49.99, 29.99]
}

df = pd.DataFrame(data)
df['signup_date'] = pd.to_datetime(df['signup_date'])
df['activity_date'] = pd.to_datetime(df['activity_date'])
```

### Problem

Write a Python function that calculates a **cohort retention table** showing:
1. Cohorts defined by signup month (e.g., "2023-01", "2023-02")
2. Retention percentage for each cohort in months 0, 1, 2, 3 (where month 0 is signup month)
3. Cohort size (number of users in each cohort)

**Function Signature:**

```python
def calculate_cohort_retention(df: pd.DataFrame) -> pd.DataFrame:
    """
    Calculate cohort retention rates.
    
    Parameters:
    -----------
    df : pd.DataFrame
        DataFrame with columns: user_id, signup_date, activity_date, revenue
        
    Returns:
    --------
    pd.DataFrame
        Cohort retention table with cohorts as rows and months as columns
        Example output:
        
        cohort_month | cohort_size | month_0 | month_1 | month_2 | month_3
        2023-01      | 100         | 100%    | 65%     | 52%     | 45%
        2023-02      | 150         | 100%    | 70%     | 58%     | NaN
        2023-03      | 120         | 100%    | 68%     | NaN     | NaN
    """
    # Your implementation here
    pass
```

### Requirements

1. **Data Cleaning:**
   - Handle missing values appropriately
   - Ensure dates are in datetime format
   - Remove duplicate user-date combinations

2. **Cohort Logic:**
   - Group users by their signup month
   - Calculate months since signup for each activity
   - Count unique active users per cohort per month

3. **Output Format:**
   - Percentage values (not decimals)
   - NaN for months that haven't occurred yet
   - Sorted by cohort_month ascending

4. **Edge Cases:**
   - Users with no activity after signup (should show in month 0 only)
   - Users with activity in non-consecutive months
   - Future dates (should be handled gracefully)

### Starter Code

```python
import pandas as pd
import numpy as np

def calculate_cohort_retention(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate cohort retention rates."""
    
    # Step 1: Data preparation
    df = df.copy()
    df['cohort_month'] = df['signup_date'].dt.to_period('M')
    df['activity_month'] = df['activity_date'].dt.to_period('M')
    
    # Step 2: Calculate months since signup
    df['months_since_signup'] = (
        (df['activity_month'] - df['cohort_month']).apply(lambda x: x.n)
    )
    
    # Step 3: Calculate cohort sizes
    cohort_sizes = df.groupby('cohort_month')['user_id'].nunique().reset_index()
    cohort_sizes.columns = ['cohort_month', 'cohort_size']
    
    # Step 4: Calculate retention for each cohort and month
    # YOUR CODE HERE
    
    # Step 5: Pivot to create retention table
    # YOUR CODE HERE
    
    # Step 6: Convert to percentages and format
    # YOUR CODE HERE
    
    return retention_table

# Test your function
# result = calculate_cohort_retention(df)
# print(result)
```

### Expected Output Format

```
cohort_month  cohort_size  month_0  month_1  month_2  month_3
2023-01       152          100.0    64.5     51.3     44.7
2023-02       187          100.0    69.5     56.7     NaN
2023-03       165          100.0    67.3     NaN      NaN
2023-04       143          100.0    NaN      NaN      NaN
```

### Bonus Challenge (if time permits)

Extend the function to also calculate:
1. **Revenue retention:** Average revenue per cohort per month
2. **Retention curves:** Plot retention curves for each cohort using matplotlib

```python
import matplotlib.pyplot as plt

def plot_retention_curves(retention_df: pd.DataFrame) -> None:
    """Plot retention curves for each cohort."""
    # Your implementation here
    pass
```

---

## Complete Solution Code (For Review After Attempting)

<details>
<summary>Click to reveal SQL solution</summary>

```sql
-- Define reference date for analysis
WITH analysis_date AS (
    SELECT CURRENT_DATE as ref_date
),

-- Calculate posts in last 30 days per user
recent_posts AS (
    SELECT 
        user_id,
        COUNT(*) as total_posts_last_30_days
    FROM posts
    CROSS JOIN analysis_date
    WHERE post_date >= DATE_SUB(ref_date, INTERVAL 30 DAY)
    GROUP BY user_id
    HAVING COUNT(*) >= 10
),

-- Calculate average session length per user (in minutes)
session_stats AS (
    SELECT 
        user_id,
        AVG(TIMESTAMPDIFF(MINUTE, session_start, session_end)) as avg_session_minutes
    FROM user_sessions
    WHERE session_end IS NOT NULL
        AND TIMESTAMPDIFF(MINUTE, session_start, session_end) >= 0
    GROUP BY user_id
    HAVING AVG(TIMESTAMPDIFF(MINUTE, session_start, session_end)) >= 15
),

-- Calculate days since signup with last activity
user_activity AS (
    SELECT 
        u.user_id,
        u.username,
        DATEDIFF(
            GREATEST(
                COALESCE(MAX(p.post_date), u.signup_date),
                COALESCE(MAX(s.session_end), u.signup_date)
            ),
            u.signup_date
        ) as days_since_signup
    FROM users u
    LEFT JOIN posts p ON u.user_id = p.user_id
    LEFT JOIN user_sessions s ON u.user_id = s.user_id
    WHERE u.username NOT LIKE 'test_%'
    GROUP BY u.user_id, u.username, u.signup_date
    HAVING days_since_signup >= 30
)

-- Combine all metrics
SELECT 
    ua.user_id,
    ua.username,
    rp.total_posts_last_30_days,
    ROUND(ss.avg_session_minutes, 1) as avg_session_minutes,
    ua.days_since_signup
FROM user_activity ua
INNER JOIN recent_posts rp ON ua.user_id = rp.user_id
INNER JOIN session_stats ss ON ua.user_id = ss.user_id
ORDER BY rp.total_posts_last_30_days DESC
LIMIT 20;
```

**Key Techniques Used:**
- CTEs for modular, readable code
- Date functions (DATE_SUB, DATEDIFF, TIMESTAMPDIFF)
- COALESCE for handling NULLs
- HAVING clause for post-aggregation filtering
- Multiple JOINs with appropriate types (INNER vs LEFT)
- String pattern matching (LIKE)

</details>

<details>
<summary>Click to reveal Python solution</summary>

```python
import pandas as pd
import numpy as np

def calculate_cohort_retention(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate cohort retention rates."""
    
    # Step 1: Data preparation and validation
    df = df.copy()
    
    # Convert to datetime if not already
    df['signup_date'] = pd.to_datetime(df['signup_date'])
    df['activity_date'] = pd.to_datetime(df['activity_date'])
    
    # Remove duplicates
    df = df.drop_duplicates(subset=['user_id', 'activity_date'])
    
    # Step 2: Create cohort and period columns
    df['cohort_month'] = df['signup_date'].dt.to_period('M')
    df['activity_month'] = df['activity_date'].dt.to_period('M')
    
    # Step 3: Calculate months since signup
    df['months_since_signup'] = (
        (df['activity_month'] - df['cohort_month']).apply(lambda x: x.n)
    )
    
    # Filter for valid months (non-negative)
    df = df[df['months_since_signup'] >= 0]
    
    # Step 4: Calculate cohort sizes (unique users per cohort)
    cohort_sizes = (
        df.groupby('cohort_month')['user_id']
        .nunique()
        .reset_index()
        .rename(columns={'user_id': 'cohort_size'})
    )
    
    # Step 5: Calculate unique active users per cohort per month
    retention_data = (
        df.groupby(['cohort_month', 'months_since_signup'])['user_id']
        .nunique()
        .reset_index()
        .rename(columns={'user_id': 'active_users'})
    )
    
    # Step 6: Merge with cohort sizes and calculate percentages
    retention_data = retention_data.merge(cohort_sizes, on='cohort_month')
    retention_data['retention_rate'] = (
        (retention_data['active_users'] / retention_data['cohort_size']) * 100
    ).round(1)
    
    # Step 7: Pivot to create retention table
    retention_table = retention_data.pivot(
        index='cohort_month',
        columns='months_since_signup',
        values='retention_rate'
    )
    
    # Step 8: Add cohort sizes and rename columns
    retention_table = retention_table.merge(
        cohort_sizes,
        left_index=True,
        right_on='cohort_month'
    )
    
    # Reorder columns: cohort_month, cohort_size, then month columns
    month_cols = [col for col in retention_table.columns if isinstance(col, (int, np.integer))]
    month_cols.sort()
    retention_table = retention_table[['cohort_month', 'cohort_size'] + month_cols]
    
    # Rename month columns
    retention_table.columns = (
        ['cohort_month', 'cohort_size'] + 
        [f'month_{i}' for i in range(len(month_cols))]
    )
    
    # Convert cohort_month to string for better display
    retention_table['cohort_month'] = retention_table['cohort_month'].astype(str)
    
    return retention_table

# Bonus: Plotting function
def plot_retention_curves(retention_df: pd.DataFrame) -> None:
    """Plot retention curves for each cohort."""
    import matplotlib.pyplot as plt
    
    # Extract month columns
    month_cols = [col for col in retention_df.columns if col.startswith('month_')]
    
    # Create figure
    plt.figure(figsize=(12, 6))
    
    # Plot each cohort
    for _, row in retention_df.iterrows():
        cohort = row['cohort_month']
        values = row[month_cols].values
        months = range(len(values))
        plt.plot(months, values, marker='o', label=cohort, linewidth=2)
    
    # Formatting
    plt.xlabel('Months Since Signup', fontsize=12)
    plt.ylabel('Retention Rate (%)', fontsize=12)
    plt.title('Cohort Retention Curves', fontsize=14, fontweight='bold')
    plt.legend(title='Cohort', bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.grid(True, alpha=0.3)
    plt.ylim(0, 105)
    plt.tight_layout()
    plt.show()

# Test the functions
if __name__ == "__main__":
    # Create sample data
    np.random.seed(42)
    
    # Generate realistic user activity data
    n_users = 500
    dates = pd.date_range('2023-01-01', '2023-06-30', freq='D')
    
    data = []
    for user_id in range(1, n_users + 1):
        signup_date = np.random.choice(dates[:150])  # Signup in first 5 months
        
        # Generate activity with declining probability
        for month_offset in range(6):
            activity_month = signup_date + pd.DateOffset(months=month_offset)
            
            # Retention probability decreases over time
            retention_prob = 1.0 - (month_offset * 0.15)
            
            if np.random.random() < retention_prob:
                # Random activity date within the month
                activity_date = activity_month + pd.Timedelta(days=np.random.randint(0, 28))
                
                if activity_date <= dates[-1]:  # Don't go beyond our date range
                    data.append({
                        'user_id': user_id,
                        'signup_date': signup_date,
                        'activity_date': activity_date,
                        'revenue': np.random.choice([29.99, 49.99, 99.99])
                    })
    
    df = pd.DataFrame(data)
    
    # Calculate retention
    result = calculate_cohort_retention(df)
    print("\nCohort Retention Table:")
    print(result.to_string(index=False))
    
    # Plot retention curves
    plot_retention_curves(result)
```

**Key Techniques Used:**
- DataFrame manipulation (copy, groupby, merge, pivot)
- Date/time operations (to_period, DateOffset)
- Handling Period data types
- Aggregation with nunique()
- Percentage calculations
- Column renaming and reordering
- Matplotlib for visualization

</details>

---

## Instructions for Taking the Challenge

### Before You Start
1. **Set up your environment:**
   - SQL: Use an online SQL editor (SQLFiddle, DB Fiddle) or local database
   - Python: Jupyter notebook or Python script with pandas installed
   
2. **Create a distraction-free environment:**
   - Turn off notifications
   - Close unnecessary tabs
   - Have water and any notes ready

3. **Prepare your timer:**
   - Use a visible countdown timer
   - Set it for 60 minutes total (or 30 min per problem)

### During the Challenge
1. **Read thoroughly:** Spend 2-3 minutes understanding the problem fully
2. **Plan your approach:** Outline your solution before coding
3. **Start simple:** Get a basic solution working first, then optimize
4. **Test as you go:** Check intermediate results to catch errors early
5. **Document your thinking:** Add comments explaining your logic
6. **Manage your time:** If stuck for >5 minutes, move to a simpler approach

### After the Challenge
1. **Compare with solutions:** Review the provided solutions
2. **Identify improvements:** What could you have done better?
3. **Note patterns:** What techniques were particularly useful?
4. **Practice gaps:** If you struggled, identify which skills to practice more

## Scoring Rubric (Self-Assessment)

### SQL Challenge
- **Correctness (40%):** Does the query produce the right results?
- **Efficiency (20%):** Is the query optimized? Are indexes considered?
- **Readability (20%):** Is the code well-structured with CTEs and comments?
- **Edge Cases (20%):** Does it handle nulls, test users, date boundaries?

### Python Challenge
- **Correctness (40%):** Does the function produce the right output?
- **Data Handling (20%):** Are edge cases and data quality issues handled?
- **Code Quality (20%):** Is the code clean, readable, and efficient?
- **Pandas Proficiency (20%):** Are appropriate pandas methods used effectively?

## Reflection Questions

After completing the challenge, answer these questions:

1. **Time Management:**
   - Did you finish within 60 minutes? If not, what took longer than expected?
   - Did you spend time wisely between planning, coding, and testing?

2. **Technical Approach:**
   - What analytical techniques did you use?
   - What would you do differently knowing what you know now?

3. **Knowledge Gaps:**
   - What concepts did you struggle with?
   - What should you review or practice more?

4. **Problem-Solving:**
   - How did you handle getting stuck?
   - What strategies helped you move forward?

5. **Interview Readiness:**
   - How confident would you feel doing this in a real interview?
   - What additional practice do you need?

## Additional Practice Problems

If you want more practice, try these variations:

### SQL Variations
1. **Funnel Analysis:** Calculate conversion rates through a multi-step signup funnel
2. **Churn Prediction:** Identify users at risk of churning based on behavior changes
3. **Feature Usage:** Analyze which features are most popular among different user segments

### Python Variations
1. **RFM Analysis:** Calculate Recency, Frequency, Monetary scores for user segmentation
2. **Time Series Forecasting:** Predict next month's revenue using historical data
3. **A/B Test Analysis:** Calculate statistical significance of experiment results

## Resources for Practice

- **SQL:** 
  - LeetCode Database problems (easy to hard)
  - HackerRank SQL challenges
  - Mode Analytics SQL tutorial with real datasets
  
- **Python/Pandas:**
  - Kaggle datasets and competitions
  - Real Python tutorials on data analysis
  - Pandas documentation examples

## Key Takeaways

1. **Practice under time pressure** to build interview stamina
2. **Focus on problem-solving process** not just the final answer
3. **Test your solution** with edge cases and sample data
4. **Learn from solutions** - there are often multiple valid approaches
5. **Build a repertoire** of common patterns you can apply quickly
6. **Stay calm** - in real interviews, thinking out loud matters as much as the solution

**Remember:** These challenges are learning tools. The goal isn't perfection—it's building confidence and identifying areas to improve before your actual interviews. Good luck!