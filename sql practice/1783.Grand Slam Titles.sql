/* 1783. Grand Slam Titles
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Players

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| player_id      | int     |
| player_name    | varchar |
+----------------+---------+
player_id is the primary key (column with unique values) for this table.
Each row in this table contains the name and the ID of a tennis player.
 

Table: Championships

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| year          | int     |
| Wimbledon     | int     |
| Fr_open       | int     |
| US_open       | int     |
| Au_open       | int     |
+---------------+---------+
year is the primary key (column with unique values) for this table.
Each row of this table contains the IDs of the players who won one each tennis tournament of the grand slam.
 

Write a solution to report the number of grand slam tournaments won by each player. Do not include the players who did not win any tournament.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Players table:
+-----------+-------------+
| player_id | player_name |
+-----------+-------------+
| 1         | Nadal       |
| 2         | Federer     |
| 3         | Novak       |
+-----------+-------------+
Championships table:
+------+-----------+---------+---------+---------+
| year | Wimbledon | Fr_open | US_open | Au_open |
+------+-----------+---------+---------+---------+
| 2018 | 1         | 1       | 1       | 1       |
| 2019 | 1         | 1       | 2       | 2       |
| 2020 | 2         | 1       | 2       | 2       |
+------+-----------+---------+---------+---------+
Output: 
+-----------+-------------+-------------------+
| player_id | player_name | grand_slams_count |
+-----------+-------------+-------------------+
| 2         | Federer     | 5                 |
| 1         | Nadal       | 7                 |
+-----------+-------------+-------------------+
Explanation: 
Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020), US_open (2018), and Au_open (2018).
Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
Player 3 (Novak) did not win anything, we did not include them in the result table. */

# Write your MySQL query statement below
with summary as (
select a.player_id,a.player_name
from players as a 
join championships as b
on a.player_id = b.Wimbledon 
union all
select a.player_id,a.player_name
from players as a 
join championships as b
on a.player_id = b.Fr_open 
union all
select a.player_id,a.player_name
from players as a 
join championships as b
on a.player_id = b.US_open  
union all
select a.player_id,a.player_name
from players as a 
join championships as b
on a.player_id = b.Au_open 
)
select player_id,player_name,count(player_id) as grand_slams_count 
from summary
group by player_id,player_name

/* Write your T-SQL query statement below */
with summary as (
select year, g_name,player_id
from championships
UNPIVOT (player_id for g_name in ([Wimbledon],[Fr_open],[US_open],[Au_open])) as u 
)

select a.player_id, b.player_name, count(a.player_id) as grand_slams_count 
from summary as a 
join players as b
on a.player_id = b.player_id
group by a.player_id, b.player_name