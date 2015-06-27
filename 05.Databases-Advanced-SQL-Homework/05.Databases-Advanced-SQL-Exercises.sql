--Exercises: Advanced SQL


/*Problem 1.	Easy Nested SELECT Statement
Write a SQL query to find the full name of the employee, his manager full name 
and the JobTitle from Sales department. Use nested select statement.
Task 1. Select all columns from Employees table.
Task 2. Join Managers.
Task 3. Write where statement with nested select.
You should write nested select statement that takes department id of the Sales department.*/

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee],
	E.JobTitle,
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
JOIN Employees M
ON E.ManagerID = M.EmployeeID
WHERE E.DepartmentID = (SELECT DepartmentID FROM Departments WHERE Name = 'Sales')

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee],
	E.JobTitle,
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
JOIN Employees M
ON E.ManagerID = M.EmployeeID
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Sales'

/*
Problem 2.	Nested SELECT Statement
Write a SQL query to find the FullName, Salary and Department Name for the top 5 employees
ordered by salary in descending order, under the average salary for their department. 
Task 1. Select all columns from Employees.
Task 2. Join Departments table.
Task 3. Write where statement with nested select.
Nested select should select the average salary for the employee’s department (using alias).
Task 4. Order by Salary.
Task 5. Select top 5 rows.
Task 6. Select only FirstName, LastName, Salary and DepartmentName columns.*/

SELECT TOP 5 E.FirstName, E.LastName, E.Salary, D.Name
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE E.Salary < (SELECT AVG(Salary) FROM Employees WHERE DepartmentID = E.DepartmentID)
ORDER BY E.Salary DESC

/*Problem 3.	Aggregating Data
Display all projects with the sum of their employee’s salaries.
Task 1. Select all columns from Projects.
Task 2. Join Employees table.
Task 3. Group by the name of the project.
Task 4. Select only project name, and the sum of the salaries.
Task 5. Oder by group name.*/

SELECT P.Name, SUM(E.Salary) AS [Employee Salaries]
FROM Projects P
JOIN EmployeesProjects EP
ON EP.ProjectID = P.ProjectID
JOIN Employees E
ON E.EmployeeID = EP.EmployeeID
GROUP BY P.Name
ORDER BY P.Name

/*Problem 4.	Data Definition Language
Create two tables. Companies and Conferences. Companies have Name, EmployeesCount, FoundedIn.
Conferences have Name, Price (optional), FreeSeats, Venue and Organizer (Company).
Use Data Definition Language (DDL) to create the tables and constraints.
Task 1. Create table with columns. Set the right data types.
Task 2. Add primary key constraint. Add Identity.
Task 3. Add the foreign key constrain between the Companies and Conferences tables.
Task 4. Alter table Conferences and add TwitterAccount column.*/

CREATE TABLE Companies (
	ID INT IDENTITY,
	Name NVARCHAR(100) NOT NULL,
	EmployeesCount INT NOT NULL,
	FoundedIn DATE NOT NULL
	CONSTRAINT PK_Companies PRIMARY KEY (ID)
)

CREATE TABLE Conferences (
	ID INT IDENTITY,
	Name NVARCHAR(100) NOT NULL,
	Price MONEY,
	FreeSeats INT NOT NULL,
	Venue NVARCHAR(100) NOT NULL,
	CompanyID INT NOT NULL
	CONSTRAINT FK_Conferences_Companies FOREIGN KEY (CompanyID) REFERENCES Companies (ID)
)

ALTER TABLE Conferences ADD TwitterAccount NVARCHAR(100)

SELECT * FROM Conferences
SELECT * FROM Companies

/*Problem 5.	Transactions
Task 1. Insert 10 companies in the transaction.
Task 2. Insert 10 conferences in two transactions from different windows.
Try to lock the table conferences with two windows.
Task 3. Try to delete some conference and to select all conferences at the same time in two different windows.*/

--DELETE FROM Companies
BEGIN TRAN
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Intel', 85000, '1/1/1980')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Microsoft', 60000, '1/1/1975')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Samsung', 180000, '1/1/1890')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Apple', 45000, '1/1/1980')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('AMD', 28000, '1/1/1990')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Nvidia', 35000, '1/1/1991')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Asus', 40000, '1/1/1985')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Gigabyte', 20000, '1/1/1988')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('AsRock', 20000, '1/1/1989')
INSERT INTO Companies (Name, EmployeesCount, FoundedIn) VALUES ('Micron', 18000, '1/1/1991')
--COMMIT TRAN

SELECT * FROM Companies
ROLLBACK TRAN
SELECT * FROM Companies
COMMIT TRAN