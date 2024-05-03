/* 2752. Customers with Maximum Number of Transactions on Consecutive Days
Solved
Hard
Topics
SQL Schema
Pandas Schema
Table: Transactions

+------------------+------+
| Column Name      | Type |
+------------------+------+
| transaction_id   | int  |
| customer_id      | int  |
| transaction_date | date |
| amount           | int  |
+------------------+------+
transaction_id is the column with unique values of this table.
Each row contains information about transactions that includes unique (customer_id, transaction_date) along with the corresponding customer_id and amount.   
Write a solution to find all customer_id who made the maximum number of transactions on consecutive days.

Return all customer_id with the maximum number of consecutive transactions. Order the result table by customer_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+----------------+-------------+------------------+--------+
| transaction_id | customer_id | transaction_date | amount |
+----------------+-------------+------------------+--------+
| 1              | 101         | 2023-05-01       | 100    |
| 2              | 101         | 2023-05-02       | 150    |
| 3              | 101         | 2023-05-03       | 200    |
| 4              | 102         | 2023-05-01       | 50     |
| 5              | 102         | 2023-05-03       | 100    |
| 6              | 102         | 2023-05-04       | 200    |
| 7              | 105         | 2023-05-01       | 100    |
| 8              | 105         | 2023-05-02       | 150    |
| 9              | 105         | 2023-05-03       | 200    |
+----------------+-------------+------------------+--------+
Output: 
+-------------+
| customer_id | 
+-------------+
| 101         | 
| 105         | 
+-------------+
Explanation: 
- customer_id 101 has a total of 3 transactions, and all of them are consecutive.
- customer_id 102 has a total of 3 transactions, but only 2 of them are consecutive. 
- customer_id 105 has a total of 3 transactions, and all of them are consecutive.
In total, the highest number of consecutive transactions is 3, achieved by customer_id 101 and 105. The customer_id are sorted in ascending order. */
# Write your MySQL query statement below
WITH RankedTransactions AS (
    SELECT 
        customer_id,
        transaction_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date) AS row_num
    FROM 
        Transactions
)
,ConsecutiveGroups AS (
    SELECT
        customer_id,
        transaction_date,
        DATE_SUB(transaction_date, INTERVAL row_num DAY) AS group_date
       ,row_num
    FROM 
        RankedTransactions
)
,ConsecutiveCounts AS (
    SELECT
        customer_id,
        group_date,
        COUNT(*) AS consecutive_count
    FROM
        ConsecutiveGroups
    GROUP BY
        customer_id,
        group_date
)
SELECT
    customer_id
FROM
    ConsecutiveCounts
WHERE
    consecutive_count = (
        SELECT MAX(consecutive_count) FROM ConsecutiveCounts
    )
ORDER BY
    customer_id;