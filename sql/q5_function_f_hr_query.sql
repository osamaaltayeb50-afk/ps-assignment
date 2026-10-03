-- Q5: function F_HR_QUERY - employees hired after SCOTT
-- The function returns a cursor with the name and the hire date.
CREATE OR REPLACE FUNCTION F_HR_QUERY
RETURN SYS_REFCURSOR
IS
    v_scott_hire_date MyEmployee.HIRE_DATE%TYPE;
    v_cursor          SYS_REFCURSOR;
BEGIN
    -- hire date of SCOTT
    SELECT HIRE_DATE
    INTO   v_scott_hire_date
    FROM   MyEmployee
    WHERE  UPPER(LAST_NAME) = 'SCOTT';

    OPEN v_cursor FOR
        SELECT FIRST_NAME || ' ' || LAST_NAME AS employee_name,
               HIRE_DATE
        FROM   MyEmployee
        WHERE  HIRE_DATE > v_scott_hire_date
        ORDER BY HIRE_DATE;

    RETURN v_cursor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee SCOTT was not found');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20002, 'More than one employee is named SCOTT');
END F_HR_QUERY;
/

-- Test: the three rows from the question (SCOTT 9/9/1987, Ahmad 10/10/1980, Rami 24/05/1986)
-- are all hired before or on SCOTT's date, so the function returns nothing for them.
-- Sara (1990) and Hana (1992) were added in q1_create_tables.sql to show a real result.
SET SERVEROUTPUT ON
DECLARE
    v_cur  SYS_REFCURSOR;
    v_name VARCHAR2(120);
    v_date DATE;
BEGIN
    v_cur := F_HR_QUERY;
    LOOP
        FETCH v_cur INTO v_name, v_date;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_name || ' - ' || TO_CHAR(v_date, 'DD/MM/YYYY'));
    END LOOP;
    CLOSE v_cur;
END;
/
