 /*
 BACKGROUND:
 
 The following schema is a subset of a relational database of a grocery store
 chain. This chain sells many products of different product classes to its
 customers across its different stores. It also conducts many different
 promotion campaigns.
 
 The relationship between the four tables we want to analyze is depicted below:
 
        # sales                                # products
        +------------------+---------+         +---------------------+---------+
        | product_id       | INTEGER |>--------| product_id          | INTEGER |
        | store_id         | INTEGER |    +---<| product_class_id    | INTEGER |
        | customer_id      | INTEGER |    |    | brand_name          | VARCHAR |
   +---<| promotion_id     | INTEGER |    |    | product_name        | VARCHAR |
   |    | store_sales      | DECIMAL |    |    | is_low_fat_flg      | TINYINT |
   |    | store_cost       | DECIMAL |    |    | is_recyclable_flg   | TINYINT |
   |    | units_sold       | DECIMAL |    |    | gross_weight        | DECIMAL |
   |    | transaction_date | DATE    |    |    | net_weight          | DECIMAL |
   |    +------------------+---------+    |    +---------------------+---------+
   |                                      |
   |    # promotions                      |    # product_classes
   |    +------------------+---------+    |    +---------------------+---------+
   +----| promotion_id     | INTEGER |    +----| product_class_id    | INTEGER |
        | promotion_name   | VARCHAR |         | product_subcategory | VARCHAR |
        | media_type       | VARCHAR |         | product_category    | VARCHAR |
        | cost             | DECIMAL |         | product_department  | VARCHAR |
        | start_date       | DATE    |         | product_family      | VARCHAR |
        | end_date         | DATE    |         +---------------------+---------+
        +------------------+---------+
 */
 /*
 PROMPT:
 -- Of sales that had a valid promotion, the VP of marketing
 -- wants to know what % of transactions occur on either
 -- the very first day or the very last day of a promotion campaign.
 
 
 EXPECTED OUTPUT:
 Note: Please use the column name(s) specified in the expected output in your solution.
 +-------------------------------------------------------------+
 | pct_of_transactions_on_first_or_last_day_of_valid_promotion |
 +-------------------------------------------------------------+
 |                                         41.9047619047619048 |
 +-------------------------------------------------------------+
  Case
Please refer to the schema and prompt on the right.
Note that in this editor, you are using a SQLite database. In the interview you will run the queries against a PostgreSQL database. Yet knowing standard ANSI SQL is sufficient for the interview.
Please feel free to collapse this panel to simulate a real interview experience.
Below are hints you can use to write the correct query.
HINTS
How do we find all sales between the start and end date?
How do we find sales with valid promotions?
You can join both the sales and promotions tables based on the promotion_id.
 -------------- PLEASE WRITE YOUR SQL SOLUTION BELOW THIS LINE ----------------
 */
SELECT SUM(CASE WHEN s.transaction_date = p.start_date OR s.transaction_date = p.end_date THEN 1 END)*1.0 /COUNT(*) * 100 AS pct_of_transactions_on_first_or_last_day_of_valid_promotion
FROM sales s
JOIN promotions p ON s.promotion_id = p.promotion_id

/* 1. What percent of all products in the grocery chain's catalog are both low fat and recyclable?
    2. What are the top five (ranked in decreasing order) single-channel media types that correspond to the most money the grocery chain had spent on its promotional campaigns?
    3. % Of sales that had a valid promotion, the VP of marketing wants to know what % of transactions occur on either the very first day or the very last day of a promotion campaign.
    4. What brands have an average price above $3 and contain at least 2 different products?
    5. To improve sales, the marketing department runs various types of promotions.
    The marketing manager would like to analyze the effectiveness of these promotion campaigns.
    In particular, what percent of our sales transactions had a valid promotion applied?
    6. We want to run a new promotion for our most successful category of products
    (we call these categories “product classes”).
    Can you find out what are the top 3 selling product classes by total sales?
    7. We are considering running a promo across brands. We want to target
    customers who have bought products from two specific brands.
    Can you find out which customers have bought products from both the
    “Fort West" and the "Golden" brands?
    8. what %age of products have both non fat and trans fat.
    9. find top 5 sales products having promotions
    10. what %age of sales happened on first and last day of the promotion
    11. Which product had the highest sales with promotions and sales ( basically a where clause on 2 flags)
    12. Manager want to analyze the how the promotions on certain products are performing.find how the the percent of promoted sales?
    13. get the top3 product class_id by the total sales.
    14. Percentage increase in revenue compared to promoted and non-promoted products.
    15. Products classes that has the highest transactions
    16. Count of Customers who bought 2 items type (A,B) 
    */












