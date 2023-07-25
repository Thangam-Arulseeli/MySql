####### MySQL Subquery  ##########
/* A MySQL subquery is a query nested within another query such as SELECT, INSERT, UPDATE or DELETE.
   Subquery can be nested within another subquery.

### When the subquery returns more than one rows(values), it will create error(Main query will not be executed)
### To avoid it, we need to use NOT IN / IN /  = != <> < > <= >=  ANY - ALL - SOME

NOTE: if the result of an inner query contains at least one row, then ANY / SOME / ALL operator will be used to complare the values with relational operator
   
### When used with a subquery, the word IN is an alias for = ANY. Thus, these two statements are the same:
	SELECT s1 FROM t1 WHERE s1 = ANY (SELECT s1 FROM t2);
	SELECT s1 FROM t1 WHERE s1 IN    (SELECT s1 FROM t2);

### NOT IN is not an alias for <> ANY, but for <> ALL. 

### The word SOME is an alias for ANY. SOME operator supports in MySQL, SQL Server, Oracle, PostgreSQL
### SOME Operator
	SOME compare a value to each value in a list or results from a query and evaluate to true if the result of an inner query contains at least one row. 
    SOME must match at least one row in the subquery and must be preceded by comparison operators. 
    Suppose using greater than ( >) with SOME means greater than at least one value.
    
	Thus, these two statements are the same:
		SELECT s1 FROM t1 WHERE s1 <> ANY  (SELECT s1 FROM t2);
		SELECT s1 FROM t1 WHERE s1 <> SOME (SELECT s1 FROM t2);
    
	SELECT s1 FROM t1 WHERE s1 > ANY (TABLE t2);
	SELECT s1 FROM t1 WHERE s1 = ANY (TABLE t2);
	SELECT s1 FROM t1 WHERE s1 IN (TABLE t2);
	SELECT s1 FROM t1 WHERE s1 <> ANY  (TABLE t2);
	SELECT s1 FROM t1 WHERE s1 <> SOME (TABLE t2);
*/

Use classicmodels;
## Example 1 : Subquery to return the employees who work with 'Sugumar'
select * from employee;
SELECT lastName, firstName FROM employee 
WHERE department = (SELECT department FROM employee WHERE empname = 'Helen');

## Example 1.1 : Subquery to return the employees who work in the offices located in the USA.
SELECT lastName, firstName FROM employee 
WHERE officeCode IN (SELECT officeCode FROM offices WHERE country = 'USA');

## Example 2 : MySQL subquery in the WHERE clause - 
SELECT empid,     empname,      department, salary FROM     employee
WHERE  amount = (SELECT MAX(salary) FROM employee);

## Example : 3 -- Find employees whose salary are greater than the average salary using a subquery
SELECT empid,     empname,      department, salary FROM     employee
WHERE  amount > (SELECT AVG(salary) FROM employee);

## Example : 4 subquery with IN and NOT IN operators
  -- If a subquery returns more than one value, you can use other operators such as IN or NOT IN operator in the WHERE clause.

# you can use a subquery with NOT IN operator to find the customers who have not placed any orders 
SELECT customerName FROM customers
WHERE customerNumber NOT IN (SELECT DISTINCT customerNumber FROM orders);               

### Example ALL  -  Display the details when  'des_amount' of 'despatch' table is more than 'ord_amount' from 'orders' table which satisfies the condition
SELECT des_date,des_amount,ord_amount
FROM despatch
WHERE des_amount>ALL(
SELECT ord_amount FROM orders
WHERE ord_amount=2000);

### Example ANY  - 1  - 'agent_code' should be any 'agent_code' from 'customer' table, which satisfies the condition - Country is 'UK'
SELECT agent_code,agent_name,working_area,commission
FROM  agents
WHERE agent_code=ANY(
SELECT agent_code FROM customer
WHERE cust_country='UK');

### Example ANY - 2 -
/*'agent_code' should be any 'agent_code' from 'customer' table, which satisfies the condition bellow :
  a) 'agent_code' should be any 'agent_code' from 'orders' table, which satisfies the condition bellow :
    i) 'advance_amount' of 'orders' table must be more than 600
*/ 
SELECT agent_code,agent_name,working_area,commission
FROM  agents
WHERE agent_code=ANY(
SELECT agent_code FROM customer
WHERE agent_code =ANY
(SELECT agent_code FROM orders
WHERE  advance_amount>600));

### Example ANY - 3 -
 /* 'advance_amount' of 'orders' table must be more than 600,
2. 'agent_code' should be any 'agent_code' from 'customer' table, which satisfies the condition bellow :
 a) 'agent_code' should be any 'agent_code' from 'agents' table, which satisfies the condition bellow :
   i) 'commission' of 'agents' table must be more than or equal to .12,
3. 'agent_code' in 'orders' table must be in a group,
*/
SELECT DISTINCT(agent_code),advance_amount
FROM orders
WHERE advance_amount>600
AND agent_code=ANY(
SELECT agent_code
FROM customer
WHERE agent_code=ANY(
SELECT agent_code FROM agents
WHERE commission>=.12
GROUP BY agent_code));


