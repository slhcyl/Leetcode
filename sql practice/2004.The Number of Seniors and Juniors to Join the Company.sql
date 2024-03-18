/* 2004. The Number of Seniors and Juniors to Join the Company
Solved
Hard
Topics
Companies
SQL Schema
Pandas Schema
Table: Candidates

+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the column with unique values for this table.
experience is an ENUM (category) type of values ('Senior', 'Junior').
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.
 

A company wants to hire new employees. The budget of the company for the salaries is $70000. The company's criteria for hiring are:

Hiring the largest number of seniors.
After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.
Write a solution to find the number of seniors and juniors hired under the mentioned criteria.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 20000  |
| 11          | Senior     | 20000  |
| 13          | Senior     | 50000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output: 
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 2                   |
| Junior     | 2                   |
+------------+---------------------+
Explanation: 
We can hire 2 seniors with IDs (2, 11). Since the budget is $70000 and the sum of their salaries is $40000, we still have $30000 but they are not enough to hire the senior candidate with ID 13.
We can hire 2 juniors with IDs (1, 9). Since the remaining budget is $30000 and the sum of their salaries is $20000, we still have $10000 but they are not enough to hire the junior candidate with ID 4.
Example 2:

Input: 
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 80000  |
| 11          | Senior     | 80000  |
| 13          | Senior     | 80000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output: 
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 0                   |
| Junior     | 3                   |
+------------+---------------------+
Explanation: 
We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
We can hire all three juniors with the remaining budget. */
# Write your MySQL query statement below
with cte as (
select *,sum(salary) over (partition by experience order by salary) as cumulative_salary
from candidates)

select 'Senior' as experience, count(*) as accepted_candidates
from cte 
where experience = 'Senior' and cumulative_salary <= 70000
union all 
select 'Junior' as experience, count(*) as accepted_candidates
from cte 
where experience = 'Junior' 
and cumulative_salary <= (select 70000 - ifnull(max(cumulative_salary),0) from cte where experience = 'Senior' and cumulative_salary<= 70000)

/* solution 2 */
with senior_salary as (
select *
,sum(salary) over (order by salary) as cumulative_salary
from candidates
where experience = 'senior'
)
,junior_salary as (
select *
,sum(salary) over (order by salary) as cumulative_salary
from candidates
where experience = 'junior'
)

,hiredSenior as (
select count(*) as cnt
from senior_salary
where cumulative_salary <= 70000
)

,remainingbudget as (
select 70000 - ifnull(max(cumulative_salary),0) as budget FROM senior_salary WHERE cumulative_salary <= 70000 
)

,hiredJunior as (
select count(*) cnt
from junior_salary
where cumulative_salary <= (select budget from  remainingbudget)
)

select 'Senior' as experience, (select cnt from hiredSenior) as accepted_candidates
union all
select 'Junior' as experience, (select cnt from hiredJunior) as accepted_candidates