/* IMPORTANT NOTE::: 

When we use update statement with/without where clause, sometime the following error occurs::: 
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
					To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
		*** To AVOID IT, USE THE FOLLOWING 

WAY - 1:        
SET SQL_SAFE_UPDATES = 0;
   *** Then after update we may also set 
   SET SQL_SAFE_UPDATES = 1;

WAY - 2:
To permanently disable safe update mode in MySQL Workbench 8.0 you should do the following:
Go to Edit --> Preferences.
Click "SQL Editor" tab and uncheck "Safe Updates" (rejects UPDATEs and DELETEs with no restrictions) check box.
Then,
Query --> Reconnect to Server.
*/

########## TRIGGERS  ###################
/*
*** In MySQL, a trigger is a stored program invoked automatically in response to an event (DML STATEMENT) such as insert, update, or delete that occurs in the associated table.
		* For example, you can define a trigger that is invoked automatically before a new row is inserted into a table.
	*** MySQL supports triggers that are invoked in response to the INSERT, UPDATE or DELETE event.

	*** The SQL standard defines two types of triggers
		*** 1. Row-level triggers
			A row-level trigger is activated for each row that is inserted, updated, or deleted. 
			For example, if a table has 100 rows inserted, updated, or deleted, the trigger is automatically invoked 100 times for the 100 rows affected.
		*** 2. Statement-level triggers.
		  A statement-level trigger is executed once for each transaction regardless of how many rows are inserted, updated, or deleted.
	*** NOTE::: MySQL supports only row-level triggers. It doesn’t support statement-level triggers.

*** Advantages of triggers
	1. Provide another way to check the integrity of data.
	2. Handles errors from the database layer.
	3. Gives an alternative way to run scheduled tasks. 
		By using triggers, you don’t have to wait for the scheduled events to run because the triggers are invoked automatically 
        before or after a change is made to the data in a table.
	4. Useful for auditing the data changes in tables.
*** Disadvantages of triggers
	1. Can only provide extended validations, not all validations. For simple validations, you can use the NOT NULL, UNIQUE, CHECK and FOREIGN KEY constraints.
	2. Can be difficult to troubleshoot because they execute automatically in the database, which may not be visible to the client applications.
	3. May increase the overhead of the MySQL server.
    
***** BASIC SYNTAX
		CREATE TRIGGER trigger_name { BEFORE | AFTER} {INSERT | UPDATE| DELETE }
		ON table_name FOR EACH ROW
		trigger_body;
	* The trigger body can access the values of the column being affected by the DML statement.
    * To distinguish between the value of the columns BEFORE and AFTER the DML has fired, you use the NEW and OLD modifiers.
    * No - OLD modifiers in INSERT statement
    * NO - NEW modifiers in DELETE statement
    
    */
    -- --------------------------------------------------------------------------------
    
    ###### Example ########
    # Step 1 : -- Create a table employees_audit to keep the changes to the employees table
    USE sample;
    CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL);
    
    # Step 2: - create a BEFORE UPDATE trigger that is invoked before a change is made to the employees table.
    CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
    
 INSERT INTO employees_audit
 SET action = 'update',
     employeeNumber = OLD.employeeNumber,
     firstname = OLD.firstname,
     changedat = NOW();
    
-- ------
SHOW TRIGGERS;  -- Show all triggers in the current database 

# Step 3: - update a row in the employees table:
UPDATE employees 
SET 
    firstName = 'Phan'
WHERE
    employeeNumber = 1056; 

# Step 4: -- employees_audit table to check if the trigger was fired by the UPDATE statement
SELECT * FROM employees_audit;

-- ---------------
##### Drop the trigger 
 -- DROP TRIGGER [IF EXISTS] [schema_name.]trigger_name;
 DROP TRIGGER IF EXISTS sample.before_employee_update ;

