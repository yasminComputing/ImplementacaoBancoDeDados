## Aula 03 - Dia 14.08.2026
Utilizado a platoforma `SQL Server Management Studio 22`. Os dados inseridos no banco foi que contém nesse repositório do professor ([DADOS](https://github.com/Herysson/Implementacao-de-Banco-de-Dados/blob/main/EMPRESA.sql)). 

---

## Revisão de palavras para **SELECT**

- `DISTINCT`

```sql
-- DISTINCT : Listar as diferentes faixas salariais dos funcionários
    SELECT DISTINCT F.Salario
    FROM FUNCIONARIO AS F;

    SELECT DISTINCT F.Sexo
    FROM FUNCIONARIO AS F;
```
---

- `WHERE`
```sql
-- Recupere todas as informações do funcionários com primeiro nome Carlos
    SELECT *
    FROM FUNCIONARIO AS F
    WHERE F.Pnome ='Carlos';
```
---
- `AND, OR e NOT`:
    * AND: as duas condições têm que ser verdadeiro 
    * OR: uma das condições tem que ser verdadeiro
    * NOT: é uma negação de uma condição

```sql
-- AND: Listar os funcionários do sexo masculino com salário >= 30.000
    SELECT *
    FROM FUNCIONARIO AS F
    WHERE F.Sexo = 'M' AND F.Salario >= 30000;

```
---
```sql
-- OR: liste os funcionários que moram em SP ou em Curitiba
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco LIKE '%São Paulo%' OR F.Endereco LIKE '%Curitiba%';

```
---
```sql
-- NOT: liste os funcionários que não moram em SP
SELECT *
FROM FUNCIONARIO AS F
WHERE NOT F.Endereco LIKE '%São Paulo%';
```

---
- `ORDER BY`: é usado para classificar um conjunto de dados em ASC OU DESC.

```sql
-- ORDER BY: listar os funcionários em ordem descrescente de salário
    SELECT CONCAT (F.Pnome ,' ',F.Minicial,' ',F.Unome) AS 'Nome do Funcionário',F.Salario*12 as 'CustoAnual' 
    FROM FUNCIONARIO AS F
    ORDER BY CustoAnual DESC;
```
---
- `NULL`: representa um campo sem valor. É possível inserir um novo registro ou atualizar um registro sem informar um valor para determinado campo; nesse caso, ele ficará como `NULL`. Para verificar se um campo possui ou não valor, utilizamos `IS NULL` ou `IS NOT NULL`.

```sql
-- IS NULL: encontre os funcionários que não possuem supervisor
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NULL;

-- IS NOT NULL: encontre os funcionários que possuem supervisor
SELECT *
FROM FUNCIONARIO AS F
WHERE F.Cpf_supervisor IS NOT NULL;

```

--- 
- `TOP`: é usada para especificar o número de registros a
serem retornados.A cláusula SELECT TOP é útil em tabelas grandes com milhares de registros.Retornar um grande número de registros pode afetar o desempenho.

```sql 
-- TOP 
SELECT TOP 3 *
FROM FUNCIONARIO AS F
ORDER BY F.Salario DESC;

```

--- 

- `MIN() | MAX()`

```sql
-- MIN(): recupere as informações do funcionários com o menor salário
SELECT MIN(Salario) as 'Salário'
FROM FUNCIONARIO AS F;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario = (SELECT MIN(Salario)FROM FUNCIONARIO);

-- Precisa rodar isso inteiro para pegar as informações
DECLARE @salario_min DECIMAL(10,2); -- não fica salvo em memória só em tempo de execução
SET @salario_min =(SELECT MIN(Salario)FROM FUNCIONARIO);
PRINT @salario_min;

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Salario = @salario_min;
-- até aqui 

```

> Select alinhado é criar um select que resolve metade de um problema e depois construir o resto.