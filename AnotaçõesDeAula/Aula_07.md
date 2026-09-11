## Aula 07 - Dia 11.09.2026

### Função Escalar 
As funções em sql devem obrigatoriamente retornar algum valor (tabela ou escalar)e pode ser utilizado em instruções `SELECT`,`WHERE`. 

> OBSERVAÇÃO: cuidar onde vai ser criado a função, por exemplo, quando executei a primeira vez acabei criando no master. Tem que ser no banco no caso da `EMPRESA`.Quando criado a função dentro da pasta programação e função com valor escalar vai estar a função criada e se clicar em cima tem opção de modificar para mudar a função já criada. 

```sql
-- FUNÇÕES
GO
-- cria ou altera a função
CREATE OR ALTER FUNCTION fn_dobro (@numero DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN @numero * 2;
END;
GO

-- exibindo o resultado e passando como parâmetro um número. 
SELECT dbo.fn_dobro(250) AS 'Resultado';


-- duplicando salário do funcionário
GO
SELECT
		F.Pnome,
		F.Unome,
		F.Salario AS 'Salário antigo',
		dbo.fn_dobro(F.Salario) AS 'Novo Salário'
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Carlos';
GO
-- Pegar o menor salário e listar os funcinário que ganham mais que o dobra do menor salário
GO
DECLARE @menor_salario DECIMAL(10,2);

SELECT @menor_salario = MIN(Salario)
FROM FUNCIONARIO;
SELECT
		F.Pnome,
		F.Unome,
		F.Salario
FROM FUNCIONARIO AS F
WHERE F.Salario > dbo.fn_dobro(@menor_salario);
GO

---
-- FUNÇÃO: que calcula a idade do funcionário
GO
CREATE FUNCTION fn_calcula_idade(@data_nasc DATE)
RETURNS INT
AS
BEGIN
	DECLARE @idade INT;
	SET @idade = DATEDIFF(YEAR,@data_nasc,GETDATE());
	IF(MONTH(@data_nasc) > MONTH(GETDATE()) OR MONTH(@data_nasc) = MONTH(GETDATE()) AND DAY(@data_nasc) > DAY(GETDATE()))
		SET @idade -= 1;
	RETURN @idade
END;
GO

-- PRINT para mostrar a idade dos dependente numa tabela e funcionário.
SELECT D.Nome_dependente,D.Datanasc,dbo.fn_calcula_idade(D.Datanasc) AS 'Idade'
FROM DEPENDENTE AS D;

SELECT  Pnome,
		Unome,
		Datanasc,
		CONVERT(VARCHAR,DataNasc,103) AS 'Data Nasc',
		dbo.fn_calcula_idade(Datanasc) AS 'Idade'
FROM FUNCIONARIO;
```
---
### Funções Inline

```sql

GO
CREATE OR ALTER FUNCTION fn_dpto_func(@nome_dpto VARCHAR(100))
RETURNS TABLE
AS 
RETURN 
(
	SELECT F.Pnome,F.Unome,D.Dnome
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
	WHERE D.Dnome = @nome_dpto

);
GO
-- precisa estar vinculada no FROM, pois estou pedindo os campos de uma tabela inteira.
SELECT * FROM dbo.fn_dpto_func('Pesquisa');

```
---
### Funções Multi - Statament (Tabela com Lógica)

```sql
-- Funções Multi - Statament (Tabela com Lógica):

/*
Criar uma função que retorna nome completo dos funcionários e o valor do salário anual, 
com férias e décimo terceiro
*/
GO
CREATE OR ALTER FUNCTION fn_calculo()
RETURNS @SalAno TABLE
(
	nome VARCHAR(100),
	salario DECIMAL(10,2),
	salario_anual DECIMAL(10,2)
)
AS 
BEGIN
	INSERT INTO @SalAno
	SELECT CONCAT(F.Pnome,' ',F.Minicial,' ',F.Unome),F.Salario,F.Salario*13+(F.Salario *0.3)
	FROM FUNCIONARIO AS F
	RETURN;
END;
GO
SELECT * FROM dbo.fn_calculo();
```
---
### Stored Procedure (Criação e Execução no SQL)
São lotes (batches) de declarações que podem ser executadas como uma subrotina, entrando no conceito de `BANCO ATIVO`, também é possível controlar as permissões de acesso aos usuários definindo quem pode ou não executá - las. 

