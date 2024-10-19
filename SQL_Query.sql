#toUSE databaseUSE dataspark;SELECT *
FROM   customers;SELECT *
FROM   products;SELECT *
FROM   stores;SELECT *
FROM   exchange_rates;SELECT *
FROM   sales;


SELECT *
FROM   customers AS c
       INNER JOIN sales AS s1
               ON s1.customerkey = c.customerkey -- First alias for sales
       INNER JOIN products AS p
               ON s1.productkey = p.productkey
       -- Second alias for Joined products table
       INNER JOIN stores AS st
               ON s1.storekey = st.storekey
-- Third alias for Joined stores table
LIMIT  0, 200000;

SELECT gender,
       continent,
       Count(customerkey) AS CustomerCount
FROM   customers
GROUP  BY gender,
          continent
ORDER  BY customercount DESC; 

SELECT country,
       CASE
         WHEN Year(Curdate()) - Year(birthday) < 25 THEN 'Under 25'
         WHEN Year(Curdate()) - Year(birthday) BETWEEN 25 AND 40 THEN '25-40'
         WHEN Year(Curdate()) - Year(birthday) BETWEEN 41 AND 58 THEN '41-58'
         ELSE 'Above 59'
       END                AS AgeGroup,
       Count(customerkey) AS CustomerCount
FROM   customers
WHERE  birthday IS NOT NULL
GROUP  BY country,
          agegroup
ORDER  BY customercount DESC; 

SELECT city,
       country,
       Count(customerkey) AS CustomerCount
FROM   customers
GROUP  BY city,
          country
ORDER  BY customercount DESC
LIMIT  5; 

SELECT subcategory,
       Sum(quantity) AS TotalPurchased
FROM   products AS p
       INNER JOIN sales AS s
               ON s.productkey = p.productkey
       INNER JOIN customers AS c
               ON c.customerkey = s.customerkey
WHERE  gender = 'Female'
GROUP  BY subcategory
ORDER  BY totalpurchased DESC 
LIMIT 3;

SELECT c.country,
       Date_format(s.order_date, '%Y-%m') AS OrderMonth,
       Count(s.order_number)              AS TotalOrders,
       Sum(s.quantity)                    AS TotalQuantitySold,
       Sum(s.quantity * p.unit_price_usd) AS TotalRevenueGenerated
FROM   sales s
       JOIN products p
         ON s.productkey = p.productkey
       JOIN customers c
         ON s.customerkey = c.customerkey
GROUP  BY c.country,
          Date_format(s.order_date, '%Y-%m')
ORDER  BY Date_format(s.order_date, '%Y-%m'),
          Sum(s.quantity) DESC; 

SELECT c.country,
       Round(Sum(s.quantity * p.unit_price_usd * er.exchange), 2) AS Total_Spent
FROM   sales s
       INNER JOIN products p
               ON s.productkey = p.productkey
       INNER JOIN customers c
               ON s.customerkey = c.customerkey
       INNER JOIN exchange_rates er
               ON s.order_date = er.date
GROUP  BY c.country
ORDER  BY total_spent DESC
LIMIT  5; 