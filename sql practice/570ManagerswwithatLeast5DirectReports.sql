/*570. Managers with at Least 5 Direct Reports
Solved
Medium
Topics
Companies
Hint
SQL Schema
Pandas Schema
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+ 
Approach: Group By and Join */
SELECT
    Name
FROM
    Employee AS t1 
JOIN
    (SELECT 
        ManagerId
    FROM 
        Employee
    GROUP BY ManagerId
    HAVING COUNT(ManagerId) >= 5) AS t2
ON 
    t1.Id = t2.ManagerId
;

/* Approach 2: IN Clause with Subquery */
SELECT
    name
FROM
    employee
WHERE
    id IN (
        SELECT
            managerId
        FROM
            employee
        GROUP BY
            managerId
        HAVING COUNT(*) >= 5
    );

