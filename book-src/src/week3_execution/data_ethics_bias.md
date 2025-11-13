# Data Ethics and Bias Detection

In today's data-driven world, ethical considerations are paramount. As data analysts and scientists, we have the power to influence decisions that affect people's lives. This guide covers key ethical principles, bias detection, and responsible data practices.

---

## 1. Core Ethical Principles

### Privacy
- **Principle**: Respect individuals' right to privacy and data protection
- **Practice**:
  - Collect only necessary data
  - Anonymize/pseudonymize personal data
  - Implement proper access controls
  - Follow regulations (GDPR, CCPA, HIPAA)
  - Be transparent about data collection and use

**Example**: When analyzing user behavior, aggregate data to segment level rather than tracking individuals.

### Fairness
- **Principle**: Ensure analyses and models don't discriminate against protected groups
- **Practice**:
  - Test for bias across demographic groups
  - Use fairness metrics (equal opportunity, demographic parity)
  - Consider disparate impact
  - Involve diverse stakeholders

**Example**: A hiring algorithm showing 70% male recommendations when the applicant pool is 50% female indicates potential bias.

### Transparency
- **Principle**: Be open about methods, limitations, and potential impacts
- **Practice**:
  - Document data sources and methodology
  - Disclose limitations and uncertainties
  - Make results interpretable
  - Explain model decisions when impactful

**Example**: When presenting A/B test results, include confidence intervals and note any threats to validity.

### Accountability
- **Principle**: Take responsibility for the consequences of your analyses
- **Practice**:
  - Monitor deployed models for drift and bias
  - Establish feedback mechanisms
  - Have processes to address errors
  - Document decisions and rationale

---

## 2. Types of Bias in Data and Models

### Selection Bias
- **Definition**: Sample doesn't represent the population
- **Examples**:
  - Survey only sent to email subscribers (excludes non-subscribers)
  - Training data from English-speaking countries only
  - A/B test that excludes mobile users
- **Detection**: Compare sample demographics to known population
- **Mitigation**: Use representative sampling, stratified sampling, weighting

```python
import pandas as pd

# Check representation
sample_demographics = df.groupby('country').size() / len(df)
population_demographics = population_df.groupby('country').size() / len(population_df)

comparison = pd.DataFrame({
    'sample': sample_demographics,
    'population': population_demographics,
    'difference': sample_demographics - population_demographics
})
print(comparison)

# Flag large discrepancies
concerning = comparison[abs(comparison['difference']) > 0.05]
if len(concerning) > 0:
    print("\n⚠ Warning: Sample differs significantly from population:")
    print(concerning)
```

### Measurement Bias
- **Definition**: Systematic error in how data is collected or measured
- **Examples**:
  - Survey questions that lead respondents
  - Inconsistent data collection across groups
  - Sensor accuracy varies by demographic
- **Detection**: Validate measurements, check for systematic patterns
- **Mitigation**: Standardize data collection, validate instruments, test across groups

### Historical Bias
- **Definition**: Past discrimination reflected in historical data
- **Examples**:
  - Loan approval data reflecting past discriminatory practices
  - Hiring data reflecting gender imbalances
  - Criminal justice data reflecting over-policing
- **Detection**: Examine historical outcomes by protected groups
- **Mitigation**: Don't blindly replicate past decisions, adjust for historical inequities

### Aggregation Bias
- **Definition**: One-size-fits-all model doesn't work for all groups
- **Examples**:
  - Medical algorithm trained on one demographic performs poorly on others
  - Product recommendation works well for majority but not minority groups
- **Detection**: Test model performance by subgroup
- **Mitigation**: Train separate models per group or use group-aware features

```python
from sklearn.metrics import accuracy_score

# Test model performance by group
for group in df['demographic_group'].unique():
    group_df = df[df['demographic_group'] == group]
    accuracy = accuracy_score(group_df['actual'], group_df['predicted'])
    print(f"{group}: Accuracy = {accuracy:.2%}")

# Flag disparities
accuracies = df.groupby('demographic_group').apply(
    lambda x: accuracy_score(x['actual'], x['predicted'])
)
if accuracies.max() - accuracies.min() > 0.05:
    print("\n⚠ Warning: Model performance varies significantly across groups")
```

### Algorithmic Bias
- **Definition**: Model perpetuates or amplifies existing biases
- **Examples**:
  - Word embeddings associating "doctor" with male, "nurse" with female
  - Image recognition worse for darker skin tones
  - Recommendation systems creating filter bubbles
- **Detection**: Audit model outputs, test fairness metrics
- **Mitigation**: Debiasing techniques, fairness constraints, diverse training data

---

## 3. Fairness Metrics

### Demographic Parity
- **Definition**: Positive prediction rate should be equal across groups
- **Formula**: P(Ŷ=1|A=0) = P(Ŷ=1|A=1)
- **Use case**: When equal representation is desired

