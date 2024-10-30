--TRANSACTIONS

--A. transaction to transfer a book’s distribution quantity from one distributor to another

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
