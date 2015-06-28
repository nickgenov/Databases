SELECT 5 + 4

SELECT DepartmentID + ManagerID 
FROM Employees

SELECT Salary + 300 AS IncreasedSalary
FROM Employees

SELECT 
	ISNULL(CAST(ManagerID AS NVARCHAR(100)) , '(no manager)') AS Manager
FROM Employees
WHERE ManagerID IS NULL

SELECT 
	FirstName + ' ' +LastName AS [Full Name], 
	Salary, 
	Salary * 0.2 AS Bonus
FROM Employees
ORDER BY [Full Name]

SELECT 
	FirstName + ' ' +LastName AS 'Full Name', 
	Salary, 
	Salary * 0.2 AS Bonus
FROM Employees
ORDER BY "Full Name"

CREATE TABLE Months (
	ID INT IDENTITY NOT NULL,
	Code INT UNIQUE NOT NULL,
	Name NVARCHAR(20) UNIQUE NOT NULL,
	CONSTRAINT PK_Months PRIMARY KEY (ID)
)

INSERT INTO Months (Code, Name) VALUES (1, 'Jan')
INSERT INTO Months (Code, Name) VALUES (2, 'Feb')
INSERT INTO Months (Code, Name) VALUES (3, 'Mar')
INSERT INTO Months (Code, Name) VALUES (4, 'Apr')
INSERT INTO Months (Code, Name) VALUES (5, 'May')
INSERT INTO Months (Code, Name) VALUES (6, 'Jun')
INSERT INTO Months (Code, Name) VALUES (7, 'Jul')
INSERT INTO Months (Code, Name) VALUES (8, 'Aug')
INSERT INTO Months (Code, Name) VALUES (9, 'Sep')
INSERT INTO Months (Code, Name) VALUES (10, 'Oct')
INSERT INTO Months (Code, Name) VALUES (11, 'Nov')
INSERT INTO Months (Code, Name) VALUES (12, 'Dec')

SELECT 
	'0' + CAST(Code AS NVARCHAR(10)),
	Name 
FROM Months

