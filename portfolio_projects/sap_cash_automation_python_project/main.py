

"""
num1 = 3

if num1 == 10:
    print("Your order is free")
elif num1 < 10:
    print("You have " + str(num1) + " orders")


material = 'plastic'

if material == 'plastic':
    waste = 'recycling'

if material != 'plastic':
    waste = 'trash'

print("please put to " + waste + " thanks.")




import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="Starlink@sn25"
)

print(mydb)
"""

import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="Starlink@sn25"
)
mycursor = mydb.cursor()

mycursor.execute("SHOW DATABASES")

for x in mycursor:
  print(x)