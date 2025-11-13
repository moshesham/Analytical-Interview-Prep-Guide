# SQL Query Optimization and Performance

Writing correct SQL queries is essential, but writing *efficient* SQL is what separates good analysts from great ones. This guide covers optimization techniques to make your queries faster and more scalable.

---

## 1. Understanding Query Execution

### How SQL Queries Are Executed

1. **Parsing**: SQL syntax is checked
2. **Optimization**: Query optimizer chooses execution plan
3. **Execution**: Query plan is executed
4. **Return**: Results are returned

**Key Insight**: The optimizer tries to find the most efficient way to execute your query, but you can help by writing optimized SQL.

### EXPLAIN Plans

Use `EXPLAIN` to see how the database will execute your query:

```sql
-- PostgreSQL/MySQL
EXPLAIN SELECT * FROM users WHERE city = 'New York';

-- Shows: Sequential Scan vs Index Scan, estimated rows, cost
```

**Look for**:
- Sequential Scans on large tables (bad - means full table scan)
- Index Scans (good - means using index)
- High estimated row counts
- Nested loops vs Hash joins

---

## 2. Indexing: The Performance Multiplier

### What Are Indexes?

Indexes are data structures that allow fast lookups, similar to a book's index.

**Without Index**: Full table scan - O(n)
**With Index**: Index lookup - O(log n)

### When to Create Indexes

✓ **Create indexes on**:
- Columns in WHERE clauses
- Columns in JOIN conditions
- Columns in ORDER BY
- Foreign keys

✗ **Avoid indexes on**:
- Small tables (< 1000 rows)
- Columns with low cardinality (few unique values)
- Columns that are frequently updated
- Tables with high insert/update volume

### Creating Indexes

```sql
-- Single column index
CREATE INDEX idx_users_city ON users(city);

-- Composite index (order matters!)
CREATE INDEX idx_users_city_age ON users(city, age);

-- Unique index
CREATE UNIQUE INDEX idx_users_email ON users(email);

-- Partial index (PostgreSQL)
CREATE INDEX idx_active_users ON users(last_login) 
WHERE is_active = true;
```

### Index Best Practices

1. **Leftmost prefix rule**: For composite indexes, use in order
   ```sql
   -- Index on (city, age) helps:
   WHERE city = 'NYC'  -- ✓ Uses index
   WHERE city = 'NYC' AND age > 25  -- ✓ Uses full index
   WHERE age > 25  -- ✗ Can't use index
   ```

2. **Covering indexes**: Include all columns needed in query
   ```sql
   CREATE INDEX idx_users_covering 
   ON users(city, age, name, email);
   
   -- This query uses only the index, no table lookup needed
   SELECT name, email 
   FROM users 
   WHERE city = 'NYC' AND age > 25;
   ```

3. **Index maintenance**: Rebuild/analyze periodically
   ```sql
   -- PostgreSQL
   REINDEX INDEX idx_users_city;
   ANALYZE users;
   
   -- MySQL
   OPTIMIZE TABLE users;
   ```

---

## 3. Query Optimization Techniques

### Use SELECT columns instead of SELECT *

```sql
-- BAD: Transfers unnecessary data
SELECT * FROM users WHERE city = 'NYC';

-- GOOD: Only select what you need
SELECT user_id, name, email FROM users WHERE city = 'NYC';
```

**Why it matters**: Reduces I/O, memory usage, and network transfer.

### WHERE vs HAVING

```sql
-- BAD: HAVING filters after aggregation (processes more rows)
SELECT city, COUNT(*) 
FROM users 
GROUP BY city 
HAVING city = 'NYC';

-- GOOD: WHERE filters before aggregation
SELECT city, COUNT(*) 
FROM users 
WHERE city = 'NYC' 
GROUP BY city;
```

### Avoid Functions on Indexed Columns

```sql
-- BAD: Can't use index on created_at
SELECT * FROM orders 
WHERE YEAR(created_at) = 2024;

-- GOOD: Index can be used
SELECT * FROM orders 
WHERE created_at >= '2024-01-01' 
  AND created_at < '2025-01-01';
```

