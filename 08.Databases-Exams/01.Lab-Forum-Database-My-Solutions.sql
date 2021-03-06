/*
Problem 1.	All Question Titles
Display all question titles in ascending order. Name the columns exactly like in the table below.
Steps:
1.	Select all question titles from questions table.
2.	Add order by descending statement.
*/

SELECT Title 
FROM dbo.Questions
ORDER BY Title ASC

/*
Problem 2.	Answers in Date Range
Find all answers created between 15-June-2012 (00:00:00) and 21-Mart-2013 (23:59:59) 
sorted by date, then by id. Name the columns exactly like in the table below.
Steps:
1.	Select all answers (only Content and CreatedOn columns).
2.	Add where filter by CreatedOn, then by Id columns. You can use between or comparison statements.
*/

SELECT 
	Content, 
	CreatedOn
FROM dbo.Answers
WHERE CreatedOn BETWEEN '15-June-2012' AND '21-March-2013'
ORDER BY 
	CreatedOn ASC, 
	ID ASC

/*
Problem 3.	Users with "1/0" Phones
Display usernames and last names along with a column named "Has Phone" holding "1" or "0" 
for all users sorted by their last name, then by id. Name the columns exactly like in the table below.
Steps:
1.	Select all users (only Username and LastName columns).
2.	Add order by last name statement.
3.	Add �Has Phone� column. You can use case statement in select to check is there a phone 
and set 1 or 0.
*/

SELECT 
	Username, 
	LastName,
	CASE 
		WHEN PhoneNumber IS NULL THEN 0
		ELSE 1	
	END AS [Has Phone]
FROM dbo.Users
ORDER BY 
	LastName ASC, 
	ID ASC

/*
Problem 4.	Questions with their Author
Find all questions along with their user sorted by Id. Display the question title and author username. 
Name the columns exactly like in the table below.
Steps:
1.	Select all columns from Questions table.
2.	Join Users table.
3.	Add only the required columns in the expression.
4.	Add the required aliases.
*/

SELECT 
	Q.Title AS [Question Title], 
	U.Username AS [Author]
FROM dbo.Questions Q
INNER JOIN dbo.Users U
ON U.ID = Q.UserID

/*
Problem 5.	Answers with their Question with their Category and User 
Find all answers along with their questions, along with question category, along with question author sorted by Category Name, then by Answer Author, then by CreatedOn. Display the answer content, created on, question title, category name and author username. Name the columns exactly like in the table below.
Steps:
1.	Select all columns from Answers table.
2.	Join Questions table by QuestionId foreign key.
3.	Join Categories table by CategoryId foreign key.
4.	Join Users table by UserId foreign key in Answers table.
5.	Add order by statement by Category Name, Answer Author and CreatedOn.
6.	Select only the required columns with their aliases.
*/

SELECT 
	A.Content AS [Answer Content], 
	A.CreatedOn AS [CreatedOn],
	U.Username AS [Answer Author],
	Q.Title AS [Question Title],
	C.Name AS [Category Name]
FROM dbo.Answers A
INNER JOIN dbo.Users U
ON U.ID = A.UserID
INNER JOIN dbo.Questions Q
ON Q.ID = A.QuestionID
INNER JOIN dbo.Categories C
ON C.ID = Q.CategoryID
ORDER BY 
	C.NAME ASC, 
	U.Username ASC, 
	A.CreatedOn ASC

SELECT 
	CAST(a.Content AS NVARCHAR(MAX)) as [Answer Content], 
	A.CreatedOn AS [CreatedOn],
	U.Username AS [Answer Author],
	Q.Title AS [Question Title],
	C.Name AS [Category Name]
FROM dbo.Answers A
INNER JOIN dbo.Users U
ON U.ID = A.UserID
INNER JOIN dbo.Questions Q
ON Q.ID = A.QuestionID
INNER JOIN dbo.Categories C
ON C.ID = Q.CategoryID
GROUP BY CAST(A.Content AS NVARCHAR(MAX)), A.CreatedOn, U.Username, Q.Title, C.Name 
ORDER BY 
	C.NAME ASC, 
	U.Username ASC, 
	A.CreatedOn ASC

--Author solution, does not work

