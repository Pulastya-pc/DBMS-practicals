-- EXPERIMENT 5
-- AIM: To create and manipulate SQL views for department salary summary and
-- employee hierarchy, test the updatability of views, and implement a recursive
-- CTE to display employee reporting chains.
--
-- Prerequisite: Run Experiment 3 first to create and populate EmployeeManagement.
-- Note: This script adds manager_id to Employee. Run that ALTER TABLE section
-- only once on a database where manager_id does not already exist.

USE EmployeeManagement;

-- ---------------------------------------------------------
-- DEPARTMENT SALARY SUMMARY VIEW
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW Department_Salary_Summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_employees,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS average_salary,
    MAX(e.salary) AS highest_salary,
    MIN(e.salary) AS lowest_salary
FROM Department AS d
LEFT JOIN Employee AS e
    ON e.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT *
FROM Department_Salary_Summary;

-- Query the view: departments with average salary above 75,000
SELECT
    dept_name,
    average_salary
FROM Department_Salary_Summary
WHERE average_salary > 75000;

-- ---------------------------------------------------------
-- EMPLOYEE HIERARCHY: Add a manager reference to Employee
-- ---------------------------------------------------------
ALTER TABLE Employee
    ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
    ADD CONSTRAINT fk_employee_manager
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);

-- ---------------------------------------------------------
-- ASSIGN MANAGER IDs
-- Root managers have manager_id = NULL.
-- The assignments below use the employee IDs in this experiment.
-- ---------------------------------------------------------
UPDATE Employee
SET manager_id = NULL
WHERE emp_id IN (105, 112, 114, 122, 125);

-- IT
UPDATE Employee
SET manager_id = 105
WHERE emp_id IN (103, 104);

UPDATE Employee
SET manager_id = 103
WHERE emp_id IN (101, 102);

UPDATE Employee
SET manager_id = 104
WHERE emp_id = 106;

-- HR
UPDATE Employee
SET manager_id = 112
WHERE emp_id IN (107, 108);

UPDATE Employee
SET manager_id = 107
WHERE emp_id = 109;

UPDATE Employee
SET manager_id = 108
WHERE emp_id IN (110, 111);

-- Finance
UPDATE Employee
SET manager_id = 114
WHERE emp_id IN (115, 116, 117, 118);

UPDATE Employee
SET manager_id = 114
WHERE emp_id = 113;

-- Marketing
UPDATE Employee
SET manager_id = 122
WHERE emp_id IN (119, 120, 121, 123, 124);

-- Research
UPDATE Employee
SET manager_id = 125
WHERE emp_id IN (126, 127, 128);

UPDATE Employee
SET manager_id = 126
WHERE emp_id = 129;

UPDATE Employee
SET manager_id = 128
WHERE emp_id = 130;

-- ---------------------------------------------------------
-- EMPLOYEE HIERARCHY VIEW
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW Employee_Hierarchy AS
SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.salary,
    e.dept_id
FROM Employee AS e
LEFT JOIN Employee AS m
    ON m.emp_id = e.manager_id;

SELECT *
FROM Employee_Hierarchy;

-- ---------------------------------------------------------
-- TEST UPDATABILITY OF A SIMPLE VIEW
-- ---------------------------------------------------------
CREATE OR REPLACE VIEW Employee_Basic AS
SELECT
    emp_id,
    emp_name,
    salary,
    dept_id
FROM Employee;

SELECT *
FROM Employee_Basic
WHERE emp_id = 101;

-- Update a base-table column through the simple view
UPDATE Employee_Basic
SET salary = 78000
WHERE emp_id = 101;

SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id = 101;

-- ---------------------------------------------------------
-- TEST NON-UPDATABILITY OF AN AGGREGATE VIEW
-- The following UPDATE is expected to fail in MySQL because the view
-- contains aggregate functions and GROUP BY. It is intentionally included
-- to demonstrate that such a view is not updatable.
-- Run this statement separately if you want the remaining script to continue.
-- ---------------------------------------------------------
-- UPDATE Department_Salary_Summary
-- SET average_salary = 80000
-- WHERE dept_id = 1;

-- ---------------------------------------------------------
-- RECURSIVE CTE: Reporting chains for all employees
-- ---------------------------------------------------------
WITH RECURSIVE EmployeeChain AS (
    -- Anchor member: start with employees who have no manager
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level,
        CAST(emp_name AS CHAR(500)) AS reporting_chain
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: append each employee to their manager's chain
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        ec.level + 1,
        CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
    FROM Employee AS e
    INNER JOIN EmployeeChain AS ec
        ON e.manager_id = ec.emp_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level,
    reporting_chain
FROM EmployeeChain
ORDER BY reporting_chain;

-- ---------------------------------------------------------
-- RECURSIVE CTE: Reporting chain above one employee (employee 101)
-- ---------------------------------------------------------
WITH RECURSIVE ReportingChain AS (
    -- Anchor member: begin with employee 101
    SELECT
        emp_id,
        emp_name,
        manager_id,
        0 AS level
    FROM Employee
    WHERE emp_id = 101

    UNION ALL

    -- Recursive member: follow the manager link upward
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1
    FROM Employee AS e
    INNER JOIN ReportingChain AS rc
        ON e.emp_id = rc.manager_id
)
SELECT
    emp_id,
    emp_name,
    manager_id,
    level
FROM ReportingChain;
