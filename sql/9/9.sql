--Utilizamos a window function de lag pra pegar as mudanças de status, ou seja, se um paciente fez 4 exames sendo o primeiro negativo e os outros 
-- positivos pegamos a diferença de datas entre o primeiro e o segundo exame. (Não a distância entre o primeiro positivo e o ultimo negativo)
SELECT
    id_paciente,
    resultado,
	resultado_lag,
	data_coleta,
	data_coleta_lag,
	data_coleta - data_coleta_lag as diff
FROM (
    SELECT
        id_paciente,
        resultado,
        data_coleta,
        LAG(resultado) OVER (PARTITION BY id_paciente, id_atendimento ORDER BY data_coleta) AS resultado_lag,
	 	LAG(data_coleta) OVER (PARTITION BY id_paciente, id_atendimento ORDER BY data_coleta) AS data_coleta_lag 
		FROM(
            SELECT
                id_paciente,
                id_atendimento,
                data_coleta,
				resultado
            FROM exames
            WHERE UPPER(descricao_exame) LIKE '%COV%' and (resultado='Negativo' or resultado='Positivo')
        ) x
) tbl
WHERE resultado <> resultado_lag