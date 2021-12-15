--encontrar valores numericos
select descricao_analito,resultado, valor_referencia from exames where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false

--ajustar os dados
update exames set valor_referencia = replace(right(valor_referencia, 3), ',', '.') where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false

--buscar
update exames set resultado = 
	case 
		when (cast(resultado as float) <= cast(valor_referencia as float)) then 'Negativo'
		else 'Positivo'
		end
where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false