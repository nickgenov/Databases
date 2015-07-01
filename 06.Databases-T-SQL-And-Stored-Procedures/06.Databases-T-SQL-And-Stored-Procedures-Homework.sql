/*
Problem 1.	Create a database with two tables
Persons (id (PK), first name, last name, SSN) and Accounts (id (PK), 
person id (FK), balance). Insert few records for testing. 
Write a stored procedure that selects the full names of all persons.
*/

CREATE DATABASE TransactSQL

USE TransactSQL

GO
CREATE TABLE Persons (
	ID INT IDENTITY NOT NULL,
	FirstName NVARCHAR(100) NOT NULL,
	LastName NVARCHAR(100) NOT NULL,
	SSN INT NOT NULL
	CONSTRAINT PK_Persons PRIMARY KEY (ID)
)
GO

/*
CREATE TABLE Accounts (
	ID INT IDENTITY NOT NULL,
	PersonID INT NOT NULL,
	Balance MONEY NULL
	CONSTRAINT PK_Accounts PRIMARY KEY (ID)
)
GO

ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Persons FOREIGN KEY (PersonID) REFERENCES Persons (ID)

DROP TABLE Accounts
*/

USE TransactSQL
GO
CREATE TABLE Accounts (
	ID INT IDENTITY NOT NULL,
	PersonID INT NOT NULL,
	Balance MONEY NULL
	CONSTRAINT PK_Accounts PRIMARY KEY (ID),
	CONSTRAINT FK_Accounts_Persons FOREIGN KEY (PersonID) REFERENCES Persons (ID)
)
GO

INSERT INTO Persons (FirstName, LastName, SSN) VALUES
	('Petar', 'Petrov', 321654987),
	('Ivan', 'Ivanov', 852963740),
	('Minka', 'Gicheva', 987357159),
	('Stamat', 'Stamatov', 951753852),
	('Maria', 'Petrova', 123159753)

INSERT INTO Accounts (PersonID, Balance) VALUES
	(1, 50001),
	(2, 60000),
	(3, 15020),
	(4, 23000),
	(5, 18500)


USE TransactSQL
GO
CREATE PROCEDURE usp_PersonsFullNames
AS
	SELECT FirstName + ' ' + LastName AS [Full Name] 
	FROM Persons
GO

EXEC usp_PersonsFullNames

/*
Problem 2.	Create a stored procedure
Your task is to create a stored procedure that accepts a number as a parameter 
and returns all persons who have more money in their accounts than the supplied number.
*/

USE TransactSQL
GO
CREATE PROCEDURE usp_ReturnPersonsWithMoneyOver (@Money MONEY)
AS
		SELECT 
		P.FirstName, 
		P.LastName, 
		A.Balance
	FROM Persons P
	INNER JOIN Accounts A
	ON A.PersonID = P.ID
	WHERE A.Balance > @Money
GO

EXEC usp_ReturnPersonsWithMoneyOver 1000

GO
DECLARE @MoneyAmount MONEY
	SET @MoneyAmount = 1500
	EXEC usp_ReturnPersonsWithMoneyOver @MoneyAmount
GO

/*
Problem 3.	Create a function with parameters
Your task is to create a function that accepts as parameters – sum, 
yearly interest rate and number of months. It should calculate and return 
the new sum. Write a SELECT to test whether the function works as expected.
*/

USE TransactSQL
GO
CREATE FUNCTION ufn_CalculateInterest 
	(@Sum MONEY, @InterestRate REAL, @Months INT)
	RETURNS MONEY
AS
	BEGIN
		DECLARE 
			@MonthlyMultiplier REAL, 
			@TotalMultiplier REAL,
			@Result MONEY

		SET @MonthlyMultiplier = (@InterestRate / 12) / 100
		SET @TotalMultiplier = @MonthlyMultiplier * @Months
		SET @Result = (@TotalMultiplier + 1) * @Sum

		RETURN @Result
	END
GO

SELECT dbo.ufn_CalculateInterest (10000, 6, 7) AS [Money With Interest]
SELECT dbo.ufn_CalculateInterest (100, 12, 10) AS [Money With Interest]

/*
Problem 4.	Create a stored procedure that uses the function from the previous example.
Your task is to create a stored procedure that uses the function from the previous example 
to give an interest to a person's account for one month. It should take the AccountId and 
the interest rate as parameters.
*/

USE TransactSQL
GO

