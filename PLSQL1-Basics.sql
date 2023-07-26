/************* STOREED PROCEDURE   *******************/
/****** Intoduction  ********/
/* 1. Introduction
*** CREATE PROCEDURE statement creates a new stored procedure 
*** By definition, a stored procedure is a segment of declarative SQL statements stored inside the MySQL Server. 
*** Once you save the stored procedure, you can invoke it by using the CALL statement: CALL GetCustomers();
NOTE::: * The first time you invoke a stored procedure, MySQL looks up for the name in the database catalog, compiles the stored procedure’s code, 
			place it in a memory area known as a cache, and execute the stored procedure.
		* If you invoke the same stored procedure in the same session again, MySQL just executes the stored procedure from the cache without having to recompile it.
        * A stored procedure may contain control flow statements such as IF, CASE, and LOOP that allow you to implement the code in the procedural way.
		* A stored procedure can call other stored procedures or stored functions, which allows you to modulize your code.
MySQL stored procedures advantages
	* Reduce network traffic   ----  Because instead of sending multiple lengthy SQL statements, applications have to send only the name and parameters of stored procedures.
    * Centralize business logic in the database ---- business logic that is reusable by multiple applications
    * Make database more secure   ---- The database administrator can grant appropriate privileges to applications that only access specific stored procedures (without giving any privileges on the underlying tables)   
MySQL stored procedures disadvantages
	* Resource usages ---- the memory usage of every connection will increase substantially.
      Besides, overusing a large number of logical operations in the stored procedures will increase the CPU usage because the MySQL is not well-designed for logical operations.
	* Troubleshooting --- t’s difficult to debug stored procedures. MySQL does not provide any facilities to debug stored procedures like other enterprise database products such as Oracle and SQL Server.
    * Maintenances  ---- Developing and maintaining stored procedures often requires a specialized skill set that not all application developers possess. This may lead to problems in both application development and maintenance.

 ##### ---------------------------------------- 
*****  2. Changing the Delimiters
*** 	A MySQL client program such as MySQL Workbench or mysql program uses the delimiter (;) to separate statements and executes each statement separately.
***     If you use a MySQL client program to define a stored procedure that contains semicolon characters,
			the MySQL client program will not treat the whole stored procedure as a single statement, but many statements.
***  	Therefore, you must redefine the delimiter temporarily so that you can pass the whole stored procedure to the server as a single statement.
*** 	To redefine the default delimiter, you use the DELIMITER command:
***		DELIMITER delimiter_character
*** 	The delimiter_character may consist of a single character or multiple characters e.g., // or $$. However, you should avoid using the backslash (\) because it’s the escape character in MySQL.
*** 	For example, the following statement changes the current delimiter to //:   DELIMITER //

##### ------------------------------------------
***** 3. Declaring Variables
DECLARE x, y INT DEFAULT 0;
DECLARE totalSale DEC(10,2) DEFAULT 0.0;

***** Assigning variables

DECLARE total INT DEFAULT 0;
SET total = 10;
DECLARE productCount INT DEFAULT 0;

SELECT COUNT(*)  INTO productCount FROM products;

##### ----------------------------------------
***** 4. Variable scopes    ---  A variable has its own scope that defines its lifetime. 
	When you declare a variable inside the block BEGIN END, it will be out of scope if the END is reached.
	MySQL allows you to declare two or more variables that share the same name in different scopes. Because a variable is only effective in its scope.
NOTE::: A variable whose name begins with the @ sign is a session variable. It is available and accessible until the session ends.  

##### ------------------------------------------
******  5. MySQL stored procedure parameters
*** A parameter in a stored procedure has one of three modes: IN,OUT, or INOUT.
*** IN parameter  -- Input parameter (Default)
*** OUT parameters --- The value of an OUT parameter can be changed inside the stored procedure and its new value is passed back to the calling program.
*** INOUT parameters --- An INOUT  parameter is a combination of IN and OUT parameters.  (Same variable acts as INPUT & OUTPUT parmeter)

##### ---------------------------------------
6.1 Alter Stored Procedures ---  Alter the stored procedure using the MySQL Workbench wizard
-- Right click on Stored Procedure and Choose ALTER STORED PROCEDURE and change it 

6.2  Drop Stored Procedures  ---  Remove the stored procedures
DROP PROCEDURE GetEmployee;

#### -----------------------------------------
7. Listing stored procedures using SHOW PROCEDURE STATUS statement
   *** The SHOW PROCEDURE STATUS statement shows all characteristic of stored procedures including stored procedure names. 
		It returns stored procedures that you have a privilege to access.
        
	Example: SHOW PROCEDURE STATUS;

#### -------------------------------------------
 8. MySQL simple IF-THEN statement
 IF condition THEN 
   statements;
END IF;
 -- -----------
9. MySQL  IF-THEN-ELSE statement
IF condition THEN
   statements;
ELSE
   else-statements;
END IF;
-- -----------
10. MySQL IF-THEN-ELSEIF-ELSE statement
IF condition1 THEN
   statements1;
ELSEIF elseif-condition2 THEN
   elseif-statements2;
...
ELSE
   else-statements;
END IF;
-- -----------

11. MySQL CASE Statement   -- The CASE statements make the code more readable and efficient.
	*** The CASE statement has two forms: SimpleCASE and Searched CASE statements.
		11.1 Simple CASE statement    --- Compares a value with a set of distinct values.
		CASE case_value
		   WHEN when_value1 THEN statements
		   WHEN when_value2 THEN statements
		   ...
		   [ELSE else-statements]
		END CASE;


		11.2 To avoid the error when the  case_value does not equal any when_value, you can use an empty BEGIN END block in the ELSE clause as follows:
				CASE case_value
					WHEN when_value1 THEN ...
					WHEN when_value2 THEN ...
					ELSE 
						BEGIN
						END;
				END CASE;
                
                11.3. Searched CASE statement
					To perform more complex matches such as ranges, you use the searched CASE statement. 
                    The searched CASE statement is equivalent to the IF  statement, however, it’s much more readable than the IF statement.
						CASE
							WHEN search_condition1 THEN statements
							WHEN search_condition1 THEN statements
							...
							[ELSE else-statements]
						END CASE;
                        
-- --------------

12.1. Looping statements -- LOOP statement allows you to execute one or more statements repeatedly.
	*** Basic syntax of the LOOP statement:
			[begin_label:] LOOP
				statement_list
			END LOOP [end_label]

NOTE: *** The LOOP can have optional labels at the beginning and end of the block.
	  *** We terminate the loop when a condition is satisfied by using the LEAVE statement. [LEAVE statement is like BREAK statement]
      *** We can use the ITERATE statement to skip the current loop iteration and start a new iteration. [ITERATE is similar to the CONTINUE statement] 
 
 12.2. MySQL WHILE loop  -- The WHILE loop is a loop statement that executes a block of code repeatedly as long as a condition is true.
		*** Syntax::: 
				[begin_label:] WHILE search_condition DO
					statement_list
				END WHILE [end_label]

12.3. MySQL REPEAT statement  -----   The REPEAT statement executes one or more statements until a search condition is false. When condition is true, loop terminates.
		Basic SYNTAX:
				[begin_label:] REPEAT
					statement
				UNTIL search_condition
				END REPEAT [end_label]

12.4. MySQL LEAVE statement 	- 	 	The LEAVE statement exits the flow control that has a given label.
	 *** Basic syntax: 
		  LEAVE label;

	*** Example
		CREATE PROCEDURE sp_name()
		sp: BEGIN
			IF condition THEN
				LEAVE sp;
			END IF;
			-- other statement
		END$$
-- --------------
****************************************************************************   */
 
