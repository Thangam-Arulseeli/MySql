###### SP - Part - 2
/* 

Error Handling in SP

*** When an error occurs inside a stored procedure, it is important to handle it appropriately,
		such as continuing or exiting the current code block’s execution, and issuing a meaningful error message.
*** MySQL provides an easy way to define handlers that handle from general conditions such as warnings or exceptions to specific conditions e.g., specific error codes.

*** Declaring a handler
	DECLARE action HANDLER FOR condition_value statement;

*** If a condition whose value matches the  condition_value , MySQL will execute the statement and continue or exit the current code block based on the action .
*** The action accepts one of the following values:
	CONTINUE :  the execution of the enclosing code block ( BEGIN … END ) continues.
	EXIT : the execution of the enclosing code block, where the handler is declared, terminates.
*** The  condition_value specifies a particular condition or a class of conditions that activate the handler. The  condition_value accepts one of the following values:

*** A MySQL error code.
* A standard SQLSTATE value. Or it can be an SQLWARNING , NOT FOUND or SQLEXCEPTION condition, which is shorthand for the class of SQLSTATE values. 
* The NOT FOUND condition is used for a cursor or  SELECT INTO variable_list statement.
* A named condition associated with either a MySQL error code or SQLSTATE value.
* The statement could be a simple statement or a compound statement enclosing by the BEGIN and END keywords.

*** Example: 1 - Error handler sets the value of the  hasError variable to 1 and continue the execution if an SQLEXCEPTION occurs
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
	SET hasError = 1;

*** Example: 2 - The following handler rolls back the previous operations, issues an error message, and exit the current code block in case an error occurs. 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SELECT 'An error has occurred, operation rollbacked and the stored procedure was terminated';
	END;
NOTE: If you declare it inside the BEGIN END block of a stored procedure, it will terminate the stored procedure immediately.

*** Example: 3 - Error handler sets the value of the  RowNotFound variable to 1 and continues execution if there is no more row to fetch in case of a cursor or SELECT INTO statement:
		DECLARE CONTINUE HANDLER FOR NOT FOUND 
		SET RowNotFound = 1;

*** Example: 4 - If a duplicate key error occurs, the following handler issues an error message and continues execution.
		DECLARE CONTINUE HANDLER FOR 1062
		SELECT 'Error, duplicate key occurred';

***** NOTE:  
		*** MySQL handler precedence
			When we have multiple handlers that handle the same error, MySQL will call the most specific handler to handle the error first based on the following rules:

			1. An error always maps to a MySQL error code because in MySQL it is the most specific.
			2. An SQLSTATE may map to many MySQL error codes, therefore, it is less specific.
			3. An SQLEXCPETION or an SQLWARNING is the shorthand for a class of SQLSTATES values so it is the most generic.
			Based on the handler precedence rules,  MySQL Error Code handler, SQLSTATE handler and SQLEXCEPTION takes the first, second and third precedence.

-- ------------------
##### How to use SIGNAL  and RESIGNAL statements to raise error conditions inside stored procedures.    
***** MySQL SIGNAL statement
	 *** Use the SIGNAL statement to return an error or warning condition to the caller from a stored program e.g., stored procedure, stored function, trigger or event. 
     *** The SIGNAL  statement provides you with control over which information for returning such as value and message SQLSTATE.
     *** Syntax of the SIGNAL statement:
			SIGNAL SQLSTATE | condition_name;
			SET condition_information_item_name_1 = value_1,
				condition_information_item_name_1 = value_2, etc;
			
			* Following the SIGNAL keyword is a SQLSTATE value or a condition name declared by the  DECLARE CONDITION statement. 
            * Notice that the SIGNAL statement must always specify a SQLSTATE value or a named condition that defined with an  SQLSTATE value.

			* To provide the caller with information, you use the SET clause. If you want to return multiple condition information item names with values,
				you need to separate each name/value pair by a comma.
			* The  condition_information_item_name can be MESSAGE_TEXT, MYSQL_ERRORNO, CURSOR_NAME , etc.        

***** MySQL RESIGNAL statement
	  ***  Besides the SIGNAL  statement, MySQL also provides the RESIGNAL  statement used to raise a warning or error condition.
	  ***  The RESIGNAL  statement is similar to SIGNAL  statement in term of functionality and syntax, except that:
	  ***  You must use the RESIGNAL  statement within an error or warning handler, otherwise, you will get an error message saying that “RESIGNAL when the handler is not active”.
			Notice that you can use SIGNAL  statement anywhere inside a stored procedure.
	  *** You can omit all attributes of the RESIGNAL statement, even the SQLSTATE value.
	  *** If you use the RESIGNAL statement alone, all attributes are the same as the ones passed to the condition handler.
*****************************************************************************************************	*/

