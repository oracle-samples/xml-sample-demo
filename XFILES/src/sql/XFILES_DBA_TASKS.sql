
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

set echo on
spool XFILES_DBA_TASKS.log
--
def XFILES_SCHEMA = &1
--
--
begin
	XDB_OUTPUT.createLogFile('/public/xFilesInstallation.log',TRUE);
	XDB_OUTPUT.writeLogFileEntry('Start: XFILES_DBA_TASKS.sql');
	XDB_OUTPUT.writeLogFileEntry('XFILES_SCHEMA = &XFILES_SCHEMA');
	XDB_OUTPUT.flushLogFile();
end;
/
--
-- Enable Anonymous access to XML DB Repository
--
ALTER SESSION SET XML_DB_EVENTS = DISABLE
/
alter user anonymous account unlock
/
call xdb_configuration.setAnonymousAccess('true')
/
--
-- Enable use of Unified Java API for all users on NT...
--
call dbms_java.grant_permission('PUBLIC','SYS:oracle.aurora.rdbms.security.PolicyTablePermission','0:java.lang.RuntimePermission#loadLibrary.oraxml11',null)
/
call dbms_java.grant_permission('PUBLIC','SYS:java.lang.RuntimePermission','loadLibrary.oraxml11',null)
/
--
-- Delete and Install the Servlets
--
call dbms_xdb.deleteServletMapping('SelectionProcessor')
/
call dbms_xdb.deleteServletMapping('VersionResources')
/
call dbms_xdb.deleteServletMapping('VersionHistory')
/
call dbms_xdb.deleteServletMapping('UploadFiles')
/
call dbms_xdb.deleteServletMapping('FolderProcessor')
/
call dbms_xdb.deleteServletMapping('NewFolder')
/
call dbms_xdb.deleteServletMapping('XDBReposSearch')
/
call dbms_xdb.deleteServletMapping('XMLRefProcessor')
/
call dbms_xdb.deleteServlet('SelectionProcessor')
/
call dbms_xdb.deleteServlet('VersionResources')
/
call dbms_xdb.deleteServlet('VersionHistory')
/
call dbms_xdb.deleteServlet('UploadFiles')
/
call dbms_xdb.deleteServlet('FolderProcessor')
/
call dbms_xdb.deleteServlet('NewFolder')
/
call dbms_xdb.deleteServlet('XDBReposSearch')
/
call dbms_xdb.deleteServlet('XMLRefProcessor')
/
call dbms_xdb.deleteServlet('XFilesServlet')
/
--
declare
  non_existant_dad exception;
  PRAGMA EXCEPTION_INIT( non_existant_dad , -24231 );
begin
--
  dbms_epg.drop_dad('XFILESUPLOAD');
exception
  when non_existant_dad  then
    null;
end;
/
begin
  dbms_epg.create_dad('XFILESUPLOAD','/sys/servlets/&XFILES_SCHEMA/FileUpload/*');
  dbms_epg.set_dad_attribute('XFILESUPLOAD','document-table-name','&XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE');
  dbms_epg.set_dad_attribute('XFILESUPLOAD','nls-language','american_america.al32utf8');
end;
/
begin
  dbms_epg.create_dad('XFILESREST','/sys/servlets/&XFILES_SCHEMA/RestService/*');
  dbms_epg.set_dad_attribute('XFILESREST','database-username','ANONYMOUS');
end;
/
begin
  dbms_epg.create_dad('XFILESAUTH','/sys/servlets/&XFILES_SCHEMA/Protected/*');
end;
/
call DBMS_XDB.DELETESERVLET(NAME => 'orawsv')
/
call DBMS_XDB.DELETESERVLETMAPPING(NAME => 'orawsv')
/
call DBMS_XDB.DELETESERVLETSECROLE(SERVNAME  => 'orawsv', ROLENAME  => 'XDB_WEBSERVICES' ) 
/    
call DBMS_XDB.ADDSERVLETMAPPING(PATTERN => '/orawsv/*', NAME    => 'orawsv')
/
call DBMS_XDB.ADDSERVLET(
        NAME     => 'orawsv',
        LANGUAGE => 'C',
        DISPNAME => 'Oracle Database Native Web Services',
        DESCRIPT => 'Servlet for issuing queries as a Web Service'
     )
