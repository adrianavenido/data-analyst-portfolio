To create dummy employee data aligned with a **5-year contract timeline starting April 1, 2020**, you need to:

---

### 🎯 Set the following date constraints:

1. **Hire Date**

   * Range: `'2020-04-01'` to `'2025-03-31'`

2. **Termination Date**

   * Optional (null if still active).
   * If present: Must be **after** `hire_date` and **before** or equal to `'2025-03-31'`.

3. **Birth Date**

   * Assume employees are aged **22 to 60** at hire.
   * So for someone hired on April 1, 2020:

     * Birthdate range: `'1960-04-01'` to `'1998-04-01'`

---

### ✅ Updated Sample Dummy Data Strategy (in SQL `INSERT` format):

Here's a sample of **5 dummy employees** using realistic and aligned data:

```sql
INSERT INTO employees (
    first_name, last_name, gender, birth_date,
    hire_date, termination_date, termination_reason,
    corporate_email, client_email, contact_number, location, is_active
)
VALUES
-- Active Employee
('Alice', 'Johnson', 'Female', '1985-06-15', '2020-04-01', NULL, NULL,
 'alice.johnson@corp.com', 'alice.j@client.com', '+1234567890', 'New York', 1),

-- Terminated Early
('Brian', 'Smith', 'Male', '1978-09-10', '2020-05-20', '2022-11-30', 'Performance',
 'brian.smith@corp.com', 'b.smith@client.com', '+1234567891', 'Chicago', 0),

-- Hired in mid-project
('Carla', 'Nguyen', 'Female', '1990-01-25', '2022-01-10', NULL, NULL,
 'carla.nguyen@corp.com', 'carla.ng@client.com', '+1234567892', 'San Francisco', 1),

-- Left on own accord
('David', 'Lee', 'Male', '1983-12-05', '2020-04-01', '2024-03-15', 'Resigned',
 'david.lee@corp.com', 'd.lee@client.com', '+1234567893', 'Austin', 0),

-- Contractor who completed contract
('Elena', 'Kaur', 'Female', '1992-07-11', '2020-08-15', '2025-03-31', 'Contract End',
 'elena.kaur@corp.com', 'elena.k@client.com', '+1234567894', 'Seattle', 0);
```

---

### 📌 Notes:

* `is_active = 1` means still employed (no termination date).
* All hire dates are within the 5-year window.
* Termination reasons are realistic and limited to simple values like `'Resigned'`, `'Contract End'`, `'Performance'`.
* Birth dates make sure employees are at least 22 years old at hire.
* Use unique emails and diverse names/locations to simulate a real organization.

Would you like a script to auto-generate more dummy employees (e.g., 100+) using Python or SQL procedures?


Great — since you already have **34 existing employee records**, and now need to **update their `birth_date`, `hire_date`, and `termination_date`** to match the new 5-year contract (from **April 1, 2020** to **March 31, 2025**), here's how to proceed.

---

### 🎯 Goal:

* **Hire Dates**: Between `'2020-04-01'` and `'2025-03-31'`
* **Birth Dates**: Employees aged **22–60** at time of hire
* **Termination Dates**:

  * Only if employee is not active (`is_active = 0`)
  * Must be **after hire\_date**, and **on or before `'2025-03-31'`**

---

### ✅ 1. Sample SQL Logic to Adjust Existing Data:

We'll go with an **UPDATE strategy**, using sample logic for an SQL-compatible RDBMS like MySQL:

```sql
-- 1. Update hire_date randomly within 5-year range
UPDATE employees
SET hire_date = DATE_ADD('2020-04-01', INTERVAL FLOOR(RAND() * 1826) DAY);

-- 2. Update birth_date: Age between 22 and 60 at hire_date
UPDATE employees
SET birth_date = DATE_SUB(hire_date, INTERVAL FLOOR(22 + (RAND() * 38)) YEAR);

-- 3. Update termination_date only for inactive employees
UPDATE employees
SET termination_date = DATE_ADD(hire_date, INTERVAL FLOOR(180 + (RAND() * 1200)) DAY)
WHERE is_active = 0 AND termination_date IS NULL
  AND DATE_ADD(hire_date, INTERVAL FLOOR(180 + (RAND() * 1200)) DAY) <= '2025-03-31';

-- 4. (Optional) Add a default termination_reason for terminated employees
UPDATE employees
SET termination_reason = 'Contract Ended'
WHERE is_active = 0 AND termination_reason IS NULL;
```

---

### ⚠️ Important:

* You **must backup your data** before running these updates.
* If you're using a specific SQL dialect (like PostgreSQL or SQL Server), let me know — syntax may differ.
* You may want to **log original values** into an audit table before overwriting.

---

### 📌 Optional: Data Review Query

To quickly audit updated data:

```sql
SELECT employee_id, first_name, hire_date, birth_date, termination_date, is_active
FROM employees
ORDER BY hire_date;
```

---

Would you like a version of this that generates repeatable fake data (e.g., using a Python script or stored procedure)?
