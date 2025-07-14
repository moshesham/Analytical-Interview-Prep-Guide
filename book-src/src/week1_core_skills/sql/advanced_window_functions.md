# Section B: Data Integrity—The Backbone of Reliable Analytics

Data integrity is the foundation of trustworthy analytics. Without it, your insights are built on sand. Here’s how to enforce and maintain it:

## Integrity Constraints
- **NOT NULL:** Ensures a column cannot have missing values. Use for required fields (e.g., primary keys, essential attributes).
- **UNIQUE:** Guarantees all values in a column (or set of columns) are distinct. Useful for email addresses, usernames, etc.
- **PRIMARY KEY:** Uniquely identifies each row. Only one per table, must be NOT NULL and UNIQUE. Prefer surrogate keys for analytics tables to avoid business logic changes breaking your model.
- **FOREIGN KEY:** Enforces referential integrity between tables. Use ON DELETE/UPDATE CASCADE carefully—understand the business impact before enabling automatic changes.
- **CHECK:** Restricts values in a column (e.g., salary > 0). Use for business rules and data quality.
- **ASSERTION:** Cross-table constraints (rarely supported, but powerful for enterprise data integrity).
- **DOMAIN:** Custom data types with built-in constraints (e.g., CREATE DOMAIN email AS VARCHAR(255) CHECK (...)).

**Expert Tips:**
- Always define explicit constraints—don’t rely on application logic alone.
- Use surrogate keys for analytics tables, but document natural keys for business understanding.
- Regularly audit for orphaned records and constraint violations.

## Real-World Example: Enforcing Integrity in a Sales Database
Suppose you have `orders` and `customers` tables. Use a FOREIGN KEY on `orders.customer_id` referencing `customers.customer_id` to ensure every order is linked to a valid customer. Add CHECK constraints to ensure order amounts are positive and dates are valid.

---

# Section C: Advanced SQL Concepts—Power Tools for Analysts

SQL is more than just SELECT and JOIN. Here are advanced concepts every analytics pro should master:

## 1. Common Table Expressions (CTEs)
CTEs (WITH clauses) make complex queries readable and reusable. They’re essential for breaking down multi-step logic, recursive queries, and modular analytics pipelines.

```sql
WITH recent_sales AS (
  SELECT * FROM sales WHERE sale_date > CURRENT_DATE - INTERVAL '30 days'
)
SELECT employee_id, SUM(amount) FROM recent_sales GROUP BY employee_id;
```

## 2. Window Functions (Recap)
Window functions let you calculate running totals, moving averages, and rankings without collapsing your data. Use them for time series, cohort analysis, and advanced reporting.

## 3. Advanced Joins
- **Self-Join:** Compare rows within the same table (e.g., find employees with the same manager).
- **Anti-Join:** Find records in one table not present in another (e.g., customers with no orders).
- **Semi-Join:** Check for existence without duplication (e.g., customers who placed at least one order).

## 4. Subqueries and Nested Logic
Use subqueries for filtering, aggregation, and conditional logic. Prefer CTEs for readability in complex queries.

## 5. Performance Optimization
- **Indexes:** Create on columns used in JOIN, WHERE, and ORDER BY. Monitor and drop unused indexes.
- **Query Plans:** Use EXPLAIN to understand and optimize query execution.
- **Avoid SELECT *:** Only select needed columns to reduce I/O and improve performance.
- **Batch Updates/Inserts:** For large data loads, use bulk operations and disable/rebuild indexes as needed.

## 6. Security and Access Control
- Use roles and privileges to restrict access to sensitive data.
- Grant the least privilege necessary for analytics users.

---


# Advanced Window Functions: Analytics Superpowers in SQL

Welcome to the world of window functions! These tools let you perform calculations across rows—without losing the detail of each row. If you want to do rankings, running totals, or compare each row to its neighbors, this is your new best friend.

---

## 1. What’s a Window Function?

Window functions let you look at a “window” of rows related to the current row. Unlike GROUP BY, you keep all your original rows and add new insights alongside them.

**Scenario:**
Suppose you have a `sales` table:

| sale_id | employee_id | sale_date  | amount |
|---------|-------------|------------|--------|
| 1       | 1           | 2023-01-01 | 500    |
| 2       | 2           | 2023-01-02 | 700    |
| 3       | 1           | 2023-01-03 | 300    |
| 4       | 3           | 2023-01-04 | 900    |

---

## 2. Key Window Functions (with Examples)

### ROW_NUMBER(): Unique Row IDs
```sql
SELECT employee_id, sale_date, amount,
       ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY sale_date) AS sale_num
FROM sales;
```

