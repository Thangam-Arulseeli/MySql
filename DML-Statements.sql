-- ### ---- MySQL DML Statements -------------
-- -------- ######## INSERT Statements ###########
/*
Syntax:1   -- Single record
	INSERT INTO table(c1,c2,...)
	VALUES (v1,v2,...);

Syntax:2   -- Multiple records
	INSERT INTO table(c1,c2,...)
	VALUES 
	   (v11,v12,...),
	   (v21,v22,...),
		...
	   (vnn,vn2,...);
  
  Syntax:3   -- Inserting data to all the columns of the record
	INSERT INTO table
	VALUES (v1,v2,...);
  
  Syntax: 4  -- Insert based on existing table data
	  INSERT INTO table(c1,c2,...)
		SELECT (c1,c2,...) FROM existing-table-name [optioal condition];
   */
-- ---------------------------------------------------------------------------------
   
-- use MyDataBase;
use clssicmodels;
create table IF NOT EXISTS Employee (  
EmpID int,
EmpName varchar(30),
Department varchar(20),
Designation varchar(20),
salary float);

DESCRIBE Employee;   /* To display the structure of the table */ 


insert into Employee values(1,'Hepsibha','HR','Manager',34000); -- Insert single row
insert into Employee values
(2,'Hamilton','Tech','Developer',23000),
(3,'Peter','HR','Asst',23000),
(4,'George','Tech','Designer',18000),
(5,'Helen','Tech','Tester',13000);  -- Insert multiple rows

select * from Employee;
      

-- ***** Inserting the values to the table
-- 1. Insert only one record
 INSERT INTO Employee VALUES (1001, 'Vasanth', 'IT', '05-20-2023', 'Developer', 2.5); 
-- 2. Insert multiple records
 INSERT INTO Employee VALUES (1002, 'Hari Karthick', 'Tech', '05-25-2020', 'Developer', 2.5) ,(1003, 'Vickram', 'Tech', '05-25-2020', 'Developer', 4); 
-- 3. Insert only the specific fields
 INSERT INTO Employee(Empcode,Empname,department,doj) VALUES (1004, 'Sharon David', 'Tech', '04-20-2024'); 
 
 INSERT INTO Employee VALUES (1011, 'Karthikayan', 'IT', '05-20-2023', 'Developer', 2.5); 

-- ----------------------------------------------------------
-- CREATE THE TABLE AND POPULATE THE TABLE ROWS BASED ON THE EXISING TABLE
-- select into (CopyOfEmployee will be created automatically)
SELECT * INTO CopyOfEmployee FROM Employee;   -- Where clause can also be included

SELECT * FROM CopyOfEmployee;
-- -----------------------------------------------
-- 4. Insert records from the existing table
INSERT INTO COPYOFEMPLOYEE SELECT * FROM EMPLOYEE WHERE SALARY > 20000;
SELECT * FROM CopyOfEmployee;

INSERT INTO COPYOFEMPLOYEE(EmpCode, EmpName, Department, Salary ) SELECT Empcode, empname, Department, Salary FROM Employee WHERE Experience=4;

-- --------------------------------------------------------------------------------
   -- Examples :
   USE sample;
   CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
);
INSERT INTO tasks(title,priority)
VALUES('Learn MySQL INSERT Statement',1);

SELECT * FROM tasks;

-- NOTE:
-- The task_id column is an AUTO_INCREMENT column. It means that MySQL generates a sequential integer whenever a row is inserted into the table.
-- The start_date, due_date, and description columns use NULL as the default value, therefore, MySQL uses NULL to insert into these columns if you don’t specify their values in the INSERT statement.
   
-- ##### MySQL INSERT – DEFAULT value example --- 
  -- There are 2 ways to insert DEFAULT values
  --  WAY - 1  :   Ignore both the column name and value in the INSERT statement.
  --  WAY - 2  :   Specify the column name in the INSERT INTO clause and use the DEFAULT keyword in the VALUES clause.
  
-- ### Examples
-- WAY -1   -- Default value specified to the column while creation of the record is inserted when we omit it
INSERT INTO tasks(title)
VALUES('Keeping DEFAULT value wihout giving new value');
-- WAY -2   -- Specifying DEFAULT keyword
INSERT INTO tasks(title,priority)
VALUES('Understanding DEFAULT keyword in INSERT statement',DEFAULT);

-- ### select statement returns the contents of the tasks table after the insert:
SELECT * FROM tasks;

-- -----------------------------------------------
-- ### MySQL INSERT – DATE value insertion  ### ------------- 

/* To insert a literal date value into a column, you use the following format:
     'YYYY-MM-DD'
     
In this format:
YYYY represents a four-digit year e.g., 2018.
MM represents a two-digit month e.g., 01, 02, and 12.
DD represents a two-digit day e.g., 01, 02, 30, 31
*/

INSERT INTO tasks(title, start_date, due_date)
VALUES('Insert date into table','2018-01-09','2018-09-15');

-- MySQL INSERT DATES  into table[use expressions in the VALUES clause]
 INSERT INTO tasks(title,start_date,due_date)
VALUES('Use current date for the task',CURRENT_DATE(),CURRENT_DATE());
-- Note: CURRENT_DATE() function is a date function that returns the current system date.

select * from tasks;
-- --------------------------

-- ### MySQL INSERT – Inserting multiple rows example #### ------
INSERT INTO tasks(title, priority)
VALUES
	('My first task', 1),
	('It is the second task',2),
	('This is the third task of the week',3);

SELECT * FROM tasks;

-- #########  Restrictions in inserting Multiple Rows ### ---------------
/* NOTE:-
MySQL server receives the INSERT statement whose size is bigger than max_allowed_packet, 
it will issue a packet too large error and terminates the connection.
This statement shows the current value of the max_allowed_packet variable:
*/

SHOW VARIABLES LIKE 'max_allowed_packet';
-- OUTPUT--
-- max_allowed_packet --- 4,194,304

-- # Point to Remember # Here is the output on our MySQL database server. Note that the value in your server may be different.

/*
The number is the Value column, which is the number of bytes.
To set a new value for the max_allowed_packet variable, you use the following statement:
*/

SET GLOBAL max_allowed_packet=size; -- where size in bytes is an integer that represents the number the maximum allowed packet size.

