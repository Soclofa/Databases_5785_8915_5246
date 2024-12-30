-- graph 1: subscription types
SELECT tier, count(*) tier_count
FROM subscription 
group by tier
ORDER BY
    tier_count DESC;

-- graph 2: payday
SELECT monthly_payment_date, count(*) mpd_count
FROM wage 
group by monthly_payment_date
ORDER BY mpd_count DESC;