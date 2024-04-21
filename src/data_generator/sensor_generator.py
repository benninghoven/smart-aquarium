import random
from datetime import datetime


class SensorGenerator:
    def __init__(self):
        self.ph_range = (6.5, 7.5)
        self.ppm_range = (0, 200)
        self.temperature_range = (65, 90)
        self.previous_values = {'ph': 7.0, 'ppm': 100, 'temperature': 72}

        self.timestp = None
        self.tank_id = 1111111111

    def change_tank_id(self, tank_id):
        self.tank_id = tank_id

    def generate_values(self):

        ph_variation = random.uniform(-0.1, 0.1)
        ppm_variation = random.uniform(-10, 10)
        temperature_variation = random.uniform(-0.5, 0.5)

        self.previous_values['ph'] += ph_variation
        self.previous_values['ppm'] += ppm_variation
        self.previous_values['temperature'] += temperature_variation

        self.previous_values['ph'] = max(self.ph_range[0], min(self.ph_range[1], self.previous_values['ph']))
        self.previous_values['ppm'] = max(self.ppm_range[0], min(self.ppm_range[1], self.previous_values['ppm']))
        self.previous_values['temperature'] = max(self.temperature_range[0], min(self.temperature_range[1], self.previous_values['temperature']))

        self.timestp = datetime.now()

        return {
            'ph': round(self.previous_values['ph'], 2),
            'ppm': round(self.previous_values['ppm']),
            'temperature': round(self.previous_values['temperature'], 2),
            'timestp': self.timestp,
            'tank_id': self.tank_id,
        }

    def generate_unhealthy_values(self):

        return {
            'ph': 11.3,
            'ppm': 1020,
            'temperature': 120,
            'timestp': self.timestp,
            'tank_id': self.tank_id,
        }


if __name__ == "__main__":

    generator = SensorGenerator()
    values = generator.generate_values()

    print(f"pH: {values['ph']}, PPM: {values['ppm']}, Temperature: {values['temperature']}")
