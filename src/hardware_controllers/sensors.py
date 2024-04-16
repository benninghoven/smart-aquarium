############################
# DJB 02/17/2024
############################

from w1thermsensor import W1ThermSensor, Unit
from statistics import mode
from random import randint, randrange
from time import sleep


class Sensor:
    def __init__(self, /, *, name, unit):
        self.name = name
        self.unit = unit
        self.times_to_poll = 10
        print(f"Sensor {name} initialized")

    def Poll(self):
        return -1

    def Read(self):
        readings = []
        for _ in range(self.times_to_poll):
            reading = self.Poll()
            if reading is not None:
                readings.append(reading)
        return mode(readings)


class TemperatureSensor(Sensor):
    def __init__(self):
        super().__init__(name="temperature", unit="°F")
        try:
            self.sensor = W1ThermSensor()
        except Exception as e:
            print(f"Error initializing sensor: {e}")
            exit(1)

    def Poll(self):
        try:
            return self.sensor.get_temperature(Unit.DEGREES_F)
        except Exception as e:
            print(f"Error polling sensor: {e}")
            return None


class PPMSensor(Sensor):
    def __init__(self):
        super().__init__(name="ppm", unit="ppm")

    def Poll(self):
        return randint(100, 250)

    def Read(self):
        readings = []
        for _ in range(self.times_to_poll):
            reading = self.Poll()
            if reading is not None:
                readings.append(reading)
        sleep(3)
        return mode(readings)


class PHSensor(Sensor):
    def __init__(self):
        super().__init__(name="pH", unit="pH")

    def Poll(self):
        return randrange(65, 80) / 10

    def Read(self):
        readings = []
        for _ in range(self.times_to_poll):
            reading = self.Poll()
            if reading is not None:
                readings.append(reading)
        sleep(3)
        return mode(readings)
