/* 
Code
Testcase
Testcase
Test Result
2084. Drop Type 1 Orders for Customers With Type 0 Orders
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| order_id    | int  | 
| customer_id | int  |
| order_type  | int  | 
+-------------+------+
order_id is the column with unique values for this table.
Each row of this table indicates the ID of an order, the ID of the customer who ordered it, and the order type.
The orders could be of type 0 or type 1.
 

Write a solution to report all the orders based on the following criteria:

If a customer has at least one order of type 0, do not report any order of type 1 from that customer.
Otherwise, report all the orders of the customer.
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input:
Orders table:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 12       | 2           | 1          |
| 21       | 3           | 1          |
| 22       | 3           | 0          |
| 31       | 4           | 1          |
| 32       | 4           | 1          |
+----------+-------------+------------+
Output:
+----------+-------------+------------+
| order_id | customer_id | order_type |
+----------+-------------+------------+
| 31       | 4           | 1          |
| 32       | 4           | 1          |
| 1        | 1           | 0          |
| 2        | 1           | 0          |
| 11       | 2           | 0          |
| 22       | 3           | 0          |
+----------+-------------+------------+
Explanation:
Customer 1 has two orders of type 0. We return both of them.
Customer 2 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 3 has one order of type 0 and one order of type 1. We only return the order of type 0.
Customer 4 has two orders of type 1. We return both of them.
 */
 # Write your MySQL query statement below
select *
from orders 
where order_type = 0
or customer_id not in (select customer_id from orders where order_type = 0);


SELECT * FROM Orders
WHERE (customer_id, order_type) 
IN (SELECT customer_id, MIN(order_type) 
    FROM Orders 
    GROUP BY customer_id)
-- with type0_cust as (
-- select customer_id
-- from orders
-- group by customer_id
-- having sum(case when order_type = 0 then 1 else 0 end) >= 1
-- )

-- ,type1_cust as (
-- select customer_id
-- from orders
-- group by customer_id
-- having sum(case when order_type = 1 then 1 else 0 end) >= 1
-- )

-- ,summary as (
-- select a.order_id, a.customer_id,a.order_type
-- ,case when b.customer_id is not null then 1 else 0 end as flag0
-- ,case when c.customer_id is not null then 1 else 0 end as flag1
-- from orders as a
-- left join type0_cust as b
-- on a.customer_id = b.customer_id
-- left join type1_cust as c
-- on a.customer_id = c.customer_id
-- )

-- select order_id, customer_id,order_type
-- from summary
-- where flag0 = 1 and order_type = 0
-- union all
-- select order_id, customer_id,order_type
-- from summary
-- where flag0 = 0 and flag1 = 1

