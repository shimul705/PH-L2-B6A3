-- Query 1: JOIN
SELECT 
    Bookings.booking_id,
    Users.name AS customer_name,
    Vehicles.name AS vehicle_name,
    Bookings.start_date,
    Bookings.end_date,
    Bookings.status
FROM 
    Bookings
INNER JOIN 
    Users ON Bookings.user_id = Users.user_id
INNER JOIN 
    Vehicles ON Bookings.vehicle_id = Vehicles.vehicle_id;


-- Query 2: EXISTS
SELECT 
    Vehicles.vehicle_id,
    Vehicles.name,
    Vehicles.type,
    Vehicles.model,
    Vehicles.registration_number,
    Vehicles.rental_price,
    Vehicles.status
FROM 
    Vehicles
WHERE 
    NOT EXISTS (
        SELECT 1 
        FROM Bookings 
        WHERE Bookings.vehicle_id = Vehicles.vehicle_id
    )
ORDER BY Vehicles.vehicle_id;



-- Query 3: WHERE
SELECT 
    vehicle_id,
    name,
    type,
    model,
    registration_number,
    rental_price,
    status
FROM 
    Vehicles
WHERE 
    type = 'car' 
    AND status = 'available'
ORDER BY Vehicles.vehicle_id;



-- Query 4: GROUP BY and HAVING
SELECT 
    Vehicles.name AS vehicle_name,
    COUNT(Bookings.booking_id) AS total_bookings
FROM 
    Vehicles
INNER JOIN 
    Bookings ON Vehicles.vehicle_id = Bookings.vehicle_id
GROUP BY 
    Vehicles.vehicle_id, Vehicles.name
HAVING 
    COUNT(Bookings.booking_id) > 2;