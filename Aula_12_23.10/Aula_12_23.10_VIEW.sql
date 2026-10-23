--- VIEW
GO
CREATE VIEW vw_rh_funcionario_dpt
AS

	SELECT 
			CONCAT (Pnome, ' ',Minicial,'.',Unome) AS 'Nome',
			DATEDIFF(YEAR,Datanasc,GETDATE()) AS 'Idade',
			Endereco AS 'Endereço',
			Data_Admissao AS 'Admissão',
			D.Dnome AS 'Departamento'
	FROM FUNCIONARIO AS F
	JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
GO
GO
SELECT * 
FROM vw_rh_funcionario_dpt 
ORDER BY 'Nome';

SELECT * 
FROM vw_rh_funcionario_dpt 
WHERE Departamento = 'Matriz';
GO
---
--- EXERCICIOS
