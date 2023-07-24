#####################  CONSTRAINTS IN MySQL ###################################
-- ***** CONSTRAINTS [SET OF RULES APPLIED FOR HAVING CONSISTANT(VALID) VALUES   
-- -------------------------------------

-- **PRIMARY KEY [UNIQUE + NOT NULL -- Only one primary key in a table - To identify the record uniquely)
-- **UNIQUE [ No duplicates, and allows one NOT NULLs)
-- **COMPOSITE KEY [Combination of more than one columns act as PRIMARY KEY]
-- **CANDIDATE KEY [Additional columns added with SUPER KEY column to identify the particular record]
-- **FOREIGN KEY - REFERENCES [Child table column which refers the parent table Primary key field]
-- **CHECK [To insists to enter only the valid value]
-- **DEFAULT [When no value is entered, default value is automatically taken] 
-- **NOT NULL [ Value must be entered - Should not be left null]

---------------------------------------------
--  Table Creation with constraints
CREATE DATABASE constr;
USE constr;

## EXAMPLE - 1
CREATE TABLE EmployeeCons1
(EID int PRIMARY KEY,
EName varchar(30) UNIQUE,
Gender varchar(10) CHECK (gender='Male' OR gender='Female'),
Age INT CHECK (Age>=18),
Designation varchar(20) DEFAULT 'Trainee',
Salary float CHECK (Salary between 20000 and 30000) );

INSERT INTO EmployeeCons1 VALUES(101,'DAVID','Male',54,'Manager',25000); -- Inserted
INSERT INTO EmployeeCons1(EID,EName,Gender,Age) VALUES(102,'SWEETY','Female',37); 
SELECT * FROM EmployeeCons1;

INSERT INTO EmployeeCons VALUES(101,'LILLY',54,'Accountant');  -- Error comes

ALTER TABLE employeeCons1
ADD CONSTRAINT Sal_Default  UNIQUE (SALARY);  

## EXAMPLE - 2
 -- Table Creation with constraints using explicit Constraint name
CREATE TABLE EmployeeCons2
(EID int ,
EName varchar(30) ,
Gender varchar(10) Constraint PEmpChkGen CHECK (gender='Male' OR gender='Female'),
Age INT Constraint PEmpChkAge CHECK (Age>=18),
Designation varchar(20) DEFAULT 'Trainee',
Salary float Constraint PEmp CHECK (Salary between 20000 and 30000),
    Constraint PEmpPKey  PRIMARY KEY (EID) , Constraint PEmpUniq UNIQUE(EName)) ;


## EXAMPLE - 3
CREATE TABLE IF NOT EXISTS newpublisher1
(pub_id varchar(8) ,
pub_name varchar(50),
pub_city varchar(25) ,          
country varchar(25) ,
country_office varchar(25) ,
no_of_branch int,          
estd date,
CHECK ((country='India' AND pub_city='Mumbai')            
OR (country='India' AND pub_city='New Delhi')) , 
PRIMARY KEY (pub_id) );


--  ---------------------------------------------------


######### NOT NULL ###############
/* If you update or insert NULL into a NOT NULL column, MySQL will issue an error.
It’s a good practice to have the NOT NULL constraint in every column of a table unless you have a good reason not to do so.

NULL value makes your queries more complicated because you have to use functions such as ISNULL(), IFNULL(), and NULLIF() for handling NULL.
*/

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);
INSERT INTO tasks(title ,start_date, end_date)
VALUES('Learn MySQL NOT NULL constraint', '2017-02-01','2017-02-02'),
      ('Check and update NOT NULL constraint to your database', '2017-02-01',NULL);

-- Checking null in WHERE clause
SELECT *  FROM tasks
WHERE end_date IS NULL;  

-- Update NULL value column with values 
UPDATE tasks 
SET end_date = start_date + 7
WHERE end_date IS NULL;

-- Select the values
SELECT * FROM tasks;

