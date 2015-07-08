/*
Problem 1.	Create a table in SQL Server
Your task is to create a table in SQL Server with 10 000 000 entries (date + text). 
Search in the table by date range. Check the speed (without caching).
You should submit a SQL file with queries and screenshot of speed comparison as a part of your homework.
*/

CREATE DATABASE Performance
ALTER DATABASE Performance MODIFY FILE
( NAME = N'Performance' , SIZE = 1GB , MAXSIZE = UNLIMITED, FILEGROWTH = 1000MB ) 
GO

USE Performance
GO

CREATE TABLE SimpleTable(
	Id int PRIMARY KEY IDENTITY,
	SomeText nvarchar(50) NOT NULL,
	SomeDate date NOT NULL
)
GO

--TRUNCATE TABLE SimpleTable

DECLARE @currIndex int = 0;
WHILE @currIndex < 10000000
  BEGIN
    INSERT INTO SimpleTable VALUES('SampleText' + CAST(@currIndex AS nvarchar(50)), CAST('1900-1-1' AS datetime) + @currIndex)
	SET @currIndex = @currIndex + 1 
  END
GO


/*
Clear cache
*/
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

SELECT SomeDate
FROM SimpleTable
WHERE SomeDate LIKE '20%'

/*
Problem 2.	Add an index to speed-up the search by date 
Your task is to add an index to speed-up the search by date. Test the search speed (after cleaning the cache).
You should submit a SQL file with queries and screenshot of speed comparison as a part of your homework.
*/

GO
CREATE INDEX index_date
ON SimpleTable (SomeDate)

/*
Clear cache
*/
CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; 
GO

GO
SELECT SomeDate
FROM SimpleTable
WHERE SomeDate LIKE '20%'