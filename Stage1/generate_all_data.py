import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta
import uuid

# Initialize Faker
fake = Faker()

# Define fixed values
subscription_types = ['Family Plan', 'Individual Plan', 'Student Plan', 'Corporate Plan', 'Premium Plan']
penalty_types = ['Late Fee', 'Damage Fee', 'Lost Item Fee']
employee_positions = ['Librarian', 'Assistant', 'Manager']
asset_types = ['Computer', 'Furniture', 'Book', 'Building']
insurance_types = ['Full Coverage', 'Partial Coverage', 'No Coverage']

# Database connection
connection = psycopg2.connect(
    dbname="Library Billing System",  # replace with your database name
    user="postgres",        # replace with your user
    password="AviSoclof",   # replace with your password
    host="localhost",       # or your host if not local
    port="5432"             # default PostgreSQL port
)
cursor = connection.cursor()

# Helper function to generate random dates
def random_date(start_year=2020, end_year=2025):
    start_date = datetime(start_year, 1, 1)
    end_date = datetime(end_year, 12, 31)
    return fake.date_between_dates(date_start=start_date, date_end=end_date)

# Insert data into Insurance table
for i in range(200000):
    insurance_type = random.choice(insurance_types)
    start_date = random_date()
    end_date = start_date + timedelta(days=random.randint(30, 365))
    covered_amount = round(random.uniform(1000, 50000), 2)
    cursor.execute("""
        INSERT INTO Insurance (CoveredAmount, StartDate, EndDate)
        VALUES (%s, %s, %s)
    """, (covered_amount, start_date, end_date))

# Insert data into Subscription table
for i in range(100000):
   
    subscription_type = random.choice(subscription_types)
    renewal_date = random_date()
    purchase_date = renewal_date - timedelta(days=random.randint(30, 365))
    cursor.execute("""
        INSERT INTO Subscription (SubscriptionType, RenewalDate, PurchaseDate)
        VALUES (%s, %s, %s)
    """, ( subscription_type, renewal_date, purchase_date))

for i in range(200000):
    subscription_id_index = random.randint(1,99999)

    cursor.execute("""
        INSERT INTO Reader (SubscriptionID)
        VALUES (%s)
    """, [subscription_id_index])

for i in range(50000):

    subscription_id_index = random.randint(1,99999)
    penalty_id = random.randint(1,200000)

    book_id = i + 1
    cursor.execute("""
        INSERT INTO SubscriptionPenalties (SubscriptionID, PenaltyID, BookID)
        VALUES (%s, %s, %s)
    """, (subscription_id_index, penalty_id, book_id))

# Insert data into Wage table
for i in range(200000):
    amount = round(random.uniform(1000, 10000), 2)
    pay_day = random_date(2020, 2024)
    cursor.execute("""
        INSERT INTO Wage (Amount, PayDay)
        VALUES (%s, %s)
    """, (amount, pay_day))

    wage_id = i + 1
    cursor.execute("""
        INSERT INTO Employee (WageID)
        VALUES (%s)
    """, (wage_id,))

connection.commit()

# Insert data into Procurement table
for i in range(1000):
    procurement_id = i+1
    source = fake.company()
    procurement_date = random_date()
    cost = round(random.uniform(500, 10000), 2)
    cursor.execute("""
        INSERT INTO Procurement (Source, ProcurementDate, Cost)
        VALUES (%s, %s, %s)
    """, (source, procurement_date, cost))
connection.commit()

for i in range(200000):
    procurement_id = random.randint(1,999)
    insurance_id = i + 1
    asset_type = random.choice(asset_types)
    cursor.execute("""
        INSERT INTO Asset (Type, InsuranceID, ProcurementID)
        VALUES (%s, %s, %s)
    """, (asset_type, insurance_id, procurement_id))

# Commit all transactions and close the connection
connection.commit()
cursor.close()
connection.close()

print("Data insertion complete.")
