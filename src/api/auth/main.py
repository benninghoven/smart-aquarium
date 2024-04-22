from pwinput import pwinput as pwin
import bcrypt
from sql_helpers import connect_to_mysql


def Login(username, password):
    username = username.strip(" ")
    password = password.strip(" ")
    password = password.encode("utf-8")

    try:
        # log in to an account
        conn = connect_to_mysql()
        cur = conn.cursor()
        cur.execute(f"SELECT hashed_pw FROM ACCOUNTS WHERE USERNAME = '{username}';")
        db_hashed_pw = cur.fetchall()[0][0]
        return bcrypt.checkpw(password, db_hashed_pw.encode('utf-8'))
    except Exception as e:
        # query fails
        print(e)
        return False


def Menu():
    print("1) Login")
    print("2) Create Account")
    print("3) List Accounts")
    print("9) Exit")

    choice = input()

    if choice.isdigit() and int(choice) in [1, 2, 3, 9]:
        return int(choice)
    else:
        print("Invalid input. Please a digit.")
        Menu()


def main():
    selectedScreen = Menu()

    if selectedScreen == 1:
        print("Login")
        if Login(input("Username: "), pwin("Password: ")):
            print("Logged in")
        else:
            print("Login failed")
    elif selectedScreen == 2:
        print("Create Account")
    elif selectedScreen == 3:
        print("List Accounts")
    elif selectedScreen == 9:
        print("Exit")
        exit()



if __name__ == "__main__":
    main()