/* Note that the max_allowed_packet has no influence on the INSERT INTO .. SELECT statement. 
 INSERT INTO .. SELECT statement can insert as many rows as you want. */

-- -----------------------------------------------------------------------------------------------

-- ### MySQL INSERT multiple rows example

CREATE TABLE projects(
	project_id INT AUTO_INCREMENT, 
	name VARCHAR(100) NOT NULL,
	start_date DATE,
	end_date DATE,
	PRIMARY KEY(project_id)
);

INSERT INTO  Projects(name, start_date, end_date)
VALUES 	('AI for Marketing','2019-08-01','2019-12-31'),
	    ('ML for Sales','2019-05-15','2019-11-20');

/* ### Note:- 
  when you insert multiple rows and use the LAST_INSERT_ID() function to get the last inserted id of an AUTO_INCREMENT column, 
  you will get the id of the first inserted row only, not the id of the last inserted row.
  */
  
SELECT * FROM projects;
SELECT last_insert_id();
------------------------------------------------------------------------------

-- ####### INSERT INTO SELECT clause
/* Instead of using the VALUES clause, you can use a SELECT statement. 
    The SELECT statement can retrieve data from one or more tables.
    INSERT INTO SELECT statement is very useful when you want to copy data from other tables to a table 
    or to summary data from multiple tables into a table.

-- Syntax ---
INSERT INTO table_name(column_list)
SELECT select_list FROM another_table WHERE condition;
*/

-- ### Examples: ----
  
-- ### Using SELECT statement in the VALUES list ---- 

CREATE TABLE stats (
    totalProduct INT,
    totalCustomer INT,
    totalOrder INT
);

-- Instead of keeping the values in the values clause select with aggregate function is used........
INSERT INTO stats(totalProduct, totalCustomer, totalOrder)
VALUES(
	(SELECT COUNT(*) FROM products),
	(SELECT COUNT(*) FROM customers),
	(SELECT COUNT(*) FROM orders)
);

SELECT * FROM stats;

-- -------------------------------------------------------------------------------

-- ### MySQL INSERT IGNORE statement [ When we insert multiple rows in insert] ---
/* NOTE :-
When you use the INSERT statement to add multiple rows to a table and if an error occurs during the processing, 
MySQL terminates the statement and returns an error. As the result, no rows are inserted into the table.

However, if you use the INSERT IGNORE statement, the rows with invalid data that cause the error are ignored
 and the rows with valid data are inserted into the table.
 
 Note that the IGNORE clause is an extension of MySQL to the SQL standard.


-- ### Syntax of INSERT IGNORE statement --

INSERT IGNORE INTO table(column_list)
VALUES( value_list),
      ( value_list),
      ...
*/

-- MySQL INSERT IGNORE example

CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE
);

-- The UNIQUE constraint ensures that no duplicate email exists in the email column.

INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com');  -- Works

INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');  -- Error
-- Error Code: 1062. Duplicate entry 'john.doe@gmail.com' for key 'email'

select * from subscribers;

-- However, if you use the INSERT IGNORE statement instead.
INSERT IGNORE INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');
-- Note: MySQL returned a message indicating that one row was inserted and the other row was ignored.
-- 1 row(s) affected, 1 warning(s): 1062 Duplicate entry 'john.doe@gmail.com' for key 'email' Records: 2  Duplicates: 1  Warnings: 1
-- To find the detail of the warning, you can use the SHOW WARNINGS command as shown below:
SHOW WARNINGS;

-- MySQL INSERT IGNORE - warning
-- In conclusion, when you use the INSERT IGNORE statement, instead of issuing an error, MySQL issued a warning in case an error occurs.

/* MySQL INSERT IGNORE and STRICT mode
When the strict mode is on, MySQL returns an error and aborts the INSERT statement if you try to insert invalid values into a table.

However, if you use the INSERT IGNORE statement, MySQL will issue a warning instead of an error. 
In addition, it will try to adjust the values to make them valid before adding the value to the table.
*/

-- EXAMPLE -- 
-- First, we create a new table named tokens:
CREATE TABLE tokens (
    names VARCHAR(6)
);

-- Second, insert a string whose length is seven into the tokens table.

-- INSERT  INTO tokens VALUES('abcdefg');
-- INSERT WITH STRICT SQL MODE INTO tokens VALUES('abcdefg');  -- Not Working

-- MySQL issued the following error because the strict mode is on.
-- Error Code: 1406. Data too long for column 'names' at row 1
-- Third, use the INSERT IGNORE statement to insert the same string.

INSERT IGNORE INTO tokens VALUES('abcdefg');
INSERT IGNORE INTO tokens VALUES('aaaa'),('bbbbbbb'),('ccccccccc'),('dddddd');
-- MySQL truncated data before inserting it into the tokens table. In addition, it issues a warning.

-- ------------------------------------------------------------------------------------------------------
-- ###### UPDATE statement ----------------------------
-- UPDATE statement updates / change the values in one or more columns of a single row or multiple rows.

-- Basic syntax of the UPDATE statement
/* UPDATE [LOW_PRIORITY] [IGNORE] table_name 
SET 
    column_name1 = expr1,
    column_name2 = expr2,
    ...
[WHERE
    condition];
*/

/* NOTE:-
The LOW_PRIORITY modifier instructs the UPDATE statement to delay the update until there is no connection reading data from the table.
The LOW_PRIORITY takes effect for the storage engines that use table-level locking only such as MyISAM, MERGE, and MEMORY.
The IGNORE modifier enables the UPDATE statement to continue updating rows even if errors occurred. 
The rows that cause errors such as duplicate-key conflicts are not updated.
*/

-- MySQL UPDATE examples
SELECT firstname, lastname, email FROM employees WHERE employeeNumber = 1056;
UPDATE employees SET email = 'mary.patterson@classicmodelcars.com' WHERE employeeNumber = 1056; -- Updates single column
SELECT firstname, lastname, email FROM employees WHERE employeeNumber = 1056;
UPDATE employees SET lastname = 'Hill', email = 'mary.hill@classicmodelcars.com' WHERE employeeNumber = 1056; -- Updates multiple columns

-- --------------------------------------------------------------------------------------------------
# *****Updating the table data/columns

UPDATE employee SET designation='Testing', experience=1 WHERE empcode=1004;
UPDATE employee SET designation='Testing', experience=experience*2 WHERE empcode=1004;
UPDATE employee SET designation=designation+',Testing', experience=experience*2 WHERE empcode=1011;

