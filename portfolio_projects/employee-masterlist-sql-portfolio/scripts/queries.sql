-- Workforce Distribution by Gender
-- This query provides the count of active employees categorized by gender.
SELECT gender, COUNT(*) AS employee_count
FROM employees
WHERE is_active = TRUE
GROUP BY gender;

-- Attrition Trends
-- Analyzes termination reasons and provides the total count of terminations per reason.
SELECT termination_reason, COUNT(*) AS terminations
FROM employees
WHERE termination_date IS NOT NULL
GROUP BY termination_reason;

-- Coaching Impact Analysis
-- Evaluates the number of employees coached under each team leader.
SELECT tl.name AS team_leader, COUNT(e.employee_id) AS coached_employees
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
GROUP BY tl.name;

-- Organizational Structure Visualization
-- Displays the hierarchy between cluster managers and team leaders, along with their team sizes.
SELECT cm.name AS cluster_manager, tl.name AS team_leader, COUNT(e.employee_id) AS team_size
FROM employees e
JOIN team_leaders tl ON e.team_leader_id = tl.team_leader_id
JOIN cluster_managers cm ON tl.cluster_manager_id = cm.cluster_manager_id
GROUP BY cm.name, tl.name;

-- Attendance Tracking (Employees with High Absences)
-- Lists employees who have more than 5 absences, sorted in descending order.
SELECT e.first_name, e.last_name, a.absent_days
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
WHERE a.absent_days > 5
ORDER BY a.absent_days DESC;

-- Total Absences per Employee
-- Provides the total absences recorded for each employee, ordered from highest to lowest.
SELECT e.first_name, e.last_name, SUM(a.absent_days) AS total_absences
FROM employees e
JOIN attendance_tracking a ON e.employee_id = a.employee_id
GROUP BY e.first_name, e.last_name
ORDER BY total_absences DESC;