##### Example: 1: Error Handler in MySQL
-- 1. Creates a table  --  create a new table named SupplierProductsfor the demonstration: 
USE Example;
CREATE TABLE SupplierProducts (
    supplierId INT,
    productId INT,
    PRIMARY KEY (supplierId , productId)
);

-- 2. SP --  create a stored procedure that inserts product id and supplier id into the SupplierProducts table:
DELIMITER $$
CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
		SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

DELIMITER ;
-- -------
/*DECLARE EXIT HANDLER FOR 1062
BEGIN
    SELECT CONCAT('Duplicate key (',supplierId,',',productId,') occurred') AS message;
END; */

-- -------
CALL InsertSupplierProduct(1,1);
CALL InsertSupplierProduct(1,2);
CALL InsertSupplierProduct(1,3);

CALL InsertSupplierProduct(1,3);    -- Duplicate key (1,3) occurred -- Error message will come
-- NOTE: Because the handler is an EXIT handler, the above statement does not execute and SP is terminated
-- -------------

##### Example: 2::::: -- If  you change the EXIT in the handler declaration to CONTINUE , you will also get the number of products provided by the supplier:
#### Example: -- If  you change the EXIT in the handler declaration to CONTINUE , you will also get the number of products provided by the supplier:

DROP PROCEDURE IF EXISTS InsertSupplierProduct;

DELIMITER $$

CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- Continue if the duplicate key occurs
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
	SELECT CONCAT('Duplicate key (',inSupplierId,',',inProductId,') occurred') AS message;
    END;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

DELIMITER ;

-- ---------
CALL InsertSupplierProduct(1,3);  -- call the stored procedure again to see the effect of the CONTINUE handler:
-- Insert statement won't work, however the next SELECT query will be executed
-- -------------------------------------------------------------------------

##### Example: 3:::: SP has three handlers for handling error the stored procedure

DROP PROCEDURE IF EXISTS InsertSupplierProduct;

DELIMITER $$

CREATE PROCEDURE InsertSupplierProduct(
    IN inSupplierId INT, 
    IN inProductId INT
)
BEGIN
    -- exit if the duplicate key occurs
    DECLARE EXIT HANDLER FOR 1062 SELECT 'Duplicate keys error encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'SQLException encountered' Message; 
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SELECT 'SQLSTATE 23000' ErrorCode;
    
    -- insert a new row into the SupplierProducts
    INSERT INTO SupplierProducts(supplierId,productId)
    VALUES(inSupplierId,inProductId);
    
    -- return the products supplied by the supplier id
    SELECT COUNT(*) 
    FROM SupplierProducts
    WHERE supplierId = inSupplierId;
    
END$$

DELIMITER ;
-- -----------------
CALL InsertSupplierProduct(1,3);  -- call the stored procedure again to see the effect of the multiple handlers
-- MySQL error code handler is called.
-- ----------------------------------------------------------------

##### Example: 4::::   -- Using a named error condition
-- Let’s start with an error handler declaration.
DELIMITER $$

CREATE PROCEDURE TestProc()
BEGIN

    DECLARE EXIT HANDLER FOR 1146 
    SELECT 'Table does not exist.... Please create table first....' Message; 
        
    SELECT * FROM abc;
END$$

