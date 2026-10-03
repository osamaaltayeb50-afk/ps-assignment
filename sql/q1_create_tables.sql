-- Q1: create the tables (Oracle syntax)
-- Two extra columns were added to MyEmployee because Q2 and Q3 need them:
--   MANAGER_ID  -> to show the manager name (self reference)
--   JOB_TITLE   -> to group the payroll by job title

CREATE TABLE MyDepartment (
    Dept_ID  NUMBER        CONSTRAINT pk_department PRIMARY KEY,
    Name     VARCHAR2(100) CONSTRAINT nn_dept_name NOT NULL
);

CREATE TABLE Gender (
    Gender_ID NUMBER       CONSTRAINT pk_gender PRIMARY KEY,
    Name      VARCHAR2(20) CONSTRAINT nn_gender_name NOT NULL
);

CREATE TABLE University (
    ID    NUMBER        CONSTRAINT pk_university PRIMARY KEY,
    Name  VARCHAR2(150) CONSTRAINT nn_univ_name NOT NULL
);

CREATE TABLE MyEmployee (
    ID            NUMBER        CONSTRAINT pk_employee PRIMARY KEY,
    LAST_NAME     VARCHAR2(50)  CONSTRAINT nn_emp_last  NOT NULL,
    FIRST_NAME    VARCHAR2(50)  CONSTRAINT nn_emp_first NOT NULL,
    HIRE_DATE     DATE          CONSTRAINT nn_emp_hire  NOT NULL,
    USERID        NUMBER        CONSTRAINT uq_emp_userid UNIQUE,
    SALARY        NUMBER(10,2)  CONSTRAINT nn_emp_salary NOT NULL
                                CONSTRAINT ck_emp_salary CHECK (SALARY > 0),
    DEPT_ID       NUMBER        CONSTRAINT fk_emp_dept   REFERENCES MyDepartment (Dept_ID),
    Gender_ID     NUMBER        CONSTRAINT fk_emp_gender REFERENCES Gender (Gender_ID),
    University_ID NUMBER        CONSTRAINT fk_emp_univ   REFERENCES University (ID),
    EMP_IMAGE     BLOB,
    JOB_TITLE     VARCHAR2(50),
    MANAGER_ID    NUMBER        CONSTRAINT fk_emp_manager REFERENCES MyEmployee (ID)
);

-- index on the foreign key that is used the most in joins
CREATE INDEX idx_emp_dept ON MyEmployee (DEPT_ID);

-- sample data so the queries can be tested
INSERT INTO MyDepartment VALUES (10, 'HR');
INSERT INTO MyDepartment VALUES (20, 'IT');
INSERT INTO MyDepartment VALUES (30, 'Sales');

INSERT INTO Gender VALUES (1, 'Male');
INSERT INTO Gender VALUES (2, 'Female');

INSERT INTO University VALUES (1, 'University of Jordan');
INSERT INTO University VALUES (2, 'Yarmouk University');

-- the manager has to be inserted first (MANAGER_ID points to MyEmployee)
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, JOB_TITLE, MANAGER_ID)
VALUES (1, 'SCOTT', 'Adam', TO_DATE('09/09/1987','DD/MM/YYYY'), 101, 3000, 20, 1, 1, 'MANAGER', NULL);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, JOB_TITLE, MANAGER_ID)
VALUES (2, 'Ahmad', 'Khaled', TO_DATE('10/10/1980','DD/MM/YYYY'), 102, 1800, 20, 1, 2, 'ANALYST', 1);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, JOB_TITLE, MANAGER_ID)
VALUES (3, 'Rami', 'Omar', TO_DATE('24/05/1986','DD/MM/YYYY'), 103, 1500, 10, 1, 1, 'CLERK', 1);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, JOB_TITLE, MANAGER_ID)
VALUES (4, 'Sara', 'Lina', TO_DATE('02/02/1990','DD/MM/YYYY'), 104, 1400, 30, 2, 2, 'SALESMAN', 1);
INSERT INTO MyEmployee (ID, LAST_NAME, FIRST_NAME, HIRE_DATE, USERID, SALARY, DEPT_ID, Gender_ID, University_ID, JOB_TITLE, MANAGER_ID)
VALUES (5, 'Hana', 'Noor', TO_DATE('15/03/1992','DD/MM/YYYY'), 105, 1900, 20, 2, 1, 'ANALYST', 1);
COMMIT;
