
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
def USERNAME = &1
--
var ACL_PATH varchar2(700)
--
call dbms_xdb.setACL('/home/&USERNAME','/sys/acls/all_owner_acl.xml')
/
call dbms_xdb.setACL('/publishedContent','/sys/acls/bootstrap_acl.xml')
/
call dbms_xdb.deleteResource('/publishedContent/allImages',4)
/
call dbms_xdb.deleteResource('/home/&USERNAME/ImageLibrary',4)
/
begin
  :ACL_PATH := '/sys/acls/all_owner_metadata_enabled_acl.xml';
  if (dbms_xdb.existsResource(:ACL_PATH)) then
    dbms_xdb.deleteResource(:ACL_PATH);
    commit;
  end if;
end;
/
begin
  :ACL_PATH := '/sys/acls/ro_all_metadata_enabled_acl.xml';
  if (dbms_xdb.existsResource(:ACL_PATH)) then
    dbms_xdb.deleteResource(:ACL_PATH);
    commit;
  end if;
end;
/
begin
  :ACL_PATH := '/sys/acls/bootstrap_metadata_enabled_acl.xml';
  if (dbms_xdb.existsResource(:ACL_PATH)) then
    dbms_xdb.deleteResource(:ACL_PATH);
    commit;
  end if;
end;
/
begin
  :ACL_PATH := '/sys/acls/published_image_folder_acl.xml';
  if (dbms_xdb.existsResource(:ACL_PATH)) then
    dbms_xdb.deleteResource(:ACL_PATH);
    commit;
  end if;
end;
/
begin
  :ACL_PATH := '/sys/acls/published_image_acl.xml';
  if (dbms_xdb.existsResource(:ACL_PATH)) then
    dbms_xdb.deleteResource(:ACL_PATH);
    commit;
  end if;
end;
/
commit
/

