/*
1: 
	1.1. Declaração de Variáveis
	Declare três variáveis no SQL Server: uma para armazenar o nome de um produto (tipo VARCHAR), 
	outra para armazenar a quantidade em estoque (tipo INT) e a última para armazenar o preço do produto (tipo DECIMAL(10,2)).


	1.2. Atribuição de Valores
	Atribua os seguintes valores às variáveis declaradas:

	Nome do Produto: "Notebook"
	Quantidade em Estoque: 15
	Preço do Produto: 2999.99
	1.3. Exibição de Valores
	Exiba os valores atribuídos às variáveis utilizando tanto o comando PRINT quanto o comando SELECT.*/

DECLARE @nome_produto VARCHAR(100),
		@qtde_estoque INT,
		@preco_produto DECIMAL(10,2);

SET @nome_produto = 'Notebook';
SET @qtde_estoque = 15;
SET @preco_produto =  2999.99;

PRINT 'Nome do Produto: ' + @nome_produto 
PRINT 'Quantidade em estoque: ' +CAST(@qtde_estoque AS VARCHAR(20))
PRINT 'Preço do Produto: R$ ' + CAST(@preco_produto AS VARCHAR(100));

SELECT @nome_produto AS 'Nome do Produto', @qtde_estoque AS 'Qtde Estoque', @preco_produto AS 'Preço';

----
/*
2:
	1.4. Cálculo utilizando Variáveis
	Declare três variáveis: @SalarioBase (tipo DECIMAL(10,2)), @Bonus (tipo DECIMAL(10,2)) e @SalarioTotal (tipo DECIMAL(10,2)). 
	Atribua valores de 5000.00 e 800.00 às variáveis @SalarioBase e @Bonus, respectivamente. 
	Em seguida, calcule o valor total do salário somando @SalarioBase e @Bonus e armazene o resultado em @SalarioTotal. Exiba o valor de @SalarioTotal.
*/

DECLARE @SalarioBase DECIMAL (10,2),
		@Bonus DECIMAL(10,2),
		@SalarioTotal DECIMAL(10,2);

 SET @SalarioBase = 5000.00;
 SET @Bonus = 800.00;

 SET @SalarioTotal = @SalarioBase + @Bonus;

 SELECT @SalarioBase AS 'Salário Base',@Bonus AS 'Bônus', @SalarioTotal AS 'Salário Total';

----
/*
3: 
	3.1. IF / ELSE Básico
	Crie uma variável chamada @Idade e atribua a ela um valor inteiro. Escreva um bloco IF / ELSE que exiba "Maior de Idade" 
	se a idade for maior ou igual a 18, e "Menor de Idade" caso contrário.
*/
DECLARE @Idade INT;
SET @Idade = 80;

IF(@Idade < 18)
	PRINT 'Menor de Idade';
ELSE
	PRINT 'Maior de Idade';

----
/*
4: 
	4.2. While com Condição Complexa
	Escreva um loop WHILE que comece com uma variável @Valor igual a 100 e a cada iteração subtraia 5 de @Valor. 
	O loop deve continuar até que @Valor seja menor que 50. Exiba o valor de @Valor a cada iteração.
*/
DECLARE @Valor INT = 100;

WHILE @Valor >= 50
	BEGIN
			PRINT @Valor;
			SET @Valor -= 5;
	END;

----
/*
5: 
	3.2. IF / ELSE com Múltiplas Condições
	Crie uma variável chamada @NotaFinal e atribua um valor entre 0 e 100. Utilize um bloco IF / ELSE para exibir as seguintes mensagens baseadas no valor da nota:

	Nota >= 90: "Aprovado com Excelência"
	Nota >= 70 e < 90: "Aprovado"
	Nota >= 50 e < 70: "Em Recuperação"
	Nota < 50: "Reprovado"
*/
DECLARE @NotaFinal INT = 85;

IF(@NotaFinal >= 90)
	PRINT 'Aprovado com excelência';
ELSE IF(@NotaFinal >= 70)
	PRINT 'Aprovado';
ELSE IF (@NotaFinal >= 50)
	PRINT 'Em Recuperação';
ELSE
	PRINT 'Reprovado';