-- ----------------------------------
-- Step - 1
CREATE TABLE billings (
    billingNo INT AUTO_INCREMENT,
    customerNo INT,
    billingDate DATE,
    amount DEC(10 , 2 ),
    PRIMARY KEY (billingNo)
);
-- Step 2: --  create a new trigger called BEFORE UPDATE that is associated with the billings table:
DELIMITER $$
CREATE TRIGGER before_billing_update 
    BEFORE UPDATE 
    ON billings FOR EACH ROW
BEGIN
    IF new.amount > old.amount * 10 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'New amount cannot be 10 times greater than the current amount.';
    END IF;
END$$    
DELIMITER ;
-- Step 3:  -- 
DROP TRIGGER before_billing_update;
SHOW TRIGGERS;
-- -----------------------------------------

##### Example for MySQL BEFORE INSERT trigger example

SET SQL_SAFE_UPDATES = 0; 

-- STEP 1:  Create a new table called WorkCenters:
DROP TABLE IF EXISTS WorkCenters;

CREATE TABLE WorkCenters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

-- STEP 2: -- create another table called WorkCenterStats that stores the summary of the capacity of the work centers:
DROP TABLE IF EXISTS WorkCenterStats;

CREATE TABLE WorkCenterStats(
    totalCapacity INT NOT NULL
);

-- STEP 3: -- Creating BEFORE INSERT trigger example
-- The following trigger updates the total capacity in the WorkCenterStats table before a new work center is inserted into the WorkCenter table:
DROP TRIGGER IF EXISTS before_workcenters_insert;
DELIMITER $$

CREATE TRIGGER before_workcenters_insert
BEFORE INSERT
ON WorkCenters FOR EACH ROW
BEGIN
    DECLARE rowcount INT;
    DECLARE tcapacity INT;
    
    SELECT COUNT(*) 
    INTO rowcount
    FROM WorkCenterStats;
    
    IF rowcount > 0 THEN
        UPDATE WorkCenterStats
        SET totalCapacity = totalCapacity + new.capacity;  
        -- select totalcapacity into tcapacity from WorkCenterStats;
       -- SET tcapacity = tcapacity +new.capacity;
        -- delete from WorkCenterStats;
      --  INSERT INTO WorkCenterStats(totalCapacity)
       --  VALUES(tcapacity +new.capacity);
    ELSE
        INSERT INTO WorkCenterStats(totalCapacity)
        VALUES(new.capacity);
    END IF; 

END $$

DELIMITER ;
-- ----------------------------
-- 1. Testing the MySQL BEFORE INSERT trigger
INSERT INTO WorkCenters(name, capacity)
VALUES('Mold Machine',100);    

-- 2. Query data from the WorkCenterStats table:
SELECT * FROM WorkCenters;
SELECT * FROM WorkCenterStats;    -- The trigger has been invoked and inserted a new row into the WorkCenterStats table.

-- 3. Insert a new work center:
INSERT INTO WorkCenters(name, capacity)
VALUES('Packing',200);

-- 4. Query data from the WorkCenterStats:
SELECT * FROM WorkCenters;
SELECT * FROM WorkCenterStats;
-- ----------------
-- Answer : The trigger has updated the total capacity from 100 to 200 as expected.
-- ---------------------------------------------------------------------------

###### Example for MySQL AFTER INSERT trigger 

-- 1. Create a new table called members:
 DROP TABLE IF EXISTS members;

CREATE TABLE members (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    birthDate DATE,
    PRIMARY KEY (id)
);

-- 2. Create another table called reminders that stores reminder messages to members.
DROP TABLE IF EXISTS reminders;

CREATE TABLE reminders (
    id INT AUTO_INCREMENT,
    memberId INT,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (id , memberId)
);

-- 3. Creating AFTER INSERT trigger example
-- The following statement creates an AFTER INSERT trigger that inserts a reminder into the reminders table if the birth date of the member is NULL.

DELIMITER $$

