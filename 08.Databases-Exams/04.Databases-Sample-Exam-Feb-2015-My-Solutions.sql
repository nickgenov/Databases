/*
Problem 1.	All Ad Titles
Display all ad titles in ascending order.
*/

SELECT Title 
FROM Ads
ORDER BY Title ASC

/*
Problem 2.	Ads in Date Range
Find all ads created between 26-December-2014 (00:00:00) and 1-January-2015 (23:59:59) sorted by date. 
*/

SELECT 
	Title, 
	[Date]
FROM Ads
WHERE
	[Date] >= '26-Dec-2014' 
	AND [Date] < '02-Jan-2015'
ORDER BY [Date] ASC

/*
Problem 3.	* Ads with "Yes/No" Images
Display all ad titles and dates along with a column named "Has Image" holding "yes" 
or "no" for all ads sorted by their Id.
*/

SELECT 
	Title, 
	[Date], 
	CASE
		WHEN ImageDataURL IS NULL THEN 'no'
		ELSE 'yes'
	END AS [Has Image]
FROM Ads
ORDER BY Id ASC

/*
Problem 4.	Ads without Town, Category or Image
Find all ads that have no town or no category or no image sorted by Id. 
Show all their data.
*/

SELECT * FROM Ads
WHERE 
	TownId IS NULL 
	OR CategoryId IS NULL 
	OR ImageDataURL IS NULL
ORDER BY Id ASC

/*
Problem 5.	Ads with Their Town
Find all ads along with their towns sorted by Id. Display the ad title and town 
(even when there is no town). Name the columns exactly like in the table below. 
*/

SELECT 
	A.Title, 
	T.Name AS [Town]
FROM Ads A
LEFT OUTER JOIN Towns T ON T.Id = A.TownId
ORDER BY A.Id

/*
Problem 6.	Ads with Their Category, Town and Status
Find all ads along with their categories, towns and statuses sorted by Id. 
Display the ad title, category name, town name and status. Include all ads without town 
or category or status. Name the columns exactly like in the table below. 
*/

SELECT 
	A.Title, 
	C.Name AS [CategoryName], 
	T.Name AS [TownName],
	S.Status AS [Status]
FROM Ads A
LEFT OUTER JOIN Categories C ON C.Id = A.CategoryId
LEFT OUTER JOIN Towns T ON T.Id = A.TownId
LEFT OUTER JOIN AdStatuses S ON S.Id = A.StatusId
ORDER BY A.Id

/*
Problem 7.	Filtered Ads with Category, Town and Status
Find all Published ads from Sofia, Blagoevgrad or Stara Zagora, along with their category, 
town and status sorted by title. Display the ad title, category name, town name and status. 
Name the columns exactly like in the table below. 
*/

SELECT 
	A.Title, 
	C.Name AS [CategoryName], 
	T.Name AS [TownName],
	S.Status AS [Status]
FROM Ads A
LEFT OUTER JOIN Categories C ON C.Id = A.CategoryId
LEFT OUTER JOIN Towns T ON T.Id = A.TownId
LEFT OUTER JOIN AdStatuses S ON S.Id = A.StatusId
WHERE 
	T.Name IN ('Sofia', 'Blagoevgrad', 'Stara Zagora')
	AND S.Status = 'Published'
ORDER BY A.Title

/*
Problem 8.	Earliest and Latest Ads
Find the dates of the earliest and the latest ads. 
Name the columns exactly like in the table below. 
*/

SELECT 
	MIN(Date) AS [MinDate], 
	MAX(Date) AS [MaxDate]
FROM Ads

/*
Problem 9.	Latest 10 Ads
Find the latest 10 ads sorted by date in descending order. Display for each ad its title, date 
and status. Name the columns exactly like in the table below. 
*/

SELECT TOP 10
	A.Title, 
	A.[Date], 
	S.[Status] AS [Status]
FROM Ads A
LEFT OUTER JOIN AdStatuses S ON S.Id = A.StatusId
ORDER BY A.[Date] DESC

/*
Problem 10.	Not Published Ads from the First Month
Find all not published ads, created in the same month and year like the earliest ad. 
Display for each ad its id, title, date and status. Sort the results by Id. 
Name the columns exactly like in the table below. 
*/

SELECT 
	A.Id, 
	A.Title, 
	A.[Date], 
	S.[Status]
FROM Ads A
LEFT OUTER JOIN AdStatuses S ON S.Id = A.StatusId
WHERE 
	DATEPART(MONTH, A.[Date]) = (SELECT DATEPART(MONTH, MIN([Date])) FROM Ads)
	AND DATEPART(YEAR, A.[Date]) = (SELECT DATEPART(YEAR, MIN([Date])) FROM Ads)
	AND S.[Status] <> 'Published'
ORDER BY A.Id ASC

/*
Problem 11.	Ads by Status
Display the count of ads in each status. Sort the results by status. Name the columns exactly 
like in the table below.
*/

SELECT 
	S.[Status], 
	COUNT(A.Id) AS [Count]
