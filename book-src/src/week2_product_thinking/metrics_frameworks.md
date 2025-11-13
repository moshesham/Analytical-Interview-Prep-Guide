# Metrics Frameworks: HEART and AARRR

## Overview

Metrics frameworks provide structured approaches to measuring product success. They help teams:
- Choose the right metrics for different product goals
- Avoid vanity metrics that look good but don't drive decisions
- Connect user behavior to business outcomes
- Communicate product health to stakeholders

This guide covers two essential frameworks: **HEART** (for user experience) and **AARRR** (for customer lifecycle). These are frequently discussed in product analytics interviews.

## HEART Framework

Developed by Google's research team, HEART helps measure user experience across five dimensions. It's particularly useful for feature-level analysis and teams focused on user satisfaction.

### The Five Components

#### 1. **Happiness** - User Satisfaction and Sentiment

Measures how users *feel* about the product through subjective feedback.

**Common Metrics:**
- **Net Promoter Score (NPS)**: "How likely are you to recommend this product?" (-100 to +100 scale)
- **Customer Satisfaction (CSAT)**: "How satisfied are you?" (1-5 or 1-10 scale)
- **Customer Effort Score (CES)**: "How easy was it to accomplish your task?" (1-7 scale)
- **App Store Ratings**: Average rating and review sentiment
- **Survey responses**: Targeted feedback on specific features

**Example - Spotify:**
- **Metric**: NPS score by user segment
- **Baseline**: Free users NPS = 30, Premium users NPS = 60
- **Goal**: Improve Free user NPS to 40 by improving discovery features
- **Hypothesis**: Better personalization → higher satisfaction → more premium conversions

**When to use:**
- Measuring overall product sentiment
- Evaluating major redesigns
- Comparing satisfaction across user segments
- Understanding emotional response to changes

**Limitations:**
- Lagging indicator (measures past experience)
- Survey response bias (happiest and unhappiest users respond most)
- Doesn't explain *why* users feel a certain way

#### 2. **Engagement** - Intensity of User Interaction

Measures how *actively* users interact with the product.

**Common Metrics:**
- **Daily/Weekly/Monthly Active Users (DAU/WAU/MAU)**
- **Session length**: Average time spent per visit
- **Session frequency**: Visits per user per time period
- **Feature adoption**: % of users who use specific features
- **Depth of engagement**: Pages viewed, actions taken per session

**Key Engagement Ratios:**
```
DAU/MAU Ratio = Daily Active Users / Monthly Active Users
- Measures "stickiness" of the product
- Higher ratio = more frequent return visits
- Benchmark: >20% is good, >50% is exceptional

Example:
- Social media (Instagram): ~55% (people check multiple times daily)
- E-commerce (Amazon): ~30% (frequent but not daily for most)
- Tax software (TurboTax): ~3% (highly seasonal usage)
```

**Example - YouTube:**
- **Primary Metric**: Watch time per user per day
- **Supporting Metrics**: 
  - Videos watched per session (breadth)
  - Average video completion rate (depth)
  - Return visit rate within 24 hours
- **Segmentation**: Mobile vs. Desktop, Subscriber vs. Non-subscriber

**Engagement Analysis Example:**
```
Segment              | DAU/MAU | Avg Session | Sessions/Day | Watch Time/Day
---------------------|---------|-------------|--------------|---------------
Power Users (10%)    |   85%   |   45 min    |     3.2      |    2.4 hours
Regular Users (40%)  |   40%   |   25 min    |     1.5      |    0.6 hours
Casual Users (50%)   |   15%   |   15 min    |     1.0      |    0.25 hours
```

**When to use:**
- Measuring product "stickiness"
- Identifying power users vs. casual users
- Evaluating features that drive repeat usage
- Understanding usage patterns over time

#### 3. **Adoption** - Uptake of New Features

Measures how quickly users discover and start using new functionality.

**Common Metrics:**
- **Feature adoption rate**: % of active users who used the feature
- **Time to first use**: How quickly after release do users try it?
- **Activation rate**: % of new users who complete key onboarding actions
- **Breadth of adoption**: % of user segments using the feature

