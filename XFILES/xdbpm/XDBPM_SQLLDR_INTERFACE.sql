
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
-- RESOURCE LOADER is created XDBPM
--
alter session set current_schema = XDBPM
/
create table SQLLDR_REPOSITORY_TABLE (
  RESULT NUMBER
)
/
create or replace view SQLLDR_REPOSITORY_INTERFACE
as 
SELECT RESULT                         "RESULT",
       CAST(NULL AS VARCHAR2(256))    "RESOURCE_COMMENT",
       CAST(NULL AS VARCHAR2(256))    "TARGET_FOLDER",
       CAST(NULL AS VARCHAR2(001))    "CREATE_FOLDER",
       CAST(NULL AS VARCHAR2(128))    "DISPLAY_NAME",
       CAST(NULL AS VARCHAR2(010))    "DUPLICATE_POLICY",       
       TO_BLOB(NULL)                  "CONTENT"
  from SQLLDR_REPOSITORY_TABLE
/
desc SQLLDR_REPOSITORY_INTERFACE
--
create or replace trigger SQLLDR_REPOSITORY_TRIGGER
instead of INSERT on SQLLDR_REPOSITORY_INTERFACE
begin
	null;
end;
/
grant INSERT 
   on SQLLDR_REPOSITORY_INTERFACE
   to PUBLIC
/
create or replace view SQLLDR_STAGING_VIEW
as 
SELECT RESULT                          "RESULT",
       CAST(NULL AS VARCHAR2(0001))    "CREATE_FOLDER",
       CAST(NULL AS VARCHAR2(0010))    "DUPLICATE_POLICY",       
       CAST(NULL AS VARCHAR2(1024))    "RESOURCE_PATH",
       TO_BLOB(NULL)                   "CONTENT"
  from SQLLDR_REPOSITORY_TABLE
/
create or replace trigger SQLLR_STAGING_TRIGGER
instead of INSERT on SQLLDR_STAGING_VIEW
begin
	null;
end;
/
grant all 
   on SQLLDR_STAGING_VIEW 
   to PUBLIC
/
create or replace package XDBPM_SQLLDR_INTERFACE
authid CURRENT_USER
as
  function UPLOAD_RESOURCE(P_RESOURCE_PATH VARCHAR2, P_CREATE_FOLDER VARCHAR2, P_CONTENT BLOB, P_DUPLICATE_POLICY VARCHAR2) return NUMBER;
  function UPLOAD_CONTENT(P_TARGET_FOLDER VARCHAR2, P_CREATE_FOLDER VARCHAR2, P_DISPLAY_NAME VARCHAR2, P_CONTENT BLOB, P_DUPLICATE_POLICY VARCHAR2, P_COMMENT VARCHAR2) return NUMBER;
end;
/
show errors
--
grant execute on XDBPM_SQLLDR_INTERFACE to public
/
create or replace package body XDBPM_SQLLDR_INTERFACE
as
--
function UPLOAD_RESOURCE(P_RESOURCE_PATH VARCHAR2, P_CREATE_FOLDER VARCHAR2, P_CONTENT BLOB, P_DUPLICATE_POLICY VARCHAR2)
return NUMBER
as
  V_TARGET_FOLDER VARCHAR2(700);
begin
	V_TARGET_FOLDER := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1);
 	
  if (P_CREATE_FOLDER = 'Y')  then
    XDB_UTILITIES.mkdir(V_TARGET_FOLDER,TRUE);
  end if;
 
  XDB_UTILITIES.UPLOADRESOURCE(P_RESOURCE_PATH => P_RESOURCE_PATH, P_CONTENT => P_CONTENT, P_DUPLICATE_POLICY => P_DUPLICATE_POLICY);

  return 1;
end;
--
function UPLOAD_CONTENT(P_TARGET_FOLDER VARCHAR2, P_CREATE_FOLDER VARCHAR2, P_DISPLAY_NAME VARCHAR2, P_CONTENT BLOB, P_DUPLICATE_POLICY VARCHAR2, P_COMMENT VARCHAR2)
return NUMBER
as
  V_RESOURCE_PATH VARCHAR2(700) := P_TARGET_FOLDER || '/' || P_DISPLAY_NAME;
  V_RESID         RAW(16);
  V_DO_CHECKIN    BOOLEAN := FALSE;
  V_RESOURCE      DBMS_XDBRESOURCE.XDBRESOURCE;
begin
 	
$IF $$DEBUG $THEN
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPLOAD_CONTENT(): P_TARGET_FOLDER = "' || P_TARGET_FOLDER || '".',TRUE);
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPLOAD_CONTENT(): P_CREATE_FOLDER = "' || P_CREATE_FOLDER || '".',TRUE);
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPLOAD_CONTENT(): P_DISPLAY_NAME = "' || P_DISPLAY_NAME || '".',TRUE);
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPLOAD_CONTENT(): P_DUPLICATE_POLICY = "' || P_DUPLICATE_POLICY || '".',TRUE);
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPLOAD_CONTENT(): P_COMMENT = "' || P_COMMENT || '".',TRUE);
$END

  if (P_CREATE_FOLDER = 'Y' and NOT(DBMS_XDB.existsResource(P_TARGET_FOLDER)))  then
    XDB_UTILITIES.mkdir(P_TARGET_FOLDER,TRUE);
  end if;
 
  XDB_UTILITIES.UPLOADRESOURCE(P_RESOURCE_PATH => V_RESOURCE_PATH, P_CONTENT => P_CONTENT, P_DUPLICATE_POLICY => P_DUPLICATE_POLICY);
  
  if (XDB_UTILITIES.is_Versioned(V_RESOURCE_PATH)) then
    if not(DBMS_XDB_VERSION.isCheckedOut(V_RESOURCE_PATH)) then
      DBMS_XDB_VERSION.checkOut(V_RESOURCE_PATH);
      V_DO_CHECKIN := TRUE;
    end if;
  end if;
  
  V_RESOURCE := DBMS_XDB.getResource(V_RESOURCE_PATH);
  DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);
  DBMS_XDBRESOURCE.save(V_RESOURCE);
  
  if (V_DO_CHECKIN) then
    V_RESID := DBMS_XDB_VERSION.checkin(V_RESOURCE_PATH);
  end if;
 
  return 1;
end;
--
end;
/
show errors
--