/
call DBMS_XDB.ADDSERVLETSECROLE(
   SERVNAME  => 'orawsv',               
   ROLENAME  => 'XDB_WEBSERVICES',
   ROLELINK  => 'XDB_WEBSERVICES'
)     
/
call DBMS_XDB.addMimeMapping('sql','text/plain')
/
call DBMS_XDB.addMimeMapping('log','text/plain')
/
call DBMS_XDB.addMimeMapping('ctl','text/plain')
/
call DBMS_XDB.addMimeMapping('exif','text/xml')
/
call DBMS_XDB.addMimeMapping('doc', 'application/msword')
/
call DBMS_XDB.addMimeMapping('dot', 'application/msword')
/
call DBMS_XDB.addMimeMapping('docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document')
/
call DBMS_XDB.addMimeMapping('dotx','application/vnd.openxmlformats-officedocument.wordprocessingml.template')
/
call DBMS_XDB.addMimeMapping('docm','application/vnd.ms-word.document.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('dotm','application/vnd.ms-word.template.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('xls', 'application/vnd.ms-excel')
/
call DBMS_XDB.addMimeMapping('xlt', 'application/vnd.ms-excel')
/
call DBMS_XDB.addMimeMapping('xla', 'application/vnd.ms-excel')
/
call DBMS_XDB.addMimeMapping('xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
/
call DBMS_XDB.addMimeMapping('xltx','application/vnd.openxmlformats-officedocument.spreadsheetml.template')
/
call DBMS_XDB.addMimeMapping('xlsm','application/vnd.ms-excel.sheet.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('xltm','application/vnd.ms-excel.template.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('xlam','application/vnd.ms-excel.addin.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('xlsb','application/vnd.ms-excel.sheet.binary.macroEnabled.12')
/                                   
call DBMS_XDB.addMimeMapping('ppt', 'application/vnd.ms-powerpoint')
/
call DBMS_XDB.addMimeMapping('pot', 'application/vnd.ms-powerpoint')
/
call DBMS_XDB.addMimeMapping('pps', 'application/vnd.ms-powerpoint')
/
call DBMS_XDB.addMimeMapping('ppa', 'application/vnd.ms-powerpoint')
/                                   
call DBMS_XDB.addMimeMapping('pptx','application/vnd.openxmlformats-officedocument.presentationml.presentation')
/
call DBMS_XDB.addMimeMapping('potx','application/vnd.openxmlformats-officedocument.presentationml.template')
/
call DBMS_XDB.addMimeMapping('ppsx','application/vnd.openxmlformats-officedocument.presentationml.slideshow')
/
call DBMS_XDB.addMimeMapping('ppam','application/vnd.ms-powerpoint.addin.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('pptm','application/vnd.ms-powerpoint.presentation.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('potm','application/vnd.ms-powerpoint.template.macroEnabled.12')
/
call DBMS_XDB.addMimeMapping('ppsm','application/vnd.ms-powerpoint.slideshow.macroEnabled.12')
/
commit
/
@@XFILES_DROP_OLD_OBJECTS
--
declare 
  XFILES_ROOT                  VARCHAR2(700) := '/XFILES';
  XFILES_HOME                  VARCHAR2(700) := '/home/&XFILES_SCHEMA';
                             
  WHOAMI_DOCUMENT              VARCHAR2(700) := XFILES_ROOT || '/whoami.xml';
  AUTH_STATUS_DOCUMENT         VARCHAR2(700) := XFILES_ROOT || '/authenticationStatus.xml';
  UNAUTHENTICATED_DOCUMENT     VARCHAR2(700) := XFILES_ROOT || '/unauthenticated.xml';
                             
  FOLDER_RESCONFIG_ARCHIVE     VARCHAR2(700) := '/sys/resConfig/XFILES/xfilesRedirect';

  ACL_ALLOW_XFILES_USERS       VARCHAR2(700) := XFILES_HOME || '/src/acls/xfilesUserAcl.xml';
  ACL_DENY_XFILES_USERS        VARCHAR2(700) := XFILES_HOME || '/src/acls/denyXFilesUserAcl.xml';

  XMLINDEX_LIST                VARCHAR2(700) := XFILES_HOME || '/configuration/xmlIndex/xmlIndexList.xml';
  XMLSCHEMA_LIST               VARCHAR2(700) := XFILES_HOME || '/configuration/xmlSchema/xmlSchemaList.xml';
  XMLSCHEMA_OBJ_LIST           VARCHAR2(700) := XFILES_HOME || '/configuration/xmlSchema/xmlSchemaObjectList.xml';
                             
  V_RESULT                     BOOLEAN;
  V_COUNTER                    NUMBER;
  V_TARGET_NAME                VARCHAR2(4000);

  cursor getAclUsage(C_ACL_PATH VARCHAR2)
  is
  select r.ANY_PATH RESOURCE_PATH
    from XDB.RESOURCE_VIEW r, RESOURCE_VIEW ar
   where equals_path(ar.res,C_ACL_PATH) = 1
     and XMLCast(
           XMLQuery(
             'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
              $RES/Resource/ACLOID'
              passing r.RES as "RES"
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

  cursor getResConfigUsage(C_FOLDER_PATH VARCHAR2)
  is             
  select RV.ANY_PATH RESOURCE_PATH, RCRV.ANY_PATH RESCONFIG_PATH
    from RESOURCE_VIEW RV, RESOURCE_VIEW rcrv,
         XMLTable(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             OBJECT_ID RAW(16) path '.'
         ) rce
   where XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList' 
           passing rv.RES as "R"
         )
     and under_path(rcrv.RES,C_FOLDER_PATH) = 1
     and under_path(rv.RES,C_FOLDER_PATH) = 1
     and SYS_OP_R2O(
           XMLCast(
             XMLQuery(
               'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                fn:data($RES/Resource/XMLRef)'
                passing rcrv.RES as "RES"
                returning content
              ) as REF XMLType
            )
          ) = rce.OBJECT_ID;
          
  cursor getResConfigsInUse(C_FOLDER_PATH VARCHAR2)
  is             
  select distinct(RCRV.ANY_PATH) RESCONFIG_PATH
    from RESOURCE_VIEW RV, XDB.XDB$RESCONFIG rc, RESOURCE_VIEW rcrv,
         XMLTable(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             OBJECT_ID RAW(16) path '.'
         ) rce
   where XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList' 
           passing rv.RES as "R"
         )
     and under_path(rcrv.RES,C_FOLDER_PATH) = 1
     and rc.OBJECT_ID = rce.OBJECT_ID
     and SYS_OP_R2O(
           XMLCast(
             XMLQuery(
               'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                fn:data($RES/Resource/XMLRef)'
                passing rcrv.RES as "RES"
                returning content
              ) as REF XMLType
            )
          ) = rc.OBJECT_ID;
          
   cursor getRepositoryResConfigs(C_FOLDER_PATH VARCHAR2) 
   is
   select POSITION, RESCONFIG_PATH
     from (
       select (ROWNUM-1) POSITION, COLUMN_VALUE RESCONFIG_PATH
         from TABLE(
                DBMS_RESCONFIG.getRepositoryResConfigPaths()
              )
       )
    where RESCONFIG_PATH like C_FOLDER_PATH || '%';
                
begin
 
	if DBMS_XDB.existsResource(XMLINDEX_LIST) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || XMLINDEX_LIST);
    XDB_OUTPUT.flushLogFile();
    dbms_xdb.deleteResource(XMLINDEX_LIST,DBMS_XDB.DELETE_FORCE);
  end if;
  commit;

	if DBMS_XDB.existsResource(XMLSCHEMA_LIST) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || XMLSCHEMA_LIST);
    XDB_OUTPUT.flushLogFile();
    dbms_xdb.deleteResource(XMLSCHEMA_LIST,DBMS_XDB.DELETE_FORCE);
  end if ;
  commit;

	if DBMS_XDB.existsResource(XMLSCHEMA_OBJ_LIST) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || XMLSCHEMA_OBJ_LIST);
    XDB_OUTPUT.flushLogFile();
    dbms_xdb.deleteResource(XMLSCHEMA_OBJ_LIST,DBMS_XDB.DELETE_FORCE);
  end if ;
  commit;

  if (DBMS_XDB.existsResource(UNAUTHENTICATED_DOCUMENT)) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || UNAUTHENTICATED_DOCUMENT);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.deleteResource(UNAUTHENTICATED_DOCUMENT);
  end if;  
  commit;

  if (DBMS_XDB.existsResource(WHOAMI_DOCUMENT)) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || WHOAMI_DOCUMENT);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.deleteResource(WHOAMI_DOCUMENT);
  end if;  
  commit;

  if (DBMS_XDB.existsResource(AUTH_STATUS_DOCUMENT)) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || AUTH_STATUS_DOCUMENT);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.deleteResource(AUTH_STATUS_DOCUMENT);
  end if;  
  commit;

  -- Remove Repository Resource configurations under /XFILES
  XDB_OUTPUT.writeLogFileEntry('Delete Repository Resconfig under ' || XFILES_ROOT);
  XDB_OUTPUT.flushLogFile();

  for r in getRepositoryResConfigs(XFILES_ROOT) loop
    XDB_OUTPUT.writeLogFileEntry(r.RESCONFIG_PATH);
    DBMS_RESCONFIG.deleteRepositoryResConfig(r.POSITION);
    XDB_OUTPUT.flushLogFile();
  end loop;
  commit;

  -- Remove Repository Resource configurations under /home/XFILES
  XDB_OUTPUT.writeLogFileEntry('Delete Repository Resconfig under ' || XFILES_HOME);
  XDB_OUTPUT.flushLogFile();

  for r in getRepositoryResConfigs(XFILES_HOME) loop
    DBMS_RESCONFIG.deleteRepositoryResConfig(r.POSITION);
    XDB_OUTPUT.flushLogFile();
    DBMS_RESCONFIG.deleteRepositoryResConfig(r.POSITION);
  end loop;
  commit;

  XDB_OUTPUT.writeLogFileEntry('Delete  Resconfig under ' || XFILES_HOME);
  XDB_OUTPUT.flushLogFile();
	
  -- Remove Resource configurations from any documents under /home/XFILES that are protected by Resource Configurations under /home/XFILES

  for r in getResConfigUsage(XFILES_HOME) loop
    XDB_OUTPUT.writeLogFileEntry(r.RESCONFIG_PATH);
    XDB_OUTPUT.flushLogFile();
    DBMS_RESCONFIG.deleteResConfig(r.RESOURCE_PATH,r.RESCONFIG_PATH,DBMS_RESCONFIG.DELETE_RESOURCE );
  end loop;
  commit;

  -- Move any Resource Configurations that protect resources outside of /home/XFILES into an archive folder 
  -- outside of /home/XFILES  


  XDB_UTILITIES.mkdir(FOLDER_RESCONFIG_ARCHIVE,TRUE);
  XDB_OUTPUT.writeLogFileEntry('Moving Resconfigs under ' || XFILES_HOME  || ' to ' || FOLDER_RESCONFIG_ARCHIVE);
  XDB_OUTPUT.flushLogFile();

  V_COUNTER := 0;
  for r in getResConfigsInUse(XFILES_HOME) loop
    V_COUNTER := V_COUNTER + 1;
    V_TARGET_NAME := 'resConfig-' || to_char(systimestamp,'YYYY-MM-DD"T"HH24MISS') || '.' || LPAD(V_COUNTER,3,'0') || '.xml';
    XDB_OUTPUT.writeLogFileEntry(r.RESCONFIG_PATH || ' --> ' || V_TARGET_NAME);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.renameResource(r.RESCONFIG_PATH, FOLDER_RESCONFIG_ARCHIVE, V_TARGET_NAME);
  end loop;
  commit;

  XDB_OUTPUT.writeLogFileEntry('Free ACL:' || ACL_ALLOW_XFILES_USERS);
  XDB_OUTPUT.flushLogFile();
  XDB_UTILITIES.freeAcl(ACL_ALLOW_XFILES_USERS,'/sys/acls/all_owner_acl.xml');

  XDB_OUTPUT.writeLogFileEntry('Free ACL:' || ACL_DENY_XFILES_USERS);
  XDB_OUTPUT.flushLogFile();
  XDB_UTILITIES.freeAcl(ACL_DENY_XFILES_USERS,'/sys/acls/all_owner_acl.xml');
    
  
  /*
  **
  ** Fixed 11.2.0.3.0
  **
  ** -- Workaround for bug 9866493.
  **
  ** if (DBMS_XDB.existsResource('/home/XFILES/plugins/Xinha')) then
  **   DBMS_XDB.deleteResource('/home/XFILES/plugins/Xinha');
  ** end if;
  ** commit;
  **
  */
  
  -- End Workaround

  if (DBMS_XDB.existsResource(XFILES_ROOT)) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || XFILES_ROOT);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.deleteResource(XFILES_ROOT,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end if;
  commit;
  
	if DBMS_XDB.existsResource(XFILES_HOME) then
    XDB_OUTPUT.writeLogFileEntry('Delete: ' || XFILES_HOME);
    XDB_OUTPUT.flushLogFile();
    DBMS_XDB.deleteResource(XFILES_HOME,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end if ;
  commit;
  
	XDB_OUTPUT.writeLogFileEntry('Create: ' || XFILES_HOME);
  XDB_OUTPUT.flushLogFile();
  V_RESULT := DBMS_XDB.createFolder(XFILES_ROOT);
  DBMS_XDB.setAcl(XFILES_ROOT,'/sys/acls/bootstrap_acl.xml');
  DBMS_XDB.changeOwner(XFILES_ROOT,'&XFILES_SCHEMA');
  commit;

end;
/
column LOG format A240
set pages 100 lines 250 trimspool on
set long 1000000
--
select xdburitype('/public/xFilesInstallation.log').getClob() LOG
  from dual
/
select PATH
  from PATH_VIEW 
 where UNDER_PATH(RES,'/XFILES') = 1
/
select PATH
  from PATH_VIEW 
 where UNDER_PATH(RES,'/home/&XFILES_SCHEMA') = 1
/
select r.any_path
  from RESOURCE_VIEW r, RESOURCE_VIEW AR, XDB.XDB$ACL a
  where extractValue(r.res,'/Resource/ACLOID') = a.object_id
    and ref(a) = extractValue(ar.res,'/Resource/XMLRef')
    and equals_path(ar.res,'/home/XFILES/src/acls/xfilesUserAcl.xml') = 1
/
grant CONNECT, 
      RESOURCE, 
      ALTER SESSION, 
      CREATE TABLE, 
      CREATE VIEW, 
      CREATE SYNONYM
   to &XFILES_SCHEMA
/
grant CREATE ANY DIRECTORY, 
      DROP ANY DIRECTORY 
   to &XFILES_SCHEMA
/
grant CTXAPP 
   to &XFILES_SCHEMA
/
grant XDB_SET_INVOKER  
   to &XFILES_SCHEMA
 with ADMIN OPTION  
/
-- 
var XFILES_PERMISSIONS_SCRIPT varchar2(120);
--
declare
  V_XFILES_PERMISSIONS_SCRIPT varchar2(120);
begin
  V_XFILES_PERMISSIONS_SCRIPT := 'XFILES_SET_PERMISSIONS_12100.sql';
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  V_XFILES_PERMISSIONS_SCRIPT := 'XFILES_DO_NOTHING.sql';
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
  V_XFILES_PERMISSIONS_SCRIPT := 'XFILES_DO_NOTHING.sql';
$END
 :XFILES_PERMISSIONS_SCRIPT := V_XFILES_PERMISSIONS_SCRIPT;
end;
/
column XFILES_PERMISSIONS_SCRIPT new_value XFILES_PERMISSIONS_SCRIPT 
--
select :XFILES_PERMISSIONS_SCRIPT XFILES_PERMISSIONS_SCRIPT 
  from dual
/
def XFILES_PERMISSIONS_SCRIPT
--
@@&XFILES_PERMISSIONS_SCRIPT
--
call XDB_UTILITIES.createHomeFolder()
/
commit
/
--
--  Create Roles
--
create role XFILES_USER
/
grant XDB_WEBSERVICES 
   to XFILES_USER 
/
grant XDB_WEBSERVICES_OVER_HTTP 
   to XFILES_USER
/
grant XDB_WEBSERVICES_WITH_PUBLIC 
   to XFILES_USER
/
create role XFILES_ADMINISTRATOR
/
grant XDB_WEBSERVICES 
   to XFILES_ADMINISTRATOR 
 with admin option
/
grant XDB_WEBSERVICES_OVER_HTTP 
   to XFILES_ADMINISTRATOR 
 with admin option
/
grant XDB_WEBSERVICES_WITH_PUBLIC 
   to XFILES_ADMINISTRATOR 
 with admin option
/
grant XFILES_USER 
   to XFILES_ADMINISTRATOR 
 with admin option
/
grant XFILES_USER
   to &XFILES_SCHEMA
/
ALTER SESSION SET XML_DB_EVENTS = ENABLE
/
alter session set CURRENT_SCHEMA = &XFILES_SCHEMA
/
@@XFILES_LOG_QUEUE
--
@@XFILES_REGISTER_WIKI
--
quit
