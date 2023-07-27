/*  ----------------- CURSORS  and  ACCESS CONTROL  -----------------
  ########################   CURSORS   ########################## 
###### MySQL cursor
*** To handle a result set inside a stored procedure, we use a cursor.
	* A cursor allows you to iterate a set of rows returned by a query and process each row individually.
    * You can use MySQL cursors in stored procedures, stored functions, and triggers.
	* MySQL cursor is read-only, non-scrollable and asensitive.
		* Read-only: you cannot update data in the underlying table through the cursor.
		* Non-scrollable: you can only fetch rows in the order determined by the SELECT statement. You cannot fetch rows in the reversed order.
			In addition, you cannot skip rows or jump to a specific row in the result set.
		* Asensitive: there are two kinds of cursors: asensitive cursor and insensitive cursor.
			An asensitive cursor points to the actual data, whereas an insensitive cursor uses a temporary copy of the data.
            An asensitive cursor performs faster than an insensitive cursor because it does not have to make a temporary copy of data. 
            However, any change that made to the data from other connections will affect the data that is being used by an asensitive cursor,
				therefore, it is safer if you do not update the data that is being used by an asensitive cursor. 
		* MySQL cursor is asensitive.
	

*** Working with MySQL cursor
	1. Declare a cursor by using the DECLARE statement:
			DECLARE cursor_name CURSOR FOR SELECT_statement;
		NOTE: The cursor declaration must be after any variable declaration.
			If you declare a cursor before the variable declarations, MySQL will issue an error. A cursor must always associate with a SELECT statement.
	2. Open the cursor by using the OPEN statement. The OPEN statement initializes the result set for the cursor, 
			OPEN cursor_name;
	3. Use the FETCH statement to retrieve the next row pointed by the cursor and move the cursor to the next row in the result set.
			FETCH cursor_name INTO variables list;
	4. Check if there is any row available before fetching it.
	5. Deactivate the cursor and release the memory associated with it  using the CLOSE statement:
			CLOSE cursor_name;
		NOTE: It is a good practice to always close a cursor when it is no longer used.

*** Point to Remember: 
	* When working with MySQL cursor, you must also declare a NOT FOUND handler to handle the situation when the cursor could not find any row.
	* Because each time you call the FETCH statement, the cursor attempts to read the next row in the result set. 
		When the cursor reaches the end of the result set, it will not be able to get the data, and a condition is raised. The handler is used to handle this condition.
	* To declare a NOT FOUND handler, you use the following syntax:
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	NOTE: The finished is a variable to indicate that the cursor has reached the end of the result set.
		Notice that the handler declaration must appear after variable and cursor declaration inside the stored procedures.
        
        
	# ###########################################################################################################
*/

###### Example: 1 - Illustration
/*
-- 1. Declare some variables, a cursor for looping over the emails of employees, and a NOT FOUND handler:
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE emailAddress varchar(100) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curEmail 
		CURSOR FOR 
			SELECT email FROM employees;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;
-- -----------------

-- 2. Open the cursor by using the OPEN statement:
		OPEN curEmail;
-- -----------------

-- 3. Iterate the email list, and concatenate all emails where each email is separated by a semicolon(;):
	  -- -- Inside the loop, we used the finished variable to check if there is an email in the list to terminate the loop.
       getEmail: LOOP
		FETCH curEmail INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		SET emailList = CONCAT(emailAddress,";",emailList);
	END LOOP getEmail;
    
-- ---------------------------------

-- 4.  Close the cursor using the CLOSE statement:
		CLOSE email_cursor;
-- -----------------------------------------------------
*/

###### Example 1: createEmailList stored procedure with cusor
USE classicmodels;
select * from employees where reportsto=1621;
DROP procedure createEmailList;

