USE [RPGBDD]
GO

/****** Object:  Table [dbo].[personnage]    Script Date: 02/05/2021 15:47:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[personnage]') AND type in (N'U'))
DROP TABLE [dbo].[personnage]
GO

/****** Object:  Table [dbo].[personnage]    Script Date: 02/05/2021 15:47:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[personnage](
	[Nom] [varchar](20) NOT NULL,
	[Pv] [int] NOT NULL,
	[Niveau] [int] NOT NULL,
	[Xp] [int] NOT NULL
) ON [PRIMARY]
GO

