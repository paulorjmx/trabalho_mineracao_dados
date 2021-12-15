WITH CTE_COLESTEROL AS (
SELECT
    id_paciente,
    id_atendimento,
    descricao_exame,
    descricao_analito, 
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito)='COLESTEROL NAO-HDL, SORO') OVER (PARTITION BY id_paciente, id_atendimento) AS media,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito)='HDL-COLESTEROL') OVER (PARTITION BY id_paciente, id_atendimento) AS media_hdl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito)='LDL COLESTEROL') OVER (PARTITION BY id_paciente, id_atendimento) AS media_ldl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito)='VLDL-COLESTEROL' OR upper(descricao_analito)='V-COLESTEROL') OVER (PARTITION BY id_paciente, id_atendimento) AS media_vldl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito)='COLESTEROL TOTAL') OVER (PARTITION BY id_paciente, id_atendimento) AS media_total
FROM exames where upper(descricao_exame) like '%COLESTEROL%' AND
    (upper(resultado) ~* '[A-Z]') is false)

SELECT 
    id_paciente,
	COALESCE(MAX(media_hdl), (MAX(media_total)-MAX(media_vldl)-MAX(media_ldl))) as media_hdl,
	COALESCE(MAX(media_ldl), (MAX(media_total)-MAX(media_vldl)-MAX(media_hdl))) as media_ldl,
	COALESCE(MAX(media_vldl), (MAX(media_total)-MAX(media_ldl)-MAX(media_hdl))) as media_vldl,
	COALESCE(MAX(media_total), (MAX(media_ldl)+MAX(media_vldl)+MAX(media_hdl))) as media_total
FROM CTE_COLESTEROL
GROUP BY id_paciente
;