/* 618. Students Report By Geography
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Student

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| name        | varchar |
| continent   | varchar |
+-------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the name of a student and the continent they came from.
 

A school has students from Asia, Europe, and America.

Write a solution to pivot the continent column in the Student table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia, and Europe, respectively.

The test cases are generated so that the student number from America is not less than either Asia or Europe.

The result format is in the following example.

 

Example 1:

Input: 
Student table:
+--------+-----------+
| name   | continent |
+--------+-----------+
| Jane   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jack   | America   |
+--------+-----------+
Output: 
+---------+------+--------+
| America | Asia | Europe |
+---------+------+--------+
| Jack    | Xi   | Pascal |
| Jane    | null | null   |
+---------+------+--------+
  */
# Write your MySQL query statement below
with cte as (
select
case when continent = 'America' then name end as America
,case when continent = 'Asia' then name end as Asia
,case when continent = 'Europe' then name end as Europe
,row_number() over (partition by continent order by name) as rn
from student
)

select min(America) as America,min(Asia) as Asia,min(Europe) as Europe
from cte 
group by rn