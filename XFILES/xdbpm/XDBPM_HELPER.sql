
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
$IF DBMS_DB_VERSION.VER_LE_11_2 $THEN
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
create or replace package XDBPM_UTILITIES_PRIVATE
as
  procedure createHomeFolder(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME);
  procedure createPublicFolder(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME);
  procedure setPublicIndexPageContent(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME);
  procedure createDebugFolders(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME);
end;
/
show errors
--  
set define off
--
-- & Characters is HTML Fragments..
--
create or replace package body XDBPM_UTILITIES_PRIVATE
as
--
procedure changeOwner(P_RESOURCE_PATH VARCHAR2, P_OWNER VARCHAR2, P_RECURSIVE BOOLEAN default false)
as

  -- Differs from 11g DBMS_XDB implementation that it automatically handles versioned documents...

  cursor getTargetDocument
  is
  select existsNode(RES,'/r:Resource/r:VCRUID',XDB_NAMESPACES.RESOURCE_PREFIX_R) IS_VERSIONED,
         existsNode(RES,'/r:Resource/@Container',XDB_NAMESPACES.RESOURCE_PREFIX_R) IS_FOLDER 
    from resource_view
   where equals_path(res,P_RESOURCE_PATH) = 1;
 
  cursor findChildren 
  is
  select ANY_PATH, 
         existsNode(RES,'/r:Resource/r:VCRUID',XDB_NAMESPACES.RESOURCE_PREFIX_R) IS_VERSIONED 
    from resource_view
   where under_path(res,P_RESOURCE_PATH) = 1
     and existsNode(res,'/r:Resource[r:Owner="' || P_OWNER || '"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 0;
     
   V_IS_CHECKED_OUT  BOOLEAN;
   V_IS_FOLDER       BOOLEAN;
   
   V_NEW_RESOURCE_ID RAW(16);
begin
  -- xdb_debug.writeDebug('XDBPM_HELPER.changeOwner() : Processing ' || P_RESOURCE_PATH);

  for d in getTargetDocument loop
    V_IS_FOLDER := d.IS_FOLDER = 1;
    if (d.IS_VERSIONED = 0) then
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
      doChangeOwner(P_RESOURCE_PATH,P_OWNER);
$ELSE
      XDBPM_DBMS_XDB.changeOwner(P_RESOURCE_PATH,P_OWNER);
$END
      commit;
    else
      V_IS_CHECKED_OUT := XDBPM_DBMS_XDB_VERSION.isCheckedOut(P_RESOURCE_PATH);
      if (not V_IS_CHECKED_OUT) then
        XDBPM_DBMS_XDB_VERSION.checkout(P_RESOURCE_PATH);
      end if;
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
      doChangeOwner(P_RESOURCE_PATH,P_OWNER);
$ELSE
      XDBPM_DBMS_XDB.changeOwner(P_RESOURCE_PATH,P_OWNER);
$END
      commit;
      if (not V_IS_CHECKED_OUT) then
        V_NEW_RESOURCE_ID  := XDBPM_DBMS_XDB_VERSION.checkin(P_RESOURCE_PATH);
      end if;
    end if;
  end loop;
    
  if (V_IS_FOLDER and P_RECURSIVE) then
    for c in findChildren loop
      -- xdb_debug.writeDebug('XDBPM_HELPER.changeOwner() : Processing ' || c.ANY_PATH);
      -- dbms_output.put_line('XDBPM_HELPER.changeOwner() : Processing ' || c.ANY_PATH);
      if (c.IS_VERSIONED = 0) then
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
        doChangeOwner(c.ANY_PATH,P_OWNER);
$ELSE
        XDBPM_DBMS_XDB.changeOwner(c.ANY_PATH,P_OWNER);
$END
        commit;
      else
        V_IS_CHECKED_OUT := XDBPM_DBMS_XDB_VERSION.isCheckedOut(c.ANY_PATH);
        if (not V_IS_CHECKED_OUT) then
          XDBPM_DBMS_XDB_VERSION.checkout(c.ANY_PATH);
        end if;
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
        doChangeOwner(c.ANY_PATH,P_OWNER);
$ELSE
        XDBPM_DBMS_XDB.changeOwner(c.ANY_PATH,P_OWNER);
$END
        commit;
        if (not V_IS_CHECKED_OUT) then
          V_NEW_RESOURCE_ID  := XDBPM_DBMS_XDB_VERSION.checkin(c.ANY_PATH);
        end if;
      end if;
    end loop;
  end if;

end;
--
procedure createFolder(P_FOLDER_PATH VARCHAR2, P_OWNER VARCHAR2, P_ACL_PATH VARCHAR2)
as
  res BOOLEAN;
begin
  res := XDBPM_DBMS_XDB.createFolder(P_FOLDER_PATH);
  XDBPM_DBMS_XDB.changeOwner(P_FOLDER_PATH,P_OWNER);
  XDBPM_DBMS_XDB.setAcl(P_FOLDER_PATH,P_ACL_PATH);
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 
$THEN
--
procedure setComment(P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2)
as 
begin
  begin
    update RESOURCE_VIEW 
       set res = insertChildXML
                 (
                   res,
                   '/Resource',
                   'Comment',
                   xmlelement("Comment",'Contains home folder for each XDB User.')
                 )
      where equals_path(res,P_RESOURCE_PATH) = 1
         and existsNode(res,'/Resource/Comment') = 0;
  exception 
    when no_data_found then
      update RESOURCE_VIEW 
         set res = updateXML
                   (
                     res,
                     '/Resource/Comment',
                     xmlelement("Comment",'Contains home folder for each XDB User.')
                   )
       where equals_path(res,P_RESOURCE_PATH) = 1
         and existsNode(res,'/Resource/Comment') = 1;
  end;
end;
--
$ELSE  
--
procedure setComment(P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2)
as
  res dbms_xdbResource.xdbResource;
begin
  res := XDBPM_DBMS_XDB.getResource(P_RESOURCE_PATH);
  XDBPM_DBMS_XDBRESOURCE.setComment(res,P_COMMENT);
  XDBPM_DBMS_XDBRESOURCE.save(res);
end;
--  
$END
--
procedure createHomeFolder(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME)
as
  V_PRINCIPLE_NAME   VARCHAR2(32) := upper(P_PRINCIPLE);
  V_TARGET_FOLDER    VARCHAR2(700) := XDB_CONSTANTS.FOLDER_HOME || '/'  || V_PRINCIPLE_NAME;
  V_RESULT           BOOLEAN;
begin
    
  --
  -- Create the Global Home Folder if necessary
  --

  if (not XDBPM_DBMS_XDB.existsResource(XDB_CONSTANTS.FOLDER_HOME)) then
    createFolder(XDB_CONSTANTS.FOLDER_HOME,'SYS','/sys/acls/bootstrap_acl.xml');
    setComment(XDB_CONSTANTS.FOLDER_HOME,'Container for all home folders.');
  end if;
   
  --
  -- Create the User's Home Folder if necessary
  --

  if (not XDBPM_DBMS_XDB.existsResource(V_TARGET_FOLDER)) then
    createFolder(V_TARGET_FOLDER,V_PRINCIPLE_NAME,'/sys/acls/all_owner_acl.xml');
    setComment(V_TARGET_FOLDER,'Home folder for user : ' || V_PRINCIPLE_NAME);
  end if;
  
  --
  -- Ensure the User's Home Folder is protected with the ALL to Owner / Nothing to Others ACL
  --

  XDBPM_DBMS_XDB.setAcl(V_TARGET_FOLDER,'/sys/acls/all_owner_acl.xml');

  --
  -- Ensure the User owns their Home folder and all of its content
  --

  -- dbms_output.put_line('createHomeFolder() : Changing ownership of all documents contained ' || V_TARGET_FOLDER);
  changeOwner(V_TARGET_FOLDER, V_PRINCIPLE_NAME, true);
  
end;
--
function getPublicIndexPageContent(P_PRINCIPLE VARCHAR2) 
return VARCHAR2
as
begin
/*
  select xmlElement
         (
           "html",
           xmlattributes('http://www.w3.org/1999/xhtml' as "xmlns"),
           xmlElement
           (
             "head",
             xmlElement("title",'Welcome to the public folder of ' || P_PRINCIPLE),
             xmlElement
             (
               "meta",
               xmlattributes
               (
                 'refresh' as "http-equiv", 
                 '0;url=/sys/servlets/XFILES/FolderProcessor?xmldoc=' || XDB_CONSTANTS.FOLDER_PUBLIC || '/' || P_PRINCIPLE || '&listDir=true&xsldoc=/XFILES/xsl/FolderBrowser.xsl&contentType=text/html' as "content"
               )
             ),
             xmlElement
             (
               "link",
               xmlAttributes
               (
                 'stylesheet' as "rel",
                 'UTF-8' as "charset",
                 'text/css' as "type",
                 '/XFILES/lib/css/xdb-en-ie-6.css' as "href"
               )
             )
           ),
           xmlElement
           (
             "body",
             xmlElement("p",'Welcome to the public folder of ' || P_PRINCIPLE)
           )
         ).getClobVal()
    into V_INDEX_PAGE_XHTML
    from dual;
*/
return 
'<html>
	<head>
		<title>Welcome to the Published Page of ' || P_PRINCIPLE || '.</title>
		<script language="javascript">
		  function doRedirect() {
   		    window.location.href = "/XFILES/lite/Folder.html?target=" + escape("' || XDB_CONSTANTS.FOLDER_PUBLIC || '/' || P_PRINCIPLE || '");
		  }
		</script>
	</head>
	<body onload="doRedirect()">
	</body>
</html>';
end;
--
procedure createPublicFolder(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME)
as
  V_PRINCIPLE_NAME    VARCHAR2(32)  := upper(P_PRINCIPLE);
  V_HOME_FOLDER       VARCHAR2(700) := XDB_CONSTANTS.FOLDER_HOME || '/'  || V_PRINCIPLE_NAME;
  V_PUBLIC_FOLDER     VARCHAR2(700) := V_HOME_FOLDER || '/publishedContent';
  V_PUBLIC_URL        VARCHAR2(700) := '/XFILES/' || V_PRINCIPLE_NAME;
  V_PUBLISHED_FOLDER  VARCHAR2(700) := XDB_CONSTANTS.FOLDER_PUBLIC || '/'  || V_PRINCIPLE_NAME;
  V_INDEX_PAGE        VARCHAR2(700) := V_PUBLIC_FOLDER || '/index.html';
  V_RESULT            BOOLEAN;
  V_INDEX_PAGE_XHTML  CLOB; 
begin

  -- Ensure the user has a home folder.

  if not XDBPM_DBMS_XDB.existsResource(V_HOME_FOLDER) then
    createHomeFolder(V_PRINCIPLE_NAME); 
  end if;
  
  --
  -- Create a 'Public' folder for all users.
  --
  
  if (not XDBPM_DBMS_XDB.existsResource(XDB_CONSTANTS.FOLDER_PUBLIC)) then
    createFolder(XDB_CONSTANTS.FOLDER_PUBLIC,'SYS','/sys/acls/bootstrap_acl.xml');
    setComment(XDB_CONSTANTS.FOLDER_PUBLIC,'Container for links to all public folders.');
  end if;
  
  -- Create a 'Public' folder for the specified user
   
  if (not XDBPM_DBMS_XDB.existsResource(V_PUBLIC_FOLDER)) then
    createFolder(V_PUBLIC_FOLDER,V_PRINCIPLE_NAME,'/sys/acls/bootstrap_acl.xml');
    setComment(V_PUBLIC_FOLDER,'Public folder for user : ' || V_PRINCIPLE_NAME);
  end if;

  --
  -- Ensure the User's Public Folder is protected with the ALL to Owner / Read Only to Others ACL
  --

  XDBPM_DBMS_XDB.setAcl(V_PUBLIC_FOLDER,'/sys/acls/bootstrap_acl.xml');

  -- Create an index.html for the public Folder
  
  if (XDBPM_DBMS_XDB.existsResource(V_INDEX_PAGE)) then
    XDBPM_DBMS_XDB.deleteResource(V_INDEX_PAGE,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end if;
 
  V_RESULT := XDBPM_DBMS_XDB.createResource(V_INDEX_PAGE,getPublicIndexPageContent(V_PRINCIPLE_NAME));

  --
  -- Ensure the User owns their Public folder and all of its content
  --

  changeOwner(V_PUBLIC_FOLDER, V_PRINCIPLE_NAME, true);

  -- Publish the public Folder 
  
  if (XDBPM_DBMS_XDB.existsResource(V_PUBLISHED_FOLDER)) then
    XDBPM_DBMS_XDB.deleteResource(V_PUBLISHED_FOLDER,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end if;
 
  XDBPM_DBMS_XDB.link(V_PUBLIC_FOLDER,XDB_CONSTANTS.FOLDER_PUBLIC,V_PRINCIPLE_NAME);

end;
--
procedure setPublicIndexPageContent(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME)
as
  V_INDEX_PAGE_PATH   VARCHAR(1024) := XDB_CONSTANTS.FOLDER_HOME || '/' || P_PRINCIPLE || XDB_CONSTANTS.FOLDER_PUBLIC || '/index.html';
  V_RESULT            BOOLEAN;
begin

  -- Create Index.html for the public Folder

  if (XDBPM_DBMS_XDB.existsResource(V_INDEX_PAGE_PATH)) then
    XDBPM_DBMS_XDB.deleteResource(V_INDEX_PAGE_PATH,DBMS_XDB.DELETE_FORCE);
  end if;
 
  V_RESULT := XDBPM_DBMS_XDB.createResource(V_INDEX_PAGE_PATH,getPublicIndexPageContent(P_PRINCIPLE));
  changeOwner(V_INDEX_PAGE_PATH,P_PRINCIPLE);
end;
--
procedure createDebugFolders(P_PRINCIPLE VARCHAR2 default XDB_USERNAME.GET_USERNAME)
as
  V_PRINCIPLE_NAME   VARCHAR2(32) := upper(P_PRINCIPLE);
  V_DEBUG_FOLDER     VARCHAR2(700) := XDB_CONSTANTS.FOLDER_DEBUG || '/'  || V_PRINCIPLE_NAME;
  V_TRACE_FOLDER     VARCHAR2(700) := V_DEBUG_FOLDER || '/traceFiles';
  V_LOG_FOLDER       VARCHAR2(700) := V_DEBUG_FOLDER || '/logFiles';
  V_RESULT           BOOLEAN;
begin
    
  --
  -- Create the Global Debug Folder if necessary
  --

  if (not XDBPM_DBMS_XDB.existsResource(XDB_CONSTANTS.FOLDER_DEBUG)) then
    createFolder(XDB_CONSTANTS.FOLDER_DEBUG,'SYS','/sys/acls/bootstrap_acl.xml');
    setComment(XDB_CONSTANTS.FOLDER_DEBUG,'Container for all debugging and trace files.');
  end if;
   
  --
  -- Create the User's Debug Folder if necessary
  -- Ensure the User owns their Home folder and all of its content
  -- Ensure the User's Debug Folder is protected with the ALL to Owner / Nothing to Others ACL
  --

  if (not XDBPM_DBMS_XDB.existsResource(V_DEBUG_FOLDER)) then
    createFolder(V_DEBUG_FOLDER,V_PRINCIPLE_NAME,'/sys/acls/all_owner_acl.xml');
    setComment(V_DEBUG_FOLDER,'Logging and Trace files for user : ' || V_PRINCIPLE_NAME);
  else
    changeOwner(V_DEBUG_FOLDER,V_PRINCIPLE_NAME,TRUE);
  end if;
  
  XDBPM_DBMS_XDB.setAcl(V_DEBUG_FOLDER,'/sys/acls/all_owner_acl.xml');

  if (not XDBPM_DBMS_XDB.existsResource(V_TRACE_FOLDER)) then
    createFolder(V_TRACE_FOLDER,V_PRINCIPLE_NAME,'/sys/acls/all_owner_acl.xml');
    setComment(V_TRACE_FOLDER,'Trace files for user : ' || V_PRINCIPLE_NAME);
  end if;
  
  if (not XDBPM_DBMS_XDB.existsResource(V_LOG_FOLDER)) then
    createFolder(V_LOG_FOLDER,V_PRINCIPLE_NAME,'/sys/acls/all_owner_acl.xml');
    setComment(V_LOG_FOLDER,'Application Log files for user : ' || V_PRINCIPLE_NAME);
  end if;
  
end;
--
end;
/
show errors
--
set define on
--
create or replace package XDBPM_HELPER
AUTHID DEFINER
as

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
    
  procedure resetLobLocator(P_RESID RAW);
  procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER);
  procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER);
  procedure setXMLContent(P_RESID RAW);
  procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE);
  procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER);

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
	sys.dbms_system.KSDFLS;
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
procedure resetLobLocator(P_RESID RAW)
is
begin
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob()
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER)
is
begin
  -- dbms_output.put_line('Creating Binary Content');
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_BINARY_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER)
is
begin
  -- dbms_output.put_line('Creating Text Content');
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_TEXT_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setXMLContent(P_RESID RAW)
is
begin
  -- dbms_output.put_line('Creating NSB XML Content');
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.XMLLOB = empty_blob(),
         r.XMLDATA.SCHOID = NULL,
         r.XMLDATA.ELNUM  = NULL
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE)
is
begin
  -- dbms_output.put_line('Creating SB XML Content');
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_RESID             = ' || P_RESID);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_XMLREF            = ' || P_XMLREF);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_SCHEMA_OID        = ' || P_SCHEMA_OID);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_GLOBAL_ELEMENT_ID = ' || P_GLOBAL_ELEMENT_ID);
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
end;
--
procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER)
is
begin
  -- dbms_output.put_line('Creating SB XML Content');
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_RESID             = ' || P_RESID);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_XMLREF            = ' || P_XMLREF);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_SCHEMA_OID        = ' || P_SCHEMA_OID);
  -- dbms_output.put_line('xdb_helper.setSBXMLContent() : P_GLOBAL_ELEMENT_ID = ' || P_GLOBAL_ELEMENT_ID);
  update XDB.XDB$RESOURCE r
     set r.XMLDATA.xmlref = P_XMLREF,
         r.XMLDATA.SCHOID = P_SCHEMA_OID,
         r.XMLDATA.ELNUM  = P_GLOBAL_ELEMENT_ID
   where OBJECT_ID = P_RESID
     and r.XMLDATA.XMLLOB is null;
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
	createTraceFileDirectory;
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

