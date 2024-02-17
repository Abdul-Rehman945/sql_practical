create database sql_practical;
use sql_practical;



----First Table--------

create table Customer (
	cus_id int primary key identity,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(60) unique,
	contact bigint
);

INSERT INTO Customer (first_name, last_name, email, contact) VALUES
('John', 'Doe', 'john.doe@email.com', 1234567890),
('Jane', 'Smith', 'jane.smith@email.com', 9876543210),
('Michael', 'Johnson', 'michael.johnson@email.com', 5551234567),
('Emily', 'Williams', 'emily.williams@email.com', 9998887777),
('Chris', 'Brown', 'chris.brown@email.com', 1112223333),
('Alice', 'Johnson', 'alice.johnson@email.com', 5551112222),
('Bob', 'Miller', 'bob.miller@email.com', 7778889999),
('Eva', 'Jones', 'eva.jones@email.com', 3334445555),
('David', 'Clark', 'david.clark@email.com', 6667778888),
('Sophie', 'Turner', 'sophie.turner@email.com', 4445556666);


--------Second Table----------

create table Orders (
	ord_id int primary key identity,
	cus_id int,
	order_date date,
	total_amount bigint,

	foreign key (cus_id) references Customer(cus_id)
);

INSERT INTO Orders (cus_id, order_date, total_amount) VALUES
(1, '2024-02-17', 500),
(2, '2024-02-18', 700),
(3, '2024-02-19', 300),
(4, '2024-02-20', 900),
(5, '2024-02-21', 450),
(6, '2024-02-22', 600),
(7, '2024-02-23', 800),
(8, '2024-02-24', 350),
(9, '2024-02-25', 200),
(10, '2024-02-26', 1000);


----------Third Table-------------

create table Product (
	prod_id int primary key identity,
	prod_name varchar(50),
	unit_price bigint,
	stock bigint
);


INSERT INTO Product (prod_name, unit_price, stock) VALUES
('Product1', 50, 100),
('Product2', 75, 150),
('Product3', 30, 200),
('Product4', 100, 50),
('Product5', 25, 300),
('Product6', 60, 120),
('Product7', 80, 180),
('Product8', 40, 250),
('Product9', 90, 70),
('Product10', 120, 100);


-----------FOurth Table---------------

create table Orders_details (
	od_det_id int primary key identity,
	order_id int,
	product_id int,
	quantity bigint,
	unit_price bigint,

	foreign key (product_id) references Product(prod_id),
	foreign key (order_id) references Orders(ord_id)
);


INSERT INTO Orders_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 50),
(1, 2, 1, 75),
(2, 3, 3, 30),
(2, 4, 2, 100),
(3, 5, 1, 25),
(3, 6, 2, 60),
(4, 7, 5, 80),
(4, 8, 3, 40),
(5, 9, 4, 90),
(5, 10, 1, 120);




----------First Querry-------------

create login Store
with password = 'password';


create user Order_Clerk
for login Store ;


grant insert , update on dbo.Orders to Order_clerk;

grant insert , update on dbo.Orders_details to Order_clerk;



---------------Second Querry-------------------


CREATE TABLE Stock_Update_Audit (
    audit_id int PRIMARY KEY IDENTITY,
    prod_id int,
    old_quantity bigint,
    new_quantity bigint,
    update_date datetime
);


----------Trigger-----------

CREATE TRIGGER Update_Stock_Audit
ON Product
AFTER UPDATE
AS
BEGIN
    declare @old_stock bigint , @new_stock bigint , @product_id int;
	select @old_stock =  stock from deleted ;
	select @new_stock = stock from inserted ;
	select @product_id = prod_id from inserted;


	insert into Stock_Update_Audit (prod_id , old_quantity , new_quantity , update_date) values 
	(@product_id , @old_stock , @new_stock , GETDATE());

END;



----------Third Querry------------

select c.first_name , c.last_name , c.email , c.contact , o.order_date , o.total_amount
from Customer as c inner join Orders as o on c.cus_id = o.cus_id;



-------------Fourth Querry--------------


select p.prod_name , o.quantity , (o.quantity * p.unit_price) as Total_Price from Product as p  join Orders_details
as o on p.prod_id = o.product_id  join
Orders as od on o.order_id = od.ord_id where od.total_amount > (select AVG(total_amount) from Orders);







-----------Fifth Querry------------------

create procedure Get_Orders_By_Customer
@id int
as 
begin
select c.cus_id , c.first_name  , c.last_name , c.email , c.contact , o.ord_id , o.order_date , o.total_amount 
from Customer as c inner join Orders as o on c.cus_id = o.cus_id where c.cus_id = @id ;
end

exec Get_Orders_By_Customer @id = 2 ;





-----------------Sixth Querry------------------

create view Order_Summary as
select * from Orders ;

select * from Order_Summary ;






---------------Seventh Querry--------------

create view Product_Inventory as
select prod_name , stock from Product;

select *  from Product_Inventory ;



--------------Eight Querry----------------

select c.first_name , c.last_name , o.ord_id , o.order_date ,o.total_amount from Order_Summary as o
inner join Customer as c on o.cus_id = c.cus_id ;