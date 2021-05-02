USE [RPGBDD]
GO

/****** Object:  Table [dbo].[Attaque]    Script Date: 02/05/2021 15:47:19 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attaque]') AND type in (N'U'))
DROP TABLE [dbo].[Attaque]
GO

/****** Object:  Table [dbo].[Attaque]    Script Date: 02/05/2021 15:47:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Attaque](
	[Nom] [varchar](20) NOT NULL,
	[Degat] [int] NOT NULL
) ON [PRIMARY]
GO

