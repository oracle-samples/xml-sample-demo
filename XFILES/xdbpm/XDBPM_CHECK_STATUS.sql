
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
set echo on
--
set serveroutput on
--
begin
  dbms_utility.compile_schema('XDBPM',TRUE);
end;
/
set pages 100
--
select object_name, object_type, status 
  from all_objects
 where owner= 'XDB' and object_name like 'XDBPM%'
 order by status, object_type, object_name
/
select object_name, object_type, status 
  from all_objects
 where owner= 'XDBPM'
 order by status, object_type, object_name
/
--
set echo off verify off
select case when INVALID_OBJECT_COUNT = 0 
                 then 'XDBPM Installation Successful : See "&XDBPM_LOG_FILE" for details'
                 else 'XDBPM Installation Failed : See "&XDBPM_LOG_FILE" for further details'
            end "Installation Status"
  from (
         select count(*) INVALID_OBJECT_COUNT
           from all_objects
          where OWNER='XDBPM' and status = 'INVALID'
       )
/
set echo on verify on
--
                  