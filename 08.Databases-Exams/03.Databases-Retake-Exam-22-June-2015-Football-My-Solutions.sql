/*
Problem 1.	All Teams
Display all teams in alphabetical order. 
Submit for evaluation the result grid with headers.
*/

SELECT TeamName
FROM Teams
ORDER BY TeamName ASC

/*
Problem 2.	Biggest Countries by Population
Find the 50 biggest countries by population. Display the country name and population. 
Sort the results by population (from biggest to smallest), then by country alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT TOP 50
	CountryName, 
	Population 
FROM Countries
ORDER BY Population DESC, CountryName ASC

/*
Problem 3.	Countries and Currency (Eurzone)
Find all countries along with information about their currency. Display the country name, 
country code and information if the country is in the Eurozone or not 
(the currency is EUR or not): either "Inside" or "Outside". Sort the results by country name alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT 
	C.CountryName, 
	C.CountryCode, 
	CASE 
		WHEN C.CurrencyCode = 'EUR' THEN 'Inside'
		ELSE 'Outside'
	END AS [Eurozone]
FROM Countries C
ORDER BY C.CountryName ASC

/*
Problem 4.	Teams Holding Numbers
Find all teams that holds numbers in their name, sorted by country code. Display the team name and country code. 
Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.
*/

SELECT 
	T.TeamName AS [Team Name],
	T.CountryCode AS [Country Code]
FROM Teams T
WHERE (T.TeamName LIKE '%0%' 
	OR T.TeamName LIKE '%1%' 
	OR T.TeamName LIKE '%2%' 
	OR T.TeamName LIKE '%3%'
	OR T.TeamName LIKE '%4%' 
	OR T.TeamName LIKE '%5%' 
	OR T.TeamName LIKE '%6%'
	OR T.TeamName LIKE '%7%' 
	OR T.TeamName LIKE '%8%' 
	OR T.TeamName LIKE '%9%')
ORDER BY T.CountryCode ASC

/*
Problem 5.	International Matches
Find all international matches sorted by date. Display the country name of the home and away team. 
Sort the results starting from the newest date and ending with games with no date. 
Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.
*/

