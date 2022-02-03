USE AdventureWorks2019
GO

-- 1.How many products can you find in the Production.Product table?
SELECT COUNT(*) AS NumOfProducts
FROM Production.Product

-- 2.Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(*)
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL 

-- 3.How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT p.ProductSubcategoryID, SUM(ProductSubcategoryID) AS CountedProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

-- 4.How many products that do not have a product subcategory.
SELECT COUNT(*)
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NULL

-- 5.Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(p.Quantity)
FROM Production.ProductInventory p

-- 6.Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT p.ProductID, SUM(p.Quantity) TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40 AND p.Quantity <= 100
GROUP BY p.ProductID

-- 7.Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT p.Shelf, p.ProductID, SUM(p.Quantity) TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40 AND p.Quantity <= 100
GROUP BY p.Shelf, p.ProductID

 -- 8.Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT p.ProductID, AVG(p.Quantity) TheAvg
FROM Production.ProductInventory p 
WHERE p.LocationID = 10
GROUP BY p.ProductID

-- 9.Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) TheAvg
FROM Production.ProductInventory p 
GROUP BY p.ProductID, p.Shelf

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT p.ProductID, AVG(p.Quantity) TheAvg
FROM Production.ProductInventory p 
WHERE p.Shelf IS NOT NULL
GROUP BY p.ProductID

-- 11.List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT p.Color, p.Class, COUNT(*) TheCount, AVG(p.ListPrice) AvgPrice
FROM Production.Product p
WHERE p.Color IS NOT NULL AND p.Class IS NOT NULL
GROUP BY p.Color, p.Class

-- 12.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode

-- 13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')

------Using Northwnd Database: (Use aliases for all the Joins)------
USE Northwind
GO
-- 14.List all Products that has been sold at least once in last 25 years.
SELECT p.ProductName, s.ProductSales
FROM Products p INNER JOIN [Product Sales for 1997] s ON p.ProductName = s.ProductName

-- 15.List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 od.ProductID, ord.ShipPostalCode, SUM(od.Quantity) TheSum
FROM [Order Details] od INNER JOIN Orders ord ON  od.OrderID = ord.OrderID
GROUP BY od.ProductID, ord.ShipPostalCode
ORDER BY TheSum DESC

-- 16.List top 5 locations (Zip Code) where the products sold most in last 25 years.

-- 17.List all city names and number of customers in that city
SELECT c.City, COUNT(*) NumOfCustomers
FROM Customers c
GROUP BY c.City

-- 18.List city names which have more than 2 customers, and number of customers in that city
SELECT c.City, COUNT(*) NumOfCustomers
FROM Customers c
GROUP BY c.City
HAVING COUNT(*) > 2

-- 19.List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1998-01-01 00:00:00:00'

-- 20.List the names of all customers with most recent order dates
SELECT c.ContactName, MAX(o.OrderDate)
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

-- 21.Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(*) CountOfProducts
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName

-- 22.Display the customer ids who bought more than 100 Products with count of products.
SELECT c.ContactName, COUNT(*) CountOfProducts
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
HAVING COUNT(*) > 100

-- 23.List all of the possible ways that suppliers can ship their products. Display the results as below

-- 24.Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM  Orders o INNER JOIN [Order Details] od ON od.OrderID = o.OrderID INNER JOIN Products p ON p.ProductID = od.ProductID

-- 25.Displays pairs of employees who have the same job title.
SELECT e1.FirstName + e1.LastName Employee1, e2.FirstName + e2.LastName Employee2
FROM Employees e1, Employees e2
WHERE e1.Title = e2.Title AND e1.EmployeeID != e2.EmployeeID



