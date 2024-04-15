from sensor_generator import SensorGenerator
from datetime import datetime, timedelta
import time
from sql_helpers import connect_to_mysql, execute_query

from fish_tolerances import FISH_TOLERANCES


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

        cursor.execute("SELECT COUNT(*) FROM SENSOR_READINGS")
        count = cursor.fetchone()[0]
        cursor.close()

        if count > 0:
            print("Database already has data. Not populating with simulated data")
        else:
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
                # do not need to commit every time but need to do often enough to
                # avoid overflowing the buffer. May lower number if have weird errors
                if _ % 1000 == 0:
                    print(f"{_/MINUTES * 100:.1F}% done")

            print("100%  done")

        cursor = conn.cursor()

        cursor.execute("SELECT COUNT(*) FROM FISH_TOLERANCES")
        count = cursor.fetchone()[0]
        cursor.close()

        if count > 0:
            print("FISH_TOLERANCES Database already has data. Not populating with simulated data")
            return
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
        conn.close()
        return


if __name__ == "__main__":
    main()
