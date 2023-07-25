###### COLUMN and TABLE ALIASES ##############################
### COLUMN ALIASES #########################
/*CONCAT_WS()
 This function in MySQL helps in joining two or more strings along with a separator.
 The separator must be specified by the user and it can also be a string. 
 If the separator is NULL, then the result will also be NULL.
*/
SELECT CONCAT_WS("-", "SQL", "Tutorial", "is", "fun!") AS ConcatenatedString;   -- Output: SQL-Tutorial-is-fun!
SELECT CONCAT_WS(', ', lastName, firstname) FROM employees; -- Without column alias
SELECT CONCAT_WS(', ', lastName, firstname) AS `Full name` FROM employees; -- With column alias
SELECT CONCAT_WS(' : ', lastName, firstname) `Full name` FROM employees; -- (No AS clause) With column alias 
SELECT 	CONCAT_WS(' / ', lastName, firstname) `Full name` FROM employees ORDER BY  `Full name`;  -- Using alias name in the query
        
SELECT orderNumber `Order no.`, SUM(priceEach * quantityOrdered) total FROM orderDetails
   GROUP BY `Order no.` ;

-- HAVING ( Conditions in ORDER BY values)   
SELECT orderNumber `Order no.`, SUM(priceEach * quantityOrdered) total FROM orderDetails
   GROUP BY `Order no.` HAVING total > 60000;
   
## CAUTION:
/* We cannot use a column alias in the WHERE clause. 
The reason is that when MySQL evaluates the WHERE clause, the values of columns specified in the 
SELECT clause  are not be evaluated yet.
*/

### TABLE ALIASES ##############################################
 SELECT e.firstName, e.lastName FROM employees e
ORDER BY e.firstName;    -- Aliases in single table with order by clause 

SELECT customers.customerName, COUNT(orders.orderNumber) total FROM customers
INNER JOIN orders ON customers.customerNumber = orders.customerNumber
GROUP BY customerName ORDER BY 	total DESC;   -- Inner Join without aliases
    
SELECT customerName, COUNT(o.orderNumber) total FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY customerName ORDER BY total DESC;   -- Inner Join with Aliases

-- -------------------------------------------------------------------------------------------

-- ####### JOIN clause [ Join one or more tables ] ########################

/* A join is a method of linking data between one (self-join) or more tables 
   based on values of the common column between the tables.
  -- Used to combine columns from more than one table to get the resultant values
  -- Mainly used to get data from the Parent(Primary Key) and Child(Foreign Key) table which have common key field values, but it is not mandatory.
  
Types of JOINS in MySQL

There are mainly 3 types of joins in MySQL:

INNER JOIN: The Inner join returns only the matching records from both the tables involved in the Join. Non-matching records are eliminated.
OUTER JOIN: The Outer Join retrieves the matching records as well as non-matching records from both the tables involved in the join in MySQL.
			Left outer join
			Right outer join
			Full outer join - Not supported. We can get it using LEFT, RIGHT and UNION
CROSS JOIN: If two or more tables are combined with each other without any condition then we call it cross join in MySQL. 
				In cross join, each record of a table is joins with each record of another table.
                It results m X n rows when Table-A contains m rows and Table-B contains n rows
SELF JOIN: 
*/

### Examples for JOIN in MySQL
-- STEP - 1
CREATE DATABASE Company;
USE Company;

CREATE TABLE Employee (
  Id INT PRIMARY KEY,
  Name VARCHAR(45) NOT NULL,
  Department VARCHAR(45) NOT NULL,
  Salary FLOAT NOT NULL,
  Gender VARCHAR(45) NOT NULL,
  Age INT NOT NULL,
  City VARCHAR(45) NOT NULL
);

INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1001, 'John Doe', 'IT', 35000, 'Male', 25, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1002, 'Mary Smith', 'HR', 45000, 'Female', 27, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1003, 'James Brown', 'Finance', 50000, 'Male', 28, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1004, 'Mike Walker', 'Finance', 50000, 'Male', 28, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1005, 'Linda Jones', 'HR', 75000, 'Female', 26, 'London');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1006, 'Anurag Mohanty', 'IT', 35000, 'Male', 25, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1007, 'Priyanla Dewangan', 'HR', 45000, 'Female', 27, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1008, 'Sambit Mohanty', 'IT', 50000, 'Male', 28, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1009, 'Pranaya Kumar', 'IT', 50000, 'Male', 28, 'Mumbai');
INSERT INTO Employee (Id, `Name`, Department, Salary, Gender, Age, City) VALUES (1010, 'Hina Sharma', 'HR', 75000, 'Female', 26, 'Mumbai');

SELECT * FROM Employee;

CREATE TABLE Projects (
 ProjectId INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    ClientId INT,
 EmployeeId INT,
    StartDate DATETIME,
    EndDate DATETIME,
    FOREIGN KEY (EmployeeId) REFERENCES Employee(Id)
);

INSERT INTO Projects ( Title, ClientId, EmployeeId, StartDate, EndDate) VALUES 
('Develop ecommerse website from scratch', 1, 1003, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
('WordPress website for our company', 1, 1002, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY)),
('Manage our company servers', 2, 1007, NOW(), DATE_ADD(NOW(), INTERVAL 45 DAY)),
('Hosting account is not working', 3, 1009, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
('MySQL database from my desktop application', 4, 1010, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY)),
('Develop new WordPress plugin for my business website', 2, NULL, NOW(), DATE_ADD(NOW(), INTERVAL 10 DAY)),
('Migrate web application and database to new server', 2, NULL, NOW(), DATE_ADD(NOW(), INTERVAL 5 DAY)),
('Android Application development', 4, 1004, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
('Hosting account is not working', 3, 1001, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
('MySQL database from my desktop application', 4, 1008, NOW(), DATE_ADD(NOW(), INTERVAL 15 DAY)),
('Develop new WordPress plugin for my business website', 2, NULL, NOW(), DATE_ADD(NOW(), INTERVAL 10 DAY)); 

SELECT * FROM Projects;

-- STEP -2 (INNER JOIN)  -- In MySQL, you can use either the INNER JOIN or JOIN keyword to perform Inner Join.
/* 
Note: The INNER JOIN returns the rows in the result set where the column value in a row of table1 is equal to the column value in a row of table2. 
In INNER JOIN the ON clause defines the columns and condition to be evaluated.
*/

-- Using INNER JOIN keyword
SELECT Id as EmployeeID, Name, Department, City, Title as Project, ClientId
FROM Employee 
INNER JOIN Projects 
ON Employee.Id = Projects.EmployeeId;

-- Using JOIN keyword
SELECT Id as EmployeeID, Name, Department, City, Title as Project, ClientId
FROM Employee 
JOIN Projects 
ON Employee.Id = Projects.EmployeeId;


-- STEP- 3
##### Outer Join in MySQL
/* Unlike INNER JOIN, the OUTER JOIN returns matched data rows as well as unmatched data rows from both the tables involved in the join. 
   Outer join is again classified into three types.
		Left outer join
		Right outer join
		Full outer join -  
			NOTE : 1. MySQL doesn’t support FULL OUTER JOIN; we will achieve the FULL OUTER JOIN using UNION Operator in MySQL.
				   2. FULL OUTER JOIN can be performed using LEFT OUTER JOIN, RIGHT OUTER JOIN and UNION.
*/

-- STEP-3.1
##### LEFT OUTER JOIN
/* The LEFT OUTER JOIN in MySQL retrieves all the matching rows from both the tables as well as non-matching rows from the left side table. 
      In this case, the un-matching data will take a null value.
      
      NOTE:: In MySQL, you can use either the LEFT OUTER JOIN or LEFT JOIN keyword to perform Left Outer Join.
*/

## EXample Using LEFT OUTER JOIN
SELECT Id as EmployeeID, Name, Department, City, Title as Project, ClientId
FROM Employee 
LEFT OUTER JOIN Projects 
ON Employee.Id = Projects.EmployeeId;

## EXample Using LEFT JOIN
SELECT Employee.Id as Id, Name, Department, City, Title as Project, Projects.EmployeeId
FROM Employee 
LEFT JOIN Projects 
ON Employee.Id = Projects.EmployeeId;

-- Step- 3.2
/* RIGHT OUTER JOIN in MySQL
The RIGHT OUTER JOIN in MySQL retrieves all the matching rows from both the tables as well as non-matching rows from the right-side table. 
   In this case, the un-matching data will take a null value. 
  NOTE::  In MySQL, you can use either the RIGHT OUTER JOIN or RIGHT JOIN keyword to perform Right Outer Join operations.
  */
  
## Example using RIGHT OUTER JOIN keyword
SELECT Employee.Id as EmployeeId, Name, Department, City, Title as Project
FROM Employee 
RIGHT OUTER JOIN Projects 
ON Employee.Id = Projects.EmployeeId;
  
## Example using RIGHT JOIN keyword 
SELECT Employee.Id as EmployeeId, Name, Department, City, Title as Project
FROM Employee 
RIGHT JOIN Projects 
ON Employee.Id = Projects.EmployeeId;


-- STEP- 3.3 FULL OUTER JOIN in MySQL
/* The FULL OUTER JOIN retrieves all the matching rows from both the tables as well as non-matching rows from both the tables involved in the Join. 
In this case, the un-matching data will take a null value. 
caution :: MySQL doesn’t support FULL OUTER JOIN; we will achieve the FULL OUTER JOIN using UNION Operator in MySQL.

IMPORTANT NOTE:: FULL OUTER JOIN in MySQL is achieved using the UNION operator is given below. 

SYNTAX: 
SELECT * FROM table1
LEFT OUTER JOIN table2
ON table1.column1 = table2.column2
UNION
SELECT * FROM table1
RIGHT OUTER JOIN table2
ON table1.column1 = table2.column2;
*/

## Example for FULL OUTER JOIN using LEFT OUTER JOIN, RIGHT OUTER JOIN and UNION
SELECT Employee.Id as EmployeeId, Name, Department, City, Title as Project 
FROM Employee 
LEFT OUTER JOIN Projects 
ON Employee.Id = Projects.EmployeeId
UNION 
SELECT Employee.Id as EmployeeId, Name, Department, City, Title as Project 
FROM Employee 
RIGHT OUTER JOIN Projects 
ON Employee.Id = Projects.EmployeeId;


## Cross Join in MySQL
 /* 
   -- Unlike INNER JOIN, the CROSS-JOIN returns matched data rows as well as unmatched data rows from the table.
   When we combine two or more tables with each other without any condition (where or on) then we call such type of joins as cross join. 
   In Cross Join, each record of a table is joined with each record of the other table involved in the join.
   -- The CROSS JOIN is created by using the CROSS JOIN keyword. 
   -- The CROSS JOIN does not contain an ON clause. 
   
   NOTE: A Cross Join in MySQL produces the Cartesian product of the tables involved in the join. 
         (number of records present in the first table is multiplied by the number of records present in the second table) 
   */
## Example for CROSS JOIN
SELECT Employee.Id as EmployeeId, Name, Department, City, Title as Project
FROM Employee 
CROSS JOIN Projects;

-- --------------------------------------------------------------------------------------------------

-- ######## MYSQL SELF JOIN  ######### ----------------------
/* Special case that you need to join a table to itself, which is known as a self join.
  USES: The self join is often used to query hierarchical data or to compare a row with other rows within the same table.
*/

-- ###### Example - 1 (Self Join with Inner Join Clause)
USE classicmodels;
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
    
-- Example - 2 (Self Join with LEFT Join Clause)
SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname),
            'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Direct report'
FROM
    employees e
LEFT JOIN employees m ON 
    m.employeeNumber = e.reportsto
ORDER BY 
    manager DESC;

-- Example - 3 self join to compare successive rows
-- By using the MySQL self join, you can display a list of customers who locate in the same city by 
   -- joining the customers table to itself.    
SELECT 
    c1.city, 
    c1.customerName, 
    c2.customerName
FROM
    customers c1
INNER JOIN customers c2 ON 
    c1.city = c2.city
    AND c1.customername > c2.customerName
ORDER BY 
    c1.city;
    
-- ---------------------------------------------------------------------

##### Additionals ######
/*
MySQL supports the following types of joins:

Inner join  -- Common values in both the table
Left join
Right join
Cross join
Self Join

NOTE: MySQL hasn’t supported the FULL OUTER JOIN yet.
*/

##### EXAMPLES: ######## ------------
### --- INNER JOIN #### -----------------
/* SYNTAX
-- 1. Basic syntax of the inner join clause

SELECT column_list FROM table_1
INNER JOIN table_2 ON join_condition;

-- 2. If the join condition uses the equality operator (=) and 
      the column names in both tables used for matching are the same,
      and you can use the USING clause instead
      
SELECT column_list FROM table_1
INNER JOIN table_2 USING (column_name);

*/

-- STEP 1: Create Sample Tables [ members & committees]
CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (member_id)
);