DELIMITER ;
-- ----------------
CALL TestProc();
SELECT * FROM abc;
-- -----------------------------------------------------------------
/* ### NOTE ######
	What does the number 1146 really mean? 
	Imagine you have stored procedures polluted with these numbers all over places; it will be difficult to understand and maintain the code.
	Fortunately, MySQL provides you with the DECLARE CONDITION statement that declares a named error condition, which associates with a condition.

	Syntax of the DECLARE CONDITION statement:
		DECLARE condition_name CONDITION FOR condition_value;
	The condition_value  can be a MySQL error code such as 1146 or a SQLSTATE value. The condition_value is represented by the condition_name .
	After the declaration, you can refer to condition_name instead of condition_value .

Some Error codes........................    
Error 1040: Too many connections. ...
Error 1045: Access denied. ...
Error 1064: Syntax error. ...
Error 1114: Table is full. ...
Error 2006: MySQL server connection closed. ...
Error 2008: Client ran out of memory. ...
Error 2013: Lost connection during query.
Error 1062: Duplicate key.
Error 1146: Table/Object doesn't exist
Error 1305: Procedure does not exist

Reference ..... https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html 
*/


##### Example: 5::::: -- Rewrite the above SP example

DROP PROCEDURE IF EXISTS TestProc;

DELIMITER $$

CREATE PROCEDURE TestProc()
BEGIN
    DECLARE TableNotFound CONDITION for 1146 ; 

    DECLARE EXIT HANDLER FOR TableNotFound 
	SELECT 'Please create table  first' Message; 
    SELECT * FROM abc;
END$$

DELIMITER ;

CALL TestProc ( );

-- Note: This code is more readable. Notice that the condition declaration must appear before handler or cursor declarations.
-- -----------------------------------------------

##### Example: 6:::: - The following stored procedure adds an order line item into an existing sales order. 
						-- It issues an error message if the order number does not exist.
		use classicmodels;
        Drop procedure AddOrderItem;
        select * from orders;
        DELIMITER $$

		CREATE PROCEDURE AddOrderItem(
						 in orderNo int,
					 in productCode varchar(45),
					 in qty int, 
					in price double, 
					in lineNo int , out result varchar(50))
		BEGIN
			DECLARE C INT;

			SELECT COUNT(orderNumber) INTO C
			FROM orders 
			WHERE orderNumber = orderNo;
			SELECT c ;
			-- check if orderNumber exists
			IF(C != 1) THEN 
				SIGNAL SQLSTATE '45000'   -- User defined exception
					SET MESSAGE_TEXT = 'Order No not found in orders table';
                 SET result := 'Checking - Failed';
			else
                SET result := 'Order details are found in orders table';
			END IF;
			
		END$$
        
        DELIMITER ;
        -- ------------------------
        CALL AddOrderItem(104251,'S10_1678',1,95.7,1, @result);
        select @result;
        -- ---
        /*First, it counts the orders with the input order number that we pass to the stored procedure.
		Second, if the number of order is not 1, it raises an error with  SQLSTATE 45000 along with an error message saying that order number does not exist in the orders table.
		Notice that 45000 is a generic SQLSTATE value that illustrates an unhandled user-defined exception.
		If we call the stored procedure  AddOrderItem() and pass a nonexistent order number, we will get an error message.
        */
        -- -------------------------------------------------
        
#### Example: 7:::: - SP changes the error message before issuing it to the caller. 
	USE sample;	
        DELIMITER $$

		CREATE PROCEDURE Divide(IN numerator INT, IN denominator INT, OUT result double)
		BEGIN
			DECLARE division_by_zero CONDITION FOR SQLSTATE '22012';

			DECLARE CONTINUE HANDLER FOR division_by_zero 
			RESIGNAL SET MESSAGE_TEXT = 'Division by zero / Denominator cannot be zero';
			-- 
			IF denominator = 0 THEN
				SIGNAL division_by_zero;
			ELSE
				SET result := numerator / denominator;
			END IF;
		END $$
        
		Delimiter ;
-- --------
CALL Divide(10,3,@result);
SELECT @result;
-- -----------------------------------------------------
##### Example: 8  --- SQLSTATE

