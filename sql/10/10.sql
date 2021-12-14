SELECT Bins.B AS Idade,
	CASE WHEN Tab.Contagem IS NULL THEN 0
			ELSE Tab.Contagem END Contagem
	FROM
		(WITH Lim AS (
			SELECT Max(date_part('year', CURRENT_DATE) - ano_nascimento) Mi
				FROM pacientes)
			SELECT generate_series(0, Lim.Mi::INTEGER, 2)
						AS B FROM Lim) AS Bins
				LEFT OUTER JOIN
		(SELECT Floor((date_part('year', CURRENT_DATE) - ano_nascimento)/2.00)*2 as Idade, Count(*) as Contagem 
			FROM pacientes
			GROUP BY Idade) AS Tab
				ON Bins.B=Tab.Idade;
