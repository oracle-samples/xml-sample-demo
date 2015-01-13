
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
 * ================================================ */

--
-- RESOURCE LOADER is created XDBPM
--
alter session set current_schema = XDBPM
/
create table SQLLDR_STAGING_TARGET
(
  RESULT              NUMBER(1),
  CREATE_FOLDER       VARCHAR2(1),
  DUPLICATE_POLICY    VARCHAR2(10),
  RESOURCE_PATH       VARCHAR2(1024),
  CONTENT             BLOB        
)
/
create or replace view SQLLDR_STAGING_VIEW
as 
SELECT *
  from SQLLDR_STAGING_TARGET
/
create or replace trigger SQLLR_STAGING_TRIGGER
instead of INSERT on SQLLDR_STAGING_VIEW
begin
	null;
end;
/
grant all on SQLLDR_STAGING_VIEW to PUBLIC
/
create or replace package XDBPM_SQLLDR_INTERFACE
authid CURRENT_USER
as
  function  UPLOAD_RESOURCE(P_RESOURCE_PATH VARCHAR2, P_CREATE_FOLDER VARCHAR2, P_CONTENT BLOB, P_DUPLICATE_POLICY VARCHAR2) return NUMBER;
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
  V_RESULT        BOOLEAN;
  V_TARGET_FOLDER VARCHAR2(700);
begin
	V_TARGET_FOLDER := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1);
 	
  if (P_CREATE_FOLDER = 'Y')  then
    XDB_UTILITIES.mkdir(V_TARGET_FOLDER,TRUE);
  end if;
 
  XDB_UTILITIES.UPLOADRESOURCE(P_RESOURCE_PATH,P_CONTENT,P_DUPLICATE_POLICY);

  return 1;
end;
--
end;
/
show errors
--
