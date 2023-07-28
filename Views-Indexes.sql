################# VIEWS #################
/*
***** Introduction to MySQL Views

*** By definition, a view is a named query stored in the database catalog. View is referred to as a virtual table.
*** View is the database object which contains only the structure of the table, not the data(records)
*** When the select statement on the view is called (view is executed) it gets the data fron the table(s) and display the result.
 
*** create View
		CREATE [OR REPLACE] VIEW [db_name.]view_name [(column_list)]
			AS  select-statement;
            
  *** Example:
		CREATE VIEW customerPayments
		AS 
		SELECT 
			customerName, 
			checkNumber, 
			paymentDate, 
			amount
		FROM
			customers
		INNER JOIN
			payments USING (customerNumber);

* Once you execute the CREATE VIEW statement, MySQL creates the view and stores the data in, and is in the database.
* Now, you can reference the view as a table in SQL statements. 
	SELECT * FROM customerPayments;

*** Note that a view does not physically store the data. When you issue the SELECT statement against the view,
	* MySQL executes the underlying query specified in the view’s definition and returns the result set. 
	* MySQL allows you to create a view based on a SELECT statement that retrieves data from one or more tables. 

	*** MySQL View - Important NOTE
	* In addition, MySQL even allows you to create a view that does not refer to any table. But you will rarely find this kind of view in practice.
	* You can create a view called daysofweek that return 7 days of a week by executing the following query:
	
    
	*** Advantages of MySQL Views
		1. Simplify complex query
		2. Make the business logic consistent
		3. Add extra security layers
			A table may expose a lot of data including sensitive data such as personal and banking information.
			By using views and privileges, you can limit which data users can access by exposing only the necessary data to them.
			To expose general information such as first name, last name, and gender to the General Administration (GA) department, you can create a view based on these columns and grant the users of the GA department to the view, not the entire table employees .
		4. Enable backward compatibility
In legacy systems, views can enable backward compatibility.

Suppose, you want to normalize a big table into many smaller ones. And you don’t want to impact the current applications that reference the table.
In this case, you can create a view whose name is the same as the table based on the new tables so that all applications can reference the view as if it were a table.
Note that a view and table cannot have the same name so you need to drop the table first before creating a view whose name is the same as the deleted table.

	Managing views in MySQL
		Create views – show you how to use the CREATE VIEW statement to create a new view in the database.
		Understand view processing algorithms – learn how MySQL process a view.
		Create updatable views – learn how to create updatable views.
		Create views with a WITH CHECK OPTION – ensure the consistency of views  using the WITH CHECK OPTION clause.
		LOCAL & CASCADED and WITH CHECK OPTION – specify the scope of the check with LOCAL and CASCADED options.
		Drop views – guide you on how to remove one or more existing views.
		Show views – provide ways to find views in a database.
		Rename views – change the name of a view to another.
   
-- ------------------------------
###### MySQL View Processing Algorithms
	*** The CREATE VIEW and ALTER VIEW statements have an optional clause: ALGORITHM. 
    ***The algorithm determines how MySQL process a view and can take one of three values MERGE, TEMPTABLE, and UNDEFINE.

	*** Syntax for CREATE VIEW statement with the ALGORITHM clause:
			CREATE [OR REPLACE][ALGORITHM = {MERGE | TEMPTABLE | UNDEFINED}] VIEW 
			   view_name[(column_list)]
				AS 
				   select-statement;
	*** MERGE
		* MySQL processes for MERGE view:
			1. Merge the input query with the SELECT statement in the view definition into a single query.
			2. Execute the combined query to return the result set.
		NOTE:  the combination of input query and the SELECT statement of the view definition into a single query is referred to as view resolution.

	*** TEMPTABLE
		* MySQL processes for TEMPTABLE view:
			1. Create a temporary table to store the result of the SELECT in the view definition.
			2. Execute the input query against the temporary table.
			NOTE: TEMPTABLE algorithm  is less efficient than the MERGE algorithm. TEMPTABLE views cannot be updatable.

	*** UNDEFINED (Default)
		* The UNDEFINED allows MySQL to choose either MERGE or TEMPTABLE. And MySQL prefers MERGE  over TEMPTABLE  if possible because MERGE is often more efficient than TEMPTABLE.
		* In addition, when you create a view with ALGORITHM = MERGE and MySQL can only process the view with a temporary table, MySQL automatically sets the algorithm to UNDEFINED and generates a warning.

	*** Introduction to MySQL updatable views
		* In MySQL, views are not only query-able but also updatable. We can provide INSERT/UPDATE/DELETE statement to the table through views
		* However, to create an updatable view, the SELECT statement must not contain any of the following clauses
			* Aggregate functions such as MIN, MAX, SUM, AVG, and COUNT.
			* DISTINCT, GROUP BY and HAVING clause.
			* UNION or UNION ALL clause.
			* Left join or outer join.
			* Subquery in the SELECT clause 
			* Reference to non-updatable view in the FROM clause.
			* Reference only to literal values.
			* Multiple references to any column of the base table.
			NOTE: If you create a view with the TEMPTABLE algorithm, you cannot update the view.
				  It is sometimes possible to create updatable views based on multiple tables using an inner join.


	*** Introduction to MySQL View & the WITH CHECK OPTION clause
		* Sometimes, you create a view to reveal the partial data of a table. 
        * However, a simple view is updatable therefore it is possible to update data which is not visible through the view. 
        * This update makes the view inconsistent. 
        * To ensure the consistency of the view, you use the WITH CHECK OPTION clause when you create or modify the view.

		* The WITH CHECK OPTION is an optional clause of the CREATE VIEW statement. 
        * The WITH CHECK OPTION prevents a view from updating or inserting rows that are not visible through it.
        * In other words, whenever you update or insert a row of the base tables through a view, 
          MySQL ensures that the insert or update operation is conformed with the definition of the view.

		* Syntax of the WITH CHECK OPTION clause.
				CREATE [OR REPLACE VIEW] view_name 
				AS
				  select_statement
				  WITH CHECK OPTION;

*/
-- -------------------------------------------------------------------------------------
use mydatabase;

