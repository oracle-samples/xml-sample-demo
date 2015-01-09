
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
 * ================================================ */

set echo on
spool XFILES_STATUS_PAGE.log
--
create or replace view XFILES_CURRENT_STATUS of XMLType
with OBJECT ID ( 1 )
as
select xmlElement(
         "xfilesStatus",
         xmlAGG(
           COLUMN_VALUE
         )
       )
  from table(
         XFILES_QUERY_LIST.executeQueryList(
           xdburitype('/home/XFILES/xfilesStatus/statusPage.xml').getXML()
         )
       )
/
create or replace trigger XFILES_CURRENT_STATUS_DML
instead of INSERT or UPDATE or DELETE 
on XFILES_CURRENT_STATUS
begin
  null;
end;
/
declare 
  V_RESULT      BOOLEAN;
  V_XMLREF      REF XMLTYPE;
  V_STATUS_PATH VARCHAR2(2000) := '/home/XFILES/xfilesStatus/currentStatus.xml';
begin
	select REF(CS)
	  into V_XMLREF
	  from XFILES_CURRENT_STATUS CS;
	  
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
select xdburitype('/home/XFILES/xfilesStatus/currentStatus.xml').getXML()
  from DUAL
/
--
quit