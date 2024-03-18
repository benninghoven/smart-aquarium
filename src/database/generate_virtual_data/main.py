import mysql.connector
import time
from sensor_generator import SensorGenerator
from datetime import datetime, timedelta


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


def main():

    TRIES = 10
    for _ in range(TRIES):
        conn = connect_to_mysql()
        if conn:
            break
        print(f"Failed to connect to database. Try {_ + 1}/{TRIES}")
        time.sleep(5)

    if conn:
        print("POPULATING DATABASE WITH SIMULATED DATA")
        generator = SensorGenerator()
        MINUTES = 14400
        simulated_dt = datetime.now() - timedelta(days=10)
        for _ in range(MINUTES):
            rand_data = generator.generate_values()
            simulated_dt += timedelta(minutes=1)
            insert_query = f"""
                INSERT INTO SENSOR_READINGS (username, timestp, water_temp, PPM, pH)
                VALUES ('TESTUSER', '{simulated_dt.strftime('%Y/%m/%d %H:%M:%S')}',
                {rand_data['temperature']},
                {rand_data['ppm']},
                {rand_data['ph']});
                """

            execute_query(conn, insert_query)
            # do not need to commit every time but need to do often enough to avoid overflowing the buffer. May lower number if have weird errors
            if _ % 1000 == 0:
                print(f"{_/MINUTES * 100:.1F}% done")

        conn.close()
        print("100%  done")


if __name__ == "__main__":
    main()
