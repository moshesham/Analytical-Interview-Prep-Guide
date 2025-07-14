# Advanced Window Functions in SQL

## Overview

Advanced window functions in SQL allow you to perform calculations across a set of table rows that are related to the current row. Unlike regular aggregate functions, window functions do not collapse the result set; instead, they provide additional insights while retaining the original rows.

## Key Window Functions

1. **RANK()**
   - Assigns a unique rank to each row within a partition of a result set, with gaps in the ranking for ties.
   - Example: `RANK() OVER (PARTITION BY department ORDER BY salary DESC)`

2. **DENSE_RANK()**
   - Similar to RANK(), but without gaps in the ranking for ties.
   - Example: `DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC)`

3. **ROW_NUMBER()**
   - Assigns a unique sequential integer to rows within a partition of a result set, starting at 1 for the first row.
   - Example: `ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC)`

4. **LAG()**
   - Accesses data from a previous row in the same result set without the use of a self-join.
   - Example: `LAG(salary, 1) OVER (ORDER BY hire_date)`

5. **LEAD()**
   - Accesses data from a subsequent row in the same result set.
   - Example: `LEAD(salary, 1) OVER (ORDER BY hire_date)`

## Use Cases

- **Running Totals**: Calculate cumulative sums over a set of rows.
- **Moving Averages**: Compute averages over a specified range of rows.
- **Comparative Analysis**: Compare current row values with previous or next row values.

## Example Queries

### Example 1: Ranking Employees by Salary

```sql
SELECT 
    employee_id, 
    salary, 
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM 
    employees;
```

### Example 2: Calculating Year-over-Year Growth

```sql
SELECT 
    year, 
    revenue, 
    LAG(revenue, 1) OVER (ORDER BY year) AS previous_year_revenue,
    (revenue - LAG(revenue, 1) OVER (ORDER BY year)) / LAG(revenue, 1) OVER (ORDER BY year) AS growth_rate
FROM 
    financials;
```

## Conclusion

Mastering advanced window functions is crucial for performing complex analytical queries in SQL. These functions enhance your ability to derive insights from data without losing the context of individual records. Practice using these functions with real datasets to solidify your understanding and improve your analytical skills.