##### Example: 1  -- Example for simple stored procedure for getting the details from employee table
use mydatabase;
DELIMITER $$
CREATE PROCEDURE  GetEmployee()
BEGIN
	SELECT empid, empname, department, designation, salary 
	FROM employee ORDER BY EmpName;    
END$$

DELIMITER ;    -- Delimiter back to ;
-- -------
CALL GetEmployee();   -- Executing the stored procedure / Calling statement for the procedure
-- update employee set salary = 50000 where empid=2;
-- -------------------------------
##### Example: 2
-- Drop/Removing the stored procedure

 DROP PROCEDURE IF EXISTS GetEmployee;
 SHOW WARNINGS; -- To show the warnings if any......
-- ----------------------------

##### Example: 3   -- Changing the delimiter
DELIMITER ;
DELIMITER //
 -- USE mydatabase ;
SELECT * FROM employee ;
SELECT * FROM products //
DELIMITER ;
-- ---------------------------------

#####: Example: 4   --   Creating a stored procedure using the MySQL Workbench wizard
-- Right click on Stored Procedure and create -- GetProduct() procedure
-- Delimiters and other supporting things are automatically created  -- $$ is the default delimiter when we use wizard to create SP
-- Apply and execute by CALL GetProduct()
CALL GetProduct();
CALL getemploy('Tech');
-- -----------------------------

