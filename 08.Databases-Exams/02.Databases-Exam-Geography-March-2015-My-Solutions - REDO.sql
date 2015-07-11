USE Geography

/*
Problem 1.	All Mountain Peaks
Display all ad mountain peaks in alphabetical order. 
*/

SELECT PeakName 
FROM Peaks
ORDER BY PeakName ASC

/*
Problem 2.	Biggest Countries by Population
Find the 30 biggest countries by population from Europe. 
Display the country name and population. Sort the results by population 
(from biggest to smallest), then by country alphabetically.
*/

SELECT TOP 30
	C.CountryName, 
	C.[Population]
FROM Countries C
INNER JOIN Continents CN ON CN.ContinentCode = C.ContinentCode
WHERE CN.ContinentName = 'Europe'
ORDER BY C.[Population] DESC, C.CountryName ASC

/*
Problem 3.	Countries and Currency (Euro / Not Euro)
Find all countries along with information about their currency. 
Display the country code, country name and information about its currency: 
either "Euro" or "Not Euro". Sort the results by country name alphabetically. 
*/

SELECT 
	C.CountryName, 
	C.CountryCode, 
	CASE 
		WHEN CR.CurrencyCode = 'EUR' THEN 'Euro' 
		ELSE 'Not Euro' 
	END AS [Currency]
FROM Countries C
LEFT OUTER JOIN Currencies CR ON CR.CurrencyCode = C.CurrencyCode
ORDER BY C.CountryName ASC

/*
Problem 4.	Countries Holding 'A' 3 or More Times
Find all countries that holds the letter 'A' in their name at least 3 times (case insensitively), 
sorted by ISO code. Display the country name and ISO code.
*/

SELECT 
	CountryName AS [Country Name], 
	IsoCode AS [ISO Code]
FROM Countries
WHERE LOWER(CountryName) LIKE '%A%A%A%'
ORDER BY IsoCode ASC

SELECT 
	CountryName AS [Country Name], 
	IsoCode AS [ISO Code]
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode ASC

/*
Problem 5.	Peaks and Mountains
Find all peaks along with their mountain sorted by elevation 
(from the highest to the lowest), then by peak name alphabetically. 
Display the peak name, mountain range name and elevation. 
*/

SELECT 
	P.PeakName, 
	M.MountainRange AS [Mountain], 
	P.Elevation
FROM Peaks P
LEFT OUTER JOIN Mountains M ON M.Id = P.MountainId
ORDER BY P.Elevation DESC, P.PeakName ASC

/*
Problem 6.	Peaks with Their Mountain, Country and Continent
Find all peaks along with their mountain, country and continent. 
When a mountain belongs to multiple countries, display them all. 
Sort the results by peak name alphabetically, then by country name alphabetically.
*/

SELECT 
	P.PeakName, 
	M.MountainRange AS [Mountain], 
	C.CountryName, 
	CN.ContinentName
FROM Peaks P
INNER JOIN Mountains M ON M.Id = P.MountainId
INNER JOIN MountainsCountries MC ON MC.MountainId = M.Id
INNER JOIN Countries C ON C.CountryCode = MC.CountryCode
INNER JOIN Continents CN ON CN.ContinentCode = C.ContinentCode
ORDER BY P.PeakName ASC, C.CountryName ASC

/*
Rivers Passing through 3 or More Countries
Find all rivers that pass through to 3 or more countries. 
Display the river name and the number of countries. Sort the results by river name.
*/

SELECT 
	R.RiverName AS [River], 
	COUNT(C.CountryName) AS [Countries Count]
FROM Rivers R
INNER JOIN CountriesRivers CR ON CR.RiverId = R.Id
INNER JOIN Countries C ON C.CountryCode = CR.CountryCode
GROUP BY R.RiverName
HAVING COUNT(C.CountryName) > 2
ORDER BY R.RiverName

SELECT 
	R.RiverName AS [River], 
	COUNT(CR.CountryCode) AS [Countries Count]
FROM Rivers R
INNER JOIN CountriesRivers CR ON CR.RiverId = R.Id
GROUP BY R.RiverName
HAVING COUNT(CR.CountryCode) > 2
ORDER BY R.RiverName

