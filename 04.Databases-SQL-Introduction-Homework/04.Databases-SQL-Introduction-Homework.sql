USE SoftUni

/*Problem 4.	Write a SQL query to find all information about all departments 
(use "SoftUni" database).*/

SELECT * FROM Departments

SELECT 	
	D.DepartmentID,
	D.Name AS [Department Name],
	COUNT(E.EmployeeID) AS [Employee Count],
	M.FirstName + ' ' + M.LastName AS [Manager Name]
FROM Employees E
INNER JOIN Employees M
ON M.EmployeeID = E.ManagerID
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentID, D.Name, M.FirstName, M.LastName
ORDER BY 
	[Manager Name] ASC, 
	[Department Name] ASC, 
	[Employee Count] DESC

/*Problem 5.	Write a SQL query to find all department names.*/

SELECT Name AS [Department Name] 
FROM Departments

SELECT 
	D.DepartmentID,
	D.Name AS [Department Name] 
FROM Departments D
ORDER BY [Department Name] ASC, DepartmentID ASC

/*Problem 6.	Write a SQL query to find the salary of each employee.*/

SELECT 
	EmployeeID AS [Employee ID], 
	FirstName + ' ' + LastName AS [Employee Name], 
	Salary 
FROM Employees
ORDER BY Salary DESC, [Employee Name] ASC

/*Problem 7.	Write a SQL to find the full name of each employee.*/

SELECT FirstName, MiddleName, LastName 
FROM Employees

SELECT 
	E.FirstName + ' ' + E.LastName AS [Full Employee Name]
FROM Employees E

/*Problem 8.	Write a SQL query to find the email addresses of each employee.

Write a SQL query to find the email addresses of each employee. (by his first and last name). 
Consider that the mail domain is softuni.bg. Emails should look like “John.Doe@softuni.bg". 
The produced column should be named "Full Email Addresses".*/

SELECT
	E.FirstName + '.' + E.LastName + '@softuni.bg' AS [Full Email Addresses]
FROM Employees E
ORDER BY [Full Email Addresses] ASC

SELECT
	E.FirstName + '.' + E.LastName + '@softuni.bg' AS "Full Email Addresses"
FROM Employees E
ORDER BY "Full Email Addresses" ASC

SELECT
	E.FirstName + '.' + E.LastName + '@softuni.bg' AS 'Full Email Addresses'
FROM Employees E
ORDER BY 'Full Email Addresses' ASC

/*Problem 9.	Write a SQL query to find all different employee salaries.*/

SELECT 
	DISTINCT Salary 
FROM Employees
ORDER BY Salary DESC

/*Problem 10.	Write a SQL query to find all information about the employees
 whose job title is “Sales Representative“.*/

SELECT * 
FROM Employees 
WHERE JobTitle = 'Sales Representative'

SELECT * 
FROM Employees 
WHERE JobTitle IN ('Sales Representative')

/*Problem 11.	Write a SQL query to find the names of all employees whose
first name starts with "SA".*/

SELECT 
	E.FirstName, 
	E.LastName, 
	E.MiddleName 
FROM Employees E
WHERE E.FirstName LIKE 'SA%'

/*Problem 12.	Write a SQL query to find the names of all employees whose
last name contains "ei".*/

SELECT 
	E.FirstName, 
	E.LastName, 
	E.MiddleName 
FROM Employees E
WHERE E.LastName LIKE '%ei%'

/*Problem 13.	Write a SQL query to find the salary of all employees whose salary
is in the range [20000…30000].*/

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name],	
	E.Salary
FROM Employees E
WHERE E.Salary BETWEEN 20000 AND 30000
ORDER BY Salary DESC, [Employee Name] ASC

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name],	
	E.Salary
FROM Employees E
WHERE (E.Salary >= 20000 AND E.Salary <= 30000)
ORDER BY Salary DESC, [Employee Name] ASC

/*Problem 14.	Write a SQL query to find the names of all employees
whose salary is 25000, 14000, 12500 or 23600.*/

SELECT
	FirstName + ' ' + LastName AS [Employee Name],
	Salary 
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)
ORDER BY Salary DESC, [Employee Name] ASC

/*Problem 15.	Write a SQL query to find all employees that do not have manager.*/

SELECT 
	FirstName + ' ' + LastName AS [Employee Name]
FROM Employees
WHERE ManagerID IS NULL

SELECT 
	FirstName + ' ' + LastName AS [Employee Name],
	ISNULL(CAST(ManagerID AS NVARCHAR(20)), '(no manager)') AS [Manager Name]
