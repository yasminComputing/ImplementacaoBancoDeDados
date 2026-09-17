--Exercícios Stored Procedure

/* 
	5. Crie uma procedure que receba o nome de uma categoria e retorne todos os livros
	dentro dessa categoria.
*/

GO
CREATE OR ALTER PROCEDURE sp_retorna_livros (@categoria VARCHAR(40))
AS 
BEGIN
		SELECT L.*
		FROM LIVRO AS L
		JOIN CATEGORIA AS C ON L.fk_categoria = C.id
		WHERE C.tipo_categoria= @categoria;

END
GO

EXEC dbo.sp_retorna_livros @categoria = 'Literatura Juvenil';
EXEC dbo.sp_retorna_livros @categoria = 'Humor';

----
/*
	6. Desenvolva uma procedure que receba o nome de um autor e retorne todos os livros
	escritos por esse autor.
*/
GO
CREATE OR ALTER PROCEDURE sp_retorna_livros_autor (@autor VARCHAR(100))
AS
BEGIN
    SELECT L.*
    FROM LIVRO AS L
    JOIN LIVROAUTOR AS L_A ON L.isbn = L_A.fk_livro
    JOIN AUTOR AS A ON L_A.fk_autor = A.id
    WHERE A.nome = @autor;
END
GO

EXEC dbo.sp_retorna_livros_autor @autor = 'Affonso Solano';

-----
/*
	8. Implemente uma procedure para listar os livros publicados por uma editora
	específica
*/
GO
CREATE OR ALTER PROCEDURE sp_listar_livros_editora (@editora VARCHAR(50))
AS
BEGIN
		SELECT *
		FROM LIVRO AS L
		JOIN EDITORA AS E ON L.fk_editora = E.id
		WHERE E.nome = @editora;
END
GO
EXEC dbo.sp_listar_livros_editora @editora = 'Belas Letras';
EXEC dbo.sp_listar_livros_editora @editora = 'Casa da Palavra';

----

-- 10. Crie uma procedure para contar o número de livros em cada categoria.
GO
CREATE OR ALTER PROCEDURE sp_contar_livros_categoria
AS
BEGIN
    SELECT C.tipo_categoria AS 'Categoria',
           COUNT(L.isbn) AS 'Quantidade'
    FROM CATEGORIA AS C
    LEFT JOIN LIVRO AS L ON C.id = L.fk_categoria
    GROUP BY C.tipo_categoria;
END
GO

EXEC dbo.sp_contar_livros_categoria;

---
/*
	14. Implemente uma procedure para listar autores juntamente com os títulos dos livros
	que eles escreveram.
*/
GO
CREATE	OR ALTER PROCEDURE sp_listar_autores_titulos
AS 
BEGIN
		SELECT 
				A.nome as 'Nome do Autor',
				L.titulo as 'Livro',
				A.nacionalidade
		FROM AUTOR AS A
		JOIN LIVROAUTOR AS L_A ON A.id = L_A.fk_autor
		JOIN LIVRO AS L ON L_A.fk_livro = L.isbn;
END
GO
EXEC dbo.sp_listar_autores_titulos;