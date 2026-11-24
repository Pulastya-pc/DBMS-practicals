-- ============================================================================
-- EXPERIMENT - 10
-- AIM: To create a Sales database containing at least 10,000 records, identify 
--      slow SQL queries, analyze their execution plans using EXPLAIN, and 
--      optimize queries using indexing and query rewriting techniques.
-- ============================================================================

-- 1. Create Table
CREATE TABLE Sales (
    Sale_ID INT PRIMARY KEY,
    Customer_ID INT,
    Customer_Name VARCHAR(50),
    Product_ID INT,
    Product_Name VARCHAR(50),
    Category VARCHAR(30),
    Quantity INT,
    Price DECIMAL(10,2),
    Total_Amount DECIMAL(12,2),
    Sale_Date DATE,
    City VARCHAR(50),
    Payment_Mode VARCHAR(20)
);

-- 2. Generate 10,000 Synthetic Records using Recursive CTE
SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO Sales
    (Sale_ID, Customer_ID, Customer_Name, Product_ID,
     Product_Name, Category, Quantity, Price, Total_Amount,
     Sale_Date, City, Payment_Mode)
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 10000
)
SELECT
    n,
    100 + (n % 500),
    CONCAT('Customer_', n % 500),
    1000 + (n % 100),
    CONCAT('Product_', n % 100),
    CASE
        WHEN n % 4 = 0 THEN 'Electronics'
        WHEN n % 4 = 1 THEN 'Clothing'
        WHEN n % 4 = 2 THEN 'Furniture'
        ELSE 'Grocery'
    END,
    (n % 10) + 1,
    100 + (n % 900),
    ((n % 10) + 1) * (100 + (n % 900)),
    DATE_ADD('2026-01-01', INTERVAL (n % 365) DAY),
    CASE
        WHEN n % 4 = 0 THEN 'Lucknow'
        WHEN n % 4 = 1 THEN 'Delhi'
        WHEN n % 4 = 2 THEN 'Kanpur'
        ELSE 'Mumbai'
    END,
    CASE
        WHEN n % 3 = 0 THEN 'UPI'
        WHEN n % 3 = 1 THEN 'Cash'
        ELSE 'Card'
    END
FROM Numbers;

SELECT COUNT(*) AS Total_Records FROM Sales;
SELECT * FROM Sales;

-- 3. Baseline Queries & Execution Plans (Before Indexing)
EXPLAIN SELECT * FROM Sales WHERE Customer_ID = 150;
SELECT * FROM Sales WHERE Customer_ID = 150;

EXPLAIN SELECT * FROM Sales WHERE Category = 'Electronics';
SELECT * FROM Sales WHERE Category = 'Electronics';

EXPLAIN SELECT * FROM Sales WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';
SELECT * FROM Sales WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';

EXPLAIN SELECT City, SUM(Total_Amount) AS Total_Sales FROM Sales GROUP BY City;
SELECT City, SUM(Total_Amount) AS Total_Sales FROM Sales GROUP BY City;

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150
  AND Category = 'Electronics'
  AND Sale_Date >= '2026-03-01';

SELECT *
FROM Sales
WHERE Customer_ID = 150
  AND Category = 'Electronics'
  AND Sale_Date >= '2026-03-01';

-- 4. Create Single-Column & Composite Indexes
CREATE INDEX idx_customer ON Sales(Customer_ID);
CREATE INDEX idx_category ON Sales(Category);
CREATE INDEX idx_sale_date ON Sales(Sale_Date);
CREATE INDEX idx_city ON Sales(City);
CREATE INDEX idx_customer_category_date ON Sales(Customer_ID, Category, Sale_Date);

-- 5. Execution Plans After Indexing
EXPLAIN SELECT * FROM Sales WHERE Customer_ID = 150;
EXPLAIN SELECT * FROM Sales WHERE Category = 'Electronics';
EXPLAIN SELECT * FROM Sales WHERE Sale_Date BETWEEN '2026-03-01' AND '2026-06-30';
EXPLAIN SELECT City, SUM(Total_Amount) AS Total_Sales FROM Sales GROUP BY City;

EXPLAIN
SELECT *
FROM Sales
WHERE Customer_ID = 150
  AND Category = 'Electronics'
  AND Sale_Date >= '2026-03-01';

-- 6. Rewritten / Optimized Queries (Column Projection & Range Optimization)
SELECT Sale_ID, Customer_ID, Total_Amount
FROM Sales
WHERE Customer_ID = 150;

SELECT Category, SUM(Total_Amount) AS Category_Sales
FROM Sales
GROUP BY Category;

SELECT Sale_ID, Product_Name, Total_Amount
FROM Sales
WHERE Sale_Date >= '2026-03-01'
  AND Sale_Date < '2026-07-01';

SELECT Sale_ID, Customer_Name, Total_Amount
FROM Sales
ORDER BY Total_Amount DESC
LIMIT 10;

SELECT SUM(Total_Amount) AS Total_Revenue
FROM Sales;

-- 7. Inspect Indexes & Refresh Table Statistics
SHOW INDEX FROM Sales;
ANALYZE TABLE Sales;
