/* 1683. Invalid Tweets
Solved
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
This table contains all the tweets in a social media app.
 

Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Tweets table:
+----------+----------------------------------+
| tweet_id | content                          |
+----------+----------------------------------+
| 1        | Vote for Biden                   |
| 2        | Let us make America great again! |
+----------+----------------------------------+
Output: 
+----------+
| tweet_id |
+----------+
| 2        |
+----------+
Explanation: 
Tweet 1 has length = 14. It is a valid tweet.
Tweet 2 has length = 32. It is an invalid tweet. */
# Write your MySQL query statement below: Approach: Filtering Rows
select tweet_id
from tweets
where length(content) > 15

/* Algorithm
For a SQL table, the best function to use to count the number of characters used in a string is CHAR_LENGTH(str), which returns the length of the string str.
The other common function, LENGTH(str), also works for this question since the column content contains only English characters and no special characters. 
Otherwise, LENGTH() might return a different result because this function returns the length of the string str in bytes and certain characters contain more than 1 byte.
Using character '¥' as an example: CHAR_LENGTH() returns 1 as the result, while LENGTH() return 2 because this string contains 2 bytes. */
SELECT 
    tweet_id
FROM 
    tweets
WHERE 
    CHAR_LENGTH(content)> 15

/* Write your T-SQL query statement below */
select tweet_id
from tweets
where len(content) > 15

/* pandas */
import pandas as pd

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    is_valid = tweets['content'].str.len() > 15

    df = tweets[is_valid]

    return df[['tweet_id']]