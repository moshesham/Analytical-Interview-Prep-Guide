# A/B Testing Analysis

## Overview

After running an A/B test, proper analysis is critical to making the right decision. This is where statistics meets business judgment - you need to:
- Validate data quality and test integrity
- Apply appropriate statistical tests
- Interpret results correctly (avoiding common pitfalls)
- Make actionable recommendations

In interviews, you'll be asked to:
- Analyze A/B test results and make recommendations
- Interpret p-values, confidence intervals, and effect sizes
- Identify issues with test execution or analysis
- Explain trade-offs in decision-making

## The 6-Step Analysis Framework

### Step 1: Validate Data Quality and Test Integrity

**Before analyzing results, ensure the experiment ran correctly.**

**Checks to Perform:**

**A. Sample Size Validation**
```
Question: Did we reach our required sample size?

Example:
- Planned: 10,000 per group
- Actual Control: 9,850
- Actual Treatment: 9,920

Status: ✅ Close enough (within 5%)

Red flag: If actual sample is <80% of planned
```

**B. Sample Ratio Mismatch (SRM)**
```
Expected: 50/50 split
Actual: Should be within ±2% due to random variation

Example:
- Total users: 20,000
- Control: 9,500 (47.5%)
- Treatment: 10,500 (52.5%)

Chi-square test for equal proportions:
χ² = (9500-10000)²/10000 + (10500-10000)²/10000
χ² = 250/10000 + 250/10000 = 0.05
p-value > 0.05 → No SRM ✅

Red flag: If ratio is significantly different (p < 0.001)
Indicates: Randomization bug, tracking issue, or bot traffic
```

**C. Baseline Metric Check (A/A Test)**
```
Question: Do control and treatment groups look similar pre-treatment?

Check:
- User demographics (age, location, platform)
- Historical behavior (past engagement, purchases)
- Should NOT be statistically different

Example:
Metric            | Control | Treatment | p-value
------------------|---------|-----------|--------
Avg Age           | 32.5    | 32.3      | 0.65 ✅
% Mobile          | 68%     | 67%       | 0.53 ✅
Avg Sessions/Week | 4.2     | 6.8       | 0.001 ❌

Red flag: Treatment group was more engaged to begin with!
This invalidates the experiment - groups weren't comparable.
```

**D. Timeline Validation**
```
Check: Did the experiment run for the planned duration?
- Start date correct?
- End date correct?
- No gaps in data collection?
- No overlapping experiments that could interfere?

Visualize daily metric over time:
Day  | Control Conv% | Treatment Conv%
-----|---------------|----------------
1    | 5.2%          | 5.1%
2    | 5.3%          | 5.8%
3    | 5.1%          | 5.9%
...
14   | 5.2%          | 6.0%

Red flag: Large day-to-day swings or suspicious patterns
```

### Step 2: Calculate Statistical Significance

**Choose the appropriate statistical test based on your metric type.**

**A. For Proportions (e.g., Conversion Rate, CTR)**

**Two-Sample Z-Test for Proportions:**

```
Test Statistic:
Z = (p₁ - p₂) / SE

Where:
- p₁ = treatment conversion rate
- p₂ = control conversion rate
- SE = √[p(1-p) × (1/n₁ + 1/n₂)]
- p = pooled proportion = (x₁ + x₂) / (n₁ + n₂)

Example:
Control:  800 conversions / 10,000 users = 8.0%
Treatment: 920 conversions / 10,000 users = 9.2%

Calculation:
p = (800 + 920) / 20,000 = 0.086
SE = √[0.086 × 0.914 × (1/10000 + 1/10000)]
SE = √[0.0786 × 0.0002] = 0.00396

Z = (0.092 - 0.080) / 0.00396 = 3.03

p-value = 2 × P(Z > 3.03) = 0.0024

Conclusion: p < 0.05 → Statistically significant! ✅
```

