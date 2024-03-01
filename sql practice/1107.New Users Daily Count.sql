/* 1107. New Users Daily Count
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Traffic

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| activity      | enum    |
| activity_date | date    |
+---------------+---------+
This table may have duplicate rows.
The activity column is an ENUM (category) type of ('login', 'logout', 'jobs', 'groups', 'homepage').
 

Write a solution to reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Traffic table:
+---------+----------+---------------+
| user_id | activity | activity_date |
+---------+----------+---------------+
| 1       | login    | 2019-05-01    |
| 1       | homepage | 2019-05-01    |
| 1       | logout   | 2019-05-01    |
| 2       | login    | 2019-06-21    |
| 2       | logout   | 2019-06-21    |
| 3       | login    | 2019-01-01    |
| 3       | jobs     | 2019-01-01    |
| 3       | logout   | 2019-01-01    |
| 4       | login    | 2019-06-21    |
| 4       | groups   | 2019-06-21    |
| 4       | logout   | 2019-06-21    |
| 5       | login    | 2019-03-01    |
| 5       | logout   | 2019-03-01    |
| 5       | login    | 2019-06-21    |
| 5       | logout   | 2019-06-21    |
+---------+----------+---------------+
Output: 
+------------+-------------+
| login_date | user_count  |
+------------+-------------+
| 2019-05-01 | 1           |
| 2019-06-21 | 2           |
+------------+-------------+
Explanation: 
Note that we only care about dates with non zero user count.
The user with id 5 first logged in on 2019-03-01 so he's not counted on 2019-06-21. */
# Write your MySQL query statement below
with cte as (
select 
user_id
,activity_date
,first_value(activity_date) over (partition by user_id order by activity_date) as first_date
from traffic
where activity = 'login'
)

select first_date as login_date
,count(distinct user_id) as user_count
from cte
where first_date >= date_add('2019-06-30', interval -90 day)
group by first_date

/* Write your T-SQL query statement below */
with cte as (
select user_id
,min(activity_date) as first_login_date
from traffic
where activity = 'login'
group by user_id
)

select 
first_login_date as login_date
,count(user_id) as user_count
from cte
where first_login_date >= dateadd(day,-90,'2019-06-30')
group by first_login_date