
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
  V_XDBPM_HELPER VARCHAR2(120) := 'XDBPM_HELPER_12100.sql';
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
  V_XDBPM_HELPER := 'XDBPM_HELPER_10200.sql';
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
@@XDBPM_CHECK_PERMISSIONS
--
var XDBPM_SYSDBA_INTERNAL VARCHAR2(120)
--
declare
  V_XDBPM_SYSDBA_INTERNAL VARCHAR2(120);
begin
$IF XDBPM.XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN
  V_XDBPM_SYSDBA_INTERNAL := 'XDBPM_SYSDBA_SYSDBA.sql';
$ELSIF XDBPM.XDBPM_INSTALLER_PERMISSIONS.IS_SYSTEM $THEN
  V_XDBPM_SYSDBA_INTERNAL := 'XDBPM_SYSDBA_SYSTEM.sql';
$ELSIF XDBPM.XDBPM_INSTALLER_PERMISSIONS.HAS_DBA $THEN
  V_XDBPM_SYSDBA_INTERNAL := 'XDBPM_DO_NOTHING.sql';
$ELSE
  V_XDBPM_SYSDBA_INTERNAL := 'XDBPM_DO_NOTHING.sql';
$END
  :XDBPM_SYSDBA_INTERNAL := V_XDBPM_SYSDBA_INTERNAL;
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
create or replace package XDBPM_INTERNAL_CONSTANTS
AUTHID DEFINER
as
	function getTraceFileId return VARCHAR2;
end;
/
show errors
--
create or replace package body XDBPM_INTERNAL_CONSTANTS
as
--
function getTraceFileId
return VARCHAR2
--
-- Return the current session id used in trace file names...
--
as
  V_TRACE_ID VARCHAR2(32);
begin
  select p.spid ||   nvl2(p.traceid,  '_' || p.traceid, null )
    into V_TRACE_ID
    from v$process p
    join v$session s
      on p.addr = s.paddr
   where s.audsid=sys_context('userenv','sessionid');
   
  return V_TRACE_ID;
end;
--
end;
/
show errors
--
@@&XDBPM_SYSDBA_INTERNAL
--
show user
--
create or replace package XDBPM_SYSDBA_INTERNAL
as
  C_WRITE_TO_TRACE_FILE constant binary_integer := 1;

  procedure resetResConfigs(P_RESID RAW);
  procedure resetLobLocator(P_RESID RAW);
  procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER);
  procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER);
  procedure setXMLContent(P_RESID RAW);
  procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE);
  procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER);

  procedure releaseDavLocks;
  procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2);  
  procedure cleanupSchema(P_OWNER VARCHAR2);
  procedure CLEAN_UP_XMLSCHEMA(P_SCHEMA_URL VARCHAR2, P_OWNER VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','CURRENT_SCHEMA'), P_LOCAL VARCHAR2 DEFAULT 'YES');
  
  procedure writeToTraceFile(P_COMMENT VARCHAR2);
  procedure flushTraceFile;

end;
/
show errors
--
create or replace package body XDBPM_SYSDBA_INTERNAL
as
--
  UNIMPLEMENTED_FEATURE EXCEPTION;
  PRAGMA EXCEPTION_INIT(UNIMPLEMENTED_FEATURE , -03001 );  
--
procedure flushTraceFile
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  sys.dbms_system.KSDFLS;
$ELSE
  NULL;
$END
end;
--
procedure writeToTraceFile(P_COMMENT VARCHAR2)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  sys.dbms_system.KSDWRT(C_WRITE_TO_TRACE_FILE,P_COMMENT);
  sys.dbms_system.KSDFLS();
$ELSE
  NULL;
$END
end;
--  
procedure resetLobLocator(P_RESID RAW)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob()
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure resetResConfigs(P_RESID RAW)
as
/*
**
** TODO: Delete the offending object(s) rather than the entire set of RESCONFIG entries.
**
** Remove the RCList (entry) if the RCLIST contains a reference to a non existing RESCONFIG.
**
*/
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.RCLIST = NULL
   where OBJECT_ID = P_RESID
     and r.XMLDATA.RCLIST is not NULL
     and exists (
           select 1
             from XDB.XDB$RESOURCE r,
                  table(r.XMLDATA.RCLIST.OID) x
						where OBJECT_ID = P_RESID
              and not exists (
                        select 1 
                          from XDB.XDB$RESCONFIG rc
                         where COLUMN_VALUE = rc.OBJECT_ID
                      )
         );    
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_BINARY_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_TEXT_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure setXMLContent(P_RESID RAW)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = NULL,
         r.XMLDATA.ELNUM  = NULL
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF,
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_GLOBAL_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure releaseDavLocks
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
    delete from XDB.XDB$NLOCKS;
    update XDB.XDB$RESOURCE r
    set r.XMLDATA.LOCKS = null
    where r.XMLDATA.LOCKS is not null;
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2)
as
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  update XDB.XDB$ROOT_INFO
 	   set RCLIST = hexToRaw(P_NEW_OIDLIST);
