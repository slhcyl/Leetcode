/* 1972. First and Last Call On the Same Day
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Calls

+--------------+----------+
| Column Name  | Type     |
+--------------+----------+
| caller_id    | int      |
| recipient_id | int      |
| call_time    | datetime |
+--------------+----------+
(caller_id, recipient_id, call_time) is the primary key (combination of columns with unique values) for this table.
Each row contains information about the time of a phone call between caller_id and recipient_id.
 

Write a solution to report the IDs of the users whose first and last calls on any day were with the same person. Calls are counted regardless of being the caller or the recipient.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Calls table:
+-----------+--------------+---------------------+
| caller_id | recipient_id | call_time           |
+-----------+--------------+---------------------+
| 8         | 4            | 2021-08-24 17:46:07 |
| 4         | 8            | 2021-08-24 19:57:13 |
| 5         | 1            | 2021-08-11 05:28:44 |
| 8         | 3            | 2021-08-17 04:04:15 |
| 11        | 3            | 2021-08-17 13:07:00 |
| 8         | 11           | 2021-08-17 22:22:22 |
+-----------+--------------+---------------------+
Output: 
+---------+
| user_id |
+---------+
| 1       |
| 4       |
| 5       |
| 8       |
+---------+
Explanation: 
On 2021-08-24, the first and last call of this day for user 8 was with user 4. User 8 should be included in the answer.
Similarly, user 4 on 2021-08-24 had their first and last call with user 8. User 4 should be included in the answer.
On 2021-08-11, user 1 and 5 had a call. This call was the only call for both of them on this day. Since this call is the first and last call of the day for both of them, they should both be included in the answer. */
# Write your MySQL query statement below
with population as (
select caller_id, recipient_id, call_time from calls
union
select recipient_id, caller_id,  call_time from calls
)

,summary as (
select caller_id
,recipient_id
,cast(call_time as date) as call_date ,call_time
,rank() over (partition by caller_id, cast(call_time as date) order by call_time desc) as rank1
,rank() over (partition by caller_id, cast(call_time as date) order by call_time) as rank0
from population
-- order by 1,3,4
)

SELECT 
  DISTINCT caller_id user_id 
FROM 
  summary 
WHERE 
  rank1 = 1 
  OR rank0 = 1 
GROUP BY 
  caller_id, 
  call_date 
HAVING 
  COUNT(DISTINCT recipient_id) = 1;