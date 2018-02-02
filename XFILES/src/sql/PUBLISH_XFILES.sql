
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
spool PUBLISH_XFILES.log
--
def LOGO = &1
--
undef XFILES_ROOT
--
column XFILES_ROOT new_value XFILES_ROOT
--
select XFILES_CONSTANTS.FOLDER_ROOT XFILES_ROOT
  from dual
/
def XFILES_ROOT
--
-- Set XFilesLaunchPad.html as the index.html page for /XFILES
--
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/index.html';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  DBMS_XDB.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/XFilesLaunchPad.html',XFILES_CONSTANTS.FOLDER_ROOT,'index.html');
end;
/  
--
-- Set aboutXFiles.html as the aboutXFiles.html page for /XFILES
--
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/aboutXFiles.html';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  DBMS_XDB.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/aboutXFiles.html',XFILES_CONSTANTS.FOLDER_ROOT,'aboutXFiles.html');
end;
/  
--
-- Create the 'lib' folder tree
--
declare
  cursor deleteFolders 
  is 
  select PATH
    from PATH_VIEW
   where under_path(RES,1,XFILES_CONSTANTS.FOLDER_ROOT || '/lib') = 1;
begin 
	for f in deleteFolders loop
	  DBMS_XDB.deleteResource(f.PATH,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end loop;
  XDB_UTILITIES.mkdir(XFILES_CONSTANTS.FOLDER_ROOT || '/lib/icons',TRUE);
end;
/
--
-- Publish Common components under /XFILES
-- 
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/common';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  dbms_xdb.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/common/',XFILES_CONSTANTS.FOLDER_ROOT,'common',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
--
-- Publish Image Library components under /XFILES/lib
-- 
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/images';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  dbms_xdb.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/images/',XFILES_CONSTANTS.FOLDER_ROOT || '/lib' ,'images',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
-- 
-- Publish XFILES 'lite' under /XFILES
--
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/lite';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
	DBMS_XDB.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/lite',XFILES_CONSTANTS.FOLDER_ROOT,'lite',DBMS_XDB.LINK_TYPE_WEAK);
end;
/ 
--
-- Publish resConfig documents
--
declare 
  V_LINK_TARGET  VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/resConfig';
begin
	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  dbms_xdb.link(XFILES_CONSTANTS.C_FOLDER_RESCONFIG_INT,XFILES_CONSTANTS.FOLDER_ROOT,'resConfig',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
-- 
-- Publish Assets
--
declare 
  V_TARGET_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT;
begin                                                                                     
  dbms_xdb.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/images/&LOGO',                                     V_TARGET_FOLDER,             'logo.png',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(XFILES_CONSTANTS.FOLDER_HOME || '/src/images/Barber_Pole_Red.gif',                       V_TARGET_FOLDER,             'loading.gif',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
-- 
-- Publish Xinha under FRAMEWORKS
--
declare 
  V_FRAMEWORK_VERSION VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/Xinha-0.96.1';
  V_FRAMEWORK_ROOT    VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/Xinha';
  V_LINK_TARGET   VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC  || '/Xinha';
begin
	if DBMS_XDB.existsResource(V_FRAMEWORK_ROOT) then
	  DBMS_XDB.deleteResource(V_FRAMEWORK_ROOT);
	end if;

	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
	
	dbms_xdb.link(V_FRAMEWORK_VERSION,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE,'Xinha');
	
  DBMS_XDB.link(V_FRAMEWORK_ROOT,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,'Xinha',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
-- 
-- Publish Bootstap Dialogs 3 under FRAMEWORKS
--
declare 
  V_FRAMEWORK_VERSION VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/bootstrap3-dialog-master/dist';
  V_FRAMEWORK_ROOT    VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/bootstrap-dialog';
  V_LINK_TARGET       VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC || '/bootstrap-dialog';
begin
	if DBMS_XDB.existsResource(V_FRAMEWORK_ROOT) then
	  DBMS_XDB.deleteResource(V_FRAMEWORK_ROOT);
	end if;

	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
	
	dbms_xdb.link(V_FRAMEWORK_VERSION,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE,'bootstrap-dialog');
	
  DBMS_XDB.link(V_FRAMEWORK_ROOT,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,'bootstrap-dialog',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
-- 
-- Publish Bootstap 3.2.0 under FRAMEWORKS
--
declare 
  V_FRAMEWORK_VERSION VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/bootstrap-3.2.0-dist';
  V_FRAMEWORK_ROOT    VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/bootstrap';
  V_LINK_TARGET       VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC || '/bootstrap';
begin
	if DBMS_XDB.existsResource(V_FRAMEWORK_ROOT) then
	  DBMS_XDB.deleteResource(V_FRAMEWORK_ROOT);
	end if;

	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
	
	dbms_xdb.link(V_FRAMEWORK_VERSION,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE,'bootstrap');
	
  DBMS_XDB.link(V_FRAMEWORK_ROOT,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,'bootstrap',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
-- 
-- Publish JQuery 3.3.1 under FRAMEWORKS
--
declare 
  V_FRAMEWORK_VERSION VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/jquery-3.3.1/jquery-3.3.1.min.js';
  V_FRAMEWORK_ROOT    VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/jquery.js';
  V_LINK_TARGET       VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC || '/jquery.js';
begin
	if DBMS_XDB.existsResource(V_FRAMEWORK_ROOT) then
	  DBMS_XDB.deleteResource(V_FRAMEWORK_ROOT);
	end if;

	if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
	
	dbms_xdb.link(V_FRAMEWORK_VERSION,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE,'jquery.js');
	
  DBMS_XDB.link(V_FRAMEWORK_ROOT,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,'jquery.js',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
-- 
-- Publish jssor under FRAMEWORKS
--
declare 
  V_FRAMEWORK_ROOT    VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PRIVATE || '/jssor';
  V_LINK_TARGET       VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC || '/jssor';
begin
  if DBMS_XDB.existsResource(V_LINK_TARGET) then
	  DBMS_XDB.deleteResource(V_LINK_TARGET);
	end if;
  DBMS_XDB.link(V_FRAMEWORK_ROOT,XFILES_CONSTANTS.FOLDER_FRAMEWORKS_PUBLIC,'jssor',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
@@PUBLISH_XFILES_ICONS
--
@@PUBLISH_WEBSERVICES_DEMO
--
@@PUBLISH_WEBDEMO_FRAMEWORK
--
@@PUBLISH_XMLVIEWER
--
@@PUBLISH_XMLSEARCH
--
-- Ensure all items in /XFILES are readable by the world
--
declare
  cursor publishResources is
  select path 
    from path_view
-- where under_path(res,XFILES_CONSTANTS.FOLDER_ROOT) = 1;
   where under_path(res,'&XFILES_ROOT') = 1;
begin
  dbms_xdb.setACL(XFILES_CONSTANTS.FOLDER_ROOT,XDB_CONSTANTS.ACL_BOOTSTRAP);
  for res in publishResources loop
    dbms_xdb.setACL(res.path,XDB_CONSTANTS.ACL_BOOTSTRAP);
  end loop;
end;
/
commit
/
declare
  cursor findSoftLinks 
  is
  select RESID
    from PATH_VIEW
-- where under_path(res,XFILES_CONSTANTS.FOLDER_ROOT) = 1
   where under_path(res,'&XFILES_ROOT') = 1
     and XMLExists
         (
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBStandard"; (: :)
            $L/LINK[LinkType="Weak"]'
            passing LINK as "L"
         )
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
     and existsNode(res,'/Resource[@Container="true"]','xmlns="http://xmlns.oracle.com/xdb/XDBResource.xsd"') = 1;
$ELSE
     and XMLExists
         (
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
            $R/Resource[@Container=xs:boolean("true")]'
           passing RES as "R"
         );
$END
  cursor findHardLink(C_RESID RAW)
  is
  select path 
    from PATH_VIEW
   where RESID = C_RESID
     and XMLExists
         (
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBStandard"; (: :)
            $L/LINK[LinkType="Hard"]'
            passing LINK as "L"
         );

  cursor publishResources(C_PATH VARCHAR2) is
  select path 
    from path_view
   where under_path(res,C_PATH) = 1;

begin
  for r in findSoftLinks loop
    for hl in findHardLink(r.RESID) loop
      dbms_xdb.setACL(hl.PATH,XDB_CONSTANTS.ACL_BOOTSTRAP);
      for p in publishResources(hl.PATH) loop  
        dbms_xdb.setACL(p.PATH,XDB_CONSTANTS.ACL_BOOTSTRAP);
      end loop;
    end loop;
  end loop;
end;
/        
commit
/
-- 
-- Reset the ACL on /XFILES/whoami.xml to prevent access by anonymous...
--
@@XFILES_ACCESS_CONTROL
--
column RES_PATH FORMAT A100
column ACL_PATH FORMAT A100
--
set lines 256 pages 100 trimspool on
--
select r.any_path RES_PATH,
       (
         select r.ANY_PATH
           from RESOURCE_VIEW r
          where extractValue(r.res,'/Resource/XMLRef') = ref(a)
       ) ACL_PATH
  from xdb.xdb$acl a, resource_view r
 where extractValue(r.res,'/Resource/ACLOID') = a.object_id
-- and under_path(r.res,XFILES_CONSTANTS.FOLDER_HOME) = 1
   and under_path(r.res,'/home/XFILES') = 1
 order by 2,1
/
--
-- Revoke XDB_SET_INVOKER from XFILES
--
revoke XDB_SET_INVOKER
  from XFILES
/
quit
