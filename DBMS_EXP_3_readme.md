# DBMS Experiment 3: Employee–Department–Project Database Schema & Basic SQL Queries

## Aim
To design and implement an **Employee–Department–Project** relational database schema (`EmployeeManagement`) and execute fundamental SQL queries involving Selection, Projection, Aggregate Functions, `GROUP BY`, `HAVING`, `CASE` expressions, and `ORDER BY`.

## Database Schema
The script creates the `EmployeeManagement` database containing four normalized tables:

1. **`Department`**
   * `dept_id` (INT, Primary Key)
   * `dept_name` (VARCHAR(50), NOT NULL)
   * `location` (VARCHAR(50))
2. **`Employee`**
   * `emp_id` (INT, Primary Key)
   * `emp_name` (VARCHAR(50), NOT NULL)
   * `gender` (CHAR(1))
   * `salary` (DECIMAL(10, 2))
   * `hire_date` (DATE)
   * `dept_id` (INT, Foreign Key $\rightarrow$ `Department.dept_id`)
3. **`Project`**
   * `project_id` (INT, Primary Key)
   * `project_name` (VARCHAR(100), NOT NULL)
   * `budget` (DECIMAL(12, 2))
   * `dept_id` (INT, Foreign Key $\rightarrow$ `Department.dept_id`)
4. **`Employee_Project`** (Junction table for Many-to-Many relationship)
   * `emp_id` (INT, Foreign Key $\rightarrow$ `Employee.emp_id`)
   * `project_id` (INT, Foreign Key $\rightarrow$ `Project.project_id`)
   * `hours_worked` (INT)
   * *Composite Primary Key:* `(emp_id, project_id)`

## Sample Data Populated
* **5 Departments:** IT, HR, Finance, Marketing, and Research.
* **30 Employees:** Distributed across all 5 departments (IDs `101`–`130`).
* **8 Projects:** Assigned to respective departments (IDs `201`–`208`).
* **30 Project Assignments:** Mapping employees to projects with logged hours.

## Key SQL Concepts Demonstrated
* **Selection & Projection:** Filtering rows with `WHERE` and selecting specific columns.
* **Aggregate Functions:** Computing `COUNT`, `SUM`, `AVG`, `MAX`, and `MIN` across employee salaries.
* **Grouping & Filtering Aggregates:** Grouping records by department using `GROUP BY` and filtering groups using `HAVING` (e.g., departments with an average salary $> 75,000$).
* **Conditional Logic:** Categorizing salaries into `'High Salary'`, `'Medium Salary'`, and `'Low Salary'` using `CASE` expressions.
* **Sorting & Reporting:** Using `INNER JOIN` and `ORDER BY` to generate sorted reports for employees, project budgets, and hours worked.

## How to Run
1. Open your MySQL client (MySQL Workbench, CLI, etc.).
2. Execute `DBMS Exp-3.sql`. *(Note: Ensure there are no trailing double commas `,,` in the `INSERT` statements if running in strict SQL mode).*
3. This database serves as the foundational dataset for **Experiments 4, 5, and 6**.