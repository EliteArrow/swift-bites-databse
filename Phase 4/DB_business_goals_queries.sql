-- 1. Identify the most popular restaurants (by orders)

SELECT 
    RestaurantData.restaurant_id, 
    RestaurantData.restaurant_Name, 
    COUNT(OrdersData.order_id) AS num_orders
FROM 
    RestaurantData
JOIN OrdersData ON RestaurantData.restaurant_id = OrdersData.restaurant_id
GROUP BY RestaurantData.restaurant_id
ORDER BY num_orders DESC;

-- 2. Find the most liked food items (by orders)

SELECT 
    ItemData.item_name, 
    COUNT(OrderHasItems.order_id) AS num_orders
FROM ItemData
JOIN OrderHasItems ON ItemData.item_id = OrderHasItems.item_id
GROUP BY ItemData.item_name
ORDER BY num_orders DESC;

-- 3. Determine the busiest areas (by zip code) in terms of the number of orders

SELECT emp.zip_code,
       COUNT(*) AS num_orders,
       emp_count.num_employees
FROM OrdersData ord
  JOIN EmployeeData emp ON ord.employee_id = emp.employee_id
  JOIN (SELECT zip_code,
               COUNT(*) AS num_employees
        FROM EmployeeData
        GROUP BY zip_code) emp_count ON emp.zip_code = emp_count.zip_code
GROUP BY emp.zip_code,
         emp_count.num_employees
ORDER BY num_orders DESC;

-- 4. Find out the average rating for each restaurant

SELECT 
    RestaurantData.restaurant_id, 
    RestaurantData.restaurant_Name, 
    AVG(ReviewsData.rating) AS average_rating
FROM RestaurantData
JOIN ReviewsData ON RestaurantData.restaurant_id = ReviewsData.restaurant_id
GROUP BY RestaurantData.restaurant_id
ORDER BY average_rating DESC;

-- 5. Find out top rated of delivery employee with their total working hours, total number of orders they delivered, average tip amount they received

SELECT 
    EmployeeData.employee_id, 
    EmployeeData.name, 
    AVG(ReviewsData.rating) AS average_rating, 
    SUM(EmployeeData.total_working_hours) AS total_working_hours,
    COUNT(OrdersData.order_id) AS total_orders, 
    AVG(OrdersData.tip_amount) AS average_tip
FROM EmployeeData
JOIN ReviewsData ON ReviewsData.employee_id = EmployeeData.employee_id
JOIN OrdersData ON OrdersData.employee_id = EmployeeData.employee_id
GROUP BY EmployeeData.employee_id
ORDER BY 
    average_rating DESC, 
    total_working_hours DESC, 
    total_orders DESC, average_tip DESC;

-- 6. Find the average delivery time per restaurant

SELECT 
    RestaurantData.restaurant_id, 
    RestaurantData.restaurant_Name, 
    AVG(TIMESTAMPDIFF(
        MINUTE, 
        OrdersData.out_for_delivery_time, 
        OrdersData.delivered_time)) AS average_delivery_time
FROM RestaurantData
JOIN OrdersData ON RestaurantData.restaurant_id = OrdersData.restaurant_id
GROUP BY RestaurantData.restaurant_id
ORDER BY average_delivery_time ASC;

-- 7. Identify the customers who order the most

SELECT 
    CustomerData.customer_id, 
    CustomerData.name, 
    COUNT(OrdersData.order_id) AS num_orders
FROM CustomerData
JOIN OrdersData ON CustomerData.customer_id = OrdersData.customer_id
GROUP BY CustomerData.customer_id
ORDER BY num_orders DESC;

-- 8. Find the distribution of order volumes throughout the day

SELECT 
    HOUR(order_time) AS hour_of_day, 
    COUNT(order_id) AS number_of_orders
FROM OrdersData
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- 9. Identify the peak order hour for each zip code

SELECT zip_code, hour_of_day, num_orders
FROM (
    SELECT 
        CustomerData.zip_code,
        HOUR(OrdersData.order_time) AS hour_of_day,
        COUNT(*) AS num_orders,
        ROW_NUMBER() OVER (PARTITION BY CustomerData.zip_code ORDER BY COUNT(*) DESC) as rn
    FROM OrdersData
    JOIN CustomerData ON OrdersData.customer_id = CustomerData.customer_id
    GROUP BY CustomerData.zip_code, hour_of_day) AS T
WHERE rn = 1;

-- 10. Identify the most popular cuisine type in each quarter

SELECT 'QUARTER 1' AS QUARTER,
       CUISINE,
       ORDER_COUNT
FROM (SELECT ID.cuisine_type AS CUISINE,
             COUNT(OI.quantity) AS ORDER_COUNT,
             DENSE_RANK() OVER (ORDER BY COUNT(OI.quantity) DESC) item_rank
      FROM OrdersData OD
      JOIN OrderHasItems OI ON OD.order_id = OI.order_id
      JOIN ItemData ID ON OI.item_id = ID.item_id
      WHERE OD.order_date BETWEEN '2022-01-01' AND '2022-03-31'
      GROUP BY ID.cuisine_type) as Q1
