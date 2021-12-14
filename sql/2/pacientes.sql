--#### Exercicio 2


--Faixa etária
SELECT 
	sexo,
	MAX( date_part('year', age(TO_DATE(ano_nascimento::varchar, 'yyyy'))) ),
	MIN( date_part('year', age(TO_DATE(ano_nascimento::varchar, 'yyyy'))) )
FROM pacientes
GROUP BY sexo


-- quartis
select
  sexo,
  percentile_disc(0.25) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.5) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.75) within group (order by extract(year from now()) - ano_nascimento)
from pacientes group by sexo


--Quartis por decada
select
  sexo,
  floor((extract(year from now()) - ano_nascimento)/10),
  percentile_disc(0.25) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.5) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.75) within group (order by extract(year from now()) - ano_nascimento)
from pacientes group by sexo,floor((extract(year from now()) - ano_nascimento)/10)


-- por idade testes e poisitivos
select distinct
	(extract(year from now()) - ano_nascimento) as idade,
	count(*) over(partition by (extract(year from now()) - ano_nascimento)) as total,
	count(*) filter (WHERE resultado like any (array['%POSITIVO%','DETECTADO','REAGENTE'])) over(partition by (extract(year from now()) - ano_nascimento)) as positivos
from exames inner join pacientes on id = id_paciente where upper(descricao_analito) like '%NCOV%'
