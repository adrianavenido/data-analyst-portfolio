CREATE DATABASE employee_management;

USE employee_management;


CREATE TABLE lines_of_business (
    lob_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cluster_managers (
    cluster_manager_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    lob_id INT NOT NULL,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id)
);

CREATE TABLE team_leaders (
    team_leader_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    lob_id INT NOT NULL,
    cluster_manager_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);

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



SHOW TABLES

DESCRIBE team_leaders;

INSERT INTO lines_of_business (name) VALUES 
('Order Management'), 
('Billing'), 
('Accounts Receivable'), 
('Cash Application');


INSERT INTO cluster_managers (name, lob_id) VALUES 
('Alice Johnson', 1), -- Order Management
('Bob Smith', 2);     -- Billing


INSERT INTO team_leaders (first_name, last_name, lob_id, cluster_manager_id) VALUES 
('Charlie', 'Brown', 1, 1),  -- Order Management under Alice
('Diane', 'Taylor', 2, 2),   -- Billing under Bob
('Evan', 'Green', 3, 2),   -- Accounts Receivable under Bob
('Lisa', 'White', 3, 3), -- Under new Cluster Manager Michael
('Mark', 'Johnson', 4, 2); -- Under Cluster Manager Bob (Cash Application)

INSERT INTO employees (first_name, last_name, gender, birth_date, hire_date, corporate_email, client_email, contact_number, location) VALUES 
('Emily', 'Clark', 'Female', '1990-05-20', '2020-09-15', 'emily.clark@company.com', 'emily.client@client.com', '1234567890', 'New York'),
('David', 'Lee', 'Male', '1992-03-10', '2019-05-22', 'david.lee@company.com', 'david.client@client.com', '1234567891', 'Los Angeles'),
('Sarah', 'Miller', 'Female', '1995-08-08', '2021-02-14', 'sarah.miller@company.com', 'sarah.client@client.com', '1234567892', 'Chicago'),
('James', 'Wilson', 'Male', '1988-11-12', '2017-06-30', 'james.wilson@company.com', 'james.client@client.com', '1234567893', 'Houston'),
('Olivia', 'Adams', 'Female', '1991-07-25', '2018-07-18', 'olivia.adams@company.com', 'olivia.client@client.com', '1234567894', 'San Francisco'),
('Daniel', 'Brown', 'Male', '1993-05-04', '2022-01-12', 'daniel.brown@company.com', 'daniel.client@client.com', '1234567895', 'Miami'),
('Sophia', 'Martinez', 'Female', '1989-12-09', '2016-10-03', 'sophia.martinez@company.com', 'sophia.client@client.com', '1234567896', 'Seattle'),
('Ryan', 'Garcia', 'Male', '1994-06-30', '2023-04-01', 'ryan.garcia@company.com', 'ryan.client@client.com', '1234567897', 'Boston'),
('Megan', 'Harris', 'Female', '1997-09-15', '2020-11-05', 'megan.harris@company.com', 'megan.client@client.com', '1234567898', 'Denver'),
('Ethan', 'Robinson', 'Male', '1987-02-18', '2015-09-20', 'ethan.robinson@company.com', 'ethan.client@client.com', '1234567899', 'Atlanta');


UPDATE employees 
SET location = CASE employee_id
    WHEN 1 THEN 'Makati'
    WHEN 2 THEN 'Taguig'
    WHEN 3 THEN 'Quezon City'
    WHEN 4 THEN 'Pasig'
    WHEN 5 THEN 'Mandaluyong'
    WHEN 6 THEN 'Manila'
    WHEN 7 THEN 'Las Piñas'
    WHEN 8 THEN 'Parañaque'
    WHEN 9 THEN 'Caloocan'
    WHEN 10 THEN 'San Juan'
END
WHERE employee_id BETWEEN 1 AND 10;


SELECT * FROM team_leaders

ALTER TABLE team_leaders AUTO_INCREMENT = 1;

TRUNCATE Table team_leaders

CREATE TABLE employee_assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    team_leader_id INT NOT NULL,
    cluster_manager_id INT NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (team_leader_id) REFERENCES team_leaders(team_leader_id),
    FOREIGN KEY (cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);

