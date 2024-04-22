from utils.sql_helpers import connect_to_mysql, execute_query, query_to_json
import sqlite3
import hashlib
import random
import string


class Account:
    def __init__(self, username, hashed_pw, salt_val, tank_id):
        self.username = username
        self.hashed_pw = None
        self.salt_val = None
        self.tank_id = None


class Authenticator:
    def __init__(self, db_file):
        self.conn = connect_to_mysql()
        self.cursor = self.conn.cursor()
        self.fubar()

    def fubar(self):
        print("fubar")

    def create_account(self, username, password):
        salt_val = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
        hashed_pw = hashlib.sha256((password + salt_val).encode()).hexdigest()
        try:
            self.cursor.execute('''
                INSERT INTO accounts (username, hashed_password, salt_val)
                VALUES (?, ?, ?)
            ''', (username, hashed_pw, salt_val))
            self.conn.commit()
            return True  # Account created successfully
        except sqlite3.IntegrityError:
            return False  # Username already exists

    def authenticate(self, username, password):
        self.cursor.execute('''
            SELECT hashed_password, salt_val FROM users WHERE username = ?
        ''', (username,))
        row = self.cursor.fetchone()
        if row is None:
            return False  # Username does not exist
        hashed_pw, salt_val = row
        hashed_input_pw = hashlib.sha256((password + salt_val).encode()).hexdigest()
        return hashed_input_pw == hashed_pw

# Example usage
authenticator = Authenticator('users.db')

# Create accounts
authenticator.create_account("user1", "password1")
authenticator.create_account("user2", "password2")

# Authenticate users
print(authenticator.authenticate("user1", "password1"))  # True
print(authenticator.authenticate("user1", "password2"))  # False
print(authenticator.authenticate("user3", "password3"))  # False (user3 does not exist)



acc1 = Account("admin", "hashed_pw", "salt_val", "tank_id")

print(acc1)
