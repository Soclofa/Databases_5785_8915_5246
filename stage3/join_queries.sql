-- Query 1: Update Wages of Employees Based on Their Role and amount of payments received
UPDATE Wage w
SET 
    Amount = Amount + 100

WHERE (SELECT count(*)
         FROM Billing b2
		 	JOIN
            wage_expense we ON b2.BillingID = we.BillingID
            JOIN
            employee e ON w.EmployeeID = e.EmployeeID
            WHERE w.EmployeeID = we.EmployeeID) > 5;


-- query 2: Get all subscriptions that are maxed out in readers
SELECT * FROM (SELECT s.SubscriptionID, (st.max_readers - count(r.readerid)) dif
FROM 
    Subscription s
JOIN Subscription_Tiers st ON s.tier = st.tier
JOIN reader r on r.SubscriptionID = s.SubscriptionID
GROUP BY s.subscriptionID, st.max_readers)
WHERE dif = 0;


--q query 3: get total incomes and expenses
WITH IncomeCounts AS (SELECT count(amount) as income
FROM Billing b
INNER JOIN subscription_monthly_income smi on smi.BillingID = b.BillingID
UNION
SELECT count(amount) as income
FROM Billing b
INNER JOIN penalty_income pi on pi.BillingID = b.BillingID),
ExpenseCounts AS (SELECT count(amount) as expense
FROM Billing b
INNER JOIN insurance_expense ie on ie.BillingID = b.BillingID
UNION
SELECT count(amount) as expense
FROM Billing b
INNER JOIN wage_expense we on we.BillingID = b.BillingID
UNION
SELECT count(amount) as expense
FROM Billing b
INNER JOIN asset_expense ae on ae.BillingID = b.BillingID)
SELECT 
    (SELECT SUM(income) FROM IncomeCounts) AS TotalIncome,
    (SELECT SUM(expense) FROM ExpenseCounts) AS TotalExpense;