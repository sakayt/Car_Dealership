from flask import Flask, render_template, request, redirect, url_for
import sqlite3

app = Flask(__name__)

# Function to connect to the SQLite database
def get_db_connection():
    conn = sqlite3.connect('Checkpoint3-dbase.sqlite3.db')  # Ensure the correct database file is used
    conn.row_factory = sqlite3.Row
    return conn

# Function to create tables if they do not exist
def create_database():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Create Customer table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Customer (
            CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT NOT NULL,
            Address TEXT NOT NULL,
            Phone TEXT NOT NULL,
            Email TEXT NOT NULL
        )
    ''')

    # Create Car table (example)
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS Car (
            CarID INTEGER PRIMARY KEY AUTOINCREMENT,
            Model TEXT NOT NULL,
            Year INTEGER NOT NULL,
            Price REAL NOT NULL,
            CustomerID INTEGER,
            FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        )
    ''')

    conn.commit()
    conn.close()

# Initialize the database
create_database()

@app.route('/')
def home():
    return render_template('website.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        address = request.form['address']
        phone = request.form['phone']
        email = request.form['email']

        conn = get_db_connection()
        conn.execute('INSERT INTO Customer (Name, Address, Phone, Email) VALUES (?, ?, ?, ?)',
                     (name, address, phone, email))
        conn.commit()
        conn.close()

        return redirect(url_for('home'))

    return render_template('website.html')

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    conn = get_db_connection()
    customers = conn.execute('SELECT * FROM Customer').fetchall()
    conn.close()

    if request.method == 'POST':
        customer_id = request.form['customer_id']
        conn = get_db_connection()
        conn.execute('DELETE FROM Customer WHERE CustomerID = ?', (customer_id,))
        conn.commit()
        conn.close()
        return redirect(url_for('admin'))

    return render_template('admin.html', customers=customers)

if __name__ == '__main__':
    app.run(debug=True)
