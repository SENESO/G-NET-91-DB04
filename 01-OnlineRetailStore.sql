CREATE DATABASE OnlineRetailStore;
GO
USE OnlineRetailStore;
GO

CREATE TABLE Categories (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    MainCategory INT NULL,
    FOREIGN KEY (MainCategory) REFERENCES Categories(CategoryId)
);

CREATE TABLE Suppliers (
    SupplierId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Country NVARCHAR(50),
    Email NVARCHAR(100),
    Address NVARCHAR(255),
    ContactNumber NVARCHAR(20)
);

CREATE TABLE Customers (
    CustomerId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(100),
    ShippingAddress NVARCHAR(255),
    RegistrationDate DATE
);

CREATE TABLE Products (
    ProductId INT IDENTITY(1,1) PRIMARY KEY,
    StockQuantity INT DEFAULT 0,
    Name NVARCHAR(100) NOT NULL,
    AddedDate DATE,
    Description NVARCHAR(500),
    UnitPrice DECIMAL(10,2) NOT NULL,
    CategoryId INT NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
);

CREATE TABLE Products_Suppliers (
    SupplierId INT NOT NULL,
    ProductId INT NOT NULL,
    PRIMARY KEY (SupplierId, ProductId),
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(SupplierId),
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

CREATE TABLE StockTransactions (
    TranId INT IDENTITY(1,1) PRIMARY KEY,
    TranDate DATETIME,
    QuantityChange INT,
    Type NVARCHAR(50),
    Reference NVARCHAR(100),
    ProductId INT,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId)
);

CREATE TABLE Orders (
    OrderId INT IDENTITY(1,1) PRIMARY KEY,
    Status NVARCHAR(50),
    TotalAmount DECIMAL(10,2),
    OrderDate DATETIME,
    CustomerId INT,
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE OrderItems (
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    ProductId INT,
    OrderId INT,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);

CREATE TABLE Reviews (
    ReviewId INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT,
    Date DATETIME,
    Comment NVARCHAR(500),
    ProductId INT,
    CustomerId INT,
    FOREIGN KEY (ProductId) REFERENCES Products(ProductId),
    FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId)
);

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATETIME,
    Amount DECIMAL(10,2),
    Status NVARCHAR(50),
    Method NVARCHAR(50)
);

CREATE TABLE Orders_Payments (
    OrderId INT NOT NULL,
    PaymentId INT NOT NULL,
    PRIMARY KEY (OrderId, PaymentId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId)
);

CREATE TABLE Shipments (
    ShipmentId INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentDate DATETIME,
    Status NVARCHAR(50),
    DeliveryDate DATETIME,
    CarrierName NVARCHAR(100),
    TrackingNumber NVARCHAR(100),
    OrderId INT,
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
);
GO

INSERT INTO Customers (FullName, PhoneNumber, Email, ShippingAddress, RegistrationDate)
VALUES ('Ahmed Hassan', '01001234567', 'ahmed.hassan@mail.com', '15 Nasr City, Cairo', GETDATE());

SELECT * FROM Customers;

INSERT INTO Suppliers (Name, Country, Email, Address, ContactNumber)
VALUES
('TechSupply Co', 'Egypt', 'info@techsupply.com', 'Cairo', '0223456789'),
('Global Parts', 'UAE', 'sales@globalparts.ae', 'Dubai', '971501234567'),
('Nile Traders', 'Egypt', 'contact@niletraders.com', 'Alexandria', '034567890');

SELECT * FROM Suppliers;

INSERT INTO Categories (Name, Description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Men and women clothing');

SELECT * FROM Categories;

INSERT INTO Products (Name, UnitPrice)
VALUES ('Wireless Mouse', 25.50);

SELECT ProductId, Name, UnitPrice FROM Products;

CREATE TABLE ArchivedStock (
    TranId INT PRIMARY KEY,
    TranDate DATETIME,
    QuantityChange INT,
    Type NVARCHAR(50),
    Reference NVARCHAR(100),
    ProductId INT
);

INSERT INTO ArchivedStock
SELECT * FROM StockTransactions WHERE TranDate < '2023-01-01';

SELECT * FROM ArchivedStock;

UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE UnitPrice < 100;

SELECT ProductId, Name, UnitPrice FROM Products;

UPDATE Orders
SET Status = CASE WHEN TotalAmount > 5000 THEN 'Premium' ELSE 'Standard' END;

SELECT OrderId, TotalAmount, Status FROM Orders;
