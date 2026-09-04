USE EMPRESA;

-- CAST:  converter o salário decimal em uma string

GO
DECLARE @salario DECIMAL(10,2),
		@nome VARCHAR(15);
SET @nome = 'Jennifer';
SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'O funcionário(a) ' 
	   + @nome + ' tem um salário de: R$ ' 
	   + CAST(@salario AS VARCHAR(100));
GO

-- CONVERT: converter o salário decimal em uma string
GO
DECLARE @salario DECIMAL(10,2),
		@nome VARCHAR(15);
SET @nome = 'Jennifer';
SELECT @salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'O funcionário(a) ' 
	   + @nome + ' tem um salário de: R$ ' 
	   + CONVERT(VARCHAR(10), @salario); -- pode passar um calculo tipo aumentar o salario * 1.1.
GO

--- CONVERT DATAS: Converta a data de nascimento da Jennifer para o padrão brasileiro: dd/mm/aaaa
GO
DECLARE @data_nasc DATE,
		@nome VARCHAR(15);
SET @nome = 'Jennifer';

SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'Data de nascimento: ' + CONVERT(VARCHAR(20),@data_nasc,103);
GO
---
-- CONDIÇÕES IF/ ELSE: verificar se um funcionário recebe abaixo da média salarial
GO
DECLARE @nome VARCHAR(15),
		@salario_medio DECIMAL(10,2),
		@salario DECIMAL(10,2);
SET @nome = 'Jennifer';

SELECT @salario_medio = AVG(F.Salario)
FROM FUNCIONARIO AS F

SELECT @salario = Salario FROM FUNCIONARIO WHERE @nome = Pnome;

IF(@salario < @salario_medio)
	PRINT 'O funcionário(a) '
			+ @nome
			+ ' ganha abaixo da média';
ELSE
	PRINT 'O funcionário(a)'
		  + @nome
		  + ' ganha acima da média';
GO

-- Verificar se um Funcionário Está Próximo da Aposentadoria, considerar a
-- idade para aposentadoria de 60 anos.
/*GO 

CODIGO QUE REALIZEI MAIS TEM FORMA MAIS SIMPLES DE REALIZAR O CALCULO DA IDADE

DECLARE @data DATE,
		@idade_atual INT,
		@data_nasc DATE,
		@nome VARCHAR(100);
SET @nome = 'Jennifer';

SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F;
SET @idade_atual = YEAR(GETDATE()) - YEAR(@data_nasc);



IF (@idade_atual <= 55)
	PRINT 'Longe da aposentadoria';
ELSE IF(@idade_atual > 55 AND @idade_atual <= 60)
	PRINT 'Próximo da aposentadoria';
ELSE
	PRINT 'Passou';

GO*/
--- 

-- CÓDIGO DO PROFESSOR
GO
DECLARE @ano_atual INT,
		@ano_nasc INT,
		@nome VARCHAR(100),
		@idade INT;

SET @nome = 'Ana';
SET @ano_atual = YEAR(GETDATE());

SELECT @ano_nasc = YEAR(DataNasc)
FROM FUNCIONARIO
WHERE @nome = Pnome;

SET @idade = @ano_atual - @ano_nasc;

IF (@idade <= 55)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Longe da aposentadoria';
ELSE IF(@idade > 55 AND @idade <= 60)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Próximo da aposentadoria';
ELSE
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Passou';
GO

--- 
-- USANDO O DATEDIFF 
GO
DECLARE @data_nasc DATE,
		@nome VARCHAR(100),
		@idade INT;
SET @nome = 'Fernando';

SELECT @data_nasc = DataNasc
FROM FUNCIONARIO
WHERE @nome = Pnome;

SET @idade = DATEDIFF(YEAR,@data_nasc,GETDATE());

IF (@idade <= 55)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Longe da aposentadoria';
ELSE IF(@idade > 55 AND @idade <= 60)
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Próximo da aposentadoria';
ELSE
	PRINT 'Idade: ' + CAST(@idade AS VARCHAR(3)) + ' Passou';
