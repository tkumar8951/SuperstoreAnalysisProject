--Beginner

--1. List the top 10 orders with the highest sales from the EachOrderBreakdown table.
use SuperstoreDB
select top 10 * from EachOrderBreakdown
order by Sales desc;

--2. Show the number of orders for each product category in the EachOrderBreakdown table.
select Category, count(*) as NumberofOrders
from EachOrderBreakdown
group by Category

--3. Find the total profit for each sub-category in the EachOrderBreakdown table.
select SubCategory, sum(Profit) as total_profit
from EachOrderBreakdown
group by SubCategory

--Intermediate

--1. Identify the customer with the highest total sales across all orders.
select top 1 CustomerName, sum(sales) as total_sales
from OrdersList ol
join EachOrderBreakdown ob
on ol.OrderID=ob.OrderID
group by CustomerName
order by total_sales desc

--2. Find the month with the highest average sales in the OrdersList table.
select top 1 MONTH(OrderDate) as Month, AVG(Sales) as average_sales
from OrdersList ol
join EachOrderBreakdown ob
on ol.OrderID=ob.OrderID
group by Month(OrderDate)
order by average_sales desc

--3. Find out the average quantity ordered by customers whose first name starts with an alphabet 's'?
select AVG(Quantity) as Average_Quantity
from OrdersList ol
join EachOrderBreakdown ob
on ol.OrderID=ob.OrderID
where LEFT(CustomerName,1)='s'

--Advanced

--1. Find out how many new customers were acquired in the year 2014?
select count(*) as NumberOfNewCustomers from
(select CustomerName, MIN(OrderDate) as First_Order_Date
from OrdersList
group by CustomerName
having YEAR(MIN(OrderDate))='2014') as CustomerWithFirstOrderIn2014

--2. Calculate the percentage of total profit contributed by each sub-category to the overall profit.
select SubCategory,SUM(Profit) as SubCategoryProfit,
sum(Profit)/(select sum(Profit) from EachOrderBreakdown) * 100 as PercentageOfTotalContribution
from EachOrderBreakdown
group by SubCategory

--3. Find the average sales per customer, considering only customers who have made more than one order.

with CustomerAvgSales as (
select CustomerName, COUNT(DISTINCT ol.OrderID) as NumberOfOrders, AVG(Sales) as AverageSales
from OrdersList ol
join EachOrderBreakdown ob
on ol.OrderID=ob.OrderID
group by CustomerName)
select CustomerName, AverageSales
from CustomerAvgSales
where NumberOfOrders>12

--4. Identify the top-performing subcategory in each category based on total sales. Include the subcategory name, total sales, and a ranking of sub-category within each category.

with TopSubCategory as (
select Category,SubCategory, SUM(Sales) as SumOfSales,
RANK() over(partition by Category order by sum(Sales) desc) as SubCategoryRank
from EachOrderBreakdown
group by Category,SubCategory
)
select * from TopSubCategory
where SubCategoryRank = 1

