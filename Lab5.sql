-- ***********************
-- Name: Chetan Arora
-- ID: 100976240
-- Date: 02 Mar 2025
-- Purpose: Lab 05 DBS311
-- ***********************

---- Q1 ----
SELECT city
FROM locations
MINUS
SELECT l.city
FROM locations l
JOIN warehouses w ON l.location_id = w.location_id;



--- Q2 ----
SELECT p.category_id, c.category_name, COUNT(p.product_id) AS num_products
FROM products p
JOIN product_categories c ON p.category_id = c.category_id
WHERE p.category_id = 5
GROUP BY p.category_id, c.category_name

UNION ALL

SELECT p.category_id, c.category_name, COUNT(p.product_id) AS num_products
FROM products p
JOIN product_categories c ON p.category_id = c.category_id
WHERE p.category_id = 1
GROUP BY p.category_id, c.category_name

UNION ALL

SELECT p.category_id, c.category_name, COUNT(p.product_id) AS num_products
FROM products p
JOIN product_categories c ON p.category_id = c.category_id
WHERE p.category_id = 2
GROUP BY p.category_id, c.category_name;

---- Q3 ----
SELECT product_id FROM inventories  
INTERSECT  
SELECT product_id FROM inventories WHERE quantity < 5;

---- Q4 ----
(SELECT w.warehouse_name, l.state  
FROM warehouses w  
JOIN locations l  
ON w.location_id = l.location_id)  

UNION  

(SELECT NULL AS warehouse_name, l.state  
FROM locations l);

