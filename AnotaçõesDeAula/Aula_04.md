## Aula 04 - Dia 21.08.2026

- `IN`: o operador permite que você especifique vários valores em uma cláusula `WHERE`. O operador IN é um forma abreviada para múltiplas condições. 

```sql
-- IN: Recupere as informações dos funcionários que recebem 25000 e 30000 R$
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario IN (25000, 30000)
ORDER BY F.Pnome ASC;

-- IN (SELECT...): Recupere os registros dos funcionários que trabalham (TRABALHA_EM) no mesmo 
-- projeto e na mesma quantidade de horas do “Fernando” (Fcpf = “33344555587” )

SELECT F.Pnome as "Nome", T.Pnr 
FROM TRABALHA_EM AS T, FUNCIONARIO AS F
WHERE F.Cpf = T.Fcpf 
	AND F.Pnome <> 'Fernando'-- para Fernando não aparecer no relatório
	AND T.Pnr IN(
				SELECT T.Pnr 
				FROM TRABALHA_EM AS T 
				WHERE T.Fcpf =
							  (SELECT F.Cpf
							  FROM FUNCIONARIO AS F
							  WHERE F.PNome = 'Fernando'));

```

- `BETWEEN`: seleciona valores dentro de um determinado intervalo. Os valores podem ser números, texto ou datas.

```sql
-- BETWEEN: Recuperar todos os funcionários no departamento 5 cujo salário esteja entre R$ 
-- 30.000 e R$ 40.000
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Dnr = 5 AND F.Salario BETWEEN 30000 AND 40000;
```
--- 
## JOINS
Material usado ([JOINS](https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/Aula%2003%20-%20Consultas%20Joins.pdf)). 
O *JOIN* é usado para combinar linhas de duas ou mais tabelas, com base em uma coluna relacionada entre elas. 

- **INNER JOIN**: apenas os registros que possuem correspondência nas duas tabelas. Ou seja, retorna somente os dados que estão relacionados entre elas.
```sql
-- INNER JOIN: Selecionar o primeiro nome, último nome, endereço dos funcionários que trabalham no departamento de
-- “Pesquisa”

SELECT	
		CONCAT(F.Pnome,' ',F.Unome) AS "Nome do Funcionário",
		F.Endereco AS "Endereço",
		D.Dnome AS "Departamento"
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO	 AS D ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Pesquisa';

-- Liste o nome dos funcionários que estão desenvolvendo o “ProdutoX”. 

SELECT 
		CONCAT(F.Pnome,' ',F.Unome) AS "Nome do Funcionário",
		T.Horas AS "Horas Trabalhadas",
		P.Projnome AS "Nome do Projeto"
FROM TRABALHA_EM AS T
INNER JOIN PROJETO AS P ON T.Pnr = P.Projnumero
INNER JOIN FUNCIONARIO AS F ON T.Fcpf = F.Cpf
WHERE P.Projnome = 'ProdutoX';


```

- **LEFT JOIN**: os registros da tabela da esquerda, mesmo que não exista um registro correspondente na tabela da direita. Por exemplo, mostra todos os funcionários, inclusive aqueles que não estão vinculados a nenhum departamento.

- **RIGHT JOIN**: todos os registros da tabela da direita, mesmo que não exista um registro correspondente na tabela da esquerda. Por exemplo, mostra todos os departamentos, inclusive aqueles que ainda não possuem funcionários.

- **CROSS JOIN**: retorna todos os registros de ambas as tabelas. 