WHERE item_rank = 1
UNION
SELECT 'QUARTER 2' AS QUARTER,
       CUISINE,
       ORDER_COUNT
FROM (SELECT ID.cuisine_type AS CUISINE,
             COUNT(OI.quantity) AS ORDER_COUNT,
             DENSE_RANK() OVER (ORDER BY COUNT(OI.quantity) DESC) item_rank
      FROM OrdersData OD
      JOIN OrderHasItems OI ON OD.order_id = OI.order_id
      JOIN ItemData ID ON OI.item_id = ID.item_id
      WHERE OD.order_date BETWEEN '2022-04-01' AND '2022-06-30'
      GROUP BY ID.cuisine_type) as Q2
WHERE item_rank = 1
UNION
SELECT 'QUARTER 3' AS QUARTER,
       CUISINE,
       ORDER_COUNT
FROM (SELECT ID.cuisine_type AS CUISINE,
             COUNT(OI.quantity) AS ORDER_COUNT,
             DENSE_RANK() OVER (ORDER BY COUNT(OI.quantity) DESC) item_rank
      FROM OrdersData OD
      JOIN OrderHasItems OI ON OD.order_id = OI.order_id
      JOIN ItemData ID ON OI.item_id = ID.item_id
      WHERE OD.order_date BETWEEN '2022-07-01' AND '2022-09-30'
      GROUP BY ID.cuisine_type) as Q3
WHERE item_rank = 1
UNION
SELECT 'QUARTER 4' AS QUARTER,
       CUISINE,
       ORDER_COUNT
FROM (SELECT ID.cuisine_type AS CUISINE,
             COUNT(OI.quantity) AS ORDER_COUNT,
             DENSE_RANK() OVER (ORDER BY COUNT(OI.quantity) DESC) item_rank
      FROM OrdersData OD
      JOIN OrderHasItems OI ON OD.order_id = OI.order_id
      JOIN ItemData ID ON OI.item_id = ID.item_id
      WHERE OD.order_date BETWEEN '2022-10-01' AND '2022-12-31'
      GROUP BY ID.cuisine_type) as Q4
WHERE item_rank = 1;

-- 11. Track the number of new customers joining the service each quarter (Winter, Spring, Summer, and Fall)

WITH CustomerQuarter AS (
    SELECT
        customer_id,
        joined_date,
        CASE
            WHEN EXTRACT(MONTH FROM joined_date) BETWEEN 1 AND 3 THEN 'Winter'
            WHEN EXTRACT(MONTH FROM joined_date) BETWEEN 4 AND 6 THEN 'Spring'
            WHEN EXTRACT(MONTH FROM joined_date) BETWEEN 7 AND 9 THEN 'Summer'
            ELSE 'Fall'
        END AS quarter
    FROM
        CustomerData
),
QuarterCounts AS (
    SELECT
        EXTRACT(YEAR FROM joined_date) AS year,
        quarter,
        COUNT(customer_id) AS new_customer_count
    FROM
        CustomerQuarter
    GROUP BY
        EXTRACT(YEAR FROM joined_date),
        quarter
)
SELECT
    year,
    quarter,
    new_customer_count
FROM
    QuarterCounts
ORDER BY
    year,
    quarter;

-- 12. Identify the most preferred cuisine in a specific state (in this case, New Jersey)

SELECT ID.cuisine_type,
       COUNT(*) AS NUMBER_OF_ORDERS
FROM RestaurantData RD
  INNER JOIN ItemData ID ON RD.restaurant_id = ID.restaurant_id
WHERE RD.state = 'NJ'
GROUP BY ID.cuisine_type
ORDER BY NUMBER_OF_ORDERS DESC;

-- 13. Determine the average number of orders per month for each restaurant

SELECT 
    R.restaurant_id,
    ROUND(AVG(monthly_orders)) AS avg_orders_per_month
FROM 
    OrdersData R
JOIN
    (
    SELECT 
        O.restaurant_id,
        YEAR(O.order_date) AS year,
        MONTH(O.order_date) AS month,
        COUNT(*) AS monthly_orders
    FROM 
        OrdersData O
    GROUP BY 
        O.restaurant_id, YEAR(O.order_date), MONTH(O.order_date)
    ) AS T
ON 
    R.restaurant_id = T.restaurant_id
GROUP BY 
    R.restaurant_id;

-- 14. Identify potentially fraudulent customer

SELECT CUSTOMER_ID, NAME
FROM CustomerData
WHERE CUSTOMER_ID IN (SELECT CD.CUSTOMER_ID
                      FROM OrdersData OD,
                           CustomerData CD
                      WHERE OD.CUSTOMER_ID = CD.CUSTOMER_ID
                      AND   FLAG = 'suspicious'
                      GROUP BY CD.CUSTOMER_ID
                      HAVING COUNT(*) >= 2);

-- 15. Calculate the average processing time for each restaurant (from receiving an order to dispatching it for delivery)

