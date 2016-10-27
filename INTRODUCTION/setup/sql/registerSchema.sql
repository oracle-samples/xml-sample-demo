
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

set echo on
--
-- Register the XML Schema
--
declare
  V_XML_SCHEMA xmlType := xdburitype('%DEMOCOMMON%/xsd/2010/purchaseOrder.xsd').getXML();
begin
	
  -- DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_XML_SCHEMA);

  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'PurchaseOrderType','%ROOT_TYPE%');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'ShippingInstructionsType','SHIPPING_INSTRUCTIONS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'LineItemsType','LINEITEMS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'LineItemType','LINEITEM_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'ActionsType','ACTIONS_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'ActionsType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'Action','ACTION_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,'PartType','PART_T');
  
  DBMS_XMLSCHEMA.registerSchema
  (
    SCHEMAURL        => '%SCHEMAURL%', 
    SCHEMADOC        => V_XML_SCHEMA,
    LOCAL            => TRUE,
    GENBEAN          => FALSE,
    GENTYPES         => TRUE,
    GENTABLES        => FALSE,
    ENABLEHIERARCHY  => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE
  );
end;
/  
create table %TABLE1%
          of XMLType
             XMLTYPE STORE AS OBJECT RELATIONAL
             XMLSCHEMA "%SCHEMAURL%" Element "PurchaseOrder"
/
--
-- Rename the Nested Tables used to manage the collections of Action and LineItem elements
-- 
begin
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE1%',null,'/PurchaseOrder/Actions/Action','ACTION_TABLE',null);
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE1%',null,'/PurchaseOrder/LineItems/LineItem','LINEITEM_TABLE',null);
end;
/
--
-- Load the sample data
--
insert /*+ APPEND */ into %TABLE1%
select OBJECT_VALUE
  from %DATA_STAGING_TABLE%
/
commit
/
select count(*)
  from %TABLE1%
/
