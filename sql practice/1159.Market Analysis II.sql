/* 1159. Market Analysis II
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| join_date      | date    |
| favorite_brand | varchar |
+----------------+---------+
user_id is the primary key (column with unique values) of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| order_date    | date    |
| item_id       | int     |
| buyer_id      | int     |
| seller_id     | int     |
+---------------+---------+
order_id is the primary key (column with unique values) of this table.
item_id is a foreign key (reference column) to the Items table.
buyer_id and seller_id are foreign keys to the Users table.
 

Table: Items

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| item_id       | int     |
| item_brand    | varchar |
+---------------+---------+
item_id is the primary key (column with unique values) of this table.
 

Write a solution to find for each user whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no. It is guaranteed that no seller sells more than one item in a day.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2019-01-01 | Lenovo         |
| 2       | 2019-02-09 | Samsung        |
| 3       | 2019-01-19 | LG             |
| 4       | 2019-05-21 | HP             |
+---------+------------+----------------+
Orders table:
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2019-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2019-08-04 | 1       | 4        | 2         |
| 5        | 2019-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+
Items table:
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
Output: 
+-----------+--------------------+
| seller_id | 2nd_item_fav_brand |
+-----------+--------------------+
| 1         | no                 |
| 2         | yes                |
| 3         | yes                |
| 4         | no                 |
+-----------+--------------------+
Explanation: 
The answer for the user with id 1 is no because they sold nothing.
The answer for the users with id 2 and 3 is yes because the brands of their second sold items are their favorite brands.
The answer for the user with id 4 is no because the brand of their second sold item is not their favorite brand. */
# Write your MySQL query statement below
with cte as (
select a.user_id
,a.favorite_brand
,b.order_date
,c.item_brand
,row_number() over (partition by a.user_id order by b.order_date) as rownbr
from users as a
left join orders as b
on a.user_id = b.seller_id
left join items as c
on b.item_id = c.item_id
-- where user_id = 1
)

,fav as (
select 
user_id
, 'yes' as 2nd_item_fav_brand
from cte
where rownbr = 2
and item_brand = favorite_brand
)

select a.user_id as seller_id
,ifnull(b.2nd_item_fav_brand,'no') as 2nd_item_fav_brand
from users as a
left join fav as b
on a.user_id = b.user_id