$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
procedure CLEAN_UP_XMLSCHEMA(P_SCHEMA_URL VARCHAR2, P_OWNER VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','CURRENT_SCHEMA'), P_LOCAL VARCHAR2 DEFAULT 'YES')
as
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
  INVALID_OPERATION EXCEPTION;
  PRAGMA EXCEPTION_INIT( INVALID_OPERATION, -20001 );

  V_RESOURCE_PATH VARCHAR2(4000) := P_SCHEMA_URL;
  V_OBJECT_COUNT  NUMBER(5);
  V_SCHEMA_ID     RAW(16);

  V_SCHEMA_REF    REF XMLTYPE;
  
  cursor CLEAN_UP_SCHEMAS
  is 
  select ref(x) SCHEMA_REF
    from XDB.XDB$SCHEMA x
   where x.XMLDATA.SCHEMA_URL   = P_SCHEMA_URL
     and x.XMLDATA.SCHEMA_OWNER = P_OWNER;
   
begin

  if (instr(P_SCHEMA_URL,'://') > 0) then
    V_RESOURCE_PATH := substr(V_RESOURCE_PATH,INSTR(P_SCHEMA_URL,'://')+3);
  end if;
  
  if (P_LOCAL = 'YES') then
    V_RESOURCE_PATH := '/sys/schemas/' || SYS_CONTEXT('USERENV','CURRENT_SCHEMA') || '/' || V_RESOURCE_PATH;
  end if;
  
  if (P_LOCAL = 'NO') then
    V_RESOURCE_PATH := '/sys/schemas/PUBLIC/' || V_RESOURCE_PATH;
  end if;
 
  DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': Checking for existance of resource "' || V_RESOURCE_PATH || '"');
  
  if DBMS_XDB.existsResource(V_RESOURCE_PATH) then
    DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': Resource exists.');
    RAISE_APPLICATION_ERROR( -20001, 'XMLSchema "' || P_SCHEMA_URL || '": Still present in XDB Repository as resource "' || V_RESOURCE_PATH || '". Please use DBMS_XMLSCHEMA.deleteSchema().');
  end if;
  
  DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": no longer found in the XDB Repository as resource "' || V_RESOURCE_PATH || '". Attempting direct clean-up of schema artifacts.' );

  select count(*) 
    into V_OBJECT_COUNT
    from XDB.XDB$SCHEMA x
   where x.XMLDATA.SCHEMA_URL   = P_SCHEMA_URL
     and x.XMLDATA.SCHEMA_OWNER = P_OWNER;
  
  if (V_OBJECT_COUNT > 0) then
    DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Located 1 or more entries in XDB.XDB$SCHEMA.');
   
    for s in CLEAN_UP_SCHEMAS loop

      -- XDB.XDB$ANY

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ANY x
       where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;


       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ANY.');
         delete 
           from XDB.XDB$ANY x
          where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;
        commit;
       end if;

      -- XDB.XDB$ALL_MODEL

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ALL_MODEL x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ALL_MODEL.');
         delete 
           from XDB.XDB$ALL_MODEL x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;
       
      -- XDB.XDB$ANYATTR

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ANYATTR x
       where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ANYATTR.');
         delete 
           from XDB.XDB$ANYATTR x
          where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;
  
      -- XDB.XDB$ATTRGROUP_DEF
      
      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ATTRGROUP_DEF x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         
       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ATTRGROUP_DEF.');
         delete 
           from XDB.XDB$ATTRGROUP_DEF x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$ATTRGROUP_REF
      
      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ATTRGROUP_REF x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         
       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ATTRGROUP_REF.');
         delete 
           from XDB.XDB$ATTRGROUP_REF x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;
       
       -- XDB$XDB.XDB$ATTRIBUTE

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ATTRIBUTE x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ATTRIBUTE.');
         delete 
           from XDB.XDB$ATTRIBUTE x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;
    
      -- XDB.XDB$CHOICE_MODEL

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$CHOICE_MODEL x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$CHOICE_MODEL.');
         delete 
           from XDB.XDB$CHOICE_MODEL x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$COMPLEX_TYPE

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$COMPLEX_TYPE x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$COMPLEX_TYPE.');
         delete 
           from XDB.XDB$COMPLEX_TYPE x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$ELEMENT

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$ELEMENT x
       where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$ELEMENT.');
         delete 
           from XDB.XDB$ELEMENT x
          where X.XMLDATA.PROPERTY.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$GROUP_DEF

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$GROUP_DEF x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$GROUP_DEF.');
         delete 
           from XDB.XDB$GROUP_DEF x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$GROUP_REF

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$GROUP_REF x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$GROUP_REF.');
         delete 
           from XDB.XDB$GROUP_REF x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$SEQUENCE_MODEL

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$SEQUENCE_MODEL x
       where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$SEQUENCE_MODEL.');
         delete 
           from XDB.XDB$SEQUENCE_MODEL x
          where X.XMLDATA.PARENT_SCHEMA = s.SCHEMA_REF;
         commit;
       end if;

      -- XDB.XDB$SCHEMA

      select count(*) 
        into V_OBJECT_COUNT
        from XDB.XDB$SCHEMA x
       where ref(x) = s.SCHEMA_REF;

       if (V_OBJECT_COUNT > 0) then
         DBMS_OUTPUT.put_line(SYSTIMESTAMP || ': XMLSchema "' || P_SCHEMA_URL ||'": Removing ' || V_OBJECT_COUNT || ' entries from XDB.XDB$SCHEMA.');
         delete 
           from XDB.XDB$SCHEMA x
          where ref(x) = s.SCHEMA_REF;
         commit;
       end if;
    end loop;
  end if;
