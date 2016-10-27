
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

set echo on
spool deinstall.log APPEND
--
DEF USERNAME = &1
--
DEF RESCONFIG_PATH = &2
--
set serveroutput on
--
column config_path format a64
--
-- Remove any links to the Configuration Document
--
declare
   cursor findPaths (targetPath varchar2) is
   select path 
     from path_view p, resource_view r
    where p.resid = r.resid
      and equals_path(r.res,targetPath) = 1
      and p.path <> targetPath;
begin
  dbms_output.put_line('Processing: &RESCONFIG_PATH');
  for p in findPaths('&RESCONFIG_PATH') loop
    dbms_output.put_line('Processing: ' + p.PATH);
    dbms_xdb.deleteResource(p.PATH);
  end loop;
  commit;
end;
/
--
-- DeRegister the Repository Level Resource Configuration for Image Metadata
--
declare
   configid number(2) := null;
begin
  select config_id - 1
    into configId
    from (
           select rownum config_id, column_value config_path
             from table( dbms_resConfig.getRepositoryResConfigPaths() )
         )
   where config_path = '&RESCONFIG_PATH';

  dbms_resConfig.deleteRepositoryResConfig(configid);
  commit;

  dbms_output.put_line('Deleted Repository Configuration Document #' || configid); 

exception
  when no_data_found then 
    null;
end;
/
declare
  cursor getPackages
  is
  select OBJECT_NAME, OWNER 
    from ALL_OBJECTS
   where OWNER = '&USERNAME'
     and OBJECT_NAME = 'IMAGE_EVENT_MANAGER'
     and OBJECT_TYPE = 'PACKAGE';
begin
	for p in getPackages loop
	  execute immediate 'drop package "' || p.OWNER || '"."' || p.OBJECT_NAME || '"';
	end loop;
end;
/
quit
