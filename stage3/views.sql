-- view #1:  all billing from the current month
CREATE VIEW BillingCurrentMonth AS
SELECT *
FROM Billing b
WHERE b.date > '2024-12-1' AND b.date < '2025-01-01';


-- view #2: all subscriptions that their tiers of premium and above
CREATE VIEW DamageFeePenalty AS
SELECT *
FROM Penalty p
WHERE p.penalty_type = 'Damage Fee';

-- view #3: high wages
CREATE VIEW HighWages AS
SELECT *
FROM Wage w
WHERE w.amount > 3070;


--view #4: expensive assets
CREATE VIEW ExpensiveAssets AS
SELECT *
FROM Asset a
WHERE a.cost > 400;