USE AdventureWorksLT2022;

CREATE LOGIN nk WITH PASSWORD = 'Ab123cd456usd';

CREATE USER nk FOR LOGIN nk;

EXEC sp_addrolemember 'db_datareader', 'nk';

--------------ADF pipeline query

select * from sys.tables;
select * from sys.schemas;

select s.name as SchemaName, t.name as TableName
from sys.tables t
JOIN sys.schemas s
on t.schema_id = s.schema_id
where s.name = 'SalesLT'

-- Grant CREATE TABLE, INSERT, and UPDATE permissions to a user or role
GRANT CREATE TABLE TO nk;
GRANT INSERT, UPDATE ON SCHEMA::SalesLT TO nk;


