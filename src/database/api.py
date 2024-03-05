from flask import Flask, jsonify
from sql import get_db_and_cursor

app = Flask(__name__)

@app.route("/user/<username>", methods=["POST"])
def hello_world(username):
    return "<p>Hello, World!</p>"

@app.route("/<username>/24")
def get_last_24hr(username):
    db, cursor = get_db_and_cursor()
    cursor.execute(f"""SELECT * FROM SENSOR_READINGS
WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1 AND username = {username};""")
    #data is type list
    data = cursor.fetchall()
    
    db.close()
    return jsonify(data)