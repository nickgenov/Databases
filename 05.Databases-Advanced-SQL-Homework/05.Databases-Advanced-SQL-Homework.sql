/*Problem 1.	Write a SQL query to find the names and salaries of the employees
that take the minimal salary in the company.
Use a nested SELECT statement.*/

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
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
INNER JOIN dbo.Addresses A
ON A.AddressID = E.AddressID
INNER JOIN dbo.Towns T
ON T.TownID = A.TownID
GROUP BY D.Name, T.Name
ORDER BY D.Name ASC

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
	E.LastName,
	LEN(E.LastName) AS [Last name length]
FROM dbo.Employees E
WHERE LEN(E.LastName) = 5

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee],
	LEN(E.LastName) AS [Employee last name length],
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
INNER JOIN Employees M
ON M.EmployeeID = E.ManagerID
WHERE LEN(E.LastName) = 5

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

CREATE TABLE Users (
	ID INT IDENTITY,
	Username NVARCHAR(50) NOT NULL UNIQUE,
	Password NVARCHAR(50) NOT NULL CHECK (LEN(Password) >= 5),
	FullName NVARCHAR(100) NOT NULL,
	LastLogin DATE NOT NULL
	CONSTRAINT PK_Users PRIMARY KEY (ID)
)

--DROP TABLE Users
--DELETE FROM USERS

GO
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Petar', 'Petar', 'Petar Petrov', GETDATE())
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Ivan', '12345', 'Ivan Ivanov', GETDATE())
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Minka', 'parolata', 'Minka Petkova', GETDATE())
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Gosho', 'cska123', 'Georgi Georgiev', GETDATE())
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Pencho12', '123456789', 'Pencho Georgiev', '2015-06-25')
INSERT INTO Users (Username, Password, FullName, LastLogin) VALUES ('Gosho1', '654321', 'Georgi Penchev', '2015-06-21')
GO

SELECT * FROM Users
SELECT GETDATE()

/*Problem 16.	Write a SQL statement to create a view that displays the users from the Users table
that have been in the system today. Test if the view works correctly.*/

GO
CREATE VIEW UsersLoggedToday AS
SELECT Username, FullName FROM Users WHERE LastLogin = CONVERT(DATE, GETDATE()) 
GO

--DROP VIEW UsersLoggedToday
SELECT * FROM UsersLoggedToday

/*Problem 17.	Write a SQL statement to create a table Groups. 
Groups should have unique name (use unique constraint). Define primary key and identity column.*/

CREATE TABLE Groups (
	ID INT IDENTITY NOT NULL,
	Name NVARCHAR(100) UNIQUE NOT NULL,
	CONSTRAINT PK_Groups PRIMARY KEY (ID)
)

SELECT * FROM Groups

/*Problem 18.	Write a SQL statement to add a column GroupID to the table Users.
Fill some data in this new column and as well in the Groups table. Write a SQL statement
to add a foreign key constraint between tables Users and Groups tables.*/

ALTER TABLE Users ADD GroupID INT
--ALTER TABLE Groups DROP COLUMN GroupID

TRUNCATE TABLE Groups
GO
INSERT INTO Groups VALUES ('Team1')
INSERT INTO Groups VALUES ('Team2')
INSERT INTO Groups VALUES ('Team3')
INSERT INTO Groups VALUES ('Team4')
GO

ALTER TABLE Users
	ADD CONSTRAINT FK_Users_Groups FOREIGN KEY(GroupID) REFERENCES Groups(ID)

/*Problem 19.	Write SQL statements to insert several records in the Users and Groups tables.*/

GO
INSERT INTO Groups (Name) VALUES ('Team5')
INSERT INTO Groups (Name) VALUES ('Team6')

INSERT INTO Users (Username, Password, FullName, LastLogin, GroupID) 
	VALUES ('Mincho', '987654321', 'Mincho Petrov', DATEADD(DAY, -14, GETDATE()), 2)
INSERT INTO Users (Username, Password, FullName, LastLogin, GroupID) 
	VALUES ('Stamat', '987654321', 'Stamat Stamatov', DATEADD(DAY, -4, GETDATE()), 2)

/*Problem 20.	Write SQL statements to update some of the records in the Users and Groups tables.*/

