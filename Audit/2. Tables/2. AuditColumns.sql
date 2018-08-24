CREATE TABLE AuditColumns	
(
	ColumnID INT IDENTITY(1,1)
	, ColumnName	NVARCHAR(256)
	, TableID INT
	, TrackChanges BIT CONSTRAINT DF_AuditColumns_TrackChanges_1 DEFAULT (1)
)
GO
INSERT INTO AuditColumns(ColumnName, TableID, TrackChanges)
SELECT name, TableID, 1 FROM sys.columns c INNER JOIN AuditTables AT ON AT.TableName = Object_name(c.object_id) AND AT.SchemaName = OBJECT_SCHEMA_NAME(c.object_id) ORDER BY c.OBJECT_ID 
GO
