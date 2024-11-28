import pyodbc

# Connection setup
conn = pyodbc.connect(
    "Driver={ODBC Driver 18 for SQL Server};"
    "Server={tmp_db_server_name}.database.windows.net;"
    "Database={tmp_db_name};"
    "Uid={tmp_db_server_user};"
    "Pwd={tmp_db_server_password};"
    "Encrypt=yes;"
    "TrustServerCertificate=no;"
)

cursor = conn.cursor()

print("-----------------------------------")
cursor.execute("SELECT DB_NAME();")
print("Current Database:", cursor.fetchone()[0])
print("-----------------------------------")
print("")

cursor.execute("""
    SELECT TABLE_SCHEMA, TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE';
""")

print("-----------------------------------")
print("Tables in the Database:")
for row in cursor.fetchall():
    print(row)
print("-----------------------------------")
print("")

# List tables
cursor.execute("""
    SELECT * FROM dbo.users;
""")

print("-----------------------------------")
print("Records in the users table:")
for row in cursor.fetchall():
    print(row)
print("-----------------------------------")
print("")

cursor.execute("""
    SELECT * FROM dbo.posts;
""")

print("-----------------------------------")
print("Records in the posts table:")
for row in cursor.fetchall():
    print(row)
print("-----------------------------------")
print("")

# Close the connection
conn.close()

