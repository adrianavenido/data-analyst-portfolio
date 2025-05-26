-- ===============================
-- Employee Masterlist Analysis SQL Documentation
-- ===============================

-- ===============================
-- 1. Database Schema Definitions
-- ===============================

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS masterlist;

-- Use the database
USE masterlist;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    termination_date DATE,
    termination_reason ENUM('Voluntary', 'Involuntary'),
    corporate_email VARCHAR(100) UNIQUE NOT NULL,
    client_email VARCHAR(100) UNIQUE NOT NULL,
    contact_number VARCHAR(20) NOT NULL, -- Anonymized
    location VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    lob_id INT,
    team_leader_id INT,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (team_leader_id) REFERENCES team_leaders(team_leader_id)
);

CREATE TABLE team_leaders (
    team_leader_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    lob_id INT,
    cluster_manager_id INT,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);

CREATE TABLE cluster_managers (
    cluster_manager_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    line_of_business VARCHAR(100) NOT NULL
);

CREATE TABLE lines_of_business (
    lob_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE capacity_target (
    lob_id INT PRIMARY KEY,
    target_fte INT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id)
);

CREATE TABLE coaching_logs (
    coaching_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    coach_id INT NOT NULL,
    coaching_date DATE NOT NULL,
    coaching_notes TEXT,
    impact_score INT CHECK (impact_score BETWEEN 1 AND 5),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (coach_id) REFERENCES team_leaders(team_leader_id)
);

