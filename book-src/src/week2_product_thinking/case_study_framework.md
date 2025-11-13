# Product Case Study Framework

## Overview

Product case studies are the most common type of interview question for product analyst roles. They test your ability to:
- Think systematically about product problems
- Apply analytical frameworks appropriately
- Make data-driven recommendations
- Communicate your thinking clearly

Unlike pure SQL or statistics questions, case studies assess your product intuition, business acumen, and structured problem-solving approach.

**Common Case Study Types:**
1. **Metric Investigation**: "Metric X dropped by Y%. How would you investigate?"
2. **Feature Evaluation**: "Should we build feature X?"
3. **Product Improvement**: "How would you improve product X?"
4. **Root Cause Analysis**: "Why did X happen?"
5. **Experiment Design**: "How would you test hypothesis X?"

## The 5-Step Framework

### Step 1: Clarify and Define (2-3 minutes)

**Never start analyzing immediately.** Spend time understanding the problem deeply. This demonstrates thoughtfulness and prevents you from solving the wrong problem.

**Key Questions to Ask:**

**For Metric Changes:**
- How is the metric defined precisely? (e.g., "engagement" could mean many things)
- What's the timeframe? (daily, weekly, monthly)
- What's the magnitude? (absolute vs. relative change)
- Is this significant? (statistical significance, business significance)
- What's the baseline and current value?

**For Product Decisions:**
- What are the business goals? (revenue, growth, retention?)
- Who are the target users?
- What's the success criteria?
- What are the constraints? (technical, time, resources)
- What's the competitive landscape?

**Example - "DAU dropped 5%":**
```
Clarifying Questions:
Q: "How do we define DAU? Is it app opens or a specific action?"
A: "Any user who opens the app and performs at least one action"

Q: "Over what time period did this 5% drop occur?"
A: "Week-over-week, started last Monday"

Q: "What's the baseline? 5% of what number?"
A: "From 10M DAU to 9.5M DAU"

Q: "Has this been adjusted for seasonality or is this unusual?"
A: "This is unusual for this time of year"

Q: "Are there any known changes - product releases, outages, etc.?"
A: "We released a redesign of the home screen last Monday"
```

**Pro Tips:**
- Write down the clarifying information (helps you remember and shows organization)
- If the interviewer doesn't have specific answers, state your assumptions clearly
- Spend 10-15% of your total time on clarification

### Step 2: Structure Your Approach (2-3 minutes)

**Create a roadmap before diving in.** This shows the interviewer you think systematically.

**The MECE Principle (Mutually Exclusive, Collectively Exhaustive):**
Break down the problem so categories don't overlap and you've covered all possibilities.

**Common Structures:**

**A. For Metric Investigations (Internal vs. External):**
```
1. Data Quality Issues
   - Tracking/measurement bugs
   - Definition changes
   - Reporting errors

2. Internal Factors
   - Product changes (features, UX)
   - Technical issues (bugs, performance)
   - Operational changes (policy, moderation)

3. External Factors
   - User behavior shifts
   - Competitive actions
   - Seasonality/holidays
   - Market/macro trends

4. User Segment Variations
   - Geography
   - Platform (iOS, Android, web)
   - User cohorts (new vs. old users)
```

**B. For Feature Decisions (Goals, Users, Costs, Benefits):**
```
1. User Problem & Need
   - What problem does this solve?
   - How big is the problem?
   - Who has this problem?

2. Solution Evaluation
   - Does the feature solve the problem?
   - Are there alternative solutions?
   - What's unique about our solution?

3. Business Impact
   - Expected benefit (revenue, engagement, retention)
   - Estimated cost (development, maintenance, opportunity cost)
   - Strategic value (competitive, positioning)

4. Risks & Trade-offs
   - Technical risks
   - User experience risks
   - Opportunity cost
```

