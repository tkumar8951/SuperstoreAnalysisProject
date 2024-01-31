--Q1 Establish the relationship between the tables as per the ER diagram
use SuperstoreDB
alter table OrdersList
add constraint pk_orderid primary key (OrderID)

alter table OrdersList
alter column OrderID nvarchar(255) not null

alter table EachOrderBreakdown
alter column OrderID nvarchar(255) not null

alter table EachOrderBreakdown
add constraint fk_orderid foreign key (OrderID) references OrdersList(OrderID)

--Q2. Split City State Country into 3 individual columns namely ‘City’, ‘State’, ‘Country’.

alter table OrdersList
add City nvarchar(255),
    State nvarchar(255),
    Country nvarchar(255);

update OrdersList
set City=PARSENAME(REPLACE([City State Country],',','.'),3),
    State=PARSENAME(REPLACE([City State Country],',','.'),2),
    Country=PARSENAME(REPLACE([City State Country],',','.'),1);

alter table OrdersList
drop column [City State Country];

select * from OrdersList
--Q3. Add a new Category Column using the following mapping as per the first 3 characters in the
Product Name Column:
a. TEC- Technology
b. OFS – Office Supplies
c. FUR - Furniture

select * from EachOrderBreakdown

alter table EachOrderBreakdown
add Category nvarchar(255)

update EachOrderBreakdown
set Category = case when left(ProductName,3)='OFS' then 'Office Supplies'
					when left(ProductName,3)='TEC' then 'Technology'
					when left(ProductName,3)='FUR' then 'Furniture'
				end;

--Q4.Delete the first 4 characters from the ProductName Column.

update EachOrderBreakdown
set ProductName= SUBSTRING(ProductName,5,LEN(ProductName)-4)

--Q5.Remove duplicate rows from EachOrderBreakdown table, if all column values are matching

with cte as (
select *, ROW_NUMBER() over (partition by OrderID,ProductName,Discount,Sales,Profit, Quantity,SubCategory,Category
							order by OrderID) as rn
							from EachOrderBreakdown
			)
delete from cte
where rn>1

