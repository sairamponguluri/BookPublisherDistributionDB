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


-- Functions

--a. function that returns the total quantity of a book distributed across all distributors
CREATE FUNCTION dbo.GetTotalQuantityDistributed(@BookID INT)
RETURNS INT
AS
BEGIN
    DECLARE @TotalQuantity INT;

    SELECT @TotalQuantity = SUM(Quantity)
    FROM BookDistribution
    WHERE BookID = @BookID;

    RETURN ISNULL(@TotalQuantity, 0);
END;
GO

--b. function to concatenate an authorâ€™s full name
CREATE FUNCTION dbo.GetAuthorFullName(@AuthorID INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @FullName VARCHAR(100);

    SELECT @FullName = FirstName + ' ' + LastName
    FROM Authors
    WHERE AuthorID = @AuthorID;

    RETURN @FullName;
END;
GO

--TRIGGERS

--A. trigger to prevent deletion of a book if there are associated records in BookDistribution
CREATE TRIGGER trg_PreventBookDeletion
ON Books
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM BookDistribution BD
        JOIN deleted d ON BD.BookID = d.BookID
    )
    BEGIN
        RAISERROR ('Cannot delete book. Book is distributed.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Books
        WHERE BookID IN (SELECT BookID FROM deleted);
    END
END;
GO


--B. trigger to update the total distribution quantity in BookDistribution whenever a record is inserted
CREATE TRIGGER trg_UpdateTotalQuantity
ON BookDistribution
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @BookID INT;

    SELECT @BookID = i.BookID FROM inserted i;

    UPDATE Books
    SET TotalDistributed = (SELECT SUM(Quantity) FROM BookDistribution WHERE BookID = @BookID)
    WHERE BookID = @BookID;
END;
GO
ALTER TABLE Books
ADD TotalDistributed INT DEFAULT 0;
GO


--TRANSACTIONS

--A. transaction to transfer a bookâ€™s distribution quantity from one distributor to another

CREATE PROCEDURE TransferBookQuantity
    @BookID INT,
    @FromDistributorID INT,
    @ToDistributorID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Reduce quantity from the original distributor
        UPDATE BookDistribution
        SET Quantity = Quantity - @Quantity
        WHERE BookID = @BookID AND DistributorID = @FromDistributorID;

        -- Add quantity to the target distributor
        IF EXISTS (SELECT 1 FROM BookDistribution WHERE BookID = @BookID AND DistributorID = @ToDistributorID)
        BEGIN
            UPDATE BookDistribution
            SET Quantity = Quantity + @Quantity
            WHERE BookID = @BookID AND DistributorID = @ToDistributorID;
        END
        ELSE
        BEGIN
            INSERT INTO BookDistribution (BookID, DistributorID, DistributionDate, Quantity)
            VALUES (@BookID, @ToDistributorID, GETDATE(), @Quantity);
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO
