USE SoftUni

GO
DECLARE @TABLE VARCHAR(50) = 'Projects'

SELECT 'The table is ' + @TABLE

DECLARE @QUERY VARCHAR(100) = 'SELECT * FROM ' + @TABLE
EXEC (@QUERY)

GO

SELECT 'The table is ' + @TABLE

---------------------------
GO
DECLARE @EmpID VARCHAR(11), @LastName CHAR(20)
SET @LastName = 'King'

SET @EmpID = (SELECT EmployeeID FROM Employees WHERE LastName = @LastName)
SELECT @EmpID AS EmployeeID

SELECT @EmpID = EmployeeID FROM Employees WHERE LastName = @LastName
SELECT @EmpID AS EmployeeID
GO

---------------------------

IF
(SELECT COUNT(EmployeeID) FROM Employees) > 1000
	BEGIN 
		PRINT 'OVER 1000'
	END
ELSE
	BEGIN
		PRINT 'UNDER 1000'
	END

-------------------------------------
--CALCULATE FACTORIAL
GO
DECLARE @RESULT BIGINT = 1, @NUM INT = 10
DECLARE @COUNTER INT = @NUM

WHILE (@COUNTER > 1)
	BEGIN
		SET @RESULT = @RESULT * @COUNTER
		SET @COUNTER = @COUNTER - 1
	END

SELECT @RESULT
GO

-------------------------------------
--CALCULATE FIBONACCI
GO
DECLARE @FIRST INT = 1, @SECOND INT = 1, @TEMP INT,  @NthNumber INT = 12
DECLARE @COUNTER INT = @NthNumber

WHILE (@COUNTER > 2)
BEGIN
	SET @TEMP = @FIRST + @SECOND
	SET @FIRST = @SECOND
	SET @SECOND = @TEMP

	SET @COUNTER = @COUNTER - 1
END

PRINT 'The ' + CAST(@NthNumber AS NVARCHAR(10)) + 
	'-th fibonacci number is ' + CAST(@SECOND AS NVARCHAR(10))

----------------------------------------------

SELECT 
	Salary,  
	CASE 
		WHEN Salary BETWEEN 0 AND 10000 THEN 'LOW'
		WHEN Salary BETWEEN 10001 AND 30000 THEN 'AVERAGE'
		WHEN Salary BETWEEN 30001 AND 200000 THEN 'HIGH'
		ELSE 'UNKNOWN'
	END
	AS [Salary Level]
FROM Employees 

--SAME AS:

SELECT 
	Salary,  
	[Salary Level] = 
	CASE 
		WHEN Salary BETWEEN 0 AND 10000 THEN 'LOW'
		WHEN Salary BETWEEN 10001 AND 30000 THEN 'AVERAGE'
		WHEN Salary BETWEEN 30001 AND 200000 THEN 'HIGH'
		ELSE 'UNKNOWN'
	END
FROM Employees 

------------------------------------
DROP PROCEDURE usp_SelectEmployeesBySeniority 

USE SoftUni
GO

CREATE PROCEDURE usp_SelectEmployeesBySeniority 
AS
	SELECT 
		FirstName, 
		LastName, 
		DATEDIFF(YEAR, HireDate, GETDATE()) AS [Years in the company] 
	FROM Employees
		WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 14
GO

EXEC usp_SelectEmployeesBySeniority

--------------------------------------------
GO
CREATE TABLE SeniorStaff (
	ID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	YearsWorked INT NOT NULL
	CONSTRAINT PK_SeniorStaff PRIMARY KEY(ID)
)
GO

INSERT INTO SeniorStaff
	EXEC usp_SelectEmployeesBySeniority

SELECT * FROM SeniorStaff

------------------------------------------
--ALTER PROCEDURE

GO
ALTER PROCEDURE usp_SelectEmployeesBySeniority 
AS
	SELECT 
		FirstName, 
		LastName, 
		DATEDIFF(YEAR, HireDate, GETDATE()) AS [Years in the company] 
	FROM Employees
		WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 14
	ORDER BY [Years in the company] ASC, LastName
