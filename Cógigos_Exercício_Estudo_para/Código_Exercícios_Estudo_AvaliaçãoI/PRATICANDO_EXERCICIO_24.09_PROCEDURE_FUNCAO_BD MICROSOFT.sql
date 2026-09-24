/*
1. Crie uma Stored Procedure que receba o CategoryID e retorne:

Nome do produto;
Preço unitário;
Quantidade em estoque;
Nome da categoria.

Os produtos devem ser apresentados somente quando não estiverem descontinuados.
*/
GO
CREATE OR ALTER PROCEDURE sp_listar_prod_nao_descontinuados (@categoria_id INT)
AS
BEGIN
		SELECT
				P.ProductName AS 'Produto',
				P.UnitPrice AS 'Preço Unitário',
				P.UnitsInStock AS 'Qtde em Estoque',
				C.CategoryName AS 'Categoria'
		FROM PRODUCTS AS P
		JOIN Categories AS C ON P.CategoryID = C.CategoryID
		WHERE P.Discontinued <> 1 AND @categoria_id = C.CategoryID

END
EXEC sp_listar_prod_nao_descontinuados @categoria_id = 1;

GO
----
/*
2. Crie uma Stored Procedure que receba o EmployeeID e duas datas (data inicial e data final).

A procedure deve retornar:

Nome completo do funcionário;
ID do pedido;
Data de envio;
Valor total do pedido.
Considere o cálculo do valor usando preço, quantidade e desconto.
*/
GO
CREATE OR ALTER PROCEDURE sp_dados_calculo(@empregado_id AS INT, @data_inicial AS DATE, @data_final AS DATE)
AS
BEGIN 
		SELECT 
				CONCAT(E.FirstName, ' ', E.LastName) AS 'Nome Funcionário',
				O.OrderID,
				O.ShippedDate AS 'Data de Envio',
				SUM((P.UnitPrice * ORD.Quantity) * (1 - ORD.Discount)) AS 'Valor Total do Pedido'
		FROM Orders AS O
		JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
		JOIN [Order Details] AS ORD ON O.OrderID = ORD.OrderID
		JOIN PRODUCTS AS P ON ORD.ProductID = P.ProductID
		WHERE @empregado_id  = E.EmployeeID AND O.OrderDate BETWEEN @data_inicial AND  @data_final
		GROUP BY E.FirstName,E.LastName,O.OrderID,O.ShippedDate;
END
GO
EXEC sp_dados_calculo @empregado_id = 5, @data_inicial = '1996-01-01', @data_final = '1996-12-31';


SELECT *
FROM PRODUCTS;



----

/*
3. Crie uma procedure que receba um valor de preço como parâmetro.
Ela deve retornar todos os produtos cujo UnitPrice seja maior que o valor informado, mostrando:
Nome do produto;
Preço;
Categoria.

Ordene do produto mais caro para o mais barato.
*/
GO
CREATE OR ALTER PROCEDURE sp_retornar_Produto (@preco MONEY)
AS
BEGIN
		SELECT P.ProductName,P.UnitPrice,C.CategoryName
		FROM Products AS P
		JOIN Categories AS C ON P.CategoryID = C.CategoryID
		WHERE P.UnitPrice > @preco
		ORDER BY P.UnitPrice DESC

END
EXEC sp_retornar_Produto @preco = 50;
GO

----
/*
4. Faça uma consulta que mostre:

Nome completo do funcionário;
Quantidade de pedidos realizados por ele.

Considere somente os funcionários que possuem pelo menos 1 pedido.

Depois, ordene pela quantidade de vendas, da maior para a menor

*/
GO
SELECT CONCAT(E.FirstName, ' ', E.LastName) AS 'Nome Funcionário', COUNT(O.OrderID) AS 'Quantidade de pedidos'
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE O.EmployeeID >= 1
GROUP BY E.FirstName,E.LastName
ORDER BY COUNT(O.EmployeeID) DESC;
GO
---
/*
5. Faça uma consulta que mostre:

OrderID;
Nome da empresa cliente;
Valor total do pedido.*/
SELECT 
		ORD.OrderID,
		C.CompanyName,
		SUM((P.UnitPrice * ORD.Quantity) * (1 - ORD.Discount)) AS 'Valor Total do Pedido'