SELECT FirstName + '''s last name is ' + LastName AS [Our employees]
FROM Employees

SELECT *
FROM Employees WHERE HireDate = '2001-01-02'

SELECT *
FROM Employees WHERE HireDate = '2001-Jan-02'

SELECT 
	DISTINCT E.DepartmentID, 
	D.Name
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID

--UNION Shows only DISTINCT values!
SELECT FirstName FROM Employees
UNION
SELECT LastName FROM Employees

--UNION ALL shows DUPLICATE values
SELECT FirstName FROM Employees
UNION ALL
SELECT LastName FROM Employees
--ORDER BY LastName --DOES NOT WORK!

BEGIN TRAN
UPDATE Employees SET FirstName = 'Ivan'
UPDATE Employees SET FirstName = 'IvanKA' WHERE EmployeeID = 5 
UPDATE Employees SET LastName = 'Ivan' WHERE EmployeeID < 290

SELECT FirstName FROM Employees
EXCEPT
SELECT LastName FROM Employees

SELECT FirstName FROM Employees
INTERSECT
SELECT LastName FROM Employees

ROLLBACK TRAN

SELECT * FROM Employees E
WHERE ManagerID IS NULL 
	AND DepartmentID = 6
	AND (MiddleName IS NULL OR Salary > 10000) --BRACKETS!!!

SELECT *
FROM Employees
WHERE Salary BETWEEN 50500 AND 84100 --BORDER VALUES ARE INCLUDED

SELECT *
FROM Employees WHERE Salary >= 50500 AND Salary <= 84100 

SELECT E.FirstName, E.LastName, D.Name AS Department
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE E.DepartmentID NOT IN 
	(SELECT DepartmentID FROM Departments 
		WHERE Name LIKE 'Production%')
ORDER BY D.Name ASC

SELECT * FROM Addresses
WHERE TownID IN (SELECT TownID FROM Towns WHERE TownID > 20)

SELECT FirstName
FROM Employees
WHERE FirstName LIKE 'A%'

SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE '_____' --EACH _ MEANS ONE MORE CHAR
AND LastName LIKE '____'

--SAME AS:

SELECT FirstName, LastName
FROM Employees
WHERE LEN(FirstName) = 5 AND LEN(LastName) = 4

SELECT FirstName, LastName, Salary
FROM Employees E
WHERE Salary BETWEEN 10000 AND 25000
ORDER BY Salary DESC

SELECT FirstName, LastName, HireDate, Salary
FROM Employees
WHERE HireDate BETWEEN '10-Apr-2000' AND '20-May-2005'

SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID = 1
	OR DepartmentID = 4
	OR DepartmentID = 7

SELECT FirstName, LastName, DepartmentID 
FROM Employees
WHERE DepartmentID IN (1, 4, 7)

SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID IN 
	(SELECT DepartmentID FROM Departments
	WHERE ManagerID = 42)

SELECT FirstName, LastName, DepartmentID
FROM Employees
WHERE DepartmentID IN 
(SELECT DepartmentID FROM Departments WHERE ManagerID = 
	(SELECT EmployeeID FROM Employees 
		WHERE FirstName = 'Jean' 
		AND LastName = 'Trenary'))

SELECT FirstName, LastName, ManagerID
FROM Employees
WHERE ManagerID IS NULL

SELECT FirstName, LastName, ManagerID
FROM Employees
WHERE ManagerID IS NOT NULL

--NO RESULT:
SELECT FirstName, LastName, ManagerID
FROM Employees
WHERE ManagerID = NULL --WRONG!!!

SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary >= 30000 AND LastName LIKE 'C%'

SELECT LastName, ManagerID
FROM Employees
WHERE ManagerID IS NOT NULL AND LastName LIKE '%so_'

SELECT LastName, ManagerID
FROM Employees
WHERE ManagerID IS NOT NULL OR LastName LIKE '%so_'

SELECT FirstName, LastName, ManagerID
FROM Employees
WHERE NOT (ManagerID = 3 OR ManagerID = 4)
ORDER BY ManagerID

SELECT FirstName, LastName, ManagerID, Salary
FROM Employees
WHERE 
(ManagerID = 3 OR ManagerID = 4) AND
(Salary >= 33000 OR ManagerID IS NULL)

SELECT FirstName, LastName, Salary FROM Employees
ORDER BY Salary ASC, FirstName ASC, LastName ASC

SELECT TOP 5 TownID, Name FROM Towns

SELECT TOP (SELECT COUNT(*) FROM Departments) * FROM 
Employees

SELECT *
FROM Towns
ORDER BY Name ASC
OFFSET 20 ROWS
FETCH NEXT 5 ROWS ONLY

SELECT *
FROM Employees
ORDER BY EmployeeID -- THIS IS REQUIRED, WHY?
OFFSET 20 ROWS
FETCH NEXT 5 ROWS ONLY

SELECT LastName, Name AS DepartmentName 
FROM Employees, Departments --CARTESIAN PRODUCT

SELECT LastName, Name AS DepartmentName 
FROM Employees E
CROSS JOIN Departments D --CARTESIAN PRODUCT

--LEFT OUTER JOIN - THE VALUES FROM THE RIGHT TABLE ARE OPTIONAL
--RIGHT OUTER JOIN - THE VALUES FROM THE LEFT TABLE ARE OPTIONAL
--FULL OUTER JOIN - THE VALUES FROM BOTH TABLES ARE OPTIONAL
--CROSS JOIN = CARTESIAN PRODUCT

--LEFT OUTER JOIN = LEFT JOIN
--RIGHT OUTER JOIN = RIGHT JOIN
--FULL OUTER JOIN = FULL JOIN

SELECT 
	E.FirstName, 
	E.LastName, 
	E.DepartmentID,
	D.DepartmentID, 
	D.Name AS [Department Name]
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID

SELECT 
	E.FirstName, 
	E.LastName, 
	P.Name AS [Project Name]
FROM Employees E
INNER JOIN EmployeesProjects EP
ON EP.EmployeeID = E.EmployeeID
INNER JOIN Projects P
ON P.ProjectID = EP.ProjectID
ORDER BY [Project Name]

SELECT 
	E.FirstName, 
	E.LastName, 
	P.Name AS [Project Name]
FROM Employees E
LEFT OUTER JOIN EmployeesProjects EP
ON EP.EmployeeID = E.EmployeeID
LEFT OUTER JOIN Projects P
ON P.ProjectID = EP.ProjectID
ORDER BY [Project Name]

--EQUIJOINS

SELECT 
	E.FirstName, 
	E.LastName, 
	D.Name AS [Department Name]
FROM Employees E, Departments D
WHERE E.DepartmentID = D.DepartmentID --JOIN IN THE WHERE CLAUSE

--INNER, OUTER, FULL JOINS

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
INNER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID
ORDER BY [Manager]

SELECT 
	E.FirstName, 
	E.LastName, 
	ISNULL(M.FirstName + ' ' + M.LastName, '(no manager)') AS [Manager]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
RIGHT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID
ORDER BY [Manager]

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
FULL OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID
ORDER BY [Manager]

SELECT 
	E.FirstName, 
	E.LastName, 
	T.Name + ', ' + A.AddressText AS [Full Address]
FROM Employees E
INNER JOIN Addresses A
ON A.AddressID = E.AddressID
INNER JOIN Towns T
ON T.TownID = A.TownID
WHERE T.Name = 'Redmond'

--SELF JOIN

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
LEFT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
RIGHT OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName, 
	E.LastName, 
	M.FirstName + ' ' + M.LastName AS [Manager]
FROM Employees E
FULL OUTER JOIN Employees M
ON M.EmployeeID = E.ManagerID

SELECT 
	E.FirstName + ' ' + E.LastName + ' is managed by ' 
	+ M.FirstName + ' ' + M.LastName AS [Message]
FROM Employees E
INNER JOIN Employees M
ON M.EmployeeID = E.ManagerID

--CROSS JOIN - THE SAME AS CARTESIAN PRODUCT

SELECT E.LastName, D.Name AS [Department]
FROM Employees E
CROSS JOIN Departments D

SELECT E.LastName, D.Name AS [Department]
FROM Employees E, Departments D

--OTHER THINGS

SELECT E.FirstName, E.LastName, D.Name AS Dept
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Sales'

SELECT E.FirstName, E.LastName, E.HireDate, D.Name AS Department
FROM Employees E
INNER JOIN Departments D
ON (D.DepartmentID = E.DepartmentID 
	AND E.HireDate > '1-1-1999'
	AND D.Name IN ('Sales', 'Finance'))

--INSERT

INSERT INTO Projects (Name, StartDate) VALUES ('New project', GETDATE()) -- DO THIS!!!

INSERT INTO Projects VALUES ('Mission to Mars', NULL, GETDATE(), NULL)

--INSERT SELECTED VALUES

INSERT INTO Projects (Name, StartDate)
	SELECT Name + ' Restructuring', GETDATE() 
	FROM Departments

INSERT INTO EmployeesProjects (EmployeeID, ProjectID) VALUES 
	(1, 5),
	(5, 24),
	(2, 11),
	(3, 12)

UPDATE Employees
	SET LastName = 'Brown'
WHERE EmployeeID = 5

UPDATE Employees 
	SET Salary = Salary * 1.2, JobTitle = 'Senior ' + JobTitle
WHERE DepartmentID = 3

SELECT * FROM Employees WHERE DepartmentID = 3

UPDATE Employees 
	SET Salary = Salary * 2,
	JobTitle = 'Vice President',
	HireDate = GETDATE()
WHERE FirstName = 'Alex'

UPDATE Employees
SET
	FirstName = 'Alexandra',
	LastName = 'Svilarova',
	ManagerID = (SELECT EmployeeID FROM Employees WHERE FirstName = 'Svetlin'),
	JobTitle = 'Manager',
	Salary = Salary * 1.5
WHERE EmployeeID = 155

SELECT * FROM Employees WHERE FirstName LIKE 'Alex%'

SELECT * 
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Engineering'

UPDATE Employees
	SET 
	JobTitle = 'Senior ' + JobTitle,
	Salary = 1.5 * Salary,
	HireDate = GETDATE(),
	ManagerID = (SELECT TOP 1 M.EmployeeID FROM Employees M WHERE M.LastName = 'Tamburello')
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Engineering'

UPDATE Employees
	SET 
	JobTitle = 'Senior ' + JobTitle,
	Salary = 1.5 * Salary,
	HireDate = GETDATE(),
	ManagerID = 3
FROM Employees E
INNER JOIN Departments D
ON D.DepartmentID = E.DepartmentID
WHERE D.Name = 'Engineering'


UPDATE Employees
SET JobTitle = 'Senior ' + JobTitle
FROM Employees e 
  JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Marketing'

--DELETE

BEGIN TRAN

DELETE FROM EmployeesProjects
WHERE EmployeeID = 1

TRUNCATE TABLE EmployeesProjects

SELECT * FROM EmployeesProjects

ROLLBACK TRAN