SELECT * from employee;
------------------------------------------------------------------------------
## *****Deleting the record  -- specific record / entire records if no where clause
 DELETE FROM employee WHERE empcode=101;
 DELETE FROM employee WHERE empname='Malathi';
 DELETE FROM employee;    ---- To delete entire records from the table

 SELECT * FROM employee;
-- --------------------------------------------------------------------------

## *****Truncate command used  to delete the entire recoed from the table
## WHERE condition cannot be used with TRUNCATE command
## Allocated Memory (Storage) is released wen we use it
## Table only contains structure

TRUNCATE EMPLOYEE;

-- --------------------------------------------------------------------------
USE MyDataBase;

## ***** SELECT (DQL) statement
 SELECT * FROM employee;    -- Select all records with all columns in each record
 SELECT empcode,empname,department FROM employee;   -- Select only the specific columns
 SELECT empcode, empname, department, salary, salary*.5 BONUS FROM Employee;  -- Computed column / Dummy column
 --  Concatenated Column values with alias -- COLUMN ALIAS 
 SELECT empcode AS ECODE , 'Mr./ Ms. ' + empname AS 'Employee Name', department, salary, salary*.5 BONUS FROM Employee; 
 SELECT empcode, 'Mr./ Ms. ' + empname 'Employee Name', department, salary, salary*.5 BONUS FROM Employee; 
 SELECT * INTO employeebackup from employee where ecode<3;    -- employeebackup table is created and populated with 2 rows

 -- *** USING ALIAS NAMES TO THE COLUMNS
  SELECT CustomerName, CONCAT(Address,', ',PostalCode,', ',City,', ',Country) AS Address FROM Customers;  -- Alias name in MySQL
-- SELECT CustomerName, (Address || ', ' || PostalCode || ' ' || City || ', ' || Country) AS Address FROM Customers;  -- Alias name in Oracle
-- *** ALIAS NAMES TO THE TABLES
 SELECT o.OrderID, o.OrderDate, c.CustomerName FROM Customers AS c, Orders AS o WHERE c.CustomerName='Aron Antony' AND c.CustomerID=o.CustomerID;
 SELECT o.OrderID, o.OrderDate, c.CustomerName FROM Customers, Orders  WHERE Customers.CustomerName='Aron Antony' AND Customers.CustomerID=Orders.CustomerID;  -- Without alias
 SELECT ecode,empname,experience 'In-HOUSE', experience+3 'Total Experience' FROM employee;  -- Including compluted column in SELECT statement
 SELECT ecode,empname,experience AS 'In-HOUSE', experience+3 AS 'Total Experience' FROM employee;    -- Including compluted column in the query

-- *** DISTINCT
 SELECT DISTINCT designation FROM Employee;  -- Distinct with 1 columns
 SELECT DISTINCT department,designation FROM employee;  -- Distinct with 2 columns
 
 -- ***FILTER THE RECORDS [WHERE clause]
SELECT * FROM employee WHERE experience>=2.5;
SELECT * FROM employee WHERE salary<20000;
SELECT * FROM employee WHERE salary>20000 and experience>3;
SELECT * FROM employee WHERE EmpName='Sharon';
SELECT * FROM employee WHERE EmpName!='Yamini';

SELECT * FROM employee WHERE Experience=2.5 OR EmpName='Harishmita';
SELECT * FROM employee WHERE Experience=2.5 AND EmpName='Harita';

SELECT * FROM employee WHERE Experience=2.5 or Experience=2;
SELECT * FROM employee WHERE Experience IN (2.5, 2);
SELECT * FROM employee WHERE Experience NOT IN (2.5, 2);
SELECT * FROM employee WHERE Designation='Developer' OR Designation='Testing';
SELECT * FROM employee WHERE Designation IN ('Developer','Testing');
SELECT * FROM employee WHERE Designation NOT IN ('Developer','Testing');

SELECT * FROM employee WHERE Experience >=2 AND Experience<=4;
SELECT * FROM employee WHERE Experience BETWEEN 2 AND 4 ;    --  2 and 4 values are inclusive
SELECT * FROM employee WHERE Experience NOT BETWEEN 2 AND 4;

SELECT * FROM employee WHERE Designation=NULL;
SELECT * FROM employee WHERE Designation IS NULL;
SELECT * FROM employee WHERE Designation IS NOT NULL;
SELECT * FROM employee WHERE Designation IS NULL;

SELECT * FROM employee WHERE EmpName LIKE 'Harita';
SELECT * FROM employee WHERE EmpName NOT LIKE 'Sharon';
SELECT * FROM employee WHERE EmpName  LIKE 'V%';
SELECT * FROM employee WHERE EmpName  LIKE 'Raj_';      --  EmpName like Raji, Raja, Raj1, Raj2 etc can be selected
SELECT * FROM employee WHERE EmpName  LIKE 'Raj[1-5]';   -- Raj1 to Raj5 can be selected
SELECT * FROM employee WHERE EmpName  LIKE 'Raj[^1-5]';   -- EmpName is other than Raj1 to Raj5 are selected
SELECT * FROM employee WHERE EmpName  LIKE 'Raj[a,i,u,1,2]';  -- Select  EmpName like Raji, Raja, Raju, Raj1 and Raj2
SELECT * FROM employee WHERE EmpName  LIKE 'Raj[^a,i,u,1,2]';  -- Select  EmpName not like Raji, Raja, Raju, Raj1 and Raj2
SELECT * FROM employee WHERE EmpName  NOT LIKE 'Raj[a,i,u,1,2]';   -- Select  EmpName not like Raji, Raja, Raju, Raj1 and Raj2
SELECT * FROM employee WHERE EmpName  LIKE '[ADJ]%';   -- Name starts with A, D and J are displayed
SELECT * FROM employee WHERE EmpName  NOT LIKE '[A-M]%';  -- Name starts from A-M are displayed
SELECT * FROM Employee WHERE SOUNDEX(EMPNAME)=SOUNDEX('Tharsan');   -- GETS THE RECORD WHEN SOUND IS SIMILAR

-- -------------------------------------------------------------------------------------------------

