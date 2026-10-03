-- Q3: job titles with total monthly salary above 2500, without the sales jobs
SELECT JOB_TITLE,
       SUM(SALARY) AS total_monthly_salary
FROM   MyEmployee
WHERE  UPPER(JOB_TITLE) NOT LIKE 'SALES%'
GROUP BY JOB_TITLE
HAVING SUM(SALARY) > 2500
ORDER BY total_monthly_salary DESC;
-- WHERE removes the sales rows before grouping, HAVING filters the groups after SUM.