/*
Problem 8.	Highest, Lowest and Average Peak Elevation
Find the highest, lowest and average peak elevation.
*/

SELECT 
	MAX(Elevation) AS [MaxElevation], 
	MIN(Elevation) AS [MinElevation], 
	AVG(Elevation) AS [AverageElevation]
FROM Peaks

/*
Problem 9.	Rivers by Country
For each country in the database, display the number of rivers passing 
through that country and the total length of these rivers. When a country 
does not have any river, display 0 as rivers count and as total length. 
Sort the results by rivers count (from largest to smallest), then by 
total length (from largest to smallest), then by country alphabetically. 
*/

SELECT 
	C.CountryName, 
	CN.ContinentName, 
	COUNT(R.RiverName) AS [RiversCount], 
	ISNULL(SUM(R.[Length]), 0) AS [TotalLength]
FROM Countries C
INNER JOIN Continents CN ON CN.ContinentCode = C.ContinentCode
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers R ON R.Id = CR.RiverId
GROUP BY C.CountryName, CN.ContinentName
ORDER BY [RiversCount] DESC, [TotalLength] DESC, C.CountryName ASC

/*
SELECT 
	C.CountryName, 
	CN.ContinentName, 
	R.RiverName, 
	R.[Length]
FROM Countries C
INNER JOIN Continents CN ON CN.ContinentCode = C.ContinentCode
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers R ON R.Id = CR.RiverId


SELECT C.CountryName, R.RiverName
FROM Countries C
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
FULL JOIN Rivers R ON R.Id = CR.RiverId
*/

/*
Problem 10.	Count of Countries by Currency
Find the number of countries for each currency. Display three columns: currency code, currency description 
and number of countries. Sort the results by number of countries (from highest to lowest), then by 
currency description alphabetically. Name the columns exactly like in the table below. 
*/

SELECT 
	CR.CurrencyCode, 
	CR.[Description] AS [Currency], 
	ISNULL(COUNT(C.CountryName), 0) AS [NumberOfCountries]
FROM Currencies CR
LEFT OUTER JOIN Countries C ON C.CurrencyCode = CR.CurrencyCode
GROUP BY CR.CurrencyCode, CR.[Description]
ORDER BY [NumberOfCountries] DESC, [Currency] ASC

/*
SELECT 
	CR.CurrencyCode, 
	CR.[Description] AS [Currency], 
	C.CountryName AS [NumberOfCountries]
FROM Currencies CR
LEFT OUTER JOIN Countries C ON C.CurrencyCode = CR.CurrencyCode
*/

/*
Problem 11.	* Population and Area by Continent
For each continent, display the total area and total population of all its countries. 
Sort the results by population from highest to lowest.
*/

SELECT 
	CN.ContinentName, 
	SUM(CAST(C.AreaInSqKm AS BIGINT)) AS [CountriesArea], 
	SUM(CAST(C.[Population] AS BIGINT)) AS [CountriesPopulation]
FROM Continents CN
INNER JOIN Countries C ON C.ContinentCode = CN.ContinentCode
GROUP BY CN.ContinentName
ORDER BY [CountriesPopulation] DESC

/*
Problem 12.	Highest Peak and Longest River by Country
For each country, find the elevation of the highest peak and the length of the longest river, 
sorted by the highest peak elevation (from highest to lowest), then by the longest river length 
(from longest to smallest), then by country name (alphabetically). 
Display NULL when no data is available in some of the columns. 
*/

SELECT 
	C.CountryName, 
	MAX(P.Elevation) AS [HighestPeakElevation], 
	MAX(R.[Length]) AS [LongestRiverLength]
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers R ON R.Id = CR.RiverId
GROUP BY C.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, C.CountryName ASC

/*
SELECT 
	C.CountryName, P.Elevation, R.[Length]
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers R ON R.Id = CR.RiverId
WHERE C.CountryName = 'China'
ORDER BY P.Elevation DESC, R.[Length] DESC, C.CountryName ASC
*/

/*
Problem 13.	Mix of Peak and River Names
Combine all peak names with all river names, so that the last letter of each peak name is the 
same like the first letter of its corresponding river name. Display the peak names, river names, 
and the obtained mix. Sort the results by the obtained mix.
*/

