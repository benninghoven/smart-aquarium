import mysql.connector


def connect_to_mysql():
    try:
        conn = mysql.connector.connect(
            host="0.0.0.0",
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


def main():

    conn = connect_to_mysql()
    if conn:
        print("Connected to MySQL")

    conn.close()
    print("100%  done")


if __name__ == "__main__":
    main()
