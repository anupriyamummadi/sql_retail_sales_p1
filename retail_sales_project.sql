-- SQL Retail Sales Analysis- P1 

-- Create Table 
DROP TABLE IF EXISTS retail_sales; 
CREATE TABLE retail_sales(
				transactions_id	INT PRIMARY KEY, 
				sale_date DATE,	
				sale_time TIME, 	
				customer_id	INT,
				gender VARCHAR(15),
				age	INT, 
				category VARCHAR(15), 
				quantity	INT, 
				price_per_unit	FLOAT, 
				cogs FLOAT, 
				total_sale FLOAT
				); 
select * 
from retail_sales
limit 10

select count(*) from retail_sales 

-- Check null values in data 
select * from retail_sales 
where transactions_id is null 
	or sale_date is null 
	or sale_time is null 
	or customer_id is null 
	or gender is null  
	or category is null 
	or quantity is null 
	or price_per_unit is null 
	or cogs is null 
	or total_sale is null;

-- Data Cleaning - deleting the Null values 
Delete from retail_sales 
where transactions_id is null 
	or sale_date is null 
	or sale_time is null 
	or customer_id is null 
	or gender is null  
	or category is null 
	or quantity is null 
	or price_per_unit is null 
	or cogs is null 
	or total_sale is null;

-- Data Exploration

-- Check total number of sales 

select count(*)
from retail_sales 

--How many unique customers we have? 

select count(distinct customer_id) as total_sale 
from retail_sales 

-- How many categories we have? 

select distinct category as total_categories 
from retail_sales 


-- Data Analysis and Business key problems 

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * 
from retail_sales 
where sale_date = '2022-11-05'


-- Write an SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is atleast 4 in the month of Nov- 2022
select * 
from retail_sales 
where category = 'Clothing' and quantity >= 4  and to_char(sale_date, 'YYYY-MM')= '2022-11'

-- Write an SQL query to calculate the total sales (total_sale) for each category 

select category, sum(total_sale) as total_sales_per_category, count(*) as total_orders_per_category
from retail_sales 
group by category

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category 

select round(avg(age),2) as average_age 
from retail_sales 
where category ='Beauty'


-- Write a SQL query to find all transactions where the total_sales is greater than 1000
select * 
from retail_sales 
where total_sale > 1000


-- Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category
select category, gender, count(*) as total_transactions 
from retail_sales 
group by category, gender
order by category

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
select year, month,average_sale from 
(
select extract (year from sale_date) as year, 
		extract(month from sale_date) as month, 
		avg(total_sale) as average_sale, 
		rank() over (partition by extract (year from sale_date) order by avg(total_sale) desc) as ranking 
from retail_sales 
group by 1,2 
) as t
where ranking = 1

-- Write a SQL query to find the top 5 customers based on the highest sales 

select customer_id, sum(total_sale) as total_sales_per_customer
from retail_sales 
group by customer_id 
order by total_sales_per_customer desc 
limit 5


-- Write a SQL query to find the number of unique customers who purchased items from each category 
select category, count(distinct customer_id) as unique_customers
from retail_sales 
group by category 


-- Write a SQL query to create each shift and number of orders (Example morning <= 12, Afternoon between 12&17, evening > 17)
with hourly_shift as(
select * , 
case
	when extract (hour from sale_time)<= 12 then 'Morning'
	when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as Shift 
from retail_sales 
) 
select shift, count(*) as nr_of_orders 
from hourly_shift 
group by shift
