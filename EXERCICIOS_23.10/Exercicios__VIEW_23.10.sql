/*1- Crie uma visão que liste todos os funcionários que não são chefes.*/
GO
CREATE OR ALTER VIEW vw_listar_nao_chefes
AS
	SELECT *
	FROM Employees AS E
	WHERE E.Title NOT LIKE '%MANAGER%' AND E.Title NOT LIKE '%Vice President%';
GO
SELECT *
FROM vw_listar_nao_chefes;

---

/*2- Faça uma visão que liste a quantidade de vendas que cada produto
(o quanto cada produto foi vendido).*/
GO
CREATE OR ALTER VIEW vw_qtde_vendas_produtos
AS
	SELECT P.ProductName,OD.ProductID, SUM(OD.Quantity) AS 'Total de venda'
	FROM [Order Details] AS OD
	JOIN PRODUCTS AS P ON OD.ProductID = P.ProductID
	GROUP BY P.ProductName, OD.ProductID;
GO
SELECT *
FROM vw_qtde_vendas_produtos;


----

/*3- Faça uma visão que liste os territórios e quantos vendedores 
estão vinculados a ele.*/
GO
CREATE OR ALTER VIEW  vw_listar_territorios_vendedores
AS
	SELECT ET.TerritoryID,T.TerritoryDescription, COUNT(ET.EmployeeID) AS 'Qtde de Vendedores'
	FROM Territories AS T
	LEFT JOIN EmployeeTerritories AS ET ON T.TerritoryID = ET.TerritoryID
	GROUP BY ET.TerritoryID, T.TerritoryDescription

GO
SELECT *
FROM vw_listar_territorios_vendedores;
---

/*4- Faça uma visão que retorne o nome do cliente da venda de maior valor.*/
GO
CREATE OR ALTER VIEW vw_maior_venda
AS
	
	SELECT TOP 1 C.CompanyName, SUM(UnitPrice * Quantity * (1 - Discount)) AS 'Valor'
	FROM Customers AS C
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID  = OD.OrderID
	GROUP BY  O.OrderID,C.CompanyName
	ORDER BY [Valor] DESC;
	
GO
SELECT *
FROM vw_maior_venda;
/*5- Faça uma visão que liste os vendedores ordenados pela lucratividade.*/
GO
CREATE OR ALTER VIEW vw_listar_lucratividade_vendedor
AS
	SELECT 
			E.EmployeeID,
			E.FirstName,
			SUM(UnitPrice * Quantity * (1 - Discount)) AS 'Valor'
	FROM Employees AS E
	JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	GROUP BY E.EmployeeID,E.FirstName
GO
SELECT *
FROM vw_listar_lucratividade_vendedor
ORDER BY [Valor] DESC;

/*6- Faça uma visão que retorne os produtos, seu fornecedor, sua categoria, seu preço 
e a informação de ele estar descontinuado ou não, 
para aqueles que possuem estoque*/
GO
CREATE OR ALTER VIEW vw_listar_dados_produtos
AS
	SELECT 
			P.ProductName,
			S.CompanyName,
			C.CategoryName as 'Categoria',
			P.UnitPrice,
			P.Discontinued
	FROM Products AS P
	JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
	JOIN Categories AS C ON P.CategoryID = C.CategoryID
	GROUP BY P.ProductName,S.CompanyName,C.CategoryName,P.UnitPrice,P.Discontinued
	
GO
SELECT *
FROM vw_listar_dados_produtos
ORDER BY [Categoria] DESC;