```python
# Calculate demographic parity
def demographic_parity(df, prediction_col, group_col):
    rates = df.groupby(group_col)[prediction_col].mean()
    print("Positive prediction rates by group:")
    print(rates)
    
    parity_diff = rates.max() - rates.min()
    print(f"\nDemographic parity difference: {parity_diff:.4f}")
    
    if parity_diff < 0.05:
        print("✓ Satisfies demographic parity")
    else:
        print("✗ Violates demographic parity")
    
    return parity_diff

demographic_parity(df, 'predicted_hire', 'gender')
```

### Equal Opportunity
- **Definition**: True positive rate should be equal across groups
- **Formula**: P(Ŷ=1|Y=1,A=0) = P(Ŷ=1|Y=1,A=1)
- **Use case**: When we care about not missing qualified candidates

```python
def equal_opportunity(df, prediction_col, actual_col, group_col):
    # TPR for each group (recall)
    from sklearn.metrics import recall_score
    
    for group in df[group_col].unique():
        group_df = df[df[group_col] == group]
        tpr = recall_score(group_df[actual_col], group_df[prediction_col])
        print(f"{group}: TPR = {tpr:.2%}")
```

### Equalized Odds
- **Definition**: Both TPR and FPR should be equal across groups
- **Use case**: When both false positives and false negatives are important

```python
def equalized_odds(df, prediction_col, actual_col, group_col):
    from sklearn.metrics import confusion_matrix
    
    for group in df[group_col].unique():
        group_df = df[df[group_col] == group]
        tn, fp, fn, tp = confusion_matrix(
            group_df[actual_col], 
            group_df[prediction_col]
        ).ravel()
        
        tpr = tp / (tp + fn) if (tp + fn) > 0 else 0
        fpr = fp / (fp + tn) if (fp + tn) > 0 else 0
        
        print(f"{group}: TPR = {tpr:.2%}, FPR = {fpr:.2%}")
```

---

## 4. Detecting Bias in Practice

### Step-by-Step Bias Audit

```python
import pandas as pd
import numpy as np
from sklearn.metrics import confusion_matrix, accuracy_score

def comprehensive_bias_audit(df, prediction_col, actual_col, sensitive_attributes):
    """
    Perform comprehensive bias audit on model predictions
    
    Parameters:
    - df: DataFrame with predictions and actuals
    - prediction_col: column name with model predictions
    - actual_col: column name with ground truth
    - sensitive_attributes: list of demographic columns to check
    """
    
    print("="*60)
    print("BIAS AUDIT REPORT")
    print("="*60)
    
    for attribute in sensitive_attributes:
        print(f"\n--- Analysis by {attribute} ---")
        
        # Overall distribution
        print("\nGroup distribution:")
        print(df[attribute].value_counts())
        
        # Prediction rates
        print("\nPositive prediction rates:")
        pred_rates = df.groupby(attribute)[prediction_col].mean()
        print(pred_rates)
        
        # Performance metrics by group
        print("\nPerformance by group:")
        for group in df[attribute].unique():
            group_df = df[df[attribute] == group]
            
            accuracy = accuracy_score(group_df[actual_col], group_df[prediction_col])
            
            # Confusion matrix
            tn, fp, fn, tp = confusion_matrix(
                group_df[actual_col], 
                group_df[prediction_col]
            ).ravel()
            
            # Calculate metrics
            precision = tp / (tp + fp) if (tp + fp) > 0 else 0
            recall = tp / (tp + fn) if (tp + fn) > 0 else 0
            fpr = fp / (fp + tn) if (fp + tn) > 0 else 0
            
            print(f"\n{group}:")
            print(f"  Accuracy: {accuracy:.2%}")
            print(f"  Precision: {precision:.2%}")
            print(f"  Recall (TPR): {recall:.2%}")
            print(f"  False Positive Rate: {fpr:.2%}")
        
        # Check disparities
        accuracies = df.groupby(attribute).apply(
            lambda x: accuracy_score(x[actual_col], x[prediction_col])
        )
        
        if accuracies.max() - accuracies.min() > 0.05:
            print(f"\n⚠ WARNING: Performance disparity detected in {attribute}")
            print(f"   Max accuracy: {accuracies.max():.2%}")
            print(f"   Min accuracy: {accuracies.min():.2%}")
            print(f"   Difference: {(accuracies.max() - accuracies.min()):.2%}")

# Usage
comprehensive_bias_audit(
    df, 
    prediction_col='predicted', 
    actual_col='actual',
    sensitive_attributes=['gender', 'race', 'age_group']
)
```

---

## 5. Mitigating Bias

### Pre-processing: Fix the Data

