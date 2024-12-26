
# Library Billing System

# STAGE 1

## Project Overview

This project represents a **Library Billing System** designed to track subscriptions, penalties, employee wages, assets, and procurement processes within a library. It focuses on managing the core aspects of library operations and their financial transactions.

---

## Features

- **Reader Management**: Track readers' subscriptions, renewals, and penalties.
- **Employee Management**: Manage employee wages, payroll, and compensation.
- **Asset Tracking**: Monitor physical library assets, including insurance and procurement.
- **Financial Tracking**: Record costs associated with penalties, procurement, and employee wages.

---

## Design Specifications and Entity Relationship Diagram

### Data Structure Diagram (DSD)

Below is the Data Structure Diagram (DSD) representing the logical flow and structure of the system:

**Data Structure Diagram**  
![Data Structure Diagram](Stage1/DSD.png)

### Entity Relationship Diagram (ERD)

The following Entity Relationship Diagram (ERD) illustrates the relationships between the various entities in the system:

**Entity Relationship Diagram**  
![Entity Relationship Diagram](Stage1/ERD.png)

---

## Entities and Relationships

### Entities

The system includes the following key entities:

# Library Database Schema

This database schema represents a comprehensive library management system that includes subscriptions, billing, penalties, asset management, and more.

## Tables Overview

- **Reader**: Represents an individual who subscribes to the library.
  - **Attributes**: `ReaderID` (Primary Key), `SubscriptionID` (Foreign Key)

- **Subscription**: Tracks library subscription details.
  - **Attributes**: `SubscriptionID` (Primary Key), `Renewal_Date`, `Purchase_Date`, `Tier` (Foreign Key)

- **Subscription_Tiers**: Defines different subscription plans offered by the library.
  - **Attributes**: `Tier` (Primary Key), `Cost`, `max_readers`

- **Employee**: Represents a library employee.
  - **Attributes**: `EmployeeID` (Primary Key)

- **Wage**: Tracks wages paid to employees.
  - **Attributes**: `Amount`, `monthly_payment_date`, `EmployeeID` (Primary Key and Foreign Key)

- **Wage_Expense**: Links employee wages to billing records.
  - **Attributes**: `BillingID` (Primary Key, Foreign Key), `EmployeeID` (Foreign Key)

- **Book**: Represents books in the library.
  - **Attributes**: `BookID` (Primary Key), `AssetID` (Foreign Key)

- **Book_Loan**: Tracks loans of books to readers.
  - **Attributes**: `BookLoanId` (Primary Key)

- **Penalty**: Represents penalties incurred by readers for overdue or damaged books.
  - **Attributes**: `PenaltyID` (Primary Key), `Cost`, `Description`, `Status`, `BookLoanId` (Foreign Key)

- **Penalty_Income**: Links penalties to billing records.
  - **Attributes**: `BillingID` (Primary Key, Foreign Key), `PenaltyID` (Foreign Key)

- **Billing**: Tracks all financial transactions in the library.
  - **Attributes**: `BillingID` (Primary Key), `amount`, `Date`

- **Asset**: Represents physical assets owned by the library.
  - **Attributes**: `AssetID` (Primary Key), `Type`, `cost`, `BillingID` (Foreign Key)

- **Asset_Expense**: Links assets to billing records.
  - **Attributes**: `Source`, `BillingID` (Primary Key and Foreign Key)

- **Insurance**: Tracks insurance policies for library assets.
  - **Attributes**: `InsuranceID` (Primary Key), `Covered_Amount`, `EndDate`, `StartDate`, `AssetID` (Foreign Key)

- **Insurance_Expense**: Links insurance policies to billing records.
  - **Attributes**: `BillingID` (Primary Key and Foreign Key), `InsuranceID` (Foreign Key)

- **Subscription_Monthly_Income**: Tracks income from subscription renewals.
  - **Attributes**: `BillingID` (Primary Key and Foreign Key), `SubscriptionID` (Foreign Key)

---

## Design Rationale

### Why These Entities Were Chosen

The design of the Library Billing System is centered around the essential operations of the library, ensuring efficient management and tracking of both financial and operational data.

- **Reader**: This entity tracks individuals who interact with the library's services. The reader’s subscription details are essential for determining billing and penalties.
- **Subscription**: Subscriptions define the reader’s relationship with the library and are crucial for tracking renewal dates and managing service usage.
- **Penalty**: Penalties are needed to enforce library rules and track costs incurred due to overdue or damaged items.
- **Employee and Wage**: Employees are central to library operations, and tracking wages is necessary for payroll and compensation purposes.
- **Asset and Insurance**: Assets represent library property, and insurance coverage is necessary for risk management.
- **Procurement**: This entity is critical for tracking new acquisitions and maintaining inventory levels.

