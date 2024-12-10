from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)

# Function to connect to the SQLite database
def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

# Function to initialize database
def create_database():
    # Check if database already exists
    conn = get_db_connection()
    
    # Create the table with the exact specifications
    conn.executescript('''
        -- Drop existing tables if they exist to avoid conflicts
        DROP TABLE IF EXISTS CarCustomer;

        -- Create the combined CarCustomer table
        CREATE TABLE CarCustomer (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            -- Customer information
            Name TEXT NOT NULL,
            Address TEXT NOT NULL,
            Phone TEXT NOT NULL,
            Email TEXT NOT NULL,
            -- Car information
            Make TEXT NOT NULL,
            Model TEXT NOT NULL,
            Year INTEGER NOT NULL,
            LicensePlate TEXT NOT NULL
        );
    ''')
    
    print("Database created successfully!")
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
        make = request.form['make']
        model = request.form['model']
        year = request.form['year']
        license_plate = request.form['license_plate']

        try:
            conn = get_db_connection()
            conn.execute('''
                INSERT INTO CarCustomer 
                (Name, Address, Phone, Email, Make, Model, Year, LicensePlate) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                ''',
                (name, address, phone, email, make, model, year, license_plate))
            conn.commit()
            print("Data inserted successfully!")
        except sqlite3.Error as e:
            print(f"Database error: {e}")
        finally:
            conn.close()

        return redirect(url_for('home'))

    return render_template('website.html')

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    conn = get_db_connection()
    customers = conn.execute('SELECT * FROM CarCustomer').fetchall()
    conn.close()

    if request.method == 'POST':
        customer_id = request.form['customer_id']
        conn = get_db_connection()
        conn.execute('DELETE FROM CarCustomer WHERE ID = ?', (customer_id,))
        conn.commit()
        conn.close()
        return redirect(url_for('admin'))

    return render_template('website.html', customers=customers)

if __name__ == '__main__':
    app.run(debug=True)
