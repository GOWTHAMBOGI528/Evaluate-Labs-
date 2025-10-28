create database sales;

use sales;

select count(*) from online_sales_dataset;

-- 1. Monthly Revenue and Order Volume Analysis
-- Objective: Find monthly total revenue and number of unique orders

SELECT 
    EXTRACT(YEAR FROM InvoiceDate) AS Sales_Year,
    EXTRACT(MONTH FROM InvoiceDate) AS Sales_Month,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Gross_Revenue,
    SUM((Quantity * UnitPrice) - Discount) AS Net_Revenue
FROM online_sales_dataset
WHERE InvoiceDate BETWEEN '2022-01-01' AND '2024-12-31'
GROUP BY Sales_Year, Sales_Month
ORDER BY Sales_Year, Sales_Month;


-- 2. Top Categories by Total Revenue Each Year

SELECT 
    EXTRACT(YEAR FROM InvoiceDate) AS Year,
    Category,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM online_sales_dataset
GROUP BY Year, Category
HAVING SUM(Quantity * UnitPrice) > 0
ORDER BY Year, Total_Revenue DESC;


-- 2. Top Categories by Total Revenue Each Year

SELECT 
    EXTRACT(YEAR FROM InvoiceDate) AS Year,
    Category,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM online_sales_dataset
GROUP BY Year, Category
HAVING SUM(Quantity * UnitPrice) > 0
ORDER BY Year, Total_Revenue DESC;

-- 3. Country-wise Sales Overview

SELECT 
    Country,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    SUM(ShippingCost) AS Total_Shipping_Cost,
    AVG(Quantity * UnitPrice) AS Avg_Order_Value
FROM online_sales_dataset
GROUP BY Country
ORDER BY Total_Revenue DESC;

-- 4. Revenue by Payment Method

SELECT 
    PaymentMethod,
    COUNT(*) AS Transactions,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    ROUND(SUM(Quantity * UnitPrice) / COUNT(*), 2) AS Avg_Revenue_Per_Transaction
FROM online_sales_dataset
GROUP BY PaymentMethod
ORDER BY Total_Revenue DESC;

-- 5. Return Analysis by Month

SELECT 
    EXTRACT(YEAR FROM InvoiceDate) AS Year,
    EXTRACT(MONTH FROM InvoiceDate) AS Month,
    COUNT(CASE WHEN ReturnStatus = 'Returned' THEN 1 END) AS Total_Returns,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    ROUND((COUNT(CASE WHEN ReturnStatus = 'Returned' THEN 1 END) * 100.0) / COUNT(DISTINCT InvoiceNo), 2) AS Return_Rate_Percentage
FROM online_sales_dataset
GROUP BY Year, Month
ORDER BY Year, Month;

-- 6. Shipment Provider Analysis

SELECT 
    ShipmentProvider,
    COUNT(DISTINCT InvoiceNo) AS Orders_Shipped,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    SUM(ShippingCost) AS Total_Shipping_Cost,
    ROUND(AVG(ShippingCost), 2) AS Avg_Shipping_Cost_Per_Order
FROM online_sales_dataset
GROUP BY ShipmentProvider
ORDER BY Total_Revenue DESC;

-- 7. Warehouse Performance Summary

SELECT 
    WarehouseLocation,
    COUNT(DISTINCT InvoiceNo) AS Orders_Dispatched,
    SUM(Quantity * UnitPrice) AS Revenue_Generated,
    ROUND(SUM(Quantity) / COUNT(DISTINCT InvoiceNo), 2) AS Avg_Items_Per_Order
FROM online_sales_dataset
GROUP BY WarehouseLocation
ORDER BY Revenue_Generated DESC;

-- 8. Order Priority-Based Sales Summary

SELECT 
    OrderPriority,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Total_Revenue,
    ROUND(AVG(Quantity * UnitPrice), 2) AS Avg_Order_Value
FROM online_sales_dataset
GROUP BY OrderPriority
ORDER BY Total_Revenue DESC;

-- 9. Yearly Revenue Growth Percentage

WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM InvoiceDate) AS Year,
        SUM(Quantity * UnitPrice) AS Total_Revenue
    FROM online_sales_dataset
    GROUP BY Year
)
SELECT 
    Year,
    Total_Revenue,
    ROUND(((Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Year)) / LAG(Total_Revenue) OVER (ORDER BY Year)) * 100, 2) AS Growth_Percentage
FROM yearly_sales
ORDER BY Year;

-- 10. Monthly Revenue by Sales Channel

SELECT 
    EXTRACT(YEAR FROM InvoiceDate) AS Year,
    EXTRACT(MONTH FROM InvoiceDate) AS Month,
    SalesChannel,
    SUM(Quantity * UnitPrice) AS Total_Revenue
FROM online_sales_dataset
GROUP BY Year, Month, SalesChannel
ORDER BY Year, Month, Total_Revenue DESC;


