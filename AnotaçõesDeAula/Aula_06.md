## Aula 06 - Dia 04.09.2026

## Conversões 

### CAST
Para converter o decimal em uma string

```sql
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

```
--- 

### CONVERT
É usado para normalmente para converter datas ou trabalhar com float/real. 

| Código do Estilo | Padrão | Formato |
|------------------:|--------|---------|
| 101 | EUA | `mm/dd/aaaa` |
| 102 | ANSI | `aaaa.mm.dd` |
| 103 | BRITÂNICO/FRANCÊS | `dd/mm/aaaa` |
| 112 | ISO | `aaaammdd` |
| 109 | PADRÃO | `mês dd aaaa` |

Documentação do banco de dados: ([DOCUMENTO CONVERSÃO](https://learn.microsoft.com/pt-br/sql/t-sql/functions/cast-and-convert-transact-sql?redirectedfrom=MSDN&view=sql-server-ver16)).

```sql
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
DECLARE @data_nasc DATE,
		@nome VARCHAR(15);
SET @nome = 'Jennifer';

SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = @nome;

PRINT 'Data de nascimento: ' + CONVERT(VARCHAR(20),@data_nasc,103);
```
--- 

## Condicional IF / ELSE
```sql
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
```
