# Trabalho prático da disciplina SCC0244
Este repositório abriga os arquivos necessários para a realização do trabalho prático da disciplina SCC0244 - Mineração a partir de grandes bases de dados.

## Integrantes

- Gabriell Tavares - 
- João Marcos Deltodi -
- Paulo Ricardo Jordão Miranda - 10133456


## Restaurando o banco de dados
Para restaurar o banco de dados, certifique-se, primeiramente, que o PostgreSQL está instalado e devidamente configurado. Em seguida, faça o _download_ do arquivo "beneficiencia_portuguesa.tar.gz", abra o terminal no local onde o arquivo recém baixado está, e execute o seguinte comando:

`pg_restore -d dbname beneficiencia_portuguesa.tar.gz`

onde, `db_name` é o nome do banco de dados onde as tabelas e os dados da mesma estarão armazenados.
