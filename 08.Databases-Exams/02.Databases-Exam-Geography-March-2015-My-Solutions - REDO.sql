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

USE Geography
GO

BEGIN TRAN

GO
CREATE TABLE Monasteries (
	Id INT IDENTITY NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	CountryCode CHAR(2) NOT NULL
	CONSTRAINT PK_Id PRIMARY KEY(Id)
)
GO

ALTER TABLE Monasteries
	ADD CONSTRAINT FK_Monasteries_Countries FOREIGN KEY(CountryCode) 
		REFERENCES Countries(CountryCode)
GO
	
COMMIT

/*
2.	Execute the following SQL script (it should pass without any errors):
*/

INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

/*
3.	Write a SQL command to add a new Boolean column IsDeleted in the Countries table (defaults to false). 
Note that there is no "Boolean" type in SQL server, so you should use an alternative.
*/

GO
ALTER TABLE Countries
	ADD IsDeleted BIT DEFAULT 0
GO

UPDATE Countries SET IsDeleted = 0

/*
4.	Write and execute a SQL command to mark as deleted all countries that have more than 3 rivers.
*/

SELECT *
FROM Countries 
WHERE CountryCode IN
	(SELECT 
		C.CountryCode
	FROM Countries C
	INNER JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
	GROUP BY C.CountryCode
	HAVING COUNT(CR.RiverId) > 3)

UPDATE Countries 
SET IsDeleted = 1
WHERE CountryCode IN
	(SELECT 
		C.CountryCode
	FROM Countries C
	INNER JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
	GROUP BY C.CountryCode
	HAVING COUNT(CR.RiverId) > 3)

/*
5.	Write a query to display all monasteries along with their countries sorted by monastery name. 
Skip all deleted countries and their monasteries. Submit for evaluation the result grid with headers.
*/

SELECT 
	M.Name AS [Monastery], 
	C.CountryName AS [Country]
FROM Monasteries M
LEFT JOIN Countries C ON C.CountryCode = M.CountryCode
WHERE C.IsDeleted = 0
ORDER BY M.Name

/*
Problem 16.	Monasteries by Continents and Countries
This problem assumes that the previous problem is completed successfully without errors.

1.	Write and execute a SQL command that changes the country named "Myanmar" to its other name "Burma".
*/

SELECT * FROM Countries WHERE CountryName = 'Myanmar'
UPDATE Countries SET CountryName = 'Burma' WHERE CountryName = 'Myanmar'

/*
2.	Add a new monastery holding the following information: Name="Hanga Abbey", Country="Tanzania".
*/

INSERT INTO Monasteries (Name, CountryCode) VALUES
	('Hanga Abbey', (SELECT CountryCode FROM Countries WHERE CountryName = 'Tanzania'))

/*
3.	Add a new monastery holding the following information: Name="Myin-Tin-Daik", Country="Myanmar".
*/

INSERT INTO Monasteries (Name, CountryCode) VALUES
	('Myin-Tin-Daik', (SELECT CountryCode FROM Countries WHERE CountryName = 'Myanmar'))

/*
4.	Find the count of monasteries for each continent and not deleted country. Display the continent name, 
the country name and the count of monasteries. Include also the countries with 0 monasteries. 
Sort the results by monasteries count (from largest to lowest), then by country name alphabetically. 
Name the columns exactly like in the table below. Submit for evaluation the result grid with headers.
*/

SELECT 
	CN.ContinentName, 
	C.CountryName, 
	COUNT(M.Id) AS [MonasteriesCount]
FROM Continents CN
INNER JOIN Countries C ON C.ContinentCode = CN.ContinentCode
LEFT JOIN Monasteries M ON M.CountryCode = C.CountryCode
WHERE C.IsDeleted = 0
GROUP BY CN.ContinentName, C.CountryName
ORDER BY [MonasteriesCount] DESC, C.CountryName ASC

/*
Problem 17.	Stored Function: Mountain Peaks JSON
Create a stored function fn_MountainsPeaksJSON that lists all mountains alphabetically along with 
all its peaks alphabetically. Format the output as JSON string without any whitespace.
*/

SELECT 
	M.MountainRange AS name,
	P.PeakName AS name,
	P.Elevation AS elevation
FROM Mountains M
JOIN Peaks P ON P.MountainId = M.Id
ORDER BY M.MountainRange, P.PeakName
	
