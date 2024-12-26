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
SELECT tier, COUNT(*) AS row_count
FROM subscriptionPremiumPlus
GROUP BY tier
ORDER BY tier;

-- update on view #2: 



-- select on view #3: assets that are the insurance expiration date is before 2025
SELECT 
    AssetID, 
    AssetType, 
    AssetCost, 
    InsuranceID, 
    CoveredAmount, 
    StartDate, 
    EndDate
FROM 
    AssetInsuranceDetails
WHERE 
    EndDate < '2024-12-31';

-- update on view #3: update wage if the employee got more then 5 paychecks