-- SELECT TOP 3 * FROM employee;  -- Select top 2 rows from the table (SQL SERVER/MS ACCESS/ORACLE) [Use WHERE clause also with top]
-- SELECT TOP 3 WITH TIES empname,salary FROM Employee ORDER BY salary DESC; -- Displays all records that matches the last resultant value apart from top 3 records
 SELECT * FROM employees LIMIT 3;  -- Select top 3 rows from the table (MySQL)  
 SELECT * FROM employees LIMIT 0,5;  -- Select first 5 rows
 SELECT * FROM employees LIMIT 6,3;   -- Skips first 6 rows and display next 3 rows 
 SELECT * FROM employees ORDER BY empname LIMIT 5;  --  Displays first 5 
 SELECT * FROM employees ORDER BY empname LIMIT 0, 5;  -- Displays first 5
 SELECT * FROM  employee ORDER BY empname LIMIT 5 OFFSET 2;   -- Skips first 2 and displays next 5 records (OFFSET means Skips) 
SELECT * FROM employees LIMIT 2, 5;   -- (Same as previous select query)

## LIMIT WITH ORDER BY Clause
SELECT * FROM employee ORDER BY salary LIMIT 3;  -- Select top 3 rows from the table (MySQL)  
 SELECT * FROM employee ORDER BY ecdode LIMIT 0,5;  -- Select first 5 rows
 SELECT * FROM employee ORDER BY empname LIMIT 6,3;   -- Skips first 6 rows and display next 3 rows 

/* Third highest salary from the employee table */
 select distinct salary from employee order by salary desc limit 2 , 1 ;     -- Way 1  (3rd highest salary)
 
 select salary  from employee where salary <ALL (select max(salary) from employee    
		where salary <ALL (select max(salary) from employee)) limit 1 ;       -- Way 2 (3rd highest salary)
        
-- SELECT * FROM Employee FETCH FIRST 3 ROWS ONLY; -- Select first 3 rows (ORACLE)
-- SELECT TOP 10 PERCENT * FROM Employee;  -- Select top 10% records from employes table (SQL SERVER/MS ACCESS) [Use WHERE clause also with top]
-- SELECT * FROM Customers FETCH FIRST 10 PERCENT ROWS ONLY;  --  Select top 10% records from employes table (ORACLE)

-- ***ORDER BY clause
 SELECT * FROM employee ORDER BY experience; -- [ASC/DESC] -- ASC is default, must specify DESC for descending order
 SELECT  * FROM  employee ORDER BY experience DESC, designation ASC;  -- Order by with multiple column
 -- SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name; -- Orderby without offset(Skipping)
 ### CAUTION ### No Offset In MYSQL ----------------
 --  SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS;  -- Skips first 10 rows and gets all other records
 -- SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY; -- Skips first 10 rows and fetches next 10 rows only
 -- SELECT product_name, list_price FROM production.products ORDER BY list_price DESC, product_name  OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY; -- Fetches top 10 most expensive product
 

-- --------------------------------------------------------------------------

##### MySQL Natural Sorting (ORDER BY)

## STEP - 1   -- Create a new table named items by using the following  CREATE TABLE statement:
CREATE TABLE items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_no VARCHAR(255) NOT NULL
);

## STEP- 2 -- Insert some rows into the items table:
INSERT INTO items(item_no)
VALUES ('1'), ('17C'), ('10Z'), ('2A'), ('25A'), ('3C'), ('20D');


## STEP- 3 -- Query data from the items table sorted by the item_no:
SELECT item_no FROM items ORDER BY item_no;    -- Unexpected result will come

## STEP- 4 --  We use the ORDER BY clause to sort the rows numerically first and alphabetically then.
SELECT item_no FROM items 
ORDER BY CAST(item_no AS UNSIGNED) , item_no;   -- Required result

## STEP-5
TRUNCATE TABLE items;

## STEP- 6
INSERT INTO items(item_no)
VALUES('A-1'), ('A-2'), ('A-3'), ('A-4'), ('A-5'),
      ('A-10'), ('A-11'), ('A-20'), ('A-30');

## STEP- 7
-- sort the item_no data by length first and then by column value
SELECT item_no FROM items ORDER BY LENGTH(item_no) , item_no;

-- ---------------------------------------------------------------------------
##### MySQL GROUP BY clause (set of summary rows by values of columns or expressions)
-- GROUP BY clause returns one row for each group and it reduces the number of rows in the result set.

## Examples
SELECT department FROM employees GROUP BY department;      --  Works like DISTINCT operator
SELECT DISTINCT department FROM employees; 			--  Works like DISTINCT operator

/*
NOTE: DISTINCT clause is a special case of the GROUP BY clause.
      GROUP BY clause sorts the result set, whereas the DISTINCT clause does not.

	Without using aggregate functions, the GROUP BY clause behaves like the DISTINCT clause.
    
###### Aggregate functions
COUNT(*), COUNT(column-name), MAX(), MIN(), SUM(), AVG() 

 -- COUNT(*) counts NULL values in the ROWS also 
 -- COUNT(column-name) counts only the specific values 
*/
SELECT DISTINCT department FROM employees ORDER BY employees;

SELECT department, COUNT(*) FROM employees ;
-- GROUP BY department;  

SELECT department, COUNT(*) FROM employees 
GROUP BY department;                           

SELECT department, SUM(salary * 10/100) AS 'Total Bonus'
FROM employees 
GROUP BY department;

-- -------------------------------------------------------------------------- 
/*
-- Inner Join with USING clause
-- Example-1
SELECT status, SUM(quantityOrdered * priceEach) AS amount
FROM orders INNER JOIN orderdetails USING (orderNumber)
GROUP BY status;

-- Example-2
SELECT YEAR(orderDate) AS year, SUM(quantityOrdered * priceEach) AS total
FROM orders INNER JOIN orderdetails USING (orderNumber)
WHERE status = 'Shipped' GROUP BY YEAR(orderDate);
*/
-- --------------------------------------------------------------------

##### GROUP BY with HAVING clause example
/* To filter the groups returned by GROUP BY clause, you use HAVING clause. 
NOTE: If you omit the GROUP BY clause, the HAVING clause behaves like the WHERE clause.
COUNT(), COUNT(*), SUM(), AVG(), MAX(), MIN()
*/
-- EXAMPLE 1.1:
SELECT department, SUM(wage) 
FROM employees
GROUP BY department
HAVING department = "Tech Writer";

