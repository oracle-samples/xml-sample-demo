
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
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
-- Revert to Global Token Tables (Pre 12.2 Behavoir)
--
var XFILES_SET_EVENT    varchar2(120)
var XFILES_CLEAR_EVENT  varchar2(120)
--
declare
  V_XFILES_SET_EVENT    varchar2(120);
  V_XFILES_CLEAR_EVENT  varchar2(120);
begin
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  V_XFILES_SET_EVENT   := 'XFILES_DO_NOTHING.sql';
  V_XFILES_CLEAR_EVENT := 'XFILES_DO_NOTHING.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_12_1 $THEN
  V_XFILES_SET_EVENT   := 'XFILES_DO_NOTHING.sql';
  V_XFILES_CLEAR_EVENT := 'XFILES_DO_NOTHING.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_12_2 $THEN
  V_XFILES_SET_EVENT   := 'XFILES_SET_EVENT.sql 19054 1';
  V_XFILES_CLEAR_EVENT := 'XFILES_CLEAR_EVENT.sql 19054';
$ELSE
  V_XFILES_SET_EVENT   := 'XFILES_DO_NOTHING.sql';
  V_XFILES_CLEAR_EVENT := 'XFILES_DO_NOTHING.sql';
$END
  :XFILES_SET_EVENT   := V_XFILES_SET_EVENT;
  :XFILES_CLEAR_EVENT := V_XFILES_CLEAR_EVENT;
end;
/
undef XFILES_SET_EVENT 
--
column XFILES_SET_EVENT new_value XFILES_SET_EVENT 
column XFILES_CLEAR_EVENT new_value XFILES_CLEAR_EVENT 
--
select :XFILES_SET_EVENT XFILES_SET_EVENT,
       :XFILES_CLEAR_EVENT XFILES_CLEAR_EVENT
  from dual
/
def XFILES_SET_EVENT
def XFILES_CLEAR_EVENT
--
--
-- ************************************************
-- *           Table Creation                   *
-- ************************************************
--
--
@@&XFILES_SET_EVENT
--
declare
  table_exists exception;
  PRAGMA EXCEPTION_INIT( table_exists , -00955 );

  V_CREATE_TABLE_DDL     VARCHAR2(4000) :=
'create table XFILES_LOG_TABLE of XMLType 
              XMLTYPE store as SECUREFILE binary xml';

begin
  execute immediate V_CREATE_TABLE_DDL;
exception
  when table_exists  then
    null;
end;
/
--
@@&XFILES_CLEAR_EVENT
--
--
-- ************************************************
-- *           Index Creation                   *
-- ************************************************
--
declare
  no_such_index exception;
  PRAGMA EXCEPTION_INIT( no_such_index , -01418 );
begin
--
  execute immediate 'drop index LOG_RECORD_INDEX';
exception
  when no_such_index  then
    null;
end;
/
var XFILES_LOG_TABLE_INDEX  varchar2(120)
--
declare
  V_XFILES_LOG_TABLE_INDEX  varchar2(120) := 'XFILES_LOG_TABLE_INDEX_11201.sql';
begin
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  V_XFILES_LOG_TABLE_INDEX := 'XFILES_LOG_TABLE_INDEX_11100.sql';
$END
 :XFILES_LOG_TABLE_INDEX := V_XFILES_LOG_TABLE_INDEX;
end;
/
undef XFILES_LOG_TABLE_INDEX 
--
column XFILES_LOG_TABLE_INDEX new_value XFILES_LOG_TABLE_INDEX 
--
select :XFILES_LOG_TABLE_INDEX XFILES_LOG_TABLE_INDEX
  from dual
/
def XFILES_LOG_TABLE_INDEX
--
@@&XFILES_LOG_TABLE_INDEX
-- 
-- Create the Parent Value Index on the PATH Table
--
CREATE INDEX LOG_RECORD_PARENT_INDEX
    ON LOG_RECORD_PATH_TABLE (RID, SYS_ORDERKEY_PARENT(ORDER_KEY))
/
--
-- Create Depth Index on the PATH Table
--
CREATE INDEX LOG_RECORD_DEPTH_INDEX
    ON LOG_RECORD_PATH_TABLE (RID, SYS_ORDERKEY_DEPTH(ORDER_KEY),ORDER_KEY)
/
@@XFILES_LOGGING_VIEWS
--
--
-- ************************************************
-- *           Trigger Creation                   *
-- *                                              *
-- *  Cannot use Trigger due to Manifest causing  *
-- *  Mutating Table error in create Resource...  *
-- *                                              *
-- ************************************************
--
/*
**
**
** create or replace trigger FOLDER_LOG_RECORDS
** after insert 
** on XFILES_LOG_TABLE
** for each row
** declare
**   logRecordName varchar2(256);
**   nextLogRecordId raw(16);
**   result boolean;
**   logFolderName varchar2(256) := '/home/XFILES/logRecords';
**   logRecordRef  ref XMLType;
**            
** begin
**   select NEXT_LOG_RECORD_ID into nextLogRecordId from NEXT_LOG_RECORD for update;
** 
**   select extractValue(:new.sys_nc_rowinfo$,'/XFilesLogRecord/User') 
**          || '-' ||
**          extractValue(:new.sys_nc_rowinfo$,'/XFilesLogRecord/Timestamps/Init') 
**          || '.xml'
**     into logRecordName
**     from dual;
**   
**   select ref(x) 
**     into logRecordRef 
**     from RECENT_LOG_VIEW x
**    where object_id = NextLogRecordId;
** 
**   -- Delete any existing Resource that references the selected Log Record
** 
**   delete from path_view
**    where under_path(res,1,logFolderName) = 1
**      and extractValue(res,'/Resource/XMLRef') = logRecordRef;
** 
**   update RECENT_LOG_RECORDS
**      set LOG_RECORD = MAKE_REF(XFILES_LOG_TABLE,:new.SYS_NC_OID$)
**    where OBJECT_ID = NextLogRecordId;
** 
**   result := dbms_xdb.createResource(logFolderName || '/' || logRecordName,logRecordRef); 
** 
** end;
** /
** show errors
** --
**
*/
