####################
# Devin Benninghoven
# 02/02/24
####################

# Taken from this wiki below
# http://www.cqrobot.wiki/index.php/TDS_(Total_Dissolved_Solids)_Meter_Sensor_SKU:_CQRSENTDS01
# TDS Measurement Range: 0 to 1000ppm
# DS Measurement Accuracy: Plus/Minus 10% F.S. (25 Degree Celsius)

from temperature_sensor import TemperatureSensor
from time import sleep


TIMESTOPOLL = 10
TIMETOSLEEP = .5
SENSORS = []


temperatureSensor = TemperatureSensor()

SENSORS.append(temperatureSensor)

for sensor in SENSORS:
    print("RUNNING: {SENSOR_NAME}")
    for i in range(0, TIMESTOPOLL):
        value = sensor.poll()
        print(value)
        sleep(TIMETOSLEEP)
