




SELECT * FROM team_leaders

-- DELETE FROM employees WHERE employee_id > 0;
-- ALTER TABLE employees AUTO_INCREMENT = 1;


-- SHOW VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = 0;

UPDATE lines_of_business SET name = 'Reporting' WHERE lob_id = 6;



TRUNCATE TABLE team_leaders

Error Code: 1701. Cannot truncate a table referenced in a foreign key constraint (`employee_masterlist`.`employees`, CONSTRAINT `employees_ibfk_2`)

SELECT * FROM team_leaders


ALTER TABLE team_leaders AUTO_INCREMENT = 1;

SELECT * FROM team_leaders



DELETE FROM team_leaders WHERE id > 0;

DELETE FROM team_leaders WHERE team_leader_id > 0;

SELECT * FROM team_leaders

ALTER TABLE team_leaders AUTO_INCREMENT = 1;





-- SELECT * FROM employees
-- DELETE FROM employees;
-- SET SQL_SAFE_UPDATES = 1
-- TRUNCATE TABLE employees

-- DELETE FROM team_leaders
-- SHOW VARIABLES LIKE "SQL_SAFE_UPDATES";
-- SET GLOBAL SQL_SAFE_UPDATES = 0;

-- SELECT * FROM team_leaders
-- SET SQL_SAFE_UPDATES = 0;
-- SET SQL_SAFE_UPDATES = 0;
-- TRUNCATE TABLE team_leaders

-- SELECT * FROM employees

-- DESCRIBE employees
-- SHOW CREATE TABLE employees
/*
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees';


UPDATE employees
SET location = 
    CASE FLOOR(RAND() * 4)
        WHEN 0 THEN 'Bulacan'
        WHEN 1 THEN 'Rizal'
        WHEN 2 THEN 'Cavite'
        WHEN 3 THEN 'Laguna'
    END
WHERE location IN ('Manila', 'Quezon City', 'Pasig', 'Makati', 'Taguig', 'Mandaluyong', 'Parañaque', 'Las Piñas', 'Pasay', 'San Juan', 'Marikina', 'Valenzuela', 'Malabon', 'Navotas', 'Caloocan', 'Pateros');
*/
/*
UPDATE employees
SET location = 
    CASE FLOOR(RAND() * 20)
        WHEN 0 THEN 'Manila'
        WHEN 1 THEN 'Quezon City'
        WHEN 2 THEN 'Pasig'
        WHEN 3 THEN 'Makati'
        WHEN 4 THEN 'Taguig'
        WHEN 5 THEN 'Mandaluyong'
        WHEN 6 THEN 'Parañaque'
        WHEN 7 THEN 'Las Piñas'
        WHEN 8 THEN 'Pasay'
        WHEN 9 THEN 'San Juan'
        WHEN 10 THEN 'Marikina'
        WHEN 11 THEN 'Valenzuela'
        WHEN 12 THEN 'Malabon'
        WHEN 13 THEN 'Navotas'
        WHEN 14 THEN 'Caloocan'
        WHEN 15 THEN 'Pateros'
        WHEN 16 THEN 'Bulacan'
        WHEN 17 THEN 'Rizal'
        WHEN 18 THEN 'Cavite'
        WHEN 19 THEN 'Laguna'
    END;


SELECT location,COUNT(*) FROM employees
GROUP BY location ORDER BY COUNT(*) DESC

*/





-- SELECT * FROM cluster_managers

/*
INSERT INTO lines_of_business (name) VALUES
('Billing'),
('Accounts Receivable'),
('Global'),
('Order Management');
*/
-- SELECT * FROM lines_of_business

-- SELECT * FROM team_leaders

-- SHOW VARIABLES LIKE 'datadir';

-- SELECT * FROM lines_of_business

/*
INSERT INTO lines_of_business VALUES (5,'Cash Application');
INSERT INTO lines_of_business VALUES (6,'Reporting')
*/