### Use LIMIT for Large Result Sets

```sql
-- Add LIMIT when you don't need all rows
SELECT * FROM users 
ORDER BY created_at DESC 
LIMIT 100;

-- Paginate large results
SELECT * FROM users 
ORDER BY user_id 
LIMIT 100 OFFSET 0;  -- First page
```

### Avoid SELECT DISTINCT When Possible

```sql
-- BAD: DISTINCT is expensive
SELECT DISTINCT category FROM products;

-- GOOD: GROUP BY is often faster
SELECT category FROM products GROUP BY category;

-- BETTER: If you just need existence check
SELECT category FROM products LIMIT 1;
```

---

## 4. JOIN Optimization

### Join Order Matters

The query optimizer usually handles this, but understanding helps:

```sql
-- Join smaller tables first
SELECT o.order_id, u.name
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.created_at >= '2024-01-01'  -- Filters orders first
  AND u.country = 'US';
```

### Use INNER JOIN Over Subqueries

```sql
-- BAD: Subquery runs for each row
SELECT name 
FROM users 
WHERE user_id IN (
    SELECT user_id FROM orders WHERE amount > 100
);

-- GOOD: JOIN is more efficient
SELECT DISTINCT u.name 
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
WHERE o.amount > 100;

-- EVEN BETTER: EXISTS for existence check
SELECT u.name 
FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.user_id = u.user_id AND o.amount > 100
);
```

### Avoid Cartesian Products

```sql
-- BAD: Cartesian product (every row with every row)
SELECT * 
FROM table1, table2;

-- GOOD: Explicit JOIN with condition
SELECT * 
FROM table1 
JOIN table2 ON table1.id = table2.table1_id;
```

---

## 5. Subquery Optimization

### Use CTEs for Readability and Performance

```sql
-- CTE (Common Table Expression)
WITH active_users AS (
    SELECT user_id, name 
    FROM users 
    WHERE is_active = true
),
high_value_orders AS (
    SELECT user_id, SUM(amount) as total
    FROM orders
    WHERE amount > 100
    GROUP BY user_id
)
SELECT u.name, o.total
FROM active_users u
JOIN high_value_orders o ON u.user_id = o.user_id;
```

**Benefits**: 
- More readable
- Can be referenced multiple times
- Optimizer can optimize better

### Avoid Correlated Subqueries

```sql
-- BAD: Correlated subquery (runs for each row)
SELECT name,
    (SELECT COUNT(*) FROM orders WHERE user_id = users.user_id) as order_count
FROM users;

-- GOOD: Join with aggregation
SELECT u.name, COUNT(o.order_id) as order_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name;
```

---

## 6. Aggregation Optimization

### Filter Before Aggregating

```sql
-- BAD: Aggregates then filters
SELECT category, AVG(price)
FROM products
GROUP BY category
HAVING category IN ('Electronics', 'Books');

-- GOOD: Filters then aggregates
SELECT category, AVG(price)
FROM products
WHERE category IN ('Electronics', 'Books')
GROUP BY category;
```

### Use Covering Indexes for Aggregations

```sql
-- Create index
CREATE INDEX idx_products_cat_price ON products(category, price);

-- This query can use the index for both GROUP BY and AVG
SELECT category, AVG(price)
FROM products
GROUP BY category;
```

---

## 7. Working with Large Datasets

### Partition Large Tables

```sql
-- PostgreSQL partitioning by date range
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    amount DECIMAL
) PARTITION BY RANGE (order_date);

CREATE TABLE orders_2024_q1 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE orders_2024_q2 PARTITION OF orders
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');
```

**Benefits**: 
- Queries only scan relevant partitions
- Faster data loading/deletion
- Better index performance

### Batch Processing for Large Updates

