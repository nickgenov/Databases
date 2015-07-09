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



/*
Problem 12.	Ads by Town and Status
Display the count of ads for each town and each status. Sort the results by town, 
then by status. Display only non-zero counts. Name the columns exactly like in the table below. 
*/

/*
Problem 13.	* Ads by Users
Find the count of ads for each user. Display the username, ads count and "yes" or "no" 
depending on whether the user belongs to the role "Administrator". Sort the results by username. 
Display all users, including the users who have no ads. Name the columns exactly like in the 
table below. 
*/

/*
Problem 14.	Ads by Town
Find the count of ads for each town. Display the ads count and town name or "(no town)" 
for the ads without a town. Display only the towns, which hold 2 or 3 ads. Sort the results 
by town name. Name the columns exactly like in the table below.
*/

/*
Problem 15.	Pairs of Dates within 12 Hours
Consider the dates of the ads. Find among them all pairs of different dates, 
such that the second date is no later than 12 hours after the first date. 
Sort the dates in increasing order by the first date, then by the second date. 
Name the columns exactly like in the table below. 
*/

