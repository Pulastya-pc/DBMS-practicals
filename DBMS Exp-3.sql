-- EXPERIMENT 3
-- AIM: To design and implement an Employee–Department–Project database schema
-- and perform SQL queries using Selection, Projection, Aggregate Functions,
-- GROUP BY, HAVING, CASE expressions, and ORDER BY.

CREATE DATABASE IF NOT EXISTS EmployeeManagement;
USE EmployeeManagement;
-- Department Table
CREATE TABLE Department (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location  VARCHAR(50)
);

-- Employee Table
CREATE TABLE Employee (
    emp_id    INT PRIMARY KEY,
    emp_name  VARCHAR(50) NOT NULL,
    gender    CHAR(1),
    salary    DECIMAL(10, 2),
    hire_date DATE,
    dept_id   INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Project Table
CREATE TABLE Project (
    project_id   INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget       DECIMAL(12, 2),
    dept_id      INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Employee-Project Relationship
CREATE TABLE Employee_Project (
    emp_id       INT,
    project_id   INT,
    hours_worked INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);
INSERT INTO Department (dept_id, dept_name, location)
VALUES
    (1, 'IT', 'Delhi'),
    (2, 'HR', 'Mumbai'),
    (3, 'Finance', 'Bangalore'),
    (4, 'Marketing', 'Pune'),
    (5, 'Research', 'Hyderabad');

-- ---------------------------------------------------------
-- INSERT 30 EMPLOYEES
-- ---------------------------------------------------------
INSERT INTO Employee (emp_id, emp_name, gender, salary, hire_date, dept_id)
VALUES
    (101, 'Aarav Sharma', 'M', 75000, '2021-01-15', 1),,
    (102, 'Ananya Singh', 'F', 68000, '2022-03-10', 1),,
    (103, 'Rohan Verma', 'M', 82000, '2020-07-20', 1),,
    (104, 'Priya Gupta', 'F', 72000, '2021-11-05', 1),,
    (105, 'Karan Mehta', 'M', 95000, '2019-06-18', 1),,
    (106, 'Sneha Kapoor', 'F', 64000, '2023-01-12', 1),,
    (107, 'Rahul Kumar', 'M', 55000, '2022-05-15', 2),,
    (108, 'Neha Sharma', 'F', 62000, '2021-09-22', 2),,
    (109, 'Amit Jain', 'M', 58000, '2020-04-11', 2),,
    (110, 'Pooja Verma', 'F', 67000, '2023-02-19', 2),,
    (111, 'Vikas Singh', 'M', 60000, '2022-08-01', 2),,
    (112, 'Riya Agarwal', 'F', 71000, '2019-12-10', 2),,
    (113, 'Arjun Patel', 'M', 88000, '2020-01-25', 3),,
    (114, 'Meera Shah', 'F', 92000, '2019-08-14', 3),,
    (115, 'Suresh Rao', 'M', 76000, '2021-06-30', 3),,
    (116, 'Kavya Iyer', 'F', 85000, '2022-10-17', 3),,
    (117, 'Manish Gupta', 'M', 73000, '2023-03-21', 3),,
    (118, 'Nisha Reddy', 'F', 90000, '2020-11-09', 3),,
    (119, 'Aditya Joshi', 'M', 70000, '2021-02-28', 4),,
    (120, 'Simran Kaur', 'F', 66000, '2022-04-15', 4),,
    (121, 'Mohit Bansal', 'M', 74000, '2020-09-12', 4),,
    (122, 'Isha Malhotra', 'F', 81000, '2019-07-07', 4),,
    (123, 'Nikhil Sethi', 'M', 69000, '2023-01-05', 4),,
    (124, 'Tanya Arora', 'F', 77000, '2021-12-18', 4),,
    (125, 'Dev Malhotra', 'M', 98000, '2018-05-20', 5),,
    (126, 'Aditi Mishra', 'F', 91000, '2020-03-16', 5),,
    (127, 'Varun Nair', 'M', 87000, '2021-10-08', 5),,
    (128, 'Shreya Das', 'F', 93000, '2019-11-25', 5),,
    (129, 'Yash Thakur', 'M', 79000, '2022-07-14', 5),,
    (130, 'Diya Kapoor', 'F', 96000, '2023-02-02', 5);;

-- ---------------------------------------------------------
-- INSERT 8 PROJECTS
-- ---------------------------------------------------------
INSERT INTO Project (project_id, project_name, budget, dept_id)
VALUES
    (201, 'AI Chatbot', 500000, 1),
    (202, 'Cloud Migration', 750000, 1),
    (203, 'Employee Training', 250000, 2),
    (204, 'Financial Analysis', 600000, 3),
    (205, 'Digital Marketing', 450000, 4),
    (206, 'Market Research', 350000, 4),
    (207, 'Machine Learning Research', 900000, 5),
    (208, 'AI Security System', 1000000, 5);

-- ---------------------------------------------------------
-- ASSIGN EMPLOYEES TO PROJECTS
-- ---------------------------------------------------------
INSERT INTO Employee_Project (emp_id, project_id, hours_worked)
VALUES
    (101, 201, 120),,
    (102, 201, 100),,
    (103, 202, 150),,
    (104, 202, 110),,
    (105, 201, 130),,
    (106, 202, 90),,
    (107, 203, 100),,
    (108, 203, 120),,
    (109, 203, 80),,
    (110, 203, 110),,
    (111, 203, 90),,
    (112, 203, 130),,
    (113, 204, 140),,
    (114, 204, 150),,
    (115, 204, 120),,
    (116, 204, 135),,
    (117, 204, 100),,
    (118, 204, 145),,
    (119, 205, 110),,
    (120, 205, 100),,
    (121, 206, 120),,
    (122, 205, 140),,
    (123, 206, 90),,
    (124, 206, 130),,
    (125, 207, 160),,
    (126, 207, 140),,
    (127, 208, 150),,
    (128, 208, 160),,
    (129, 207, 120),,
    (130, 208, 135);;

-- ---------------------------------------------------------
-- SQL QUERIES
-- ---------------------------------------------------------

-- SELECTION: Employees earning more than 80,000
SELECT *
FROM Employee
WHERE salary > 80000;

-- PROJECTION: Display employee names and salaries
SELECT emp_name, salary
FROM Employee;

-- AGGREGATE FUNCTIONS: Summary of employee salaries
SELECT
    COUNT(*)   AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM Employee;

-- GROUP BY: Employee count in each department
SELECT
    dept_id,
    COUNT(*) AS employee_count
FROM Employee
GROUP BY dept_id;

-- GROUP BY WITH JOIN: Average salary by department
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department AS d
JOIN Employee AS e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- HAVING: Departments with average salary above 75,000
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department AS d
JOIN Employee AS e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 75000;

-- CASE EXPRESSIONS: Categorize employee salaries
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 90000 THEN 'High Salary'
        WHEN salary >= 70000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;

-- ORDER BY: List employees from highest to lowest salary
SELECT emp_id, emp_name, salary
FROM Employee
ORDER BY salary DESC;

-- COMPLETE EMPLOYEE-DEPARTMENT REPORT
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary
FROM Employee AS e
JOIN Department AS d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;

-- PROJECT DETAILS: Show projects ordered by budget
SELECT
    p.project_name,
    d.dept_name,
    p.budget
FROM Project AS p
JOIN Department AS d
    ON p.dept_id = d.dept_id
ORDER BY p.budget DESC;

-- EMPLOYEES WORKING ON PROJECTS: Sort by hours worked
SELECT
    e.emp_name,
    p.project_name,
    ep.hours_worked
FROM Employee_Project AS ep
JOIN Employee AS e
    ON ep.emp_id = e.emp_id
JOIN Project AS p
    ON ep.project_id = p.project_id
ORDER BY ep.hours_worked DESC;
