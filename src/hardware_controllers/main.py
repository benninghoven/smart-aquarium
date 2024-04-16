from time import sleep
from gpiozero import LED
import threading
from sensors import TemperatureSensor, PPMSensor, PHSensor
from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json


def main():

    temperatureSensor = TemperatureSensor()
    ppmSensor = PPMSensor()
    phSensor = PHSensor()
    debugLight = LED(17)

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

            print(f"Sleeping for {TIME_BETWEEN_READINGS} seconds...")
            sleep(TIME_BETWEEN_READINGS)

    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        exit(0)


if __name__ == "__main__":
    main()
