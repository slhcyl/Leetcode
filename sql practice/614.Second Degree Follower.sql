/* 614. Second Degree Follower
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Follow

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| followee    | varchar |
| follower    | varchar |
+-------------+---------+
(followee, follower) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the user follower follows the user followee on a social network.
There will not be a user following themself.
 

A second-degree follower is a user who:

follows at least one user, and
is followed by at least one user.
Write a solution to report the second-degree users and the number of their followers.

Return the result table ordered by follower in alphabetical order.

The result format is in the following example.

 

Example 1:

Input: 
Follow table:
+----------+----------+
| followee | follower |
+----------+----------+
| Alice    | Bob      |
| Bob      | Cena     |
| Bob      | Donald   |
| Donald   | Edward   |
+----------+----------+
Output: 
+----------+-----+
| follower | num |
+----------+-----+
| Bob      | 2   |
| Donald   | 1   |
+----------+-----+
Explanation: 
User Bob has 2 followers. Bob is a second-degree follower because he follows Alice, so we include him in the result table.
User Donald has 1 follower. Donald is a second-degree follower because he follows Bob, so we include him in the result table.
User Alice has 1 follower. Alice is not a second-degree follower because she does not follow anyone, so we don not include her in the result table. */
# Write your MySQL query statement below
with sec_follower as (
    select distinct follower
    from follow
    where follower in (select followee from follow)
)

select a.follower
,count(b.follower) as num
from sec_follower as a 
left join follow as b
on a.follower = b.followee
group by a.follower
order by 1