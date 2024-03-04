####################
# Devin Benninghoven
# 02/02/24
####################

import os

from temperature_sensor.temperature_sensor import TemperatureSensor
from adc.adc import Adc
from time import sleep
from statistics import mode


current_script_dir = os.path.dirname(os.path.realpath(__file__))
parent_dir = os.path.abspath(os.path.join(current_script_dir, os.pardir))
os.chdir(parent_dir)


LOOPS = 100
SLEEPTIME = .3


def convert_to_tds(voltage, temperature):

    compensationCoefficient = 1.0 + 0.02 * (temperature - 25.0)
    compensationVolatge = voltage / compensationCoefficient
    tdsValue = (133.42 * compensationVolatge * compensationVolatge * compensationVolatge - 255.86 * compensationVolatge * compensationVolatge + 857.39 * compensationVolatge) * 0.5

    return tdsValue


temperatureSensor = TemperatureSensor()
temperatureValues = []

print("""MEASURING TEMPERATURE""")

for i in range(0, LOOPS):
    temperatureValue = temperatureSensor.poll()
    print(f"{temperatureValue:.2f}F")
    temperatureValues.append(temperatureValue)
    sleep(SLEEPTIME)

modeTemperature = mode(temperatureValues)
print(f"Mode Temperature: {modeTemperature:.2f}F")
