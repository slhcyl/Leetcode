/* 180. Consecutive Numbers
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
In SQL, id is the primary key for this table.
id is an autoincrement column.
 

Find all numbers that appear at least three times consecutively.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times. */
# Write your MySQL query statement below
select distinct a.num as ConsecutiveNums
from logs as a, logs as b, logs as c
where a.id = b.id - 1
and b.id = c.id - 1
and a.num = b.num
and b.num = c.num

/* Write your T-SQL query statement below */
select distinct a.num as ConsecutiveNums
from logs as a, logs as b, logs as c
where a.id = b.id - 1
and b.id = c.id - 1
and a.num = b.num
and b.num = c.num

-- Write your PostgreSQL query statement below
select distinct a.num as ConsecutiveNums
from logs as a, logs as b, logs as c
where a.id = b.id - 1
and b.id = c.id - 1
and a.num = b.num
and b.num = c.num

select distinct num as ConsecutiveNums
from (
select num
, lead(num,1) over (order by id) as num1
, lead(num,2) over (order by id) as num2
from Logs
) t
where num = num1
and num1 = num2