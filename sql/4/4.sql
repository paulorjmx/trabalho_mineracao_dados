--Com subquery
SELECT 
	P.id, 
    EXTRACT(YEAR FROM NOW()) - P.ano_nascimento as idade,
    P.municipio, 
    MM.IdMin, 
    MM.idMax
FROM pacientes P, (
	SELECT 
    	municipio, 
      	Min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) IdMin, 
      	Max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) IdMax
FROM pacientes
	GROUP BY municipio) MM
		WHERE 
        	(P.municipio=MM.municipio AND EXTRACT(YEAR FROM NOW()) - P.ano_nascimento=MM.IdMin) OR
			(P.municipio=MM.municipio AND EXTRACT(YEAR FROM NOW()) - P.ano_nascimento=MM.IdMax)
ORDER BY municipio ASC;



--Com CTE
with maximoMinimo as 
	(select 
     	max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) as idade_maxima,
     	min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) as idade_minima,
     	municipio 
     FROM pacientes group by municipio)
select 
	id,
    EXTRACT(YEAR FROM NOW()) - ano_nascimento as idade,
    p.municipio,
    idade_minima,
    idade_maxima
from pacientes p
inner join maximoMinimo mm on 
	((p.municipio = mm.municipio and EXTRACT(YEAR FROM NOW()) - ano_nascimento = mm.idade_minima) or 
     p.municipio = mm.municipio and EXTRACT(YEAR FROM NOW()) - ano_nascimento = mm.idade_maxima)
ORDER BY municipio ASC
LIMIT 10;


--com window function
select 
	id,
	EXTRACT(YEAR FROM NOW()) - ano_nascimento as idade,
	municipio,
	max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) over(partition by municipio) as maximo,
	min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) over(partition by municipio) as minimo
from pacientes LIMIT 10
