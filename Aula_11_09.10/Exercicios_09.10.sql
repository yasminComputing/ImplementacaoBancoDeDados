--- EXERCICIOS:

/*
2. SAVEPOINT e ROLLBACK Parcial Tarefa: Dentro de uma única transação,
insira dois departamentos. Crie um SAVEPOINT após o primeiro insert e faça
ROLLBACK para o savepoint (mantendo o primeiro e desfazendo o segundo). 
Entregável: Evidencie que apenas o primeiro persiste após COMMIT.
*/
GO
CREATE OR ALTER PROCEDURE usp_inserirDpto
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
			INSERT  INTO DEPARTAMENTO (Dnome,Dnumero) VALUES ('Financeiro',15);
			
			SAVE TRANSACTION insercao_dados;
            PRINT 'Savepoint criado';
            SELECT * FROM DEPARTAMENTO;
            PRINT 'Departamento Financeiro inserido';

            INSERT INTO DEPARTAMENTO(Dnome,Dnumero) VALUES('Compras',30);
            
            SELECT * FROM DEPARTAMENTO;
            PRINT 'Departamento Compras inserido';

            ROLLBACK TRANSACTION insercao_dados;
            PRINT 'Rollback realizado: retornando ao savepoint insercao_dados.';
            PRINT 'Departamento Compras desfeito.';
            
            COMMIT TRANSACTION;
            PRINT 'COMMITT: Transacao confirmada';

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		PRINT 'Mensagem de Erro: ' + ERROR_MESSAGE();
	END CATCH
END
GO

EXEC dbo.usp_inserirDpto;

SELECT * 
FROM DEPARTAMENTO;

------
/*
4. SAVEPOINT antes de UPDATE em Massa Tarefa: 
Em uma transação, crie um SAVEPOINT e aplique um reajuste salarial (ex.: +2%) 
para um departamento. Avalie o impacto (média e quantidade). Caso o efeito não seja desejado, ROLLBACK 
para o savepoint; caso contrário, COMMIT. Entregável: Relatório curto do antes/depois e a decisão tomada.
*/
GO
CREATE OR ALTER PROCEDURE usp_reajuste (@nome_dpto VARCHAR(50),@porcentual DECIMAL (5,2),@escolha INT)
AS 
BEGIN 
    BEGIN TRANSACTION;
        BEGIN TRY
            SELECT COUNT (*) AS 'Quantidade de Funcionários', AVG(F.Salario) AS 'Média Salarial Sem Reajuste'
            FROM FUNCIONARIO AS F
            JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
            WHERE D.Dnome = @nome_dpto;

            SAVE TRANSACTION dados_antes_do_reajuste;
            PRINT 'Save Point criado';

            UPDATE F
            SET F.Salario = F.Salario * (1 + @porcentual / 100.0)
            FROM FUNCIONARIO AS F
            JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
            WHERE D.Dnome = @nome_dpto

            PRINT 'Reajuste Salarial';
            SELECT COUNT (*) AS 'Quantidade de Funcionários', AVG(F.Salario) AS 'Média Salarial Com Reajuste'
            FROM FUNCIONARIO AS F
            JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
            WHERE D.Dnome = @nome_dpto;

            IF @escolha = 1 -- realiza o reajuste quando for 1
                BEGIN 
                    COMMIT TRANSACTION;
                    PRINT 'Reajuste realizado';
                END
            ELSE
                BEGIN 
                    ROLLBACK TRANSACTION dados_antes_do_reajuste;
                    COMMIT TRANSACTION;
                    PRINT 'Reajuste desfeito.';
                END
        

        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT 'Mensagem de Erro: ' + ERROR_MESSAGE();

        END CATCH

END;
GO
EXEC usp_reajuste @nome_dpto ='Financeiro', @porcentual = 2, @escolha = 0;

SELECT F.Pnome, F.Salario
FROM FUNCIONARIO AS F
INNER JOIN DEPARTAMENTO AS D ON F.Dnr = D.Dnumero
WHERE D.Dnome = 'Financeiro';