/*
DECLARE employeesCursor CURSOR READ_ONLY FOR
	SELECT FirstName, LastName FROM Employees

OPEN employeesCursor
DECLARE @FirstName NVARCHAR(50), @LastName NVARCHAR(50)
FETCH NEXT FROM employeesCursor INTO @FirstName, @LastName

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT @FirstName + ' ' + @LastName

		FETCH NEXT FROM employeesCursor INTO @FirstName, @LastName
	END

CLOSE employeesCursor
DEALLOCATE employeesCursor
*/
IF OBJECT_ID('fn_MountainsPeaksJSON') IS NOT NULL
  DROP FUNCTION fn_MountainsPeaksJSON
GO
CREATE FUNCTION fn_MountainsPeaksJSON() RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @JSON NVARCHAR(MAX) = '{"mountains":['

	DECLARE mountainsCursor CURSOR FOR
		SELECT Id, MountainRange FROM Mountains --ORDER BY MountainRange

		OPEN mountainsCursor

		DECLARE @MountainID INT
		DECLARE @MountainName NVARCHAR(MAX)

		FETCH NEXT FROM mountainsCursor INTO @MountainID, @MountainName
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @JSON = @JSON + '{"name":"' + @MountainName + '","peaks":['

				DECLARE peaksCursor CURSOR FOR
					SELECT PeakName, Elevation FROM Peaks WHERE MountainId = @MountainID

					OPEN peaksCursor

					DECLARE @PeakName NVARCHAR(MAX)
					DECLARE @Elevation INT

					FETCH NEXT FROM peaksCursor INTO @PeakName, @Elevation
					WHILE @@FETCH_STATUS = 0
						BEGIN
							SET @JSON = @JSON + '{"name":"' + @PeakName + '","elevation":' + 
								CONVERT(NVARCHAR(MAX), @Elevation) + '}'

							FETCH NEXT FROM peaksCursor INTO @PeakName, @Elevation
							IF @@FETCH_STATUS = 0
								SET @JSON = @JSON + ','
						END
					CLOSE peaksCursor
					DEALLOCATE peaksCursor

					SET @JSON = @JSON + ']}'
			
				FETCH NEXT FROM mountainsCursor INTO @MountainID, @MountainName	
				IF @@FETCH_STATUS = 0
					SET @JSON = @JSON + ','
			END

			CLOSE mountainsCursor
			DEALLOCATE mountainsCursor

		SET @JSON = @JSON + ']}'
	RETURN @JSON
END
GO

-----------------------------------------------------------
IF OBJECT_ID('fn_MountainsPeaksJSON') IS NOT NULL
  DROP FUNCTION fn_MountainsPeaksJSON
GO

CREATE FUNCTION fn_MountainsPeaksJSON()
	RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @json NVARCHAR(MAX) = '{"mountains":['

	DECLARE montainsCursor CURSOR FOR
	SELECT Id, MountainRange FROM Mountains

	OPEN montainsCursor
	DECLARE @mountainName NVARCHAR(MAX)
	DECLARE @mountainId INT
	FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @json = @json + '{"name":"' + @mountainName + '","peaks":['

		DECLARE peaksCursor CURSOR FOR
		SELECT PeakName, Elevation FROM Peaks
		WHERE MountainId = @mountainId

		OPEN peaksCursor
		DECLARE @peakName NVARCHAR(MAX)
		DECLARE @elevation INT
		FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @json = @json + '{"name":"' + @peakName + '",' +
				'"elevation":' + CONVERT(NVARCHAR(MAX), @elevation) + '}'
			FETCH NEXT FROM peaksCursor INTO @peakName, @elevation
			IF @@FETCH_STATUS = 0
				SET @json = @json + ','
		END
		CLOSE peaksCursor
		DEALLOCATE peaksCursor
		SET @json = @json + ']}'

		FETCH NEXT FROM montainsCursor INTO @mountainId, @mountainName
		IF @@FETCH_STATUS = 0
			SET @json = @json + ','
	END
	CLOSE montainsCursor
	DEALLOCATE montainsCursor

	SET @json = @json + ']}'
	RETURN @json
END
GO


SELECT DBO.fn_MountainsPeaksJSON()

/*
Problem 18.	Design a Database Schema in MySQL and Write a Query
1.	Design a MySQL database "trainings" to hold training centers, courses and a course timetable. 
Courses hold name and optional description. Training centers hold name, optional description and optional URL. 
The course timetable holds a set of timetable items, each consisting of course, training center and starting date. 
All tables should have auto-increment primary key – id. All text fields should accept Unicode characters.
*/

