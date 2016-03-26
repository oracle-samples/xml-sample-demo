
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
-- XDBPM_IMPORT_UTILITIES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_IMPORT_UTILITIES
authid CURRENT_USER
as

  C_LINE_01  constant VARCHAR2(128) := 'declare' || CHR(13) || CHR(10);
  C_LINE_02  constant VARCHAR2(128) := '  V_RESULT  BOOLEAN;' || CHR(13) || CHR(10);
  C_LINE_03  constant VARCHAR2(128) := '  V_CONTENT BLOB;' || CHR(13) || CHR(10);
  C_LINE_04  constant VARCHAR2(128) := '  V_RESOURCE VARCHAR2(1024) := ';
  C_LINE_05  constant VARCHAR2(128) := 'begin' || CHR(13) || CHR(10);
  C_LINE_06  constant VARCHAR2(128) := '  if (DBMS_XDB.existsResource(V_RESOURCE)) then' || CHR(13) || CHR(10);
  C_LINE_07  constant VARCHAR2(128) := '    DBMS_XDB.deleteResource(V_RESOURCE);' || CHR(13) || CHR(10);
  C_LINE_08  constant VARCHAR2(128) := '  end if;' || CHR(13) || CHR(10);
  C_LINE_09  constant VARCHAR2(128) := '  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);' || CHR(13) || CHR(10);
  C_LINE_10  constant VARCHAR2(128) := '  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(';
  C_LINE_11  constant VARCHAR2(128) := '  V_RESULT := DBMS_XDB.createResource(V_RESOURCE,V_CONTENT);' || CHR(13) || CHR(10);
  C_LINE_12  constant VARCHAR2(128) := '  DBMS_LOB.FREETEMPORARY(V_CONTENT);' || CHR(13) || CHR(10);
  C_LINE_13  constant VARCHAR2(128) := '  COMMIT;' || CHR(13) || CHR(10);
  C_LINE_14  constant VARCHAR2(128) := 'end;' || CHR(13) || CHR(10);
  C_LINE_15  constant VARCHAR2(128) := '/' || CHR(13) || CHR(10);
 
  C_COMMENT  constant VARCHAR2(129) := '-- SCRIPT GENEREATED BY XDB_IMPORT_UTILITIES ';

  C_RESOURCE_CREATED      constant NUMBER(2) := 1;
  C_RESOURCE_UPDATED      constant NUMBER(2) := 2;
  C_RESOURCE_NEW_VERSION  constant NUMBER(2) := 3;
  C_RESOURCE_UNCHANGED    constant NUMBER(2) := 4;
 
  TYPE DECODED_REFERENCE_ROW_T
  IS RECORD (
    OWNER VARCHAR2(32),
    TABLE_NAME      VARCHAR2(32),
    OBJECT_ID       RAW(16)
  );

  TYPE DECODED_REFERENCE_TABLE_T
  IS TABLE OF DECODED_REFERENCE_ROW_T;
  
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
  
  procedure startImport(P_DUPLICATE_POLICY VARCHAR2,P_ROOT_FOLDER VARCHAR2);
  procedure resetAclFolder(P_TEMPORARY_ACL_FOLDER VARCHAR2);
  procedure removeAclFolder(P_TEMPORARY_ACL_FOLDER VARCHAR2);

  function importFolder(P_RESOURCE_PATH VARCHAR2) return number;
  function importResource(P_RESOURCE_PATH VARCHAR2, P_RESOURCE_TEXT CLOB) return number;
  function importLink(P_LINK_DEFINITION CLOB) return number;
  function getLOBLocator(P_RESOURCE_PATH VARCHAR2) return BLOB; 
  function patchXMLReference(P_RESOURCE_PATH VARCHAR2, P_XML_REFERENCE CLOB) return number;
  function getVersionDetails(P_RESID RAW) return RESOURCE_EXPORT_TABLE_T pipelined;      

  function matchPath(P_PATH_LIST XMLType) return VARCHAR2;

  procedure updateResource(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLTYPE);

  procedure setDuplicatePolicy(P_DUPLICATE_POLICY VARCHAR2);
  procedure setPrintMode(P_PRINT_MODE NUMBER);
  procedure clearPrintMode(P_PRINT_MODE NUMBER);

  procedure validateRepository;

  procedure ZIP(P_PARAMETERS XMLType);
  procedure UNZIP(P_ZIP_FILE_PATH VARCHAR2, P_LOG_FILE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_DUPLICATE_ACTION VARCHAR2);
  procedure EXPORT(P_PARAMETERS XMLTYPE);
  procedure IMPORT(P_PARAMETERS XMLTYPE);
  
  function EXPORT_FILE_AS_SQL(P_RESOURCE_PATH VARCHAR2) return CLOB;
  function EXPORT_FILES_AS_SQL(P_RESOURCE_LIST XDB.XDB$STRING_LIST_T) return CLOB;

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
  procedure createResource(P_RESOURCE_PATH VARCHAR2,P_CONTENT_BLOB BLOB,P_DUPLICATE_POLICY VARCHAR2);
$END
end;
/
show errors
--
create or replace synonym XDB_IMPORT_UTILITIES for XDBPM_IMPORT_UTILITIES
/
grant execute on XDBPM_IMPORT_UTILITIES to public
/
create or replace package body XDBPM_IMPORT_UTILITIES
as
  invalid_user exception;
  PRAGMA EXCEPTION_INIT( invalid_user , -31071 );

  read_only_property exception;
  PRAGMA EXCEPTION_INIT( read_only_property , -31065 );

  missing_resource_namespace exception;
  PRAGMA EXCEPTION_INIT( missing_resource_namespace , -30937 );
  
  G_DUPLICATE_POLICY    VARCHAR2(10) := XDB_CONSTANTS.RAISE_ERROR;
  G_IMPORT_START_DATE   TIMESTAMP;
  G_ROOT_FOLDER         VARCHAR2(700);
--
  G_SCHEMA_ELEMENT      VARCHAR2(700);
  G_TARGET_SCHEMA_OID   RAW(16);
  G_GLOBAL_ELEMENT_ID   NUMBER(16);
--
procedure setDuplicatePolicy(P_DUPLICATE_POLICY VARCHAR2)
as
begin
  G_DUPLICATE_POLICY := P_DUPLICATE_POLICY;
end;
--
procedure startImport(P_DUPLICATE_POLICY VARCHAR2,P_ROOT_FOLDER VARCHAR2)
as
  V_RESULT BOOLEAN;
begin
  G_IMPORT_START_DATE := systimestamp;
  setDuplicatePolicy(P_DUPLICATE_POLICY);
  XDB_UTILITIES.mkdir(P_ROOT_FOLDER,TRUE);
  
   if (SUBSTR(P_ROOT_FOLDER,LENGTH(P_ROOT_FOLDER)) = '/')  then
    G_ROOT_FOLDER := P_ROOT_FOLDER;
  else
    G_ROOT_FOLDER := P_ROOT_FOLDER || '/';
  end if;

end;
--
function getAbsolutePath(P_PATH VARCHAR2) 
return VARCHAR2
as
begin
  if (INSTR(P_PATH,'/',1) = 1) then
    return P_PATH;
  else
    return G_ROOT_FOLDER || P_PATH;
  end if;
