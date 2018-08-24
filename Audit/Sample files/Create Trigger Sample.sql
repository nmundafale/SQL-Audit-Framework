IF EXISTS(SELECT TOp 1 1 FROM sys.triggers WHERE name = 'Audit_product_master')
DROP TRIGGER Audit_product_master
GO
CREATE TRIGGER Audit_product_master ON product_master
FOR UPDATE, DELETE, INSERT
AS
BEGIN
	DECLARE @SBDialog uniqueidentifier
	DECLARE @Message XML
	--INSERT INTO Audit_Stage(TableID,InsertedDate,InesrtedUTCDate,UpdatedRows_xml)
	--SELECT 1 Table_ID, GETDATE(), GETUTCDATE(), (SELECT ISNULL(I.product_id,D.product_id) product_id

	BEGIN DIALOG CONVERSATION @SBDialog
	FROM SERVICE Ser_Ini_Audit
	TO SERVICE 'Ser_Rec_Audit'
	ON CONTRACT Cnt_Audit
	WITH ENCRYPTION = OFF


	SET @Message = 
	(SELECT ISNULL(I.product_id,D.product_id) product_id
		,I.product_id I_product_id
		,I.class_id I_class_id
		,I.subclass_id I_subclass_id
		,I.active_flag I_active_flag
		,I.product_type_cd I_product_type_cd
		,I.product_name I_product_name
		,I.product_desc I_product_desc
		,I.sku I_sku
		,I.retail_price I_retail_price
		,I.cost_price I_cost_price
		,I.lastupdated I_lastupdated
		,I.updatedby I_updatedby
		,I.cid I_cid
		,I.bucket_id I_bucket_id
		,I.commission_rate I_commission_rate
		,I.point_rate I_point_rate
		,I.brand_id I_brand_id
		,I.department_id I_department_id
		,I.bof_code I_bof_code
		,D.product_id D_product_id
		,D.class_id D_class_id
		,D.subclass_id D_subclass_id
		,D.active_flag D_active_flag
		,D.product_type_cd D_product_type_cd
		,D.product_name D_product_name
		,D.product_desc D_product_desc
		,D.sku D_sku
		,D.retail_price D_retail_price
		,D.cost_price D_cost_price
		,D.lastupdated D_lastupdated
		,D.updatedby D_updatedby
		,D.cid D_cid
		,D.bucket_id D_bucket_id
		,D.commission_rate D_commission_rate
		,D.point_rate D_point_rate
		,D.brand_id D_brand_id
		,D.department_id D_department_id
		,D.bof_code D_bof_code
	FROM Inserted I
	FULL JOIN DELETED D
	ON I.product_id = D.product_id
	FOR XML PATH, TYPE, ROOT('_1'));

	SEND ON CONVERSATION @SBDialog
	MESSAGE TYPE Msg_Audit (@Message)

	SELECT @Message
END
GO