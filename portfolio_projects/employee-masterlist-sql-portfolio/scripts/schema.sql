-- ===============================
-- Employee Masterlist Analysis SQL Documentation
-- ===============================

-- ===============================
-- 1. Database Schema Definitions
-- ===============================

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

INSERT INTO lines_of_business (lob_id, name) VALUES
(1, 'Finance'),
(2, 'Customer Support'),
(3, 'IT Services'),
(4, 'Sales'),
(5, 'Marketing');

INSERT INTO capacity_target (lob_id, target_fte, updated_at) VALUES
(1, 150, '2025-05-01 08:00:00'),
(2, 200, '2025-05-01 08:00:00'),
(3, 250, '2025-05-01 08:00:00'),
(4, 300, '2025-05-01 08:00:00'),
(5, 180, '2025-05-01 08:00:00');

INSERT INTO coaching_logs (employee_id, coach_id, coaching_date, coaching_notes, impact_score) VALUES
(1, 1, '2025-04-10', 'Reviewed onboarding challenges and progress.', 5),
(2, 2, '2025-04-12', 'Guidance on communication skills improvement.', 4),
(3, 3, '2025-04-15', 'Addressed workflow efficiency concerns.', 3),
(4, 4, '2025-04-20', 'Performance coaching to enhance productivity.', 5),
(5, 5, '2025-04-22', 'Discussion on teamwork and collaboration.', 4);

INSERT INTO attendance_tracking (employee_id, total_working_days, present_days, leave_type) VALUES
(1, 22, 20, 'Sick Leave'),
(2, 22, 18, 'Vacation Leave'),
(3, 22, 22, NULL),
(4, 22, 21, 'Unpaid Leave'),
(5, 22, 19, 'Sick Leave');


-- ===============================
-- End of Documentation
-- ===============================
