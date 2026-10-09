## Aula 11 - Dia 09.10.2026

### Transações
A transações podem incluir **inserções,atualizações,exclusões ou consultar**. Essa operação deve ser completamente **concluída ou completamente revertida** para garantia que o bd permaneça em um estado consistente.
O principal objetivo é garantir a integridade e consistência de dados, mesmo diante de falhas.
Exemplo: se tiver cinco INSERT todos devem ser corretamente funcionando para funcionamento da transação.Todo SBGD tem que obdecer o `ACID`:

- `A`tomicidade: não divivel
- `C`onsistência: estado válido - válido
- `I`solamento: 1 por vez
- `D`urabilidade: fazer os dados persistir/persistência

**Comando utilizado: TRANSACTION**  é utilizado para uma sequência de operações (transações) no banco.

**Para que serve uma transação?**
- Garantir integridade e consistência dos dados:
- Reverter alterações em caso de erro:
- Controlar múltiplas operações simultâneas

---

### Atomicidade
Garante que uma transação é tratada como uma única unidade, ou seja, não é divivel, que significa que ela deve ser completamente concluída ou totalmente desfeita.

---

### Consistência
Garante que o banco de dados de um **estado válido para outro estado válido**, respeitando todas as regras definidas.

---

### Isolamento
Transações sejam executadas de forma isolada, sem que as operações de uma transação afetem as operações de outra.**Trata um requisição por vez.**

---

### Durabilidade
Deve garantir que uma vez que uma transação é **confirmada(committed)**, ela fique no bando de dados mesmo que ocorra uma falha no sistema.

---