FROM Ads A
JOIN AdStatuses S ON S.Id = A.StatusId
GROUP BY S.[Status]
ORDER BY S.[Status] ASC

/*
Problem 12.	Ads by Town and Status
Display the count of ads for each town and each status. Sort the results by town, 
then by status. Display only non-zero counts. Name the columns exactly like in the table below. 
*/

SELECT 
	T.Name AS [Town Name], 
	S.[Status] AS [Status], 
	COUNT(A.Id) AS [Count]
FROM Ads A
INNER JOIN Towns T ON T.Id = A.TownId
INNER JOIN AdStatuses S ON S.Id = A.StatusId
GROUP BY T.Name, S.[Status]
HAVING COUNT(A.Id) <> 0
ORDER BY T.Name ASC, S.[Status] ASC

/*
Problem 13.	* Ads by Users
Find the count of ads for each user. Display the username, ads count and "yes" or "no" 
depending on whether the user belongs to the role "Administrator". Sort the results by username. 
Display all users, including the users who have no ads. Name the columns exactly like in the 
table below. 
*/

SELECT 
	U.UserName, 
	COUNT(A.Id) AS [AdsCount], 
	CASE 
		WHEN R.Name = 'Administrator' THEN 'yes'
		ELSE 'no'
	END AS [IsAdministrator]
FROM Ads A
RIGHT OUTER JOIN AspNetUsers U ON U.Id = A.OwnerId
LEFT OUTER JOIN AspNetUserRoles UR ON UR.UserId = U.Id
LEFT OUTER JOIN AspNetRoles R ON R.Id = UR.RoleId
GROUP BY U.UserName, R.Name
ORDER BY U.UserName ASC

--REWRITE IT TO SHOW DISTINCT ROWS

SELECT OwnerId, COUNT(Id) FROM Ads GROUP BY OwnerId
SELECT * FROM AspNetUsers

SELECT * FROM AspNetUserRoles WHERE UserId = '39b7333d-664b-428d-9e11-4cde699d5e5e'

/*
Problem 14.	Ads by Town
Find the count of ads for each town. Display the ads count and town name or "(no town)" 
for the ads without a town. Display only the towns, which hold 2 or 3 ads. Sort the results 
by town name. Name the columns exactly like in the table below.
*/

SELECT 
	COUNT(A.Id) AS [AdsCount],
	ISNULL(T.Name, '(no town)') AS [Town]
FROM Ads A
LEFT OUTER JOIN Towns T ON T.Id = A.TownId
GROUP BY T.Name
HAVING COUNT(A.Id) IN (2, 3)
ORDER BY T.Name ASC

/*
Problem 15.	Pairs of Dates within 12 Hours
Consider the dates of the ads. Find among them all pairs of different dates, 
such that the second date is no later than 12 hours after the first date. 
Sort the dates in increasing order by the first date, then by the second date. 
Name the columns exactly like in the table below. 
*/

SELECT 
	F.[Date] AS [FirstDate], 
	S.[Date] AS [SecondDate]
FROM Ads F, Ads S
WHERE 
	F.[Date] < S.[Date] 
	AND DATEDIFF(HOUR, F.[Date], S.[Date]) < 12
ORDER BY F.[Date] ASC, S.[Date] ASC

/*
Problem 16.	Ads by Country
1.	Create a table Countries(Id, Name). Use auto-increment for the primary key. 
Add a new column CountryId in the Towns table to link each town to some country 
(non-mandatory link). Create a foreign key between the Countries and Towns tables.
*/

CREATE TABLE Countries (
	Id INT IDENTITY NOT NULL, 
	Name NVARCHAR(100)
	CONSTRAINT PK_Countries PRIMARY KEY (Id)
)
GO

ALTER TABLE Towns
	ADD CountryId INT NULL
GO

ALTER TABLE Towns
	ADD CONSTRAINT FK_Towns_Countries 
	FOREIGN KEY (CountryId) REFERENCES Countries (Id)
GO

/*
2.	Execute the following SQL script (it should pass without any errors):
*/

INSERT INTO Countries(Name) VALUES ('Bulgaria'), ('Germany'), ('France')
UPDATE Towns SET CountryId = (SELECT Id FROM Countries WHERE Name='Bulgaria')
INSERT INTO Towns VALUES
('Munich', (SELECT Id FROM Countries WHERE Name='Germany')),
('Frankfurt', (SELECT Id FROM Countries WHERE Name='Germany')),
('Berlin', (SELECT Id FROM Countries WHERE Name='Germany')),
('Hamburg', (SELECT Id FROM Countries WHERE Name='Germany')),
('Paris', (SELECT Id FROM Countries WHERE Name='France')),
('Lyon', (SELECT Id FROM Countries WHERE Name='France')),
('Nantes', (SELECT Id FROM Countries WHERE Name='France'))

/*
3.	Write and execute a SQL command that changes the town to "Paris" 
for all ads created at Friday.
*/

UPDATE Ads 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Paris')
WHERE DATEPART(WEEKDAY, Date) = 6

/*
4.	Write and execute a SQL command that changes the town to "Hamburg" 
for all ads created at Thursday.
*/