**C. For Root Cause Analysis (The 5 W's Framework):**
```
WHEN:
- Exact timing of the issue
- Duration (gradual vs. sudden)
- Time-based patterns

WHERE:
- Geographic variations
- Platform differences (mobile, web)
- User segments affected

WHO:
- Which user segments?
- New vs. returning users
- Power users vs. casual users

WHAT:
- Which specific features/flows?
- What metrics are affected?
- What's the magnitude?

WHY:
- Correlations with other events
- Potential causal factors
- Hypotheses to test
```

**Example - Structuring Instagram Reels Investigation:**
```
"I'd like to structure my investigation into four areas:

1. First, validate the data - ensure this is a real issue, not a measurement problem

2. Second, segment the data to see WHERE the drop is concentrated:
   - User segments (new vs. returning, demographics)
   - Platform (iOS, Android, web)
   - Geography

3. Third, investigate internal factors:
   - Recent product changes
   - Technical issues or bugs
   - Algorithm or ranking changes

4. Fourth, consider external factors:
   - Competitor activity (TikTok, YouTube Shorts)
   - Content creator behavior
   - Seasonal or event-driven effects

I'll go through each systematically, and we can dive deeper where you'd like."
```

**Pro Tips:**
- State your structure out loud before diving in
- Draw it on paper/whiteboard if available
- Ask if the interviewer wants you to focus on specific areas
- Be ready to adjust if the interviewer redirects

### Step 3: Analyze and Generate Hypotheses (8-10 minutes)

**Work through your structure systematically, generating specific, testable hypotheses.**

**Hypothesis Quality:**
- ❌ Bad: "Maybe users don't like the new feature"
- ✅ Good: "Engagement dropped primarily among iOS users after the redesign, suggesting a platform-specific UX issue"

**Analysis Approach:**

**A. Segmentation Analysis:**
Break down metrics by different dimensions to find patterns.

```
Example - DAU Drop Analysis:

Overall: -5% (10M → 9.5M)

By Platform:
- iOS: -8% (6M → 5.5M) ⚠️ Higher impact
- Android: -2% (3.5M → 3.4M)
- Web: -1% (0.5M → 0.495M)

By User Type:
- New users (<30 days): -15% ⚠️ Significant
- Returning users: -2%
- Power users (top 10%): -1%

By Geography:
- US: -6%
- Europe: -4%
- Asia: -3%

By Feature Usage:
- Users who engaged with new home screen: -12% ⚠️ Correlation
- Users who didn't see new home screen: -1%

Hypothesis: The new home screen redesign is causing new iOS users to churn before establishing habits.
```

**B. Funnel Analysis:**
Identify where users drop off in key flows.

```
Example - Onboarding Funnel Analysis:

Old Version:
Download → Open App → Create Account → Complete Profile → First Post
100%    → 90%      → 60%            → 50%             → 30%

New Version (with redesign):
Download → Open App → Create Account → Complete Profile → First Post
100%    → 90%      → 55% ⚠️ DROP   → 45%             → 25%

Finding: 5pp drop at account creation step
Hypothesis: New account creation flow is more complex or has a bug
```

**C. Cohort Analysis:**
Compare behavior across user groups over time.

```
Example - Retention by Signup Cohort:

Cohort        | Week 1 | Week 2 | Week 4 | Week 8
--------------|--------|--------|--------|--------
Jan 2024      | 60%    | 45%    | 35%    | 30%
Feb 2024      | 55%    | 42%    | 33%    | 28%
Mar 2024      | 50% ⚠️ | 38%    | ?      | ?

Finding: Recent cohorts showing weaker retention from Week 1
Hypothesis: Changes to onboarding or early experience affecting new user retention
```

**D. Time-Series Analysis:**
Look for patterns over time.

```
Example - Engagement Over Time:

Week | Mon  | Tue  | Wed  | Thu  | Fri  | Sat  | Sun
-----|------|------|------|------|------|------|------
-4   | 100  | 102  | 101  | 103  | 98   | 95   | 92
-3   | 101  | 103  | 102  | 102  | 99   | 96   | 93
-2   | 100  | 102  | 101  | 104  | 97   | 95   | 91
-1   | 102  | 103  | 103  | 102  | 98   | 96   | 93
 0   | 98 ⚠️| 95   | 93   | 91   | 88   | 85   | 82

Finding: Sudden drop started Monday of Week 0, persistent through the week
Hypothesis: Something changed Monday - deploy, external event, or competitor launch
```

**Correlation vs. Causation:**
Always be clear about what you've proven vs. what you're hypothesizing.

```
✅ Good: "We observe a correlation between the new feature and engagement drop, 
         but we need to validate causation through further analysis"

❌ Bad: "The new feature caused the engagement drop"
```

**Prioritizing Hypotheses:**
Use an impact/likelihood matrix:

```
High Likelihood, High Impact: ⚠️ Investigate first
- iOS-specific bug in new home screen
- Account creation flow broken on mobile

High Likelihood, Low Impact:
- Minor seasonal effect
- Small A/B test running

Low Likelihood, High Impact:
- Major competitor launched killer feature
- Privacy policy change affecting tracking

Low Likelihood, Low Impact: ⛔ Deprioritize
- Random variance
- Minor UX annoyance
```

### Step 4: Recommend Solutions (3-5 minutes)

**Propose specific, actionable solutions with clear trade-offs.**

**Solution Framework:**

**A. Immediate Actions (0-1 week):**
Quick fixes and validations

**B. Short-term Solutions (1-4 weeks):**
Tactical improvements

**C. Long-term Solutions (1-3 months):**
Strategic changes

**Example - Instagram Reels Case:**

```
Based on analysis showing new iOS users dropping off in the first session:

IMMEDIATE (This week):
1. Validate the bug hypothesis:
   - Review iOS app logs for errors
   - Check if specific iOS versions affected
   - A/B test: roll back home screen for 10% of new iOS users

2. Quick fixes if bug confirmed:
   - Emergency patch
   - Improve error handling
   - Add fallback to old experience

SHORT-TERM (Next month):
1. Improve new user onboarding for Reels:
   - Add contextual tooltips
   - Show example Reels first
   - Simplify creation flow

2. Re-engage churned users:
   - Push notification campaign
   - Email highlighting Reels content
   - Creator spotlight features

LONG-TERM (Next quarter):
1. Redesign Reels discovery:
   - Personalization improvements
   - Better for-you algorithm
   - Creator quality programs

2. Competitive features:
   - Advanced editing tools
   - Cross-platform sharing
   - Monetization for creators

Expected Impact:
- Immediate: +3pp recovery if bug fix
- Short-term: +2-3pp from better onboarding
- Long-term: +5pp from strategic improvements
Total: Return to baseline + 5-8% improvement
```

**Trade-off Analysis:**
Always acknowledge costs and risks.

```
Recommendation: Simplify account creation by allowing Google/Apple sign-in

PROS:
+ Reduces friction (3 taps vs. form fill)
+ Industry best practice
+ Likely +5-10pp conversion improvement

CONS:
- Development cost: 2 engineer-weeks
- Dependency on third-party auth
- Less direct user data collected
- Privacy implications

RISKS:
- Technical integration issues
- User confusion if auth fails
- May not solve root problem

MITIGATION:
- Pilot with 10% of users first
- Keep existing option available
- Monitor auth success rates closely
```

### Step 5: Communicate and Wrap Up (2-3 minutes)

**Summarize your analysis clearly and confidently.**

**The SCQA Format (Situation, Complication, Question, Answer):**

```
SITUATION: Instagram Reels DAU dropped 5% week-over-week

COMPLICATION: Drop concentrated in new iOS users, correlating with home screen redesign

QUESTION: What's causing this and how do we fix it?

ANSWER: 
1. Root cause: New home screen confuses first-time iOS users
2. Evidence: -15% new user engagement, -12% for redesign exposure
3. Solution: Quick rollback for new users + improved onboarding
4. Expected impact: +8pp recovery within 2 weeks
```

**Handling Follow-up Questions:**

**Common Follow-ups:**
- "How would you validate that hypothesis?"
- "What if you're wrong about the root cause?"
- "How would you prioritize these solutions?"
- "What metrics would you track to measure success?"

**Strong Response Pattern:**
1. Acknowledge the question
2. State your approach
3. Provide specific example
4. Tie back to business impact

**Example:**
```
Q: "How would you validate the iOS hypothesis?"

A: "I'd use three methods:

First, a quick A/B test: Roll back the redesign for 10% of new iOS users. 
If engagement recovers for this group but not the control, that's strong evidence.

Second, qualitative research: User interviews and session recordings to see 
where new iOS users get confused or stuck.

Third, platform comparison: If it's truly iOS-specific, we should see normal 
behavior on Android with the same redesign. We'd compare engagement patterns 
and identify differences.

I'd expect to have directional answers within 3-5 days from the A/B test, 
with qualitative insights confirming within a week."
```

## Complete Case Study Example

### Case: "YouTube video views dropped 10% last week. Investigate."

**Step 1: Clarify (2 min)**
```
Q: "How is a 'view' defined?"
A: "User watches at least 30 seconds or completes the video if shorter"

Q: "Is this overall views or per-user views?"
A: "Total platform views dropped 10%"

Q: "What's the time comparison?"
A: "Week-over-week, from 1B daily views to 900M"

Q: "Any known changes?"
A: "No major product changes, but TikTok did launch a new feature last week"

Noted: -10% (1B → 900M), WoW, no internal changes, possible external factor
```

**Step 2: Structure (2 min)**
```
"I'll investigate in four areas:

1. Data Quality - Rule out measurement issues
2. User Segmentation - Find where the drop concentrates
3. Internal Factors - Product, technical, operational
4. External Factors - Competition, seasonality, events

Let me start with segmentation to find the signal."
```

**Step 3: Analyze (8 min)**
```
SEGMENTATION ANALYSIS:

By Geography:
- US: -8% (stable timezone coverage)
- Europe: -9%
- Asia: -12% ⚠️ Highest impact
- Rest of world: -7%

By Content Type:
- Short-form (<1 min): -15% ⚠️ Significant
- Medium (1-10 min): -8%
- Long-form (>10 min): -5%

By User Type:
- Mobile users: -12% ⚠️
- Desktop users: -4%
- Smart TV: -3%

By User Age:
- Age 13-24: -15% ⚠️ Highest impact
- Age 25-34: -8%
- Age 35+: -5%

PATTERN IDENTIFIED:
Biggest drop in: Asia, young users, mobile, short-form content

HYPOTHESIS FORMATION:

Strong hypothesis: TikTok's new feature is pulling young mobile users, 
especially in Asia, away from YouTube Shorts

Supporting evidence:
- TikTok launched "Creator Fund Plus" incentivizing content creation
- Short-form content most affected (direct competition with Shorts)
- Young users most likely to try new platforms
- Mobile is primary TikTok usage platform
- Asia is TikTok's strongest market

Alternative hypotheses to test:
1. YouTube Shorts algorithm change affecting distribution
2. Technical issues with mobile video loading
3. Content creator exodus (check upload rates)
4. Seasonal effect (school holidays in Asia)
```

**Step 4: Recommend (4 min)**
```
IMMEDIATE ACTIONS (This week):

1. Validate competitive hypothesis:
   - Survey sample of churned users
   - Social listening for mentions of TikTok vs. YouTube
   - Cross-platform usage data (if available)

2. Quick engagement boosts:
   - Promote top Shorts creators on Home feed
   - Increase Shorts in recommendation algorithm
   - Push notifications for personalized Shorts

SHORT-TERM (Next month):

1. Creator incentives:
   - Expand Shorts Fund to match TikTok
   - Bonus payments for exclusive content
   - Better monetization for short-form

2. Product improvements:
   - Enhanced Shorts creation tools
   - Better discovery algorithm
   - Cross-promotion between Shorts and long-form

3. Targeted marketing:
   - Asia-focused campaigns
   - Young creator spotlights
   - Highlight YouTube advantages (discoverability, monetization)

LONG-TERM (Next quarter):

1. Strategic differentiation:
   - Leverage YouTube's strengths (music licensing, long-form integration)
   - Better creator tools than TikTok
   - Unique features (commerce, memberships)

2. Platform improvements:
   - Shorts Studio (advanced editing)
   - AI-powered creation tools
   - Community features

EXPECTED IMPACT:
- Immediate: +2-3pp from engagement tactics
- Short-term: +4-5pp from creator incentives
- Long-term: +5-7pp from product differentiation
- Recovery timeline: 4-6 weeks to baseline, 3 months to growth

RISKS & TRADE-OFFS:
- Cost: Creator incentives expensive ($50-100M annually)
- Opportunity cost: Resources from other initiatives
- May not match TikTok's viral dynamics
- Long-form creators might feel neglected

METRICS TO TRACK:
- Primary: Daily views by content type
- Secondary: Creator upload rates, new user signups
- Guardrail: Long-form content engagement, creator satisfaction
```

**Step 5: Summarize (1 min)**
```
"To summarize: YouTube views dropped 10% due to competitive pressure 
from TikTok, primarily affecting young mobile users in Asia watching 
short-form content.

I recommend a three-pronged approach: immediate engagement tactics, 
short-term creator incentives, and long-term product differentiation.

This should recover the baseline within 6 weeks and position us for 
growth, though it requires significant investment in creator programs.

The key metrics to track are views by content type and creator activity, 
with success defined as returning to growth trajectory within 3 months."
```

## Common Mistakes to Avoid

### ❌ Mistake 1: Jumping to Solutions Too Quickly
```
Bad: "Views dropped? We should improve the recommendation algorithm!"

Good: "Let me first understand where the drop is concentrated, 
      then we can identify root causes and appropriate solutions"
```

### ❌ Mistake 2: Not Being MECE in Structure
```
Bad: Analyzing "user issues, bugs, and iOS problems" (iOS is overlapping)

Good: "Internal factors (bugs, features) vs. External factors (competition, seasonality)"
```

### ❌ Mistake 3: Vague Hypotheses
```
Bad: "Maybe users don't like the product anymore"

Good: "New users in the 18-24 age group are churning 2x faster after 
      the onboarding redesign, suggesting a younger user UX issue"
```

### ❌ Mistake 4: Forgetting Trade-offs
```
Bad: "We should just build everything competitors have"

Good: "Adding feature X would cost 2 eng-months and might cannibalize 
      feature Y, but would address user need Z. Let's prioritize based on impact."
```

### ❌ Mistake 5: Not Grounding in Data
```
Bad: "I think users would like this feature"

Good: "Based on the user survey, 65% of power users requested this 
      feature, and similar features on competitor products show 40% adoption"
```

### ❌ Mistake 6: Losing the Thread
```
Bad: Going deep on one hypothesis and forgetting your overall structure

Good: "That's one hypothesis. Let me continue through my framework 
      and then we can decide which areas to explore deeper"
```

## Pro Tips for Case Study Success

### 1. Practice the Opening
Your first 2 minutes set the tone. Practice saying:
"Thank you for the question. Let me first clarify a few things before I dive in..."

### 2. Think Out Loud
Interviewers want to see your thought process, not just your final answer.
"I'm considering two hypotheses here. Let me think about which is more likely..."

### 3. Use Frameworks as Guides, Not Crutches
Don't robotically apply frameworks. Adapt them to the specific question.
"While I'd normally use framework X, in this case Y makes more sense because..."

### 4. Showcase Both Quant and Qual Skills
Good PMs balance data analysis with user empathy.
"The data shows X, which makes sense given user behavior Y that we see in interviews..."

### 5. Be Comfortable with Ambiguity
You won't have perfect information. State assumptions clearly.
"I don't have data on X, so I'll assume Y based on industry benchmarks..."

### 6. Ask for Feedback Mid-Interview
Don't wait until the end.
"Before I go deeper on this, am I on the right track or would you like me to adjust?"

### 7. Time Management
- Clarify: 2 min
- Structure: 2 min
- Analysis: 8 min
- Solutions: 4 min
- Wrap-up: 2 min
Set a watch/timer if allowed.

### 8. Practice Common Variants
- Metric investigations (most common)
- Feature decisions
- Product strategy
- Root cause analysis
- Experiment design

Do 20-30 practice case studies to build intuition.

## Practice Exercises

### Exercise 1: Metric Investigation
**Question**: "Spotify's premium subscription conversions dropped 15% this month. Investigate."

**Your task**:
1. Write out clarifying questions (5+ questions)
2. Create your structural framework
3. Generate 5 specific hypotheses with supporting logic
4. Recommend 3 immediate actions

### Exercise 2: Feature Decision
**Question**: "Should Twitter add an 'edit tweet' feature?"

**Your task**:
1. Define success criteria
2. Analyze user problem and business value
3. Identify risks and trade-offs
4. Make a recommendation with supporting rationale

### Exercise 3: Root Cause Analysis
**Question**: "Uber's wait time for rides increased from 4 minutes to 7 minutes in the last week in NYC. Why?"

**Your task**:
1. Structure your investigation using the 5 W's
2. Create a decision tree of hypotheses
3. Identify what data you'd need to test each hypothesis
4. Recommend next steps

## Key Takeaways

1. **Structure beats brilliance**: A methodical approach trumps random insights

2. **Clarify before solving**: 2 minutes of clarification saves 10 minutes of wrong analysis

3. **Be MECE**: Mutually exclusive, collectively exhaustive thinking shows rigor

4. **Data + intuition**: Balance quantitative analysis with qualitative user understanding

5. **Think in trade-offs**: Every decision has costs, benefits, and risks

6. **Practice, practice, practice**: Case studies are a learnable skill

7. **Communication matters**: How you present is as important as what you present

8. **Stay calm**: If stuck, go back to your framework

## Additional Resources

**Books:**
- "Case Interview Secrets" by Victor Cheng
- "Cracking the PM Interview" - Case study section
- "Decode and Conquer" by Lewis Lin

**Websites:**
- Exponent.com - Product case study videos
- GrowthX - Case study practice
- Reforge - Product analytics frameworks

**Practice Partners:**
- Find interview practice groups
- Do mock interviews
- Record yourself and review

**Case Study Banks:**
- Exponent case study database
- YouTube PM interview channels
- Company interview prep guides

Master this framework through deliberate practice, and case study interviews will become your strength rather than a source of anxiety.
