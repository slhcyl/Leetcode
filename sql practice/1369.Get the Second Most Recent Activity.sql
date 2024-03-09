/* 1369. Get the Second Most Recent Activity
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: UserActivity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
This table may contain duplicates rows.
This table contains information about the activity performed by each user in a period of time.
A person with username performed an activity from startDate to endDate.
 

Write a solution to show the second most recent activity of each user.

If the user only has one activity, return that one. A user cannot perform more than one activity at the same time.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Output: 
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
Explanation: 
The most recent activity of Alice is Travel from 2020-02-24 to 2020-02-28, before that she was dancing from 2020-02-21 to 2020-02-23.
Bob only has one record, we just take that one. */

# Write your MySQL query statement below
with cte as (
select *
,lead(activity,1) over (partition by username order by startDate desc) as sec_activity
,lead(startDate,1) over (partition by username order by startDate desc) as sec_startdt
,lead(endDate,1) over (partition by username order by startDate desc) as sec_enddt
,row_number() over (partition by username order by startDate desc) as rownbr
from useractivity
)

select username
,ifnull(sec_activity,activity) as activity
,ifnull(sec_startdt,startDate) as startDate
,ifnull(sec_enddt,endDate) as endDate
from cte
where rownbr=1

# Write your MySQL query statement below
with cte as (
select *
,count(*) over (partition by username) as cnt
,row_number() over (partition by username order by startDate desc) as rownbr
from useractivity
)

select username
,activity
,startDate
,endDate as endDate
from cte
where rownbr=2 or cnt = 1