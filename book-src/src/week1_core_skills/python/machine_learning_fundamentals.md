# Machine Learning Fundamentals for Analytics

Machine Learning (ML) is increasingly important for data analysts and product analysts. While you may not build production ML systems, understanding ML concepts helps you work with data science teams and apply ML techniques to analytics problems.

---

## 1. What is Machine Learning?

**Definition**: ML is the process of training algorithms to find patterns in data and make predictions without being explicitly programmed.

### Types of Machine Learning

1. **Supervised Learning**: Learning from labeled data
   - Classification: Predict categories (e.g., churn vs. non-churn)
   - Regression: Predict continuous values (e.g., revenue, engagement score)

2. **Unsupervised Learning**: Finding patterns in unlabeled data
   - Clustering: Group similar observations (e.g., user segments)
   - Dimensionality Reduction: Reduce features while preserving information

3. **Reinforcement Learning**: Learning through trial and error
   - Less common in analytics, more in robotics and games

---

## 2. Supervised Learning: Classification

### Use Cases in Product Analytics
- Predict user churn
- Identify high-value customers
- Classify user feedback sentiment
- Detect fraud or anomalies

### Common Classification Algorithms

#### Logistic Regression
- **Pros**: Simple, interpretable, fast
- **Cons**: Assumes linear relationships, limited with complex patterns
- **Use when**: You need interpretability and have linearly separable classes

```python
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

# Prepare data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
model = LogisticRegression()
model.fit(X_train, y_train)

# Predict
y_pred = model.predict(X_test)

# Evaluate
print(f"Accuracy: {accuracy_score(y_test, y_pred):.2%}")
print(classification_report(y_test, y_pred))

# Feature importance
feature_importance = pd.DataFrame({
    'feature': X.columns,
    'coefficient': model.coef_[0]
}).sort_values('coefficient', ascending=False)
print(feature_importance)
```

#### Decision Trees
- **Pros**: Handles non-linear relationships, easy to visualize
- **Cons**: Prone to overfitting, unstable
- **Use when**: You need interpretability with non-linear patterns

```python
from sklearn.tree import DecisionTreeClassifier
from sklearn import tree
import matplotlib.pyplot as plt

model = DecisionTreeClassifier(max_depth=5, min_samples_split=20)
model.fit(X_train, y_train)

# Visualize tree
plt.figure(figsize=(20,10))
tree.plot_tree(model, feature_names=X.columns, 
               class_names=['No Churn', 'Churn'], filled=True)
plt.show()
```

#### Random Forest
- **Pros**: High accuracy, handles non-linearity, reduces overfitting
- **Cons**: Less interpretable, slower than single trees
- **Use when**: Accuracy is more important than interpretability

```python
from sklearn.ensemble import RandomForestClassifier

model = RandomForestClassifier(n_estimators=100, max_depth=10, random_state=42)
model.fit(X_train, y_train)

# Feature importance
importance = pd.DataFrame({
    'feature': X.columns,
    'importance': model.feature_importances_
}).sort_values('importance', ascending=False)

print(importance.head(10))
```

---

## 3. Supervised Learning: Regression

### Use Cases in Product Analytics
- Predict customer lifetime value (CLV)
- Forecast revenue or engagement metrics
- Estimate time to conversion
- Model pricing elasticity

### Common Regression Algorithms

#### Linear Regression
```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import numpy as np

model = LinearRegression()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)

print(f"R² Score: {r2_score(y_test, y_pred):.3f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test, y_pred)):.2f}")

# Coefficients interpretation
coef_df = pd.DataFrame({
    'feature': X.columns,
    'coefficient': model.coef_
}).sort_values('coefficient', key=abs, ascending=False)
print(coef_df)
```

#### Regularized Regression (Ridge, Lasso)
**Use when**: You have many features or multicollinearity

