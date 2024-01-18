/* 1747. Leetflex Banned Accounts
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: LogInfo

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| account_id  | int      |
| ip_address  | int      |
| login       | datetime |
| logout      | datetime |
+-------------+----------+
This table may contain duplicate rows.
The table contains information about the login and logout dates of Leetflex accounts. It also contains the IP address from which the account was logged in and out.
It is guaranteed that the logout time is after the login time.
 

Write a solution to find the account_id of the accounts that should be banned from Leetflex. An account should be banned if it was logged in at some moment from two different IP addresses.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
LogInfo table:
+------------+------------+---------------------+---------------------+
| account_id | ip_address | login               | logout              |
+------------+------------+---------------------+---------------------+
| 1          | 1          | 2021-02-01 09:00:00 | 2021-02-01 09:30:00 |
| 1          | 2          | 2021-02-01 08:00:00 | 2021-02-01 11:30:00 |
| 2          | 6          | 2021-02-01 20:30:00 | 2021-02-01 22:00:00 |
| 2          | 7          | 2021-02-02 20:30:00 | 2021-02-02 22:00:00 |
| 3          | 9          | 2021-02-01 16:00:00 | 2021-02-01 16:59:59 |
| 3          | 13         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
| 4          | 10         | 2021-02-01 16:00:00 | 2021-02-01 17:00:00 |
| 4          | 11         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
+------------+------------+---------------------+---------------------+
Output: 
+------------+
| account_id |
+------------+
| 1          |
| 4          |
+------------+
Explanation: 
Account ID 1 --> The account was active from "2021-02-01 09:00:00" to "2021-02-01 09:30:00" with two different IP addresses (1 and 2). It should be banned.
Account ID 2 --> The account was active from two different addresses (6, 7) but in two different times.
Account ID 3 --> The account was active from two different addresses (9, 13) on the same day but they do not intersect at any moment.
Account ID 4 --> The account was active from "2021-02-01 17:00:00" to "2021-02-01 17:00:00" with two different IP addresses (10 and 11). It should be banned. */
# Write your MySQL query statement below
select distinct a.account_id
from logInfo as a
join logInfo as b 
on a.account_id = b.account_id 
and a.ip_address != b.ip_address
# and a.logout >= b.login and a.login <= b.logout
# and a.logout between b.login and b.logout
# and a.logout >= b.login and a.logout <= b.logout
and not (a.logout < b.login or a.login > b.logout)

# Write your MySQL query statement below
select distinct b.account_id
from loginfo as a
join loginfo as b 
on a.account_id = b.account_id
and a.ip_address != b.ip_address
# and a.login <= b.logout and a.logout >= b.login
and a.logout between b.login and b.logout

/* A self-join and a cross join involving the same table can result in similar or identical results under certain conditions. Let's break down each scenario:

Self-Join:

A self-join occurs when a table is joined with itself. This is often done by using aliases to differentiate between the two instances of the same table.
The self-join is usually performed based on some condition, such as matching values in specific columns.
Example:

sql
Copy code
SELECT A.*, B.*
FROM YourTable A
JOIN YourTable B ON A.some_column = B.some_column;
Cross Join:

A cross join, on the other hand, results in a Cartesian product of the two instances of the same table. It means each row from the first instance is combined with each row from the second instance.
Example:

sql
Copy code
SELECT A.*, B.*
FROM YourTable A
CROSS JOIN YourTable B;
If the condition in your self-join is not restrictive enough, or if the join condition allows for a wide range of matches, the result of the self-join might be similar to that of a cross join.

For example, consider a case where the join condition in the self-join is not specific enough, and it effectively allows for many matches or all rows to be matched. In such cases, the self-join result might resemble the result of a cross join.

It's crucial to carefully define the join conditions in a self-join to achieve the desired results and avoid unintentional cross-join-like behavior. Always consider how the data should be related between the instances of the same table to get meaningful results. */