```sql
-- BAD: Update all at once (locks table)
UPDATE users SET last_login = CURRENT_TIMESTAMP 
WHERE is_active = true;

-- GOOD: Batch updates
UPDATE users SET last_login = CURRENT_TIMESTAMP 
WHERE is_active = true 
  AND user_id IN (
    SELECT user_id FROM users 
    WHERE is_active = true 
    LIMIT 10000
  );
-- Repeat until all rows updated
```

### Use Appropriate Data Types

```sql
-- BAD: VARCHAR(255) for everything
CREATE TABLE users (
    id VARCHAR(255),  -- Bad: Should be INT
    age VARCHAR(255),  -- Bad: Should be INT
    is_active VARCHAR(255)  -- Bad: Should be BOOLEAN
);

-- GOOD: Use specific types
CREATE TABLE users (
    id INT PRIMARY KEY,
    age INT,
    is_active BOOLEAN
);
```

**Why it matters**: Smaller data types = less storage, faster queries, better indexes.

---

## 8. Window Functions Optimization

### Use Window Functions Instead of Self-Joins

```sql
-- BAD: Self-join for ranking
SELECT a.*, COUNT(b.order_id) as rank
FROM orders a
LEFT JOIN orders b ON a.amount <= b.amount AND a.category = b.category
GROUP BY a.order_id;

-- GOOD: Window function
SELECT *,
    RANK() OVER (PARTITION BY category ORDER BY amount DESC) as rank
FROM orders;
```

### Reuse Window Definitions

```sql
-- Define window once, use multiple times
SELECT 
    order_id,
    amount,
    AVG(amount) OVER w as avg_amount,
    RANK() OVER w as rank
FROM orders
WINDOW w AS (PARTITION BY category ORDER BY amount DESC);
```

---

## 9. Query Analysis Example

### Problem: Slow Query

```sql
-- Original slow query (10 seconds)
SELECT 
    u.name,
    COUNT(o.order_id) as order_count,
    SUM(o.amount) as total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.created_at >= '2024-01-01'
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC
LIMIT 100;
```

### Step 1: Check EXPLAIN plan

```sql
EXPLAIN SELECT ...
-- Shows: Sequential Scan on users (bad!)
--        Sequential Scan on orders (bad!)
```

### Step 2: Add Indexes

```sql
-- Index on users.created_at for WHERE clause
CREATE INDEX idx_users_created ON users(created_at);

-- Index on orders.user_id for JOIN
CREATE INDEX idx_orders_user ON orders(user_id);

-- Composite index for orders aggregation
CREATE INDEX idx_orders_user_amount ON orders(user_id, amount);
```

### Step 3: Optimize Query

```sql
-- Optimized query (0.5 seconds)
WITH filtered_users AS (
    SELECT user_id, name
    FROM users
    WHERE created_at >= '2024-01-01'
),
order_aggregates AS (
    SELECT 
        user_id,
        COUNT(*) as order_count,
        SUM(amount) as total_spent
    FROM orders
    WHERE user_id IN (SELECT user_id FROM filtered_users)
    GROUP BY user_id
)
SELECT 
    u.name,
    COALESCE(o.order_count, 0) as order_count,
    COALESCE(o.total_spent, 0) as total_spent
FROM filtered_users u
LEFT JOIN order_aggregates o ON u.user_id = o.user_id
ORDER BY total_spent DESC
LIMIT 100;
```

**Improvements**:
1. Filter users first (reduces join size)
2. Pre-aggregate orders
3. Added indexes
4. Used CTE for clarity

---

## 10. Performance Testing

### Benchmarking Queries

```sql
-- PostgreSQL: Show query execution time
\timing on

-- Run query multiple times
SELECT ... ;
-- Time: 234.567 ms

-- Compare with optimized version
SELECT ... ;
-- Time: 45.678 ms
```

### Analyze Table Statistics

```sql
-- Update statistics for better query plans
ANALYZE users;
ANALYZE orders;

-- View statistics
SELECT * FROM pg_stats WHERE tablename = 'users';
```

### Monitor Long-Running Queries