end;
--
procedure removeAclFolder(P_TEMPORARY_ACL_FOLDER VARCHAR2)
--
-- Clean up the Temporary ACL folder at the end of the import.
--
as
  V_ACL_SCHEMA_ID              RAW(16);
  V_PERMANENT_ACL_FOLDER VARCHAR2(700) := P_TEMPORARY_ACL_FOLDER;
   
  -- Find ACLs in the Temporary ACL folder that are not currently referenced elsewhere in the repository
  -- and which secure at least one other document in the repository
  
  cursor getOrphanedAcls
  is
  select ar.ANY_PATH
    from RESOURCE_VIEW ar
   where under_Path(ar.RES,P_TEMPORARY_ACL_FOLDER) = 1
     and existsNode(ar.RES,'/Resource[SchOID="' ||  V_ACL_SCHEMA_ID || '" and RefCount=1]') = 1
     and exists (
           select 1 
             from RESOURCE_VIEW rv
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
            where extractValue(rv.RES,'/r:Resource/r:ACLOID',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)
                = SYS_OP_R2O(HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)))
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
            where extractValue(rv.RES,'/r:Resource/r:ACLOID',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)
                = SYS_OP_R2O(HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)))
$ELSE                
            where XMLCast(
                    XMLQuery(
                     'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                      $RES/Resource/ACLOID'
                     passing rv.RES as "RES"
                     returning content
                   ) as RAW(16)
                 ) = SYS_OP_R2O(
                       XMLCast(
                         XMLQuery(
                           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                            fn:data($RES/Resource/XMLRef)'
                           passing ar.RES as "RES"
                           returning content
                         ) as REF XMLType
                       )
                     )
$END                     
             and ar.RESID <> rv.RESID
         );
         
         
  cursor getSelfSecuringAcls 
  is
  select ar.ANY_PATH
    from XDB.RESOURCE_VIEW rv, RESOURCE_VIEW ar
   where under_Path(ar.res,P_TEMPORARY_ACL_FOLDER) = 1
     and equals_path(ar.res,rv.ANY_PATH) = 1
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
     and extractValue(rv.RES,'/r:Resource/r:ACLOID',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)
       = SYS_OP_R2O(HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)));
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
    and extractValue(rv.RES,'/r:Resource/r:ACLOID',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)
      = SYS_OP_R2O(HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)));
$ELSE                
     and XMLCast(
           XMLQuery(
             'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
              $RES/Resource/ACLOID'
             passing rv.RES as "RES"
             returning content
           ) as RAW(16)
         ) = SYS_OP_R2O(
               XMLCast(
                 XMLQuery(
                   'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                    fn:data($RES/Resource/XMLRef)'
                   passing ar.RES as "RES"
                   returning content
                 ) as REF XMLType
               )
             );
$END            
  cursor getUnusedAcls
  is
  select ANY_PATH 
    from RESOURCE_VIEW
   where under_Path(RES,P_TEMPORARY_ACL_FOLDER) = 1
     and existsNode(RES,'/Resource[SchOID="' ||  V_ACL_SCHEMA_ID || '"]') = 1;
  
begin
	
	select SCHEMA_ID 
	  into V_ACL_SCHEMA_ID
	  from ALL_XML_SCHEMAS
	 where SCHEMA_URL = DBMS_XDB_CONSTANTS.SCHEMAURL_ACL;
	
	V_PERMANENT_ACL_FOLDER := SUBSTR(V_PERMANENT_ACL_FOLDER,1,INSTR(V_PERMANENT_ACL_FOLDER,'/',-1)-1);
	V_PERMANENT_ACL_FOLDER := SUBSTR(V_PERMANENT_ACL_FOLDER,INSTR(V_PERMANENT_ACL_FOLDER,'/',-1)+1);
	V_PERMANENT_ACL_FOLDER := '/sys/acls/export/' || V_PERMANENT_ACL_FOLDER;
  
  -- Move Orphanded Acls from the Temporary ACL Folder to a permanent location under /sys/acls

  for a in getOrphanedAcls loop
    XDB_UTILITIES.mkdir(V_PERMANENT_ACL_FOLDER, TRUE);
    DBMS_XDB.renameResource(A.ANY_PATH,V_PERMANENT_ACL_FOLDER,SUBSTR(a.ANY_PATH,INSTR(a.ANY_PATH,'/',-1) + 1));
  end loop;

	-- Delete Acls in the Temporary ACL Folder that are also located elsewhere in the repository.
	  
	delete 
	  from PATH_VIEW
   where under_path(RES,P_TEMPORARY_ACL_FOLDER) = 1
     and ( 
       existsNode(RES,'/Resource[SchOID="' ||  V_ACL_SCHEMA_ID || '" and RefCount > 1]') = 1
     or 
       existsNode(LINK,'/Link[LinkType="WEAK"]') = 1
     );

	-- Reset ACLS that are self securing.

	for a in getSelfSecuringAcls loop
	  DBMS_XDB.setACL(a.ANY_PATH,'/sys/acls/bootstrap_acl.xml');
	end loop;
	
	-- Delete any remaining ACLs

  for a in getUnusedAcls loop
	  DBMS_XDB.deleteResource(a.ANY_PATH);
  end loop;
    
  DBMS_XDB.deleteResource(P_TEMPORARY_ACL_FOLDER);
  DBMS_XDB.deleteResource(substr(P_TEMPORARY_ACL_FOLDER,1,INSTR(P_TEMPORARY_ACL_FOLDER,'/',-1)-1));
  
end;
-- 	
procedure resetAclFolder(P_TEMPORARY_ACL_FOLDER VARCHAR2)
as
begin
	if (DBMS_XDB.existsResource(P_TEMPORARY_ACL_FOLDER)) then
	  removeAclFolder(P_TEMPORARY_ACL_FOLDER);
	end if;
  XDB_UTILITIES.mkdir(P_TEMPORARY_ACL_FOLDER,TRUE);