CREATE TRIGGER after_members_insert
AFTER INSERT
ON members FOR EACH ROW
BEGIN
    IF NEW.birthDate IS NULL THEN
        INSERT INTO reminders(memberId, message)
        VALUES(new.id,CONCAT('Hi ', NEW.name, ', Please update your date of birth.'));
    END IF;
END$$

DELIMITER ;
-- ------------------

-- Testing the MySQL AFTER INSERT trigger
-- 1. Insert two rows into the members table:

INSERT INTO members(name, email, birthDate)
VALUES
    ('John Daniel', 'john.doe@example.com', NULL),
    ('Jane Joseph', 'jane.doe@example.com','2000-01-01');

-- 2. Query data from the members table:
SELECT * FROM members;    

-- 3. Query data from reminders table:
SELECT * FROM reminders;    

-- MySQL AFTER INSERT Trigger Output
-- We inserted two rows into the members table. 
-- However, only the first row that has a birth date value NULL, therefore, the trigger inserted only one row into the reminders table.
-- -----------------------------------------------------------------------------------

######## MySQL BEFORE UPDATE trigger example
-- 1. Create a new table called sales to store sales volumes:
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    id INT AUTO_INCREMENT,
    product VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    fiscalYear SMALLINT NOT NULL,
    fiscalMonth TINYINT NOT NULL,
    CHECK(fiscalMonth >= 1 AND fiscalMonth <= 12),
    CHECK(fiscalYear BETWEEN 2000 and 2050),
    CHECK (quantity >=0),
    UNIQUE(product, fiscalYear, fiscalMonth),
    PRIMARY KEY(id)
);

-- 2. Insert some rows into the sales table:
INSERT INTO sales(product, quantity, fiscalYear, fiscalMonth)
VALUES
    ('2003 Harley-Davidson Eagle Drag Bike',120, 2020,1),
    ('1969 Corvair Monza', 150,2020,1),
    ('1970 Plymouth Hemi Cuda', 200,2020,1);

-- 3. Query data from the sales table to verify the insert:
SELECT * FROM sales;

-- 4. Create trigger for BEFORE UPDATE 
	-- When the updated new quantity value is more than 3 times of the old quantity value, user defined error message is set using SIGNAL SQLSTATE 
		--  and is displayed using SHOW ERRORS statement..... 
        
DELIMITER $$

CREATE TRIGGER before_sales_update
BEFORE UPDATE
ON sales FOR EACH ROW
BEGIN
    DECLARE errorMessage VARCHAR(255);
    SET errorMessage = CONCAT('The new quantity ',
                        NEW.quantity,
                        '  cannot be 3 times greater than the current quantity ',
                        OLD.quantity);
                        
    IF new.quantity > old.quantity * 3 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = errorMessage;
    END IF;
END $$

DELIMITER ;
-- ----------

-- Testing BEFORE UPDATE trigger
-- The trigger is automatically fired before an update event occurs for each row in the sales table.
-- If you update the value in the quantity column to a new value that is 3 times greater than the current value, the trigger raises an error and stops the update.

-- 1. The name of the trigger is before_sales_update specified in the CREATE TRIGGER clause:

-- 1. Update the quantity of the row with id 1 to 150:
UPDATE sales 
SET quantity = 150
WHERE id = 1;

-- It worked because the new quantity does not violate the rule.

-- 2. Query data from the sales table to verify the update:
SELECT * FROM sales;

-- 3. Update the quantity of the row with id 1 to 500:
UPDATE sales 
SET quantity = 500
WHERE id = 1;

-- MySQL issued this error:
-- Error Code: 1644. The new quantity 500 cannot be 3 times greater than the current quantity 150
-- (In this case, the trigger found that the new quantity caused a violation and raised an error)

-- 4. use the SHOW ERRORS to display the error:
SHOW ERRORS;
-- -----------------------------------------------------------------------------

