# Vehicle Rental System - Database Design & SQL Queries

## Project Overview

This project implements a simple **Vehicle Rental System** database using **PostgreSQL**. The system manages users (customers and admins), vehicles (cars, bikes, trucks), and rental bookings. It demonstrates core relational database concepts including table design with primary/foreign keys, data integrity constraints, and fundamental SQL querying techniques.

The database consists of three main tables:
- **Users** – Stores user information with roles (Admin/Customer)
- **Vehicles** – Stores vehicle details with type, pricing, and availability status
- **Bookings** – Records rental bookings linking users to vehicles with dates, status, and total cost

The design fully supports the required business logic: unique emails and registration numbers, role-based access, vehicle availability tracking, and booking management.

## Database Schema Summary

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