end;
--
/*
**
** procedure resetAclFolder(P_TEMPORARY_ACL_FOLDER VARCHAR2)
** as
**   cursor getSelfSecuringAcls 
**   is
**   select ar.ANY_PATH
**     from XDB.RESOURCE_VIEW r, RESOURCE_VIEW ar
**    where XMLCast(
**            XMLQuery(
**              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
**               $RES/Resource/ACLOID'
**               passing r.RES as "RES"
**               returning content
**             ) as RAW(16)
**          ) = SYS_OP_R2O(
**                XMLCast(
**                  XMLQuery(
**                    'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
**                     fn:data($RES/Resource/XMLRef)'
**                     passing ar.RES as "RES"
**                     returning content
**                   ) as REF XMLType
**                 )
**               )
**     and under_Path(ar.res,P_TEMPORARY_ACL_FOLDER) = 1
**     and equals_path(ar.res,r.ANY_PATH) = 1;
** begin
** 	--
** 	-- Delete ACLs from Temporary ACL Folder that exist elsewhere in the repository.
** 	--
** 	delete
** 	  from PATH_VIEW
** 	 where under_path(res,P_TEMPORARY_ACL_FOLDER) = 1
** 	   and (
** 	         existsNode(res,'/Resource[RefCount > 1]') = 1
** 	       or 
** 	         existsNode(link,'Link[LinkType="WEAK"]') = 1
** 	       );
** 	--
** 	-- Ensure ACLs in Temporary ACL Folder are not secured by ACLs in Temporary ACL Folder.
** 	--
** 	for a in getSelfSecuringAcls loop
** 	  DBMS_XDB.setACL(a.ANY_PATH,'/sys/acls/bootstrap_acl.xml');
** 	end loop;
** 	
** 	delete from RESOURCE_VIEW
** 	 where under_path(res,1,P_TEMPORARY_ACL_FOLDER) = 1;
** 
**   if (DBMS_XDB.existsResource(P_TEMPORARY_ACL_FOLDER)) then
**     DBMS_XDB.deleteResource(P_TEMPORARY_ACL_FOLDER);
**   end if;
**   
**   XDB_UTILITIES.mkdir(P_TEMPORARY_ACL_FOLDER,TRUE);
** end;
**
*/
--
procedure setBinaryContent(P_RESID RAW)
is
begin
  XDBPM_SYSDBA_INTERNAL.setBinaryContent(P_RESID,XDBPM_RESOURCE_SCHEMA_INFO.RESOURCE_SCHEMA_OID,XDBPM_RESOURCE_SCHEMA_INFO.BINARY_ELEMENT_ID);
end;
--
procedure setTextContent(P_RESID RAW)
is
begin
  XDBPM_SYSDBA_INTERNAL.setTextContent(P_RESID,XDBPM_RESOURCE_SCHEMA_INFO.RESOURCE_SCHEMA_OID,XDBPM_RESOURCE_SCHEMA_INFO.BINARY_ELEMENT_ID);
end;
--
procedure setXMLContent(P_RESID RAW)
is
begin
  XDBPM_SYSDBA_INTERNAL.setXMLContent(P_RESID);
end;
--
procedure setXMLContent(P_RESID RAW,P_XML_REFERENCE REF XMLTYPE)
as
begin
  XDBPM_SYSDBA_INTERNAL.setXMLContent(P_RESID ,P_XML_REFERENCE);
end;
--
procedure setSBXMLContent(P_RESID RAW, P_XML_REFERENCE REF XMLTYPE)
as
begin
	XDBPM_SYSDBA_INTERNAL.setSBXMLContent(P_RESID,P_XML_REFERENCE,G_TARGET_SCHEMA_OID,G_GLOBAL_ELEMENT_ID);        
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
function getResourceID(V_RESOURCE_XML in out XMLTYPE)
return string 
is
  V_RESOURCE_ID            VARCHAR2(32);

  dom                   dbms_xmldom.DOMDocument;
  nl                    dbms_xmldom.DOMNodeList;
  node                  dbms_xmldom.DOMNode;
  pi                    dbms_xmldom.DOMProcessingInstruction;
      
begin

  dom           := dbms_xmldom.newDOMDocument(V_RESOURCE_XML);
  node          := dbms_xmldom.getFirstChild(dbms_xmldom.makeNode(dom));
  pi            := dbms_xmldom.makeProcessingInstruction(node);
  V_RESOURCE_ID := dbms_xmldom.getData(pi);
  node          := dbms_xmldom.removeChild(dbms_xmldom.makeNode(dom),node);

  dbms_xmldom.freeNode(node);
   
  return V_RESOURCE_ID;
end;
-- 
function getACLPath(V_RESOURCE_XML in out XMLTYPE)
return string 
is
  V_ACL_PATH               VARCHAR2(256);

  dom                   dbms_xmldom.DOMDocument;
  nl                    dbms_xmldom.DOMNodeList;
  node                  dbms_xmldom.DOMNode;
  pi                    dbms_xmldom.DOMProcessingInstruction;
      
begin
   
  dom          := dbms_xmldom.newDOMDocument(V_RESOURCE_XML);
  node         := dbms_xmldom.getFirstChild(dbms_xmldom.makeNode(dom));
  pi           := dbms_xmldom.makeProcessingInstruction(node);
  V_ACL_PATH      := dbms_xmldom.getData(pi);
  node         := dbms_xmldom.removeChild(dbms_xmldom.makeNode(dom),node);

  dbms_xmldom.freeNode(node);

  return V_ACL_PATH;
end;
-- 
procedure createEmptyContent(P_RESOURCE_PATH VARCHAR2, P_RESOURCE_XML XMLTYPE, P_SCHEMA_ELEMENT VARCHAR2)
as
  V_NEW_RESOURCE_ID         RAW(16);
begin
    
  select RESID
    into V_NEW_RESOURCE_ID
    from RESOURCE_VIEW
   where equals_path(RES,P_RESOURCE_PATH) = 1;
                     
    -- Create empty content LOB based on document type.

   if (P_SCHEMA_ELEMENT =  XDB_NAMESPACES.BINARY_CONTENT) then
     setBinaryContent(V_NEW_RESOURCE_ID); 
   end if;
  
   if (P_SCHEMA_ELEMENT =  XDB_NAMESPACES.TEXT_CONTENT) then
     setTextContent(V_NEW_RESOURCE_ID); 
   end if;
  
   if (P_SCHEMA_ELEMENT =  XDB_NAMESPACES.ACL_CONTENT) then
     null;
   end if;

   if (P_SCHEMA_ELEMENT is null) then
     setXMLContent(V_NEW_RESOURCE_ID);
   end if;

end;
--
function importVersionedResource(P_RESOURCE_PATH VARCHAR2, P_VERSIONED_RESOURCE XMLType, P_SCHEMA_ELEMENT VARCHAR2) 
return NUMBER
as
  V_RESOURCE_XML     XMLType := P_VERSIONED_RESOURCE;
  V_NEW_RESOURCE_ID  RAW(16);
  V_RESULT           NUMBER(1);
