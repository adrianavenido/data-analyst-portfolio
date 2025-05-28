Using **MySQL queries** instead of **Excel pivot tables** when connecting to **Tableau** provides **better performance, scalability, and automation** for data visualization. Here are some **best practices** to follow:

---

### **1. Optimize Database Queries for Performance**
✅ **Use Aggregation in SQL**  
Instead of loading raw data into Tableau and aggregating later, **pre-aggregate** in MySQL:
```sql
SELECT department, COUNT(employee_id) AS total_employees, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```
✔ **Improves query speed and Tableau efficiency**  
✔ **Reduces Tableau processing workload**

✅ **Use Indexed Queries for Faster Data Retrieval**  
Ensure **indexed fields** for quick filtering:
```sql
CREATE INDEX idx_department ON employees(department);
```
✔ **Speeds up filtering and aggregation in Tableau**

✅ **Limit Data Scope** Instead of loading entire tables, **filter unnecessary data**:
```sql
SELECT * FROM employees WHERE hire_date >= '2022-01-01';
```
✔ **Prevents excess data load into Tableau**

---

### **2. Use Views Instead of Raw SQL**
Instead of writing complex queries each time in Tableau, **create reusable views** in MySQL:
```sql
CREATE VIEW employee_summary AS
SELECT department, COUNT(employee_id) AS total_employees, AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```
✔ **Allows Tableau to reference a predefined dataset**  
✔ **Avoids redundant SQL writing in Tableau**

---

### **3. Leverage Table Extracts Instead of Live Connections**
✅ **Use Tableau Extracts (`.hyper`)**  
✔ Faster data loading, especially for **large MySQL datasets**  
✔ Reduces **real-time strain** on the MySQL database  
✔ Enables **offline access to queried data**

✅ **Schedule Refreshes for Extracts**  
Use **scheduled refreshes** in Tableau **instead of live queries** to balance performance.

---

### **4. Avoid Excess Joins & Complex Queries in Tableau**
✅ **Pre-Join Data in MySQL** Instead of creating joins inside Tableau, **join data beforehand** in MySQL:
```sql
CREATE VIEW employee_details AS
SELECT e.employee_id, e.name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
```
✔ **Reduces query complexity in Tableau**  
✔ **Improves visualization speed**

---

### **5. Use Stored Procedures for Dynamic Filtering**
✅ **Stored Procedures for Tableau Parameters**  
Instead of making multiple queries, **use stored procedures**:
```sql
CREATE PROCEDURE get_employees_by_department(IN dept_name VARCHAR(100))
BEGIN
    SELECT * FROM employees WHERE department = dept_name;
END;
```
✔ **Improves interactivity when using Tableau parameters**

---

### **Final Thoughts**
📌 **MySQL provides better control** over **query optimization, indexing, and automation**, making it superior to Excel pivot tables for **Tableau visualizations**.  
📌 **Using views, extracts, and stored procedures** ensures **scalable dashboards without excessive computation** inside Tableau.  

Would you like help designing a **MySQL schema optimized for Tableau dashboards? 🚀**  
Let me know if you need **custom SQL queries for visualization**!