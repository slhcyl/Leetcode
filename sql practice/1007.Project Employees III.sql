/* 1077. Project Employees III
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Project

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| project_id  | int     |
| employee_id | int     |
+-------------+---------+
(project_id, employee_id) is the primary key (combination of columns with unique values) of this table.
employee_id is a foreign key (reference column) to Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with project_id.
 

Table: Employee

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| employee_id      | int     |
| name             | varchar |
| experience_years | int     |
+------------------+---------+
employee_id is the primary key (column with unique values) of this table.
Each row of this table contains information about one employee.
 

Write a solution to report the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Project table:
+-------------+-------------+
| project_id  | employee_id |
+-------------+-------------+
| 1           | 1           |
| 1           | 2           |
| 1           | 3           |
| 2           | 1           |
| 2           | 4           |
+-------------+-------------+
Employee table:
+-------------+--------+------------------+
| employee_id | name   | experience_years |
+-------------+--------+------------------+
| 1           | Khaled | 3                |
| 2           | Ali    | 2                |
| 3           | John   | 3                |
| 4           | Doe    | 2                |
+-------------+--------+------------------+
Output: 
+-------------+---------------+
| project_id  | employee_id   |
+-------------+---------------+
| 1           | 1             |
| 1           | 3             |
| 2           | 1             |
+-------------+---------------+
Explanation: Both employees with id 1 and 3 have the most experience among the employees of the first project. For the second project, the employee with id 1 has the most experience. */
# Write your MySQL query statement below
select project_id,employee_id
from 
(select p.project_id,p.employee_id
,e.experience_years
,dense_rank() over (partition by p.project_id order by experience_years desc) as ranknbr
from project as p 
join employee as e 
on p.employee_id = e.employee_id) as t
where ranknbr = 1;

WITH project_and_employee AS(
  SELECT t0.project_id, t1.employee_id, experience_years
  FROM Project t0
  JOIN Employee t1
  ON t0.employee_id = t1.employee_id
)
SELECT a.project_id, employee_id
FROM project_and_employee a
JOIN 
    (SELECT project_id, 
            MAX(experience_years) AS max_experience 
     FROM project_and_employee
     GROUP BY 1)b
ON a.project_id = b.project_id
AND a.experience_years = b.max_experience