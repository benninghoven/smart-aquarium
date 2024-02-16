import time
from w1thermsensor import W1ThermSensor, Unit

sensor = W1ThermSensor()

while True:
    temperature_in_fahrenheit = sensor.get_temperature(Unit.DEGREES_F)
    print(f"Temperature: {temperature_in_fahrenheit:.2F} °F")
    time.sleep(1)
