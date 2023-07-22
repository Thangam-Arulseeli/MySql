###########  DDL Statements ############

-- ##### Data Base creation -----------------------------
create database Example;
CREATE DATABASE IF NOT EXISTS Example;    -- Worning will come if exists
-- ------------------------------------
SHOW DATABASES;     -- Shows all the databases
SHOW CREATE DATABASE Sample;  -- Shows only the specified DB

SHOW DATABASES LIKE "s%";  -- List the databases started with s

-- ------------------------------------
use Sample;    -- To make the specific DB as active
-- ------------------------------------
CREATE schema Testing;  -- COULDN'T CREATE SCHEMA & db OF SAME NAME, SINCE BOTH ARE = HERE 
CREATE schema Example;   -- It represents and creates DB only;

-- -------------------------------------
-- To drop Database / Schema
DROP DATABASE IF EXISTS Example;   
DROP SCHEMA IF EXISTS Example;
----------------------------------------------

-- Comment --------------------------------
-- Single line comment
# single line comment
/* Multi line
     Comment  */
-- ---------------------------------
 
-- ##### Table Creation -----------------------
use Example;
create table Employee(
EmpID int,
EmpName varchar(30),
Department varchar(20),
Designation varchar(20),
salary float);

-- Warning comes when we attempt to create same table again with IF NOT EXISTS clause
use Sample;
create table IF NOT EXISTS Employee (  
EmpID int,
EmpName varchar(30),
Department varchar(20),
Designation varchar(20),
salary float);

DESCRIBE Employee;   /* To display the structure of the table */ 
----------------------------------------------------------------------------

-- ######  Insert the rows ----------------------------------
insert into Employee values(1,'Hepsibha','HR','Manager',34000); -- Insert single row
insert into Employee values
(2,'Hamilton','Tech','Developer',23000),
(3,'Peter','HR','Asst',23000),
(4,'George','Tech','Designer',18000),
(5,'Helen','Tech','Tester',13000);  -- Insert multiple rows

select * from Employee;

/* Third highest salary from the employee table */
 select distinct salary from employee order by salary desc limit 2 , 1 ;     -- Way 1  (3rd highest salary)
 
 select salary  from employee where salary <ALL (select max(salary) from employee    
		where salary <ALL (select max(salary) from employee)) limit 1 ;       -- Way 2 (3rd highest salary)
        
-- -------------------------------------------------------------
-- ###### MySQL Sequence /*Check Auto increament */    
/*
-- MySQL does not provide any built-in function to create a sequence for a table's rows or columns. But we can generate it via SQL query
-- Creating a sequence in MySQL is by defining the column as AUTO_INCREMENT during table creation, which should be a primary key column.
-- We can create only one AUTO_INCREMENT column in each table, and the data type of this column is an integer.
-- The AUTO_INCREMENT column should also have either PRIMARY or UNIQUE KEY indexing.
-- The AUTO_INCREMENT column must contain NOT NULL However, MySQL automatically adds the NOT NULL constraint to the column implicitly 
    when we set the column as an AUTO_INCREMENT attribute.
*/
use Sample;     
create table Check_Auto2
(Id int auto_increment unique,
CName varchar(20));

insert into check_auto2 values(202,'Seelan');
insert into check_auto2(Cname) values('Banu');

delete from check_auto2 where id=202;

select * from check_auto2;
SELECT last_insert_id();  -- To get the last inserted auto_increment value [The last generated sequence is unique across sessions. ]
-- ----------------------------------------------------------

-- ######  Copy the structure of table into another table Using LIKE keyword --------------
CREATE TABLE Copy1 (
    id INT PRIMARY KEY auto_increment,
    cname varchar(20)
);

insert into Copy1(cname) values('Julia'),('Mano'),('Peter');
select * from Copy1;

-- ------------------------
CREATE TABLE Copy3 LIKE Copy1;   -- Table structure is created, No rows copied
Select * from Copy3;   -- Doesn't contain rows
describe copy3;
-- --------------------------------------------------- TABLE CREATED WITH RECORDS

create table IF NOT EXISTS Copy2
  as select * from Copy1;           -- Table is created based on the query given (Exising table with rows)
select * from copy2;       -- Contains rows
-- ---------------------------------------------------

-- ## Explicit Use of MySQL Storage Engine / Table type  --------- Default is InnoDB after MySQL V-5.5, before MyISAM 
CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE=INNODB;
DESCRIBE Employee;  --  To display the structure of the table

