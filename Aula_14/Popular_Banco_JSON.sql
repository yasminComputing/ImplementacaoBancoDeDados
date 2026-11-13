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