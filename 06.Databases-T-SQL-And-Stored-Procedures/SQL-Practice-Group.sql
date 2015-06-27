SELECT * FROM Employees
WHERE Salary = (SELECT MAX(Salary) FROM Employees)

SELECT COUNT(*)
FROM
(SELECT E.FirstName, E.LastName, D.Name AS DeptName 
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID) AS A

--IMPORTANT - ALIAS 
SELECT A.FirstName
FROM
(SELECT E.FirstName, E.LastName, D.Name AS DeptName 
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID) AS A

--OFFSET
SELECT * FROM Employees
ORDER BY FirstName
OFFSET 20 ROWS
FETCH NEXT 5 ROWS ONLY

SELECT *
FROM Departments
ORDER BY DepartmentID
OFFSET 10 ROWS
FETCH NEXT 2 ROWS ONLY

SELECT FirstName, LastName, DepartmentID, Salary
FROM Employees
WHERE DepartmentID IN
	(SELECT DepartmentID 
	FROM Departments 
	WHERE Name = 'Sales' 
	OR Name = 'Marketing')
ORDER BY DepartmentID, FirstName

SELECT E.FirstName, E.LastName, E.DepartmentID, Salary
FROM Employees E
JOIN Departments D
	ON E.DepartmentID = D.DepartmentID
	WHERE D.Name = 'Sales'
	OR D.Name = 'Marketing'
ORDER BY E.DepartmentID, E.FirstName

SELECT E.FirstName, E.LastName, E.Salary, E.DepartmentID, D.Name AS DeptName
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE Salary =
	(SELECT MAX(Salary)
	FROM Employees
	WHERE DepartmentID = E.DepartmentID)
ORDER BY E.Salary DESC

SELECT *
FROM Employees E
WHERE EXISTS
	(SELECT EmployeeID FROM Employees M
	WHERE M.EmployeeID = E.ManagerID 
	AND M.DepartmentID = 1)

SELECT MIN(E.FirstName + ' ' + E.LastName)
FROM Employees E

SELECT MAX(E.FirstName + ' ' + E.LastName)
FROM Employees E

SELECT MAX(EmpName) 
FROM(
SELECT TOP 2 E.FirstName + ' ' + E.LastName AS EmpName
FROM Employees E
ORDER BY EmpName) AS EMPS


SELECT E.FirstName + ' ' + E.LastName AS EmpName
FROM Employees E
ORDER BY EmpName
OFFSET 1 ROWS
FETCH NEXT 1 ROWS ONLY

SELECT MAX(HireDate) MAXHD, MIN(HireDate) MINHD 
FROM Employees

--PROCEDURE

DECLARE @MAXDATE DATE;
SET @MAXDATE = (SELECT MAX(HireDate) FROM Employees)

DECLARE @EMP NVARCHAR(50)
SET @EMP = (SELECT MIN(FirstName) FROM Employees WHERE HireDate = @MAXDATE)
SELECT @MAXDATE AS [First hire date], @EMP AS [Employee]

SELECT 
AVG(Salary) [Average Salary],
MAX(Salary) [Max Salary],
MIN(Salary) [Min Salary],
SUM(Salary) [Sum Salary]
FROM Employees 
WHERE JobTitle = 'Production Technician'

SELECT COUNT(*) FROM Employees
SELECT COUNT(FirstName) FROM Employees
SELECT COUNT(DISTINCT FirstName) FROM Employees

SELECT COUNT(ManagerID) FROM Employees
SELECT COUNT(DISTINCT ManagerID) FROM Employees

SELECT COUNT(DISTINCT (M.EmployeeID))
FROM Employees E
INNER JOIN Employees M
ON E.ManagerID = M.ManagerID

--EARLIEST HIRED EMPLOYEE IN EACH DEPARTMENT
SELECT E.FirstName, E.LastName, D.Name AS Department, E.HireDate
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE E.HireDate = 
	(SELECT MIN(HireDate) FROM Employees WHERE DepartmentID = E.DepartmentID)

--SUM OF SALARIES BY DEPARTMENT
SELECT SUM(E.Salary) AS [SUM (Salaries)], COUNT(E.EmployeeID) AS [Employees Count],  D.Name AS DepartmentName
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name
ORDER BY [SUM (Salaries)] DESC

--AVERAGE SALARY BY DEPARTMENT
SELECT AVG(E.Salary) AS [AVG (Salaries)], COUNT(E.EmployeeID) AS [Employees Count],  D.Name AS DepartmentName
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name
ORDER BY [AVG (Salaries)] DESC

SELECT DepartmentID, SUM(Salary) AS SumSalaries
FROM Employees
GROUP BY DepartmentID

SELECT SUM(Salary) AS Salaries
FROM Employees
GROUP BY DepartmentID

SELECT SUM(E.Salary) Salaries, D.Name Department
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY D.Name

--SALARIES BY DEPARTMENT AND JOB TITLE
SELECT 
	E.JobTitle, 
	D.Name Department, 
	AVG(E.Salary) AS AvgSalary, 
	COUNT(E.EmployeeID) AS EmployeeCount
FROM Employees E
JOIN Departments D
ON D.DepartmentID = E.DepartmentID
GROUP BY E.JobTitle, D.Name
ORDER BY D.Name, AvgSalary DESC

SELECT E.DepartmentID, E.JobTitle, SUM(E.Salary) AS [Salaries], COUNT(E.EmployeeID) AS [Employees]
FROM Employees E
GROUP BY E.DepartmentID, E.JobTitle

SELECT DATEADD(DAY, 1, DATEFROMPARTS(2015, 11, 20))

SELECT Name AS [Project Name],
ISNULL(CONVERT(nvarchar(50), EndDate), 'Not Finished') AS [Date Finished]
FROM Projects

SELECT DATEADD(DAY, 1, GETDATE())

CREATE TABLE Cities
(CityID INT IDENTITY,
Name NVARCHAR(100) NOT NULL,
Population INT)
GO

CREATE VIEW [Top 10 Cities] AS
SELECT TOP 10 *
FROM Cities
GO