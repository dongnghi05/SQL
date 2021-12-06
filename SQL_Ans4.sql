--What is View? What are the benefits of using views: A view is a virtual table whose contents are defined by a query. Like a real table, a view consists of a set of named columns and rows of data
--Can data be modified through views: no
--What is stored procedure and what are the benefits of using it: hide direct SQL queries from the code and improve performance of datatbase operations
--What is the difference between view and stored procedure: stored procedure hold more complex operation so it is for large SQL workflows
--What is the difference between stored procedure and functions: function use RETURN arguments, not necessary with stored function
--Can stored procedure return multiple result sets: yes
--Can stored procedure be executed as part of SELECT Statement? Why: yes,  the stored procedure returns a result set
--What is Trigger? What types of Triggers are there?Triggers are a special type of stored procedure that get executed (fired) when a specific event happens.DML Statements like Insert , Delete or Update
--What is the difference between Trigger and Stored Procedure? trigger is a stored procedure that runs automatically when various events happen (egupdate, insert, delete).

--Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
create view view_product_order_vo
as
select p.ProductName, Count(o.Quantity) QuantityCount from Products p inner join
[Order Details] o
on o.ProductID = p.ProductID
group by p.ProductName;

--Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
alter proc spProductOrderQuant2
@id int,
@total int out
as
begin
 select @id = view_product_quantity_order_vo.ProductID,@total =
view_product_quantity_order_vo.QuantityCount from
view_product_quantity_order_vo
where view_product_quantity_order_vo.ProductID = @id
end
declare @id int, @total int
exec spProductOrderQuant2 2, @total out
print @total

--Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
create table people_vo(id int,name char(20),cityid int)
create table city_vo(cityid int,city char(20))
insert into people_vo(id,name,cityid)values(1,'Aaron Rodgers',2)
insert into people_vo(id,name,cityid)values(2,'Russell Wilson',1)
insert into people_vo(id,name,cityid)values(3,'Jody Nelson',2)
insert into city_vo(cityid,city)values(1,'Settle')
insert into city_vo(cityid,city)values(2,'Green Bay')

create view Packers_nghi_vo as
select p.id, p.name from people_vo p inner join city_vo c on p.cityid=c.cityid
where c.city='Green bay'
drop table people_vo
drop table city_vo
drop view Packers_nghi_vo