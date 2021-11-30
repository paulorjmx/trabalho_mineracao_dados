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