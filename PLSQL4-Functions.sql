################# STORED FUNCTIONS ####################
/* 
	* A stored function is a special kind stored program that returns a single value after the calculations/Formula/business logic. 
	* Different from a stored procedure, you can use a stored function in SQL statements wherever an expression is used. 
    * This helps improve the readability and maintainability of the procedural code.

	*** MySQL CREATE FUNCTION syntax
			DELIMITER $$

			CREATE FUNCTION function_name(
				param1,
				param2,…
			)
			RETURNS datatype
			[NOT] DETERMINISTIC
			BEGIN
			 -- statements
			END $$

			DELIMITER ;

	NOTE: * Specify if a function is deterministic or not using the DETERMINISTIC keyword, in the function
		  * A deterministic function always returns the same result for the same input parameters 
          * A non-deterministic function returns different results for the same input parameters(By Default).

		* Write the code in the body of the stored function in the BEGIN END block. Inside the body section, you need to specify at least one RETURN statement. 
        The RETURN statement returns a value to the calling programs. Whenever the RETURN statement is reached, the execution of the stored function is terminated immediately.
###########################################################3
  */
  ###### Example 1:
	 /* * MySQL CREATE FUNCTION example
		* Let’s take the example of creating a stored function. We will use the customers table in the sample database for the demonstration.
		* The following CREATE FUNCTION statement creates a function that returns the customer level based on credit:
      */
      USE classicmodels;
      DROP FUNCTION CustomerLevel;
			DELIMITER $$

			CREATE FUNCTION CustomerLevel(
				credit DECIMAL(10,2)
			) 
			RETURNS VARCHAR(20)
			DETERMINISTIC
			BEGIN
				DECLARE customerLevel VARCHAR(20);

				IF credit > 50000 THEN
					SET customerLevel = 'PLATINUM';
				ELSEIF (credit <= 50000 AND 
						credit >= 10000) THEN
					SET customerLevel = 'GOLD';
				ELSEIF credit < 10000 THEN
					SET customerLevel = 'SILVER';
				ELSE
                    SET customerLevel = 'WAITING FOR APPROVAL';
				END IF;
				-- return the customer level
				RETURN (customerLevel);
			END$$
			DELIMITER ;
 -- -------------------           

-- NOTE: Once the function is created, you can view it in MySQL Workbench under the Functions section:
		SHOW FUNCTION STATUS  WHERE db = 'classicmodels';   -- view all stored functions in the current classicmodels database by using the SHOW FUNCTION STATUS
-- ------------------
-- Calling a stored function in an SQL statement
   --  NOTE : The following SQL statement uses the CustomerLevel stored function:
        SET @creditLimit := 30000;
			SELECT 
				customerName, 
				CustomerLevel(creditLimit)
			FROM
				customers
			ORDER BY 
				customerName;    


##### Calling a stored function in a stored procedure
-- The following statement creates a new stored procedure that calls the CustomerLevel() stored function:

DROP PROCEDURE GetCustomerLevel;
SHOW WARNINGS;
DROP FUNCTION IF EXISTS GetCustomerLevel;

DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  customerNo INT,  
    OUT customerLevel VARCHAR(20)
)
BEGIN
	DECLARE credit DEC(10,2) DEFAULT 0;
    
    -- get credit limit of a customer
    SELECT 
		creditLimit 
	INTO credit
    FROM customers
    WHERE 
		customerNumber = customerNo;
    
    -- call the function 
    SET customerLevel = CustomerLevel(credit);
END$$

DELIMITER ;

CALL GetCustomerLevel(103,@customerLevel);  --  Calls the GetCustomerLevel() stored procedure

SELECT @customerLevel;   -- Displays the result

Select * from customers;
-- NOTE: It’s important to notice that if a stored function contains SQL statements that query data from tables, then you should not use it in other SQL statements; 
		 -- otherwise, the stored function will slow down the speed of the query.
		
-- ---------------------------------------------------------------------

###### Listing stored functions using SHOW FUNCTION STATUS statement

SHOW FUNCTION STATUS ;
-- [LIKE 'pattern' | WHERE search_condition];


SHOW FUNCTION STATUS;   -- Displays all the fetails anout the stored function

-- NOTE: SHOW FUNCTION STATUS only shows the function that you have a privilege to access.

-- TO Show stored functions in a particular database, you can use a WHERE clause 
/*
SHOW FUNCTION STATUS 
WHERE search_condition;
*/


SHOW FUNCTION STATUS 
WHERE db = 'classicmodels';

SHOW FUNCTION STATUS LIKE '%pattern%';   -- If you want to find the stored functions whose names contain a specific word, you can use the LIKE clause

SHOW FUNCTION STATUS LIKE '%Customer%';  -- shows all stored functions whose names contain the word Customer

##### Listing stored functions using the data dictionary
-- MySQL data dictionary has a routines table that stores information about the stored functions of all databases in the current MySQL server.

SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'FUNCTION'
        AND routine_schema = '<database_name>';   -- This query finds all stored functions in a particular database:


-- EXAMPLE:
SELECT 
    routine_name
FROM
    information_schema.routines
WHERE
    routine_type = 'FUNCTION'
        AND routine_schema = 'classicmodels';
-- ---------------------------------------------------------------