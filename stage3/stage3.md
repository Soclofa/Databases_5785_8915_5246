
# Library Billing System - Stage 3


# Database Views Documentation

## Queries

### 1. Employee Wage Update
```sql
-- Query 1: Update Wages of Employees Based on Their Role and amount of payments received
UPDATE Wage w
SET Amount = Amount + 100
WHERE (SELECT count(*)
       FROM Billing b2
       JOIN wage_expense we ON b2.BillingID = we.BillingID
       JOIN employee e ON w.EmployeeID = e.EmployeeID
       WHERE w.EmployeeID = we.EmployeeID) > 5;
```
**Purpose**: Increases wages by $100 for employees who have received more than 5 payments.
**Tables Used**: Wage, Billing, wage_expense, employee


### 2. Maxed-Out Subscriptions Query
```sql
-- Query 2: Get all subscriptions that are maxed out in readers
SELECT * 
FROM (
    SELECT s.SubscriptionID, (st.max_readers - count(r.readerid)) dif
    FROM Subscription s
    JOIN Subscription_Tiers st ON s.tier = st.tier
    JOIN reader r on r.SubscriptionID = s.SubscriptionID
    GROUP BY s.subscriptionID, st.max_readers
)
WHERE dif = 0;
```
**Purpose**: Identifies subscriptions that have reached their maximum reader limit.
**Tables Used**: Subscription, Subscription_Tiers, reader


### 3. Financial Summary Query
```sql
-- Query 3: Get total incomes and expenses
WITH IncomeCounts AS (
    SELECT count(amount) as income
    FROM Billing b
    INNER JOIN subscription_monthly_income smi on smi.BillingID = b.BillingID
    UNION
    SELECT count(amount) as income
    FROM Billing b
    INNER JOIN penalty_income pi on pi.BillingID = b.BillingID
),
ExpenseCounts AS (
    SELECT count(amount) as expense
    FROM Billing b
    INNER JOIN insurance_expense ie on ie.BillingID = b.BillingID
    UNION
    SELECT count(amount) as expense
    FROM Billing b
    INNER JOIN wage_expense we on we.BillingID = b.BillingID
    UNION
    SELECT count(amount) as expense
    FROM Billing b
    INNER JOIN asset_expense ae on ae.BillingID = b.BillingID
)
SELECT 
    (SELECT SUM(income) FROM IncomeCounts) AS TotalIncome,
    (SELECT SUM(expense) FROM ExpenseCounts) AS TotalExpense;
```
**Purpose**: Calculates total income and expenses across all financial categories.
**Tables Used**: Billing, subscription_monthly_income, penalty_income, insurance_expense, wage_expense, asset_expense


## Views

### 1. BillingCurrentMonth
```sql
CREATE VIEW BillingCurrentMonth AS
SELECT *
FROM Billing b
WHERE b.date > '2024-12-1' AND b.date < '2025-01-01';
```
**Purpose**: Filters billing records for the current month
**Base Table**: Billing
**Filter Criteria**: Date range between December 2024 and January 2025

#### Operations
**Select Query**:
```sql
SELECT bcm.billingID, amount, date
FROM BillingCurrentMonth bcm 
JOIN Insurance_Expense ie ON bcm.BillingID = ie.BillingID 
UNION ALL 
SELECT bcm.billingID, amount, date 
FROM BillingCurrentMonth bcm 
JOIN asset_expense ae ON bcm.BillingID = ae.BillingID 
UNION ALL 
SELECT bcm.billingID, amount, date 
FROM BillingCurrentMonth bcm 
JOIN Wage_Expense we ON bcm.BillingID = we.BillingID;
```
**Update Query**:
```sql
UPDATE BillingCurrentMonth bcm 
SET amount = amount + 100 
WHERE exists (SELECT * FROM wage_expense we WHERE we.BillingID = bcm.BillingID);
```

### 2. DamageFeePenalty
```sql
CREATE VIEW DamageFeePenalty AS
SELECT *
FROM Penalty p
WHERE p.penalty_type = 'Damage Fee';
```
**Purpose**: Isolates damage fee penalties
**Base Table**: Penalty
**Filter Criteria**: penalty_type = 'Damage Fee'

#### Operations
**Select Query**:
```sql
SELECT * FROM DamageFeePenalty dfp
WHERE dfp.cost > 20;
```
**Update Query**:
```sql
UPDATE DamageFeePenalty dfp
SET status = 1
WHERE dfp.penaltyID = 5;
```

### 3. HighWages
```sql
CREATE VIEW HighWages AS
SELECT *
FROM Wage w
WHERE w.amount > 3070;
```
**Purpose**: Identifies high-wage employees
**Base Table**: Wage
**Filter Criteria**: amount > 3070

#### Operations
**Select Query**:
```sql
SELECT *
FROM HighWages
WHERE monthly_payment_date = 10;
```
**Delete Query**:
```sql
DELETE FROM HighWages;
```

### 4. ExpensiveAssets
```sql
CREATE VIEW ExpensiveAssets AS
SELECT *
FROM Asset a
WHERE a.cost > 400;
```
**Purpose**: Tracks high-value assets
**Base Table**: Asset
**Filter Criteria**: cost > 400

#### Operations
**Select Query**:
```sql
SELECT * FROM ExpensiveAssets ea
WHERE ea.type = 'Computer';
```
**Update Query**:
```sql
UPDATE ExpensiveAssets ea
SET ea.cost = 499
WHERE ea.cost = 500;
```

## Visualizations

### subscriptions tiers popularity

The graph shows the number of subscriptions for each tier, highlighting the popularity of different subscription levels.

``` sql
SELECT tier, count(*) tier_count
FROM subscription 
group by tier
ORDER BY
    tier_count DESC;
```

![tier popularity graph](visualizaiton-subscription-tiers.png)

this graph shows that the tier type is split about equal.

### monthly payment date

The graph shows the number of wages for each payday, highlighting the popularity of different payment dates.

``` sql
SELECT monthly_payment_date, count(*) mpd_count
FROM wage 
group by monthly_payment_date
ORDER BY mpd_count DESC;
```

![tier popularity graph](graph_visualiser-1735548594092.png)

this graph shows that the almost half of the wages are payed on the 10th, and the least popular payday is the 1st of the month.