-- -----------------------------------------------------------

-- ###### MySQL ALTER TABLE – Rename table ######
/* Syntax - 1
ALTER TABLE table_name
RENAME TO new_table_name;

Syntax - 2   -- Move the table from one database to another database
RENAME TABLE [DB_Name].[Table1] TO New_DB_Name.Table1;
*/

Use Sample;
Describe Employee;
ALTER TABLE Copy1 
RENAME TO Copy10;     -- Employee table is changed as Employees

describe copy10;

select * from Employees;

RENAME TABLE example.Copy10 TO testdb1.copy1;  -- Rename and move the table form one database to another database

-- RENAME TABLE  testdb1.Emp To sample.Employees; -- To make it to original place 
-- ---------------------------------------------------

-- ##### ALTER TABLE Statement #######
-- ## Add a column to a table
/* ALTER TABLE table_name
   ADD new_column_name column_definition
    [FIRST | AFTER column_name]

NOTE:
    [FIRST | AFTER column_name]    --  By default new column is added at the last . Specifies the position of the new column.
FIRST – Indicated new column is first column
AFTER column_name – Specifies after which column new column should come.
*/

-- Add multiple columns to a table
/* ALTER TABLE table_name
    ADD new_column_name column_definition  [FIRST | AFTER column_name],
    ADD new_column_name column_definition  [FIRST | AFTER column_name],
    ...;
*/
Use Sample;
CREATE TABLE Person1 (
    id INT PRIMARY KEY auto_increment,
    age int
);

Describe Person1;

ALTER TABLE Person1
   ADD PName varchar(20) FIRST,
   ADD Address varchar(20) AFTER id;

Describe Person1;

-- ---------------------------------------------
-- ######## ALTER TABLE - MODIFY column

/* ALTER TABLE table_name
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],
    MODIFY column_name column_definition
    [ FIRST | AFTER column_name],  ...;   
*/
-- NOTE : We can move the field to another position/order

ALTER TABLE Person1
    MODIFY Pname varchar(30) Not null,
    MODIFY Address varchar(50) Not Null Default 'Coimbatore';

Describe Person1; 

-- -------------------------------------------------

-- ######  MySQL ALTER TABLE – Rename a column in a table
/* ALTER TABLE table_name
    CHANGE COLUMN original_name new_name column_definition
    [FIRST | AFTER column_name];
*/

ALTER TABLE PERSON1
CHANGE COLUMN address city varchar(5); 

insert into person1(pname, town, age) values ('Surya', 'Eral',12);


-- ----------------------------------------------

-- ###### MySQL ALTER TABLE – Drop a column
/* Syntax:
ALTER TABLE table_name
DROP [COLUMN] column_name;

-- Syntax to remove multiple columns
ALTER TABLE table_name
DROP COLUMN column_name_1,
DROP COLUMN column_name_2,
...;
*/

ALTER TABLE Person1
DROP COLUMN Age,
drop column town;

Describe Person1;

-- ---------------------------------------------------

-- ############## Temporary Tables ###########
-- The temporary tables could be very useful in some cases to keep temporary data. 
-- The most important thing that should be known for temporary tables is that they will be deleted when the current client session terminates.
-- NOTE: Temporary tables were added in the MySQL Version 3.23. If you use an older version of MySQL than 3.23,
         -- you cannot use the temporary tables, but you can use Heap Tables.
         
-- Example
CREATE TEMPORARY TABLE SalesSummary (
    product_name VARCHAR(50) NOT NULL, 
    total_sales DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    avg_unit_price DECIMAL(7,2) NOT NULL DEFAULT 0.00,
    total_units_sold INT UNSIGNED NOT NULL DEFAULT 0);
-- -----
INSERT INTO SalesSummary
   (product_name, total_sales, avg_unit_price, total_units_sold)
   VALUES ('cucumber', 100.25, 90, 2);
-- ------
SELECT * FROM SalesSummary;

DROP TABLE SalesSummary;  -- DROP Temporary table 
SELECT * FROM SalesSummary; 
-- -----------------------------------

-- -----------------------------------------------

-- ###### To change the database name
-- ALTER DATABASE Testing MODIFY NAME = Testing1 ;   -- Error
-- RENAME DATABASE Sample TO Sample1;     -- Error
-- ---------------------------------------------



 