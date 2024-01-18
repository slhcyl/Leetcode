/* 1495. Friendly Movies Streamed Last Month
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: TVProgram

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| program_date  | date    |
| content_id    | int     |
| channel       | varchar |
+---------------+---------+
(program_date, content_id) is the primary key (combination of columns with unique values) for this table.
This table contains information of the programs on the TV.
content_id is the id of the program in some channel on the TV.
 

Table: Content

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| content_id       | varchar |
| title            | varchar |
| Kids_content     | enum    |
| content_type     | varchar |
+------------------+---------+
content_id is the primary key (column with unique values) for this table.
Kids_content is an ENUM (category) of types ('Y', 'N') where: 
'Y' means is content for kids otherwise 'N' is not content for kids.
content_type is the category of the content as movies, series, etc.
 

Write a solution to report the distinct titles of the kid-friendly movies streamed in June 2020.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
TVProgram table:
+--------------------+--------------+-------------+
| program_date       | content_id   | channel     |
+--------------------+--------------+-------------+
| 2020-06-10 08:00   | 1            | LC-Channel  |
| 2020-05-11 12:00   | 2            | LC-Channel  |
| 2020-05-12 12:00   | 3            | LC-Channel  |
| 2020-05-13 14:00   | 4            | Disney Ch   |
| 2020-06-18 14:00   | 4            | Disney Ch   |
| 2020-07-15 16:00   | 5            | Disney Ch   |
+--------------------+--------------+-------------+
Content table:
+------------+----------------+---------------+---------------+
| content_id | title          | Kids_content  | content_type  |
+------------+----------------+---------------+---------------+
| 1          | Leetcode Movie | N             | Movies        |
| 2          | Alg. for Kids  | Y             | Series        |
| 3          | Database Sols  | N             | Series        |
| 4          | Aladdin        | Y             | Movies        |
| 5          | Cinderella     | Y             | Movies        |
+------------+----------------+---------------+---------------+
Output: 
+--------------+
| title        |
+--------------+
| Aladdin      |
+--------------+
Explanation: 
"Leetcode Movie" is not a content for kids.
"Alg. for Kids" is not a movie.
"Database Sols" is not a movie
"Alladin" is a movie, content for kids and was streamed in June 2020.
"Cinderella" was not streamed in June 2020. */
/* There are several ways to extract year and month from a date column:

The most straightforward way is to use functions MONTH() and YEAR()
WHERE MONTH(program_date) = 6 AND YEAR(program_date)=2020
Extract the year and month using DATE_FORMAT() and filter by the year and month combination:
WHERE DATE_FORMAT(program_date,'%Y-%m') = '2020-06'
Treat the column as a string and return only the matched ones using LEFT():
WHERE LEFT(program_date, 7) = '2020-06' */
# Write your MySQL query statement below
select distinct title 
from content as c 
join TVProgram as p 
on c.content_id = p.content_id
where extract(year_month from p.program_date) = 202006
and c.kids_content = 'Y'
and c.content_type = 'Movies';

SELECT 
    DISTINCT c.title
FROM 
    Content c
JOIN 
    TVProgram p
ON 
    c.content_id = p.content_id
WHERE 
    c.Kids_content = 'Y'
AND 
    c.content_type = 'Movies'
AND MONTH(p.program_date) = 6 AND YEAR(p.program_date) = 2020