-- Change the cloumn using ALTER MODIFY command
ALTER TABLE tasks 
MODIFY end_date DATE NOT NULL;

-- Change the cloumn using ALTER CHANGE command
ALTER TABLE tasks 
CHANGE  end_date  end_date DATE NOT NULL;

DESCRIBE tasks;
 
 -- --------------------------------------------------------
 
 ############### PRIMARY KEY ####################################
 /* A primary key column often has the AUTO_INCREMENT attribute 
     that automatically generates a sequential integer whenever you insert a new row into the table.

  -- When you define a primary key for a table, MySQL automatically creates an index called PRIMARY.
 */
 
### Examples
-- Example - 1 : Creates a table named users whose primary key is the user_id column
CREATE TABLE users(
   user_id INT AUTO_INCREMENT PRIMARY KEY,
   username VARCHAR(40),
   password VARCHAR(25),
   email VARCHAR(40)
);

-- Example - 2 : Creates the roles table that has the PRIMARY KEY constraint as the table constraint
CREATE TABLE roles(
   role_id INT AUTO_INCREMENT,
   role_name VARCHAR(50),
   PRIMARY KEY(role_id)
);

-- Example - 3
CREATE TABLE user_roles(
   user_id INT,
   role_id INT,
   PRIMARY KEY(user_id,role_id),
   FOREIGN KEY(user_id) 
       REFERENCES users(user_id),
   FOREIGN KEY(role_id) 
       REFERENCES roles(role_id)
);

-- Define PRIMARY KEY constraints using ALTER TABLE
/* If a table, for some reasons, does not have a primary key, 
you can use the ALTER TABLEstatement to add a primary key to the table as follows:

ALTER TABLE table_name
ADD PRIMARY KEY(column_list);
*/

CREATE TABLE pkdemos(
   id INT,
   title VARCHAR(255) NOT NULL
);

-- PRIMARY KEY vs. UNIQUE KEY vs. KEY
/* 
 -- KEY is the synonym for INDEX.
    You use the KEY when you want to create an index for a column or 
    a set of columns that is not the part of a primary key or unique key.

 -- A UNIQUE index ensures that values in a column must be unique. 
    Unlike the PRIMARY index, MySQL allows NULL values in the UNIQUE index. 
    In addition, a table can have multiple UNIQUE indexes.

 -- Suppose that email and username of users in the users table must be unique. 
    To enforce thes rules, you can define UNIQUE indexes for the email and username columns
*/

-- Add a UNIQUE index for the username column
ALTER TABLE users
ADD UNIQUE INDEX username_unique (username ASC) ;

-- Add a UNIQUE index for the email column
ALTER TABLE users
ADD UNIQUE INDEX  email_unique (email ASC) ;

-- -----------------------------------------------------------------------

######################  MySQL FOREIGN KEY  ########################
/*
  -- A foreign key is a column or group of columns in a table that links to a column 
  or group of columns in another table. 
  -- The foreign key places constraints on data in the related tables, which allows MySQL to maintain referential integrity.

-- The foreign key on the column reportTo is known as a recursive or self-referencing foreign key.

-- MySQL FOREIGN KEY syntax (BASIC SYNTAX of defining a foreign key constraint in the CREATE TABLE or ALTER TABLE statement)

[CONSTRAINT constraint_name]   							-- Optional, if ommited MySQL automatically generates a name for the foreign key constraint.
FOREIGN KEY [foreign_key_name] (column_name, ...)  		-- The foreign key name is also optional and is generated automatically if you skip it.
REFERENCES parent_table(colunm_name,...)
[ON DELETE reference_option]
[ON UPDATE reference_option]

NOTE:
-- Secify how foreign key maintains the referential integrity between the child and parent tables by using the ON DELETE and ON UPDATE clauses. 
-- The reference_option determines action which MySQL will take when values in the parent key columns are deleted (ON DELETE) or updated (ON UPDATE).

-- MySQL has five reference options: CASCADE, SET NULL, NO ACTION, RESTRICT, and SET DEFAULT.

CASCADE: if a row from the parent table is deleted or updated, the values of the matching rows in the child table automatically deleted or updated.
SET NULL:  if a row from the parent table is deleted or updated, the values of the foreign key column (or columns) in the child table are set to NULL.
RESTRICT:  if a row from the parent table has a matching row in the child table, MySQL rejects deleting or updating rows in the parent table. (REJECT)
NO ACTION: is the same as RESTRICT.
SET DEFAULT: is recognized by the MySQL parser. However, this action is rejected by both InnoDB and NDB tables(NDB Cluster is the distributed database system underlying MySQL Cluster).

-- In fact, MySQL fully supports three actions: RESTRICT, CASCADE and SET NULL.
-- If you don’t specify the ON DELETE and ON UPDATE clause, the default action is RESTRICT.
*/
-- ------------------------------------------------------------------------------------
##### MySQL Foreign Key  ######
CREATE DATABASE fkdemo;
USE fkdemo;

