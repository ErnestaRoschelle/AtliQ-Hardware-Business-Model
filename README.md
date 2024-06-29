Creation of User-defined functions

**get_fiscal_year function** ---> to get the fiscal year 
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

**get_fiscal_quarter function**--->to get the transactions for each Quarters

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




