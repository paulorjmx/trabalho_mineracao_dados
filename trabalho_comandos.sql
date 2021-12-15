--##################################################################--
--          Universidade de São Paulo - Câmpus São Carlos           --
--     Instituto de Ciências Matemáticas e de Computação - ICMC     --
--##################################################################--
--      SCC0244 - Mineração a partir de grandes bases de dados      --
--     Prof. Dr. Caetano T. Jr., Profa. Dra. Agma J. M. Traina      --
--                      Erikson J. de Aguiar                        --
--##################################################################--
-- 							<<< Grupo >>> 							--
-- Gabriell Tavares Luna					NUSP 10716400 			--
-- George Alexandre Gantus					NUSP 10691988 			--
-- João Marcos Della Torre Divino 			NUSP 10377708 			--
-- Paulo Ricardo Jordão Miranda 			NUSP 10133456 			--
--##################################################################--


--##################################################################--
-- 							Exercício 1 							--
--##################################################################--

-- 						Criação das tabelas 						--

CREATE TABLE pacientes (
  id char(16),
  sexo char(1),
  ano_nascimento char(4),
  pais char(2),
  estado char(2),
  municipio varchar(40),
  cep char(5),
  PRIMARY KEY (id)
);

CREATE TABLE exames (
  id_paciente char(16),
  id_atendimento char(32),
  data_coleta date,
  origem varchar(4),
  descricao_exame varchar(80),
  descricao_analito varchar(80),
  resultado varchar(4000),
  unidade varchar(40),
  valor_referencia varchar(4000),
  FOREIGN KEY (id_paciente) REFERENCES pacientes(id) ON DELETE CASCADE
);

CREATE TABLE desfecho (
  id_paciente char(16),
  id_atendimento char(32),
  data_atendimento date,
  tipo_atendimento varchar(255),
  id_clinica int,
  descricao_clinica varchar(80),
  data_desfecho varchar(10),
  descricao_desfecho varchar(80),
  FOREIGN KEY (id_paciente) REFERENCES pacientes(id) ON DELETE CASCADE
);

----------------------------------------------------------------------
-- 			Carregamento da explicado no relatório					--
----------------------------------------------------------------------

--		Visualização dos dados após a base ser povoada 				--

SELECT * FROM pacientes LIMIT 10;

SELECT * FROM exames LIMIT 10;

SELECT * FROM desfecho LIMIT 10;

-- 			Procedimentos simples de limpeza de dados 				--

-- Mudando a coluna 'ano_nascimento' para inteiro:
UPDATE pacientes SET ano_nascimento = '0' 
	WHERE ano_nascimento = 'YYYY' OR ano_nascimento = 'AAAA';
ALTER TABLE pacientes ALTER COLUMN ano_nascimento 
	TYPE integer USING (ano_nascimento::integer);

-- Vejamos a média de idade dos homens e das mulheres:
SELECT sexo, ROUND(AVG(ano_nascimento)) as ano_nascimento_media
	FROM pacientes WHERE ano_nascimento <> 0 GROUP BY sexo;

-- Vamos substituir os valores que estão como 0 na coluna ano_nascimento, 
-- pelas médias dos homens para os homens, e pela média das mulheres para mulheres:
UPDATE pacientes SET ano_nascimento = 1976 WHERE sexo = 'M' AND ano_nascimento = 0;
UPDATE pacientes SET ano_nascimento = 1977 WHERE sexo = 'F' AND ano_nascimento = 0;

-- Vejamos quantos pacientes anonimizaram o municipio:
SELECT municipio, COUNT(municipio) as total FROM pacientes
	WHERE municipio = 'MMMM' GROUP BY municipio;

-- Substituiremos os pacientes que estão com o municpio com valo MMMM para a moda.
-- Vejamos qual é a moda de municipios:
SELECT municipio, COUNT(municipio) as total FROM pacientes
	WHERE municipio <> 'MMMM' GROUP BY municipio ORDER BY total DESC LIMIT 1;

-- Vamos substituir  MMMM por SAO PAULO:
UPDATE pacientes SET municipio = 'SAO PAULO' WHERE municipio = 'MMMM';

-- Vejamos quantos pacientes há na base de dados:
SELECT COUNT(id) as qtd_pacientes FROM pacientes;

-- Vejamos quantos destes pacientes realizaram algum exame:
SELECT COUNT(DISTINCT(id_paciente)) as qtd_pacientes_com_algum_exame FROM exames;

-- Verifiquemos qual paciente não possui correspondência na tabela exames
SELECT pacientes.id FROM pacientes
	LEFT JOIN exames ON exames.id_paciente = pacientes.id
    	WHERE exames.id_paciente IS NULL;

-- Verificando se há alguma desfecho do paciente acima
SELECT * FROM desfecho WHERE desfecho.id_paciente = '9F161F1AFB4D6041';

