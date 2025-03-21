import mysql.connector as connector

connection = connector.connect(user = "root", password = "1234",
                               host = "localhost", port = 3306,
                               database = "littlelemondm")

cursor = connection.cursor()
show_tables_query = "SHOW tables" 
cursor.execute(show_tables_query)
for line in cursor:
    print(line)

join_query = """
SELECT 
	concat(customerdetails.FirstName, ' ', customerdetails.LastName),
    customerdetails.Phone,
    orders.TotalCost
FROM customerdetails join orders on customerdetails.CustomerId = orders.CustomerId
where orders.TotalCost > 70"""
cursor.execute(join_query)
for line in cursor:
    print(line)