GO

EXEC usp_SelectEmployeesBySeniority

---------------------------------------------

EXEC sp_depends 'usp_SelectEmployeesBySeniority'

---------------------------------------------
--STORED PROCEDURES WITH PARAMETERS

DROP PROCEDURE usp_SelectEmployeesBySeniority

GO
CREATE PROCEDURE usp_SelectEmployeesBySeniority (@MinYears INT = 10)
AS
	SELECT 
		FirstName, 
		LastName, 
		DATEDIFF(YEAR, HireDate, GETDATE()) AS [YearsWorked]
	FROM Employees
	WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= @MinYears
	ORDER BY [YearsWorked] ASC, LastName
GO

EXEC usp_SelectEmployeesBySeniority --WITH DEFAULT PARAMETER 10
EXEC usp_SelectEmployeesBySeniority 15 --PARAMETER 15

EXEC usp_SelectEmployeesBySeniority @MinYears = 13

------------------------------------------------------
--CREATE PROCEDURE TO ADD SENIOR STAFF TO THE TABLE

SELECT * FROM SeniorStaff

GO
CREATE PROCEDURE usp_AddSeniorStaff (@FirstName NVARCHAR(50), @LastName NVARCHAR(50), @YearsWorked INT)
AS
	INSERT INTO SeniorStaff (FirstName, LastName, YearsWorked) VALUES
		(@FirstName, @LastName, @YearsWorked)
GO

--PASS VALUES BY POSITION:
EXEC usp_AddSeniorStaff 'Petar', 'Petrov', 20

--PASS VALUES BY PARAMETER NAME:
EXEC usp_AddSeniorStaff @YearsWorked = 7, @FirstName = 'Nick', @LastName = 'Genov'

SELECT * FROM SeniorStaff

--------------------------------------------------------

DROP PROCEDURE usp_AddNumbers

GO
CREATE PROCEDURE usp_AddNumbers (@FirstNumber INT, @SecondNumber INT, @Result INT OUTPUT) --BRACKETS ARE OPTIONAL
AS
	SET @Result = @FirstNumber + @SecondNumber
GO

DECLARE @Answer INT
EXEC usp_AddNumbers 100, 200, @Answer OUTPUT
SELECT @Answer AS Result
GO

DECLARE @Answer INT
EXEC usp_AddNumbers 25, 35, @Answer OUTPUT
SELECT 'The result is: ', @Answer
GO

-------------------------------------------------------------
--RETURNING VALUES
--SCOPE_IDENTITY()

DROP PROC usp_NewEmployee

GO
CREATE PROC usp_NewEmployee(
  @firstName nvarchar(50), @lastName nvarchar(50),
  @jobTitle nvarchar(50), @deptId int, @salary money)
AS
  INSERT INTO Employees(FirstName, LastName, 
    JobTitle, DepartmentID, HireDate, Salary)
  VALUES (@firstName, @lastName, @jobTitle, @deptId,
    GETDATE(), @salary)
  RETURN SCOPE_IDENTITY()
GO

DECLARE @newEmployeeId int
EXEC @newEmployeeId = usp_NewEmployee
  @firstName='Steve', @lastName='Jobs', @jobTitle='Trainee',
  @deptId=1, @salary=7500

SELECT EmployeeID, FirstName, LastName
FROM Employees
WHERE EmployeeId = @newEmployeeId

---------------------------------------------------------------
--TRIGGERS

--FOR TRIGGER:
GO
CREATE TRIGGER tr_TownsUpdate ON Towns FOR UPDATE
AS
	IF (EXISTS(SELECT Name FROM inserted WHERE Name IS NULL) 
			OR EXISTS(SELECT * FROM inserted WHERE LEN(Name) = 0))
		BEGIN
			RAISERROR('Town name cannot be empty!', 16, 1)
			ROLLBACK TRAN
			RETURN
		END
GO

