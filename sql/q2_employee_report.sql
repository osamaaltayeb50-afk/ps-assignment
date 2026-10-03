-- Q2: employee, salary, department, manager, gender and university (all as names)
-- LEFT JOIN is used so an employee without a manager (the top one) still appears
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME  AS employee_name,
       e.SALARY                            AS salary,
       d.Name                              AS department_name,
       m.FIRST_NAME || ' ' || m.LAST_NAME  AS manager_name,
       g.Name                              AS gender,
       u.Name                              AS university
FROM   MyEmployee   e
LEFT JOIN MyDepartment d ON d.Dept_ID   = e.DEPT_ID
LEFT JOIN MyEmployee   m ON m.ID        = e.MANAGER_ID
LEFT JOIN Gender       g ON g.Gender_ID = e.Gender_ID
LEFT JOIN University   u ON u.ID        = e.University_ID
ORDER BY e.ID;
