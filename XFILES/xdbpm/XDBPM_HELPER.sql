
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
-- Pre 12c
--
-- Install XDB.XDBPM_DBMS_XDB as a definers rights package
-- XDB.XDBPM_DBMS_XDB is a facade for XDB.DBMS_XDB
-- Grant XDBPM access to XDB.XDBPM_DBMS_XDB
--
-- Install XDBPM.XDBPM_DBMS_XDB as an invokers rights package
-- XDBPM.XDBPM_DBMS_XDB is a facade for XDB.XDBPM_DBMS_XDB
-- 
-- 12c and later
--
-- Install XDBPM.XDBPM_DBMS_XDB as as invokers rights package
-- XDBPM.XDBPM_DBMS_XDB is a facade for XDB.DBMS_XDB
-- Grant XDBADIM to XDBPM.XDBPM_DBMS_XDB
--
-- Modify code that used XDBPM.XDBPM_XDB to use XDBPM.XDBPM_DBMS_XDB
--
var XDBPM_HELPER VARCHAR2(120)
--
declare
  V_XDBPM_HELPER VARCHAR2(120);
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
$ELSE 
  V_XDBPM_HELPER := 'XDBPM_HELPER_12100.sql';
$END
  :XDBPM_HELPER := V_XDBPM_HELPER;
end;
/
undef XDBPM_HELPER
--
column XDBPM_HELPER new_value XDBPM_HELPER
--
select :XDBPM_HELPER XDBPM_HELPER 
  from dual
/
select '&XDBPM_HELPER'
  from DUAL
/
set define on
--
@@&XDBPM_HELPER
--
alter session set current_schema = XDBPM
/
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/

create or replace type DECODED_REFERENCE_T
as object  (
    OWNER VARCHAR2(32),
    TABLE_NAME      VARCHAR2(32),
    OBJECT_ID       RAW(16)
);
/
show errors
--
grant execute on DECODED_REFERENCE_T to public
/
set define on
--
var XDBPM_SYSDBA_INTERNAL VARCHAR2(120)
--
begin
  select 'XDBPM_SYSDBA_SYSDBA.sql' 
    into :XDBPM_SYSDBA_INTERNAL
    from ALL_TAB_PRIVS
   where TABLE_NAME = 'DBMS_SYSTEM'
     and TABLE_SCHEMA = 'SYS'
     and GRANTEE = 'SYSTEM';
exception
  when NO_DATA_FOUND then
    :XDBPM_SYSDBA_INTERNAL := 'XDBPM_SYSDBA_DBAONLY.sql';
  when others then
    RAISE;
end;
/
undef XDBPM_SYSDBA_INTERNAL
--
column XDBPM_SYSDBA_INTERNAL new_value XDBPM_SYSDBA_INTERNAL
--
select :XDBPM_SYSDBA_INTERNAL XDBPM_SYSDBA_INTERNAL 
  from dual
/
select '&XDBPM_SYSDBA_INTERNAL'
  from DUAL
/
set define on
--
@@&XDBPM_SYSDBA_INTERNAL
--
create or replace package XDBPM_HELPER
AUTHID DEFINER
as
--
  TYPE RESOURCE_EXPORT_ROW_T
  is record (
     RESID           RAW(16),
     VERSION       NUMBER(4),
     ACLOID          RAW(16),
     RES                CLOB,
     XMLLOB             BLOB,
     TABLE_NAME VARCHAR2(30),    
     OWNER      VARCHAR2(30),
     OBJECT_ID       RAW(16)
   );

  TYPE RESOURCE_EXPORT_TABLE_T
  is table of RESOURCE_EXPORT_ROW_T;

  TYPE DECODED_REFERENCE_ROW_T
  IS RECORD (
    OWNER VARCHAR2(32),
    TABLE_NAME      VARCHAR2(32),
    OBJECT_ID       RAW(16)
  );

  TYPE DECODED_REFERENCE_TABLE_T
  IS TABLE OF DECODED_REFERENCE_ROW_T;
  
  function  isCheckedOutByResID(P_RESOID RAW) return BOOLEAN;


  function  getXMLReference(P_PATH VARCHAR2) return REF XMLType;
  function  getXMLReferenceByResID(P_RESOID RAW) return REF XMLType;
  function  decodeXMLReference(P_XMLREF REF XMLTYPE) return DECODED_REFERENCE_TABLE_T pipelined;  

  function getComplexType(P_PROP_NUMBER NUMBER, P_SCHEMA_NAMESPACE_MAPPINGS VARCHAR2) return XMLType;
  
  function getSessionId return NUMBER;
  function getTraceFileName return VARCHAR2;
  function getTraceFileName(P_SESSION_ID NUMBER) return VARCHAR2;
  function getTraceFileContents return CLOB;
  function getTraceFileContents(P_SESSION_ID NUMBER) return CLOB;
    
  function getVersionDetails(P_RESID RAW) return RESOURCE_EXPORT_TABLE_T pipelined;      
