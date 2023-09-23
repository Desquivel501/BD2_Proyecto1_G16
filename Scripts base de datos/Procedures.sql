USE BD2
GO

-- Consulta 2
-- Procedimiento para buscar juegos 
DROP PROCEDURE IF EXISTS dbo.SearchGame
GO 

CREATE PROCEDURE dbo.SearchGame
	@key_word VARCHAR(MAX)
AS 
BEGIN 
	IF LEN(@key_word) < 4 
	BEGIN
		SELECT 'La palabra cable debe tener al menos 4 caracteres'
		AS 'Error';
		RETURN;
	END;
		
	SELECT g.game_id AS ID, 
		g.name AS Nombre,
		g.rating AS Rating,
		g.summary AS Resumen,
		g.storyline AS Storyline,
		dbo.ConcatenateFranchises(g.game_id) AS Franquicias,
		dbo.ConcatenatePlatforms(g.game_id) AS Plataformas
	FROM game g 
	JOIN franchise_member fm 
	ON g.game_id = fm.game_id 
	JOIN franchise f 
	ON f.franchise_id = fm.franchise_id 
	AND g.name LIKE CONCAT('%', @key_word, '%')
	JOIN release r 
	ON r.game_id = g.game_id 
	JOIN platform p 
	ON p.platform_id = r.platform_id  
	GROUP BY g.game_id, g.name, g.storyline, g.rating, g.summary 
	ORDER BY g.name;
END
GO

-- Consulta 2
-- Procedimiento para buscar juegos por su franquicia 
DROP PROCEDURE IF EXISTS dbo.SearchFranchise
GO 

CREATE PROCEDURE dbo.SearchFranchise
	@key_word VARCHAR(MAX)
AS 
BEGIN 
	IF LEN(@key_word) < 4 
	BEGIN
		SELECT 'La palabra cable debe tener al menos 4 caracteres'
		AS 'Error';
		RETURN;
	END;
		
	SELECT g.game_id AS ID, 
		g.name AS Nombre,
		g.rating AS Rating,
		g.summary AS Resumen,
		g.storyline AS Storyline,
		dbo.ConcatenateFranchises(g.game_id) AS Franquicias,
		dbo.ConcatenatePlatforms(g.game_id) AS Plataformas
	FROM game g 
	JOIN franchise_member fm 
	ON g.game_id = fm.game_id 
	JOIN franchise f 
	ON f.franchise_id = fm.franchise_id 
	AND f.name LIKE CONCAT('%', @key_word, '%')
	JOIN release r 
	ON r.game_id = g.game_id 
	JOIN platform p 
	ON p.platform_id = r.platform_id  
	GROUP BY g.game_id, g.name, g.storyline, g.rating, g.summary 
	ORDER BY g.name;
END
GO

-- Consulta 3
-- Desplegar información del juego
DROP PROCEDURE IF EXISTS dbo.Consulta3
GO 

CREATE PROCEDURE dbo.Consulta3(
	@game_id INT,
	@name VARCHAR(MAX)
)
AS
BEGIN
	DECLARE @game_name VARCHAR(MAX);
	
	IF @game_id IS NOT NULL 
	BEGIN
		SELECT @game_name = g.name 
		FROM game g 
		WHERE g.game_id = @game_id;		
	END;
	
	IF @name IS NOT NULL
	BEGIN
		SELECT @game_name = @name;
	END;
	
	SELECT g.game_id  AS ID,
		g.name AS Nombre,
		g.rating AS Rating,
		g.storyline AS Storyline,
		g.summary AS Resumen,
		dbo.ConcatenateCompanies(g.game_id) AS Desarrolladores,
		dbo.ConcatenatePlatforms(g.game_id) AS Plataformas
	FROM game g 
	JOIN [release] r 
	ON r.game_id = g.game_id 
	JOIN platform p 
	ON p.platform_id = r.platform_id 
	JOIN involved_companies ic 
	ON ic.game_id = g.game_id 
	JOIN company c 
	ON c.company_id = ic.company_id 
	WHERE g.name LIKE CONCAT('%', @game_name, '%')
	GROUP BY g.game_id, g.name, g.rating, g.storyline, g.summary;
END
GO