DELIMITER $$
CREATE PROCEDURE ageCheck(age INT)
BEGIN
  DECLARE specialty CONDITION FOR SQLSTATE '45000';
  IF age <= 0 THEN
    SIGNAL SQLSTATE '01000' 
       SET MESSAGE_TEXT = 'Age can not be less than 0 - Error occured';
  ELSEIF age = 1 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Infant - An error occurred';
  ELSEIF age > 80 THEN
    SIGNAL specialty
      SET MESSAGE_TEXT = 'Age above 80 - An error occurred';
  ELSE
   /* SIGNAL SQLSTATE '01000'
      SET MESSAGE_TEXT = 'A warning occurred', MYSQL_ERRNO = 1000; */
 
 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Middle age value', MYSQL_ERRNO = 1001;  
  END IF;
END $$
DELIMITER ;

-- -----------------------------------------------
-- Call to the procedure
CALL ageCheck(0);   -- 

DROP PROCEDURE ageCheck;

-- ------------------------------------------------
##### Example 8.1::: If the SIGNAL statement indicates a particular SQLSTATE value, that value is used to signal the condition specified

DELIMITER $$
CREATE PROCEDURE p1 (divisor INT, OUT result varchar(50))
BEGIN
  IF divisor = 0 THEN
    SIGNAL SQLSTATE '22012';
  ELSE
     SET result := 'No Error in Code';
  END IF;
END $$
DELIMITER ;
-- ----------
CALL p1(0, @result);
SELECT @result;

-- -----------------------------------------------------------
##### Example 8.2::::  If the SIGNAL statement uses a named condition, the condition must be declared in some scope that applies to the SIGNAL statement, 
						-- and must be defined using an SQLSTATE value, not a MySQL error number. 
DELIMITER $$
CREATE PROCEDURE p2 (divisor INT)
BEGIN
  DECLARE divide_by_zero CONDITION FOR SQLSTATE '22012';
  IF divisor = 0 THEN
    SIGNAL divide_by_zero;
  END IF;
END;
DELIMITER ;
-- -----------------
CALL p2(0, @result);
SELECT @result;
-- ---------------------------------------------------
##### Example 8.3:::: f a condition with a given name is declared multiple times in different scopes, the declaration with the most local scope applies.
use mydatabase;
DELIMITER $$
CREATE PROCEDURE p3 (divisor INT)
BEGIN
  DECLARE my_error CONDITION FOR SQLSTATE '45000';
  IF divisor = 0 THEN
    BEGIN
      DECLARE my_error CONDITION FOR SQLSTATE '22012';
      SIGNAL my_error;
    END;
  END IF;
  SIGNAL my_error;
END$$
DELIMITER ;
-- -----------------------------------------
CALL p3(1);
SELECT @result;
-- -----------------------------------------
##### Example 8.4:::: 
/* CALL p() reaches the DROP TABLE statement. There is no table named no_such_table, so the error handler is activated. 
The error handler destroys the original error (“no such table”) and makes a new error with SQLSTATE '99999' and message An error occurred.
*/
DELIMITER &&
CREATE PROCEDURE p4 ()
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SIGNAL SQLSTATE VALUE '99999'
      SET MESSAGE_TEXT = 'An error occurred - Specified table is not exist';
  END;
  DROP TABLE no_such_table;
END &&
DELIMITER ;
-- ---------------
CALL p4();
-- --------------------------------------------------------------------
##### SHOW WARNINGS  
-- mysql>\w
-- Show warnings enabled;
Show warnings ;
SELECT 1/0;

-- Shows the warnings ----- 1 row in set, 1 warning (0.03 sec)
-- Warning (Code 1365): Division by 0
-- mysql> \w
-- Show warnings disabled.
-- ----------------
DROP TABLE IF EXISTS test.no_such_table;

SHOW WARNINGS ;
SELECT @@warning_count;
SHOW VARIABLES LIKE 'max_error_count';
-- -----------
SELECT @@warning_count;
-- SHOW WARNINGS [LIMIT [offset,] row_count]
SHOW COUNT(*) WARNINGS
-- ---------------------------------------------------------------------









        
				


