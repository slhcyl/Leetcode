/* 1205. Monthly Transactions II
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the column of unique values of this table.
The table has information about incoming transactions.
The state column is an ENUM (category) of type ["approved", "declined"].
Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| trans_date     | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key (reference column) to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write a solution to find for each month and country: the number of approved transactions and their total amount, the number of chargebacks, and their total amount.

Note: In your solution, given the month and country, ignore rows with all zeros.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+-----+---------+----------+--------+------------+
| id  | country | state    | amount | trans_date |
+-----+---------+----------+--------+------------+
| 101 | US      | approved | 1000   | 2019-05-18 |
| 102 | US      | declined | 2000   | 2019-05-19 |
| 103 | US      | approved | 3000   | 2019-06-10 |
| 104 | US      | declined | 4000   | 2019-06-13 |
| 105 | US      | approved | 5000   | 2019-06-15 |
+-----+---------+----------+--------+------------+
Chargebacks table:
+----------+------------+
| trans_id | trans_date |
+----------+------------+
| 102      | 2019-05-29 |
| 101      | 2019-06-30 |
| 105      | 2019-09-18 |
+----------+------------+
Output: 
+---------+---------+----------------+-----------------+------------------+-------------------+
| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
+---------+---------+----------------+-----------------+------------------+-------------------+
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 2              | 8000            | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |
+---------+---------+----------------+-----------------+------------------+-------------------+ */
# Write your MySQL query statement below
# mysql dosen't have full join and need to use union all
# In your solution, given the month and country, ignore rows with all zeros. that means we need to limit transaction with approved only
select month
,country
,sum(approved_count) as approved_count
,sum(approved_amount) as approved_amount
,sum(chargeback_count) as chargeback_count
,sum(chargeback_amount) as chargeback_amount
from (
select date_format(a.trans_date, '%Y-%m') as month
,b.country
,0 as approved_count
,0 as approved_amount
,count(a.trans_id) as chargeback_count
,sum(b.amount) as chargeback_amount
from chargebacks as a
inner join transactions as b
on a.trans_id = b.id
group by date_format(a.trans_date, '%Y-%m')
,b.country

union all

select date_format(trans_date, '%Y-%m') as month
,country
,count(*) as approved_count
,sum(amount) as approved_amount
,0 as chargeback_count
,0 as chargeback_amount
from transactions
where state = 'approved'
group by date_format(trans_date, '%Y-%m') 
,country
) as t
group by month, country

/* Write your T-SQL query statement below */
with chargecte as (
select format(a.trans_date, 'yyyy-MM') as month
,b.country
,count(a.trans_id) as chargeback_count
,sum(b.amount) as chargeback_amount
from chargebacks as a
inner join transactions as b
on a.trans_id = b.id
group by format(a.trans_date, 'yyyy-MM')
,b.country
)

,transcte as (
select format(trans_date, 'yyyy-MM') as month
,country
,sum(case when state = 'approved' then 1 else 0 end) as approved_count
,sum(case when state = 'approved' then amount else 0 end) as approved_amount
from transactions
where state = 'approved'
group by format(trans_date, 'yyyy-MM') 
,country
)

select 
coalesce(a.month,b.month) as month
,coalesce(a.country,b.country) as country
,isnull(b.approved_count,0) as approved_count
,isnull(b.approved_amount,0) as approved_amount
,isnull(a.chargeback_count,0) as chargeback_count
,isnull(a.chargeback_amount,0) as chargeback_amount
from chargecte as a
full outer join transcte as b
on a.country = b.country
and a.month = b.month