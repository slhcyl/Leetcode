/* 1454. Active Users
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Accounts

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
This table contains the account id and the user name of each account.
 

Table: Logins

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
This table may contain duplicate rows.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

Active users are those who logged in to their accounts for five or more consecutive days.

Write a solution to find the id and the name of active users.

Return the result table ordered by id.

The result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Winston  |
| 7  | Jonathan |
+----+----------+
Logins table:
+----+------------+
| id | login_date |
+----+------------+
| 7  | 2020-05-30 |
| 1  | 2020-05-30 |
| 7  | 2020-05-31 |
| 7  | 2020-06-01 |
| 7  | 2020-06-02 |
| 7  | 2020-06-02 |
| 7  | 2020-06-03 |
| 1  | 2020-06-07 |
| 7  | 2020-06-10 |
+----+------------+
Output: 
+----+----------+
| id | name     |
+----+----------+
| 7  | Jonathan |
+----+----------+
Explanation: 
User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.
 

Follow up: Could you write a general solution if the active users are those who logged in to their accounts for n or more consecutive days? */
# Write your MySQL query statement below
with cte as (
select 
l.id
,l.login_date
,dense_rank() over (partition by l.id order by l.login_date) as rownbr
from logins as l 
group by l.id
,l.login_date
)

, cte2 as (
select
*, date_add(login_date, interval -rownbr day) as groupdsc
from cte as a
)

,groupcte as (
select id, groupdsc
,min(login_date) as start_date
,max(login_date) as end_date
,datediff(max(login_date),min(login_date)) as daydiff
from cte2 as a
group by id,groupdsc
)

select distinct g.id,a.name
from groupcte as g
join accounts as a
on g.id = a.id
where daydiff >= 4
order by id

/* Write your T-SQL query statement below */
with cte as (
select 
l.id
,l.login_date
,dense_rank() over (partition by l.id order by l.login_date) as rownbr
from logins as l 
group by l.id
,l.login_date
)

, cte2 as (
select
*, dateadd(day, -rownbr, login_date) as groupdsc
from cte as a
)

,groupcte as (
select id, groupdsc
,min(login_date) as start_date
,max(login_date) as end_date
,datediff(day,min(login_date),max(login_date)) as daydiff
from cte2 as a
group by id,groupdsc
)

select distinct g.id,a.name
from groupcte as g
join accounts as a
on g.id = a.id
where daydiff >= 4
order by id