**Confidence Interval for the Difference:**
```
95% CI = (p₁ - p₂) ± 1.96 × SE
      = (0.092 - 0.080) ± 1.96 × 0.00396
      = 0.012 ± 0.0078
      = [0.0042, 0.0198]
      = [0.42pp, 1.98pp]

Interpretation: We're 95% confident the true lift is between 0.42pp and 1.98pp
```

**B. For Continuous Metrics (e.g., Revenue, Session Duration)**

**Two-Sample T-Test:**

```
Test Statistic:
t = (x̄₁ - x̄₂) / SE

Where:
- x̄₁, x̄₂ = sample means
- SE = √(s₁²/n₁ + s₂²/n₂)
- s₁, s₂ = sample standard deviations

Example:
Control:  Avg revenue = $45.20, SD = $12.50, n = 10,000
Treatment: Avg revenue = $47.80, SD = $13.20, n = 10,000

SE = √((12.50²/10000) + (13.20²/10000))
SE = √(0.0156 + 0.0174) = 0.182

t = (47.80 - 45.20) / 0.182 = 14.29

With df ≈ 10,000, p-value < 0.001

Conclusion: Highly significant! ✅
```

**C. For Multiple Metrics (Bonferroni Correction)**

```
When testing N metrics, adjust significance level:

α_adjusted = α / N

Example: Testing 5 metrics, want overall α = 0.05
- Use α = 0.05 / 5 = 0.01 for each individual test

Why: Prevents false discoveries from multiple comparisons
```

### Step 3: Calculate Effect Size and Confidence Intervals

**Statistical significance ≠ Practical significance**

**A. Relative Lift (Percent Change):**
```
Relative Lift = (Treatment - Control) / Control × 100%

Example:
Control: 8.0% conversion
Treatment: 9.2% conversion

Relative Lift = (9.2 - 8.0) / 8.0 × 100% = 15%

Interpretation: 15% relative improvement
```

**B. Absolute Lift (Percentage Points):**
```
Absolute Lift = Treatment - Control

Example: 9.2% - 8.0% = 1.2pp (percentage points)

This matters more for business impact:
- 10,000 users × 1.2pp = 120 additional conversions
```

**C. Confidence Intervals Tell the Full Story:**
```
Example Results:

Metric A:
- Lift: +10%
- 95% CI: [+8%, +12%]
- Interpretation: Very precise, clearly positive ✅

Metric B:
- Lift: +10%
- 95% CI: [-5%, +25%]
- Interpretation: Wide CI, unreliable estimate ⚠️

Metric C:
- Lift: +2%
- 95% CI: [+1.5%, +2.5%]
- Interpretation: Small but precise, might not be worth it

Always report both point estimate AND confidence interval!
```

**D. Practical Significance Thresholds:**
```
Ask: Is the effect size large enough to matter?

Example: Checkout flow optimization
- Statistically significant: p = 0.03 ✅
- Effect size: +0.5% conversion
- Business value: 0.5% × 100,000 users × $50 = $25,000/month
- Development cost: 1 eng-month = $20,000

ROI: $25K/month return on $20K investment → Ship it! ✅

Counter-example:
- Effect size: +0.1% conversion
- Business value: $5,000/month
- Development cost: $20,000
- ROI: 4 months to break even → Maybe not worth it
```

### Step 4: Segment Analysis

**Examine results across key user segments.**

**A. Pre-defined Segments (Low Risk):**
```
Analysis you planned before running the test.

Example: Mobile vs. Desktop

Overall:
- Treatment: +10% conversion (p = 0.001) ✅

By Platform:
Platform | Control | Treatment | Lift   | p-value
---------|---------|-----------|--------|--------
Mobile   | 5.0%    | 6.5%      | +30%   | <0.001 ✅
Desktop  | 10.0%   | 9.5%      | -5%    | 0.12 ❌

Insight: Feature works great on mobile, neutral/negative on desktop
Decision: Ship mobile version, investigate desktop experience
```

**B. Post-hoc Segments (High Risk):**
```
Analysis you didn't plan - prone to false discoveries.

Example: Finding that treatment works for:
- Users aged 25-30 in California using Chrome on Tuesdays

This is likely spurious! Multiple testing without correction.

Best practice:
- Treat post-hoc findings as hypotheses for future tests
- Don't make decisions based on unplanned segments
- If compelling, run a new experiment targeting that segment
```

