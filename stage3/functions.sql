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


-- function #3 create high wage view

CREATE or replace  function highWage(my_amount NUMERIC(10, 2))
RETURNS table (wage_amount NUMERIC(10, 2), wage_employeeid int)
language plpgsql
AS
$$
BEGIN
        RETURN QUERY
        SELECT w.amount::NUMERIC(10, 2), w.employeeid
        FROM Wage w
        WHERE w.amount > my_amount;
end;
$$;

 SELECT wage_amount, wage_employeeid
FROM Wage w
WHERE w.amount > 3000;


-- function #4 selects all the billing rows from the billing table given a start and end date
CREATE or replace  function billingByDate(startDate DATE, endDate DATE)
RETURNS table (billing_amount NUMERIC(10,2), billing_date DATE, billing_billingID INT)
language plpgsql
AS
$$
BEGIN
        RETURN QUERY
        SELECT b.amount::NUMERIC(10,2), b.date, b.billingID
        FROM Billing b
        WHERE b.date >= startDate AND b.date <= endDate;
end;
$$;