# Metrics Frameworks: HEART and AARRR

## Introduction
Understanding metrics frameworks is crucial for product analysis and decision-making. This document covers two industry-standard frameworks—HEART (developed by Google) and AARRR (Pirate Metrics)—providing practical insights on how to apply them effectively in product analytics interviews and real-world scenarios.

These frameworks help structure your thinking when analyzing product performance, identifying growth opportunities, and making data-driven decisions.

## HEART Framework
The HEART framework, developed by Google's research team, is designed to help teams measure user experience and product success holistically. It consists of five key components:

### 1. Happiness
Measures user satisfaction, emotional response, and overall sentiment toward the product.

**Example Metrics:**
- Net Promoter Score (NPS): "How likely are you to recommend this product?" (Scale 0-10)
- Customer Satisfaction Score (CSAT): Post-interaction satisfaction ratings
- User sentiment analysis from reviews and feedback
- Star ratings and app store reviews

**Real-World Example - Spotify:**
- Track NPS quarterly to measure brand loyalty
- Survey users after key interactions (playlist creation, premium upgrade)
- Monitor app store ratings and review sentiment

### 2. Engagement
Assesses the depth and frequency of user interaction with the product.

**Example Metrics:**
- Daily Active Users (DAU) / Monthly Active Users (MAU)
- Session length and frequency
- Feature usage rates (e.g., % of users using search daily)
- Interactions per session (likes, comments, shares)

**Real-World Example - Instagram:**
- Stories views per DAU
- Average time spent per session
- Number of posts created per week
- Engagement rate: (likes + comments) / followers

### 3. Adoption
Tracks how many new users start using the product or feature, and how quickly they onboard.

**Example Metrics:**
- New user sign-ups per week/month
- Feature adoption rate (% of users who tried a new feature within 7 days)
- Time to first key action (e.g., time to first post, first purchase)
- Activation rate (% of users completing onboarding)

**Real-World Example - Slack:**
- % of new users who send their first message within 24 hours
- % of teams that create their first channel within the first week
- Adoption of new features like Huddles or Clips

### 4. Retention
Measures the ability to keep users returning to the product over time.

**Example Metrics:**
- Day 1, Day 7, Day 30 retention rates
- Churn rate (% of users who stop using the product)
- Cohort retention analysis
- Monthly retention rate: (Active users this month who were active last month) / (Active users last month)

**Real-World Example - Netflix:**
- Monthly subscriber retention rate
- Content completion rates (% of users who finish a series)
- Time between viewing sessions
- Cohort analysis: retention by acquisition channel

### 5. Task Success
Evaluates how effectively and efficiently users can achieve their goals.

**Example Metrics:**
- Task completion rate (% of users who successfully complete a key task)
- Error rate (% of attempts that result in errors)
- Time on task (average time to complete an action)
- Search success rate (% of searches leading to a click)

**Real-World Example - Amazon:**
- % of searches resulting in a purchase
- Checkout completion rate (cart-to-purchase conversion)
- Average time from landing to purchase
- Customer support tickets per transaction

### Applying HEART: Step-by-Step Process

**Step 1: Define Your Product Goals**
Start with what you want to achieve. Examples:
- "Increase user engagement with our new video feature"
- "Improve onboarding experience for new users"
- "Reduce churn among power users"

**Step 2: Map Goals to HEART Categories**
For each goal, identify which HEART dimensions are most relevant:
- Video feature → Engagement, Adoption, Retention
- Onboarding → Adoption, Task Success
- Churn reduction → Retention, Happiness

**Step 3: Choose Specific Metrics**
Select 2-3 metrics per category that align with your goals:
```
Goal: Increase video feature engagement

Engagement:
- DAU using video feature / Total DAU
- Average videos watched per session
- Video completion rate

Adoption:
- % of users who try video within first week
- Time to first video view

Retention:
- 7-day retention of users who watched a video
- Frequency of video feature usage
```

**Step 4: Collect and Analyze Data**
```sql
-- Example SQL: Calculate 7-day retention for video feature
WITH first_video AS (
    SELECT 
        user_id,
        MIN(DATE(video_timestamp)) as first_video_date
    FROM video_events
    GROUP BY user_id
),
day7_return AS (
    SELECT DISTINCT
        fv.user_id,
        fv.first_video_date,
        CASE 
            WHEN ve.video_timestamp IS NOT NULL THEN 1 
            ELSE 0 
        END as returned_day7
    FROM first_video fv
    LEFT JOIN video_events ve 
        ON fv.user_id = ve.user_id
        AND DATE(ve.video_timestamp) = DATE_ADD(fv.first_video_date, INTERVAL 7 DAY)
)
SELECT 
    first_video_date,
    COUNT(*) as total_users,
    SUM(returned_day7) as returned_users,
    ROUND(100.0 * SUM(returned_day7) / COUNT(*), 2) as retention_rate_pct
FROM day7_return
GROUP BY first_video_date
ORDER BY first_video_date DESC;
```