INSERT INTO employee_assignments (employee_id, team_leader_id, cluster_manager_id) VALUES
(1, 1, 1), -- Employee 1 assigned to Team Leader 1, Cluster Manager 1
(2, 2, 2), -- Employee 2 assigned to Team Leader 2, Cluster Manager 2
(3, 3, 2), -- Employee 3 assigned to Team Leader 3, Cluster Manager 2
(4, 1, 1),
(5, 2, 2),
(6, 3, 2),
(7, 1, 1),
(8, 2, 2),
(9, 3, 2),
(10, 1, 1);

SHOW CREATE TABLE employee_assignments;


SELECT * FROM cluster_managers


SELECT 
    e.first_name AS Employee_Name, 
    tl.first_name AS Team_Leader, 
    cm.name AS Cluster_Manager, 
    ea.assigned_date
FROM employee_assignments ea
JOIN employees e ON ea.employee_id = e.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
ORDER BY ea.assigned_date DESC;

CREATE TRIGGER track_team_changes
AFTER UPDATE ON employee_assignments
FOR EACH ROW
INSERT INTO employee_movements (
    employee_id, previous_team_leader_id, new_team_leader_id, previous_cluster_manager_id, new_cluster_manager_id
)
VALUES (NEW.employee_id, OLD.team_leader_id, NEW.team_leader_id, OLD.cluster_manager_id, NEW.cluster_manager_id);


CREATE TABLE employee_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    previous_team_leader_id INT,
    new_team_leader_id INT NOT NULL,
    previous_cluster_manager_id INT,
    new_cluster_manager_id INT NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (previous_team_leader_id) REFERENCES team_leaders(team_leader_id),
    FOREIGN KEY (new_team_leader_id) REFERENCES team_leaders(team_leader_id),
    FOREIGN KEY (previous_cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id),
    FOREIGN KEY (new_cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);


SELECT * FROM employee_movements;

UPDATE employee_assignments 
SET team_leader_id = 3, cluster_manager_id = 2 
WHERE employee_id = 1;

SELECT * FROM employee_assignments

TRUNCATE TABLE employee_assignments


SELECT * FROM employee_movements WHERE employee_id = 1 ORDER BY change_date DESC;

SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(e.first_name, ' ', e.last_name) AS Supervisor_Name,
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;

INSERT INTO cluster_managers (name, lob_id) VALUES 
('Michael Thompson', 3); -- New Cluster Manager for Accounts Receivable


INSERT INTO team_leaders (first_name, last_name, lob_id, cluster_manager_id) VALUES 




INSERT INTO employees (first_name, last_name, gender, birth_date, hire_date, corporate_email, client_email, contact_number, location) VALUES 
('Aaron', 'Cole', 'Male', '1990-03-12', '2022-07-01', 'aaron.cole@company.com', 'aaron.client@client.com', '09171234567', 'Makati'),
('Brenda', 'King', 'Female', '1992-05-15', '2019-04-10', 'brenda.king@company.com', 'brenda.client@client.com', '09181234567', 'Taguig'),
('Cameron', 'Evans', 'Male', '1988-09-30', '2023-01-05', 'cameron.evans@company.com', 'cameron.client@client.com', '09191234567', 'Quezon City'),
('Diana', 'Foster', 'Female', '1995-07-18', '2018-12-20', 'diana.foster@company.com', 'diana.client@client.com', '09201234567', 'Pasig'),
('Edward', 'Simmons', 'Male', '1993-11-02', '2017-08-14', 'edward.simmons@company.com', 'edward.client@client.com', '09211234567', 'Mandaluyong'),
('Fiona', 'Black', 'Female', '1997-03-25', '2021-03-19', 'fiona.black@company.com', 'fiona.client@client.com', '09221234567', 'Manila'),
('George', 'Lopez', 'Male', '1994-06-08', '2020-10-07', 'george.lopez@company.com', 'george.client@client.com', '09231234567', 'Las Piñas'),
('Hannah', 'Stewart', 'Female', '1991-12-12', '2016-05-28', 'hannah.stewart@company.com', 'hannah.client@client.com', '09241234567', 'Parañaque'),
('Isaac', 'Warren', 'Male', '1990-01-17', '2015-09-30', 'isaac.warren@company.com', 'isaac.client@client.com', '09251234567', 'Caloocan'),
('Jessica', 'Hill', 'Female', '1989-08-23', '2019-11-03', 'jessica.hill@company.com', 'jessica.client@client.com', '09261234567', 'San Juan'),
('Kevin', 'Mitchell', 'Male', '1996-04-04', '2022-05-11', 'kevin.mitchell@company.com', 'kevin.client@client.com', '09271234567', 'Makati'),
('Laura', 'Adams', 'Female', '1993-06-09', '2017-06-15', 'laura.adams@company.com', 'laura.client@client.com', '09281234567', 'Taguig'),
('Matthew', 'Harris', 'Male', '1992-02-28', '2021-01-22', 'matthew.harris@company.com', 'matthew.client@client.com', '09291234567', 'Quezon City'),
('Natalie', 'Rodriguez', 'Female', '1994-09-30', '2018-04-10', 'natalie.rodriguez@company.com', 'natalie.client@client.com', '09301234567', 'Pasig'),
('Oscar', 'Campbell', 'Male', '1990-07-15', '2020-09-05', 'oscar.campbell@company.com', 'oscar.client@client.com', '09311234567', 'Mandaluyong'),
('Paula', 'Wood', 'Female', '1998-12-05', '2023-06-27', 'paula.wood@company.com', 'paula.client@client.com', '09321234567', 'Manila'),
('Quincy', 'Parker', 'Male', '1995-11-30', '2017-03-18', 'quincy.parker@company.com', 'quincy.client@client.com', '09331234567', 'Las Piñas'),
('Rebecca', 'Scott', 'Female', '1996-07-25', '2019-10-09', 'rebecca.scott@company.com', 'rebecca.client@client.com', '09341234567', 'Parañaque'),
('Samuel', 'Johnson', 'Male', '1991-05-08', '2016-11-01', 'samuel.johnson@company.com', 'samuel.client@client.com', '09351234567', 'Caloocan'),
('Tina', 'Nelson', 'Female', '1993-10-19', '2021-07-15', 'tina.nelson@company.com', 'tina.client@client.com', '09361234567', 'San Juan');