CREATE TABLE attendance_tracking (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    total_working_days INT NOT NULL,
    present_days INT NOT NULL,
    absent_days INT GENERATED ALWAYS AS (total_working_days - present_days),
    leave_type ENUM('Sick Leave', 'Vacation Leave', 'Unpaid Leave') DEFAULT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ===============================
-- 2. Sample Data Inserts
-- ===============================


INSERT INTO employees (first_name, last_name, gender, birth_date, hire_date, termination_date, termination_reason, corporate_email, client_email, contact_number, location, is_active, lob_id, team_leader_id)
VALUES
('John', 'Doe', 'Male', '1985-04-12', '2015-06-01', NULL, NULL, 'john.doe@corp.com', 'j.doe@email.com', '123-456-7890', 'New York', TRUE, 1, 5),
('Jane', 'Smith', 'Female', '1990-09-22', '2017-03-15', NULL, NULL, 'jane.smith@corp.com', 'j.smith@email.com', '987-654-3210', 'Los Angeles', TRUE, 2, 6),
('Alice', 'Brown', 'Female', '1982-11-05', '2010-08-24', '2022-05-30', 'Voluntary', 'alice.brown@corp.com', 'a.brown@email.com', '555-123-9876', 'Chicago', FALSE, 3, NULL),
('Bob', 'Johnson', 'Male', '1995-07-19', '2019-12-10', NULL, NULL, 'bob.johnson@corp.com', 'b.johnson@email.com', '444-789-1234', 'Houston', TRUE, 4, 7),
('Emily', 'Davis', 'Female', '1988-06-30', '2016-07-18', NULL, NULL, 'emily.davis@corp.com', 'e.davis@email.com', '333-456-7890', 'San Francisco', TRUE, 5, 8),
('Michael', 'Wilson', 'Male', '1980-03-25', '2008-05-14', '2021-11-01', 'Involuntary', 'michael.wilson@corp.com', 'm.wilson@email.com', '222-123-4567', 'Seattle', FALSE, 6, NULL),
('Sophia', 'Martinez', 'Female', '1992-01-08', '2020-09-23', NULL, NULL, 'sophia.martinez@corp.com', 's.martinez@email.com', '777-987-6543', 'Denver', TRUE, 7, 9),
('James', 'Taylor', 'Male', '1984-12-15', '2012-02-10', NULL, NULL, 'james.taylor@corp.com', 'j.taylor@email.com', '888-456-3210', 'Boston', TRUE, 8, 10),
('Olivia', 'Anderson', 'Female', '1998-08-03', '2021-04-05', NULL, NULL, 'olivia.anderson@corp.com', 'o.anderson@email.com', '666-789-0123', 'Austin', TRUE, 9, 11),
('David', 'Thomas', 'Male', '1987-05-27', '2014-11-29', '2023-02-15', 'Voluntary', 'david.thomas@corp.com', 'd.thomas@email.com', '999-654-3210', 'Phoenix', FALSE, 10, NULL);

INSERT INTO team_leaders (name, lob_id, cluster_manager_id) VALUES
('Sophia Rivera', 1, 1), -- Billing
('James Fernandez', 2, 2), -- Accounts Receivable
('Lily Gomez', 3, 3), -- Global
('Nathan Cruz', 4, 4), -- Order Management
('Olivia Mendoza', 1, 1), -- Billing
('William Santos', 1, 2), -- Accounts Receivable
('Emma Castillo', 2, 3), -- Global
('Lucas Ramos', 3, 4), -- Order Management
('Mia Torres', 4, 5), -- Billing
('Daniel Navarro', 1, 2); -- Accounts Receivable


INSERT INTO cluster_managers (name, region) VALUES
('Daniel Reyes', 'Billing'),
('Maria Santos', 'Accounts Receivable'),
('Carlos Mendoza', 'Global'),
('Angela Cruz', 'Order Management'),
('Fernando Lopez', 'Billing');


INSERT INTO lines_of_business (lob_name, department_id) VALUES
('Order Management', 1),
('Billing', 1),
('Accounts Receivables', 1),

INSERT INTO lines_of_business (name) VALUES
('Disputes'),
('Reporting'),
( 'Cash Application');


INSERT INTO capacity_target (lob_id, target_fte, updated_at) VALUES
(1, 150, '2025-05-01 08:00:00'),
(2, 200, '2025-05-01 08:00:00'),
(3, 250, '2025-05-01 08:00:00'),
(4, 300, '2025-05-01 08:00:00');

INSERT INTO coaching_logs (employee_id, coach_id, coaching_date, coaching_notes, impact_score) VALUES
(1, 1, '2025-04-10', 'Reviewed onboarding challenges and progress.', 5),
(2, 2, '2025-04-12', 'Guidance on communication skills improvement.', 4),
(3, 3, '2025-04-15', 'Addressed workflow efficiency concerns.', 3),
(4, 4, '2025-04-20', 'Performance coaching to enhance productivity.', 5),
(5, 5, '2025-04-22', 'Discussion on teamwork and collaboration.', 4),
(6, 6, '2025-04-25', 'Reviewed technical skill gaps and training plan.', 3),
(7, 7, '2025-05-01', 'Leadership development coaching session.', 5),
(8, 8, '2025-05-05', 'Time management strategies and prioritization.', 4),
(9, 9, '2025-05-07', 'Guidance on handling client interactions effectively.', 4),
(10, 10, '2025-05-10', 'Addressed motivation and goal-setting strategies.', 5),
(11, 1, '2025-05-12', 'Coaching on improving documentation practices.', 3),
(12, 2, '2025-05-15', 'Session on conflict resolution in teams.', 5),
(13, 3, '2025-05-18', 'Enhancing presentation skills.', 4),
(14, 4, '2025-05-20', 'Performance feedback and improvement plan.', 4),
(15, 5, '2025-05-22', 'Guidance on maintaining work-life balance.', 3),
(16, 6, '2025-05-25', 'Training session on data handling best practices.', 5),
(17, 7, '2025-05-28', 'Discussion on leadership skills and career growth.', 5),
(18, 8, '2025-05-30', 'Feedback on attendance and punctuality.', 3),
(19, 9, '2025-06-01', 'Coaching on adaptability and change management.', 4),
(20, 10, '2025-06-03', 'Session focused on role-based efficiency strategies.', 5);

INSERT INTO attendance_tracking (employee_id, total_working_days, present_days, leave_type) VALUES
(1, 22, 20, 'Sick Leave'),
(2, 22, 18, 'Vacation Leave'),
(3, 22, 22, NULL),
(4, 22, 21, 'Unpaid Leave'),
(5, 22, 19, 'Sick Leave');

-- ===============================
-- End of Documentation
-- ===============================
