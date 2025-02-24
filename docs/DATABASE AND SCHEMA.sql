--DROP EXISTING 'Data_warehouse' databse
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'Data_warehouse')
BEGIN
  ALTER DATABASE Data_warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE Data_warehouse;
END;

USE MASTER;
GO

--CREATE THE DATABASE WAREHOUSE
CREATE DATABASE Data_warehouse;
GO

--Creating the 3 schemas

CREATE SCHEMA bronze;
Go

CREATE SCHEMA silver;
GO
CREATE SCHEMA Gold;

