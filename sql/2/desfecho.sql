--Contagem de desfechos por categoria
select 
	count(*) as quantidade,
    descricao_desfecho 
from desfecho 
	group by descricao_desfecho order by count(*) desc limit 1

--por sexo
select 
	count(*),
    sexo,
    descricao_desfecho 
from desfecho 
	inner join pacientes 
    	on id = id_paciente group by descricao_desfecho,sexo order by count(*) desc limit 2

--por idade 
select count(*),floor((extract(year from now()) - ano_nascimento)/10) as decada,descricao_desfecho from desfecho inner join pacientes on id = id_paciente group by descricao_desfecho,floor((extract(year from now()) - ano_nascimento)/10) order by decada,count(*) desc

