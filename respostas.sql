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

# Ao importar os dados do bpsp_desfecho_01.csv, verificou-se que o paciente abaixo, não tinha registro na tabela de 'pacientes'
# Verifiquemos, então, se o mesmo possui exames e mais desfechos:
SELECT * FROM desfecho WHERE id_paciente = '9F161F1AFB4D6041';
SELECT * FROM exames WHERE id_paciente = '9F161F1AFB4D6041';
