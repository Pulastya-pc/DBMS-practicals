# Experiment 9: Indexing and Query Execution Plan Analysis (`EXPLAIN`)

## Aim
To create a `Railway_Booking` table populated with **5,000 synthetic records**, execute SQL queries before and after index creation, and compare execution plans using the `EXPLAIN` command.

---

## Workflow Summary

1. **Synthetic Data Generation (5,000 Rows)**
   - Uses a recursive Common Table Expression (`WITH RECURSIVE Numbers`) with `cte_max_recursion_depth = 5000` to populate `Railway_Booking` across 20 trains, multiple stations (`Lucknow`, `Delhi`, `Kanpur`, `Mumbai`, `Jaipur`, `Varanasi`), and booking statuses (`Confirmed`, `Waiting`, `Cancelled`, `RAC`).
2. **Baseline Execution Plans (Pre-Indexing)**
   - Runs `EXPLAIN` on equality lookups (`Train_No`, `Passenger_Name`, `Booking_Status`), resulting in full table scans (`type: ALL`).
3. **Index Creation**
   - **Single-Column Indexes:** `idx_train_no`, `idx_passenger_name`, `idx_booking_status`, `idx_source_station`, `idx_journey_date`, `idx_fare`.
   - **Composite Index:** `idx_train_date` on `(Train_No, Journey_Date)`.
4. **Post-Indexing Verification & Statistics**
   - Re-runs `EXPLAIN` to observe index usage (`type: ref` / `range`), executes analytical aggregations (`COUNT`, `AVG`, `SUM`), inspects indexes with `SHOW INDEX`, and updates optimizer statistics with `ANALYZE TABLE`.

---

## Files
- `DBMS_Exp_9.sql` — Executable MySQL script for table creation, recursive CTE data population, indexing, and `EXPLAIN` analysis.
