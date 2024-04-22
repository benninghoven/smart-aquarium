import mysql.connector
from mysql.connector import errorcode

#TODO: get it to work with stored procedure for better security

db_config = {
    'host': '127.0.0.1',
    'port': '3307',
    'database': 'FISHOLOGY',
    'user': 'root',
    'password': 'root'
}

def get_db_and_cursor():
    try:
        db = mysql.connector.connect(**db_config)
        cursor = db.cursor(prepared=True)
        return db, cursor   # dont forget to db.close()
    except mysql.connector.Error as err:
        print("Error with connecting to database")
        print(err.msg)
