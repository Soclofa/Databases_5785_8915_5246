-- select on view #1: 
SELECT bcm.billingID, amount, date
FROM  BillingCurrentMonth bcm 
JOIN Insurance_Expense ie ON bcm.BillingID = ie.BillingID 
UNION ALL 
SELECT bcm.billingID, amount, date 
FROM  BillingCurrentMonth bcm 
JOIN asset_expense ae ON bcm.BillingID = ae.BillingID 
UNION ALL 
SELECT bcm.billingID, amount, date 
FROM  BillingCurrentMonth bcm 
JOIN Wage_Expense we ON bcm.BillingID = we.BillingID;

-- update on view #1: update wage if the employee got more then 5 paychecks
UPDATE BillingCurrentMonth bcm 
SET amount = amount + 100 
WHERE exists (SELECT * FROM wage_expense we WHERE we.BillingID = bcm.BillingID);


-- select on view #2: 
select * from DamageFeePenalty dfp
where dfp.cost > 20;

-- update on view #2: 
UPDATE DamageFeePenalty dfp
SET status = 1
where dfp.penaltyID = 5;


-- select on view #3: assets that are the insurance expiration date is before 2025
SELECT 
    *
FROM 
    HighWages
WHERE 
    monthly_payment_date = 10;

-- update on view #3: update wage if the employee got more then 5 paychecks
Delete 
FROM HighWages;

--select on view #4:
select * from ExpensiveAssets ea
where ea.type = 'Computer';

--update on vew #4:
UPDATE ExpensiveAssets ea
SET ea.cost = 499
where ea.cost = 500;

