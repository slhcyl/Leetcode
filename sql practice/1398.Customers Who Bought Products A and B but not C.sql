/* 
Code

Testcase
Testcase
Test Result

1398. Customers Who Bought Products A and B but Not C
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Customers

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| customer_id         | int     |
| customer_name       | varchar |
+---------------------+---------+
customer_id is the column with unique values for this table.
customer_name is the name of the customer.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_name  | varchar |
+---------------+---------+
order_id is the column with unique values for this table.
customer_id is the id of the customer who bought the product "product_name".
 

Write a solution to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them to purchase this product.

Return the result table ordered by customer_id.

The result format is in the following example.

 

Example 1:

Input: 
Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Diana         |
| 3           | Elizabeth     |
| 4           | Jhon          |
+-------------+---------------+
Orders table:
+------------+--------------+---------------+
| order_id   | customer_id  | product_name  |
+------------+--------------+---------------+
| 10         |     1        |     A         |
| 20         |     1        |     B         |
| 30         |     1        |     D         |
| 40         |     1        |     C         |
| 50         |     2        |     A         |
| 60         |     3        |     A         |
| 70         |     3        |     B         |
| 80         |     3        |     D         |
| 90         |     4        |     C         |
+------------+--------------+---------------+
Output: 
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 3           | Elizabeth     |
+-------------+---------------+
Explanation: Only the customer_id with id 3 bought the product A and B but not the product C. */
# Write your MySQL query statement below
WITH cust_prod as (
select customer_id
,SUM(case when product_name = 'A' then 1 else 0 end) as product_a
,SUM(case when product_name = 'B' then 1 else 0 end) as product_b
,SUM(case when product_name = 'C' then 1 else 0 end) as product_c
from orders 
group by customer_id
)

select a.customer_id,b.customer_name
from cust_prod as a 
join Customers  as b 
on a.customer_id = b.customer_id
where product_a >= 1 and product_b >= 1 and product_c = 0
order by a.customer_id


/* Write your T-SQL query statement below */
select a.customer_id,b.customer_name
from orders as a 
join Customers  as b 
on a.customer_id = b.customer_id
group by a.customer_id,b.customer_name
HAVING SUM(case when product_name = 'A' then 1 else 0 end) > 0
AND SUM(case when product_name = 'B' then 1 else 0 end) > 0
AND SUM(case when product_name = 'C' then 1 else 0 end) = 0
order by customer_id

/*Option 2*/
WITH cust_prod as (
select customer_id
from orders 
group by customer_id
HAVING SUM(case when product_name = 'A' then 1 else 0 end) > 0
AND SUM(case when product_name = 'B' then 1 else 0 end) > 0
AND SUM(case when product_name = 'C' then 1 else 0 end) = 0
)

select a.customer_id,b.customer_name
from cust_prod as a 
join Customers  as b 
on a.customer_id = b.customer_id
-- where product_a >= 1 and product_b >= 1 and product_c = 0
order by a.customer_id