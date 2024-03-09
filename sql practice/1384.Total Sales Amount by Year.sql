/* 1384. Total Sales Amount by Year
Solved
Hard
Topics
SQL Schema
Pandas Schema
Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key (column with unique values) for this table.
product_name is the name of the product.
 

Table: Sales

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key (column with unique values) for this table. 
period_start and period_end indicate the start and end date for the sales period, and both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.
The dates of the sales years are between 2018 to 2020.
 

Write a solution to report the total sales amount of each item for each year, with corresponding product_name, product_id, report_year, and total_amount.

Return the result table ordered by product_id and report_year.

The result format is in the following example.

 

Example 1:

Input: 
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+
Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+
Output: 
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
Explanation: 
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively. */
# Write your MySQL query statement below
with recursive cte as (
    SELECT MIN(period_start) as date
     FROM Sales 
     UNION ALL
     SELECT DATE_ADD(date, INTERVAL 1 day)
     FROM CTE
     WHERE date <= ALL (SELECT MAX(period_end) FROM Sales)
)

select a.product_id,c.product_name
,LEFT(b.date,4) as report_year
-- ,year(b.date) as report_year
,sum(average_daily_sales) as total_amount
from sales as a
left join cte as b
on b.date between a.period_start and a.period_end
join product as c
on a.product_id = c.product_id
group by  a.product_id,c.product_name,year(date)
order by product_id, report_year


/* my version */
with recursive yrange as (
    select product_id 
        ,left(period_start,4) as starty
        ,left(period_end,4) as endy
    from sales
)

,yr as (
select product_id
      ,starty
from yrange
union all
select product_id
      ,starty + 1
from yr as a
where starty < (select endy from yrange as b where a.product_id = b.product_id)
)

,summary as (
select a.product_id
,c.product_name
,b.starty
,a.period_start
,a.period_end  
,a.average_daily_sales 
,case when b.starty = year(a.period_start) then a.period_start else DATE(CONCAT(b.starty,"-01-01")) end as dt0
,case when b.starty = year(a.period_end) then a.period_end else DATE(CONCAT(b.starty,"-12-31")) end as dt1
/* ,datediff(case when b.starty = year(a.period_end) then a.period_end else DATE(CONCAT(b.starty,"-12-31")) end ,case when b.starty = year(a.period_start) then a.period_start else DATE(CONCAT(b.starty,"-01-01")) end) as days */
from sales as a
join yr as b
on a.product_id = b.product_id
join product as c
on a.product_id = c.product_id
)
select product_id
,product_name
,starty as report_year
,(datediff(dt1,dt0)+1)*average_daily_sales as total_amount
from summary