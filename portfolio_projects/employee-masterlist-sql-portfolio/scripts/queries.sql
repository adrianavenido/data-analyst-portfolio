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

-- SQL Export Guide
SHOW VARIABLES LIKE 'secure_file_priv';

SELECT gender, COUNT(*) AS employee_count
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employees_gender_count.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM employees
WHERE is_active = TRUE
GROUP BY gender;

-- Employee Statistics
SELECT COUNT(*) AS total_employees FROM employee_masterlist;

-- Workforce Distribution by Gender
SELECT gender, COUNT(*) AS employee_count
FROM employees
WHERE is_active = TRUE
GROUP BY gender;

-- Department Salary Averages
SELECT department, AVG(salary) AS average_salary
FROM employee_masterlist
GROUP BY department;

-- Hiring Trends (Post-2020)
SELECT * FROM employee_masterlist WHERE hire_date > '2020-01-01';

-- Highest-Paid Employee
SELECT * FROM employee_masterlist ORDER BY salary DESC LIMIT 1;

-- Department Employee Count
SELECT department, COUNT(*) AS employee_count
FROM employee_masterlist
GROUP BY department;

-- Attrition Trends
SELECT termination_reason, COUNT(*) AS terminations
FROM employees
WHERE termination_date IS NOT NULL
GROUP BY termination_reason;

-- Coaching Impact
SELECT tl.name AS team_leader, COUNT(e.employee_id) AS coached_employees
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
GROUP BY tl.name;

-- Organizational Structure
SELECT cm.name AS cluster_manager, tl.name AS team_leader, COUNT(e.employee_id) AS team_size
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
GROUP BY cm.name, tl.name;

-- Attendance Tracking (Employees with High Absences)
SELECT e.first_name, e.last_name, a.absent_days
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
WHERE a.absent_days > 5
ORDER BY a.absent_days DESC;

-- Total Absences Per Employee
SELECT e.first_name, e.last_name, SUM(a.absent_days) AS total_absences
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_absences DESC;

-- Employees Considering Resignation
SELECT COUNT(*) AS employees_considering_resignation
FROM early_warning_indicators
WHERE status = 'Consideration';

-- Formally Resigned Employees
SELECT employee_id, reason, resignation_date
FROM early_warning_indicators
WHERE status = 'Formal Notice'
ORDER BY resignation_date ASC;

-- Withdrawn Resignation Intent
SELECT employee_id, reason, updated_at AS withdrawal_date
FROM early_warning_indicators
WHERE status = 'Withdrawn'
ORDER BY withdrawal_date DESC;

-- Resignation Reasons Analysis
SELECT reason, COUNT(*) AS frequency
FROM early_warning_indicators
GROUP BY reason
ORDER BY frequency DESC;

-- Resignations Over Time
SELECT YEAR(resignation_date) AS year, MONTH(resignation_date) AS month, COUNT(*) AS total_resignations
FROM early_warning_indicators
WHERE status = 'Formal Notice'
GROUP BY year, month
ORDER BY year DESC, month DESC;

-- Employees with Multiple Resignation Attempts
SELECT employee_id, COUNT(*) AS resignation_attempts
FROM early_warning_indicators
WHERE status IN ('Consideration', 'Formal Notice', 'Withdrawn')
GROUP BY employee_id
HAVING resignation_attempts > 1;

-- Employees with Early Warning Indicators
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, e.team_leader_id, e.lob_id, 
       ew.resignation_id, ew.reason, ew.resignation_date, ew.status, ew.created_at, ew.updated_at
FROM employees e
JOIN early_warning_indicators ew ON e.employee_id = ew.employee_id
WHERE ew.status IN ('Consideration', 'Formal Notice','Withdrawn')
ORDER BY e.employee_id, ew.resignation_date;
