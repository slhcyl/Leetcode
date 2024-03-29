/* 
Code

Testcase
Testcase
Test Result

1667. Fix Names in a Table
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key (column with unique values) for this table.
This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 

Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.

Return the result table ordered by user_id.

The result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
Output: 
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+ */
select user_id, CONCAT(upper(left(name,1)),lower(substring(name, 2 ))) as name
from users
order by user_id

/* Write your T-SQL query statement below */
select user_id, CONCAT(upper(left(name,1)),lower(substring(name, 2 , len(name)-1))) as name
from users
order by user_id