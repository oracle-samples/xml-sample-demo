
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
-- XDBPM_SBIMPORT_UTILITIES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_SBIMPORT_UTILITIES
authid CURRENT_USER
as
  procedure prepareSBExport(P_USER VARCHAR2 default USER);
  procedure exportSBResources(P_OWNER VARCHAR2, P_TABLE_NAME VARCHAR2);
  procedure importSBResources(P_USER VARCHAR2 default USER);
end;
/
show errors
--
create or replace synonym XDB_SBIMPORT_UTILITIES for XDBPM_SBIMPORT_UTILITIES
/
grant execute on XDBPM_SBIMPORT_UTILITIES to public
/
create or replace package body XDBPM_SBIMPORT_UTILITIES
as
  invalid_user exception;
  PRAGMA EXCEPTION_INIT( invalid_user , -31071 );

  G_DUPLICATE_POLICY    VARCHAR2(10) := XDB_CONSTANTS.RAISE_ERROR;

  G_SCHEMA_ELEMENT      VARCHAR2(700);
  G_TARGET_SCHEMA_OID   RAW(16);
  G_GLOBAL_ELEMENT_ID   NUMBER(16);
  
procedure getTargetSchemaInfo(P_SCHEMA_ELEMENT VARCHAR2)
as
  V_SCHEMA_URL          VARCHAR2(700);
  V_GLOBAL_ELEMENT_NAME VARCHAR2(700);
begin
  -- dbms_output.put_line('xdb_import_utilities.getTargetSchemaInfo() : Target Schema = ' || P_SCHEMA_ELEMENT);
  if (G_SCHEMA_ELEMENT is null) or (P_SCHEMA_ELEMENT <> G_SCHEMA_ELEMENT) then
    G_SCHEMA_ELEMENT      := P_SCHEMA_ELEMENT;   
    V_SCHEMA_URL          := substr(P_SCHEMA_ELEMENT,1,instr(P_SCHEMA_ELEMENT,'#',-1)-1);
    V_GLOBAL_ELEMENT_NAME := substr(P_SCHEMA_ELEMENT,instr(P_SCHEMA_ELEMENT,'#',-1)+1);
    select object_id,
           extractValue
           (
             object_value,
             '/xs:schema/xs:element[@name="' || V_GLOBAL_ELEMENT_NAME || '"]/@xdb:propNumber',
             'xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdb="http://xmlns.oracle.com/xdb"'
           )
      into G_TARGET_SCHEMA_OID, G_GLOBAL_ELEMENT_ID
      from xdb.xdb$schema
     where extractValue
         (
           object_value,
           '/xs:schema/@xdb:schemaURL',
           'xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdb="http://xmlns.oracle.com/xdb"'
         )  = V_SCHEMA_URL;
  end if; 
end;
--
procedure patchXMLReference(P_RESOURCE_PATH VARCHAR2,P_XMLREF REF XMLTYPE, P_SCHEMA_ELEMENT VARCHAR2)
as
begin
  getTargetSchemaInfo(P_SCHEMA_ELEMENT);
  xdb_helper.setSBXMLContent(DBMS_XDB.getRESOID(P_RESOURCE_PATH),P_XMLREF,G_TARGET_SCHEMA_OID,G_GLOBAL_ELEMENT_ID);
end;
--  
procedure createPrinciples(P_XML_RESOURCE XMLType )
as
  V_TMP      XMLType;
  V_OWNER    VARCHAR2(32);
  V_MODIFIER VARCHAR2(32);
  V_CREATOR  VARCHAR2(32);
  V_RESULT   NUMBER;
begin  
  V_TMP := P_XML_RESOURCE.createNonSchemaBasedXML();
  select extractValue(V_TMP,'/r:Resource/r:Owner',XDB_NAMESPACES.RESOURCE_PREFIX_R),
         extractValue(V_TMP,'/r:Resource/r:LastModifier',XDB_NAMESPACES.RESOURCE_PREFIX_R),
         extractValue(V_TMP,'/r:Resource/r:Creator',XDB_NAMESPACES.RESOURCE_PREFIX_R) 
    into V_OWNER, V_MODIFIER, V_CREATOR
    from dual;
    -- dbms_output.put_line('Owner := ' || V_OWNER || '. LastModifier = ' || V_MODIFIER || '. Creator = ' || V_CREATOR);
  begin
    select 1 
      into V_RESULT
      from all_users
     where username = V_OWNER;
  exception
    when no_data_found then 
      execute immediate 'create user "' || V_OWNER || '" identified by password account lock';
  end;
        
  begin
    select 1 
      into V_RESULT
      from all_users
     where username = V_MODIFIER;
  exception
    when no_data_found then
      execute immediate 'create user "' || V_MODIFIER || '" identified by password account lock';
  end;

  begin
    select 1 
      into V_RESULT 
      from all_users
     where username = V_CREATOR;
  exception
    when no_data_found then 
      execute immediate 'create user "' || V_CREATOR || '" identified by password account lock';
  end;

