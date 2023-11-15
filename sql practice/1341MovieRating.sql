/*1341. Movie Rating
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Movies

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key (column with unique values) for this table.
title is the name of the movie.
 

Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.
 

Table: MovieRating

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key (column with unique values) for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date. 
 

Write a solution to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
The result format is in the following example.

 

Example 1:

Input: 
Movies table:
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
Users table:
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
MovieRating table:
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
Output: 
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
Explanation: 
Daniel and Monica have rated 3 movies ("Avengers", "Frozen 2" and "Joker") but Daniel is smaller lexicographically.
Frozen 2 and Joker have a rating average of 3.5 in February but Frozen 2 is smaller lexicographically.*/
# Write your MySQL query statement below
select name as results
from (
select u.name, count(movie_id) as cnt
from MovieRating as mr
inner join users as u
on mr.user_id = u.user_id
group by u.name
order by cnt desc, name
limit 1
) t

union all

select title as results
from (
select m.title, avg(mr.rating) as rating
from MovieRating as mr
inner join movies as m
on mr.movie_id = m.movie_id
where mr.created_at BETWEEN '2020-02-01' AND '2020-02-28'
group by m.title
order by rating desc, title
limit 1
) t;

select name as results
from (
select u.name, count(mr.movie_id) as cnt
,row_number() over (order by count(mr.movie_id) desc, u.name) as RowNBR
from MovieRating as mr
inner join users as u
on mr.user_id = u.user_id
group by u.name
) t
WHERE RowNBR = 1

union all

select title as results
from (
select m.title, avg(mr.rating*1.0) as rating  
,row_number() over (order by avg(mr.rating*1.0) desc, m.title) as RowNBR
from MovieRating as mr
inner join movies as m
on mr.movie_id = m.movie_id
where mr.created_at BETWEEN '2020-02-01' AND '2020-02-28'
group by m.title 
) t
WHERE RowNBR = 1;

SELECT DISTINCT FIRST_VALUE(u.name) OVER(ORDER BY COUNT(r.movie_id) DESC, u.name ASC) AS results
FROM Users AS u LEFT JOIN MovieRating AS r
ON u.user_id=r.user_id
GROUP BY u.user_id,u.name
UNION ALL
SELECT DISTINCT FIRST_VALUE(m.title) OVER(ORDER BY AVG(r.rating*1.0) DESC, m.title ASC) AS results
FROM Movies AS m join MovieRating AS r
ON m.movie_id=r.movie_id
WHERE r.created_at BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY m.movie_id,m.title

/* Write your T-SQL query statement below */
select name as results
from (
select u.name, count(mr.movie_id) as cnt
,row_number() over (order by count(mr.movie_id) desc, u.name) as RowNBR
from MovieRating as mr
inner join users as u
on mr.user_id = u.user_id
group by u.name
) t
WHERE RowNBR = 1

union all

select title as results
from (
select m.title, avg(mr.rating*1.0) as rating  
,row_number() over (order by avg(mr.rating*1.0) desc, m.title) as RowNBR
from MovieRating as mr
inner join movies as m
on mr.movie_id = m.movie_id
where mr.created_at BETWEEN '2020-02-01' AND '2020-02-28'
group by m.title 
) t
WHERE RowNBR = 1;

SELECT DISTINCT FIRST_VALUE(u.name) OVER(ORDER BY COUNT(r.movie_id) DESC, u.name ASC) AS results
FROM Users AS u LEFT JOIN MovieRating AS r
ON u.user_id=r.user_id
GROUP BY u.user_id,u.name
UNION ALL
SELECT DISTINCT FIRST_VALUE(m.title) OVER(ORDER BY AVG(r.rating*1.0) DESC, m.title ASC) AS results
FROM Movies AS m join MovieRating AS r
ON m.movie_id=r.movie_id
WHERE r.created_at BETWEEN '2020-02-01' AND '2020-02-28'
GROUP BY m.movie_id,m.title;

select name as results
from (
    SELECT TOP 1
        u.name,
        COUNT(mr.movie_id) AS cnt
    FROM 
        MovieRating AS mr
    INNER JOIN 
        users AS u 
        ON mr.user_id = u.user_id
    GROUP BY 
        u.name
    ORDER BY 
        cnt DESC, name
) t

union all

select title as results
from (
select top 1 r.title , avg(mr.rating*1.0) as rating
from movieRating AS mr
    INNER JOIN 
        movies AS  r 
        ON mr.movie_id = r.movie_id
    where mr.created_at between '2020-02-01' and '2020-02-29'
    group by r.title
    order by rating desc, title
) t