SELECT a.Content as [Answer Content], a.CreatedOn, u.Username as [Answer Author], q.Title as [Question Title], c.Name as [Category Name]
FROM Answers a
  JOIN Questions q on q.Id = a.QuestionId
  JOIN Categories c on q.CategoryId = c.Id
  JOIN Users u on a.UserId = u.Id
ORDER BY c.Name -- TODO: Fix order by! The result is not unique! 

/*
Problem 6.	Category with Questions
Find all categories along with their questions sorted by category name and question title. 
Display the category name, question title and created on columns. Name the columns exactly like 
in the table below.
1.	Select all Questions.
2.	Join Categories table (think how to display null values).
3.	Add order by statement by category name, then by question title.
4.	Select only required columns.
*/

SELECT 
	C.Name, 
	Q.Title,
	Q.CreatedOn
FROM dbo.Questions Q
RIGHT OUTER JOIN dbo.Categories C
ON Q.CategoryID = C.ID
ORDER BY 
	C.Name ASC, 
	Q.Title ASC

/*
Problem 7.	*Users without PhoneNumber and Questions
Find all users that have no phone and no questions sorted by RegistrationDate. Show all user data. 
Name the columns exactly like in the table below.
1.	Select all users.
2.	Add where filter by null phone number.
3.	Add order by statement by RegistrationDate.
4.	Join Questions table and display all users with questions for each user (with questions with 
null values).
5.	Add filter to show only users with no questions.
*/

SELECT U.Id, U.Username, U.FirstName, U.PhoneNumber, U.RegistrationDate, U.Email
FROM dbo.Users U
WHERE U.PhoneNumber IS NULL
AND U.ID NOT IN (SELECT DISTINCT UserID FROM dbo.Questions)
ORDER BY U.RegistrationDate ASC

/*
Problem 8.	Earliest and Latest Answer Date
Find the dates of the earliest answer for 2012 year and the latest answer for 2014 year. 
Name the columns exactly like in the table below.
Steps:
1.	Select min and max date from Answers.
2.	Add where filter by year.
*/

SELECT 
	MIN(A.CreatedON) AS [MinDate],
	MAX(A.CreatedON) AS [MaxDate] 
FROM dbo.Answers A
WHERE YEAR(A.CreatedOn) BETWEEN 2012 AND 2014

/*
Problem 9.	Find the last ten answers
Find the last 10 answers sorted by date of creation in descending order. 
Display for each ad its content, date and author. Name the columns exactly like in the table below.
*/

SELECT TOP 10
	A.Content, 
	A.CreatedOn, 
	U.Username
FROM dbo.Answers A
INNER JOIN dbo.Users U
ON U.ID = A.UserID
ORDER BY A.CreatedOn ASC

/*
Problem 10.	Not Published Answers from the First and Last Month
Find the answers which is hidden from the first and last month where there are any published answer, 
from the last year where there are any published answers. Display for each ad its answer content, 
question title and category name. Sort the results by category name. Name the columns exactly like 
in the table below.
Steps:
1.	Select all data from Answers.
2.	Join Questions and Categories by foreign keys.
3.	Add order by statement by category name.
4.	Select only needed columns.
5.	Add where statement. You can use MONTH and YEAR functions and nested select statements.
*/

SELECT 
	A.Content AS [Answer Content], 
	Q.Title AS [Question],
	C.Name AS [Category]
FROM dbo.Answers A
INNER JOIN dbo.Questions Q
ON Q.ID = A.QuestionID
INNER JOIN dbo.Categories C
ON C.ID = Q.CategoryID
WHERE 
	(MONTH(A.CreatedOn) = (SELECT MIN(MONTH(CreatedOn)) FROM dbo.Answers) 
		OR MONTH(A.CreatedOn) = (SELECT MAX(MONTH(CreatedOn)) FROM dbo.Answers))	
	AND YEAR(A.CreatedOn) = (SELECT MAX(YEAR(CreatedOn)) FROM dbo.Answers)
	AND A.IsHidden = 1
ORDER BY C.Name

/*
Problem 11.	Answers count for Category
Display the count of answers in each category. Sort the results by answers count 
in descending order. Name the columns exactly like in the table below.
Steps:
1.	Select all data from Categories.
2.	Join Questions and Answers (What type of join do you need?).
3.	Order results.
4.	Group results and add COUNT column in select statement.
*/