create view emp_view1 as select empid, empname, doj, department, salary from employee where salary >30000;  -- WITH CHECK OPTION;
create view emp_view2 as select empid, empname, doj, department, salary from employee where salary >30000  WITH CHECK OPTION;

describe emp_view1;
describe emp_view2;

select * from emp_view1;
select * from emp_view2;


insert into emp_view1 values (1003, 'Prabhavathi', '2009-05-10', 'Tech', 25000);  --  Record inserted, since no check option(<25000)
insert into emp_view2 values (1003, 'Prabhavathi', '2009-05-10', 'Tech', 25000);  --  Record NOT inserted, because WITH CHECK OPTION (<25000)

########### Examples::::::
###### Example: 
		CREATE VIEW daysofweek (day) AS
			SELECT 'Mon' 
			UNION 
			SELECT 'Tue'
			UNION 
			SELECT 'Web'
			UNION 
			SELECT 'Thu'
			UNION 
			SELECT 'Fri'
			UNION 
			SELECT 'Sat'
			UNION 
			SELECT 'Sun';

SELECT * FROM daysofweek;
-- ------------------------------------------------
USE classicmodels;
DROP VIEW IF EXISTS salePerOrder;
###### Example 1: Creating a simple view
		CREATE VIEW salePerOrder AS
			SELECT 
				orderNumber, 
				SUM(quantityOrdered * priceEach) total
			FROM
				orderDetails
			GROUP by orderNumber
			ORDER BY total DESC;
    
    -- --------------------------
    ######  To display all the tables as well as views
			SHOW TABLES;   -- all tables as well as views in the classicmodels database
            SHOW FULL TABLES;  -- -- all tables as well as views with table(object) type in the classicmodels database
	-- ------------------------
###### Example 2: Creating a view based on another view 
DROP VIEW IF EXISTS bigsaleOrder;
		CREATE VIEW bigSalesOrder AS
			SELECT 
				orderNumber, 
				ROUND(total,2) as total
			FROM
				salePerOrder
			WHERE
				total > 60000;
 -- -------------------
 SELECT orderNumber, total FROM  bigSalesOrder;
-- ---------------------

###### Example 3: Creating a view with join (More than one table) 

CREATE OR REPLACE VIEW customerOrders AS
SELECT 
    orderNumber,
    customerName,
    SUM(quantityOrdered * priceEach) total
FROM
    orderDetails
INNER JOIN orders o USING (orderNumber)
INNER JOIN customers USING (customerNumber)
GROUP BY orderNumber;
-- ----------------
SELECT * FROM customerOrders 
ORDER BY total DESC;

-- -------------------

