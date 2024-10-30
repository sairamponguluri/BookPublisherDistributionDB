--OPTIMIZE QUERY PERFORMANCE

--a. Use Execution Plans
   --Run a query with SET STATISTICS to analyze its performance
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Sample query for analysis
SELECT b.Title, a.FirstName, a.LastName
FROM Books b
JOIN BookAuthors ba ON b.BookID = ba.BookID
JOIN Authors a ON ba.AuthorID = a.AuthorID
WHERE b.PublishedYear > 2000;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

--b. Avoid SELECT *
--Using SELECT * increases resource usage. Specify required columns instead

-- Avoid this
SELECT * FROM Books WHERE BookID = 1;

-- Use this instead
SELECT Title, PublisherID, PublishedYear, Price FROM Books WHERE BookID = 1;

-- Optimize Stored Procedures with Parameter Sniffing

CREATE PROCEDURE GetBooksByPublisher
    @PublisherID INT
AS
BEGIN
    DECLARE @LocalPublisherID INT = @PublisherID;

    SELECT Title, PublishedYear, Price
    FROM Books
    WHERE PublisherID = @LocalPublisherID;
END;
GO


--Implement Indexed Views for Aggregation
/*If you frequently query aggregated data (e.g., total distribution quantity per book),
consider creating an indexed view*/

CREATE VIEW vw_TotalDistributed
WITH SCHEMABINDING
AS
SELECT BookID, SUM(Quantity) AS TotalQuantity
FROM BookDistribution
GROUP BY BookID;
GO

CREATE UNIQUE CLUSTERED INDEX idx_TotalDistributed ON vw_TotalDistributed(BookID);


--Query Optimization with IN and EXISTS
--Use EXISTS over IN when checking for existence in a subquery, as it performs better with larger datasets

-- Avoid using IN
SELECT Title FROM Books WHERE PublisherID IN (SELECT PublisherID FROM Publishers WHERE Name = 'Sample Publisher');

-- Use EXISTS instead
SELECT Title 
FROM Books 
WHERE EXISTS (SELECT 1 FROM Publishers WHERE Publishers.PublisherID = Books.PublisherID AND Name = 'Sample Publisher');


--Limit Transactions and Use Locking Hints
--Large transactions can cause locking. Minimize transaction scope and use locking hints if needed

BEGIN TRANSACTION;

UPDATE Books WITH (ROWLOCK)
SET Price = Price * 1.05
WHERE PublishedYear < 2000;

COMMIT;

-- Optimize TempDB Usage
--Monitor and manage TempDB, especially for complex queries that rely on temporary tables or sorting
-- Monitor TempDB contention
SELECT session_id, wait_type, wait_duration_ms, resource_description
FROM sys.dm_exec_requests
WHERE database_id = 2; -- TempDB is usually DB_ID 2

-- If contention is high, consider splitting TempDB files




SELECT
    session_id,
    wait_type,
    blocking_session_id,
    wait_time AS wait_duration,
    command,
    status
FROM sys.dm_exec_requests
WHERE database_id = 2; -- TempDB is usually DB_ID 2


