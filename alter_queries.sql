USE BookPublisherDistributionDB;

--Adding a new column to the authors table, like adding email adress
Alter Table Authors
ADD Email Varchar(100);

--Modifying a columns data type (increase the contactnumber length in Distributors Table)
Alter table Distributors
Alter Column ContactNumber Varchar(20);

--Adding a default value of 0 for the Quantity column in Distribution Table
Alter Table Distribution 
ADD Constraint DF_Distribution_Quantity Default 0 For Quantity;

--Adding a NotNull constraint
Alter Table Books
Alter Column PublishedYear INT Not Null;

--Rename a Column
EXEC sp_rename 'Authors.Bio', 'Biography', 'COLUMN';

--Rename the distribution table to BookDistribution
EXEC sp_rename 'Distribution', 'BookDistribution';

--adding a new EditorID column in the Books table and want it to reference an Editors table
ALTER TABLE Books
ADD CONSTRAINT FK_Books_Editors FOREIGN KEY (EditorID) REFERENCES Editors(EditorID);

-- Drop a column
ALTER TABLE Publishers
DROP COLUMN Address;

--Adding a Unique constraint
ALTER TABLE Books
ADD CONSTRAINT UQ_Books_Title UNIQUE (Title);

-- remove the foreign key constraint on PublisherID in Books
ALTER TABLE Books
DROP CONSTRAINT FK_Books_Publishers;

--add a composite primary key based on BookID and DistributorID
ALTER TABLE BookDistribution
ADD CONSTRAINT PK_BookDistribution PRIMARY KEY (BookID, DistributorID);




