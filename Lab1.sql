//Name=Chetan Arora

//Ans-1
DEFINE tomorrow = sysdate + 1;
SELECT 
    TO_CHAR(&tomorrow, 'FMMonth DDth "of year" YYYY') AS "Tomorrow"
FROM dual;

//Ans:-2
SELECT 
    p.product_id AS "Product ID", 
    p.product_name AS "Product Name", 
    p.list_price, 
    ROUND(p.list_price + 0.02 * p.list_price) AS "New Price",
    ROUND(p.list_price + 0.02 * p.list_price) - p.list_price AS "Price Difference"
FROM products p
INNER JOIN product_categories c 
ON p.category_id = c.category_id
WHERE p.category_id IN (2, 3, 5)
ORDER BY p.category_id, p.product_id; 

//Ans-3
SELECT last_name || ', ' || concat(first_name, ' ') || 'is ' || job_title AS "Employee Info"
FROM employees
WHERE manager_id = 2
ORDER BY employee_id;

//Ans4
SELECT 
    last_name AS "Last Name",
    hire_date AS "Hire Date",
    ROUND(MONTHS_BETWEEN(sysdate, hire_date)/12) as "Years Worked"
FROM employees
WHERE hire_date < to_date('01-OCT-2016', 'DD-MON-YYYY')
ORDER BY hire_date, "Years Worked";
    
//Ans-5
SELECT 
    last_name AS "Last Name",
    hire_date AS "Hire Date",
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY'), 
    'fmDAY, Month "the" ddspth "of year" YYYY') AS "Review Date"
FROM employees
WHERE hire_date > to_date('01-JAN-2016', 'DD-MON-YYYY')
ORDER BY "Review Date";


//Ans 6
SELECT 
    w.warehouse_id AS "Warehouse ID",
    w.warehouse_name AS "Warehouse Name",
    l.city AS "City",
    nvl(l.state, 'Unknown') AS "State"
FROM warehouses w
INNER JOIN locations l
ON w.location_id = l.location_id
ORDER BY w.warehouse_id;


