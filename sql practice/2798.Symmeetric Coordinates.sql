/* 2978. Symmetric Coordinates
Solved
Medium
Topics
SQL Schema
Pandas Schema
Table: Coordinates

+-------------+------+
| Column Name | Type |
+-------------+------+
| X           | int  |
| Y           | int  |
+-------------+------+
Each row includes X and Y, where both are integers. Table may contain duplicate values.
Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes if X1 == Y2 and X2 == Y1.

Write a solution that outputs, among all these symmetric coordintes, only those unique coordinates that satisfy the condition X1 <= Y1.

Return the result table ordered by X and Y (respectively) in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Coordinates table:
+----+----+
| X  | Y  |
+----+----+
| 20 | 20 |
| 20 | 20 |
| 20 | 21 |
| 23 | 22 |
| 22 | 23 |
| 21 | 20 |
+----+----+
Output: 
+----+----+
| x  | y  |
+----+----+
| 20 | 20 |
| 20 | 21 |
| 22 | 23 |
+----+----+
Explanation: 
- (20, 20) and (20, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. This results in displaying (20, 20) as a distinctive coordinates.
- (20, 21) and (21, 20) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (20, 21) will be displayed because X1 <= Y1.
- (23, 22) and (22, 23) are symmetric coordinates because, X1 == Y2 and X2 == Y1. However, only (22, 23) will be displayed because X1 <= Y1.
The output table is sorted by X and Y in ascending order. */
# Write your MySQL query statement below
with cte as (
select  x,y
,row_number() over (order by x,y) as rownbr
from coordinates
)
select  distinct a.x,a.y
from cte as a, cte as b
where a.x=b.y and a.y=b.x
and a.x <= a.y
and a.rownbr != b.rownbr
order by x,y