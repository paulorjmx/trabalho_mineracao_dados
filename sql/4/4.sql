--Com subquery
select id,p.municipio,maximo,minimo,idade from pacientes_idade p,
(select max(idade) as maximo,min(idade) as minimo,municipio from  pacientes_idade group by municipio) mm
where (p.municipio = mm.municipio and p.idade = mm.minimo) or p.municipio = mm.municipio and p.idade = mm.maximo
order by p.municipio