**Step 5: Track Over Time and Iterate**
- Monitor metrics weekly/monthly
- Set up dashboards for real-time tracking
- Conduct regular reviews with stakeholders
- Adjust metrics as product evolves

## AARRR Framework (Pirate Metrics)
The AARRR framework, coined by Dave McClure, focuses on the customer lifecycle funnel and is particularly valuable for growth-focused product teams and startups. It provides a sequential view of the user journey from discovery to monetization.

### 1. Acquisition
How users discover and find your product.

**Example Metrics:**
- Traffic by channel (organic search, paid ads, social media, referrals)
- Cost Per Acquisition (CPA) by channel
- Website visits and landing page views
- Sign-up conversion rate: (Sign-ups / Visitors) × 100

**Real-World Example - Dropbox:**
- Organic search traffic (users searching for "file sharing")
- Referral traffic from existing users
- Paid advertising (Google Ads, social media)
- Content marketing (blog visitors converting to sign-ups)

**SQL Example - Acquisition Channel Analysis:**
```sql
SELECT 
    acquisition_channel,
    COUNT(DISTINCT user_id) as total_users,
    SUM(acquisition_cost) as total_cost,
    ROUND(SUM(acquisition_cost) / COUNT(DISTINCT user_id), 2) as cpa,
    COUNT(DISTINCT CASE WHEN activated = TRUE THEN user_id END) as activated_users,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN activated = TRUE THEN user_id END) / 
          COUNT(DISTINCT user_id), 2) as activation_rate_pct
FROM user_acquisition
WHERE acquisition_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY acquisition_channel
ORDER BY total_users DESC;
```

### 2. Activation
The first meaningful experience users have with your product—often called the "aha moment."

**Example Metrics:**
- % of users completing onboarding
- % of users reaching "aha moment" (e.g., first file uploaded, first friend added)
- Time to first key action
- Feature adoption during first session

**Real-World Example - Facebook:**
- "Aha moment": Adding 7 friends within 10 days
- % of new users who add profile photo
- % of new users who post their first status
- Time to first friend connection

**Defining Activation - Examples by Product:**
| Product | Activation Event |
|---------|------------------|
| Slack | Team sends 2,000 messages |
| Twitter | User follows 30 accounts |
| Airbnb | User completes a booking |
| LinkedIn | User makes 5 connections |

### 3. Retention
The ability to keep users coming back and engaging with the product over time.

**Example Metrics:**
- Day 1, 7, 30, 90 retention rates
- WAU/MAU ratio (stickiness ratio)
- Churn rate by cohort
- Repeat usage rate

**Real-World Example - Duolingo:**
- Daily streak retention (users maintaining consecutive days)
- Weekly lesson completion rate
- 30-day retention by acquisition cohort
- Push notification engagement impact on retention

**Python Example - Cohort Retention Analysis:**
```python
import pandas as pd
import numpy as np

def calculate_cohort_retention(df):
    """
    Calculate cohort retention rates
    df: DataFrame with columns [user_id, signup_date, activity_date]
    """
    # Create cohort column (month of signup)
    df['cohort'] = df['signup_date'].dt.to_period('M')
    df['activity_period'] = df['activity_date'].dt.to_period('M')
    
    # Calculate periods since signup
    df['periods'] = (df['activity_period'] - df['cohort']).apply(lambda x: x.n)
    
    # Create retention matrix
    cohort_data = df.groupby(['cohort', 'periods']).agg(
        users=('user_id', 'nunique')
    ).reset_index()
    
    # Get cohort sizes
    cohort_sizes = df.groupby('cohort')['user_id'].nunique()
    
    # Calculate retention rates
    retention = cohort_data.pivot(index='cohort', 
                                   columns='periods', 
                                   values='users')
    
    retention_pct = retention.divide(cohort_sizes, axis=0) * 100
    
    return retention_pct

# Usage
# retention_rates = calculate_cohort_retention(user_activity_df)
# print(retention_rates)
```

### 4. Referral
Encouraging users to refer others, creating viral growth loops.

**Example Metrics:**
- Viral coefficient (K-factor): average number of new users each existing user brings
- Referral rate: % of users who refer at least one person
- Referral conversion rate: % of referred users who sign up
- Time to first referral

**Real-World Example - Uber:**
- % of users who send a referral code
- Referral code usage rate
- Referred user activation rate
- Cost savings per referral vs. paid acquisition

**Calculating Viral Coefficient:**
```
K = (% of users who invite) × (average invites sent per inviting user) × (conversion rate of invites)

Example:
- 20% of users send invites
- Each inviting user sends 5 invites on average
- 30% of invites convert to sign-ups

K = 0.20 × 5 × 0.30 = 0.30

If K > 1, you have viral growth (each user brings more than one new user)
If K < 1, you need other acquisition channels to grow
```

