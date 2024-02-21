from w1thermsensor import W1ThermSensor, Unit


class TemperatureSensor:
    def __init__(self):
        try:
            self.sensor = W1ThermSensor()
        except Exception as e:
            print(f"Error initializing sensor: {e}")

    def poll(self):
        try:
            return self.sensor.get_temperature(Unit.DEGREES_F)
        except Exception as e:
            print(f"Error polling sensor: {e}")
            return None
