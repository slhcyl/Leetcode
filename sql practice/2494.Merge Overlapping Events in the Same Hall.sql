/* 2494. Merge Overlapping Events in the Same Hall
Solved
Hard
Topics
SQL Schema
Pandas Schema
Table: HallEvents

+-------------+------+
| Column Name | Type |
+-------------+------+
| hall_id     | int  |
| start_day   | date |
| end_day     | date |
+-------------+------+
This table may contain duplicates rows.
Each row of this table indicates the start day and end day of an event and the hall in which the event is held.
 

Write a solution to merge all the overlapping events that are held in the same hall. Two events overlap if they have at least one day in common.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
HallEvents table:
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-14 |
| 1       | 2023-01-14 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 2       | 2022-12-13 | 2022-12-17 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Output: 
+---------+------------+------------+
| hall_id | start_day  | end_day    |
+---------+------------+------------+
| 1       | 2023-01-13 | 2023-01-17 |
| 1       | 2023-01-18 | 2023-01-25 |
| 2       | 2022-12-09 | 2022-12-23 |
| 3       | 2022-12-01 | 2023-01-30 |
+---------+------------+------------+
Explanation: There are three halls.
Hall 1:
- The two events ["2023-01-13", "2023-01-14"] and ["2023-01-14", "2023-01-17"] overlap. We merge them in one event ["2023-01-13", "2023-01-17"].
- The event ["2023-01-18", "2023-01-25"] does not overlap with any other event, so we leave it as it is.
Hall 2:
- The two events ["2022-12-09", "2022-12-23"] and ["2022-12-13", "2022-12-17"] overlap. We merge them in one event ["2022-12-09", "2022-12-23"].
Hall 3:
- The hall has only one event, so we return it. Note that we only consider the events of each hall separately. */
# Write your MySQL query statement below
WITH RECURSIVE sorted_events AS (
  SELECT 
    hall_id, 
    start_day, 
    end_day,
    ROW_NUMBER() OVER (PARTITION BY hall_id ORDER BY start_day, end_day) AS rn
  FROM 
    HallEvents
),
merged_events AS (
  SELECT 
    hall_id, 
    start_day, 
    end_day, 
    rn
  FROM 
    sorted_events
  WHERE 
    rn = 1

  UNION ALL

  SELECT 
    e.hall_id,
    CASE
      WHEN e.start_day <= m.end_day THEN m.start_day
      ELSE e.start_day END as start_day,
    CASE
      WHEN e.end_day <= m.end_day THEN m.end_day
      WHEN e.start_day <= m.end_day THEN e.end_day
      ELSE e.end_day END as end_day,
    e.rn
  FROM 
    sorted_events e
  JOIN 
    merged_events m ON e.hall_id = m.hall_id AND e.rn = m.rn + 1
)

  SELECT 
   hall_id
   ,start_day
   ,MAX(end_day) as end_day
  FROM 
    merged_events
 Group by hall_id, start_day
;

# Write your MySQL query statement below
WITH RECURSIVE rn_cte AS (
    SELECT *,
    ROW_NUMBER() OVER (PARTITION by hall_id ORDER BY start_day) AS rn 
    FROM (SELECT DISTINCT * FROM HallEvents) h
),
merge_cte_recursive AS (
    SELECT
    hall_id,
    start_day,
    end_day,
    rn
    FROM rn_cte r
    WHERE r.rn = 1

    UNION

    SELECT
    r.hall_id,
    CASE WHEN r.start_day between m.start_day and m.end_day 
        THEN m.start_day ELSE r.start_day END AS start_day,
    CASE WHEN r.end_day between m.start_day and m.end_day
        THEN m.end_day ELSE r.end_day END AS end_day,
    r.rn
    FROM rn_cte r 
    JOIN merge_cte_recursive m 
    ON r.rn = m.rn + 1
    and r.hall_id = m.hall_id
)
SELECT
hall_id,
start_day,
MAX(end_day) AS end_day
FROM merge_cte_recursive
GROUP BY hall_id, start_day;