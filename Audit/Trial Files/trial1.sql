CREATE PROCEDURE sp_Trg_Receiver
AS
BEGIN
	DECLARE @message xml
	DECLARE @TableID INT

	SELECT TOP 1
		CAST(STUFF(CAST(message_body AS xml).value('local-name(/*[1])','varchar(100)'),1,1,'') AS INT) TableID
		, CAST(message_body AS xml) MessageBody
	INTO #TempMessage
	FROM Que_Rec_Audit

	SELECT @TableID = TableID FROM #TempMessage
	
	SELECT @TableID, @message

	
	DECLARE @Query NVARCHAR(MAX) = '
	DECLARE @message xml

	SELECT TOP 1 @message = MessageBody
	FROM #TempMessage
	'
	
	SELECT @Query = @Query + '
	INSERT INTO '+TableName+'_log(PKID, ColumnID, Value, UpdatedDate)
	SELECT Data.value(''('+UniqueRowIdentifier+')[1]'', ''VARCHAR(MAX)''), 1, Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)''), GETDATE()
	FROM @message.nodes(''/_1/row'') AS Node(Data)
	WHERE Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'') != Data.value(''(D_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'')
	'
	FROM AuditTables AT
	INNER JOIN AuditColumns AC
	ON AC.TableID = AT.TableID
	WHERE TableID = @TableID
		AND AC.ColumnName != AT.UniqueRowIdentifier

	EXEC(@SQL)


END
GO

