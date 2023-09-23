
CREATE VIEW dbo.TopSuppotedLanguages AS
	SELECT g.game_id, g.name, g.rating, dbo.ConcatenateLenguages(g.game_id) AS 'Suported Languages', COUNT(*) AS 'No. Languages'
	FROM game g 
	JOIN language_support ls ON ls.game_id = g.game_id 
	WHERE g.rating > 0
	GROUP BY g.game_id, g.name, g.rating;


SELECT TOP 100 game_id, name, rating, [Suported Languages], [No. Languages]
    FROM BD2.dbo.TopSuppotedLanguages
    ORDER BY [No. Languages] DESC, rating DESC, name ASC;
