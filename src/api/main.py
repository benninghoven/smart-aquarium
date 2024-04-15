from flask import Flask, jsonify, request
import hashlib
from sql_helpers import connect_to_mysql, execute_query, query_to_json
import secrets
import string
from validate_account import *


app = Flask(__name__)

app.config['CORS_HEADERS'] = 'content-type'

def generate_salt(length=16):
    """Generate a random salt."""
    chars = string.ascii_letters + string.digits
    return ''.join(secrets.choice(chars) for _ in range(length))

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

@app.route("/login", methods=["POST"])
def login_or_signup_user():
    try:
        data = request.get_json()
        username = data["username"]
        password = data["password"]
        is_signup = data.get("signup") == "true"

        conn = connect_to_mysql()
        if not conn:
            return jsonify({"error": "Could not connect to MySQL"}), 500

        if is_signup:
            if create_account(username, password):
                return jsonify({"message": "Signup successful"}), 201  # Created status code
            else:
                return jsonify({"error": "Signup Failed"}), 409  # Conflict status code
        else:
            # Login logic
            if login(username, password):
                return jsonify({"message": "Login successful"}), 200
            else:
                return jsonify({"error": "Invalid username or password"}), 401

    except Exception as e:
        print("Error during signup/login:", e)  # Debug: Print error message
        return jsonify({"error": "An error occurred. Please try again later."}), 500



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
