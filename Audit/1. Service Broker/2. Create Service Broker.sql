-- Create Message Type
CREATE MESSAGE TYPE Msg_Audit
VALIDATION = WELL_FORMED_XML
GO
-- Create Contract
CREATE CONTRACT Cnt_Audit
(Msg_Audit SENT BY INITIATOR)
GO
-- Create Send Queue
CREATE QUEUE Que_Ini_Audit
GO
-- Create Receive Queue
CREATE QUEUE Que_Rec_Audit
GO
-- Create Send Service on Send Queue
CREATE SERVICE Ser_Ini_Audit
ON QUEUE Que_Ini_Audit (Cnt_Audit)
GO
-- Create Receive Service on Recieve Queue
CREATE SERVICE Ser_Rec_Audit
ON QUEUE Que_Rec_Audit (Cnt_Audit)
GO