begin
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:VCRUID',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:Parents',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;
  select deleteXML(V_RESOURCE_XML,'/r:Resource/@VersionID',XDB_NAMESPACES.RESOURCE_PREFIX_R)  into V_RESOURCE_XML from dual;    

  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    begin
      select 1
        into V_RESULT
        from RESOURCE_VIEW
       where equals_path(RES,P_RESOURCE_PATH) = 1
         and existsNode(RES,'/r:Resource/@VersionID',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
       --
       -- Existing Resource is versioned. Create new member of the version series.
       -- 
       if (DBMS_XDB_VERSION.isCheckedOut(P_RESOURCE_PATH)) then
         V_NEW_RESOURCE_ID  := dbms_xdb_version.checkin(P_RESOURCE_PATH);
       end if;
       dbms_xdb_version.checkout(P_RESOURCE_PATH);
       XDB_IMPORT_UTILITIES.updateResource(P_RESOURCE_PATH,V_RESOURCE_XML);
       createEmptyContent(P_RESOURCE_PATH, V_RESOURCE_XML,P_SCHEMA_ELEMENT);
       V_NEW_RESOURCE_ID  := dbms_xdb_version.checkin(P_RESOURCE_PATH);
       return C_RESOURCE_NEW_VERSION;
    exception 
      when no_data_found then
         --
         -- Existing Resource is not versioned.
         -- 
         if (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
           --
           -- Duplicate Policy is OVERWRITE. Update the current resource and initiate versioning for this resource.
           --
           XDB_IMPORT_UTILITIES.updateResource(P_RESOURCE_PATH,V_RESOURCE_XML);
           V_NEW_RESOURCE_ID  := dbms_xdb_version.makeVersioned(P_RESOURCE_PATH);
           return C_RESOURCE_UPDATED;    
         else
           --
           -- Duplicate Policy is VERSION. Initiate Versioning for the currrent resource and create a new 
           -- version of the document.
           -- 
           V_NEW_RESOURCE_ID  := dbms_xdb_version.makeVersioned(P_RESOURCE_PATH);
           dbms_xdb_version.checkout(P_RESOURCE_PATH);
           XDB_IMPORT_UTILITIES.updateResource(P_RESOURCE_PATH,V_RESOURCE_XML);
           V_NEW_RESOURCE_ID  := dbms_xdb_version.checkin(P_RESOURCE_PATH);
           return C_RESOURCE_NEW_VERSION;
         end if;
      when others then
        raise;
    end;
  else
    insert into RESOURCE_VIEW (ANY_PATH, RES) values (P_RESOURCE_PATH, V_RESOURCE_XML);     
    createEmptyContent(P_RESOURCE_PATH, V_RESOURCE_XML,P_SCHEMA_ELEMENT);
    V_NEW_RESOURCE_ID  := dbms_xdb_version.makeVersioned(P_RESOURCE_PATH);
    return C_RESOURCE_CREATED;
  end if;
end;
--
--
function importResource(P_RESOURCE_PATH VARCHAR2, P_RESOURCE_TEXT CLOB)
return number
as
  V_RESOURCE_XML           XMLType;
  V_ACL_PATH               VARCHAR2(4000);
  V_RESOURCE_ID            VARCHAR2(32);
  V_SCHEMA_ELEMENT         VARCHAR2(4000);
  V_RESULT                 NUMBER := C_RESOURCE_UNCHANGED;
  V_DATE_CREATED           TIMESTAMP;
  V_EXISTING_RESOURCE      BOOLEAN := FALSE;
  V_RES                    BOOLEAN;
begin
 
  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
  
    select XMLCAST(
             XMLQUERY(
              'declare namespace r="http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
               $RES/r:Resource/r:CreationDate'
               passing RES as "RES" 
               returning content
             )
             as TIMESTAMP
           )
      into V_DATE_CREATED
      from RESOURCE_VIEW 
     where equals_path(res,P_RESOURCE_PATH) = 1;
     
     if (V_DATE_CREATED < G_IMPORT_START_DATE) then
        V_EXISTING_RESOURCE := TRUE;
     end if;
  end if;

  --
  -- Convert Resource into valid XDBResource object
  --
  
  --     
  -- Correct Missing namespace declaration for XDB Resource namespace
  --
  
  V_RESOURCE_XML := XMLType(P_RESOURCE_TEXT);
 
  if (V_RESOURCE_XML.getNamespace() is null) then
    select insertChildXML(V_RESOURCE_XML,'/Resource','@xmlns',XDB_NAMESPACES.RESOURCE_NAMESPACE) into V_RESOURCE_XML from dual;
  end if;

  -- Get the Source Resource ID and ACL_PATH (Stored as Processing Instructions in the exported XML).

  V_RESOURCE_ID := getResourceID(V_RESOURCE_XML);
  V_ACL_PATH := getACLPath(V_RESOURCE_XML);

  if (V_ACL_PATH = 'null') then
    V_ACL_PATH := null;
  else
    V_ACL_PATH := getAbsolutePath(V_ACL_PATH);
  end if;
  
  -- Remove the Lock and RefCount element before converting to Schema Based XML.. Lock is a 'read-only' element in 10.2.X and an Invalid element in 11.1.x
  
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:Lock',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:LockBuf',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;
  select deleteXML(V_RESOURCE_XML,'/r:Resource/r:RefCount',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_RESOURCE_XML from dual;

  if (V_RESOURCE_XML.existsNode('/r:Resource/r:SchemaElement',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1 ) then
    select extractValue(V_RESOURCE_XML,'/r:Resource/r:SchemaElement',XDB_NAMESPACES.RESOURCE_PREFIX_R) into V_SCHEMA_ELEMENT from dual;
  end if;

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
  --
  -- Ensure the ACL Document is valid in release 11.1 and later.
  --
  if (V_SCHEMA_ELEMENT =  XDB_NAMESPACES.ACL_CONTENT) then
     V_RESOURCE_XML := XDB_UTILITIES.migrateACLResource(V_RESOURCE_XML);
  end if;
$END

  -- Cannot Validate a Resource against XDBResource.xsd since XDBResource.xsd is not a valid XML Schema - Bootstrap problems.
  --  
  -- if (V_RESOURCE_XML.isSchemaValid() = 0) then
  --   V_RESOURCE_XML.schemaValidate();
  -- end if;
  --
 
  -- Validate Creator, Owner and LastModifier
   
  begin  
     V_RESOURCE_XML := V_RESOURCE_XML.createSchemaBasedXML(XDB_NAMESPACES.RESOURCE_NAMESPACE);
     if (V_RESOURCE_XML.existsNode('/r:Resource/r:Owner',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1) then
       null;
     end if;
  exception
    when invalid_user then
      createPrinciples(V_RESOURCE_XML);
  end;
   
  if (V_RESOURCE_XML.existsNode('/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1) then 
    --
    -- Processing a Folder / Container :
    --
    
    -- 
    -- Folders are created using XDBPM_IMPORT_UTILITIES.importFolder. The resource document for the folder is
    -- then updated by call XDBPM_IMPORT_UTILITIES.importResource. This means that the folder will always exist
    -- by the time this point is reached.
    --
     
    --
    -- XDBPM_IMPORT_UTILITIES.importFolder must be called prior to calling XDB_IMPORT_UTILITIES.importResource. 
    -- The RAISE ERROR policy is enforced by importResource, so we do not need to manage RAISE_ERROR here.
    --
    
    --
    -- Folders cannot be versioned so we treat the VERSION policy the same way as the OVERWRITE policy.
    --

    --
    -- If Duplicate Policy is set to SKIP and the resource was created before the start of the Import operation do nothing. 
    --
 
    if ((NOT V_EXISTING_RESOURCE) or (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) or (G_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION)) then
      --
      -- Folder was created as a result of the import process, or the effective duplicate policy is OVERWRITE
      -- Update the folder's resource document
      --
      XDB_IMPORT_UTILITIES.updateResource(P_RESOURCE_PATH,V_RESOURCE_XML);        
      return C_RESOURCE_UPDATED;
    end if;

    --
    -- The folder's resource document should be left unchanged if duplicate policy is and SKIP and the folder  
    -- existed prior to the start of the import process.
    --

    return C_RESOURCE_UNCHANGED;
  else
 
     --
     -- Importing a Resource in RAISE Mode should raise an error if the resource already exists
     --

     if ((G_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) and V_EXISTING_RESOURCE) then
       V_RES := DBMS_XDB.createResource(P_RESOURCE_PATH,'Invoking DBMS_XDB.createResource() will force the correct exception to be raised');
     end if;  

     if (V_RESOURCE_XML.existsNode('/r:Resource/r:VCRUID',xdb_namespaces.RESOURCE_PREFIX_R) = 1) then

      --
      -- The resource is a member of a version series.
      -- 
      
      --
      -- TODO : Importing a Version Series in SKIP mode should do nothing if the resource existed prior to the start of the import operation.
      -- 
      
      --
      -- Importing a Version Series in OVERWRITE Mode will replace the existing resource with the new Version Series.
      -- If the existing resource is versioned the new version series extends the existing version series.
      -- If the existing resource is not versioned then the current resource is updated using the first member of the version series.
      -- 
    
      V_RESULT := importVersionedResource(P_RESOURCE_PATH,V_RESOURCE_XML,V_SCHEMA_ELEMENT);
      if (V_ACL_PATH is not null) then
        DBMS_XDB.setAcl(P_RESOURCE_PATH,V_ACL_PATH); 
      end if;    
      patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
      
      return V_RESULT;  
    else
      -- 
      -- Importing a Non Versioned Resource in SKIP Mode should be ignored if the resource already existed at the time the restore operation commenced.
      --
      
      if ((G_DUPLICATE_POLICY = XDB_CONSTANTS.SKIP) and V_EXISTING_RESOURCE) then
        return C_RESOURCE_UNCHANGED;
      end if;

      if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
      
        if (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
          --
          -- Duplicate Policy is OVERWRITE : Update of the existing resource document
          --
          XDB_IMPORT_UTILITIES.updateResource(P_RESOURCE_PATH,V_RESOURCE_XML);        
          DBMS_XDB.setAcl(P_RESOURCE_PATH,V_ACL_PATH); 
          patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
          return C_RESOURCE_UPDATED;
        end if;
        
        if (G_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
          --
          -- Duplicate Policy VERSION : Initiate versioning and create a new version of the existing document
          --
          V_RESOURCE_ID := dbms_xdb_version.makeVersioned(P_RESOURCE_PATH);
          V_RESULT := importVersionedResource(P_RESOURCE_PATH,V_RESOURCE_XML,V_SCHEMA_ELEMENT);
          DBMS_XDB.setAcl(P_RESOURCE_PATH,V_ACL_PATH); 
          patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
          return C_RESOURCE_NEW_VERSION;
        end if;
      end if;
      --
      -- Create a new resource by inserting the document into RESOURCE_VIEW.
      --
      insert into RESOURCE_VIEW (ANY_PATH, RES) values (P_RESOURCE_PATH, V_RESOURCE_XML);     
      createEmptyContent(P_RESOURCE_PATH,V_RESOURCE_XML,V_SCHEMA_ELEMENT);
      DBMS_XDB.setAcl(P_RESOURCE_PATH,V_ACL_PATH); 
      patchModificationStatus(P_RESOURCE_PATH,V_RESOURCE_XML);
      return C_RESOURCE_CREATED;
    end if;

  end if;

end;  
--
function getLOBLocator(P_RESOURCE_PATH VARCHAR2) 
return BLOB
is
  V_LOB_LOCATOR BLOB;
begin 

  select extractValue(RES,'/Resource/XMLLob')
    into V_LOB_LOCATOR
    from RESOURCE_VIEW
   where equals_path(RES,P_RESOURCE_PATH) = 1
     for update;
  
  return V_LOB_LOCATOR;

end;
--
procedure validateRepository
is
  cursor getResources
  is
  select ANY_PATH,RESID
    from RESOURCE_VIEW
   where under_path(RES,'/') = 1
     and extractValue(RES,'/Resource/XMLLob') is not null;

  V_CONTENT_SIZE NUMBER;
begin
  for r in getResources loop
    begin
      select dbms_lob.getLength(xdburitype(DBMS_XDB.createOidPath(r.RESID)).getBlob())
        into V_CONTENT_SIZE
        from dual;
    exception
      when others then
        dbms_output.put_line(r.ANY_PATH);
    end;
  end loop;
end;
--
function importFolder(P_RESOURCE_PATH VARCHAR2) 
return NUMBER
as
  V_RES          BOOLEAN;
  V_RESULT       NUMBER := C_RESOURCE_UNCHANGED;
  V_DATE_CREATED TIMESTAMP;
begin
  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
  
    -- Folder exists

    select XMLCAST(
             XMLQUERY(
              'declare namespace r="http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
               $RES/r:Resource/r:CreationDate'
               passing RES as "RES" 
               returning content
             )
             as TIMESTAMP
           )
      into V_DATE_CREATED
      from RESOURCE_VIEW 
     where equals_path(res,P_RESOURCE_PATH) = 1;

    -- For SKIP, OVERWRITE or VERSION no further action is required at this point

    if ((G_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) or (G_DUPLICATE_POLICY = XDB_CONSTANTS.SKIP) or (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE)) then
      return C_RESOURCE_UNCHANGED;
    end if;
    
    -- For RAISE,  check if the folder existed prior to the start of the import operation. 
    
    if ((G_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) and (V_DATE_CREATED < G_IMPORT_START_DATE)) then
      --
      --  Execute a createFolder to raise the required error.
      --
      V_RES := DBMS_XDB.createFolder(P_RESOURCE_PATH);
    end if;
    
    return V_RESULT;
  end if;
  
  -- Create the Folder.
  
  XDB_UTILITIES.mkdir(P_RESOURCE_PATH,TRUE);
  return C_RESOURCE_CREATED;
end;
--
function  validateACL(P_RESOURCE_XML XMLTYPE)
return XMLTYPE
as
begin
  return P_RESOURCE_XML;
end;
--
procedure setContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB) 
as
  V_LOB_LOCATOR BLOB;
  V_XMLREF      REF XMLTYPE;
begin
  select extractValue(RES,'/Resource/XMLLob'), extractValue(RES,'/Resource/XMLRef') 
    into V_LOB_LOCATOR, V_XMLREF
    from RESOURCE_VIEW
   where equals_path(RES,P_RESOURCE_PATH) = 1
     for update;

  if (V_LOB_LOCATOR is not null) then
    DBMS_LOB.TRIM(V_LOB_LOCATOR,0);
    DBMS_LOB.COPY(V_LOB_LOCATOR,P_CONTENT,DBMS_LOB.getLength(P_CONTENT),1,1);
    return;
  end if;
  
  -- Inline XML Content - Not currently supported. 
  
  if (V_XMLREF is not null) then
    update RESOURCE_VIEW
       set RES = updateXML(RES,'/Resource/Contents',xmltype(P_CONTENT,nls_charset_id('AL32UTF8')))
     where equals_path(RES,P_RESOURCE_PATH) = 1;
   return;
 end if;
end;
--
procedure getTargetSchemaInfo(P_SCHEMA_ELEMENT VARCHAR2)
as
  V_SCHEMA_URL          VARCHAR2(700);
  V_GLOBAL_ELEMENT_NAME VARCHAR2(700);
begin
  --
  -- Optimize Typical Scenario where the contents of a folder is associated with the same XML Schema.
  --
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
function patchXMLReference(P_RESOURCE_PATH VARCHAR2, P_SCHEMA_ELEMENT VARCHAR2, P_XML_REFERENCE REF XMLType)
return NUMBER
as
  V_EXISTING_RESOURCE_PATH VARCHAR2(700);
begin
	
  select ANY_PATH
    into V_EXISTING_RESOURCE_PATH
    from RESOURCE_VIEW
   where extractValue(RES,'/Resource/XMLRef') = P_XML_REFERENCE;

  -- A Resource Document whose content is defined as target row already exists. Two resources cannot have the same content (XMLRef)
  -- Delete the resource that is meant to point at the this row and replace it with an Link to the existing resource.

  DBMS_XDB.deleteResource(P_RESOURCE_PATH);

  DBMS_XDB.LINK(V_EXISTING_RESOURCE_PATH,SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,'/',-1)-1),SUBSTR(P_RESOURCE_PATH,INSTR(P_RESOURCE_PATH,'/',-1)+1));
  return 0;

exception

  when NO_DATA_FOUND then
 	  if (P_SCHEMA_ELEMENT is not null) then
      getTargetSchemaInfo(P_SCHEMA_ELEMENT);
      setSBXMLContent(DBMS_XDB.getRESOID(P_RESOURCE_PATH),P_XML_REFERENCE);        
    else
       --
       -- Resource was created using a REF XMLTYPE and the MAKEREF variant of DBMS_XDB.createResource
       --
      setXMLContent(DBMS_XDB.getRESOID(P_RESOURCE_PATH),P_XML_REFERENCE);
    end if;
    return 1;

  when others then
    raise;

end;
--  
function patchXMLReference(P_RESOURCE_PATH VARCHAR2, P_XML_REFERENCE CLOB) return number
as
  TABLE_NOT_FOUND exception;                        
  PRAGMA EXCEPTION_INIT( TABLE_NOT_FOUND , -00942 );

  V_SCHEMA_ELEMENT VARCHAR2(700);
  V_OWNER          VARCHAR2(30);
  V_TABLE_NAME     VARCHAR2(30);
  V_OID            RAW(16);
  V_XML_REFERENCE  REF XMLType;
  V_RESID          RAW(16);
begin
	select SCHEMA_ELEMENT, OWNER, TABLE_NAME, HEXTORAW(OID)
	  into V_SCHEMA_ELEMENT, V_OWNER, V_TABLE_NAME, V_OID
	  from XMLTABLE(
	         '/xmlReference'
	         passing XMLType(P_XML_REFERENCE)
	         columns
	         SCHEMA_ELEMENT VARCHAR2(700) path 'schemaElement',
	         OWNER          VARCHAR2(30)  path 'owner',
	         TABLE_NAME     VARCHAR2(30)  path 'table',
	         OID            VARCHAR2(32)  path 'OID'
	      );

    begin
		  execute immediate 'select ref(x)
	                         from "' || V_OWNER || '"."' || V_TABLE_NAME || '" x 
	                        where OBJECT_ID = ''' || V_OID || ''''
	       into V_XML_REFERENCE; 
    
    	return patchXMLReference(P_RESOURCE_PATH,V_SCHEMA_ELEMENT,V_XML_REFERENCE);
	       
	  exception
      when TABLE_NOT_FOUND then
        -- select RESID 
        -- into V_RESID 
        --  from RESOURCE_VIEW
        -- where equals_path(res,P_RESOURCE_PATH) = 1;
        -- 
        -- setXMLContent(V_RESID);
        -- setContent(P_RESOURCE_PATH, XMLTYPE(P_XML_REFERENCE).getBlobVal(nls_charset_id('AL32UTF8')));
        return 2;
    when NO_DATA_FOUND then
        -- select RESID 
        --  into V_RESID 
        --  from RESOURCE_VIEW
        -- where equals_path(res,P_RESOURCE_PATH) = 1;
  
        -- setXMLContent(V_RESID);
        -- setContent(P_RESOURCE_PATH, XMLTYPE(P_XML_REFERENCE).getBlobVal(nls_charset_id('AL32UTF8')));
        return 3;
    when OTHERS then
      RAISE;  
  end;
end;
--
function importLink(P_LINK_DEFINITION CLOB)
return number
is    
  V_LINK          XMLTYPE := XMLType(P_LINK_DEFINITION);
  V_LINK_PATH     VARCHAR2(4000) := V_LINK.extract('/LinkDescription/linkPath/text()').getStringVal();
  V_LINK_TARGET   VARCHAR2(4000) := V_LINK.extract('/LinkDescription/linkTarget/text()').getStringVal();
  V_LINK_TYPE     VARCHAR2(4000) := V_LINK.extract('/LinkDescription/linkType/text()').getStringVal();

  V_LINK_FOLDER   VARCHAR2(4000);
  V_LINK_NAME     VARCHAR2(4000);

  V_RESID         RAW(16);
  V_RESULT        NUMBER := -1;

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
  V_XDB_LINK_TYPE NUMBER := DBMS_XDB.LINK_TYPE_HARD;
$END

begin

  V_LINK_PATH   := getAbsolutePath(V_LINK_PATH);
  V_LINK_TARGET := getAbsolutePath(V_LINK_TARGET);
  
  V_LINK_FOLDER := substr(V_LINK_PATH,1,instr(V_LINK_PATH,'/',-1)-1);
  V_LINK_NAME   := substr(V_LINK_PATH,instr(V_LINK_PATH,'/',-1)+1);

  if (V_LINK_FOLDER is null) then
    V_LINK_FOLDER := '/';
  end if;

  if DBMS_XDB.existsResource(V_LINK_PATH) then
    V_RESULT := C_RESOURCE_UNCHANGED;
  else
    V_RESULT := C_RESOURCE_CREATED;
  end if;

  if (DBMS_XDB.existsResource(V_LINK_PATH)) then

    if (G_DUPLICATE_POLICY = XDB_CONSTANTS.SKIP) then
      return C_RESOURCE_UNCHANGED;
    end if;

    -- Delete the link if it already exists and points at the target document. This will enable coversion from HARD to SOFT or SOFT to HARD
        
    if ((G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) or (G_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION)) then
      --
      -- Delete the link if it already exists and points at the target document. This will enable coversion from HARD to SOFT or SOFT to HARD
      --
      begin
        select t.RESID
          into V_RESID
          from RESOURCE_VIEW l, RESOURCE_VIEW t
         where l.RESID = t.RESID
           and equals_path(l.RES,V_LINK_PATH) = 1 
           and equals_path(t.RES,V_LINK_TARGET) = 1;
           
         DBMS_XDB.deleteResource(V_LINK_PATH);         
         V_RESULT := C_RESOURCE_UPDATED;
      exception
        when no_data_found then 
          V_RESULT := C_RESOURCE_CREATED;
        when others then
          raise;
      end;
    end if; 
  
    if (G_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
      V_RESULT := C_RESOURCE_UPDATED;         
      --
      -- Delete any existing Link if it's one of multiple hard links or if it's a SOFT Link
      -- This will allow the link to be recreated.
      -- It is an error OVERWRITE the only HARD_LINK to a resource.
      --
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
      delete
        from PATH_VIEW 
       where equals_path(RES,V_LINK_PATH) = 1
         and existsNode(res,'/Resource[RefCount > 1]') = 1
    end if;
  end if;
  DBMS_XDB.link(V_LINK_TARGET,V_LINK_FOLDER,V_LINK_NAME);
$ELSE
      --
      -- Add Support for Weak links in 11.1.x. and later
      --
      delete
        from PATH_VIEW 
       where equals_path(RES,V_LINK_PATH) = 1
         and (existsNode(res,'/Resource[RefCount > 1]') = 1 
          or existsNode(link,'/Link[LinkType="WEAK"]') = 1);
    end if;
  end if;

  if (V_LINK_TYPE = 'WEAK') then
    V_XDB_LINK_TYPE := DBMS_XDB.LINK_TYPE_WEAK;
  end if;

  DBMS_XDB.link(V_LINK_TARGET,V_LINK_FOLDER,V_LINK_NAME,V_XDB_LINK_TYPE);
$END

  return V_RESULT;
end;
--
function matchPath(P_PATH_LIST XMLType)
return VARCHAR2
as
  cursor getExistingMapping
  is
  select pl.PATH 
    from XMLTABLE(
           '/paths'
           passing P_PATH_LIST
           COLUMNS
           ACLOID VARCHAR2(32) PATH '@ACLOID',
           PATHS  XMLTYPE      PATH '/paths/path'
        ) p,
        XMLTABLE(
           '/path'
           passing P.PATHS
           COLUMNS
           PATH VARCHAR2(700) PATH '.'
         ) pl
   where INSTR(pl.path,'/') = 1;

  cursor getRelativePath
  is
  select pl.PATH
    from XMLTABLE(
           '/paths'
           passing P_PATH_LIST
           COLUMNS
           ACLOID VARCHAR2(32) PATH '@ACLOID',
           PATHS  XMLTYPE      PATH '/paths/path'
        ) p,
        XMLTABLE(
           '/path'
           passing P.PATHS
           COLUMNS
           PATH VARCHAR2(700) PATH '.'
         ) pl
   where INSTR(pl.path,'/') <> 1
     and ROWNUM < 2;

begin

  -- Check if the target repository already contains an ACL that matches the location 
  -- of the ACL in the source repository. If a matching ACL exists in the target repository 
  -- create a Link between the ACL and the temporary ACL folder. 
  
  for p in getExistingMapping loop
    if (DBMS_XDB.existsResource(p.PATH)) then
      return p.PATH;
    end if;
  end loop;
 
  -- Check if the exported archive naturally includes the ACL. For this to be true
  -- the ACL was foldered underneath the target folder for the export operation. 
  -- This means that the folder structure that contained the ACL will be recreated 
  -- as part of the restore operation. 
  --
  -- TODO : Manage the partial Restore case. Ensure that the folder tree for the 
  -- ACL is also restored.
 
  for p in getRelativePath loop
    return p.PATH;
  end loop;
  
  -- The ACL does not exist in the target repository and is not naturally included in
  -- the archive. 
  
  -- return NULL indicating that the ACL does not exist in the target repository and will
  -- not exist after the import has completed. A new ACL will need to be created in /sys/acls.
  
  return null;

end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
--
procedure setPrintMode(P_PRINT_MODE NUMBER)
as
begin
  dbms_xdbutil_int.setPrintMode(1);
end;
--
procedure resetprintMode(P_PRINT_MODE NUMBER)
as
begin
  dbms_xdbutil_int.setPrintMode(0);
end;
--
procedure updateResource(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLTYPE)
as
  -- V_RESULT      BOOLEAN;
  -- V_RESOURCE_ID  RAW(16);
begin

  -- XDB_DEBUG.writeDebug('updateResource() : Resource Path = ' || P_RESOURCE_PATH);
  -- XDB_DEBUG.writeDebug(P_NEW_VALUES.getClobVal());

  update RESOURCE_VIEW
     set RES = P_NEW_VALUES
   where equals_path(RES,P_RESOURCE_PATH) = 1;
end;
--

$ELSE
--
procedure setPrintMode(P_PRINT_MODE number)
as
begin
  dbms_xdb_print.setPrintMode(P_PRINT_MODE);
end;
--
procedure clearPrintMode(P_PRINT_MODE number)
as
begin
  dbms_xdb_print.clearPrintMode(P_PRINT_MODE);
end;
--
procedure updateResource(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLTYPE)
is

  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESOURCE_DOCUMENT DBMS_XMLDOM.DOMDocument;
  V_UPDATE_DOCUMENT   DBMS_XMLDOM.DOMDocument;


  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
  V_UPDATE_ELEMENT    DBMS_XMLDOM.DOMElement;

  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_SOURCE_NODE       DBMS_XMLDOM.DOMNode;
  V_TARGET_NODE       DBMS_XMLDOM.DOMNode;
 
  V_NODE_MAP          DBMS_XMLDOM.DOMNamedNodeMap;
  
  V_NODE_NAME         VARCHAR2(512);
  
begin  
  V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
  V_RESOURCE_DOCUMENT := DBMS_XDBRESOURCE.makeDocument(V_RESOURCE);
  V_RESOURCE_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_RESOURCE_DOCUMENT);

  V_UPDATE_DOCUMENT   := DBMS_XMLDOM.newDOMDocument(P_NEW_VALUES);
  V_UPDATE_ELEMENT    := DBMS_XMLDOM.getDocumentElement(V_UPDATE_DOCUMENT);
  
  V_NODE_LIST := DBMS_XMLDOM.getChildNodes(dbms_xmldom.makeNode(V_UPDATE_ELEMENT));
  for i in 0..DBMS_XMLDOM.getLength(V_NODE_LIST) -1 loop
    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NODE_LIST,i);
    V_NODE_NAME := DBMS_XMLDOM.getNodeName(V_SOURCE_NODE);
    if (V_NODE_NAME in ('Contents','ACL','ACLOID','OwnerID','LastModifierID','CreatorID','Flags','ContentSize')) then
      null;
    else
      dbms_output.put_line('Processing Element : ' || V_NODE_NAME);
      V_TARGET_NODE := DBMS_XMLDOM.item(DBMS_XMLDOM.getElementsByTagName(V_RESOURCE_ELEMENT,V_NODE_NAME),0);
      DBMS_XMLDOM.setNodeValue(DBMS_XMLDOM.getFirstChild(V_TARGET_NODE),DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(V_SOURCE_NODE)));
    end if;
  end loop;  
  
  V_NODE_MAP := DBMS_XMLDOM.getAttributes(dbms_xmldom.makeNode(V_UPDATE_ELEMENT));
  for i in 0..DBMS_XMLDOM.getLength(V_NODE_MAP) -1 loop
    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NODE_MAP,i);
    V_NODE_NAME := DBMS_XMLDOM.getNodeName(V_SOURCE_NODE);
    if (DBMS_XMLDOM.getNodeName(V_SOURCE_NODE) in ('Container','SizeAccurate','IsVersionable','IsCheckedOut','IsVersion','IsVCR','IsWorkspace','IsXMLIndexed')) then
      null;
    else
      dbms_output.put_line('Processing Attribute : ' || V_NODE_NAME);
      DBMS_XMLDOM.setAttribute(V_RESOURCE_ELEMENT,V_NODE_NAME,DBMS_XMLDOM.getNodeValue(V_SOURCE_NODE));
    end if;
  end loop;
  
  DBMS_XDBRESOURCE.save(V_RESOURCE);

end;
--
procedure createResource(P_RESOURCE_PATH VARCHAR2,P_CONTENT_BLOB BLOB,P_DUPLICATE_POLICY VARCHAR2)
as
  V_RESULT            BOOLEAN;  
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,'/',-1) -1);
  V_RESID             RAW(16);
begin
  if (not DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT_BLOB);
    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
    return;
  end if;      

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) then
    -- Error will be thrown if item exists
    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT_BLOB);
    return;
  end if;
    
  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
    setContent(P_RESOURCE_PATH,P_CONTENT_BLOB);
    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
  end if;

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    V_RESOURCE_ELEMENT := DBMS_XMLDOM.getDocumentElement(DBMS_XDBRESOURCE.makeDocument(V_RESOURCE));
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsVersion') = 'false') then
      V_RESID := DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);
    end if;
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsCheckedOut') = 'true') then
      setContent(P_RESOURCE_PATH,P_CONTENT_BLOB);
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
    else
      DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);
      setContent(P_RESOURCE_PATH,P_CONTENT_BLOB);
      V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
    end if;	         
  end if;
