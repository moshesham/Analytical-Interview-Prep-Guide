# Product Case Study Practice

## Overview

This section provides comprehensive practice exercises with detailed solutions to help you master product case studies. Each exercise includes:
- A realistic scenario
- Step-by-step solution using the frameworks from this week
- Sample answers that would score well in interviews
- Common mistakes to avoid

Work through these exercises, time yourself, and practice delivering your answers out loud.

## Exercise 1: User Engagement Drop (Metric Investigation)

### Scenario
**You're a product analyst at Instagram. Reels engagement (measured by average watch time per user per day) has dropped by 8% over the last two weeks. Your manager asks you to investigate. You have 20 minutes.**

### Solution Framework

**Step 1: Clarify (2 minutes)**

*What to ask:*
- How is "engagement" defined? (You said watch time - is that time spent watching Reels specifically?)
- What's the baseline? (From X minutes to Y minutes?)
- Is this statistically significant? (Sample size, confidence interval?)
- Any known changes? (Product releases, algorithm updates?)
- Which user segments are affected? (All users or specific groups?)

*Assumed answers for practice:*
- Average watch time dropped from 25 min/day to 23 min/day
- Statistically significant (p < 0.001)
- No major product releases in last 2 weeks
- Appears to affect all users, but segmentation not done yet

**Step 2: Structure (2 minutes)**

"I'll investigate this systematically across four areas:

1. **Data Quality**: Rule out measurement issues
2. **Internal Factors**: Product changes, bugs, operations
3. **External Factors**: Competition, seasonality, user behavior shifts
4. **User Segmentation**: Where is the drop concentrated?

Let me start with segmentation to identify the pattern."

**Step 3: Analyze (8 minutes)**

*Segmentation Analysis:*

```
By Platform:
- iOS: -12% (25 → 22 min) ⚠️ Highest impact
- Android: -5% (25 → 23.75 min)
- Web: -2% (minimal usage anyway)

By User Type:
- New users (<30 days): -15% ⚠️
- Regular users: -7%
- Power users (top 10%): -3%

By Geography:
- US: -10%
- Europe: -8%
- Asia: -5%

By Content Category:
- Comedy/Entertainment: -12% ⚠️
- Educational: -5%
- Music: -3%

By User Age:
- 13-18: -15% ⚠️ Highest
- 19-25: -10%
- 26+: -5%
```

*Pattern Identified:*
Biggest drop in: iOS, young users, new users, entertainment content

*Hypothesis Formation:*

**Primary Hypothesis:** TikTok launched a new creator incentive program two weeks ago, pulling young content creators and viewers

