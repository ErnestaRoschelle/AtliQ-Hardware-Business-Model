*Project management tool*:JIRA
*Methodology used* : Kanban
## TASK 1
![Screenshot 2024-06-29 204559](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/0028beb0-8114-410d-b0d3-59dea198c7e3)

## SOLUTION

### step 1 : Creation of User-defined functions---> get_fiscal_year and get_fiscal_quarter

CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarter`(

 calender_date date
 
 ) RETURNS char(2) CHARSET utf8mb4
 
DETERMINISTIC
    
BEGIN

declare m tinyint;

declare qtr char(2);

set m=month(calender_date);

case

when m in (9,10,11) then set qtr="Q1";
 
when m in (12,1,2) then set qtr="Q2";
 
when m in (3,4,5) then set qtr="Q3";
 
else set qtr="Q4";
    
end case;

RETURN qtr;

END

-----------------------------

CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(

calender_date date

) RETURNS int

DETERMINISTIC
    
BEGIN

declare fiscal_year int;

set fiscal_year=year(date_add(calender_date ,interval 4 month));

return fiscal_year;

RETURN 1;

END

## MAIN QUERY

select  s.date,s.product_code,
      
 p.product,p.variant,
      
s.sold_quantity, g.gross_price,
      
 round(sold_quantity*gross_price,2) as gross_price_total
      
from fact_sales_monthly s

join dim_product p

on s.product_code=p.product_code
     
join fact_gross_price g 

on s.product_code=g.product_code and 
    
g.fiscal_year=get_fiscal_year(s.date)
       
where customer_code = 90002002

and get_fiscal_year(date)=2021

and get_fiscal_quarter(date)="Q4"

order by date asc

limit 1000000;

### Understanding of Jira Software:
![Screenshot 2024-06-29 204049](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/52ea1b90-e76e-4dcf-87f6-8300b549ec2c)

----------------------------------------------------------------------------
## TASK 2
![Screenshot 2024-06-30 113212](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/9b1ad29a-4c4f-4676-8058-6a65ec7abd1b)

### SOLUTION

select s.date,c.market,

 round(sum(sold_quantity*gross_price),2) as total_gross
       
 from fact_sales_monthly s
  
 join fact_gross_price g 
 
 on s.product_code=g.product_code and 
       
 g.fiscal_year=get_fiscal_year(s.date)
          
join dim_customer c

on s.customer_code=c.customer_code
       
where s.customer_code = 90002002 and c.market='India'

group by s.date
-----------------------------------------------------------------------
## TASK 3

Generate a yearly report for Croma India where there are two columns

1. Fiscal Year

3. Total Gross Sales amount In that year from Croma

SOLUTION

SELECT g.fiscal_year,

round(sum(s.sold_quantity*g.gross_price),2) as total_gross

from fact_gross_price g

join fact_sales_monthly s

on g.product_code=s.product_code and 

   g.fiscal_year=get_fiscal_year(s.date)
   
join dim_customer c

on s.customer_code=c.customer_code

   where c.customer='croma' and c.market='India'
   
group by g.fiscal_year;
-----------------------------------------------------------------------------------------------------------------
TASK 4 

Generate a yearly report for Ezone  India where there are two columns: Fiscal Year and  Total Gross Sales amount In that year
Generate a yearly report for AtliQ  India where there are two columns: Fiscal Year and  Total Gross Sales amount In that year 
Generate a yearly report for Amazon  India where there are two columns: Fiscal Year and  Total Gross Sales amount In that year 

SOLUTION
### By using Stored Procedure we can solve this task

Stored Procedure

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_gross_sales_for_customer`(

c_code text,

fiscal_yr year

)
BEGIN

select s.date,
       round(sum(sold_quantity*gross_price),2) as total_gross
       
  from fact_sales_monthly s
  
  join fact_gross_price g 
  
 on s.product_code=g.product_code and 
       
 g.fiscal_year=get_fiscal_year(s.date)
          
join dim_customer c

 on s.customer_code=c.customer_code
       
 where 
          
 find_in_set(s.customer_code,c_code)>0
          
 and get_fiscal_year(s.date)=fiscal_yr
         
group by s.date;

END

![Screenshot 2024-07-01 143705](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/4f730371-1878-4e5b-92c2-2b40ae0a6f3c)
#### type in many customer codes and the required fiscal year to query the result 

