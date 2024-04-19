import time
from datetime import datetime, timedelta
from sensor_generator import SensorGenerator
from fish_tolerances import FISH_TOLERANCES
from utils.sql_helpers import connect_to_mysql, execute_query
from utils.fish_reading_checker import fish_checker

def main():

    TRIES = 10
    for _ in range(TRIES):
        conn = connect_to_mysql()
        if conn:
            break
        print(f"Failed to connect to database. Try {_ + 1}/{TRIES}")
        time.sleep(5)

    if conn:
        
        cursor = conn.cursor()

        cursor.execute("SELECT COUNT(*) FROM FISH_TOLERANCES")
        count = cursor.fetchone()[0]
        cursor.close()
        

        if count > 0:
            print("FISH_TOLERANCES Database already has data. Not populating with simulated tolerances data")
            # return
        else:
            print("POPULATING FISH_TOLERANCES DATABASE")

            for fish in FISH_TOLERANCES:
                query = f"""
                INSERT INTO FISH_TOLERANCES (fish_name, max_temp, min_temp, max_ppm, min_ppm, max_ph, min_ph)
                VALUES ("{fish["fish_name"]}",
                        {fish["max_temp"]},
                        {fish["min_temp"]},
                        {fish["max_ppm"]},
                        {fish["min_ppm"]},
                        {fish["max_ph"]},
                        {fish["min_ph"]});
                """
                execute_query(conn, query)
            print("COMPLETE: POPULATED FISH_TOLERANCES")
            conn.commit()
        
        time.sleep(1)

        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM FISH_IN_USER_TANK")
        count = cursor.fetchone()[0]
        cursor.close()

        if count > 0:
            print("Databse already has data. Not populating with simulated fish in user tank data")
            # return
        else:
            print("POPULATING FISH_IN_USER_TANK DATABASE")
            query = f"""INSERT INTO FISH_IN_USER_TANK (tank_id, fish) VALUES ({1111111111}, "Angelfish"), ({1111111111}, "Betta")"""
            execute_query(conn, query)
            print("COMPLETE: POPULATED FISH IN USER TANK FOR USER: 1111111111")
            conn.commit()
        
        time.sleep(1)

        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM SENSOR_READINGS")
        count = cursor.fetchone()[0]
        cursor.close()

        # using account 1111111111 for simulated data, cannot actually sign into in app

        if count > 0:
            print("Database already has data. Not populating with simulated readings data")
            # return
        else:
            print("POPULATING DATABASE WITH SIMULATED DATA")

            generator = SensorGenerator()
            MINUTES = 1400
            simulated_dt = datetime.now() - timedelta(days=1)

            checker = fish_checker(conn, 1111111111, debug=True)

            for _ in range(MINUTES):
                rand_data = generator.generate_values()
                simulated_dt += timedelta(minutes=1)
                insert_query = f"""
                    INSERT INTO SENSOR_READINGS (tank_id, timestp, water_temp, PPM, pH)
                    VALUES ({1111111111}, '{simulated_dt.strftime('%Y/%m/%d %H:%M:%S')}',
                    {rand_data['temperature']},
                    {rand_data['ppm']},
                    {rand_data['ph']});
                    """

                execute_query(conn, insert_query)
                checker.check_bounds(rand_data['temperature'], rand_data['ppm'], rand_data['ph'], simulated_dt, add_alert=True, debug=True)
                # do not need to commit every time but need to do often enough to
                # Commit every 1000 to avoid overflowing the buffer, also update user on progress.
                if _ % 1000 == 0:
                    print(f"{_/MINUTES * 100:.1F}% done")
                    conn.commit()

            print("100%  done")
            conn.commit()
            conn.close()
        return


if __name__ == "__main__":
    main()