**Supporting Evidence:**
- Timing aligns (2 weeks ago)
- Young users most affected (TikTok's core demographic)
- Entertainment content most affected (TikTok's strength)
- iOS users more affected (TikTok strong on iOS)

**Alternative Hypotheses:**
1. iOS-specific bug or performance issue
   - Would explain platform concentration
   - Check: iOS crash logs, loading times
   
2. Algorithm change affecting content distribution
   - Check: Deployment logs, A/B tests running
   - Look for correlation with feed impressions
   
3. Seasonal effect (back-to-school timing)
   - Check: Historical patterns for this time of year
   - Compare to same period last year

**Step 4: Recommend (5 minutes)**

```
IMMEDIATE ACTIONS (This week):

1. Validate competitive hypothesis:
   - Social listening analysis (TikTok mentions vs. Reels)
   - Survey churned heavy users
   - Check creator upload rates (are creators posting less?)

2. Rule out technical issues:
   - Review iOS app metrics (crashes, load times, errors)
   - Check if specific iOS versions affected
   - Validate tracking is working correctly

3. Quick engagement boosts:
   - Promote top Reels creators on main feed
   - Increase Reels in algorithmic recommendations by 20%
   - Test personalized push notifications for Reels

SHORT-TERM (Next 2-4 weeks):

1. If competitive pressure confirmed:
   - Launch Instagram Creator Fund for Reels (match TikTok)
   - Improve monetization for short-form content
   - Highlight unique Instagram advantages (cross-posting to Feed/Stories)

2. If technical issue:
   - Emergency fix and deploy
   - Compensate with increased promotion

3. Product improvements:
   - Better discovery algorithm for Reels
   - Enhanced editing tools
   - Cross-platform sharing features

LONG-TERM (Next quarter):

1. Strategic differentiation:
   - Leverage Instagram's social graph (friend content prioritized)
   - Better integration with main Instagram (not siloed like TikTok)
   - Commerce features for creators

EXPECTED IMPACT:
- Immediate actions: +2-3% recovery within 1 week
- Short-term: +4-5% from creator incentives by week 6
- Long-term: Return to baseline + 5% growth by quarter end

METRICS TO TRACK:
- Primary: Watch time per user per day
- Secondary: Reels created per day, new creator signups
- Guardrail: Main feed engagement, Stories engagement
- Success: Return to 25+ min/day baseline within 6 weeks
```

**Step 5: Wrap-up (2 minutes)**

"To summarize: Instagram Reels engagement dropped 8%, concentrated in young iOS users watching entertainment content. Primary hypothesis is competitive pressure from TikTok's new creator program launched 2 weeks ago.

I recommend a three-phase approach: immediate validation and engagement tactics, short-term creator incentives, and long-term product differentiation. Expected recovery to baseline within 6 weeks, with return to growth trajectory by quarter end.

Key risks are cost of creator programs and potential impact on main feed engagement. Would monitor closely and adjust based on first 2 weeks of data."

### Common Mistakes to Avoid

❌ **Jumping to solutions without analysis**
"We should just copy TikTok's features"

✅ **Systematic investigation first**
"Let me segment the data to find patterns, then form hypotheses"

❌ **Vague hypotheses**
"Maybe users don't like Reels anymore"

✅ **Specific, testable hypotheses**
"TikTok's creator program is pulling young users based on timing and segment data"

❌ **Ignoring trade-offs**
"Launch a big creator fund"

✅ **Acknowledging constraints**
"Creator fund costs $50M annually, need to validate ROI and ensure it doesn't cannibalize other content"

## Exercise 2: New Feature Proposal (Product Decision)

### Scenario
**You're a product analyst at Spotify. The PM team asks: "Should we add a 'Group Playlist' feature that allows multiple users to add songs to a shared playlist in real-time?" You have 20 minutes to provide your recommendation.**

### Solution Framework

**Step 1: Clarify (2 minutes)**

*Questions to ask:*
- What's the business goal? (Engagement, retention, growth, social features?)
- Who requested this? (Users, competitor analysis, exec vision?)
- What's the target audience? (All users, specific segments?)
- Any technical constraints? (Real-time sync, scaling concerns?)
- What's the competitive landscape? (Does Apple Music / YouTube Music have this?)

*Assumed context:*
- Goal: Increase social engagement and retention
- Multiple user requests via surveys and social media
- Target: All users, but expect younger users to adopt first
- Technically feasible, ~3 engineer-months to build
- Apple Music has similar feature, gaining traction

**Step 2: Structure (2 minutes)**

"I'll analyze this decision across four dimensions:

1. **User Problem & Need**: What problem does this solve? How big is it?
2. **Solution Evaluation**: Is this the best solution? What are alternatives?
3. **Business Impact**: Expected metrics impact and ROI
4. **Risks & Trade-offs**: What could go wrong? What are we not building instead?"

**Step 3: Analyze (8 minutes)**

**1. User Problem & Need**

*Problem:*
Current Spotify playlists are solo experiences. Users want to:
- Create collaborative music experiences with friends
- Share music discovery socially
- Coordinate music for parties/road trips in real-time
- Feel more connected through shared music

*Evidence of need:*
- User surveys: 45% of users have requested collaborative features
- Workarounds exist: Users manually share songs via messages (friction)
- Competitor features show high engagement
- Social listening: "I wish Spotify had group playlists" (common theme)

*Size of problem:*
- Affects: ~30% of users (those who regularly listen with friends/family)
- Frequency: Multiple times per week for social listeners
- Impact: Medium-high (social features increase stickiness and retention)

**2. Solution Evaluation**

*Proposed Feature:*
- Multiple users can add/remove songs in real-time
- Push notifications when friends add songs
- Shared queue visible to all participants
- Works across devices

*Alternative Solutions:*
1. **Collaborative Playlists (async)**: Already exists but limited
   - Pro: Simpler technically
   - Con: Less exciting, no real-time element

2. **Group Listening Sessions**: Virtual listening party
   - Pro: More social, could add voice chat
   - Con: More complex, requires sync playback

3. **Social Feed of Music**: See what friends are listening to
   - Pro: Passive discovery
   - Con: Doesn't solve active collaboration problem

*Why this solution?*
- Balances simplicity with social value
- Clear use cases (parties, road trips, shared discovery)
- Lower technical complexity than full group listening
- Natural extension of existing playlist feature

**3. Business Impact**

*Expected Metrics Impact:*

```
Primary Metrics:
- User Retention (D30): +3-5% for users who create/join group playlists
  - Baseline: 75% → Target: 78%
  - Reasoning: Social features increase switching costs

- Engagement (weekly active days): +2 days/month for feature users
  - Social pressure to check what friends added
  - More reasons to open app

Secondary Metrics:
- Friend connections: +20% (users adding more friends)
- Playlist creation: +15%
- Shares: +25% (sharing group playlists)

Guardrail Metrics:
- Individual playlist engagement (ensure we don't cannibalize)
- Average listening time (ensure quality not sacrificed)
- Server costs (real-time sync is expensive)
```

*Adoption Forecast:*
```
Month 1: 5% of users try feature (early adopters)
Month 3: 15% adoption (word-of-mouth growth)
Month 6: 25% adoption (mainstream)
Month 12: 35% plateau (not everyone wants social features)

Active usage (of adopters):
- 60% use weekly
- 30% use monthly
- 10% churn from feature
```

*Business Value:*
```
Retention Impact:
- 10M MAU × 35% adoption × 3% retention lift
= 1.05M additional retained users
× $5 ARPU = $5.25M annual value

Development Cost:
- 3 engineer-months × $50K = $150K
- Maintenance: $50K annually

ROI: $5.25M / $150K = 35x first year
→ Strong positive ROI ✅
```

**4. Risks & Trade-offs**

*Risks:*
1. **Low adoption**: If <10% adopt, ROI questionable
   - Mitigation: Strong promotion, influencer partnerships

2. **Negative social dynamics**: Arguments over music choices
   - Mitigation: Easy leave/mute options, creator controls

3. **Technical issues**: Real-time sync failures frustrate users
   - Mitigation: Thorough testing, graceful degradation

4. **Privacy concerns**: Don't want all music public
   - Mitigation: Private groups, opt-in only

*Trade-offs:*
- **Opportunity cost**: Not building other features (better recommendations, HiFi expansion)
- **Complexity**: Adds to product surface area, support burden
- **Focus**: Pulls team away from core experience improvements

**Step 4: Recommend (5 minutes)**

```
RECOMMENDATION: Ship with phased rollout ✅

RATIONALE:
1. Clear user need (45% of users want this)
2. Strong business case (35x ROI, +3% retention)
3. Competitive necessity (Apple Music has it)
4. Manageable risks with mitigations

IMPLEMENTATION PLAN:

Phase 1 (Weeks 1-4): MVP Build
- Core functionality: Add/remove songs to shared playlist
- Basic notifications
- Privacy controls

Phase 2 (Weeks 5-6): Beta Test
- 10K users (power users + social butterflies)
- Gather feedback, fix bugs
- Validate adoption assumptions

Phase 3 (Weeks 7-10): Gradual Rollout
- Week 7: 10% of users
- Week 8: 25%
- Week 9: 50%
- Week 10: 100%

Phase 4 (Months 3-6): Iteration
- Add enhanced features based on feedback
- Improve real-time performance
- Build social discovery layer

SUCCESS CRITERIA:
- 15% adoption within 3 months
- 60% weekly active usage among adopters
- +2% D30 retention for feature users
- <1% increase in support tickets
- Positive NPS impact (>+5 points)

KILL CRITERIA:
- <8% adoption by Month 2
- Negative NPS impact
- >5% increase in churn for feature users
- Critical technical issues can't be resolved
```

**Step 5: Wrap-up (2 minutes)**

"To summarize: I recommend building the Group Playlist feature. There's clear user demand, strong business value (+$5M annually), and competitive necessity.

Key success factors are: strong promotion to drive adoption, robust technical implementation to avoid sync issues, and careful privacy controls to avoid negative social dynamics.

I'd start with a beta test to validate assumptions, then roll out gradually while monitoring retention and engagement metrics. Expected to reach 15% adoption within 3 months and deliver significant retention improvements."

## Exercise 3: Root Cause Analysis (Technical Investigation)

### Scenario
**You're at Uber. Average wait time for rides increased from 4 minutes to 7 minutes in the last week in New York City. Investigate the root cause. You have 20 minutes.**

### Solution Framework

**Step 1: Clarify (2 minutes)**

- Is this specific to NYC or seeing elsewhere?
- Which ride types affected? (UberX, Comfort, XL, etc.)
- What times of day? (All day or peak hours?)
- How many riders affected?
- Any known changes to app, pricing, or operations?

*Assumptions:*
- Specific to NYC only
- All ride types affected similarly
- Consistent throughout the day
- Affecting ~500K daily riders
- No known app changes

**Step 2: Structure using 5 W's (2 minutes)**

```
WHEN: Last week (7 days ago), sustained increase
WHERE: NYC only (Manhattan, Brooklyn, Queens, Bronx)
WHO: All user types, all driver types
WHAT: Wait time (4 → 7 minutes), +75% increase
WHY: To be determined through analysis
```

**Step 3: Hypothesize (8 minutes)**

*Framework: Supply vs. Demand*

**Demand Side (More riders):**
```
1. External event drawing people to NYC
   - Check: Event calendars, tourism data
   - Conference? Concert? Holiday?

2. Competitor issue (Lyft outage)
   - Check: Lyft status, social media
   - Users switching to Uber temporarily?

3. Weather/transit disruption
   - Check: Weather data, subway delays
   - Bad weather → more ride demand

4. Promotional campaign
   - Check: Marketing calendar
   - Did we run discounts/ads in NYC?
```

**Supply Side (Fewer drivers):**
```
1. Driver strike or protest ⚠️ MOST LIKELY
   - Check: Driver forums, news, social media
   - Recent policy change affecting drivers?

2. Competing opportunity (gig economy)
   - Check: Other platforms launching promotions
   - Are drivers moving to Lyft, DoorDash, etc.?

3. Gas prices spike
   - Check: Gas price trends
   - Makes driving less profitable

4. Regulatory change
   - Check: NYC TLC announcements
   - New rules affecting driver availability?

5. Technical issue with driver app
   - Check: Driver app logs, error rates
   - Are drivers going offline due to bugs?
```

*Data to Check:*
```
Demand Metrics:
- Trip requests per hour (trend)
- New user signups
- Ride volume by time/area

Supply Metrics:
- Active drivers per hour ⚠️ KEY METRIC
- Driver hours online
- Driver acceptance rate
- Driver cancellation rate

Matching Metrics:
- Request-to-match time
- Search radius expansion
- Surge pricing activation
```

*Deep Dive Analysis:*
```
Checked Data (fictional example):

Active Drivers:
- Week -2: 15,000 daily active drivers
- Week -1: 14,500
- Current: 10,500 ⚠️ DROP OF 4,000 DRIVERS (-27%)

Driver Hours:
- Per driver: 6.5 hrs/day (unchanged)
- Total driver hours: DOWN 27%

Trip Requests:
- Week -2: 120,000 daily
- Week -1: 122,000
- Current: 118,000 (slightly down, not up)

Conclusion: Supply problem, not demand spike
```

**Root Cause Investigation:**
```
Driver Survey Results (200 offline drivers contacted):
- 60%: Protesting new per-mile rate reduction
- 25%: Switched to Lyft (better incentives this week)
- 10%: Gas prices too high, not profitable
- 5%: Other reasons

News Search:
- "Uber drivers protest rate cuts in NYC" (5 days ago)
- Uber reduced per-mile rate by $0.15 last week
- Drivers organizing through Facebook groups

ROOT CAUSE IDENTIFIED: Rate change → Driver protest → 27% supply reduction → 75% wait time increase
```

**Step 4: Recommend Solutions (5 minutes)**

```
IMMEDIATE (This week):

1. Emergency driver incentives
   - Boost bonuses: $10/ride for next 3 days
   - Target: Bring back 2,000 drivers (+50% of lost)
   - Cost: 50K rides/day × $10 × 3 days = $1.5M

2. Communicate with drivers
   - Town hall (virtual) to address concerns
   - Explain rate change reasoning
   - Gather feedback on fair rates

3. Rider communication
   - In-app messaging: "High wait times due to low availability"
   - Offer: $5 credit for waits >10 minutes
   - Encourage: Scheduled rides (can plan better)

SHORT-TERM (Next 2 weeks):

1. Rate adjustment compromise
   - Revert 50% of cut ($0.075/mile)
   - Adds transparency in how rates calculated
   - Shows responsiveness to driver concerns

2. Enhanced incentives program
   - Bonuses for driving during peak
   - Consecutive ride bonuses
   - Loyalty rewards for consistent drivers

3. Expand driver recruitment
   - Emergency hiring push
   - Referral bonuses doubled
   - Fast-track onboarding (24 hours)

LONG-TERM (Next quarter):

1. Driver relations overhaul
   - Regular driver advisory board
   - 30-day notice for rate changes
   - Data-driven rate setting (cost-of-living adjusted)

2. Improve driver economics
   - Partner with gas stations (discounts)
   - Maintenance partnerships
   - Health insurance options

3. Better driver tools
   - Earnings predictor
   - Flexible scheduling
   - Destination mode improvements

EXPECTED IMPACT:
- Immediate: Reduce wait time to 5.5 min (-21%)
- Short-term: Return to 4.5 min by week 3
- Long-term: Stabilize at 4 min with happier drivers

COST:
- Immediate: $1.5M (incentives)
- Short-term: $0.075/mile × 50K rides/day × 365 = $1.37M annually
- Total: ~$3M year 1

BENEFIT:
- Retain riders (avoid churn from poor experience)
- 500K riders × 7-day poor experience × 5% churn risk × $200 LTV = $35M risk
- ROI: $35M / $3M = 11.7x ✅
```

**Step 5: Wrap-up (2 minutes)**

"Root cause: Uber reduced per-mile rates last week, causing 27% of NYC drivers to protest by going offline. This created supply shortage → 75% wait time increase.

Recommend three-phase response: immediate incentives to bring drivers back, short-term rate compromise, long-term driver relations improvements. Expected cost $3M, avoiding $35M in rider churn risk.

Key lesson: Rate changes must involve driver communication and have grace periods. Would implement driver advisory board to prevent future issues."

## Practice Tips

**Time Management:**
- Clarify: 10-15% of time (2-3 min in 20 min interview)
- Structure: 10% (2 min)
- Analysis: 40% (8 min)
- Recommendations: 25% (5 min)
- Wrap-up: 10% (2 min)
- Buffer: 5% (1 min for pauses/questions)

**Delivery Best Practices:**
1. **Think out loud**: "I'm considering two hypotheses here..."
2. **Signpost transitions**: "Now moving to recommendations..."
3. **Use the whiteboard**: Draw frameworks, tables, timelines
4. **Check in periodically**: "Am I going in the right direction?"
5. **Stay structured**: Don't jump around randomly

**Common Pitfalls:**
❌ Spending too long on one section
❌ Forgetting to make a clear recommendation
❌ Not quantifying business impact
❌ Ignoring trade-offs and risks
❌ Poor time management

**Mock Interview Practice:**
- Record yourself doing these exercises
- Practice with a partner and give feedback
- Time yourself strictly
- Do 10-15 practice cases before real interviews
- Focus on delivery, not just content

## Additional Practice Cases

**Metric Investigation:**
1. "Airbnb bookings dropped 15% in Europe last month"
2. "DoorDash order frequency per user decreased from 3.2 to 2.8 times per month"
3. "Slack daily active teams decreased 8% quarter-over-quarter"

**Feature Decisions:**
1. "Should Netflix add a 'watch party' feature for group streaming?"
2. "Should LinkedIn add a job salary transparency feature?"
3. "Should Amazon add a 'try before you buy' option for all products?"

**Root Cause:**
1. "Twitter/X engagement dropped 20% after a major algorithm change"
2. "Zoom meeting quality complaints increased 50% last week"
3. "PayPal transaction success rate dropped from 98% to 92%"

## Key Takeaways

1. **Framework = confidence**: Structure prevents you from freezing up

2. **Practice makes perfect**: Do 15+ cases before real interviews

3. **Quantify everything**: Vague answers don't impress, numbers do

4. **Think trade-offs**: Every decision has costs and benefits

5. **Business impact matters**: Connect everything to revenue/growth/retention

6. **Time management**: Practice with a timer, get comfortable with pace

7. **Communication**: How you present is as important as what you present

By working through these exercises repeatedly, you'll develop the muscle memory and confidence to excel in any product case study interview.
