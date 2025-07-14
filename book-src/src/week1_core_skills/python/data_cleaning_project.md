df = df[(np.abs(stats.zscore(df['numeric_column'])) < 3)]  # Example using Z-score

# Python for Data Analytics: A Practical, Expert Guide

Python is the Swiss Army knife of data analytics. With the right tools and mindset, you can wrangle, explore, visualize, and model data with confidence. This guide goes beyond basic cleaning—let’s build a full analytics workflow, with best practices from years in the field.

---

## 1. The Analytics Workflow in Python

1. **Data Acquisition**: Load data from CSV, Excel, SQL, APIs, or web scraping.
2. **Exploratory Data Analysis (EDA)**: Understand structure, spot issues, and generate hypotheses.
3. **Data Cleaning**: Handle missing values, outliers, and inconsistencies.
4. **Feature Engineering**: Create new variables, encode categories, extract dates, etc.
5. **Visualization**: Use plots to reveal patterns and communicate findings.
6. **Modeling & Evaluation**: (Optional) Build and assess predictive models.
7. **Automation & Reproducibility**: Use scripts, notebooks, and version control.

---

## 2. Data Acquisition: Getting Data In

```python
import pandas as pd
# CSV
df = pd.read_csv('data.csv')
# Excel
df = pd.read_excel('data.xlsx')
# SQL
# import sqlalchemy
# engine = sqlalchemy.create_engine('sqlite:///mydb.sqlite')
# df = pd.read_sql('SELECT * FROM table', engine)
```

---

## 3. Exploratory Data Analysis (EDA)

```python
print(df.head())
print(df.info())
print(df.describe(include='all'))
print(df.isnull().sum())
print(df.nunique())
```

**Pro Tips:**
- Use `df.sample(5)` to spot-check data.
- Use `df.value_counts()` for categorical columns.
- Visualize distributions with `df['col'].hist()` or `df.boxplot(column='col')`.

---

## 4. Data Cleaning: From Messy to Usable

### Handling Missing Values
```python
# Drop rows with missing values
df.dropna(inplace=True)
# Fill with mean/median/mode
df['age'].fillna(df['age'].median(), inplace=True)
# Fill categorical with most common
df['city'].fillna(df['city'].mode()[0], inplace=True)
```

### Removing Duplicates
```python
df.drop_duplicates(inplace=True)
```

### Data Type Conversion
```python
df['date'] = pd.to_datetime(df['date'])
df['category'] = df['category'].astype('category')
```

### Outlier Detection & Treatment
```python
import numpy as np
from scipy import stats
z = np.abs(stats.zscore(df['income']))
df = df[z < 3]
```

---

## 5. Feature Engineering: Creating Value

```python
# Extract year from date
df['year'] = df['date'].dt.year
# Encode categories
df = pd.get_dummies(df, columns=['gender', 'city'])
# Create interaction features
df['income_per_age'] = df['income'] / df['age']
```

---

## 6. Visualization: See the Story

```python
import matplotlib.pyplot as plt
import seaborn as sns
sns.histplot(df['income'])
plt.show()
sns.boxplot(x='gender', y='income', data=df)
plt.show()
```

---

## 7. Automation & Reproducibility

- Use Jupyter notebooks for exploration and storytelling.
- Save scripts for repeatable pipelines.
- Use version control (git) for code and data.
- Document every step—future you (and your team) will thank you.

---

## 8. Best Practices from the Field

- Always check data types and missing values first.
- Never trust external data—validate everything.
- Visualize before and after cleaning.
- Write modular, reusable code (functions, classes).
- Use assertions and tests for critical steps.
- Keep raw and cleaned data separate.
- Communicate findings with clear visuals and concise summaries.

---

## 9. Hands-On Challenge

1. Download a real-world dataset (Kaggle, UCI, etc.).
2. Apply the full workflow: load, explore, clean, engineer features, visualize.
3. Document your process and share your insights.

---

## 10. Further Resources

- [Pandas Documentation](https://pandas.pydata.org/docs/)
- [Seaborn Documentation](https://seaborn.pydata.org/)
- [Scikit-learn User Guide](https://scikit-learn.org/stable/user_guide.html)
- [Effective Python for Data Analysis (Book)](https://wesmckinney.com/book/)

---

Python is a powerful ally for any data analyst. Master these tools and workflows, and you’ll be ready for any data challenge—today and in the future.