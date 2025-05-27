# Employee Masterlist SQL Portfolio Project

 🔍 Description
This SQL portfolio project leverages **MySQL, VS Code, Git, and GitHub** to explore employee data, analyze workforce trends, and answer key business questions. The focus includes **retention, leadership effectiveness, workforce planning,** and **predictive analytics**.

---

📂 Project Structure

Employee-Masterlist-SQL-Portfolio/ 
├── data/                       # Sample datasets (CSV, Excel) 
├── scripts/                    # SQL queries & analysis 
│   ├── schema.sql              # Database schema creation 
│   ├── queries.sql             # SQL queries for business questions 
│   ├── analytics.sql           # Advanced analytical queries 
│   ├── data_cleaning.sql       # Data preprocessing & transformations 
├── outputs/                    # Query results, visualizations, screenshots 
├── docs/                       # Final report, Power BI insights, README files 
│   ├── README.md               # Project overview & methodology 
│   ├── database_design.md      # Schema & table descriptions 
│   ├── query_reference.md      # SQL query documentation 
│   ├── analytics_methods.md    # Statistical analysis & insights
│   ├── employee_er_diagram.mmd # Entity-Relationship (ER) diagram (Mermaid format)

---

🛠 **Tools & Technologies Utilized**

- **MySQL** – Reliable relational database management for structured data storage and analysis  
- **Visual Studio Code** – Efficient SQL development, code editing, and project documentation  
- **Git & GitHub** – Version control for project management and readiness for collaborative workflows  
- **Microsoft Excel** – Primary data source for employee records, preprocessing, and exploratory analysis  
- **Tableau** – Advanced data visualization and interactive dashboards (integrated via ODBC with Excel)  

*This project was developed independently, demonstrating strong individual initiative and technical proficiency, while leveraging industry-standard tools that also support collaborative environments.*

---

📊 Business Questions Answered
Employee Demographics & Retention  
1. What is the gender distribution among employees?  
2. What is the average age of employees?  
3. What is the retention rate per line of business?  
4. What is the most common reason for employee termination?  
5. What is the average tenure of employees before termination?  

Team & Management Performance  
6. Which team leader has the highest retention rate among employees?  
7. How does employee tenure vary across different teams?    
8. Which cluster manager oversees the most employees?  
9. Which line of business experiences the highest employee turnover?  
10. Which location has the most employees and the highest churn rate?  

Business Growth & Workforce Planning  
11. How has hiring volume changed over time?  
12. Which months or periods experience the highest hiring rates?  
13. What percentage of employees are currently active versus terminated?  
14. How many employees per line of business require replacement due to terminations?  

Advanced Analytical Questions  

Employee Retention & Attrition  
15. What is the likelihood of an employee leaving within their first year based on historical data?  
16. How does employee tenure correlate with termination reason (voluntary vs. involuntary)?  
17. Can we identify early warning signs of potential attrition based on hire date and performance trends?  
18. Which employee demographics (age, gender, location) show higher retention rates?  
19. How does the number of terminations impact team performance and overall business continuity?  

Leadership & Management Effectiveness  
20. Which team leaders consistently maintain high-performing teams based on tenure and retention?  
21. How do the leadership styles of team leaders and cluster managers affect employee longevity?  
22. What is the average employee satisfaction or performance rating under each manager?  
23. Can we predict future managerial effectiveness based on past team performance metrics?  

Workforce Planning & Business Strategy  
24. What is the ideal hiring rate to ensure business growth while minimizing turnover risk?  
25. How does the hiring pattern align with business expansion and profitability?  
26. Are there seasonal trends in hiring or terminations that could impact workforce planning?  
27. What percentage of employees require immediate succession planning due to attrition?  

Compensation & Incentives  
28. How does salary and bonus structure impact employee retention rates?  
29. What is the correlation between financial incentives and performance ratings?  
30. Do employees who receive promotions have higher tenure compared to those who don’t?  

Predictive Analytics & AI-Driven Insights  
31. Can we create a model to predict employee turnover risk based on historical data?  
32. How do hiring and termination rates correlate with external economic trends?  
33. What AI-driven recommendations can optimize employee satisfaction and retention?  
---

📑 Database Schema Overview  
This **normalized MySQL schema** ensures structured workforce analysis and efficient data retrieval.

#🧱 Core Tables
| Table Name            | Description |
|----------------------|------------|
| `employees`          | Stores employee details, tenure, and attrition |
| `team_leaders`       | Lists team leaders managing different business units |
| `cluster_managers`   | Details of senior managers handling teams |
| `lines_of_business`  | Defines various operational divisions |
| `coaching_logs`      | Tracks leadership coaching and training |
| `attendance_tracking`| Monitors employee attendance patterns |

#🔗 Table Relationships

[employees] → [team_leaders] → [cluster_managers] [employees] → [lines_of_business] → [capacity_target] [employees] → [coaching_logs] → [attendance_tracking]

#📊 Key Attributes

`employees` (Main Table)
- `employee_id` (Primary Key)
- `first_name`, `last_name`
- `gender`, `birth_date`
- `hire_date`, `termination_date`
- `team_leader_id` (Foreign Key)
- `lob_id` (Foreign Key)

`coaching_logs`
- `coaching_id` (Primary Key)
- `employee_id` (Foreign Key)
- `coach_id` (Foreign Key)
- `coaching_date`
- `impact_score` (1-5 rating)

`attendance_tracking`
- `attendance_id` (Primary Key)
- `employee_id` (Foreign Key)
- `total_working_days`, `present_days`
- `absent_days` (Auto-calculated)
- `leave_type` (Sick Leave, Vacation Leave, etc.)

---

📌 Notes
✔ **Full database schema**: See [`../scripts/schema.sql`](../scripts/schema.sql) for complete table definitions and relationships.  
✔ **Business insights SQL**: Explore key queries in [`../scripts/queries.sql`](../scripts/queries.sql).  
✔ **Data preprocessing & design**: Methods and schema details are in [`../docs/database_design.md`](../docs/database_design.md).  
✔ **Entity-Relationship Diagram**: [View ER Diagram (Mermaid)](./employee_er_diagram.mmd)