SELECT * FROM Towns WHERE TownID = 2
UPDATE Towns SET NAME = '' WHERE TownID = 2	

SELECT * FROM Towns WHERE TownID = 2

--INSTEAD OF TRIGGER:

CREATE TABLE Accounts(
  Username varchar(10) NOT NULL PRIMARY KEY,
  [Password] varchar(20) NOT NULL,
  Active CHAR NOT NULL DEFAULT 'Y')
GO

GO  
CREATE TRIGGER tr_AccountsDelete ON Accounts INSTEAD OF DELETE
AS
	UPDATE Accounts SET Active = 'N'
	WHERE 
		Active = 'Y' AND 
		Username IN (SELECT Username FROM deleted)
GO

INSERT INTO Accounts (Username, Password, Active) VALUES 
	('Pesho', '123', 'Y'),
	('Gosho', '123', 'Y'),
	('Mimi', '123', 'Y'),
	('Penka', '123', 'Y')


SELECT * FROM Accounts
DELETE FROM Accounts

-----------------------------------------------------
--USER-DEFINED FUNCTIONS

GO
CREATE FUNCTION ufn_CalcBonus (@Salary MONEY) RETURNS MONEY
AS
BEGIN
	IF (@Salary <= 10000)
		RETURN 1000
	ELSE IF (@Salary BETWEEN 10001 AND 20000)
		RETURN 2000
	RETURN 3000
END
GO

SELECT TOP 5
	FirstName, 
	LastName, 
	Salary, 
	dbo.ufn_CalcBonus(Salary) AS [Bonus]
FROM Employees

SELECT DBO.ufn_CalcBonus(10000) AS BONUS
--------------------------------------------
--FUNCTION TO CALCULATE THE TIME AN EMPLOYEE HAS WORKED FOR THE COMPANY

GO
CREATE FUNCTION ufn_EmployeeMonthsWorked(@HireDate DATE) RETURNS INT
AS
	BEGIN
		RETURN DATEDIFF(MONTH, @HireDate, GETDATE())
	END
GO

SELECT TOP 10
	FirstName, 
	LastName, 
	HireDate, 
	DBO.ufn_EmployeeMonthsWorked(HireDate) AS [Months Worked]
FROM Employees
ORDER BY [Months Worked] DESC

---------------------------------------------------------

USE SoftUni
GO
CREATE FUNCTION ufn_EmployeeNamesForJobTitle (@JobTitle NVARCHAR(100))
	RETURNS TABLE
AS
	RETURN (
		SELECT 
			FirstName, 
			LastName 
		FROM Employees
		WHERE JobTitle = @JobTitle
	)
GO

SELECT * FROM DBO.ufn_EmployeeNamesForJobTitle('Stocker')

---------------------------------------------------------------
GO
CREATE FUNCTION ufn_ListEmployees (@Format NVARCHAR(5))
	RETURNS @EmployeeTable TABLE (
		EmployeeID INT NOT NULL PRIMARY KEY,
		EmployeeName NVARCHAR(100) NOT NULL)
AS
BEGIN
	IF @Format = 'short'
		INSERT @EmployeeTable
		SELECT EmployeeID, LastName FROM Employees
	ELSE IF @Format = 'long'
		INSERT @EmployeeTable
		SELECT EmployeeID, (FirstName + ' ' + LastName) FROM Employees
	RETURN
END
GO

SELECT * FROM ufn_ListEmployees('long')

SELECT * FROM ufn_ListEmployees('short')

---------------------------------------------------------------------
--CURSORS

DECLARE employeesCursor CURSOR READ_ONLY FOR
	SELECT FirstName, LastName FROM Employees

OPEN employeesCursor
DECLARE @FirstName NVARCHAR(50), @LastName NVARCHAR(50)
FETCH NEXT FROM employeesCursor INTO @FirstName, @LastName

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @FirstName + ' ' + @LastName

		FETCH NEXT FROM employeesCursor INTO @FirstName, @LastName
	END

CLOSE employeesCursor
DEALLOCATE employeesCursor