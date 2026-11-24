# DBMS Experiment 5: SQL Views, View Updatability & Recursive CTEs

## Aim
To create and query SQL views for department salary summaries and organizational hierarchies, test the updatability constraints of simple versus aggregate views, and implement Recursive Common Table Expressions (CTEs) to traverse employee reporting chains.

## Prerequisites
* **Experiment 3 (`DBMS Exp-3.sql`)** must be executed first.
* **Important Note:** This script alters the `Employee` table by adding a `manager_id` column and a self-referencing foreign key (`fk_employee_manager`). Run the `ALTER TABLE` section only once on a fresh database instance.

## Key SQL Concepts Demonstrated
1. **Aggregate Views (`Department_Salary_Summary`):**
   * Summarizes employee count, total salary, average salary, minimum salary, and maximum salary per department using `LEFT JOIN` and `GROUP BY`.
   * Demonstrates querying directly against a view (`WHERE average_salary > 75000`).
2. **Self-Referencing Schema & Hierarchy View (`Employee_Hierarchy`):**
   * Adds `manager_id` to `Employee` and populates a multi-tier management tree across all 5 departments (root managers have `manager_id = NULL`).
   * Creates a view mapping each employee to their direct manager's name.
3. **View Updatability Testing:**
   * **Updatable Simple View (`Employee_Basic`):** Demonstrates modifying a base table's column (`salary`) directly through a single-table view without aggregates.
   * **Non-Updatable Aggregate View:** Includes a commented-out `UPDATE` statement on `Department_Salary_Summary` to illustrate why MySQL restricts updates on views containing `GROUP BY` and aggregate functions.
4. **Recursive Common Table Expressions (`WITH RECURSIVE`):**
   * **Top-Down Traversal (`EmployeeChain`):** Starts from root managers (`manager_id IS NULL`) and recursively builds the complete reporting path (`Manager -> Lead -> Employee`) along with hierarchy depth (`level`).
   * **Bottom-Up Traversal (`ReportingChain`):** Starts from a specific employee (`emp_id = 101`) and traverses upward through `manager_id` links to display their chain of command.

## How to Run
1. Ensure Experiment 3 has been run.
2. Execute `DBMS Exp-5.sql` in MySQL.
3. Optionally, uncomment the `UPDATE Department_Salary_Summary` block and run it individually to observe MySQL's non-updatable view error.