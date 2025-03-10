-- Module 2
-- create view and extract data

-- Task 1:
use littlelemondm;
create view OrdersView as select 
	orders.OrdersId, 
    orders.Quantity, 
    orders.TotalCost
from orders

-- Task 2:
Select 
	customerdetails.CustomerId, 
    concat(customerdetails.FirstName, ' ', customerdetails.LastName) as FullName,
    orders.OrdersId,
    orders.TotalCost,
    menu.MenuName,
    menu.Course,
    menu.Starter
from customerdetails
	join orders on customerdetails.CustomerId = orders.CustomerId
    join menu on orders.MenuId = menu.MenuId
where orders.TotalCost > 150
order by orders.TotalCost

-- Task 3:
Select
	menu.MenuName from menu
where
	menu.MenuId in (Select orders.MenuId 
		from orders 
        where orders.MenuId = any (Select orders.MenuId 
			from orders 
            group by orders.MenuId 
            having COUNT(orders.MenuId) > 2))
			
-- create procedure

-- Task 1:
DELIMITER // 
CREATE Procedure GetMaxQuantity()
Begin
Select max(orders.Quantity) as 'Max quantity in order' from littlelemondm.orders;
END//
DELIMITER ; 

call GetMaxQuantity();

-- Task 2:
Prepare GetOrderDetail from '
	Select 
		orders.OrdersId, 
		orders.Quantity, 
		orders.TotalCost
	from littlelemondm.orders
	where orders.CustomerId = ?';
	
set @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Task 3:
DELIMITER // 
CREATE Procedure CancelOrder(orderId INT)
Begin
delete from littlelemondm.orders 
where orders.OrdersId = orderId;
Select Concat('Order ', orderId, ' is cancelled') as Confirmation;
END//
DELIMITER ; 

call CancelOrder(5);