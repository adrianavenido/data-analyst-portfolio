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

DELETE FROM lines_of_business

SELECT * FROM cluster_managers



UPDATE cluster_managers
SET name = 'Daniel Reyes'
wHERE cluster_manager_id = 5

INSERT INTO cluster_managers (name, line_of_business)
VALUES
  ('Fernando Lopez', 'Cash Application'),
  ('Carlos Mendoza', 'Reporting');


DELETE FROM team_leaders\


ALTER TABLE team_leaders AUTO_INCREMENT = 1;

SELECT * FROM team_leaders

ALTER TABLE team_leaders
ADD COLUMN first_name VARCHAR(100),
ADD COLUMN last_name VARCHAR(100);


ALTER TABLE team_leaders
MODIFY COLUMN team_leader_id INT AUTO_INCREMENT FIRST,
MODIFY COLUMN first_name VARCHAR(100) AFTER team_leader_id,
MODIFY COLUMN last_name VARCHAR(100) AFTER first_name,
MODIFY COLUMN lob_id INT AFTER last_name,
MODIFY COLUMN cluster_manager_id INT AFTER lob_id;

INSERT INTO team_leaders (first_name, last_name, lob_id, cluster_manager_id)
VALUES
  ('Eric', 'Hickman', 1, 1),
  ('Jeffrey', 'Jefferson', 2, 2),
  ('Lisa', 'Snyder', 3, 3),
  ('Jasmine', 'Kent', 4, 4),
  ('William', 'Bradford', 5, 5),
  ('Bobby', 'Hancock', 6, 1),
  ('Rachel', 'Garcia', 7, 2),
  ('James', 'Lamb', 1, 3),
  ('Jennifer', 'Whitaker', 2, 4),
  ('Julie', 'Park', 3, 5);



SELECT * FROM team_leaders


SELECT * FROM lines_of_business;

SELECT * FROM team_leaders;