-- SELECT * FROM lines_of_business;

-- SELECT * FROM employees;

-- SELECT * FROM team_leaders;




/*
SELECT tl.name AS 'Team Leader', COUNT(e.employee_id) AS 'Employee Count'
FROM team_leaders tl
LEFT JOIN employees e ON tl.team_leader_id = e.team_leader_id
GROUP BY tl.team_leader_id
*/

-- SELECT * FROM employees
/*
UPDATE employees e
JOIN team_leaders tl ON e.lob_id = tl.lob_id
SET e.team_leader_id = tl.team_leader_id;
*/


-- SELECT * FROM team_leaders;
/*
UPDATE employees e
JOIN team_leaders tl ON e.lob_id = tl.lob_id
SET e.lob_id = tl.lob_id,
    e.team_leader_id = tl.team_leader_id;
*/


-- SELECT * FROM employees

/*
UPDATE employees e
JOIN (
    SELECT team_leader_id, cluster_manager_id, 
           ROW_NUMBER() OVER (ORDER BY team_leader_id) AS rn
    FROM team_leaders
) tl ON MOD(e.employee_id, 10) + 1 = tl.rn
SET e.team_leader_id = tl.team_leader_id,
    e.lob_id = tl.team_leader_id,
    e.location = CASE FLOOR(RAND() * 4)
        WHEN 0 THEN 'Billing'
        WHEN 1 THEN 'Accounts Receivable'
        WHEN 2 THEN 'Global'
        WHEN 3 THEN 'Order Management'
    END;
*/
/*
UPDATE employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
SET e.team_leader_id = tl.team_leader_id,
    e.lob_id = tl.lob_id,
    e.location = cm.region
WHERE cm.cluster_manager_id BETWEEN 1 AND 5;
*/


-- SELECT * FROM employees
/*
UPDATE employees e
JOIN team_leaders tl ON e.lob_id = tl.lob_id
SET e.team_leader_id = tl.team_leader_id;
*/


/*
ALTER TABLE employees
CHANGE COLUMN line_of_business location VARCHAR(100) NOT NULL;
*/

-- SELECT * FROM employees
/*
ALTER TABLE cluster_managers 
CHANGE COLUMN region line_of_business VARCHAR(100) NOT NULL;
*/

-- SELECT * FROM cluster_managers 

/*

Explanation:
JOIN team_leaders tl ON cm.cluster_manager_id = tl.cluster_manager_id → Ensures managers are linked to their team leaders.
LEFT JOIN employees e ON tl.team_leader_id = e.team_leader_id → Counts employees assigned to those team leaders.
GROUP BY cm.cluster_manager_id → Groups results by each cluster manager

SELECT cm.name AS 'Manager', COUNT(e.employee_id) AS 'Employee Count'
FROM cluster_managers cm
JOIN team_leaders tl ON cm.cluster_manager_id = tl.cluster_manager_id
LEFT JOIN employees e ON tl.team_leader_id = e.team_leader_id
GROUP BY cm.cluster_manager_id;
*/

/*
SELECT tl.name AS 'Team Leader', COUNT(e.employee_id) AS 'Employee Count'
FROM team_leaders tl
LEFT JOIN employees e ON tl.team_leader_id = e.team_leader_id
GROUP BY tl.team_leader_id;
*/

/*
SELECT 
    e.employee_id,
    first_name,
    last_name,
    e.lob_id,
    tl.team_leader_id,
    tl.name AS team_leader_name,
    cm.cluster_manager_id,
    cm.name AS cluster_manager_name
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;
*/

/*
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    lob.name AS line_of_business,  -- Displaying actual business name instead of ID
    tl.name AS team_leader_name,
    cm.name AS cluster_manager_name
FROM employees e
JOIN lines_of_business lob ON e.lob_id = lob.lob_id  -- Joining to get business name
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
ORDER BY lob.name;
*/

