--3 obter a taxa de mortalidade em cada clinica
select descricao_clinica,
	round(cast ((cast(count(distinct id_paciente) filter (where upper(data_desfecho) = 'DDMMAA') as float ) / count(distinct id_paciente))as numeric),3 ) as taxa	 
from desfecho group by descricao_clinica