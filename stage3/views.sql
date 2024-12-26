-- view #1:  all billing from the current month
CREATE VIEW BillingCurrentMonth AS
SELECT *
FROM Billing b
WHERE b.date > '2024-12-1' AND b.date < '2025-01-01';


-- view #2: all subscriptions that their tiers of premium and above
CREATE VIEW SubscriptionPremiumPlus AS
SELECT * From Subscription s
WHERE s.tier != 'Basic' and s.tier != 'Standard';


-- view #3: high wages
CREATE VIEW HighWages AS
SELECT *
FROM Wage w
WHERE w.amount > 1500;


--view #4: expensive assets
CREATE VIEW ExpensiveAssets AS
SELECT *
FROM Asset a
WHERE a.cost > 400;