-- EXAMPLE 1.2:
SELECT department, count(empid), sum(salary) AS 'Total Salary'
FROM employee WHERE age > 50 
GROUP BY department HAVING Department IN ( 'HR','Marketing');

 -- EXAMPLE 2:
SELECT department, count(empid), sum(salary) AS 'Total Salary'
FROM employee WHERE age > 50 
GROUP BY department HAVING COUNT(*) >= 3;

-- EXAMPLE 3:
SELECT ordernumber, SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS total
FROM orderdetails 
GROUP BY  ordernumber HAVING total > 1000;

-- -----------------------------------------------------------------------------

###### MySQL ROLLUP clause (To generate subtotals and grand totals.)
-- Example -1
CREATE TABLE sales
SELECT productLine, YEAR(orderDate) orderYear,
    SUM(quantityOrdered * priceEach) orderValue
FROM orderDetails
        INNER JOIN orders USING (orderNumber)
        INNER JOIN products USING (productCode)
 GROUP BY productLine , YEAR(orderDate);

-- Example -2
SELECT productline, SUM(orderValue) totalOrderValue
FROM sales GROUP BY productline;

-- Example -3
SELECT SUM(orderValue) totalOrderValue FROM sales;

-- Example -4
SELECT productline, SUM(orderValue) totalOrderValue
FROM sales GROUP BY productline 
UNION ALL
SELECT NULL, SUM(orderValue) totalOrderValue
 FROM sales;

-- Example -5
-- The ROLLUP generates the subtotal row every time the product line changes and the grand total at the end of the result.
-- The hierarchy in this case is:
-- productLine > orderYear
SELECT productLine, SUM(orderValue) totalOrderValue
FROM sales 
GROUP BY productline WITH ROLLUP;

-- Example -6
-- The ROLLUP generates the subtotal every time the year changes and the grand total at the end of the result set.
-- The hierarchy in this example is: orderYear > productLine
SELECT productLine, orderYear, SUM(orderValue) totalOrderValue
FROM sales GROUP BY productline, orderYear 
WITH ROLLUP;

-- ---------------------------------------------------------
##### GROUPING() function
/* To check whether NULL in the result set represents the subtotals or grand totals, you use the GROUPING() function.
The GROUPING() function returns 1 when NULL occurs in a super-aggregate row, otherwise, it returns 0.
The GROUPING() function can be used in the select list, HAVING clause, and (as of MySQL 8.0.12 ) ORDER BY clause.
*/

SELECT orderYear, productLine, SUM(orderValue) totalOrderValue,
    GROUPING(orderYear), GROUPING(productLine)
FROM sales GROUP BY orderYear, productline
WITH ROLLUP;

-- ----------------------------------------------------------------------------

-- MySQL allows Alias in GROUP BY clause whereas SQL standard not
SELECT YEAR(orderDate) AS year, SUM(quantityOrdered * priceEach) AS total
FROM orders INNER JOIN orderdetails USING (orderNumber)
WHERE status = 'Shipped' GROUP BY year 
HAVING year > 2003;

-- -----------------------------------------------------------------------------

##### REPLACE() function in UPDATE Statement
-- The following example updates the domain parts of emails of all Sales Reps with office code 6:
UPDATE employees SET email = REPLACE(email,'@classicmodelcars.com','@mysqltutorial.org')
WHERE jobTitle = 'Sales Rep' AND officeCode = 6;  -- UPDATES to replace string 
-- The REPLACE() function replaces @classicmodelcars.com in the email column with @mysqltutorial.org.

-- ### MySQL UPDATE to update rows returned by a SELECT statement example
SELECT customername, salesRepEmployeeNumber FROM customers WHERE salesRepEmployeeNumber IS NULL;

use classicmodels;
-- ## This query selects a random employee from the table employees whose job title is the Sales Rep
SELECT employeeNumber FROM employees WHERE jobtitle = 'Sales Rep' ORDER BY RAND() LIMIT 1;

UPDATE customers 
	SET alesRepEmployeeNumber = (SELECT employeeNumber FROM employees WHERE jobtitle = 'Sales Rep' ORDER BY RAND() LIMIT 1)
	WHERE salesRepEmployeeNumber IS NULL;
SELECT salesRepEmployeeNumber FROM customers WHERE salesRepEmployeeNumber IS NULL;


-- ##### ---- MySQL UPDATE JOIN statement to perform the cross-table update ---------------

/* You often use joins to query rows from a table that have (in the case of INNER JOIN) 
   or may not have (in the case of LEFT JOIN) matching rows in another table. 
   In MySQL, you can use the JOIN clauses in the UPDATE statement to perform the cross-table update.

---  Syntax of the MySQL UPDATE JOIN ---

UPDATE T1, T2,
[INNER JOIN | LEFT JOIN] T1 ON T1.C1 = T2.C1
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE condition

T1- Main table 
T2- The main table to join table 
The data in the table that is not specified after the UPDATE  clause will not be updated.
 The JOIN clause must appear right after the UPDATE clause. (either INNER JOIN  or LEFT JOIN  and a join predicate.)
Then, assign new values to the columns in T1 and/or T2 tables that you want to update.
After that, specify a condition in the WHERE clause to limit rows to rows for updating.

-- ### Another Syntax for MySQL update Join

UPDATE T1, T2
SET T1.c2 = T2.c2,
      T2.c3 = expr
WHERE T1.c1 = T2.c1 AND condition

-- ### This UPDATE  statement works the same as UPDATE JOIN  with an implicit INNER JOIN  clause.
 It means you can rewrite the above statement as follows:

UPDATE T1,T2
INNER JOIN T2 ON T1.C1 = T2.C1
SET T1.C2 = T2.C2,
      T2.C3 = expr
WHERE condition

-- #### Some examples of using the UPDATE JOIN  statement
-- The  employees table stores employee data with employee id, name, performance, and salary.
-- The merits table stores employee performance and merit’s percentage.
-- The following statements create and load data in the empdb sample database:

*/
CREATE DATABASE IF NOT EXISTS empdb;

USE empdb;

-- create tables
CREATE TABLE merits (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);

CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);
-- insert data for merits table
INSERT INTO merits(performance,percentage)
VALUES(1,0),
      (2,0.01),
      (3,0.03),
      (4,0.05),
      (5,0.08);
-- insert data for employees table
INSERT INTO employees(emp_name,performance,salary)      
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);

