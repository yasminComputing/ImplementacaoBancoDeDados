GO
-- Questão : 7
SELECT 
		A.Nome AS 'Nome do Aluno',
		H.Nota,
		T.Semestre,
		T.Ano AS 'Ano da Turma'
FROM DISCIPLINA AS D 
JOIN TURMA AS T ON D.Numero_disciplina = T.Numero_disciplina
JOIN HISTORICO_ESCOLAR AS H ON T.Identificacao_turma = H.Identificacao_turma
JOIN ALUNO AS A ON H.Numero_aluno = A.Numero_aluno
WHERE D.Nome_disciplina  = 'Banco de Dados I' 
ORDER BY A.Nome ASC;
GO
-----
GO
-- Questão: 8 
SELECT
		A.Nome,
		D.Nome_disciplina,
		D.Numero_disciplina,
		T.Semestre,
		T.Ano,
		H.Nota,
		H.Frequencia
FROM ALUNO AS A
JOIN HISTORICO_ESCOLAR AS H ON A.Numero_aluno = H.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma
JOIN DISCIPLINA AS D ON T.Numero_disciplina = D.Numero_disciplina
WHERE H.Frequencia < 75.0
ORDER BY H.Frequencia ASC;

GO
----
GO
-- Questão: 9 
SELECT 
			T.Identificacao_turma,
			COUNT(H.Numero_aluno) AS 'Qtde de alunos Matriculados',
			D.Nome_disciplina,
			T.Semestre,
			T.Ano,
			SUM(H.Numero_aluno) AS 'Total de Alunos'
FROM TURMA AS T
JOIN HISTORICO_ESCOLAR AS H ON T.Identificacao_turma= H.Identificacao_turma
JOIN DISCIPLINA AS D ON T.Numero_disciplina = D.Numero_disciplina
GROUP BY T.Identificacao_turma,D.Nome_disciplina,t.Semestre,T.Ano
GO
----
GO
-- Questão: 10
CREATE OR ALTER FUNCTION fn_SituacaoAluno (@nota DECIMAL(4,2),@frequencia DECIMAL (5,2))
RETURNS VARCHAR(200)
AS 
BEGIN
		DECLARE @situacao VARCHAR(200);
		
		SELECT @nota = H.Nota, @frequencia = H.Frequencia
		FROM HISTORICO_ESCOLAR AS H;
		
	IF ((@nota >= 7) AND (@frequencia >= 75.0))
		BEGIN
			SET @situacao = 'Aprovado'
		END
	

	ELSE IF ((@frequencia < 75.0) and (@nota >= 7))
		BEGIN
			SET @situacao = 'Reprovado por frequência'
		END

	ELSE IF(@nota IS  NULL OR @frequencia IS NULL)
		BEGIN
			SET @situacao = 'Em Andamento'
		END

	ELSE IF (@frequencia >= 75.0 AND (@nota BETWEEN 5 AND 6.99))
		BEGIN
			SET @situacao = 'Em Recuperação'
		END

	ELSE IF ((@frequencia >= 75.0) AND (@nota < 5))
		BEGIN
			SET @situacao = 'Reprovado por nota'
		END

	RETURN @situacao;
END;
GO
GO
SELECT 
		A.Nome,
		T.Numero_disciplina,
		H.Nota,
		H.Frequencia,
		dbo.fn_SituacaoAluno(H.Nota,H.Frequencia) AS 'Situação'
FROM HISTORICO_ESCOLAR AS H
JOIN ALUNO AS A ON A.Numero_aluno = A.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma
GO

----
GO
-- QUESTÃO: 11
CREATE OR ALTER FUNCTION fn_ConverterNotaConceito(@nota DECIMAL(4,2))
RETURNS VARCHAR(50)
BEGIN
		DECLARE @conceito AS VARCHAR(50),@numero DECIMAL(4,2);
		SET @numero = @nota;
		
		IF(@nota BETWEEN 9.0 AND 10.0)
		BEGIN
		SET @conceito = 'A'
		END
		ELSE IF (@nota BETWEEN 7.0 AND 8.99)
		BEGIN
		SET @conceito = 'B'
		END
		ELSE IF (@nota BETWEEN 5 AND 6.99)
		BEGIN
		SET @conceito = 'C'
		END
		ELSE IF (@nota < 5)
		BEGIN
			SET @conceito = 'D'
		END
		ELSE IF (@nota = null)
		BEGIN
			set @conceito = 'Sem Nota'
		END
	RETURN @conceito;
END;

GO
SELECT dbo.fn_ConverterNotaConceito(5.89) as 'Conceito da Nota';
-----
GO
-- QUESTÃO: 12
CREATE OR ALTER PROCEDURE usp_ListarAlunosPorCurso(@sigla VARCHAR(10))
AS
BEGIN
	 SELECT A.Numero_aluno, A.Nome
	 FROM ALUNO AS A
	 WHERE a.Curso = @sigla 
	 ORDER BY A.Nome ASC

END
EXEC dbo.usp_ListarAlunosPorCurso @sigla = 'CC';
GO
 ----
 GO
 -- Questão: 13
 CREATE OR ALTER PROCEDURE usp_CadastrarDisciplina (@codigo VARCHAR(10),@nome VARCHAR(100),@credito INT,@departamento VARCHAR(10))
 AS
 BEGIN
		DECLARE @cod VARCHAR(10),@nome_d VARCHAR(100), @credito_d INT,@departamento_d VARCHAR(10);
		SET @cod = @codigo;
		SET @nome_d = @nome;
		SET @credito_d = @credito;
		SET @departamento_d = @departamento;
		
		IF EXISTS (
				SELECT 1
				FROM DISCIPLINA AS D
				WHERE D.Numero_disciplina = @cod
		)
		BEGIN
			PRINT 'Este departamento já existe'
		END
		if EXISTS (
				SELECT 1
				FROM DISCIPLINA AS D
				WHERE D.Nome_disciplina = @nome
		)
		BEGIN
			
			PRINT 'Não é possível cadastrar o departemento já existente: ' + @nome
		END
		ELSE IF (@credito <= 0)
		BEGIN
			PRINT 'Não é possível cadastrar créditos menor que zero ou igual'
		END
		ELSE 
			BEGIN
				INSERT INTO DISCIPLINA(Numero_disciplina,Nome_disciplina,Creditos,Departamento)
				VALUES (@codigo, @nome,@credito,@departamento)
				PRINT 'Cadastro realizado com sucesso'
		    END

 END;
 EXEC dbo.usp_CadastrarDisciplina @codigo = 'HH01', @nome = 'História',@credito = 1,@departamento = 'H';
 SELECT *
 FROM DISCIPLINA;
 GO