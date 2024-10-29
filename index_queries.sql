Use BookPublisherDistributionDB;

-- An index is automatically created for primary keys, no need to re-index them.

--Adding indexes on foreign key columns can speed up joins and lookups

CREATE INDEX idx_Books_PublisherID On Books (PublisherID);

CREATE INDEX idx_BookDistribution_BookID ON BookDistribution (BookID);

CREATE INDEX idx_BookDistribution_DistributorID ON BookDistribution (DistributorID);

CREATE INDEX idx_BookAuthors_AuthorID ON BookAuthors (AuthorID);

CREATE INDEX idx_BookAuthors_BookID ON BookAuthors (BookID);

-- Index on Title in Books table, assuming frequent searches by title
CREATE INDEX idx_Books_Title ON Books (Title);

-- Index on Name in Publishers table, if you search by publisher name often
CREATE INDEX idx_Publishers_Name ON Publishers (Name);

-- Index on Name in Distributors table, if you search by distributor name often
CREATE INDEX idx_Distributors_Name ON Distributors (Name);

-- Composite index on BookID and DistributorID in Distribution table for combined lookups
CREATE INDEX idx_BookDistribution_BookID_DistributorID ON BookDistribution (BookID, DistributorID);

-- Composite index on FirstName and LastName in Authors table for full name searches
CREATE INDEX idx_Authors_FullName ON Authors (FirstName, LastName);

-- Unique index on Email in Authors table, assuming each email is unique
CREATE UNIQUE INDEX idx_Authors_Email ON Authors (Email);

CREATE UNIQUE INDEX idx_Authors_Email ON Authors (Email)
WHERE Email IS NOT NULL;

-- Full-text index on Bio in Authors for efficient text searching
CREATE FULLTEXT INDEX ON Authors(Bio) 
KEY INDEX PK_Authors_AuthorID;  -- Assumes PK_Authors_AuthorID is the primary key index

CREATE FULLTEXT CATALOG BookPublisherCatalog AS DEFAULT;

CREATE FULLTEXT INDEX ON Authors(Bio) 
KEY INDEX PK_Authors_AuthorID  -- Assumes PK_Authors_AuthorID is the primary key index
ON BookPublisherCatalog;       -- Use the newly created catalog

CREATE UNIQUE INDEX idx_Authors_AuthorID ON Authors (AuthorID);

CREATE FULLTEXT INDEX ON Authors(Biography)
KEY INDEX idx_Authors_AuthorID
ON BookPublisherCatalog;  -- The full-text catalog you created earlier


SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled') AS IsFullTextInstalled;










