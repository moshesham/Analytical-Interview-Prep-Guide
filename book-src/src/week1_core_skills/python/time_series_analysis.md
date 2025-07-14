# Time Series Analysis in Python: A Practical Guide

Time series data is everywhere: stock prices, weather records, website traffic, and more. Mastering time series analysis unlocks powerful insights for forecasting, anomaly detection, and trend analysis.

---

## 1. What is Time Series Data?
- **Definition:** Data points collected or recorded at specific time intervals (e.g., daily, monthly, yearly).
- **Examples:** Sales per day, temperature per hour, sensor readings per minute.

---

## 2. Key Concepts
- **Timestamp:** The date/time of each observation.
- **Frequency:** The interval between observations (e.g., hourly, daily).
- **Trend:** Long-term increase or decrease in the data.
- **Seasonality:** Regular, repeating patterns (e.g., higher sales on weekends).
- **Noise:** Random variation not explained by trend or seasonality.

---

## 3. Loading and Preparing Time Series Data
```python
import pandas as pd
# Load data with a datetime column
sales = pd.read_csv('sales.csv', parse_dates=['date'])
sales.set_index('date', inplace=True)
```

---

## 4. Visualization: See the Patterns
```python
import matplotlib.pyplot as plt
sales['revenue'].plot(figsize=(12,6))
plt.title('Revenue Over Time')
plt.xlabel('Date')
plt.ylabel('Revenue')
plt.show()
```

---

## 5. Decomposition: Trend & Seasonality
```python
from statsmodels.tsa.seasonal import seasonal_decompose
result = seasonal_decompose(sales['revenue'], model='additive')
result.plot()
plt.show()
```

---

## 6. Moving Averages & Smoothing
```python
sales['7d_avg'] = sales['revenue'].rolling(window=7).mean()
sales[['revenue', '7d_avg']].plot()
plt.show()
```

---

## 7. Forecasting (Intro)
```python
from statsmodels.tsa.arima.model import ARIMA
model = ARIMA(sales['revenue'], order=(1,1,1))
model_fit = model.fit()
pred = model_fit.forecast(steps=7)
print(pred)
```

---

## 8. Handling Missing Data & Outliers
```python
sales['revenue'].interpolate(method='time', inplace=True)
# Outlier detection (simple z-score)
import numpy as np
from scipy import stats
z = np.abs(stats.zscore(sales['revenue']))
sales = sales[z < 3]
```

---

## 9. Best Practices
- Always visualize before modeling.
- Check for stationarity (use ADF test).
- Use domain knowledge for feature engineering (e.g., holidays).
- Document assumptions and preprocessing steps.

---

## 10. Further Resources
- [pandas Documentation](https://pandas.pydata.org/docs/)
- [statsmodels Time Series](https://www.statsmodels.org/stable/tsa.html)
- [Forecasting: Principles and Practice (Book)](https://otexts.com/fpp3/)

---

Time series analysis is a deep field—this guide is your launchpad. Practice with real data and keep exploring!
