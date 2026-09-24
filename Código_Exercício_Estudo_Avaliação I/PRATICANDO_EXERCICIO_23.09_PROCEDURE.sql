-- 18. Crie uma procedure para listar livros que têm mais de um autor.
GO
CREATE OR ALTER PROCEDURE sp_listar_livros_mais_autor
AS
BEGIN
    SELECT L.isbn,L.titulo 
    FROM LIVRO AS L
    JOIN LIVROAUTOR AS LA ON L.isbn = LA.fk_livro
    GROUP BY L.isbn, L.titulo
    HAVING COUNT(LA.fk_autor) > 1;
	
END;
EXEC sp_listar_livros_mais_autor;
GO


-- 

/*17. Implemente uma procedure para remover um autor da lista de 
autores de um livro.*/
GO
CREATE OR ALTER PROCEDURE sp_remover(@autor AS VARCHAR(100),@isbn VARCHAR(50))
AS
BEGIN
        DELETE from LivroAutor
        FROM AUTOR AS A
        JOIN LIVROAUTOR AS LA ON A.id = LA.fk_autor
        WHERE A.nome = @autor AND LA.fk_livro = @isbn;


END
EXEC sp_remover @autor = 'Clive Staples Lewis',@isbn = '9780000000001';
GO

SELECT *
FROM LIVROAUTOR;
SELECT *
FROM LIVRO;
SELECT *
FROM AUTOR;