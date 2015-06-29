/*процедура с няколко параметъра

факториел
фибоначи
трибоначи
елементарна задачка от ц басикс
всички примери от демото*/



--EXEC sp_who
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
SELECT @EmpID = EmployeeID FROM Employees
WHERE LastName = @LastName
SELECT @EmpID AS EmployeeID