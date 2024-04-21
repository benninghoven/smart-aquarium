import time
import sys
from datetime import datetime, timedelta
from sensor_generator import SensorGenerator
from fish_tolerances import FISH_TOLERANCES
from utils.sql_helpers import connect_to_mysql, execute_query
from utils.fish_reading_checker import fish_checker


def generate_month_data(conn):
    cursor = conn.cursor()

    lastMonth = datetime.now() - timedelta(days=30)
    MINUTES = int((datetime.now() - lastMonth).total_seconds() / 60)


    # SORRY I COMMENTED FOR NOW - DEVIN
    #checker = fish_checker(conn, 1111111111, debug=True)

    generator = SensorGenerator()

    for i in range(MINUTES):
        data = generator.generate_values()

        dt = (lastMonth + timedelta(minutes=i)).strftime('%Y-%m-%d %H:%M:%S')

        insert_query = f"""
            INSERT INTO SENSOR_READINGS (tank_id, timestp, water_temp, PPM, pH)
            VALUES (
            {data['tank_id']},
            '{dt}',
            {data['temperature']},
            {data['ppm']},
            {data['ph']}
            );
            """

        cursor.execute(insert_query)

        # SORRY I COMMENTED FOR NOW - DEVIN
        #checker.check_bounds(rand_data['temperature'], rand_data['ppm'], rand_data['ph'], simulated_dt, add_alert=True, debug=True)

        if i % 1000 == 0:
            print(f"{i/MINUTES * 100:.1F}% done... commiting to database")
            conn.commit()

        conn.commit()

    print(f"generation complete from {lastMonth} to {datetime.now()}")
    return


def establish_database_connection():
    TRIES = 10
    for _ in range(TRIES):
        conn = connect_to_mysql()
        if conn:
            return conn
        print(f"failed to connect to database...\ntry {_ + 1}/{TRIES}")
        time.sleep(5)
    print(f"failed to connect to database after {TRIES} attempts")
    return None


def does_table_exist(cursor, table_name):
    cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
    count = cursor.fetchone()[0]
    return count > 0


def main():

    conn = establish_database_connection()

    if not conn:
        exit()

    cursor = conn.cursor()

    if does_table_exist(cursor, "FISH_TOLERANCES"):
        print("table FISH_TOLERANCES already exists")
    else:
        print("POPULATING FISH_TOLERANCES DATABASE")

        for fish in FISH_TOLERANCES:
            query = f"""
                INSERT INTO FISH_TOLERANCES (fish_name, max_temp, min_temp, max_ppm, min_ppm, max_ph, min_ph)
                VALUES(
                    '{fish["fish_name"]}',
                    {fish["max_temp"]},
                    {fish["min_temp"]},
                    {fish["max_ppm"]},
                    {fish["min_ppm"]},
                    {fish["max_ph"]},
                    {fish["min_ph"]}
                );
            """
            execute_query(conn, query)
        print("COMPLETE: POPULATED FISH_TOLERANCES")
        conn.commit()

    time.sleep(1)

    if does_table_exist(cursor, "FISH_IN_USER_TANK"):
        print("table FISH_IN_USER_TANK already exists")
    else:
        print("POPULATING FISH_IN_USER_TANK DATABASE")
        query = f"""INSERT INTO FISH_IN_USER_TANK (tank_id, fish) VALUES ({1111111111}, "Angelfish"), ({1111111111}, "Betta")"""
        execute_query(conn, query)
        print("COMPLETE: POPULATED FISH IN USER TANK FOR USER: 1111111111")
        conn.commit()

    time.sleep(1)

    # using account 1111111111 for simulated data, cannot actually sign into in app

    if does_table_exist(cursor, "SENSOR_READINGS"):
        print("table SENSOR_READINGS already exists")
    else:
        print("GENERATING MONTH DATA")
        generate_month_data(conn)

    print("looping")

    while True:

        print("reading sensor data")
        generator = SensorGenerator()
        data = generator.generate_values()

        insert_query = f"""
            INSERT INTO SENSOR_READINGS (tank_id, timestp, water_temp, PPM, pH)
            VALUES (
            {data['tank_id']},
            '{data['timestp']}',
            {data['temperature']},
            {data['ppm']},
            {data['ph']}
            );
            """

        cursor.execute(insert_query)
        conn.commit()

        print(f"inserted data: {data}")

        print("sleeping for 60 seconds")
        time.sleep(60)

    conn.close()
    return


if __name__ == "__main__":
    main()