######## MySQL AFTER UPDATE trigger example
-- 1. Create sales table
DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    id INT AUTO_INCREMENT,
    product VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    fiscalYear SMALLINT NOT NULL,
    fiscalMonth TINYINT NOT NULL,
    CHECK(fiscalMonth >= 1 AND fiscalMonth <= 12),
    CHECK(fiscalYear BETWEEN 2000 and 2050),
    CHECK (quantity >=0),
    UNIQUE(product, fiscalYear, fiscalMonth),
    PRIMARY KEY(id)
);

-- 2. Insert sample data into the Sales table:

INSERT INTO Sales(product, quantity, fiscalYear, fiscalMonth)
VALUES
    ('2001 Ferrari Enzo',140, 2021,1),
    ('1998 Chrysler Plymouth Prowler', 110,2021,1),
    ('1913 Ford Model T Speedster', 120,2021,1);

-- 3. Query data from the Sales table to display its contents:
SELECT * FROM Sales;

-- 4. Create a table that stores the changes in the quantity column from the sales table:
DROP TABLE IF EXISTS SalesChanges;

CREATE TABLE SalesChanges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    salesId INT,
    beforeQuantity INT,
    afterQuantity INT,
    changedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- 5. Creating AFTER UPDATE trigger example
-- The following statement creates an AFTER UPDATE trigger on the sales table:
-- If you update the value in the quantity column to a new value the trigger insert a new row to log the changes in the SalesChanges table.

DELIMITER $$

CREATE TRIGGER after_sales_update
AFTER UPDATE
ON sales FOR EACH ROW
BEGIN
    IF OLD.quantity <> new.quantity THEN
        INSERT INTO SalesChanges(salesId,beforeQuantity, afterQuantity)
        VALUES(old.id, old.quantity, new.quantity);
    END IF;
END$$

DELIMITER ;

-- This after_sales_update trigger is automatically fired before an update event occurs for each row in the sales table.
-- If you update the value in the quantity column to a new value the trigger insert a new row to log the changes in the SalesChanges table.

/* Use the IF-THEN statement inside the trigger body to check if the new value is not the same as the old one, then insert the changes into the SalesChanges table:
IF OLD.quantity <> new.quantity THEN
    INSERT INTO SalesChanges(salesId,beforeQuantity, afterQuantity)
    VALUES(old.id, old.quantity, new.quantity);
END IF;
*/
-- -------

-- Testing the MySQL AFTER UPDATE trigger
-- 1. Update the quantity of the row with id 1 to 350:
UPDATE Sales 
SET quantity = 350
WHERE id = 1;

-- 2. Query data from the SalesChanges table:
SELECT * FROM SalesChanges;

-- 3. Increase the sales quantity of all rows to 10%:
UPDATE Sales 
SET quantity = CAST(quantity * 1.1 AS UNSIGNED);

-- 4. Query data from the SalesChanges table:
SELECT * FROM SalesChanges;
SELECT * FROM Sales;
-- The trigger fired three times because of the updates of the three rows.
-- -----------------------------------------------------------------------------------

####### MySQL BEFORE DELETE trigger example

-- 1. Create a new table called Salaries that stores salary information of employees
DROP TABLE IF EXISTS Salaries;

CREATE TABLE Salaries (
    employeeNumber INT PRIMARY KEY,
    validFrom DATE NOT NULL,
    amount DEC(12 , 2 ) NOT NULL DEFAULT 0
);

-- 2. Insert some rows into the Salaries table:
INSERT INTO salaries(employeeNumber,validFrom,amount)
VALUES
    (1002,'2000-01-01',50000),
    (1056,'2000-01-01',60000),
    (1076,'2000-01-01',70000);

-- 3. Create a table that stores the deleted salary:
DROP TABLE IF EXISTS SalaryArchives;    

CREATE TABLE SalaryArchives (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employeeNumber INT ,
    validFrom DATE NOT NULL,
    amount DEC(12 , 2 ) NOT NULL DEFAULT 0,
    deletedAt TIMESTAMP DEFAULT NOW()
);

