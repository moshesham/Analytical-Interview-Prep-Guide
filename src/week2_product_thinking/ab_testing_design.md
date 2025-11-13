# A/B Testing Design

## Overview

A/B testing (also called split testing or randomized controlled experiments) is the gold standard for making data-driven product decisions. It allows you to validate hypotheses by comparing two or more variants in a controlled experiment.

In product analytics interviews, you'll be asked to:
- Design experiments from scratch
- Calculate required sample sizes
- Choose appropriate metrics
- Identify potential pitfalls and biases

**Key Benefits of A/B Testing:**
- Removes guesswork from product decisions
- Quantifies impact of changes
- Reduces risk of shipping bad features
- Provides statistical confidence in results

## The 8-Step A/B Test Design Framework

### Step 1: Define a Clear Hypothesis

**A good hypothesis has three components:**
1. **Change**: What are you changing?
2. **Impact**: What metric will it affect?
3. **Magnitude**: By how much?

**Format:**
```
If we [make this change], then [this metric] will [increase/decrease] by [X%] 
because [reasoning based on user behavior]
```

**Examples:**

❌ **Bad Hypothesis:**
"Adding more features will improve the product"
- Too vague, no specific metric, no magnitude

✅ **Good Hypothesis:**
"If we add a 'Save for Later' button on product pages, then cart conversion rate 
will increase by 5% because users can bookmark items and return when ready to purchase"
- Specific change, specific metric, estimated magnitude, clear reasoning

**Example Hypotheses by Product:**

| Product | Change | Metric | Expected Impact | Reasoning |
|---------|--------|--------|-----------------|-----------|
| Netflix | Auto-play previews | Time to first watch | -20% (faster) | Reduces decision paralysis |
| Uber | Show driver photo before ride | Booking acceptance | +3% | Increases trust and perceived safety |
| LinkedIn | Simplify profile edit | Profile completion rate | +15% | Reduces friction in onboarding |
| Amazon | One-click checkout | Conversion rate | +25% | Removes multi-step friction |

**Practice:** For any hypothesis, ask yourself:
- Is it testable? (can we measure the outcome?)
- Is it specific? (what exactly are we changing?)
- Is it falsifiable? (could the data prove us wrong?)

### Step 2: Identify Success Metrics

**Metric Hierarchy:**

**Primary Metric (North Star):**
- The ONE metric that determines success or failure
- Directly related to your hypothesis
- Used for decision-making

**Secondary Metrics:**
- Provide additional context and insights
- Help explain WHY primary metric moved
- May reveal unexpected impacts

**Guardrail Metrics:**
- Ensure changes don't harm other parts of the product
- Protect critical user experience elements
- Act as safety checks

**Example - Testing a New Checkout Flow:**

```
PRIMARY METRIC:
- Purchase conversion rate (% of users who complete checkout)
  - Why: Directly measures hypothesis success
  - Decision rule: Ship if +3% improvement, p<0.05

SECONDARY METRICS:
- Time to complete checkout
- Cart abandonment rate by step
- Error rate during checkout
- Support ticket volume

GUARDRAIL METRICS:
- Overall revenue per user (ensure we're not losing high-value customers)
- Return rate (ensure quality isn't suffering)
- User satisfaction score (NPS)
- App crash rate
```

**Metric Selection Criteria:**

✅ **Good Metrics:**
- Sensitive: Will move if treatment works
- Timely: Can measure within experiment timeframe
- Interpretable: Clear meaning for stakeholders
- Actionable: Can be improved through product changes

❌ **Avoid:**
- Vanity metrics: Look good but don't drive decisions
- Slow-moving metrics: Take too long to detect changes
- Noisy metrics: High variance masks true effects
- Composite metrics: Hard to interpret what caused changes

**Common Metric Pitfalls:**

| Issue | Example | Better Alternative |
|-------|---------|-------------------|
| Too aggregated | "Overall engagement" | DAU, session length, actions per user |
| Gaming-prone | "Page views" | "Time on page" or "scroll depth" |
| Not business-relevant | "Feature clicks" | "Task completion rate" |
| Delayed feedback | "90-day retention" | "D7 retention" for faster iteration |

### Step 3: Calculate Sample Size

**Why Sample Size Matters:**
- Too small: Can't detect real effects (Type II error)
- Too large: Wastes time and resources