SELECT 
	P.PeakName, 
	R.RiverName,
	LOWER((SUBSTRING(P.PeakName, 1, LEN(P.PeakName) - 1)) + R.RiverName) AS [Mix]
FROM Peaks P, Rivers R
WHERE SUBSTRING(P.PeakName, LEN(P.PeakName), 1) = LOWER(SUBSTRING(R.RiverName, 1, 1))
ORDER BY [Mix] ASC

SELECT 
	P.PeakName, 
	R.RiverName,
	LOWER((SUBSTRING(P.PeakName, 1, LEN(P.PeakName) - 1)) + R.RiverName) AS [Mix]
FROM Peaks P, Rivers R
WHERE RIGHT(P.PeakName, 1) = LEFT(R.RiverName, 1)
ORDER BY [Mix] ASC

/*
SELECT PeakName, SUBSTRING(PeakName, LEN(PeakName), 1) AS LastLetter FROM Peaks
SELECT RiverName, LOWER(SUBSTRING(RiverName, 1, 1)) AS FirstLetter FROM Rivers
*/

/*
Problem 14.	** Highest Peak Name and Elevation by Country
For each country, find the name and elevation of the highest peak, along with its mountain. 
When no peaks are available in some country, display elevation 0, "(no highest peak)" as peak name 
and "(no mountain)" as mountain name. When multiple peaks in some country have the same elevation, 
display all of them. Sort the results by country name alphabetically, then by 
highest peak name alphabetically.
*/

SELECT 
	C.CountryName AS [Country],
	P.PeakName AS [Highest Peak Name], 
	P.Elevation AS [Highest Peak Elevation],
	M.MountainRange AS [Mountain]
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id
WHERE P.Elevation =
    (SELECT MAX(P.Elevation)
	FROM Countries CR
	LEFT JOIN MountainsCountries MC ON MC.CountryCode = CR.CountryCode
	LEFT JOIN Mountains M ON M.Id = MC.MountainId
	LEFT JOIN Peaks P ON P.MountainId = M.Id
	WHERE CR.CountryName = C.CountryName)
UNION
SELECT 
	C.CountryName AS [Country],
	'(no highest peak)' AS [Highest Peak Name], 
	0 AS [Highest Peak Elevation],
	'(no mountain)' AS [Mountain]
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id
WHERE 
	(SELECT MAX(P.Elevation)
	FROM Countries CR
	LEFT JOIN MountainsCountries MC ON MC.CountryCode = CR.CountryCode
	LEFT JOIN Mountains M ON M.Id = MC.MountainId
	LEFT JOIN Peaks P ON P.MountainId = M.Id
	WHERE CR.CountryName = C.CountryName) IS NULL
ORDER BY C.CountryName ASC, [Highest Peak Name] ASC



------------------------------------------------------------
SELECT 
	C.CountryName AS [Country], 
	P.PeakName AS [Highest Peak Name], 
	P.Elevation AS [Highest Peak Elevation],
	M.MountainRange AS [Mountain]
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id
ORDER BY C.CountryName ASC, [Highest Peak Name] ASC
------------------------------------------------------------

SELECT
  c.CountryName AS [Country],
  p.PeakName AS [Highest Peak Name],
  p.Elevation AS [Highest Peak Elevation],
  m.MountainRange AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE p.Elevation =
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode)
UNION
SELECT
  c.CountryName AS [Country],
  '(no highest peak)' AS [Highest Peak Name],
  0 AS [Highest Peak Elevation],
  '(no mountain)' AS [Mountain]
FROM
  Countries c
  LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
  LEFT JOIN Mountains m ON m.Id = mc.MountainId
  LEFT JOIN Peaks p ON p.MountainId = m.Id
WHERE 
  (SELECT MAX(p.Elevation)
   FROM MountainsCountries mc
     LEFT JOIN Mountains m ON m.Id = mc.MountainId
     LEFT JOIN Peaks p ON p.MountainId = m.Id
   WHERE c.CountryCode = mc.CountryCode) IS NULL
ORDER BY c.CountryName, [Highest Peak Name]

/*
Problem 15.	Monasteries by Country

1.	Create a table Monasteries(Id, Name, CountryCode). Use auto-increment for the primary key. 
Create a foreign key between the tables Monasteries and Countries.
*/