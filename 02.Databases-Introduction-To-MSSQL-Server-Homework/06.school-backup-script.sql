USE [master]
GO
/****** Object:  Database [School]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
CREATE DATABASE [School]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'School', FILENAME = N'D:\IBIS\DB\School.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 102400KB )
 LOG ON 
( NAME = N'School_log', FILENAME = N'D:\IBIS\DB\School_log.ldf' , SIZE = 107520KB , MAXSIZE = 2048GB , FILEGROWTH = 102400KB )
GO
ALTER DATABASE [School] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [School].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [School] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [School] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [School] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [School] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [School] SET ARITHABORT OFF 
GO
ALTER DATABASE [School] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [School] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [School] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [School] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [School] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [School] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [School] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [School] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [School] SET  DISABLE_BROKER 
GO
ALTER DATABASE [School] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [School] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [School] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [School] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [School] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [School] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [School] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [School] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [School] SET  MULTI_USER 
GO
ALTER DATABASE [School] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [School] SET DB_CHAINING OFF 
GO
ALTER DATABASE [School] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [School] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [School] SET DELAYED_DURABILITY = DISABLED 
GO
USE [School]
GO
/****** Object:  User [student]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
CREATE USER [student] FOR LOGIN [student] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [student]
GO
ALTER ROLE [db_datareader] ADD MEMBER [student]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [student]
GO
/****** Object:  Table [dbo].[Classes]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Classes](
	[ClassID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[MaxStudents] [int] NOT NULL,
 CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED 
(
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Students]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Age] [int] NOT NULL,
	[PhoneNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StudentsClasses]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentsClasses](
	[StudentID] [int] IDENTITY(1,1) NOT NULL,
	[ClassID] [int] NOT NULL,
 CONSTRAINT [PK_StudentsClasses] PRIMARY KEY CLUSTERED 
(
	[StudentID] ASC,
	[ClassID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[StudentsClasses]  WITH CHECK ADD  CONSTRAINT [FK_StudentsClasses_Classes] FOREIGN KEY([ClassID])
REFERENCES [dbo].[Classes] ([ClassID])
GO
ALTER TABLE [dbo].[StudentsClasses] CHECK CONSTRAINT [FK_StudentsClasses_Classes]
GO
ALTER TABLE [dbo].[StudentsClasses]  WITH CHECK ADD  CONSTRAINT [FK_StudentsClasses_Students] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO
ALTER TABLE [dbo].[StudentsClasses] CHECK CONSTRAINT [FK_StudentsClasses_Students]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertClasses]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
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

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertStudents]    Script Date: 24.6.2015 г. 12:47:15 ч. ******/
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

GO
USE [master]
GO
ALTER DATABASE [School] SET  READ_WRITE 
GO
