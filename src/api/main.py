from flask import Flask, jsonify, request
import hashlib
from sql_helpers import connect_to_mysql, execute_query, query_to_json
import secrets
import string


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
            print("Received signup request:", data)  # Debug: Print received JSON data

            # Check if the username already exists
            fetch_user_query = f"SELECT * FROM FISHOLOGY.accounts WHERE username = '{username}'"
            existing_user_data = execute_query(conn, fetch_user_query)
            if existing_user_data:
                return jsonify({"error": "Username already exists"}), 409  # Conflict status code

            # Generate a salt and hash the password
            salt = generate_salt()
            hashed_password = hashlib.sha256((password + salt).encode()).hexdigest()

            # Insert the new user into the database
            insert_user_query = f"INSERT INTO FISHOLOGY.accounts (username, hashed_pw, salt_val) VALUES ('{username}', '{hashed_password}', '{salt}')"
            execute_query(conn, insert_user_query)

            return jsonify({"message": "Signup successful"}), 201  # Created status code
        else:
            # Login logic
            fetch_query = f"SELECT * FROM FISHOLOGY.accounts WHERE username = '{username}'"
            user_data = execute_query(conn, fetch_query)
            if not user_data:
                return jsonify({"error": "Invalid username or password"}), 401

            stored_password = user_data[0]["hashed_pw"]
            salt = user_data[0]["salt_val"]
            hashed_password = hashlib.sha256((password + salt).encode()).hexdigest()

            if hashed_password == stored_password:
                return jsonify({"message": "Login successful"}), 200
            else:
                return jsonify({"error": "Invalid username or password"}), 401

    except Exception as e:
        print("Error during signup/login:", e)  # Debug: Print error message
        return jsonify({"error": "An error occurred. Please try again later."}), 500



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
