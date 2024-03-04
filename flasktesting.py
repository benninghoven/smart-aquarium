from flask import Flask, render_template, request, redirect
from sql import get_db_and_cursor
#from flask_mysqldb import MySQL

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
            cur.execute("SELECT * FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1;") # takes all readings from last day
            query_result = cur.fetchall()
            print(query_result)
            #db.commit()
            cur.close()
        except Exception as e: 
            print(e)


        return redirect('/')###, tasks=query_result)
    else:
        query_result = []
        try:
            db, cur = get_db_and_cursor()
            cur.execute("SELECT * FROM SENSOR_READINGS WHERE TIMESTAMPDIFF(DAY, SENSOR_READINGS.TIMESTP, NOW()) < 1;") # takes all readings from last day
            query_result = cur.fetchall()
            print(query_result)
            #db.commit()
            cur.close()
        except Exception as e: 
            print(e)
        return render_template("results.html", tasks=query_result)
    

if __name__ == "__main__":
    app.run(debug=True)

