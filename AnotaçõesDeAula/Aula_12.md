## Aula 12 - Dia 23.10.2026

### Triggers
Trigger (ou gatilho) é um objeto de banco de dados que é associado a uma tabela ou visão, só é executado quando o **EVENTO CONDIÇÃO AÇÃO (ECA)**. Sua principal função é executar automaticamente uma série de instruções SQL em resposta a certos eventos, como operações de inserção (INSERT), atualização (UPDATE) ou exclusão (DELETE).
    - Eventos: eventos que normalmente são operações de atualização do banco de dados que são aplicadas dentro do banco
    - Condição: quando o evento dispara a ação e tiver ocorrido, uma condição opcional pode ser avaliada. Se nenhuma condição for especificada, a ação será executada quando ocorres o evento.
>  Trigger (Gatilho) é um tipo especial de Stored Procedure que é executada automaticamente quando um usuário realiza uma operação de modificação de dados em uma tabela especificada.

---
### Modos de Disparo de um Trigger
- `After`: código presente no trigger é executado após todas as ações terem sidos completadas na tabela especificada.
- `Instead Of`: é executado no lugar da operação que causou seu disparo.

---
### Fluxos
1. Verificação de IDENTITY INSERT
2. Restrição (Constraint) de Nulos (NULL)
3. Checagem de tipos de dados - DEPOIS DE 1 A 3 TIVEREM CORRETAS VEM PARA A 4
4. Execução de trigger INSTEAD OF (a execução do DML pára aqui; esse trigger
não é recursivo) - CASO NAO TENHA INSTEAD OF PULA PARA PROXIMA ETAPA
5. Restrição de Chave Primária
6. Restrição “Check”
7. Restrição Chave Estrangeira
8. Execução do DML e atualização do log de transações
9. Execução do trigger AFTER
10. Commit da transação (Confirmação)

--- 
### Praticando
Quando criado fica numa pasta `GATILHO`. Usando mais para regra de negócios, exemplo aumento de salário só pode ser maior já existente nunca pode ser menor, uma pessoa pode administrar no máximo 2 setores. 
```sql
--- Criando um primeiro TRIGGER AFTER INSERT
GO
CREATE TRIGGER trg_after_insert_dpt
ON DEPARTAMENTO
AFTER INSERT 
AS
BEGIN
	PRINT 'Olá meu primeiro TRIGGER!'
END;

/* VAI DAR ERRO,POIS O CAMPO DNUMERO É NOT NULL
INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES(NULL,'Expedição');*/

INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES(88,'Expedição');
GO

--- TRIGGER INSTEAD 
GO
CREATE TRIGGER trg_insteadof_delete_dpt
ON DEPARTAMENTO
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'NÃO DELETEI o registro'

END;
DELETE FROM DEPARTAMENTO 
WHERE Dnumero = 88;

SELECT  * FROM DEPARTAMENTO;

-- desabilitar o trigger pode ser manualmente ou fazer esse comando
ALTER TABLE DEPARTAMENTO 
DISABLE TRIGGER trg_insteadof_delete_dpt;

--- MONSTRA AS INFORMACOES DO TRIGGER DA TABELA
EXEC sp_helptrigger DEPARTAMENTO;
GO
```
--- 
```sql
-- INSERTED:permite recuperar todos os valores inseridos no select
GO
CREATE OR ALTER TRIGGER trg_after_insert_dpt
ON DEPARTAMENTO
AFTER INSERT
AS
BEGIN
	DECLARE @nome VARCHAR(40);
	SELECT @nome = I.Dnome
	FROM INSERTED AS I; 

	PRINT 'Foi inserido um novo departamento: ' + @nome;

END;
INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES(88,'Expedição');
GO

--- FAZER UM TRIGGER QUE NÃO PERMITE ADICIONAR NOME DUPLICADOS DEPARTAMENTO
GO
CREATE OR ALTER TRIGGER trg_insteadOf_verificacao_insert_dpt
ON DEPARTAMENTO
INSTEAD OF INSERT
AS
BEGIN
		DECLARE @nome VARCHAR(50);
		-- ATRIBUI A VARIAVEL @nome O VALOR QUE ESTÁ NO INSERT
		SELECT @nome = I.Dnome
		FROM INSERTED AS I;

		IF EXISTS(SELECT 1 FROM DEPARTAMENTO WHERE @nome = Dnome )
			BEGIN
				RAISERROR ('Não é permitido cadastrar nome de departamento duplicados',16,1);
			END
		ELSE
		BEGIN

			INSERT INTO DEPARTAMENTO (Dnumero,Dnome,Cpf_gerente,Data_inicio_gerente)
			SELECT I.Dnumero,I.Dnome,I.Cpf_gerente,I.Data_inicio_gerente
			FROM INSERTED AS I

			PRINT 'Departamento inserido: ' + @nome;
		END
END;

INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES(100,'Estoque');
SELECT * FROM DEPARTAMENTO;
GO
--- FAZER UM TRIGGER QUE NÃO PERMITE ADICIONAR NOME DUPLICADOS DEPARTAMENTO COM AFTER
CREATE OR ALTER TRIGGER trg_after_verificacao_insert_dpt
ON DEPARTAMENTO
AFTER INSERT
AS
BEGIN
		DECLARE @nome VARCHAR(50);
		
		SELECT @nome = I.Dnome
		FROM INSERTED AS I;

		SELECT * FROM DEPARTAMENTO;

		IF ((SELECT COUNT(Dnome) FROM DEPARTAMENTO WHERE Dnome = @nome) > 1)
			BEGIN
				ROLLBACK TRANSACTION; -- volta para original e nao salva;
				RAISERROR ('Não é permitido cadastrar nome de departamento duplicados',16,1);

			END
END;
INSERT INTO DEPARTAMENTO (Dnumero, Dnome)
VALUES(101,'Vendas');
```

