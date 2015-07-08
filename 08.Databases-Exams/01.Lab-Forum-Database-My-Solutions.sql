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
3.	Add “Has Phone” column. You can use case statement in select to check is there a phone 
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

BEGIN TRAN

USE Forum
CREATE TABLE Towns (
	Id INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL
	CONSTRAINT PK_Towns PRIMARY KEY (Id)
)

ALTER TABLE Users
	ADD TownId INT NULL
	CONSTRAINT FK_Users_Towns FOREIGN KEY (TownID) REFERENCES Towns (ID)

COMMIT TRAN

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

SELECT *
FROM dbo.Users
WHERE DATEPART(weekday, RegistrationDate) = 6

BEGIN TRAN
UPDATE dbo.Users 
SET TownId = (SELECT Id FROM Towns WHERE Name = 'Paris')
WHERE DATEPART(weekday, RegistrationDate) = 6
COMMIT TRAN