```python
from sklearn.linear_model import Ridge, Lasso

# Ridge Regression (L2 regularization)
ridge = Ridge(alpha=1.0)
ridge.fit(X_train, y_train)

# Lasso Regression (L1 regularization - feature selection)
lasso = Lasso(alpha=0.1)
lasso.fit(X_train, y_train)

# Features selected by Lasso (non-zero coefficients)
selected_features = X.columns[lasso.coef_ != 0]
print(f"Lasso selected {len(selected_features)} features")
```

---

## 4. Model Evaluation Metrics

### Classification Metrics

**Confusion Matrix**
|                | Predicted Negative | Predicted Positive |
|----------------|--------------------|--------------------|
| Actual Negative| True Negative (TN) | False Positive (FP)|
| Actual Positive| False Negative (FN)| True Positive (TP) |

**Key Metrics**:
- **Accuracy**: (TP + TN) / Total - Overall correctness
- **Precision**: TP / (TP + FP) - Of predicted positives, how many are correct?
- **Recall (Sensitivity)**: TP / (TP + FN) - Of actual positives, how many did we catch?
- **F1 Score**: 2 × (Precision × Recall) / (Precision + Recall) - Harmonic mean

**When to use each**:
- **Accuracy**: When classes are balanced and errors are equally costly
- **Precision**: When false positives are costly (e.g., spam detection)
- **Recall**: When false negatives are costly (e.g., fraud detection)
- **F1 Score**: When you need balance between precision and recall

```python
from sklearn.metrics import confusion_matrix, classification_report, roc_auc_score, roc_curve
import seaborn as sns

# Confusion matrix
cm = confusion_matrix(y_test, y_pred)
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix')
plt.show()

# Classification report
print(classification_report(y_test, y_pred))

# ROC-AUC for probability predictions
y_pred_proba = model.predict_proba(X_test)[:, 1]
auc = roc_auc_score(y_test, y_pred_proba)
print(f"ROC-AUC: {auc:.3f}")

# ROC Curve
fpr, tpr, thresholds = roc_curve(y_test, y_pred_proba)
plt.plot(fpr, tpr, label=f'ROC Curve (AUC = {auc:.2f})')
plt.plot([0, 1], [0, 1], 'k--', label='Random')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curve')
plt.legend()
plt.show()
```

### Regression Metrics

- **MAE (Mean Absolute Error)**: Average absolute difference between predictions and actuals
- **MSE (Mean Squared Error)**: Average squared difference (penalizes large errors more)
- **RMSE (Root Mean Squared Error)**: Square root of MSE (same units as target)
- **R² Score**: Proportion of variance explained (0 to 1, higher is better)

```python
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import numpy as np

mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2 = r2_score(y_test, y_pred)

print(f"MAE: {mae:.2f}")
print(f"MSE: {mse:.2f}")
print(f"RMSE: {rmse:.2f}")
print(f"R²: {r2:.3f}")
```

---

## 5. Overfitting and Underfitting

### Overfitting
- **Problem**: Model learns training data too well, including noise
- **Symptoms**: High training accuracy, low test accuracy
- **Solutions**:
  - Reduce model complexity (e.g., decrease tree depth)
  - Add regularization (Ridge, Lasso)
  - Get more training data
  - Use cross-validation
  - Early stopping

### Underfitting
- **Problem**: Model is too simple to capture patterns
- **Symptoms**: Low training and test accuracy
- **Solutions**:
  - Increase model complexity
  - Add more features
  - Reduce regularization

### Bias-Variance Tradeoff
- **High Bias (Underfitting)**: Model is too simple, misses patterns
- **High Variance (Overfitting)**: Model is too complex, fits noise
- **Goal**: Find the sweet spot with optimal generalization

---

## 6. Cross-Validation

**Purpose**: Assess model performance on unseen data and detect overfitting

**K-Fold Cross-Validation**:
1. Split data into K folds
2. Train on K-1 folds, test on remaining fold
3. Repeat K times, each fold used as test set once
4. Average performance across all folds