-- RESTRICT & NO ACTION actions

-- create two tables categories and products:
CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
) ENGINE=INNODB;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
) ENGINE=INNODB;

## NOTE :: We don’t specify any ON UPDATE and ON DELETE clauses, the default action is RESTRICT for both update and delete operation.

#### Steps to illustrate the RESTRICT action.
-- 1) Insert two rows into the categories table:
INSERT INTO categories(categoryName)
VALUES  ('Smartphone'),  ('Smartwatch');

-- 2) Select data from the categories table:
SELECT * FROM categories;

-- 3) Insert a new row into the products table:
INSERT INTO products(productName, categoryId)
VALUES('iPhone',1);               -- It works because the categoryId 1 exists in the categories table.

-- 4) Attempt to insert a new row into the products table with a categoryId  value does not exist in the categories table
INSERT INTO products(productName, categoryId)
VALUES('iPad',3);                 -- Error comes, 3 is not in parent table
SELECT * FROM products;

-- 5) Update the value in the categoryId column in the categories table to 100:
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;       -- Cannot update the parent table PKEY value

-- ---------------------------------------------------------------
###### CASCADE action ####### ----------------------

-- Steps to illustrate how ON UPDATE CASCADE and ON DELETE CASCADE actions work.
-- 1) Drop the products table:

DROP TABLE products;
-- 2) Create the products table with the ON UPDATE CASCADE and ON DELETE CASCADE options for the foreign key:

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (categoryId) REFERENCES categories(categoryId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=INNODB;

-- 3) Insert four rows into the products table:
INSERT INTO products(productName, categoryId)
VALUES
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

-- 4) Select data from the products table
SELECT * FROM products;

-- ---------------------------------------------------------------
-- 5) Update categoryId 1 to 100 in the categories table:
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;       -- Working because ON UPDATE CASCADE IS GIVEN

-- 6 & 7) Verify the update: Get data from the categories & products table
SELECT * FROM categories;

SELECT * FROM products;     -- Two rows with value 1 in the categoryId column of the products table were automatically updated to 100 because of the ON UPDATE CASCADE action.

-- 8) Delete categoryId 2 from the categories table:

DELETE FROM categories
WHERE categoryId = 2;

-- 9) Verify the deletion:  Display vategories table values
SELECT * FROM categories;

-- 10) Check the products table
SELECT * FROM products;

-- All products with categoryId 2 from the products table were automatically deleted because of the ON DELETE CASCADE action.

-- -------------------------------------------------------------------------

####### SET NULL action   #######
-- These steps illustrate how the ON UPDATE SET NULL and ON DELETE SET NULL actions work.
-- 1) Drop both categories and products tables:
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;

-- 2) Create the categories and products tables:
CREATE TABLE categories(
    categoryId INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(100) NOT NULL
)ENGINE=INNODB;