**Four Inputs for Sample Size Calculation:**

1. **Baseline Conversion Rate (p):**
   - Current performance of the metric
   - Example: 5% of users convert

2. **Minimum Detectable Effect (MDE):**
   - Smallest change you care about detecting
   - Example: Want to detect +0.5pp increase (5% → 5.5%)

3. **Statistical Significance (α):**
   - Probability of false positive (Type I error)
   - Standard: α = 0.05 (5% chance of false positive)

4. **Statistical Power (1-β):**
   - Probability of detecting a true effect
   - Standard: 80% power (β = 0.20)

**Sample Size Formula (Two-Sample Proportion Test):**

```
n = 2 × (Z_α/2 + Z_β)² × p(1-p) / (MDE)²

Where:
- Z_α/2 = 1.96 for α = 0.05 (two-tailed)
- Z_β = 0.84 for 80% power
- p = baseline conversion rate
- MDE = minimum detectable effect (absolute)
```

**Worked Example:**

```
Scenario: Testing a new signup flow
- Baseline conversion rate: p = 10% (0.10)
- Want to detect: MDE = 2pp (0.02) - i.e., 10% → 12%
- Significance: α = 0.05
- Power: 80% (β = 0.20)

Calculation:
n = 2 × (1.96 + 0.84)² × 0.10(0.90) / (0.02)²
n = 2 × (2.80)² × 0.09 / 0.0004
n = 2 × 7.84 × 0.09 / 0.0004
n = 1.411 / 0.0004
n ≈ 3,528 per group

Total sample needed: 7,056 users (3,528 control + 3,528 treatment)
```

**Online Calculators:**
- Evan's Awesome A/B Tools: evanmiller.org/ab-testing
- Optimizely Sample Size Calculator
- VWO Sample Size Calculator

**Sample Size Trade-offs:**

| Factor | If Increased → Sample Size |
|--------|----------------------------|
| Baseline rate closer to 50% | Increases |
| Smaller MDE (want to detect smaller changes) | Increases significantly |
| Higher power (e.g., 90% vs. 80%) | Increases |
| Higher significance (α = 0.01 vs. 0.05) | Increases |

**Practical Considerations:**

```
Traffic Reality Check:

If you need 10,000 users per group and you have:
- 1,000 DAU → Need 20 days (10,000 × 2 / 1,000)
- 10,000 DAU → Need 2 days
- 100,000 DAU → Can run in hours

Consider:
- Business cycles (run full weeks to capture weekend effects)
- Seasonal patterns (avoid holidays if possible)
- External events (avoid during major campaigns)
```

### Step 4: Design Randomization

**Proper randomization is critical to avoid bias.**

**Randomization Unit:**
Choose what entity gets randomized:

| Unit | Use When | Example | Pro | Con |
|------|----------|---------|-----|-----|
| **User** | Most common | User ID | Clean, independent | Need user login |
| **Session** | Anonymous users | Cookie/Session ID | Works for logged-out | Not independent |
| **Device** | Mobile apps | Device ID | Stable | Users with multiple devices |
| **Page View** | Testing UI only | Request ID | Maximum traffic | High correlation |

**Best Practices:**

✅ **Do:**
- Use deterministic randomization (same user always sees same variant)
- Hash user ID with experiment ID for consistent assignment
- Document randomization method
- Validate equal group sizes

❌ **Don't:**
- Use time-based randomization (Monday = control, Tuesday = treatment)
- Allow users to self-select into groups
- Change randomization mid-experiment
- Use biased hashing methods

**Randomization Code Example (Pseudocode):**
```python
def assign_variant(user_id, experiment_id):
    # Combine user_id and experiment_id for consistent hashing
    hash_input = f"{user_id}_{experiment_id}"
    hash_value = hash(hash_input)
    
    # Use modulo to assign to group (50/50 split)
    if hash_value % 2 == 0:
        return "control"
    else:
        return "treatment"
```

**Stratified Randomization:**
When you have important user segments, ensure balance across groups:

```
Example: Mobile vs. Desktop users

Simple Randomization (might create imbalance):
- Control: 45% mobile, 55% desktop
- Treatment: 55% mobile, 45% desktop
Problem: Confounds platform with treatment

Stratified Randomization:
- First, split users by platform
- Then, randomize within each platform
Result:
- Control: 50% mobile, 50% desktop
- Treatment: 50% mobile, 50% desktop
```

