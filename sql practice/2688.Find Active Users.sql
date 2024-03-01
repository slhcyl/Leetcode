/* 2688. Find Active Users
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Users

+-------------+----------+ 
| Column Name | Type     | 
+-------------+----------+ 
| user_id     | int      | 
| item        | varchar  |
| created_at  | datetime |
| amount      | int      |
+-------------+----------+
This table may contain duplicate records. 
Each row includes the user ID, the purchased item, the date of purchase, and the purchase amount.
Write a solution to identify active users. An active user is a user that has made a second purchase within 7 days of any other of their purchases.

For example, if the ending date is May 31, 2023. So any date between May 31, 2023, and June 7, 2023 (inclusive) would be considered "within 7 days" of May 31, 2023.

Return a list of user_id which denotes the list of active users in any order.

The result format is in the following example.

 

Example 1:

Input:
Users table:
+---------+-------------------+------------+--------+ 
| user_id | item              | created_at | amount |  
+---------+-------------------+------------+--------+
| 5       | Smart Crock Pot   | 2021-09-18 | 698882 |
| 6       | Smart Lock        | 2021-09-14 | 11487  |
| 6       | Smart Thermostat  | 2021-09-10 | 674762 |
| 8       | Smart Light Strip | 2021-09-29 | 630773 |
| 4       | Smart Cat Feeder  | 2021-09-02 | 693545 |
| 4       | Smart Bed         | 2021-09-13 | 170249 |
+---------+-------------------+------------+--------+ 
Output:
+---------+
| user_id | 
+---------+
| 6       | 
+---------+
Explanation: 
- User with user_id 5 has only one transaction, so he is not an active user.
- User with user_id 6 has two transaction his first transaction was on 2021-09-10 and second transation was on 2021-09-14. The distance between the first and second transactions date is <= 7 days. So he is an active user. 
- User with user_id 8 has only one transaction, so he is not an active user.  
- User with user_id 4 has two transaction his first transaction was on 2021-09-02 and second transation was on 2021-09-13. The distance between the first and second transactions date is > 7 days. So he is not an active user.  */
WITH UserPurchaseRank AS (
  SELECT
    user_id,
    item,
    created_at,
    amount,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS purchase_rank
  FROM
    Users
)

SELECT  
 distinct u1.user_id
FROM
  UserPurchaseRank u1
JOIN
  UserPurchaseRank u2
ON
  u1.user_id = u2.user_id
  AND u1.purchase_rank != u2.purchase_rank
  AND abs(DATEDIFF(u2.created_at,u1.created_at)) <= 7;

/* Solution 2:  */
select distinct user_id
from (
select *
,count(*) over (partition by user_id order by created_at range between interval 7 day preceding and current row) as runningrange
,count(*) over (partition by user_id order by created_at rows between 7 preceding and current row) as runnningrow
from users) as t
 where runningrange >= 2