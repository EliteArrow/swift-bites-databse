# SWIFT BITES

*A Food Delivery System*

### Project Definition :

- Led the creation of a Relational Database Management System (RDBMS) for "Swift Bites", a food delivery platform like DoorDash and UberEats, utilizing SQL and managing key business data.
- Designed an Entity-Relationship (ER) diagram to model data, and normalized the database for optimal structure.
- Wrote SQL queries for database and table creation, implemented Python scripts to generate and insert dummy data.
- Devised SQL queries for business insights and implemented update queries to achieve business goals, with validation checks ensuring goal fulfillment.

### Content of Each directory:

1. Phase 1: A report about project definition and what data being captured for business
2. Phase 2: A ER diagram for captured data
3. Phase 3: A Relational Mapping which is derived from ER diagram. Final relations with BCNF normalization applied
4. Phase 4: Create tables SQL query, Drop tables SQL query, Business goals SQL query and Update tables SQL query
    
    Phase 4 directory also contains pre generated business goals outputs for verification purpose only(Directory Output and Updated Output)
    
5. Python Script: A python script convert csv data into SQL insert query for future real world use

### Steps:

1. Check Phase 1, Phase 2 and Phase 3 for documentation (Optional)
2. Create a new database ‘Swift bites’ (Choose any name for database )

```sql
CREATE DATABASE Swift_Bites;
```

1. Select Created database ‘Swift_Bites’

```sql
USE Swift_Bites;
```

1. Create tables running using DB_create_tables.sql (Phase 4 Directory)
2. Insert data all tables using DB_insert_data.sql (Phase 4 Directory)
3. Check business goals using DB_business_goals_queries.sql (Phase 4 Directory)
    
    It will show 20 results for predefined business goals
    
4. Update data in tables using DB_update.sql (Phase 4 Directory)
5. Perform step 6 again to check output of some results will be changed due to data modification
6. Drop all tables using DB_drop_tables.sql (Phase 4 Directory)(optional)

### Real world data:

- Project can be modified to use for real world data
- Check all documentation to see what type of data required for this project
- Insert data into  all corresponding csv files (Python Script Directory)
- Open SQL Script.ipynb from Python Script directory
- Run each block of this jupyter notebook to convert each csv data into SQL insert query
- Perform create database, create tables and insert query(generated from script), and finally run business goals query.sql to get analysis for real world data

### Data is being captured

1. **RestaurantData:** Contains key details about each restaurant on the platform, including its unique ID, name, location (apartment, street, city, state, and ZIP code), contact details (phone number and email), and operating hours.
2. **RestaurantFacility:** Stores information about different facilities offered by each restaurant, linked to the RestaurantData table through the restaurant_id foreign key.
3. **ItemData:** Details all items available on the platform, including item ID, restaurant ID (indicating the restaurant that offers the item), item name, type of cuisine, price, calorie content, item type, and preparation time.
4. **CustomerData:** Maintains data for each customer, such as the customer ID, name, email, contact number, address, ZIP code, date of birth, and date when they joined the platform.
5. **CustomerFavouriteFood:** Stores the favorite food choices of customers. The customer_id field acts as a foreign key, linking this table to the CustomerData table.
6. **EmployeeData:** Keeps records of all employees (delivery persons), including their ID, name, address, ZIP code, date of birth, gender, contact number, pay per hour, and total working hours.
7. **OrdersData:** Manages all orders placed on the platform. Each record includes details about the order ID, customer ID, restaurant ID, employee ID, order and delivery times, charges, distances, estimated and actual times of events, payment type, order status, and tip amount.
8. **OrderHasItems:** Connects the orders with their respective items, indicating the quantity of each item in the order.
9. **ReviewsData:** Stores all reviews given by customers, including the review ID, customer ID, employee ID, restaurant ID, and rating (1 to 5). This data can help you understand customer feedback about your service.

![Relational Mapping of Database to Understand relations](https://raw.githubusercontent.com/EliteArrow/swift-bites-databse/main/Phase%203/Relational%20Mapping.png)

Relational Mapping of Database to Understand relations

### Business Goals:

1. **Determine top restaurants by order volume** for resource allocation and marketing.
2. **Identify frequently ordered food** items for inventory management and promotions.
3. **Pinpoint busiest areas by order count** to optimize delivery personnel allocation.
4. **Compute average restaurant ratings** to measure customer satisfaction and guide improvements.
5. **Evaluate delivery employees based on ratings, working hours, order count, and average tips** for performance reviews.
6. **Calculate average delivery time per restaurant** for process efficiency.
7. **Identify top customers by order** frequency for personalized promotions and rewards.
8. **Analyze order volume distribution throughout the day** for optimal staffing.
9. **Find peak order hours per zip code** for efficient resource management.
10. **Determine most popular cuisine type each quarter** for menu planning and marketing.
11. **Track new customers each quarter** for trend analysis and marketing adaptation.
12. **Identify preferred cuisine per state** for targeted marketing and partnership decisions.
13. **Measure average monthly orders per restaurant** for sales forecasting and resource management.
14. **Identify potential fraudulent customer** behavior for risk mitigation.
15. **Determine average order processing time per restaurant** for service improvement.
16. **Generate detailed sales reports per restaurant** for revenue analysis and menu planning.
17. **Identify top 10 items in terms of sales** for benchmarking and competitive analysis.
18. **Match number of delivery personnel to order volume in each zip code** for efficient service management.
19. **Find customers' preferred payment method per quarter** to improve payment systems and marketing.
20. **Analyze customer preferences and behaviors** to develop a personalized recommendation engine for enhanced engagement.