1. **Resampling**: Balance training data across groups
```python
from sklearn.utils import resample

# Oversample minority group
minority_df = df[df['group'] == 'minority']
majority_df = df[df['group'] == 'majority']

minority_upsampled = resample(
    minority_df,
    replace=True,
    n_samples=len(majority_df),
    random_state=42
)

balanced_df = pd.concat([majority_df, minority_upsampled])
```

2. **Reweighting**: Give higher weight to underrepresented groups
```python
from sklearn.utils.class_weight import compute_sample_weight

# Compute weights to balance classes
weights = compute_sample_weight('balanced', y_train)

# Use in model training
model.fit(X_train, y_train, sample_weight=weights)
```

### In-processing: Modify the Algorithm

1. **Fairness constraints**: Add fairness as optimization constraint
```python
# Using fairlearn library
from fairlearn.reductions import ExponentiatedGradient, DemographicParity
from sklearn.linear_model import LogisticRegression

model = LogisticRegression()
constraint = DemographicParity()

mitigator = ExponentiatedGradient(model, constraint)
mitigator.fit(X_train, y_train, sensitive_features=A_train)

predictions = mitigator.predict(X_test)
```

2. **Remove biased features**: Drop features that encode protected attributes
```python
# Remove features highly correlated with protected attributes
# But be careful - proxies can still exist!
sensitive_features = ['zip_code', 'first_name']  # might proxy race
X_train_clean = X_train.drop(columns=sensitive_features)
```

### Post-processing: Adjust the Outputs

1. **Threshold optimization**: Use different thresholds per group
```python
from sklearn.metrics import roc_curve

# Find optimal threshold per group
for group in df['demographic_group'].unique():
    group_df = df[df['demographic_group'] == group]
    
    fpr, tpr, thresholds = roc_curve(
        group_df['actual'], 
        group_df['prediction_score']
    )
    
    # Find threshold that maximizes TPR - FPR
    optimal_idx = np.argmax(tpr - fpr)
    optimal_threshold = thresholds[optimal_idx]
    
    print(f"{group}: Optimal threshold = {optimal_threshold:.3f}")
```

2. **Calibration**: Ensure predicted probabilities are accurate
```python
from sklearn.calibration import calibration_curve

# Check calibration
fraction_of_positives, mean_predicted_value = calibration_curve(
    y_true, 
    y_pred_proba, 
    n_bins=10
)

# Plot
plt.plot(mean_predicted_value, fraction_of_positives, 's-')
plt.plot([0, 1], [0, 1], 'k--')
plt.xlabel('Mean Predicted Probability')
plt.ylabel('Fraction of Positives')
plt.title('Calibration Plot')
plt.show()
```

---

## 6. Privacy-Preserving Techniques

### Data Anonymization
```python
# Remove direct identifiers
df_anon = df.drop(columns=['name', 'email', 'ssn', 'phone'])

# Generalize quasi-identifiers
df_anon['age_range'] = pd.cut(df_anon['age'], bins=[0, 25, 40, 60, 100])
df_anon = df_anon.drop(columns=['age'])

df_anon['zip_prefix'] = df_anon['zip_code'].astype(str).str[:3]
df_anon = df_anon.drop(columns=['zip_code'])
```

### Differential Privacy
Adding noise to protect individual privacy:

```python
import numpy as np

def add_laplace_noise(value, sensitivity, epsilon):
    """
    Add Laplace noise for differential privacy
    
    epsilon: Privacy parameter (smaller = more private)
    sensitivity: How much one person can affect the result
    """
    scale = sensitivity / epsilon
    noise = np.random.laplace(0, scale)
    return value + noise

# Example: Noisy count
true_count = len(df[df['has_condition'] == True])
private_count = add_laplace_noise(true_count, sensitivity=1, epsilon=0.1)
print(f"True count: {true_count}")
print(f"Private count: {private_count:.0f}")
```

### Aggregation
Always report at aggregate level:

```python
# BAD: Individual-level reporting
# print(df[['user_id', 'income', 'health_status']])

# GOOD: Aggregate reporting
summary = df.groupby('age_group').agg({
    'income': 'mean',
    'health_status': lambda x: (x == 'healthy').mean()
})
print(summary)
```

---

## 7. Ethical A/B Testing

### Informed Consent
- Users should know they're in an experiment
- Provide opt-out mechanisms for sensitive tests
- Don't test things that could cause harm

### Equipoise
- Only test when genuinely uncertain which is better
- Don't test known inferior options

### Minimize Harm
- Have stopping rules for negative effects
- Monitor guardrail metrics closely
- Limit exposure to risky variants

