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

grant INHERIT PRIVILEGES on user SYS to XDBPM
/
grant INHERIT PRIVILEGES on user SYSTEM to XDBPM
/
grant INHERIT PRIVILEGES on user XDB to XDBPM
/
grant execute on SYS.DBMS_SYSTEM to XDBPM
/
alter session set current_schema = XDBPM
/
grant delete on XDB.XDB$SCHEMA         to XDBPM
/
grant delete on XDB.XDB$COMPLEX_TYPE   to XDBPM
/
grant delete on XDB.XDB$ELEMENT        to XDBPM
/
grant delete on XDB.XDB$ANY            to XDBPM
/
grant delete on XDB.XDB$ATTRIBUTE      to XDBPM
/
grant delete on XDB.XDB$ANYATTR        to XDBPM
/
--
-- Explicit grants on XDB Owned objects. Requires use of USER SYSTEM or SYSDBA connection.
-- WITH GRANT OPTION is explicitly not provided to ROLE DBA on these objects.
--
grant update on XDB.XDB$RESOURCE       to XDBPM
/
grant delete on XDB.XDB$NLOCKS         to XDBPM
/
grant update on XDB.XDB$ROOT_INFO      to XDBPM
/
create or replace package XDBPM_SYSDBA_INTERNAL
authid DEFINER
as
  C_WRITE_TO_TRACE_FILE constant binary_integer := 1;

  procedure resetLobLocator(P_RESID RAW);
  
  procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER);
  procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER);
  procedure setXMLContent(P_RESID RAW);
  procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE);
  procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER);

	procedure releaseDavLocks;
  procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2);

  procedure cleanupSchema(P_OWNER VARCHAR2);
  
  function hasTraceFileAccess return BOOLEAN;
  procedure writeToTraceFile(P_COMMENT VARCHAR2);
  procedure flushTraceFile;

end;
/
show errors
--
create or replace package body XDBPM_SYSDBA_INTERNAL
as
--
procedure flushTraceFile
as
begin
  sys.dbms_system.KSDFLS;
end;
--
procedure writeToTraceFile(P_COMMENT VARCHAR2)
as
begin
  sys.dbms_system.KSDWRT(C_WRITE_TO_TRACE_FILE,P_COMMENT);
  sys.dbms_system.KSDFLS();
end;
--  
procedure resetLobLocator(P_RESID RAW)
--
-- Used by XDB_UTILTIES.updateContent() if it detects that the LOB Locator is NULL when updating a resource.
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob()
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER)
--
-- Used by XDBPM_IMPORT_UTILITIES
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_BINARY_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER)
--
-- Used by XDBPM_IMPORT_UTILITIES
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_TEXT_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setXMLContent(P_RESID RAW)
--
-- Used by XDBPM_IMPORT_UTILITIES
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = NULL,
         r.XMLDATA.ELNUM  = NULL
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE)
--
-- Used by XDBPM_IMPORT_UTILITIES
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER)
--
-- Used by XDBPM_IMPORT_UTILITIES
--
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF,
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_GLOBAL_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure releaseDavLocks
as
begin 
    delete from XDB.XDB$NLOCKS;
    update XDB.XDB$RESOURCE r
    set r.XMLDATA.LOCKS = null
    where r.XMLDATA.LOCKS is not null;
end; 
--
procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2)
as
begin
  update XDB.XDB$ROOT_INFO
 	   set RCLIST = hexToRaw(P_NEW_OIDLIST);
end;
--
procedure cleanupSchema(P_OWNER VARCHAR2)
as
  V_OBJECT_COUNT number;
begin

  select count(*) 
    into V_OBJECT_COUNT
    from ALL_USERS
   where USERNAME = P_OWNER;
   
  if (V_OBJECT_COUNT > 0) then
    RAISE_APPLICATION_ERROR( -20000, 'User "' || P_OWNER || '" exists. XML Schema clean up only valid for dropped users.');
  end if;

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$SCHEMA x
   where x.XMLDATA.SCHEMA_OWNER = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$SCHEMA x
     where x.XMLDATA.SCHEMA_OWNER = P_OWNER;
     commit;
  end if;
    
  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$COMPLEX_TYPE x
   where x.XMLDATA.SQLSCHEMA = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$COMPLEX_TYPE x
     where x.XMLDATA.SQLSCHEMA = P_OWNER;
     commit;
  end if;

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$ELEMENT x
   where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$ELEMENT x
     where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
     commit;
  end if;

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$ATTRIBUTE x
   where x.XMLDATA.SQLSCHEMA = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$ATTRIBUTE x
     where x.XMLDATA.SQLSCHEMA = P_OWNER;
     commit;
  end if;

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$ANYATTR x
   where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$ANYATTR x
     where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
     commit;
  end if;

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$ANY x
   where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    delete 
      from XDB.XDB$ANY x
     where x.XMLDATA.PROPERTY.SQLSCHEMA = P_OWNER;
     commit;
  end if;

end;
--
function hasTraceFileAccess
return BOOLEAN
as
begin
	return TRUE;
end;
--
end;
/
show errors
--

