-- =============================================================================
-- EXPERIMENT – 7: DATABASE NORMALIZATION (UNF to BCNF) & VERIFICATION
-- Student: Pulastya Pandey (25LBCS3055)
-- Aim: Identify functional dependencies in a denormalized Sales table and
--      normalize step-by-step from UNF to 1NF, 2NF, 3NF, and BCNF.
--      Verify lossless join and dependency preservation using SQL queries.
-- =============================================================================

-- =============================================================================
-- 1. CREATE AND INITIALIZE DATABASE
-- =============================================================================
CREATE DATABASE IF NOT EXISTS RetailNormalization; 
USE RetailNormalization;

-- Clean up any existing tables to allow re-runnable execution
DROP TABLE IF EXISTS Order_Details;
DROP TABLE IF EXISTS Orders_3NF;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Salespersons;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Purchase_1NF;
DROP TABLE IF EXISTS Purchase_UNF;
DROP TABLE IF EXISTS Consultant_Coordinator;
DROP TABLE IF EXISTS Coordinator_Project;
DROP TABLE IF EXISTS Consultant_Assignment;


-- =============================================================================
-- 2. CREATE THE DENORMALIZED SALES TABLE (UNNORMALIZED FORM - UNF)
-- =============================================================================
CREATE TABLE Purchase_UNF (
    Order_ID INT, 
    Order_Date DATE,
    Customer_ID VARCHAR(10), 
    Customer_Name VARCHAR(50), 
    Product_ID VARCHAR(10), 
    Product_Name VARCHAR(50), 
    Quantity INT,
    Unit_Price DECIMAL(10,2), 
    Salesperson_ID VARCHAR(10), 
    Salesperson_Name VARCHAR(50)
);

INSERT INTO Purchase_UNF VALUES
(2001, '2026-02-05', 'C11', 'Kabir', 'P11', 'Tablet', 2, 32000.00, 'S11', 'Ananya'),
(2001, '2026-02-05', 'C11', 'Kabir', 'P12', 'Headphones', 3, 1800.00, 'S11', 'Ananya'),
(2002, '2026-02-08', 'C12', 'Ishita', 'P11', 'Tablet', 1, 32000.00, 'S12', 'Vikram'),
(2003, '2026-02-12', 'C13', 'Dev', 'P13', 'Printer', 2, 12500.00, 'S11', 'Ananya'),
(2004, '2026-02-16', 'C11', 'Kabir', 'P13', 'Printer', 1, 12500.00, 'S12', 'Vikram'),
(2005, '2026-02-20', 'C14', 'Naina', 'P12', 'Headphones', 4, 1800.00, 'S13', 'Arjun');

SELECT * FROM Purchase_UNF;


-- =============================================================================
-- 3. FUNCTIONAL DEPENDENCY ANALYSIS & CANDIDATE KEY
-- =============================================================================
/*
Functional Dependencies Identified:
1. Order_ID -> Order_Date
2. Order_ID -> Customer_ID
3. Order_ID -> Salesperson_ID
4. Customer_ID -> Customer_Name
5. Product_ID -> Product_Name
6. Product_ID -> Unit_Price
7. Salesperson_ID -> Salesperson_Name
8. (Order_ID, Product_ID) -> Quantity

Candidate Key: (Order_ID, Product_ID)
*/


-- =============================================================================
-- 4. FIRST NORMAL FORM (1NF)
-- Rule: Ensure atomic values and define a composite primary key.
-- =============================================================================
CREATE TABLE Purchase_1NF (
    Order_ID INT, 
    Order_Date DATE,
    Customer_ID VARCHAR(10), 
    Customer_Name VARCHAR(50), 
    Product_ID VARCHAR(10), 
    Product_Name VARCHAR(50), 
    Quantity INT,
    Unit_Price DECIMAL(10,2), 
    Salesperson_ID VARCHAR(10), 
    Salesperson_Name VARCHAR(50), 
    PRIMARY KEY (Order_ID, Product_ID)
);

