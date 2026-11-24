# Experiment 10: Query Optimization with Indexing & Query Rewriting

## Aim
To create a `Sales` table containing **10,000 synthetic records**, identify slow SQL queries, analyze execution plans via `EXPLAIN`, and optimize performance using indexing and query rewriting techniques.

---

## Workflow Summary

1. **Synthetic Data Generation (10,000 Rows)**
   - Populates `Sales` using a recursive CTE (`cte_max_recursion_depth = 10000`) across 500 customers, 100 products, 4 categories (`Electronics`, `Clothing`, `Furniture`, `Grocery`), 4 cities, and 3 payment modes.
2. **Baseline Profiling (`EXPLAIN`)**
   - Profiles unindexed filters on `Customer_ID`, `Category`, `Sale_Date` (`BETWEEN`), `GROUP BY City`, and multi-predicate filters.
3. **Indexing Strategy**
   - **Single-Column Indexes:** `idx_customer`, `idx_category`, `idx_sale_date`, `idx_city`.
   - **Composite Covering/Filter Index:** `idx_customer_category_date` on `(Customer_ID, Category, Sale_Date)`.
4. **Query Rewriting Techniques**
   - Replaces `SELECT *` with targeted column projections (`SELECT Sale_ID, Customer_ID, Total_Amount`) to minimize I/O and leverage covering indexes.
   - Replaces inclusive `BETWEEN` date bounds with explicit half-open range predicates (`Sale_Date >= '2026-03-01' AND Sale_Date < '2026-07-01'`).
   - Uses `ORDER BY Total_Amount DESC LIMIT 10` for top-N retrieval and refreshes optimizer statistics with `ANALYZE TABLE Sales`.

---

## Files
- `DBMS_Exp_10.sql` — Executable MySQL script for 10,000-row dataset generation, index creation, `EXPLAIN` comparison, and rewritten queries.
