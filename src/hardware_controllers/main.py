from time import sleep
from gpiozero import LED
import threading
from sensors import TemperatureSensor, PPMSensor, PHSensor
from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json
from utils.fish_reading_checker import fish_checker
from datetime import datetime


def main():

    temperatureSensor = TemperatureSensor()
    ppmSensor = PPMSensor()
    phSensor = PHSensor()
    debugLight = LED(17)

    m_temp = 999999
    m_ppm = 999999
    m_ph = 999999

    const_tankid = 0
    # get tank_id, stored in tank_id.txt
    with open("tank_id.txt", 'r') as tid:
        const_tankid = int(tid.readline())

    try:
        while True:
            print("Reading temperature...")

            for i in range(3):
                t1 = threading.Thread(target=debugLight.blink, args=(0.5, 0.5))
                t1.start()

                if i == 0:
                    try:
                        measured_temperature = temperatureSensor.Read()
                        print(f"{temperatureSensor.name}: {measured_temperature}{temperatureSensor.unit}")
                    finally:
                        debugLight.off()
                elif i == 1:
                    try:
                        measured_ppm = ppmSensor.Read()
                        print(f"{ppmSensor.name}: {measured_ppm}{ppmSensor.unit}")
                    finally:
                        debugLight.off()

                elif i == 2:
                    try:
                        measured_ph = phSensor.Read()
                        print(f"{phSensor.name}: {measured_ph}{phSensor.unit}")
                    finally:
                        debugLight.off()

            with open("time_between_readings.txt", "r") as file:
                TIME_BETWEEN_READINGS = int(file.read())

            print("Inputting values into DB")
            try:
                conn = connect_to_mysql()
                cursor = conn.cursor()
                cursor.execute(f"""
                    INSERT INTO SENSOR_READINGS (tank_id, timestp, water_temp, PPM, pH)
                    VALUES ({const_tankid}, '{datetime.now()}', {m_temp}, {m_ppm}, {m_ph});""")
                cursor.close()
                conn.commit()
                conn.close()
                print("Values inserted")
                # bounds checking - DEVIN UNCOMMENT WHEN READY TO USE
                #checker = fish_checker(conn, 1111111111, debug=True)
                #checker.check_bounds(m_temp, m_ppm, m_ph, datetime.now(), add_alert=True, debug=True)
            except Exception as e:
                print("Error with inserting data into MySQL: ", e)

            print(f"Sleeping for {TIME_BETWEEN_READINGS} seconds...")
            sleep(TIME_BETWEEN_READINGS)

    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        exit(0)


if __name__ == "__main__":
    main()