-- 4. The following BEFORE DELETE trigger inserts a new row into the SalaryArchives table before a row from the Salaries table is deleted.

DELIMITER $$

CREATE TRIGGER before_salaries_delete
BEFORE DELETE
ON salaries FOR EACH ROW
BEGIN
    INSERT INTO SalaryArchives(employeeNumber,validFrom,amount)
    VALUES(OLD.employeeNumber,OLD.validFrom,OLD.amount);
END$$    

DELIMITER ;
-- ------

-- Testing the MySQL BEFORE DELETE trigger
-- 1. Delete a row from the Salaries table:
DELETE FROM salaries 
WHERE employeeNumber = 1002;

-- 2. Query data from the SalaryArchives table:
SELECT * FROM SalaryArchives;    
-- The trigger was invoked and inserted a new row into the SalaryArchives table.

-- 3. Delete all rows from the Salaries table:
DELETE FROM salaries;

-- 4. Query data from the SalaryArchives table:
SELECT * FROM SalaryArchives;

-- The trigger was triggered twice because the DELETE statement deleted two rows from the Salaries table.
-- ----------------------------------------------------------------------------------------------------

########  MySQL AFTER DELETE trigger example
-- 1. Create a new table called Salaries:

DROP TABLE IF EXISTS Salaries;

CREATE TABLE Salaries (
    employeeNumber INT PRIMARY KEY,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0
);

-- 2. Insert some rows into the Salaries table:
INSERT INTO Salaries(employeeNumber,salary)
VALUES
    (1002,5000),
    (1056,7000),
    (1076,8000);

-- 3. Create another table called SalaryBudgets that stores the total of salaries from the Salaries table:
DROP TABLE IF EXISTS SalaryBudgets;

CREATE TABLE SalaryBudgets(
    total DECIMAL(15,2) NOT NULL
);

-- 4. Use the SUM() function to get the total salary from the Salaries table and insert it into the SalaryBudgets table:
INSERT INTO SalaryBudgets(total)
SELECT SUM(salary) 
FROM Salaries;

-- 5. Query data from the SalaryBudgets table:

SELECT * FROM SalaryBudgets;        

-- The following AFTER DELETE trigger updates the total salary in the SalaryBudgets table after a row is deleted from the Salaries table:

CREATE TRIGGER after_salaries_delete
AFTER DELETE
ON Salaries FOR EACH ROW
UPDATE SalaryBudgets 
SET total = total - old.salary;

-- NOTE: Inside the trigger body, we subtract deleted salary from the total salary.
-- ----------

-- --- Testing the MySQL AFTER DELETE trigger
-- 1. Delete a row from the Salaries table:
DELETE FROM Salaries WHERE employeeNumber = 1002;

-- 2. Query total salary from the SalaryBudgets table:
SELECT * FROM SalaryBudgets;    

-- As you can see from the output, the total is reduced by the deleted salary.

-- 3. Delete all rows from the salaries table:
DELETE FROM Salaries;

-- 4. Query the total from the SalaryBudgets table:
SELECT * FROM SalaryBudgets;    

-- The trigger updated the total to zero.
-- ------------------------------------------------------------------------------------------------

####### MySQL multiple triggers example
 -- We will use the products table in the sample database for the demonstration.
-- Suppose that you want to change the price of a product (column MSRP ) and log the old price in a separate table named PriceLogs .