```sql
-- PostgreSQL: Find slow queries
SELECT 
    pid,
    now() - query_start as duration,
    query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY duration DESC;

-- Kill long-running query
SELECT pg_terminate_backend(pid);
```

---

## 11. Common Performance Antipatterns

### Antipattern 1: N+1 Queries

```python
# BAD: Separate query for each user
for user_id in user_ids:
    orders = db.execute(
        "SELECT * FROM orders WHERE user_id = ?", 
        user_id
    )

# GOOD: Single query with IN clause
orders = db.execute(
    "SELECT * FROM orders WHERE user_id IN (?)",
    user_ids
)
```

### Antipattern 2: Using OR on Different Columns

```sql
-- BAD: Can't use indexes efficiently
SELECT * FROM users 
WHERE email = 'test@example.com' 
   OR username = 'testuser';

-- GOOD: Use UNION
SELECT * FROM users WHERE email = 'test@example.com'
UNION
SELECT * FROM users WHERE username = 'testuser';
```

### Antipattern 3: Implicit Type Conversion

```sql
-- BAD: String column, numeric comparison (can't use index)
SELECT * FROM users WHERE user_id_str = 123;

-- GOOD: Match types
SELECT * FROM users WHERE user_id_str = '123';
```

---

## 12. Database-Specific Tips

### PostgreSQL
- Use `EXPLAIN (ANALYZE, BUFFERS)` for detailed plans
- Vacuum regularly: `VACUUM ANALYZE`
- Use `pg_stat_statements` for query performance tracking

### MySQL
- Use `EXPLAIN FORMAT=JSON` for detailed plans
- Optimize tables regularly
- Use Query Profiler: `SET profiling = 1; SHOW PROFILES;`

### BigQuery (Cloud)
- Partition tables by date
- Cluster tables by frequently filtered columns
- Use `_PARTITIONTIME` for partition pruning
- Avoid `SELECT *` (costs based on data scanned)

---

## 13. Optimization Checklist

Before deploying a query to production:

- [ ] SELECT only needed columns (no `SELECT *`)
- [ ] Filter early with WHERE (not HAVING)
- [ ] Indexes exist on JOIN columns
- [ ] Indexes exist on WHERE columns
- [ ] Avoid functions on indexed columns
- [ ] Use EXISTS instead of IN for subqueries
- [ ] Use LIMIT for large result sets
- [ ] Check EXPLAIN plan
- [ ] Benchmark query performance
- [ ] Consider partitioning for very large tables
- [ ] Use appropriate data types
- [ ] Update table statistics regularly

---

## 14. Interview Questions

**Q1: How would you optimize a slow query?**
1. Run EXPLAIN to see execution plan
2. Check for sequential scans on large tables
3. Add indexes on WHERE/JOIN columns
4. Rewrite query to filter early
5. Consider partitioning for huge tables
6. Benchmark before and after

**Q2: What's the difference between WHERE and HAVING?**
- WHERE filters before aggregation (faster, can use indexes)
- HAVING filters after aggregation (slower, can't use indexes on aggregated columns)

**Q3: When would you NOT create an index?**
- Small tables (< 1000 rows)
- Columns with low cardinality (e.g., boolean, gender)
- Frequently updated columns (index maintenance overhead)
- Tables with high insert volume

**Q4: Explain how indexes work.**
- Indexes are data structures (typically B-trees) that allow fast lookups
- Trade-off: Faster reads, slower writes
- Similar to a book's index - jump directly to page instead of scanning all pages

---

## Conclusion

Query optimization is both art and science:
- **Art**: Understanding data patterns, query patterns, and business needs
- **Science**: Using EXPLAIN plans, benchmarks, and indexing strategies

**Key Principles**:
1. Measure first (EXPLAIN, timing)
2. Index strategically
3. Filter early, aggregate late
4. Select only what you need
5. Test and benchmark

**Remember**: Premature optimization is the root of all evil. Optimize queries that are actually slow and matter to the business!
