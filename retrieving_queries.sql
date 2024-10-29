Use BookPublisherDistributionDB;

select * from Authors;               --Retrieve All Authors

select * from Publishers;            --Retrieve All Publishers

select * from Books;                 --Retrieve All Books

select * from Distributors;          --Retrieve All Distributors

Select * from Distribution;          --Retrieve All Distribution Records

select * from BookAuthors;           --Retrieve All Book-Author Relationships

--Retrieve Books by a specific Publisher
select * from Books Where PublisherID = 1;  

--Retrieve Distributors by City
select * from Distributors Where Address Like '%Boston%';

--Retrieve Books Published in a Specific Year
select * from Books Where PublishedYear = 2020;

--Retrieve Authors by Last Name
select * from Authors Where LastName = 'Smith';

--Count the Total Number of Books by Publisher
select PublisherID, Count(*) As TotalBooks
From Books
Group By PublisherID;

-- Retrieve Authors Who Have Written More Than One Book
select AuthorID, Count(*) AS NumberOfBooks
From BookAuthors
Group By AuthorID
Having Count(*) > 1;

--Find the most Expensive Book
select * from Books
Where Price = (select Max(price) From Books);

--Retrieve Distribution Records For a Specific Book
Select * from Distribution
Where BookID = 1;

--Retrieve Distinct Publisher Addresses
Select Distinct Address
From Publishers;

--Retrieve Books Published After A Specific Year
Select * From Books
Where PublishedYear > 2018;

--Find Distributors Who Have Distributed more than A Specific Quantity of Books
SELECT DistributorID, SUM(Quantity) AS TotalDistributed
FROM Distribution
GROUP BY DistributorID
HAVING SUM(Quantity) > 300;

--Retrieve the Average Price of Books by Publisher
SELECT PublisherID, AVG(Price) AS AveragePrice
FROM Books
GROUP BY PublisherID;

--Retrieve Books that Have Not Been Distributed
SELECT *
FROM Books
WHERE BookID NOT IN (SELECT DISTINCT BookID FROM Distribution);

--Find the Publisher with the Most Books
SELECT PublisherID, COUNT(*) AS NumberOfBooks
FROM Books
GROUP BY PublisherID
ORDER BY NumberOfBooks DESC;


