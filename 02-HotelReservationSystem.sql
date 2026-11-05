CREATE DATABASE HotelReservationSystem;
GO
USE HotelReservationSystem;
GO

CREATE TABLE Hotels (
    HotelId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255),
    City NVARCHAR(50),
    StarRating INT,
    ContactNumber NVARCHAR(20),
    ManageId INT UNIQUE
);

CREATE TABLE Staff (
    StaffId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(50),
    Salary DECIMAL(10,2),
    HotelId INT,
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);

ALTER TABLE Hotels
ADD FOREIGN KEY (ManageId) REFERENCES Staff(StaffId);

CREATE TABLE Rooms (
    RoomNumber INT PRIMARY KEY,
    RoomType NVARCHAR(50),
    Capacity INT,
    DailyRate DECIMAL(10,2),
    Availability BIT DEFAULT 1,
    HotelId INT,
    FOREIGN KEY (HotelId) REFERENCES Hotels(HotelId)
);

CREATE TABLE Amenities (
    RoomNumber INT NOT NULL,
    Amenity NVARCHAR(100) NOT NULL,
    PRIMARY KEY (RoomNumber, Amenity),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);

CREATE TABLE Guests (
    GuestId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Nationality NVARCHAR(50),
    PassportNumber NVARCHAR(20),
    DateOfBirth DATE
);

CREATE TABLE Guest_Contact_Details (
    GuestId INT NOT NULL,
    Detail NVARCHAR(255) NOT NULL,
    PRIMARY KEY (GuestId, Detail),
    FOREIGN KEY (GuestId) REFERENCES Guests(GuestId)
);

CREATE TABLE Reservations (
    ReservationId INT IDENTITY(1,1) PRIMARY KEY,
    BookingDate DATETIME,
    CheckInDate DATE,
    CheckOutDate DATE,
    ReservationStatus NVARCHAR(50),
    TotalPrice DECIMAL(10,2),
    NumberOfAdults INT,
    NumberOfChildren INT
);

CREATE TABLE Reservations_Rooms (
    ReservationId INT NOT NULL,
    RoomNumber INT NOT NULL,
    PRIMARY KEY (ReservationId, RoomNumber),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (RoomNumber) REFERENCES Rooms(RoomNumber)
);

CREATE TABLE Reservations_Guest (
    ReservationId INT NOT NULL,
    GuestId INT NOT NULL,
    PRIMARY KEY (ReservationId, GuestId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (GuestId) REFERENCES Guests(GuestId)
);

CREATE TABLE Services (
    ServiceId INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100),
    Charge DECIMAL(10,2),
    RequestDate DATETIME,
    StaffId INT,
    FOREIGN KEY (StaffId) REFERENCES Staff(StaffId)
);

CREATE TABLE ReservationService (
    ServiceId INT NOT NULL,
    ReservationId INT NOT NULL,
    PRIMARY KEY (ServiceId, ReservationId),
    FOREIGN KEY (ServiceId) REFERENCES Services(ServiceId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId)
);

CREATE TABLE Payments (
    PaymentId INT IDENTITY(1,1) PRIMARY KEY,
    Method NVARCHAR(50),
    Date DATETIME,
    Amount DECIMAL(10,2),
    ConfirmationNumber NVARCHAR(100)
);

CREATE TABLE Reservations_Payment (
    ReservationId INT NOT NULL,
    PaymentId INT NOT NULL,
    PRIMARY KEY (ReservationId, PaymentId),
    FOREIGN KEY (ReservationId) REFERENCES Reservations(ReservationId),
    FOREIGN KEY (PaymentId) REFERENCES Payments(PaymentId)
);
GO

INSERT INTO Guests (FullName, Nationality, PassportNumber, DateOfBirth)
VALUES ('Omar Khaled', 'Egyptian', 'A12345678', '1990-05-15');

INSERT INTO Guests (FullName, Nationality, PassportNumber, DateOfBirth)
VALUES
('Sara Ahmed', 'Egyptian', 'B87654321', '1995-08-20'),
('John Smith', 'American', 'C11223344', '1988-12-03'),
('Layla Mahmoud', 'Egyptian', 'D44332211', '1992-03-10');

SELECT * FROM Guests;

UPDATE Rooms
SET DailyRate = DailyRate * 1.15
WHERE RoomType = 'Suite';

SELECT RoomNumber, RoomType, DailyRate FROM Rooms;

UPDATE Reservations
SET ReservationStatus = CASE
    WHEN CheckOutDate < GETDATE() THEN 'Completed'
    WHEN CheckInDate > GETDATE() THEN 'Upcoming'
    ELSE 'Active'
END;

SELECT ReservationId, CheckInDate, CheckOutDate, ReservationStatus FROM Reservations;