## Example : 5 MySQL subquery in the FROM clause
/* When you use a subquery in the FROM clause, the result set returned from a subquery is used as a temporary table. 
   This table is referred to as a derived table or materialized subquery.

Ex: Subquery finds the maximum, minimum, and average number of items in sale orders:
*/

SELECT MAX(items), MIN(items), FLOOR(AVG(items)) FROM
    (SELECT  orderNumber, COUNT(orderNumber) AS items
    FROM orderdetails GROUP BY orderNumber) AS lineitems;
    
-- -------------------------------------------------------   

##### EXISTS Operator  [EXISTS / NOT EXISTS ] 
/* The EXISTS checks the existence of a result of a Subquery. 
   The EXISTS subquery tests whether a subquery fetches at least one row. When no data is returned then this operator returns 'FALSE'.
   A valid EXISTS subquery must contain an outer reference and it must be a correlated Subquery.
   NOTE: The select list in the EXISTS subquery is not actually used in evaluating the EXISTS so it can contain any valid select list. 
   */
###### Example for EXISTS - 1
/* Select the dtails with the following conditiond
1. 'grade' in 'customer' table must be 3,
2. 'agent_code' in 'customer' and 'agents' table must match,
3. 'commission' of 'agents' should arrange in ascending order,
4. the above condition (1) and (2) should match at least one row,
*/
SELECT agent_code,agent_name,working_area,commission 
FROM agents
WHERE exists
(SELECT * FROM  customer
WHERE grade=3
AND agents.agent_code=customer.agent_code)
ORDER BY commission;

###### Example for EXISTS - 2
-- To display the employee details who are working in the country UK, we can use the following statement
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES E
WHERE EXISTS (SELECT 1
FROM DEPARTMENTS D, LOCATIONS L
WHERE D.LOCATION_ID = L.LOCATION_ID
AND D.DEPARTMENT_ID = E.DEPARTMENT_ID
AND L.COUNTRY_ID = 'UK');

###### Example for EXISTS - 3
-- Main query is executed when 
/* 1. 'grade' in 'customer' table must be 2,
2. more than 2 agents are present in grade 2,
3. 'grade' in customer table should make a group,
*/
SELECT cust_code,cust_name,cust_city,grade
FROM customer
WHERE grade=2 AND
EXISTS(
SELECT COUNT(*) FROM customer
WHERE grade=2
GROUP BY grade
HAVING COUNT(*)>2);


## Example : 6 (MySQL correlated subquery)
/* In the previous examples, you notice that a subquery is independent. 
 It means that you can execute the subquery as a standalone query.
 Unlike a standalone subquery, a correlated subquery is a subquery that uses the data from the outer query.
 In other words, a correlated subquery depends on the outer query.
Correlated subqueries are used for row-by-row processing
 In correlated subquery, the subquery is executed once for each row in the outer query.
 
 # Example:
   Example uses a correlated subquery to select products whose buy prices are greater than 
   the average buy price of all products in each product line.
*/

/* 
Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row of the outer query.
A correlated subquery is evaluated once for each row processed by the parent statement. The parent statement can be a SELECT, UPDATE, or DELETE statement.

#### SYNTAX:: 
SELECT column1, column2, ....
FROM table1 outer
WHERE column1 operator
                    (SELECT column1, column2
                     FROM table2
                     WHERE expr1 = 
                               outer.expr2);
                               

NOTE:: 
A correlated subquery is one way of reading every row in a table and comparing values in each row against related data. 
It is used whenever a subquery must return a different result or set of results for each candidate row considered by the main query. 
In other words,
you can use a correlated subquery to answer a multipart question whose answer depends on the value in each row processed by the parent statement. 

Nested Subqueries Versus Correlated Subqueries :
With a normal nested subquery, the inner SELECT query runs first and executes once, returning values to be used by the main query.
 A correlated subquery, however, executes once for each candidate row considered by the outer query. In other words, the inner query is driven by the outer query.

NOTE: You can also use the ANY and ALL operator in a correlated subquery. 
*/

##### EXAMPLE of Correlated Subqueries : Find all the employees who earn more than the average salary in their department.
SELECT last_name, salary, department_id
	FROM employees e1 WHERE salary >
						(SELECT AVG(salary)
						 FROM employees
						 WHERE department_id =
								e1.department_id group by department_id);



##### Other use of correlation is in UPDATE and DELETE
## CORRELATED UPDATE : --- Use a correlated subquery to update rows in one table based on rows from another table
/*
UPDATE table1 alias1
 SET column = (SELECT expression 
               FROM table2 alias2
               WHERE alias1.column =
                     alias2.column); 
*/
                     
##### Use a correlated subquery to delete rows in one table based on the rows from another table.
### CORRELATED DELETE :
/* 
DELETE FROM table1 alias1
 WHERE column1 operator
               (SELECT expression
                FROM table2 alias2
                WHERE alias1.column = alias2.column); 
*/

 

###### Using the EXISTS Operator :
## The EXISTS operator tests for existence of rows in the results set of the subquery. 
-- If a subquery row value is found the condition is flagged TRUE and the search does not continue in the inner query, 
-- and if it is not found then the condition is flagged FALSE and the search continues in the inner query.
## EXAMPLE of using EXIST operator :
## Find employees who have at least one person reporting to them.
 
