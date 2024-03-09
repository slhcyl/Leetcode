/* 1127. User Purchase Platform
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Spending

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the history of the spending of users that make purchases from an online shopping website that has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key (combination of columns with unique values) of this table.
The platform column is an ENUM (category) type of ('desktop', 'mobile').
 

Write a solution to find the total number of users and the total amount spent using the mobile only, the desktop only, and both mobile and desktop together for each date.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+
Output: 
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
Explanation: 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms. */
# Write your MySQL query statement below
with cte as (
    select spend_date
,user_id
,sum(case when platform = 'desktop' then amount else 0 end) as damt
,sum(case when platform = 'mobile' then amount else 0 end) as mamt
from spending
group by spend_date
,user_id
)
,info as (
    select distinct spend_date, 'desktop' as platform
    from cte
    union 
    select distinct spend_date, 'mobile' as platform
    from cte
    union
    select distinct spend_date, 'both' as platform
    from cte
)

,summary as (
select spend_date,'both' as platform
,sum(damt + mamt) as total_amount
,count(user_id) as total_users
from cte
where damt > 0 and mamt > 0  
group by spend_date
union all
select spend_date, 'mobile' as platform
,sum(mamt) as total_amount
,count(user_id) as total_users
from cte
where mamt > 0 and damt = 0
group by spend_date
union all
select spend_date, 'desktop' as platform
,sum(damt) as total_amount
,count(user_id) as total_users
from cte
where damt > 0 and mamt = 0
group by spend_date
)
select a.spend_date
,a.platform
,ifnull(b.total_amount,0) as total_amount
,ifnull(b.total_users,0) as total_users
from info as a
left join summary as b
on a.spend_date = b.spend_date
and a.platform = b.platform