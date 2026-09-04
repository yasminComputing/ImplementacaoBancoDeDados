## Aula 05 - Dia 28.08.2026

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
A cláusula HAVING foi adicionada ao SQL porque a palavra-chave WHERE não pode ser usada com funções agregadas.

*QUANDO FAZER O USO DO GROUP BY E QUERO FAZER UMA FILTRAGEM TENHO QUE USAR O HAVING.*

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
--- 

### EXISTS
É usado para testar a existência de qualquer registro em uma subconsulta. O operador retorna `TRUE` se a subconsulta retornar um ou mais registro.
```sql
-- EXISTS: Listar departamentos que possuem projetos associados
-- O SELECT 1 É TIPO UM BOOLEANO, RETORNA 1 SE TIVER NO PROJETO, 
-- TIPO RETORNA SE TIVER NO DEPARTAMENTO 30, COMO NÃO EXISTE RETORNA NADA E SE TIVER RETORNA 1
SELECT *
FROM DEPARTAMENTO
WHERE EXISTS (
	SELECT 1
	FROM PROJETO AS P
	WHERE P.Dnum = DEPARTAMENTO.Dnumero
)

```
--- 
### ANY
Retorna um valor booleano como resultado, TRUE se QUALQUER um dos valores da subconsulta atender à condição ANY significa que a condição será verdadeira se a operação for verdadeira paraqualquer um dos valores no intervalo. 
```sql
--- ANY: Encontrar funcionários que ganham mais do que qualquer funcionário do departamento de 'Administração'
-- Monstra os funcionários que ganham ou igual do pessoal da adminstração
SELECT Pnome, Salario
FROM FUNCIONARIO 
WHERE Salario > ANY(

			SELECT F.Salario
			FROM FUNCIONARIO AS F
			JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
			WHERE D.Dnome = 'Administração'
		)
ORDER BY Salario;
```

--- 
### ALL
Retorna um valor booleano como resultado e TRUE se TODOS os valores da subconsulta atenderem à condição é usado com instruções SELECT, WHERE e HAVING ALL significa que a condição será verdadeira somente se a operação for verdadeira
para todos os valores no intervalo.
```sql
-- ALL
SELECT Pnome, Salario
FROM FUNCIONARIO 
WHERE Salario <> ALL(

			SELECT F.Salario
			FROM FUNCIONARIO AS F
			JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
			WHERE D.Dnome = 'Administração'
		)
ORDER BY Salario;
```

---
## Variáveis - Conversões IF / ELSE - While
Conceitos de **BANCO ATIVOS** são sistemas de gerenciamento de banco de dados que possuem a capacidade de reagir automaticamente a certos eventos ou condições definidas pelos usuários.

Para declarar um variável no corpo batch no SQL é:

```sql
Declare @valor INT;
SET @valor = 10;
```
*O uso do CAST é para conversão da variável tipo o int para colocar em VARCHAR.*

```sql
-- DECLARE
DECLARE @nome VARCHAR(100),
		@idade INT,
		@salario DECIMAL(10,2),
		@data DATE;
SET @nome = 'Herysson R. Figueiredo';
SET @idade = 38;
SET @salario = 2400.00;
SET @data = GETDATE();
-- Para rodar o print é necessário rodar todo o comando a partir do DECLARE, se tentar colocar
-- um mais com a IDADE vai dar erro, pois tem que ser no mesmo tipo, 
-- PRINT 'Olá SQL, meu nome é: ' + @nome;
PRINT 'Nome: ' + @nome + ' Idade: ' + CAST(@idade AS VARCHAR(10));

-- RETORNA TUDO NUMA TABELA 
SELECT 
		@nome AS 'Nome',
		@idade AS 'Idade',
		@salario AS 'Salário',
		@data AS 'Data';
GO
-- 
-- Colocar o departamento numero 4 na variavél
DECLARE @nome_departamento VARCHAR(50);

SELECT @nome_departamento = Dnome
FROM DEPARTAMENTO AS D
WHERE D.Dnumero = 4;

PRINT 'Departamento: ' + @nome_departamento;
GO

---
-- Calculando o novo salário com um aumento de 10%, para a Jennifer
DECLARE @novo_salario DECIMAL (10,2),
		@antigo_salario DECIMAL(10,2);

SELECT @antigo_salario = F.Salario
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';

SET @novo_salario = @antigo_salario * 1.1;

PRINT 'Salário antigo: ' + CAST(@antigo_salario AS VARCHAR(50)) ;
PRINT 'Novo Salário: ' + CAST(@novo_salario AS VARCHAR(50));
GO

--- 
-- Calculando a idade da Jennifer.
DECLARE @data DATE,
		@idade_atual INT,
		@data_nasc DATE;


SELECT @data_nasc = F.Datanasc
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'Jennifer';
SET @idade_atual = YEAR(GETDATE()) - YEAR(@data_nasc);
PRINT 'A Jennifer tem: ' + CAST(@idade_atual AS VARCHAR(5));

PRINT DATEDIFF(YEAR,@data_nasc, GETDATE());
```