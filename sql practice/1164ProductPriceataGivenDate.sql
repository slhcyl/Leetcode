/*1164. Product Price at a Given Date
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key (combination of columns with unique values) of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+*/
# Write your MySQL query statement below
with prod as (
select distinct product_id
from products
)

, prod_date as (
select a.product_id
    ,max(case when change_date <= '2019-08-16' then change_date end) as date 
from prod as a
left join products as b
on a. product_id = b.product_id
group by a.product_id
)

select a.product_id
    ,COALESCE(b.new_price,10) as price
from prod_date as a
left join products as b
on a.product_id = b.product_id
and a.date = b.change_date;

SELECT
  product_id,
  10 AS price
FROM Products
GROUP BY product_id
HAVING  MIN(change_date) > '2019-08-16'
UNION ALL
SELECT
  product_id,
  new_price AS price
FROM  Products
WHERE (product_id, change_date) IN (
    SELECT
      product_id,
      MAX(change_date)
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY
      product_id
  )

  -- Write your PostgreSQL query statement below
SELECT
  product_id,
  10 AS price
FROM
  Products
GROUP BY
  product_id
HAVING
  MIN(change_date) > '2019-08-16'
UNION ALL
SELECT
  product_id,
  new_price AS price
FROM
  Products
WHERE
  (product_id, change_date) IN (
    SELECT
      product_id,
      MAX(change_date)
    FROM
      Products
    WHERE
      change_date <= '2019-08-16'
    GROUP BY
      product_id
  )

  /* Write your T-SQL query statement below */
SELECT
  product_id,
  10 AS price
FROM Products
GROUP BY product_id
HAVING  MIN(change_date) > '2019-08-16'
UNION ALL
SELECT
  a.product_id,
  a.new_price AS price
FROM  Products AS a
INNER JOIN (
    SELECT
      product_id,
      MAX(change_date) as change_date
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY
      product_id
  ) as b
  on a.product_id = b.product_id
  and a.change_date = b.change_date

  /* Write your T-SQL query statement below */
SELECT
  product_id,
  10 AS price
FROM Products
GROUP BY product_id
HAVING  MIN(change_date) > '2019-08-16'
UNION ALL
SELECT
  a.product_id,
  a.new_price AS price
FROM  Products AS a,
(SELECT
      product_id,
      MAX(change_date) as change_date
    FROM Products
    WHERE change_date <= '2019-08-16'
    GROUP BY
      product_id
  ) as b
 where a.product_id = b.product_id
  and a.change_date = b.change_date