INSERT INTO employee_assignments (employee_id, team_leader_id, cluster_manager_id) VALUES
(11, 1, 1), (12, 2, 2), (13, 3, 2), (14, 1, 1), (15, 2, 2), 
(16, 3, 2), (17, 4, 3), (18, 5, 2), (19, 1, 1), (20, 3, 2), 
(21, 4, 3), (22, 5, 2), (23, 1, 1), (24, 3, 2), (25, 4, 3), 
(26, 5, 2), (27, 2, 2), (28, 3, 2), (29, 4, 3), (30, 5, 2);




SELECT * FROM employees;
SELECT * FROM team_leaders;
SELECT * FROM cluster_managers;
SELECT * FROM employee_assignments;
SELECT * FROM lines_of_business;


DESCRIBE team_leaders;

SET FOREIGN_KEY_CHECKS = 1;
TRUNCATE TABLE team_leaders;

CREATE VIEW employee_assignment_view AS
SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, -- Correcting Supervisor to show Team Leader
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;


--Shows the number of male, female, and other gender identities across employees.
SELECT gender, COUNT(*) FROM employees GROUP BY gender


--Calculates the average age of employees using their birth dates.
SELECT AVG(YEAR(CURDATE()) - YEAR(birth_date)) AS avg_age
FROM employees;


-- Displays the percentage of employees retained per business line. ✔ Formula: (Active Employees / Total Employees) * 100
SELECT lob.name AS Line_of_Business, 
       COUNT(e.employee_id) AS total_employees,
       COUNT(e.employee_id) - COUNT(e.termination_date) AS retained_employees,
       (COUNT(e.employee_id) - COUNT(e.termination_date)) / COUNT(e.employee_id) * 100 AS retention_rate
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id   
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
GROUP BY lob.name;


-- Finds the most frequent termination reason. ✔ Ranks reasons by termination count.
SELECT termination_reason, COUNT(*) AS total_terminations
FROM employees
WHERE termination_date IS NOT NULL
GROUP BY termination_reason
ORDER BY total_terminations DESC;


SELECT * FROM employees


-- Calculates how long employees worked before leaving (in years). ✔ Ignores employees still active.
SELECT AVG(DATEDIFF(termination_date, hire_date) / 365) AS avg_tenure
FROM employees
WHERE termination_date IS NOT NULL;


