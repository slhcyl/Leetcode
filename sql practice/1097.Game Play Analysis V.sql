/* 
Code
Testcase
Testcase
Test Result
1097. Game Play Analysis V
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key (combination of columns with unique values) of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

The install date of a player is the first login day of that player.

We define day one retention of some date x to be the number of players whose install date is x and they logged back in on the day right after x, divided by the number of players whose install date is x, rounded to 2 decimal places.

Write a solution to report for each install date, the number of players that installed the game on that day, and the day one retention.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
Explanation: 
Player 1 and 3 installed the game on 2016-03-01 but only player 1 logged back in on 2016-03-02 so the day 1 retention of 2016-03-01 is 1 / 2 = 0.50
Player 2 installed the game on 2017-06-25 but didn't log back in on 2017-06-26 so the day 1 retention of 2017-06-25 is 0 / 1 = 0.00 */

# Write your MySQL query statement below
with cte as (
select *
,lead(event_date) over (partition by player_id order by event_date) as next_date
,row_number() over (partition by player_id order by event_date) as loginrank
from activity
)

,firstlogininfo as (
select event_date, player_id,next_date,count(player_id) over (partition by event_date) as installs
from cte
where loginrank=1
)

,num as (
select event_date,count(player_id) as num
from firstlogininfo 
where datediff(next_date,event_date) = 1
group by event_date
)

select a.event_date as install_dt
,a.installs
-- ,ifnull(num,0) as num
,round(ifnull(num,0)/a.installs,2) as Day1_retention 
from firstlogininfo as a 
left join num as b
on a.event_date = b.event_date
group by a.event_date