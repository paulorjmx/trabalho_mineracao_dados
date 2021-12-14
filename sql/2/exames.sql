-- Maior quantidade de exames solicitados por um único paciente:
SELECT id_paciente, COUNT(*) as qt_exames FROM exames 
	INNER JOIN pacientes ON exames.id_paciente = pacientes.id
    	GROUP BY id_paciente ORDER BY qt_exames DESC LIMIT 1;

-- Média de exames por sexo
SELECT DISTINCT
	sexo,
	AVG(COUNT(*)) OVER(partition BY sexo) AS media
FROM exames 
	INNER JOIN pacientes ON id = id_paciente GROUP BY sexo, id_paciente

-- Quantidade de exames de CoVid realizados:
SELECT descricao_analito AS exame, COUNT(*) AS qt_exames
	FROM exames WHERE UPPER(descricao_analito) LIKE '%NCOV%'
    	GROUP BY descricao_analito;
    	

-- Quantidade de exames de CoVid que deram positivos:
SELECT 
	descricao_analito AS exame, 
    COUNT(*) AS qt_exames,
    COUNT(*) FILTER (WHERE resultado LIKE ANY (ARRAY['%POSITIVO%','DETECTADO','REAGENTE'])) AS positivos
FROM exames 
   	WHERE UPPER(descricao_analito) LIKE '%NCOV%' 
   		GROUP BY descricao_analito;

