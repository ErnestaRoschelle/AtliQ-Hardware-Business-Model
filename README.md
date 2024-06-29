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

Understanding of Jira Software:
![Screenshot 2024-06-29 204049](https://github.com/ErnestaRoschelle/AtliQ-Hardware-Business-Model/assets/145251891/52ea1b90-e76e-4dcf-87f6-8300b549ec2c)


