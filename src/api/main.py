from flask import Flask, jsonify
from sql_helpers import connect_to_mysql, execute_query, query_to_json

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


@app.route("/get_today_readings", methods=["GET"])
def get_today_readings():
    conn = connect_to_mysql()
    if conn:
        today_query = """
        SELECT * FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1;
        """
        today_result = query_to_json(conn, today_query)
        conn.close()
        return jsonify(today_result)
    return jsonify({"error": "Could not connect to MySQL"})


@app.route("/get_month_readings", methods=["GET"])
def get_month_readings():
    conn = connect_to_mysql()
    if conn:
        month_query = """
        SELECT * FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(MONTH, SENSOR_READINGS.TIMESTP, NOW()) < 1;
        """
        month_result = query_to_json(conn, month_query)
        conn.close()
        return jsonify(month_result)
    return jsonify({"error": "Could not connect to MySQL"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
