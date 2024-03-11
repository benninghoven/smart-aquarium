from flask import Flask, render_template, request, redirect
from sql import get_db_and_cursor
import validate_account

app = Flask(__name__)
'''mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'MySQLWorkbench'
app.config['MYSQL_DATABASE_DB'] = 'FISHOLOGY'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)'''
# when doing db things make sure to have in a try/escept statement

@app.route('/', methods=['POST', 'GET'])
def index():
    if request.method == "POST":
        post_content = request.form['content']
        print(post_content)
        query_result = []
        try:
            db, cur = get_db_and_cursor()
            cur.execute("SELECT * FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 8 LIMIT 20;") # takes all readings from last day
            query_result = cur.fetchall()
            #print(query_result)
            #db.commit()
            cur.close()
        except Exception as e: 
            print(e)


        return render_template("results.html", tasks=query_result)
    else:
        return render_template("results.html", tasks=[])
    

# account logins and creation

@app.route('/get_login', methods=['GET'])
def get_login():
    return render_template("login.html")


@app.route('/handle_login', methods=["POST", "GET"])
def handle_login():
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']

        login_success = validate_account.login(username, password)
        print(login_success)
        if login_success:
            return redirect('/')
        else:
            return render_template("login.html")
    else:
        return render_template("login.html")


@app.route('/get_account_creation_page', methods=["GET"])
def get_account_creation_page():
    return render_template("create_account.html")


@app.route('/handle_account_creation', methods=["POST"])
def handle_account_creation():
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']

        creation_success = validate_account.create_account(username, password)
        print(creation_success)
        if creation_success:
            return redirect('/handle_login')
        else:
            return render_template("create_account.html")



if __name__ == "__main__":
    app.run(debug=True)

