/*Problem 1.	Create initial architecture for massive multiplayer role-play game*/

/*Task 5. Populate buildings
It’s time to seed the predefined building types. 
On Id 1 place Metal mine, on Id 2 – Crystal mine and on Id 3 – Fusion reactor*/

INSERT INTO Buildings (Name) VALUES ('Metal mine')
INSERT INTO Buildings (Name) VALUES ('Crystal mine')
INSERT INTO Buildings (Name) VALUES ('Fusion Reactor')

SELECT * FROM Buildings

/*Task 6. Populate levels
After we have buildings with the appropriate Id’s, now we need to seed
the predefined ten levels per building. It’s said that each buildings 
first level costs the same, so we can start from there.*/

SELECT * FROM BuildingLevels

SELECT ID, 1, 1000, 500 FROM Buildings

INSERT INTO BuildingLevels 
	(BuildingID, LevelID, Metal, Crystal)
	SELECT ID, 1, 1000, 500 FROM Buildings

GO
DECLARE @I INT = 1
WHILE @I < 10
	BEGIN
		SET @I = @I + 1
		INSERT INTO BuildingLevels
		(BuildingID, LevelID, Metal, Crystal)
		SELECT
			1,
			MAX(LevelID) + 1,
			MAX(Metal) * 1.2,
			MAX(Crystal) * 1.2
		FROM 
			BuildingLevels
		WHERE 
			BuildingID = 1
	END
GO

GO
DECLARE @I INT = 1
WHILE @I < 10
	BEGIN
		SET @I = @I + 1
		INSERT INTO BuildingLevels
			(BuildingID, LevelID, Metal, Crystal)
			SELECT 
				2,
				MAX(LevelID) + 1,
				MAX(Metal) * 1.2,
				MAX(Crystal) * 1.2
			FROM 
				BuildingLevels
			WHERE 
				BuildingID = 2
	END
GO

GO
DECLARE @I INT = 1
WHILE @I < 10
	BEGIN
		SET @I = @I + 1
		INSERT INTO BuildingLevels
			(BuildingID, LevelID, Metal, Crystal)
			SELECT 
				3,
				MAX(LevelID) + 1,
				MAX(Metal) * 1.2,
				MAX(Crystal) * 1.2
			FROM 
				BuildingLevels
			WHERE 
				BuildingID = 3
	END
GO

/*Second way to do it: */
DELETE FROM BuildingLevels

GO
INSERT INTO BuildingLevels 
	(BuildingID, LevelID, Metal, Crystal)
	SELECT ID, 1, 1000, 500 FROM Buildings

DECLARE @BuildingID INT = 1
	WHILE @BuildingID <= 3
		BEGIN
			DECLARE @I INT = 1
			WHILE @I < 10
				BEGIN
					SET @I = @I + 1
					INSERT INTO BuildingLevels
						(BuildingID, LevelID, Metal, Crystal)
						SELECT 
							@BuildingID,
							MAX(LevelID) + 1,
							MAX(Metal) * 1.2,
							MAX(Crystal) * 1.2
						FROM 
							BuildingLevels
						WHERE 
							BuildingID = @BuildingID
				END
				SET @BuildingID = @BuildingID + 1
		END
GO

/*Task 7. Populate player’s buildings with initial level 0
Consider using Cartesian product in order to populate the relational table 
with only one INSERT query. The final result after populating should be something 
like the screenshot below*/

INSERT INTO Players (ID, Username, Password, Points, Email) VALUES 
	(2, 'Nick', 'qazwsx', 0, 'Nick@softuni.bg'),
	(3, 'Bot', '!@#123', 0, 'Bot@softuni.bg'),	
	(4, 'Jeni', '741852', 0, 'Jeni@softuni.bg')

INSERT INTO Planets (Name, X, Y, Z, Metal, Crystal, PlayerID) VALUES
	('Earth', 1, 1, 1, 1000, 500, 2),
	('Mars', 2, 2, 2, 500, 800, 3),
	('Venus', 3, 3, 3, 2000, 200, 4)

SELECT * FROM Planets
SELECT * FROM Players

/* CARTESIAN PRODUCT:
SELECT 
	P.ID AS [PlanetID], 
	B.ID AS [BuildingID],
	0 AS [LevelID]
FROM Planets P, Buildings B
*/

--PROBLEM - CANNOT COMMIT - KEY CONFLICT?
BEGIN TRAN
INSERT INTO PlanetsBuildings (PlanetID, BuildingID, LevelID)
	SELECT 
		P.ID AS [PlanetID], 
		B.ID AS [BuildingID],
		0 AS [LevelID]
	FROM Planets P, Buildings B

SELECT * FROM PlanetsBuildings
ROLLBACK TRAN

/*Problem 2.	Show game information

Task 1. Show player ranking (first 100 players) 
without showing any sensitive information*/

SELECT TOP 100 
	ID, 
	Username, 
	Points
FROM Players

/*Task 2. Show planets resource information for first three players 
Consider using JOINS and/or NESTED SELECTS*/

SELECT 
	P.Username AS [UserName], 
	PL.Metal, 
	PL.Crystal
FROM Players P
INNER JOIN Planets PL
ON PL.PlayerID = P.ID

/*Task 3. Rank players by all their resources and show them
Consider using: Aggregate functions, Aliases, Group condition*/

SELECT 
	P.Username AS [UserName], 
	SUM(PL.Metal) AS [AllMetal], 
	SUM(PL.Crystal) AS [AllCrystal]
FROM Players P
INNER JOIN Planets PL
ON PL.PlayerID = P.ID
GROUP BY P.Username
ORDER BY AllMetal DESC, AllCrystal DESC

/*Task 4. Extract information for each player’s building levels
Consider using multiple joins and aliases*/

SELECT 
	P.Username AS [UserName],
	PL.ID AS [PlanetId],
	B.Name AS [BuildingName],
	BL.LevelID 
FROM Players P
INNER JOIN Planets PL
ON PL.PlayerID = P.ID
INNER JOIN PlanetsBuildings PB
ON PB.PlanetID = PL.ID
INNER JOIN BuildingLevels BL
ON BL.BuildingID = PB.BuildingID
INNER JOIN Buildings B
ON B.ID = BL.BuildingID
