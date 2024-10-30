USE BookPublisherDistributionDB;
GO
--STORED PROCEDURES

--a.Insert a new book into the Books table, Checking if the publisher exists
CREATE PROCEDURE AddingNewBook
    @Title VARCHAR(255),
    @PublisherID INT,
    @PublishedYear INT,
    @Price DECIMAL(10, 2)
AS
BEGIN
    -- Check if Publisher exists
    IF EXISTS (SELECT 1 FROM Publishers WHERE PublisherID = @PublisherID)
    BEGIN
        INSERT INTO Books (Title, PublisherID, PublishedYear, Price)
        VALUES (@Title, @PublisherID, @PublishedYear, @Price);
    END
    ELSE
    BEGIN
        RAISERROR ('PublisherID does not exist.', 16, 1);
    END
END;



--b.update Book Price by book id
CREATE PROCEDURE UpdateBookPrice
    @BookID INT,
    @NewPrice DECIMAL(10, 2)
AS
BEGIN
    UPDATE Books
    SET Price = @NewPrice
    WHERE BookID = @BookID;
END;
GO


--c. The procedure deletes a book and associated records from BookAuthors and BookDistribution
CREATE PROCEDURE DeleteBook
    @BookID INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        DELETE FROM BookAuthors WHERE BookID = @BookID;
        DELETE FROM BookDistribution WHERE BookID = @BookID;
        DELETE FROM Books WHERE BookID = @BookID;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO


