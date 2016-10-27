
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

declare
  V_TARGET_FOLDER varchar2(1024) :=  '%DEMOLOCAL%/Spreadsheets';
  V_RESULT boolean;

  cursor getDepartments is
    select ref(d) XMLREF, 
           XMLCast
           (
             XMLQuery
             (
               'declare default element namespace "urn:schemas-microsoft-com:office:spreadsheet"; (: :)
                declare namespace ss = "urn:schemas-microsoft-com:office:spreadsheet"; (: :)
                $X/Workbook/Worksheet[1]/@ss:Name'
                passing OBJECT_VALUE as "X" returning content
             )
             as VARCHAR2(32)
           ) NAME
      from DEPARTMENT_SPREADSHEET d;
begin
	if (not DBMS_XDB.existsResource(V_TARGET_FOLDER)) then
	  V_RESULT := dbms_xdb.createFolder(V_TARGET_FOLDER); 
	end if;
	
  for dept in getDepartments loop
    V_RESULT := DBMS_XDB.createResource(V_TARGET_FOLDER || '/' || dept.NAME || '.xml', dept.XMLREF);
  end loop;
end;
/
--
set autotrace off
--
select path
  from path_view
 where under_path(res,'%DEMOLOCAL%/Spreadsheets') = 1
/
--
