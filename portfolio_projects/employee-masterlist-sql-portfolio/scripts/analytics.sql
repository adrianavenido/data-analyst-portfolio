-- Predictive Attrition Analysis (Likelihood of Leaving in First Year)
SELECT hire_date, termination_date, 
    CASE 
        WHEN DATEDIFF(termination_date, hire_date) <= 365 THEN 'High Risk' 
        ELSE 'Low Risk'
    END AS attrition_risk
FROM employees
WHERE termination_date IS NOT NULL;

-- Average Tenure Analysis
SELECT AVG(DATEDIFF(termination_date, hire_date)) AS avg_tenure
FROM employees
WHERE termination_date IS NOT NULL;

-- Employee Turnover Analysis
SELECT lob.name AS line_of_business, COUNT(e.employee_id) AS terminations
FROM employees e
JOIN lines_of_business lob ON e.lob_id = lob.lob_id
WHERE termination_date IS NOT NULL
GROUP BY lob.name
ORDER BY terminations DESC;

-- Salary vs. Retention Correlation
SELECT salary, AVG(DATEDIFF(termination_date, hire_date)) AS avg_tenure
FROM employees
WHERE termination_date IS NOT NULL
GROUP BY salary
ORDER BY salary DESC;
