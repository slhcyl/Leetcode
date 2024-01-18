/* 1517. Find Users With Valid E-Mails
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Users

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
| mail          | varchar |
+---------------+---------+
user_id is the primary key (column with unique values) for this table.
This table contains information of the users signed up in a website. Some e-mails are invalid.
 

Write a solution to find the users who have valid emails.

A valid e-mail has a prefix name and a domain where:

The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
The domain is '@leetcode.com'.
Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-----------+-------------------------+
| user_id | name      | mail                    |
+---------+-----------+-------------------------+
| 1       | Winston   | winston@leetcode.com    |
| 2       | Jonathan  | jonathanisgreat         |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
| 5       | Marwan    | quarz#2020@leetcode.com |
| 6       | David     | david69@gmail.com       |
| 7       | Shapiro   | .shapo@leetcode.com     |
+---------+-----------+-------------------------+
Output: 
+---------+-----------+-------------------------+
| user_id | name      | mail                    |
+---------+-----------+-------------------------+
| 1       | Winston   | winston@leetcode.com    |
| 3       | Annabelle | bella-@leetcode.com     |
| 4       | Sally     | sally.come@leetcode.com |
+---------+-----------+-------------------------+
Explanation: 
The mail of user 2 does not have a domain.
The mail of user 5 has the # sign which is not allowed.
The mail of user 6 does not have the leetcode domain.
The mail of user 7 starts with a period. */
/* editorial 
Approach: Selecting rows based on conditions
Algorithm
In general, if you are asked to match a string, writing a regular expression pattern to match on should come first to mind.

RegEx provides various functionality, here are a few relevant ones:

^: This represents the start of a string or line.

[a-z]: This represents a character range, matching any character from a to z.

[0-9]: This represents a character range, matching any character from 0 to 9.

[a-zA-Z]: This variant matches any character from a to z or A to Z. Note that there is no limit to the number of character ranges you can specify inside the square brackets -- you can add additional characters or ranges you want to match.

[^a-z]: This variant matches any character that is not from a to z. Note that the ^ character is used to negate the character range, which means it has a different meaning inside the square brackets than outside where it means the start.

[a-z]*: This represents a character range, matching any character from a to z zero or more times.

[a-z]+: This represents a character range, matching any character from a to z one or more times.

.: This matches exactly one of any character.

\.: This represents a period character. Note that the backslash is used to escape the period character, as the period character has a special meaning in regular expressions. Also note that in many languages, you need to escape the backslash itself, so you need to use \\..

The dollar sign: This represents the end of a string or line.

The key idea here is to separate the first character of the name column from the rest, change their cases accordingly, and then join them back together.
[a-zA-Z0-9_.-]*: This part allows any combination of letters, digits, underscores, periods, or hyphens after the initial letter.
The complete code is as follows:
SELECT user_id, name, mail: Selects specific columns (user_id, name, and mail) from the Users table.

FROM Users: Specifies the source table as Users.

WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*\\@leetcode\\.com$': Applies a filter to include only rows where the mail column matches the specified regular expression:

^[a-zA-Z]: Asserts that the email starts with a letter.

[a-zA-Z0-9_.-]*: Matches any sequence of letters, digits, underscores, periods, or hyphens.

\\@leetcode\\.com$: Ensures that the email ends with "@leetcode.com". The backslashes (\\) are used to escape special characters in the regular expression.

The regular expression is designed to validate email addresses based on certain criteria, ensuring that they start with a letter, followed by a combination of letters, digits, underscores, periods, or hyphens, and end with "@leetcode.com". This helps filter and retrieve rows where the email addresses meet the specified pattern.*/
SELECT user_id, name, mail
FROM Users
-- Note that we also escaped the `@` character, as it has a special meaning in some regex flavors
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*\\@leetcode\\.com$';

-- Write your PostgreSQL query statement below
SELECT *
FROM Users
WHERE
    mail LIKE '%@leetcode.com'
    AND REGEXP_LIKE(mail, '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$');

/* In this query:

~ is used for case-sensitive regular expression matching.
^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$ is the regular expression pattern. */
SELECT *
FROM Users
WHERE
    mail LIKE '%@leetcode.com'
    AND mail ~ '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$';

/* If you want to make the matching case-insensitive, you can use the ~* operator instead: */ */
SELECT *
FROM Users
WHERE
    mail LIKE '%@leetcode.com'
    AND mail ~* '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$';

# Write your MySQL query statement below
SELECT *
FROM Users
WHERE
    mail LIKE '%@leetcode.com'
    AND mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\\.com$';

/* Write your T-SQL query statement below */
SELECT *
FROM Users
WHERE
    mail LIKE '[a-zA-Z]%@leetcode.com'
    and mail Not Like '%[^a-zA-Z0-9_.-]%@leetcode.com'
