/*  
Code

Testcase
Testcase
Test Result

577. Employee Bonus
Solved
Easy
Topics
Companies
Hint
SQL Schema
Pandas Schema
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| empId       | int     |
| name        | varchar |
| supervisor  | int     |
| salary      | int     |
+-------------+---------+
empId is the column with unique values for this table.
Each row of this table indicates the name and the ID of an employee in addition to their salary and the id of their manager.
 

Table: Bonus

+-------------+------+
| Column Name | Type |
+-------------+------+
| empId       | int  |
| bonus       | int  |
+-------------+------+
empId is the column of unique values for this table.
empId is a foreign key (reference column) to empId from the Employee table.
Each row of this table contains the id of an employee and their respective bonus.
 

Write a solution to report the name and bonus amount of each employee with a bonus less than 1000.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
Output: 
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+*/
# Write your MySQL query statement below
select e.name, b.bonus
from employee as e
left join bonus as b
on e.empid = b.empid
where b.bonus < 1000 or b.bonus is null

/* pandas
Approach 1: Filter and Retrieve
Algorithm
Define the employee_bonus function that takes two DataFrames, employee and bonus, as input parameters and specifies that it returns a DataFrame.

Use the Pandas merge function to combine the employee and bonus DataFrames on the empId column using a left join. This combines employee data with their respective bonuses.

Apply a filter to the merged DataFrame to include only rows where the bonus is less than 1000 or where the bonus is missing (NaN). Use boolean indexing for filtering.

Choose the name and bonus columns from the filtered DataFrame to extract the relevant information.

Return the filtered DataFrame as the output of the function. */

import pandas as pd

def employee_bonus(employee: pd.DataFrame, bonus: pd.DataFrame) -> pd.DataFrame:
    # Merge Employee and Bonus tables using a left join
    result_df = pd.merge(employee, bonus, on='empId', how='left')

    # Filter rows where bonus is less than 1000 or missing
    result_df = result_df[(result_df['bonus'] < 1000) | result_df['bonus'].isnull()]

    # Select "name" and "bonus" columns
    result_df = result_df[['name', 'bonus']]

    return result_df