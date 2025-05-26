Employee Masterlist SQL Queries

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS employee_portfolio;

-- Use the database
USE employee_portfolio;


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

SELECT * FROM employee_portfolio.employee_masterlist;

-- Insert sample data
INSERT INTO employee_masterlist (employee_id, first_name, last_name, department, hire_date, salary) VALUES
(1, 'John', 'Doe', 'HR', '2020-05-01', 55000.00),
(2, 'Jane', 'Smith', 'IT', '2019-03-15', 75000.00),
(3, 'Alice', 'Johnson', 'Finance', '2021-07-20', 62000.00),
(4, 'Bob', 'Williams', 'IT', '2018-11-03', 80000.00),
(5, 'Emily', 'Davis', 'HR', '2022-01-10', 50000.00);


SELECT COUNT(*) AS total_employees FROM employee_masterlist;


SELECT department, AVG(salary) AS average_salary
FROM employee_masterlist
GROUP BY department;


SELECT * 
FROM employee_masterlist
WHERE hire_date > '2020-01-01';


SELECT * 
FROM employee_masterlist
ORDER BY salary DESC
LIMIT 1;


SELECT department, COUNT(*) AS employee_count
FROM employee_masterlist
GROUP BY department;
