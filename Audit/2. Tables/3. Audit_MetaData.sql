CREATE TABLE Audit_MetaData
(
	MetData_ID INT IDENTITY(1,1)
	, TableID INT
	, Metadata_Field NVARCHAR(MAX)
	, Metadata_Value NVARCHAR(MAX)
)
GO

DECLARE @i INT = ISNULL((SELECT MAX(TableID) FROM AuditTables),0)
WHILE EXISTS(SELECT TOP 1 1 FROM AuditTables WHERE TableID <= @i)
BEGIN

	DECLARE @RowCOUNT INT
	DECLARE @TableName NVARCHAR(MAX)
	DECLARE @SQL1 NVARCHAR(MAX)
	DECLARE @SQL2 NVARCHAR(MAX) = ''
	DECLARE @SQL3 NVARCHAR(MAX) = ''
	DECLARE @SQL4 NVARCHAR(MAX) = ''
	DECLARE @Query NVARCHAR(MAX) = '
	DECLARE @message xml

	SELECT TOP 1 @message = MessageBody
	FROM #TempMessage
	'
	
	SELECT @Query = @Query + '
	INSERT INTO '+AT.TableName+'_log(PKID, ColumnID, Value, UpdatedDate)
	SELECT Data.value(''('+AT.UniqueRowIdentifier+')[1]'', ''VARCHAR(MAX)''), 1, Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)''), GETDATE()
	FROM @message.nodes(''/_1/row'') AS Node(Data)
	WHERE Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'') != Data.value(''(D_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'')
	'
	, @SQL2 = @SQL2 + ', ' + AC.ColumnName
	, @SQL3 = @SQL3 + ', Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'') '
	, @SQL4 = @SQL4 + '
	OR Data.value(''(I_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'') != Data.value(''(D_'+AC.ColumnName+')[1]'', ''VARCHAR(MAX)'') '
	, @TableName = AT.TableName
	FROM AuditTables AT
	INNER JOIN AuditColumns AC
	ON AC.TableID = AT.TableID
	WHERE AT.TableID = @i
		AND AC.ColumnName != AT.UniqueRowIdentifier
	SET @RowCOUNT = @@ROWCOUNT

	SET @SQL1 = '
	DECLARE @message xml

	SELECT TOP 1 @message = MessageBody
	FROM #TempMessage
	INSERT INTO '+@TableName+'_log ('+RIGHT(@SQL2, LEN(@SQL2)-1)+')
	SELECT
	'+RIGHT(@SQL3, LEN(@SQL3)-1)+'
	FROM @message.nodes(''/_1/row'') AS Node(Data)
	WHERE
	'+RIGHT(@SQL4, LEN(@SQL4)-5)+'
	'

	
	IF @RowCOUNT > 0
	BEGIN
		INSERT INTO Audit_MetaData(TableID, Metadata_Field, Metadata_Value)
		SELECT @i,'SpaceOptimisedQuery',@Query
		
		INSERT INTO Audit_MetaData(TableID, Metadata_Field, Metadata_Value)
		SELECT @i,'ReadOptimisedQuery',@SQL1
	END

	SET @i = @i - 1
END

