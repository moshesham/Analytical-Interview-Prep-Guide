
# SQL Fundamentals: Building Your Data Superpower

Welcome! In this lesson, we’ll lay the foundation for your SQL journey. Whether you’re wrangling sales data or analyzing customer trends, these basics will empower you to ask—and answer—real business questions.

---

## 1. What is SQL, Really?

SQL (Structured Query Language) is the universal language for working with relational databases. Think of it as the bridge between you and the vast world of data stored in tables.

**Real-World Analogy:** Imagine a library. The database is the library, tables are the bookshelves, rows are the books, and columns are the information on each book (title, author, genre).

---

## 2. Key Concepts

- **Database:** A collection of related data (like a library).
- **Table:** A grid of data (like a spreadsheet or bookshelf).
- **Row:** A single record (like one book).
- **Column:** A field describing an attribute (like the author or title).

---

## 3. Your First Queries

Let’s use a simple `employees` table:

| employee_id | first_name | last_name | department | hire_date  | salary  |
|-------------|------------|-----------|------------|------------|---------|
| 1           | Alice      | Smith     | Sales      | 2020-01-15 | 70000   |
| 2           | Bob        | Lee       | Marketing  | 2019-03-22 | 65000   |
| 3           | Carol      | Jones     | Sales      | 2021-07-01 | 72000   |

### SELECT: Grabbing Data

```sql
SELECT first_name, last_name FROM employees;
```

### WHERE: Filtering Results

```sql
SELECT * FROM employees WHERE department = 'Sales';
```

### ORDER BY: Sorting Results

```sql
SELECT * FROM employees ORDER BY salary DESC;
```

### LIMIT (or TOP): Just a Few, Please

```sql
-- For MySQL/Postgres
SELECT * FROM employees LIMIT 2;

-- For SQL Server
SELECT TOP 2 * FROM employees;
```

---

## 4. Data Types: Getting Specific

| Data Type    | Example         | Description                       |
|--------------|----------------|-----------------------------------|
| INT          | 42             | Whole numbers                     |
| VARCHAR(50)  | 'Alice'        | Text, up to 50 characters         |
| DATE         | '2023-07-14'   | Calendar dates                    |
| DECIMAL(8,2) | 12345.67       | Numbers with decimals             |

---

## 5. Simple Functions: Doing More with Data

### COUNT: How Many?

```sql
SELECT COUNT(*) FROM employees WHERE department = 'Sales';
```

### SUM, AVG, MIN, MAX: Math Made Easy

```sql
SELECT SUM(salary) AS total_payroll FROM employees;
SELECT AVG(salary) AS avg_salary FROM employees;
SELECT MIN(hire_date) AS first_hire FROM employees;
```

---

## 6. Try It Yourself!

1. Write a query to find all employees hired after 2020-01-01.
2. List the names and salaries of employees in the Marketing department, sorted by salary descending.
3. Count how many employees have a salary above 70,000.

---

## 7. Common Mistakes (and How to Avoid Them)

- Forgetting the semicolon (`;`) at the end of a statement (some systems require it).
- Misspelling table or column names.
- Using single `=` instead of `==` in WHERE (SQL uses `=` for equality).
- Not using quotes for text values: `department = 'Sales'` (not `department = Sales`).

---

## 8. Final Thoughts

SQL is a skill you build by doing. Don’t just read—experiment! The more you practice, the more fluent you’ll become in speaking the language of data.

---

*Next up: Intermediate SQL—combining tables and unlocking deeper insights!*
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