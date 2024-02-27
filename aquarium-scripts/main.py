####################
# Devin Benninghoven
# 02/02/24
####################

from temperature_sensor import TemperatureSensor
from adc import Adc
from time import sleep
from statistics import mode

LOOPS = 10
SLEEPTIME = .2


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

tds_values = []
adc = Adc()
for i in range(0, LOOPS):
    adc_value, voltage = adc.poll_sensor(1)
    tds = int(convert_to_tds(voltage, modeTemperature))
    tds_values.append(tds)
    print(f"{tds}ppm")
    sleep(SLEEPTIME)

mode_tds = mode(tds_values)
print(f"Mode TDS: {mode_tds}ppm")
