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