end;
$ELSE
begin
  raise UNIMPLEMENTED_FEATURE;
end;
$END
--
procedure cleanupSchema(P_OWNER VARCHAR2)
as
  V_OBJECT_COUNT number;
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN	
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

$ELSE
  raise UNIMPLEMENTED_FEATURE;
$END
end;
--
end;
/
show errors
--
create or replace package XDBPM_HELPER
AUTHID DEFINER
as
--
  C_ORACLE_TRACE_DIRECTORY CONSTANT VARCHAR2(128) := 'ORACLE_TRACE_DIRECTORY';
  C_PACKAGE_TRACE_LOGFILE  CONSTANT  VARCHAR2(128) := '/public/XDBPM_PACKAGE_TRACE_' || XDBPM_INTERNAL_CONSTANTS.getTraceFileId() || '.log';
  
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
  
  function getTraceFileName return VARCHAR2;
  function getTraceFileContents return CLOB;
    
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
  FILE_NOT_FOUND        EXCEPTION;
  PRAGMA EXCEPTION_INIT(FILE_NOT_FOUND, -22288);

  DIRECTORY_NOT_FOUND   EXCEPTION;
  PRAGMA EXCEPTION_INIT(DIRECTORY_NOT_FOUND, -22285);
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
function getTraceFileName
return VARCHAR2
--
-- Return the trace file name for the specified session id
--
as
  V_TRACE_FILE_NAME VARCHAR2(32) := XDBPM_INTERNAL_CONSTANTS.getTraceFileId();
begin
  select p.value  || '_ora_' || V_TRACE_FILE_NAME  || '.trc'
    into V_TRACE_FILE_NAME
    from v$parameter p
   where p.name  = 'db_name';        
     
  return V_TRACE_FILE_NAME;