### Step 5: Determine Test Duration

**Three Factors:**

**A. Reach Minimum Sample Size:**
```
Duration (days) = Required Sample Size / (Daily Active Users × % in Experiment)

Example:
- Need 10,000 users per group (20,000 total)
- Have 5,000 DAU
- Running at 50% traffic (2,500 users/day in experiment)

Duration = 20,000 / 2,500 = 8 days minimum
```

**B. Account for Weekly Cycles:**
- Users behave differently on weekends vs. weekdays
- Run for full weeks (7, 14, 21 days) to balance day-of-week effects

**C. Allow for Metric Stabilization:**
- Some metrics have novelty effects (initial excitement wears off)
- Run long enough for behavior to normalize
- Rule of thumb: 2-4 weeks for most product changes

**Duration Decision Tree:**

```
Start with minimum duration from sample size calculation

If testing fundamental change (e.g., new onboarding):
→ Add 1-2 weeks for novelty effect to wear off

If low traffic:
→ Increase % of users in experiment (e.g., 100% instead of 50%)

If seasonal business (e.g., tax software):
→ Account for seasonal patterns, may need full season

If critical feature:
→ Start with smaller % of traffic, extend duration
```

**Example Durations by Test Type:**

| Test Type | Typical Duration | Reasoning |
|-----------|------------------|-----------|
| Button color | 3-7 days | Quick to detect, minimal novelty effect |
| Pricing change | 14-21 days | Need to see full purchase cycle |
| New feature | 21-28 days | Novelty effect, habit formation |
| Algorithm change | 14-28 days | Need ecosystem to stabilize |
| Onboarding flow | 28-42 days | Need to see longer-term retention |

**Early Stopping:**
- Tempting to stop when you see significance
- Risk: Random early patterns can be misleading
- Best practice: Pre-define duration and stick to it
- Exception: Critical bugs or severe negative impacts

### Step 6: Control for Confounds

**Common Confounds:**

**A. Selection Bias:**
```
Problem: Treatment and control groups differ in ways that affect outcome

Example:
- New feature only shown to iOS users
- iOS users have higher baseline engagement
- Can't tell if improvement is from feature or from having more iOS users

Solution: Stratify randomization by platform
```

**B. Survivorship Bias:**
```
Problem: Only looking at users who completed the flow

Example:
- Testing checkout flow
- Only measuring time-to-complete for users who finished
- Missing users who abandoned (treatment might cause more abandonment)

Solution: Include all users in analysis, use intention-to-treat
```

**C. Novelty Effect:**
```
Problem: Initial excitement creates temporary lift

Example:
- New button design shows +20% clicks in Week 1
- Drops to +5% by Week 3
- Users just clicked because it was new/different

Solution: Run longer tests, analyze by week
```

**D. Seasonality:**
```
Problem: External factors affect results

Example:
- Testing e-commerce feature during Black Friday
- Can't separate feature effect from holiday shopping behavior

Solution: Avoid testing during anomalous periods, or run A/A test as baseline
```

**E. Interaction Effects:**
```
Problem: Multiple experiments running simultaneously interact

Example:
- Test A: New homepage design
- Test B: New product page design
- Users in both tests have different experience than either alone

Solution: Use orthogonal experiment assignment, monitor interaction metrics
```

### Step 7: Plan for Segmentation Analysis

**Pre-define segments of interest:**

**Platform-based:**
- Mobile vs. Desktop vs. Tablet
- iOS vs. Android
- App vs. Web

**User-based:**
- New users (< 30 days) vs. Returning users
- High-value vs. Low-value customers
- Engaged vs. Casual users

**Geographic:**
- Country or region
- Timezone effects

**Behavioral:**
- Users who use feature X
- Users from acquisition channel Y

**Example Segmentation Plan:**

```
Experiment: New search algorithm

PRIMARY ANALYSIS:
- Overall impact on click-through rate

SEGMENTATION ANALYSIS:
1. By user type:
   - Power users (top 10% by searches)
   - Regular users (middle 80%)
   - Light users (bottom 10%)
   
2. By query type:
   - Navigational (looking for specific item)
   - Exploratory (browsing)
   
3. By platform:
   - Mobile app
   - Desktop web

HYPOTHESIS:
- Power users may see bigger improvement (more searches = more opportunities)
- Mobile users may see smaller effect (smaller screen = less visibility)

PRE-REGISTERED TESTS:
- Will run separate significance tests for each segment
- Will use Bonferroni correction for multiple comparisons
```