CREATE TABLE products(
    productId INT AUTO_INCREMENT PRIMARY KEY,
    productName varchar(100) not null,
    categoryId INT,
    CONSTRAINT fk_category
    FOREIGN KEY (categoryId) 
        REFERENCES categories(categoryId)
        ON UPDATE SET NULL
        ON DELETE SET NULL 
)ENGINE=INNODB;

-- NOTE:: The foreign key in the products table changed to ON UPDATE SET NULL and ON DELETE SET NULL options.

-- 3) Insert rows into the categories table:
INSERT INTO categories(categoryName)
VALUES  ('Smartphone'),  ('Smartwatch');

-- 4) Insert rows into the products table:
INSERT INTO products(productName, categoryId)
VALUES  
    ('iPhone', 1), 
    ('Galaxy Note',1),
    ('Apple Watch',2),
    ('Samsung Galary Watch',2);

-- 5) Update categoryId from 1 to 100 in the categories table:
UPDATE categories
SET categoryId = 100
WHERE categoryId = 1;

-- 6) Verify the update: Select data from the categories & products tables:
SELECT * FROM categories;
SELECT * FROM products;      -- The rows with the categoryId 1 in the products table were automatically set to NULL due to the ON UPDATE SET NULL action.

-- 7) Delete the categoryId 2 from the categories table:
DELETE FROM categories 
	WHERE categoryId = 2;

-- 8) Check the products table:
SELECT * FROM products;

-- NOTE:: The values in the categoryId column of the rows with categoryId 2 in the products table were automatically set to NULL due to the ON DELETE SET NULL action.

-- -------------------------------------------------------------

####### Drop MySQL foreign key constraints

-- To drop a foreign key constraint, you use the ALTER TABLE statement:
## WAY - 1
ALTER TABLE products 
DROP FOREIGN KEY fk_category;

## WAY - 2
ALTER TABLE products
DROP CONSTRAINT fk_category;

-- To obtain the generated constraint name of a table, you use the SHOW CREATE TABLE statement:
SHOW CREATE TABLE categories;
SHOW CREATE TABLE products;

-- Statemwnt To Drop the foreign key constraint of the products table:
ALTER TABLE products 
DROP FOREIGN KEY fk_category;

ALTER TABLE products 
DROP CONSTRAINT fk_category;

-- To view the changes in the constraints in the table
SHOW CREATE TABLE products;

### DISABLE / ENABLE FOREIGN KEY - Temporirily  #### 
-- To Disabling foreign key checks
-- Sometimes, it is very useful to disable foreign key checks e.g., when you import data from a CSV file into a table.
--  If you don’t disable foreign key checks, you have to load data into a proper order 
-- i.e., you have to load data into parent tables first and then child tables, which can be tedious. 
-- However, if you disable the foreign key checks, you can load data into tables in any order.

## WAY - 1  (To enable / enable foreign keys accross all DBs and Tables)
SET foreign_key_checks = 0;     -- To Disable foreign key 
SET foreign_key_checks = 1;   -- TO Eable Foreign key 

## WAY - 2 -- Permanently ( To specific tables)
ALTER TABLE table_name DISABLE KEYS;
ALTER TABLE table_name ENABLE KEYS;

/* USING ALTER Command  */
/*
ALTER TABLE table_name
  ADD FOREIGN KEY (table_id)
        REFERENCES other_table_name(Pkey_id)
        ON DELETE SET NULL;
*/


/* #### OTHER WAYS TO ADD / DROP KEYS  -- Permanently ( To specific tables) ###
ALTER TABLE table_name
ADD CONSTRAINT  nn categories(category_name) DEFAULT 'ELECTRONICS' ;
*/
## Example
ALTER TABLE products
ADD COLUMN quantity INT ; 

ALTER TABLE products
ADD CONSTRAINT CHK CHECK (QUANTITY > 0);

ALTER TABLE products
ADD CONSTRAINT CHK1 UNIQUE (productname);

describe products;
SHOW CREATE TABLE products;

-- ------------------------------------------------------------------------

  