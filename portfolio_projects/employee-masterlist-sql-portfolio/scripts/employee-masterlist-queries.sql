-- Employee Masterlist SQL Queries

-- Create table example
CREATE TABLE IF NOT EXISTS employee_masterlist (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10, 2)
);

-- Sample query: count employees by department
SELECT department, COUNT(*) AS employee_count
FROM employee_masterlist
GROUP BY department
ORDER BY employee_count DESC;
