/* 571. Find Median Given Frequency of Numbers
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Numbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
| frequency   | int  |
+-------------+------+
num is the primary key (column with unique values) for this table.
Each row of this table shows the frequency of a number in the database.
 

The median is the value separating the higher half from the lower half of a data sample.

Write a solution to report the median of all the numbers in the database after decompressing the Numbers table. Round the median to one decimal point.

The result format is in the following example.

 

Example 1:

Input: 
Numbers table:
+-----+-----------+
| num | frequency |
+-----+-----------+
| 0   | 7         |
| 1   | 1         |
| 2   | 3         |
| 3   | 1         |
+-----+-----------+
Output: 
+--------+
| median |
+--------+
| 0.0    |
+--------+
Explanation: 
If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0. */
# Write your MySQL query statement below
with cte as (
select *
,sum(frequency) over () as total
,sum(frequency) over (order by num) as rk1
,sum(frequency) over (order by num desc) as rk2
from numbers
)

select 
round(avg(num),2) as median
from cte
where rk1 >= total/2 
-- median from the asceding order
and rk2 >= total/2 
-- median from the descending order
order by num

# Write your MySQL query statement below
WITH
    t AS (
        SELECT
            *,
            SUM(frequency) OVER (ORDER BY num ASC) AS rk1,
            SUM(frequency) OVER (ORDER BY num DESC) AS rk2,
            SUM(frequency) OVER () AS s
        FROM Numbers
    )
SELECT *
    ROUND(AVG(num), 1) AS median
FROM t
WHERE rk1 >= s / 2 AND  rk2 >= s / 2;
# where 
#  rk2 >= s / 2;