DELIMITER $$
CREATE PROCEDURE createEmailList (
	IN repo int,
	OUT emailList varchar(200)
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE emailAddress varchar(40) DEFAULT "";
    DECLARE mailAdd varchar(400) DEFAULT "";

	-- declare cursor for employee email
	DEClARE curEmail 
		CURSOR FOR 
			SELECT email FROM employees where reportsto=repo;

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curEmail;

	getEmail: LOOP
		FETCH curEmail INTO emailAddress;
		IF finished = 1 THEN 
			LEAVE getEmail;
		END IF;
		-- build email list
		 SET mailAdd = CONCAT(mailAdd , "   " , emailAddress);
        -- SET emailList = emailAddress;
	END LOOP getEmail;
   -- SELECT emailList;
   SET emailList =  mailAdd;
	CLOSE curEmail;

END$$
DELIMITER ;

-- -------------------------------
-- Test the createEmailList stored procedure using the following script:
-- SET @emailList = "1"; 
SET @repo =1002;  -- 1002
CALL createEmailList(@repo, @emailList); 
SELECT @emailList;

-- SET @emailList = CONCAT( "Seeli" , "   " , "Arul");
-- SELECT @emaillist;
-- ---------------------------------------------------------------------------

/* 
################# MySQL Stored Object Access Control
	* In MySQL, stored routines (stored procedures and functions), triggers, events, and views execute within a security context which determines their privileges.
	* MySQL uses DEFINER and SQL SECURITY characteristics to control these privileges.
	*** The DEFINER attribute
		* When you define a stored routine such as a stored procedure or function, you can optionally specify the DEFINER attribute, which is the name of a MySQL account:
			CREATE [DEFINER=user] PROCEDURE spName(parameter_list)
			...

			CREATE [DEFINER=user] FUNCTION sfName()
			...

		NOTE: If you skip the DEFINER attribute, the default is the current user account.
		* You can specify any account in the DEFINER attribute if you have the SUPER or SET_USER_ID privilege. 
			If you specify the user account that does not exist, MySQL will issue a warning.
		* As of MySQL 8.0.16, you must have the SYSTEM_USER privilege in order to set the DEFINER attribute for a stored object to a user account that has the SYSTEM_USER privilege.

	*** The SQL SECURITY characteristic
		* Stored routines (stored procedures and functions) and views can include an SQL SECURITY clause with a value of DEFINER or INVOKER:
			CREATE [DEFINER=user] PROCEDURE spName(parameter_list)
			SQL SECURITY [DEFINER | INVOKER]
			...

			CREATE [DEFINER=user] FUNCTION sfName(parameter_list)
			SQL SECURITY [DEFINER | INVOKER]
			...

	*** SQL SECURITY DEFINER
		* When you use the SQL SECURITY DEFINER for a stored object, it will execute in definer security context with the privilege of the user specified in by the DEFINER attribute.
		* Note that the user that invokes the stored object (or invoker) may not have the same privilege as the definer.
		* In case the invoker has the least privilege and the definer has most privileges, the invoker can perform operations above its privilege within the stored object.

	*** SQL SECURITY INVOKER
		* If you use the SQL SECURITY INVOKER for a stored routine or view, it will operate within the privileges of the invoker.
		* The DEFINER attribute has no effect during object execution.
*/
	-- ****** Stored object access control example
	-- 1. Create a new database called testdb:
		CREATE DATABASE testdb;

	-- 2. The database testdb to work with:
		USE testdb;

	-- 3. Create a new table called messages:
		CREATE TABLE messages (
			id INT AUTO_INCREMENT,
			message VARCHAR(100) NOT NULL,
			PRIMARY KEY (id)
		);

	-- 4. Create a stored procedure that inserts a new row into the messages table:
		/* In this stored procedure, the definer is root@localhost that is the superuser which has all privileges.
			The SQL Security is set to the definer. It means that any user account which calls this stored procedure will execute with all privileges of the definer
				i.e., root@localhost user account.
		*/
			DELIMITER $$

			CREATE DEFINER = root@localhost PROCEDURE InsertMessage( 
				msg VARCHAR(100)
			)
			SQL SECURITY DEFINER
			BEGIN
				INSERT INTO messages(message)
				VALUES(msg);
			END$$

			DELIMITER ;

	-- 5. Create a new user named dev@localhost:
			CREATE USER dev@localhost  IDENTIFIED BY 'Abcd1234';

	-- 6. Grant the EXECUTE privilege to dev@localhost so that it can execute any stored procedure in the testdb database:
			GRANT EXECUTE ON testdb.*  TO dev@localhost;

	-- Log in to dev@localhost
	   show databases;
       use testdb;
	-- Call the InsertMessage procedure to insert a row into the messages table:
		call InsertMessage('Hello World');  -- The output will be     Query OK, 1 row affected (0.01 sec)
	-- Important Note::: Even though dev@localhost does not have any privilege on the messages table,
		-- it can insert a new row into that table successfully via the stored procedure
-- because the stored procedure executes in the security context of the root@localhost user account.
	-- Follow step 11 
	-- 7. Use the dev@localhost to log in to the MySQL Server:
			# mysql -u dev@localhost -p

	-- 8. Use the SHOW DATABASES to display the database that dev@localhost can access:
			# mysql> show databases; -- It shows information_schema as well as testdb             

	-- 9. Select the testdb database:
			# mysql> use testdb;

	-- 10. Call the InsertMessage procedure to insert a row into the messages table:
			# mysql> call InsertMessage('Hello World');  -- The output will be     Query OK, 1 row affected (0.01 sec)

	-- Important Note::: Even though dev@localhost does not have any privilege on the messages table,
		-- it can insert a new row into that table successfully via the stored procedure
        -- because the stored procedure executes in the security context of the root@localhost user account.

	-- 11. Go to the root’s session and create a stored procedure that updates the messages table:
		-- The UpdateMessage has the security context of INVOKER who will call this stored procedure.
			DELIMITER $$

			CREATE DEFINER=root@localhost 
			PROCEDURE UpdateMessage( 
				msgId INT,
				msg VARCHAR(100)
			)
			SQL SECURITY INVOKER
			BEGIN
				UPDATE messages
				SET message = msg
				WHERE id = msgId;
			END$$

			DELIMITER ;
            -- Call Stored procedure 
	call UpdateMessage(1,'Good Bye');
	-- 12. Go to the dev@localhost‘s session and call the UpdateMessage() stored procedure:
			# mysql> call UpdateMessage(1,'Good Bye');
	-- Important Note: 
		-- This time the UpdateMessage() stored procedure executes with the privileges of the caller which is dev@localhost.
		-- Because dev@localhost does not have any privileges on the messages table, MySQL issues an error and rejects the update:
		-- ERROR 1142 (42000): UPDATE command denied to user 'dev'@'localhost' for table 'messages'
        
        



