
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
spool REPUBLISH_INSTALLED_DEMOS.log
--
def XFILES_SCHEMA = &1
--
declare
  V_SOURCE_PATH varchar2(700) := '/home/&XFILES_SCHEMA/src/WebDemo/loader.html';
  V_TARGET_FILE varchar2(32)  := 'index.html';
  V_TARGET_PATH varchar2(700);
  cursor findConfigFiles 
  is
 	select substr(path,1,instr(path,'/',-1)-1) TARGET
    from path_view 
   where XMLEXISTS(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd";  (: :)
           /Resource[DisplayName="configuration.xml"]'
          passing RES
        );
begin
  dbms_xdb.setAcl(V_SOURCE_PATH,'/sys/acls/bootstrap_acl.xml');
  for c in findConfigFiles loop
    V_TARGET_PATH := c.TARGET || '/' || V_TARGET_FILE;
    if dbms_xdb.existsResource(V_TARGET_PATH) then
      dbms_xdb.deleteResource(V_TARGET_PATH);
    end if;
    dbms_xdb.link(V_SOURCE_PATH,c.TARGET,V_TARGET_FILE,DBMS_XDB.LINK_TYPE_WEAK);
  end loop;
end;
/
commit
/
select PATH
  from PATH_VIEW
 where RESID = (
   select RESID 
     from RESOURCE_VIEW 
    where equals_path(RES,'/home/&XFILES_SCHEMA/src/WebDemo/loader.html') = 1
 )
 order by PATH
/
quit
