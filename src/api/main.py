from flask import Flask, jsonify, request
from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json
import json

app = Flask(__name__)

app.config['CORS_HEADERS'] = 'content-type'

users = {}


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


@app.route('/register', methods=['POST'])
def register():
    data = request.json

    print(f"DATA: {data}")

    if not data or 'username' not in data or 'hashedPassword' not in data or 'salt' not in data:
        return jsonify({"error": "Missing required fields"}), 400

    conn = connect_to_mysql()

    if conn:
        account_query = """SELECT * FROM FISHOLOGY.ACCOUNTS;"""
        accounts = query_to_json(conn, account_query)

        username = data['username']
        hashed_password = data['hashedPassword']
        salt = data['salt']
        tankId = data.get('tankId')

        for account in accounts:
            if account['username'] == username:
                return jsonify({"error": "Username already exists"}), 400

        print(f"registering {username}")
        insert_query = f"""
        INSERT INTO FISHOLOGY.ACCOUNTS (username, hashed_pw, salt_val, tank_id)
        VALUES (
                '{username}',
                '{hashed_password}',
                '{salt}',
                '{tankId}'
                );
        """
        execute_query(conn, insert_query)

    return jsonify({"message": "User registered successfully"}), 200


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"message": "Missing username or password"}), 400

    conn = connect_to_mysql()
    if conn:
        account_query = f"""SELECT * FROM FISHOLOGY.ACCOUNTS WHERE username = '{username}';"""
        accounts = query_to_json(conn, account_query)

        print("ACCOUNTS: ", accounts)

        conn.close()

    if True:
        return jsonify({"message": "Login successful"}), 200
    else:
        return jsonify({"message": "Invalid username or password"}), 401


@app.route('/get_fish_tolerances')
def get_fish_tolerances():
    with open('fish_tolerances.json', 'r') as f:
        fish_tolerances = json.load(f)
    return jsonify(fish_tolerances)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
