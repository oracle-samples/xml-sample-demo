
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
  V_XMLSCHEMA XMLTYPE := xdburitype('/publishedContent/demonstrations/XMLDB/NVPairs/xsd/NVPairXMLSchema.xsd').getXML();

begin

  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'DataSetType','DATA_SET_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'DataItemType','DATA_ITEM_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLCollType(V_XMLSCHEMA,'DataItem','DATA_ITEM_V');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'stringType','STRING_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'dateType','DATE_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'dateTimeType','DATETIME_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'integerType','INTEGER_T');
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XMLSCHEMA,'floatType','FLOAT_T');

  -- DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_XMLSCHEMA);

  dbms_xmlschema.registerSchema(
     SCHEMAURL => 'http://xmlns.oracle.com/xdb/demonstration/xsd/nvPairStorage.xsd',
     SCHEMADOC  => V_XMLSCHEMA,
     LOCAL      => TRUE,
     GENTYPES   => TRUE,
     GENTABLES  => FALSE
  );
end;
/
create table DATA_SET_TABLE of XMLTYPE
XMLTYPE STORE AS OBJECT RELATIONAL
XMLSCHEMA "http://xmlns.oracle.com/xdb/demonstration/xsd/nvPairStorage.xsd" element "DataSet"
/
call DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'DATA_SET_TABLE',null,'/DataSet/DataItem','DATA_ITEM_TABLE')
/
desc DATA_SET_TABLE
--
insert into DATA_SET_TABLE
select OBJECT_VALUE
  from DEPARTMENT_NVPAIR x
/
insert into DATA_SET_TABLE
select OBJECT_VALUE
  from EMPLOYEE_NVPAIR x
/