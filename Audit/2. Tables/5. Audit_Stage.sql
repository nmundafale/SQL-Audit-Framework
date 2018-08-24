CREATE TABLE Audit_Stage
(
	Stage_ID BIGINT IDENTITY(1,1)
	, TableID INT
	, UpdatedRows_xml XML
	, ProcessingStatus INT CONSTRAINT DF_Audit_Stage_ProcessingStatus_0 DEFAULT(0)
	, InsertedDate DATETIME
	, InesrtedUTCDate DATETIME
)
GO
 