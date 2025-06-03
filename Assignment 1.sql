-- *********
-- Student1 Name: Devarsh Patel Student1 ID: 105813232
-- Student2 Name: Anshita Tiwari Student2 ID: 149730236
-- Student3 Name: Chetan Arora Student3 ID: 100976240
-- Date: 02/03/2025
-- Purpose: Assignment 1 - DBS311
-- *********

/*1. Write a query to display employee ID, first name, last name, and hire date for employees who have been hired after the last employee hired in August 2016 but two months before the first employee hired in December 2016.
Sort the result by hire date and employee ID*/

SELECT employee_id, first_name, last_name, hire_date
   FROM employees
   WHERE hire_date > (
       SELECT MAX(hire_date) 
       FROM employees
       WHERE hire_date BETWEEN '2016-08-01' AND '2016-08-31'
   )
   AND hire_date < (
       SELECT MIN(hire_date)
       FROM employees
       WHERE hire_date BETWEEN '2016-12-01' AND '2016-12-31'
   ) - INTERVAL '2' MONTH
   ORDER BY hire_date, employee_id;

/*2. Display manager ID for managers with more than one employee. Answer this question without using the COUNT()function.*/

SELECT DISTINCT e1.manager_id AS "Manager ID"
   FROM employees e1
   JOIN employees e2 ON e1.manager_id = e2.manager_id
   WHERE e1.employee_id != e2.employee_id
   ORDER BY e1.manager_id;

/*3. Use the previous query and SET Operator(s) to display manager ID for managers who have only one employee. */
SELECT DISTINCT manager_id AS "Manager ID"
FROM employees
WHERE manager_id IS NOT NULL
MINUS
SELECT DISTINCT e1.manager_id
   FROM employees e1
   JOIN employees e2 ON e1.manager_id = e2.manager_id
   WHERE e1.employee_id != e2.employee_id
   AND e1.manager_id IS NOT NULL
ORDER BY "Manager ID";


/*4.	Write a SQL query to display products that have been ordered multiple times in one day in 2016.
Display product ID, order date, and the number of times the product has been ordered on that day.
*/

SELECT oi.product_id AS "Product ID", o.order_date AS "Order Date", COUNT(*) AS "Number of Orders"
FROM order_items oi
JOIN orders o
ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY oi.product_id, o.order_date
HAVING COUNT(*) > 1
ORDER BY o.order_date, oi.product_id;

/*5. Write a query to display customer ID and customer name for customers who have purchased all these three products: Products with ID 7, 40, 94.
Sort the result by customer ID.
*/

SELECT c.customer_id AS "Customer ID", c.name
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE c.customer_id = o.customer_id AND oi.product_id = 7
)
AND EXISTS (
    SELECT 1 
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE c.customer_id = o.customer_id AND oi.product_id = 40
)
AND EXISTS (
    SELECT 1 
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE c.customer_id = o.customer_id AND oi.product_id = 94
)
ORDER BY c.customer_id;

/*6. Write a query to display employee ID and the number of orders for employees with the maximum number of orders (sales).
Sort the result by employee ID.
*/

SELECT salesman_id AS "Employee ID", COUNT(order_id) AS "Number of Orders"
   FROM orders
   GROUP BY salesman_id
   HAVING COUNT(order_id) = (
       SELECT MAX(order_count)
       FROM (
           SELECT COUNT(order_id) AS order_count
           FROM orders
           GROUP BY salesman_id
       ) subquery
   )
   ORDER BY salesman_id;

/*7. Write a query to display the month number, month name, year, total number of orders, and total sales amount for each month in 2017.
Sort the result according to month number.
*/

SELECT EXTRACT(MONTH FROM o.order_date) AS "Month Number", 
       TO_CHAR(o.order_date, 'Month') AS month, 
       EXTRACT(YEAR FROM o.order_date) AS year, 
       COUNT(DISTINCT o.order_id) AS "Total Number of Orders", 
       SUM(oi.quantity * oi.unit_price) AS "Sales Amount"
   FROM orders o
   JOIN order_items oi ON o.order_id = oi.order_id
   WHERE EXTRACT(YEAR FROM o.order_date) = 2017
   GROUP BY EXTRACT(MONTH FROM o.order_date), TO_CHAR(o.order_date, 'Month'), EXTRACT(YEAR FROM o.order_date)
   ORDER BY "Month Number";

/*8. Write a query to display month number, month name, and average sales amount for months with the average sales amount greater than average sales amount in 2017.
Round the average amount to two decimal places.
Sort the result by the month number.
*/

SELECT month_number AS "Month Number", month_name AS "Month", ROUND(avg_sales_amount, 2) AS "Average Sales Amount"
   FROM (
       SELECT EXTRACT(MONTH FROM o.order_date) AS month_number, 
              TO_CHAR(o.order_date, 'Month') AS month_name, 
              AVG(oi.quantity * oi.unit_price) AS avg_sales_amount
       FROM orders o
       JOIN order_items oi ON o.order_id = oi.order_id
       WHERE EXTRACT(YEAR FROM o.order_date) = 2017
       GROUP BY EXTRACT(MONTH FROM o.order_date), TO_CHAR(o.order_date, 'Month')
   ) subquery
   WHERE avg_sales_amount > (
       SELECT AVG(oi.quantity * oi.unit_price)
       FROM orders o
       JOIN order_items oi ON o.order_id = oi.order_id
       WHERE EXTRACT(YEAR FROM o.order_date) = 2017
   )
   ORDER BY month_number;

/*9. Write a query to display first names in EMPLOYEES that start with letter B but do not exist in CONTACTS. 
Sort the result by first name.
*/

SELECT first_name AS "First Name"
FROM employees
WHERE first_name LIKE 'B%'
AND first_name NOT IN (
SELECT first_name
FROM contacts
)
ORDER BY first_name;

/*10. Write a query to calculate the values corresponding to each line and generate the following output including the calculated values. Include your query and the query result in your answer.*/


SELECT
   'Number of customers with total purchase amount over average: ' || COUNT(*) AS "customer report" 
FROM
   (
      SELECT
         c.customer_id,
         SUM(oi.quantity*oi.unit_price) AS total_amount 
      FROM
         customers c 
         INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
         INNER JOIN
            order_items oi 
            ON oi.order_id = o.order_id 
      GROUP BY
         c.customer_id 
   )
WHERE
   total_amount > (
   SELECT
      AVG(quantity*unit_price) 
   FROM
      order_items) 
   UNION ALL
   SELECT
      'Number of customers with total purchase amount below average: ' || COUNT(*) 
   FROM
      (
         SELECT
            c.customer_id,
            SUM(oi.quantity*oi.unit_price) AS total_amount 
         FROM
            customers c 
            INNER JOIN
               orders o 
               ON c.customer_id = o.customer_id 
            INNER JOIN
               order_items oi 
               ON oi.order_id = o.order_id 
         GROUP BY
            c.customer_id 
      )
   WHERE
      total_amount < (
      SELECT
         AVG(quantity*unit_price) 
      FROM
         order_items) 
      UNION ALL
      SELECT
         'Number of customers with no orders: ' || COUNT(*) 
      FROM
         (
            SELECT
               customer_id 
            FROM
               customers minus 
               SELECT
                  customer_id 
               FROM
                  orders
         )
      UNION ALL
      SELECT
         'Total number of customers: ' || COUNT(*) 
      FROM
         (
            SELECT
               customer_id 
            FROM
               customers 
            UNION
            SELECT
               customer_id 
            FROM
               orders
         );