-- Removendo o paciente
DELETE FROM pacientes WHERE id = '9F161F1AFB4D6041';

--##################################################################--
-- 							Exercício 2 							--
--##################################################################--

-- 						Tabela pacientes 							--

-- Faixa etária:
SELECT 
	sexo,
	MAX( date_part('year', age(TO_DATE(ano_nascimento::varchar, 'yyyy'))) ),
	MIN( date_part('year', age(TO_DATE(ano_nascimento::varchar, 'yyyy'))) )
FROM pacientes
GROUP BY sexo

-- Quartis:
select
  sexo,
  percentile_disc(0.25) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.5) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.75) within group (order by extract(year from now()) - ano_nascimento)
from pacientes group by sexo

-- Quartis por década:
select
  sexo,
  floor((extract(year from now()) - ano_nascimento)/10),
  percentile_disc(0.25) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.5) within group (order by extract(year from now()) - ano_nascimento),
  percentile_disc(0.75) within group (order by extract(year from now()) - ano_nascimento)
from pacientes group by sexo,floor((extract(year from now()) - ano_nascimento)/10)

-- Por idade testes e poisitivos:
select distinct
	(extract(year from now()) - ano_nascimento) as idade,
	count(*) over(partition by (extract(year from now()) - ano_nascimento)) as total,
	count(*) filter (WHERE resultado like any (array['%POSITIVO%','DETECTADO','REAGENTE'])) over(partition by (extract(year from now()) - ano_nascimento)) as positivos
from exames inner join pacientes on id = id_paciente where upper(descricao_analito) like '%NCOV%'


-- 						  Tabela exames 							--

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
    	
-- Quantidade de exames de Covid que deram positivos:
SELECT 
	descricao_analito AS exame, 
    COUNT(*) AS qt_exames,
    COUNT(*) FILTER (WHERE resultado LIKE ANY (ARRAY['%POSITIVO%','DETECTADO','REAGENTE'])) AS positivos
FROM exames 
   	WHERE UPPER(descricao_analito) LIKE '%NCOV%' 
   		GROUP BY descricao_analito;


-- 						 Tabela desfecho 							--

-- Contagem de desfechos por categoria:
select 
	count(*) as quantidade,
    descricao_desfecho 
from desfecho 
	group by descricao_desfecho order by count(*) desc limit 1

-- Por sexo:
select 
	count(*),
    sexo,
    descricao_desfecho 
from desfecho 
	inner join pacientes 
    	on id = id_paciente group by descricao_desfecho,sexo order by count(*) desc limit 2

-- Por idade:
select count(*), floor((extract(year from now()) - ano_nascimento)/10) as decada, descricao_desfecho 
	from desfecho inner join pacientes on id = id_paciente 
	group by descricao_desfecho,floor((extract(year from now()) - ano_nascimento)/10) 
	order by decada,count(*) desc


--##################################################################--
-- 							Exercício 3 							--
--##################################################################--

-- Obter a taxa de mortalidade em cada clinica
select descricao_clinica,
	round(cast ((cast(count(distinct id_paciente) filter (where upper(data_desfecho) = 'DDMMAA') as float ) / count(distinct id_paciente))as numeric),3 ) as taxa	 
from desfecho group by descricao_clinica

--##################################################################--
-- 							Exercício 4 							--
--##################################################################--

-- Com subquery:
SELECT 
	P.id, 
    EXTRACT(YEAR FROM NOW()) - P.ano_nascimento as idade,
    P.municipio, 
    MM.IdMin, 
    MM.idMax
FROM pacientes P, (
	SELECT 
    	municipio, 
      	Min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) IdMin, 
      	Max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) IdMax
FROM pacientes
	GROUP BY municipio) MM
		WHERE 
        	(P.municipio=MM.municipio AND EXTRACT(YEAR FROM NOW()) - P.ano_nascimento=MM.IdMin) OR
			(P.municipio=MM.municipio AND EXTRACT(YEAR FROM NOW()) - P.ano_nascimento=MM.IdMax)
ORDER BY municipio ASC;


-- Com CTE:
with maximoMinimo as 
	(select 
     	max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) as idade_maxima,
     	min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) as idade_minima,
     	municipio 
     FROM pacientes group by municipio)
select 
	id,
    EXTRACT(YEAR FROM NOW()) - ano_nascimento as idade,
    p.municipio,
    idade_minima,
    idade_maxima
from pacientes p
inner join maximoMinimo mm on 
	((p.municipio = mm.municipio and EXTRACT(YEAR FROM NOW()) - ano_nascimento = mm.idade_minima) or 
     p.municipio = mm.municipio and EXTRACT(YEAR FROM NOW()) - ano_nascimento = mm.idade_maxima)
ORDER BY municipio ASC
LIMIT 10;