--    
end XDBPM_HELPER;
/
show errors 
--
create or replace synonym XDB_HELPER for XDBPM_HELPER
/
--
-- & characters the HTML code
--
set define off
--
create or replace package body XDBPM_HELPER
as
--
function getComplexType(P_PROP_NUMBER NUMBER, P_SCHEMA_NAMESPACE_MAPPINGS VARCHAR2) 
return XMLType
as
  V_COMPLEX_TYPE xmlType;
  V_WRAPPER      xmlType;
begin
 
  select DEREF(e.XMLDATA.PROPERTY.TYPE_REF).extract('/complexType')
    into V_COMPLEX_TYPE
    from XDB.XDB$ELEMENT e
   where e.XMLDATA.PROPERTY.PROP_NUMBER = P_PROP_NUMBER;
          
   V_WRAPPER := XMLType('<nshack:wrapper xmlns:nshack="NAMESPACE_HACK" ' || P_SCHEMA_NAMESPACE_MAPPINGS || '>' || V_COMPLEX_TYPE.getClobVal() || '</nshack:wrapper>');
   V_COMPLEX_TYPE := V_WRAPPER.extract('/nshack:wrapper/xsd:complexType',xdb_namespaces.XMLSCHEMA_PREFIX_XSD || ' xmlns:nshack="NAMESPACE_HACK"');
   return V_COMPLEX_TYPE;
end;
--
function getSessionID
return NUMBER
--
-- Return the current session id
--
as
  V_PID NUMBER(6);
begin
  select SPID
    into V_PID
    from SYS.V_$PROCESS p, SYS.V_$SESSION s
   where p.ADDR = s.PADDR
     and s.SID =  (select SID from SYS.V_$MYSTAT where ROWNUM = 1);
   return V_PID;
end;
--
function getTraceFileName(P_SESSION_ID NUMBER)
return VARCHAR2
--
-- Return the trace file name for the specified session id
--
as
  V_GLOBAL_NAME     VARCHAR2(1024);
  V_SID             VARCHAR2(8);
  V_TRACE_FILE_NAME VARCHAR2(32);
begin
  select db_name.value  || '_ora_' ||  v$process.spid ||   nvl2(v$process.traceid,  '_' || v$process.traceid, null )   || '.trc'
    into V_TRACE_FILE_NAME
    from v$parameter db_name
   cross join v$process 
         join v$session 
           on v$process.addr = v$session.paddr
   where db_name.name  = 'db_name'        
     and v$session.audsid=sys_context('userenv','sessionid');
  return V_TRACE_FILE_NAME;
end;
--
function getTraceFileName
return VARCHAR2
as
begin
	return getTraceFileName(getSessionID());
end;
--
function getTraceFileHandle(P_SESSION_ID NUMBER)
return bfile
as
  pragma autonomous_transaction;
  V_TRACE_FILE_NAME VARCHAR2(256);
begin
  V_TRACE_FILE_NAME := getTraceFileName(P_SESSION_ID);
  return bfilename('ORACLE_TRACE_DIRECTORY',V_TRACE_FILE_NAME);
end;
--
function getTraceFileContents(P_SESSION_ID NUMBER)
return CLOB
as
  V_TRACE_FILE_CONTENTS       CLOB;
