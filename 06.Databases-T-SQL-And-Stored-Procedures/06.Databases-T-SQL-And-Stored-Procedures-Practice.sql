EXEC sp_who

USE SoftUni
GO

DECLARE @table VARCHAR(50) = 'Projects'
--SELECT @table
SELECT 'The table is: ' + @table
DECLARE @query VARCHAR(50) = 'SELECT * FROM ' + @table
EXEC (@query)

GO

DECLARE @EmpID VARCHAR(11),
	@LastName CHAR(20)
SET @LastName = 'King'
SELECT @EmpID = EmployeeID FROM Employees --SELECT ALSO ASSIGNS THE VARIABLE
WHERE LastName = @LastName
SELECT @EmpID AS EmployeeID

SELECT DB_NAME() AS [Active Database]

SELECT DATEDIFF(YEAR, HireDate, GETDATE()) * Salary / 1000
FROM Employees E

GO
DECLARE @Count INT = 1
IF ((SELECT COUNT(EmployeeID) FROM Employees) > @Count)
	BEGIN
		PRINT 'The employees MORE than ' + CAST(@Count AS NVARCHAR(100))
	END
ELSE
	BEGIN
		PRINT 'Employees are LESS than ' + CAST(@Count AS NVARCHAR(100))
	END
GO

-----

DECLARE @Number BIGINT = 20, 
		@Factorial BIGINT = 1

WHILE (@Number > 1)
	BEGIN
		SET @Factorial = @Factorial * @Number
		SET @Number = @Number - 1
	END
PRINT @Factorial

------

SELECT 
	Salary, 
	[Salary Level] =
	CASE
		WHEN Salary BETWEEN 0 AND 9999 THEN 'LOW'
		WHEN Salary BETWEEN 10000 AND 30000 THEN 'AVERAGE'
		WHEN Salary > 30000 THEN 'HIGH'
		ELSE 'UNKNOWN'
	END
FROM Employees E

SELECT 
	Salary,
	[Salary Level] =
	CASE	
		WHEN Salary BETWEEN 0 AND 9999 THEN 'LOW'
		WHEN Salary BETWEEN 10000 AND 30000 THEN 'AVERAGE'
		WHEN Salary > 30000 THEN 'HIGH'
		ELSE 'UNKNOWN'
	END
FROM Employees
ORDER BY [Salary Level] ASC, Salary DESC

--------------------------------

USE SoftUni
GO

CREATE PROC dbo.usp_SelectEmployeesBySeniority 
	AS
	SELECT 
		FirstName, 
		LastName, 
		Salary, 
		HireDate
	FROM Employees
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5
GO

EXEC usp_SelectEmployeesBySeniority

USE SoftUni
GO

CREATE PROC dbo.usp_SelectEmployeesWithManager
AS
	SELECT
		E.FirstName,
		E.LastName,
		M.FirstName + ' ' + M.LastName AS [Manager]
	FROM Employees E
	INNER JOIN Employees M
	ON M.EmployeeID = E.ManagerID
	WHERE E.ManagerID IS NOT NULL
	ORDER BY [Manager] ASC
GO

EXEC usp_SelectEmployeesWithManager

CREATE TABLE Customers (
	ID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL
	CONSTRAINT PK_Customers PRIMARY KEY (ID)
	)

--Intellisense problem with added columns?

ALTER TABLE Customers
ADD Manager NVARCHAR(100) NULL

DROP TABLE Customers

CREATE TABLE Customers (
	ID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Manager NVARCHAR(100) NULL
	CONSTRAINT PK_Customers PRIMARY KEY (ID)
	)

--INSERT STORED PROCEDURE DATA
--COLUMN DATA TYPES MUST MATCH

BEGIN TRAN
INSERT INTO Customers (FirstName, LastName, Manager)
EXEC usp_SelectEmployeesWithManager
COMMIT TRAN

SELECT * FROM Customers

-------------------------------------------

USE SoftUni
GO
CREATE PROCEDURE usp_SelectEmployeesWithoutManager
AS
	SELECT 
		FirstName, 
		LastName, 
		ISNULL(CAST(ManagerID AS NVARCHAR(100)), '(no manager)') AS [Manager]
	FROM Employees
	WHERE ManagerID IS NULL
GO

EXEC usp_SelectEmployeesWithoutManager

INSERT INTO Customers (FirstName, LastName, Manager)
EXEC usp_SelectEmployeesWithoutManager

