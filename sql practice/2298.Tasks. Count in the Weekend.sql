/* 2298. Tasks Count in the Weekend
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Tasks

+-------------+------+
| Column Name | Type |
+-------------+------+
| task_id     | int  |
| assignee_id | int  |
| submit_date | date |
+-------------+------+
task_id is the primary key (column with unique values) for this table.
Each row in this table contains the ID of a task, the id of the assignee, and the submission date.
 

Write a solution to report:

the number of tasks that were submitted during the weekend (Saturday, Sunday) as weekend_cnt, and
the number of tasks that were submitted during the working days as working_cnt.
Return the result table in any order.

The result format is shown in the following example.

 

Example 1:

Input: 
Tasks table:
+---------+-------------+-------------+
| task_id | assignee_id | submit_date |
+---------+-------------+-------------+
| 1       | 1           | 2022-06-13  |
| 2       | 6           | 2022-06-14  |
| 3       | 6           | 2022-06-15  |
| 4       | 3           | 2022-06-18  |
| 5       | 5           | 2022-06-19  |
| 6       | 7           | 2022-06-19  |
+---------+-------------+-------------+
Output: 
+-------------+-------------+
| weekend_cnt | working_cnt |
+-------------+-------------+
| 3           | 3           |
+-------------+-------------+
Explanation: 
Task 1 was submitted on Monday.
Task 2 was submitted on Tuesday.
Task 3 was submitted on Wednesday.
Task 4 was submitted on Saturday.
Task 5 was submitted on Sunday.
Task 6 was submitted on Sunday.
3 tasks were submitted during the weekend.
3 tasks were submitted during the working days. */
# Write your MySQL query statement below
select sum(case when weekday(submit_date) < 5 then 1 else 0 end) as weekend_cnt
,sum(case when weekday(submit_date) >= 5 then 1 else 0 end) as working_cnt
from tasks