begin
  dbms_lob.createTemporary(V_TRACE_FILE_CONTENTS,TRUE,dbms_lob.session);
  XDBPM_SYSDBA_INTERNAL.flushTraceFile();
  V_TRACE_FILE_CONTENTS := xdb_utilities.getFileContent(getTraceFileHandle(P_SESSION_ID));
  return V_TRACE_FILE_CONTENTS;
end;
--
function getTraceFileContents
return CLOB
as
begin
	return getTraceFileContents(getSessionId());
end;
--
function isCheckedOutByRESID(P_RESOID RAW)
return BOOLEAN
as
  V_RESULT NUMBER(1) := 0;
begin  
  select 1 
    into V_RESULT
    from XDB.XDB$CHECKOUTS where VERSION = P_RESOID;
  return TRUE;
exception 
  when no_data_found then
    return FALSE;
end;
--
function getXMLReferenceByResID(P_RESOID RAW)
return REF XMLType
as
  V_XMLREF REF XMLType;
begin
  select r.XMLDATA.XMLREF 
    into V_XMLREF
    from XDB.XDB$RESOURCE r 
   where OBJECT_ID = P_RESOID;
  return V_XMLREF;
end;
--
function getXMLReference(P_PATH VARCHAR2)
return REF XMLType
as
  V_XMLREF REF XMLType;
begin
  select r.XMLDATA.XMLREF 
    into V_XMLREF
    from XDB.XDB$RESOURCE r, RESOURCE_VIEW
   where RESID = OBJECT_ID
     and equals_path(RES,P_PATH) = 1;
  return V_XMLREF;
end;
--
function decodeXMLReference(P_XMLREF REF XMLTYPE) 
return DECODED_REFERENCE_TABLE_T pipelined
as
  V_DECODED_REFERENCE DECODED_REFERENCE_ROW_T;
begin
	V_DECODED_REFERENCE.OBJECT_ID := NULL;
	V_DECODED_REFERENCE.TABLE_NAME := NULL;
	V_DECODED_REFERENCE.OWNER := NULL;

	if P_XMLREF is not NULL then
    select ao.OBJECT_NAME, ao.OWNER, r.OBJECT_ID
      into V_DECODED_REFERENCE.TABLE_NAME, V_DECODED_REFERENCE.OWNER, V_DECODED_REFERENCE.OBJECT_ID
      from DBA_OBJECTS ao, SYS.OBJ$ o, 
           ( 
             select HEXTORAW(SUBSTR(XMLREF,41,32)) TABLE_ID, HEXTORAW(SUBSTR(XMLREF,9,32)) OBJECT_ID
               from ( 
                      select RAWTOHEX(P_XMLREF) XMLREF from dual 
                    )
           ) r     
    where ao.OBJECT_ID = o.OBJ#
      and o.OID$ = r.TABLE_ID;
  end if;
  pipe row (V_DECODED_REFERENCE);
end;
--
function getVersionDetails(P_RESID RAW) 
return RESOURCE_EXPORT_TABLE_T pipelined
as
  V_RESOURCE_EXPORT_ROW RESOURCE_EXPORT_ROW_T;
begin
  select xr.OBJECT_ID
        ,extractValue(xr.OBJECT_VALUE,'/Resource/@VersionID')
        ,extractValue(xr.OBJECT_VALUE,'/Resource/ACLOID')
        ,xr.OBJECT_VALUE.getClobVal()
        ,extractValue(xr.OBJECT_VALUE,'/Resource/XMLLob')
        ,td.TABLE_NAME
        ,td.OWNER 
        ,td.OBJECT_ID
   into V_RESOURCE_EXPORT_ROW.RESID,
        V_RESOURCE_EXPORT_ROW.VERSION,
        V_RESOURCE_EXPORT_ROW.ACLOID,
        V_RESOURCE_EXPORT_ROW.RES,
        V_RESOURCE_EXPORT_ROW.XMLLOB,
        V_RESOURCE_EXPORT_ROW.TABLE_NAME,
        V_RESOURCE_EXPORT_ROW.OWNER,
        V_RESOURCE_EXPORT_ROW.OBJECT_ID
   from XDB.XDB$RESOURCE xr,
        TABLE(XDBPM_HELPER.DECODEXMLREFERENCE(extractValue(xr.OBJECT_VALUE,'/Resource/XMLRef'))) td
  where xr.OBJECT_ID = P_RESID;
	pipe row (V_RESOURCE_EXPORT_ROW);
	return;
