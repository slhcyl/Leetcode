/* 
i have charity table which contains id and name. id is primary key. 
I have another tabled called donations which contains id, charity_id, amount, donation_at. 
write a mysql query to generate charity name that don't receive any donation in last 30 days, 
if they don't receive the donation in 30 days, display last donation date, if they never receive donation just display 'never'. */
SELECT 
    c.name AS CharityName,
    COALESCE(MAX(d.donation_at), 'never') AS LastDonationDate
FROM 
    charity c
LEFT JOIN 
    donations d ON c.id = d.charity_id
    AND d.donation_at >= CURDATE() - INTERVAL 30 DAY 
GROUP BY 
    c.id
HAVING 
    MAX(d.donation_at) IS NULL # indicating no donations ever or not in the last 30 days
    OR MAX(d.donation_at) < CURDATE() - INTERVAL 30 DAY; #filter out charities that have received donations within the last 30 days
