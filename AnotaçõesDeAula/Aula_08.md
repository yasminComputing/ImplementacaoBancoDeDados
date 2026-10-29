## Aula 08 - Dia 18.09.2026
Nesta aula será realizado a revisão para avaliação I e também um assunto novo que não irá cair na avaliação. 

---
## Exercício utilizando PROCEDURE
```sql
/*
Crie um procedure que insira um novo funcionário mas antes verifique se já não existe um funcionário com o mesmo nome (nome completo)
*/
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
```
---
## Parâmetro com valor padrão
```sql
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
```
---
## Parâmetros de Saída
Os parâmetros de saída habilitam um procedimento armazenado a retornar dados ao procedimento chamado.Usamos a palavra-chave `OUTPUT` quando o procedimento é criado,também quando é chamado.No procedimento armazenado, o procedimento de saída aparece como uma variável local.

```sql
GO
CREATE OR ALTER PROCEDURE sp_duplica (@valor AS INT OUTPUT)
AS
SELECT @valor * 2
RETURN
GO

DECLARE @numero AS INT = 15;
EXEC sp_duplica @numero OUTPUT; 
PRINT @numero;
```
---
```sql
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
```
---
```text
Como vai ser avaliação: 
    - 4 de marcar conceitual(para que usa..o que faz..),
    - 2 de provovalemente para montar consultar junção (1 facil,1 intermediaria, 1 dificil)
    - Exemplo: me liste uma lista de livros que não possui nenhuma categoria atrelada..
    - historic prodecure - crie um procedure que verifica se existe um livro com este titulo se tem nao inserida na tabela 
    - classificar por exemplo editoras pode usar o then que classifica se a editora tem 2 livros é pequena, media,.... utilizar por group  by
    - dica: fracionar os problemas, resolver por maneiras separadas.
    - cuidar na hora de criar o banco verificar se está dentro do banco no sql
```
- Recomendação de jogo para ajudar na lógica:([JOGO](https://store.steampowered.com/app/375820/Human_Resource_Machine/))
