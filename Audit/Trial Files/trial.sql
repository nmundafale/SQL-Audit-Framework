SELECT * FROM AuditTables
DECLARE @message xml
--RECEIVE
SELECT TOP(1) @message = CAST(message_body AS xml)
FROM Que_Rec_Audit

SELECT
product_id = Data.value('(product_id)[1]', 'VARCHAR(MAX)')
, I_product_id = Data.value('(I_product_id)[1]', 'VARCHAR(MAX)')
, I_class_id = Data.value('(I_class_id)[1]', 'VARCHAR(MAX)')
, I_subclass_id = Data.value('(I_subclass_id)[1]', 'VARCHAR(MAX)')
, I_active_flag = Data.value('(I_active_flag)[1]', 'VARCHAR(MAX)' )
, I_product_type_cd = Data.value('(I_product_type_cd)[1]', 'VARCHAR(MAX)')
, I_product_name = Data.value('(I_product_name)[1]', 'VARCHAR(MAX)')
, I_product_desc = Data.value('(I_product_desc)[1]', 'VARCHAR(MAX)')
, I_sku = Data.value('(I_sku)[1]', 'VARCHAR(MAX)')
, I_retail_price = Data.value('(I_retail_price)[1]', 'VARCHAR(MAX)')
, I_cost_price = Data.value('(I_cost_price)[1]', 'VARCHAR(MAX)')
, I_lastupdated = Data.value('(I_lastupdated)[1]', 'VARCHAR(MAX)')
, I_updatedby = Data.value('(I_updatedby)[1]', 'VARCHAR(MAX)')
, I_cid = Data.value('(I_cid)[1]', 'VARCHAR(MAX)')
, I_bucket_id = Data.value('(I_bucket_id)[1]', 'VARCHAR(MAX)')
, I_department_id = Data.value('(I_department_id)[1]', 'VARCHAR(MAX)')
, I_bof_code = Data.value('(I_bof_code)[1]', 'VARCHAR(MAX)')
, D_product_id = Data.value('(D_product_id)[1]', 'VARCHAR(MAX)')
, D_class_id = Data.value('(D_class_id)[1]', 'VARCHAR(MAX)')
, D_subclass_id = Data.value('(D_subclass_id)[1]', 'VARCHAR(MAX)')
, D_active_flag = Data.value('(D_active_flag)[1]', 'VARCHAR(MAX)')
, D_product_type_cd = Data.value('(D_product_type_cd)[1]', 'VARCHAR(MAX)')
, D_product_name = Data.value('(D_product_name)[1]', 'VARCHAR(MAX)')
, D_product_desc = Data.value('(D_product_desc)[1]', 'VARCHAR(MAX)')
, D_sku = Data.value('(D_sku)[1]', 'VARCHAR(MAX)')
, D_retail_price = Data.value('(D_retail_price)[1]', 'VARCHAR(MAX)')
, D_cost_price = Data.value('(D_cost_price)[1]', 'VARCHAR(MAX)')
, D_lastupdated = Data.value('(D_lastupdated)[1]', 'VARCHAR(MAX)')
, D_updatedby = Data.value('(D_updatedby)[1]', 'VARCHAR(MAX)')
, D_cid = Data.value('(D_cid)[1]', 'VARCHAR(MAX)')
, D_bucket_id = Data.value('(D_bucket_id)[1]', 'VARCHAR(MAX)')
, D_department_id = Data.value('(D_department_id)[1]' , 'VARCHAR(MAX)')
, D_bof_code = Data.value('(D_bof_code)[1]', 'VARCHAR(MAX)' )
INTO #product_maste_log
FROM    @message.nodes('/_1/row') AS Node(Data)

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_class_id, GETDATE()
FROM #product_maste_log
WHERE I_class_id != D_class_id

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_subclass_id, GETDATE()
FROM #product_maste_log
WHERE I_subclass_id != D_subclass_id

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_active_flag, GETDATE()
FROM #product_maste_log
WHERE I_active_flag != D_active_flag

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_product_type_cd, GETDATE()
FROM #product_maste_log
WHERE I_product_type_cd != D_product_type_cd

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_product_name, GETDATE()
FROM #product_maste_log
WHERE I_product_name != D_product_name

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_product_desc, GETDATE()
FROM #product_maste_log
WHERE I_product_desc != D_product_desc

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_sku, GETDATE()
FROM #product_maste_log
WHERE I_sku != D_sku

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_retail_price, GETDATE()
FROM #product_maste_log
WHERE I_retail_price != D_retail_price

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_cost_price, GETDATE()
FROM #product_maste_log
WHERE I_cost_price != D_cost_price

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_lastupdated, GETDATE()
FROM #product_maste_log
WHERE I_lastupdated != D_lastupdated

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_updatedby, GETDATE()
FROM #product_maste_log
WHERE I_updatedby != D_updatedby

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_cid, GETDATE()
FROM #product_maste_log
WHERE I_cid != D_cid

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_bucket_id, GETDATE()
FROM #product_maste_log
WHERE I_bucket_id != D_bucket_id

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_department_id, GETDATE()
FROM #product_maste_log
WHERE I_department_id != I_department_id

--INSERT INTO product_maste_log(PKID, ColumnID, Value, UpdatedDate)
SELECT product_id, 1, I_class_id, GETDATE()
FROM #product_maste_log
WHERE I_bof_code != D_bof_code


WITH CTE AS(
SELECT AT.TableID,At.UniqueRowIdentifier,kcu.COLUMN_NAME, ROW_NUMBER() OVER(PARTITION BY AT.TableID ORDER BY kcu.COLUMN_NAME) rnk
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
INNER JOIN AuditTables AT
ON AT.TableName = tc.TABLE_NAME AND at.SchemaName = tc.TABLE_SCHEMA
INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU
ON KCU.CONSTRAINT_NAME = tc.CONSTRAINT_NAME AND kcu.TABLE_NAME = tc.TABLE_NAME AND kcu.TABLE_SCHEMA = TC.TABLE_SCHEMA
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'

)
UPDATE CTE
SET UniqueRowIdentifier = COLUMN_NAME
WHERE rnk = 1