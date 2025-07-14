# SQL Fundamentals

## Introduction
This document covers the foundational concepts of SQL, which is essential for data analysis and manipulation. Understanding these basics will provide a solid groundwork for more advanced SQL topics.

## Basic SQL Concepts

### What is SQL?
SQL (Structured Query Language) is a standard programming language specifically designed for managing and manipulating relational databases. It allows users to perform various operations such as querying data, updating records, and managing database structures.

### Key Components of SQL
1. **Database**: A structured collection of data.
2. **Table**: A set of data organized in rows and columns within a database.
3. **Row**: A single record in a table.
4. **Column**: A field in a table that holds a specific type of data.

## Basic Queries

### SELECT Statement
The `SELECT` statement is used to query data from a database. The basic syntax is:
```sql
SELECT column1, column2 FROM table_name;
```
Example:
```sql
SELECT first_name, last_name FROM employees;
```

### WHERE Clause
The `WHERE` clause is used to filter records based on specific conditions.
```sql
SELECT column1, column2 FROM table_name WHERE condition;
```
Example:
```sql
SELECT * FROM employees WHERE department = 'Sales';
```

### ORDER BY Clause
The `ORDER BY` clause is used to sort the result set in ascending or descending order.
```sql
SELECT column1, column2 FROM table_name ORDER BY column1 ASC|DESC;
```
Example:
```sql
SELECT * FROM employees ORDER BY last_name ASC;
```

## Data Types
Understanding data types is crucial for defining the nature of data stored in each column. Common SQL data types include:
- **INT**: Integer values.
- **VARCHAR(n)**: Variable-length string with a maximum length of n.
- **DATE**: Date values.

## Simple Functions
SQL provides several built-in functions to perform calculations on data.

### COUNT()
The `COUNT()` function returns the number of rows that match a specified criterion.
```sql
SELECT COUNT(*) FROM employees WHERE department = 'Sales';
```

### AVG()
The `AVG()` function calculates the average value of a numeric column.
```sql
SELECT AVG(salary) FROM employees;
```

### SUM()
The `SUM()` function returns the total sum of a numeric column.
```sql
SELECT SUM(salary) FROM employees WHERE department = 'Sales';
```

## Conclusion
Mastering these foundational SQL concepts is essential for progressing to more complex queries and database operations. Practice these queries and familiarize yourself with the syntax to build a strong SQL skill set.