**Beware:** Multiple segment tests increase false positive risk. Adjust significance level:

```
Bonferroni Correction:
If testing 5 segments, use α = 0.05 / 5 = 0.01 per test
```

### Step 8: Document Everything

**Create an Experiment Design Doc:**

**Template:**
```
EXPERIMENT NAME: [Descriptive name]
EXPERIMENT ID: [Unique identifier]
OWNER: [Your name/team]
START DATE: [Date]
END DATE: [Date]

1. HYPOTHESIS
   - Change: [What are we changing?]
   - Impact: [Expected effect on metrics]
   - Reasoning: [Why we think this will work]

2. METRICS
   - Primary: [Main decision metric]
   - Secondary: [Supporting metrics]
   - Guardrails: [Safety metrics]

3. SAMPLE SIZE
   - Calculation: [Show work]
   - Required: [N per group]
   - Expected duration: [Days]

4. RANDOMIZATION
   - Unit: [User/Session/Device]
   - Method: [Algorithm]
   - Traffic allocation: [50/50, 90/10, etc.]

5. SEGMENTS
   - Pre-defined segments for analysis
   - Multiple testing corrections

6. RISKS & MITIGATION
   - Potential negative impacts
   - Monitoring plan
   - Rollback criteria

7. DECISION CRITERIA
   - Launch if: [Conditions]
   - Iterate if: [Conditions]
   - Kill if: [Conditions]
```

## Complete A/B Test Design Example

### Scenario: Airbnb - Testing a New Search Ranking Algorithm

**Step 1: Hypothesis**
```
If we use a machine learning model that optimizes for booking likelihood 
instead of the current hand-tuned ranking, then booking conversion rate 
will increase by 5% because listings better match user preferences.
```

**Step 2: Metrics**
```
PRIMARY:
- Booking conversion rate: (Bookings / Searches) × 100%
- Baseline: 2.5%
- Target: 2.625% (+5%)

SECONDARY:
- Click-through rate (Searches → Property page)
- Time spent on property pages
- Booking value (average $ per booking)
- Search abandonment rate

GUARDRAIL:
- Host satisfaction (messages responded to)
- Guest satisfaction (reviews)
- Revenue per search
- Search latency (algorithm must be fast)
```

**Step 3: Sample Size**
```
Inputs:
- Baseline conversion: 2.5%
- MDE: 0.125pp (5% relative = 0.125pp absolute)
- α = 0.05, power = 80%

Calculation:
n = 2 × (1.96 + 0.84)² × 0.025 × 0.975 / (0.00125)²
n ≈ 242,000 per group

With 1M daily searches → ~0.5 day to reach sample
Decision: Run for 14 days (2 weeks) to account for weekly patterns
```

**Step 4: Randomization**
```
Unit: User ID (logged-in users)

For logged-out users: Session ID

Method: Hash(user_id + "search_algo_v2") % 100
- 0-49 → Control (current algorithm)
- 50-99 → Treatment (ML algorithm)

Validation:
- Check group sizes are ~50/50 daily
- Monitor distribution of user characteristics
```

**Step 5: Duration**
```
Duration: 14 days

Reasoning:
- Reach 14M searches (7M per group)
- Cover 2 full weeks (weekend/weekday balance)
- Allow for algorithm to learn/optimize
- Sufficient for secondary metrics (reviews take time)

Early stopping rule:
- Only if booking rate drops >20% (critical bug)
- Requires director approval
```

**Step 6: Confounds to Control**
```
CONTROLS:
1. Stratify by:
   - User segment (new vs. returning)
   - Search type (city vs. specific dates)
   
2. Exclude:
   - Bot traffic
   - Employee searches
   - Searches during outages

3. Monitor:
   - Search latency (ensure ML model isn't slower)
   - Error rates (ensure algorithm doesn't crash)
   - Property availability (external factor)
```

