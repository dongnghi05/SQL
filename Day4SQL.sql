USE Northwind   
GO

-- 1.Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.

CREATE VIEW view_product_order_vo 
AS
SELECT p.ProductName, SUM(o.Quantity) total_quantity
FROM Products p INNER JOIN [Order Details] o ON p.ProductID = o.ProductID
GROUP BY p.ProductName
GO
SELECT * FROM view_product_order_vo
GO
-- 2.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

CREATE PROC sp_product_order_quantity_vo
@id int,
@quantities int out 
AS
BEGIN
SELECT @quantities = Quantity FROM [Order Details] WHERE ProductID = @id
END
GO

BEGIN
DECLARE @result int
EXEC sp_product_order_quantity_vo 1, @result output
PRINT @result
END
GO

-- 3.Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.

CREATE PROC sp_product_order_city_vo
@productName varchar(255)
AS
BEGIN
SELECT TOP 5 od.ShipCity, p.ProductName, SUM(o.Quantity)
FROM Products p INNER JOIN [Order Details] o ON p.ProductID = o.ProductID INNER JOIN Orders od ON od.OrderID = o.OrderID
WHERE @productName = p.ProductName
GROUP BY od.ShipCity, p.ProductName
ORDER BY SUM(o.Quantity) DESC
END
GO

EXEC sp_product_order_city_vo 'Chai'
SELECT * FROM Products

-- 4.Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

CREATE TABLE city_vo (
    id int primary key, 
    City varchar(20)
    )
INSERT INTO city_vo VALUES (1,'Seattle')
INSERT INTO city_vo VALUES (2,'Green Bay')

CREATE TABLE people_vo (
    id int primary key, 
    Name varchar(20), 
    City int foreign key references city_vo(id)
    )
INSERT INTO people_vo VALUES (1,'Aaron Rodgers',2)
INSERT INTO people_vo VALUES (2,'Russell Wilson',1)
INSERT INTO people_vo VALUES (3,'Jody Nelson',2)

SELECT * FROM city_vo
SELECT * FROM people_vo

CREATE VIEW Packers_vo
AS 
SELECT p.Name
FROM people_vo p INNER JOIN city_vo c ON p.City = c.id
WHERE c.City = 'Green Bay'

DROP TABLE people_vo
DROP TABLE city_vo

-- 5.Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
CREATE PROC sp_birthday_employees_vo
AS 
BEGIN
SELECT e.EmployeeID, e.FirstName, e.LastName INTO birthday_employees_vo
FROM Employees e
WHERE MONTH(e.BirthDate) = 2
END

DROP TABLE birthday_employees_vo

SELECT * FROM birthday_employees_vo
SELECT * FROM Employees


-- 6.How do you make sure two tables have the same data?

-- I will use TABLE_A EXCEPT TABLE_B, if return any rows => not the same