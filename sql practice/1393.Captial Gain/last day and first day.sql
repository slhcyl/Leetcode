/* sql */
SELECT DATEADD(month, DATEDIFF(month, 0, @mydate), 0) AS StartOfMonth ,DATEFROMPARTS(2018, 10, 1)  as firstday
,Eomonth(@mydate) as last_date



/* postgresql */
select DATE('now', 'start of month') , date('now','start of month','+1 month','-1 day')



select 
sum(case when s.transaction_date between  DATE(start_date, 'start of month') and date(start_date,'start of month','+1 month','-1 day') 
    then 1 else 0 end)/count(s.product_id) * 100 as pct_of_transactions_on_first_or_last_day_of_valid_promotion
from sales as s
join promotions as p
on s.promotion_id = p.promotin_id