**Adoption Calculation:**
```
Feature Adoption Rate = (Users who used feature ≥1 time in period) / (Total active users in period) × 100%

Example - New "Stories" feature on Instagram:
- Week 1: 5% adoption (early adopters)
- Week 4: 25% adoption (growth phase)
- Week 12: 60% adoption (mainstream)
- Week 52: 70% adoption (mature)

Target: >50% adoption within 3 months for core features
```

**Example - Slack's Threads Feature:**
- **Launch hypothesis**: Threading will reduce noise in channels
- **Metrics**:
  - **Adoption**: % of workspaces using threads
  - **Depth**: Threads created per active user per week
  - **Quality**: % of conversations that use threads appropriately
- **Results**: 40% adoption in 6 months, but usage varied by team size
- **Insight**: Larger teams (50+ people) had 3x higher adoption than small teams

**When to use:**
- Evaluating new feature success
- Measuring onboarding effectiveness
- Understanding feature discovery mechanisms
- Identifying adoption blockers

#### 4. **Retention** - Keeping Users Over Time

Measures how well the product keeps users coming back.

**Common Metrics:**
- **Retention rate**: % of users who return after N days
- **Churn rate**: % of users who stop using the product
- **Cohort retention**: Track retention for groups who started at the same time
- **Resurrection rate**: % of churned users who return

**Retention Calculations:**
```
Day N Retention = (Users active on Day N) / (Users who signed up on Day 0) × 100%

Churn Rate = 1 - Retention Rate

Example - Mobile Game Retention:
Day 1: 40% (60% churn immediately)
Day 7: 20% (50% of Day 1 users return)
Day 30: 10% (50% of Day 7 users stay)
Day 90: 7% (long-term stable users)
```

**Cohort Retention Table Example - Spotify:**
```
Signup Month | Month 1 | Month 2 | Month 3 | Month 6 | Month 12
-------------|---------|---------|---------|---------|----------
Jan 2024     |   75%   |   62%   |   55%   |   48%   |   42%
Feb 2024     |   78%   |   65%   |   58%   |   51%   |    -
Mar 2024     |   80%   |   68%   |   61%   |    -    |    -

Insight: Retention improving with each cohort (product improvements working)
```

**Types of Retention:**
1. **Unbounded retention**: Any return counts (email, social media)
2. **Bounded retention**: Returns within specific window (subscription services)
3. **Return retention**: Multiple returns required (habits, not accidents)

**When to use:**
- Understanding long-term product value
- Calculating customer lifetime value (LTV)
- Identifying when users churn and why
- Evaluating product-market fit

#### 5. **Task Success** - Goal Completion Effectiveness

Measures how efficiently users accomplish their intended tasks.

**Common Metrics:**
- **Task completion rate**: % of attempted tasks completed successfully
- **Error rate**: % of tasks that result in errors
- **Time on task**: How long it takes to complete the task
- **Abandonment rate**: % of tasks started but not completed
- **Support tickets**: Volume of help requests for specific tasks

**Example - E-commerce Checkout:**
```
Task: Complete a purchase

Metrics:
- Completion Rate: 68% (industry benchmark: 60-70%)
- Average time to complete: 3.5 minutes
- Error rate: 5% (payment failures, form errors)
- Abandonment points:
  - Cart page: 10% leave
  - Shipping info: 15% leave
  - Payment info: 25% leave
  - Review order: 5% leave

Analysis:
Payment info page has highest drop-off → 
Hypothesis: Form is too long/complex →
Solution: Test saved payment methods feature
```

**Funnel Analysis Template:**
```
Step                    | Users | Conversion | Drop-off
------------------------|-------|------------|----------
1. Add to cart          | 1000  |   100%     |    0%
2. View cart            |  900  |    90%     |   10%
3. Start checkout       |  700  |    78%     |   22%
4. Enter shipping       |  600  |    86%     |   14%
5. Enter payment        |  450  |    75%     |   25%
6. Complete purchase    |  425  |    94%     |    6%

Overall Conversion: 42.5% (from add-to-cart to purchase)
```

