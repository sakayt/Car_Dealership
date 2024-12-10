from flask import Flask, render_template, request, redirect, url_for, jsonify
import sqlite3

app = Flask(__name__)

# Function to connect to the SQLite database
def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    return conn

# Function to initialize database
def create_database():
    conn = get_db_connection()
    conn.executescript('''
        DROP TABLE IF EXISTS CarCustomer;
        CREATE TABLE CarCustomer (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT NOT NULL,
            Address TEXT NOT NULL,
            Phone TEXT NOT NULL,
            Email TEXT NOT NULL,
            Make TEXT NOT NULL,
            Model TEXT NOT NULL,
            Year INTEGER NOT NULL,
            LicensePlate TEXT NOT NULL CHECK(length(LicensePlate) <= 7),
            SortOrder INTEGER NOT NULL
        );
    ''')
    print("Database created successfully!")
    conn.close()

# Initialize the database
create_database()

@app.route('/')
def home():
    # Fetch all records ordered by SortOrder
    conn = get_db_connection()
    records = conn.execute('SELECT * FROM CarCustomer ORDER BY SortOrder ASC').fetchall()
    conn.close()
    return render_template('website.html', records=records)

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

        # Insert with next SortOrder
        conn = get_db_connection()
        max_sort = conn.execute('SELECT IFNULL(MAX(SortOrder), 0) FROM CarCustomer').fetchone()[0]
        new_sort = max_sort + 1
        conn.execute('''
            INSERT INTO CarCustomer 
            (Name, Address, Phone, Email, Make, Model, Year, LicensePlate, SortOrder) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        (name, address, phone, email, make, model, year, license_plate, new_sort))
        conn.commit()
        conn.close()

        return redirect(url_for('home'))

    return render_template('website.html')

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        customer_id = request.form.get('customer_id')
        if customer_id:
            conn = get_db_connection()
            conn.execute('DELETE FROM CarCustomer WHERE ID = ?', (customer_id,))
            conn.commit()
            conn.close()
        return redirect(url_for('admin'))

    conn = get_db_connection()
    customers = conn.execute('SELECT * FROM CarCustomer ORDER BY SortOrder ASC').fetchall()
    conn.close()
    return render_template('website.html', records=customers)

@app.route('/update_order', methods=['POST'])
def update_order():
    new_order = request.json.get('order', [])
    conn = get_db_connection()
    for idx, record_id in enumerate(new_order, start=1):
        conn.execute('UPDATE CarCustomer SET SortOrder = ? WHERE ID = ?', (idx, record_id))
    conn.commit()
    conn.close()
    return jsonify({"status": "success"})

if __name__ == '__main__':
    app.run(debug=True)