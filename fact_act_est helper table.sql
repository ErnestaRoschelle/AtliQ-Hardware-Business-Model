

create table fact_act_est -- Helper table to get sales qty and frct qty in a single table
	(
        	select 
                    s.date as date,
                    s.fiscal_year as fiscal_year,
                    s.product_code as product_code,
                    s.customer_code as customer_code,
                    s.sold_quantity as sold_quantity,
                    f.forecast_quantity as forecast_quantity
        	from 
                    fact_sales_monthly s
        	left join fact_forecast_monthly f 
        	using (date, customer_code, product_code)
	)
	union
	(
        	select 
                    f.date as date,
                    f.fiscal_year as fiscal_year,
                    f.product_code as product_code,
                    f.customer_code as customer_code,
                    s.sold_quantity as sold_quantity,
                    f.forecast_quantity as forecast_quantity
        	from 
		    fact_forecast_monthly  f
        	left join fact_sales_monthly s 
        	using (date, customer_code, product_code)
	);



-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Update the table
UPDATE fact_act_est
SET sold_quantity = 0
WHERE sold_quantity IS NULL;

update fact_act_est
set forecast_quantity = 0
where forecast_quantity is null;

-- Re-enable safe update mode
SET SQL_SAFE_UPDATES = 1;
