-- EXPERIMENT 4
-- AIM: To perform and analyze SQL queries using INNER JOIN, LEFT JOIN, SELF JOIN,
-- 3-way JOIN, correlated subqueries, EXISTS, and simulated INTERSECT and EXCEPT
-- operations on the Employee–Department–Project database, and to compare their
-- execution plans using EXPLAIN.
--
-- Prerequisite: Run Experiment 3 first to create and populate the EmployeeManagement
-- database, including Employee, Department, Project, and Employee_Project tables.

USE EmployeeManagement;

-- ---------------------------------------------------------
-- INNER JOIN: Employees with their department names
-- ---------------------------------------------------------
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee AS e
INNER JOIN Department AS d
    ON d.dept_id = e.dept_id;

-- ---------------------------------------------------------
-- LEFT JOIN: Include every department, even if it has no employees
-- ---------------------------------------------------------
SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name
FROM Department AS d
LEFT JOIN Employee AS e
    ON e.dept_id = d.dept_id;

-- ---------------------------------------------------------
-- SELF JOIN: Pairs of employees in the same department
-- Each pair is listed once, using emp_id to avoid reversed duplicates.
-- ---------------------------------------------------------
SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    e1.dept_id
FROM Employee AS e1
INNER JOIN Employee AS e2
    ON e2.dept_id = e1.dept_id
   AND e1.emp_id < e2.emp_id;

-- ---------------------------------------------------------
-- 3-WAY JOIN: Employees, departments, and their assigned projects
-- ---------------------------------------------------------
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name
FROM Employee AS e
INNER JOIN Department AS d
    ON d.dept_id = e.dept_id
INNER JOIN Employee_Project AS ep
    ON ep.emp_id = e.emp_id
INNER JOIN Project AS p
    ON p.project_id = ep.project_id;

-- JOIN across Employee, Department, and Project by department
-- This lists employees alongside projects owned by their department.
SELECT
    e.emp_name,
    d.dept_name,
    e.salary,
    p.project_name
FROM Employee AS e
INNER JOIN Department AS d
    ON d.dept_id = e.dept_id
INNER JOIN Project AS p
    ON p.dept_id = d.dept_id;

-- ---------------------------------------------------------
-- CORRELATED SUBQUERY: Employees earning above their department average
-- ---------------------------------------------------------
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee AS e2
    WHERE e2.dept_id = e.dept_id
);

-- ---------------------------------------------------------
-- EXISTS: Employees assigned to at least one project
-- ---------------------------------------------------------
SELECT
    e.emp_id,
    e.emp_name
FROM Employee AS e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project AS ep
    WHERE ep.emp_id = e.emp_id
);

SELECT
    e.emp_id,
    e.emp_name
FROM Employee AS e
WHERE e.dept_id = 1
  AND EXISTS (
      SELECT 1
      FROM Employee_Project AS ep
      WHERE ep.emp_id = e.emp_id
        AND ep.project_id = 201
  );

SELECT
    e.emp_id,
    e.emp_name
FROM Employee AS e
WHERE e.dept_id = 1
  AND NOT EXISTS (
      SELECT 1
      FROM Employee_Project AS ep
      WHERE ep.emp_id = e.emp_id
        AND ep.project_id = 201
  );


-- EXPLAIN: INNER JOIN
EXPLAIN
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM Employee AS e
INNER JOIN Department AS d
    ON d.dept_id = e.dept_id;

-- EXPLAIN: LEFT JOIN
EXPLAIN
SELECT
    d.dept_name,
    e.emp_name
FROM Department AS d
LEFT JOIN Employee AS e
    ON e.dept_id = d.dept_id;

-- EXPLAIN: Correlated subquery
EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee AS e2
    WHERE e2.dept_id = e.dept_id
);

-- EXPLAIN: EXISTS
EXPLAIN
SELECT
    e.emp_id,
    e.emp_name
FROM Employee AS e
WHERE EXISTS (
    SELECT 1
    FROM Employee_Project AS ep
    WHERE ep.emp_id = e.emp_id
);
