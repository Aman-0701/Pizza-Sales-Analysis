create database pizza_project;

use pizza_project

select * from order_details;

select * from pizzas

select * from orders

select * from pizza_types;

-- total no of orders placed

select count(distinct order_id) as 'Total Orders' from orders

-- total no of orders placed by date 
select count(distinct order_Id) as total_orders_placed ,date
from orders
group by date order by total_orders_placed desc;

--total revenue generated from pizza sales

with cte
AS
(select o.pizza_id, o.quantity, p.price
from order_details o
join pizzas p on p.pizza_id=o.pizza_id)

select concat('$',cast(sum(price*quantity)/1000000 as decimal(10,2)),'M') as Total_Sales from cte;



select * from pizzas

select * from pizza_types;

--highest priced pizza

select top 1 p2.name as Pizza_name, concat('$',cast(p1.price as decimal(10,2))) as Price
from pizzas p1
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
order by p1.price desc

-- Second method

with cte
as
(select p2.name as pizza_name, cast(p1.price as decimal(10,2)) as price,
rank() over(order by p1.price desc) as rnk
from pizzas p1
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id)
select * from cte where rnk=1

-- Identify the most common pizza size ordered.

select p.size,count(distinct o.order_id) as no_of_orders,sum(o.quantity) as Total_quantity
from order_details o
join pizzas p on o.pizza_id=p.pizza_id
group by p.size
order by no_of_orders desc


-- List the top 5 most ordered pizza types along with their quantities.

select top 5 p2.name as pizza_name,sum(o.quantity) as no_of_quantities_ordered
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.name
order by no_of_quantities_ordered desc

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select p2.category as pizza_category,sum(o.quantity) as no_of_quantities_ordered
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.category
order by no_of_quantities_ordered desc;

select * from order_details;

select * from pizzas

select * from orders

select * from pizza_types;

-- Determine the distribution of orders by hour of the day.

select count(distinct order_id) orders, datepart(hour,time) as hour
from orders 
group by datepart(hour,time)
order by orders desc

-- find the category-wise distribution of pizzas

select category, count(distinct pizza_type_id) as no_of_pizzas 
from pizza_types
group by category
order by no_of_pizzas desc

-- Calculate the average number of pizzas ordered per day.
with cte
as
(select count(distinct o1.order_id) no_of_orders,sum(o1.quantity) total_quantity ,o2.date 
from order_details o1
join orders o2 on o1.order_id=o2.order_id
group by o2.date)
select avg(total_quantity) as avg_no_of_pizzas_ordered_per_day from cte;

-- Determine the top 3 most ordered pizza types based on revenue.

select top 3 p2.name as pizza_name, count(distinct o.order_id) as no_of_orders, cast(sum(p1.price*o.quantity) as decimal(10,2)) as price
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.name
order by price desc;


with cte
AS
(select p2.name as pizza_name, count(distinct o.order_id) as no_of_orders, cast(sum(p1.price*o.quantity) as decimal(10,2)) as price
,rank() over(order by sum(p1.price*o.quantity) desc) as rnk
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.name) 

select pizza_name, price from cte where rnk<=3;

-- Calculate the percentage contribution of each pizza type to total revenue.

select p2.name as pizza_name, count(distinct o.order_id) as no_of_orders,  concat(cast(sum(p1.price*o.quantity)/(select sum(p1.price*o.quantity)
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id) as decimal(10,2))*100,'%') as '% Contribution'
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.name;

-- Analyze the cumulative revenue generated over time.

with cte
AS
(select o2.date as Date, cast(sum(o1.quantity*p1.price) as decimal(10,2)) as Revenue
from order_details o1
join pizzas p1 on o1.pizza_id=p1.pizza_id
join orders o2 on o1.order_id=o2.order_id
group by o2.date)

select Date, Revenue, sum(Revenue) over(order by date) as cummultive_sum
from cte
group by Date, Revenue;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with cte
AS
(select sum(p1.price*o.quantity) as Price, p2.name,p2.category
from order_details o
join pizzas p1 on o.pizza_id=p1.pizza_id
join pizza_types p2 on p1.pizza_type_id=p2.pizza_type_id
group by p2.name,p2.category),

cte1 as
(select name, category, Price, rank() over(partition by category order by price desc) as rnk
from cte)

select name, category, price from cte1 where rnk<=3 order by category,name,price







