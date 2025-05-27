# SQL Query Reference

This document provides reference SQL queries used in the Employee Masterlist project. Each query is described with its purpose and example usage.

---

## 1. Retrieve All Employees

```sql
SELECT *
FROM employees;
```
*Returns all employee records from the database.*

---

## 2. Find Employees by Department

```sql
SELECT employee_id, first_name, last_name, department
FROM employees
WHERE department = 'Sales';
```
*Lists employees who work in the Sales department.*

---

## 3. Count Employees per Department

```sql
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;
```
*Shows the number of employees in each department.*

---

## 4. List Employees Hired After a Certain Date

```sql
SELECT employee_id, first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2022-01-01';
```
*Displays employees hired after January 1, 2022.*

---

## 5. Update Employee Contact Information

```sql
UPDATE employees
SET email = 'new.email@example.com'
WHERE employee_id = 123;
```
*Updates the email address for a specific employee.*

---

## 6. Delete an Employee Record

```sql
DELETE FROM employees
WHERE employee_id = 123;
```
*Removes an employee record from the database.*

---

*For more advanced queries, refer to the project source code or contact the project maintainer.*