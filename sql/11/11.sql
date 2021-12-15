select 	(CASE	WHEN upper(origem) like '%HOSP%' THEN 'HOSP'
		 		WHEN upper(origem) like '%LAB%' THEN 'LAB'
		 		WHEN upper(origem) like '%inter%' OR
		 			 upper(origem) like '%pronto%' THEN 'ATEND'
				ELSE 'Outros' END) as DE_ORIGEM,
		(CASE 	WHEN upper(descricao_exame) like '%HEMOGRAMA%' 	THEN 'Hemograma'
				WHEN upper(descricao_exame) like '%COLESTEROL%' THEN 'Colesterol'
				WHEN upper(descricao_exame) like '%COVID%' 	OR 
					 upper(descricao_exame) like '%PCR%' 	OR 
					 upper(descricao_exame) like '%IGM%' 	OR 
					 upper(descricao_exame) like '%IGG%' 		THEN 'Covid'
				ELSE 'Outros' END) as DE_EXAME,
		count(descricao_exame) as Qtd
	from exames
	group by DE_ORIGEM, DE_EXAME;
