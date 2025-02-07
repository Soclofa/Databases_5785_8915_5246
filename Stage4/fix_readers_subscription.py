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

# Fetch 30 persons
cursor.execute("select readerid from readers where subscriptionid is NULL")
readers = [row[0] for row in cursor.fetchall()]

# Fetch available subscriptions and their max limits
cursor.execute("""
                select subscriptionid
                from subscription s
                join subscription_tiers st
                on st.tier = s.tier
                where max_readers = 10 and subscriptionid IN (SELECT DISTINCT subscriptionid FROM readers WHERE subscriptionid IS NOT NULL);
               """)
subscriptions = [row[0] for row in cursor.fetchall()]

# Assign persons to subscriptions
assignments = []
random.shuffle(readers)
print(len(subscriptions))
print(len(readers))
for sub_id in subscriptions:
    num_readers = random.randint(6, 10)  # Random number between 1 and max
    for _ in range(num_readers):
        if readers:
            reader_id = readers.pop()
            assignments.append((sub_id, reader_id))
        else:
            break
print(len(assignments))
print(assignments[0])
# Update database with new assignments
for assignment in assignments:
    cursor.execute("UPDATE readers SET subscriptionid = %s WHERE readerid = %s", assignment)
# cursor.executemany("UPDATE readers SET subscriptionid = %s WHERE readerid = %s", assignments)
conn.commit()

# Close connection
cursor.close()
conn.close()

print("Assignments complete.")