end;
--
procedure patchModificationStatus(P_RESOURCE_PATH VARCHAR2,P_RESOURCE_XML XMLType)
is
begin
  null;
end;
--
procedure prepareSBExport(P_USER VARCHAR2 default USER)
as
begin
  execute immediate
'create table "' || P_USER || '".XDBPM$RESOURCE_METADATA_TABLE 
(
  RESID RAW(16), 
  XMLREF REF XMLTYPE, 
  ACL_PATH VARCHAR2(700),
  METADATA CLOB
)';
  execute immediate
'create table "' || P_USER || '".XDBPM$RESOURCE_PATH_TABLE 
(
  RESID RAW(16), 
  PATH   VARCHAR2(700)
)';
end;
--
procedure exportSBResources(P_OWNER VARCHAR2, P_TABLE_NAME VARCHAR2)
as
  V_ROW_COUNT                  NUMBER;
  V_STATEMENT                  VARCHAR2(4000);
  TYPE RESOURCE_CURSOR_TYPE IS REF CURSOR;
  V_RESOURCE_CURSOR            RESOURCE_CURSOR_TYPE;
  V_RESID                      RAW(16);
  V_XMLREF                     REF XMLTYPE;
  V_ACL_PATH                   VARCHAR2(700);
  V_RES                        CLOB;
  V_PATH                       VARCHAR2(700);
begin
  xdb_import_utilities.setPrintMode(24);
  
  execute immediate 'delete from "' || P_OWNER || '".XDBPM$RESOURCE_METADATA_TABLE';
  execute immediate 'delete from "' || P_OWNER || '".XDBPM$RESOURCE_PATH_TABLE';
  
  V_STATEMENT := 'select RESID, extractValue(RES,''/Resource/XMLRef'') XMLREF, (select ANY_PATH from RESOURCE_VIEW a where make_ref(XDB.XDB$ACL,extractValue(r.RES,''/Resource/ACLOID'')) = extractValue(a.RES,''/Resource/XMLRef'')) ACL_PATH, r.RES.getClobVal() from RESOURCE_VIEW R, "' || P_OWNER || '"."' || P_TABLE_NAME || '" x where ref(x) = extractValue(r.RES,''/Resource/XMLRef'')';

  V_ROW_COUNT := 0;

  open V_RESOURCE_CURSOR for V_STATEMENT;

  loop
    fetch V_RESOURCE_CURSOR INTO V_RESID, V_XMLREF, V_ACL_PATH, V_RES;
    exit when V_RESOURCE_CURSOR%NOTFOUND;
    execute immediate 'insert into "' || P_OWNER || '".XDBPM$RESOURCE_METADATA_TABLE values (:1, :2, :3, :4)' using V_RESID, V_XMLREF, V_ACL_PATH, V_RES;
    V_ROW_COUNT := V_ROW_COUNT + 1;
    if (V_ROW_COUNT = 1000) then
      commit;
      V_ROW_COUNT := 0;
    end if;
  END LOOP;

  CLOSE V_RESOURCE_CURSOR;

  V_STATEMENT := 'select RESID, PATH from PATH_VIEW R, "' || P_OWNER || '"."' || P_TABLE_NAME || '" x where ref(x) = extractValue(res,''/Resource/XMLRef'')';

  V_ROW_COUNT := 0;

  open V_RESOURCE_CURSOR for V_STATEMENT;

  loop
    fetch V_RESOURCE_CURSOR INTO V_RESID, V_PATH;
    exit when V_RESOURCE_CURSOR%NOTFOUND;
    execute immediate 'insert into "' || P_OWNER || '".XDBPM$RESOURCE_PATH_TABLE values (:1, :2)' using V_RESID, V_PATH;
    V_ROW_COUNT := V_ROW_COUNT + 1;
    if (V_ROW_COUNT = 1000) then
      commit;
      V_ROW_COUNT := 0;
    end if;
  END LOOP;

  CLOSE V_RESOURCE_CURSOR;
  xdb_import_utilities.clearPrintMode(24);
end;
--      
procedure importSBResource(P_RESOURCE_PATH VARCHAR2, P_XMLREF REF XMLTYPE, P_ACL_PATH VARCHAR2, P_XML_RESOURCE CLOB)
is
  V_SCHEMA_ELEMENT         VARCHAR2(4000);
  V_RESOURCE_XML           XMLType;
  V_ACL_PATH               VARCHAR2(4000);
  V_OLD_RESOURCE_ID        VARCHAR2(32);
  V_NEW_RESOURCE_ID	   RAW(16);
