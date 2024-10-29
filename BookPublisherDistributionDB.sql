CREATE DATABASE BookPublisherDistributionDB;
USE BookPublisherDistributionDB;


CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Bio TEXT
);

CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    PublisherID INT,
    PublishedYear INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID)
);

CREATE TABLE Distributors (
    DistributorID INT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(255),
    ContactNumber VARCHAR(15)
);

CREATE TABLE Distribution (
    DistributionID INT PRIMARY KEY,
    BookID INT,
    DistributorID INT,
    DistributionDate DATE,
    Quantity INT,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (DistributorID) REFERENCES Distributors(DistributorID)
);

CREATE TABLE BookAuthors (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);



-- Insert sample data into Authors
INSERT INTO Authors (AuthorID, FirstName, LastName, Bio)
VALUES
(1, 'John', 'Smith', 'An experienced author in modern fiction.'),
(2, 'Jane', 'Doe', 'A well-known children’s book writer.'),
(3, 'Mark', 'Twain', 'A celebrated American writer known for his novels.');

-- Insert sample data into Publishers
INSERT INTO Publishers (PublisherID, Name, Address)
VALUES
(1, 'HarperCollins', '195 Broadway, New York, NY 10007'),
(2, 'Penguin Random House', '1745 Broadway, New York, NY 10019'),
(3, 'Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020');

-- Insert sample data into Books
INSERT INTO Books (BookID, Title, PublisherID, PublishedYear, Price)
VALUES
(1, 'The Great Adventure', 1, 2020, 19.99),
(2, 'Mystery of the Old House', 2, 2019, 14.99),
(3, 'Life on the Mississippi', 3, 1883, 9.99);

-- Insert sample data into Distributors
INSERT INTO Distributors (DistributorID, Name, Address, ContactNumber)
VALUES
(1, 'Book Distributors Inc.', '500 Reading Rd, Boston, MA 02110', '555-123-4567'),
(2, 'Global Books LLC', '1000 Library Ln, Chicago, IL 60610', '555-987-6543'),
(3, 'National Book Supply', '750 Story St, Seattle, WA 98101', '555-765-4321');

-- Insert sample data into Distribution
INSERT INTO Distribution (DistributionID, BookID, DistributorID, DistributionDate, Quantity)
VALUES
(1, 1, 1, '2024-01-15', 500),
(2, 2, 2, '2024-02-10', 300),
(3, 3, 3, '2024-03-20', 150);

-- Insert sample data into BookAuthors
INSERT INTO BookAuthors (BookID, AuthorID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(2, 1); -- assuming 'John Smith' co-authored 'Mystery of the Old House' with 'Jane Doe'

