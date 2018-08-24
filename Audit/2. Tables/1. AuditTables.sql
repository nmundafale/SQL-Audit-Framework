CREATE TABLE AuditTables
(
	TableID INT IDENTITY(1,1)
	, TableName	NVARCHAR(256)
	, SchemaName NVARCHAR(256)
	, DBname NVARCHAR(256)
	, EnableAudit BIT
	, AutoTrackNewColumn BIT
	, isReadOptimised BIT
	, UniqueRowIdentifier NVARCHAR(256)
)
GO
INSERT INTO AuditTables (TableName, SchemaName, DBname, EnableAudit, AutoTrackNewColumn, isReadOptimised)
SELECT name, SCHEMA_NAME(SCHEMA_ID), DB_NAME(), 1, 1, 1 FROM sys.tables
GO