##### Example 4: Creating a view with a subquery  -- The view contains products whose buy prices are higher than the average price of all products.
		CREATE VIEW aboveAvgProducts AS
			SELECT 
				productCode, 
				productName, 
				buyPrice
			FROM
				products
			WHERE
				buyPrice > (
					SELECT 
						AVG(buyPrice)
					FROM
						products)
			ORDER BY buyPrice DESC;

-- ----------------------------

SELECT * FROM aboveAvgProducts; 
-- ----------------------------

##### Example 5: Creating a view with explicit view columns
		CREATE VIEW customerOrderStats (
		   customerName , 
		   orderCount
		) 
		AS
			SELECT 
				customerName, 
				COUNT(orderNumber)
			FROM
				customers
					INNER JOIN
				orders USING (customerNumber)
			GROUP BY customerName;
    -- -----------------
    
    SELECT customerName, orderCount FROM  customerOrderStats
		ORDER BY orderCount, customerName;
   -- ------------------- 

##### Example 6: Creates a view based on the customers table with the name contactPersons with the MERGE algorithm:

CREATE ALGORITHM=MERGE VIEW contactPersons(
    customerName, 
    firstName, 
    lastName, 
    phone
) AS
SELECT 
    customerName, 
    contactFirstName, 
    contactLastName, 
    phone
FROM customers;
-- -------------

	SELECT * FROM contactPersons
	WHERE customerName LIKE '%Co%';

/* MySQL performs these steps:
	* Convert view name contactPersons to table name customers.
	* Executes the query with the filter (Where clause) 
	* The resulting statement is:
		SELECT 
			customerName, 
			contactFirstName, 
			contactLastName, 
			phone
		FROM
			customers
		WHERE
			customerName LIKE '%Co%';
    */ 
-- ---------------------

 ###### EXample: 7::::: MySQL view and WITH CHECK OPTION example
	-- 1 .Creates a view named vps based on the employees table to reveal employees whose job titles are VP e.g., VP Sales, VP Marketing.

CREATE OR REPLACE VIEW vps AS
    SELECT  employeeNumber, lastname, firstname, jobtitle, extension,  email,  officeCode,  reportsTo
    FROM  employees WHERE  jobTitle LIKE '%VP%';
        
-- 2. Query data from the vps view using the following SELECT statement:
		SELECT * FROM vps;

-- 3. Insert a row into the employees table through the vps view.  -- Because the vps is a simple view, it is updatable.

INSERT INTO vps( employeeNumber, firstName, lastName, jobTitle, extension, email, officeCode, reportsTo ) 
VALUES( 1703, 'Lily', 'Bush', 'IT Manager',  'x9111', 'lilybush@classicmodelcars.com',  1, 1002 );

-- NOTE: Notice that the newly created employee is not visible through the vps view because her job title is IT Manager, which is not the VP. 
		-- You can verify it using the following SELECT statement.
SELECT *  FROM  employees ORDER BY  employeeNumber DESC;

-- This may not what we want because we just want to expose the VP employees only through the vps view, not other employees.
-- To ensure the consistency of a view so that users can only display or update data that visible through the view, 
	-- you use the WITH CHECK OPTION when you create or modify the view.
-- Let’s modify the view to include the WITH CHECK OPTION.

CREATE OR REPLACE VIEW vps AS
    SELECT  employeeNumber, lastname, firstname, jobtitle, extension,  email,  officeCode,  reportsTo
		FROM  employees WHERE  jobTitle LIKE '%VP%'
		WITH CHECK OPTION;

-- --------------------
INSERT INTO vps(employeeNumber,firstname,lastname,jobtitle,extension,email,officeCode,reportsTo)
VALUES(1704,'John','Smith','IT Staff','x9112','johnsmith@classicmodelcars.com',1,1703);

-- This time, MySQL rejected the insert and issued the following error message:
	-- Error Code: 1369. CHECK OPTION failed 'classicmodels.vps'
-- Finally, insert an employee whose job title is SVP Marketing into the employees table through the vps view to see if it is allowed.

INSERT INTO vps(employeeNumber,firstname,lastname,jobtitle,extension,email,officeCode,reportsTo)
VALUES(1704,'John','Smith','SVP Marketing','x9112','johnsmith@classicmodelcars.com',1,1076);

-- The above row is inserted, because it is applicable with view check option
SELECT * FROM vps;   -- -- Verify it 
-- -------------------------------------------------------------



    
    

   
