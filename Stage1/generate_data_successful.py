import psycopg2
import random
from datetime import datetime, timedelta
from faker import Faker

# Database credentials
DB_HOST = "localhost"
DB_NAME = "Library Billing System"
DB_USER = "postgres"
DB_PASS = "AviSoclof"

fake = Faker()

# Number of records to generate for each table

NUM_EMPLOYEES = 100
NUM_BOOK_LOANS = 20000
NUM_BILLINGS = 2000000
NUM_ASSET_EXPENSES = 15000
NUM_SUBSCRIPTION_TIERS = 5
NUM_SUBSCRIPTIONS = 20000
NUM_PENALTIES = 9000
NUM_READERS = 35000
NUM_WAGES = 100
NUM_ASSETS = 20000
NUM_PENALTY_INCOME = 8000
NUM_SUBSCRIPTION_MONTHLY_INCOME = 25000
NUM_WAGE_EXPENSE = 900
NUM_BOOKS = 15000
NUM_INSURANCES = 12000

penalty_types = ['Late Fee', 'Damage Fee', 'Lost Item Fee']
employee_positions = ['Librarian', 'Assistant', 'Manager']
asset_types = ['Computer', 'Furniture', 'Book', 'Building']
insurance_types = ['Full Coverage', 'Partial Coverage', 'No Coverage']

# Function to generate random date within a range
def generate_random_date(start_year=2020, end_year=2025):
    start_date = datetime(start_year, 1, 1)
    end_date = datetime(end_year, 12, 31)
    return fake.date_between_dates(date_start=start_date, date_end=end_date)

# Connect to the database
conn = psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS, port="5432")
cur = conn.cursor()

# --- Data Generation ---

billing_used = []

# Subscription Tiers
subscription_tiers = [('Basic', 10.00, 1), ('Standard', 25.00, 3),
                     ('Premium', 50.00, 5), ('Family', 80.00, 10), ('Elite', 150.00, 20)]

for i in subscription_tiers:
    cur.execute("INSERT INTO Subscription_Tiers (Tier, Cost, max_readers) VALUES (%s, %s, %s)", i)

# Employee
for i in range(NUM_EMPLOYEES + 1):
    cur.execute("INSERT INTO Employee (EmployeeID) VALUES (%s)", [i])

# Book Loan
for i in range(NUM_BOOK_LOANS + 1):
    cur.execute("INSERT INTO Book_Loan (BookLoanId) VALUES (%s)", [i])

# Subscription
subscriptions_list = [(0,0)]
for i in range(NUM_SUBSCRIPTIONS + 1):
    renewal_date = generate_random_date()
    purchase_date = renewal_date - timedelta(days=random.randint(30, 365))
    tier = random.choice([t for t in subscription_tiers])
    tier_id = tier[0]
    subscriptions_list.append((0, tier[2]))
    cur.execute("INSERT INTO Subscription (Renewal_Date, Purchase_Date, Tier, SubscriptionID) VALUES (%s, %s, %s, %s)", 
                (renewal_date, purchase_date, tier_id, i))

# Billing
for i in range(NUM_BILLINGS + 1):
    amount = random.uniform(10.00, 1000.00)
    random_date = generate_random_date()
    cur.execute("INSERT INTO Billing (Amount, Date, BillingID) VALUES (%s, %s, %s)",
                (amount, random_date, i))

# Asset Expense
billing_in_asset_expense = []
for i in range(NUM_ASSET_EXPENSES):
    source = fake.company()
    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id in billing_used: 
        billing_id = random.randint(1, NUM_BILLINGS)
    billing_used.append(billing_id)
    billing_in_asset_expense.append(billing_id)
    cur.execute(
        "INSERT INTO Asset_Expense (Source, BillingID) VALUES (%s, %s)", (source, billing_id))

# Asset
for i in range(NUM_ASSETS + 1):
    type = random.choice(asset_types)
    cost = random.randint(50, 500)
    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id not in billing_in_asset_expense:
        billing_id = random.randint(1, NUM_BILLINGS)
    cur.execute("INSERT INTO Asset (Type, cost, BillingID, AssetID) VALUES (%s, %s, %s, %s)",
                (type, cost, billing_id, i))


# Penalty
for i in range(NUM_PENALTIES):
    cost = random.uniform(5.00, 50.00)
    description = f"Penalty Description_{i+1}"
    type = random.choice(penalty_types)
    status = random.randint(0, 1)
    bookloan_id = random.randint(1, NUM_BOOK_LOANS)
    cur.execute("INSERT INTO Penalty (Cost, Description, Status, penalty_type, BookLoanId, PenaltyID) VALUES (%s, %s, %s, %s, %s, %s)",
                (cost, description, status, type, bookloan_id, i))