UPDATE Users SET GroupID = 3 WHERE Username LIKE 'Gosho%'
UPDATE Groups SET Name = 'Team Ontario' WHERE ID = 1

/*Problem 21.	Write SQL statements to delete some of the records from the Users and Groups tables.*/

--SELECT * FROM Groups
--SELECT * FROM Users

DELETE FROM Groups WHERE ID > 4
DELETE FROM Users WHERE Username = 'Stamat'

/*Problem 22.	Write SQL statements to insert in the Users table the names of all employees from
the Employees table. Combine the first and last names as a full name. For username use the first letter
of the first name + the last name (in lowercase). Use the same for the password, and NULL for last login time.*/

ALTER TABLE Users
ALTER COLUMN LastLogin DATE NULL

--SELECT * FROM Employees
--SELECT * FROM Users

BEGIN TRAN
GO
DECLARE @Count INT = 1, @MaxCount INT = (SELECT COUNT(EmployeeID) FROM Employees)

WHILE (@Count <= @MaxCount)
BEGIN
	DECLARE @FullName NVARCHAR(100), @Username NVARCHAR(100)
	SET @FullName = (SELECT FirstName + ' ' + LastName FROM Employees WHERE EmployeeID = @Count)
	SET @Username = (SELECT LOWER(SUBSTRING(FirstName, 1, 1) + LastName) FROM Employees WHERE EmployeeID = @Count)
	
	INSERT INTO Users (Username, Password, FullName, LastLogin, GroupID) VALUES (@Username, @Username, @FullName, NULL, NULL)

	SET @Count = @Count + 1
END
GO
ROLLBACK TRAN

COMMIT TRAN

/*Problem 23.	Write a SQL statement that changes the password to NULL for all users that have
not been in the system since 10.03.2010.*/

UPDATE Users SET LastLogin = '2009-03-10' WHERE ID < 20

ALTER TABLE Users
ALTER COLUMN Password NVARCHAR(100) NULL

UPDATE Users SET Password = NULL WHERE LastLogin <= '2010-03-10'

/*Problem 24.	Write a SQL statement that deletes all users without passwords (NULL password).*/

--SELECT * FROM Users WHERE Password IS NULL
BEGIN TRAN
DELETE FROM Users WHERE Password IS NULL
COMMIT TRAN

/*Problem 25.	Write a SQL query to display the average employee salary by department and job title.*/

SELECT 
	D.Name AS [Department],
	E.JobTitle AS [Job Title],
	AVG(E.Salary) AS [Average Salary]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name, E.JobTitle

/*Problem 26.	Write a SQL query to display the minimal employee salary by department and job title along
with the name of some of the employees that take it.*/

SELECT 
	D.Name AS [Department], 
	E.JobTitle AS [Job Title],
	E.FirstName,
	MIN(E.Salary) AS [Min Salary]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE E.Salary = 
	(SELECT MIN(Salary) FROM Employees 
	 WHERE DepartmentID = E.DepartmentID 
	 AND JobTitle = E.JobTitle)
GROUP BY D.Name, E.JobTitle, E.FirstName
ORDER BY D.Name, E.JobTitle

/*Problem 27.	Write a SQL query to display the town where maximal number of employees work.*/

SELECT TOP 1
	T.Name AS [Town],
	COUNT(E.EmployeeID) AS [Number of employees]
FROM Employees E
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
GROUP BY T.Name
ORDER BY [Number of employees] DESC

/*Problem 28.	Write a SQL query to display the number of managers from each town.*/

SELECT 
	T.Name AS [Town],
	COUNT(DISTINCT M.EmployeeID) AS [Number of managers]
FROM Towns T
INNER JOIN Addresses A
ON A.TownID = T.TownID
INNER JOIN Employees E
ON E.AddressID = A.AddressID
INNER JOIN Employees M 
ON M.EmployeeID = E.ManagerID
GROUP BY T.Name
ORDER BY T.Name

/*Problem 29.	Write a SQL to create table WorkHours to store work reports for each employee.
Each employee should have id, date, task, hours and comments. Don't forget to define identity,
primary key and appropriate foreign key.*/

BEGIN TRAN
CREATE TABLE WorkHours (
	ID INT IDENTITY NOT NULL,
	Date DATE NOT NULL,
	Task NVARCHAR(500) NOT NULL,
	Hours INT NOT NULL,
	Comments NVARCHAR(MAX),
	EmployeeID INT NOT NULL
	CONSTRAINT PK_WorkHours PRIMARY KEY (ID)
	CONSTRAINT FK_WorkHours_Employees
		FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)
