
--What is a result set: a set of rows from a database, as well metadata about the query like column names, types and sizes.

--What is the difference between Union and Union All: union and union all are the same, but union all selects all the values. Union all will not eliminate duplicate rows.

--What are the other Set Operators SQL Server has: intercept, minus, except

--What is the difference between Union and Join: Union combines queries into one query, with same number of columns. Join combines data in queries, the number of rows will depend on what kind of joins.

--What is the difference between INNER JOIN and FULL JOIN?: inner join will take the rows with same elements in both queries. Full join will take rows with all the elements.

--What is difference between left join and outer join: Left join will take the rows in the left queries and matched between both queries.

--What is cross join? Cross join combines each rows from this query with each row from second query

--What is the difference between WHERE clause and HAVING clause? Having can be used on the columns that the original queries have, but not work with WHERE. WHERE can only used after FROM and before keywords. 

--Can there be multiple group by columns? yes, using GROUP BY


--How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) AS "Number of products"
FROM Production.Product

--Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) AS "Number of products"
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NOT NULL;

--How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) AS " Counted Products" 
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

--How many products that do not have a product subcategory. 
SELECT COUNT(ProductID) AS "Number of Product not in a Category" 
FROM Production.Product AS p
WHERE p.ProductSubcategoryID IS NULL;

--Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) AS 'Sum of Products' 
FROM Production.ProductInventory
GROUP BY ProductID;

--Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

--Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID, Shelf
HAVING SUM(Quantity) < 100;

--Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID;

--Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID,Shelf;

--Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf;

--List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, Count(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

--Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.   
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode;

--Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name AS Country, s.Name AS Province 
	FROM Person.CountryRegion c 
	JOIN
	Person.StateProvince s
	ON c.CountryRegionCode = s.CountryRegionCode
	WHERE c.Name NOT IN ('Germany', 'Canada');	

--Using Northwnd Database: (Use aliases for all the Joins)

--List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductID, p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID =  od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE DATEDIFF(year, o.OrderDate, GETDATE()) < 25;

--List top 5 locations (Zip Code) where the products sold most.	
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS qty 
FROM Orders o
JOIN [Order Details] od ON o.OrderID =  od.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY qty DESC;

--List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode, SUM(od.Quantity) AS qty 
FROM Orders o
JOIN [Order Details] od ON o.OrderID =  od.OrderID
WHERE o.ShipPostalCode IS NOT NULL AND DATEDIFF(year, o.OrderDate, GETDATE()) < 25
GROUP BY ShipPostalCode
ORDER BY qty DESC;

--List all city names and number of customers in that city.     
SELECT City, COUNT(customerID) AS NumOfCustomer
FROM customers
GROUP BY City

--List city names which have more than 2 customers, and number of customers in that city 
SELECT City, COUNT(customerID) AS NumOfCustomer
FROM customers
GROUP BY City
HAVING  COUNT(customerID)>2

--List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.CustomerID, c.CompanyName, c.ContactName 
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE OrderDate > '1998-1-1';

--List the names of all customers with most recent order dates 
SELECT c.ContactName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerId = o.CustomerId
GROUP BY c.ContactName

--Display the names of all customers  along with the  count of products they bought 
SELECT c.CustomerID, c.CompanyName, c.ContactName, SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName, c.ContactName
ORDER BY QTY;

--Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(od.Quantity) AS QTY FROM 
Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100
ORDER BY QTY;

--List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT sup.CompanyName AS 'Supplier Company Name', ship.CompanyName AS 'Shipping Company Name'
FROM Orders o
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
RIGHT JOIN Suppliers sup ON p.SupplierID = sup.SupplierID
INNER JOIN Shippers ship ON o.ShipVia = ship.ShipperID;