CREATE TABLE committees (
    committee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (committee_id)
);

-- STEP 2: Insert some rows into the tables members and committees
INSERT INTO members(name)
VALUES('John'),('Jane'),('Mary'),('David'),('Amelia');

INSERT INTO committees(name)
VALUES('John'),('Mary'),('Amelia'),('Joe');

-- STEP 3 : Query data from the tables members and committees
SELECT * FROM members;
SELECT * FROM committees;


-- STEP 4: Use INNER JOIN QUERY (WAY-1)
 SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee
FROM  members m
INNER JOIN committees c ON c.name = m.name;

-- INNER JOIN with USING clause (WAY-2)
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee
FROM members m 
INNER JOIN committees c USING(name);


## LEFT JOIN ### ------------------------------------------------------
/* left join selects all data from the left table whether there are matching rows exist 
   in the right table or not.
-- All the rows in LEFT table and maching rows in right table
-- In case there are no matching rows from the right table found, 
   the left join uses NULLs for columns of the row from the right table in the result set.

-- Basic SYNTAX of a LEFT JOIN clause:
	SELECT column_list 
	FROM table_1 
	LEFT JOIN table_2 ON join_condition;

-- LEFT JOIN with USING clause
SELECT column_list 
FROM table_1 
LEFT JOIN table_2 USING (column_name);
*/

