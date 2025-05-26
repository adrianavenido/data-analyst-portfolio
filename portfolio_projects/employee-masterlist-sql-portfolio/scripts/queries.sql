/*
    SQL Export Instructions

    - Query results can be exported to a CSV file in the MySQL server's secure uploads directory:
      C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/

    - Ensure the MySQL server has write permissions to this directory and that the 'secure_file_priv' variable allows exporting to this path.
      To check:
        SHOW VARIABLES LIKE 'secure_file_priv';

    - Example export query:
        SELECT gender, COUNT(*) AS employee_count
        INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employees_gender_count.csv'
        FIELDS TERMINATED BY ',' 
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n'
        FROM employees
        WHERE is_active = TRUE
        GROUP BY gender;
*/


-- Workforce Distribution by Gender
-- This query provides the count of active employees categorized by gender.
SELECT gender, COUNT(*) AS employee_count
FROM employees
WHERE is_active = TRUE
GROUP BY gender;

-- Attrition Trends
-- Analyzes termination reasons and provides the total count of terminations per reason.
SELECT termination_reason, COUNT(*) AS terminations
FROM employees
WHERE termination_date IS NOT NULL
GROUP BY termination_reason;

-- Coaching Impact Analysis
-- Evaluates the number of employees coached under each team leader.
SELECT tl.name AS team_leader, COUNT(e.employee_id) AS coached_employees
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
GROUP BY tl.name;

-- Organizational Structure Visualization
-- Displays the hierarchy between cluster managers and team leaders, along with their team sizes.
SELECT cm.name AS cluster_manager, tl.name AS team_leader, COUNT(e.employee_id) AS team_size
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
GROUP BY cm.name, tl.name;

-- Attendance Tracking (Employees with High Absences)
-- Lists employees who have more than 5 absences, sorted in descending order.
SELECT e.first_name, e.last_name, a.absent_days
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
WHERE a.absent_days > 5
ORDER BY a.absent_days DESC;

-- Total Absences per Employee
-- Provides the total absences recorded for each employee, ordered from highest to lowest.
SELECT e.first_name, e.last_name, SUM(a.absent_days) AS total_absences
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_absences DESC;


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