-- Suppose you want to adjust the salary of employees based on their performance.
-- The merit’s percentages are stored in the merits table, 
-- therefore, you have to use the UPDATE INNER JOIN statement to adjust the salary of employees in the employees table 
-- based on the percentage stored in the merits table.
-- The link between the employees  and merit tables is the performance  field. See the following query:      
UPDATE employees
        INNER JOIN
    merits ON employees.performance = merits.performance 
SET 
    salary = salary + salary * percentage;
    
-- ###---  MySQL UPDATE JOIN example with LEFT JOIN
-- Suppose the company hires two more employees:

INSERT INTO employees(emp_name,performance,salary)
VALUES('Jack William',NULL,43000),
      ('Ricky Bond',NULL,52000);
      
-- To increase the salary for new hires, you cannot use the UPDATE INNER JOIN  statement 
-- because their performance data is not available in the merit  table. This is why the UPDATE LEFT JOIN  comes to the rescue.
-- The UPDATE LEFT JOIN  statement basically updates a row in a table when it does not have a corresponding row in another table.
-- For example, you can increase the salary for a new hire by 1.5%  using the following statement:
UPDATE employees LEFT JOIN merits ON employees.performance = merits.performance 
	SET salary = salary + salary * 0.015 WHERE merits.percentage IS NULL;
    
-- ----------------------------------------------------------------------------------------

-- ### MySQL DELETE statement
-- To delete record / set of records /all records from a table, you use the MySQL DELETE statement. 

-- Syntax of the DELETE statement
/*
DELETE FROM table_name
WHERE condition;
*/

-- To delete data from multiple tables -- Use the DELETE JOIN statement
-- To delete all rows in a table without the need of knowing how many rows deleted, Use the TRUNCATE TABLE statement 
-- For a table that has a foreign key constraint, when you delete rows from the parent table,
	-- the rows in the child table will be deleted automatically by using the ON DELETE CASCADE option.

-- MySQL DELETE examples

DELETE FROM employees;    -- Deletes all the records
DELETE FROM employees WHERE officeCode = 4;   -- Deletes based on condition

/* DELETE FROM table_table LIMIT row_count;     -- Limits number of rows to delete
-- OR
DELETE FROM table_name ORDER BY c1, c2, ... LIMIT row_count; 
   */

DELETE FROM customers ORDER BY customerName LIMIT 10;  -- sorts customers by customer names alphabetically and deletes the first 10 customers:

DELETE FROM customers WHERE country = 'France'
ORDER BY CustomerName LIMIT 5;    -- sorts customers by customer names alphabetically whose country = 'France' and deletes the first 5 customers:

-- ----------------------------------------------------------------------------
-- ### ON DELETE CASCADE Example ( Parent (PKEY) - Child(FKEY) )

-- Suppose that we have two tables:buildings(building_no,building_name,address) and rooms(room_no,room_name,building_no) .
-- In this database model, each building has one or many rooms. However, each room belongs to one only one building.
-- A room would not exist without a building.
-- The relationship between the buildings and rooms tables is one-to-many (1:N) as illustrated in the following database diagram:
   
DELETE FROM buildings WHERE building_no = 2;

-- You also want the rows in the rooms table that refers to building number 2 will be also removed. -- But it is not.
-- For deleting the child table records when parent table records are deleted (PKEY and Foreign KEY is attached)
-- Do the following

-- Parent table (Bulidings)
CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Child table (Rooms)
CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

-- Insert values to parent table
INSERT INTO buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');      
SELECT * FROM buildings;

-- Insert records to child table
INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);   
SELECT * FROM rooms;

-- When parent table records are deleted, corresponding child table records are deleted
DELETE FROM buildings WHERE building_no = 2;
SELECT * FROM rooms;

/* #### NOTE:- 
Notice that ON DELETE CASCADE  works only with tables with the storage engines that support foreign keys e.g., InnoDB.
Some table types do not support foreign keys such as MyISAM 
so you should choose appropriate storage engines for the tables that
you plan to use the MySQL ON DELETE CASCADE  referential action.
*/

-- ##### to find tables affected by MySQL ON DELETE CASCADE action ---
/*
USE information_schema;

SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'database_name'
        AND referenced_table_name = 'parent_table'
        AND delete_rule = 'CASCADE'
*/

USE information_schema;
SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'classicmodels'
        AND referenced_table_name = 'buildings'
        AND delete_rule = 'CASCADE';

-- ---------------------------------------------------------------------------
-- ##### MySQL DELETE JOIN statement------------------------
-- [ More flexible way to delete data from multiple tables using INNER JOIN or LEFT JOIN clause with the DELETE statement]

-- MySQL DELETE JOIN with INNER JOIN
-- MySQL also allows you to use the INNER JOIN clause in the DELETE statement to delete rows from a table
-- and the matching rows in another table.

-- For example, to delete rows from both T1 and T2 tables that meet a specified condition, you use the following statement:
/* Syntax
DELETE T1, T2 FROM T1
INNER JOIN T2 ON T1.key = T2.key
WHERE condition;
*/

-- ## MySQL DELETE JOIN with INNER JOIN example
-- Suppose, we have two tables t1 and t2 with the following structures and data:

DROP TABLE IF EXISTS t1, t2;