#### Examples  - 1
-- LEFT JOIN (WAY - 1)
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
  LEFT JOIN committees c on m.member_id=c.committees_id;
  
#### Examples  - 2
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	LEFT JOIN committees c USING(name);

#### Examples  - 3
-- To find members who are not the committee members, 
-- you add a WHERE clause and IS NULL operator as follows:
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	LEFT JOIN committees c USING(name) WHERE c.committee_id IS NULL;
-- -----------------------------------------------------------------------------------------

-- ###### RIGHT JOIN clause ###### ------------------------------
/* Selects all rows from the right table and matches rows in the left table. 
   If a row from the right table does not have matching rows from the left table, 
   the column of the left table will have NULL in the final result set.

-- Syntax of RIGHT JOIN (WAY -1)
SELECT column_list 
FROM table_1 
RIGHT JOIN table_2 ON join_condition;

-- RIGHT JOIN USING syntax: (WAY -2)
SELECT column_list  
FROM table_1 
RIGHT JOIN table_2 USING (column_name);

*/

#### Examples  - 1
-- Using a WHERE clause with the IS NULL operator:
SELECT column_list 
FROM table_1 
RIGHT JOIN table_2 USING (column_name)
WHERE column_table_1 IS NULL;

#### Examples - 2
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	RIGHT JOIN committees c on c.name = m.name;

##### Examples - 3 (USING Syntax)
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	RIGHT JOIN committees c USING(name);

#### Examples - 4 
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	RIGHT JOIN committees c USING(name) WHERE m.member_id IS NULL;
    
-- ----------------------------------------------------------------------------------------------------