# Reader
print("reader")
for i in range(NUM_READERS):
    subscription_id = random.randint(1, NUM_SUBSCRIPTIONS - 1)
    while subscriptions_list[subscription_id][0] == subscriptions_list[subscription_id][1]:
        subscription_id = random.randint(1, NUM_SUBSCRIPTIONS)
    readers = subscriptions_list[subscription_id][0] + 1
    max_readers = subscriptions_list[subscription_id][1]
    subscriptions_list[subscription_id] = (readers, max_readers)
    cur.execute("INSERT INTO Reader (SubscriptionID, ReaderID) VALUES (%s, %s)", (subscription_id,i))

# Wage
print("wage")
employees_used = []
for i in range(NUM_WAGES):
    amount = random.uniform(500.00, 3000.00)
    monthly_payment_date = random.choice([0,1,10,25])
    employee_id = random.randint(1, NUM_EMPLOYEES)
    while employee_id in employees_used:
        employee_id = random.randint(1, NUM_EMPLOYEES)
    employees_used.append(employee_id)
    cur.execute("INSERT INTO Wage (Amount, monthly_payment_date, EmployeeID) VALUES (%s, %s, %s)",
                (amount, monthly_payment_date, employee_id))

print("penalty")
# Penalty Income, Subscription Monthly Income, Wage Expense
penalties_uesd = []
for i in range(NUM_PENALTY_INCOME):

    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id in billing_used: 
        billing_id = random.randint(1, NUM_BILLINGS)
    billing_used.append(billing_id)

    penalty_id = random.randint(1, NUM_PENALTIES)
    while penalty_id in penalties_uesd: 
        penalty_id = random.randint(1, NUM_PENALTIES)
    penalties_uesd.append(billing_id)

    cur.execute("INSERT INTO Penalty_Income (BillingID, PenaltyID) VALUES (%s, %s)", (billing_id, penalty_id))

print("sub income")
for i in range(NUM_SUBSCRIPTION_MONTHLY_INCOME):
    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id in billing_used: 
        billing_id = random.randint(1, NUM_BILLINGS)
    billing_used.append(billing_id)

    subscription_id = random.randint(1, NUM_SUBSCRIPTIONS)
    cur.execute("INSERT INTO Subscription_Monthly_Income (BillingID, SubscriptionID) VALUES (%s, %s)",
                (billing_id, subscription_id))

print("wage expense")
for i in range(NUM_WAGE_EXPENSE):
    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id in billing_used: 
        billing_id = random.randint(1, NUM_BILLINGS)
    billing_used.append(billing_id)
    employee_id = random.randint(1, NUM_EMPLOYEES)
    cur.execute("INSERT INTO Wage_Expense (BillingID, EmployeeID) VALUES (%s, %s)", 
                (billing_id, employee_id))

print("book")
# Book & Insurance
assets_used = []
for i in range(NUM_BOOKS):
    asset_id = random.randint(1, NUM_ASSETS)
    while asset_id in assets_used: 
        asset_id = random.randint(1, NUM_ASSETS)
    assets_used.append(asset_id)
    cur.execute("INSERT INTO Book (BookID, AssetID) VALUES (%s, %s)", 
                (i, asset_id))

print("insurance")
assets_used = []
for i in range(NUM_INSURANCES + 1):
    covered_amount = random.uniform(500.00, 5000.00)
    start_date = generate_random_date()
    end_date = start_date + timedelta(days=random.randint(30, 365))
    asset_id = random.randint(1, NUM_ASSETS)
    while asset_id in assets_used: 
        asset_id = random.randint(1, NUM_ASSETS)
    assets_used.append(asset_id)

    cur.execute("INSERT INTO Insurance (Covered_Amount, EndDate, StartDate, AssetID, InsuranceID) VALUES (%s, %s, %s, %s, %s)", 
                (covered_amount, end_date, start_date, asset_id, i))

print("insurance expense")
# Insurance Expense
for i in range(NUM_INSURANCES):
    billing_id = random.randint(1, NUM_BILLINGS)
    while billing_id in billing_used: 
        billing_id = random.randint(1, NUM_BILLINGS)
    billing_used.append(billing_id)
    insurance_id = random.randint(1, NUM_INSURANCES)

    cur.execute("INSERT INTO Insurance_Expense (BillingID, InsuranceID) VALUES (%s, %s)", 
                (billing_id, insurance_id))



print("done")
# Commit the changes and close the connection
conn.commit()
cur.close()
conn.close()

print("Data populated successfully!")
