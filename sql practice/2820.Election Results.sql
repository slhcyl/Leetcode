/* 2820. Election Results
Solved
Medium
SQL Schema
Pandas Schema
Table: Votes

+-------------+---------+ 
| Column Name | Type    | 
+-------------+---------+ 
| voter       | varchar | 
| candidate   | varchar |
+-------------+---------+
(voter, candidate) is the primary key (combination of unique values) for this table.
Each row of this table contains name of the voter and their candidate. 
The election is conducted in a city where everyone can vote for one or more candidates or choose not to vote. Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across them. For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 votes each.

Write a solution to find candidate who got the most votes and won the election. Output the name of the candidate or If multiple candidates have an equal number of votes, display the names of all of them.

Return the result table ordered by candidate in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Votes table:
+----------+-----------+
| voter    | candidate |
+----------+-----------+
| Kathy    | null      |
| Charles  | Ryan      |
| Charles  | Christine |
| Charles  | Kathy     |
| Benjamin | Christine |
| Anthony  | Ryan      |
| Edward   | Ryan      |
| Terry    | null      |
| Evelyn   | Kathy     |
| Arthur   | Christine |
+----------+-----------+
Output: 
+-----------+
| candidate | 
+-----------+
| Christine |  
| Ryan      |  
+-----------+
Explanation: 
- Kathy and Terry opted not to participate in voting, resulting in their votes being recorded as 0. Charles distributed his vote among three candidates, equating to 0.33 for each candidate. On the other hand, Benjamin, Arthur, Anthony, Edward, and Evelyn each cast their votes for a single candidate.
- Collectively, Candidate Ryan and Christine amassed a total of 2.33 votes, while Kathy received a combined total of 1.33 votes.
Since Ryan and Christine received an equal number of votes, we will display their names in ascending order. */
# Write your MySQL query statement below
with cte as (
select candidate
,sum(score) as scores
,rank() over (order by sum(score) desc) as ranknbr
from (
select voter
,candidate
,case when candidate is null then 0 else 1/count(*) over (partition by voter) end as score
from votes
) as t
group by candidate
)

select candidate
from cte 
where ranknbr = 1
order by 1