-- #######  CROSS JOIN clause  ###### ----------------------------
/* The cross join clause does not have a join condition.
  * The cross join makes a Cartesian product of rows from the joined tables. 
  * The cross join combines each row from the first table with every row from the right table to make the result set.
  * Suppose the first table has n rows and the second table has m rows. The cross join that joins the tables will return nxm rows.

### USES: The cross join is useful for generating planning data. 
    For example, you can carry the sales planning by using the cross join of customers, products, and years.

 * SYNTAX of the CROSS JOIN clause:
   SELECT select_list
	FROM table_1
	CROSS JOIN table_2;
*/

-- ##### Example ##### -------- 
  --  Example uses the cross join clause to join the members with the committees tables:
SELECT m.member_id, m.name AS member, c.committee_id, c.name AS committee FROM members m
	CROSS JOIN committees c;

/* IMPORTANT NOTE: If you add a WHERE clause, 
  in case table t1 and t2 has a relationship, the CROSS JOIN works like the INNER JOIN

SELECT * FROM t1
CROSS JOIN t2
WHERE t1.id = t2.id;
*/

### EXAMPLE :
CREATE DATABASE IF NOT EXISTS salesdb;

USE salesdb;
-- --------
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(13,2 )
);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(100)
);

CREATE TABLE sales (
    product_id INT,
    store_id INT,
    quantity DECIMAL(13 , 2 ) NOT NULL,
    sales_date DATE NOT NULL,
    PRIMARY KEY (product_id , store_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------
INSERT INTO products(product_name, price)
VALUES('iPhone', 699),
      ('iPad',599),
      ('Macbook Pro',1299);

INSERT INTO stores(store_name)
VALUES('North'),
      ('South');

INSERT INTO sales(store_id,product_id,quantity,sales_date)
VALUES(1,1,20,'2017-01-02'),
      (1,2,15,'2017-01-05'),
      (1,3,25,'2017-01-05'),
      (2,1,30,'2017-01-02'),
      (2,2,35,'2017-01-05');
-- -----------------

-- INNER JOIN Query
SELECT 
    store_name,
    product_name,
    SUM(quantity * price) AS revenue
FROM
    sales
        INNER JOIN
    products ON products.id = sales.product_id
        INNER JOIN
    stores ON stores.id = sales.store_id
GROUP BY store_name , product_name; 

-- ------

-- CROSS JOIN Query
SELECT 
    store_name, product_name
FROM
    stores AS a
        CROSS JOIN
    products AS b;
--  -------------------
-- Toal Sales by stores and product
SELECT 
    b.store_name,
    a.product_name,
    IFNULL(c.revenue, 0) AS revenue
FROM
    products AS a
        CROSS JOIN
    stores AS b
        LEFT JOIN
    (SELECT 
        stores.id AS store_id,
        products.id AS product_id,
        store_name,
            product_name,
            ROUND(SUM(quantity * price), 0) AS revenue
    FROM
        sales
    INNER JOIN products ON products.id = sales.product_id
    INNER JOIN stores ON stores.id = sales.store_id
    GROUP BY stores.id, products.id, store_name , product_name) AS c ON c.store_id = b.id
        AND c.product_id= a.id
ORDER BY b.store_name;
-- ----------------------------------------------

-- ######## MYSQL SELF JOIN  ######### ----------------------
/* Special case that you need to join a table to itself, which is known as a self join.
  USES: The self join is often used to query hierarchical data or to compare a row with other rows within the same table.
*/

-- ###### Example - 1 (Self Join with Inner Join Clause)
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;
    
-- Example - 2 (Self Join with LEFT Join Clause)
SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname),
            'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Direct report'
FROM
    employees e
LEFT JOIN employees m ON 
    m.employeeNumber = e.reportsto
ORDER BY 
    manager DESC;

-- Example - 3 self join to compare successive rows
-- By using the MySQL self join, you can display a list of customers who locate in the same city by 
   -- joining the customers table to itself.    
SELECT 
    c1.city, 
    c1.customerName, 
    c2.customerName
FROM
    customers c1
INNER JOIN customers c2 ON 
    c1.city = c2.city
    AND c1.customername > c2.customerName
ORDER BY 
    c1.city;
-- ------------------------------

    






