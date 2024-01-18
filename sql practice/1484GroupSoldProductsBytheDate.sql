/* 1484. Group Sold Products By The Date
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table Activities:

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each row of this table contains the product name and the date it was sold in a market.
 

Write a solution to find for each date the number of different products sold and their names.

The sold products names for each date should be sorted lexicographically.

Return the result table ordered by sell_date.

The result format is in the following example.

 

Example 1:

Input: 
Activities table:
+------------+------------+
| sell_date  | product     |
+------------+------------+
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |
+------------+------------+
Output: 
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
Explanation: 
For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by a comma.
For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by a comma.
For 2020-06-02, the Sold item is (Mask), we just return it. */
-- Write your PostgreSQL query statement below
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    STRING_AGG(distinct product, ',' ORDER BY product) as products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

/* Write your T-SQL query statement below */
WITH DistinctProducts AS (
    SELECT DISTINCT sell_date, product
    FROM Activities
)

SELECT
    sell_date,
    COUNT(product) AS num_sold,
    STRING_AGG(product, ',') WITHIN GROUP (ORDER BY product) AS products
FROM DistinctProducts
GROUP BY sell_date
ORDER BY sell_date;

# Write your MySQL query statement below
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

/* editorial 
The most challenging part is sorting and joining all unique names in each group to get the column products. 
We can use the function GROUP_CONCAT to combine multiple values from multiple rows into a single string. The following shows the syntax of the GROUP_CONCAT() function:

GROUP_CONCAT(
    DISTINCT expression1
    ORDER BY expression2
    SEPARATOR sep
);
*/
SELECT 
    sell_date,
    COUNT(DISTINCT(product)) AS num_sold, 
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM 
    Activities
GROUP BY 
    sell_date
ORDER BY 
    sell_date ASC