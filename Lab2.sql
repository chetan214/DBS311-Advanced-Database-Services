-- ***********************
-- Name: Chetan Arora
-- ID: 100976240
-- Date: 20 Jan 2025
-- Purpose: Lab 02 DBS311
-- ***********************

-- Q1 SOLUTION --

SELECT job_title, COUNT(*) AS employees
FROM employees
GROUP BY job_title
ORDER BY employees;

-- Q2 SOLUTION --

SELECT 
    MAX(credit_limit) AS HIGH, 
    MIN(credit_limit) AS LOW, 
    ROUND(AVG(credit_limit), 2) AS AVERAGE, 
    MAX(credit_limit) - MIN(credit_limit) AS "High Low Difference"
FROM customers;

-- Q3 SOLUTION --
SELECT 
    o.order_id,  
    SUM(oi.quantity) AS TOTAL_ITEMS,
    SUM(oi.quantity * oi.unit_price) AS TOTAL_AMOUNT
FROM 
    orders O
JOIN 
    order_items OI ON o.order_id = o.order_id
GROUP BY 
    o.order_id
HAVING 
    SUM(oi.quantity * oi.unit_price) > 1000000
ORDER BY 
    total_amount DESC;

-- Q4 SOLUTION --

SELECT
   w.warehouse_id,
   w.warehouse_name,
   SUM(i.quantity) AS "TOTAL_PRODUCTS" 
FROM
   warehouses w 
   INNER JOIN
      inventories i 
      ON w.warehouse_id = i.warehouse_id 
GROUP BY
   w.warehouse_id,
   w.warehouse_name 
ORDER BY
w.warehouse_id;

-- Q5 SOLUTION --
SELECT
    customers.customer_id,
    customers.name AS "customer name",
    COUNT(orders.order_id) AS "total number OF orders"
FROM
    customers
LEFT JOIN
    orders ON customers.customer_id = orders.customer_id
WHERE
    (customers.name LIKE 'O%e%' -- Starts with 'O' and contains 'e'
     OR customers.name LIKE '%t') -- Ends with 't'
GROUP BY
    customers.customer_id,
    customers.name
ORDER BY
    "total number OF orders" DESC; -- Highest number of orders first

-- Q6 SOLUTION
SELECT
   p.category_id,
   SUM(o.quantity*o.unit_price) AS "TOTAL_AMOUNT",
   ROUND(AVG(o.quantity*o.unit_price), 2) AS "AVERAGE_AMOUNT" 
FROM
   order_items o 
   INNER JOIN
      products p 
      ON p.product_id = o.product_id 
GROUP BY
   p.category_id;