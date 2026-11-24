# DBMS Experiment 6: Stored Procedures, Transaction Control & Triggers

## Aim
To implement a transactional stored procedure (`transfer_employee`) with input validation and error handling, and to build `BEFORE` and `AFTER` triggers for salary validation and automated audit logging.

## Prerequisites
* **Experiment 3 (`DBMS Exp-3.sql`)** must be executed first so the `Employee` and `Department` tables exist in `EmployeeManagement`.
* **Dialect:** MySQL (uses `DELIMITER //`, `SIGNAL SQLSTATE`, and `SQLEXCEPTION` handlers).

## Database Objects Created
1. **Stored Procedure: `transfer_employee(IN p_emp_id INT, IN p_new_dept_id INT)`**
   * Wraps the transfer operation in an explicit transaction (`START TRANSACTION`, `COMMIT`, `ROLLBACK`).
   * Includes an `EXIT HANDLER FOR SQLEXCEPTION` to safely roll back on unexpected database errors.
   * Validates three business rules before updating:
     1. Employee exists.
     2. Target department exists.
     3. Employee is not already assigned to the target department.
2. **Validation Triggers (`BEFORE INSERT` & `BEFORE UPDATE` on `Employee`):**
   * `validate_employee_salary` & `validate_employee_salary_update`: Enforce a minimum salary threshold of `15000` using `SIGNAL SQLSTATE '45000'`.
   * Later refined to explicitly reject `NULL` salaries (`NEW.salary IS NULL OR NEW.salary < 15000`).
3. **Audit Table (`Salary_Audit`) & Trigger (`salary_audit_trigger`):**
   * Logs `emp_id`, `old_salary`, `new_salary`, `changed_at` timestamp, and `action` whenever an employee's salary is modified (`OLD.salary <> NEW.salary`).

## Test Cases Included
* **Stored Procedure Tests:**
  * Valid transfer of employee `101` to department `3`.
  * Edge cases: Non-existent employee (`999`), non-existent department (`99`), and transferring to the current department (`3`).
* **Trigger Tests:**
  * Attempting to insert/update a salary below `15000` (expected to fail with custom error message).
  * Inserting/updating valid salaries (`30000`, `35000`, `40000`, `45000`) and verifying entries in `Salary_Audit`.
  * Updating a salary to its existing value (`45000`) to confirm no redundant audit row is generated.
  * Attempting to insert a `NULL` salary (expected to fail).

## How to Run
1. Select your active database (`USE EmployeeManagement;`).
2. Execute `DBMS Exp-6.sql` section by section (since intentional validation failures using `SIGNAL SQLSTATE '45000'` will halt sequential batch execution if run all at once).
3. Update the database name in the final `SHOW PROCEDURE STATUS WHERE Db = 'EmployeeManagement';` statement if needed.