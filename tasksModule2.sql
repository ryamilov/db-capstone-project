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

-- Table booking system

-- Task 1:
INSERT INTO `LittleLemonDM`.`Bookings` (`BookingId`, `BookingDate`, `TableNumber`, `CustomerId`, `StaffId`, `MenuId`) VALUES
(1, '2023-10-01', 5, 1, 1, 1),
(2, '2023-10-02', 3, 2, 2, 2),
(3, '2023-10-03', 7, 3, 3, 3),
(4, '2023-10-04', 2, 4, 4, 4),
(5, '2023-10-05', 8, 5, 5, 5),
(6, '2023-10-06', 1, 6, 6, 6),
(7, '2023-10-07', 4, 7, 7, 7),
(8, '2023-10-08', 6, 8, 8, 8),
(9, '2023-10-09', 9, 9, 9, 9),
(10, '2023-10-10', 10, 10, 10, 10);

-- Task 2:
DELIMITER // 
CREATE Procedure CheckBooking(bookingDateParam date, tableNumberParam int)
Begin
	SELECT CONCAT('Table ', TableNumber, ' already booked') 
	FROM littlelemondm.bookings 
    where BookingDate = bookingDateParam and TableNumber = tableNumberParam;
END//
DELIMITER ;

call CheckBooking('2023-10-07', 4);

-- Task 3:
DELIMITER // 
CREATE Procedure AddValidBooking(bookingDateParam date, tableNumberParam int)
Begin
	DECLARE numberOfRows INT;
	START TRANSACTION; 
    
		SET @lastId = (select MAX(BookingId) from littlelemondm.bookings);
		INSERT INTO littlelemondm.bookings 
			(`BookingId`, `BookingDate`, `TableNumber`)
		VALUES
			(@lastId + 1, bookingDateParam, tableNumberParam); 
            
		Select count(*) into numberOfRows
        from (select BookingDate, TableNumber, count(*) as numberOfBookings
				FROM littlelemondm.bookings 
                where BookingDate = bookingDateParam and TableNumber = tableNumberParam
				Group by BookingDate, TableNumber
				Having numberOfBookings > 1) as temp;
                
        IF numberOfRows > 0 
			THEN 
				select concat('table ', tableNumberParam, ' already booked - booking cancelled');
                rollback;
			ELSE 
				select concat('table ', tableNumberParam, ' booked successfully on date ', bookingDateParam);
                commit;
        END IF;
    rollback;
END//
DELIMITER ;

call AddValidBooking('2023-10-08', 4);

-- manage bookings
-- Task 1:
DELIMITER // 
CREATE Procedure AddBooking(bookingIdParam int,
	customerIdParam int,
    bookingDateParam date, 
    tableNumberParam int)
Begin
START TRANSACTION; 
	INSERT INTO littlelemondm.bookings 
		(`BookingId`, `CustomerId`, `BookingDate`, `TableNumber`)
	VALUES
		(bookingIdParam, customerIdParam, bookingDateParam, tableNumberParam); 
	IF ROW_COUNT() > 0 
		THEN 
			commit;
			select 'New booking added';
		ELSE 
			rollback;
			select 'Cannot add the booking';
    END IF;
END//
DELIMITER ;

call AddBooking(12, 1, '2023-10-08', 4);

-- Task 2:
DELIMITER // 
CREATE Procedure UpdateBooking(bookingIdParam int, bookingDateParam date)
Begin
START TRANSACTION; 
	update littlelemondm.bookings 
    set BookingDate = bookingDateParam
    where BookingId = bookingIdParam;
    
	IF ROW_COUNT() > 0 
		THEN 
			commit;
			select 'Booking updated';
		ELSE 
			rollback;
			select 'Cannot update the booking';
    END IF;
END//
DELIMITER ;

call UpdateBooking(12, '2023-10-09');

-- Task 3
DELIMITER // 
CREATE Procedure CancelBooking(bookingIdParam int)
Begin
START TRANSACTION; 
	delete from littlelemondm.bookings 
    where BookingId = bookingIdParam;
    
	IF ROW_COUNT() > 0 
		THEN 
			commit;
			select concat('Booking ', bookingIdParam, ' cancelled');
		ELSE 
			rollback;
			select 'Cannot cancel the booking';
    END IF;
END//
DELIMITER ;

call CancelBooking(12);