GO
--- 
-- Tendo o nome da pessoa calcular a idade correta,usando IF/ELSE
GO
DECLARE @data_nasc DATE,
		@nome VARCHAR(100),
		@idade INT,
		@mes_atual INT;
SET @nome = 'Maria';

SELECT @data_nasc = DataNasc
FROM FUNCIONARIO
WHERE @nome = Pnome;


IF(MONTH(GETDATE()) < MONTH(@data_nasc))
 BEGIN
	SET @idade = DATEDIFF(YEAR,@data_nasc,GETDATE()) - 1;
	PRINT 'Data de Nascimento: ' + CONVERT(VARCHAR(20),@data_nasc,103);
	PRINT @idade;
 END

ELSE IF(MONTH(GETDATE()) = MONTH(@data_nasc) AND DAY(@data_nasc) > DAY(GETDATE()))
 BEGIN
	SET @idade = DATEDIFF(YEAR,@data_nasc,GETDATE()) - 1;
	PRINT 'Data de Nascimento: ' + CONVERT(VARCHAR(20),@data_nasc,103);
	PRINT @idade;
 END
ELSE
 BEGIN
	SET @idade = DATEDIFF(YEAR,@data_nasc,GETDATE())
	PRINT 'Data de Nascimento: ' + CONVERT(VARCHAR(20),@data_nasc,103);
	PRINT @idade;
 END
GO

--- 


-- IIF: Se o funcionário ganha menos de 20 mil ganha pouco e se ganha maior ou igual a 20k = ganha bem
GO
SELECT 
		F.Pnome,
		F.Unome,
		F.Salario,
		IIF(F.Salario < 20000,'Baixo','Alto') AS 'Categoria'
FROM FUNCIONARIO AS F;
GO

---
-- CASE:Se o funcionário ganha menos de 20 mil ganha pouco e se ganha maior ou igual a 20k = ganha bem
GO
SELECT 
		F.Pnome,
		F.Unome,
		F.Salario,
		CASE
			WHEN F.Salario <= 10000 AND F.Salario > 0 THEN 'Baixo'
			WHEN F.Salario > 10000 AND F.Salario <= 30000 THEN 'Médio'
			WHEN F.Salario > 30000 THEN 'Alto'
			ELSE 'ERRO' -- caso tenha um salário negativo
		END AS 'Categoria'
FROM FUNCIONARIO AS F;
GO

--- 

---  LOOP 
-- WHILE
GO
DECLARE @contador INT = 0;

WHILE @contador < 10
 BEGIN 
		IF @contador = 5
			BREAK;
		SET @contador = @contador + 1;
		PRINT 'Contador: ' + CAST(@contador AS VARCHAR (3));	
 END
GO

-- imprimir os numeros impares
GO
DECLARE @contador INT = 0;

WHILE @contador < 10
 BEGIN 
 		SET @contador = @contador + 1;

		IF @contador % 2 != 0
			PRINT 'Contador: ' + CAST(@contador AS VARCHAR (3));	

 END
GO

-- CONTINUE
GO
DECLARE @contador INT = 0;

WHILE @contador < 10
 BEGIN 
 		SET @contador = @contador + 1;
		IF @contador % 2 = 0
		    CONTINUE

		PRINT 'Contador: ' + CAST(@contador AS VARCHAR (3));	

 END
GO


--- 

-- CURSORES

DECLARE @nome VARCHAR (50);

DECLARE cursorFuncionario CURSOR FOR
SELECT Pnome FROM FUNCIONARIO;

-- quando abrir o cursorFuncionario inserir um pnome, tipo um vetor. 
OPEN cursorFuncionario;

FETCH NEXT FROM cursorFuncionario INTO @nome;

WHILE @@FETCH_STATUS = 0 -- quando não tiver mais ninguém ele vira 1;
BEGIN 
	PRINT @nome;
	FETCH NEXT FROM cursorFuncionario INTO @nome;
END

CLOSE cursorFuncionario;
DEALLOCATE cursorFuncionario;
