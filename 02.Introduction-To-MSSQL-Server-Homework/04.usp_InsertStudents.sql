USE [School]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertStudents]    Script Date: 24.6.2015 г. 12:35:24 ч. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertStudents]
AS
DECLARE @Counter INT = 0, @Age INT = 20

WHILE @Counter < 10000
	BEGIN
		INSERT INTO dbo.Students ( Name, Age, PhoneNumber )
		VALUES  ( 'Pesho', @Age, '0885-045-189' )
	SET @Counter = @Counter + 1
	IF @Counter = 5000
	BEGIN
		SET @Age = @Age + 1
	END
END
