Certainly! Below is a **comprehensive documentation** in **Markdown (`.md`) format** that details the **database creation, structure, and functionality**.

---

### **Employee Management Database Documentation**
**Author:** _Your Name_  
**Date:** _May 28, 2025_  
**Database Name:** `employee_management`

---

## **Table of Contents**
1. [Introduction](#introduction)  
2. [Database Schema Overview](#database-schema-overview)  
3. [Table Structures](#table-structures)  
4. [Relationships & Constraints](#relationships--constraints)  
5. [Views](#views)  
6. [Triggers for Automatic Updates](#triggers-for-automatic-updates)  
7. [Sample Queries](#sample-queries)  
8. [Future Improvements](#future-improvements)  

---

## **Introduction**
This documentation outlines the design and implementation of an **Employee Management Database**, structured to track employees, their team leaders, cluster managers, and business lines. Additionally, it logs **employee movements** for historical tracking.

---

## **Database Schema Overview**
The schema consists of **six core tables**:
- `employees`: Stores employee details.
- `team_leaders`: Stores team leader details.
- `cluster_managers`: Stores cluster manager details.
- `lines_of_business`: Stores different business units.
- `employee_assignments`: Stores current employee-to-team mappings.
- `employee_movements`: Logs employee movement history.

![Database Schema](schema-diagram-url.png) *(Replace with actual diagram link)*

---

## **Table Structures**
### **1. Employees**
```sql
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
```
### **2. Team Leaders**
```sql
CREATE TABLE team_leaders (
    team_leader_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    lob_id INT NOT NULL,
    cluster_manager_id INT NOT NULL,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);
```

### **3. Cluster Managers**
```sql
CREATE TABLE cluster_managers (
    cluster_manager_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    lob_id INT NOT NULL,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id)
);
```

### **4. Lines of Business**
```sql
CREATE TABLE lines_of_business (
    lob_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);
```

### **5. Employee Assignments**
```sql
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
```

### **6. Employee Movements**
```sql
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
```

---

## **Relationships & Constraints**
The database follows **referential integrity** using **foreign keys**:
- **Employees → Team Leaders** (`team_leader_id`)
- **Team Leaders → Cluster Managers** (`cluster_manager_id`)
- **Cluster Managers → Lines of Business** (`lob_id`)
- **Employee Assignments → Team Leaders & Cluster Managers**
- **Employee Movements logs historical changes**

---

## **Views**
### **Employee Assignment View**
To **simplify querying active employee assignments**, we create a view:
```sql
CREATE VIEW employee_assignment_view AS
SELECT 
    e.employee_id, 
    e.first_name AS Employee_First_Name, 
    e.last_name AS Employee_Last_Name, 
    e.gender, 
    e.location, 
    CONCAT(tl.first_name, ' ', tl.last_name) AS Supervisor_Name,
    cm.name AS Cluster_Manager_Name, 
    lob.name AS Line_of_Business, 
    ea.assigned_date
FROM employees e
JOIN employee_assignments ea ON e.employee_id = ea.employee_id
JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;
```
**Usage:**  
```sql
SELECT * FROM employee_assignment_view;
```

---

## **Triggers for Automatic Updates**
### **Track Employee Movements Automatically**
```sql
CREATE TRIGGER track_team_changes
AFTER UPDATE ON employee_assignments
FOR EACH ROW
INSERT INTO employee_movements (
    employee_id, previous_team_leader_id, new_team_leader_id, previous_cluster_manager_id, new_cluster_manager_id
)
VALUES (NEW.employee_id, OLD.team_leader_id, NEW.team_leader_id, OLD.cluster_manager_id, NEW.cluster_manager_id);
```
This ensures **every team change is logged automatically**.

---

## **Sample Queries**
### **Retrieve Employee Assignments**
```sql
SELECT * FROM employee_assignment_view;
```

### **Show Employee Movement History**
```sql
SELECT * FROM employee_movements ORDER BY change_date DESC;
```

### **Update Employee Team Assignment**
```sql
UPDATE employee_assignments 
SET team_leader_id = 3, cluster_manager_id = 2 
WHERE employee_id = 15;
```

---

## **Future Improvements**
- **Automated Reports** for HR teams
- **Scheduled Alerts** for upcoming employee transfers
- **Index Optimization** for faster lookups on historical movements
- **User Role-Based Access** to secure sensitive employee data

---

## **Conclusion**
This database provides a **structured, scalable** way to manage employees, their teams, movements, and assignments efficiently. With **automated tracking**, **historical logs**, and **simple query views**, it enables organizations to **track personnel changes dynamically**.

Let me know if you need additional customization or performance optimizations! 🚀  
Would you like me to add example **INSERT** statements for initial setup?



Sure! Below is a **Markdown (`.md`) file** documenting the **additional tables added** to the Employee Management Database, along with their purpose, best practices, and improvements.

---

# **Employee Management Database - Additional Tables Documentation**
**Author:** _Your Name_  
**Date:** _May 28, 2025_  
**Database Name:** `employee_management`

---

## **New Tables Added**
This document outlines the **additional tables introduced** to enhance tracking of employee risks, attendance, coaching, performance, and emergency contacts.

---

## **1. Early Warning Indicators (`early_warning_indicators`)**
### **Purpose**
This table tracks employees based on their **resignation intent**, categorizing them into **Green, Amber, or Red risk levels**.

### **Table Structure**
```sql
CREATE TABLE early_warning_indicators (
    risk_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    risk_level ENUM('Green', 'Amber', 'Red') NOT NULL, -- Green = Low, Amber = Medium, Red = High risk of resignation
    risk_reason ENUM('Low Engagement', 'High Absenteeism', 'Poor Performance', 'Manager Conflict', 'Personal Reasons') NOT NULL,
    reported_by INT NOT NULL,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution_status ENUM('Monitoring', 'Intervention Needed', 'Escalated') DEFAULT 'Monitoring',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reported_by) REFERENCES team_leaders(team_leader_id)
);
```

### **Best Practices**
✅ Ensure **timely updates** when employee risk levels change.  
✅ Link this table with **performance evaluations** to spot resignation patterns.  
✅ Set **alerts** when employees move into "Red" status.  

---

## **2. Performance Risk Tracking (`performance_risk_tracking`)**
### **Purpose**
Tracks performance-related risks such as **attendance issues, behavioral concerns, or performance decline**.

### **Table Structure**
```sql
CREATE TABLE performance_risk_tracking (
    warning_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    risk_type ENUM('Attendance Issues', 'Behavioral Concerns', 'Performance Decline') NOT NULL,
    description TEXT NOT NULL,
    reported_by INT NOT NULL,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution_status ENUM('Pending', 'Resolved', 'Escalated') DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reported_by) REFERENCES team_leaders(team_leader_id)
);
```

### **Best Practices**
✅ Use **historical tracking** to analyze employee risks over time.  
✅ Implement **trigger automation** to auto-detect performance dips.  
✅ Ensure **HR teams review and escalate critical cases**.  

---

## **3. Attendance Tracking (`attendance_tracking`)**
### **Purpose**
Logs employee attendance status, check-in/check-out times, and leave details.

### **Table Structure**
```sql
CREATE TABLE attendance_tracking (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    check_in_time TIMESTAMP,
    check_out_time TIMESTAMP,
    status ENUM('Present', 'Absent', 'Late', 'On Leave') NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
```

### **Best Practices**
✅ Integrate attendance tracking with **performance risk** data for deeper insights.  
✅ Use **triggers** to calculate late arrivals automatically.  
✅ Provide **monthly reports** to management for attendance trends.  

---

## **4. Coaching Logs (`coaching_logs`)**
### **Purpose**
Records employee coaching sessions, feedback, and improvement plans.

### **Table Structure**
```sql
CREATE TABLE coaching_logs (
    coaching_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    coach_id INT NOT NULL,
    session_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_notes TEXT,
    improvement_plan TEXT,
    follow_up_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (coach_id) REFERENCES team_leaders(team_leader_id)
);
```

### **Best Practices**
✅ Ensure employees receive **follow-ups** after coaching.  
✅ Link coaching sessions with **performance metrics**.  
✅ Store structured feedback for **continuous development**.  

---

## **5. Capacity Target (`capacity_target`)**
### **Purpose**
Tracks workforce capacity per team leader and cluster manager.

### **Table Structure**
```sql
CREATE TABLE capacity_target (
    target_id INT PRIMARY KEY AUTO_INCREMENT,
    lob_id INT NOT NULL,
    team_leader_id INT NOT NULL,
    cluster_manager_id INT NOT NULL,
    target_filled INT NOT NULL,
    available_capacity INT NOT NULL,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (team_leader_id) REFERENCES team_leaders(team_leader_id),
    FOREIGN KEY (cluster_manager_id) REFERENCES cluster_managers(cluster_manager_id)
);
```

### **Best Practices**
✅ Track **current vs required** workforce capacity.  
✅ Enable **real-time updates** to improve resource allocation.  
✅ Link data with **team performance** reports.  

---

## **6. Operations Score (`operations_score`)**
### **Purpose**
Stores monthly performance scores categorized into **Efficiency, Quality, Productivity**.

### **Table Structure**
```sql
CREATE TABLE operations_score (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    lob_id INT NOT NULL,
    team_leader_id INT NOT NULL,
    score INT CHECK (score BETWEEN 0 AND 100),
    performance_category ENUM('Efficiency', 'Quality', 'Productivity') NOT NULL,
    recorded_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lob_id) REFERENCES lines_of_business(lob_id),
    FOREIGN KEY (team_leader_id) REFERENCES team_leaders(team_leader_id)
);
```

### **Best Practices**
✅ **Use scheduled queries** to refresh scores monthly.  
✅ Ensure **performance categories are aligned with business KPIs**.  
✅ Store historical trends for **team optimization**.  

---

## **7. Behavioral Score (`behavioral_score`)**
### **Purpose**
Records behavioral evaluations with feedback.

### **Table Structure**
```sql
CREATE TABLE behavioral_score (
    behavior_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    review_date DATE NOT NULL,
    score INT CHECK (score BETWEEN 0 AND 100),
    feedback TEXT,
    reviewed_by INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewed_by) REFERENCES team_leaders(team_leader_id)
);
```

### **Best Practices**
✅ Assign **weighted behavioral scores** per review.  
✅ Ensure **feedback aligns with improvement plans**.  
✅ Store **trend analysis reports** for employee engagement.  

---

## **8. In Case of Emergency (`icoe_in_case_of_emergency`)**
### **Purpose**
Stores emergency contacts for employees.

### **Table Structure**
```sql
CREATE TABLE icoe_in_case_of_emergency (
    emergency_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    relationship_type ENUM('Spouse', 'Parent', 'Sibling', 'Friend', 'Other') NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    alternate_phone VARCHAR(15),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);
```

### **Best Practices**
✅ Store **multiple emergency contacts** per employee.  
✅ Ensure **HR teams keep records updated annually**.  
✅ Allow **quick retrieval for emergency situations**.  

---

## **Next Steps**
Would you like me to help set up **automated triggers**, **indexing**, or **alert notifications** when employees move between risk levels? 🚀  
Let me know how you'd like to refine tracking based on these new tables!
