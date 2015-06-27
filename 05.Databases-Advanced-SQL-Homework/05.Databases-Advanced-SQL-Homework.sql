/*Problem 1.	Write a SQL query to find the names and salaries of the employees
that take the minimal salary in the company.
Use a nested SELECT statement.*/

--VLADO@SOFTUNI.BG

SELECT 
	E.FirstName, 
	E.LastName, 
	E.Salary
FROM Employees E
WHERE Salary = (SELECT MIN(Salary) FROM Employees)

/*Problem 2.	Write a SQL query to find the names and salaries of the employees
that have a salary that is up to 10% higher than the minimal salary for the company.*/

SELECT 
	FirstName, 
	LastName, 
	Salary
FROM Employees
WHERE Salary <= (SELECT MIN(Salary) FROM Employees) * 1.1
ORDER BY Salary DESC

/*Problem 3.	Write a SQL query to find the full name, salary and department of the
employees that take the minimal salary in their department.
Use a nested SELECT statement.*/

SELECT 
	E.FirstName, 
	E.LastName, 
	E.Salary, 
	D.Name AS Department,
	E.DepartmentID
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE E.Salary = 
(SELECT MIN(Salary) FROM Employees WHERE DepartmentID = E.DepartmentID)

SELECT 
	E.FirstName, 
	E.LastName, 
	E.Salary
FROM Employees E
WHERE E.Salary = (SELECT MIN(Salary) FROM Employees WHERE DepartmentID = E.DepartmentID)

/*Problem 4.	Write a SQL query to find the average salary in the department #1.*/

SELECT AVG(Salary) AS [Average salary in the department #1]
FROM Employees
WHERE DepartmentID = 1

SELECT 
	E.DepartmentID AS [Department ID], 
	D.Name AS [Department Name], 
	AVG(E.Salary) AS [Average Salary]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name, E.DepartmentID
HAVING E.DepartmentID = 1

/*Problem 5.	Write a SQL query to find the average salary in the "Sales" department.*/

SELECT 
	AVG(E.Salary) AS [Average Salary for Sales Department]--,D.Name
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Sales'
GROUP BY D.Name

SELECT 
	AVG(E.Salary) AS [Average Salary for Sales Department]--,D.Name
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name
HAVING D.Name = 'Sales'

SELECT AVG(Salary) AS [Average Salary for Sales Department]
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Sales'

SELECT AVG(Salary) AS [Average Salary for Sales Department]
FROM Employees WHERE DepartmentID = 3

/*Problem 6.	Write a SQL query to find the number of employees in the "Sales" department.*/

SELECT COUNT(E.EmployeeID) AS [Sales Employees Count]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Sales'

SELECT 
	COUNT(EmployeeID) AS [Employees Count], 
	D.Name AS [Department]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name
HAVING D.Name = 'Sales'


SELECT * FROM Departments --Sales DepartmentID = 3
SELECT COUNT(EmployeeID) AS [Sales Employees Count]
FROM Employees
WHERE DepartmentID = 3 --18


/*Problem 7.	Write a SQL query to find the number of all employees that have manager.*/

SELECT 
	COUNT(EmployeeID) AS [Employees with manager]
FROM Employees
WHERE ManagerID IS NOT NULL

/*Problem 8.	Write a SQL query to find the number of all employees that have no manager.*/

SELECT 
	COUNT(EmployeeID) AS [Employees without manager]
FROM Employees
WHERE ManagerID IS NULL

/*Problem 9.	Write a SQL query to find all departments and the average salary for each of them.*/

SELECT 
	D.Name AS Department,
	AVG(E.Salary) AS [Average Salary]
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name

SELECT 
	D.Name AS Department,
	AVG(E.Salary) AS [Average Salary]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name

/*Problem 10.	Write a SQL query to find the count of all employees in each department and for each town.*/

SELECT 	
	T.Name AS [Town],
	D.Name AS [Department],	
	COUNT(E.EmployeeID) AS [Employees Count]
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
JOIN dbo.Addresses A
ON A.AddressID = E.AddressID
JOIN dbo.Towns T
ON T.TownID = A.TownID
GROUP BY D.Name, T.Name
ORDER BY D.Name ASC

SELECT 
	T.Name AS Town, 
	D.Name AS Department,
	COUNT(E.EmployeeID) AS [Employees Count]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
GROUP BY D.Name, T.Name
ORDER BY D.Name ASC

/*Problem 11.	Write a SQL query to find all managers that have exactly 5 employees.
Display their first name and last name.*/

SELECT 
	M.FirstName, 
	M.LastName, 
	COUNT(E.EmployeeID) AS [Employees count] 
FROM Employees E
JOIN Employees M
ON M.EmployeeID = E.ManagerID
GROUP BY M.FirstName, M.LastName
HAVING COUNT(E.EmployeeID) = 5

/*Problem 12.	Write a SQL query to find all employees along with their managers.
For employees that do not have a manager display the value "(no manager)".*/

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee],
	ISNULL(M.FirstName + ' ' + M.LastName, '(no manager)') AS [Manager]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