UPDATE Ads 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Hamburg')
WHERE DATEPART(WEEKDAY, Date) = 5

/*
5.	Delete all ads created by user in role "Partner".
*/

SELECT * FROM Ads WHERE OwnerId IN 
	(SELECT U.Id FROM AspNetUsers U
		JOIN AspNetUserRoles UR ON UR.UserId = U.Id
		JOIN AspNetRoles R ON R.Id = UR.RoleId
		WHERE R.Name = 'Partner')

DELETE FROM Ads WHERE OwnerId IN 
	(SELECT U.Id FROM AspNetUsers U
		JOIN AspNetUserRoles UR ON UR.UserId = U.Id
		JOIN AspNetRoles R ON R.Id = UR.RoleId
		WHERE R.Name = 'Partner')

/*
6.	Add a new add holding the following information: Title="Free Book", 
Text="Free C# Book", Date={current date and time}, Owner="nakov", 
Status="Waiting Approval".
*/

INSERT INTO Ads (Title, Text, Date, OwnerId, StatusId) VALUES
	('Free Book',
	 'Free C# Book',
	 GETDATE(),
	 (SELECT Id FROM AspNetUsers WHERE UserName = 'nakov'),
	 (SELECT Id FROM AdStatuses WHERE Status = 'Waiting Approval')
	)

/*
7.	Find the count of ads for each town. Display the ads count, the town name and the country 
name. Include also the ads without a town and country. Sort the results by town, 
then by country. Name the columns exactly like in the table below. 
*/

SELECT 
	T.Name AS [Town],
	C.Name AS [Country],
	COUNT(A.Id) AS [AdsCount]
FROM Ads A
	FULL OUTER JOIN Towns T ON T.Id = A.TownId
	FULL OUTER JOIN Countries C ON C.Id = T.CountryId
GROUP BY T.Name, C.Name
ORDER BY T.Name ASC, C.Name ASC

/*
Problem 17.	Create a View and a Stored Function
Create a view "AllAds" in the database that holds information about ads: 
id, title, author (username), date, town name, category name and status, sorted by id. 
*/

GO
CREATE VIEW AllAds AS
	SELECT 
		A.Id, A.Title, 
		U.UserName AS [Author], 
		A.[Date], 
		T.Name AS [Town], 
		C.Name AS [Category], 
		S.[Status]
	FROM Ads A
		INNER JOIN AspNetUsers U ON U.Id = A.OwnerId
		LEFT OUTER JOIN Towns T ON T.Id = A.TownId
		LEFT OUTER JOIN Categories C ON C.Id = A.CategoryId
		INNER JOIN AdStatuses S ON S.Id = A.StatusId
GO

SELECT * FROM AllAds

/*
1.	Using the view above, create a stored function "fn_ListUsersAds" that returns a table, 
holding all users in descending order as first column, along with all dates of their ads 
(in ascending order) in format "yyyyMMdd", separated by "; " as second column.
*/

USE Ads
GO
CREATE FUNCTION fn_ListUsersAds()
RETURNS TABLE
AS
RETURN (
  SELECT Author FROM AllAds
)

/*
Problem 17.	Create a View and a Stored Function
Create a view "AllAds" in the database that holds information about ads: id, title, author (username),
date, town name, category name and status, sorted by id. If you execute the following SQL query:

SELECT * FROM AllAds
*/

USE Ads

GO
CREATE VIEW AllAds
AS
SELECT 
  a.Id,
  a.Title, 
  u.UserName AS Author,
  a.Date,
  t.Name AS Town, 
  c.Name AS Category,
  s.Status AS Status
FROM
  Ads a
  LEFT JOIN Towns t on a.TownId = t.Id
  LEFT JOIN Categories c on a.CategoryId = c.Id
  LEFT JOIN AdStatuses s on a.StatusId = s.Id
  LEFT JOIN AspNetUsers u on u.Id = a.OwnerId
GO

SELECT * FROM AllAds

/*
1.	Using the view above, create a stored function "fn_ListUsersAds" that returns a table, 
holding all users in descending order as first column, along with all dates of their ads 
(in ascending order) in format "yyyyMMdd", separated by "; " as second column.
If your function is correct and you execute the following SQL query:

SELECT * FROM fn_ListUsersAds()
*/

USE Ads
GO
CREATE FUNCTION fn_ListUsersAds()
	RETURNS @tbl_UsersAds TABLE(
		UserName NVARCHAR(MAX),
		AdDates NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT UserName FROM AspNetUsers
		ORDER BY UserName DESC;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @ads NVARCHAR(MAX) = NULL;
		SELECT
			@ads = CASE
				WHEN @ads IS NULL THEN CONVERT(NVARCHAR(MAX), Date, 112)
				ELSE @ads + '; ' + CONVERT(NVARCHAR(MAX), Date, 112)
			END
		FROM AllAds
		WHERE Author = @username
		ORDER BY Date;

		INSERT INTO @tbl_UsersAds
		VALUES(@username, @ads)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

SELECT * FROM fn_ListUsersAds()