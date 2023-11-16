/* 1378. Replace Employee ID With The Unique Identifier
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the id and the name of an employee in a company.
 

Table: EmployeeUNI

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| unique_id     | int     |
+---------------+---------+
(id, unique_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the company.
 

Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employees table:
+----+----------+
| id | name     |
+----+----------+
| 1  | Alice    |
| 7  | Bob      |
| 11 | Meir     |
| 90 | Winston  |
| 3  | Jonathan |
+----+----------+
EmployeeUNI table:
+----+-----------+
| id | unique_id |
+----+-----------+
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |
+----+-----------+
Output: 
+-----------+----------+
| unique_id | name     |
+-----------+----------+
| null      | Alice    |
| null      | Bob      |
| 2         | Meir     |
| 3         | Winston  |
| 1         | Jonathan |
+-----------+----------+
Explanation: 
Alice and Bob do not have a unique ID, We will show null instead.
The unique ID of Meir is 2.
The unique ID of Winston is 3.
The unique ID of Jonathan is 1. */
# Write your MySQL query statement below
/* Approach: Left Join on ID */
select eu.unique_id , e.name
from employees as e
left join employeeuni as eu
on e.id = eu.id


/* Approach: Left Join on ID
Algorithm
To combine employee names with their unique ids and get the related data from two DataFrames, 
let's merge employees and employee_uni based on the common column id. This can be implemented using the merge() function in Pandas. 
Note that we need to set some parameters in merge:

employees and employee_uni: these are the two DataFrames that we want to merge.
on='id', this specifies the column on which the merge operation will be performed. Both DataFrames contain the column id.
how='left': this defines the type of merge to be performed. The left merge means that all the rows from the employees DataFrame will be included in the result, 
and any matching rows from the employee_uni DataFrame will also be included. Hence, employees without unique IDs will also be retained, but their corresponding 
columns from employee_uni will be filled with NaN (Not a Number) values.
employee_name_uni = pd.merge(employees, employee_uni, on='id', how='left')
This creates the employee_name_uni DataFrame as shown below, where all the rows from employees are preserved and additional information from employee_uni is included 
for the matching id values. For rows that don't have a matching id in employee_uni, the corresponding columns from employee_uni are filled with NaN. */
import pandas as pd

def replace_employee_id(employees: pd.DataFrame, employee_uni: pd.DataFrame) -> pd.DataFrame:
    employee_name_uni = pd.merge(employees, employee_uni, on='id', how='left')
    answer = employee_name_uni[['unique_id','name']]
    return answer