### RANK() and DENSE_RANK(): Who’s on Top?
```sql
SELECT employee_id, amount,
       RANK() OVER (ORDER BY amount DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank
FROM sales;
```

### LAG() and LEAD(): Peeking at Neighbors
```sql
SELECT sale_date, amount,
       LAG(amount, 1) OVER (ORDER BY sale_date) AS prev_amount,
       LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_amount
FROM sales;
```

---

## 3. Step-by-Step: Running Total Example

```sql
SELECT sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales;
```

**How it works:**
- For each row, SQL adds up all `amount` values up to and including that row (ordered by date).

---

## 4. Try It Yourself!

1. For each employee, show their sales in order, with a running total of their sales.
2. Find the difference between each sale and the previous sale (hint: use LAG).
3. Rank employees by their highest single sale.

---

## 5. Common Pitfalls

- Forgetting to use `ORDER BY` in the window function (results may be meaningless).
- Using window functions in WHERE (they only work in SELECT or ORDER BY).
- Not understanding PARTITION BY: it resets the calculation for each group.

---

## 6. Real-World Use Cases

- **Sales Trends:** Running totals, moving averages.
- **Customer Analytics:** Ranking top customers, finding churn points.
- **Finance:** Year-over-year growth, period comparisons.

---

## 7. Final Thoughts

Window functions are a leap forward in SQL analytics. Practice with real data, and you’ll soon be answering questions your colleagues didn’t even know they could ask!

---

*Congratulations! You’re now ready to tackle real-world analytics with SQL.*


---

## 8. Common SQL Errors: Learn from the Pros

Even seasoned SQL experts make mistakes! Here are the three most common error types and how to avoid them:

### A. Technical Mistakes
- Mishandling NULLs (e.g., forgetting COALESCE in aggregates)
- Incorrect JOIN conditions (accidentally creating a Cartesian product)
- Missing edge cases in query logic

### B. Logical Mistakes
- Misreading the business question (e.g., average vs. sum)
- Overlooking key business rules

### C. Performance Mistakes
- Using inefficient JOINs or subqueries
- Not leveraging indexes
- Neglecting query optimization for large datasets

**Pro Tip:** Always test your queries with edge cases and large datasets!

---

## 9. SQL Analytical Patterns: The Building Blocks

Mastering SQL means recognizing patterns in problems. Here are the essentials:

- **Aggregation & Grouping:** Use GROUP BY, COUNT(), SUM(), etc. to summarize data.
- **Filtering & Selection:** WHERE, AND, OR, IN, BETWEEN, LIKE for precise data retrieval.
- **Self-Joins:** Compare rows within the same table (e.g., employees and managers).
- **Ranking & Ordering:** Use DENSE_RANK(), ROW_NUMBER() for advanced analytics.

---

## 10. Advanced Problem-Solving: Real-World Scenarios

Tough SQL problems often combine multiple patterns:

- **Complex Joins:** Multiple tables, various JOIN types
- **Aggregations:** Multi-level summaries
- **Date & String Manipulation:** Extracting, cleaning, and comparing
- **Window Functions:** For running totals, moving averages, and more

**Business Examples:**
- Engagement Rate Analysis (likes/comments per impression)
- Churn Rate Analysis (user retention over time)
- Time Series & Cohort Analysis (trends, retention)
- Funnel Analysis (user drop-off at each step)

---

## 11. Short-Answer Quiz: Test Your Mastery

1. What’s a common technical mistake related to NULL values?
2. When would you use the HAVING clause?
3. Give an example of a self-join scenario.
4. What’s the difference between DENSE_RANK() and ROW_NUMBER()?
5. Why are indexes important for performance?

---

## 12. Glossary: Speak Like a Pro

- **NULL:** Absence of a value (not zero or empty string)
- **Join:** Combine rows from two or more tables
- **Index:** Data structure for fast lookups
- **Aggregate Function:** Operates on a set of values (e.g., SUM, AVG)
- **Window Function:** Calculates across a set of rows related to the current row
- **Self-Join:** Table joined to itself
- **Churn Rate:** % of users who stop using a product
- **User Engagement Funnel:** Steps users take toward a goal
- **CTE:** Common Table Expression, for modular queries
- **Subquery:** Query within a query

---

Mastering advanced window functions is crucial for performing complex analytical queries in SQL. These functions enhance your ability to derive insights from data without losing the context of individual records. Practice using these functions with real datasets to solidify your understanding and improve your analytical skills.