INSERT INTO employees (employee_id,first_name, last_name, gender, birth_date, hire_date, termination_date, termination_reason, corporate_email, client_email, contact_number, location) VALUES 
(31,'Sophia', 'Garcia', 'Female', '1992-09-14', '2018-11-20', '2025-05-15', 'Pursuing Further Studies', 'sophia.garcia@company.com', 'sophia.client23@client.com', '09171234567', 'Manila'),
(32,'Ethan', 'Martinez', 'Male', '1990-04-05', '2016-08-10', '2025-05-10', 'Better Career Opportunity', 'ethan.martinez@company.com', 'ethan.client34@client.com', '09181234567', 'Cebu City');


SELECT * FROM employees

DELETE FROM employees WHERE employee_id IN (31,32);

ALTER TABLE employees
DROP COLUMN is_active;

ALTER TABLE employees
ADD COLUMN is_active TINYINT(1) AS (
    CASE WHEN termination_date IS NULL THEN 1 ELSE 0 END
) STORED;



SHOW CREATE TABLE employees;

INSERT INTO employees (first_name, last_name, gender, birth_date, hire_date, termination_date, termination_reason, corporate_email, client_email, contact_number, location) VALUES 
('Sophia', 'Garcia', 'Female', '1992-09-14', '2018-11-20', '2025-05-15', 'Pursuing Further Studies', 'sophia.garcia@company.com', 'sophia.client23@client.com', '09171234567', 'Manila'),
('Ethan', 'Martinez', 'Male', '1990-04-05', '2016-08-10', '2025-05-10', 'Better Career Opportunity', 'ethan.martinez@company.com', 'ethan.client34@client.com', '09181234567', 'Cebu City');

SELECT employee_id, first_name, last_name, is_active, termination_date
FROM employees
WHERE termination_date IS NOT NULL;

ALTER TABLE employees MODIFY employee_id INT AUTO_INCREMENT;

SHOW TABLE STATUS LIKE 'employees';

ALTER TABLE employees AUTO_INCREMENT = 1;

SELECT * FROM employees



-- Tracks termination changes, including old vs new values. ✔ Stores who made the change for accountability. ✔ Ensures historical tracking for resignations.
CREATE TABLE termination_audit_log (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    previous_termination_date DATE,
    new_termination_date DATE,
    previous_is_active TINYINT(1),
    new_is_active TINYINT(1),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100), -- Can store username or admin ID making the change
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);



-- Automatically logs termination date changes. ✔ Keeps a history of modifications for resignations. ✔ USER() captures who made the update.
CREATE TRIGGER log_termination_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.termination_date != NEW.termination_date THEN
        INSERT INTO termination_audit_log (employee_id, previous_termination_date, new_termination_date, previous_is_active, new_is_active, change_timestamp, changed_by)
        VALUES (NEW.employee_id, OLD.termination_date, NEW.termination_date, OLD.is_active, NEW.is_active, NOW(), USER());
    END IF;
END;


-- Displays all resignations updates and edits.
SELECT * FROM termination_audit_log ORDER BY change_timestamp DESC;



INSERT INTO employees (employee_id, first_name, last_name, gender, birth_date, hire_date, termination_date, termination_reason, corporate_email, client_email, contact_number, location) VALUES
(33, 'Isabella', 'Reyes', 'Female', '1993-06-21', '2019-04-01', '2025-05-20', 'Relocation Abroad', 'isabella.reyes@company.com', 'isabella.client45@client.com', '09201234567', 'Davao City'),
(34, 'Liam', 'Cruz', 'Male', '1988-12-11', '2014-09-05', '2025-05-18', 'Retirement', 'liam.cruz@company.com', 'liam.client56@client.com', '09301234567', 'Quezon City');


SELECT * FROM employees;

CREATE TABLE termination_audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    previous_termination_date DATE,
    new_termination_date DATE,
    previous_is_active TINYINT(1),
    new_is_active TINYINT(1),
    change_timestamp DATETIME,
    changed_by VARCHAR(100)
);




DROP TRIGGER IF EXISTS log_termination_changes;


/*
CREATE TRIGGER log_termination_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Only log if the termination_date is newly set
    IF OLD.termination_date IS NULL AND NEW.termination_date IS NOT NULL THEN
        INSERT INTO termination_audit_log (
            employee_id,
            previous_termination_date,
            new_termination_date,
            previous_is_active,
            new_is_active,
            change_timestamp,
            changed_by
        ) VALUES (
            NEW.employee_id,
            OLD.termination_date,
            NEW.termination_date,
            OLD.is_active,
            NEW.is_active,
            NOW(),
            USER()
        );
    END IF;
END;
*/