#####: Example: 5  --- SP with variable declaration and SELECT INTO statement
USE classicmodels;
DELIMITER $$

CREATE PROCEDURE GetTotalSalary()
BEGIN
	DECLARE TotalAmount INT DEFAULT 0;
    
    SELECT COUNT(*)  INTO TotalAmount FROM orders;
    SELECT TotalAmount AS 'Total Amount';
END$$

DELIMITER ;

CALL GetTotalSalary();
-- ---------------------------------------------------------------------------
### Example: Using SET Statement in MySQL
SET @MyCounter = 1;   -- (OR)   SET @MyCounter := 1;
SELECT @MyCounter;

### Example: Using SET Statement in MySQL
SET @a = 100;  
SET @b := 8;
SET @c := @a * @b;
SELECT @c 'Result' ;

-- ------------------------------------------------------------------------------
#####: Example: 6  ---    Passing the employee name to SP to select all details
DELIMITER //

CREATE PROCEDURE GetEmployeeByName( IN eName VARCHAR(30) )
BEGIN
	SELECT * 
 	FROM employee
	WHERE empName = eName;
END //

DELIMITER ;

call GetEmployeeByName('Helen');
Call GetEmployeeByName('James');
call  GetEmployeeByName();   -- Error

-- -----------------------------------------------------
##### Example: 7::: ---  SP with IN and OUT parameter  
use mydatabase;
DELIMITER $$

CREATE PROCEDURE GetBonusByName (
	IN  eName VARCHAR(30),
	OUT bonus float
)
BEGIN
	SELECT salary*25/100 INTO bonus 
	FROM employee
	WHERE EmpName = eName;
END$$

DELIMITER ;
    
CALL GetBonusByName('Helen',@bonus);
SELECT 'Bonus Amount = ' , @bonus;

SET ename := 'Helen';
CALL GetBonusByName('Helen',@bonus);
SELECT @bonus AS  Bonus_Amount;
-- --------------------------------------------

###### Example: 8:::  INOUT Parameter
DELIMITER $$

CREATE PROCEDURE SetCounter(
	INOUT counter INT,
    IN inc INT
)
BEGIN
	SET counter = counter + inc;
END$$

DELIMITER ;
-- -------

SET @counter = 1;
CALL SetCounter(@counter,1); -- 2
SELECT @counter;
CALL SetCounter(@counter,1); -- 3
SELECT @counter;
CALL SetCounter(@counter,5); -- 8
SELECT @counter; -- 8

-- -------------------------------------------------
##### Example: 9::: Listing stored procedures using SHOW PROCEDURE STATUS statement

SHOW PROCEDURE STATUS;   --  shows all stored procedure in the current MySQL server
SHOW PROCEDURE STATUS WHERE db = 'mydatabase';  -- lists all stored procedures in the mydatabase
-- SHOW PROCEDURE STATUS LIKE '%data%' ;    -- Finds stored procedures whose names contain a specific word, you can use the LIKE clause
SHOW PROCEDURE STATUS where db like '%data%' ; 
-- The routines table in the information_schema database contains all information on the stored procedures and stored functions of all databases in the current MySQL server.
SELECT 
    routine_name
FROM
    information_schema.routines    --  information_schema.employee
WHERE
    routine_type = 'PROCEDURE'
        AND routine_schema = 'mydatabase';

-- ------------------------------------------------
#### Example: 10:::: 

USE classicmodels; 
Select * from customers;
DROP PROCEDURE GetCustomerLevel;
DELIMITER $$
CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;

    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
	ELSE 
       SET pCustomerLevel = 'GOLD';
    END IF;
END$$

DELIMITER ;
-- -------------------------
-- Calling the SP with parameter
SET @CustNo = 103;
SET  @CustLevel ="";
CALL GetCustomerLevel(@CustNo, @CustLevel);
SELECT @CustNo as 'CUSTOMER NO' , @CustLevel as 'CUSTOMER CREDIT LEVEL';
 -- --------------------------------------------------
 ##### Example: 11::  --  IF - THEN in SP
 DELIMITER $$

