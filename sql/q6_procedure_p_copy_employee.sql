-- Q6: procedure P_COPY_EMPLOYEE - copy all data from MyEmployee to MyEmployee_update
CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE
IS
    v_exists NUMBER;
    v_rows   NUMBER;
BEGIN
    -- create the target table with the same structure if it does not exist yet
    SELECT COUNT(*) INTO v_exists
    FROM   user_tables
    WHERE  table_name = 'MYEMPLOYEE_UPDATE';

    IF v_exists = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE MyEmployee_update AS SELECT * FROM MyEmployee WHERE 1 = 0';
    ELSE
        -- run it again without duplicating rows
        EXECUTE IMMEDIATE 'TRUNCATE TABLE MyEmployee_update';
    END IF;

    INSERT INTO MyEmployee_update
    SELECT * FROM MyEmployee;

    v_rows := SQL%ROWCOUNT;   -- take the count before the commit
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(v_rows || ' rows copied to MyEmployee_update');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END P_COPY_EMPLOYEE;
/

-- Test
SET SERVEROUTPUT ON
EXEC P_COPY_EMPLOYEE;
SELECT COUNT(*) FROM MyEmployee_update;
