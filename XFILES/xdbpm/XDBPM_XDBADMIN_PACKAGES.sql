
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "as IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

/*
**
** These packages are installed in the XDBPM schema in 12.1 and later databases. They are granted XDBADMIN in order to allow them to bypass normal ACL based security.
** IN databsase 11.2.x and earlier the packages have to installed in the XDB schema, and set of facades are installed into the XDBPM_SCHEMA.
**
*/

--
create or replace package XDBPM_RV_HELPER
AUTHID &RIGHTS
as
  procedure deleteResource(P_RESOURCE_PATH VARCHAR2);
  procedure deleteResource(P_XMLREF REF XMLType);

  function existsResource(P_RESOURCE_PATH VARCHAR2) return BOOLEAN;
  function existsResource(P_XMLREF REF XMLType) return BOOLEAN;
  --
end;
/
show errors 
--
create or replace package body XDBPM_RV_HELPER
as
procedure deleteResource(P_RESOURCE_PATH VARCHAR2)
as
begin
 
  delete 
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <unlink-from/>
             </privilege>'
           )
         ) = 1;

end;
--
procedure deleteResource(P_XMLREF REF XMLType)
as
begin
 
  delete 
    from RESOURCE_VIEW
   where extractValue(res,'/Resource/XMLRef') = P_XMLREF
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <unlink-from/>
             </privilege>'
           )
         ) = 1;

end;  
--
function existsResource(P_RESOURCE_PATH VARCHAR2)
return BOOLEAN
as
  V_RESULT BOOLEAN := FALSE;
  V_TEMP   NUMBER;
begin
	select 1
	  into V_TEMP
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <read-properties/>
              <read-content/>
             </privilege>'
           )
         ) = 1;
  return TRUE;
exception
  when no_data_found then
    return FALSE;
  when others then
     RAISE;
end;
--
function existsResource(P_XMLREF REF XMLType)
return BOOLEAN
as
  V_RESULT BOOLEAN := FALSE;
  V_TEMP   NUMBER;
begin
	select 1
	  into V_TEMP
    from RESOURCE_VIEW
   where extractValue(res,'/Resource/XMLRef') = P_XMLREF
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <read-properties/>
              <read-content/>
             </privilege>'
           )
         ) = 1;
  return TRUE;
exception
  when no_data_found then
    return FALSE;
  when others then
     RAISE;
end;
--
end;
/
show errors
--
create or replace package XDBPM_RESCONFIG_HELPER
AUTHID &RIGHTS
as
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
  function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) return VARCHAR2;
$END
end;
/
show errors
--
create or replace package body XDBPM_RESCONFIG_HELPER
as
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
return VARCHAR2
as
  V_UPLOAD_FOLDER_PATH VARCHAR2(700);
begin
  select ANY_PATH 
    into V_UPLOAD_FOLDER_PATH
	  from RESOURCE_VIEW rv, 
	       XDB.XDB$RESCONFIG cfg,
	       XDB.XDB$RESOURCE r,
	       TABLE(r.XMLDATA.RCLIST.OID) rc
	 where rv.RESID = r.OBJECT_ID
	   and rc.COLUMN_VALUE = cfg.OBJECT_ID
	   and XMLExists
         (
           'declare namespace rc = "http://xmlns.oracle.com/xdb/XDBResConfig.xsd"; (::)
            declare namespace tu = "http:/xmlns.oracle.com/xdb/pm/tableUpload"; (::)
            $RC/rc:ResConfig/rc:applicationData/tu:Target[tu:Owner=$OWNER and tu:Table=$TABLE]'
            passing cfg.OBJECT_VALUE as "RC", P_OWNER as "OWNER", P_TABLE_NAME as "TABLE"
         );
         
  return V_UPLOAD_FOLDER_PATH;
end;
$END
--
end;
/
show errors
--
create or replace package XDBPM_UTILITIES_PRIVATE
AUTHID &RIGHTS
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
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
procedure doChangeOwner(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2)
as
  res BOOLEAN;
begin
  update resource_view
         set res = updateXml(res,'/Resource/Owner/text()',P_NEW_OWNER)
  where equals_path(res,P_RESOURCE_PATH) = 1;
end;
$END
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
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('XDBPM_UTILITIES_PRIVATE.changeOwner() : Processing ' || P_RESOURCE_PATH);
  XDB_OUTPUT.writeTraceFileEntry('XDBPM_UTILITIES_PRIVATE.changeOwner() : Recursive ' || XDBPM_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_RECURSIVE));
  XDB_OUTPUT.flushTraceFile();
$END

  for d in getTargetDocument loop
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeTraceFileEntry('XDBPM_UTILITIES_PRIVATE.changeOwner() : Versioned ' || d.IS_VERSIONED);
    XDB_OUTPUT.writeTraceFileEntry('XDBPM_UTILITIES_PRIVATE.changeOwner() : Folder ' || d.IS_FOLDER);
    XDB_OUTPUT.flushTraceFile();
$END
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
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeTraceFileEntry('XDBPM_UTILITIES_PRIVATE.changeOwner() : Processing Children ');
    XDB_OUTPUT.flushTraceFile();
$END

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
begin
	NULL;
$IF $$DEBUG $THEN
  XDB_OUTPUT.createTraceFile('/public/XDBPM_TRACE_FILE.log',TRUE);
$END
end;
/
set define on
--
show errors
--