FROM Employees
WHERE ManagerID IS NULL

/*Problem 16.	Write a SQL query to find all employees that have salary more than 50000.
Order them in decreasing order by salary.*/

SELECT
	FirstName + ' ' + LastName AS [Employee Name],
	Salary 
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

/*Problem 17.	Write a SQL query to find the top 5 best paid employees.*/

SELECT TOP 5 
	FirstName + ' ' + LastName AS [Employee Name], 
	Salary 
FROM Employees
ORDER BY Salary DESC

SELECT
	FirstName + ' ' + LastName AS [Employee Name],
	Salary 
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY

/*Problem 18.	Write a SQL query to find all employees along with their address.
Use inner join with ON clause.*/

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	A.AddressText AS [Address],
	T.Name AS [Town]
FROM Employees E
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
ORDER BY T.Name ASC, [Employee Name] ASC

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	T.Name + ', ' + A.AddressText AS [Full Address] 
FROM Employees E
INNER JOIN Addresses A
ON E.AddressID = A.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
ORDER BY [Full Address] ASC, [Employee Name] ASC

/*Problem 19.	Write a SQL query to find all employees and their address. 
Use equijoins (conditions in the WHERE clause).*/

SELECT 
	E.FirstName,
	E.LastName,
	T.Name + ', ' + A.AddressText AS [Full Address] 
FROM Employees E, Addresses A, Towns T
WHERE 
	E.AddressID = A.AddressID 
	AND A.TownID = T.TownID
ORDER BY [Full Address] ASC

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	T.Name AS [Town],
	A.AddressText AS [Address]
FROM Employees E, Addresses A, Towns T
WHERE 
	E.AddressID = A.AddressID 
	AND A.TownID = T.TownID
ORDER BY Town ASC, Address ASC

/*Problem 20.	Write a SQL query to find all employees along with their manager.*/

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	ISNULL((M.FirstName + ' ' + M.LastName), '(no manager)') AS [Manager Name]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	M.FirstName + ' ' + M.LastName AS [Manager Name]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

/*Problem 21.	Write a SQL query to find all employees, along with their manager 
and their address. You should join the 3 tables: Employees e, Employees m and Addresses a.*/

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name], 
	ISNULL((M.FirstName + ' ' + M.LastName), '(no manager)') AS [Manager Name], 
	A.AddressText AS [Address]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
ORDER BY [Manager Name] ASC, [Address] ASC, [Employee Name] ASC

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name], 
	ISNULL((M.FirstName + ' ' + M.LastName), '(no manager)') AS [Manager Name], 
	T.Name + ', ' + A.AddressText AS [Full Address]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
ORDER BY [Manager Name] ASC, [Full Address] ASC, [Employee Name] ASC

/*Problem 22.	Write a SQL query to find all departments and all town names as a single list.
Use UNION.*/

SELECT Name FROM Departments
UNION
SELECT Name FROM Towns

SELECT Name FROM Departments
UNION ALL
SELECT Name FROM Towns

/*Problem 23.	Write a SQL query to find all the employees and the manager for each of them
along with the employees that do not have a manager. Use right outer join. Rewrite the query 
to use left outer join.*/

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name], 
	M.FirstName + ' ' + M.LastName AS [Manager Name]
FROM Employees M
RIGHT OUTER JOIN Employees E
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName + ' ' + E.LastName AS [Employee Name], 
	M.FirstName + ' ' + M.LastName AS [Manager Name]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

/*Problem 24.	Write a SQL query to find the names of all employees from the
departments "Sales" and "Finance" whose hire year is between 1995 and 2005.*/

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	E.HireDate AS [Hire Date], 
	D.Name AS [Department Name]
FROM Employees E
INNER JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE 
	D.Name = 'Sales' OR D.Name = 'Finance'
	AND E.HireDate BETWEEN '1995-1-1' AND '2005-12-31'
ORDER BY E.HireDate DESC

SELECT
	E.FirstName + ' ' + E.LastName AS [Employee Name],
	E.HireDate AS [Hire Date], 
	D.Name AS [Department Name]
FROM Employees E
INNER JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE 
	E.DepartmentID IN 
		(SELECT DepartmentID FROM Departments WHERE Name = 'Sales' OR Name = 'Finance') 
	AND E.HireDate BETWEEN '1995-1-1' AND '2005-12-31'
ORDER BY E.HireDate DESC
