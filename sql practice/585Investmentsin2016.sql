/* 585. Investments in 2016
Medium
Topics
Companies
Hint
SQL Schema
Pandas Schema
Table: Insurance

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key (column with unique values) for this table.
Each row of this table contains information about one policy where:
pid is the policyholder's policy ID.
tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holder's city. It's guaranteed that lat is not NULL.
lon is the longitude of the policy holder's city. It's guaranteed that lon is not NULL.
 

Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places.

The result format is in the following example.

 

Example 1:

Input: 
Insurance table:
+-----+----------+----------+-----+-----+
| pid | tiv_2015 | tiv_2016 | lat | lon |
+-----+----------+----------+-----+-----+
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
+-----+----------+----------+-----+-----+
Output: 
+----------+
| tiv_2016 |
+----------+
| 45.00    |
+----------+
Explanation: 
The first record in the table, like the last record, meets both of the two criteria.
The tiv_2015 value 10 is the same as the third and fourth records, and its location is unique.

The second record does not meet any of the two criteria. Its tiv_2015 is not like any other policyholders and its location is the same as the third record, which makes the third record fail, too.
So, the result is the sum of tiv_2016 of the first and last record, which is 45. */
-- Write your PostgreSQL query statement below
with tiv_2015 as (
select tiv_2015
from insurance
group by tiv_2015
having count(*) > 1 
)

,map as (
select lat, lon
from insurance
group by lat, lon
having  count(*) = 1
)

select cast(sum(tiv_2016) as numeric(38,2)) as tiv_2016 /*Postgre SQL support cast(sum(d) as decimal(38,2))*/
from insurance
where tiv_2015 in (select tiv_2015 from tiv_2015)
and (lat,lon) in (select lat, lon from map);

SELECT cast(sum(tiv_2016) as decimal(38,2)) as tiv_2016
FROM Insurance a
WHERE a.tiv_2015 IN (SELECT tiv_2015
                     FROM Insurance
                     WHERE pid <> a.pid)
  AND (a.lat, a.lon) NOT IN
      (SELECT lat, lon
       FROM Insurance
       WHERE pid <> a.pid);

# Write your MySQL query statement below
select sum(tiv_2016) as tiv_2016
from 
(select pid
,tiv_2015
,tiv_2016
,lat
,lon 
,count(*) over (partition by tiv_2015) as tiv_2015cnt
,count(*) over (partition by lat,lon) as locationcnt
from insurance) as t 
where tiv_2015cnt > 1
and locationcnt = 1


# Write your MySQL query statement below
SELECT cast(sum(tiv_2016) as decimal(38,2)) tiv_2016 /*only suuport decimal*/
FROM Insurance a
WHERE a.tiv_2015 IN (SELECT tiv_2015
                     FROM Insurance
                     WHERE pid <> a.pid)
  AND (a.lat, a.lon) NOT IN
      (SELECT lat, lon
       FROM Insurance
       WHERE pid <> a.pid);

/* Write your T-SQL query statement below */
SELECT cast(sum(tiv_2016) as numeric(38,2)) as tiv_2016 /*only support numeric not decimal*/
FROM Insurance a
WHERE a.tiv_2015 IN (SELECT tiv_2015
                     FROM Insurance
                     WHERE pid <> a.pid)
AND NOT EXISTS (
      SELECT 1
      FROM Insurance b
      WHERE b.pid <> a.pid
        AND b.lat = a.lat
        AND b.lon = a.lon
  );

with tiv_2015 as (
select tiv_2015
from insurance
group by tiv_2015
having count(*) > 1 
)

,map as (
select lat, lon
from insurance
group by lat, lon
having  count(*) = 1
)

select cast(sum(tiv_2016) as numeric(38,2)) as tiv_2016 /*Ms SQL support cast(sum(d) as numeric(38,2))*/
from insurance
where tiv_2015 in (select tiv_2015 from tiv_2015)
and exists (
    select 1 from map where map.lat = insurance.lat and map.lon=insurance.lon);

/* editorial */
SELECT
    ROUND(SUM(insurance.TIV_2016),2) AS TIV_2016
FROM
    insurance
WHERE
    insurance.TIV_2015 IN
    (
      SELECT
        TIV_2015
      FROM
        insurance
      GROUP BY TIV_2015
      HAVING COUNT(*) > 1
    )
    AND CONCAT(LAT, LON) IN
    (
      SELECT
        CONCAT(LAT, LON)
      FROM
        insurance
      GROUP BY LAT , LON
      HAVING COUNT(*) = 1
    )