INSERT INTO Purchase_1NF
SELECT * FROM Purchase_UNF;

SELECT * FROM Purchase_1NF;


-- =============================================================================
-- 5. SECOND NORMAL FORM (2NF)
-- Rule: Must be in 1NF and eliminate partial dependencies
--       (no non-prime attribute should depend on a proper subset of candidate key).
--
-- Partial Dependencies:
--   Order_ID -> Order_Date, Customer_ID, Customer_Name, Salesperson_ID, Salesperson_Name
--   Product_ID -> Product_Name, Unit_Price
-- Full Dependency:
--   (Order_ID, Product_ID) -> Quantity
-- =============================================================================

-- Table 1: Orders (Attributes depending strictly on Order_ID)
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Order_Date DATE, 
    Customer_ID VARCHAR(10), 
    Customer_Name VARCHAR(50), 
    Salesperson_ID VARCHAR(10),
    Salesperson_Name VARCHAR(50)
);

INSERT INTO Orders 
SELECT DISTINCT
    Order_ID, 
    Order_Date, 
    Customer_ID, 
    Customer_Name,
    Salesperson_ID, 
    Salesperson_Name
FROM Purchase_1NF;

-- Table 2: Products (Attributes depending strictly on Product_ID)
CREATE TABLE Products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(50), 
    Unit_Price DECIMAL(10,2)
);

INSERT INTO Products 
SELECT DISTINCT
    Product_ID, 
    Product_Name, 
    Unit_Price
FROM Purchase_1NF;

-- Table 3: Order_Details (Attributes fully dependent on (Order_ID, Product_ID))
CREATE TABLE Order_Details ( 
    Order_ID INT,
    Product_ID VARCHAR(10), 
    Quantity INT,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID), 
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

INSERT INTO Order_Details
SELECT Order_ID, Product_ID, Quantity 
FROM Purchase_1NF;

-- Verify 2NF Tables
SELECT * FROM Orders; 
SELECT * FROM Products;
SELECT * FROM Order_Details;


-- =============================================================================
-- 6. THIRD NORMAL FORM (3NF)
-- Rule: Must be in 2NF and eliminate transitive dependencies
--       (no non-prime attribute should transitively depend on the primary key).
--
-- Transitive Dependencies in Orders table:
--   Order_ID -> Customer_ID -> Customer_Name    ==> Customer_ID -> Customer_Name
--   Order_ID -> Salesperson_ID -> Salesperson_Name ==> Salesperson_ID -> Salesperson_Name
-- =============================================================================

-- Table 1: Customers
CREATE TABLE Customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(50)
);

INSERT INTO Customers
SELECT DISTINCT Customer_ID, Customer_Name 
FROM Purchase_1NF;

-- Table 2: Salespersons
CREATE TABLE Salespersons (
    Salesperson_ID VARCHAR(10) PRIMARY KEY, 
    Salesperson_Name VARCHAR(50)
);

INSERT INTO Salespersons
SELECT DISTINCT Salesperson_ID, Salesperson_Name 
FROM Purchase_1NF;

-- Table 3: Orders_3NF (Transitive attributes removed; foreign keys maintained)
CREATE TABLE Orders_3NF ( 
    Order_ID INT PRIMARY KEY,
    Order_Date DATE, 
    Customer_ID VARCHAR(10), 
    Salesperson_ID VARCHAR(10),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Salesperson_ID) REFERENCES Salespersons(Salesperson_ID)
);

INSERT INTO Orders_3NF 
SELECT DISTINCT
    Order_ID, 
    Order_Date, 
    Customer_ID, 
    Salesperson_ID
FROM Purchase_1NF;

-- Verify 3NF Tables
SELECT * FROM Customers; 
SELECT * FROM Salespersons;
SELECT * FROM Orders_3NF;


