
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
-- Find the name of the PATH TABLE
--
alter session set current_schema = XDBPM
/
var pathTableName varchar2(34)
--
declare
  V_PATH_TABLE_NAME varchar2(34);
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  V_PATH_TABLE_NAME := 'XDB.XDB$PATH_ID';
$ELSE
  V_PATH_TABLE_NAME := DBMS_CSX_ADMIN.pathIdtable();
$END
  :pathTableName := V_PATH_TABLE_NAME;
end;
/
undef pathTableName
--
column PATH_TABLE_NAME new_value pathTableName
--
select :pathTableName PATH_TABLE_NAME from dual
/
def pathTableName
--
alter session set current_schema = SYS
/
--
set define on
--
grant all on &pathTableName         to XDBPM
/
alter session set current_schema = SYS
/
--