CREATE TRIGGER log_termination_changes
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Log if termination_date was added, changed, or removed
    IF (OLD.termination_date IS NULL AND NEW.termination_date IS NOT NULL)
       OR (OLD.termination_date IS NOT NULL AND NEW.termination_date IS NULL)
       OR (OLD.termination_date IS NOT NULL AND NEW.termination_date IS NOT NULL AND OLD.termination_date != NEW.termination_date) THEN

        INSERT INTO termination_audit_log (
            employee_id,
            previous_termination_date,
            new_termination_date,
            previous_is_active,
            new_is_active,
            change_timestamp,
            changed_by
        ) VALUES (
            NEW.employee_id,
            OLD.termination_date,
            NEW.termination_date,
            OLD.is_active,
            NEW.is_active,
            NOW(),
            USER()
        );

    END IF;
END;


SELECT * FROM employees


UPDATE employees
SET termination_date = '2025-05-31'
WHERE employee_id = 28;

SELECT * FROM termination_audit_log

UPDATE employees
SET termination_date = NULL
WHERE employee_id = 28;

DELETE FROM termination_audit_log


SELECT 
    employee_id,
    first_name,
    last_name,
    hire_date,
    termination_date,
    DATEDIFF(termination_date, hire_date) / 365 AS tenure_years
FROM employees
WHERE termination_date IS NOT NULL;


SELECT * FROM employee_assignments

SELECT * FROM employee_movements

UPDATE employee_assignments
SET team_leader_id = 1, cluster_manager_id = 1
WHERE employee_id = 4;

SELECT * FROM employee_assignments
WHERE employee_id = 4;


DROP VIEW IF EXISTS employee_assignment_view;

SELECT * from employees

UPDATE employees
SET termination_date = NULL, termination_reason = NULL
WHERE employee_id = 34;

SELECT * FROM termination_audit_log


SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, -- Correcting Supervisor to show Team Leader
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    e.hire_date,
    ea.assigned_date
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;

SELECT COUNT(*) from employees WHERE is_active = 0;

SELECT team_leader_id,COUNT(*) from employee_assignments GROUP BY team_leader_id;

SELECT * FROM employee_assignments

INSERT INTO employee_assignments (employee_id, team_leader_id, cluster_manager_id) VALUES
(31, 1, 1), -- New employee assigned to Team Leader 1, Cluster Manager 1
(32, 2, 2), -- New employee assigned to Team Leader 2, Cluster Manager 2
(33, 3, 2), -- New employee assigned to Team Leader 3, Cluster Manager 2
(34, 4, 3);


SELECT * FROM employees

SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, 
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date,
    ROUND(DATEDIFF(CURDATE(), ea.assigned_date) / 365.25, 2) AS Tenure_Years
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;


SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, 
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date,
    ROUND(DATEDIFF(CURDATE(), ea.assigned_date) / 30.44, 1) AS Tenure_Months
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;


SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, 
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date,
    DATEDIFF(CURDATE(), ea.assigned_date) AS Tenure_Days
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;

CREATE  VIEW employee_assignment_view AS
SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name, 
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    e.hire_date,
    e.termination_date,
    ea.assigned_date,
    ROUND(DATEDIFF(CURDATE(), e.hire_date)/ 365.25, 2) AS Company_Tenure_Years,
    DATEDIFF(CURDATE(), ea.assigned_date) AS Assignment_Tenure_Days
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;


DROP VIEW IF EXISTS employee_assignment_view;




-- Define the time period
SET @start_date = '2025-04-01';
SET @end_date = '2025-04-30';

-- Calculate attrition rate
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
    ) AS attrition_rate_percentage;


SELECT * from employees

SELECT termination_date FROM employees WHERE termination_date IS NOT NULL;


-- test query for employees left in April 2025
SET @start_date = '2025-04-01';
SET @end_date = '2025-04-30';


SELECT 
    COUNT(*) AS employees_left
FROM employees
WHERE termination_date BETWEEN @start_date AND @end_date;



SELECT * FROM employees

-- working query for attrition rate in April 2025
SET @start_date = '2025-04-01';
SET @end_date = '2025-05-31';

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


SELECT * from employees ORDER BY hire_date DESC;