SELECT restaurant_id,
AVG(EXTRACT(HOUR FROM (out_for_delivery_time - order_time))*60 +
    EXTRACT(MINUTE FROM (out_for_delivery_time - order_time)) +
    EXTRACT(SECOND FROM (out_for_delivery_time - order_time)) / 60)
AS avg_processing_time
FROM OrdersData
WHERE order_time IS NOT NULL
AND   out_for_delivery_time IS NOT NULL
GROUP BY restaurant_id;

-- 16. Generate detailed sales reports for a specific restaurant (in this case, 'R95')

SELECT order_date,
       (SELECT item_name
        FROM ItemData ID
        WHERE OI.item_id = ID.item_id) AS ITEM_NAME,
       SUM(quantity*price) AS TOTAL_SALES
FROM OrdersData OD,
     OrderHasItems OI,
     ItemData ID
WHERE OD.order_id = OI.order_id
AND   OI.item_id = ID.item_id
AND   OD.restaurant_id = 'R95'
GROUP BY order_date, OI.item_id;

-- 17. Identify the top 10 most successful items in terms of sales across all restaurants

WITH popular_items AS (
   SELECT 
      OHI.item_id AS it,
      SUM(OHI.quantity) AS total_quantity,
      SUM(OHI.quantity * ID.price) AS total_sales,
      DENSE_RANK() OVER (ORDER BY SUM(OHI.quantity) DESC) AS `RANK`
   FROM 
      OrderHasItems OHI
      JOIN ItemData ID ON OHI.item_id = ID.item_id
   GROUP BY 
      OHI.item_id
)
SELECT 
    ID.item_name, 
    RD.restaurant_name, 
    PI.total_sales
FROM 
    popular_items PI
    JOIN ItemData ID ON PI.it = ID.item_id
    JOIN RestaurantData RD ON RD.restaurant_id = ID.restaurant_id
WHERE 
    `RANK` <= 10
ORDER BY 
    total_sales DESC;

-- 18. Determine the number of delivery personnel available in each zip code and the corresponding number of orders in those areas

SELECT
    zc.zip_code,
    COALESCE(orders.total_orders, 0) AS orders_per_zip,
    COALESCE(emp_count.employee_count, 0) AS employees_per_zip
FROM
    (SELECT DISTINCT zip_code FROM CustomerData) zc
LEFT JOIN
    (SELECT
        c.zip_code,
        COUNT(o.order_id) AS total_orders
    FROM
        CustomerData c
    JOIN
        OrdersData o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.zip_code) orders
    ON zc.zip_code = orders.zip_code
LEFT JOIN
    (SELECT
        zip_code,
        COUNT(employee_id) AS employee_count
    FROM
        EmployeeData
    GROUP BY
        zip_code) emp_count
    ON zc.zip_code = emp_count.zip_code
ORDER BY
    zc.zip_code;

-- 19. FInd the customers' preferred payment method (Credit or Debit) for each quarter of the particular year(in this case 2022)

WITH PaymentOptions AS (
    SELECT
        order_id,
        order_date,
        CASE
            WHEN payment_type LIKE '%CREDIT%' THEN 'CREDIT'
            WHEN payment_type LIKE '%DEBIT%' THEN 'DEBIT'
            ELSE NULL
        END AS payment_option
    FROM
        OrdersData
    WHERE
        (payment_type LIKE '%CREDIT%' OR payment_type LIKE '%DEBIT%')
        AND EXTRACT(YEAR FROM order_date) = 2022
),
PaymentCount AS (
    SELECT
        payment_option,
        CASE
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3 THEN 1
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 2
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 3
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 10 AND 12 THEN 4
        END AS quarter,
        COUNT(order_id) AS total_orders
    FROM
        PaymentOptions
    GROUP BY
        payment_option,
        CASE
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 1 AND 3 THEN 1
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 2
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 3
            WHEN EXTRACT(MONTH FROM order_date) BETWEEN 10 AND 12 THEN 4
        END
)
SELECT
    quarter,
    SUM(CASE WHEN payment_option = 'CREDIT' THEN total_orders ELSE 0 END) AS credit_orders,
    SUM(CASE WHEN payment_option = 'DEBIT' THEN total_orders ELSE 0 END) AS debit_orders
FROM
    PaymentCount
GROUP BY
    quarter
ORDER BY
    quarter;

-- 20. Finding the preferences and behaviors of customers

SELECT 
    (SELECT ID.cuisine_type
    FROM OrdersData OD
    JOIN OrderHasItems OI ON OD.order_id = OI.order_id
    JOIN ItemData ID ON OI.item_id = ID.item_id
    GROUP BY ID.cuisine_type
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS Most_Preferred_Cuisine,
    
    (SELECT HOUR(order_time) AS hour_of_day
    FROM OrdersData
    GROUP BY hour_of_day
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS Most_Common_Ordering_Hour,
    
    (SELECT payment_type
    FROM OrdersData
    GROUP BY payment_type
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS Most_Preferred_Payment_Method;
