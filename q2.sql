--Q2a
SELECT count(Orders.OrderID)from Orders left join Shippers 	
    on Orders.ShipperID =Shippers.ShipperID 
    where Shippers.ShipperName='Speedy Express';

--Q2b
SELECT LastName From Employees where EmployeeID = (
		SELECT EmployeeID from Orders Group by EmployeeID 
        Order by Count(OrderID) DESC limit 1);
--Q2c
With
	GermanCustomers as (Select CustomerID from Customers where Country = 'Germany'),
    GermanOrders as (Select OrderID from GermanCustomers as gc 
		inner join Orders as o on o.CustomerID = gc.CustomerID),
	GermanBoughtProducts as (Select p.ProductID as PID, sum(od.Quantity) as TotalProductQuantity 
		from OrderDetails as od inner join GermanOrders as go on od.OrderID=go.OrderID 
        inner join Products as p on p.ProductID=od.ProductID group by PID),
    MaxPID as (Select PID from GermanBoughtProducts 
		where TotalProductQuantity = (Select max(TotalProductQuantity) from GermanBoughtProducts))
Select p2.ProductName from MaxPID as p1 inner join Products as p2 on p1.PID=p2.ProductID;