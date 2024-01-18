/* 
Code

Testcase
Testcase
Test Result

1965. Employees With Missing Information
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the column with unique values for this table.
Each row of this table indicates the name of the employee whose ID is employee_id.
 

Table: Salaries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
employee_id is the column with unique values for this table.
Each row of this table indicates the salary of the employee whose ID is employee_id.
 

Write a solution to report the IDs of all the employees with missing information. The information of an employee is missing if:

The employee's name is missing, or
The employee's salary is missing.
Return the result table ordered by employee_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
Explanation: 
Employees 1, 2, 4, and 5 are working at this company.
The name of employee 1 is missing.
The salary of employee 2 is missing. */
select a.employee_id 
from employees as a 
left join salaries as b 
on a.employee_id = b.employee_id
where b.employee_id is null
union
select a.employee_id
from salaries as a 
left join employees as b
on a.employee_id = b.employee_id
where b.employee_id is null
order by employee_id;

# Write your MySQL query statement below
select employee_id
from employees
where employee_id not in (
    select employee_id from salaries
)
union
select employee_id
from salaries
where employee_id not in (
    select employee_id
    from employees
)
order by employee_id
/* FULL JOIN
MySQL does not support FULL JOIN, so you have to combine JOIN, UNION and LEFT JOIN to get an equivalent. It gives the results of A union B. 
It returns all records from both tables. Those columns which exist in only one table will contain NULL in the opposite table.
 */
 SELECT T.employee_id
FROM  
  (SELECT * FROM Employees LEFT JOIN Salaries USING(employee_id)
   UNION 
   SELECT * FROM Employees RIGHT JOIN Salaries USING(employee_id))
AS T
WHERE T.salary IS NULL OR T.name IS NULL
ORDER BY employee_id;

/* Write your T-SQL query statement below */
select 
distinct  coalesce(a.employee_id,b.employee_id) as employee_id
from employees as a 
full join salaries as b 
on a.employee_id = b.employee_id
where a.employee_id is null or b.employee_id is null