### Comandos
```sql
-- INICIA UMA NOVA TRANSAÇÃO
BEGIN TRANSACTION

-- CONFIRMA A TRANSAÇÃO APLICANDO PERMANENTEMENTE TODAS AS OPERACOES FEITOS NO BD
COMMIT TRANSACTION

-- DESFAZ TODAS AS OPERACOES REALIZADAS DESDE O INICIO DA TRANSAÇÃO
ROLLBACK TRANSACTION

--- DEFINE UM PONTO DENTRO DE UMA TRANSAÇÃO PARA PERMITER UM ROLLBACK PARCIAL 
SAVEPOINT 
```
--- 
### @@ERROR, ROLLBACK, COMMIT 
```sql
-- PRIMEIRA TRANSAÇÃO: testando o ERROR adicionado o mesmo id já existente no banco de dados
GO
BEGIN TRAN;
	-- Caso no print dá zero significa que deu certo e se for diferente de 0 deu erro.
	DECLARE @erro INT = 0;
	INSERT INTO conta VALUES
				(50,'Pedro',50);
	SET @erro += @@ERROR
	INSERT INTO conta VALUES
				(10,'Judas',666); -- como o judas tem o mesmo id existente no banco de dados essa transação toda vai ser revertida, pois o mesmo id não pode existir no banco
	SET @erro += @@ERROR;
	SELECT * FROM CONTA;

	IF @erro <> 0
	 BEGIN
		PRINT 'Transação revertida!';
		ROLLBACK TRAN;
	 END
	ELSE
	 BEGIN
		PRINT 'Transação realizada com sucesso!';
		COMMIT TRAN;
	 END
SELECT * FROM CONTA;
 GO
---

-- USAR O ROLLBACK PARA VER COMO FICA O BANCO ANTES DE FAZER DENTRO DO BANCO MESMO
-- quando quer dar update e não tiver o identificador utilizar  TRANSACTION
GO
BEGIN TRAN;
	UPDATE conta
	SET Saldo += 10000
	WHERE Nome = 'Maria';
	IF @@ROWCOUNT <> 1 -- CASO FOR AFETADO MAIS DE UMA LINHA REVERTE ALTERAÇÕES, COMO TEM DUAS MARIAS SERÁ REVERTIDO
	 BEGIN
		SELECT * FROM conta -- MOSTRA COMO FICARIA O RESULTADO COM O SALDO += 10000
		ROLLBACK TRAN; -- REVERTE ALTERAÇÃO
		SELECT * FROM conta 
	 END
	ELSE
		COMMIT TRAN;
GO
----
--- TRANSFERIR DINHEIRO DE UMA PESSOA PARA OUTRA
GO	
CREATE OR ALTER PROCEDURE sp_transferir(@id_recebe INT,@id_envia INT ,@valor_deposito MONEY)
AS 
BEGIN
		BEGIN TRAN; -- começa a transação
		--tirando dinheiro da conta de origem

		UPDATE CONTA
		SET Saldo = Saldo - @valor_deposito
		WHERE id = @id_envia;

		--depositar dinheiro conta destino
		UPDATE conta
		SET Saldo = Saldo + @valor_deposito
		WHERE id = @id_recebe;
		SELECT * FROM CONTA;
		-- condição de rollback o select que pega o saldo da conta de origem/envia
		IF ( SELECT Saldo FROM conta WHERE id = @id_envia ) < 0
		 BEGIN
			ROLLBACK TRAN;
			PRINT 'Saldo Insuficiente';
			SELECT * FROM CONTA;
		 END
		ELSE
		 BEGIN
			COMMIT TRAN;
			PRINT 'Transferência realizada com sucesso!';
		 END


	END
GO

EXEC dbo.sp_transferir @id_recebe = 10, @id_envia = 40, @valor_deposito = 500;
EXEC dbo.sp_transferir @id_recebe = 20, @id_envia = 10, @valor_deposito = 2000;
SELECT * FROM CONTA;
drop database caixa;
```
---
## Save Point e Try-Catch()
```sql
-- SAVEPOINT
BEGIN TRAN;
INSERT INTO conta
VALUES (50,'Pedro',50);

-- SAVE POINT
GO
SAVE TRAN pedroOK;
INSERT INTO conta
VALUES (10,'Juca',-200);
-- O COMANDO @@ERROR SOMENTE PODE SER UTILIZADO PARA INSERT INTO E O ULTIMO CODIGO QUE ESTÁ EM CIMA DELE
IF @@ERROR <> 0
 BEGIN
		ROLLBACK TRAN pedroOk;
		COMMIT TRAN;
		PRINT 'Voltamos para o SAVE POINT';
 END
 ELSE
		COMMIT TRAN;

SELECT * FROM CONTA;
GO
----
-- TRY CATCH
BEGIN TRY
		PRINT 'Olá TRY-CATCH!';-- CONSEGUIU
		SELECT 1/0; -- erro VAI PARA DEU ERRO
		PRINT 'NÃO CHEGUEI AQUI!'; -- nao aparece
END TRY
BEGIN CATCH
		PRINT 'DEU ERRO!';
		PRINT 'Número do ERRO: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
END CATCH
-- TRANSACTION + TRY CATCH
BEGIN TRAN;
	BEGIN TRY
		INSERT INTO conta
		VALUES (60,'Mateus',15);

		SELECT * FROM CONTA;

		INSERT INTO conta
		VALUES (10,'Juca',-200);

		COMMIT TRAN;

		SELECT * FROM CONTA;

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN;
		PRINT 'ERRO!';
		PRINT 'Número do ERRO: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
	END CATCH
SELECT * FROM conta;
```
---

```sql
-- CRIAR UM PROCEDURA PARA INSERIR UM NOVO USUARIO NO BANCO (não permita duplicidade de nomes)
DELETE conta
WHERE id = 40; -- excluindo maria sem duplicidade

GO
CREATE OR ALTER PROCEDURE usp_inserirUsuario(@id INT,@nome VARCHAR(100),@saldo MONEY)
AS 
BEGIN 
		BEGIN TRAN;
			BEGIN TRY
					INSERT INTO conta VALUES (@id,@nome,@saldo);
					IF	(SELECT COUNT(*) FROM conta WHERE Nome = @nome) > 1
					BEGIN
							ROLLBACK TRAN;
							PRINT 'Já existe alguém com o nome: ' + @nome;
					END
					ELSE
						BEGIN
								COMMIT TRAN;
								PRINT 'Cadastro realizado com sucesso';
						END
			   END TRY
			   BEGIN CATCH
					ROLLBACK TRAN;
					PRINT 'ERRO!';
					PRINT 'Número do ERRO: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
					PRINT 'Mensagem de ERRO: ' + ERROR_MESSAGE();
			  END CATCH

END
GO

SELECT * FROM CONTA;

EXEC dbo.usp_inserirUsuario @id = 100,@nome = 'Pedro',@saldo = 600;

EXEC dbo.usp_inserirUsuario @id = 90,@nome = 'Tiago',@saldo = 600;
```