---

## Relationships

1. **Reader ↔ Subscription**
   - A **Reader** is part of a **Subscription** that can have multiple readers.
   - Links readers to their active or previous subscriptions.

2. **Subscription ↔ Subscription Tiers**
   - A **Subscription** belongs to a specific **Subscription Tier**.
   - Defines different subscription plans based on cost and maximum number of readers.

3. **Subscription ↔ Billing**
   - Each **Subscription Payment** contributes to **Subscription Monthly Income** tracked under **Billing**.

4. **Penalty ↔ Billing**
   - Penalties are recorded in **Penalty Income** under **Billing**.
   - The **Penalty** entity tracks details such as status, description, cost, and penalty payment.

5. **Penalty ↔ Book Loan**
   - A **Penalty** is associated with a **Book Loan** (e.g., overdue fines or damages).

6. **Asset ↔ Billing**
   - Expenses for **Assets** are recorded under **Asset Expense** in **Billing**.
   - Represents costs incurred by purchasing or maintaining assets.

7. **Book ↔ Asset**
   - A **Book** is a **Asset** that belongs to the library (e.g., purchased as part of the library's inventory).
   - Represents the library's physical collection.

8. **Employee ↔ Wage**
   - An **Employee** receives a **Wage**.
   - Represents the library's staff and their associated salary payments.

9. **Wage ↔ Billing**
    - Wages paid to employees are recorded as **Wage Expense** in **Billing**.

10. **Insurance ↔ Billing**
    - Payments for **Insurance** are recorded under **Insurance Expense** in **Billing**.
    - Allows tracking of regular insurance payments for covered items, rooms, or the building.

11. **Asset ↔ Insurance**
    - An **Asset** can be **Insured**.
    - Represents coverage for valuable library assets.

12. **Insurance ↔ Billing**
    - The **Insurance Expense** links payments for monthly insurance premiums to **Billing**.

13. **Billing** has a with various expense and income categories:
    1. **Subscription Monthly Income**: Captures income from subscriptions.
    2. **Penalty Income**: Captures income from penalties.
    3. **Asset Expense**: Captures expenses for purchasing or maintaining assets.
    4. **Wage Expense**: Captures expenses related to employee wages.
    5. **Insurance Expense**: Captures expenses related to library insurance.

---

## Use Cases

The Library Billing System supports the following use cases:

- **Subscription Management**: Library administrators can track reader subscriptions, renewals, and penalties.
- **Employee Payroll**: Administrators can manage employee wages, ensuring timely payments.
- **Asset Management**: Keep track of library assets and their associated insurance coverage.
- **Billing Process**: Record details about the acquisition of new assets and incomes, as well as recording the library's expenses.

---

## Target Users

- **Library Administrators**: They will manage subscriptions, penalties, employee wages, and assets.
- **Employees**: Employees can view their wage records and interact with the system for asset-related tasks.
- **Readers**: Readers' information will be managed through their subscriptions and penalties.

---

## Data Population Process

### Data Population Overview

The data population script generates random data for multiple tables using the **Faker** library and inserts it into the PostgreSQL database using **psycopg2**. The script populates data for tables such as **Insurance**, **Wage**, **Penalty**, **Subscription**, **Reader**, **Asset**, **Employee** and more.

### Tables Populated

1. **Subscription** - Tracks subscription plans for readers, including renewal and purchase dates, and the subscription tier.  
2. **Subscription Tiers** - Defines various subscription levels, specifying their cost and the maximum number of readers allowed.  
3. **Billing** - Records financial transactions, including subscription payments, penalties, and other expenses.  
4. **Subscription Monthly Income** - Links subscriptions to their corresponding monthly billing entries.  
5. **Penalty** - Details penalties issued for late returns or damaged books, including cost and description.  
6. **Penalty Income** - Tracks penalties collected through billing records.  
7. **Asset** - Tracks library-owned items, including books, equipment, or other resources, with associated costs.  
8. **Asset Expense** - Records expenses related to library assets and their sources.  
9. **Insurance** - Details insurance policies for library assets, including covered amounts and policy periods.  
10. **Insurance Expense** - Tracks insurance costs paid for assets, linked to billing records.  
11. **Wage** - Tracks employee wages and payment dates.  
12. **Wage Expense** - Records wage payments linked to the billing system.  

(the following are tables that are managed by other teams)
13. **Book** - Maintains details about library books, including their associated assets.  
14. **Reader** - Stores information about individual readers, including their subscription details.  
15. **Employee** - Stores employee data, including identifiers and wage details.  
16. **Book Loan** - Represents information about books borrowed by readers.  

### Data Size

The script populates the following number of records for each table:

- **employees** = 100
- **book_loans** = 20,000
- **billings** = 2,000,000
- **asset_expenses** = 15,000
- **subscription_tiers** = 5
- **subscriptions** = 20,000
- **penalties** = 9,000
- **readers** = 35,000
- **wages** = 100
- **assets** = 20,000
- **penalty_income** = 8,000
- **subscription_monthly_income** = 25,000
- **wage_expense** = 900
- **books** = 15,000
- **insurances** = 12,000

**Total Records**: 2,180,105

---


# Library Billing System - Stage 2

This repository contains Stage 2 of the Library Billing System database project, implementing backup procedures, queries, indexing, and constraints.

## Backup and Restore Procedures

### SQL Backup
- File: `backupSQL.sql`
- Log: `backupSQL.log`
- Command used:
```powershell
pg_dump -U postgres -h localhost -d "Library Billing System" --file=backupSQL.sql --verbose --clean --if-exists 2> backupSQL.log
```

### PSQL Backup
- File: `backupPSQL.sql`
- Log: `backupPSQL.log`
- Command used:
```powershell
pg_dump -U postgres -h localhost -d "Library Billing System" --file=backupPSQL.sql --verbose --clean --if-exists -F c 2> backupPSQL.log
```

### Restore Procedure
```powershell
pg_restore -U postgres -h localhost -v -d "Library Billing System" -F c --if-exists --clean backupPSQL.SQL 2> restorePSQL.log
```

## Queries

### Select Queries
1. **Find the total revenue from all subscription tiers across all time,
ordered by tier with the highest revenue first** (14.869 ms)
   ```sql
   SELECT s.Tier, st.Cost, COUNT(*) as number_of_subscribers, SUM(st.Cost) as total_revenue
   FROM Subscription s
   JOIN Subscription_Tiers st ON s.Tier = st.Tier
   GROUP BY s.Tier, st.Cost
   ORDER BY total_revenue DESC;
   ```

2. **List all BookLoanIds with Unpaid Penalties** (95.468 ms)
   ```sql
   SELECT bl.BookLoanId, p.PenaltyID, p.Cost as penalty_amount
   FROM Book_Loan bl
   JOIN Penalty p ON p.BookLoanId = bl.BookLoanId
   WHERE p.Status = '0'
   ORDER BY p.Cost DESC;
   ```

3. **Calculate the total monthly expenses broken down by category** (434.960 ms)
   ```sql
   SELECT EXTRACT(MONTH FROM b.Date) as month,
          'Wages' as expense_type,
          SUM(b.amount) as total_amount
   FROM Billing b
   JOIN Wage_Expense we ON we.BillingID = b.BillingID
   GROUP BY EXTRACT(MONTH FROM b.Date)
   UNION ALL
   -- Similar for Insurance and Assets
   ORDER BY month, expense_type;
   ```

4. **Monthly Income Analysis** (597.410 ms)
   ```sql
   SELECT sum(amount)
   FROM billing B
   WHERE (EXISTS (SELECT * FROM penalty_income P WHERE B.billingID = P.billingID)
      OR EXISTS (SELECT * FROM subscription_monthly_income S WHERE B.billingID = S.billingID))
      AND B.date >= DATE('1-12-2024');
   ```

### Update Queries
5. **Penalty Status Update** (243.493 ms)
6. **Employee Wage Adjustment** (372.993 ms)

### Delete Queries
7. **Insurance Plan Removal** (57.027 ms)
8. **Loan Record Removal** (304.270 ms)

## Parameterized Queries

1. **Find the total revenue from all subscription tiers across all time,
ordered by tier with the highest revenue first** (75.593 ms)
   ```sql
   PREPARE reader_by_tier(varchar) AS
   SELECT r.ReaderID, s.SubscriptionID, s.Renewal_Date, st.Cost as subscription_cost
   FROM Reader r
   JOIN Subscription s ON r.SubscriptionID = s.SubscriptionID
   JOIN Subscription_Tiers st ON s.Tier = st.Tier
   WHERE st.Tier = $1
   ORDER BY s.Renewal_Date;
   ```

2. **Penalty Revenue Calculator** (213.958 ms)
   ```sql
   PREPARE penalty_revenue(date, date) AS
   SELECT COUNT(p.PenaltyID) as number_of_penalties,
          SUM(b.amount) as total_revenue
   FROM Penalty p
   JOIN Penalty_Income pi ON p.PenaltyID = pi.PenaltyID
   JOIN Billing b ON pi.BillingID = b.BillingID
   WHERE b.Date BETWEEN $1 AND $2;
   ```

3. **Insurance Expiration Monitor** (71.855 ms)
   ```sql
   PREPARE expiring_insurance(int) AS
   SELECT i.InsuranceID, i.EndDate, i.Covered_Amount, a.Type as asset_type
   FROM Insurance i
   JOIN Asset a ON i.AssetID = a.AssetID
   WHERE i.EndDate <= CURRENT_DATE + ($1 * INTERVAL '1 month')
   ORDER BY i.EndDate;
   ```

4. **Reader Subscription Assignment** (40.068 ms)
   ```sql
   PREPARE add_reader_to_subscription(int, int) AS
   WITH subscription_limit AS (
       SELECT s.subscriptionid, st.max_readers, COUNT(r.readerid) as current_readers
       FROM subscription s
       JOIN subscription_tiers st ON s.tier = st.tier
       LEFT JOIN reader r ON s.subscriptionid = r.subscriptionid
       WHERE s.subscriptionid = $1
       GROUP BY s.subscriptionid, st.max_readers
       HAVING COUNT(r.readerid) < st.max_readers
   )
   UPDATE reader 
   SET subscriptionid = (SELECT subscriptionid FROM subscription_limit)
   WHERE readerid = $2;
   ```

## Indices

### Penalty Management Indices
```sql
CREATE INDEX idx_penalty_status_date 
ON Penalty(Status, BookLoanId);
```
- Improves performance for:
  - Query #2 (List unpaid penalties)
  - Query #5 (Update penalty status)
  - Query #8 (Delete book loan and penalties)
- Performance improvement: 95.468ms → 24.593ms for penalty listing

### Subscription Management Indices
```sql
CREATE INDEX idx_subscription_tier_renewal 
ON Subscription(Tier, Renewal_Date);
```
- Optimizes:
  - Query #1 (Total revenue by tier)
  - Parameterized query #1 (Readers by tier)
  - Subscription status checks
- Performance improvement: 147.148ms → 14.869ms for subscription analysis

### Billing Date Indices
```sql
CREATE INDEX idx_billing_date 
ON Billing(Date);
```
- Enhances:
  - Query #3 (Monthly expenses)
  - Query #4 (Monthly income)
  - Query #5 (Recent penalty payments)
  - Query #6 (Wage updates)
- Performance improvement: 434.960ms → 396.732ms for monthly expense analysis

### Performance Summary

| Query Type | Before Indices | After Indices | Improvement |
|------------|---------------|---------------|-------------|
| Subscription | 147.148ms | 14.869ms | 89.9% |
| Penalties | 95.468ms | 24.593ms | 74.2% |
| Monthly Expenses | 434.960ms | 396.732ms | 8.8% |
| Monthly Income | 597.410ms | 411.062ms | 31.2% |

## Constraints

### Subscription Management
```sql
ALTER TABLE Subscription_Tiers
ADD CONSTRAINT positive_tier_cost CHECK (Cost > 0);

ALTER TABLE Subscription
ADD CONSTRAINT valid_subscription_dates 
CHECK (Purchase_Date <= CURRENT_DATE AND Renewal_Date > Purchase_Date);
```

### Financial Constraints
```sql
ALTER TABLE Penalty
ADD CONSTRAINT positive_penalty CHECK (Cost > 0);

ALTER TABLE Wage
ADD CONSTRAINT positive_wage CHECK (Amount > 0);

ALTER TABLE Asset
ADD CONSTRAINT positive_asset_cost CHECK (cost > 0);

ALTER TABLE Billing
ADD CONSTRAINT positive_billing CHECK (amount > 0),
ADD CONSTRAINT valid_billing_date CHECK (Date <= CURRENT_DATE);
```

### Insurance Management
```sql
ALTER TABLE Insurance
ADD CONSTRAINT positive_insurance_amount CHECK (Covered_Amount > 0),
ADD CONSTRAINT valid_insurance_dates CHECK (EndDate > StartDate);
```

## Error Messages

| Constraint Violation | Error Message | Example Test Case |
|---------------------|---------------|-------------------|
| Negative Amount | "violates check constraint positive_billing" | INSERT INTO Billing (amount, Date) VALUES (-100, '2025-01-01') |
| Future Date | "violates check constraint valid_billing_date" | UPDATE Billing SET Date = '2025-01-01' WHERE BillingID = 1 |
| Asset Cost | "violates check constraint positive_asset_cost" | INSERT INTO Asset (Type, cost, BillingID) VALUES ('Computer', -5000, 1) |
| Insurance Amount | "violates check constraint positive_insurance_amount" | INSERT INTO Insurance (Covered_Amount, EndDate, StartDate) VALUES (-1000, '2024-12-31', '2024-01-01') |
| Subscription Cost | "violates check constraint positive_tier_cost" | UPDATE Subscription_Tiers SET Cost = -20 WHERE Tier = 'Basic' |

