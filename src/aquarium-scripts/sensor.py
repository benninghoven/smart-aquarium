############################
# DJB 02/17/2024
# Base Class for All Sensors
############################

from random import randint


sensorStatsDictionary = {
        "temperature": {"max": 10000,
                        "min": 0,
                        "symbol": "°F",
                        },
        "ph": {"max": 14,
               "min": 0,
               "symbol": "°F",
               },
        "ppm": {"max": 10000,
                "min": 0,
                "symbol": "PPM",
                },
        }


class Sensor:
    def __init__(self, sensorType=None):
        self.name = sensorType
        if sensorType in sensorStatsDictionary:
            self.max = sensorStatsDictionary[sensorType]["max"]
            self.min = sensorStatsDictionary[sensorType]["min"]
            self.symbol = sensorStatsDictionary[sensorType]["symbol"]
        else:
            self.max = 666
            self.min = 32 
            self.symbol = "sym"
        print(f'''created {self.name} sensor with values
              {self.max},{self.min},{self.symbol}
              ''')

    def poll(self):
        if self.name in sensorStatsDictionary:
            # Use specific function
            return -42
        else:
            return randint(self.min, self.max)

