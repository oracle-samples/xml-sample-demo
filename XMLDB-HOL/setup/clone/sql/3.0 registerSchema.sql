
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
 
declare
  cursor getTable
  is
  select TABLE_NAME
    from USER_XML_TABLES
   where TABLE_NAME in ( '%TABLE_NAME%');
begin
  for t in getTable() loop
    execute immediate 'DROP TABLE "' || t.TABLE_NAME || '" PURGE';
  end loop;
end;
/
declare
  V_XML_SCHEMA xmlType := xdburitype('%DEMOCOMMON%/xsd/purchaseOrder.xsd').getXML();
begin
  DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_XML_SCHEMA);
  DBMS_XMLSCHEMA_ANNOTATE.setDefaultTable(V_XML_SCHEMA,'PurchaseOrder','%TABLE_NAME%');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XML_SCHEMA,'PurchaseOrderType','%TABLE_NAME%_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XML_SCHEMA,'LineItemType','LINEITEM_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLCollType(V_XML_SCHEMA,'LineItem','LINEITEM_V');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'ActionsType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'Action','ACTION_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLCollType(V_XML_SCHEMA,'Action','ACTION_V');

  DBMS_XMLSCHEMA_ANNOTATE.setSqlType(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,'PurchaseOrderType',DBMS_XDB_CONSTANTS.XSD_ELEMENT,'CostCenter','VARCHAR2');
  
  DBMS_XMLSCHEMA.registerSchema(
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
create table %TABLE_NAME% 
             of XMLType
             XMLTYPE STORE as OBJECT RELATIONAL
             XMLSCHEMA "%SCHEMAURL%"
             Element "PurchaseOrder"
/       
desc %TABLE_NAME%
--
desc %TABLE_NAME%_T
--
select table_name
  from USER_NESTED_TABLES
 where PARENT_TABLE_NAME = '%TABLE_NAME%'
/
-- Rename the Nested Tables used to manage the collections of Action and LineItem elements
-- 
begin
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE_NAME%',null,'/PurchaseOrder/Actions/Action','ACTION_TABLE',null);
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE_NAME%',null,'/PurchaseOrder/LineItems/LineItem','LINEITEM_TABLE',null);
end;
/
select table_name
  from USER_NESTED_TABLES
 where PARENT_TABLE_NAME = '%TABLE_NAME%'
/