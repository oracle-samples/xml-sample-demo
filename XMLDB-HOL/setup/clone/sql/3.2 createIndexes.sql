
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
 
--
--  Create an Unique Index on /PurchaseOrder/Reference
-- 
SELECT 'create unique index "REFERENCE_INDEX" on "' || i.TARGET_TABLE_NAME || '" ("' || i.TARGET_COLUMN_NAME || '");' REFERENCE_INDEX
  from XMLTable(
         '/Result/Mapping'
         passing DBMS_XMLSTORAGE_MANAGE.XPATH2TABCOLMAPPING(USER,'%TABLE_NAME%',NULL,'/PurchaseOrder/Reference','')
         COLUMNS
           TARGET_TABLE_NAME   VARCHAR2(30) path '@TableName',
           TARGET_COLUMN_NAME  VARCHAR2(30) path '@ColumnName'
        ) i
/
--
--  Create an Non-Unique Index on /PurchaseOrder/Requestor
-- 
SELECT 'create index "USER_INDEX" on "' || i.TARGET_TABLE_NAME || '" ("' || i.TARGET_COLUMN_NAME || '");' USER_INDEX
  from XMLTable(
          '/Result/Mapping'
           passing DBMS_XMLSTORAGE_MANAGE.XPATH2TABCOLMAPPING(USER,'%TABLE_NAME%',NULL,'/PurchaseOrder/User','')
           COLUMNS
           TARGET_TABLE_NAME   VARCHAR2(30) path '@TableName',
           TARGET_COLUMN_NAME  VARCHAR2(30) path '@ColumnName'
        ) i
/
--
--  Create an Non-Unique Composite Index on /PurchaseOrder/LineItems/LineItem/Part/text() and /PurchaseOrder/LineItems/LineItem/Quantity
-- 
SELECT 'create index "PART_NUMBER_QUANTITY_INDEX" on "' || i.TARGET_TABLE_NAME || '" ("' || i.TARGET_COLUMN_NAME || '","' || j.TARGET_COLUMN_NAME || '");' PART_NUMBER_QUANTITY_INDEX
  from XMLTable(
         '/Result/Mapping'
         passing DBMS_XMLSTORAGE_MANAGE.XPATH2TABCOLMAPPING(USER,'%TABLE_NAME%',NULL,'/PurchaseOrder/LineItems/LineItem/Part','')
         COLUMNS
         TARGET_TABLE_NAME   VARCHAR2(30) path '@TableName',
         TARGET_COLUMN_NAME  VARCHAR2(30) path '@ColumnName'
       ) i,
       XMLTable(
          '/Result/Mapping'
          passing DBMS_XMLSTORAGE_MANAGE.XPATH2TABCOLMAPPING(USER,'%TABLE_NAME%',NULL,'/PurchaseOrder/LineItems/LineItem/Quantity','')
          COLUMNS
          TARGET_TABLE_NAME   VARCHAR2(30) path '@TableName',
          TARGET_COLUMN_NAME  VARCHAR2(30) path '@ColumnName'
       ) j
/        
select 'call dbms_stats.gather_schema_stats(USER);' from dual
/