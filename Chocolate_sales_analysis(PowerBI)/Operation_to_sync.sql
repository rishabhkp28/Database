SHOW DATABASES;
USE chocolate_sales;

SHOW TABLES;

ALter table sales_fact_table
RENAME TO sales_dimension

Select * from customer_dimension
Select * from sales_dimension
Select * from product_dimension

drop table final_table
CREATE TABLE final_table AS
(
    SELECT * 
    FROM (
        SELECT * 
        FROM product_dimension 
        NATURAL JOIN  sales_DIMENSION 
    ) AS temp 
    NATURAL JOIN customer_dimension )

    
-- we got a table with everythin combined--

--generating a column for PURCHASE

Select * from final_table
ALTER TABLE final_table
ADD COLUMN Total_Purchase INTEGER
    GENERATED ALWAYS AS (Quantity_Sold * COST) STORED;

Select * from final_table

--verifying the funnet chart--
SELECT Loyalty_Status, SUM(TOTAL_PURCHASE) 
FROM final_table
GROUP BY Loyalty_Status
ORDER BY SUM(TOTAL_PURCHASE) DESC;

--verifying the donut chart--
Select GENDER,SUM(TOTAL_PURCHASE) from final_table group by gender order by SUM(TOTAL_PURCHASE) desc

--making an  age column -- 
ALTER TABLE final_table
ADD COLUMN Age INT;

UPDATE final_table
SET DOB = STR_TO_DATE(DOB, '%d-%b-%y');

/*
%d: Day of the month as a two-digit number (01 to 31).
%m: Month as a two-digit number (01 to 12).
%b: Abbreviated month name (Jan, Feb, Mar, etc.).
%Y: Year as a four-digit number (e.g., 2024).
%y: Year as a two-digit number (00 to 99).*/

UPDATE final_table
SET Age = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
--in above statement first is the different unit ,initial and then current date

Select * from final_table

ALTER TABLE final_table
ADD COLUMN AGE_SEGMENT VARCHAR(10);

UPDATE final_table
SET age_segment = 
  CASE
    WHEN age >= 50 THEN 'Old'
    WHEN age >= 30 THEN 'Mid'
    ELSE 'Young'
  END;

SELECT AGE_SEGMENT,SUM(TOTAL_PURCHASE) FROM FINAL_TABLE group by age_segment
Select * from final_table
Select * from final_table order by total_purchase desc;

use chocolate_sales;
Select * from final_table


UPDATE final_table
SET Date = STR_TO_DATE(Date, '%m/%d/%Y');
/* the inner DATE_FORMAT gives the string format dd/mm/yr
while th other STR_TO_Date changes the date to dateformat YYYY_mm-_dd*/


Select * from final_table

CREATE Table linegraph
(
Select Brand,Year(Date),Month(Date),SUM(Quantity_Sold  * cost) AS Revenue from final_table group by Brand,Year(Date),Month(Date) order by Year(Date),Month(Date)
)
use chocolate_sales


--contains monthwise revenue of each chocolate type
Select * from linegraph


--lets make total sales by each chocolate type

Select Chocolate_Type,SUM(cost*Quantity_Sold) As Total_Sales from final_table group by Chocolate_Type

Alter table final_table
ADD COLUMN COST_SEGMENT VARCHAR(20)

UPDATE FINAL_TABLE SET COST_SEGMENT = 
CASE
  WHEN COST>150  THEN "VERY COSTLY"
  WHEN COST > 100 THEN "HIGH COST"
  WHEN COST > 50 THEN " AVERAGE COST"
  ELSE "INEXPENSIVE"
END


Use chocolate_sales
Select * from final_table order by DATE

Create table total_sales_by_month
(
SELECT 
    YEAR(date) AS year,         -- Extracts the year from the date
    MONTH(date) AS month,       -- Extracts the month from the date
    SUM(Total_Purchase) AS total_sales  -- Sums the total purchases for each year-month combination
FROM 
    final_table
GROUP BY 
    YEAR(date), MONTH(date)     -- Groups the results by year and month
ORDER BY 
    year, month desc                
)

Select * from total_sales_by_month order by month
/*The LAG function cannot be used directly within a GENERATED ALWAYS AS clause in MySQL, as 
LAG is a window function, and generated columns do not support window functions.*/



/*total sales by month only had year month and total_sales so i made a new table that also contains change in sales */
CREATE TABLE total_sales_by__month AS (
    SELECT 
        year,
        month,
        total_sales,
        (LAG(total_sales, 1, 0) OVER (ORDER BY year, month) - total_sales) * 100 / 
        NULLIF(LAG(total_sales, 1, 0) OVER (ORDER BY year, month), 0) AS change_in_sales  -- Using NULLIF to avoid division by zero
    FROM 
        total_sales_by_month
);

/*Used NULLIF(total_sales, 0) to prevent division by zero. 
If total_sales is zero, it returns NULL,
 avoiding a division error and returning NULL for change_in_sales in those cases.*/

drop table total_sales_by_month
Alter table total_sales_by__month
rename to total_sales_by_month

Select * from total_sales_by_month