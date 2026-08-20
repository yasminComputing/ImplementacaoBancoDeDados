USE Comercio;



-- 1. Criar um relatório que mostre os detalhes principais dos produtos, combinando
-- informações de produtos, categorias e fornecedores. Listar o nome do produto, o
-- nome da empresa fornecedora, o nome da categoria, o preço unitário do produto e a
-- quantidade em estoque.

SELECT  p.ProductName as "Nome do Produto", 
    s.CompanyName as "Companhia Nome", 
    c.CategoryName as "Categoria", 
    p.UnitPrice as "Preço Unitário", 
    p.UnitsInStock as "Quantidade em Estoque"
FROM Products as p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
JOIN Categories AS c ON p.CategoryID = c.CategoryID;

-- 2. Filtrar a lista de produtos, mostrando apenas aqueles que estão disponíveis para
-- venda imediata. A partir da consulta anterior, ocultar os produtos que possuem
-- estoque zerado ou que foram descontinuados
SELECT  p.ProductName as "Nome do Produto", 
    s.CompanyName as "Companhia", 
    c.CategoryName as "Categoria", 
    p.UnitPrice as "Preço Unitário", 
    p.UnitsInStock as "Quantidade em Estoque"
FROM Products as p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
JOIN Categories AS c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = 0 AND p.UnitsInStock > 0;


-- 3. Analisar a produtividade da equipe de vendas, contando o número total de pedidos
-- (vendas) por vendedor. Mostrar o nome completo de cada vendedor (funcionário) e a
-- quantidade total de vendas que ele realizou.

SELECT
        CONCAT(e.FirstName, ' ', e.LastName) AS "Nome do Vendedor(a)",
        COUNT(e.EmployeeID) as "Quantidade de Venda"
FROM Employees as e
JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY [Nome do Vendedor(a)] ASC;

-- 4. Identificar os vendedores com o maior volume de transações. Utilizando a mesma
-- lógica da consulta anterior, exibir apenas os vendedores que realizaram uma
-- quantidade de vendas maior ou igual a 100
SELECT
        CONCAT(e.FirstName, ' ', e.LastName) AS "Nome do Vendedor(a)",
        COUNT(o.EmployeeID) as "Quantidade de Venda"
FROM Orders as o
JOIN Employees AS e ON  o.EmployeeID =e.EmployeeID
GROUP BY e.FirstName, e.LastName
HAVING COUNT(o.EmployeeID) >= 100
ORDER BY [Nome do Vendedor(a)] ASC;

-- 5. Entender a distribuição de trabalho dos vendedores por áreas geográficas. Mostrar o
-- nome completo do vendedor e a quantidade de territórios aos quais ele está
-- vinculado.
SELECT 
        CONCAT(e.FirstName, ' ', e.LastName) AS "Nome do Vendedor(a)",
        COUNT(e.EmployeeID) as "Qtde de Territórios Vinculados"
FROM Employees AS e
JOIN EmployeeTerritories as e_territories ON e.EmployeeID = e_territories.EmployeeID
GROUP BY e.FirstName, e.LastName
ORDER BY [Nome do Vendedor(a)] ASC;

--
select *
from EmployeeTerritories;

-- 6. Classificar os pedidos pelo seu valor monetário total, permitindo identificar as vendas
-- mais valiosas. Listar todos os pedidos, calculando o valor total de cada um
-- (considerando preço, quantidade e desconto) e ordená-los do maior para o menor
-- valor
SELECT 
        o.OrderID as "ID Pedido",
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS "Preço Final"
FROM   Orders AS o
JOIN [Order Details] AS od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY "Preço Final"DESC;


 SELECT *
 FROM Products;

 SELECT *
 FROM [Order Details];



-- 7. Crie uma consulta que identifique todos os itens de pedidos que foram vendidos por
-- um preço unitário inferior ao padrão cadastrado na tabela de produtos. Exiba o ID do
-- Pedido, o nome do produto, o preço de lista e o preço que foi efetivamente

SELECT 
        od.OrderID AS "ID Pedido",
        p.ProductName AS "Produto Nome",
        p.UnitPrice AS "Preço Lista",
        od.UnitPrice AS "Preço Vendido"
FROM [Order Details] AS od
JOIN Products AS p ON od.ProductID = p.ProductID
WHERE od.UnitPrice < p.UnitPrice
ORDER BY od.OrderID;