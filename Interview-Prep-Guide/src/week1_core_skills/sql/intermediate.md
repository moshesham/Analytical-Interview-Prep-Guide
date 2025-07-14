# Intermediate SQL Concepts

This document covers intermediate SQL topics that are essential for building a solid understanding of SQL beyond the basics. The focus will be on JOIN operations, GROUP BY clauses, and HAVING statements.

## 1. JOIN Operations

JOIN operations are used to combine rows from two or more tables based on a related column between them. Understanding how to use different types of JOINs is crucial for querying relational databases effectively.

### Types of JOINs:

- **INNER JOIN**: Returns records that have matching values in both tables.
- **LEFT JOIN (or LEFT OUTER JOIN)**: Returns all records from the left table and the matched records from the right table. If there is no match, NULL values are returned for columns from the right table.
- **RIGHT JOIN (or RIGHT OUTER JOIN)**: Returns all records from the right table and the matched records from the left table. If there is no match, NULL values are returned for columns from the left table.
- **FULL JOIN (or FULL OUTER JOIN)**: Returns all records when there is a match in either left or right table records. If there is no match, NULL values are returned for non-matching columns.

### Example:

```sql
SELECT 
    a.column1, 
    b.column2
FROM 
    table_a a
INNER JOIN 
    table_b b ON a.common_column = b.common_column;
```

## 2. GROUP BY Clause

The GROUP BY clause is used to arrange identical data into groups. It is often used with aggregate functions (like COUNT, SUM, AVG) to perform operations on each group of data.

### Syntax:

```sql
SELECT 
    column1, 
    aggregate_function(column2)
FROM 
    table_name
GROUP BY 
    column1;
```

### Example:

```sql
SELECT 
    department, 
    COUNT(*) AS employee_count
FROM 
    employees
GROUP BY 
    department;
```

## 3. HAVING Statement

The HAVING statement is used to filter records that work on summarized GROUP BY results. It is similar to the WHERE clause but is used for aggregate functions.

### Syntax:

```sql
SELECT 
    column1, 
    aggregate_function(column2)
FROM 
    table_name
GROUP BY 
    column1
HAVING 
    condition;
```

### Example:

```sql
SELECT 
    department, 
    COUNT(*) AS employee_count
FROM 
    employees
GROUP BY 
    department
HAVING 
    COUNT(*) > 10;
```

## Conclusion

Mastering these intermediate SQL concepts will enhance your ability to analyze and manipulate data effectively. Practice writing queries that utilize JOINs, GROUP BY, and HAVING to solidify your understanding.