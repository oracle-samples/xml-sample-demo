
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
 * ================================================ */

set echo on
spool statusPage.log
--
def OWNER = &1
--
alter session set current_schema = &OWNER
/
grant execute on XFILES.XFILES_QUERY_LIST to &OWNER with grant option
/
create or replace view XDBEXT_CURRENT_STATUS of XMLType
with OBJECT ID ( 1 )
as
select xmlElement(
         "xfilesStatus",
         xmlAGG(
           COLUMN_VALUE
         )
       )
  from table(
         XFILES.XFILES_QUERY_LIST.executeQueryList(
           xdburitype('/home/XDBEXT/statusPage.xml').getXML()
         )
       )
/
create or replace trigger XDBEXT_CURRENT_STATUS_DML
instead of INSERT or UPDATE or DELETE 
on XDBEXT_CURRENT_STATUS
begin
  null;
end;
/
declare 
  V_RESULT      BOOLEAN;
  V_XMLREF      REF XMLTYPE;
  V_STATUS_PATH VARCHAR2(2000) := '/home/XDBEXT/currentStatus.xml';
begin
	select REF(CS)
	  into V_XMLREF
	  from XDBEXT_CURRENT_STATUS CS;
	  
	if (DBMS_XDB.existsResource(V_STATUS_PATH)) then
	  DBMS_XDB.deleteResource(V_STATUS_PATH);
	end if;
	  
	V_RESULT := DBMS_XDB.createResource(V_STATUS_PATH,V_XMLREF,FALSE);
	XDB_REPOSITORY_SERVICES.setCustomViewer(V_STATUS_PATH,'/XFILES/lite/xsl/xfilesStatus.xsl');
	commit;

end;
/
set long 10000 pages 0
--
select xdburitype('/home/XDBEXT/currentStatus.xml').getXML()
  from DUAL
/
quit
