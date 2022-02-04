USE Northwind   
GO

-- 1.List all cities that have both Employees and Customers.
SELECT DISTINCT c.City
FROM Customers c 
WHERE c.City IN ( 
    SELECT e.City
    FROM Employees e
)

-- 2.List all cities that have Customers but no Employee.

--a.Use sub-query
SELECT DISTINCT c.City
FROM Customers c 
WHERE c.City NOT IN ( 
    SELECT e.City
    FROM Employees e
) 
--b.Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL

-- 3.List all products and their total order quantities throughout all orders.
SELECT p.ProductName, o.Quantity
FROM [Order Details] o  LEFT JOIN Products p ON o.ProductID = p.ProductID

-- 4.List all Customer Cities and total products ordered by that city.
SELECT  o.ShipCity, SUM(od.Quantity) NumOfProducts
FROM Orders o LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.ShipCity

-- 5. List all Customer Cities that have at least two customers.

--a.Use UNION

--b.Use sub-query and no union
SELECT c.City
FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE c.City IN (
    SELECT c.City 
    FROM Customers c
    GROUP BY c.City
    HAVING COUNT(c.CustomerID) >= 2 
)

-- 6.List all Customer Cities that have ordered at least two different kinds of products.

-- 7.List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.ContactName, c.City, o.ShipCity
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE c.City != o.ShipCity

-- 8.List 5 most popular products, their average price, and the customer city that ordered most quantity of it.


-- 9.List all cities that have never ordered something but we have employees there.

--a.Use sub-query
SELECT e.City
FROM Employees e 
WHERE e.City NOT IN (
    SELECT o.ShipCity
    FROM Orders o
)

--b.Do not use sub-query
SELECT e.CIty
FROM Employees e LEFT JOIN Orders o ON e.City = o.ShipCity
WHERE o.ShipCity IS NULL

-- 10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

-- 11.How do you remove the duplicates record of a table?
---- 1.On the cte, we will use ROW_NUMBER() OVER (PARTITION BY ) so it will rank the value 
---- (RowNum) then if the RowNum > 1 which mean there are duplicates
---- 2.Use DELETE FROM cte to delete the RowNum > 1

