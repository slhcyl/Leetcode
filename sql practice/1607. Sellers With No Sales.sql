/* 1607. Sellers With No Sales
Solved
Easy
Topics
SQL Schema
Pandas Schema
Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
Each row of this table contains the information of each customer in the WebStore.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| sale_date     | date    |
| order_cost    | int     |
| customer_id   | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the column with unique values for this table.
Each row of this table contains all orders made in the webstore.
sale_date is the date when the transaction was made between the customer (customer_id) and the seller (seller_id).
 

Table: Seller

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| seller_id     | int     |
| seller_name   | varchar |
+---------------+---------+
seller_id is the column with unique values for this table.
Each row of this table contains the information of each seller.
 

Write a solution to report the names of all sellers who did not make any sales in 2020.

Return the result table ordered by seller_name in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+--------------+---------------+
| customer_id  | customer_name |
+--------------+---------------+
| 101          | Alice         |
| 102          | Bob           |
| 103          | Charlie       |
+--------------+---------------+
Orders table:
+-------------+------------+--------------+-------------+-------------+
| order_id    | sale_date  | order_cost   | customer_id | seller_id   |
+-------------+------------+--------------+-------------+-------------+
| 1           | 2020-03-01 | 1500         | 101         | 1           |
| 2           | 2020-05-25 | 2400         | 102         | 2           |
| 3           | 2019-05-25 | 800          | 101         | 3           |
| 4           | 2020-09-13 | 1000         | 103         | 2           |
| 5           | 2019-02-11 | 700          | 101         | 2           |
+-------------+------------+--------------+-------------+-------------+
Seller table:
+-------------+-------------+
| seller_id   | seller_name |
+-------------+-------------+
| 1           | Daniel      |
| 2           | Elizabeth   |
| 3           | Frank       |
+-------------+-------------+
Output: 
+-------------+
| seller_name |
+-------------+
| Frank       |
+-------------+
Explanation: 
Daniel made 1 sale in March 2020.
Elizabeth made 2 sales in 2020 and 1 sale in 2019.
Frank made 1 sale in 2019 but no sales in 2020. */
# Write your MySQL query statement below
with sales2020 as (
select o.seller_id
from orders as o 
where year(o.sale_date) = 2020
)

select seller_name
from seller
where seller_id not in (select seller_id from sales2020)
order by 1

/*editoral*/
SELECT 
    seller_name
FROM (
    SELECT 
        seller_name, 
        SUM(CASE WHEN YEAR(sale_date) ='2020' THEN 1 ELSE 0 END) AS flag
    FROM 
        Seller s
    LEFT JOIN 
        Orders o
    ON 
        s.seller_id = o.seller_id
    GROUP BY 
        s.seller_id
)t0
WHERE 
    flag=0
ORDER BY 1 ASC

/*  option 2*/
SELECT 
    seller_name
FROM 
    Seller s
LEFT JOIN 
    Orders o
ON 
    s.seller_id = o.seller_id
GROUP BY 
    s.seller_id
HAVING 
    SUM(IFNULL(YEAR(sale_date)='2020',0)) = 0
ORDER BY 1 ASC

/* Write your T-SQL query statement below */
select seller_name
from seller
where seller_id not in 
(select seller_id
from orders
where datepart(year,sale_date) = 2020)
order by 1