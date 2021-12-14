--#verificar coluna sexo

select sexo,count(*) from pacientes group by sexo

--#identificamos um campo com valor null, vamos verificar
select * from pacientes where sexo is null

--#descobrimos que o paciente 9F161F1AFB4D6041 está com os dados todos vazios
--#vamos substituir os vazios pela moda e média

update pacientes set sexo = 'F',municipio = 'SAO PAULO', ano_nascimento = 1977, pais='BR',estado = 'SP' where id = '9F161F1AFB4D6041'