**C. Simpson's Paradox:**
```
Overall effect can be opposite of segment effects!

Example:
Overall: Treatment converts better (10% vs. 8%)

But by user type:
New Users:     Control 15% > Treatment 12%
Returning Users: Control 5% > Treatment 4%

How? Treatment group had more new users (higher baseline conversion).

Lesson: Always segment by important user characteristics!
```

### Step 5: Check Guardrail Metrics

**Ensure improvements don't come at a cost.**

**Framework:**
```
Primary metric ✅ + All guardrails ✅ → Ship
Primary metric ✅ + Some guardrails ⚠️ → Investigate trade-offs
Primary metric ❌ → Don't ship (usually)
```

**Example: E-commerce Search Redesign**
```
PRIMARY METRIC:
✅ Click-through rate: +15% (p < 0.001)

SECONDARY METRICS:
✅ Add-to-cart rate: +8% (p = 0.02)
✅ Time on page: +12% (p = 0.005)

GUARDRAIL METRICS:
⚠️ Search latency: +150ms (p < 0.001)
⚠️ Page load time: +0.5s (p < 0.001)

DECISION ANALYSIS:
Pros:
- Strong improvement in engagement and conversions
- More time on page = better product discovery

Cons:
- Slower performance could frustrate users
- Latency increase might hurt mobile users more

Next Steps:
1. Segment by connection speed
2. Optimize algorithm for performance
3. Run follow-up test with optimized version
4. Consider hybrid: new algo for WiFi, old for cellular
```

### Step 6: Make a Recommendation

**Structure your decision clearly.**

**Decision Framework:**

**Clear Win:**
```
Conditions:
- Primary metric significantly improves (p < 0.05)
- Effect size is practically meaningful (> MDE)
- All guardrails are neutral or positive
- Results consistent across key segments

Recommendation: SHIP ✅

Example:
"The new onboarding flow increases activation rate by 12% 
(95% CI: [8%, 16%]), with no negative impact on retention or 
satisfaction. This translates to 5,000 additional activated users 
per month. Recommend full rollout."
```

**Clear Loss:**
```
Conditions:
- Primary metric flat or negative
- Or critical guardrail degraded significantly

Recommendation: DON'T SHIP ❌

Example:
"The redesigned checkout flow shows no significant improvement in 
conversion (+0.5%, p = 0.42) but increases cart abandonment by 8% 
(p < 0.001). Recommend not shipping and investigating why users 
abandon more frequently."
```

**Mixed Results:**
```
Conditions:
- Primary metric improves but effect is small
- Or some segments win, others lose
- Or guardrails show concerning trends

Recommendation: ITERATE 🔄

Example:
"Purchase conversion increased 3% (p = 0.03), but session duration 
decreased 10% (p < 0.001). Users complete purchases faster but 
browse less. Segmentation shows mobile users love it (+8% conversion), 
desktop users hate it (-2%). Recommend shipping mobile-only version 
while redesigning desktop experience."
```

## Complete Analysis Example

### Scenario: YouTube - Testing New Video Recommendation Algorithm

**Test Setup:**
- Hypothesis: ML-based recommendations will increase watch time by 10%
- Primary metric: Average watch time per user per day
- Duration: 14 days
- Sample: 20,000 users per group

**Step 1: Data Quality Checks**
```
✅ Sample Size: 
   - Control: 19,985 users
   - Treatment: 20,024 users
   - Status: Reached target

✅ Sample Ratio:
   - Expected: 50/50
   - Actual: 49.98% / 50.02%
   - Chi-square p-value = 0.94
   - Status: No SRM

✅ Baseline Metrics:
   Pre-experiment average watch time:
   - Control: 42.3 min/day
   - Treatment: 42.1 min/day
   - t-test p-value = 0.75
   - Status: Groups balanced

✅ Timeline:
   - Ran full 14 days
   - No data gaps
   - Status: Clean run
```