Sometimes Customer might have two customer_codes based on their business requirements ,
so in order to aggregate the gross_sales in a particular time period we use 
find_in set function in Stored Procedure


---------------------------------------------------------------------------------------------------------------

 TASK 5:
 
 ![Screenshot 2024-07-01 185820](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/28b0882e-bd7c-454e-869f-7cbf4a670f00)

 ### SOLUTION:

 #### Learnings from this Stored Procedure

1. IN (Input Argument)
   
2. OUT (Output Argument)

3. How to write comments
  
4. How to set a defualt value

5. How to use IF Statement to find out the result of a condition

#### STORED PROCEDURE:

CREATE DEFINER=`root`@`localhost` PROCEDURE `market_badge`(
 
IN in_market varchar(45),

IN in_fiscal_year year,

OUT out_badge varchar(45)

)

BEGIN

declare total_qty int default 0;

*set default market to be India*

if in_market="" then

set in_market="India";

end if;

*retrieve total qty for a given market and fyear*

select  sum(s.sold_quantity) into total_qty

 from fact_sales_monthly s
  
join dim_customer c
  
 on s.customer_code=c.customer_code
    
 where market =in_market and get_fiscal_year(s.date) = in_fiscal_year
 
 group by c.market;
  
   if total_qty > 5000000 then
        
   set out_badge = "Gold";
        
   else 
        
   set out_badge = "Silver";
         
   end if;
         
END


![Screenshot 2024-07-02 135143](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/60e08bec-b60b-4858-91e3-4d7b7f428a1c)
This pic shows the stored procedure calling input arguments


------------------------------------------------------------------------------------------------

### BENEFITS OF STORED PROCEDURE

1.Convinience  

2.security-limited access is given through stored procedure

3.Maintaintability - easier to read and is reused in other stored procedure

4.Performance - faster than native SQL queries

5.Developer Productivity - easy to reuse this stored procedure in anoter stored procedure


-----------------------------------------------------------------------------------

TASK 6

![Screenshot 2024-07-05 114048](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/f2ec504d-1e32-488d-b38c-f307117459bd)


### SOLUTION:

### *Query 1*

#### *Step1:To find the total gross price*

select s.date,s.product_code,
      
p.product,p.variant,
      
 s.sold_quantity, g.gross_price,
      
 round(sold_quantity*gross_price,2) as gross_price_total,pre.pre_invoice_discount_pct
      
from fact_sales_monthly s

join dim_product p

 on s.product_code=p.product_code
      
join fact_gross_price g 

 on s.product_code=g.product_code and 
      
g.fiscal_year=get_fiscal_year(s.date)
       
join fact_pre_invoice_deductions pre

 on pre.customer_code=s.customer_code and
      
 pre.fiscal_year=get_fiscal_year(s.date)

order by date asc

limit 1000000;

### *Query 2*

select  s.date,s.product_code,
       
   p.product,p.variant,
       
   s.sold_quantity, g.gross_price,
       
   round(sold_quantity*gross_price,2) as gross_price_total,
       
   pre.pre_invoice_discount_pct
       
 from fact_sales_monthly s
 
 join dim_product p
 
   on s.product_code=p.product_code
       
 join fact_gross_price g 
 
  on s.product_code=g.product_code and 
       
   g.fiscal_year=get_fiscal_year(s.fiscal_year)
        
 join fact_pre_invoice_deductions pre
 
   on pre.customer_code=s.customer_code and
   
   pre.fiscal_year=get_fiscal_year(s.fiscal_year)
    
 limit 1000000	;
 

![Screenshot 2024-07-05 200850](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/df73154e-9970-4072-bb31-7ab9d01870cf)

#### *duration taken to execute the first query was 23.45 sec* 
#### *duration taken by the second query (which used new date_table created ) was 2.2 sec*

### *QUERY OPTIMIZATION*

*EXPLAIN ANALYZE* is a profiling tool for your queries that will show you where MySQL spends time on your query and why

*1.Actual time to get first row (in milliseconds)*

*2.Actual time to get all rows (in milliseconds)*

*3.Actual number of rows read*

*4.Actual number of loops*

*DURATION  is the time taken by the query to execute*

*FETCH is the time taken to retrieve data from the database server*

### Query 3



