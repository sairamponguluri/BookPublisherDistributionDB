use BookPublisherDistributionDB;

--FULL DATABASE BACKUP
BACKUP DATABASE BookPublisherDistributionDB
TO DISK = 'C:\Users\Backup\BookPublisherDistributionDB_FullBackup.bak'
WITH FORMAT, INIT,
     SKIP, NOREWIND, NOUNLOAD,STATS = 10;

--DIFFERENTIAL BACKUP
BACKUP DATABASE BookPublisherDistributionDB
TO DISK = 'C:\Users\Backup\BookPublisherDistributionDB_DiffBackup.bak'
WITH DIFFERENTIAL, FORMAT, INIT,
     SKIP, NOREWIND, NOUNLOAD,STATS = 10;


--LOG BACKUP
BACKUP DATABASE BookPublisherDistributionDB
TO DISK = 'C:\Users\Backup\BookPublisherDistributionDB_LogBackup.trn'
WITH FORMAT, INIT,
     SKIP, NOREWIND, NOUNLOAD,STATS = 10;

