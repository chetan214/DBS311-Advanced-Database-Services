-- ***********************
-- Name: Chetan Arora
-- ID: 100976240
-- Date: 10 Mar 2025
-- Purpose: Lab 06 DBS311
-- ***********************

-- Question 1: Factorial Calculation
SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE calculate_factorial(n IN NUMBER) AS
    fact NUMBER := 1;
    i NUMBER;
    calculation VARCHAR2(1000);
BEGIN
    IF n < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Factorial is not defined for negative numbers.');
    ELSE
        calculation := n || '! = fact(' || n || ') = ';

        FOR i IN REVERSE 1..n LOOP
            fact := fact * i;
            calculation := calculation || i;
            IF i > 1 THEN
                calculation := calculation || ' * ';
            END IF;
        END LOOP;

        calculation := calculation || ' = ' || fact;

        DBMS_OUTPUT.PUT_LINE(calculation);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in calculating factorial: ' || SQLERRM);
END calculate_factorial;
/

BEGIN
    calculate_factorial(&n);
END;
/

-- Question 2: Employee Salary Calculation
SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE calculate_salary(emp_id IN NUMBER) AS
    v_years NUMBER;
    v_salary NUMBER := 10000;
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
BEGIN
    SELECT first_name, last_name, TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) / 12
    INTO v_first_name, v_last_name, v_years
    FROM employees
    WHERE employee_id = emp_id;
    
    IF v_years > 0 THEN
        FOR i IN 1..v_years LOOP
            v_salary := v_salary * 1.05; -- 5% increase per year
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Salary: $' || TO_CHAR(v_salary, '99999.99'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee does not exist');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error calculating the salary: ' || SQLERRM);
END calculate_salary;
/

BEGIN
    calculate_salary(&emp_id);
END;
/


-- Question 3: Warehouse Report
SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PROCEDURE warehouses_report AS
    v_warehouse_name VARCHAR2(100);
    v_city VARCHAR2(100);
    v_state VARCHAR2(100);
BEGIN
    FOR i IN 1..9 LOOP
        BEGIN
            SELECT w.warehouse_name, l.city, NVL(l.state, 'no state')
            INTO v_warehouse_name, v_city, v_state
            FROM warehouses w
            JOIN locations l ON w.location_id = l.location_id
            WHERE w.warehouse_id = i;
            
            DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || i);
            DBMS_OUTPUT.PUT_LINE('Warehouse Name: ' || v_warehouse_name);
            DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
            DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
            DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Handle case where no data is found for the warehouse ID
                DBMS_OUTPUT.PUT_LINE('No data found for Warehouse ID: ' || i);
                DBMS_OUTPUT.PUT_LINE('---------------------------------------');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Error fetching warehouse data for ID: ' || i || ': ' || SQLERRM);
                DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        END;
    END LOOP;
END warehouses_report;
/

BEGIN
    warehouses_report;
END;
/