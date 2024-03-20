import mysql.connector


def connect_to_mysql():
    try:
        conn = mysql.connector.connect(
            host="database",
            user="root",
            password="root",
            database="FISHOLOGY",
            port="3306",
        )
        print("Connected to MySQL")
        return conn
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None


def execute_query(conn, query):
    try:
        cursor = conn.cursor()
        cursor.execute(query)
        conn.commit()
    except mysql.connector.Error as err:
        print(f"Error: {err}")


def query_to_json(conn, query):
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        return None
