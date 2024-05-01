from flask import Flask, request, jsonify
import pyodbc
import jwt
from datetime import datetime, timedelta

app = Flask(__name__)

server = 'DESKTOP-77TM42R\SQLEXPRESS01'
database = 'koloexptracker'
username = 'DESKTOP-77TM42R\omofo'
password = '3080'
driver = '{ODBC Driver 17 for SQL Server}'
secret_key = 'nonofyourbusiness'

from flask import Flask, request, jsonify
import pyodbc
import bcrypt
import jwt
from datetime import datetime, timedelta

app = Flask(__name__)
app.config['SECRET_KEY'] = 'nonofyourbusiness'

server = 'DESKTOP-77TM42R\SQLEXPRESS01'
database = 'koloexptracker'
username = 'DESKTOP-77TM42R\omofo'
password = '3080'
driver = '{ODBC Driver 17 for SQL Server}'

def connect_to_database():
    try:
        conn = pyodbc.connect(f'DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password}')
        return conn
    except Exception as e:
        print(f"Error connecting to database: {str(e)}")
        return None

@app.route('/register', methods=['POST'])
def register_user():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("INSERT INTO Users (Username, Password, Email) VALUES (?, ?, ?)", (username, hashed_password, email))
            conn.commit()
            return jsonify({'message': 'User registered successfully'}), 201
        except Exception as e:
            return jsonify({'error': 'Failed to register user'}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/login', methods=['POST'])
def login_user():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT Password FROM Users WHERE Username = ?", (username,))
            result = cursor.fetchone()
            if result and bcrypt.checkpw(password.encode('utf-8'), result[0].encode('utf-8')):
                token = jwt.encode({'username': username, 'exp': datetime.utcnow() + timedelta(minutes=30)}, app.config['SECRET_KEY'], algorithm='HS256')
                return jsonify({'token': token.decode('utf-8')})
            else:
                return jsonify({'error': 'Invalid username or password'}), 401
        except Exception as e:
            return jsonify({'error': 'Failed to authenticate user'}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/expenses', methods=['POST'])
def create_expense():
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Authorization token is required'}), 401

    try:
        payload = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        username = payload['username']
    except jwt.ExpiredSignatureError:
        return jsonify({'error': 'Token has expired'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'error': 'Invalid token'}), 401

    data = request.json
    expense_name = data.get('name')
    amount = data.get('amount')
    category = data.get('category')

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("INSERT INTO Expenses (Username, Name, Amount, Category) VALUES (?, ?, ?, ?)", (username, expense_name, amount, category))
            conn.commit()
            return jsonify({'message': 'Expense created successfully'}), 201
        except Exception as e:
            return jsonify({'error': 'Failed to create expense'}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

# Add these endpoints below the existing code

@app.route('/expenses/<int:expense_id>', methods=['GET'])
def get_expense(expense_id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Authorization token is required'}), 401

    username = authenticate_user(token)
    if not username:
        return jsonify({'error': 'Invalid or expired token'}), 401

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM Expenses WHERE Username = ? AND ExpenseID = ?", (username, expense_id))
            expense = cursor.fetchone()
            if expense:
                return jsonify({'expense': expense})
            else:
                return jsonify({'error': 'Expense not found'}), 404
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/expenses/<int:expense_id>', methods=['PUT'])
def update_expense(expense_id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Authorization token is required'}), 401

    username = authenticate_user(token)
    if not username:
        return jsonify({'error': 'Invalid or expired token'}), 401

    data = request.json
    new_name = data.get('name')
    new_amount = data.get('amount')
    new_category = data.get('category')

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("UPDATE Expenses SET Name = ?, Amount = ?, Category = ? WHERE Username = ? AND ExpenseID = ?", (new_name, new_amount, new_category, username, expense_id))
            conn.commit()
            return jsonify({'message': 'Expense updated successfully'})
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

@app.route('/expenses/<int:expense_id>', methods=['DELETE'])
def delete_expense(expense_id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({'error': 'Authorization token is required'}), 401

    username = authenticate_user(token)
    if not username:
        return jsonify({'error': 'Invalid or expired token'}), 401

    conn = connect_to_database()
    if conn:
        try:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM Expenses WHERE Username = ? AND ExpenseID = ?", (username, expense_id))
            conn.commit()
            return jsonify({'message': 'Expense deleted successfully'})
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            cursor.close()
            conn.close()
    else:
        return jsonify({'error': 'Unable to connect to the database'}), 500

if __name__ == '__main__':
    app.run(debug=True)


#*In this update:
#We added endpoints for retrieving all expenses (`GET /expenses`), retrieving a single expense by ID (`GET /expenses/<expense_id>`), updating an expense (`PUT /expenses/<expense_id>`), and deleting an expense (`DELETE /expenses/<expense_id>`).
#Each of these endpoints requires authentication using a valid JWT token in the request headers. If the token is missing or invalid, the endpoints return an error response.
#The `authenticate_user` function validates the JWT token and extracts the username for further authorization checks.*/