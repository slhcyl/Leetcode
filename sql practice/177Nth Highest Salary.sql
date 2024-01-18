/* 177. Nth Highest Salary
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the nth highest salary from the Employee table. If there is no nth highest salary, return null.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
n = 2
Output: 
+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| null                   |
+------------------------+ */
/* Approach: Sort and Limit
Algorithm
In SQL, the query to find the nthn^{th}n 
th
  highest salary involves sorting the distinct salaries in descending order and limiting the result to the nth row. Here we subtract 1 from N because SQL indexing starts from 0.

This task requires to find the nth highest salary from the Employee table. If there is no nth highest salary, the query should return null. This implies that we have to order the salary column in descending order and pick the nth entry.

Here is an example to help solidify the intuition behind the algorithm:

Original Employee table with N = 2:
Sub-Table after removing duplicates via SELECT DISTINCT: 
Sub-Table after sorting in descending order via ORDER BY salary DESC:
And the 2nd highest salary is 300, which can be found by taking the second row in the descendingly-ordered table! We do this with LIMIT M, 1 which takes the next 1 row starting from the Mth row (indexed from 0).

Note that in SQL, the order of execution for the clauses in a query is generally as follows:

FROM clause: This specifies the tables from which data will be retrieved.
WHERE clause: This filters the rows based on a specified condition.
GROUP BY clause: This groups rows based on a specified column or expression.
HAVING clause: This filters the grouped rows based on a condition.
SELECT clause: This selects the columns or expressions that will be returned in the result set.
ORDER BY clause: This sorts the result set based on a specified column or expression.
LIMIT/OFFSET clause: This limits the number of rows returned in the result set.
Note: Your DBMS may execute a query in an equivalent but different order.*/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT; 
    SET M = N-1; 
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
      LIMIT M, 1
  );
END

/* LIMIT row_count OFFSET offset
LIMIT [offset,] row_count;
The offset specifies the offset of the first row to return. The offset of the first row is 0, not 1.
The row_count specifies the maximum number of rows to return.
 */

 CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT; 
    SET M = N-1; 
  RETURN (
      SELECT DISTINCT salary
      FROM Employee
      ORDER BY salary DESC
    #   LIMIT M, 1
      LIMIT 1 OFFSET M
  );
END