-- ***********************
-- Name: Chetan Arora
-- ID: 100976240
-- Date: 26 Jan 2025
-- Purpose: Lab 03 DBS311
-- ***********************
---- Q1 ----

select last_name, TO_CHAR(hire_date, 'DD-MON-YY') AS HIREDATE
from employees
where hire_date > to_date('31-MAR-2016', 'DD-MON-YYYY')
  and hire_date < (select hire_date
                   from employees
                   where employee_id = 107)
order by hire_date, employee_id;

--- Q2 ----

SELECT 
    name, 
    credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit)
                      FROM customers)
ORDER BY customer_id;


---- Q3 ----
SELECT 
    category_id,
    product_id,
    product_name,
    list_price
FROM products
WHERE list_price IN (SELECT MAX(list_price)
                    FROM products
                    GROUP BY category_id)
ORDER BY category_id, product_id;
                    

---- Q4 ----
SELECT
    c.category_id,
    c.category_name
FROM product_categories c
INNER JOIN products p
ON p.category_id = c.category_id
WHERE p.list_price = (SELECT MAX(list_price)
                      FROM products);



---- Q5 ----
SELECT
    product_name,
    list_price
FROM products
WHERE category_id = 1 
AND list_price < ANY(SELECT MIN(list_price)
                  FROM products
                  GROUP BY category_id)
ORDER BY list_price DESC, product_id;


--- Q6 ---

SELECT MAX(list_price)
FROM products
WHERE category_id = (SELECT category_id
                     FROM products
                     WHERE list_price = (SELECT MIN(list_price)
                                         FROM products));