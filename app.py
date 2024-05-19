from flask import Flask, request, jsonify, render_template, redirect, url_for
import pyodbc
import hashlib
import re

app = Flask(__name__)

# Database configuration
server = 'DESKTOP-77TM42R\SQLEXPRESS01'
database = 'koloexptracker'
driver = '{ODBC Driver 17 for SQL Server}'

def connect_to_database():
    try:
        conn = pyodbc.connect(
            f'DRIVER={driver};SERVER={server};DATABASE={database};Trusted_Connection=yes;')
        return conn
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        return None

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Validate email format
def validate_email(email):
    return re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email)

# Validate password complexity
def validate_password(password):
    return len(password) >= 8

@app.route('/')
def home():
    return redirect(url_for('login_form'))

@app.route('/login', methods=['POST'])
def login():
    data = request.form
    if not data or not all(key in data for key in ['username', 'password']):
        return jsonify({'error': 'Missing required fields'}), 400

    username = data['username']
    password = data['password']
    hashed_password = hash_password(password)

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT * FROM Users WHERE Username = ? AND Password = ?",
                (username, hashed_password)
            )
            user = cursor.fetchone()
            if user:
                return jsonify({'message': 'Login successful'}), 200
            else:
                return jsonify({'error': 'Invalid username or password'}), 401
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/login.html')
def login_form():
    return render_template('login.html')

# User Dashboard endpoint
@app.route('/user')
def dashboard():
    return 'Welcome to your user dashboard!'

@app.route('/signup', methods=['POST'])
def signup():
    data = request.form
    if not data or not all(key in data for key in ['username', 'email', 'password']):
        return jsonify({'error': 'Missing required fields'}), 400

    username = data['username']
    email = data['email']
    password = data['password']

    if not validate_email(email):
        return jsonify({'error': 'Invalid email format'}), 400

    if not validate_password(password):
        return jsonify({'error': 'Password must be at least 8 characters long'}), 400

    hashed_password = hash_password(password)

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute(
                "INSERT INTO Users (Username, Password, Email) VALUES (?, ?, ?)",
                (username, hashed_password, email)
            )
            conn.commit()
            return jsonify({'message': 'User signed up successfully'}), 201
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/signup.html')
def signup_form():
    return render_template('signup.html')

# User Dashboard endpoint
@app.route('/user')
def dashboard():
    return 'Welcome to your user dashboard!'

if __name__ == '__main__':
    app.run(debug=True)
