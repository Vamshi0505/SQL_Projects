-- Drop tables if they already exist (for clean setup)
DROP TABLE IF EXISTS InvoiceLine;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS PlaylistTrack;
DROP TABLE IF EXISTS Playlist;
DROP TABLE IF EXISTS Track;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Artist;

-- ARTIST TABLE
CREATE TABLE Artist (
    ArtistId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

-- ALBUM TABLE
CREATE TABLE Album (
    AlbumId INTEGER PRIMARY KEY,
    Title VARCHAR(160),
    ArtistId INTEGER,
    FOREIGN KEY (ArtistId) REFERENCES Artist (ArtistId)
);

-- MEDIATYPE TABLE
CREATE TABLE MediaType (
    MediaTypeId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

-- GENRE TABLE
CREATE TABLE Genre (
    GenreId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

-- TRACK TABLE
CREATE TABLE Track (
    TrackId INTEGER PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    AlbumId INTEGER,
    MediaTypeId INTEGER NOT NULL,
    GenreId INTEGER,
    Composer VARCHAR(220),
    Milliseconds INTEGER NOT NULL,
    Bytes INTEGER,
    UnitPrice NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (AlbumId) REFERENCES Album (AlbumId),
    FOREIGN KEY (MediaTypeId) REFERENCES MediaType (MediaTypeId),
    FOREIGN KEY (GenreId) REFERENCES Genre (GenreId)
);

-- PLAYLIST TABLE
CREATE TABLE Playlist (
    PlaylistId INTEGER PRIMARY KEY,
    Name VARCHAR(120)
);

-- PLAYLISTTRACK (Many-to-Many: Playlist <-> Track)
CREATE TABLE PlaylistTrack (
    PlaylistId INTEGER NOT NULL,
    TrackId INTEGER NOT NULL,
    PRIMARY KEY (PlaylistId, TrackId),
    FOREIGN KEY (PlaylistId) REFERENCES Playlist (PlaylistId),
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId)
);

-- EMPLOYEE TABLE
CREATE TABLE Employee (
    EmployeeId SERIAL PRIMARY KEY,
    LastName VARCHAR(20) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    Title VARCHAR(30),
    ReportsTo INTEGER,
    BirthDate TIMESTAMP,
    HireDate TIMESTAMP,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60),
    FOREIGN KEY (ReportsTo) REFERENCES Employee (EmployeeId)
);


-- CUSTOMER TABLE
CREATE TABLE Customer (
    CustomerId INTEGER PRIMARY KEY,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60) NOT NULL,
    SupportRepId INTEGER,
    FOREIGN KEY (SupportRepId) REFERENCES Employee (EmployeeId)
);

-- INVOICE TABLE
CREATE TABLE Invoice (
    InvoiceId INTEGER PRIMARY KEY,
    CustomerId INTEGER NOT NULL,
    InvoiceDate DATE NOT NULL,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (CustomerId) REFERENCES Customer (CustomerId)
);

-- INVOICELINE TABLE
CREATE TABLE InvoiceLine (
    InvoiceLineId INTEGER PRIMARY KEY,
    InvoiceId INTEGER NOT NULL,
    TrackId INTEGER NOT NULL,
    UnitPrice NUMERIC(10,2) NOT NULL,
    Quantity INTEGER NOT NULL,
    FOREIGN KEY (InvoiceId) REFERENCES Invoice (InvoiceId),
    FOREIGN KEY (TrackId) REFERENCES Track (TrackId)
);


select * from artist;
select * from album;
select * from genre;
select * from mediatype;
select * from playlist;
select * from playlisttrack;
select * from track;
select * from employee;
select * from customer;
select * from invoice;
select * from invoiceline;

INSERT INTO Employee (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email)
VALUES
(1, 'Adams', 'Andrew', 'General Manager', 9, '1962-02-18 00:00:00', '2016-08-14 00:00:00', '11120 Jasper Ave NW', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'andrew@chinookcorp.com'),
(2, 'Edwards', 'Nancy', 'Sales Manager', 1, '1958-12-08 00:00:00', '2016-05-01 00:00:00', '825 8 Ave SW', 'Calgary', 'AB', 'Canada', 'T2P 2T3', '+1 (403) 262-3443', '+1 (403) 262-3322', 'nancy@chinookcorp.com'),
(3, 'Peacock', 'Jane', 'Sales Support Agent', 2, '1973-08-29 00:00:00', '2017-04-01 00:00:00', '1111 6 Ave SW', 'Calgary', 'AB', 'Canada', 'T2P 5M5', '+1 (403) 262-3443', '+1 (403) 262-6712', 'jane@chinookcorp.com'),
(4, 'Park', 'Margaret', 'Sales Support Agent', 2, '1947-09-19 00:00:00', '2017-05-03 00:00:00', '683 10 Street SW', 'Calgary', 'AB', 'Canada', 'T2P 5G3', '+1 (403) 263-4423', '+1 (403) 263-4289', 'margaret@chinookcorp.com'),
(5, 'Johnson', 'Steve', 'Sales Support Agent', 2, '1965-03-03 00:00:00', '2017-10-17 00:00:00', '7727B 41 Ave', 'Calgary', 'AB', 'Canada', 'T3B 1Y7', '1 (780) 836-9987', '1 (780) 836-9543', 'steve@chinookcorp.com'),
(6, 'Mitchell', 'Michael', 'IT Manager', 1, '1973-07-01 00:00:00', '2016-10-17 00:00:00', '5827 Bowness Road NW', 'Calgary', 'AB', 'Canada', 'T3B 0C5', '+1 (403) 246-9887', '+1 (403) 246-9899', 'michael@chinookcorp.com'),
(7, 'King', 'Robert', 'IT Staff', 6, '1970-05-29 00:00:00', '2017-01-02 00:00:00', '590 Columbia Boulevard West', 'Lethbridge', 'AB', 'Canada', 'T1K 5N8', '+1 (403) 456-9986', '+1 (403) 456-8485', 'robert@chinookcorp.com'),
(8, 'Callahan', 'Laura', 'IT Staff', 6, '1968-01-09 00:00:00', '2017-03-04 00:00:00', '923 7 ST NW', 'Lethbridge', 'AB', 'Canada', 'T1H 1Y8', '+1 (403) 467-3351', '+1 (403) 467-8772', 'laura@chinookcorp.com'),
(9, 'Madan', 'Mohan', 'Senior General Manager', NULL, '1961-01-26 00:00:00', '2016-01-14 00:00:00', '1008 Vrinda Ave MT', 'Edmonton', 'AB', 'Canada', 'T5K 2N1', '+1 (780) 428-9482', '+1 (780) 428-3457', 'madan.mohan@chinookcorp.com');



ALTER TABLE Employee DROP COLUMN lEVEL;
ALTER TABLE Employee ADD COLUMN level VARCHAR(10);
DELETE FROM EMPLOYEE;
UPDATE Employee SET level = 'l6' WHERE EmployeeId = 1;
UPDATE Employee SET level = 'l4' WHERE EmployeeId = 2;
UPDATE Employee SET level = 'l1' WHERE EmployeeId = 3;
UPDATE Employee SET level = 'l1' WHERE EmployeeId = 4;
UPDATE Employee SET level = 'l1' WHERE EmployeeId = 5;
UPDATE Employee SET level = 'l3' WHERE EmployeeId = 6;
UPDATE Employee SET level = 'l2' WHERE EmployeeId = 7;
UPDATE Employee SET level = 'l2' WHERE EmployeeId = 8;
UPDATE Employee SET level = 'l7' WHERE EmployeeId = 9;










































































