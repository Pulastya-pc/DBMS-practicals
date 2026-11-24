-- ============================================================================
-- EXPERIMENT - 8
-- AIM: To implement banking-style transactions using BEGIN, COMMIT, ROLLBACK, 
--      and SAVEPOINT, simulate partial failures, and demonstrate isolation 
--      levels and concurrency anomalies using two sessions.
-- ============================================================================

-- 1. Table Setup & Initial Data
CREATE TABLE Bank_Account (
    Account_ID INT PRIMARY KEY,
    Account_Holder VARCHAR(50),
    Balance DECIMAL(10,2)
);

INSERT INTO Bank_Account
VALUES
    (101, 'Rahul Sharma', 50000.00),
    (102, 'Priya Singh', 30000.00),
    (103, 'Amit Kumar', 40000.00);

SELECT * FROM Bank_Account;

-- 2. Transaction with COMMIT (Successful Fund Transfer)
START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 5000
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance + 5000
WHERE Account_ID = 102;

COMMIT;

SELECT * FROM Bank_Account;

-- 3. Transaction with ROLLBACK (Aborted Fund Transfer)
START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 10000
WHERE Account_ID = 101;

UPDATE Bank_Account
SET Balance = Balance + 10000
WHERE Account_ID = 103;

ROLLBACK;

SELECT * FROM Bank_Account;

-- 4. Transaction with SAVEPOINT and Partial Rollback (Case 1)
START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 3000
WHERE Account_ID = 101;

SAVEPOINT transfer_point;

UPDATE Bank_Account
SET Balance = Balance + 3000
WHERE Account_ID = 102;

ROLLBACK TO transfer_point;

COMMIT;

SELECT * FROM Bank_Account;

-- 5. Transaction with SAVEPOINT and Rerouted Transfer (Case 2)
START TRANSACTION;

UPDATE Bank_Account
SET Balance = Balance - 2000
WHERE Account_ID = 101;

SAVEPOINT before_second_transfer;

UPDATE Bank_Account
SET Balance = Balance + 2000
WHERE Account_ID = 102;

ROLLBACK TO before_second_transfer;

UPDATE Bank_Account
SET Balance = Balance + 2000
WHERE Account_ID = 103;

COMMIT;

SELECT * FROM Bank_Account;

-- 6. Transaction Isolation Levels Demonstration
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM Bank_Account WHERE Account_ID = 101;
COMMIT;

-- 7. Concurrency Simulation (Session 1 & Session 2 Operations)
-- Session 1
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance - 5000 WHERE Account_ID = 101;
COMMIT;

-- Session 2
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT Balance FROM Bank_Account WHERE Account_ID = 101;
UPDATE Bank_Account SET Balance = Balance - 3000 WHERE Account_ID = 101;
COMMIT;

SELECT * FROM Bank_Account WHERE Account_ID = 101;
