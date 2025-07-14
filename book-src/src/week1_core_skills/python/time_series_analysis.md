
# Time Series Analysis in Python: From Fundamentals to Forecasting

Time series data is the heartbeat of business, science, and technology—think stock prices, weather, IoT sensors, and web traffic. Mastering time series unlocks forecasting, anomaly detection, and trend discovery. This guide blends practical code, expert tips, and real-world context.

---

## 1. What is Time Series Data?

- **Definition:** Data points indexed in time order, usually at regular intervals (e.g., daily, hourly).
- **Examples:** Sales per day, temperature per hour, website visits per minute, heart rate per second.

**Why it matters:** Time adds structure—patterns, cycles, and causality—that you can’t see in unordered data.

---

## 2. Key Concepts & Vocabulary

- **Timestamp:** The date/time of each observation.
- **Frequency:** How often data is recorded (hourly, daily, etc.).
- **Trend:** Long-term movement (up, down, flat).
- **Seasonality:** Regular, repeating patterns (e.g., weekends, holidays).
- **Cyclicality:** Irregular, but recurring, patterns (e.g., business cycles).
- **Noise:** Random variation.
- **Stationarity:** Statistical properties (mean, variance) do not change over time. Many models require this.

---

## 3. Loading, Indexing, and Resampling

```python
import pandas as pd
# Load data
df = pd.read_csv('sales.csv', parse_dates=['date'])
df.set_index('date', inplace=True)
# Resample to daily frequency (if needed)
df = df.resample('D').sum()
```

**Expert tip:** Always set your datetime column as the index for time series operations.

---

## 4. Exploratory Visualization: See the Patterns

```python
import matplotlib.pyplot as plt
df['revenue'].plot(figsize=(12,6), title='Revenue Over Time')
plt.xlabel('Date')
plt.ylabel('Revenue')
plt.show()
```

**Try:** Plot rolling means, highlight holidays, or overlay events for richer context.

---

## 5. Decomposition: Trend, Seasonality, Residuals

```python
from statsmodels.tsa.seasonal import seasonal_decompose
result = seasonal_decompose(df['revenue'], model='additive')
result.plot()
plt.show()
```

**Interpret:** Trend = long-term movement; Seasonal = repeating cycles; Residual = what’s left (noise, anomalies).

---

## 6. Smoothing & Moving Averages

```python
df['7d_avg'] = df['revenue'].rolling(window=7).mean()
df[['revenue', '7d_avg']].plot()
plt.title('Revenue and 7-Day Moving Average')
plt.show()
```

**Why smooth?** To reveal underlying patterns and reduce noise.

---

## 7. Handling Missing Data & Outliers

```python
# Interpolate missing values
df['revenue'] = df['revenue'].interpolate(method='time')
# Outlier detection (z-score)
import numpy as np
from scipy import stats
z = np.abs(stats.zscore(df['revenue']))
df = df[z < 3]
```

**Pro tip:** Always visualize before and after cleaning. Outliers can be signals, not just errors!

---

## 8. Stationarity & Differencing

Many models (ARIMA, SARIMA) require stationary data.

```python
from statsmodels.tsa.stattools import adfuller
result = adfuller(df['revenue'])
print('ADF Statistic:', result[0])
print('p-value:', result[1])
# If not stationary, difference the series
df['revenue_diff'] = df['revenue'].diff().dropna()
```

---

## 9. Forecasting: ARIMA (Intro)

```python
from statsmodels.tsa.arima.model import ARIMA
model = ARIMA(df['revenue'], order=(1,1,1))
model_fit = model.fit()
pred = model_fit.forecast(steps=7)
print(pred)
```

**Next steps:** Try SARIMA for seasonality, or Prophet for business-friendly forecasting.

---

## 10. Real-World Scenarios & Advanced Tips

- **Retail:** Forecast sales for inventory planning.
- **Finance:** Detect anomalies in stock prices.
- **IoT:** Monitor sensor data for equipment failure.
- **Web Analytics:** Spot traffic spikes and dips.

**Advanced:**
- Use lag features (previous values as predictors).
- Engineer calendar features (day of week, holidays).
- Try anomaly detection with rolling z-scores or isolation forests.

---

## 11. Common Pitfalls
- Ignoring missing timestamps (can break models).
- Overfitting to noise—always validate forecasts.
- Forgetting to reverse transformations (e.g., differencing) before interpreting results.

---

## 12. Hands-On Challenge
1. Download a real time series dataset (e.g., [AirPassengers](https://raw.githubusercontent.com/jbrownlee/Datasets/master/airline-passengers.csv)).
2. Load, visualize, decompose, clean, and forecast.
3. Document your process and share your insights.

---

## 13. Further Resources
- [pandas Documentation](https://pandas.pydata.org/docs/)
- [statsmodels Time Series](https://www.statsmodels.org/stable/tsa.html)
- [Prophet Forecasting Tool](https://facebook.github.io/prophet/)
- [Forecasting: Principles and Practice (Book)](https://otexts.com/fpp3/)

---

Time series analysis is a journey—practice, experiment, and always keep learning. The best insights come from curiosity and iteration!
