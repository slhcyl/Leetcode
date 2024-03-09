/* 601. Human Traffic of Stadium
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Stadium

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the column with unique values for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
As the id increases, the date increases as well.
 

Write a solution to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Output: 
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Explanation: 
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids. */
# Write your MySQL query statement below
/* Now we can start to identify the consecutive ids. Since we want to return all the records with three or more consecutive ids, we want to make sure the id from the current is in any of the possible positions within the three consecutive ids.

When id is in the middle of the three consecutive ids and the order is next_id > id > last_id:

WHERE (next_id - id = 1 AND id - last_id = 1)
When id is the minimum id of the three consecutive ids and the order is second_next_id > next_id > id:

OR (second_next_id - next_id = 1 AND next_id - id = 1)
When id is the maximum id of the three consecutive ids and the order is id > last_id > second_last_id:

OR (id - last_id = 1 AND last_id - second_last_id = 1)
Now the only thing left us to do is to update the output by selecting the required columns and order the result by visit_date in the main query. */
with cte as (
select *
,lead(id,1) over (order by id) as next_id
,lead(id,2) over (order by id) as next_next_id
,lag(id,1) over (order by id) as prev_id
,lag(id,2) over (order by id) as prev_prev_id
from stadium
where people >= 100
)

select 
 id, visit_date, people
from cte

where (next_id - id = 1 and id - prev_id = 1)
or (next_next_id - next_id = 1 and next_id - id = 1)
or (id - prev_id = 1 and prev_id - prev_prev_id = 1)
order by visit_date

/* Approach 1: Using Self-Join
Algorithm
The number of consecutive values we need to identify decides how many table aliases we need to create. For this problem, the number is three. Since we are only interested in the records with people greater than or equal to 100, we can also add the filter to all three table aliases in this step.

SELECT 
    *
FROM 
    stadium AS a, stadium AS b, stadium AS c
WHERE
    a.people >= 100 AND b.people >= 100 AND c.people >= 100
​
Now we can identify the consecutive ids by calculating the differences between ids from each table alias.

If the three ids are consecutive from table a, b, and c, which means the difference between the two ids are 1, we can add filters like below:

WHERE (a.id - b.id = 1 AND b.id - c.id = 1)
But how can we select all three ids from three table aliases and put these ids into one column instead of multiple columns? A workaround is to put one table alias, in this approach we select table a, in all possible positions of the three consecutive ids.

When a.id is the minimum id in the three consecutive ids (c.id > b.id > a.id):

(c.id - b.id = 1 AND b.id - a.id = 1)
When a.id is in the middle of the three consecutive ids (b.id > a.id > c.id):

(b.id - a.id = 1 AND a.id - c.id = 1)
Now we can just SELECT records from table a and ORDER the results by visit_date as requested. */
SELECT 
    DISTINCT a.*
FROM 
    stadium AS a, stadium AS b, stadium AS c
WHERE
     a.people >= 100 AND b.people >= 100 AND c.people >= 100
AND 
    (
       (a.id - b.id = 1 AND b.id - c.id = 1)
    OR (c.id - b.id = 1 AND b.id - a.id = 1)
    OR (b.id - a.id = 1 AND a.id - c.id = 1)
    )
ORDER BY visit_date