/*
DROP DATABASE IF EXISTS `trainings`;

CREATE DATABASE `trainings`
CHARACTER SET utf8 COLLATE utf8_unicode_ci;

USE `trainings`;

DROP TABLE IF EXISTS `training_centers`;

CREATE TABLE `training_centers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` text,
  `url` varchar(2083),
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `courses`;

CREATE TABLE `courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `courses_timetable`;

CREATE TABLE `timetable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL,
  `training_center_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_courses_timetable_courses`
    FOREIGN KEY (`course_id`) 
    REFERENCES `courses` (`id`),
  CONSTRAINT `fk_courses_timetable_training_centers` 
    FOREIGN KEY (`training_center_id`) 
    REFERENCES `training_centers` (`id`)
);
*/

/*
2.	Execute the following SQL script to load data in your tables. It should pass without any errors:
*/

/*
INSERT INTO `training_centers` VALUES
(1, 'Sofia Learning', NULL, 'http://sofialearning.org'),
(2, 'Varna Innovations & Learning', 'Innovative training center, located in Varna. Provides trainings in software development and foreign languages', 'http://vil.edu'),
(3, 'Plovdiv Trainings & Inspiration', NULL, NULL),
(4, 'Sofia West Adult Trainings', 'The best training center in Lyulin', 'https://sofiawest.bg'),
(5, 'Software Trainings Ltd.', NULL, 'http://softtrain.eu'),
(6, 'Polyglot Language School', 'English, French, Spanish and Russian language courses', NULL),
(7, 'Modern Dances Academy', 'Learn how to dance!', 'http://danceacademy.bg');

INSERT INTO `courses` VALUES
(101, 'Java Basics', 'Learn more at https://softuni.bg/courses/java-basics/'),
(102, 'English for beginners', '3-month English course'),
(103, 'Salsa: First Steps', NULL),
(104, 'Avancée Français', 'French language: Level III'),
(105, 'HTML & CSS', NULL),
(106, 'Databases', 'Introductionary course in databases, SQL, MySQL, SQL Server and MongoDB'),
(107, 'C# Programming', 'Intro C# corse for beginners'),
(108, 'Tango dances', NULL),
(109, 'Spanish, Level II', 'Aprender Español');

INSERT INTO `timetable`(course_id, training_center_id, start_date) VALUES
(101, 1, '2015-01-31'), (101, 5, '2015-02-28'),
(102, 6, '2015-01-21'), (102, 4, '2015-01-07'), (102, 2, '2015-02-14'), (102, 1, '2015-03-05'), (102, 3, '2015-03-01'),
(103, 7, '2015-02-25'), (103, 3, '2015-02-19'),
(104, 5, '2015-01-07'), (104, 1, '2015-03-30'), (104, 3, '2015-04-01'),
(105, 5, '2015-01-25'), (105, 4, '2015-03-23'), (105, 3, '2015-04-17'), (105, 2, '2015-03-19'),
(106, 5, '2015-02-26'),
(107, 2, '2015-02-20'), (107, 1, '2015-01-20'), (107, 3, '2015-03-01'), 
(109, 6, '2015-01-13');

UPDATE `timetable` t
  JOIN `courses` c ON t.course_id = c.id
SET t.start_date = DATE_SUB(t.start_date, INTERVAL 7 DAY)
WHERE c.name REGEXP '^[a-j]{1,5}.*s$';
*/

/*
3.	Write a SQL query to list all entries from the timetable ordered by start date and then by id. 
Display the training center, start date, course name and more info about the course (course details). 
Name the columns exactly like in the table below:
*/

/*
SELECT 
  tc.name AS `traning center`,
  t.start_date AS `start date`,
  c.name AS `course name`,
  c.description AS `more info`
FROM `timetable` t
  JOIN `courses` c ON t.course_id = c.id
  JOIN `training_centers` tc ON t.training_center_id = tc.id
ORDER BY t.start_date, t.id

select 
	tc.name as 'training center',
    t.start_date as 'start date',
    c.name as 'course name',
    c.description as 'more info'
from timetable t 
join training_centers tc on tc.id = t.training_center_id
join courses c on c.id = t.course_id
order by t.start_date asc, t.id asc;
*/