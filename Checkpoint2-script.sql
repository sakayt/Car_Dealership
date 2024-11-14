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
VALUES (1, 'John Doe', '123 Elm St', '555-1234', 'johndoe@example.com', 1, 1),
       (2, 'Doe Bob', '410 Sakayt St', '332-7781', 'doebob@example.com', 2, 2 ),
       (3, 'Narrow Sum', '441 Arav St', '414-1409', 'narrowsum@example.com', 3, 3),
       (4, 'Jill Nom', '111 Billy Ave', '104-1239', 'jillnom@example.com', 4, 4),
       (5, 'Alice Brown', '235 Pine St', '555-8890', 'alicebrown@example.com', 5, 5),
       (6, 'Eve Harper', '789 Cherry Ln', '555-2045', 'eveharper@example.com', 6, 6),
       (7, 'Sam Green', '987 Oak Blvd', '555-6753', 'samgreen@example.com', 7, 7),
       (8, 'Mike Black', '123 Willow Rd', '555-1247', 'mikeblack@example.com', 8, 8),
       (9, 'Chris Blue', '456 Maple Ave', '555-4328', 'chrisblue@example.com', 9, 9),
       (10, 'Kyle Man', '414 Norrow Drive', '132-2134', 'kyleman@example.com', 10, 10);

-- Sample data for Car
INSERT INTO Car (CarID, Model, Price, Year, VIN, LicensePlate, CustomerID, DealerID)
VALUES  (1, 'Toyota Camry', 25000.00, 2020, 'JT12345ABCDE67890', 'ABC1234', 1, 1),
        (2, 'Honda Accord', 22000.00, 2021, '1HGCM82633A123456', 'XYZ5678', 2, 1),
        (3, 'Ford Focus', 18000.00, 2019, '1FAFP34PXXW123456', 'DEF1234', 3, 2),
        (4, 'Chevrolet Malibu', 24000.00, 2022, '1G1ZD5ST8LF123456', 'GHI5678', 4, 3),
        (5, 'Nissan Altima', 23000.00, 2021, '1N4AL3AP3DN123456', 'JKL9101', 5, 1),
        (6, 'Hyundai Sonata', 21000.00, 2020, 'KMHEC4A45GA123456', 'LMN1234', 6, 2),
        (7, 'Kia Optima', 19500.00, 2018, '5XXGM4A73EG123456', 'OPQ5678', 7, 3),
        (8, 'Volkswagen Passat', 26500.00, 2022, '1VWBP7A34CC123456', 'RST9012', 8, 1),
        (9, 'Mazda 6', 25000.00, 2021, 'JM1GL1V53M1234567', 'UVW3456', 9, 2),
        (10, 'Subaru Legacy', 23500.00, 2020, '4S3BNAA64J1234567', 'XYZ7890', 10, 3);

-- Sample data for Car_Dealer
INSERT INTO Car_Dealer (DealerID, Email, Phone, CommissionRate, Name, CarID)
VALUES  (1, 'dealer1@example.com', '555-5678', 5.50, 'Jill Nam', 1),
        (2, 'dealer2@example.com', '555-6789', 4.75, 'Kio Doll', 2),
        (3, 'dealer3@example.com', '555-7890', 6.00, 'Vill Jack', 3),
        (4, 'dealer4@example.com', '555-8901', 5.25, 'Jack Man', 4),
        (5, 'dealer5@example.com', '555-9012', 5.00, 'Poll Doll', 5),
        (6, 'dealer6@example.com', '555-0123', 4.50, 'Quinn Filt', 6),
        (7, 'dealer7@example.com', '555-1234', 5.75, 'Kilm Jon', 7),
        (8, 'dealer8@example.com', '555-2345', 4.85, 'Johnny Apple', 8),
        (9, 'dealer9@example.com', '555-3456', 5.40, 'Gothom June', 9),
        (10, 'dealer10@example.com', '555-4567', 6.20, 'Maple Story', 10);

-- Sample data for Manager
INSERT INTO Manager (ManagerID, Email, Name, Phone, DealershipID)
VALUES  (1, 'manager1@example.com', 'Alice Johnson', '555-4321', 1),
        (2, 'manager2@example.com', 'Bob Smith', '555-5432', 2),
        (3, 'manager3@example.com', 'Charlie Adams', '555-6543', 3),
        (4, 'manager4@example.com', 'Diane Brown', '555-7654', 4),
        (5, 'manager5@example.com', 'Eve Miller', '555-8765', 5),
        (6, 'manager6@example.com', 'Frank White', '555-9876', 6),
        (7, 'manager7@example.com', 'Grace Lewis', '555-0987', 7),
        (8, 'manager8@example.com', 'Hank Thompson', '555-1098', 8),
        (9, 'manager9@example.com', 'Ivy Scott', '555-2109', 9),
        (10, 'manager10@example.com', 'Jack Carter', '555-3210', 10);

-- Sample data for Dealership
INSERT INTO Dealership (DealershipID, NumofCars, Address, PaymentID, ManagerID)
VALUES  (1, 20, '456 Oak St', 1, 1),
        (2, 15, '789 Pine Ave', 2, 2),
        (3, 25, '123 Main St', 3, 3),
        (4, 10, '987 Elm Rd', 4, 4),
        (5, 30, '321 Maple Dr', 5, 5),
        (6, 18, '654 Birch Ln', 6, 6),
        (7, 22, '432 Cedar St', 7, 7),
        (8, 12, '876 Spruce Blvd', 8, 8),
        (9, 28, '555 Willow Way', 9, 9),
        (10, 16, '111 Aspen Ct', 10, 10);

-- Sample data for Payment
INSERT INTO Payment (PaymentID, PaymentMethod, Bank, DealershipID, CustomerID)
VALUES  (1, 'Credit Card', 'Bank of America', 1, 1),
        (2, 'Debit Card', 'Chase Bank', 2, 2),
        (3, 'Cash', 'Wells Fargo', 3, 3),
        (4, 'Bank Transfer', 'Citibank', 4, 4),
        (5, 'Credit Card', 'HSBC', 5, 5),
        (6, 'Debit Card', 'PNC Bank', 6, 6),
        (7, 'Cash', 'US Bank', 7, 7),
        (8, 'Credit Card', 'TD Bank', 8, 8),
        (9, 'Bank Transfer', 'Capital One', 9, 9),
        (10, 'Credit Card', 'Barclays', 10, 10);

-- Relationship data for Interacts_with and Hires
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (1, 1);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (2, 2);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (3, 3);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (4, 4);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (5, 5);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (6, 6);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (7, 7);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (8, 8);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (9, 9);
INSERT INTO Interacts_with (CustomerID, DealerID) VALUES (10, 10);

INSERT INTO Hires (DealerID, ManagerID) VALUES (1, 1);
INSERT INTO Hires (DealerID, ManagerID) VALUES (2, 2);
INSERT INTO Hires (DealerID, ManagerID) VALUES (3, 3);
INSERT INTO Hires (DealerID, ManagerID) VALUES (4, 4);
INSERT INTO Hires (DealerID, ManagerID) VALUES (5, 5);
INSERT INTO Hires (DealerID, ManagerID) VALUES (6, 6);
INSERT INTO Hires (DealerID, ManagerID) VALUES (7, 7);
INSERT INTO Hires (DealerID, ManagerID) VALUES (8, 8);
INSERT INTO Hires (DealerID, ManagerID) VALUES (9, 9);
INSERT INTO Hires (DealerID, ManagerID) VALUES (10, 10);

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