-- 1. Create a new price_logs table using the following CREATE TABLE statement:
USE classicmodels;
DROP TABLE IF EXISTS PriceLogs; 
CREATE TABLE PriceLogs (
    id INT AUTO_INCREMENT,
    productCode VARCHAR(15) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    updated_at TIMESTAMP NOT NULL 
			DEFAULT CURRENT_TIMESTAMP 
            ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (productCode)
        REFERENCES products (productCode)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
describe products;
-- 2. Create a new trigger that activates when the BEFORE UPDATE event of the products table occurs:
DROP TRIGGER IF EXISTS before_products_update;
DELIMITER $$

CREATE TRIGGER before_products_update 
   BEFORE UPDATE ON products 
   FOR EACH ROW 
BEGIN
     IF OLD.msrp <> NEW.msrp THEN
         INSERT INTO PriceLOgs(productCode,price)
         VALUES(old.productCode,old.msrp);
     END IF;
END$$

DELIMITER ;

-- 3. check the price of the product S12_1099:
SELECT productCode, msrp 
FROM  products WHERE productCode = 'S12_1099';

-- 4. Change the price of a product using the following UPDATE statement:
UPDATE products
SET msrp = 200
WHERE productCode = 'S12_1099';

-- 5. Query data from the PriceLogs table:
SELECT * FROM PriceLogs;   -- It works as expected.

/* You want to log the user who changed the price. To achieve this, you can add an additional column to the PriceLogs table.
However, for the purpose of multiple triggers demonstration, we will create a new separate table to store the data of users who made the changes.
*/

-- 6. Create the UserChangeLogs table:
CREATE TABLE UserChangeLogs (
    id INT AUTO_INCREMENT,
    productCode VARCHAR(15) DEFAULT NULL,
    updatedAt TIMESTAMP NOT NULL 
	DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    updatedBy VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (productCode)
        REFERENCES products (productCode)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- 7. Create a BEFORE UPDATE trigger for the products table. This trigger activates after the before_products_update trigger.
DELIMITER $$

CREATE TRIGGER before_products_update_log_user
   BEFORE UPDATE ON products 
   FOR EACH ROW 
   FOLLOWS before_products_update
BEGIN
    IF OLD.msrp <> NEW.msrp THEN
	INSERT INTO 
            UserChangeLogs(productCode,updatedBy)
        VALUES
            (OLD.productCode,USER());
    END IF;
END$$

DELIMITER ;

-- 8. Let’s do a quick test.
--  Update the price of a product using the following UPDATE statement:
UPDATE products SET  msrp = 220
WHERE  productCode = 'S12_1099';

-- 9. Query data from both PriceLogs and UserChangeLogs tables:
SELECT * FROM PriceLogs;

-- MySQL Multiple Trigger Price Log 2
SELECT * FROM UserChangeLogs;

-- MySQL Multiple Trigger User Log
-- As you can see, both triggers were activated in the sequence as expected.

#### Information on trigger order
-- If you use the SHOW TRIGGERS statement to show the triggers, you will not see the order that triggers activate for the same event and action time.

SHOW TRIGGERS 
FROM classicmodels
WHERE `table` = 'products';

-- To find this information, you need to query the action_order column in the triggers table of the information_schema database as follows:

SELECT 
    trigger_name, 
    action_order
FROM
    information_schema.triggers
WHERE
    trigger_schema = 'classicmodels'
ORDER BY 
    event_object_table , 
    action_timing , 
    event_manipulation;

-- ----------------------------------------------------------------------------------------------

###### Introduction to MySQL SHOW TRIGGER statement
-- The SHOW TRIGGERS statement shows all triggers. The following illustrates the basic syntax of the SHOW TRIGGERS statement:
/*
 SHOW TRIGGERS
[{FROM | IN} database_name]
[LIKE 'pattern' | WHERE search_condition];
*/

SHOW TRIGGERS;   -- returns all triggers in all databases:

SHOW TRIGGERS FROM database_name;  -- To show all triggers in a specific database, [ Use FROM / IN clause to specify DB name ] 
SHOW TRIGGERS IN database_name;   -- Same ass previous query

-- To find triggers according to a pattern, you use the LIKE clause:
SHOW TRIGGERS LIKE 'pattern';

SHOW TRIGGERS FROM database_name LIKE 'pattern';

-- To find triggers that match a condition, you use the WHERE clause:
SHOW TRIGGERS WHERE search_condition;

SHOW TRIGGERS FROM database_name
WHERE search_condition;

-- --------------------------------------------------------------------------------------------
