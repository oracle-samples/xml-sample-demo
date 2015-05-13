
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
spool XFILES_SYSDBA_TASKS.log
--
def XFILES_SCHEMA = &1
--
grant execute 
   on DBMS_AQ 
   to &XFILES_SCHEMA
/
grant execute 
   on DBMS_AQADM
   to &XFILES_SCHEMA
/
grant select on XDB.XDB$RESOURCE to &XFILES_SCHEMA
/
--
-- Enable LOB Cache for XMLLob.
--
declare
	cursor getLobStatus
	is
	select 1
	  from DBA_LOBS
	 where OWNER = 'XDB'
	   and TABLE_NAME = 'XDB$RESOURCE'
	   and COLUMN_NAME = '"XMLDATA"."XMLLOB"'
	   and CACHE = 'NO';
begin
	for l in getLobStatus() loop
	  execute immediate 'alter table xdb.xdb$resource modify lob (xmldata.xmllob) (cache)';
	end loop;
end;
/
--
@@XFILES_SYSDBA_DROP_OBJECTS.sql
--
quit
