/* 2474. Customers With Strictly Increasing Purchases
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Orders

+--------------+------+
| Column Name  | Type |
+--------------+------+
| order_id     | int  |
| customer_id  | int  |
| order_date   | date |
| price        | int  |
+--------------+------+
order_id is the column with unique values for this table.
Each row contains the id of an order, the id of customer that ordered it, the date of the order, and its price.
 

Write a solution to report the IDs of the customers with the total purchases strictly increasing yearly.

The total purchases of a customer in one year is the sum of the prices of their orders in that year. If for some year the customer did not make any order, we consider the total purchases 0.
The first year to consider for each customer is the year of their first order.
The last year to consider for each customer is the year of their last order.
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Orders table:
+----------+-------------+------------+-------+
| order_id | customer_id | order_date | price |
+----------+-------------+------------+-------+
| 1        | 1           | 2019-07-01 | 1100  |
| 2        | 1           | 2019-11-01 | 1200  |
| 3        | 1           | 2020-05-26 | 3000  |
| 4        | 1           | 2021-08-31 | 3100  |
| 5        | 1           | 2022-12-07 | 4700  |
| 6        | 2           | 2015-01-01 | 700   |
| 7        | 2           | 2017-11-07 | 1000  |
| 8        | 3           | 2017-01-01 | 900   |
| 9        | 3           | 2018-11-07 | 900   |
+----------+-------------+------------+-------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
+-------------+
Explanation: 
Customer 1: The first year is 2019 and the last year is 2022
  - 2019: 1100 + 1200 = 2300
  - 2020: 3000
  - 2021: 3100
  - 2022: 4700
  We can see that the total purchases are strictly increasing yearly, so we include customer 1 in the answer.

Customer 2: The first year is 2015 and the last year is 2017
  - 2015: 700
  - 2016: 0
  - 2017: 1000
  We do not include customer 2 in the answer because the total purchases are not strictly increasing. Note that customer 2 did not make any purchases in 2016.

Customer 3: The first year is 2017, and the last year is 2018
  - 2017: 900
  - 2018: 900
 We do not include customer 3 in the answer because the total purchases are not strictly increasing. */
 # Write your MySQL query statement below
with recursive yearcte as (
    select customer_id
    , MIN(YEAR(ORDER_DATE)) as order_year
    , max(year(order_date)) as last_year
    from orders
    group by customer_id

    union all

    select customer_id
    ,order_year + 1 as order_year
    ,last_year
    from yearcte
    where order_year < last_year

)

,pricecte as (
select a.customer_id
,a.order_year
,ifnull(sum(b.price),0) as price
,lag(ifnull(sum(b.price),0),1,0) over (partition by a.customer_id order by order_year) as prev_price
,row_number() over (partition by a.customer_id order by a.order_year) as rnk1
from yearcte as a
left join orders as b
on a.customer_id = b.customer_id
and a.order_year = year(b.order_date)
group by a.customer_id,a.order_year
)

select customer_id 
from (
select *,price - prev_price as diff
 , case when price - prev_price > 0 then 1 else 0 end AS is_increasing
from pricecte 
) as t
group by customer_id
HAVING
    MIN(is_increasing) = 1;