**Step 2: Statistical Tests**
```
PRIMARY METRIC: Watch Time per User per Day

Control:  Mean = 42.5 min, SD = 18.2, n = 19,985
Treatment: Mean = 46.8 min, SD = 19.1, n = 20,024

t-test:
SE = √((18.2²/19985) + (19.1²/20024)) = 0.192
t = (46.8 - 42.5) / 0.192 = 22.4
p-value < 0.001

Result: Highly significant! ✅
```

**Step 3: Effect Size**
```
Absolute Lift: 46.8 - 42.5 = 4.3 minutes/day
Relative Lift: 4.3 / 42.5 × 100% = 10.1%

95% Confidence Interval:
4.3 ± 1.96 × 0.192 = [3.92, 4.68] minutes

Interpretation:
- 10.1% improvement (met hypothesis!)
- Adds ~4 minutes per user per day
- Very tight confidence interval

Business Impact:
- 1 billion users × 4.3 min/day × 365 days = 1.57 trillion additional minutes/year
- At ~$0.10 CPM revenue → $15.7 billion annual revenue impact!
```

**Step 4: Segmentation**
```
By User Type:
Segment         | Control | Treatment | Lift  | p-value
----------------|---------|-----------|-------|--------
New users       | 25 min  | 32 min    | +28%  | <0.001 ✅
Casual users    | 35 min  | 39 min    | +11%  | <0.001 ✅
Power users     | 90 min  | 93 min    | +3%   | 0.08 ⚠️

Insight: Biggest impact on new and casual users, minimal on power users
(Power users already watch a lot, harder to increase further)

By Content Type Preference:
Type            | Control | Treatment | Lift
----------------|---------|-----------|------
Music videos    | 40 min  | 51 min    | +28% ✅
Gaming          | 45 min  | 50 min    | +11% ✅
Vlogs           | 38 min  | 41 min    | +8%  ✅
News            | 35 min  | 36 min    | +3%  ⚠️

Insight: Entertainment content sees bigger lift than informational

By Platform:
Platform  | Control | Treatment | Lift
----------|---------|-----------|-----
Mobile    | 38 min  | 43 min    | +13% ✅
Desktop   | 48 min  | 52 min    | +8%  ✅
Smart TV  | 85 min  | 88 min    | +4%  ✅

Insight: Works across all platforms, strongest on mobile
```

**Step 5: Guardrail Metrics**
```
ENGAGEMENT METRICS:
✅ Videos watched per day: +8% (p < 0.001)
✅ Video completion rate: 72% → 74% (p = 0.003)
✅ Channel subscriptions: +5% (p = 0.02)

SATISFACTION METRICS:
✅ Thumbs up rate: 8.2% → 8.5% (p = 0.04)
✅ Share rate: +12% (p = 0.001)
⚠️ Thumbs down rate: 0.8% → 1.0% (p = 0.03)

BUSINESS METRICS:
✅ Ad impressions per user: +9% (p < 0.001)
✅ Revenue per user: +11% (p < 0.001)
✅ Creator satisfaction (survey): No change (p = 0.65)

TECHNICAL METRICS:
⚠️ API latency: 45ms → 85ms (p < 0.001)
⚠️ CPU usage: +15% (p < 0.001)

Analysis:
- Strong improvements in engagement and revenue
- Slight increase in negative feedback (1% vs. 0.8%)
- Performance concerns need addressing
```

**Step 6: Recommendation**
```
DECISION: Ship with Performance Optimization ✅

RATIONALE:
1. Strong primary metric improvement (10% watch time)
2. Massive business impact ($15B+ annually)
3. Positive across all key segments
4. Most guardrails positive or neutral
5. Performance issues solvable with engineering effort

CONCERNS:
1. Slight increase in thumbs down (0.8% → 1.0%)
   → Hypothesis: Recommending more content = more opportunities for dislikes
   → Acceptable given overall positive signals
   
2. API latency increase (45ms → 85ms)
   → Must optimize before launch
   → Target: Get to <60ms (user-imperceptible)
   
3. Limited improvement for power users
   → Future opportunity: Specialized algo for power users

ACTION PLAN:
1. Week 1-2: Performance optimization sprint
2. Week 3: Re-run test with optimized version
3. Week 4: If performance fixed, begin 10% rollout
4. Week 5-8: Ramp to 100% while monitoring metrics
5. Month 2: Start design work on power user algorithm

EXPECTED OUTCOME:
- Full rollout by end of Q2
- Sustained 10% watch time improvement
- $15B+ annual revenue impact
- Sets foundation for personalization improvements
```

