/*
8. Crie uma função fn_RankingSalarioDepartamento que receba o número de um
departamento e retorne uma tabela com os funcionários desse departamento,
incluindo:
a. Nome completo
b. Salário
c. Posição no ranking de salários (1 = maior salário do departamento).
d. Dica: Use ROW_NUMBER() dentro da função.
*/
GO
CREATE OR ALTER FUNCTION fn_RankingSalaioDepartamento(@numero_dpto INT)
RETURNS TABLE
AS
RETURN (
		SELECT 
				CONCAT(F.Pnome,' ',F.Minicial,' ',F.Unome) AS 'Nome Completo',
				F.Salario as 'Salário(R$)',
				ROW_NUMBER() OVER (ORDER BY F.Salario DESC) AS 'Posição'
		FROM FUNCIONARIO AS F
		WHERE @numero_dpto = F.Dnr
		)
GO
SELECT * FROM fn_RankingSalaioDepartamento(4);
GO
select *
from departamento;

----
/*6. Crie uma função fn_TemMaisQueNDependentes que receba um número N e o CPF
de um funcionário, retornando 1 se ele tiver mais que N dependentes e 0 caso
contrário.*/
GO
CREATE OR ALTER FUNCTION fn_TemMaisQueNDependentes(@n INT, @cpf AS VARCHAR(11))
RETURNS INT
AS 
BEGIN
		DECLARE @retorno INT = 0;

			SELECT @retorno = 1
			FROM FUNCIONARIO AS F
			JOIN DEPENDENTE AS D ON F.Cpf = D.Fcpf
			HAVING COUNT(D.Fcpf) > @n
	RETURN @retorno
END
GO

SELECT dbo.fn_TemMaisQueNDependentes(1,'12345678966') AS 'Possui Maior Dependentes';
select *
from dependente;
