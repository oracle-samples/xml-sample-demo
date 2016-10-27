
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
  V_TARGET_FOLDER varchar2(1024);
begin
  V_TARGET_FOLDER :=  '%DEMOLOCAL%/Departments';
  if dbms_xdb.existsResource(V_TARGET_FOLDER) then
     dbms_xdb.deleteResource(V_TARGET_FOLDER,dbms_xdb.DELETE_RECURSIVE_FORCE);
  end if;
  commit;
  
  V_TARGET_FOLDER :=  '%DEMOLOCAL%/Spreadsheets';
  if dbms_xdb.existsResource(V_TARGET_FOLDER) then
     dbms_xdb.deleteResource(V_TARGET_FOLDER,dbms_xdb.DELETE_RECURSIVE_FORCE);
  end if;
  commit;
end;
/
declare
  cursor getView
  is
  select VIEW_NAME
    from USER_XML_VIEWS
   where VIEW_NAME in ( 'DEPARTMENTS_XML', 'DEPARTMENT_SPREADSHEET' );
begin
  for v in getView() loop
    execute immediate 'DROP VIEW "' || v.VIEW_NAME || '"';
  end loop;
end;
/
begin
	--
	-- Reset Changes to HR data..
	--
  delete from hr.job_history
   where (employee_id = 178 or employee_id = 199);

  update hr.employees 
     set DEPARTMENT_ID = NULL
   where EMPLOYEE_ID = 178;

  update hr.employees 
     set DEPARTMENT_ID = 50
   where EMPLOYEE_ID = 199;

  delete from hr.job_history
   where (employee_id = 178 or employee_id = 199);

end;
/
--
