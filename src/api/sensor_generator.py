import random


class SensorGenerator:
    def __init__(self):
        self.ph_range = (6.5, 7.5)
        self.ppm_range = (0, 200)
        self.temperature_range = (24, 28)
        self.previous_values = {'ph': 7.0, 'ppm': 100, 'temperature': 26.0}

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

        return {
            'ph': round(self.previous_values['ph'], 2),
            'ppm': round(self.previous_values['ppm']),
            'temperature': round(self.previous_values['temperature'], 2)
        }


if __name__ == "__main__":

    generator = SensorGenerator()
    values = generator.generate_values()

    print(f"pH: {values['ph']}, PPM: {values['ppm']}, Temperature: {values['temperature']}")