end;
--
$END
--
procedure ZIP(P_PARAMETERS XMLType) 
as
--
--  public static void zip(XMLType parameterSettings)
--
LANGUAGE JAVA 
NAME 'com.oracle.st.xdb.pm.zip.ZipManager.zip ( oracle.xdb.XMLType )';
--
procedure UNZIP(P_ZIP_FILE_PATH VARCHAR2, P_LOG_FILE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DUPLICATE_ACTION VARCHAR2)
AS
--
--     public static void unzip(String zipFilePath, String logFilePath, String targetFolder,String duplicateAction) 
--
LANGUAGE JAVA 
NAME 'com.oracle.st.xdb.pm.zip.ZipManager.unzip ( java.lang.String, java.lang.String, java.lang.String, java.lang.String)';
--
procedure EXPORT(P_PARAMETERS XMLTYPE)
as
LANGUAGE JAVA 
NAME 'com.oracle.st.xdb.pm.zip.RepositoryExport.repositoryExport ( oracle.xdb.XMLType)';
--
procedure IMPORT(P_PARAMETERS XMLTYPE)
as
LANGUAGE JAVA 
NAME 'com.oracle.st.xdb.pm.zip.RepositoryImport.repositoryImport ( oracle.xdb.XMLType)';
--
function EXPORT_FILE_AS_SQL(P_RESOURCE_PATH VARCHAR2) 
return CLOB
as
  V_SCRIPT   CLOB;
  V_CONTENT  BLOB;
  V_BUFFER   RAW(40);
  V_LENGTH   NUMBER;
  V_AMOUNT   NUMBER(5) := 40;
  V_OFFSET   NUMBER := 1;

  V_COMMENT  VARCHAR2(256) := C_COMMENT || SYSTIMESTAMP || CHR(13) || CHR(10);
  V_LINE_04  VARCHAR2(256) := C_LINE_04 || '''' || P_RESOURCE_PATH || ''';' || CHR(13) || CHR(10);
  V_LINE_10  VARCHAR2(256);
