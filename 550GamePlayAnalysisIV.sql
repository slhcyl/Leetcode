/*550. Game Play Analysis IV
Solved
Medium
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
 

Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

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
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33*/

# Write your MySQL query statement below
SELECT ROUND(COUNT(distinct A2.player_id) / COUNT(distinct A1.player_id), 2) As fraction 
FROM Activity as A1 
LEFT JOIN Activity as A2 
ON A2.player_id = A1.player_id 
AND datediff(A2.event_date, A1.event_date) =  1 
WHERE (A1.player_id, A1.event_date) IN 
    (SELECT player_id 
        ,MIN(event_date) 
        FROM Activity GROUP BY player_id 
    )

 /* Write your T-SQL query statement below */
with day_log as 
(select player_id, min(event_date) as day1,dateadd(day,1,min(event_date)) as next_day  
from Activity
group by player_id
)

select 
round(cast(count(distinct b.player_id) as float)/count(distinct a.player_id) ,2) as fraction 
from day_log a 
left join Activity b 
on b.player_id = a.player_id 
and b.event_date = a.next_day    

-- Write your PostgreSQL query statement below
SELECT ROUND(COUNT(distinct a1.player_id)::numeric/(SELECT count(distinct player_id) FROM Activity),2) as fraction 
FROM Activity a1 
JOIN Activity a2
    ON a1.event_date = a2.event_date + INTERVAL '1 DAY' 
    AND a1.player_id = a2.player_id
WHERE (a2.player_id,a2.event_date) IN
  (SELECT player_id,min(event_date) FROM Activity 
   GROUP BY player_id)

 --OPTION2
 SELECT ROUND(COUNT(distinct A2.player_id) *1.0 / COUNT(distinct A1.player_id), 2) As fraction 
FROM Activity as A1 
LEFT JOIN Activity as A2 
ON A2.player_id = A1.player_id 
AND A2.event_date =  A1.event_date + INTERVAL '1 DAY' 
WHERE (A1.player_id, A1.event_date) IN 
    (SELECT player_id 
        ,MIN(event_date) 
        FROM Activity GROUP BY player_id 
    )  