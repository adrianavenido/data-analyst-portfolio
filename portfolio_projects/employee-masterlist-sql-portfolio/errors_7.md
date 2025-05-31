
# MySQL `ONLY_FULL_GROUP_BY` Troubleshooting Guide

## Issue:
When executing a SQL query that involves **GROUP BY** and **ORDER BY**, MySQL throws the following error:

```
Error Code: 1055. Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'employee_management.employees.hire_date' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
```

## Cause:
The error occurs because MySQL’s **`ONLY_FULL_GROUP_BY`** mode enforces strict grouping rules. Specifically:
- Every **non-aggregated column** in the `ORDER BY` clause must be included in the `GROUP BY`.
- MySQL does **not allow implicit column ordering** unless an aggregate function is used.

## Solution:

### ✅ 1. Modify Query to Use an Aggregate Function
Instead of trying to order by a column that is **not part of the GROUP BY**, use an **aggregate function** such as `MIN()`:

```sql
SELECT DATE_FORMAT(hire_date, '%M') AS hire_month, COUNT(*) AS employee_count
FROM employees
GROUP BY DATE_FORMAT(hire_date, '%M')
ORDER BY MIN(hire_date);
```

This ensures:
✔ **Proper grouping** without violating MySQL constraints.  
✔ **Month names appear correctly ordered** in the result.

---

### 🚀 2. Disable `ONLY_FULL_GROUP_BY` (Optional)
If you **control the MySQL configuration** and want to disable strict mode, run:

```sql
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
```

**Note:** Disabling `ONLY_FULL_GROUP_BY` can affect query integrity. Use with caution!

---

## Additional Formatting Options:

### **Show Month Names**
```sql
SELECT DATE_FORMAT(hire_date, '%M') AS hire_month, COUNT(*) AS employee_count
FROM employees
GROUP BY DATE_FORMAT(hire_date, '%M')
ORDER BY MIN(hire_date);
```

### **Show Month Abbreviations**
```sql
SELECT DATE_FORMAT(hire_date, '%b') AS hire_month, COUNT(*) AS employee_count
FROM employees
GROUP BY DATE_FORMAT(hire_date, '%b')
ORDER BY MIN(hire_date);
```

## Summary:
- **The error occurs** because MySQL restricts ordering when using `GROUP BY`.
- **Use `MIN(hire_date)`** to resolve it cleanly.
- **Disabling `ONLY_FULL_GROUP_BY`** is another option, but should be used carefully.

---

Let me know if you need modifications! 🚀
```

You can copy and save this as a `.md` file for easy reference. Let me know if you'd like any refinements!  
Would you like me to add **code comments** for extra clarity? 😃