CREATE TABLE employee_lob (
    employee_id INT,
    lob_id INT,
    PRIMARY KEY (employee_id, lob_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (lob_id) REFERENCES lines_of_business (lob_id)
);


DROP TABLE IF EXISTS employees;


SELECT COUNT(*) FROM employees;

ALTER TABLE employees AUTO_INCREMENT = 1;

-- Step 1: Add a temp column
ALTER TABLE employees ADD COLUMN temp_id INT;

-- Step 2: Assign sequential values to temp_id
SET @counter = 0;
UPDATE employees SET temp_id = (@counter := @counter + 1) ORDER BY employee_id;

SET FOREIGN_KEY_CHECKS = 0;

-- Step 3: Drop auto-increment columnALTER TABLE employees MODIFY employee_id INT;
ALTER TABLE employees MODIFY employee_id INT;

UPDATE employees SET employee_id = temp_id;

ALTER TABLE employees DROP COLUMN temp_id;


ALTER TABLE employees AUTO_INCREMENT = 201;

SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE employees DROP COLUMN employee_id;

-- Step 4: Rename temp_id to employee_id and make it auto-increment
ALTER TABLE employees CHANGE temp_id employee_id INT PRIMARY KEY AUTO_INCREMENT;

-- Step 5 (Optional): Reset auto-increment counter
ALTER TABLE employees AUTO_INCREMENT = 201;


SELECT * FROM employees;


ALTER TABLE employees
DROP COLUMN lob_id,
DROP COLUMN team_leader_id;


ALTER TABLE employees DROP CONSTRAINT employees_ibfk_1;


ALTER TABLE employees DROP CONSTRAINT employees_ibfk_2;

ALTER TABLE employees
DROP COLUMN lob_id,
DROP COLUMN team_leader_id;

SELECT * FROM employee_lob


SELECT * FROM capacity_target


INSERT INTO managerbusinessmapping
VALUES
  (1, 3), 
  (1, 4), 
  (2, 5), 
  (3, 1), 
  (3, 7), 
  (4, 2), 
  (6, 6);


SELECT * FROM managerbusinessmapping;

SELECT
  cluster_managers.name AS MANAGER, 
  lines_of_business.name AS LOB
FROM managerbusinessmapping
JOIN cluster_managers ON managerbusinessmapping.cluster_manager_id = cluster_managers.cluster_manager_id
JOIN lines_of_business ON managerbusinessmapping.lob_id = lines_of_business.lob_id
ORDER BY LOB;


SELECT 
    cm.name AS MANAGER, 
    lob.business_name AS LOB
FROM managerbusinessmapping mbm
JOIN cluster_managers cm ON mbm.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON mbm.lob_id = lob.lob_id
ORDER BY lob.business_name;


TRUNCATE TABLE cluster_managers;



SELECT * FROM cluster_managers;

ALTER TABLE cluster_managers
DROP COLUMN line_of_business;


INSERT INTO cluster_managers (name)
VALUES
  ('Daniel Reyes'),
  ('Maria Santos'),
  ('Angela Cruz'),
  ('Fernando Lopez'),
  ('Carlos Mendoza');

  

SELECT * FROM cluster_managers

SELECT * FROM lines_of_business

ALTER TABLE lines_of_business
CHANGE COLUMN name business_name VARCHAR(100);

SELECT * FROM managerbusinessmapping

UPDATE managerbusinessmapping
SET cluster_manager_id = 5
WHERE cluster_manager_id = 6;

--PROBLEMATIC QUERY
SELECT 
  e.first_name,
  e.last_name,
  tl.name AS team_leader, 
  cm.name AS cluster_manager
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id

SELECT * FROM team_leaders

SELECT COUNT(*) FROM employee_lob






-- List of Lines of Business with their cluster Managers
SELECT 
    lob.lob_id as 'SN',
    cm.name AS 'Cluster Manager', 
    lob.business_name AS 'Line of Business'
FROM managerbusinessmapping mbm
JOIN cluster_managers cm ON mbm.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON mbm.lob_id = lob.lob_id
ORDER BY lob.lob_id;

-- List of Team Leaders with their Lines of Business and Cluster Managers
SELECT DISTINCT
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN managerbusinessmapping mbm ON tl.cluster_manager_id = mbm.cluster_manager_id
JOIN lines_of_business lob ON mbm.lob_id = lob.lob_id
JOIN cluster_managers cm ON mbm.cluster_manager_id = cm.cluster_manager_id;


SELECT * from team_leaders


ALTER TABLE team_leaders DROP CONSTRAINT team_leaders_ibfk_1;

ALTER TABLE team_leaders
DROP COLUMN lob_id;


UPDATE team_leaders
SET cluster_manager_id = 1
WHERE team_leader_id = 8;

SELECT * FROM team_leaders;


--Use DISTINCT: If you only need unique team_leader names, you can modify the query:
SELECT DISTINCT 
  tl.first_name, 
  tl.last_name, 
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN managerbusinessmapping mbm ON tl.cluster_manager_id = mbm.cluster_manager_id
JOIN cluster_managers cm ON mbm.cluster_manager_id = cm.cluster_manager_id;


--Aggregate Data: If you want a consolidated view, consider grouping and concatenating business names:
SELECT 
  tl.first_name, 
  tl.last_name, 
  cm.name AS 'Cluster Manager',
  GROUP_CONCAT(lob.business_name SEPARATOR ', ') AS 'Lines of Business'
FROM team_leaders tl
JOIN managerbusinessmapping mbm ON tl.cluster_manager_id = mbm.cluster_manager_id
JOIN lines_of_business lob ON mbm.lob_id = lob.lob_id
JOIN cluster_managers cm ON mbm.cluster_manager_id = cm.cluster_manager_id
GROUP BY tl.first_name, tl.last_name, cm.name;


ALTER TABLE team_leaders
ADD COLUMN lob_id INT;

SELECT * FROM team_leaders
ORDER BY cluster_manager_id;

ALTER TABLE team_leaders
MODIFY COLUMN team_leader_id INT AUTO_INCREMENT PRIMARY KEY,
MODIFY COLUMN first_name VARCHAR(100) NOT NULL,
MODIFY COLUMN last_name VARCHAR(100) NOT NULL,
MODIFY COLUMN lob_id INT,
MODIFY COLUMN cluster_manager_id INT;

SELECT * FROM team_leaders;


SELECT 
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;


/*
```sql
SELECT 
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;
```

### **How This Query Works:**
✅ Retrieves **team leader names** (`first_name`, `last_name`).  
✅ Fetches **business assignments** (`business_name`).  
✅ Shows **cluster managers** (`name`).  
✅ Uses **joins** to link `team_leaders` with `lines_of_business` and `cluster_managers`.  
*/



--Filter by Cluster Manager Name
--If you want to see only team leaders under a specific manager, say "Maria Santos":

SELECT 
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
WHERE cm.name = 'Maria Santos';



--Filter by Line of Business
--If you only want to see team leaders assigned to "Billing":
SELECT 
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
WHERE lob.business_name = 'Billing';


--Filter by Both (Specific Manager + Business)
--If you want to see team leaders under "Angela Cruz" assigned to "Reporting":
SELECT 
  tl.first_name, 
  tl.last_name, 
  lob.business_name AS 'Line of Business',
  cm.name AS 'Cluster Manager'
FROM team_leaders tl
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
WHERE cm.name = 'Angela Cruz' AND lob.business_name = 'Reporting';


SELECT * FROM employee_lob


--Query to Retrieve Employee Assignments
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    lob.business_name AS 'Line of Business',
    tl.first_name AS 'Team Leader First Name',
    tl.last_name AS 'Team Leader Last Name',
    cm.name AS 'Cluster Manager'
FROM employees e
JOIN employee_lob el ON e.employee_id = el.employee_id
JOIN lines_of_business lob ON el.lob_id = lob.lob_id
JOIN team_leaders tl ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;


/*
That’s a good start! Now, to create a **filterable view** that links **employees**, their assigned **line of business**, **team leaders**, and **cluster managers**, we need to join these tables properly.

### **Updated Schema for Filtering Employee Assignments**
Ensure you have the following related tables before creating the query:
- **`employees`** (Contains employee information)
- **`team_leaders`** (Links to `lines_of_business` and `cluster_managers`)
- **`employee_lob`** (Mapping table between employees and lines of business)
- **`lines_of_business`** (Business unit details)
- **`cluster_managers`** (Manager details)

---

### **Query to Retrieve Employee Assignments**
```sql
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    lob.business_name AS 'Line of Business',
    tl.first_name AS 'Team Leader First Name',
    tl.last_name AS 'Team Leader Last Name',
    cm.name AS 'Cluster Manager'
FROM employees e
JOIN employee_lob el ON e.employee_id = el.employee_id
JOIN lines_of_business lob ON el.lob_id = lob.lob_id
JOIN team_leaders tl ON tl.lob_id = lob.lob_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;
```

---

### **Key Features of This Query**
✅ **Displays full employee details**  
✅ **Links employees to their assigned line of business**  
✅ **Includes the relevant team leader and cluster manager**  
✅ **Uses JOIN operations to connect mapping relationships**  

---

### **Optional Filters**
Want to refine the data further? Add a `WHERE` clause:
#### **Filter by Specific Employee**
```sql
WHERE e.first_name = 'John' AND e.last_name = 'Doe';
```
#### **Filter by Specific Business Name**
```sql
WHERE lob.business_name = 'Billing';
```
#### **Filter by Specific Cluster Manager**
```sql
WHERE cm.name = 'Maria Santos';
```
*/  