select 

 s.date,s.product_code,
      
 p.product,p.variant,
      
 s.sold_quantity, g.gross_price,

 round(sold_quantity*gross_price,2) as gross_price_total,
      
 pre.pre_invoice_discount_pct
      
from fact_sales_monthly s

join dim_product p

 on s.product_code=p.product_code
      
join fact_gross_price g 

 on s.product_code=g.product_code and 
      
 g.fiscal_year=s.fiscal_year
       
join fact_pre_invoice_deductions pre

 on pre.customer_code=s.customer_code and
      
 pre.fiscal_year=s.fiscal_year
        
limit 1000000;

*this query uses a newly created column fiscal_year in fact_sales_monthly table which reduces more time than compared to the previous two queries*

#### *Step2:To find the pre invoice discount* 

We use *Common Table Expression* here,

with cte as (

select 

s.date,s.product_code,
      
 p.product,p.variant,

 s.sold_quantity, g.gross_price,
      
round(sold_quantity*gross_price,2) as gross_price_total,
      
 pre.pre_invoice_discount_pct
      
from fact_sales_monthly s

join dim_product p

on s.product_code=p.product_code
      
join fact_gross_price g 

 on s.product_code=g.product_code and 
      
 g.fiscal_year=s.fiscal_year
       
join fact_pre_invoice_deductions pre

on pre.customer_code=s.customer_code and
      
 pre.fiscal_year=s.fiscal_year
        
limit 1000000)

select * ,

(gross_price_total-gross_price_total*pre_invoice_discount_pct) as net_invoice_sales

from cte;

*Instead of CTE we can use *DATABASE VIEW* here,*

 ### *VIEW TABLE 1: pre_invoice_discount*

Query goes like this,

SELECT * ,

(gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales

 FROM gdb0041.pre_invoice_discount;

 #### Views are virtual tables when invoked produces a result set and are permanent objects in the database used to simplify complex queries for better maintainability and reusability.
 #### CTEs are temporary result sets used within the scope of a single query and are often used  for complex or recursive queries. 

### *VIEW TABLE 2 : post_invoice_discount*
 
 #### *Using this view ,we query to find out total post _invoice_discount*

SELECT *,

(1-post_invoice_discount_sales)*net_invoice_sales as net_sales

 FROM gdb0041.post_invoice_disount;
 
 *With the help of this query I created the third view table for net sales

### *VIEW TABLE 3 : NET SALES*


---------------------------------------------------------------------------------

TASK 7

Create a view for gross sales. It should have the following columns,

date, fiscal_year, customer_code, customer, market, product_code, product, variant,

sold_quanity, gross_price_per_item, gross_price_total


*created a view with the help of the query below*

SELECT s.date,

   s.fiscal_year,
       
   c.customer_code,
       
   c.customer,
       
   c.market,
       
   p.product,
       
   p.product_code,
       
   p.variant,
       
   s.sold_quantity,
       
   g.gross_price,
       
   round( s.sold_quantity*g.gross_price,2) as total_gross
      
FROM fact_sales_monthly s

join dim_customer c

   on s.customer_code=c.customer_code
     
join dim_product p

   on s.product_code=p.product_code
     
join fact_gross_price g 

  on s.product_code=g.product_code and 
     
   s.fiscal_year=g.fiscal_year

-----------------------------------------------------------------------------------------

TASK 8:

![Screenshot 2024-07-08 114609](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/e678c796-1f7d-4464-8f58-94954ca93809)


SOLUTION

SELECT market,

round(sum(net_sales)/1000000,2) as net_sales_million

 FROM gdb0041.net_sales
 
 where fiscal_year=2021
 
 group by market
 
 order by net_sales_million desc
 
 limit 5;

 *Using this query lets create a Stored procedure,so that each time a different fiscal year is entered*

#### *Stored procedure : get_top_n_markets_for_net_sales

 CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_markets_for_net_sales`(
 
in_fiscal_year int,

top_n int

)

BEGIN

SELECT market,

round(sum(net_sales)/1000000,2) as net_sales_million

 FROM gdb0041.net_sales
 
 where fiscal_year=in_fiscal_year
 
 group by market
 
 order by net_sales_million desc
 
 limit top_n;
 
END

#### *OUTPUT*

![Screenshot 2024-07-08 123301](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/26b07c41-e36c-4156-b9d1-9ca1d1f7a72c)

----------------------------------------------------------------------------------------------------

TASK 9

![Screenshot 2024-07-08 125505](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/a4709418-3ae9-443d-a37f-031e262745b7)

 select customer ,
 
 round(sum(net_sales)/1000000,2) as net_sales_million
 
 from net_sales ns
 
 join dim_customer c
 
   on ns.customer_code=c.customer_code
      
 where fiscal_year = 2021
 
 group by customer
 
 order by net_sales_million desc
 
 limit 3;

 #### *Using this query we create stored procedure for finding out top 'n' customers in a given market,fiscal year*

 CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_customer_net_sales`(
 
in_market varchar(45),

in_fiscal_year int,

in_top_n int)

BEGIN

 select customer ,
 
 round(sum(net_sales)/1000000,2) as net_sales_million
 
 from net_sales ns
 
 join dim_customer c
 
   on ns.customer_code=c.customer_code
      
 where fiscal_year = in_fiscal_year and ns.market=c.market
 
 group by customer
 
 order by net_sales_million desc
 
 limit in_top_n;
 
END

*OUTPUT*

![Screenshot 2024-07-08 124727](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/3872c66f-3a5e-43aa-bca8-3eb9e0812e2b)


 #### *note:*
 #### *in represents input parameteres in the stored procedure* 
 #### *Stored procedure is used to find top or bottom 'n'*

 -------------------------------------------------------------------------------

 TASK 10 - EXERCISE
 

 ![Screenshot 2024-07-08 125522](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/5c5faa3b-8a58-4fcb-b076-2fcdddb13b90)
 

 * Stored procedure to find the top n products*
   
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_products`(

in_fiscal_year int,

in_top_n int)

BEGIN

select product ,

 round(sum(net_sales)/1000000,2) as net_sales_million
 
 from net_sales ns
 
 where fiscal_year = in_fiscal_year
 
 group by product
 
 order by net_sales_million desc
 
 limit in_top_n;

END

*OUTPUT*

![Screenshot 2024-07-08 130529](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/3e0776e9-5278-4bdc-b439-bd2f4c85b8cd)


 
![image](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/2ba71044-c932-4f38-8c1f-8d612cfc8c3e)

![image](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/333d10e6-3c36-4fce-87c6-4bc066d837de)

----------------------------------------------------------------------------------------------

### Task 11

Learnings in this task

1.What are Window functions?

2.When to use them?

#### 1.Find out the % with respect to the total amount

SELECT *,

amount*100/sum(amount) over() as pct

FROM random_tables.expenses

order by category;

NOTE : Here over() is a window function and every row acts like a window

#### 2.Find out the % with respect to the total amount grouped by category

SELECT *,

amount*100/sum(amount) over(partition by category) as pct

FROM random_tables.expenses

order by category;

NOTE : Here OVER(PARTITION BY ...) is a window function and each category serves as a window

#### 3..Find out the amount spent with respect to category

SELECT *,

sum(amount) over(partition by category order by date) as total_till_date

FROM random_tables.expenses

order by date,category;

NOTE : Cumulative sum is adding the amount until all the amount has been added one by one 

example : Bank balance

#### 4.Display the top 10 customer  market share distribution

 with cte as (
 
 select customer ,
 
 round(sum(net_sales)/1000000,2) as net_sales_million
 
 from net_sales ns
 
 join dim_customer c
 
   on ns.customer_code=c.customer_code
      
 where fiscal_year = '2021'
 
 group by customer
 
 order by net_sales_million desc)
 
 select *,
 
 (net_sales_million*100)/sum(net_sales_million) over() as pct
 
 from cte
 
 order by net_sales_million desc;
 
![Screenshot 2024-07-10 212127](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/e41a9b9a-61e4-4036-9f53-fc30358c7e95)

-----------------------------------------------------------------------------------------


### 4. Display the market share with respect to Net Sales


![Screenshot 2024-07-11 135055](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/1a671379-bd95-47ca-a564-9360527badd2)


  with cte as (
  
 select customer , region,
 
 round(sum(net_sales)/1000000,2) as net_sales_million
 
 from net_sales ns
 
 join dim_customer c
 
   on ns.customer_code=c.customer_code
      
 where fiscal_year = '2021'
 
 group by customer,region 
 
 select *,
 
 (net_sales_million*100)/sum(net_sales_million) over(partition by region) as pct
 
 from cte
 
 order by region;
 