INSERT INTO Customers
EXEC usp_SelectEmployeesWithoutManager

-------------------------------
USE SoftUni
GO
ALTER PROC usp_SelectEmployeesWithoutManager
AS
	SELECT 
		FirstName, 
		LastName, 
		ManagerID,
		ISNULL(CAST(ManagerID AS NVARCHAR(100)), '(no manager)') AS [Manager]
	FROM Employees
	WHERE ManagerID IS NULL
GO

USE SoftUni
GO
ALTER PROC usp_SelectEmployeesWithoutManager
AS
	SELECT 
		E.FirstName,
		E.LastName,
		M.FirstName + M.LastName AS [Manager],
		D.Name AS [Department]
	FROM Employees E
	INNER JOIN Employees M
	ON M.EmployeeID = E.ManagerID
	INNER JOIN Departments D
	ON D.DepartmentID = E.DepartmentID
	WHERE D.Name IN ('Sales', 'Engineering')
	ORDER BY Department ASC, Manager ASC
GO

EXEC usp_SelectEmployeesWithoutManager

--------------------------------------
USE SoftUni
EXEC sp_depends usp_SelectEmployeesWithoutManager

---------------------------------------
--STORED PROCEDURES WITH PARAMETERS

BEGIN TRAN

USE SoftUni
GO
CREATE PROCEDURE usp_ManagersBySeniority (@YearsWorked INT)
AS
	SELECT 
		M.FirstName + ' ' + M.LastName AS [Manager],
		DATEDIFF(YEAR, M.HireDate, GETDATE()) AS [Worked for years]
	FROM Employees E
	INNER JOIN Employees M
	ON M.EmployeeID = E.ManagerID
	WHERE DATEDIFF(YEAR, M.HireDate, GETDATE()) > @YearsWorked
	GROUP BY M.FirstName, M.LastName, M.HireDate
	ORDER BY [Worked for years] DESC, [Manager] ASC
GO
	
COMMIT TRAN

EXEC usp_ManagersBySeniority 5

USE SoftUni
GO

ALTER PROC usp_ManagersBySeniority (@MinYears INT, @MaxYears INT)
AS
	SELECT 
		M.FirstName + ' ' + M.LastName AS [Manager],
		DATEDIFF(YEAR, M.HireDate, GETDATE()) AS [Worked for years]
	FROM Employees E
	INNER JOIN Employees M
	ON M.EmployeeID = E.ManagerID
	WHERE 
		DATEDIFF(YEAR, M.HireDate, GETDATE()) BETWEEN @MinYears AND @MaxYears		
	GROUP BY M.FirstName, M.LastName, M.HireDate
	ORDER BY [Worked for years] DESC, [Manager] ASC
GO

EXEC usp_ManagersBySeniority 5, 14

--ADD DEFAULT VALUES TO THE PROCEDURE

USE SoftUni
GO

ALTER PROC usp_ManagersBySeniority (@MinYears INT = 5, @MaxYears INT = 15)
AS
	SELECT 
		M.FirstName + ' ' + M.LastName AS [Manager],
		DATEDIFF(YEAR, M.HireDate, GETDATE()) AS [Worked for years]
	FROM Employees E
	INNER JOIN Employees M
	ON M.EmployeeID = E.ManagerID
	WHERE 
		DATEDIFF(YEAR, M.HireDate, GETDATE()) BETWEEN @MinYears AND @MaxYears		
	GROUP BY M.FirstName, M.LastName, M.HireDate
	ORDER BY [Worked for years] DESC, [Manager] ASC
GO

EXEC usp_ManagersBySeniority
EXEC usp_ManagersBySeniority 15, 16

----------------------------------------

SELECT * FROM Customers

USE SoftUni
GO

CREATE PROCEDURE usp_AddCustomer (
	@FirstName NVARCHAR(50), 
	@LastName NVARCHAR(50),
	@Manager NVARCHAR(100))
	AS
	INSERT INTO Customers 
		(FirstName, LastName, Manager) VALUES 
		(@FirstName, @LastName, @Manager)
GO

EXEC usp_AddCustomer 'Petar', 'Petrov', 'Jenja'

EXEC usp_AddCustomer 
	@FirstName = 'Ivan', 
	@LastName = 'Kolev', 
	@Manager = 'Petrov'

	
SELECT * FROM Customers

------------------------
--OUTPUT PARAMETERS IN A PROCEDURE

