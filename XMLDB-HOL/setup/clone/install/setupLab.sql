
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
spool setupLab.log
--
def USERNAME = &1
--
def PASSWORD = &2
--
alter user &USERNAME identified by &PASSWORD account unlock
/
grant UNLIMITED TABLESPACE to &USERNAME
/
grant CREATE ANY DIRECTORY, DROP ANY DIRECTORY to &USERNAME
/
grant SELECT_CATALOG_ROLE to &USERNAME
/
grant SELECT ANY DICTIONARY to &USERNAME
/
grant CTXAPP to &USERNAME
/
--
declare
  cursor getTables
  is
  select TABLE_NAME
    from ALL_XML_TABLES
   where TABLE_NAME in ('%DATA_STAGING_TABLE%')
     and OWNER = '&USERNAME';
begin
  for t in getTables() loop
    execute immediate 'DROP TABLE "&USERNAME"."' || t.TABLE_NAME || '" PURGE';
  end loop;
end;
/
alter session set CURRENT_SCHEMA = &USERNAME
/
create table %DATA_STAGING_TABLE%
    of XMLTYPE
/
quit
