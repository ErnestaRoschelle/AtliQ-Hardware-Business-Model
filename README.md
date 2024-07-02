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

 SOLUTION:

 #### Learnings from this Stored Procedure

 #### 1. IN (Input Argument)

 #### 2. OUT (Output Argument)

 #### 3. How to write comments

 #### 4. How to set a defualt value

 #### 5. How to use IF Statement to find out the result of a condition

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
 






