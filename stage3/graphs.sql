-- graph 1: subscription types
SELECT tier, count(*) tier_count
FROM subscription
group by tier
ORDER BY
    tier_count DESC;
   tier   | tier_count
----------+------------
 Premium  |      40460
 Family   |      40034
 Elite    |      39980
 Standard |      39786
 Basic    |      39741
(5 rows)

-- graph 2: payday
 SELECT monthly_payment_date, count(*) mpd_count
FROM wage
group by monthly_payment_date
ORDER BY mpd_count DESC;
 monthly_payment_date | mpd_count
----------------------+-----------
                   10 |        49
                   25 |        30
                    1 |        21
(3 rows)