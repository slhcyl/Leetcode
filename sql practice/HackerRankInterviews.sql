/* Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, hacker_id, name, and the sums of total_submissions, total_accepted_submissions, total_views, and total_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are .

Note: A specific contest can be used to screen candidates at more than one college, but each college only holds  screening contest.

Input Format

The following tables hold interview data:

Contests: The contest_id is the id of the contest, hacker_id is the id of the hacker who created the contest, and name is the name of the hacker. 

Colleges: The college_id is the id of the college, and contest_id is the id of the contest that Samantha used to screen the candidates. 

Challenges: The challenge_id is the id of the challenge that belongs to one of the contests whose contest_id Samantha forgot, and college_id is the id of the college where the challenge was given to candidates. 

View_Stats: The challenge_id is the id of the challenge, total_views is the number of times the challenge was viewed by candidates, and total_unique_views is the number of times the challenge was viewed by unique candidates. 

Submission_Stats: The challenge_id is the id of the challenge, total_submissions is the number of submissions for the challenge, and total_accepted_submission is the number of submissions that achieved full scores. 

Sample Input

Contests Table:  Colleges Table:  Challenges Table:  View_Stats Table:  Submission_Stats Table: 

Sample Output

66406 17973 Rose 111 39 156 56
66556 79153 Angela 0 0 11 10
94828 80275 Frank 150 38 41 15
Explanation

The contest  is used in the college . In this college , challenges  and  are asked, so from the view and submission stats:

Sum of total submissions 

Sum of total accepted submissions 

Sum of total views 

Sum of total unique views 

Similarly, we can find the sums for contests  and . */
With totalSubStats AS (
SELECT challenge_id
    ,SUM(total_submissions) AS total_submissions
    ,SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id
)
,totalViewStats AS (
SELECT challenge_id
    ,SUM(total_views) AS total_views
    ,SUM(total_unique_views) AS total_unique_views
    FROM View_Stats
    GROUP BY challenge_id
)

select ct.contest_id, ct.hacker_id, ct.name
,SUM(ss.total_submissions) AS total_submissions
,SUM(ss.total_accepted_submissions) AS total_accepted_submissions
,SUM(vs.total_views) AS total_views
,SUM(vs.total_unique_views) AS total_unique_views 
from Contests as ct
LEFT join Colleges as cl
    on ct.contest_id = cl.contest_id
LEFT join Challenges as ch
    on cl.college_id = ch.college_id
LEFT join totalViewStats as vs
    on ch.challenge_id = vs.challenge_id
LEFT join totalSubStats as ss
    on ch.challenge_id = ss.challenge_id
group by ct.contest_id, ct.hacker_id, ct.name
having SUM(ss.total_submissions) + SUM(ss.total_accepted_submissions) +SUM(vs.total_views) + SUM(vs.total_unique_views) <> 0
order by contest_id;
