
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
alter session set current_schema = XDBPM
/
--
DEF SOURCE_PATH = /home/XDBPM/java/src 
DEF CLASS_PATH = com/oracle/st/xdb/pm/zip
--
DEF JAVA_SOURCE_NAME = ExternalConnectionProvider
@@XDBPM_COMPILE_JAVA   
--
DEF JAVA_SOURCE_NAME = ArchiveManager
@@XDBPM_COMPILE_JAVA   
--
DEF JAVA_SOURCE_NAME = RepositoryImport
@@XDBPM_COMPILE_JAVA 
--
DEF JAVA_SOURCE_NAME = RepositoryExport
@@XDBPM_COMPILE_JAVA 
--
DEF JAVA_SOURCE_NAME = ZipManager
@@XDBPM_COMPILE_JAVA 
--
set serveroutput on
--
declare
  cursor getClasses
  is
  select NAME, dbms_java.shortname(NAME) SHORT_NAME
    from ALL_JAVA_CLASSES
   where OWNER = 'XDBPM'
     and NAME like '&CLASS_PATH%'; 
begin
  for c in getClasses() loop
    DBMS_OUTPUT.put_line('Processing class ' || c.NAME);
    execute immediate 'grant execute on "' || c.SHORT_NAME || '" to public';
  end loop;
end;
/
--
set serveroutput off
--
alter session set current_schema = SYS
/
