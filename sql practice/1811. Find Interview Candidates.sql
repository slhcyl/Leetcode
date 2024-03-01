/* 1811. Find Interview Candidates
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Contests

+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the column with unique values for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 

Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the column with unique values for this table.
This table contains information about the users.
 

Write a solution to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:

The user won any medal in three or more consecutive contests.
The user won the gold medal in three or more different contests (not necessarily consecutive).
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Contests table:
+------------+------------+--------------+--------------+
| contest_id | gold_medal | silver_medal | bronze_medal |
+------------+------------+--------------+--------------+
| 190        | 1          | 5            | 2            |
| 191        | 2          | 3            | 5            |
| 192        | 5          | 2            | 3            |
| 193        | 1          | 3            | 5            |
| 194        | 4          | 5            | 2            |
| 195        | 4          | 2            | 1            |
| 196        | 1          | 5            | 2            |
+------------+------------+--------------+--------------+
Users table:
+---------+--------------------+-------+
| user_id | mail               | name  |
+---------+--------------------+-------+
| 1       | sarah@leetcode.com | Sarah |
| 2       | bob@leetcode.com   | Bob   |
| 3       | alice@leetcode.com | Alice |
| 4       | hercy@leetcode.com | Hercy |
| 5       | quarz@leetcode.com | Quarz |
+---------+--------------------+-------+
Output: 
+-------+--------------------+
| name  | mail               |
+-------+--------------------+
| Sarah | sarah@leetcode.com |
| Bob   | bob@leetcode.com   |
| Alice | alice@leetcode.com |
| Quarz | quarz@leetcode.com |
+-------+--------------------+
Explanation: 
Sarah won 3 gold medals (190, 193, and 196), so we include her in the result table.
Bob won a medal in 3 consecutive contests (190, 191, and 192), so we include him in the result table.
    - Note that he also won a medal in 3 other consecutive contests (194, 195, and 196).
Alice won a medal in 3 consecutive contests (191, 192, and 193), so we include her in the result table.
Quarz won a medal in 5 consecutive contests (190, 191, 192, 193, and 194), so we include them in the result table.
 

Follow up:

What if the first condition changed to be "any medal in n or more consecutive contests"? How would you change your solution to get the interview candidates? Imagine that n is the parameter of a stored procedure.
Some users may not participate in every contest but still perform well in the ones they do. How would you change your solution to only consider contests where the user was a participant? Suppose the registered users for each contest are given in another table. */
# Write your MySQL query statement below
with condition1 as (
select a.user_id
from users as a 
left join contests as b
on a.user_id = b.gold_medal
group by user_id
having count(b.gold_medal)>= 3
)

, condition2 as (
select user_id
,contest_id
,lag(contest_id) over (partition by user_id order by contest_id) as prev_contest_id
,lead(contest_id) over (partition by user_id order by contest_id) as next_contest_id
from (
select a.user_id
,g.contest_id
from users as a
join contests as g 
on a.user_id = g.gold_medal
union all
select a.user_id
,s.contest_id
from users as a
join contests as s 
on a.user_id = s.silver_medal 
union all
select a.user_id
,b.contest_id
from users as a
join contests as b 
on a.user_id = b.bronze_medal
# order by 1,2
) as t
)

select b.name, b.mail
from (
select distinct user_id
from condition2
where contest_id - prev_contest_id = 1
and next_contest_id - contest_id = 1
union 
select user_id
from condition1) as t
join users as b
on t.user_id = b.user_id

# Write your MySQL query statement below
with summary as (
select a.user_id
,g.contest_id
from users as a
join contests as g 
on a.user_id = g.gold_medal
union all
select a.user_id
,s.contest_id
from users as a
join contests as s 
on a.user_id = s.silver_medal 
union all
select a.user_id
,b.contest_id
from users as a
join contests as b 
on a.user_id = b.bronze_medal
)

,cte as (
select user_id, contest_id
,row_number() over (partition by user_id order by contest_id) as rn
,contest_id - row_number() over (partition by user_id order by contest_id) as groupdesc
from summary
)

,final as (
select user_id
from cte
group by user_id, groupdesc
having count(*) >= 3 
union all
select gold_medal as user_id
from contests
group by gold_medal
having count(*) >= 3
)

select distinct b.name,b.mail
from final as a
join users as b
on a.user_id = b.user_id