CREATE TABLE t1 (
    id INT PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE t2 (
    id VARCHAR(20) PRIMARY KEY,
    ref INT NOT NULL
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2(id,ref) VALUES('A',1),('B',2),('C',3);
   
delete t1, t2 from t1 inner join t2 on t2.ref = t1.id where t1.id=1;

-- ### DELETE JOIN with LEFT JOIN ---- 
-- We often use the LEFT JOIN clause in the SELECT statement to find rows in the left table that have or don’t have matching rows in the right table.

-- We can also use the LEFT JOIN clause in the DELETE statement to delete rows in a table (left table) that does not have matching rows in another table (right table).

-- Syntax illustrates how to use DELETE statement with LEFT JOIN clause to delete rows from T1 table that does not have corresponding rows in the T2 table:

/* DELETE T1 FROM T1 
 LEFT JOIN T2 ON T1.key = T2.key 
    WHERE T2.key IS NULL; 
*/
  
-- Example 1
DELETE customers 
FROM customers
        LEFT JOIN
    orders ON customers.customerNumber = orders.customerNumber 
WHERE
    orderNumber IS NULL;
    
-- Example 2
SELECT 
    c.customerNumber, 
    c.customerName, 
    orderNumber
FROM
    customers c
        LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL;
    
-- -------------------------------------------------------------------------------
    
-- ########## MySQL REPLACE statement --------------------

/* The MySQL REPLACE statement is an extension to the SQL Standard. The MySQL REPLACE statement works as follows:

Step 1. Insert a new row into the table, if a duplicate key error occurs.

Step 2. If the insertion fails due to a duplicate-key error occurs:

Delete the conflicting row that causes the duplicate key error from the table.
Insert the new row into the table again.

-- SYNTAX:
REPLACE [INTO] table_name(column_list)
VALUES(value_list);

*/

####  Example::
CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cyname VARCHAR(50),
    population INT NOT NULL
);

INSERT INTO cities(cyname,population)
VALUES('New York',8008278),
	  ('Los Angeles',3694825),
	  ('San Diego',1223405);
   
SELECT * FROM cities;

REPLACE INTO cities(id,population) 
VALUES(2,3696820);   -- id=2 is replaced with new population values with cyname is null 


-- ### MySQL REPLACE statement to UPDATE A ROW  -------
/* The following illustrates how to use the REPLACE statement to update data: 
 -- SYNTAX
REPLACE INTO table
SET column1 = value1,
    column2 = value2; 

NOTE: This statement is like the UPDATE statement except for the REPLACE keyword and no WHERE clause.
*/

### Example:
REPLACE INTO cities
SET id = 4, name = 'Phoenix', population = 1768980 ; -- Use the REPLACE statement to update the population of the Phoenix city to 1768980:


-- #### REPLACE to insert data from a SELECT statement ------
/* The following illustrates the REPLACE statement that inserts data into a table with the data come from a query.

REPLACE INTO table_1(column_list)
SELECT column_list
FROM table_2
WHERE where_condition;

NOTE: Note that this form of the REPLACE statement is similar to INSERT INTO SELECT statement.
*/

### Example: -- The following statement uses the REPLACE INTO statement to copy a row within the same table:
REPLACE INTO cities(cyname,population)
SELECT cyname, population FROM cities WHERE id = 1;

### Example - Replace statement  (Record is replaced)
-- Step - 1
CREATE TABLE test (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  data VARCHAR(64) DEFAULT NULL,
  ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);
-- Step - 2
REPLACE INTO test VALUES (1, 'Old', '2014-08-20 18:47:00');
-- Step - 3
REPLACE INTO test VALUES (1, 'New', '2014-08-20 18:47:42');

## Example - 2   (Record is inserted)
-- Step -1
CREATE TABLE test2 (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  data VARCHAR(64) DEFAULT NULL,
  ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id, ts)
);
-- Step -2
REPLACE INTO test2 VALUES (1, 'Old', '2014-08-20 18:47:00');
-- Step - 3
REPLACE INTO test2 VALUES (1, 'New', '2014-08-20 18:47:42');

 
-- -------------------------------------------------------------------------------------------

###################### MySQL PREPARED STATEMENT ############################ 

/* Prior MySQL version 4.1, a query is sent to the MySQL server in the textual format.
 In turn, MySQL returns the data to the client using textual protocol.

The prepared statement takes advantage of client/server binary protocol.
 It passes the query that contains placeholders (?) to the MySQL Server.

Example:

SELECT * FROM products WHERE productCode = ?; -- While parsing different values can be passed

In order to use MySQL prepared statement, you use three following statements:

PREPARE – prepare a statement for execution.
EXECUTE – execute a prepared statement prepared by the PREPARE statement.
DEALLOCATE PREPARE – release a prepared statement.

*/

### Example for PREPARED STATEMENT
USE sample;
CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(30) not null,
    categoryId INT
   ) ENGINE=INNODB;
INSERT INTO products(productName,categoryId) values('Mobile',1),('Laptop',2),('Head Phone',3); 

# Step-1 : Prepare a statement that returns the product code and name of a product specified by product code:
PREPARE stmt1 FROM 
	'SELECT productId, productName FROM products 
        WHERE productId = ?';
        
# STEP - 2: Declare a variable named pc, stands for product code, and set its value to 'S10_1678':
SET @pc = 1; 

# STEP - 3: Execute the prepared statement:
EXECUTE stmt1 USING @pc;

# STEP - 4: Assign the pc variable another product code:
SET @pc = 3;

# STEP - 5: Execute the prepared statement with the new product code:
EXECUTE stmt1 USING @pc;

# STEP - 6: Finally Release the prepared statement:
DEALLOCATE PREPARE stmt1;

-- --------------------------------------------------------------------------------------------

##### Assigning Variables using Assignment Operator in MySQL
/* ## Two ways to assign a value:

1. By using SET statement: Using SET statement we can either use := or = as an assignment operator.
2. By using SELECT statement: Using SELECT statement we must use := as an assignment operator because = operator is used for comparison in MySQL.

Syntax:
SET variableName = expression; where the variable name can be any variable created.
SELECT FieldName = expression; where field name can be any given name.
*/

### Example1: Using SET Statement in MySQL
SET @MyCounter = 1;   -- (OR)   SET @MyCounter := 1;
SELECT @MyCounter;

### Example2: Using SET Statement in MySQL
SET @a = 100;  
SET @b := 8;
SET @c := @a * @b;
SELECT @c 'Result' ;


## Example3: Using SELECT Statement in MySQL
-- Let’s get the most expensive item from the Product table and assigns the Price to the variable @ExpensiveItem. 
--   Following is the SQL Statement.

SELECT @ExpensiveItem := MAX(ProductId) AS 'MAX PRODUCTS' FROM Products;

-- ------------------------------------------------------------------------------------------
###### String Matching ##
/*
^	Beginning of string
$	End of string
.	Any single character
[...]	Any character listed between the square brackets
[^...]	Any character not listed between the square brackets
p1|p2|p3	Alternation; matches any of the patterns p1, p2, or p3
*	Zero or more instances of preceding element
+	One or more instances of preceding element
{n}	n instances of preceding element
{m,n}	m through n instances of preceding element
*/

-- EXAMPLES with REGEXP ----------------------

-- Query to find all the names starting with 'st' -------- 
SELECT name FROM person_tbl WHERE name REGEXP '^st';

-- Query to find all the names ending with 'ok' ---------
SELECT name FROM person_tbl WHERE name REGEXP 'ok$';