CREATE PROCEDURE GetEmployeeLevel1(
    IN  pEmplyeeNumber INT, 
    OUT pEmployeeLevel  VARCHAR(20))
BEGIN
    DECLARE sal DECIMAL(10,2) DEFAULT 0;

    SELECT salary 
    INTO sal
    FROM employee
    WHERE EmpID = pEmplyeeNumber;

    IF salary > 50000 THEN
        SET pCustomerLevel = 'High Package';
    END IF;
END$$

DELIMITER ;
-- -----------
-- Executing the procedure 
CALL GetEmployeeLevel1(144, @level);
SELECT @level;
-- ------------------------------------------

 ##### Example: 12::  --  IF - THEN  - ELSE in SP
 DELIMITER $$

CREATE PROCEDURE GetEmployeeLevel2(
    IN  pEmplyeeNumber INT, 
    OUT pEmployeeLevel  VARCHAR(20))
BEGIN
    DECLARE sal DECIMAL(10,2) DEFAULT 0;

    SELECT salary 
    INTO sal
    FROM employee
    WHERE EmpID = pEmplyeeNumber;

    IF salary > 50000 THEN
        SET pCustomerLevel = 'High Package';
	ELSE 
         SET pCustomerLevel = 'NOT High Package';
    END IF;
END$$

DELIMITER ;
-- -----------
-- Executing the procedure 
CALL GetEmployeeLevel2(3, @level);
SELECT @level;
-- ------------------------------------------

 ##### Example: 13::  --  IF - THEN  - ELSEIF in SP
 DELIMITER $$

CREATE PROCEDURE GetEmployeeLevel3(
    IN  pEmplyeeNumber INT, 
    OUT pEmployeeLevel  VARCHAR(20))
BEGIN
    DECLARE sal DECIMAL(10,2) DEFAULT 0;

    SELECT salary 
    INTO sal
    FROM employee
    WHERE EmpID = pEmplyeeNumber;

    IF salary > 50000 THEN
        SET pEmployeeLevel = 'High Package';
	ELSEIF salary <= 50000 AND salary >= 30000  THEN
         SET pEmployeeLevel = 'Average Package';
	ELSE
		SET pEmployeeLevel = 'Low Package';
    END IF;
END$$

DELIMITER ;
-- -----------
-- Executing the procedure 
CALL GetEmployeeLevel3(1, @level);
SELECT @level;
-- ------------------------------------------

##### Example: 14::: --- Simple case Example
USE mydatabase;
select * from employee;
DELIMITER $$

CREATE PROCEDURE GetEmployeeBonus(
	IN  pEmpNo INT, 
	OUT pBonus int
)
BEGIN
    DECLARE empDept varchar(40);

SELECT  department INTO empDept FROM employee WHERE empID= pEmpNo;

    CASE empDept
		WHEN   "HR" THEN
		   SET pBonus = 2000;
		WHEN 'Tech' THEN
		   SET pBonus = 5000;
		ELSE
		   SET pbonus = 3000;
	END CASE;
END$$

DELIMITER ;
-- ------
CALL GetEmployeeBonus(3,@Bbonus);
SELECT @pBonus AS 'Incentives';
-- --------------------------------------------

##### Example: 15:::: -- Search case Example
DELIMITER $$

CREATE PROCEDURE GetExperienceStatus(
	IN pEmpNumber INT, 
    OUT pExpStatus VARCHAR(100)
)
BEGIN
	DECLARE Experience INT DEFAULT 0;
    DECLARE Depart varchar(20);
    SELECT DATEDIFF(Date, DOJ), department INTO Experience, Depart  
		FROM employee  WHERE Empid = pEmpNumber;
    
    CASE 
		WHEN Experience = 0 THEN 
			SET pExpStatus = 'New Joinee';
        WHEN Experience = 1 AND Depart ="Tech"  THEN
			SET pExpStatus = 'Trainee';
		WHEN Experience = 1 AND Depart = "HR" THEN
			SET pExpStatus = 'Fresher';
		WHEN (Experience > 1 AND Experience < 5) AND Depart = "Tech" THEN
			SET pExpStatus = 'Experienced';
		WHEN (Experience >= 5 ) AND Depart = "Tech" THEN
			SET pExpStatus = 'Highly Experienced';
		ELSE
			SET pExpStatus ="Worker";
	END CASE;	