/*
Great question! Let’s break down what’s happening when you run this SQL query and how MySQL processes it step by step.

### **Step-by-Step Execution Process**
#### **1. Query Parsing and Validation**
- When you execute the SQL statement, MySQL first **checks its syntax** to ensure it's valid.
- It verifies that all **tables, columns, and joins** exist and can be processed.
- If there's an issue (like a column that doesn't exist), MySQL throws an error before execution.

#### **2. Table Joins and Data Retrieval**
Your query involves **three table joins**:  
```sql
FROM employees e
JOIN lines_of_business lob ON e.lob_id = lob.lob_id
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
```
This means MySQL will process them in sequence:

1. **`employees` table** (`e` alias) is the primary table.  
2. **`lines_of_business` table** (`lob` alias) is joined on `lob_id` to retrieve the business name instead of displaying numeric IDs.  
3. **`team_leaders` table** (`tl` alias) is joined using `team_leader_id`, linking employees to their assigned team leader.  
4. **`cluster_managers` table** (`cm` alias) is joined using `cluster_manager_id`, ensuring each team leader is mapped to their manager.

These joins **combine the tables into a single result set**, pulling relevant data.

#### **3. Query Execution and Index Usage**
- MySQL **checks indexes** to optimize performance. If an index exists on `lob_id`, `team_leader_id`, or `cluster_manager_id`, it speeds up data retrieval.
- **Index scan or full scan:** If indexes exist, MySQL **quickly retrieves** matching rows without scanning the whole table. Without indexes, it scans **every row**, making execution slower.
- MySQL **builds a temporary dataset** that links employees to their respective business, leaders, and managers.

#### **4. Sorting the Results (`ORDER BY lob.name`)**
The query includes:
```sql
ORDER BY lob.name;
```
- After **retrieving all matching rows**, MySQL **sorts them alphabetically** by `line_of_business`.
- If the column is indexed, sorting is fast; otherwise, MySQL **performs an internal sorting operation** before displaying the results.

#### **5. Final Output**
Once MySQL completes joining the tables, retrieving data, and sorting:
- It **formats the output** as a table with readable column names.
- You get results where each employee is shown with their:
  - **Full name (`first_name`, `last_name`)**
  - **Line of business (`lob.name`)**
  - **Team leader (`tl.name`)**
  - **Cluster manager (`cm.name`)**
- No numeric IDs are shown, making the data **human-readable**.

### **Performance Considerations**
- If the database is large, joins can be **resource-intensive**. Using indexes can **dramatically improve speed**.
- Sorting (`ORDER BY`) on large datasets can cause **performance bottlenecks**.
- If MySQL uses temporary tables for sorting, it may take **more memory** depending on dataset size.

### **Final Thoughts**
This query is well-structured for **readability and alignment**, ensuring all relationships are accurately reflected. However, for **large datasets**, performance optimization techniques (like indexing) can help make it run faster.

Let me know if you want deeper insights into how MySQL processes joins or optimizes execution! 🚀
*/

/*
SELECT 
    e.*,  -- Selects all columns from employees
    tl.name AS team_leader_name,
    cm.name AS cluster_manager_name
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;

To efficiently display all columns from the `employees` table along with their corresponding **team leaders (tl)** and **cluster managers (cm)**, use the following query:

```sql
SELECT 
    e.*,  -- Selects all columns from employees
    tl.name AS team_leader_name,
    cm.name AS cluster_manager_name
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;
```

### **Optimized Approach:**
- **`e.*`** → Fetches **all columns** from `employees`, ensuring every detail is shown.
- **Explicitly selects `tl.name` and `cm.name`** → Avoids column name conflicts.
- **Maintains efficiency** by using indexed joins.

### **Performance Considerations:**
- If `employees` has **many columns**, ensure indexes exist on `team_leader_id` and `cluster_manager_id` to improve query speed.
- If needed, use **`SELECT e.*, tl.*, cm.*`** to get **all columns** from `team_leaders` and `cluster_managers`.

This query gives a **complete overview** of employees and their leadership assignments with minimal complexity. Let me know if you need refinements! 🚀
*/
/*
SELECT 
    e.*,  -- Selects all columns from employees
    tl.name AS team_leader_name,
    cm.name AS cluster_manager_name
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id;

*/

