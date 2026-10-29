CREATE DATABASE CAIXA;

USE CAIXA;

-- CRIAÇÃO DA TABELA
CREATE TABLE conta(
	id INT PRIMARY KEY,
	Nome VARCHAR(50),
	Saldo MONEY
);

INSERT INTO conta VALUES
			(10,'Maria',500),
			(20,'João',1500),
			(30,'Paulo',30000),
			(40,'Maria',50000);

SELECT * FROM conta;