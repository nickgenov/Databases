/*
Problem 1.	All Teams
Display all teams in alphabetical order. 
*/

SELECT TeamName
FROM Teams
ORDER BY TeamName ASC

/*
Problem 2.	Biggest Countries by Population
Find the 50 biggest countries by population. Display the country name and population. 
Sort the results by population (from biggest to smallest), then by country alphabetically. 
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
Name the columns exactly like in the table below.
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
Name the columns exactly like in the table below.
*/

SELECT 
	CH.CountryName AS [Home Team], 
	CA.CountryName AS [Away Team], 
	IM.MatchDate AS [Match Date]
FROM InternationalMatches IM
INNER JOIN Countries CH ON CH.CountryCode = IM.HomeCountryCode
INNER JOIN Countries CA ON CA.CountryCode = IM.AwayCountryCode
ORDER BY IM.MatchDate DESC

/*
Problem 6.	*Teams with their League and League Country
Find all teams, along with the leagues, they play in and the country of the league. 
If the league does not have a country, display "International" instead. Sort the results by team name. 
Name the columns exactly like in the table below.
*/

SELECT 
	T.TeamName AS [Team Name],
	L.LeagueName AS [League],
	ISNULL(C.CountryName, 'International') AS [League Country]
FROM Teams T
INNER JOIN Leagues_Teams LT ON LT.TeamId = T.Id
INNER JOIN Leagues L ON L.Id = LT.LeagueId
LEFT OUTER JOIN Countries C ON C.CountryCode = L.CountryCode
ORDER BY T.TeamName ASC

SELECT
  TeamName AS [Team Name],
  LeagueName AS [League],
  (CASE WHEN l.CountryCode IS NULL THEN 'International' ELSE c.CountryName END) AS [League Country]
FROM Teams t
JOIN Leagues_Teams lt on t.Id = lt.TeamId
JOIN Leagues l on l.id = lt.LeagueId
LEFT JOIN Countries c on c.CountryCode = l.CountryCode
ORDER BY TeamName

--WHY 0 POINTS?!

/*
Problem 7.	* Teams with more than One Match
Find all teams that have more than 1 match in any league. Sort the results by team name. 
Name the columns exactly like in the table below.
*/

SELECT 
	T.TeamName AS [Team], 
	COUNT(TMHome.HomeTeamId) + COUNT(TMAway.AwayTeamId) AS [Matches Count]
FROM Teams T
FULL OUTER JOIN TeamMatches TMHome ON TMHome.HomeTeamId = T.Id
FULL OUTER JOIN TeamMatches TMAway ON TMAway.AwayTeamId = T.Id
GROUP BY T.TeamName
HAVING (COUNT(TMHome.HomeTeamId) + COUNT(TMAway.AwayTeamId)) > 1
ORDER BY T.TeamName ASC

--NOT DONE!

/*
Problem 8.	Number of Teams and Matches in Leagues
For each league in the database, display the number of teams, number of matches and average goals per match in it. 
Sort the results by number of teams (from largest to smallest), then by numbers of matches (from largest to smallest). 
Name the columns exactly like in the table below.
*/

SELECT 
	L.LeagueName AS [League Name],
	COUNT(DISTINCT T.TeamName) AS [Teams],
	(SELECT COUNT(Id) FROM dbo.TeamMatches WHERE LeagueId = L.Id) AS [Matches],
	ISNULL((SELECT (SUM(HomeGoals) + SUM(AwayGoals)) / COUNT(Id) FROM dbo.TeamMatches WHERE LeagueId = L.Id), 0) AS [Average Goals]
FROM dbo.Leagues L
LEFT OUTER JOIN dbo.Leagues_Teams LT ON LT.LeagueId = L.Id
LEFT OUTER JOIN dbo.Teams T ON T.Id = LT.TeamId
LEFT OUTER JOIN dbo.TeamMatches TM ON TM.LeagueId = L.Id
GROUP BY L.LeagueName, L.Id
ORDER BY [Teams] DESC, [Matches] DESC

