/*1. Crie uma procedure que receba o nome de uma categoria e retorne:

Nome da categoria;
Quantidade de livros dessa categoria;
Ano mais antigo de publicação;
Ano mais recente de publicação;
Título dos livros pertencentes à categoria.*/
GO
CREATE OR ALTER PROCEDURE sp_retornar_dados(@nome_categoria AS VARCHAR(50))
AS
BEGIN
			SELECT
				C.tipo_categoria AS Categoria,
				COUNT(L.isbn) AS QuantidadeLivros,
				MIN(L.ano) AS AnoMaisAntigo,
				MAX(L.ano) AS AnoMaisRecente,
				L.titulo AS Titulo
				FROM LIVRO AS L
				JOIN CATEGORIA AS C ON C.id = L.fk_categoria
				WHERE C.tipo_categoria = @nome_categoria
				GROUP BY C.tipo_categoria, L.titulo;	
END



EXEC sp_retornar_dados @nome_categoria = 'Literatura Juvenil';
GO
----

--20. Implemente uma procedure para listar livros que não têm uma editora especificada.
GO
CREATE OR ALTER PROCEDURE sp_listar_livros_nao_especificos 
AS 
BEGIN
IF EXISTS (
		
		SELECT 1
		FROM LIVRO AS L
		JOIN EDITORA AS E ON L.fk_editora = E.id
		WHERE L.fk_editora IS NOT NULL)
	BEGIN
		PRINT 'Todos os livros possui editora especificada. '
	END
ELSE
	SELECT L.titulo
	FROM LIVRO AS L;



END

EXEC sp_listar_livros_nao_especificos;
GO
---

/*
14. Implemente uma procedure para listar autores juntamente 
com os títulos dos livros que eles escreveram.
*/
GO
CREATE OR ALTER PROCEDURE sp_listar_autores_livros
AS
BEGIN 
		SELECT 
				A.nome AS 'Nome do Autor',
				A.nacionalidade as 'Nacionalidade',
				L.titulo AS 'Título'
		FROM LIVROAUTOR AS L_AUTOR
		JOIN AUTOR AS A ON L_AUTOR.fk_autor = A.id
		JOIN LIVRO AS L ON L_AUTOR.fk_livro = L.isbn;


END

EXEC sp_listar_autores_livros;

GO
--- 
/*
15. Crie uma procedure para calcular o ano médio de publicação de livros em uma
categoria específica.
*/
GO
CREATE OR ALTER PROCEDURE sp_media_livro(@categoria VARCHAR(50))
AS
BEGIN 
	 SELECT AVG(L.ano) AS 'Média do ano de publicação'
	 FROM LIVRO AS L
	 JOIN CATEGORIA AS C ON C.id = L.fk_categoria
	 WHERE C.tipo_categoria = @categoria;
END

EXEC sp_media_livro @categoria = 'Literatura Juvenil';

GO


SELECT *
FROM LIVROaUTOR;
SELECT *
FROM EDITORA;
SELECT *
FROM CATEGORIA;



