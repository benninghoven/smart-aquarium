import bcrypt, sys
from sql_helpers import connect_to_mysql

def login(username, password):
    username = username.strip(" ")
    password = password.strip(" ")
    password = password.encode("utf-8")
    
    try:
        # log in to an account
        cur = connect_to_mysql().cursor()
        cur.execute(f"SELECT hashed_pw FROM ACCOUNTS WHERE USERNAME = '{username}';")
        db_hashed_pw = cur.fetchall()[0][0]
        return bcrypt.checkpw(password, db_hashed_pw.encode('utf-8'))
    except Exception as e:
        # query fails
        print(e)
        return False


def create_account(username, password):
    username = username.strip(" ")
    password = password.strip(" ")
    password = bytes(password, "utf-8")

    # generate a salt
    salt = bcrypt.gensalt()
    hashed_pw = bcrypt.hashpw(password, salt)
    
    try:
        # add new account information to db
        print(username + hashed_pw.decode('utf-8') + salt.decode('utf-8'), sep="\t\t")
        cur = connect_to_mysql().cursor()
        #print(f"INSERT INTO ACCOUNTS VALUES ('{username}', '{hashed_pw.decode('utf-8')}', '{salt.decode('utf-8')}');")
        cur.execute(f"INSERT INTO ACCOUNTS VALUES ('{username}', '{hashed_pw.decode('utf-8')}', '{salt.decode('utf-8')}');")
        cur.close()
        
        print(f"Account for {username} created successfully")
        return True
    except Exception as e:
        # query may have failed, or username is a duplicate (more likely)
        return False

if __name__ == "__main__":
    login(sys.argv[1], sys.argv[2])