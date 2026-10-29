-- 	Exercícios Funções

/*
	1. Crie uma função fn_ProjetosPorFuncionario que receba o Cpf de um funcionário e
	retorne os nomes dos projetos nos quais ele trabalha (usando a tabela
	TRABALHA_EM)*/

USE EMPRESA;

GO
CREATE OR ALTER FUNCTION fn_ProjetosPorFuncionario (@cpf AS CHAR(11))
RETURNS TABLE
AS
RETURN(
		SELECT
				
				P.Projnome AS 'Nome do Projeto',
				P.Projlocal AS 'Local do Projeto'
		FROM FUNCIONARIO AS F
		JOIN TRABALHA_EM AS T ON F.Cpf = T.Fcpf
		JOIN PROJETO AS P ON T.Pnr = P.Projnumero
		WHERE F.Cpf = @cpf);
	
GO

SELECT *FROM dbo.fn_ProjetosPorFuncionario('12345678966');

SELECT *FROM dbo.fn_ProjetosPorFuncionario('98765432168');

SELECT *FROM dbo.fn_ProjetosPorFuncionario('99988777767');

--
/*
	3. Crie uma função fn_NomeSupervisor que receba o Cpf de um funcionário e retorne o
	nome completo do seu supervisor (usando a coluna Cpf_supervisor da tabela
	FUNCIONARIO).
*/
GO
CREATE OR ALTER FUNCTION fn_NomeSupervisor(@cpf_funcionario CHAR(11))
RETURNS VARCHAR(100)
BEGIN
		DECLARE @nome_supervisor VARCHAR(100);

		SELECT @nome_supervisor = CONCAT(FUNC_2.Pnome,' ',FUNC_2.Minicial,' ',FUNC_2.Unome) 
		FROM FUNCIONARIO AS FUNC_1
		INNER JOIN FUNCIONARIO AS FUNC_2 ON FUNC_1.Cpf_supervisor = FUNC_2.Cpf_supervisor
		WHERE FUNC_1.Cpf  = @cpf_funcionario;

	RETURN @nome_supervisor
END;

GO
SELECT dbo.fn_NomeSupervisor('45345345376') AS 'Nome Supervisor';

SELECT dbo.fn_NomeSupervisor('65465465433') AS 'Nome Supervisor';

-----

/*
	4. Crie uma função fn_GanhaMaisQueSupervisor que receba o Cpf de um funcionário
	e retorne 1 (verdadeiro) se o salário dele for maior que o salário de seu supervisor,
	ou 0 (falso) caso contrário
*/
GO
CREATE OR ALTER FUNCTION fn_GanhaMaisQueSupervisor(@cpf_funcionario CHAR(11))
RETURNS INT
BEGIN
		DECLARE @booleano INT;
IF EXISTS (
		SELECT *
		FROM FUNCIONARIO AS FUNC_1
		INNER JOIN FUNCIONARIO AS FUNC_2 ON FUNC_1.Cpf_supervisor = FUNC_2.Cpf
		WHERE FUNC_1.Cpf  = @cpf_funcionario AND FUNC_1.Salario > FUNC_2.Salario)
	   SET @booleano = 1;

ELSE 
	SET @booleano = 0 ;

	  RETURN @booleano;

END;

GO
SELECT dbo.fn_GanhaMaisQueSupervisor('65465465433') AS  'Ganha mais que Supervisor';

SELECT dbo.fn_GanhaMaisQueSupervisor('98765432300') AS  'Ganha mais que Supervisor';

----
/*
	7. Crie uma função fn_QtdProjetosFuncionario que receba o CPF de um funcionário e
	retorne o número de projetos nos quais ele trabalha (tabela TRABALHA_EM).
*/
GO
CREATE OR ALTER FUNCTION fn_QtdeProjetosFuncionario(@cpf_funcionario CHAR(11))
RETURNS INT
BEGIN
	DECLARE @qtde INT;

	SELECT @qtde = COUNT(*)
	FROM TRABALHA_EM
	WHERE Fcpf = @cpf_funcionario;
	
	RETURN @qtde;

END;
GO

SELECT dbo.fn_QtdeProjetosFuncionario('45345345376') AS  'Qtde Projetos';

SELECT dbo.fn_QtdeProjetosFuncionario('33344555587') AS  'Qtde Projetos';

----
/*
	9. Crie uma função fn_CustoDepartamento que receba o número de um departamento
	e retorne a soma dos salários de todos os funcionários do departamento (ou seja,
	quanto custa manter esse time por mês).
*/
GO
CREATE OR ALTER FUNCTION fn_CustoDepartamento(@numero_dpto INT)
RETURNS DECIMAL(10,2)
BEGIN
		DECLARE @soma DECIMAL(10,2);

		SELECT @soma = SUM(F.Salario) 
		FROM FUNCIONARIO AS F
		WHERE F.Dnr = @numero_dpto;

	RETURN @soma;

END;


GO
SELECT dbo.fn_CustoDepartamento(1) AS 'Soma do Sálario por Departamento';
SELECT dbo.fn_CustoDepartamento(5) AS 'Soma do Sálario por Departamento';
SELECT dbo.fn_CustoDepartamento(4) AS 'Soma do Sálario por Departamento';

