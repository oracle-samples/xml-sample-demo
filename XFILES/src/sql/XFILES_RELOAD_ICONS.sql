
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

spool XFILES_RELOAD_ICONS.log
set echo on
--
declare 
  
  V_ZIP_FILE      VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_HOME || '/src/famfamfam_silk_icons_v013.zip';
  V_SOURCE_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_HOME || '/icons/famfamfam'; 
  V_LOG_FILE      VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_HOME || '/famfamfam_silk_icons_v013.log';
  V_ICON_FOLDER   VARCHAR2(700) := V_SOURCE_FOLDER || '/icons';
  V_TARGET_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/lib/icons';
begin                        
	if (DBMS_XDB.existsResource(V_ICON_FOLDER)) then                                                    
    DBMS_XDB.deleteResource(V_ICON_FOLDER,DBMS_XDB.DELETE_RECURSIVE);
    commit;
  end if;
  
	if (DBMS_XDB.existsResource(V_LOG_FILE)) then                                                    
    DBMS_XDB.deleteResource(V_LOG_FILE);
    commit;
  end if;

  delete 
   from resource_view 
  where under_path(res,V_SOURCE_FOLDER) = 1;
  commit; 

  delete 
   from resource_view 
  where under_path(res,V_TARGET_FOLDER) = 1;
  commit; 
  
  XDB_IMPORT_UTILITIES.UNZIP(V_ZIP_FILE,V_SOURCE_FOLDER,V_LOG_FILE,XDB_CONSTANTS.RAISE_ERROR);
end;
/
--
@@PUBLISH_XFILES_ICONS
--
declare
  V_TARGET_FOLDER VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/lib/icons';
  cursor publishIcons is
  select path 
    from path_view
-- where under_path(res,XFILES_CONSTANTS.FOLDER_ROOT) = 1;
   where under_path(res,V_TARGET_FOLDER) = 1;
begin
  for res in publishIcons loop
    dbms_xdb.setACL(res.path,'/sys/acls/bootstrap_acl.xml');
  end loop;
end;
/
commit
/
exit
