create database walmartproject;
use walmartproject;
create table sales(
	invoice_id varchar(30) Not null Primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date DATETIME not null,
    time TIME not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);

select * from sales;

SELECT * FROM walmartproject.sales;

/*-------------------------feature engineering------------------------------/*

/*----time_of_day-----*/
SELECT time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

Alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day = (
CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

/*------------------------day name---------------------------*/
select date , dayname(date) as day_name from sales;
alter table sales add column day_name varchar(10);
update sales set day_name = dayname(date);

/*------------------------month name-------------------------*/
select date, monthname(date) as month_name from sales;
alter table sales add column month_name varchar(10);
update sales set month_name = monthname(date);


/*---------------------------genric bussiness needs--------------------------*/

/*how many unique city are having walmart branch*/
select distinct city  as walmart_branches from sales;

/*In each city what walmart branches are there*/
select distinct branch from sales;
select distinct city , branch from sales;

/*-----------------------------------------product_based_needs---------------------------------------*/
/*how many unique products are in data*/
select count(distinct product_line) as count_of_products from sales;
select distinct product_line from sales;

/*what is the most common payment method*/
select payment_method,count(payment_method) as count from sales group by payment_method order by count desc ;

/*what is the most selling product line*/
select product_line ,count(product_line) as count from sales group by product_line order by count desc;
select product_line ,count(product_line) as count from sales group by product_line order by count desc limit 1 ;
select product_line ,count(product_line) as count from sales group by product_line order by count asc limit 1 ;


/*what is the total revenue by the month-to know which of the month has given good revenue*/
select month_name as month,sum(total) as total_revenue from sales group by month_name order by total_revenue desc;
select month_name as month,sum(total) as total_revenue from sales group by month_name order by total_revenue desc limit 1;
select month_name as month,sum(total) as total_revenue from sales group by month_name order by total_revenue asc limit 1;

/*what month had largest cost of goods*/
select month_name as month, sum(cogs) as cogs  from sales group by month_name order by cogs desc;
select month_name as month, sum(cogs) as cogs from sales group by month_name order by cogs desc limit 1;
select month_name as month, sum(cogs) as cogs from sales group by month_name order by cogs asc limit 1;

/* what product has largest revenue*/
select product_line , sum(total) as total_revenue from sales group by product_line order by total_revenue desc;
select product_line , sum(total) as total_revenue from sales group by product_line order by total_revenue desc limit 1;
select product_line , sum(total) as total_revenue from sales group by product_line order by total_revenue asc limit 1;

/*what is the city with largest revenue*/
select city , sum(total) as total_revenue from sales group by city order by total_revenue desc;
select city , sum(total) as total_revenue from sales group by city order by total_revenue desc limit 1;
select city , sum(total) as total_revenue from sales group by city order by total_revenue asc limit 1;

/*what product line has largest VAT*/
select product_line,avg(VAT) as avg_tax from sales group by product_line order by avg_tax desc;
select product_line,avg(VAT) as avg_tax from sales group by product_line order by avg_tax desc limit 1;
select product_line,avg(VAT) as avg_tax from sales group by product_line order by avg_tax asc limit 1;

/*which branch sold more products than average product sold*/
select branch,sum(quantity) as qty from sales group by branch having qty > (select avg(quantity) from sales);
select branch , sum(quantity) as qty from sales group by branch having qty > (select avg(quantity) from sales) order by qty desc limit 1;
select branch,sum(quantity) as qty from sales group by branch having qty > (select avg(quantity) from sales) order by qty asc limit 1;

/*what is the most common product famous by gender*/
select gender, product_line, count(gender) as total_count from sales group by gender, product_line order by total_count desc;
select gender, product_line, count(gender) as total_count from sales group by gender, product_line order by total_count asc;

/*what is the average rating for each product*/
select product_line , round(avg(rating),2) as avg_rating from sales group by product_line order by avg_rating desc;
select product_line , round(avg(rating),2) as avg_rating from sales group by product_line order by avg_rating desc limit 1;
select product_line , round(avg(rating),2) as avg_rating from sales group by product_line order by avg_rating asc limit 1;


/*--------------------------------------------sales needs--------------------------------------------*/

/*number of sales made in each time of the day per weekday*/
select time_of_day,count(*) as total_sale from sales where day_name ="Monday" group by time_of_day order by total_sale desc;
select time_of_day,day_name,count(*) as total_sale from sales group by time_of_day,day_name order by day_name;

/*what type of customers bring more revenue*/
select customer_type,sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;
select customer_type,sum(total) as total_revenue from sales group by customer_type order by total_revenue desc limit 1;
select customer_type,sum(total) as total_revenue from sales group by customer_type order by total_revenue asc limit 1;

/*which city has largest tax per/VAT*/
select city, avg(VAT) as VAT from sales group by city order by VAT desc;
select city, avg(VAT) as VAT from sales group by city order by VAT desc limit 1;
select city, avg(VAT) as VAT from sales group by city order by VAT asc limit 1;

/*which customer type pays the most VAT*/
select customer_type,avg(VAT) as VAT from sales group by customer_type order by VAT desc;

/*------------------------------------------customer needs--------------------------------------*/

/*how many unique customer types does data have*/
select distinct customer_type from sales;
select count(distinct customer_type) as unique_count_of_customers from sales;

/*how many unique payment methods does the data have*/
select distinct payment_method from sales;

/*what is the most common customer type / which customer type buys most*/
select customer_type,count(*) as count_of_type from sales group by customer_type order by count_of_type desc;
select customer_type,count(*) as count_of_type from sales group by customer_type order by count_of_type desc limit 1;
select customer_type,count(*) as count_of_type from sales group by customer_type order by count_of_type asc limit 1;

/*what is the gender of most of the customers*/
select gender,count(*) as count_of_gen from sales group by gender order by count_of_gen desc;

/*what is the gender distribution per branch*/
select branch,gender,count(*) as count_of_gen from sales group by branch,gender order by branch;
select branch,gender,count(*) as count_of_gen from sales group by branch,gender order by branch, count_of_gen desc;
select branch,gender,count(*) as count_of_gen from sales where branch ='C' group by gender order by count_of_gen;

/*what time of the day customers give most ratings*/
select time_of_day,avg(rating) as rating from sales group by time_of_day order by rating desc;
 
 /*what time of the day customers give most ratings by branch*/
 select branch,time_of_day,avg(rating) as rating from sales group by branch,time_of_day order by branch,rating;
 select branch,time_of_day,avg(rating) as rating from sales group by branch,time_of_day order by branch,rating desc;
 
 /*which day of the week has the best avg_rating*/
select day_name,avg(rating) as rating from sales group by day_name order by rating desc;
select day_name,avg(rating) as rating from sales group by day_name order by rating desc limit 1;
select day_name,avg(rating) as rating from sales group by day_name order by rating;

/*which day of the week has teh best average rating per branch*/
select branch,day_name,avg(rating) as rating from sales group by branch,day_name order by branch,rating desc;

SELECT 
    branch,
    day_name,
    avg_rating AS rating
FROM (
    SELECT 
        branch,
        day_name,
        AVG(rating) AS avg_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn
    FROM sales
    GROUP BY branch, day_name
) AS RankedRatings
WHERE rn = 1
ORDER BY branch;