CREATE PROCEDURE usp_AccountInterestForOneMonth (@AccountID INT, @InterestRate REAL)
AS
	DECLARE @Balance MONEY
	SET @Balance = (SELECT Balance FROM Accounts WHERE ID = @AccountID)

	SELECT dbo.ufn_CalculateInterest (@Balance, 1, @InterestRate) AS [Money With Interest]
GO

EXEC usp_AccountInterestForOneMonth 1, 5
EXEC usp_AccountInterestForOneMonth 2, 10

/*
Problem 5.	Add two more stored procedures WithdrawMoney and DepositMoney.
Add two more stored procedures WithdrawMoney (AccountId, money) and 
DepositMoney (AccountId, money) that operate in transactions.
*/

USE TransactSQL
GO
CREATE PROCEDURE usp_WithdrawMoney (@AccountID INT, @Amount MONEY)
AS
	UPDATE Accounts 
	SET Balance = Balance - @Amount 
	WHERE ID = @AccountID
GO

SELECT ID, Balance FROM Accounts WHERE ID = 1
EXEC usp_WithdrawMoney 1, 100
SELECT ID, Balance FROM Accounts WHERE ID = 1

USE TransactSQL
GO
CREATE PROCEDURE usp_DepositMoney (@AccountID INT, @Amount MONEY)
AS
	UPDATE Accounts 
	SET Balance = Balance + @Amount 
	WHERE ID = @AccountID
	
GO	

SELECT ID, Balance FROM Accounts WHERE ID = 1
EXEC usp_DepositMoney 1, 1000
SELECT ID, Balance FROM Accounts WHERE ID = 1

/*
Problem 6.	Create table Logs.
Create another table – Logs (LogID, AccountID, OldSum, NewSum). Add a trigger to the 
Accounts table that enters a new entry into the Logs table every time the sum on an account changes.
*/

USE TransactSQL
GO
CREATE TABLE Logs (
	LogID INT IDENTITY NOT NULL,
	AccountID INT NOT NULL,
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL
	CONSTRAINT PK_Logs PRIMARY KEY(LogID),
	CONSTRAINT FK_Logs_Accounts FOREIGN KEY (AccountID) REFERENCES Accounts(ID)
)
GO

USE TransactSQL
GO
CREATE TRIGGER tr_AccountsChange ON Accounts FOR INSERT, DELETE, UPDATE
AS
	BEGIN
	DECLARE @AccountID INT, @OldSum MONEY, @NewSum MONEY

	SET @AccountID = (SELECT I.ID FROM INSERTED I)
	SET @NewSum = (SELECT I.Balance FROM INSERTED I)
	SET @OldSum = (SELECT D.Balance FROM DELETED D)

	INSERT INTO Logs (AccountID, OldSum, NewSum) VALUES
		(@AccountID, @OldSum, @NewSum)

	END
GO

SELECT * FROM Accounts
SELECT * FROM Logs

UPDATE Accounts SET Balance = 10000 WHERE ID = 1
UPDATE Accounts SET Balance = 20000 --PROBLEM WHEN UPDATIGN MORE THAN ONE ROW, FIX IT!

SELECT * FROM Accounts
SELECT * FROM Logs


/*
Problem 7.	Define function in the SoftUni database.
Define a function in the database SoftUni that returns all Employee's names 
(first or middle or last name) and all town's names that are comprised of given set of letters. 
Example: 'oistmiahf' will return 'Sofia', 'Smith', but not 'Rob' and 'Guy'.
*/

/*
Problem 8.	Using database cursor write a T-SQL
Using database cursor write a T-SQL script that scans all employees and their 
addresses and prints all pairs of employees that live in the same town.
*/




/*
Wood: John Wood Redmond John
Hill: John Wood Redmond Annette
Feng: John Wood Redmond Hanying
Sousa: John Wood Redmond Anibal
Glimp: John Wood Redmond Diane
Pournasseh: John Wood Redmond Houman
Kane: John Wood Redmond Lori
…
*/



/*
Problem 9.	Define a .NET aggregate function
Define a .NET aggregate function StrConcat that takes as input a sequence of strings 
and return a single string that consists of the input strings separated by ','. 
For example the following SQL statement should return a single string:
SELECT StrConcat (FirstName + ' ' + LastName)
FROM Employees
*/

/*
Problem 10.	*Write a T-SQL script
Write a T-SQL script that shows for each town a list of all employees that live in it. Sample output:
Sofia -> Svetlin Nakov, Martin Kulov, Vladimir Georgiev
Ottawa -> Jose Saraiva,
*/ 


