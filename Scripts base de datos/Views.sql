USE BD2
GO

-- Consulta 1
-- Vista de top 100 juegos evaluados por rating
CREATE VIEW dbo.TopJuegos 
AS 
SELECT
	g.name AS Nombre,
	g.rating AS Rating,
	dbo.ConcatenatePlatforms(g.game_id) AS Plataforma,
	STRING_AGG(g2.name , CHAR(13) + CHAR(10)) AS Generos
FROM game g 
JOIN release r 
ON r.game_id = g.game_id 
JOIN platform p 
ON p.platform_id = r.platform_id 
JOIN used_genre ug 
ON ug.game_id = g.game_id 
JOIN genre g2 
ON g2.genre_id = ug.genre_id 
GROUP BY g.game_id, g.name, g.rating;
GO

SELECT TOP 100 * FROM dbo.TopJuegos tj
ORDER BY tj.Rating DESC;
GO

CREATE VIEW dbo.TopSuppotedLanguages AS
	SELECT g.game_id, g.name, g.rating, dbo.ConcatenateLenguages(g.game_id) AS 'Suported Languages', COUNT(*) AS 'No. Languages'
	FROM game g 
	JOIN language_support ls ON ls.game_id = g.game_id 
	WHERE g.rating > 0
	GROUP BY g.game_id, g.name, g.rating;
GO

SELECT TOP 100 game_id, name, rating, [Suported Languages], [No. Languages]
    FROM BD2.dbo.TopSuppotedLanguages
    ORDER BY [No. Languages] DESC, rating DESC, name ASC;
GO

