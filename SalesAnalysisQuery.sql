--Data Exploration and Cleaning
SELECT * FROM retail_sales

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

SELECT *
FROM retail_sales
WHERE price_per_unit = 0;

UPDATE retail_sales
SET price_per_unit = NULL
WHERE price_per_unit = 0;

SELECT COUNT (*) as total_sale FROM retail_sales;

--Data Analysis and Business Key Problems

---Retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

---Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >=4
AND YEAR(sale_date) = 2022
AND MONTH(sale_date) = 11;

---Calculate the total sales for each category
SELECT category,
SUM(total_sale) as TotalSales
FROM retail_sales
GROUP BY category;

---Find the average age of customers who purchased items from the 'Beauty' category
SELECT category,
ROUND(AVG(age), 2) as Average_Age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

---Find all transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000
ORDER BY total_sale DESC;

---Find the total number of transactions made by each gender in each category
SELECT 
	category,
	gender,
	count(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY gender;

---Calculate the average sale for each month. Find out best selling month in each year.
SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1
ORDER BY year, month;

---Find the top 5 customers based on the highest total sales
SELECT TOP 5
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 
	customer_id
ORDER BY SUM(total_sale) DESC;

---Find the number of unique customers who purchased items from each category
SELECT
	category,
	count(DISTINCT customer_id) AS Total_Unique_Customers
FROM retail_sales
GROUP BY category;

---Create each shift and number of orders
WITH hourly_sale
AS
(
SELECT *, 
    CASE
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM
    retail_sales
)
SELECT 
	shift,
	COUNT (*) AS total_orders
FROM hourly_sale
GROUP BY shift;