/*
SELECT 
    e.*,    lob.name AS line_of_business,  -- Displaying actual business name instead of ID
    tl.name AS team_leader_name,
    cm.name AS cluster_manager_name
FROM employees e
JOIN lines_of_business lob ON e.lob_id = lob.lob_id  -- Joining to get business name
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
ORDER BY lob.name;
*/

/*
-- Insert 190 employees while strictly following the schema
INSERT INTO employees (first_name, last_name, gender, birth_date, hire_date, corporate_email, client_email, contact_number, location, is_active, lob_id, team_leader_id)
SELECT 
    CONCAT('Employee', ROW_NUMBER() OVER (ORDER BY RAND())),
    CONCAT('Last', ROW_NUMBER() OVER (ORDER BY RAND())),
    CASE WHEN RAND() > 0.5 THEN 'Male' ELSE 'Female' END, -- Random gender
    DATE_ADD('1980-01-01', INTERVAL FLOOR(RAND() * 40) YEAR), -- Random birth_date between 1980 and 2020
    '2023-01-15',
    CONCAT('employee', ROW_NUMBER() OVER (ORDER BY RAND()), '@company.com'),
    CONCAT('client', ROW_NUMBER() OVER (ORDER BY RAND()), '@client.com'),
    CONCAT('+63', FLOOR(RAND() * 900000000 + 100000000)), -- Random contact number
    'Naga, Bicol, Philippines', -- Example location
    TRUE, -- Default active status
    tl.lob_id,
    tl.team_leader_id
FROM team_leaders tl
ORDER BY RAND()
LIMIT 190;

*/

-- SELECT * FROM employees


/*

Expanding your `employees` table is straightforward! You can add more fields by updating your `CREATE TABLE` statement with new columns that fit your business needs. Here’s how you can do it:

### **Steps to Add More Fields**
1. **Identify Missing Information** – Think about extra details you want to store (e.g., middle name, emergency contact, department, job title).
2. **Modify the Table Structure** – Use `ALTER TABLE` if your table is already created, or directly update the `CREATE TABLE` statement.
3. **Ensure Data Integrity** – Use appropriate data types, constraints (like `NOT NULL` or `UNIQUE`), and foreign keys if needed.



### **Using `ALTER TABLE` to Add Fields Later**
If you've already created the table, you can add columns dynamically:
```sql
ALTER TABLE employees 
ADD COLUMN emergency_contact VARCHAR(20),
ADD COLUMN department VARCHAR(100),
ADD COLUMN job_title VARCHAR(100),
ADD COLUMN salary DECIMAL(10,2) NOT NULL;
```

Do you have specific fields you'd like to include? I can help refine them! 🚀

*/


-- SELECT employee_id FROM employees;
-- SELECT team_leader_id FROM team_leaders;


*
SELECT e.first_name, e.last_name, a.absent_days
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
WHERE a.absent_days > 5
ORDER BY a.absent_days DESC;
*/


INSERT INTO employees (
    first_name, last_name, gender, birth_date, hire_date, termination_date,
    termination_reason, corporate_email, client_email, contact_number, location, is_active
) 
VALUES

('Michael', 'Smith', 'Male', '1985-07-23', '2023-09-01', NULL, NULL, 'employee405@bpo.com', 'employee20ADF0@client.com', '123-456-7890', 'Laguna', TRUE),
('Emily', 'Davis', 'Female', '1990-03-15', '2023-09-05', NULL, NULL, 'employee384@bpo.com', 'employee20ADF1@client.com', '987-654-3210', 'Bulacan', TRUE);
