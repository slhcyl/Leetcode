/* 603. Consecutive Available Seats
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.
 

Find all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.

The result format is in the following example.

 

Example 1:

Input: 
Cinema table:
+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output: 
+---------+
| seat_id |
+---------+
| 3       |
| 4       |
| 5       |
+---------+ */

select distinct seat_id
from 
(select seat_id, free 
,lead(free,1) over (order by seat_id) as nextfree
,lag(free,1) over (order by seat_id) as previousfree
from cinema) as t
where (free = 1 and nextfree = 1) or (free = 1 and previousfree =1)
order by 1

# Write your MySQL query statement below
select distinct a.seat_id
from cinema as a 
join cinema as b 
on (a.seat_id = b.seat_id - 1 or a.seat_id = b.seat_id + 1)
and a.free = true and b.free = true
order by seat_id

select distinct a.seat_id
from cinema a join cinema b
  on abs(a.seat_id - b.seat_id) = 1
  and a.free = true and b.free = true
order by a.seat_id
;
