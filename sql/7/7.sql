--precisa fazer esse update pq nos emogramas tem , sendo usada com oseparador de decimal
update exames
set resultado=replace(resultado, ',', '.')
where resultado like '%,%';

--verificar analitos presentes
select distinct descricao_analito from exames where upper(descricao_exame) like '%HEMOGRAMA%'

--comando
select distinct
	e.id_paciente,
    e.id_atendimento,
	e.descricao_exame,
	d.descricao_desfecho,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BASOFILOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS basofilos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BASOFILOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS basofilos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BASTONETES') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS bastonetes,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BASTONETES (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS bastonetes_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BLASTOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS blastos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'BLASTOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS blastos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'CONCENTRACAO DE HEMOGLOBINA CORPUSCULAR') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS hemo_concentracao,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'EOSINOFILOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS eosinofilos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'EOSINOFILOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS eosinofilos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'ERITROCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS eritrocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'FRACAO IMATURA DE PLAQUETAS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS taxa_plaquetas_iamturas,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'HAIRY CELLS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS hairy_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'HEMATOCRITO') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS hematocrito,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'HEMOGLOBINA') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS hemoglobina,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'HEMOGLOBINA CORPUSCULAR MEDIA') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS hemo_corpular,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'INDICE DE GREEN & KING') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS i_green_king,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'LEUCOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS leucocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'LINFOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS linfocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'LINFOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS linfocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'METAMIELOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS metamielocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'METAMIELOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS metamielocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'MIELOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS mielocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'MIELOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS mielocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'MONOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS monocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'MONOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS monocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'NEUTROFILOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS neutrofilos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'NEUTROFILOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS neutrofilos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'PLAQUETAS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS plaquetas,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'PLASMOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS plasmocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'PLASMOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS plasmocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'PROMIELOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS promielocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'PROMIELOCITOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS promielocitos_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'RDW') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS rdw,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'SEGMENTADOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS segmentados,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'SEGMENTADOS (%)') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS segmentados_taxa,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'TRICOLEUCOCITOS') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS tricoleucocitos,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'VCM') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS vcm,
	AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'VOLUME PLAQUETARIO MEDIO') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS volume_plaq
from exames e
inner join desfecho d on e.id_atendimento = d.id_atendimento
where upper(descricao_exame) like '%HEMOGRAMA%' and (upper(resultado) ~* '[A-Z]') is false and resultado not like '% %'