end;
--
function getTraceFileHandle
return bfile
as
  pragma autonomous_transaction;
  V_TRACE_FILE_NAME VARCHAR2(256);
begin
  V_TRACE_FILE_NAME := getTraceFileName();
  return bfilename(C_ORACLE_TRACE_DIRECTORY,V_TRACE_FILE_NAME);
end;
--
$IF DBMS_DB_VERSION.VER_LE_12_1 $THEN
$ELSE
function getTraceFileFromView
return CLOB
as
  V_TRACE_FILE_NAME     VARCHAR2(64) := lower(getTraceFileName());
  V_TRACE_FILE_CONTENTS CLOB;
  
  cursor getTraceFileContent(C_TRACE_FILE_NAME VARCHAR2)
  is
  select PAYLOAD
    from V$DIAG_TRACE_FILE_CONTENTS
   order by LINE_NUMBER;
begin
	DBMS_LOB.createTemporary(V_TRACE_FILE_CONTENTS,FALSE,DBMS_LOB.SESSION);
	for l in getTraceFileContent(V_TRACE_FILE_NAME) loop
	  DBMS_LOB.writeAppend(V_TRACE_FILE_CONTENTS,length(l.PAYLOAD),l.PAYLOAD);
  end loop;
  
  if (DBMS_LOB.getLength(V_TRACE_FILE_CONTENTS) = 0) then
    V_TRACE_FILE_CONTENTS := 'No content found for Trace File  "' || V_TRACE_FILE_NAME || '".';
  end if;
  
	return V_TRACE_FILE_CONTENTS;
end;
--
$END
function getTraceFileContents
return CLOB
as
  V_TRACE_FILE_CONTENTS       CLOB;
begin
	begin
    dbms_lob.createTemporary(V_TRACE_FILE_CONTENTS,TRUE,dbms_lob.session);
    XDBPM_SYSDBA_INTERNAL.flushTraceFile();
    V_TRACE_FILE_CONTENTS := xdb_utilities.getFileContent(getTraceFileHandle());
  exception
$IF DBMS_DB_VERSION.VER_LE_12_1 $THEN
$ELSE    
    when DIRECTORY_NOT_FOUND then
      V_TRACE_FILE_CONTENTS := getTraceFileFromView();
    when FILE_NOT_FOUND then
      V_TRACE_FILE_CONTENTS := getTraceFileFromView();
$END
    when OTHERS then
      RAISE;
  end;
  return V_TRACE_FILE_CONTENTS;
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
function getTraceFileDirectoryLocation
return VARCHAR2
as
  V_USER_TRACE_LOCATION VARCHAR2(512);
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
  return V_USER_TRACE_LOCATION;
end;
--
procedure createTraceFileDirectory
--
-- Create a SQL Directory object pointing at the user trace directory. Enables access to Trace Files via the BFILE constructor.
--
as
  pragma autonomous_transaction;
  V_STATEMENT           VARCHAR2(256);
  V_DBNAME              VARCHAR2(256);
begin
$IF XDBPM_INSTALLER_PERMISSIONS.HAS_CREATE_DIRECTORY $THEN	
  V_STATEMENT := 'create or replace directory ' || C_ORACLE_TRACE_DIRECTORY || ' as ''' || getTraceFileDirectoryLocation() || '''';
  execute immediate V_STATEMENT;
  rollback;
$ELSE
  NULL;
$END
end;
--
procedure checkTraceFileDirectory
as
  V_DIRECTORY_PATH VARCHAR2(4000);
begin
	begin
  	select DIRECTORY_PATH
	    into V_DIRECTORY_PATH
	    from ALL_DIRECTORIES
	   where DIRECTORY_NAME = XDBPM_HELPER.C_ORACLE_TRACE_DIRECTORY;
	 exception
	   when NO_DATA_FOUND then
	     createTraceFileDirectory();
	   when OTHERS then
	     RAISE;
	 end;
end;
--
begin
	checkTraceFileDirectory();
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
end;
/
alter session set current_schema = SYS
/
show errors
--
