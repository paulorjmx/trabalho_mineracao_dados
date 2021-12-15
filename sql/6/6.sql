SELECT distinct
    e.id_paciente,
    e.id_atendimento,
	d.descricao_desfecho,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'COLESTEROL NAO-HDL, SORO') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS media_colesterol,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'HDL-COLESTEROL') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS media_hdl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'LDL COLESTEROL') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS media_ldl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) LIKE ANY (ARRAY['VLDL-COLESTEROL','V-COLESTEROL'])) OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS media_vldl,
    AVG(cast(resultado as float)) FILTER (WHERE upper(descricao_analito) = 'COLESTEROL TOTAL') OVER (PARTITION BY e.id_paciente,e.id_atendimento) AS media_total
FROM exames e
inner join desfecho d on e.id_atendimento = d.id_atendimento
where upper(descricao_exame) like '%COLESTEROL%' AND
    (upper(resultado) ~* '[A-Z]') is false