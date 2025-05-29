Here’s a Markdown (`.md`) document you can use to **document the troubleshooting process** and solution for future reference:

---

````markdown
# 🛠️ Troubleshooting: "Unknown column in the termination_date field" in MySQL Attrition Query

## ✅ Context

We attempted to calculate the **employee attrition rate** using a query based on the following schema:

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    termination_reason VARCHAR(50),
    corporate_email VARCHAR(100) UNIQUE NOT NULL,
    client_email VARCHAR(100) UNIQUE NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    location VARCHAR(100) NOT NULL,
    is_active TINYINT(1) DEFAULT 1
);
````

## ❌ Issue Encountered

The query failed with the error:

```
Unknown column in the termination_date field
```

Despite confirming that `termination_date` exists via:

```sql
SELECT termination_date FROM employees LIMIT 5;
```

## 🔍 Root Cause

The issue was in this part of the query:

```sql
SELECT 
    COUNT(CASE WHEN termination_date BETWEEN @start_date AND @end_date THEN 1 END) AS employees_left,
    ...
```

This expression referenced `termination_date` **without a `FROM` clause**, so MySQL didn’t know which table to pull `termination_date` from.

## ✅ Solution

Add `FROM employees` to the main query so that `termination_date` (and other columns) have a clear source:

### ✅ Fixed Query

```sql
SET @start_date = '2025-04-01';
SET @end_date = '2025-04-30';

SELECT 
    COUNT(CASE WHEN termination_date BETWEEN @start_date AND @end_date THEN 1 END) AS employees_left,
    (
        (
            SELECT COUNT(*) 
            FROM employees 
            WHERE hire_date <= @start_date AND (termination_date IS NULL OR termination_date >= @start_date)
        ) +
        (
            SELECT COUNT(*) 
            FROM employees 
            WHERE hire_date <= @end_date AND (termination_date IS NULL OR termination_date >= @end_date)
        )
    ) / 2 AS avg_employees,
    ROUND(
        (
            COUNT(CASE WHEN termination_date BETWEEN @start_date AND @end_date THEN 1 END) * 100.0 /
            (
                (
                    SELECT COUNT(*) 
                    FROM employees 
                    WHERE hire_date <= @start_date AND (termination_date IS NULL OR termination_date >= @start_date)
                ) +
                (
                    SELECT COUNT(*) 
                    FROM employees 
                    WHERE hire_date <= @end_date AND (termination_date IS NULL OR termination_date >= @end_date)
                )
            ) / 2
        ), 2
    ) AS attrition_rate_percentage
FROM employees;
```

## 🧠 Lessons Learned

* Always ensure every column in a `SELECT` clause has a corresponding `FROM` source.
* Even if subqueries are scoped correctly, the **outer query** still requires a table reference for any field used.
* Use simple test queries to isolate the problem and confirm column existence.

## 📌 Next Steps

* Consider wrapping this logic into a **view** or **stored procedure**.
* Expand to a **monthly attrition report** grouped by year/month.

```

---

Let me know if you’d like to include diagrams, extend this for a GitHub README, or add a section on converting it to a stored procedure or report.
```
