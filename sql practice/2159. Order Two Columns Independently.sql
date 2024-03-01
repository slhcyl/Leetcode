/* 
Code
Testcase
Testcase
Test Result
2159. Order Two Columns Independently
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Data

+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
This table may contain duplicate rows.
 

Write a solution to independently:

order first_col in ascending order.
order second_col in descending order.
The result format is in the following example.

 

Example 1:

Input: 
Data table:
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 4         | 2          |
| 2         | 3          |
| 3         | 1          |
| 1         | 4          |
+-----------+------------+
Output: 
+-----------+------------+
| first_col | second_col |
+-----------+------------+
| 1         | 4          |
| 2         | 3          |
| 3         | 2          |
| 4         | 1          |
+-----------+------------+ */
# Write your MySQL query statement below
with first as (
select first_col, row_number() over(order by first_col) as ranknbr
 from data 
)
, second as (
    select second_col , row_number() over(order by second_col desc) as ranknbr
    from data 
)

select a.first_col,b.second_col
from first as a
join second as b
on a.ranknbr=b.ranknbr