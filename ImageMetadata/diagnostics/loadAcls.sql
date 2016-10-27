
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

connect &DBA/&DBAPASSWORD@&TNSALIAS
--
create or replace directory DEMOROOT as '&INSTALL_FOLDER'
/
declare 
  res boolean;
  NEW_ACL_PATH varchar2(2000);
begin
  NEW_ACL_PATH := '/sys/acls/all_owner_metadata_enabled_acl.xml';
  if (not dbms_xdb.existsResource(NEW_ACL_PATH)) then
    res := dbms_xdb.createResource(NEW_ACL_PATH,bfilename('DEMOROOT','xml/all_owner_metadata_enabled_acl.xml'));
    commit;
  end if;
  NEW_ACL_PATH := '/sys/acls/ro_all_metadata_enabled_acl.xml';
  if (not dbms_xdb.existsResource(NEW_ACL_PATH)) then
    res := dbms_xdb.createResource(NEW_ACL_PATH,bfilename('DEMOROOT','xml/ro_all_metadata_enabled_acl.xml'));
    commit;
  end if;
  NEW_ACL_PATH := '/sys/acls/bootstrap_metadata_enabled_acl.xml';
  if (not dbms_xdb.existsResource(NEW_ACL_PATH)) then
    res := dbms_xdb.createResource(NEW_ACL_PATH,bfilename('DEMOROOT','xml/bootstrap_metadata_enabled_acl.xml'));
    commit;
  end if;
  NEW_ACL_PATH := '/sys/acls/published_image_folder_acl.xml';
  if (not dbms_xdb.existsResource(NEW_ACL_PATH)) then
    res := dbms_xdb.createResource(NEW_ACL_PATH,bfilename('DEMOROOT','xml/published_image_folder_acl.xml'));
    commit;
  end if;
  NEW_ACL_PATH := '/sys/acls/published_image_acl.xml';
  if (not dbms_xdb.existsResource(NEW_ACL_PATH)) then
    res := dbms_xdb.createResource(NEW_ACL_PATH,bfilename('DEMOROOT','xml/published_image_acl.xml'));
    commit;
  end if;
end;
/
connect &METADATAOWNER/&USERPASSWORD@&TNSALIAS
--
set serveroutput on
--
begin
  xdb_utilities.uploadFiles('xml/sourceFileList.xml','DEMOROOT','/home/' || :METADATAOWNER);
  dbms_xdb.changeOwner('/home/' || :METADATAOWNER,:METADATAOWNER,TRUE);
end;
/
disconnect
--