COMMIT TRAN

/*Problem 30.	Issue few SQL statements to insert, update and delete of some data in the table.*/

SELECT * FROM WorkHours

BEGIN TRAN
GO
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task1', 2, NULL, 34)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task2', 4, NULL, 33)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task3', 5, NULL, 25)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task4', 6, NULL, 66)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task5', 21, NULL, 55)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task6', 3, NULL, 33)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task7', 66, NULL, 42)
INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task8', 54, NULL, 72)
GO
COMMIT TRAN

UPDATE WorkHours SET Hours = 5 WHERE Hours > 5
UPDATE WorkHours SET Date = DATEADD(DAY, -2, GETDATE()) WHERE EmployeeID = 33 AND HOURS > 1

DELETE FROM WorkHours WHERE DATE = CONVERT(DATE, GETDATE()) AND Task LIKE 'Task%'

/*Problem 31.	Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
For each change keep the old record data, the new record data and the command (insert / update / delete).*/

BEGIN TRAN
CREATE TABLE WorkHoursLogs (
	ID INT IDENTITY NOT NULL,
	WorkHoursID INT NOT NULL,
	Date DATE NOT NULL,
	Task NVARCHAR(500) NOT NULL,
	Hours INT NOT NULL,
	Comments NVARCHAR(MAX),
	EmployeeID INT NOT NULL,
	Command NVARCHAR(6) NOT NULL
	CONSTRAINT PK_WorkHoursLogs PRIMARY KEY (ID)
)
COMMIT TRAN

SELECT * FROM WorkHoursLogs

BEGIN TRAN
--CREATE TRIGGER WorkHoursTrigger ON WorkHours FOR DELETE, INSERT, UPDATE AS




--INSERT INTO WorkHours (Date, Task, Hours, Comments, EmployeeID) VALUES (GETDATE(), 'Task1', 2, NULL, 34)
/*

CREATE TRIGGER TableTrigger ON OriginalTable FOR DELETE, INSERT, UPDATE AS

DECLARE @NOW DATETIME
SET @NOW = CURRENT_TIMESTAMP

UPDATE HistoryTable
   SET EndDate = @now
  FROM HistoryTable, DELETED
 WHERE HistoryTable.ColumnID = DELETED.ColumnID
   AND HistoryTable.EndDate IS NULL

INSERT INTO HistoryTable (ColumnID, Column2, ..., Columnn, StartDate, EndDate)
SELECT ColumnID, Column2, ..., Columnn, @NOW, NULL
  FROM INSERTED

IF OBJECT_ID ('Sales.reminder1', 'TR') IS NOT NULL
   DROP TRIGGER Sales.reminder1;
GO
CREATE TRIGGER reminder1
ON Sales.Customer
AFTER INSERT, UPDATE 
AS RAISERROR ('Notify Customer Relations', 16, 10);
GO
*/


/*Problem 32.	Start a database transaction, delete all employees from the 'Sales' department
along with all dependent records from the other tables. At the end rollback the transaction.*/

SELECT * FROM Employees 
WHERE DepartmentID IN 
	(SELECT DepartmentID FROM Departments WHERE Name = 'Sales')

BEGIN TRAN

GO
ALTER TABLE Departments
DROP CONSTRAINT FK_Departments_Employees
GO
ALTER TABLE Employees
ADD CONSTRAINT FK_Departments_Employees FOREIGN KEY (DepartmentID)
	REFERENCES Departments (DepartmentID)
	ON DELETE CASCADE 
GO

DELETE FROM Employees 
WHERE DepartmentID IN 
	(SELECT DepartmentID FROM Departments WHERE Name = 'Sales')

ROLLBACK TRAN

COMMIT TRAN

/*Problem 33.	Start a database transaction and drop the table EmployeesProjects.
Then how you could restore back the lost table data?*/

SELECT * FROM EmployeesProjects

BEGIN TRAN
DROP TABLE EmployeesProjects

ROLLBACK TRAN

/*Problem 34.	Find how to use temporary tables in SQL Server.
Using temporary tables backup all records from EmployeesProjects and restore them back 
after dropping and re-creating the table.*/