USE SoftUni
GO
CREATE PROCEDURE usp_AddNumbers  --BRACKETS ARE OPTIONAL
	@FirstNumber INT,
	@SecondNumber INT,
	@Result INT OUTPUT
AS
	SET @Result = @FirstNumber + @SecondNumber
GO


DECLARE @Answer INT
EXEC usp_AddNumbers 1213, 123123, @Answer OUTPUT
SELECT 'The result is: ', @Answer AS Result

-------------------------------
--RETURN
SELECT * FROM Customers

/*
GO
ALTER TABLE Customers
ADD Date DATE NULL
GO


USE SoftUni
GO
CREATE PROCEDURE usp_NewCustomer
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Manager NVARCHAR(100),
	@Date DATE
AS
	INSERT INTO Customers 
		(FirstName, LastName, Manager, Date) VALUES --INVALID COLUMN NAME DATE?!
		(@FirstName, @LastName, @Manager, GETDATE())
GO
*/

DROP TABLE Customers

CREATE TABLE Customers (
	ID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Manager NVARCHAR(100) NULL,
	Date DATE NULL
	CONSTRAINT PK_Customers PRIMARY KEY (ID)
	)


USE SoftUni
GO
CREATE PROCEDURE usp_NewCustomer
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Manager NVARCHAR(100),
	@Date DATE
AS
	INSERT INTO Customers 
		(FirstName, LastName, Manager, Date) VALUES --Now Date is valid, why?
		(@FirstName, @LastName, @Manager, GETDATE())
	RETURN SCOPE_IDENTITY()
GO

BEGIN TRAN

DECLARE @newCustomerID INT
EXEC @newCustomerID = usp_NewCustomer
  @FirstName = 'Steve', 
  @LastName = 'Jobs', 
  @Manager = 'Nakov',
  @Date = '1-1-2015'
SELECT ID, FirstName, LastName, Manager, Date
FROM Customers
WHERE ID = @newCustomerID

COMMIT TRAN

------------------------
--TRIGGERS

--UPDATE TRIGGER:

USE SoftUni
GO
CREATE TRIGGER tr_TownsUpdate ON Towns FOR UPDATE
AS
	IF EXISTS((SELECT TownID FROM dbo.Towns WHERE Name IS NULL) OR
		EXISTS(SELECT TownID FROM dbo.Towns WHERE LEN(Name) = 0))
		BEGIN
			RAISERROR ('Town name cannot be empty', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END
GO

USE SoftUni
GO
ALTER TRIGGER tr_TownsUpdate ON dbo.Towns FOR UPDATE
AS
	IF (EXISTS(SELECT TownID FROM dbo.Towns WHERE Name IS NULL) OR
		EXISTS(SELECT TownID FROM dbo.Towns WHERE LEN(Name) = 0))
		BEGIN
			RAISERROR ('Town name cannot be empty or NULL!', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END
GO


UPDATE dbo.Towns SET NAME = '' WHERE TownID = 1

--INSERT TRIGGER:
USE SoftUni

GO	
CREATE TRIGGER tr_TownsInsert ON dbo.Towns FOR INSERT
AS
	IF (EXISTS(SELECT * FROM dbo.Towns WHERE LEN(Name) > 20))
		BEGIN
			RAISERROR ('Town names cannot be over 20 letters long!', 16, 1)
			ROLLBACK TRANSACTION
			RETURN
		END
GO


INSERT INTO dbo.Towns (Name) VALUES ('12345678901234567890') --THIS WORKS

INSERT INTO dbo.Towns (Name) VALUES ('123456789012345678901') --THIS DOES NOT

--INSTEAD OF TRIGGERS

GO
CREATE TABLE Accounts (
	ID INT NOT NULL IDENTITY,
	Name NVARCHAR(50) NOT NULL,
	[Password] NVARCHAR(50) NOT NULL,
	ACTIVE CHAR(1) NOT NULL DEFAULT 'Y'
	CONSTRAINT PK_Accounts PRIMARY KEY (ID)
)
GO

USE SoftUni
GO
CREATE TRIGGER tr_AccountsDelete ON Accounts INSTEAD OF DELETE
AS
	UPDATE A SET A.Active = 'N'
	FROM Accounts A
	JOIN DELETED D
	ON A.ID = D.ID
	WHERE A.ACTIVE = 'Y'
GO

SELECT * FROM ACCOUNTS

INSERT INTO ACCOUNTS (Name, Password) VALUES
		('BBB', '123')

DELETE FROM ACCOUNTS
SELECT * FROM ACCOUNTS