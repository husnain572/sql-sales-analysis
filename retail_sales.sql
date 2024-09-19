CREATE TABLE retail_sales(
transactions_id integer primary key,
sale_date date,
sale_time time,
customer_id integer,
gender varchar(15),	
age integer,	
category varchar(15),
quantity integer,
price_per_unit INTEGER,
cogs DECIMAL,
total_sale INTEGER
);


SELECT * FROM RETAIL_SALES;

SELECT COUNT(*) AS TOTAL_ROWS FROM RETAIL_SALES ;

SELECT * FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL
OR
SALE_DATE IS NULL
OR
SALE_TIME IS NULL
OR
CUSTOMER_ID IS NULL
OR
GENDER IS NULL
OR
AGE IS NULL
OR
CATEGORY IS NULL
OR
QUANTITY IS NULL
OR
PRICE_PER_UNIT IS NULL
OR
COGS IS NULL
OR
TOTAL_SALE IS NULL;

-- DELETE THE NULL RECORDS
DELETE FROM RETAIL_SALES
WHERE TRANSACTIONS_ID IS NULL
OR
SALE_DATE IS NULL
OR
SALE_TIME IS NULL
OR
CUSTOMER_ID IS NULL
OR
GENDER IS NULL
OR
AGE IS NULL
OR
CATEGORY IS NULL
OR
QUANTITY IS NULL
OR
PRICE_PER_UNIT IS NULL
OR
COGS IS NULL
OR
TOTAL_SALE IS NULL;


-- DATA EXPLORATION
-- HOW MANY TOTAL CUSTOMERS WE HAVE
SELECT COUNT(CUSTOMER_ID) AS TOTAL_CUSTOMERS FROM RETAIL_SALES;
-- HOW MANY SALES WE HAVE
SELECT COUNT(*) AS TOTAL_SALE FROM RETAIL_SALES;
-- HOW MANY UNIQUE CUSTOMERS WE HAVE
SELECT COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS FROM RETAIL_SALES;
-- UNIQUE CATEGORIES WE HAVE
SELECT DISTINCT CATEGORY FROM RETAIL_SALES;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM RETAIL_SALES WHERE SALE_DATE ='2022-11-05';
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
    AND 
    TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT CATEGORY, SUM(TOTAL_SALE) AS TOTAL_SALE,COUNT(*) as total_orders FROM RETAIL_SALES
GROUP BY CATEGORY;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) as avg_age 
FROM RETAIL_SALES
WHERE CATEGORY='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM RETAIL_SALES
WHERE TOTAL_SALE >1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT GENDER, CATEGORY, COUNT(TRANSACTIONS_ID)
FROM RETAIL_SALES
GROUP BY GENDER, CATEGORY
ORDER BY 2;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM RETAIL_SALES;
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT CUSTOMER_ID, SUM(TOTAL_SALE) AS TOTAL_SUM FROM RETAIL_SALES
GROUP BY CUSTOMER_ID
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