SELECT 
	C.Name AS [Category],
	COUNT(A.ID) AS [Answers Count]
FROM dbo.Categories C
LEFT OUTER JOIN dbo.Questions Q
ON C.ID = Q.CategoryID
LEFT OUTER JOIN dbo.Answers A
ON A.QuestionID = Q.ID
GROUP BY C.NAME
ORDER BY [Answers Count] DESC

/*
Problem 12.	Answers Count by Category and Username
Display the count of answers for category and each username. Sort the results by 
Answers count. Display only non-zero counts. Display only users with phone number. 
Name the columns exactly like in the table below. 
Steps:
1.	Select all data from Categories.
2.	Join Questions, Answers and Users (What type of joins do you need?).
3.	Add needed columns in select statement and group by them.
4.	Add order by statement by answers count.
*/

SELECT 
	C.Name AS [Category], 
	U.Username AS [Username], 
	U.PhoneNumber AS [PhoneNumber],
	COUNT(A.ID) AS [Answers Count]
FROM dbo.Categories C
LEFT OUTER JOIN dbo.Questions Q
ON Q.CategoryID = C.ID
LEFT OUTER JOIN dbo.Answers A
ON A.QuestionID = Q.ID
LEFT OUTER JOIN dbo.Users U
ON U.ID = A.UserID
GROUP BY C.Name, U.Username, U.PhoneNumber
HAVING U.PhoneNumber IS NOT NULL
ORDER BY [Answers Count] DESC

/*
Problem 13.	Answers for the users from town

1.	Create a table Towns(Id, Name). Use auto-increment for the primary key. 
Add a new column TownId in the Users table to link each user to some town 
(non-mandatory link). Create a foreign key between the Users and Towns tables.
*/

USE Forum
CREATE TABLE Towns (
	Id INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Towns PRIMARY KEY (Id)
)

ALTER TABLE Users
	ADD TownId INT NULL
	CONSTRAINT FK_Users_Towns FOREIGN KEY (TownID) REFERENCES Towns (ID)

/*
2.	Execute the following SQL script (it should pass without any errors):
*/

INSERT INTO Towns(Name) VALUES ('Sofia'), ('Berlin'), ('Lyon')
UPDATE Users SET TownId = (SELECT Id FROM Towns WHERE Name='Sofia')
INSERT INTO Towns VALUES
('Munich'), ('Frankfurt'), ('Varna'), ('Hamburg'), ('Paris'), ('Lom'), ('Nantes')

/*
3.	Write and execute a SQL command that changes the town to "Paris" for all users 
with registration date at Friday.
Steps:
1.	Write update statement by Users table.
2.	Get town id with nested select statement.
3.	Add where statement where check the day of the week (You can use DATEPART function).
*/

UPDATE dbo.Users 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Paris')
WHERE DATEPART(weekday, RegistrationDate) = 6

/*
4.	Write and execute a SQL command that changes the question to �Java += operator� of Answers, 
answered at Monday or Sunday in February.
Steps:
1.	Write update statement by Answers table.
2.	Get QuestionId with nested select statement.
3.	Add where filter (You can check the day of week with DATEPART function and the month with MONTH function).
*/

UPDATE Answers
SET QuestionId = (SELECT Id FROM Questions WHERE Title = 'Java += operator')
WHERE DATEPART(MONTH, CreatedOn) = 2
	AND DATEPART(WEEKDAY, CreatedOn) IN (1, 2)

/*
5.	Delete all answers with negative sum of votes.
Steps:
1.	Create temporary table [#AnswerIds] with one column AnswerId (int)
2.	Insert into [#AnswerIds] table all answer ids where sum of answer votes are negative number.
3.	Delete votes where sum of answer votes are negative number.
4.	Delete answers which ids are in table [#AnswerIds]
5.	Drop temporary table [#AnswerIds]
Hint: Think how to delete votes with answers.
*/

GO
CREATE TABLE #AnswerIds (
	AnswerId INT NOT NULL
)