## Common Analysis Pitfalls

### ❌ Pitfall 1: P-Hacking
```
Bad Practice:
- Peek at results daily
- Stop test when p < 0.05
- Try different metrics until one is significant
- Segment users in many ways to find a "winner"

Why it's bad: Inflates false positive rate from 5% to 30%+

Good Practice:
- Pre-define test duration and stick to it
- Pre-define primary metric
- Pre-register analysis plan
- Report all metrics, not just significant ones
```

### ❌ Pitfall 2: Ignoring Practical Significance
```
Bad: "p = 0.001, so we should ship!"

Example:
- Conversion: 10.00% → 10.05%
- p-value: 0.001 (significant)
- Business impact: +0.05pp × 100K users × $50 = $2,500/month
- Development cost: 2 engineer-months = $40,000
- ROI: 16 months to break even

Good: "Statistically significant but not worth the engineering cost"
```

### ❌ Pitfall 3: Misinterpreting P-Values
```
❌ Wrong: "p = 0.03 means there's a 97% chance the treatment is better"

✅ Right: "p = 0.03 means if there were truly no difference, we'd see 
          results this extreme 3% of the time due to random chance"

❌ Wrong: "p = 0.06, so there's no effect"

✅ Right: "p = 0.06, so we can't reject the null hypothesis at α = 0.05, 
          but there might still be a small effect we didn't detect"
```

### ❌ Pitfall 4: Novelty Effect
```
Week 1: Treatment wins! +20% engagement
Week 2: Treatment still up, +12%
Week 3: Treatment at +5%
Week 4: No difference

Explanation: Users clicked because it was new/different, not better

Solution:
- Run tests for 2-4 weeks
- Plot metrics over time
- Look for sustained improvements
```

### ❌ Pitfall 5: Survivor Bias
```
Bad Analysis:
"Of users who completed checkout, treatment had higher satisfaction"

Problem: Treatment might have higher abandonment rate
- Only analyzing survivors (completers)
- Missing users who gave up

Good Analysis:
- Analyze all users (intention-to-treat)
- Separately analyze abandonment rate
- Look at satisfaction among all users, not just completers
```

## Interview Question Examples

### Question 1: Interpreting Results

**Question:** "We ran an A/B test. Control converted at 5%, treatment at 5.5%, p = 0.08. What do you conclude?"

**Strong Answer:**
```
"With p = 0.08, we fail to reject the null hypothesis at α = 0.05. 
However, I wouldn't conclude there's definitely no effect. A few considerations:

1. What was the minimum detectable effect (MDE)?
   - If MDE was 1pp, we weren't powered to detect 0.5pp
   
2. What's the confidence interval?
   - If CI is [-0.1pp, +1.1pp], there could be a positive effect
   
3. What's the business context?
   - If this is a critical feature with minimal cost, might be worth shipping
   - If expensive to build, probably not worth it

4. Could we re-run with more power?
   - Larger sample size might detect the 0.5pp effect

I'd recommend either:
A) Re-run with 4x sample size to detect 0.5pp effect, or
B) If that's not feasible, don't ship and focus on higher-impact features"
```

### Question 2: Metric Conflicts

**Question:** "Primary metric (conversion) is up 5% (p = 0.01), but revenue per user is down 3% (p = 0.04). What do you do?"

