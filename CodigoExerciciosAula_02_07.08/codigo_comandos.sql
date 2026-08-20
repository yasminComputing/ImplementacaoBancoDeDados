-- 4. CRIAÇÃO DO BANCO DE DADOS 
CREATE DATABASE biblioteca;

USE biblioteca;
-- 5. CRIAÇÃO DA TABELAS
CREATE TABLE autor(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    nacionalidade VARCHAR (100) NOT NULL
);

CREATE TABLE editora(
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE categoria(
	codigo INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE livro(
	ISBN CHAR(13)PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL UNIQUE,
    ano INT NOT NULL,
    fk_id_autor INT,
    fk_id_editora INT,
    fk_codigo_categoria INT,
    FOREIGN KEY(fk_id_autor) REFERENCES autor(id),
	FOREIGN KEY(fk_id_editora) REFERENCES editora(id),
	FOREIGN KEY(fk_codigo_categoria) REFERENCES categoria(codigo)
);

-- 6. COMANDO SQL PARA INSERÇÃO DOS DADOS DAS TABELAS. 

INSERT INTO autor(nome,nacionalidade)
VALUES 
    ("J.K. Rowling","Inglaterra"),
    ("Clive Staples Lewis","Inglaterra"),
    ("Affonso Solano","Brasil"),
    ("Marcos Piangers","Brasil"),
    ("Ciro Botelho - Tiririca","Brasil"),
    ("Bianca Mól","Brasil");

INSERT INTO editora(nome)
VALUES
	("Rocco"),
    ("Wmf Martins Fontes"),
    ("Casa da Palavra"),
    ("Belas Letras"),
    ("Matrix");
    
INSERT INTO categoria(descricao)
VALUES
		("Literatura Juvenil"),
        ("Ficção Científica"),
        ("Humor");

INSERT INTO livro(ISBN,titulo,ano,fk_id_autor,fk_id_editora,fk_codigo_categoria)
VALUES
    ("8532511015","Harry Potter e A Pedra Filosofal",2000,1,1,1),
    ("9788578270698","As Crônicas de Nárnia",2009,2,2,1),
    ("9788577343348","O Espadachim de Carvão",2013,3,3,2),
    ("9788581742458","O Papai é Pop",2015,4,4,3),
    ("9788582302026","Pior Que Tá Não Fica",2015,5,5,3),
    ("9788577345670","Garota Desdobrável",2015,6,3,1),
    ("8532512062","Harry Potter e o prisioneiro de Azkaban",2000,1,1,1);
    
    
-- 7. CRIAR UMA CONSULTA DE TODOS OS DADOS EM ORDEM ALFABÉTICA DE TITULO
SELECT *
FROM livro as l
ORDER BY l.titulo ASC;

-- 8.Todos os dados dos livros em ordem alfabética de autor
SELECT a.nome as "Autor", l.titulo as "Título", l.ano as "Ano de lançamento", l.ISBN as "ISBN"
FROM livro as l
JOIN autor as a on l.fk_id_autor = a.id
ORDER BY a.nome ASC;

-- 9.Livros da categoria "Literatura Juvenil" em ordem de ano
SELECT l.titulo as "Título", l.ano as "Ano de Lançamento"
FROM livro as l
JOIN categoria as c on l.fk_codigo_categoria = c.codigo
WHERE c.descricao = "Literatura Juvenil"
ORDER BY l.ano ASC;


-- 10.Livros de Humor OU Ficção Científica, entre 2000 e 2010
SELECT l.titulo as "Título", c.descricao as "Categoria", l.ano as "Ano de Lançamento"
FROM livro as l
JOIN categoria as c on l.fk_codigo_categoria = c.codigo
WHERE c.descricao IN ("Humor","Ficção Científica") AND l.ano BETWEEN 2000 AND 2010;
