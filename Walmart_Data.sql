drop database if exists walmartSales;

-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

use walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating DECIMAL(3,1)
);


-- upload the csv file to _secure_file_prev location (i.e- C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/) directory.
LOAD DATA  INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/walmart_dataset.csv' INTO TABLE sales FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 ROWS;

-- Adding a new column named time_of_day :
alter table sales
add column time_of_day datetime;

-- Adding a new column named day_name :
alter table sales
add column day_name date;

-- Adding a new column named month_name :
alter table sales
add column month_name date;

-- There are no null values in our database as in creating the tables, we set NOT NULL for each field, hence null values are filtered out.

-- How many unique cities does the data have?
select distinct city
from sales;

-- In which city is each branch?
select city, branch from sales
union 
select city, branch from sales;

-- How many unique product lines does the data have?
select distinct product_line
from sales;

-- What is the most common payment method?
select distinct payment
from sales;

-- What is the most selling product line?
select max(product_line) as most_selling from sales;  

-- What is the total revenue by month?
select month(date) as revenue_by_month, sum(total) as total from sales
group by month(date);

-- What month had the largest COGS?

select * from sales;

select month(date) as m_month, max(cogs) as max_cogs from sales
group by month(date)
order by max_cogs desc limit 1;

-- What product line had the largest revenue?
select product_line, sum(total) as revenue from sales
group by product_line
order by revenue desc limit 1;

-- What is the city with the largest revenue?
select city, sum(total) as revenue from sales
group by city
order by revenue desc limit 1;

-- What product line had the largest VAT?
select product_line, sum(tax_pct) as largest_vta from sales
group by product_line
order by largest_vta desc limit 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select product_line, branch from sales;

select distinct product_line,
	case
		when total > (select avg(total) from sales) then 'Good'
        else 'Bad'
	end as Good_Bad
from sales;

-- Which branch sold more products than average product sold?
select branch from sales
where quantity > (select avg(quantity) from sales) limit 1;

-- What is the most common product line by gender?
select max(gender) as most_selling from sales;

-- What is the average rating of each product line?
select product_line, avg(rating) as avg_rating from sales
group by product_line;

-- Number of sales made in each time of the day per weekday
select dayname(date) as day, time(time) as t_time from sales
group by day, t_time;

-- Which of the customer types brings the most revenue? 
select customer_type, sum(total) as revenue from sales
group by customer_type
order by revenue desc limit 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, sum(tax_pct) as largest_vta from sales
group by city
order by largest_vta desc limit 1;

-- Which customer type pays the most in VAT?
select customer_type, sum(tax_pct) as most_vta from sales
group by customer_type
order by most_vta desc limit 1;

-- How many unique customer types does the data have?
select distinct customer_type, count(customer_type) as count_cust from sales
group by customer_type;

-- How many unique payment methods does the data have?
select distinct payment, count(payment) as count_pay from sales
group by payment;

-- What is the most common customer type?
select max(customer_type) as common_cust from sales;

-- Which customer type buys the most?
select distinct customer_type, max(total) as most_buys from sales
group by customer_type 
order by most_buys desc limit 1;

-- What is the gender of most of the customers?
select gender, max(customer_type) as most_cust from sales
group by gender
order by most_cust desc limit 1;

-- What is the gender distribution per branch?
select branch, gender, count(*) as dist_per_branch from sales
group by branch, gender
order by branch, gender;

-- Which time of the day do customers give most ratings?

select time_format()


-- Which time of the day do customers give most ratings per branch?



-- Which day fo the week has the best avg ratings? 
select dayname(date) as day_of_week, avg(rating) as average_rating from sales
where rating is not null
group by day_of_week
order by average_rating desc limit 1;

-- Which day of the week has the best average ratings per branch?
select dayname(date) as day_of_week, branch, avg(rating) as average_rating from sales
where rating is not null
group by day_of_week, branch
order by average_rating desc limit 1;