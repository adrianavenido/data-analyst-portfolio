Here is a Markdown (`.md`) documentation file summarizing the troubleshooting steps, insights, and recommendations from this session:

---

````markdown
# 🛠 Employee Assignment View & Data Quality Troubleshooting

## 🧩 Issue Overview

The initial concern was that the `employee_assignment_view` was not reflecting all employee assignment records. Upon investigation, it was discovered that the issue stemmed from **missing records** in the `employee_assignments` table, rather than a problem with the view itself.

---

## ✅ Root Cause

Missing `INSERT` statements for newly added employees meant that no corresponding entries existed in the `employee_assignments` table. Therefore, when the view was queried (which uses `INNER JOIN`s), those employees were excluded.

Example of missing data:
```sql
INSERT INTO employee_assignments (employee_id, team_leader_id, cluster_manager_id) VALUES
(31, 1, 1),
(32, 2, 2),
(33, 3, 2),
(34, 4, 3);
````

---

## 🔄 Resolution Strategy

To prevent similar issues in the future, a series of **controls and monitoring strategies** are recommended.

---

## 🛡 Recommendations for Ensuring Data Completeness

### 1. Use `LEFT JOIN` in the View

Update the view to use `LEFT JOIN`s instead of `INNER JOIN`s so unassigned employees still appear:

```sql
CREATE OR REPLACE VIEW employee_assignment_view AS
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
LEFT JOIN employee_assignments ea ON e.employee_id = ea.employee_id
LEFT JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
LEFT JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
LEFT JOIN lines_of_business lob ON tl.lob_id = lob.lob_id
ORDER BY e.employee_id;
```

---

### 2. Add Data Validation Queries

#### Unassigned Employees:

```sql
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
LEFT JOIN employee_assignments ea ON e.employee_id = ea.employee_id
WHERE ea.employee_id IS NULL;
```

#### Invalid Assignments (Missing Manager Data):

```sql
SELECT ea.employee_id
FROM employee_assignments ea
LEFT JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
LEFT JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id
WHERE tl.team_leader_id IS NULL OR cm.cluster_manager_id IS NULL;
```

---

### 3. Build a Data Quality Summary View

```sql
CREATE OR REPLACE VIEW employee_data_quality_summary AS
SELECT 
    e.employee_id,
    CASE WHEN ea.employee_id IS NULL THEN 'Missing Assignment' ELSE 'OK' END AS assignment_status,
    CASE 
        WHEN ea.assigned_date > CURRENT_DATE THEN 'Future Date' 
        WHEN ea.assigned_date IS NULL THEN 'No Date'
        ELSE 'OK'
    END AS date_status,
    CASE 
        WHEN tl.team_leader_id IS NULL THEN 'Missing Team Leader'
        ELSE 'OK'
    END AS team_leader_status,
    CASE 
        WHEN cm.cluster_manager_id IS NULL THEN 'Missing Cluster Manager'
        ELSE 'OK'
    END AS cluster_manager_status
FROM employees e
LEFT JOIN employee_assignments ea ON e.employee_id = ea.employee_id
LEFT JOIN team_leaders tl ON ea.team_leader_id = tl.team_leader_id
LEFT JOIN cluster_managers cm ON ea.cluster_manager_id = cm.cluster_manager_id;
```

---

## 📊 Creating a Data Quality Dashboard

### Tool Options:

| Tool                    | Description                      |
| ----------------------- | -------------------------------- |
| Power BI                | Drag-and-drop, scheduled reports |
| Tableau                 | Interactive, real-time insights  |
| Metabase                | Lightweight and SQL-friendly     |
| Excel                   | Good for small-scale checks      |
| Python (Streamlit/Dash) | Fully customizable dashboards    |

### Dashboard Metrics to Include:

* Count of unassigned employees
* Assignments with missing managers
* Assignments with future dates
* Distribution by team leader or cluster manager

---

## 🔁 Automation (Optional)

* Schedule data quality checks using database CRON jobs or BI tool scheduling
* Send email alerts when data quality issues exceed thresholds

---

## 🧠 Summary

| Action                 | Purpose                                  |
| ---------------------- | ---------------------------------------- |
| Use `LEFT JOIN`        | Ensure no records are hidden in reports  |
| Validation Queries     | Catch missing or invalid data early      |
| Quality View           | Aggregate quality indicators             |
| Dashboards             | Visualize and communicate issues clearly |
| Triggers & Constraints | Prevent bad data entry at the source     |

---

## 📬 Next Steps

* Implement the improved view with `LEFT JOIN`
* Deploy validation queries or summary view
* Choose a dashboard tool and set up regular monitoring

Need help setting up a dashboard in a specific tool? Let us know!

```

---

Would you like this as a downloadable `.md` file or integrated into a documentation platform like Notion or GitBook?
```