begin
  select extractValue(res,'/Resource/XMLLob')
   into V_CONTENT
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1;

  DBMS_LOB.createTemporary(V_SCRIPT,FALSE);
  DBMS_LOB.writeAppend(V_SCRIPT,length(V_COMMENT),V_COMMENT);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_01),C_LINE_01);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_02),C_LINE_02);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_03),C_LINE_03);
  DBMS_LOB.writeAppend(V_SCRIPT,length(V_LINE_04),V_LINE_04);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_05),C_LINE_05);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_06),C_LINE_06);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_07),C_LINE_07);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_08),C_LINE_08);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_09),C_LINE_09);
  
  V_LENGTH := DBMS_LOB.getLength(V_CONTENT);
   
  while ((V_OFFSET + V_AMOUNT) <= V_LENGTH) loop
    V_BUFFER := DBMS_LOB.SUBSTR(V_CONTENT,V_AMOUNT,V_OFFSET);
    V_LINE_10 := C_LINE_10 || '''' || RAWTOHEX(V_BUFFER) || '''));' || CHR(13) || CHR(10);
    DBMS_LOB.writeAppend(V_SCRIPT,length(V_LINE_10),V_LINE_10);
    V_OFFSET := V_OFFSET + V_AMOUNT;
  end loop;
  
  V_AMOUNT := V_LENGTH - V_OFFSET +1;
  if (V_AMOUNT > 0) then
    V_BUFFER := DBMS_LOB.SUBSTR(V_CONTENT,V_AMOUNT,V_OFFSET);
    V_LINE_10 := C_LINE_10 || '''' || RAWTOHEX(V_BUFFER) || '''));' || CHR(13) || CHR(10);
    DBMS_LOB.writeAppend(V_SCRIPT,length(V_LINE_10),V_LINE_10);
  end if;
    
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_11),C_LINE_11);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_12),C_LINE_12);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_13),C_LINE_13);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_14),C_LINE_14);
  DBMS_LOB.writeAppend(V_SCRIPT,length(C_LINE_15),C_LINE_15);

  return V_SCRIPT;
