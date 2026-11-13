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

