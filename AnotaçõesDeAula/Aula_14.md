### Aula 14 - Dia 13.11.2026
Vendo o sistema do Museu Treze de Maio para o trabalho final. 
Dentro do banco não tem log que armazena historio do usuaio, pode sugerir mudança na estrutura do banco (bem justificar muito bem). 

Entregar:
    - Código sql
    - Apresentação curta slides máximo 10 minutos, defender a ideia
    - Resumo da ideia, formato SEPE máximo 3 páginas COLOCAR REFERENCIA, conceitos exemplo de trigger colocar referencia

> caso tiver alguma pergunta que o professor e não saber responder vai receber ZERO, prefere que entregue melhorias básicas do que inovação.
Trazer pontos positivos bem descrito, quanto melhor utilizar essa função, quanto piorou. 

- Ideias
    - Registro do usuário que realizar o cadastro de livros - somente os administradores e bibliotecario podem visualizar o usuario que adicionou.
    - quando recarrega o site contabiliza a quantidade de acesso do site

---
## Índice
([INDICE](https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/Aula%2012%20-%20%C3%8Dndices.md)).
```sql 
CREATE DATABASE INDICE;
USE INDICE;
GO
CREATE TABLE Funcionario(
	Id INT PRIMARY KEY,
	Nome VARCHAR(100),
	Cargo VARCHAR(50),
	Salario DECIMAL(10,2),
	DataAdmissao DATE
);
INSERT INTO Funcionario VALUES(1,'João Carlos','Adm',3500,GETDATE()),
							  (2,'Paulo','Tec',3500,GETDATE()),
							  (3,'Juca','TI',2500,GETDATE()),
							  (4,'Maria','TI',12500,GETDATE()),
							  (5,'Cezar','TI',2500,GETDATE());

GO
--
GO
DECLARE @Contador INT = 1;
DECLARE @Id INT;

SELECT @Id = ISNULL(MAX(Id),0) 
FROM Funcionario;

WHILE @Contador <= 30000
BEGIN
	SET @Id = @Id + 1;
	INSERT INTO Funcionario VALUES (
		@Id,
		'Funcionario' + CAST(@Id AS VARCHAR(10)),
		 CASE @Contador % 5
			WHEN 0 THEN 'Gerente'
			WHEN 1 THEN 'Dsenvolvedor'
			WHEN 2 THEN 'Analista'
			WHEN 3 THEN 'Suporte'
			ELSE 'Financeiro'
		END,
		FLOOR(10000*RAND()) + 1600,
		DATEADD(DAY,@Contador % 3650,'20150101')
	)
	
	SET @Contador = @Contador + 1;

END

SELECT * FROM Funcionario;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT *
FROM Funcionario
WHERE Id = 255000;

SELECT *
FROM Funcionario
WHERE Nome LIKE '% 255000';

SELECT *
FROM Funcionario
WHERE Nome  = 'Funcionario 25500';

INSERT INTO Funcionario VALUES(300100,'João ','Adm',3500,GETDATE());

CREATE NONCLUSTERED INDEX ix_Funcionario_Nome
ON Funcionario(Nome);

SELECT *
FROM Funcionario
WHERE DataAdmissao = '20150101' AND DataAdmissao <= '20150201';
```
---

### Usando JSON para Popular
Usar JSON para popular um banco somente o JSON tem que ser o mesmo dá tabela ([Estado para popular](https://json-generator.com/))
```sql
CREATE TABLE PESSOA(
	id INT PRIMARY KEY IDENTITY,
	nome VARCHAR(255),
	cidade VARCHAR (255),
    estado VARCHAR(255),
	email VARCHAR(255)
);


DECLARE @json NVARCHAR(MAX);

SELECT @json = BulkColumn
FROM OPENROWSET(
        BULK 'C:\Users\laboratorio\Downloads\pessoas.json',   -- ajuste o caminho conforme o seu ambiente
        SINGLE_CLOB,
        CODEPAGE = '65001'              -- UTF-8
     ) AS j;

INSERT INTO Pessoa (nome,cidade,estado,email)
SELECT
    nome,
    cidade,
    estado,
    email

FROM OPENJSON(@json)
WITH (
    nome   VARCHAR(255) '$.nome',
    cidade VARCHAR(255) '$.cidade',
    estado VARCHAR(255)  '$.estado',
    email    VARCHAR(255) '$.email'
);

SELECT * 
FROM Pessoa;
```