```sql
-- Stored Procedure

GO
CREATE PROCEDURE sp_exibe_meu_nome
AS 
BEGIN
	PRINT 'Yasmin D. Tavares';
END
GO;
-- exibe o print
EXEC sp_exibe_meu_nome;

--- Criar um procedure que aumente o salario dos funcionario em 5
GO
CREATE OR ALTER PROCEDURE sp_aumento (@porcentagem DECIMAL(3,1),
							@cpf CHAR(11))
AS
BEGIN
		UPDATE FUNCIONARIO 
		SET Salario = Salario * (1 + (@porcentagem / 100))
		Where Cpf = @cpf;
		-- como não tem where vai aumentar salário de todos os que estão na tabela
END
GO

EXEC dbo.sp_aumento @porcentagem =  50,@cpf = '98765432300';

SELECT * 
FROM FUNCIONARIO
WHERE Pnome = 'Maria';

SELECT * FROM FUNCIONARIO;

-- da informações qdo foi criado...
EXEC sp_help sp_aumento; 
EXEC sp_help funcionario;

```
### Criptografar Stored Procedure
Usado para ninguém  vizualizar o que tem dentro da função só quem criou pode visualizar
```sql
---
/* Criptografar Stored Procedure: usado para ninguém 
vizualizar o que tem dentro da função só quem criou pode visualizar*/
GO
CREATE PROCEDURE sp_funcionarios 
WITH ENCRYPTION
AS 
SELECT * FROM FUNCIONARIO;

GO
EXEC sp_help sp_funcionarios;
```

---
### Modificar Stored Procedure

```sql

/*Crie um procedure que insira um novo departamento com sua respectiva
localidade*/
GO
CREATE OR ALTER PROCEDURE sp_departamento (@nome_dpto VARCHAR(100),@dpto_numero INT,@localidade VARCHAR(100))
AS
BEGIN

	IF EXISTS
		 
			(SELECT 1 -- retornar algo se existe o departamento com nome criado
			FROM DEPARTAMENTO 
			WHERE Dnome = 'Compras')
			BEGIN
				    PRINT 'Esse Departamento já existe' + @nome_dpto;;
		  			RETURN;
		  END
		ELSE
		BEGIN
			 INSERT INTO DEPARTAMENTO (Dnome,Dnumero)
			 VALUES(@nome_dpto,@dpto_numero);

			 INSERT INTO LOCALIZACAO_DEP(Dnumero,Dlocal)
			 VALUES (@dpto_numero,@localidade);
			 PRINT 'Departamento inserido com sucesso ' + @nome_dpto;
		END

END
GO

EXEC dbo.sp_departamento @dpto_numero = '9',@nome_dpto = 'Compras', @localidade = 'Santa Maria';

SELECT *
FROM DEPARTAMENTO AS D
JOIN LOCALIZACAO_DEP AS L ON D.Dnumero = L.Dnumero;
```

--- 
```sql
/*
Crie um procedure que faz uma listagem dos funcionários por departamento, mas
se o departamento não for especificado, o procedimento lista todos os
funcionarios
*/
GO
CREATE OR ALTER PROCEDURE sp_lista (@nome_dpto VARCHAR(100))
AS

BEGIN
	IF (@nome_dpto IS NULL)
				
		BEGIN
			 SELECT *
			FROM FUNCIONARIO AS F;
		END;
				
	ELSE
		BEGIN
		 SELECT F.Pnome,F.Unome,D.Dnome
			FROM FUNCIONARIO AS F
			JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
			WHERE D.Dnome = @nome_dpto
		END
END
GO

EXEC dbo.sp_lista @nome_dpto ='Pesquisa';



```