END$$
DELIMITER ;
-- -------------
CALL GetExperienceStatus(3,@pExpStatus);
SELECT @pExpStatus;
-- ------------------------------------------------------

#### Example: 16:::: MySQL LOOP statement example 
-- SP to print 2,4,6,8,10

DROP PROCEDURE LoopDemo;

DELIMITER $$
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT;
	DECLARE str  VARCHAR(255);
        
	SET x = 1;
	SET str =  '';
        
	loop_label:  LOOP
		IF  x > 10 THEN 
			LEAVE  loop_label;
		END  IF;
            
		SET  x = x + 1;
		IF  (x mod 2) THEN
			ITERATE  loop_label;
		ELSE
			SET  str = CONCAT(str,x,',');
		END  IF;
	END LOOP;
	SELECT str;
END$$

DELIMITER ;
-- ----------------
CALL LoopDemo();
-- -------------------------------------------

##### Example: 17 ::::::  -- MySQL WHILE loop statement example
-- Creates a table Calendar
CREATE TABLE calendars(
    id INT AUTO_INCREMENT,
    fulldate DATE UNIQUE,
    day TINYINT NOT NULL,
    month TINYINT NOT NULL,
    quarter TINYINT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY(id)
);
-- ----
#### Creates a new stored procedure to insert a date into the calendars table:

DELIMITER $$

CREATE PROCEDURE InsertCalendar(dt DATE)
BEGIN
    INSERT INTO calendars(
        fulldate,
        day,
        month,
        quarter,
        year
    )
    VALUES(
        dt, 
        EXTRACT(DAY FROM dt),
        EXTRACT(MONTH FROM dt),
        EXTRACT(QUARTER FROM dt),
        EXTRACT(YEAR FROM dt)
    );
END$$

DELIMITER ;
-- ------------

#### create a new stored procedure LoadCalendars() that loads a number of days starting from a start date into the calendars table.
DELIMITER $$

CREATE PROCEDURE LoadCalendars(
    startDate DATE, 
    day INT
)
BEGIN
    
    DECLARE counter INT DEFAULT 1;
    DECLARE dt DATE DEFAULT startDate;

    WHILE counter <= day DO
        CALL InsertCalendar(dt);
        SET counter = counter + 1;
        SET dt = DATE_ADD(dt,INTERVAL 1 day);
    END WHILE;

END$$

DELIMITER ;
-- -----------------------
CALL LoadCalendars('2019-01-01',31);
-- OUTPUT:
-- --------------------------------------------------

##### Example: 18:::: Example for REPEAT loop [SP to concatenate from 1 to 9]
DELIMITER $$

CREATE PROCEDURE RepeatDemo()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE result VARCHAR(100) DEFAULT '';
    
    REPEAT
        SET result = CONCAT(result,counter,',');
        SET counter = counter + 1;
    UNTIL counter >= 10
    END REPEAT;
    
    -- display result
    SELECT result;
END$$

DELIMITER ;
-- -------------
CALL RepeatDemo();
-- ------------------------------------
###### EXample 18.1
DELIMITER //
CREATE PROCEDURE RepeatExample()
BEGIN
   DECLARE val INT;
   DECLARE squares INT;
   DECLARE res VARCHAR(100);
   SET val=1;
   SET squares=1;
   SET res = '';
   REPEAT
      SET squares = val*val;
      SET res = CONCAT(res, squares,',');
      SET val = val + 1;
   UNTIL val >= 10
   END REPEAT;
   SELECT res;
END//

DELIMITER ;
-- ------------------------
CALL RepeatExample();
-- -----------------------------------------------------------------
##### Example: 19:  Example for LEAVE (break) statement
DELIMITER $$

CREATE PROCEDURE CheckCredit(
    inCustomerNumber int
)
sp: BEGIN
    
    DECLARE customerCount INT;

    -- check if the customer exists
    SELECT 
        COUNT(*)
    INTO customerCount 
    FROM
        customers
    WHERE
        customerNumber = inCustomerNumber;
    
    -- if the customer does not exist, terminate
    -- the stored procedure
    IF customerCount = 0 THEN
        LEAVE sp;
    END IF;
    
    -- other logic
    -- ...
END$$

DELIMITER ;
-- ----------
CALL LeaveDemo(@result);
SELECT @result;
-- -----------------------------------------------

#####Example: 20 ::::







