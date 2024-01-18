

WITH MaxSubmission AS (
    SELECT Submission_date,hacker_id,name
    FROM (
SELECT s.Submission_date
    ,s.hacker_id
    ,h.name
    ,RANK() OVER (PARTITION BY s.Submission_date ORDER BY COUNT(s.hacker_id) DESC, s.hacker_id) AS ranknbr
FROM Submissions AS s
    JOIN Hackers AS h
    on s.hacker_id = h.hacker_id
GROUP BY s.Submission_date
    ,s.hacker_id
    ,h.name
         ) as t
where ranknbr=1
)

,UniqueCNT AS (
SELECT Submission_date, COUNT(DISTINCT hacker_id) AS UniqueHackerCNT
FROM (
SELECT s.Submission_date
    ,s.hacker_id
    ,DENSE_RANK() OVER (ORDER BY s.Submission_date) AS daySeq
    ,DENSE_RANK() OVER (PARTITION BY s.hacker_id ORDER BY s.Submission_date) AS hackerSubSeq
FROM Submissions s
) T
WHERE daySeq = hackerSubSeq
GROUP BY Submission_date
)

SELECT a.Submission_date,b.UniqueHackerCNT,a.hacker_id,a.name
FROM MaxSubmission as a
JOIN UniqueCNT as b
ON a.Submission_date = b.Submission_date
order by 1

/* option 2 */
select big_1.submission_date, big_1.hkr_cnt, big_2.hacker_id, h.name
from
(
    select submission_date, count(distinct hacker_id) as hkr_cnt
    from 
        (
            select s.submission_date,S.hacker_id
            ,dense_rank() over(order by s.submission_date) as date_rank
            ,dense_rank() over(partition by s.hacker_id order by submission_date) as hacker_rank 
            from submissions s 
            ) a 
    where date_rank = hacker_rank 
    group by submission_date
) big_1 
join 
(select submission_date,hacker_id, 
 rank() over(partition by submission_date order by sub_cnt desc, hacker_id) as max_rank 
from (select submission_date, hacker_id, count(*) as sub_cnt 
      from submissions 
      group by submission_date, hacker_id) b ) big_2
on big_1.submission_date = big_2.submission_date and big_2.max_rank = 1 
join hackers h on h.hacker_id = big_2.hacker_id 
order by 1 ;