### 5. Revenue
The financial outcomes and monetization of the product.

**Example Metrics:**
- Average Revenue Per User (ARPU)
- Customer Lifetime Value (LTV)
- LTV:CAC ratio (should be > 3:1)
- Conversion to paid rate
- Monthly Recurring Revenue (MRR)
- Average transaction value

**Real-World Example - Spotify:**
- Free to Premium conversion rate
- ARPU for Premium subscribers
- Churn rate by subscription tier
- LTV by acquisition channel

**SQL Example - Revenue Metrics:**
```sql
WITH user_revenue AS (
    SELECT 
        user_id,
        MIN(subscription_start_date) as first_payment_date,
        SUM(amount) as total_revenue,
        COUNT(DISTINCT DATE_TRUNC('month', payment_date)) as months_active,
        MAX(payment_date) as last_payment_date
    FROM payments
    WHERE status = 'completed'
    GROUP BY user_id
),
user_acquisition AS (
    SELECT 
        user_id,
        acquisition_channel,
        acquisition_cost
    FROM users
)
SELECT 
    ua.acquisition_channel,
    COUNT(DISTINCT ur.user_id) as paying_users,
    ROUND(AVG(ur.total_revenue), 2) as avg_ltv,
    ROUND(AVG(ur.total_revenue / ur.months_active), 2) as avg_arpu,
    ROUND(AVG(ua.acquisition_cost), 2) as avg_cac,
    ROUND(AVG(ur.total_revenue) / NULLIF(AVG(ua.acquisition_cost), 0), 2) as ltv_cac_ratio
FROM user_revenue ur
JOIN user_acquisition ua ON ur.user_id = ua.user_id
GROUP BY ua.acquisition_channel
ORDER BY avg_ltv DESC;
```

### Applying AARRR: Funnel Optimization

**Step 1: Map Your Funnel**
Document your user journey and key conversion points:
```
Acquisition → Activation → Retention → Referral → Revenue
   ↓              ↓             ↓            ↓         ↓
Landing    →  Sign-up  →  Week 1    →   Share   →  Upgrade
 page          complete     active       feature      to paid
  
10K visitors → 2K sign-ups → 1K active → 200 shares → 100 paid
  (20%)         (50%)         (20%)       (10%)
```

**Step 2: Identify Bottlenecks**
Calculate conversion rates between stages and identify where you're losing users:
- Acquisition to Activation: 20% (low—need better onboarding)
- Retention: 50% (good—users who activate stay engaged)
- Referral: 20% (moderate—could improve sharing mechanisms)
- Revenue: 10% (depends on business model)

**Step 3: Prioritize Improvements**
Focus on the stage with the biggest potential impact:
- **Biggest drop-off:** Activation (only 20% sign-up)
- **Highest impact:** Improving activation by 10% = 200 more active users
- **Quick wins:** A/B test onboarding flow, add product tour

**Step 4: Measure and Iterate**
- Run experiments to improve each stage
- Track changes over time
- Calculate compound effect of improvements

## Comparing HEART vs. AARRR

### When to Use Each Framework

**Use HEART when:**
- You need a holistic view of user experience
- Your product is mature and focused on quality
- You're optimizing existing features
- User satisfaction is a key business objective
- You want to balance quantitative and qualitative metrics

**Use AARRR when:**
- You're focused on growth and scaling
- You need to optimize the user funnel
- You're launching a new product or feature
- You need to improve specific conversion points
- You want to track the customer journey sequentially

### Framework Comparison Table

| Aspect | HEART | AARRR |
|--------|-------|-------|
| **Focus** | User experience quality | Growth funnel optimization |
| **Structure** | Dimensional (parallel metrics) | Sequential (funnel stages) |
| **Best for** | Mature products, UX teams | Startups, growth teams |
| **Primary goal** | Balance quality across dimensions | Maximize conversions and growth |
| **Metrics type** | Mix of attitudinal and behavioral | Primarily behavioral |
| **Time frame** | Ongoing monitoring | Stage-by-stage optimization |

### Combining Both Frameworks

Many successful product teams use both frameworks together:

**Example - E-commerce App:**

```
AARRR Stage → HEART Metrics Applied

Acquisition:
- Track traffic sources (AARRR)
- Measure initial Happiness via landing page survey (HEART)

Activation:
- Monitor sign-up completion (AARRR)
- Track Task Success rate for first purchase (HEART)

Retention:
- Calculate cohort retention (AARRR)
- Measure Engagement via DAU/MAU (HEART)

Referral:
- Monitor viral coefficient (AARRR)
- Track Happiness via NPS from referring users (HEART)

Revenue:
- Calculate LTV and ARPU (AARRR)
- Ensure Retention of paying users (HEART)
```