**Strong Answer:**
```
"This is a classic trade-off scenario. More conversions but lower value suggests:

Hypotheses:
1. Treatment attracting lower-value customers
2. Treatment increasing small purchases, fewer large purchases
3. Treatment causing users to use discount codes more

Analysis I'd do:
1. Segment by purchase value: 
   - Is treatment winning for low-value, losing for high-value?
   
2. Check average order value:
   - Control: 1000 users × $50 = $50K
   - Treatment: 1050 users × $47.60 = $50K
   - Same total revenue, just distributed differently

3. Look at customer lifetime value:
   - Are these lower-value customers more likely to return?
   - If yes, might still be net positive long-term

Decision Framework:
- If LTV is better in treatment → Ship (more customers worth slightly less each)
- If LTV is worse → Don't ship (attracting wrong customers)
- If LTV is same → Neutral, might ship for volume growth

I'd need to see the full picture before recommending, but initial concern 
is that we're optimizing for volume over value."
```

### Question 3: Unexpected Results

**Question:** "Test ran for 2 weeks. Week 1: treatment +10%. Week 2: treatment -5%. What happened?"

**Strong Answer:**
```
"The drop from Week 1 to Week 2 suggests a few possibilities:

1. Novelty Effect:
   - Users excited by new design in Week 1
   - Excitement wears off, revert to baseline or worse
   - Classic A/B test pitfall

2. User Learning Curve:
   - New design confusing at first, users click more randomly
   - Once they understand it, engagement drops because it's actually worse
   
3. Selection Bias:
   - Power users saw it first in Week 1 (positive)
   - Casual users saw it in Week 2 (negative)
   - Indicates randomization issue

4. External Event:
   - Something changed in Week 2 (holiday, competitor launch, outage)
   - Check if control also dropped in Week 2

Analysis to do:
1. Plot both control and treatment daily
2. Check if control was stable across both weeks
3. Analyze Week 1 users who returned in Week 2 (novelty test)
4. Check randomization logs for issues

Recommendation:
- If novelty effect: Don't ship
- If external event: Extend test another 2 weeks
- If randomization issue: Invalidate test, re-run

Key lesson: This is why we run tests for 2-4 weeks, not just 1 week!"
```

## Key Takeaways

1. **Validate first, analyze second**: Bad data → bad decisions

2. **Statistical significance ≠ Practical significance**: Always check effect size and business impact

3. **Report confidence intervals**: Point estimates alone are misleading

4. **Check guardrails**: Don't optimize one metric at expense of others

5. **Segment wisely**: Pre-defined segments good, post-hoc fishing bad

6. **Watch for novelty effects**: Run long enough for behavior to stabilize

7. **Think in trade-offs**: Rarely is one variant better in all ways

8. **Document everything**: Future you will thank present you

## Practice Exercises

### Exercise 1: Calculate Statistical Significance
Given:
- Control: 500 conversions / 10,000 users
- Treatment: 580 conversions / 10,000 users

Calculate:
1. Conversion rates
2. Z-statistic
3. P-value
4. 95% confidence interval for the difference
5. Business impact (assume $50 per conversion)

### Exercise 2: Interpret Results
You ran a test:
- Primary metric: +5% (p = 0.03)
- Guardrail A: -2% (p = 0.15)
- Guardrail B: -8% (p = 0.001)

What's your recommendation and why?

### Exercise 3: Debug a Failed Test
- Planned sample: 20,000 per group
- Actual: Control 15,000, Treatment 25,000
- Treatment shows +15% improvement (p < 0.001)

What's wrong? Should you trust the results?

## Additional Resources

**Statistical Tests:**
- Khan Academy: Hypothesis Testing
- StatQuest: P-values and confidence intervals
- Seeing Theory: Visual introduction to statistics

**Tools:**
- Online A/B test calculators
- Python: scipy.stats, statsmodels
- R: t.test, prop.test

**Books:**
- "Trustworthy Online Controlled Experiments" (Kohavi et al.)
- "Statistical Methods for A/B Testing"

**Practice:**
- Work through real A/B test examples from Kaggle
- Analyze published experiment results from tech blogs
- Run simulations to build intuition

Master A/B test analysis and you'll be able to make confident, data-driven decisions that drive real business impact.
