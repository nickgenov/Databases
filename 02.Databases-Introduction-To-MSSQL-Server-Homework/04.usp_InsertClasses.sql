USE [School]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertClasses]    Script Date: 24.6.2015 г. 12:34:19 ч. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_InsertClasses]
AS

DECLARE 
	@CourseName NVARCHAR(100) = 'Programming Basics', 
	@StudentCount INT = 250, 
	@Counter INT = 0

WHILE @Counter <= 100
BEGIN
	INSERT INTO dbo.Classes ( Name, MaxStudents )
	VALUES  ( @CourseName, @StudentCount )
	SET @Counter += 1
END