## Interview Tips: Using Frameworks Effectively

### Common Interview Questions

**Q: "How would you measure the success of [feature/product]?"**

**Strong Answer Structure:**
1. **Clarify the goal:** "First, I'd want to understand the primary objective—is it user growth, engagement, or monetization?"
2. **Choose a framework:** "For a new feature launch, I'd use AARRR to track the funnel from discovery to value realization."
3. **Define specific metrics:** "For Activation, I'd measure % of users who complete the key action within 7 days..."
4. **Explain trade-offs:** "While focusing on Acquisition, I'd also monitor Retention with HEART to ensure we're not sacrificing quality for growth."

**Q: "Instagram Stories engagement is declining. How would you investigate?"**

**Strong Answer Using HEART:**
1. **Happiness:** Check NPS and sentiment—are users frustrated?
2. **Engagement:** Analyze DAU/MAU, stories per user, view duration
3. **Adoption:** Look at new user adoption vs. existing user behavior
4. **Retention:** Check if Stories users are churning faster
5. **Task Success:** Measure story creation success rate, technical errors

### Common Pitfalls to Avoid

1. **Metric Overload:** Don't try to track everything
   - ❌ "We'll track 20 metrics across all HEART dimensions"
   - ✅ "We'll focus on 2-3 key metrics per dimension aligned with our goal"

2. **Vanity Metrics:** Focus on actionable metrics
   - ❌ "Total sign-ups increased 50%!"
   - ✅ "Activated users (who completed onboarding) increased 30%"

3. **Missing Context:** Always consider the full picture
   - ❌ "Engagement is down 10%"
   - ✅ "Engagement is down 10%, but revenue per user increased 15%—users are more selective but higher value"

4. **No Baseline:** Establish comparisons
   - ❌ "Our retention rate is 40%"
   - ✅ "Our 30-day retention is 40%, up from 35% last quarter and above the 30% industry benchmark"

## Practice Exercise

**Scenario:** You're launching a new "group workout" feature for a fitness app.

**Your Task:**
1. Choose HEART or AARRR (or both) and justify your choice
2. Define 3-4 key metrics for each relevant stage/dimension
3. Write a SQL query to calculate one of your chosen metrics
4. Explain how you'd use these metrics to evaluate success

**Example Solution:**

*I'd use both frameworks:*

**AARRR for Launch:**
- **Acquisition:** % of users who see the feature announcement
- **Activation:** % who create or join their first group workout
- **Retention:** 7-day retention of users who joined a group

**HEART for Quality:**
- **Engagement:** Group workout sessions per user per week
- **Task Success:** % of scheduled workouts completed
- **Happiness:** Post-workout satisfaction rating

**Key Metric Query (Activation):**
```sql
SELECT 
    DATE_TRUNC('week', feature_launch_date) as week,
    COUNT(DISTINCT user_id) as total_users_eligible,
    COUNT(DISTINCT CASE 
        WHEN first_group_action IS NOT NULL 
        THEN user_id 
    END) as activated_users,
    ROUND(100.0 * COUNT(DISTINCT CASE 
        WHEN first_group_action IS NOT NULL 
        THEN user_id 
    END) / COUNT(DISTINCT user_id), 2) as activation_rate_pct
FROM (
    SELECT 
        u.user_id,
        u.feature_launch_date,
        MIN(gw.created_at) as first_group_action
    FROM users u
    LEFT JOIN group_workouts gw 
        ON u.user_id = gw.user_id
        AND gw.created_at >= u.feature_launch_date
        AND gw.created_at <= u.feature_launch_date + INTERVAL '7 days'
    WHERE u.feature_launch_date >= '2024-01-01'
    GROUP BY u.user_id, u.feature_launch_date
) subquery
GROUP BY week
ORDER BY week DESC;
```

## Conclusion

Both HEART and AARRR frameworks provide powerful structures for analyzing product performance and user experience. HEART offers a holistic view of user experience quality, while AARRR focuses on optimizing the growth funnel. 

**Key Takeaways:**
- Choose frameworks based on your product stage and goals
- Define clear, measurable metrics for each dimension/stage
- Use SQL and Python to calculate and track metrics over time
- Always consider trade-offs between different metrics
- Communicate insights clearly with context and comparisons

By mastering these frameworks, you'll be well-equipped to answer product analytics interview questions and drive data-informed product decisions in your role.

## Additional Resources

- **HEART Framework:** [Original Google Research Paper](https://research.google/pubs/pub43887/)
- **AARRR Metrics:** Dave McClure's presentations on Pirate Metrics
- **Cohort Analysis:** [Amplitude's Guide to Retention](https://amplitude.com/blog/retention-cohort-analysis)
- **Metric Selection:** "Lean Analytics" by Alistair Croll and Benjamin Yoskovitz