**Step 7: Segmentation**
```
PRE-DEFINED SEGMENTS:

1. By user type:
   - First-time searchers
   - Returning users
   - Power users (5+ bookings/year)

2. By search characteristics:
   - Flexible dates vs. specific dates
   - High price range (>$200/night) vs. low
   - Long stays (7+ nights) vs. short

3. By geography:
   - Domestic vs. international searches
   - Top 10 cities vs. other

HYPOTHESIS:
- Power users may benefit most (clear preferences)
- Flexible searches may see bigger lift (more to optimize)
```

**Step 8: Documentation**
```
DECISION CRITERIA:

SHIP:
- Booking conversion +3% or more, p < 0.05
- No guardrail metric degrades >2%
- Search latency increase <50ms
- All segments show positive or neutral impact

ITERATE:
- +1-3% booking conversion
- Some segments show degradation
- Need to tune algorithm

KILL:
- Negative or flat booking conversion
- Guardrail metrics degrade significantly
- Critical technical issues
```

## Interview Question Examples

### Question 1: "Design an A/B test for a new feature"

**Strong Answer Structure:**
1. Clarify the feature and business goal (2 min)
2. Define hypothesis with specific metric and magnitude (1 min)
3. Choose primary, secondary, and guardrail metrics (2 min)
4. Calculate sample size (show formula and work) (2 min)
5. Discuss randomization and duration (2 min)
6. Mention potential confounds and how to control them (1 min)

### Question 2: Sample Size Calculation

"You want to test a new checkout flow. Current conversion is 8%, you want to detect a 1pp increase. How many users do you need?"

**Answer:**
```
Given:
- p = 0.08 (baseline)
- MDE = 0.01 (1pp)
- α = 0.05, power = 0.80

n = 2 × (1.96 + 0.84)² × 0.08 × 0.92 / (0.01)²
n = 2 × 7.84 × 0.0736 / 0.0001
n = 1.154 / 0.0001
n ≈ 11,540 per group

Total: ~23,000 users needed
```

### Question 3: Test Duration

"You calculated you need 10,000 users per group. You have 5,000 DAU. How long should you run the test?"

**Answer:**
```
Minimum duration:
20,000 users / 5,000 DAU = 4 days

But I'd run for 14 days because:
1. Need full weeks to balance weekday/weekend effects
2. 4 days isn't enough for novelty effects to stabilize
3. Want statistical confidence across all user segments
4. Need time for secondary metrics to materialize

If we needed results faster:
- Increase % of traffic in experiment (100% vs. 50%)
- Would halve the duration to 7 days
- Trade-off: Higher risk if experiment has issues
```

## Key Takeaways

1. **Start with a specific, testable hypothesis**: Vague hypotheses lead to ambiguous results

2. **Choose the right metrics**: Primary (decision), Secondary (context), Guardrail (safety)

3. **Calculate sample size properly**: Don't under-power your experiments

4. **Randomize correctly**: User-level, deterministic, validated

5. **Run long enough**: Full weeks, account for cycles, watch for novelty effects

6. **Document everything**: Design doc prevents p-hacking and hindsight bias

7. **Pre-define segments**: Prevents cherry-picking results post-hoc

8. **Balance speed and rigor**: Fast iteration is good, but not at the cost of invalid results

## Common Pitfalls

❌ **Peeking at results early** → Increases false positive rate

❌ **Not running full weeks** → Confounds day-of-week with treatment

❌ **Ignoring novelty effects** → Short-term lift disappears

❌ **Testing too many things** → Can't tell what caused the change

❌ **Choosing wrong randomization unit** → Biased estimates

❌ **Stopping when significant** → Regression to mean

❌ **Post-hoc segmentation** → Cherry-picking leads to false discoveries

## Additional Resources

**Calculators:**
- Evan Miller's A/B Testing Tools
- Optimizely Sample Size Calculator
- SurveyMonkey A/B Test Calculator

**Books:**
- "Trustworthy Online Controlled Experiments" by Kohavi, Tang, Xu
- "A/B Testing: The Most Powerful Way to Turn Clicks Into Customers" by Siroker

**Online Courses:**
- Udacity A/B Testing Course
- Coursera Design of Experiments

**Tools:**
- Optimizely, VWO, LaunchDarkly (commercial)
- GrowthBook, Unleash (open source)

Master A/B test design, and you'll be able to rigorously validate any product change with confidence.
