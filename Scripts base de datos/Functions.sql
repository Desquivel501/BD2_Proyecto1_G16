USE BD2
GO

CREATE FUNCTION dbo.ConcatenatePlatforms(@game_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Platforms NVARCHAR(MAX)

    SELECT @Platforms = COALESCE(@Platforms + ' / ', '') + p.name
    FROM [release] r 
	JOIN platform p on r.platform_id = p.platform_id 
	WHERE r.game_id = @game_id
	GROUP BY p.name

    RETURN @Platforms
END
GO

CREATE FUNCTION dbo.ConcatenateLenguages(@game_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Languages NVARCHAR(MAX)

    SELECT @Languages = COALESCE(@Languages + ' / ', '') + l.name 
    FROM [language] l 
	JOIN language_support ls ON ls.lenguage_id = l.lenguage_id 
	WHERE ls.game_id  = @game_id
	GROUP BY l.name

    RETURN @Languages
END
GO

CREATE FUNCTION dbo.CountLanguages(@game_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT

    SELECT @Count = COUNT(*) 
	FROM [language] l 
	JOIN language_support ls ON ls.lenguage_id = l.lenguage_id 
	JOIN support_type st ON st.support_type_id = ls.support_type_id 
	WHERE ls.game_id = @game_id

    RETURN @Count
END
GO

CREATE FUNCTION dbo.ConcatenateFranchises(@game_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Franchises NVARCHAR(MAX)

    SELECT @Franchises = COALESCE(@Franchises + ' / ', '') + f.name
    FROM franchise_member fm 
	JOIN franchise f on fm.franchise_id  = f.franchise_id  
	WHERE fm.game_id  = @game_id

    RETURN @Franchises
END
GO

CREATE FUNCTION dbo.ConcatenateCompanies(@game_id INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Companies NVARCHAR(MAX)

    SELECT @Companies = COALESCE(@Companies + ' / ', '') + c.name
    FROM involved_companies ic 
	JOIN company c on ic.company_id  = c.company_id  
	WHERE ic.game_id  = @game_id

    RETURN @Companies
END
GO

-- Generos
DROP FUNCTION IF EXISTS dbo.GetGenres;
CREATE FUNCTION dbo.GetGenres(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @genres VARCHAR(MAX);
	SELECT  @genres = STRING_AGG(g.name,', ')FROM  genre g 
	JOIN used_genre ug ON g.genre_id=ug.genre_id
	WHERE ug.game_id=@id;
	RETURN @genres
END;
SELECT  dbo.GetModes(5);
-- platform 
DROP FUNCTION IF EXISTS dbo.GetPlatforms;
CREATE FUNCTION dbo.GetPlatforms(@id INT)
RETURNS TABLE
	RETURN SELECT p.name plataforma, STRING_AGG(CONCAT(re.[date],' ' ,r.name), ', ') [release]   FROM  platform p
	JOIN dbo.release re ON p.platform_id =re.platform_id 
	JOIN dbo.region r ON r.id_region=re.region_id 
	WHERE re.game_id=@id
	GROUP BY p.name;
GO
-- Modes
DROP FUNCTION IF EXISTS dbo.GetModes;
CREATE FUNCTION dbo.GetModes(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @modes VARCHAR(MAX);
	SELECT @modes= STRING_AGG( gm.name,', ')FROM  dbo.game_mode gm
	JOIN dbo.used_mode um ON um.game_mode_id =gm.game_mode_id 
	WHERE um.game_id =@id;
	RETURN @modes
END;
GO
-- Themes
DROP FUNCTION IF EXISTS dbo.GetThemes;
CREATE FUNCTION dbo.GetThemes(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @themes VARCHAR(MAX);
	SELECT @themes= STRING_AGG( t.name,', ')FROM  dbo.theme t
	JOIN dbo.used_theme ut ON ut.theme_id=t.theme_id 
	WHERE ut.game_id =@id;
	RETURN @themes
END;
GO
-- Perspective
DROP FUNCTION IF EXISTS dbo.GetPerspective;
CREATE FUNCTION dbo.GetPerspective(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @perspective VARCHAR(MAX);
	SELECT @perspective= STRING_AGG( t.name,', ')FROM  dbo.perspective t
	JOIN dbo.used_perspective up ON up.perspective_id =t.perspective_id 
	WHERE up.game_id =@id;
	RETURN @perspective
END;
GO
-- Engine
DROP FUNCTION IF EXISTS dbo.GetEngine;
CREATE FUNCTION dbo.GetEngine(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @engine VARCHAR(MAX);
	SELECT @engine= STRING_AGG( e.name,', ')FROM  dbo.game_engine e
	JOIN dbo.used_engine ue ON ue.game_engine_id =e.game_engine_id
	WHERE ue.game_id =@id;
	RETURN @engine
END;
GO
-- Franchise
DROP FUNCTION IF EXISTS dbo.GetFranchise;
CREATE FUNCTION dbo.GetFranchise(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @franchise VARCHAR(MAX);
	SELECT @franchise= STRING_AGG( f.name,', ')FROM  dbo.franchise f
	JOIN dbo.franchise_member fm ON fm.franchise_id =f.franchise_id 
	WHERE fm.game_id =@id;
	RETURN @franchise
END;
GO
-- Alternatives
DROP FUNCTION IF EXISTS dbo.GetAlternatives;
CREATE FUNCTION dbo.GetAlternatives(@id INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @alternative VARCHAR(MAX);
	SELECT @alternative= STRING_AGG( a.title,', ')FROM  dbo.alternate_title a
	WHERE a.game_id =@id;
	RETURN @alternative
END;
GO
-- Involved_company
DROP FUNCTION IF EXISTS dbo.GetCompanyInfo;
CREATE FUNCTION dbo.GetCompanyInfo(@id INT)
RETURNS TABLE
	RETURN SELECT
	STRING_AGG((CASE WHEN ia.developer=1 THEN c.name ELSE NULL END) ,
	', ') developer,
	STRING_AGG((CASE WHEN ia.publisher=1 THEN c.name ELSE NULL END) ,
	', ') publisher
FROM
	dbo.involved_companies ia
JOIN dbo.company c ON
	c.company_id = ia.company_id
WHERE
	ia.game_id = @id;
GO
