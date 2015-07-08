USE Geography

/*
Problem 1.	All Mountain Peaks
Display all ad mountain peaks in alphabetical order. 
Submit for evaluation the result grid with headers.
*/

SELECT PeakName
FROM dbo.Peaks
ORDER BY PeakName ASC

/*
Problem 2.	Biggest Countries by Population
Find the 30 biggest countries by population from Europe. 
Display the country name and population. Sort the results by population 
(from biggest to smallest), then by country alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT TOP 30
	C.CountryName, 
	C.Population
FROM dbo.Countries C
WHERE C.ContinentCode = 'EU'
ORDER BY C.Population DESC

/*
Problem 3.	Countries and Currency (Euro / Not Euro)
Find all countries along with information about their currency. 
Display the country code, country name and information about its currency: 
either "Euro" or "Not Euro". Sort the results by country name alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT 
	C.CountryName,
	C.CountryCode,
	(CASE 
		WHEN C.CurrencyCode = 'EUR' THEN 'Euro'
		ELSE 'Not Euro'
		END) AS [Currency]
FROM dbo.Countries C
ORDER BY C.CountryName ASC

/*
Problem 4.	Countries Holding 'A' 3 or More Times
Find all countries that holds the letter 'A' in their name at least 
3 times (case insensitively), sorted by ISO code. Display the country name 
and ISO code. Submit for evaluation the result grid with headers.
*/

SELECT 
	C.CountryName AS [Country Name], 
	C.IsoCode AS [ISO Code]
FROM dbo.Countries C
WHERE UPPER(C.CountryName) LIKE '%A%A%A%'
ORDER BY C.IsoCode ASC


/*
Problem 5.	Peaks and Mountains
Find all peaks along with their mountain sorted by elevation 
(from the highest to the lowest), then by peak name alphabetically. 
Display the peak name, mountain range name and elevation. 
Submit for evaluation the result grid with headers.
*/

SELECT
	P.PeakName,
	M.MountainRange AS [Mountain],
	P.Elevation
FROM dbo.Peaks P
INNER JOIN dbo.Mountains M
ON M.Id = P.MountainId
ORDER BY 
	P.Elevation DESC, 
	P.PeakName ASC

/*
Problem 6.	Peaks with Their Mountain, Country and Continent
Find all peaks along with their mountain, country and continent. 
When a mountain belongs to multiple countries, display them all. 
Sort the results by peak name alphabetically, then by country name alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT
	P.PeakName,
	M.MountainRange AS [Mountain],
	C.CountryName,
	CN.ContinentName
FROM dbo.Peaks P
INNER JOIN dbo.Mountains M
ON M.Id = P.MountainId
INNER JOIN dbo.MountainsCountries MC
ON MC.MountainId = M.Id
INNER JOIN dbo.Countries C
ON C.CountryCode = MC.CountryCode
INNER JOIN dbo.Continents CN
ON CN.ContinentCode = C.ContinentCode
ORDER BY 
	P.PeakName ASC,
	C.CountryName ASC

/*
Rivers Passing through 3 or More Countries
Find all rivers that pass through to 3 or more countries. 
Display the river name and the number of countries. Sort the results 
by river name. Submit for evaluation the result grid with headers.
*/

SELECT 
	R.RiverName AS [River],
	COUNT(C.CountryName) AS [Countries Count]
FROM dbo.Rivers R
INNER JOIN dbo.CountriesRivers CR
ON CR.RiverId = R.Id
INNER JOIN dbo.Countries C
ON C.CountryCode = CR.CountryCode
GROUP BY R.RiverName
HAVING COUNT(C.CountryName) >= 3
ORDER BY R.RiverName ASC

/*
Problem 8.	Highest, Lowest and Average Peak Elevation
Find the highest, lowest and average peak elevation. 
Submit for evaluation the result grid with headers.
*/

SELECT 
	MAX(P.Elevation) AS [MaxElevation], 
	MIN(P.Elevation) AS [MinElevation],  
	AVG(P.Elevation) AS [AverageElevation]
FROM dbo.Peaks P

/*
Problem 9.	Rivers by Country
For each country in the database, display the number of rivers passing 
through that country and the total length of these rivers. When a country 
does not have any river, display 0 as rivers count and as total length. 
Sort the results by rivers count (from largest to smallest), then by 
total length (from largest to smallest), then by country alphabetically. 
Submit for evaluation the result grid with headers.
*/

SELECT 
	C.CountryName, 
	CN.ContinentName,
	R.RiverName,
	R.Length
FROM dbo.Rivers R
INNER JOIN dbo.CountriesRivers CR
ON CR.RiverId = R.Id
INNER JOIN dbo.Countries C
ON C.CountryCode = CR.CountryCode
INNER JOIN dbo.Continents CN
ON CN.ContinentCode = C.ContinentCode