-- =============================================================================
-- 7. BOYCE-CODD NORMAL FORM (BCNF)
-- Demonstration with Consultant_Assignment relation:
--   Relation: Consultant_Assignment(Consultant_ID, Project_ID, Coordinator_ID)
--   Dependencies:
--     (Consultant_ID, Project_ID) -> Coordinator_ID
--     Coordinator_ID -> Project_ID
--
--   Note: Coordinator_ID -> Project_ID violates BCNF because Coordinator_ID
--   is not a superkey. It satisfies 3NF because Project_ID is a prime attribute.
-- =============================================================================

CREATE TABLE Consultant_Assignment (
    Consultant_ID VARCHAR(10),
    Project_ID VARCHAR(10),
    Coordinator_ID VARCHAR(10),
    PRIMARY KEY (Consultant_ID, Project_ID)
);

INSERT INTO Consultant_Assignment VALUES
('E11', 'P11', 'S11'),
('E12', 'P11', 'S11'),
('E13', 'P12', 'S12'),
('E14', 'P12', 'S12');

-- Decompose into BCNF:
-- Table 1: Coordinator_Project (Coordinator_ID is a superkey / PK)
CREATE TABLE Coordinator_Project (
    Coordinator_ID VARCHAR(10) PRIMARY KEY,
    Project_ID VARCHAR(10)
);

INSERT INTO Coordinator_Project VALUES
('S11', 'P11'),
('S12', 'P12');

-- Table 2: Consultant_Coordinator
CREATE TABLE Consultant_Coordinator (
    Consultant_ID VARCHAR(10),
    Coordinator_ID VARCHAR(10),
    PRIMARY KEY (Consultant_ID, Coordinator_ID)
);

INSERT INTO Consultant_Coordinator VALUES
('E11', 'S11'),
('E12', 'S11'),
('E13', 'S12'),
('E14', 'S12');

-- Verify BCNF Decomposition (Lossless Join)
SELECT
    cc.Consultant_ID,
    cp.Project_ID,
    cc.Coordinator_ID
FROM Consultant_Coordinator cc
JOIN Coordinator_Project cp
    ON cc.Coordinator_ID = cp.Coordinator_ID;


-- =============================================================================
-- 8. VERIFY LOSSLESS JOIN (3NF DECOMPOSITION RECONSTRUCTION)
-- Reconstructing the original denormalized data from 3NF relations
-- =============================================================================
SELECT
    o.Order_ID,
    o.Order_Date,
    c.Customer_ID,
    c.Customer_Name,
    od.Product_ID,
    p.Product_Name,
    od.Quantity,
    p.Unit_Price,
    s.Salesperson_ID,
    s.Salesperson_Name
FROM Orders_3NF o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
JOIN Salespersons s
    ON o.Salesperson_ID = s.Salesperson_ID
JOIN Order_Details od
    ON o.Order_ID = od.Order_ID
JOIN Products p
    ON od.Product_ID = p.Product_ID
ORDER BY o.Order_ID, od.Product_ID;

-- Verify Row Count matches the original 6 rows
SELECT COUNT(*) AS reconstructed_rows
FROM Orders_3NF o
JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
JOIN Salespersons s
    ON o.Salesperson_ID = s.Salesperson_ID
JOIN Order_Details od
    ON o.Order_ID = od.Order_ID
JOIN Products p
    ON od.Product_ID = p.Product_ID;


-- =============================================================================
-- 9. VERIFY DEPENDENCY PRESERVATION
-- Schema inspection to confirm primary keys & foreign keys preserve dependencies
-- =============================================================================
/*
Mapping of Functional Dependencies to Normalized Relations:
- Customer_ID -> Customer_Name                         --> Customers
- Salesperson_ID -> Salesperson_Name                   --> Salespersons
- Order_ID -> Order_Date, Customer_ID, Salesperson_ID  --> Orders_3NF
- Product_ID -> Product_Name, Unit_Price               --> Products
- (Order_ID, Product_ID) -> Quantity                   --> Order_Details
*/

SHOW CREATE TABLE Customers; 
SHOW CREATE TABLE Salespersons; 
SHOW CREATE TABLE Orders_3NF; 
SHOW CREATE TABLE Products;
SHOW CREATE TABLE Order_Details;