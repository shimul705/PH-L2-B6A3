# Vehicle Rental System - Database Design & SQL(postgresql) Queries

## Project Overview

This project implements a simple **Vehicle Rental System** database using **PostgreSQL**. The system manages users (customers and admins), vehicles (cars, bikes, trucks), and rental bookings. It demonstrates core relational database concepts including table design with primary/foreign keys, data integrity constraints, and fundamental SQL (postgresql) querying techniques.

The database consists of three main tables:
- **Users** – Stores user information with roles (Admin/Customer)
- **Vehicles** – Stores vehicle details with type, pricing, and availability status
- **Bookings** – Records rental bookings linking users to vehicles with dates, status, and total cost

The design fully supports the required business logic: unique emails and registration numbers, role-based access, vehicle availability tracking, and booking management.

## Database Schema Summary

### ERD Link 
```
https://lucid.app/lucidchart/f67b9b3f-f0ae-4476-8268-c3f41fe382f7/edit?viewport_loc=-747%2C-1139%2C2300%2C1016%2C0_0&invitationId=inv_33e862bc-e7e0-4059-9456-e0fd9efa8912

```
### Users Table
- `user_id` (SERIAL PK)
- `name`, `email` (UNIQUE), `password`, `phone`, `role` (Admin/Customer)

### Vehicles Table
- `vehicle_id` (SERIAL PK)
- `name`, `type` (car/bike/truck), `model`, `registration_number` (UNIQUE)
- `rental_price`, `status` (available/rented/maintenance, default: available)

### Bookings Table
- `booking_id` (SERIAL PK)
- `user_id` → FK to Users
- `vehicle_id` → FK to Vehicles
- `start_date`, `end_date`, `status` (pending/confirmed/completed/cancelled), `total_cost`

Foreign key constraints with `ON DELETE CASCADE` ensure referential integrity.


**Users Table (Sample Data)**

| user_id | name    | email              | phone      | role     |
|---------|---------|--------------------|------------|----------|
| 1       | Alice   | alice@example.com  | 1234567890 | Customer |
| 2       | Bob     | bob@example.com    | 0987654321 | Admin    |
| 3       | Charlie | charlie@example.com| 1122334455 | Customer |

**Vehicles Table (Sample Data)**

| vehicle_id | name           | type  | model | registration_number | rental_price | status      |
|------------|----------------|-------|-------|---------------------|--------------|-------------|
| 1          | Toyota Corolla | car   | 2022  | ABC-123             | 50.00        | available   |
| 2          | Honda Civic    | car   | 2021  | DEF-456             | 60.00        | rented      |
| 3          | Yamaha R15     | bike  | 2023  | GHI-789             | 30.00        | available   |
| 4          | Ford F-150     | truck | 2020  | JKL-012             | 100.00       | maintenance |

**Bookings Table (Sample Data)**

| booking_id | user_id | vehicle_id | start_date   | end_date     | status    | total_cost |
|------------|---------|------------|--------------|--------------|-----------|------------|
| 1          | 1       | 2          | 2023-10-01   | 2023-10-05   | completed | 240.00     |
| 2          | 1       | 2          | 2023-11-01   | 2023-11-03   | completed | 120.00     |
| 3          | 3       | 2          | 2023-12-01   | 2023-12-02   | confirmed | 60.00      |
| 4          | 1       | 1          | 2023-12-10   | 2023-12-12   | pending   | 100.00     |

## SQL Queries (queries.sql)

The following queries demonstrate the required SQL concepts using the sample data provided in the assignment:

### Query 1: JOIN – Booking Details with Customer and Vehicle Names
```sql
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
```


**Sample Result:**

| booking_id | customer_name | vehicle_name   | start_date   | end_date     | status    |
|------------|---------------|----------------|--------------|--------------|-----------|
| 1          | Alice         | Honda Civic    | 2023-10-01   | 2023-10-05   | completed |
| 2          | Alice         | Honda Civic    | 2023-11-01   | 2023-11-03   | completed |
| 3          | Charlie       | Honda Civic    | 2023-12-01   | 2023-12-02   | confirmed |
| 4          | Alice         | Toyota Corolla | 2023-12-10   | 2023-12-12   | pending   |



### Query 2: NOT EXISTS – Vehicles Never Booked
```sql
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
```
**Sample Result:**

| vehicle_id | name         | type  | model | registration_number | rental_price | status      |
|------------|--------------|-------|-------|---------------------|--------------|-------------|
| 3          | Yamaha R15   | bike  | 2023  | GHI-789             | 30.00        | available   |
| 4          | Ford F-150   | truck | 2020  | JKL-012             | 100.00       | maintenance |




### Query 3: WHERE – Available Vehicles of Type 'car'
```sql
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
```

**Sample Result:**

| vehicle_id | name           | type | model | registration_number | rental_price | status    |
|------------|----------------|------|-------|---------------------|--------------|-----------|
| 1          | Toyota Corolla | car  | 2022  | ABC-123             | 50.00        | available |



### Query 4: GROUP BY & HAVING – Vehicles with More Than 2 Bookings
```sql
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
```
**Sample Result:**

| vehicle_name | total_bookings |
|--------------|----------------|
| Honda Civic  | 3              |





## Files in This Repository

- `queries.sql` – Contains all four required SQL queries (exactly as shown above)
- `README.md` – This project documentation

## Technologies Used

- PostgreSQL
- Standard SQL (JOIN, NOT EXISTS, WHERE, GROUP BY, HAVING)

This submission strictly adheres to the assignment guidelines, using only the required SQL (postgresql) concepts and matching all expected outputs.

---
**Submitted for Database Assignment – Vehicle Rental System**  
*Submission Date: December 23, 2025*