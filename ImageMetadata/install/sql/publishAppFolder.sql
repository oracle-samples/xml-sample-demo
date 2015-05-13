
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
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
--
spool sqlOperations.log APPEND
--
def OWNER = &1
--
def FOLDER = &2
--
def XFILES = &3
--
-- Create index.html in the user's folder pointing to WebDemo application
--
declare
  V_HOME_FOLDER varchar2(700) := XDB_CONSTANTS.FOLDER_HOME || '/&OWNER';
  V_SOURCE_PATH varchar2(700) := V_HOME_FOLDER || '/&FOLDER';
  V_TARGET_PATH varchar2(700) := XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC || '/&FOLDER';

  cursor publishResources is
  select path 
    from path_view
   where under_path(res,V_SOURCE_PATH) = 1;

begin
  if dbms_xdb.existsResource(V_TARGET_PATH) then
    dbms_xdb.deleteResource(V_TARGET_PATH);
  end if;
  
  -- Set Bootstap ACL on home folder to allow ImageEventResConfig.xml to be seen by other users
  dbms_xdb.setAcl(V_HOME_FOLDER,XDB_CONSTANTS.ACL_BOOTSTRAP);
  dbms_xdb.setAcl(V_SOURCE_PATH,XDB_CONSTANTS.ACL_BOOTSTRAP);
  
  for res in publishResources loop
    dbms_xdb.setACL(res.path,XDB_CONSTANTS.ACL_BOOTSTRAP);
  end loop;

  dbms_xdb.link(V_SOURCE_PATH,XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC,'&FOLDER',DBMS_XDB.LINK_TYPE_WEAK);
	DBMS_XDB.link(XDB_METADATA_CONSTANTS.XSL_IMAGE_GALLERY,XFILES_CONSTANTS.FOLDER_VIEWERS_PUBLIC,'ImageGallery.xsl',DBMS_XDB.LINK_TYPE_WEAK);
end;
/
commit
/
--
grant select 
   on &XFILES..REPOS_ERRORS 
   to &OWNER 
 with grant option
/
alter session set current_schema = &OWNER
/
create or replace view IMAGE_METADATA_STATUS_VIEW (
  STATE,COUNT
)
as
select 'PROCESSED', count(*)
  from &OWNER..IMAGE_METADATA_TABLE
union all
select 'QUEUED', count(*)
  from &OWNER..REPOSITORY_EVENTS_TABLE
union all
select 'FAILED', count(*)
  from &XFILES..REPOS_ERRORS
/
--
declare
  V_RESULT BOOLEAN;
  V_STATUS_FOLDER VARCHAR2(700) := XDB_CONSTANTS.FOLDER_HOME || '/&OWNER/status';
  V_STATUS_PAGE   VARCHAR2(700) := V_STATUS_FOLDER || '/PendingEvents.xml';  
begin
	if (not DBMS_XDB.existsResource(V_STATUS_FOLDER)) then
    V_RESULT := DBMS_XDB.createFolder(V_STATUS_FOLDER);
  end if;
  if (DBMS_XDB.existsResource(V_STATUS_PAGE)) then
    DBMS_XDB.deleteResource(V_STATUS_PAGE);
  end if;
  	
	XDB_REPOSITORY_SERVICES.mapTableToResource(V_STATUS_PAGE,'&OWNER','PENDING_EVENTS_VIEW',NULL);
	
	commit;
end;
/
create or replace view PENDING_EVENTS_VIEW
as
select D.*, ENQ_TIME, DEQ_TIME, RETRY_COUNT
  from REPOSITORY_EVENTS_TABLE,
       XMLTABLE(
         XMLNAMESPACES(
           default 'http://xmlns.oracle.com/xdb/pm/resourceEvent'
         ),
         '/EventDetail'
         passing USER_DATA
         columns
           USERID       VARCHAR2(128) path 'currentUser',
           IMAGE_PATH   VARCHAR2(700) path 'resourcePath'
       ) d
/

@@postInstallationSteps
--
quit
