--Contagem de desfechos por categoria
select count(*),descricao_desfecho from desfecho group by descricao_desfecho order by count(*) desc

--por sexo

select count(*),sexo,descricao_desfecho from desfecho inner join pacientes on id = id_paciente group by descricao_desfecho,sexo order by count(*) desc

--por idade 

select count(*),floor((extract(year from now()) - ano_nascimento)/10) as decada,descricao_desfecho from desfecho inner join pacientes on id = id_paciente group by descricao_desfecho,floor((extract(year from now()) - ano_nascimento)/10) order by decada,count(*) desc