```python
from sklearn.model_selection import cross_val_score, cross_validate

# Simple cross-validation score
scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
print(f"Cross-validation scores: {scores}")
print(f"Mean accuracy: {scores.mean():.2%} (+/- {scores.std() * 2:.2%})")

# Multiple metrics
scoring = ['accuracy', 'precision', 'recall', 'f1', 'roc_auc']
cv_results = cross_validate(model, X, y, cv=5, scoring=scoring)

for metric in scoring:
    scores = cv_results[f'test_{metric}']
    print(f"{metric}: {scores.mean():.3f} (+/- {scores.std() * 2:.3f})")
```

---

## 7. Feature Engineering for ML

### Creating Features

```python
# Interaction features
df['feature_interaction'] = df['feature1'] * df['feature2']

# Polynomial features
from sklearn.preprocessing import PolynomialFeatures
poly = PolynomialFeatures(degree=2, include_bias=False)
X_poly = poly.fit_transform(X)

# Binning continuous variables
df['age_group'] = pd.cut(df['age'], bins=[0, 25, 40, 60, 100], 
                          labels=['young', 'adult', 'middle', 'senior'])

# Time-based features
df['hour'] = df['timestamp'].dt.hour
df['day_of_week'] = df['timestamp'].dt.dayofweek
df['is_weekend'] = df['day_of_week'].isin([5, 6]).astype(int)

# Lag features for time series
df['previous_value'] = df['value'].shift(1)
df['7day_rolling_avg'] = df['value'].rolling(7).mean()
```

### Feature Scaling

```python
from sklearn.preprocessing import StandardScaler, MinMaxScaler

# Standardization (z-score): mean=0, std=1
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Normalization: scale to [0, 1]
scaler = MinMaxScaler()
X_normalized = scaler.fit_transform(X_train)
```

**When to scale**:
- ✓ Always for distance-based algorithms (KNN, SVM, neural networks)
- ✓ For regularized regression (Ridge, Lasso)
- ✗ Not necessary for tree-based methods (decision trees, random forests)

### Encoding Categorical Variables

```python
# One-Hot Encoding
df_encoded = pd.get_dummies(df, columns=['category', 'city'])

# Label Encoding (for ordinal categories)
from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
df['category_encoded'] = le.fit_transform(df['category'])

# Target Encoding (advanced - use with caution)
# Replace category with mean of target variable
category_means = df.groupby('category')['target'].mean()
df['category_target_encoded'] = df['category'].map(category_means)
```

---

## 8. Unsupervised Learning: Clustering

### K-Means Clustering
**Use cases**: Customer segmentation, anomaly detection

```python
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

# Elbow method to find optimal k
inertias = []
K_range = range(2, 11)
for k in K_range:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertias.append(kmeans.inertia_)

plt.plot(K_range, inertias, 'bo-')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('Inertia')
plt.title('Elbow Method')
plt.show()

# Fit final model
kmeans = KMeans(n_clusters=4, random_state=42)
df['cluster'] = kmeans.fit_predict(X_scaled)

# Analyze clusters
print(df.groupby('cluster').mean())

# Visualize (if 2D)
plt.scatter(X_scaled[:, 0], X_scaled[:, 1], c=df['cluster'], cmap='viridis')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.title('K-Means Clustering')
plt.colorbar(label='Cluster')
plt.show()
```

---

## 9. Real-World Example: Churn Prediction

### Full ML Pipeline