### Example: A/B Test Ethics Checklist
```python
def ethical_ab_test_check(test_description):
    """
    Checklist for ethical A/B testing
    """
    checks = {
        'informed_consent': False,
        'potential_harm_assessed': False,
        'stopping_rules_defined': False,
        'guardrail_metrics_set': False,
        'minority_groups_considered': False,
        'privacy_protected': False
    }
    
    print("Ethical A/B Test Checklist")
    print("-" * 40)
    for check, status in checks.items():
        status_icon = "✓" if status else "✗"
        print(f"{status_icon} {check.replace('_', ' ').title()}")
    
    # Return True only if all checks pass
    return all(checks.values())
```

---

## 8. Case Studies

### Case Study 1: Biased Hiring Algorithm

**Problem**: AI hiring tool favored male candidates

**Root Cause**: 
- Training data from historical hires (mostly male)
- Model learned that being male = better candidate

**Solution**:
1. Audit training data for gender imbalance
2. Remove gendered terms from resumes
3. Test model performance by gender
4. Apply fairness constraints
5. Human review of flagged cases

**Key Lesson**: Historical data reflects historical biases

### Case Study 2: Discriminatory Credit Scoring

**Problem**: Credit model denied more loans to minority applicants with similar profiles

**Root Cause**:
- Used zip code as feature (proxy for race)
- Different thresholds effectively applied to different groups

**Solution**:
1. Remove zip code or aggregate to larger regions
2. Test for disparate impact
3. Implement equal opportunity constraint
4. Regular bias audits

**Key Lesson**: Seemingly neutral features can be proxies for protected attributes

### Case Study 3: Medical Algorithm Bias

**Problem**: Healthcare algorithm underestimated illness severity for Black patients

**Root Cause**:
- Predicted healthcare cost as proxy for health needs
- Black patients historically received less care (lower costs), despite equal illness

**Solution**:
1. Change target from cost to actual health outcomes
2. Retrain on unbiased health measures
3. Test across racial groups

**Key Lesson**: Choice of target variable matters

---

## 9. Interview Questions

**Q1: How would you detect bias in a model?**
- Answer: (1) Test performance across demographic groups, (2) Check if positive prediction rates differ, (3) Calculate fairness metrics (demographic parity, equal opportunity), (4) Examine feature importances for proxies, (5) Interview stakeholders from affected groups.

**Q2: What's the difference between accuracy and fairness?**
- Answer: A model can be highly accurate overall but unfair to specific groups. For example, 95% accurate but 70% accurate for a minority group. Fairness requires equitable performance across groups.

**Q3: Your model uses zip code. Is that ethical?**
- Answer: It depends. Zip code can be a proxy for race and income, leading to discriminatory outcomes. Ask: (1) Is it necessary? (2) Does it lead to disparate impact? (3) Can you use a less granular geography? (4) Are there fairer alternatives? Context matters.

**Q4: How do you balance accuracy and fairness?**
- Answer: They sometimes trade off. Strategies: (1) Define acceptable fairness constraints, (2) Optimize accuracy subject to fairness, (3) Use ensemble methods, (4) Consider the cost of unfairness vs. slightly lower accuracy, (5) Sometimes fairness increases long-term accuracy by building trust.

---

## 10. Best Practices

### Do's
✓ Question your data's origins and biases
✓ Test disaggregated (break down by groups)
✓ Involve diverse stakeholders
✓ Document decisions and rationale
✓ Monitor deployed models continuously
✓ Be transparent about limitations
✓ Prioritize interpretability for high-stakes decisions

### Don'ts
✗ Assume data is neutral or objective
✗ Optimize for a single metric blindly
✗ Ignore fairness in favor of accuracy
✗ Deploy without bias testing
✗ Use personal data without consent
✗ Rely solely on aggregate metrics
✗ Forget that models affect real people

---

## 11. Resources

### Tools
- [Fairlearn](https://fairlearn.org/): Bias detection and mitigation (Python)
- [AI Fairness 360](https://aif360.mybluemix.net/): IBM's fairness toolkit
- [What-If Tool](https://pair-code.github.io/what-if-tool/): Google's model debugging tool

### Guidelines
- [Microsoft AI Ethics](https://www.microsoft.com/en-us/ai/responsible-ai)
- [Google AI Principles](https://ai.google/principles/)
- [ACM Code of Ethics](https://www.acm.org/code-of-ethics)

### Frameworks
- GDPR (General Data Protection Regulation)
- CCPA (California Consumer Privacy Act)
- HIPAA (Health Insurance Portability and Accountability Act)

---

## Conclusion

Ethics in data science isn't optional—it's essential. As analysts, we must:

1. **Be aware**: Recognize that bias exists in data and models
2. **Be proactive**: Test for and mitigate bias systematically
3. **Be responsible**: Consider the impact of our work on people
4. **Be transparent**: Document and communicate limitations
5. **Be accountable**: Monitor and address issues in deployed systems

**Remember**: With great data comes great responsibility. Build systems that are not just accurate, but fair, transparent, and beneficial to all.
