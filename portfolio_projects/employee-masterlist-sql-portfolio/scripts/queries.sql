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

SELECT * FROM capacity_target

-- Ideal Headcount Distribution for Lines of Business

-- Global: 1 FTE
INSERT INTO capacity_target (lob_id, target_fte, updated_at)
SELECT lob_id, 1, CURRENT_DATE()
FROM lines_of_business
WHERE lob_name = 'Global';

-- Reporting: 2 FTEs
INSERT INTO capacity_target (lob_id, target_fte, updated_at)
SELECT lob_id, 2, CURRENT_DATE()
FROM lines_of_business
WHERE lob_name = 'Reporting';

-- Distribute remaining 197 FTEs among Billing, Accounts Receivable, Order Management, Disputes, Cash Application
-- Example distribution 
-- Billing: 50, Accounts Receivable: 45, Order Management: 40, Disputes: 32, Cash Application: 30

DELETE FROM capacity_target

SELECT * FROM capacity_target;

INSERT INTO capacity_target (lob_id, target_fte, target_month)
VALUES
  (1, 10, '2025-06-01'), -- Billing (Month 1)
  (1, 20, '2025-07-01'), -- Billing (Month 2)
  (1, 30, '2025-08-01'), -- Billing (Month 3)
  (1, 40, '2025-09-01'), -- Billing (Month 4)
  (1, 50, '2025-10-01'), -- Billing (Month 5)

  (2, 9, '2025-06-01'), -- Accounts Receivable (Month 1)
  (2, 18, '2025-07-01'), -- Accounts Receivable (Month 2)
  (2, 27, '2025-08-01'), -- Accounts Receivable (Month 3)
  (2, 36, '2025-09-01'), -- Accounts Receivable (Month 4)
  (2, 45, '2025-10-01'), -- Accounts Receivable (Month 5)

  (3, 8, '2025-06-01'), -- Order Management (Month 1)
  (3, 16, '2025-07-01'), -- Order Management (Month 2)
  (3, 24, '2025-08-01'), -- Order Management (Month 3)
  (3, 32, '2025-09-01'), -- Order Management (Month 4)
  (3, 40, '2025-10-01'), -- Order Management (Month 5)

  (4, 6, '2025-06-01'), -- Disputes (Month 1)
  (4, 12, '2025-07-01'), -- Disputes (Month 2)
  (4, 18, '2025-08-01'), -- Disputes (Month 3)
  (4, 24, '2025-09-01'), -- Disputes (Month 4)
  (4, 32, '2025-10-01'), -- Disputes (Month 5)

  (5, 6, '2025-06-01'), -- Cash Application (Month 1)
  (5, 12, '2025-07-01'), -- Cash Application (Month 2)
  (5, 18, '2025-08-01'), -- Cash Application (Month 3)
  (5, 24, '2025-09-01'), -- Cash Application (Month 4)
  (5, 30, '2025-10-01'); -- Cash Application (Month 5)


SELECT * FROM capacity_target;

--How many total FTEs are allocated per line of business over time?
SELECT lob_id, SUM(target_fte) AS total_fte 
FROM capacity_target 
GROUP BY lob_id;

--How does FTE allocation change month over month?
SELECT target_month, SUM(target_fte) AS monthly_fte_allocation 
FROM capacity_target 
GROUP BY target_month 
ORDER BY target_month;


--Which line of business has the highest allocation in a given month?
SELECT lob_id, target_month, target_fte 
FROM capacity_target 
ORDER BY target_fte DESC 
LIMIT 1;

--Are there months where fewer FTEs are allocated than expected?
SELECT target_month, SUM(target_fte) AS total_fte 
FROM capacity_target 
GROUP BY target_month 
HAVING SUM(target_fte) < (SELECT AVG(target_fte) FROM capacity_target);


--What is the cumulative workforce allocation per business line over the first year?
SELECT lob_id, target_month, SUM(target_fte) OVER (PARTITION BY lob_id ORDER BY target_month) AS cumulative_fte
FROM capacity_target;


--How does the workforce ramp-up compare across business lines?
SELECT lob_id, target_month, target_fte, 
       SUM(target_fte) OVER (PARTITION BY lob_id ORDER BY target_month) AS cumulative_fte
FROM capacity_target
ORDER BY lob_id, target_month;


-- Track FTE allocation per month:
SELECT target_month, SUM(target_fte) AS monthly_fte_allocation 
FROM capacity_target 
GROUP BY target_month 
ORDER BY target_month;


-- EMPLOYEE TABLE REDO

TRUNCATE TABLE employees

-- Export employees table to Excel-compatible CSV in the data folder
SELECT * 
INTO OUTFILE 'C:/Users/adria/Desktop/data-analyst-portfolio/portfolio_projects/employee-masterlist-sql-portfolio/data/employees_export.xlsx'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM employees;