```python
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score
from sklearn.preprocessing import StandardScaler

# 1. Load and explore data
df = pd.read_csv('user_data.csv')
print(df.info())
print(df['churned'].value_counts())

# 2. Feature engineering
df['account_age_days'] = (pd.to_datetime('today') - pd.to_datetime(df['signup_date'])).dt.days
df['avg_session_duration'] = df['total_time'] / df['num_sessions']
df['days_since_last_login'] = (pd.to_datetime('today') - pd.to_datetime(df['last_login'])).dt.days

# 3. Handle missing values
df['avg_session_duration'].fillna(df['avg_session_duration'].median(), inplace=True)

# 4. Select features
features = ['account_age_days', 'num_sessions', 'avg_session_duration', 
            'days_since_last_login', 'total_purchases', 'total_revenue']
X = df[features]
y = df['churned']

# 5. Train-test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# 6. Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 7. Train model
model = RandomForestClassifier(n_estimators=100, max_depth=10, random_state=42)
model.fit(X_train_scaled, y_train)

# 8. Evaluate
y_pred = model.predict(X_test_scaled)
y_pred_proba = model.predict_proba(X_test_scaled)[:, 1]

print(classification_report(y_test, y_pred))
print(f"ROC-AUC: {roc_auc_score(y_test, y_pred_proba):.3f}")

# 9. Cross-validation
cv_scores = cross_val_score(model, X_train_scaled, y_train, cv=5, scoring='roc_auc')
print(f"CV ROC-AUC: {cv_scores.mean():.3f} (+/- {cv_scores.std() * 2:.3f})")

# 10. Feature importance
importance_df = pd.DataFrame({
    'feature': features,
    'importance': model.feature_importances_
}).sort_values('importance', ascending=False)

print("\nTop features:")
print(importance_df)

# 11. Apply model to score users
df['churn_probability'] = model.predict_proba(scaler.transform(df[features]))[:, 1]
high_risk_users = df[df['churn_probability'] > 0.7]
print(f"\nHigh-risk users: {len(high_risk_users)}")
```

---

## 10. ML Interview Topics

### Common Questions

**Q1: Explain overfitting and how to prevent it.**
- Answer: Overfitting occurs when a model learns training data too well, including noise, resulting in poor generalization. Prevention: cross-validation, regularization, simpler models, more data, early stopping.

**Q2: When would you use logistic regression vs. random forest?**
- Logistic regression: When interpretability is crucial, relationships are mostly linear, you have limited data
- Random forest: When accuracy is priority, relationships are complex/non-linear, you have sufficient data

**Q3: How do you handle imbalanced classes?**
- Resampling: Oversample minority or undersample majority
- Use appropriate metrics: Precision, recall, F1, ROC-AUC (not accuracy)
- Adjust decision threshold
- Use class weights in algorithm
- Try ensemble methods like random forest

**Q4: Explain the bias-variance tradeoff.**
- Bias: Error from oversimplifying the model (underfitting)
- Variance: Error from model being too sensitive to training data (overfitting)
- Goal: Find optimal complexity that minimizes total error

---

## 11. Best Practices for ML in Analytics

1. **Start simple**: Try logistic regression or decision trees before complex models
2. **Validate rigorously**: Always use cross-validation
3. **Focus on features**: Good features > complex models
4. **Interpret results**: Understand why the model works
5. **Monitor performance**: Models degrade over time, retrain regularly
6. **Consider business context**: 90% accuracy might be great or terrible depending on use case
7. **Document assumptions**: What data, features, and hyperparameters did you use?

---

## 12. Resources for Further Learning

### Online Courses
- [Coursera: Machine Learning by Andrew Ng](https://www.coursera.org/learn/machine-learning)
- [Fast.ai: Practical Deep Learning](https://www.fast.ai/)
- [Kaggle Learn](https://www.kaggle.com/learn)

### Books
- *Hands-On Machine Learning with Scikit-Learn and TensorFlow* by Aurélien Géron
- *The Elements of Statistical Learning* by Hastie, Tibshirani, Friedman
- *Introduction to Machine Learning with Python* by Müller & Guido

### Practice
- [Kaggle Competitions](https://www.kaggle.com/competitions)
- [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/)

---

## Conclusion

Machine Learning enhances analytics by enabling prediction, automation, and discovery of complex patterns. Key takeaways:

- Understand the problem before choosing an algorithm
- Feature engineering often matters more than algorithm choice
- Always validate with cross-validation
- Interpret and communicate results in business terms
- Start simple, add complexity only when needed

ML is a powerful tool in the analyst's toolkit—use it wisely!