/* SELECT employee_id, last_name, job_id, department_id
FROM employees outer
WHERE EXISTS ( SELECT ’X’
FROM employees
WHERE manager_id =
outer.employee_id); */

## EXAMPLE of using NOT EXIST operator :
-- Find all departments that do not have any employees.
/*
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (SELECT ’X’
FROM employees
WHERE department_id
= d.department_id); */


## Ex : 6.1
SELECT 
    customerNumber,
    ROUND(SUM(quantityOrdered * priceEach)) sales,
    (CASE
        WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
        WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
        WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
    END) customerGroup
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
WHERE
    YEAR(shippedDate) = 2003
GROUP BY customerNumber;


## Ex : 6.2
SELECT 
    customerGroup, 
    COUNT(cg.customerGroup) AS groupCount
FROM
    (SELECT 
        customerNumber,
            ROUND(SUM(quantityOrdered * priceEach)) sales,
            (CASE
                WHEN SUM(quantityOrdered * priceEach) < 10000 THEN 'Silver'
                WHEN SUM(quantityOrdered * priceEach) BETWEEN 10000 AND 100000 THEN 'Gold'
                WHEN SUM(quantityOrdered * priceEach) > 100000 THEN 'Platinum'
            END) customerGroup
    FROM
        orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY customerNumber) cg
GROUP BY cg.customerGroup;    

-- ---------------------------------------------------------------------


## Example : 7   (MySQL subquery with EXISTS and NOT EXISTS)
/* When a subquery is used with the EXISTS or NOT EXISTS operator,
   a subquery returns a Boolean value of TRUE or FALSE. 
   The following query illustrates a subquery used with the EXISTS operator:

SELECT  *  FROM  table_name WHERE  EXISTS ( subquery );

NOTE : If the subquery returns any rows, EXISTS subquery returns TRUE, otherwise, it returns FALSE.
       The EXISTS and NOT EXISTS are often used in the correlated subqueries. 
   */
   
## EXample : Query finds sales orders whose total values are greater than 60K.
SELECT 
    orderNumber, 
    SUM(priceEach * quantityOrdered) total
FROM
    orderdetails
        INNER JOIN
    orders USING (orderNumber)
GROUP BY orderNumber
HAVING SUM(priceEach * quantityOrdered) > 60000;
  

## Example : 
/* You can use the query above as a correlated subquery to find customers who placed at least 
one sales order with the total value greater than 60K by using the EXISTS operator:
*/
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( SELECT 
            orderNumber, SUM(priceEach * quantityOrdered)
        FROM
            orderdetails
                INNER JOIN
            orders USING (orderNumber)
        WHERE
            customerNumber = customers.customerNumber
        GROUP BY orderNumber
        HAVING SUM(priceEach * quantityOrdered) > 60000);
      
## Ex : Uses the EXISTS operator to find the customer who has at least one order:

SELECT customerNumber, customerName FROM  customers
WHERE  EXISTS 
    ( SELECT  1 FROM  orders  WHERE orders.customernumber  = customers.customernumber);

## Ex : Uses the NOT EXISTS operator to find customers who do not have any orders:
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    NOT EXISTS( 
	SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber
	);
    
## Ex : MySQL UPDATE EXISTS examples
-- This example adds the number 1 to the phone extension of employees who work at the office in San Francisco:
UPDATE employees 
SET 
    extension = CONCAT(extension, '1')
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            offices
        WHERE
            city = 'San Francisco'
                AND offices.officeCode = employees.officeCode);
	

## EX : MySQL INSERT EXISTS example
/* To archive customers who don’t have any sales order in a separate table.  */
  
 -- 1. Create a new table for archiving the customers by copying the structure from the customers table:

CREATE TABLE customers_archive  LIKE customers;

-- 2. Insert customers who do not have any sales order into the customers_archive table using the following INSERT statement.

INSERT INTO customers_archive
SELECT * 
FROM customers
WHERE NOT EXISTS( 
   SELECT 1
   FROM
       orders
   WHERE
       orders.customernumber = customers.customernumber
);

-- 3. Query data from the customers_archive table to verify the insert operation.

SELECT * FROM customers_archive;

-- ---------------------------------

## Ex : MySQL DELETE EXISTS example
/* Archiving the customer data is to delete the customers that exist in the customers_archive table from the customers table.
To do this, you use the EXISTS operator in WHERE clause of the DELETE statement as follows:
*/

DELETE FROM customers
WHERE EXISTS( SELECT 1 FROM  customers_archive a  WHERE a.customernumber = customers.customerNumber);

### MySQL EXISTS operator vs. IN operator
/* To find the customer who has placed at least one order, 
 you can use the IN operator as shown in the following query:
*/

SELECT customerNumber, customerName FROM customers
WHERE customerNumber IN (  SELECT  customerNumber  FROM  orders);

-- Compare the query that uses the IN operator with the one that uses the EXISTS operator by using the EXPLAIN statement.

EXPLAIN SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber);

-- --------------------------------------------
    
    
        


       