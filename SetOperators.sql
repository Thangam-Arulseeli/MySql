###### SET OPERATORS  ##########
/* The SET Operators in MySQL are basically used to combine the result of more than 1 select statement and return the output as a single result set. 
In SQL, 4 types of set operators.

UNION: It is used to combine two or more result sets into a single set, without duplicates.
UNION ALL: It is used to combine two or more result sets into a single set, including duplicates.
INTERSECT: It is used to combine two result sets and returns the data which are common in both the result set. - ( Not supported in MySQL ), But can implement it......
MINUS (Oracle) EXCEPT(SQL SERVER/PostgreSQL) : It is used to combine two result sets and returns the data from the first result set which is not present in the second result set. 
		(Not supported in MySQL ), But can implement it......

### Points to Remember while working with Set Operations:

1. Every SELECT statement involved in the query must have a similar number of columns.
2. The columns in the SELECT statement must be in the same order and have similar data types.
3. In order to sort the result, an ORDER BY clause should be part of the last select statement. 
4. The column names or aliases must be found out by the first select statement.

*/

### MySQL UNION operator ###

/*  MySQL UNION operator allows you to combine two or more result sets of queries into a single result set.

RULES 
1. The number and the orders of columns that appear in all SELECT statements must be the same.
2. The data types of columns must be the same or compatible.
By default, the UNION operator removes duplicate rows even if you don’t specify the DISTINCT operator explicitly.

-- A JOIN combines result sets horizontally, a UNION appends result set vertically. 

SYNTAX
SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
UNION [DISTINCT | ALL]
SELECT column_list
...
-------------------------------------
*/

### Example for ::: 
Use sample;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;

CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 (
    id INT PRIMARY KEY
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (2),(3),(4);

-- --------- 
SELECT id
FROM t1
UNION
SELECT id
FROM t2;
-- -------------

### EXAMPLE ::: UNION ALL 
-- Use the UNION ALL explicitly, the duplicate rows, if available, remain in the result. 
-- Because UNION ALL does not need to handle duplicates, it performs faster than UNION DISTINCT .
SELECT id
FROM t1
UNION ALL
SELECT id
FROM t2;

-- --------------------------------------
Use sample;
DROP TABLE IF EXISTS tb1;
DROP TABLE IF EXISTS tb2;

CREATE TABLE tb1 (
    FirstName varchar(20),
    LastName varchar(20),
	Age int
);

CREATE TABLE tb2 (
    ContactFirstName varchar(20),
    ContactLastName varchar(20),
	Age int
);

INSERT INTO tb1 VALUES ('Arul', 'Seeli',11),('Jeyam', 'Christin',71), ('Joseph', 'Daniel',58);
INSERT INTO tb2 VALUES ('Arokia', 'Seean',23),('Jeyam', 'Christin',71), ('Joseph', 'Daniel',58);

-- ----------------------------------------
### Example - 1
SELECT 
    firstName, 
    lastName, Age
FROM
    tb1
UNION 
SELECT 
    contactFirstName, 
    contactLastName, Age
FROM
   tb2;
    
###  Example - 2 (Union and Order By) --  if you place the ORDER BY clause in each SELECT statement, 
										-- it will not affect the order of the rows in the final result set. (Next Example)
SELECT 
    concat(firstName,' ',lastName) fullname, Age
FROM  tb1 
UNION
SELECT 
    concat(contactFirstName,' ',contactLastName) , Age
FROM tb2
ORDER BY fullname;


###  Example - 3 (Union and Order By - To get required result)
SELECT 
    CONCAT(firstName, ' ', lastName) fullname, Age,
        'tb1' as contactType
FROM tb1
    UNION 
SELECT 
    CONCAT(contactFirstName, ' ', contactLastName), Age, 
    'tb2' as contactType
FROM
    tb2
ORDER BY  fullname;
    
### EXample - 4 (it is not a good practice to sort the result set by column position.)
-- To sort a result set based on column position using ORDER BY clause
SELECT 
    CONCAT(firstName,' ',lastName) fullname
FROM
    tb1
UNION SELECT 
    CONCAT(contactFirstName,' ',contactLastName)
FROM
   tb2
ORDER BY 1;

-- ----------------------------------------------

##### MySQL INTERSECT ##### -----------------------

/* MySQL does not support the INTERSECT operator. 
   MySQL emulates how to emulate the INTERSECT operator in MySQL using join clauses.

-- The INTERSECT operator compares the result sets of two queries and returns the distinct rows that are output by both queries.
   Returns only distinct rows of two queries or more queries.
   
SYNTAX:
(SELECT column_list 
FROM table_1)
INTERSECT
(SELECT column_list
FROM table_2);

# RULES
1. The order and the number of columns in the select list of the queries must be the same.
2. The data types of the corresponding columns must be compatible.

NOTE: MySQL does not support the INTERSECT operator. However, you can emulate the INTERSECT operator.
*/ 

### Example :

CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 LIKE t1;

INSERT INTO t1(id) VALUES(1),(2),(3);
INSERT INTO t2(id) VALUES(2),(3),(4);

SELECT id FROM t1;
SELECT id FROM t2;

## Ex: 1 (Emulates INTERSECT using DISTINCT and INNER JOIN clause)
SELECT DISTINCT id 
FROM t1
   INNER JOIN t2 USING(id);

## Ex: 2 : (Emulate INTERSECT using IN and subquery)
SELECT DISTINCT id
FROM t1
WHERE id IN (SELECT id FROM t2);

-- -----------------------------------------------------------

###### MINUS Operator ###### ---------
/* The MINUS compares the results of two queries and 
   returns distinct rows from the result set of the first query that does not appear in the result set of the second query.

SYNTAX: 
SELECT select_list1 
FROM table_name1
MINUS 
SELECT select_list2 
FROM table_name2;

RULES:
1. The number and order of columns in both select_list1 and select_list2 must be the same.
2. The data types of the corresponding columns in both queries must be compatible.

NOTE:: (A-B) <> (B-A)

NOTE: MySQL does not support the MINUS operator. 
Microsoft SQL Server and PostgreSQL use the EXCEPT instead of MINUS.

*/

### Example :
CREATE TABLE t1 (
    id INT PRIMARY KEY
);

CREATE TABLE t2 (
    id INT PRIMARY KEY
);

INSERT INTO t1 VALUES (1),(2),(3);
INSERT INTO t2 VALUES (2),(3),(4);



## SYNTAX :  - MySQL MINUS operator emulation (Using Left JOIN)
/*SELECT 
    select_list
FROM 
    table1
LEFT JOIN table2 
    ON join_predicate
WHERE 
    table2.column_name IS NULL; 
 */

## Example : 1 --- (A-B) (MySQL MINUS operator emulation (Left JOIN with USING Operator) 
SELECT 
    id
FROM
    t1
LEFT JOIN
    t2 USING (id);
 -- WHERE
 --    t2.id IS NULL;


## Example : 2 --- (B-A) (MySQL MINUS operator emulation (Left JOIN with USING Operator) 
SELECT 
    id
FROM
    t2
LEFT JOIN
    t1 USING (id);
-- WHERE
 --    t1.id IS NULL;

-- -------------------------------------------------------------

##### SET OPERATOR -- Example

## STEP - 1

CREATE DATABASE EmployeeDB;
USE EmployeeDB;

CREATE TABLE EmployeeUK
(
  EmployeeId INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUK VALUES(1, 'Pranaya', 'Rout', 'Male','IT');
INSERT INTO EmployeeUK VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUK VALUES(3, 'Preety', 'Tiwary', 'Female','HR');
INSERT INTO EmployeeUK VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUK VALUES(5, 'Anurag', 'Mohanty', 'Male','IT');
INSERT INTO EmployeeUK VALUES(6, 'Rajesh', 'Pradhan', 'Male','HR');
INSERT INTO EmployeeUK VALUES(7, 'Hina', 'Sharma', 'Female','IT');

CREATE TABLE EmployeeUSA
(
  EmployeeId INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Gender VARCHAR(10),
  Department VARCHAR(20)
);

INSERT INTO EmployeeUSA VALUES(1, 'James', 'Pattrick', 'Male','IT');
INSERT INTO EmployeeUSA VALUES(2, 'Priyanka', 'Dewangan', 'Female','IT');
INSERT INTO EmployeeUSA VALUES(3, 'Sara', 'Taylor', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(4, 'Subrat', 'Sahoo', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(5, 'Sushanta', 'Jena', 'Male','HR');
INSERT INTO EmployeeUSA VALUES(6, 'Mahesh', 'Sindhey', 'Female','HR');
INSERT INTO EmployeeUSA VALUES(7, 'Hina', 'Sharma', 'Female','IT');

-- STEP - 2
## UNION Operator -- Without duplicates (Time consuming process)
SELECT FirstName, LastName, Gender, Department FROM EmployeeUK
UNION
SELECT FirstName, LastName, Gender, Department FROM EmployeeUSA;

-- STEP - 3
## UNION ALL Operator -- With duplicates (NOT A Time consuming process)
SELECT FirstName, LastName, Gender, Department FROM EmployeeUK
UNION ALL
SELECT FirstName, LastName, Gender, Department FROM EmployeeUSA;

-- STEP - 4
## UNION/UNION ALL with ORDER BY Clause in MySQL
SELECT FirstName, LastName, Gender, Department FROM EmployeeUK
UNION
SELECT FirstName, LastName, Gender, Department FROM EmployeeUSA
ORDER BY FirstName;

-- STEP - 5
####### MySQL EXCEPT Operator (MINUS)
/* The EXCEPT operator is used to combine two tables or two result sets and will return rows from the first select statement 
   that are not present in the second select statement. 
   
Syntax of EXCEPT Operator
SELECT select_list1 
FROM table_name1
EXCEPT 
SELECT select_list2 
FROM table_name2;

*/

##### (MINUS) / EXCEPT Operator  -- NOT SUPPORTED in MySQL --  
 --  We can achieve the EXCEPT Operator functionality in MySQL using the following ways.

-- WAY - 1 ( Using NOT IN Operator to achieve EXCEPT )
SELECT * FROM EmployeeUK
WHERE FirstName NOT IN (SELECT FirstName FROM EmployeeUSA);

-- Way - 2 ( Using Join to achieve EXCEPT )
SELECT t1.* FROM EmployeeUK AS t1
LEFT JOIN EmployeeUSA AS t2 ON 
    t1.FirstName=t2.FirstName
    AND t1.LastName=t2.LastName
    AND t1.Gender=t2.Gender
    AND t1.Department=t2.Department
WHERE t2.EmployeeId IS NULL;

-- -------------------------------------------------------

###### INTERSECT Operator in MySQL (Common values in both tables)

/* The INTERSECT operator is used to combine two result sets and returns the data which are common in both the result se 
    Syntax of INTERSECT operator

Syntax of EXCEPT Operator
SELECT select_list1 
FROM table_name1
INTERSECT 
SELECT select_list2 
FROM table_name2;
  */

##### INTERSECT Operator  -- NOT SUPPORTED in MySQL --  
--  We can achieve the INTERSECT Operator functionality in MySQL using the following ways.

-- WAY - 1  ( Using IN Operator to achieve INTERSECT )
SELECT * FROM EmployeeUK
WHERE FirstName IN (SELECT FirstName FROM EmployeeUSA);

-- WAY - 2 (  Using Join to achieve INTERSECT )
SELECT t1.* FROM EmployeeUK AS t1
INNER JOIN EmployeeUSA AS t2 ON 
    t1.FirstName=t2.FirstName
    AND t1.LastName=t2.LastName
    AND t1.Gender=t2.Gender
    AND t1.Department=t2.Department; 
    


