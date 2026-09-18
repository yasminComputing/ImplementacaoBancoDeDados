GO
CREATE OR ALTER PROCEDURE sp_nome_procedimento (@pnome VARCHAR (15),@minicial AS CHAR(1),@unome AS VARCHAR(15),@cpf AS CHAR(11))
AS 
BEGIN
		DECLARE @nome_completo VARCHAR(50);
		SET @nome_completo = CONCAT(@pnome,' ',@minicial,' ',@unome)
		

	IF EXISTS(
		SELECT 1
		FROM FUNCIONARIO AS F
		WHERE @nome_completo = CONCAT(F.Pnome,' ',F.Minicial,' ',F.Unome)
	)
	BEGIN
		PRINT 'Este nome já existe no banco ' + @nome_completo;
	END

 ELSE
 BEGIN
	INSERT INTO FUNCIONARIO (pnome,minicial,unome,cpf)
	VALUES (@pnome,@minicial,@unome,@cpf);
	PRINT 'Funcionário cadastrado';
	END

END
GO
EXEC sp_nome_procedimento @pnome = 'Renato',@minicial = 'P',@unome = 'Barros',@cpf= '00000000100';
EXEC sp_nome_procedimento @pnome = 'Carlos',@minicial = 'M',@unome = 'Ferreira',@cpf= '12312312311';
SELECT *
FROM FUNCIONARIO;

----
/*
	Passando como parametro valor, caso não for passado o valor no EXEC o  metódo vai pegar o pré - definido no
	CREATE
*/
GO
CREATE OR ALTER PROCEDURE sp_aumento(@cpf CHAR(11),@aumento DECIMAL (10,2) = 500)
AS 
BEGIN
		UPDATE FUNCIONARIO 
		SET Salario += @aumento
		WHERE Cpf = @cpf;
END
GO
EXEC sp_aumento @cpf = '98765432100',@aumento = 1000;
SELECT *
FROM FUNCIONARIO WHERE Cpf = '98765432100';
----
/*
	Parâmetros de saída
*/
GO
CREATE OR ALTER PROCEDURE sp_duplica (@valor AS INT OUTPUT)
AS
SELECT @valor * 2
RETURN
GO

DECLARE @numero AS INT = 15;
EXEC sp_duplica @numero OUTPUT; 
PRINT @numero;

---
/*
	Crie um procedure para calcular o salário total de todos os funcionários de
um determinado departamento e retorna o valor por meio de um
parâmetro de saída.
*/
GO
CREATE OR ALTER PROCEDURE sp_retorna_salario_dpto (@numero_dpto INT,@salario_total DECIMAL(10,2) OUTPUT)
AS 
BEGIN
	SELECT @salario_total = SUM(F.Salario)
	FROM FUNCIONARIO AS F
	WHERE F.Dnr = @numero_dpto
	IF(@salario_total IS NULL)
		SET @salario_total = 0
END

DECLARE @s_total DECIMAL(10,2);
EXEC sp_retorna_salario_dpto @numero_dpto = 4, @salario_total = @s_total OUTPUT;
PRINT'O Salário total é:  ' + CAST(@s_total AS VARCHAR(10));
GO
