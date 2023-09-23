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
