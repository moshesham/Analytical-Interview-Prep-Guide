
# Intermediate SQL: Joining Forces & Grouping for Insight

Welcome back! Now that you’re comfortable with the basics, let’s unlock the real power of SQL: combining tables and summarizing data. This is where SQL starts to feel like magic.

---

## 1. JOIN Operations: Bringing Data Together

Imagine you have two tables:

**employees**
| employee_id | first_name | department_id |
|-------------|------------|--------------|
| 1           | Alice      | 10           |
| 2           | Bob        | 20           |
| 3           | Carol      | 10           |

**departments**
| department_id | department_name |
|---------------|----------------|
| 10            | Sales          |
| 20            | Marketing      |

### Types of JOINs (with Examples)

- **INNER JOIN**: Only rows with matches in both tables.

    ```sql
    SELECT e.first_name, d.department_name
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id;
    ```

- **LEFT JOIN**: All rows from the left table, matched rows from the right (NULL if no match).

    ```sql
    SELECT e.first_name, d.department_name
    FROM employees e
    LEFT JOIN departments d ON e.department_id = d.department_id;
    ```

- **RIGHT JOIN**: All rows from the right table, matched rows from the left (NULL if no match).

    ```sql
    SELECT e.first_name, d.department_name
    FROM employees e
    RIGHT JOIN departments d ON e.department_id = d.department_id;
    ```

- **FULL OUTER JOIN**: All rows from both tables, matched where possible.

    ```sql
    SELECT e.first_name, d.department_name
    FROM employees e
    FULL OUTER JOIN departments d ON e.department_id = d.department_id;
    ```

- **CROSS JOIN**: Every row from the first table with every row from the second (use with caution!).

    ```sql
    SELECT e.first_name, d.department_name
    FROM employees e
    CROSS JOIN departments d;
    ```

- **Self-Join**: Joining a table to itself (e.g., employees and their managers).

    ```sql
    SELECT a.first_name AS employee, b.first_name AS manager
    FROM employees a
    LEFT JOIN employees b ON a.manager_id = b.employee_id;
    ```

---

## 2. GROUP BY: Summarizing Data

Want to know how many employees are in each department?

```sql
SELECT d.department_name, COUNT(*) AS num_employees
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
```

---

## 3. HAVING: Filtering Groups

Suppose you only want departments with more than 1 employee:

```sql
SELECT d.department_name, COUNT(*) AS num_employees
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) > 1;
```

---

## 4. Try It Yourself!

1. Write a query to list all employees and their department names, including employees without a department.
2. Find departments with no employees (hint: use RIGHT or FULL OUTER JOIN).
3. For each department, show the average salary (assume a salary column in employees).

---

## 5. Common Pitfalls

- Forgetting to specify the join condition (can cause a CROSS JOIN!).
- Using WHERE instead of HAVING for aggregate filters.
- Not grouping by all non-aggregated columns.

---

## 6. Final Thoughts

Mastering JOINs and GROUP BY is a game-changer. These tools let you answer complex business questions and uncover patterns hidden in your data.

---

*Next up: Advanced Window Functions—analytics at a whole new level!*

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