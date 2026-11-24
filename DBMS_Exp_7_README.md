# Experiment 7: Database Normalization (UNF to 3NF & BCNF)

## Aim
To normalize a denormalized `Sales` table from **Unnormalized Form (UNF)** through **1NF, 2NF, 3NF, and BCNF**, and to verify **lossless join** and **dependency preservation**.

---

## Schema Progression

1. **Unnormalized Form (`Sales_UNF`)**
   - Single flat table containing redundant customer, product, and salesperson attributes without a defined primary key.
2. **First Normal Form (`Sales_1NF`)**
   - Enforces atomic attributes and establishes a composite primary key: `(Sale_ID, Product_ID)`.
3. **Normalized Schema (2NF / 3NF / BCNF)**
   - Eliminates partial and transitive functional dependencies by decomposing into five relations:
     - `Customer(Customer_ID PK, Customer_Name, Customer_City)`
     - `Product(Product_ID PK, Product_Name)`
     - `Salesperson(Salesperson_ID PK, Salesperson_Name)`
     - `Sales(Sale_ID PK, Customer_ID FK, Salesperson_ID FK)`
     - `Sale_Details(Sale_ID PK/FK, Product_ID PK/FK, Quantity)`

---

## Verification Steps

- **Lossless Join Verification:** Reconstructs the original records by performing `JOIN` operations across `Sales`, `Customer`, `Salesperson`, `Sale_Details`, and `Product` without generating spurious tuples.
- **Dependency Preservation Verification:** Confirms that functional dependencies (`Sale_ID -> Customer_ID, Salesperson_ID` and `(Sale_ID, Product_ID) -> Quantity`) remain enforceable directly within individual decomposed tables.

---

## Files
- `DBMS_Exp_7.sql` — Executable MySQL script containing DDL, DML, normalization decomposition, and verification queries.
