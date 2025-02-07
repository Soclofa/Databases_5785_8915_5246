import random
import psycopg2

# Database connection (update credentials as needed)
conn = psycopg2.connect(
    dbname="Library Billing System",  # replace with your database name
    user="postgres",        # replace with your user
    password="AviSoclof",   # replace with your password
    host="localhost",       # or your host if not local
    port="5432"             # default PostgreSQL port
)
cursor = conn.cursor()

# Fetch available subscriptions and their max limits
cursor.execute("""
                select subscriptionid, max_readers
                from subscription s
                join subscription_tiers st
                on st.tier = s.tier
               """)
subscriptions = cursor.fetchall()

# Fetch 30 persons
cursor.execute("select readerid from readers")
readers = [row[0] for row in cursor.fetchall()]

# Assign persons to subscriptions
assignments = []
random.shuffle(readers)

for sub_id, max_readers in subscriptions:
    if max_readers == 0:
        continue
    num_readers = random.randint(1, max_readers)  # Random number between 1 and max
    for _ in range(num_readers):
        if readers:
            reader_id = readers.pop()
            assignments.append((reader_id, sub_id))
        else:
            break

# Update database with new assignments
cursor.executemany("UPDATE readers SET subscriptionid = %s WHERE readerid = %s", assignments)
conn.commit()

# Close connection
cursor.close()
conn.close()

print("Assignments complete.")