SELECT
  l.LeagueName AS [League Name],
  COUNT(DISTINCT lt.TeamId) AS [Teams],
  COUNT(DISTINCT tm.Id) AS [Matches],
  ISNULL(AVG(tm.HomeGoals + tm.AwayGoals), 0) AS [Average Goals]
FROM Leagues l
LEFT JOIN Leagues_Teams lt ON l.Id = lt.LeagueId
LEFT JOIN TeamMatches tm ON tm.LeagueId = l.Id
GROUP BY l.LeagueName
ORDER BY Teams DESC, Matches DESC

/*
Problem 9.	Total Goals per Team in all Matches
Find the number of goals for each Team from all matches played. Sort the results by number of goals 
(from highest to lowest), then by team name alphabetically. Name the columns exactly like in the table below.
*/

SELECT 
	T.TeamName,
	ISNULL(SUM(A.AwayGoals), 0) + ISNULL(SUM(H.HomeGoals), 0) AS [Total Goals]
FROM dbo.Teams T
LEFT OUTER JOIN dbo.TeamMatches A ON A.AwayTeamId = T.Id
LEFT OUTER JOIN dbo.TeamMatches H ON H.HomeTeamId = T.Id
GROUP BY T.TeamName
ORDER BY [Total Goals] DESC, T.TeamName ASC

SELECT
  t.TeamName,
  ISNULL(SUM(tm1.HomeGoals), 0) + ISNULL(SUM(tm2.AwayGoals), 0) AS [Total Goals]
FROM Teams t
LEFT JOIN TeamMatches tm1 on tm1.HomeTeamId = t.Id
LEFT JOIN TeamMatches tm2 on tm2.AwayTeamId = t.Id
GROUP BY t.TeamName
ORDER BY [Total Goals] DESC, TeamName

--WHY 0 POINTS?!

/*
Problem 10.	Pairs of Matches on the Same Day
Find all pairs of team matches that are on the same day. Show the date and time of each pair. 
Sort the dates from the newest to the oldest first date, then from the newest to the oldest second date.
Name the columns exactly like in the table below.
*/

SELECT 
	F.MatchDate AS [First Date], 
	S.MatchDate AS [Second Date]
FROM dbo.TeamMatches F, dbo.TeamMatches S
WHERE 
	F.MatchDate < S.MatchDate
	AND CAST(F.MatchDate AS DATE) = CAST(S.MatchDate AS DATE)
ORDER BY [First Date] DESC, [Second Date] DESC

SELECT 
	F.MatchDate AS [First Date], 
	S.MatchDate AS [Second Date]
FROM dbo.TeamMatches F, dbo.TeamMatches S
WHERE 
	F.MatchDate < S.MatchDate
	AND DATEDIFF(DAY, F.MatchDate, S.MatchDate) < 1
ORDER BY [First Date] DESC, [Second Date] DESC

/*
Problem 11.	Mix of Team Names
Combine all team names with one another (including itself), so that the last letter of the first team name 
is the same as the first letter of the reversed second team name. 
Sort the results by the obtained mix alphabetically.
*/

SELECT LOWER(SUBSTRING(F.TeamName, 1, LEN(F.TeamName) - 1) + REVERSE(S.TeamName)) AS Mix
FROM dbo.Teams F, dbo.Teams S
WHERE SUBSTRING(F.TeamName, LEN(F.TeamName), 1) = SUBSTRING(REVERSE(S.TeamName), 1, 1)
ORDER BY Mix ASC

--SELECT SUBSTRING(TeamName, 1, 1), TeamName, SUBSTRING(TeamName, LEN(TeamName), 1) FROM dbo.Teams

SELECT LOWER(SUBSTRING(t1.teamname, 1, LEN(t1.TeamName) - 1) +  REVERSE(t2.TeamName)) AS Mix
FROM Teams t1, Teams t2
WHERE RIGHT(t1.TeamName, 1) = RIGHT(t2.TeamName, 1)
ORDER BY Mix