
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
SELECT
  survey_id,
  agent_id,
  team,
  survey_date,
  nsat_rating,
  CASE
    WHEN nsat_rating = 100 THEN 'Promoter'
    WHEN nsat_rating = 0 THEN 'Passive'
    WHEN nsat_rating = -100 THEN 'Detractor'
  END AS sentiment
FROM customer_feedback
WHERE survey_date BETWEEN '2024-01-01' AND '2024-12-31';
```

> Full query is saved in [`sql_queries/nsat_data_extraction.sql`](./sql_queries/nsat_data_extraction.sql)

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
