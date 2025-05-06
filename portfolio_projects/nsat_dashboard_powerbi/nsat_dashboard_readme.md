
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
