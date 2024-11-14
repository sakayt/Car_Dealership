-- Checkpoint2-script.sql

-- DROP TABLES if they already exist to avoid conflicts during testing
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Interacts_with;
DROP TABLE IF EXISTS Car_Dealer;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Hires;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Dealership;
DROP TABLE IF EXISTS Payment;

-- Table: Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    CarID INT,
    PaymentID INT,
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

-- Table: Interacts_with (Relationship table)
CREATE TABLE Interacts_with (
    CustomerID INT,
    DealerID INT,
    PRIMARY KEY (CustomerID, DealerID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (DealerID) REFERENCES Car_Dealer(DealerID)
);

-- Table: Car_Dealer
CREATE TABLE Car_Dealer (
    DealerID INT PRIMARY KEY,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    CommissionRate DECIMAL(5,2),
    Name VARCHAR(100),
    CarID INT,
    FOREIGN KEY (CarID) REFERENCES Car(CarID)
);

-- Table: Car
CREATE TABLE Car (
    CarID INT PRIMARY KEY,
    Model VARCHAR(50),
    Price DECIMAL(10,2),
    Year INT,
    VIN VARCHAR(17),
    LicensePlate VARCHAR(10),
    CustomerID INT,
    DealerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (DealerID) REFERENCES Car_Dealer(DealerID)
);

-- Table: Hires (Relationship table)
CREATE TABLE Hires (
    DealerID INT,
    ManagerID INT,
    PRIMARY KEY (DealerID, ManagerID),
    FOREIGN KEY (DealerID) REFERENCES Car_Dealer(DealerID),
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

-- Table: Manager
CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,
    Email VARCHAR(100),
    Name VARCHAR(100),
    Phone VARCHAR(15),
    DealershipID INT,
    FOREIGN KEY (DealershipID) REFERENCES Dealership(DealershipID)
);

-- Table: Dealership
CREATE TABLE Dealership (
    DealershipID INT PRIMARY KEY,
    NumofCars INT,
    Address VARCHAR(255),
    PaymentID INT,
    ManagerID INT,
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
    FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

-- Table: Payment
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    PaymentMethod VARCHAR(50),
    Bank VARCHAR(50),
    DealershipID INT,
    CustomerID INT,
    FOREIGN KEY (DealershipID) REFERENCES Dealership(DealershipID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Sample Data for Each Table
-- Sample data for Customer
INSERT INTO Customer (CustomerID, Name, Address, Phone, Email, CarID, PaymentID)
VALUES (1, 'John Doe', '123 Elm St', '555-1234', 'johndoe@example.com', 1, 1);

-- Sample data for Car
INSERT INTO Car (CarID, Model, Price, Year, VIN, LicensePlate, CustomerID, DealerID)
VALUES (1, 'Toyota Camry', 25000.00, 2020, 'JT12345ABCDE67890', 'ABC1234', 1, 1);

-- Sample data for Car_Dealer
INSERT INTO Car_Dealer (DealerID, Email, Phone, CommissionRate, Name, CarID)
VALUES (1, 'dealer1@example.com', '555-5678', 5.50, 'Best Deals Cars', 1);

-- Sample data for Manager
INSERT INTO Manager (ManagerID, Email, Name, Phone, DealershipID)
VALUES (1, 'manager1@example.com', 'Alice Johnson', '555-4321', 1);

-- Sample data for Dealership
INSERT INTO Dealership (DealershipID, NumofCars, Address, PaymentID, ManagerID)
VALUES (1, 20, '456 Oak St', 1, 1);

-- Sample data for Payment
INSERT INTO Payment (PaymentID, PaymentMethod, Bank, DealershipID, CustomerID)
VALUES (1, 'Credit Card', 'Bank of America', 1, 1);

-- Relationship data for Interacts_with and Hires
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (1, 1);
INSERT INTO Hires (DealerID, ManagerID) VALUES (1, 1);

-- 20 SQL Queries and Modification Statements

-- SELECT queries
SELECT Name, Address FROM Customer;
SELECT Model, Price FROM Car WHERE Year > 2018;
SELECT DealerID, CommissionRate FROM Car_Dealer WHERE Name LIKE '%Deals%';
SELECT Dealership.Address, COUNT(Car.CarID) AS TotalCars
FROM Dealership
JOIN Car ON Dealership.DealershipID = Car.DealerID
GROUP BY Dealership.Address;

-- INSERT statements
INSERT INTO Customer (CustomerID, Name, Address, Phone, Email, CarID, PaymentID)
VALUES (2, 'Jane Smith', '789 Maple Ave', '555-8765', 'janesmith@example.com', 2, 2);

INSERT INTO Car (CarID, Model, Price, Year, VIN, LicensePlate, CustomerID, DealerID)
VALUES (2, 'Honda Accord', 22000.00, 2021, '1HGCM82633A123456', 'XYZ5678', 2, 1);

-- UPDATE statements
UPDATE Car SET Price = 24000.00 WHERE VIN = 'JT12345ABCDE67890';
UPDATE Customer SET Address = '321 Cedar Ln' WHERE CustomerID = 1;

-- DELETE statements
DELETE FROM Dealership WHERE DealershipID = 1;
DELETE FROM Car WHERE CarID = 2;

-- Additional SELECT statements for reports and joins
SELECT Car.Model, Car.Price, Customer.Name
FROM Car
JOIN Customer ON Car.CustomerID = Customer.CustomerID;

SELECT Dealership.Address, Manager.Name AS ManagerName
FROM Dealership
JOIN Manager ON Dealership.ManagerID = Manager.ManagerID;

-- Complex SELECT with Join and Aggregation
SELECT Car_Dealer.Name, AVG(Car.Price) AS AverageCarPrice
FROM Car_Dealer
JOIN Car ON Car_Dealer.DealerID = Car.DealerID
GROUP BY Car_Dealer.Name;

-- Another INSERT for relationships
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (2, 1);

-- Additional UPDATE for relationship table
UPDATE Hires SET ManagerID = 2 WHERE DealerID = 1;

-- Final sample query to retrieve payment methods used by customers
SELECT Customer.Name, Payment.PaymentMethod
FROM Customer
JOIN Payment ON Customer.PaymentID = Payment.PaymentID;

-- Aggregated sales report by bank
SELECT Bank, COUNT(PaymentID) AS TotalPayments
FROM Payment
GROUP BY Bank;

-- JOIN query for Interacts_with table
SELECT 
    Customer.Name AS CustomerName,
    Customer.Email AS CustomerEmail,
    Car_Dealer.Name AS DealerName,
    Car_Dealer.Email AS DealerEmail
FROM 
    Interacts_with
JOIN 
    Customer ON Interacts_with.CustomerID = Customer.CustomerID
JOIN 
    Car_Dealer ON Interacts_with.DealerID = Car_Dealer.DealerID;

-- JOIN query for Hires table
SELECT 
    Car_Dealer.Name AS DealerName,
    Car_Dealer.Email AS DealerEmail,
    Manager.Name AS ManagerName,
    Manager.Email AS ManagerEmail
FROM 
    Hires
JOIN 
    Car_Dealer ON Hires.DealerID = Car_Dealer.DealerID
JOIN 
    Manager ON Hires.ManagerID = Manager.ManagerID;
