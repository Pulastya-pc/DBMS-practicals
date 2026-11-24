-- ============================================================================
-- EXPERIMENT - 9
-- AIM: To create a Railway Booking table containing at least 5,000 records, 
--      execute SQL queries before and after creating indexes, and compare 
--      query execution plans using the EXPLAIN command.
-- ============================================================================

-- 1. Create Table
CREATE TABLE Railway_Booking (
    Booking_ID INT PRIMARY KEY,
    Passenger_Name VARCHAR(50) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Train_No INT,
    Train_Name VARCHAR(50),
    Source_Station VARCHAR(50),
    Destination_Station VARCHAR(50),
    Journey_Date DATE,
    Seat_No INT,
    Coach VARCHAR(10),
    Booking_Status VARCHAR(20),
    Fare DECIMAL(8,2)
);

-- 2. Generate 5,000 Synthetic Records using Recursive CTE
SET SESSION cte_max_recursion_depth = 5000;

INSERT INTO Railway_Booking
    (Booking_ID, Passenger_Name, Age, Gender, Train_No,
     Train_Name, Source_Station, Destination_Station,
     Journey_Date, Seat_No, Coach, Booking_Status, Fare)
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 5000
)
SELECT
    n,
    CONCAT('Passenger_', n),
    18 + (n % 50),
    CASE
        WHEN n % 2 = 0 THEN 'Male'
        ELSE 'Female'
    END,
    12000 + (n % 20),
    CONCAT('Express_', n % 20),
    CASE
        WHEN n % 3 = 0 THEN 'Lucknow'
        WHEN n % 3 = 1 THEN 'Delhi'
        ELSE 'Kanpur'
    END,
    CASE
        WHEN n % 3 = 0 THEN 'Mumbai'
        WHEN n % 3 = 1 THEN 'Jaipur'
        ELSE 'Varanasi'
    END,
    DATE_ADD('2026-01-01', INTERVAL (n % 365) DAY),
    (n % 72) + 1,
    CASE
        WHEN n % 3 = 0 THEN 'A1'
        WHEN n % 3 = 1 THEN 'B1'
        ELSE 'S1'
    END,
    CASE
        WHEN n % 4 = 0 THEN 'Confirmed'
        WHEN n % 4 = 1 THEN 'Waiting'
        WHEN n % 4 = 2 THEN 'Cancelled'
        ELSE 'RAC'
    END,
    300 + (n % 1000)
FROM Numbers;

SELECT * FROM Railway_Booking;
SELECT COUNT(*) AS Total_Bookings FROM Railway_Booking;

-- 3. Queries Before Indexing
SELECT * FROM Railway_Booking WHERE Train_No = 12005;
SELECT * FROM Railway_Booking WHERE Passenger_Name = 'Passenger_100';
SELECT * FROM Railway_Booking WHERE Booking_Status = 'Confirmed';
SELECT * FROM Railway_Booking WHERE Source_Station = 'Lucknow';

SELECT Train_No, COUNT(*) AS Total_Passengers
FROM Railway_Booking
GROUP BY Train_No;

SELECT Booking_Status, COUNT(*) AS Total
FROM Railway_Booking
GROUP BY Booking_Status;

SELECT * FROM Railway_Booking WHERE Fare BETWEEN 500 AND 1000;
SELECT * FROM Railway_Booking ORDER BY Journey_Date;

-- Execution Plans Before Indexing
EXPLAIN SELECT * FROM Railway_Booking WHERE Train_No = 12005;
EXPLAIN SELECT * FROM Railway_Booking WHERE Passenger_Name = 'Passenger_100';
EXPLAIN SELECT * FROM Railway_Booking WHERE Booking_Status = 'Confirmed';

-- 4. Create Single-Column and Composite Indexes
CREATE INDEX idx_train_no ON Railway_Booking(Train_No);
CREATE INDEX idx_passenger_name ON Railway_Booking(Passenger_Name);
CREATE INDEX idx_booking_status ON Railway_Booking(Booking_Status);
CREATE INDEX idx_source_station ON Railway_Booking(Source_Station);
CREATE INDEX idx_journey_date ON Railway_Booking(Journey_Date);
CREATE INDEX idx_fare ON Railway_Booking(Fare);
CREATE INDEX idx_train_date ON Railway_Booking(Train_No, Journey_Date);

-- 5. Execution Plans & Queries After Indexing
EXPLAIN SELECT * FROM Railway_Booking WHERE Train_No = 12005;
EXPLAIN SELECT * FROM Railway_Booking WHERE Passenger_Name = 'Passenger_100';
EXPLAIN SELECT * FROM Railway_Booking WHERE Booking_Status = 'Confirmed';

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE Train_No = 12005
  AND Journey_Date BETWEEN '2026-02-01' AND '2026-06-30';

SELECT *
FROM Railway_Booking
WHERE Train_No = 12005
  AND Journey_Date BETWEEN '2026-02-01' AND '2026-06-30';

SHOW INDEX FROM Railway_Booking;

-- 6. Analytical & Filtered Queries
SELECT
    Train_No,
    COUNT(*) AS Total_Bookings,
    AVG(Fare) AS Average_Fare
FROM Railway_Booking
GROUP BY Train_No;

SELECT
    Source_Station,
    Destination_Station,
    COUNT(*) AS Total_Passengers
FROM Railway_Booking
GROUP BY Source_Station, Destination_Station;

SELECT
    Train_No,
    SUM(Fare) AS Total_Revenue
FROM Railway_Booking
GROUP BY Train_No
ORDER BY Total_Revenue DESC;

SELECT *
FROM Railway_Booking
WHERE Booking_Status = 'Confirmed'
  AND Source_Station = 'Lucknow';

SELECT *
FROM Railway_Booking
WHERE Journey_Date >= '2026-05-01'
ORDER BY Journey_Date;

-- Update Table Statistics & Verify Indexes
ANALYZE TABLE Railway_Booking;
SHOW INDEX FROM Railway_Booking;
