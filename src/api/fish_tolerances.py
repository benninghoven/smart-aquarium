import json
# source https://www.aqueon.com/resources/care-guides


FISH_TOLERANCES = [

        {
            "fish_name": "African Cichlid",
            "max_temp": 80,
            "min_temp": 74,
            "max_ppm": 450,
            "min_ppm": 180,
            "max_ph": 9.0,
            "min_ph": 8.0,
        },
        {
            "fish_name": "Angelfish",
            "max_temp": 84,
            "min_temp": 78,
            "max_ppm": 145,
            "min_ppm": 54,
            "max_ph": 7.8,
            "min_ph": 6.8,
        },
        {
            "fish_name": "Barbs",
            "max_temp": 80,
            "min_temp": 75,
            "max_ppm": 140,
            "min_ppm": 50,
            "max_ph": 7.8,
            "min_ph": 6.8,
        },
        {
            "fish_name": "Betta",
            "max_temp": 85,
            "min_temp": 76,
            "max_ppm": 1000,
            "min_ppm": 100,
            "max_ph": 7.5,
            "min_ph": 6.8,
        },
        {
            "fish_name": "Corydoras Catfish",
            "max_temp": 80,
            "min_temp": 74,
            "max_ppm": 54,
            "min_ppm": 0,
            "max_ph": 8.0,
            "min_ph": 7.0,
        },
        {
            "fish_name": "Danios",
            "max_temp": 78,
            "min_temp": 70,
            "max_ppm": 140,
            "min_ppm": 50,
            "max_ph": 7.8,
            "min_ph": 7.0,
        },
        {
            "fish_name": "Discus",
            "max_temp": 86,
            "min_temp": 82,
            "max_ppm": 70,
            "min_ppm": 18,
            "max_ph": 7.0,
            "min_ph": 6.0,
        },
        {
            "fish_name": "Common Goldfish",
            "max_temp": 70,
            "min_temp": 60,
            "max_ppm": 200,
            "min_ppm": 50,
            "max_ph": 8.4,
            "min_ph": 7.0,
        }
        ]
# Convert Python data to JSON
json_data = json.dumps(FISH_TOLERANCES, indent=4)  # indent for pretty printing (optional)

# Print JSON data
print(json_data)

# Save JSON data to a file (optional)
with open('fish_tolerances.json', 'w') as json_file:
    json_file.write(json_data)