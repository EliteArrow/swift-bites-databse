-- 1. RESTAURANT DATA
CREATE TABLE RestaurantData (
    restaurant_id VARCHAR(50) PRIMARY KEY,
    restaurant_Name VARCHAR(100) NOT NULL,
    apartment_Building VARCHAR(50),
    street VARCHAR(50),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zipCode VARCHAR(20) NOT NULL,
    contact_No VARCHAR(20) NOT NULL UNIQUE,
    contact_Email VARCHAR(100) NOT NULL UNIQUE,
    operating_Hours VARCHAR(50)
);

-- 2. RESTAURANT FACILITY
CREATE TABLE RestaurantFacility (
    restaurant_id VARCHAR(50) NOT NULL,
    facility VARCHAR(50) NOT NULL,
    PRIMARY KEY(restaurant_id, facility),
    FOREIGN KEY(restaurant_id) REFERENCES RestaurantData(restaurant_id)
);

-- 3. ITEM DATA
CREATE TABLE ItemData (
    item_id VARCHAR(10) PRIMARY KEY,
    restaurant_id VARCHAR(10),
    item_name VARCHAR(50) NOT NULL,
    cuisine_type VARCHAR(20) NOT NULL,
    price VARCHAR(20),
    calories VARCHAR(20),
    item_type VARCHAR(15) NOT NULL,
    preparation_time VARCHAR(10),
    FOREIGN KEY(restaurant_id) REFERENCES RestaurantData(restaurant_id)
);

-- 4. CUSTOMER DATA
CREATE TABLE CustomerData(
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    contact_number VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    dob DATE,
    joined_date DATE
);

-- 5. CUSTOMER FAVOURITE FOOD
CREATE TABLE CustomerFavouriteFood(
    customer_id VARCHAR(10) NOT NULL,
    favorite_foods VARCHAR(255) NOT NULL,
    PRIMARY KEY(customer_id, favorite_foods),
    FOREIGN KEY(customer_id) REFERENCES CustomerData(customer_id)
);

-- 6. EMPLOYEE DATA
CREATE TABLE EmployeeData (
    employee_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(255) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    contact_number VARCHAR(20) UNIQUE NOT NULL,
    pay_per_hour VARCHAR(10),
    total_working_hours VARCHAR(10)
);

-- 7. ORDERS DATA
CREATE TABLE OrdersData(
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    restaurant_id VARCHAR(10) NOT NULL,
    employee_id VARCHAR(10) NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    delivery_charges VARCHAR(20),
    distance_from_restaurant VARCHAR(20),
    prepared_time TIME,
    out_for_delivery_time TIME,
    delivered_time TIME,
    pick_up_time TIME,
    estimated_delivery_time VARCHAR(10),
    completion_time TIME,
    cancellation_time TIME,
    refund_time TIME,
    payment_type VARCHAR(20),
    flag VARCHAR(20),
    tip_amount VARCHAR(20),
    FOREIGN KEY(customer_id) REFERENCES CustomerData(customer_id),
    FOREIGN KEY(employee_id) REFERENCES EmployeeData(employee_id),
    FOREIGN KEY(restaurant_id) REFERENCES RestaurantData(restaurant_id)
);

-- 8. ORDERS HAS ITEMS
CREATE TABLE OrderHasItems(
    order_id VARCHAR(10) NOT NULL,
    item_id VARCHAR(10) NOT NULL,
    quantity INT,
    PRIMARY KEY(order_id, item_id),
    FOREIGN KEY(order_id) REFERENCES OrdersData(order_id),
    FOREIGN KEY(item_id) REFERENCES ItemData(item_id)
);

-- 9. REVIEWS DATA
CREATE TABLE ReviewsData (
    review_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    employee_id VARCHAR(10),
    restaurant_id VARCHAR(10),
    rating INT NOT NULL CHECK (
        rating = 1
        OR rating = 2
        OR rating = 3
        OR rating = 4
        OR rating = 5
    ),
    FOREIGN KEY(customer_id) REFERENCES CustomerData(customer_id),
    FOREIGN KEY(employee_id) REFERENCES EmployeeData(employee_id),
    FOREIGN KEY(restaurant_id) REFERENCES RestaurantData(restaurant_id)
);