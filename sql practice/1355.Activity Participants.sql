/* 1355. Activity Participants
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Friends

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and the primary key for this table in SQL.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.
 

Table: Activities

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
In SQL, id is the primary key for this table.
name is the name of the activity.
 

Find the names of all the activities with neither the maximum nor the minimum number of participants.

Each activity in the Activities table is performed by any person in the table Friends.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+
Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+
Output: 
+--------------+
| activity     |
+--------------+
| Singing      |
+--------------+
Explanation: 
Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.) */
# Write your MySQL query statement below
with cte as (
    select activity
    ,count(*) as cnt
    from friends
    group by activity
)

,rankcte as (
select activity
,cnt
,rank() over (order by cnt desc) as ranknbr
,rank() over (order by cnt) as rev_ranknbr
from cte
)

select name as activity
from activities
where name in (select activity from rankcte where ranknbr != 1 and rev_ranknbr != 1)

