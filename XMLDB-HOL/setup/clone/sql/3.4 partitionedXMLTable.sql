
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
 
create table %TABLE_NAME%_TEMP 
as 
select * 
  from %TABLE_NAME%
/
drop table %TABLE_NAME%
/
create table %TABLE_NAME% 
             of XMLType
             XMLTYPE STORE as OBJECT RELATIONAL
             XMLSCHEMA "%SCHEMAURL%"
             Element "PurchaseOrder"
             PARTITION BY LIST (XMLDATA."CostCenter") (
               PARTITION P01 VALUES ('A0','A10','A20','A30'),
               PARTITION P02 VALUES ('A40','A50','A60','A70'),
               PARTITION P03 VALUES ('A80','A90','A100','A110')
             )
             PARALLEL 4
/
--
-- Rename the Nested Tables used to manage the collections of Action and LineItem elements
-- 
begin
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE_NAME%',null,'/PurchaseOrder/Actions/Action/User','ACTION_TABLE',null);
  DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,'%TABLE_NAME%',null,'/PurchaseOrder/LineItems/LineItem/Part','LINEITEM_TABLE',null);
end;
/
insert into %TABLE_NAME%
select *
  from %TABLE_NAME%_TEMP
/
drop table %TABLE_NAME%_TEMP
/

create unique index "REFERENCE_INDEX" 
              on "%TABLE_NAME%" ("SYS_NC00008$") 
/              
create index "USER_INDEX" 
       on "%TABLE_NAME%" ("SYS_NC00019$") 
       Local
/
create index "PART_NUMBER_QUANTITY_INDEX" 
       on "LINEITEM_TABLE" ("SYS_NC00008$","Quantity") 
       Local
/
call DBMS_STATS.gather_schema_stats(USER)
/