-- Com window function:
select 
	id,
	EXTRACT(YEAR FROM NOW()) - ano_nascimento as idade,
	municipio,
	max(EXTRACT(YEAR FROM NOW()) - ano_nascimento) over(partition by municipio) as maximo,
	min(EXTRACT(YEAR FROM NOW()) - ano_nascimento) over(partition by municipio) as minimo
from pacientes LIMIT 10


--##################################################################--
-- 							Exercício 5 							--
--##################################################################--

select distinct descricao_analito from exames where upper(descricao_exame) like '%HEMOGRAMA%'

--##################################################################--
-- 							Exercício 6 							--
--##################################################################--

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

--##################################################################--
-- 							Exercício 7 							--
--##################################################################--

-- Precisa fazer esse update pois nos hemogramas a "," é usada como separador decimal
update exames
set resultado=replace(resultado, ',', '.')
where resultado like '%,%';

-- Verificar analitos presentes
select distinct descricao_analito from exames where upper(descricao_exame) like '%HEMOGRAMA%'

-- Comando:
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

--##################################################################--
-- 							Exercício 8 							--
--##################################################################--

-- Encontrar valores numericos:
select descricao_analito,resultado, valor_referencia from exames where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false

-- Ajustar os dados:
update exames set valor_referencia = replace(right(valor_referencia, 3), ',', '.') where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false

-- Buscar:
update exames set resultado = 
	case 
		when (cast(resultado as float) <= cast(valor_referencia as float)) then 'Negativo'
		else 'Positivo'
		end
where UPPER(descricao_exame) LIKE '%COV%' and (upper(resultado) ~* '[A-Z]') is false

--##################################################################--
-- 							Exercício 9 							--
--##################################################################--


--##################################################################--
-- 							Exercício 10 							--
--##################################################################--

-- Histograma equi-largura de distribuição das idades dos pacientes --
--   Largura de cada bin do histograma corresponde a ’duas idades’  --
-- Atente todas as ’idades possíveis’, de 0 até a maior registrada  --

SELECT Bins.B AS Idade,
	CASE WHEN Tab.Contagem IS NULL THEN 0
			ELSE Tab.Contagem END Contagem
	FROM
		(WITH Lim AS (
			SELECT Max(date_part('year', CURRENT_DATE) - ano_nascimento) Mi
				FROM pacientes)
			SELECT generate_series(0, Lim.Mi::INTEGER, 2)
						AS B FROM Lim) AS Bins
				LEFT OUTER JOIN
		(SELECT Floor((date_part('year', CURRENT_DATE) - ano_nascimento)/2.00)*2 as Idade, 
		 		Count(*) as Contagem 
			FROM pacientes
			GROUP BY Idade) AS Tab
				ON Bins.B=Tab.Idade;

--   Modificação para gerar um histograma equi-largura com 10 bins  --
SELECT Bins.B AS Idade,
	CASE WHEN Tab.Contagem IS NULL THEN 0
			ELSE Tab.Contagem END Contagem
	FROM
		(WITH Lim AS (
			SELECT Max(date_part('year', CURRENT_DATE) - ano_nascimento) Mi
				FROM pacientes)
			SELECT generate_series(0, Lim.Mi::INTEGER, 10) -- Trecho modificado
						AS B FROM Lim) AS Bins
				LEFT OUTER JOIN
		(SELECT Floor((date_part('year', CURRENT_DATE) - ano_nascimento)/10.00)*10 as Idade, -- Trecho modificado
		 		Count(*) as Contagem 
			FROM pacientes
			GROUP BY Idade) AS Tab
				ON Bins.B=Tab.Idade;

--##################################################################--
-- 							Exercício 11 							--
--##################################################################--

-- Histograma tridimensional equi-largura de distribuição de exames --
-- 			Dimensões: DE_HOSPITAL, DE_ORIGEM e DE_EXAME 			--

SELECT 	(CASE	WHEN UPPER(origem) like '%HOSP%' 	THEN 'HOSP'
		 		WHEN UPPER(origem) like '%LAB%' 	THEN 'LAB'
		 		WHEN UPPER(origem) like '%inter%' OR
		 			 UPPER(origem) like '%pronto%' 	THEN 'ATEND'
				ELSE 'Outros' END) AS DE_ORIGEM,
		(CASE 	WHEN UPPER(descricao_exame) like '%HEMOGRAMA%' 	THEN 'Hemograma'
				WHEN UPPER(descricao_exame) like '%COLESTEROL%' THEN 'Colesterol'
				WHEN UPPER(descricao_exame) like '%COVID%' 	OR 
					 UPPER(descricao_exame) like '%PCR%' 	OR 
					 UPPER(descricao_exame) like '%IGM%' 	OR 
					 UPPER(descricao_exame) like '%IGG%' 		THEN 'Covid'
				ELSE 'Outros' END) AS DE_EXAME,
		COUNT(descricao_exame) AS Qtd
	FROM exames
	GROUP BY DE_ORIGEM, DE_EXAME;

--##################################################################--
-- 							Exercício 12 							--
--##################################################################--