#########################################
# DJB 02/16/2024
# Will generate noise from virtual sensor
#########################################

from sensor import Sensor
import json
from time import sleep

testSensor = Sensor("test")

total = 0.0
tries = 10

for i in range(0, tries):
    pollValue = testSensor.poll()
    print("value:", pollValue, testSensor.symbol)
    total += pollValue
    sleep(0.25)

averagePoll = total / tries

print("Average Poll", averagePoll)

data = {
        testSensor.name: averagePoll,
        }

with open("data_file.json", "w") as write_file:
    print("writing data to file")
    json.dump(data, write_file)