/*Problem 13.	Write a SQL query to find the names of all employees whose last name is exactly 5 characters long. 
Use the built-in LEN(str) function.*/

SELECT 
	E.FirstName, 
	E.LastName
FROM dbo.Employees E
WHERE LEN(E.LastName) = 5

SELECT 
	E.FirstName, 
	E.LastName , 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
INNER JOIN Employees M
ON M.EmployeeID = E.ManagerID
WHERE LEN(E.LastName) = 5 AND LEN(E.FirstName) = 5

/*Problem 14.	Write a SQL query to display the current date and time in the following format 
"day.month.year hour:minutes:seconds:milliseconds". 
Search in Google to find how to format dates in SQL Server.
DateTIme 11.02.2015 18:50:02:960*/

SELECT CONVERT(VARCHAR(24),GETDATE(),113) AS [DateTime]
--Europe default + milliseconds dd mon yyyy hh:mi:ss:mmm(24h)

/*Problem 15.	Write a SQL statement to create a table Users.
Users should have username, password, full name and last login time. Choose appropriate data types
for the table fields. Define a primary key column with a primary key constraint. Define the primary key 
column as identity to facilitate inserting records. Define unique constraint to avoid repeating usernames.
Define a check constraint to ensure the password is at least 5 characters long.*/





/*Problem 16.	Write a SQL statement to create a view that displays the users from the Users table that have been in the system today.
Test if the view works correctly.
You should submit a SQL file as a part of your homework.
Problem 17.	Write a SQL statement to create a table Groups. 
Groups should have unique name (use unique constraint). Define primary key and identity column.
You should submit a SQL file as a part of your homework.
Problem 18.	Write a SQL statement to add a column GroupID to the table Users.
Fill some data in this new column and as well in the Groups table. Write a SQL statement to add a foreign key constraint between tables Users and Groups tables.
You should submit a SQL file as a part of your homework.
Problem 19.	Write SQL statements to insert several records in the Users and Groups tables.
You should submit a SQL file as a part of your homework.
Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables.
You should submit a SQL file as a part of your homework.
Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables.
You should submit a SQL file as a part of your homework.
Problem 22.	Write SQL statements to insert in the Users table the names of all employees from the Employees table.
Combine the first and last names as a full name. For username use the first letter of the first name + the last name (in lowercase). Use the same for the password, and NULL for last login time.
You should submit a SQL file as a part of your homework.
Problem 23.	Write a SQL statement that changes the password to NULL for all users that have not been in the system since 10.03.2010.
You should submit a SQL file as a part of your homework.
Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).
You should submit a SQL file as a part of your homework.
Problem 25.	Write a SQL query to display the average employee salary by department and job title.
Department	Job Title	Average Salary
Finance	Accountant	26400.00
Finance	Accounts Manager	34700.00
Finance	Accounts Payable Specialist	19000.00
Finance	Accounts Receivable Specialist	19000.00
…	…	…

You should submit a SQL file as a part of your homework.
Problem 26.	Write a SQL query to display the minimal employee salary by department and job title along with the name of some of the employees that take it.
Department	Job Title	First Name	Min Salary
Engineering	Engineering Manager	Roberto	43300.00
Engineering	Senior Design Engineer	Michael	36100.00
Engineering	Vice President of Engineering	Terri	63500.00
Executive	Chief Executive Officer	Ken	125500.00
…	…		…

You should submit a SQL file as a part of your homework.
Problem 27.	Write a SQL query to display the town where maximal number of employees work.
Name	Number of employees
Seattle	44

You should submit a SQL file as a part of your homework.
Problem 28.	Write a SQL query to display the number of managers from each town.
Town	Number of managers
Issaquah	3
Kenmore	5
Monroe	2
Newport Hills	1

You should submit a SQL file as a part of your homework.
Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.
Each employee should have id, date, task, hours and comments. Don't forget to define identity, primary key and appropriate foreign key.
You should submit a SQL file as a part of your homework.
Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.
You should submit a SQL file as a part of your homework.
Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
For each change keep the old record data, the new record data and the command (insert / update / delete).
You should submit a SQL file as a part of your homework.
Problem 32.	Start a database transaction, delete all employees from the 'Sales' department along with all dependent records from the pother tables. At the end rollback the transaction.
You should submit a SQL file as a part of your homework.
Problem 33.	Start a database transaction and drop the table EmployeesProjects.
Then how you could restore back the lost table data?
You should submit a SQL file as a part of your homework.
Problem 34.	Find how to use temporary tables in SQL Server.
Using temporary tables backup all records from EmployeesProjects and restore them back after dropping and re-creating the table.
You should submit a SQL file as a part of your homework.
