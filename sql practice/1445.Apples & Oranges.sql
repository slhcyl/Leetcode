/* 
Code

Testcase
Testcase
Test Result

1445. Apples & Oranges
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
This table contains the sales of "apples" and "oranges" sold each day.
 

Write a solution to report the difference between the number of apples and oranges sold each day.

Return the result table ordered by sale_date.

The result format is in the following example.

 

Example 1:

Input: 
Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+
Output: 
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+
Explanation: 
Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1). */
# Write your MySQL query statement below
select
sale_date
,sum(case when fruit = 'oranges' then -1*sold_num 
          when fruit = 'apples' then sold_num end) as diff
from sales
group by sale_date
order by sale_date


SELECT 
    a.sale_date, a.sold_num-b.sold_num AS diff
FROM 
    (SELECT sale_date, sold_num FROM Sales WHERE fruit IN ('apples'))a
JOIN
    (SELECT sale_date, sold_num FROM Sales WHERE fruit IN ('oranges'))b
ON 
    a.sale_date = b.sale_date
GROUP BY 1
ORDER BY 1

SELECT 
    a.sale_date, a.sold_num-b.sold_num AS diff
FROM
    Sales a
JOIN
    Sales b
ON 
    a.sale_date = b.sale_date
AND 
    a.fruit IN ('apples') AND b.fruit IN ('oranges')
GROUP BY 1
ORDER BY 1 

SELECT 
    a.sale_date, a.sold_num-b.sold_num AS diff
FROM
    Sales a, Sales b
WHERE 
    a.fruit IN ('apples') AND b.fruit IN ('oranges')
    AND a.sale_date = b.sale_date
GROUP BY 1
ORDER BY 1 