INSERT INTO #AnswerIds (AnswerId) 
	SELECT A.ID
	FROM Answers A
	INNER JOIN Votes V
	ON V.AnswerId = A.Id
	GROUP BY A.Id
	HAVING SUM(V.Value) < 0
GO

DELETE FROM Votes
WHERE AnswerId IN (SELECT AnswerId FROM #AnswerIds)

DELETE FROM Answers
WHERE Id IN (SELECT AnswerId FROM #AnswerIds)

DROP TABLE #AnswerIds

/*
6.	Add a new question holding the following information: Title="Fetch NULL values in PDO query", 
Content="When I run the snippet, NULL values are converted to empty strings. How can fetch NULL values?", 
CreatedOn={current date and time}, Owner="darkcat", Category="Databases".
Hint: You can use GETDATE function for current datetime and nested select statements for user id and category id.
*/

INSERT INTO Questions (Title, Content, CategoryId, UserId, CreatedOn) VALUES
	('Fetch NULL values in PDO query', 
	'When I run the snippet, NULL values are converted to empty strings. How can fetch NULL values?',
	(SELECT Id FROM Categories WHERE Name = 'Databases'),
	(SELECT Id FROM Users WHERE Username = 'darkcat'),
	GETDATE())

/*
7.	Find the count of the answers for the users from town. Display the town name, username and answers count. 
Sort the results by answers count in descending order, then by username. Name the columns exactly like in the table below. 
*/

SELECT 
	T.Name AS [Town],
	U.Username,
	COUNT(A.Id) AS [AnswersCount]
FROM Answers A
FULL OUTER JOIN Users U
ON U.Id = A.UserId
FULL OUTER JOIN Towns T
ON T.Id = U.TownId
GROUP BY T.Name, U.Username
ORDER BY 
	[AnswersCount] DESC, 
	U.Username ASC

/*
Problem 14.	Create a View and a Stored Function
1.	Create a view "AllQuestions" in the database that holds information about questions and users 
(use RIGHT OUTER JOIN): If you execute the following SQL query:
SELECT * FROM AllAnswers
*/

USE Forum
GO

CREATE VIEW AllAnswers
AS
SELECT
	U.Id as UId,
	U.Username,
	U.FirstName,
	U.LastName,
	U.Email,
	U.PhoneNumber,
	U.RegistrationDate,
	Q.Id as QId,
	Q.Title,
	Q.Content,
	Q.CategoryId,
	Q.UserId,
	Q.CreatedOn
FROM
  Questions Q
  RIGHT OUTER JOIN Users u on Q.UserId = U.Id
GO

SELECT * FROM AllAnswers

/*
2.	Using the view above, create a stored function "fn_ListUsersQuestions" that returns a table, 
holding all users in descending order as first column, along with all titles of their questions 
(in ascending order), separated by ", " as second column.
If your function is correct and you execute the following SQL query:

SELECT * FROM fn_ ListUsersQuestions()
*/

IF (object_id(N'fn_ListUsersQuestions') IS NOT NULL)
DROP FUNCTION fn_ListUsersQuestions
GO

CREATE FUNCTION fn_ListUsersQuestions()
	RETURNS @tbl_UsersQuestions TABLE(
		UserName NVARCHAR(MAX),
		Questions NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE UsersCursor CURSOR FOR
		SELECT Username FROM Users
		ORDER BY Username;
	OPEN UsersCursor;
	DECLARE @username NVARCHAR(MAX);
	FETCH NEXT FROM UsersCursor INTO @username;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @questions NVARCHAR(MAX) = NULL;
		SELECT
			@questions = CASE
				WHEN @questions IS NULL THEN CONVERT(NVARCHAR(MAX), Title, 112)
				ELSE @questions + ', ' + CONVERT(NVARCHAR(MAX), Title, 112)
			END
		FROM AllAnswers
		WHERE Username = @username
		ORDER BY Title DESC;

		INSERT INTO @tbl_UsersQuestions
		VALUES(@username, @questions)
		
		FETCH NEXT FROM UsersCursor INTO @username;
	END;
	CLOSE UsersCursor;
	DEALLOCATE UsersCursor;
	RETURN;
END
GO

SELECT * FROM fn_ListUsersQuestions()

/*
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
*/