FROM Orders AS O
JOIN Customers AS C ON O.CustomerID = C.CustomerID
JOIN [Order Details] AS ORD ON O.OrderID = ORD.OrderID
JOIN PRODUCTS AS P ON ORD.ProductID = P.ProductID
GROUP BY ORD.OrderID, C.CompanyName

----
/*
6.Crie uma função chamada:

fn_QtdPedidosFuncionario

Ela deve receber o EmployeeID e retornar a quantidade de pedidos realizados pelo funcionário.

Depois, faça uma consulta para mostrar:

Nome completo do funcionário;
Quantidade de pedidos retornada pela função.

*/
GO
CREATE OR ALTER FUNCTION fn_QtdePedidosFuncionario(@id INT)
RETURNS INT
BEGIN
		DECLARE @qtde_pedido INT;

		SELECT @qtde_pedido = COUNT(O.OrderId)
		FROM Employees AS E
		JOIN ORDERS AS O ON E.EmployeeID = O.EmployeeID
		WHERE @id = E.EmployeeID;
	   
	   RETURN @qtde_pedido;

END;
GO

SELECT CONCAT(E.FirstName, ' ', E.LastName) AS 'Nome Funcionário',dbo.fn_QtdePedidosFuncionario(E.EmployeeID) as 'Qtde de Pedidos'
FROM EMPLOYEES AS E
WHERE E.EmployeeID = 8;
----
/*
7.Crie uma função chamada:
fn_ProdutosCategoria
Ela deve receber o CategoryID e retornar uma tabela contendo:
Nome do produto;
Preço;
Estoque.
Depois utilize essa função em um SELECT.*/
GO
CREATE OR ALTER FUNCTION fn_ProdutosCategoria (@categoria_id INT)
RETURNS TABLE 
AS
RETURN 
(
		SELECT
				P.ProductName,
				P.UnitPrice,
				p.UnitsInStock
		FROM Products AS P
		WHERE @categoria_id = P.CategoryID
)
GO
SELECT * FROM dbo.fn_ProdutosCategoria(1);
-----
/*
8.Crie uma função chamada fn_ProdutosMaisCarosCategoria.

Ela deve receber o CategoryID como parâmetro e retornar uma tabela contendo:

Nome do produto;
Preço;
Estoque.

A função deve retornar somente os produtos cujo preço seja maior que a média de preço dos produtos daquela categoria.

Depois, utilize a função em um SELECT.
*/

GO
CREATE OR ALTER FUNCTION fn_ProdutosMaisCarosCategoria(@id INT)
RETURNS TABLE
RETURN 
(
		
		SELECT
				P.ProductName,P.UnitPrice,P.UnitsInStock
		FROM PRODUCTS AS P
		GROUP BY P.ProductName,P.UnitPrice,P.UnitsInStock,P.CategoryID
		HAVING @id  = P.CategoryID AND P.UnitPrice > AVG(P.UnitPrice)
		
				
)
GO
select  * from dbo.fn_ProdutosCategoria(1)

----
/*Crie uma função que receba o CategoryID e retorne uma string contendo os nomes de todos os produtos daquela categoria, separados por vírgula.

Exemplo do resultado:

Chai, Chang, Aniseed Syrup, Chef Anton's Cajun Seasoning

Depois faça uma consulta mostrando:

Nome da categoria;
String com os produtos.
*/
GO
CREATE OR ALTER FUNCTION fn_dados(@categoria_id INT)
RETURNS VARCHAR(200)
BEGIN
		DECLARE @nome VARCHAR(250);
		SELECT @nome = STRING_AGG(P.ProductName, ', ') WITHIN GROUP (ORDER BY P.ProductName ASC)
		FROM Products AS P
		WHERE P.CategoryID = @categoria_id
		RETURN @nome;
END;
GO

SELECT C.CategoryName AS 'Categoria' , dbo.fn_dados(C.CategoryID) AS 'Nomes do Produto'
FROM Categories AS C;