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

--b. function to concatenate an author’s full name
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

