-- function #1 adds bonus to wage, params are the bonus amount and seniority (how many paychecks was already sent)

CREATE or replace  function add_bonus(bonus int, seniority int)
RETURNS void
language plpgsql
AS
$$
BEGIN
       UPDATE Wage w
       SET
               Amount = Amount + bonus

       WHERE (SELECT count(*)
               FROM Billing b2
                       JOIN
            wage_expense we ON b2.BillingID = we.BillingID
            JOIN
            employee e ON w.EmployeeID = e.EmployeeID
            WHERE w.EmployeeID = we.EmployeeID) > seniority;
end;
$$;

--

select add_bonus(5, 1);
 add_bonus
-----------

(1 row)

-- function #2 get how many readers per subscription

CREATE or replace  function readersInSub(Subscription_ID int)
RETURNS int
language plpgsql
AS
$reader_count$
BEGIN
        SELECT count(*) INTO reader_count
        FROM 
        reader r 
        WHERE r.SubscriptionID = Subscription_ID
        return reader_count
end;
$reader_count$;

SELECT * FROM (SELECT s.SubscriptionID, (st.max_readers - count(r.readerid)) dif
FROM 
Subscription s
JOIN Subscription_Tiers st ON s.tier = st.tier
JOIN reader r on r.SubscriptionID = s.SubscriptionID
GROUP BY s.subscriptionID, st.max_readers)
WHERE dif = 0;
