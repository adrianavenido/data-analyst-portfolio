
# 📊 NSAT Dashboard – Power BI + MySQL

This project showcases a Net Satisfaction (NSAT) analysis dashboard built in Power BI, using customer survey data sourced from a MySQL database. It focuses on delivering actionable insights to help improve customer experience.

---

## 📌 Objective

To analyze **customer sentiment** and **identify areas for improvement** by tracking NSAT trends, detractor drivers, and team-level performance across time and locations.

---

## 🛠️ Tools & Technologies

- **Power BI** for data visualization
- **MySQL** for data storage and querying
- **DAX** for calculated measures
- **SQL** for data transformation
- Optional: Excel/CSV for backups & prototyping

---

## 📊 Key Features

| Feature                     | Description |
|----------------------------|-------------|
| NSAT Score Trend           | Weekly/Monthly visualization of net satisfaction score |
| Driver Analysis            | Breakdown of promoter, passive, and detractor reasons |
| Agent Performance          | Ranking by NSAT score, filtered by teams |
| Drill-Down Interactivity   | Click to explore trends by site, team, or time |
| Filters                    | Date range, team, channel, and region |

---

## 🧩 Data Model

- **Source**: `customer_feedback` table from MySQL
- **Fact Table**: Survey responses
- **Dimension Tables**: Agents, Teams, Regions, Survey Type
- **Measures**:
  - `NSAT = ((Promoters - Detractors) / Total Respondents) * 100`
  - `Promoter Count`, `Detractor Count`, `Passive Count`

---

## 🧾 SQL Query Example

```sql
-- Drop tables if they already exist (optional cleanup)
DROP TABLE IF EXISTS csat;
DROP TABLE IF EXISTS roster;

-- Create Roster table
CREATE TABLE roster (
    employee_name VARCHAR(100) PRIMARY KEY,
    supervisor VARCHAR(100),
    manager VARCHAR(100)
);

-- Insert 20 employees under 5 supervisors and 2 managers
INSERT INTO roster (employee_name, supervisor, manager) VALUES
('Alice Smith', 'John Doe', 'Mary Johnson'),
('Bob Jones', 'John Doe', 'Mary Johnson'),
('Charlie Lee', 'John Doe', 'Mary Johnson'),
('Diana Green', 'John Doe', 'Mary Johnson'),
('Ethan Brown', 'John Doe', 'Mary Johnson'),

('Fiona Black', 'Sarah Kim', 'Mary Johnson'),
('George White', 'Sarah Kim', 'Mary Johnson'),
('Hannah Adams', 'Sarah Kim', 'Mary Johnson'),
('Ian Clark', 'Sarah Kim', 'Mary Johnson'),
('Jane Foster', 'Sarah Kim', 'Mary Johnson'),

('Kevin Reed', 'Tom Hall', 'David Smith'),
('Laura Bell', 'Tom Hall', 'David Smith'),
('Michael King', 'Tom Hall', 'David Smith'),
('Nina Cook', 'Tom Hall', 'David Smith'),
('Oliver Ward', 'Tom Hall', 'David Smith'),

('Paula Scott', 'Emma Price', 'David Smith'),
('Quentin Ross', 'Emma Price', 'David Smith'),
('Rachel Gray', 'Emma Price', 'David Smith'),
('Samuel Wood', 'Emma Price', 'David Smith'),
('Tina Evans', 'Emma Price', 'David Smith');

-- Create CSAT table
CREATE TABLE csat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date_of_survey DATE,
    employee_name VARCHAR(100),
    csat_score INT,
    FOREIGN KEY (employee_name) REFERENCES roster(employee_name)
);

-- Procedure to populate 1 year of CSAT data
DELIMITER $$

CREATE PROCEDURE populate_csat()
BEGIN
    DECLARE emp_name VARCHAR(100);
    DECLARE survey_date DATE;
    DECLARE emp_cursor CURSOR FOR SELECT employee_name FROM roster;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @done = TRUE;

    SET @done = FALSE;
    OPEN emp_cursor;

    emp_loop: LOOP
        FETCH emp_cursor INTO emp_name;
        IF @done THEN
            LEAVE emp_loop;
        END IF;

        SET @month = 0;
        WHILE @month < 12 DO
            SET @day = 1;
            WHILE @day <= 5 DO
                SET survey_date = DATE_ADD('2024-05-01', INTERVAL @month MONTH);
                SET survey_date = DATE_ADD(survey_date, INTERVAL FLOOR(RAND() * 28) DAY);

                INSERT INTO csat (date_of_survey, employee_name, csat_score)
                VALUES (
                    survey_date,
                    emp_name,
                    ELT(FLOOR(1 + RAND() * 3), 100, 0, -100)
                );

                SET @day = @day + 1;
            END WHILE;
            SET @month = @month + 1;
        END WHILE;

    END LOOP;

    CLOSE emp_cursor;
END$$

DELIMITER ;

-- Call procedure
CALL populate_csat();

-- Optional: drop the procedure after use
DROP PROCEDURE populate_csat;

```

> Full query is saved in https://raw.githubusercontent.com/adrianavenido/data-analyst-portfolio/refs/heads/main/portfolio_projects/nsat_dashboard_powerbi/nsat_data_extraction.sql

---

## 🖼️ Preview

![NSAT Dashboard Preview](./images/nsat_dashboard_preview.png)

---

## 🧠 Insights Gained

- Team X has the highest number of detractors driven by "Agent Courtesy"
- Region Y's NSAT dropped significantly in Q2 2024
- Promoter scores are highest in surveys post-issue resolution

---

## 📎 Supporting Files

- `nsat_report.pbix` – Full Power BI dashboard
- `sql_queries/` – All SQL used for data extraction
- `data/sample_nsat_data.csv` – Dummy data for demo (if allowed)
- `documentation/nsat_case_study.pdf` – PDF report for stakeholder presentation

---

## 🚀 How to Run

1. Import data from your MySQL database or use the sample CSV
2. Open `nsat_report.pbix` in Power BI
3. Update the data source in Power BI to point to your own SQL server
4. Refresh the model

---

## 📬 Contact

For questions, feedback, or collaboration:
- 📧 yourname@email.com
- 🔗 [LinkedIn](https://linkedin.com/in/yourprofile)
