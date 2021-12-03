############# EXERCICIO 1 ##############
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

SELECT * FROM pacientes LIMIT 10;

SELECT * FROM exames LIMIT 10;

SELECT * FROM desfecho LIMIT 10;

# Mudando a coluna 'ano_nascimento' para inteiro:
UPDATE pacientes SET ano_nascimento = '0' 
	WHERE ano_nascimento = 'YYYY' OR ano_nascimento = 'AAAA';
ALTER TABLE pacientes ALTER COLUMN ano_nascimento 
	TYPE integer USING (ano_nascimento::integer);


# Vejamos a média de idade dos homens e das mulheres:
SELECT sexo, ROUND(AVG(ano_nascimento)) as ano_nascimento_media
	FROM pacientes WHERE ano_nascimento <> 0 GROUP BY sexo;


# Vamos substituir os valores que estão como 0 na coluna ano_nascimento, pelas médias dos homens
# para os homens, e pela média das mulheres para mulheres:
UPDATE pacientes SET ano_nascimento = 1976 WHERE sexo = 'M' AND ano_nascimento = 0;
UPDATE pacientes SET ano_nascimento = 1977 WHERE sexo = 'F' AND ano_nascimento = 0;

# Vejamos quantos pacientes anonimizaram o municipio:
SELECT municipio, COUNT(municipio) as total FROM pacientes
	WHERE municipio = 'MMMM' GROUP BY municipio;

# Substituiremos os pacientes que estão com o municpio com valo MMMM para a moda.
# Vejamos qual é a moda de municipios:
SELECT municipio, COUNT(municipio) as total FROM pacientes
	WHERE municipio <> 'MMMM' GROUP BY municipio ORDER BY total DESC LIMIT 1;

# Vamos substituir  MMMM por SAO PAULO:
UPDATE pacientes SET municipio = 'SAO PAULO' WHERE municipio = 'MMMM';


# Vejamos quantos pacientes há na base de dados:
SELECT COUNT(id) as qtd_pacientes FROM pacientes;

# Vejamos quantos destes pacientes realizaram algum exame:
SELECT COUNT(DISTINCT(id_paciente)) as qtd_pacientes_com_algum_exame FROM exames;

# Verifiquemos qual paciente não possui correspondência na tabela exames
SELECT pacientes.id FROM pacientes
	LEFT JOIN exames ON exames.id_paciente = pacientes.id
    	WHERE exames.id_paciente IS NULL;

# Verificando se há alguma desfecho do paciente acima
SELECT * FROM desfecho WHERE desfecho.id_paciente = '9F161F1AFB4D6041';

# Removendo o paciente
DELETE FROM pacientes WHERE id = '9F161F1AFB4D6041';







############# EXERCICIO 2 ##############
# Qual a quantidade de pacientes presente na base de dados?
SELECT COUNT(id) qtd_pacientes FROM pacientes;

# Quantos são homens e quantos são mulheres?
SELECT sexo, COUNT(sexo) as qtd_total FROM pacientes 
	WHERE sexo = 'F' GROUP BY sexo
UNION
SELECT sexo, COUNT(sexo) as qtd_total FROM pacientes 
	WHERE sexo = 'M' GROUP BY sexo;

# Qual é faixa etária dos pacientes homens e mulheres?
# Para homens, temos:
SELECT ano_nascimento, COUNT(ano_nascimento) as total FROM pacientes
	WHERE sexo = 'M' GROUP BY ano_nascimento ORDER BY ano_nascimento ASC LIMIT 10;

# Para mulheres, temos:
SELECT ano_nascimento, COUNT(ano_nascimento) as total FROM pacientes
	WHERE sexo = 'F' GROUP BY ano_nascimento ORDER BY ano_nascimento ASC LIMIT 10;