-- Query to find all the names, which contain 'mar' −-----
SELECT name FROM person_tbl WHERE name REGEXP 'mar';

-- Query to find all the names starting with a vowel and ending with 'ok' −-----
SELECT FirstName FROM intque.person_tbl WHERE FirstName REGEXP '^[aeiou].*ok$';
 
-- --------------------------------------------

SELECT * FROM pet WHERE name LIKE '%w%';    -- To find names containing a w:
SELECT * FROM pet WHERE name LIKE '_____';   -- To find names containing exactly five characters

-- To find names beginning with b, use ^ to match the beginning of the name
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b');   

-- To find names ending with fy, use $ to match the end of the name:
SELECT * FROM pet WHERE REGEXP_LIKE(name, 'fy$');

-- To find names containing a w, use this query:
SELECT * FROM pet WHERE REGEXP_LIKE(name, 'w');


-- To find names containing exactly five characters, use ^ and $ to match the beginning and end of the name, 
-- and five instances of . in between:
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^.....$');

-- Write the previous query using the {n} (“repeat-n-times”) operator:
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^.{5}$');

### 
-- To force a regular expression comparison to be case-sensitive, use a case-sensitive collation,
--  or use the BINARY keyword to make one of the strings a binary string, 
-- or specify the c match-control character. 
-- Each of these queries matches only lowercase b at the beginning of a name:
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b' COLLATE utf8mb4_0900_as_cs);
SELECT * FROM pet WHERE REGEXP_LIKE(name, BINARY '^b');
SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b', 'c');


##########  Regular Expressions in MySQL #############
SELECT 'Michael!' REGEXP '.*';    -- '.*'   -- '.r'  -- Returns 1 if matches found, otherwise 0 (. - Single * - No/More characters)
SELECT 'x' REGEXP '[^a-d]';     -- 'x' is not in a-d range

## Checks the substring in th given string ( Match found return 0 otherwise 1 ) 
SELECT REGEXP_INSTR('dog cat dog', 'dog');    -- 'dog' is present in the 1st position, returns the position of the match, otherwise 0
SELECT REGEXP_INSTR('dog cat dog', 'doa', 2);   -- Search starts from 2nd position and returns the position of the string if found
 SELECT REGEXP_INSTR('aa aaa aaaa', 'a{2}');  -- 2 a's are in 1st position
SELECT REGEXP_INSTR('aa aaa aaaa', 'a{4}');  -- 4 a's are in 8th position
SELECT REGEXP_LIKE('CamelCas', 'CAMELCASE'); -- Omits case sensitiveness, takes only the value for checking
SELECT REGEXP_LIKE('CamelCase', 'CAMELCASE' COLLATE utf8mb4_0900_as_cs); 

SELECT REGEXP_LIKE('Michael!', '.*');    -- 
SELECT REGEXP_LIKE('abc', 'ABC');   -- Returns 1 (Checks only the data, not the case)
SELECT REGEXP_LIKE('abc', 'ABC', 'c');  -- Returns 0 (Checks Case sensitiveness)

-- Replace
SELECT REGEXP_REPLACE('a b c', 'b', 'X');  -- Output : a X c
SELECT REGEXP_REPLACE('abc def ghi', '[a-z]+', 'X', 1, 3);  -- abc def X

## Match the beginning of a string. ^
 SELECT REGEXP_LIKE('fo\nfo', '^fo$');     --               -> 0
 SELECT REGEXP_LIKE('fofo', '^fo');        --              -> 1


## Match the end of a string.    -- $
SELECT REGEXP_LIKE('fo\no', '^fo\no$');      --           -> 1
SELECT REGEXP_LIKE('fo\no', '^fo$');         --           -> 0

## Match any character (including carriage return and newline, 
	-- although to match these in the middle of a string, 
    -- the m (multiple line) match-control character or the (?m) within-pattern modifier must be given).
 SELECT REGEXP_LIKE('fofo', '^f.*$');             --       -> 1
 SELECT REGEXP_LIKE('fo\r\nfo', '^f.*$');         --       -> 0
 SELECT REGEXP_LIKE('fo\r\nfo', '^f.*$', 'm');    --       -> 1  (Match-control character ('m') for Multiple line checking )
 SELECT REGEXP_LIKE('fo\r\nfo', '(?m)^f.*$');     --      -> 1  (Modifier for (?m) Multiple line checking )
 
## Match any sequence of zero or more a characters.  ( a* )
 SELECT REGEXP_LIKE('Ban', '^Ba*n');           --          -> 1
 SELECT REGEXP_LIKE('Baaan', '^Ba*n');         --          -> 1
 SELECT REGEXP_LIKE('Bn', '^Ba*n');      --          -> 1


## Match any sequence of one or more a characters.  a+
 SELECT REGEXP_LIKE('Ban', '^Ba+n');          --           -> 1
 SELECT REGEXP_LIKE('Bn', '^Ba+n');          --            -> 0


## Match either zero or one a character.    ( a? )
 SELECT REGEXP_LIKE('Bn', '^Ba?n');         --             -> 1
 SELECT REGEXP_LIKE('Ban', '^Ba?n');        --            -> 1
 SELECT REGEXP_LIKE('Baan', '^Ba?n');       --           -> 0


## Alternation; match either of the sequences de or abc.   (de|abc)
 SELECT REGEXP_LIKE('pi', 'pi|apa');          --           -> 1
 SELECT REGEXP_LIKE('axe', 'pi|apa');         --           -> 0
 SELECT REGEXP_LIKE('apa', 'pi|apa');         --           -> 1
 SELECT REGEXP_LIKE('apa', '^(pi|apa)$');      --          -> 1
 SELECT REGEXP_LIKE('pi', '^(pi|apa)$');       --          -> 1
SELECT REGEXP_LIKE('pix', '^(pi|apa)$');       --         -> 0

## Match zero or more instances of the sequence abc.   (abc)*
 SELECT REGEXP_LIKE('pi', '^(pi)*$');          --          -> 1
 SELECT REGEXP_LIKE('pip', '^(pi)*$');         --          -> 0
 SELECT REGEXP_LIKE('pipi', '^(pi)*$');        --          -> 1
 SELECT REGEXP_LIKE('pipio', '^(pi)*$');        --          -> 0
 
-- ----------------------------------------------------------------------

