from flask import Flask, jsonify
from sensor_generator import SensorGenerator


app = Flask(__name__)


@app.route('/get_sensor_values', methods=["GET"])
def get_sensor_values():
    generator = SensorGenerator()
    values = generator.generate_values()

    return jsonify(values)


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")
