# Aula 02 — 07/08/2026

## Retomada da Revisão de SQL

Quando uma **seta em negrito** é utilizada em um diagrama, ela representa uma **entidade fraca**. Isso significa que a entidade possui uma **chave primária composta**, formada pela chave estrangeira (FK) da entidade principal.

### Exemplo

**Funcionário (1,1) ──> Dependente (0,N)**

Nesse caso, **Dependente** é uma entidade fraca, pois sua existência depende da entidade **Funcionário**. Portanto, ao desativar um funcionário, todos os seus dependentes também serão desativados.

> **Observações**
>
> * A **seta contínua em negrito** representa uma **entidade fraca**.
> * **Autorrelacionamento**: ocorre quando uma entidade se relaciona consigo mesma. Exemplo: identificar **quem é chefe de quem** dentro da entidade **Funcionário**.

## DDL
São a criação e alterações dentro do banco de dados SQL:
* `CREATE DATABASE`: para criar um novo banco de dados.
* `DROP DATABASE`: para excluir um banco de dados existente.
* `CREATE TABLE`: para criar novas tabelas dentro de um banco de dados.
* `DROP TABLE`: para excluir uma tabela existente e todos os seus dados.
* `TRUNCATE TABLE`: para remover todos os registros de uma tabela sem excluir a tabela em si.
* `RENAME TABLE`: para renomear uma tabela existente.
* `ALTER TABLE`: para modificar a estrutura de uma tabela existente, como adicionar uma nova restrição de chave estrangeira.
* `PRIMARY KEY`: para definir a chave primária de uma tabela.
* `FOREIGN KEY`: para definir uma chave estrangeira, estabelecendo uma relação entre tabelas.
* `CREATE INDEX`: para melhorar a velocidade de busca/retrieval de dados, os índices podem ser criados em colunas específicas. 

No repositório do professor tem mais intruções sobre criação de banco de dados ([INSTRUÇÕES](https://github.com/Herysson/Projeto-de-Banco-de-Dados/blob/main/Aula%2008%20-%20Instru%C3%A7%C3%B5es%20DDL%20-%20CREATE%2C%20ALTER%20e%20DROP.md))

## Comandos Básico
Comandos Básico realizado em aula usando o MySQL WorkBench
```sql
-- Criando meu banco
CREATE DATABASE biblioteca;
-- Colocando o banco criado em uso
USE biblioteca;
-- Criando tabela
CREATE TABLE autor(
	id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade VARCHAR(100) NOT NULL
);
-- Exibe as tabelas
SHOW TABLES;

-- EXIBE METADADOS DA TABELA
DESC autor;


CREATE TABLE livro(
	id INT PRIMARY KEY,
    titulo TEXT NOT NULL,
    ano_publicacao YEAR NOT NULL,
    fk_id_autor INT
);

-- Remover a tabela livro
-- DROP TABLE livro;

-- Adicionando FK via alteração
ALTER TABLE livro 
ADD CONSTRAINT fk_autor -- nome da restrição
FOREIGN KEY (fk_id_autor) REFERENCES autor (id);

-- Adicionando uma nova coluna
ALTER TABLE livro
ADD genero VARCHAR(100) NOT NULL;

-- Removendo uma coluna
ALTER TABLE livro
DROP COLUMN genero;

-- Modificando tipo de dado de uma coluna
ALTER TABLE autor
MODIFY COLUMN nacionalidade CHAR(2);

-- Alterando nome de uma coluna
ALTER TABLE livro
CHANGE id ISBN VARCHAR(200);

```