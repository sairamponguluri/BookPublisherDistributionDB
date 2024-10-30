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


