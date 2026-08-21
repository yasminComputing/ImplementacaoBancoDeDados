## Aula 04 - Dia 21.08.2026

### IN
O operador permite que você especifique vários valores em uma cláusula `WHERE`. O operador IN é um forma abreviada para múltiplas condições. 

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

### BETWEEN
Seleciona valores dentro de um determinado intervalo. Os valores podem ser números, texto ou datas.

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

### **INNER JOIN**
Apenas os registros que possuem correspondência nas duas tabelas. Ou seja, retorna somente os dados que estão relacionados entre elas.
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

--- Para cada projeto localizado em “Mauá”, liste o número do projeto, o número do departamento que o
-- controla e o sobrenome, endereço e data de nascimento do gerente do departamento
SELECT	
		D.Dnome AS "Nome do Departamento",
		P.Projnome AS "Nome do Projeto",
		P.Projlocal AS "Local do Projeto",
		F.Unome AS "Sobrenome do Funcionário",
		F.Cpf  AS "CPF",
		F.Endereco AS "Endereço"
FROM DEPARTAMENTO AS D
INNER JOIN PROJETO AS P ON P.Dnum =  D.Dnumero
INNER JOIN FUNCIONARIO AS F ON F.Cpf = D.Cpf_gerente
WHERE P.Projlocal = 'Mauá';
```
---

### **LEFT JOIN**
Os registros da tabela da esquerda, mesmo que não exista um registro correspondente na tabela da direita. Por exemplo, mostra todos os funcionários, inclusive aqueles que não estão vinculados a nenhum departamento.

```sql
-- LEFT JOIN: Liste o último nome de TODOS os funcionários e o 
--  último nome dos respectivos departamento,caso possuam

SELECT
		F.Unome,
		D.Dnome as "Departamento"
FROM FUNCIONARIO AS F
LEFT JOIN DEPARTAMENTO AS D ON D.Dnumero = F.Dnr
ORDER BY D.Dnome ASC;

-- Encontre os departamentos que não possuem funcionários a eles vinculados
SELECT *
FROM DEPARTAMENTO AS D
LEFT JOIN FUNCIONARIO AS F ON F.Dnr = D.Dnumero
WHERE F.Cpf IS NULL;

```
---- 

###  **RIGHT JOIN**
Todos os registros da tabela da direita, mesmo que não exista um registro correspondente na tabela da esquerda. Por exemplo, mostra todos os departamentos, inclusive aqueles que ainda não possuem funcionários.

```sql 
-- RIGHT JOIN:Encontre os departamentos que não possuem nenhum funcionário
SELECT *
FROM FUNCIONARIO AS F
RIGHT JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
WHERE F.Cpf IS NULL;


```
--- 

### **FULL JOIN**
Retorna todos os registros de ambas as tabelas. 

```sql
-- FULL JOIN: Teste entre as relações Funcionários e Departamento
SELECT *
FROM FUNCIONARIO AS F 
FULL JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero;
-- 
SELECT *
FROM FUNCIONARIO AS F 
FULL JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
WHERE D.Dnumero IS NULL OR F.Cpf IS NULL ;
```
- **SELF JOIN**: quanto uma tabela possui um auto relacionamento, ou seja, quando uma tabela se relaciona com ela mesma.

```sql
-- SELF JOIN: Crie uma consulta que mostra apenas os funcionários que têm um supervisor

SELECT F.Pnome AS "Funcionário", SUPERVISOR.Unome AS "Supervisor" 
FROM FUNCIONARIO AS F 
JOIN FUNCIONARIO AS SUPERVISOR ON F.Cpf_supervisor = SUPERVISOR.Cpf 
ORDER BY SUPERVISOR ASC;
```
---

### UNION
Operador UNION é usado para combinar o conjunto de resultados de duas ou
mais instruções SELECT.Cada instrução SELECT dentro de UNION deve ter o mesmo número de colunas. 
```sql
-- UNION: Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco.

SELECT 
		F.Pnome AS "Nome", 
		F.Sexo AS "Sexo", 
		F.Datanasc AS "Data de Nascimento"
FROM FUNCIONARIO AS F
UNION
SELECT 
		D.Nome_dependente AS "Nome",
		D.Sexo AS "Sexo",
		D.Datanasc as "Data"
FROM DEPENDENTE AS D;
```

### INTERSECT


```sql



```

### EXCEPT

```sql



```