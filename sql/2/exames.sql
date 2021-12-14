select max(count(*)) over(), count(*) from exames group by id_paciente

-- media por sexo
select avg(count(*)) over(partition by sexo),count(*),sexo from exames inner join pacientes on id = id_paciente group by sexo,id_paciente

--quantos covid
select count(*) over(),
	count(*) filter (WHERE resultado like any (array['%POSITIVO%','DETECTADO','REAGENTE'])) over()
from exames where upper(descricao_analito) like '%NCOV%'

