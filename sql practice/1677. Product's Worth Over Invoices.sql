/* 
Code

Testcase
Testcase
Test Result

1677. Product's Worth Over Invoices
Solved
Easy
Topics
SQL Schema
Pandas Schema
Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| name        | varchar |
+-------------+---------+
product_id is the column with unique values for this table.
This table contains the ID and the name of the product. The name consists of only lowercase English letters. No two products have the same name.
 

Table: Invoice

+-------------+------+
| Column Name | Type |
+-------------+------+
| invoice_id  | int  |
| product_id  | int  |
| rest        | int  |
| paid        | int  |
| canceled    | int  |
| refunded    | int  |
+-------------+------+
invoice_id is the column with unique values for this table and the id of this invoice.
product_id is the id of the product for this invoice.
rest is the amount left to pay for this invoice.
paid is the amount paid for this invoice.
canceled is the amount canceled for this invoice.
refunded is the amount refunded for this invoice.
 

Write a solution that will, for all products, return each product name with the total amount due, paid, canceled, and refunded across all invoices.

Return the result table ordered by product_name.

The result format is in the following example.

 

Example 1:

Input: 
Product table:
+------------+-------+
| product_id | name  |
+------------+-------+
| 0          | ham   |
| 1          | bacon |
+------------+-------+
Invoice table:
+------------+------------+------+------+----------+----------+
| invoice_id | product_id | rest | paid | canceled | refunded |
+------------+------------+------+------+----------+----------+
| 23         | 0          | 2    | 0    | 5        | 0        |
| 12         | 0          | 0    | 4    | 0        | 3        |
| 1          | 1          | 1    | 1    | 0        | 1        |
| 2          | 1          | 1    | 0    | 1        | 1        |
| 3          | 1          | 0    | 1    | 1        | 1        |
| 4          | 1          | 1    | 1    | 1        | 0        |
+------------+------------+------+------+----------+----------+
Output: 
+-------+------+------+----------+----------+
| name  | rest | paid | canceled | refunded |
+-------+------+------+----------+----------+
| bacon | 3    | 3    | 3        | 3        |
| ham   | 2    | 4    | 5        | 3        |
+-------+------+------+----------+----------+
Explanation: 
- The amount of money left to pay for bacon is 1 + 1 + 0 + 1 = 3
- The amount of money paid for bacon is 1 + 0 + 1 + 1 = 3
- The amount of money canceled for bacon is 0 + 1 + 1 + 1 = 3
- The amount of money refunded for bacon is 1 + 1 + 1 + 0 = 3
- The amount of money left to pay for ham is 2 + 0 = 2
- The amount of money paid for ham is 0 + 4 = 4
- The amount of money canceled for ham is 5 + 0 = 5
- The amount of money refunded for ham is 0 + 3 = 3 */
# Write your MySQL query statement below
select p.name
,ifnull(sum(rest),0) as rest
,ifnull(sum(paid),0) as paid
,ifnull(sum(canceled),0) as canceled
,ifnull(sum(refunded),0) as refunded
from product as p
left join invoice as i
on p.product_id = i.product_id
group by p.name
order by 1