begin
  
  -- dbms_output.put_line('importResource() : P_RESOURCE_PATH = "' || P_RESOURCE_PATH || '"');

  --
  -- If Duplicate Policy is set to SKIP do Nothing 
  --
 
  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    if (G_DUPLICATE_POLICY = XDB_CONSTANTS.SKIP) then
      return;
    end if;
  end if;
   
  V_RESOURCE_XML := xmltype(P_XML_RESOURCE);

  -- Fix namespace before converting to Schema Based XMLType.
 
  if (V_RESOURCE_XML.getNamespace() is null) then
    select insertChildXML(V_RESOURCE_XML,'/Resource','@xmlns',XDB_NAMESPACES.RESOURCE_NAMESPACE) into V_RESOURCE_XML from dual;
  end if;

  if (V_ACL_PATH = 'null') then
    V_ACL_PATH := null;
  end if;

  -- Remove the Lock and RefCount element before converting to Schema Based XML.. Lock is a 'read-only' element in 10.2.X and an Invalid element in 11.1.x
  
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:Lock',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:RefCount',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;

  if (V_RESOURCE_XML.existsNode('/r:Resource/r:SchemaElement',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1 ) then
    select extractValue(V_RESOURCE_XML,'/r:Resource/r:SchemaElement',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_SCHEMA_ELEMENT from dual;
  end if;

  -- Convert to Schema Based XML and validate Creator, Owner and LastModifier

  begin  
     V_RESOURCE_XML := V_RESOURCE_XML.createSchemaBasedXML(XDB_NAMESPACES.RESOURCE_NAMESPACE);
     if (V_RESOURCE_XML.existsNode('/r:Resource/r:Owner',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1) then
       null;
     end if;
     if (V_RESOURCE_XML.existsNode('/r:Resource/r:Creator',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1) then
       null;
     end if;
     if (V_RESOURCE_XML.existsNode('/r:Resource/r:LastModifier',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1) then
       null;
     end if;
  exception
    when invalid_user then
      createPrinciples(V_RESOURCE_XML);
  end;

  -- Cannot Validate a Resource against XDBResource.xsd since XDBResource.xsd is not a valid XML Schema - Bootstrap problems.
  --  
  -- if (V_RESOURCE_XML.isSchemaValid() = 0) then
  --   V_RESOURCE_XML.schemaValidate();
  -- end if;
  --
   
  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    --
    -- If Duplicate Policy is set to OVERWRITE_DUPLICATES treat as an update of the existing document
    --
    if (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
      patchXMLReference(P_RESOURCE_PATH,P_XMLREF,V_SCHEMA_ELEMENT);        
      DBMS_XDB.setAcl(P_RESOURCE_PATH,V_ACL_PATH); 
      patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
      return;   
    end if;
    --
    -- If Duplicate Policy is set to VERSION initiate versioning and treat a new version of the existing document
    --
    if (G_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
      -- Need to versioned schema based documents here...
      return;
    end if;
  end if;
 
  --
  -- If Duplicate Policy is set to RAISE_ERROR an error will be raised if the RESOURCE already exists when the Resource is Inserted
  --

  insert into RESOURCE_VIEW (ANY_PATH, RES) values (P_RESOURCE_PATH, V_RESOURCE_XML);     
  patchXMLReference(P_RESOURCE_PATH,P_XMLREF,V_SCHEMA_ELEMENT);        
  DBMS_XDB.setAcl(P_RESOURCE_PATH,P_ACL_PATH); 
  patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
  return;

end;  
--
procedure importSBResources(P_USER VARCHAR2 default USER)
as
  V_ROW_COUNT NUMBER;
  TYPE RESOURCE_CURSOR_TYPE IS REF CURSOR;
  V_RESOURCE_CURSOR RESOURCE_CURSOR_TYPE;
  V_STATEMENT VARCHAR2(4000);
  
  V_LAST_RESID RAW(16);
  V_LAST_PATH  VARCHAR2(700);
  V_PATH       VARCHAR2(700);
  V_RESID      RAW(16);
  V_ACL_PATH   VARCHAR2(700);
  V_XMLREF     REF XMLTYPE;
  V_METADATA   CLOB;
  
begin 
  V_LAST_RESID := DBMS_XDB.GETRESOID('/');
  V_STATEMENT := 'select m.RESID, m.XMLREF, m.ACL_PATH, m.METADATA, p.PATH from "' || P_USER || '".XDBPM$RESOURCE_METADATA_TABLE m, "' || P_USER || '".XDBPM$RESOURCE_PATH_TABLE p where m.RESID = p.RESID';

  V_ROW_COUNT := 0;

  open V_RESOURCE_CURSOR for V_STATEMENT;

  loop
    fetch V_RESOURCE_CURSOR INTO V_RESID, V_XMLREF, V_ACL_PATH, V_METADATA, V_PATH;
    exit when V_RESOURCE_CURSOR%NOTFOUND;
    if V_LAST_RESID <> V_RESID then  
      importSBResource(V_PATH,V_XMLREF,V_ACL_PATH,V_METADATA);
      V_LAST_PATH := V_PATH;
      V_LAST_RESID := V_RESID;
    else
      -- Code to create Link
      null;
    end if;
    V_ROW_COUNT := V_ROW_COUNT + 1;
    if (V_ROW_COUNT = 1000) then
      commit;
      V_ROW_COUNT := 0;
    end if;
  END LOOP;

  CLOSE V_RESOURCE_CURSOR;
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
--