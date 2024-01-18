/* 1527. Patients With a Condition
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Patients

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
patient_id is the primary key (column with unique values) for this table.
'conditions' contains 0 or more code separated by spaces. 
This table contains information of the patients in the hospital.
 

Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Patients table:
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |
+------------+--------------+--------------+
Output: 
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 | 
+------------+--------------+--------------+
Explanation: Bob and George both have a condition that starts with DIAB1. */
-- Write your PostgreSQL query statement below, mysql, ms sql
select patient_id, patient_name, conditions
from patients
where conditions like 'DIAB1%' or conditions like '% DIAB1%'

/* editorial 
Approach 1: Using Regular Expression Word Boundaries
WHERE conditions REGEXP '\\bDIAB1.*': This is the filter condition. It uses the REGEXP operator, which is used for regular expression matching. The regular expression \\bDIAB1.* is applied to the conditions column.

\\b: Represents a word boundary, ensuring that "DIAB1" is a whole word and not part of a larger word.

DIAB1: Matches the specific string "DIAB1".

.*: Matches any characters (zero or more) that come after "DIAB1".

So, the condition is looking for rows where the conditions column starts with the word "DIAB1".

Note: The double backslashes (\\) are used to escape the backslash character in SQL strings, ensuring that it is interpreted as a literal backslash in the regular expression.
*/
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1.*';