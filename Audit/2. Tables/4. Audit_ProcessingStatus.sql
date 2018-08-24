CREATE TABLE Audit_ProcessingStatus
(
	ProcessingStatus INT
	, ProcessingStatusDescription NVARCHAR(256)
)
GO
INSERT INTO Audit_ProcessingStatus(ProcessingStatus,ProcessingStatusDescription)
VALUES(0,'Data Inserted/Not Processed'),
	  (1,'Processing started'),
	  (2, 'Processed/Completed')
GO
