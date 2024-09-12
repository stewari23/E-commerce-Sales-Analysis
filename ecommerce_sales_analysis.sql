-- Data Cleaning Query
-- This query cleans the data by handling null values and replacing negative quantities with 0
SELECT
  InvoiceNo,                -- Unique invoice number for each transaction
  StockCode,                -- Product code for each item
  Description,              -- Description of the product
  CASE
    WHEN Quantity < 0 THEN 0  -- Convert negative quantities to 0
    ELSE Quantity
  END AS Quantity,          -- Quantity of products sold
  InvoiceDate,              -- Date and time of the transaction
  UnitPrice,                -- Unit price of each product
  CustomerID,               -- Unique customer identifier
  Country                   -- Country of the customer
FROM `basic-bison-378623.googledacap.data_cleaning`
WHERE 
  InvoiceNo IS NOT NULL      -- Ensure invoice number is not null
  AND StockCode IS NOT NULL  -- Ensure product code is not null
  AND Description IS NOT NULL-- Ensure product description is not null
  AND Quantity IS NOT NULL   -- Ensure quantity is not null
  AND Quantity > 0           -- Exclude rows where quantity is 0
  AND InvoiceDate IS NOT NULL-- Ensure invoice date is not null
  AND UnitPrice IS NOT NULL  -- Ensure unit price is not null
  AND CustomerID IS NOT NULL -- Ensure customer ID is not null
  AND Country IS NOT NULL;   -- Ensure country is not null


-- Total Sales Calculation Query
-- This query calculates the total sales by multiplying the unit price with the quantity
SELECT SUM(UnitPrice * Quantity) AS total_sales
FROM `basic-bison-378623.googledacap.data_cleaning`;


-- Average Sales Calculation Query
-- This query calculates the average sales per transaction
SELECT AVG(UnitPrice * Quantity) AS mean_sales
FROM `basic-bison-378623.googledacap.data_cleaning`;


-- Sales Over Time Query
-- This query calculates total sales grouped by year and month to identify sales trends over time
SELECT
  EXTRACT(YEAR FROM InvoiceDate) AS year,  -- Extract year from the invoice date
  EXTRACT(MONTH FROM InvoiceDate) AS month,-- Extract month from the invoice date
  SUM(UnitPrice * Quantity) AS total_sales -- Calculate total sales for each month
FROM `basic-bison-378623.googledacap.data_cleaning`
GROUP BY year, month                       -- Group the results by year and month
ORDER BY year, month;                      -- Order the results by year and month


-- Customer Count by Country Query
-- This query calculates the number of unique customers per country
SELECT 
  Country,                                -- Customer's country
  COUNT(DISTINCT CustomerID) AS unique_customer_count -- Count unique customers per country
FROM `basic-bison-378623.googledacap.data_cleaning`
GROUP BY Country;                         -- Group the result by country