---
### Continuando
```sql
-- FUNÇÃO UPDATE()
-- VERIFICAR SE UM NOME FOI ALTERADO
GO
CREATE OR ALTER TRIGGER trg_for_update_nome
ON DEPARTAMENTO
FOR UPDATE -- FOR = AFTER
AS
BEGIN
		DECLARE @nome_antigo VARCHAR (40),
				@nome_novo VARCHAR(40);

		SELECT @nome_antigo = D.Dnome
		FROM DELETED AS D -- PEGA AS INFORMACOES DO NOME ANTIGO

		SELECT @nome_novo = I.Dnome
		FROM INSERTED AS I; -- PEGA AS INFORMACOES DO NOVO NOME

		IF UPDATE (Dnome) -- consegue verificar se foi alterado um campo especifico na tabela
			BEGIN
				PRINT 'O nome era: ' + @nome_antigo;
				PRINT 'O novo nome é: ' + @nome_novo;
			END
		ELSE
			BEGIN
				PRINT 'O nome não foi alterado';
			END
END;

UPDATE DEPARTAMENTO
SET Dnome = 'Tecnologia'
WHERE Dnome = 'TI';

UPDATE DEPARTAMENTO
SET Dnumero = '9'
WHERE Dnome = 'Estoque';

SELECT * FROM DEPARTAMENTO;
GO

--- LOG
CREATE TABLE LOG_FUNCIONARIO(
	log_id INT IDENTITY (100,1) PRIMARY KEY,
	cpf CHAR(11),
	operacao VARCHAR(10),
	data_hora DATETIME DEFAULT GETDATE()
);
	-- TRIGGER de log de insert
GO
CREATE OR ALTER TRIGGER trg_for_insert_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
		INSERT INTO LOG_FUNCIONARIO (cpf,operacao)
		SELECT I.Cpf,'INSERT'
		FROM INSERTED AS I;
END;
GO

-- TRIGGER de log de update
GO
CREATE OR ALTER TRIGGER trg_for_update_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
		INSERT INTO LOG_FUNCIONARIO (cpf,operacao)
		SELECT I.Cpf,'UPDATE'
		FROM INSERTED AS I;
END;
GO
-- TRIGGER de log de delete
go
CREATE OR ALTER TRIGGER trg_for_delete_funcionario
ON FUNCIONARIO
FOR INSERT
AS
BEGIN
		INSERT INTO LOG_FUNCIONARIO (cpf,operacao)
		SELECT D.Cpf,'DELETE'
		FROM DELETED AS D;
END;
GO

INSERT INTO FUNCIONARIO(Pnome,Unome,Cpf,Datanasc,Endereco,Sexo,Salario,Bonus,Data_Admissao,Dnr)
VALUES('Juca','da Silva','4454454','2005-06-08','Rua Sete','M',1100,0,'2026-10-23',9);

SELECT * 
FROM FUNCIONARIO 
WHERE Pnome = 'Juca';

UPDATE FUNCIONARIO 
SET Salario = 100
WHERE Cpf = '4454454';

DELETE FROM FUNCIONARIO 
WHERE Cpf = '4454454';

SELECT * FROM LOG_FUNCIONARIO;

-- TRIGGER DE LOG insert, update,delete
GO
CREATE OR ALTER TRIGGER trg_for_insert_update_delete_funcionario
ON FUNCIONARIO
FOR INSERT,UPDATE,DELETE
AS
BEGIN
		-- SE FOR INSERT
		
		IF EXISTS (SELECT * FROM INSERTED)
		BEGIN
			IF EXISTS (SELECT * FROM DELETED)
			BEGIN
				INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
				SELECT I.Cpf, 'UPDATE'
				FROM INSERTED AS I;
			END
			ELSE
			BEGIN
				INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
				SELECT I.Cpf, 'INSERT'
				FROM INSERTED AS I;
			END
		END
		ELSE
		BEGIN
			INSERT INTO LOG_FUNCIONARIO (cpf, operacao)
			SELECT D.Cpf, 'DELETE'
			FROM DELETED AS D;
		END
END;
GO
```
---
### Exibição - View Subconsulta - Subqueries TE - Common Table Expression
Fica em `EXIBIÇÕES`
```sql
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
```
