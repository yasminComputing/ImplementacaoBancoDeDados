/*12. Crie um trigger que limite o número de livros em uma categoria específica na tabela
Categoria para um máximo de 100 livros e não permita mais inserções além desse
limite.*/
GO
CREATE OR ALTER TRIGGER trg_after_limite
ON LIVRO
AFTER INSERT
AS
BEGIN
    DECLARE @quantidade INT,
            @categoria INT;


    SELECT @categoria = I.fk_categoria
    FROM INSERTED AS I;

    SELECT @quantidade = COUNT(*)
    FROM LIVRO
    WHERE fk_categoria = @categoria;


    IF @quantidade > 100
    BEGIN
        ROLLBACK TRANSACTION;

        RAISERROR('Não é permitido cadastrar mais de 100 livros na mesma categoria.',16,1);
    END
END;
GO

---

/*13. Crie um trigger que atualize automaticamente o campo nacionalidade na tabela
Autor para 'Desconhecida' sempre que um autor for excluído da tabela Autor*/
GO
CREATE OR ALTER TRIGGER trg_instead_atualizar
ON AUTOR
INSTEAD OF DELETE
AS
BEGIN
        
        IF EXISTS(SELECT * FROM DELETED)
          BEGIN
            UPDATE AUTOR
            SET nacionalidade = 'Desconhecida'
            WHERE id IN (SELECT id FROM DELETED);
            SELECT * 
            FROM AUTOR;
           END
        ELSE
            PRINT 'Nenhum autor foi excluído';
END;
GO
-- ADICIONANDO AUTOR P/TESTE DO TRIGGER
INSERT INTO AUTOR VALUES('João','Chile');

DELETE FROM AUTOR
WHERE id = 7;

----

/*14. Crie um trigger que registre automaticamente todas as exclusões de livros na tabela
LogExclusaoLivros com detalhes sobre o livro excluído, data e hora.*/

CREATE TABLE LOG_LIVROS(
    log_id INT IDENTITY (100,1) PRIMARY KEY,
    isbn VARCHAR(50),
    titulo VARCHAR(100),
    data_hora DATETIME DEFAULT GETDATE()
);
GO
CREATE OR ALTER TRIGGER trg_after_registro_exclusao
ON LIVRO
AFTER DELETE
AS 
BEGIN
        IF EXISTS (SELECT * FROM DELETED)
          BEGIN
                INSERT INTO LOG_LIVROS(isbn,titulo)
                SELECT D.isbn,D.titulo
                FROM DELETED AS D;

                SELECT * FROM LOG_LIVROS;
          END
        ELSE
            PRINT 'Nenhum livro foi excluído';
END;
GO

INSERT INTO LIVRO (isbn, titulo, ano, fk_editora, fk_categoria)
VALUES ('9999912121', 'Livro de Teste do Trigger', 2026, 1, 1);

DELETE FROM LIVRO
WHERE isbn = '9999912121';

/*15. Crie um trigger que, quando um livro for atualizado na tabela Livro, verifique se o
novo título contém a palavra "proibido" e, se sim, reverta o título anterior.*/
GO
CREATE OR ALTER TRIGGER trg_after_atualizar_titulo
ON LIVRO
AFTER UPDATE
AS
BEGIN
    IF UPDATE (titulo)
        BEGIN
            IF EXISTS(SELECT 1 FROM INSERTED WHERE titulo LIKE '%proibido%')
                BEGIN
                RAISERROR('Não é permitido inserção de titulo com a palavra proibido',16,1);
                ROLLBACK TRANSACTION;
                RETURN;
                END
        END
  
END;
GO
INSERT INTO LIVRO (isbn, titulo, ano, fk_editora, fk_categoria)
VALUES ('91111111', 'O briquedo', 2026, 2, 1);
UPDATE  LIVRO
SET titulo = 'O brinquedo proibido'
WHERE isbn = '91111111';

select * from livro;
----

/*8. Crie um trigger que restrinja a atualização do ISBN na tabela Livro para impedir que
ele seja alterado.*/
GO
CREATE OR ALTER TRIGGER trg_restricao_after_atualizacao_isbn
ON LIVRO
AFTER UPDATE 
AS
BEGIN
    IF UPDATE (isbn)
        BEGIN
            IF EXISTS (SELECT isbn FROM INSERTED)
                BEGIN
                    RAISERROR('Não é permitido alterar o ISBN do livro',16,1);
                    ROLLBACK TRANSACTION;
                    RETURN;
                END
        END

END
GO
UPDATE LIVRO
SET isbn = '000000'
WHERE isbn = '91111111';

----

/*18. Crie um trigger que registre automaticamente todas as atualizações de livros na
tabela LogAtualizacaoLivros com detalhes sobre o livro atualizado, data e hora.*/
CREATE TABLE LOG_ATUALIZACAO_LIVROS(
    log_id INT IDENTITY (50,1) PRIMARY KEY,
    isbn VARCHAR(50),
    titulo VARCHAR(100),
    data_hora DATETIME DEFAULT GETDATE()
);
GO
CREATE OR ALTER TRIGGER trg_registro_after_atualizacao_livros
ON LIVRO
AFTER UPDATE
AS
BEGIN
    INSERT INTO LOG_ATUALIZACAO_LIVROS (isbn,titulo,data_hora)
    SELECT I.isbn,I.titulo,GETDATE()
    FROM INSERTED AS I;

END
GO
UPDATE LIVRO
SET ano = '2026'
WHERE isbn = '9788581742458'

SELECT * FROM LOG_ATUALIZACAO_LIVROS;