end;
--
procedure createTraceFileDirectory
--
-- Create a SQL Directory object pointing at the user trace directory. Enables access to Trace Files via the BFILE constructor.
--
as
  pragma autonomous_transaction;
  V_USER_TRACE_LOCATION VARCHAR2(512);
  V_STATEMENT           VARCHAR2(256);
  V_DBNAME              VARCHAR2(256);
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN  
  execute immediate 'select VALUE from SYS.V_$PARAMETER where NAME = ''user_dump_dest''' into V_USER_TRACE_LOCATION;
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  execute immediate 'select VALUE from SYS.V_$PARAMETER where NAME = ''user_dump_dest''' into V_USER_TRACE_LOCATION;
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
  execute immediate 'select VALUE from SYS.V_$PARAMETER where NAME = ''user_dump_dest''' into V_USER_TRACE_LOCATION;
$ELSE
  execute immediate 'select VALUE from V$DIAG_INFO where NAME = ''Diag Trace''' into V_USER_TRACE_LOCATION;
$END
  dbms_output.put_line(V_USER_TRACE_LOCATION);
  V_STATEMENT := 'create or replace directory ORACLE_TRACE_DIRECTORY as ''' || V_USER_TRACE_LOCATION || '''';
  execute immediate V_STATEMENT;
  rollback;
end;
--
begin
	if (XDBPM_SYSDBA_INTERNAL.hasTraceFileAccess) then
	  createTraceFileDirectory();
	end if;
$IF $$DEBUG $THEN
  XDB_OUTPUT.createTraceFile('/public/XDBPM_TRACE_FILE.log',TRUE);
$END
end XDBPM_HELPER;
/
show errors
--
create or replace package XDBPM_IMPORT_HELPER
AUTHID DEFINER
as
  TYPE DECODED_REFERENCE_ROW_T
  IS RECORD (
    OWNER VARCHAR2(32),
    TABLE_NAME      VARCHAR2(32),
    OBJECT_ID       RAW(16)
  );

  TYPE DECODED_REFERENCE_TABLE_T
  IS TABLE OF DECODED_REFERENCE_ROW_T;
  
  function decodeXMLReference(P_XMLREF REF XMLTYPE) return DECODED_REFERENCE_TABLE_T pipelined;  
end;
/
show errors
--
create or replace synonym XDB_IMPORT_HELPER for XDBPM_IMPORT_HELPER
/
grant execute on XDBPM_IMPORT_HELPER to public
/
create or replace package body XDBPM_IMPORT_HELPER
as
function decodeXMLReference(P_XMLREF REF XMLTYPE) 
return DECODED_REFERENCE_TABLE_T pipelined
as
  V_DECODED_REFERENCE DECODED_REFERENCE_ROW_T;
begin
	V_DECODED_REFERENCE.OBJECT_ID := NULL;
	V_DECODED_REFERENCE.TABLE_NAME := NULL;
	V_DECODED_REFERENCE.OWNER := NULL;
	if P_XMLREF is not NULL then
    select TABLE_NAME, OWNER, OBJECT_ID
      into V_DECODED_REFERENCE.TABLE_NAME, V_DECODED_REFERENCE.OWNER, V_DECODED_REFERENCE.OBJECT_ID
      from TABLE(XDBPM.XDBPM_HELPER.DECODEXMLREFERENCE(P_XMLREF));
    pipe row (V_DECODED_REFERENCE);
  end if;
end;
--
begin
	NULL;
$IF $$DEBUG $THEN
  XDB_OUTPUT.createTraceFile('/public/XDBPM_PACKAGE_TRACE.log',TRUE);
$END
end;
/
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
alter session set current_schema = SYS
/
show errors
--