end;
--
function EXPORT_FILES_AS_SQL(P_RESOURCE_LIST XDB.XDB$STRING_LIST_T)
return CLOB
as
  V_SCRIPT   CLOB;
begin
  DBMS_LOB.createTemporary(V_SCRIPT,FALSE);
  for i in 1..P_RESOURCE_LIST.count() loop
    DBMS_LOB.APPEND(V_SCRIPT,EXPORT_FILE_AS_SQL(P_RESOURCE_LIST(i)));
  end loop;
  return V_SCRIPT;
end;
--
function getVersionDetails(P_RESID RAW) 
return RESOURCE_EXPORT_TABLE_T pipelined
as
  V_RESOURCE_EXPORT_ROW RESOURCE_EXPORT_ROW_T;
begin
  select OBJECT_ID
        ,VERSION
        ,ACLOID
        ,RES
        ,XMLLOB
        ,TABLE_NAME
        ,OWNER 
        ,OBJECT_ID
   into V_RESOURCE_EXPORT_ROW.RESID,
        V_RESOURCE_EXPORT_ROW.VERSION,
        V_RESOURCE_EXPORT_ROW.ACLOID,
        V_RESOURCE_EXPORT_ROW.RES,
        V_RESOURCE_EXPORT_ROW.XMLLOB,
        V_RESOURCE_EXPORT_ROW.TABLE_NAME,
        V_RESOURCE_EXPORT_ROW.OWNER,
        V_RESOURCE_EXPORT_ROW.OBJECT_ID
   from TABLE(XDBPM.XDBPM_HELPER.getVersionDetails(P_RESID));
  pipe row (V_RESOURCE_EXPORT_ROW);
	return;
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
--