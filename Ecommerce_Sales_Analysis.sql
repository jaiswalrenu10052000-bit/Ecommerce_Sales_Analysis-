create database ecommerce_project
USE ecommerce_project;

CREATE TABLE ecommerce_orders (
    Order_ID VARCHAR(20) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Customer_Age INT,
    Gender VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50),
    Product_ID VARCHAR(20),
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    Unit_Price_INR DECIMAL(10,2),
    Discount_Percent DECIMAL(5,2),
    Discount_Amount_INR DECIMAL(10,2),
    Shipping_Charge_INR DECIMAL(10,2),
    Order_Value_INR DECIMAL(10,2),
    Payment_Method VARCHAR(50),
    Order_Status VARCHAR(30),
    Sales_Channel VARCHAR(30)
);
SELECT * FROM ECOMMERCE_ORDERS;
USE ecommerce_project;
SHOW TABLES;
USE ecommerce_project;

SELECT *
FROM `e-commerce _sql_data`
LIMIT 10;

USE ecommerce_project;

SELECT *
FROM `e-commerce_sql_data`
LIMIT 10;
-- total orders
SELECT COUNT(*) AS Total_Orders
FROM `e-commerce _sql_data`;

DESCRIBE `e-commerce _sql_data`;
SELECT Order_Date
FROM `e-commerce _sql_data`
LIMIT 5;

SELECT
    Order_Date,
    STR_TO_DATE(Order_Date, '%Y-%m-%d') AS Correct_SQL_Date
FROM `e-commerce _sql_data`
LIMIT 5;
-- rename table
USE ecommerce_project;

RENAME TABLE `e-commerce _sql_data`
TO ecommerce_sales_data;
-- total orders
SELECT COUNT(*) AS Total_Orders
FROM ecommerce_sales_data;

-- total sales
SELECT ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data;
-- average order value (aov)
SELECT ROUND(AVG(Order_Value_INR), 2) AS Average_Order_Value
FROM ecommerce_sales_data;
-- category wise sales
SELECT
    Category,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Category
ORDER BY Total_Sales DESC;
-- month wise sales
SELECT
    DATE_FORMAT(
        STR_TO_DATE(Order_Date, '%Y-%m-%d'),
        '%Y-%m'
    ) AS Sales_Month,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Sales_Month
ORDER BY Sales_Month;
-- payment method analysis
SELECT
    Payment_Method,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Payment_Method
ORDER BY Total_Orders DESC;
-- city wise sales
SELECT
    City,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY City
ORDER BY Total_Sales DESC;
-- state wise sales
SELECT
    State,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY State
ORDER BY Total_Sales DESC;
-- top 10 customers alter
SELECT
    Customer_ID,
    ROUND(SUM(Order_Value_INR), 2) AS Customer_Sales
FROM ecommerce_sales_data
GROUP BY Customer_ID
ORDER BY Customer_Sales DESC
LIMIT 10;
-- top 10 pruducts by quantity
SELECT
    Product_Name,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_sales_data
GROUP BY Product_Name
ORDER BY Total_Quantity DESC
LIMIT 10;
-- top 10 product by sales
SELECT
    Product_Name,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- sales channel analysis
SELECT
    Sales_Channel,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Sales_Channel
ORDER BY Total_Sales DESC;

-- GENDER WISE SALES
SELECT
    Gender,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Gender
ORDER BY Total_Sales DESC;

-- total discount
SELECT
    ROUND(SUM(Discount_Amount_INR), 2) AS Total_Discount
FROM ecommerce_sales_data;
-- orders above average orders value
SELECT *
FROM ecommerce_sales_data
WHERE Order_Value_INR > (
    SELECT AVG(Order_Value_INR)
    FROM ecommerce_sales_data
);
-- PRODUCT SALES RANKING
SELECT
    Product_Name,
    Total_Sales,
    DENSE_RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM (
    SELECT
        Product_Name,
        ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
    FROM ecommerce_sales_data
    GROUP BY Product_Name
) AS Product_Sales;

-- ORDERS VALUE VALIDATION
SELECT
    Order_ID,
    Order_Value_INR,
    ROUND(
        Quantity * Unit_Price_INR
        - Discount_Amount_INR
        + Shipping_Charge_INR,
        2
    ) AS Calculated_Order_Value
FROM ecommerce_sales_data
WHERE ABS(
    Order_Value_INR -
    (
        Quantity * Unit_Price_INR
        - Discount_Amount_INR
        + Shipping_Charge_INR
    )
) > 0.01;

--
DESCRIBE ecommerce_sales_data;

-- order_id rename
ALTER TABLE ecommerce_sales_data
RENAME COLUMN `ï»¿Order_ID` TO Order_ID;

-- duplicate order_id check
SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM ecommerce_sales_data
GROUP BY Order_ID
HAVING COUNT(*) > 1;
-- duplicate column check
SELECT
    COUNT(*) AS Total_Rows,
    SUM(Order_ID IS NULL) AS Null_Order_ID,
    SUM(Order_Date IS NULL) AS Null_Order_Date,
    SUM(Customer_ID IS NULL) AS Null_Customer_ID,
    SUM(Product_ID IS NULL) AS Null_Product_ID,
    SUM(Order_Value_INR IS NULL) AS Null_Order_Value
FROM ecommerce_sales_data;

-- space check krna 
SELECT COUNT(*) AS Blank_Order_ID
FROM ecommerce_sales_data
WHERE TRIM(Order_ID) = '';

-- blank order date check 
SELECT COUNT(*) AS Blank_Order_Date
FROM ecommerce_sales_data
WHERE TRIM(Order_Date) = '';

-- customer id check
SELECT COUNT(*) AS Blank_Customer_ID
FROM ecommerce_sales_data
WHERE TRIM(Customer_ID) = '';

-- product id check
SELECT COUNT(*) AS Blank_Product_ID
FROM ecommerce_sales_data
WHERE TRIM(Product_ID) = '';

-- order value check table
SELECT COUNT(*) AS Blank_Order_Value
FROM ecommerce_sales_data
WHERE Order_Value_INR IS NULL;

-- 
SELECT
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales,
    ROUND(AVG(Order_Value_INR), 2) AS Average_Order_Value
FROM ecommerce_sales_data;

--
SELECT
    Category,
    ROUND(SUM(Order_Value_INR), 2) AS Total_Sales
FROM ecommerce_sales_data
GROUP BY Category
ORDER BY Total_Sales DESC;
