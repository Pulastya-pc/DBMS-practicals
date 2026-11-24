# Experiment 8: Transactions, Savepoints, and Isolation Levels

## Aim
To implement banking-style transactions using `START TRANSACTION`, `COMMIT`, `ROLLBACK`, and `SAVEPOINT`, simulate partial failures, and demonstrate SQL transaction isolation levels and concurrency behavior across sessions.

---

## Key Operations Demonstrated

1. **Atomic Fund Transfer (`COMMIT`)**
   - Transfers `5000.00` from Account `101` (Rahul Sharma) to Account `102` (Priya Singh) and commits the transaction permanently.
2. **Aborted Transaction (`ROLLBACK`)**
   - Attempts a `10000.00` transfer from Account `101` to Account `103` (Amit Kumar) and rolls back the entire transaction, restoring balances to their pre-transaction state.
3. **Partial Rollback with `SAVEPOINT`**
   - **Case 1 (`transfer_point`):** Debits `3000.00` from Account `101`, sets a savepoint, credits Account `102`, rolls back to `transfer_point`, and commits.
   - **Case 2 (`before_second_transfer`):** Debits `2000.00` from Account `101`, rolls back an erroneous credit to Account `102`, redirects the `2000.00` credit to Account `103`, and commits.
4. **Transaction Isolation Levels & Concurrency**
   - Configures and tests `READ COMMITTED`, `REPEATABLE READ`, and `SERIALIZABLE` session isolation levels, followed by sequential debit operations (`-5000` and `-3000`) on Account `101` across two sessions.

---

## Files
- `DBMS_Exp_8.sql` — Executable MySQL script covering `Bank_Account` setup, `COMMIT`, `ROLLBACK`, `SAVEPOINT`, and isolation level tests.
