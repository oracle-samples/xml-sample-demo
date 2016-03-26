
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
alter session set CURRENT_SCHEMA = XDBPM
/
VAR HOME_FOLDER VARCHAR2(700)
VAR PUBLIC_FOLDER VARCHAR2(700)
--
begin
	:HOME_FOLDER    := XDB_CONSTANTS.FOLDER_HOME || '/XDBPM';  
	:PUBLIC_FOLDER  := XDB_CONSTANTS.FOLDER_PUBLIC || '/XDBPM';
end;
/
declare
  V_HOME_FOLDER     VARCHAR2(700) := :HOME_FOLDER;    
  V_PUBLIC_FOLDER   VARCHAR2(700) := :PUBLIC_FOLDER; 
--
-- Delete any RESCONFIG documents under /home/XDBPM
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
  V_RESCONFIG_LIST        XDB.XDB$OID_LIST_T;
  V_RESCONFIG_PATH_LIST   XDB.XDB$STRING_LIST_T;
  V_PATH_LIST             XDB.XDB$STRING_LIST_T;
$END
--
begin
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  NULL;
$ELSE
  select cfg.OBJECT_ID, ANY_PATH
          bulk collect into V_RESCONFIG_LIST, V_RESCONFIG_PATH_LIST
    from RESOURCE_VIEW, XDB.XDB$RESCONFIG cfg
   where ref(cfg) = extractValue(res,'/Resource/XMLRef')
     and under_path(res,V_HOME_FOLDER || '') = 1;

  if (V_RESCONFIG_LIST.last > 0) then
    for i in V_RESCONFIG_LIST.first .. V_RESCONFIG_LIST.last loop

      select rv.ANY_PATH
             bulk collect into V_PATH_LIST
        from RESOURCE_VIEW rv, XDB.XDB$RESOURCE r,
             TABLE(r.XMLDATA.RCLIST.OID) rc
       where rc.COLUMN_VALUE = V_RESCONFIG_LIST(i)
         and r.OBJECT_ID = rv.RESID;
   
       if (V_PATH_LIST.last > 0) then
         for j in V_PATH_LIST.first .. V_PATH_LIST.last loop
           DBMS_RESCONFIG.deleteResConfig(V_PATH_LIST(j),V_RESCONFIG_PATH_LIST(i),DBMS_RESCONFIG.DELETE_RESOURCE);
         end loop;
       end if;
    end loop;
  end if;
$END
--
end;
/
begin
	 if (DBMS_XDB.existsResource(:HOME_FOLDER || '')) then
    DBMS_XDB.deleteResource(:HOME_FOLDER || '',DBMS_XDB.DELETE_RECURSIVE);  
    commit;
  end if;
end;
/
declare
  V_RESULT boolean;
begin
	xdbpm.xdb_helper.createHomeFolder('XDBPM');
  xdbpm.xdb_helper.createPublicFolder('XDBPM');  
end;
/
--
@@XDBPM_SET_SCRIPT_LOCATION
@@XDBPM_FIX_FILE_LOCATION
--
grant CREATE SESSION to XDBPM
/
alter user XDBPM identified by XDBPM account unlock
/
--
host sqlldr -userid=XDBPM/XDBPM@&_CONNECT_IDENTIFIER -control=&CONTROL_FILE_LOCATION -data=&DATA_FILE_LOCATION
--
alter user XDBPM identified by XDBPM account lock
/
revoke CREATE SESSION from XDBPM
/
/*
**
** Load the Log file into the SQL*PLUS SQLBUFFER so that it appears in the main log.
**
*/
get XDBPM_SOURCE_FILES.log
.
declare
  V_RESULT          BOOLEAN;
  V_HOME_FOLDER     VARCHAR2(700) := :HOME_FOLDER;    
  V_PUBLIC_FOLDER   VARCHAR2(700) := :PUBLIC_FOLDER; 
begin
--
$IF DBMS_DB_VERSION.VER_LE_10_2 
$THEN
  NULL;
$ELSE
	if (not DBMS_XDB.existsResource(V_PUBLIC_FOLDER || '/events')) then
    DBMS_XDB.link(V_HOME_FOLDER || '/events',V_PUBLIC_FOLDER,'events',DBMS_XDB.LINK_TYPE_WEAK);
	end if;

	DBMS_XDB.setAcl(V_HOME_FOLDER || '/events','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/events/UPLOAD_FOLDER_EVENTS.pkg','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/events/UPLOAD_FOLDER_EVENTS.sql','/sys/acls/bootstrap_acl.xml');

	if (not DBMS_XDB.existsResource(V_PUBLIC_FOLDER || '/lib')) then
    DBMS_XDB.link(V_HOME_FOLDER || '/lib',V_PUBLIC_FOLDER,'lib',DBMS_XDB.LINK_TYPE_WEAK);
	end if;

	DBMS_XDB.setAcl(V_HOME_FOLDER || '/lib','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/lib/XDBResource.xml','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/lib/XDBResource.xsd','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/lib/XDBSchema.xsd','/sys/acls/bootstrap_acl.xml');
	DBMS_XDB.setAcl(V_HOME_FOLDER || '/lib/xdbAnnotations.xsd','/sys/acls/bootstrap_acl.xml');
  commit;
$END
--
end;
/
set pages 50
--
select PATH
  from PATH_VIEW
 where under_path(res,:HOME_FOLDER || '') = 1
/
select PATH
  from PATH_VIEW
 where under_path(res,:PUBLIC_FOLDER) = 1
/
alter session set CURRENT_SCHEMA = SYS
/
--