**When to use:**
- Optimizing conversion funnels
- Identifying usability issues
- Measuring feature quality
- A/B testing user flows

### Applying the HEART Framework

**Step-by-Step Process:**

1. **Define Goals** (What matters for this product/feature?)
   - Example: "Increase engagement with recommendation engine"

2. **Choose Signals** (What user behaviors indicate success?)
   - Users clicking on recommended items
   - Users completing recommended content
   - Users returning after positive recommendations

3. **Select Metrics** (How do we measure these signals?)
   - Happiness: Satisfaction survey after using recommendations
   - Engagement: Click-through rate on recommendations
   - Adoption: % of users who click any recommendation
   - Retention: Week-over-week return rate
   - Task Success: % of clicked recommendations completed

4. **Set Targets** (What's good performance?)
   - CTR on recommendations: 15% (baseline: 10%)
   - Weekly return rate: 70% (baseline: 65%)
   - Recommendation satisfaction: 4.2/5.0 (baseline: 3.8/5.0)

**Example - Gmail Smart Compose Feature:**

| HEART Category | Goal | Signal | Metric | Target |
|----------------|------|--------|--------|--------|
| **Happiness** | Users like the feature | Survey feedback | Feature satisfaction score | >4.0/5.0 |
| **Engagement** | Users use it regularly | Accept suggestions | Acceptance rate | >30% |
| **Adoption** | Users discover it | Try feature | % users who accept ≥1 suggestion | >50% |
| **Retention** | Users keep using it | Continued usage | Week-over-week usage rate | >80% |
| **Task Success** | Emails sent faster | Time saved | Avg time to compose email | -15% |

## AARRR Framework (Pirate Metrics)

Created by Dave McClure, AARRR focuses on the customer lifecycle from first touch to monetization. It's particularly popular in startup and growth contexts.

### The Five Stages

#### 1. **Acquisition** - How Users Find You

Measures the effectiveness of channels bringing users to your product.

**Common Metrics:**
- **Traffic sources**: Organic search, paid ads, social media, referrals
- **Cost Per Acquisition (CPA)**: Marketing spend / new users
- **Landing page conversion**: % of visitors who sign up
- **Channel mix**: Distribution of users across acquisition channels

**Channel Analysis Example:**
```
Channel          | Users | CPA   | Quality (D30 Retention) | CAC:LTV Ratio
-----------------|-------|-------|-------------------------|---------------
Organic Search   | 5000  | $0    | 45%                     | 1:8 (excellent)
Paid Social      | 3000  | $15   | 30%                     | 1:2 (marginal)
Referrals        | 2000  | $5    | 55%                     | 1:10 (best)
Content Marketing| 1500  | $10   | 40%                     | 1:5 (good)
Paid Search      | 1000  | $25   | 35%                     | 1:1.5 (poor)

Insight: Invest more in referral program and organic search; reduce paid search spend
```

**Acquisition Funnel:**
```
Impression → Click → Landing Page → Sign Up → Activation

Example - SaaS Product:
100,000 impressions (ads/search results)
→ 2,000 clicks (2% CTR)
→ 1,800 landing page views (90% load successfully)
→ 360 sign-ups (20% conversion)
→ 180 activated users (50% activation)

Key Levers:
- Improve CTR (2% → 3%): Better ad copy/targeting
- Improve landing conversion (20% → 25%): Better value prop
- Improve activation (50% → 70%): Better onboarding
```

**When to focus on Acquisition:**
- Early growth stage
- Entering new markets
- High churn requiring constant new user inflow
- When retention and monetization are optimized

#### 2. **Activation** - First User Experience

Measures how effectively new users experience the product's value.

**Common Metrics:**
- **Activation rate**: % of users who complete "aha moment" actions
- **Time to value**: How long until user experiences core benefit
- **Onboarding completion**: % who finish onboarding flow
- **Day 1 retention**: % who return the next day

**Defining Activation (Examples):**
```
Product              | Activation Event                    | Why It Matters
---------------------|-------------------------------------|--------------------------------
Facebook             | Add 7 friends in 10 days           | Network effects kick in
Dropbox              | Upload first file                   | Value stored in product
Slack                | 2,000 messages sent in team        | Communication centralized
LinkedIn             | Complete profile + 5 connections    | Network building started
Spotify              | Listen to 10+ songs                 | Catalog value demonstrated
```

**Activation Funnel Example - Notion:**
```
Stage                           | Users | Conversion | Cumulative
--------------------------------|-------|------------|------------
1. Sign up                      | 1000  |   100%     |   100%
2. Create first page            |  700  |    70%     |    70%
3. Add content to page          |  500  |    71%     |    50%
4. Invite teammate or share     |  250  |    50%     |    25%
5. Return within 7 days         |  200  |    80%     |    20%

Activated Users: 200 (20% activation rate)

Bottleneck Analysis:
- Biggest drop: Sign up → Create page (30% drop)
- Solution: Improve onboarding with templates and examples
- Expected impact: 70% → 85% = +150 activated users
```

**Time to Activation Analysis:**
```
Time to First Value | % of Users | D30 Retention
--------------------|------------|---------------
< 5 minutes         |    30%     |     65%
5-15 minutes        |    25%     |     50%
15-30 minutes       |    20%     |     40%
30-60 minutes       |    15%     |     30%
> 60 minutes        |    10%     |     15%

Insight: Users who activate in <5 min have 4x better retention
Action: Streamline onboarding to get users to value faster
```

**When to focus on Activation:**
- High sign-up volume but low engagement
- Users signing up but not understanding value
- Long or complex onboarding process
- When you need to improve trial-to-paid conversion

#### 3. **Retention** - Keeping Users Coming Back

Measures long-term product stickiness (similar to HEART Retention).

**Common Metrics:**
- **Cohort retention curves**: How different user groups retain over time
- **Churn rate**: % of users who stop using product each period
- **Activity recency**: When users last used the product
- **Reactivation rate**: % of dormant users who return

**Retention Benchmarks by Industry:**
```
Industry              | Good D7 Retention | Good D30 Retention | Good D90 Retention
----------------------|-------------------|--------------------|-----------------
Social Media          |      45%+         |        35%+        |       25%+
E-commerce            |      30%+         |        25%+        |       20%+
SaaS/Productivity     |      50%+         |        40%+        |       35%+
Gaming                |      25%+         |        15%+        |       10%+
News/Content          |      35%+         |        25%+        |       20%+
```

**Retention Curve Analysis:**
```
Months Since Signup | Cohort A (2024-Q1) | Cohort B (2024-Q2) | Improvement
--------------------|--------------------|--------------------|-------------
Month 0             |       100%         |        100%        |      -
Month 1             |        65%         |         70%        |    +5pp
Month 2             |        48%         |         55%        |    +7pp
Month 3             |        40%         |         48%        |    +8pp
Month 6             |        32%         |         40%        |    +8pp
Month 12            |        28%         |         36%        |    +8pp

Analysis: Cohort B shows consistently better retention due to improved onboarding
```

**Churn Analysis Framework:**
```
1. When do users churn?
   - Identify critical time periods (first week, first month, etc.)

2. Who churns?
   - Segment by user type, behavior, demographics

3. Why do they churn?
   - Exit surveys
   - Usage data before churn
   - Competitive analysis

4. Can we predict churn?
   - Build churn risk model
   - Identify leading indicators

5. How can we prevent churn?
   - Targeted interventions
   - Win-back campaigns
```

**When to focus on Retention:**
- Acquisition costs are high (must keep users longer)
- Product has strong competition
- Negative word-of-mouth from churned users
- Before scaling acquisition (fix leaky bucket first)

#### 4. **Referral** - Users Bringing Other Users

Measures organic, user-driven growth through word-of-mouth.

**Common Metrics:**
- **Referral rate**: % of users who refer others
- **Viral coefficient (K-factor)**: Avg number of new users each user brings
- **Referral conversion rate**: % of referred users who sign up
- **Time to referral**: How soon do users refer others?

**Viral Coefficient Calculation:**
```
K-factor = (% of users who refer) × (Avg invites per referring user) × (Conversion rate of invites)

Example 1 - Dropbox:
- 20% of users send referrals
- Average 5 invites per referring user
- 30% of invites sign up
K = 0.20 × 5 × 0.30 = 0.30

Each user brings 0.30 new users (not self-sustaining growth, K<1)

Example 2 - WhatsApp (in growth phase):
- 60% of users invite others
- Average 8 invites per user (need friends to message)
- 40% of invites sign up
K = 0.60 × 8 × 0.40 = 1.92

Each user brings 1.92 new users (viral growth, K>1)
```

**Referral Mechanics:**
```
Type                  | Example                | Incentive        | K-factor
----------------------|------------------------|------------------|----------
Incentivized         | Dropbox, Airbnb        | Storage, credits | 0.3-0.6
Built-in (Network)   | WhatsApp, Venmo        | Utility          | 1.0-3.0
Social Sharing       | Instagram, TikTok      | Status, content  | 0.5-0.8
Embedded            | Zoom, Figma            | Collaboration    | 0.7-1.2
```

**Referral Funnel Example - Uber:**
```
Stage                        | Users | Conversion
-----------------------------|-------|------------
Active users                 | 10000 |   100%
See referral program         |  7000 |    70%
Click "refer friend"         |  2100 |    30%
Send ≥1 referral             |  1050 |    50%
Referrals sent (total)       |  5250 |   5 each
Referrals who sign up        |  1050 |    20%
Referred users who ride      |   735 |    70%

Effective K-factor: 0.0735 (7.35% of users successfully refer an activated user)
```

**When to focus on Referral:**
- Product has network effects
- Strong product-market fit (happy users)
- Lower customer acquisition cost needed
- After retention is solid (don't want referred users to churn)

#### 5. **Revenue** - Monetization and Business Value

Measures how effectively the product generates revenue from users.

**Common Metrics:**
- **Average Revenue Per User (ARPU)**: Total revenue / total users
- **Customer Lifetime Value (LTV)**: Total revenue from a user over their lifetime
- **Conversion rate**: % of free users who become paying customers
- **Customer Acquisition Cost (CAC)**: Cost to acquire one customer
- **LTV:CAC ratio**: Efficiency of revenue vs. acquisition cost

**Revenue Calculations:**
```
ARPU = Total Revenue / Total Active Users

Example - Spotify (2024):
- Total monthly revenue: $1.2B
- Total monthly active users: 500M
- ARPU = $1,200,000,000 / 500,000,000 = $2.40/user/month

Customer Lifetime Value (LTV):
LTV = (ARPU per month) × (Average customer lifetime in months) × (Gross margin)

Example - SaaS Product:
- ARPU: $50/month
- Average customer lifetime: 24 months
- Gross margin: 80%
- LTV = $50 × 24 × 0.80 = $960

LTV:CAC Ratio:
- If CAC = $200, then LTV:CAC = $960:$200 = 4.8:1
- Benchmark: 3:1 is good, >4:1 is excellent
```

**Monetization Model Analysis:**
```
Model        | Product Example | ARPU | Conversion | Pros                | Cons
-------------|-----------------|------|------------|---------------------|---------------------
Freemium     | Spotify         | $2   | 5-10%      | Wide reach          | Low conversion
Subscription | Netflix         | $12  | 90%+       | Predictable revenue | Churn risk
Transaction  | Uber            | $5   | 100%       | Usage-based         | Variable revenue
Advertising  | Instagram       | $1   | N/A        | Free for users      | Need scale
Hybrid       | LinkedIn        | $4   | 20%        | Multiple streams    | Complex optimization
```

**Revenue Optimization Framework:**
```
1. Increase ARPU:
   - Upsell to higher tiers
   - Add premium features
   - Reduce discounts

2. Increase Conversion Rate:
   - Improve free → paid funnel
   - Better value demonstration
   - Optimize pricing

3. Increase Retention:
   - Reduce churn
   - Increase usage
   - Build switching costs

4. Reduce CAC:
   - Improve channel efficiency
   - Increase organic growth
   - Optimize funnel conversion

5. Expand Customer Lifetime:
   - Annual contracts
   - Usage-based pricing
   - Lock-in mechanisms
```

**When to focus on Revenue:**
- After activation and retention are optimized
- When unit economics don't support growth
- Pressure from investors/stakeholders
- Entering new monetization models

### Applying the AARRR Framework

**Complete Example - Meditation App:**

```
**Acquisition**
- Channels: App store search (40%), social media ads (30%), influencer partnerships (20%), PR (10%)
- CPA: $3.50
- Weekly new users: 10,000
- Target: Reduce CPA to $3 by improving organic search ranking

**Activation**
- Definition: Complete first meditation session + return within 24 hours
- Current rate: 35%
- Bottleneck: 70% start a session, but only 50% complete it
- Target: 45% activation by improving first-session experience

**Retention**
- D7 retention: 28%
- D30 retention: 18%
- Observation: Users who meditate 3+ times in first week have 60% D30 retention
- Target: Increase 3+ session rate in Week 1 from 20% to 30%

**Referral**
- Current K-factor: 0.15
- Referral rate: 8% of users share app
- Conversion: 25% of referred friends sign up
- Target: K-factor of 0.25 through incentivized referral program

**Revenue**
- Model: Freemium with $10/month subscription
- Free → Paid conversion: 6%
- ARPU: $0.60/user/month (includes free users)
- LTV: $72 (average paid subscriber stays 12 months)
- CAC: $3.50
- LTV:CAC: 20.6:1 (excellent)
- Target: Increase conversion to 8% through paywalled premium content

**Priority:**
1. Activation (biggest impact on all downstream metrics)
2. Retention (improve before scaling acquisition)
3. Referral (lower CAC)
4. Revenue (already healthy LTV:CAC)
5. Acquisition (scale after fixing retention)
```

## Comparing HEART vs. AARRR

| Aspect | HEART | AARRR |
|--------|-------|-------|
| **Focus** | User experience quality | Business/growth outcomes |
| **Best for** | Feature evaluation, UX teams | Startups, growth teams |
| **Time horizon** | Cross-sectional (current state) | Longitudinal (user journey) |
| **Metrics type** | Qualitative + Quantitative | Primarily quantitative |
| **Primary goal** | User satisfaction | Revenue/growth |
| **Typical users** | Product teams at established companies | Growth hackers, early-stage startups |

**When to use HEART:**
- Evaluating specific features or redesigns
- Measuring user experience quality
- Balancing business metrics with user happiness
- When user satisfaction is the primary goal

**When to use AARRR:**
- Optimizing growth and conversion funnels
- Understanding full customer lifecycle
- Identifying growth bottlenecks
- When business metrics are the primary focus

**Combined Approach:**
Many teams use both frameworks together:
- AARRR for overall product strategy and growth
- HEART for feature-level decisions and quality

## Interview Practice Questions

### Question 1: Framework Application
"You're launching a new feature in Instagram that allows users to schedule posts. What metrics would you track, and which framework would you use?"

**Strong Answer:**
"I'd use HEART to evaluate the feature quality, since this is a feature-level decision:

- **Happiness**: Survey satisfaction with scheduling feature (target: 4.2/5)
- **Engagement**: Posts scheduled per active user per week (target: 2+)
- **Adoption**: % of eligible users who schedule ≥1 post (target: 25% in 3 months)
- **Retention**: Week-over-week usage of scheduling feature (target: 70%)
- **Task Success**: Success rate of scheduled posts actually posting (target: 99.5%)

I'd also check AARRR Revenue metrics since this could be premium feature:
- Conversion lift for free → paid among scheduling users
- Willingness to pay for advanced scheduling features"

### Question 2: Metric Investigation
"Netflix's D30 retention dropped from 80% to 78%. Walk me through how you'd investigate using a metrics framework."

**Strong Answer:**
"I'd use AARRR to systematically check each stage:

1. **Acquisition**: Did we get lower quality users recently? Check retention by acquisition channel.

2. **Activation**: Are new users hitting their 'aha moment'? Check % completing first show/movie.

3. **Retention** (focus area):
   - Segment by cohort: Which signup cohorts show the drop?
   - Segment by user type: New vs. existing content preferences
   - Segment by behavior: Viewing hours, content diversity before churn
   - Check: Did we lose a popular show? Content library changes?

4. **Revenue**: Are high-value subscribers churning at different rates?

I'd also check HEART metrics for context:
- Happiness: Recent NPS/satisfaction changes?
- Engagement: Any changes in viewing patterns before churn?

Most likely hypotheses:
- Competitor launched compelling content
- Price increase affected specific segment
- Content recommendation quality degraded
- Seasonal effect (summer viewing patterns)"

### Question 3: Framework Selection
"Your CEO asks you to define success metrics for the company's new product. How would you approach this?"

**Strong Answer:**
"I'd use AARRR as the primary framework since we need to track the full customer lifecycle for a new product. For each stage, I'd define:

**Acquisition**: 
- Primary: Weekly new signups
- Cost: CPA by channel
- Quality: D7 retention by channel

**Activation**:
- Definition: User completes [key action] within first session
- Target: 40% activation rate
- Supporting: Time to activation

**Retention**:
- Primary: D30, D90 retention rates
- Cohort analysis: Track each month's signup cohort
- Target: 35% D30 retention within 6 months

**Referral**:
- K-factor: Target >0.3
- Organic growth: % of new users from referrals

**Revenue**:
- LTV: Target $400
- CAC: Target $100 (4:1 LTV:CAC ratio)
- Conversion: Target 10% free → paid

I'd complement this with key HEART metrics for qualitative validation:
- Happiness: NPS (target: 40+)
- Engagement: DAU/MAU (target: 25%+)

This gives us both growth metrics (AARRR) and experience metrics (HEART)."

## Key Takeaways

1. **Frameworks prevent metric chaos**: They ensure you measure what matters without drowning in data

2. **Choose the right tool**: HEART for experience quality, AARRR for growth and lifecycle

3. **Metrics must drive decisions**: If a metric doesn't inform action, don't track it

4. **Segment everything**: Overall metrics hide important trends in user segments

5. **Connect metrics to business outcomes**: Every metric should tie to revenue, growth, or strategic goals

6. **Balance leading and lagging indicators**: 
   - Leading: Engagement, activation (predict future success)
   - Lagging: Revenue, retention (measure current success)

7. **Avoid vanity metrics**: Metrics that look good but don't drive decisions (total signups, page views without context)

## Practice Exercises

### Exercise 1: Build a Metrics Dashboard
Choose a product you use daily and create a complete metrics framework:
1. Decide which framework fits better (HEART or AARRR)
2. Define 3-5 metrics for each component
3. Estimate current values and set targets
4. Identify the #1 metric you'd focus on and why

### Exercise 2: Metric Debugging
Given this scenario, identify the problem and solution:
```
Product: Social fitness app
Issue: MAU growing 10% month-over-month, but revenue flat

Data:
- DAU/MAU declining from 40% to 30%
- New user activation rate: 50% (stable)
- D30 retention: 25% (stable)
- Free → Paid conversion: 8% (declining from 12%)
- ARPU: $4 (declining from $6)
```

What's the root cause? What metrics would you dive deeper on?

### Exercise 3: Interview Response
Practice answering: "How would you measure the success of Facebook Groups?"

Structure your answer using both HEART and AARRR, explaining which you'd prioritize and why.

## Additional Resources

- Google's HEART Framework paper: [research.google.com](https://research.google.com)
- Dave McClure's AARRR presentation: Startup Metrics for Pirates
- "Lean Analytics" by Alistair Croll and Benjamin Yoskovitz
- Reforge's Growth Series courses
- GoPractice Product Management exercises

Master these frameworks and you'll be able to confidently discuss metrics in any product analytics interview.