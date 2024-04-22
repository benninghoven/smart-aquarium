from flask import Flask, jsonify
from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json
import json

app = Flask(__name__)

app.config['CORS_HEADERS'] = 'content-type'


@app.route("/get_latest_reading", methods=["GET"])
def get_latest_readings():
    conn = connect_to_mysql()
    if conn:
        latest_readings_query = """SELECT * FROM FISHOLOGY.SENSOR_READINGS ORDER BY timestp DESC LIMIT 1;"""
        result = query_to_json(conn, latest_readings_query)
        conn.close()
        return jsonify(result[0])
    return jsonify({"error": "Could not connect to MySQL"})


@app.route("/get_all_readings", methods=["GET"])
def get_all_readings():
    conn = connect_to_mysql()
    if conn:
        everything_query = """SELECT * FROM FISHOLOGY.SENSOR_READINGS LIMIT 500;"""
        everything_result = query_to_json(conn, everything_query)
        conn.close()
        return jsonify(everything_result)
    return jsonify({"error": "Could not connect to MySQL"})


@app.route("/get_7_day_readings", methods=["GET"])
def get_7_day_readings():
    conn = connect_to_mysql()
    if conn:
        seven_day_query = """SELECT * FROM FISHOLOGY.SENSOR_READINGS WHERE timestp >= DATE_SUB(NOW(), INTERVAL 7 DAY);"""
        seven_day_result = query_to_json(conn, seven_day_query)
        conn.close()
        return jsonify(seven_day_result)
    return jsonify({"error": "Could not connect to MySQL"})


@app.route('/get_fish_tolerances')
def get_fish_tolerances():
    with open('fish_tolerances.json', 'r') as f:
        fish_tolerances = json.load(f)
    return jsonify(fish_tolerances)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
