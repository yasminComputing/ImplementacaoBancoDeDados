## Aula 05 - Dia 28.08.2026
---
### INTERSECT

```sql
-- INTERSECT: Encontre os Funcionários que são Supervisores

SELECT Cpf
FROM FUNCIONARIO
INTERSECT
SELECT DISTINCT Cpf_supervisor
FROM FUNCIONARIO;

```
---
### EXCEPT

```sql
-- EXCEPT: Listar os CPFs dos funcionários que não são gerentes de nenhum departamento.

SELECT F.Cpf,F.Pnome
FROM FUNCIONARIO AS F
EXCEPT
SELECT D.Cpf_gerente,F.Pnome
FROM DEPARTAMENTO AS D
JOIN FUNCIONARIO AS F ON D.Cpf_gerente = F.Cpf

```
---
### GROUP  BY
A instrução GROUP BY agrupa linhas com os mesmos valores em linhas deresumo, como "encontre o número de clientes em cada país".A instrução `GROUP BY` é frequentemente usada com funções agregadas(COUNT(), MAX(), MIN(), SUM(), AVG()) para agrupar o conjunto de resultadospor uma ou mais colunas.

```sql
--- GROUP BY: Quantidade de funcionários por sexo
-- O count vai contar a qtde do genêro. 
SELECT COUNT( F.Cpf) AS "Qtde", F.Sexo
FROM FUNCIONARIO AS F
GROUP BY F.Sexo; -- quantos f ou m tem nesse grupo


-- Contar o número de funcionários por departamento
SELECT COUNT(F.Cpf) AS "Qtde", D.Dnome
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
GROUP BY D.Dnome;


-- Somar os salários por departamento
SELECT SUM(F.Salario) as "Salário", D.Dnome as "Departamento"
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
GROUP BY D.Dnome;

-- Média de horas trabalhadas por projeto
SELECT AVG(T.Horas) AS "Média", P.Projnome
FROM TRABALHA_EM  AS T
JOIN PROJETO AS P ON T.Pnr = P.Projnumero
GROUP BY P.Projnome;

```
> Quando usado o group by e colocar o D.Dnome não pode deixar o F.Cpf por isso vamos contar a quantidade do CPF que aparece um número. 

--- 

### HAVING
A cláusula HAVING foi adicionada ao SQL porque a palavra-chave WHERE não
pode ser usada com funções agregadas.

*QUANDO USO O GROUP BY E QUERO FAZER UMA FILTRAGEM TENHO QUE USAR O HAVING.*

```sql
-- HAVING: Encontrar departamentos com mais de 3 funcionários
SELECT COUNT(F.Cpf) as "Func", D.Dnome as "Departamento"
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
GROUP BY D.Dnome
HAVING COUNT(F.Cpf) > 3;

-- Listar projetos que exigem no minimo 50 horas trabalho no total
SELECT SUM(T.Horas) as "Horas", P.Projnome
FROM PROJETO AS P
JOIN TRABALHA_EM AS T ON T.Pnr = P.Projnumero
GROUP BY P.Projnome
HAVING SUM(T.Horas) >= 50;

```