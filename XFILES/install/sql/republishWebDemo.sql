
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
--
connect sys/&1  as sysdba
--
def DEMONSTRATION_FOLDER = &2
--
spool republishWebDemo_&DEMONSTRATION_FOLDER..log
--
declare 
  res boolean;
  targetPath varchar2(700) := XDB_CONSTANTS.PUBLIC_FOLDER || '/' || '&DEMONSTRATION_FOLDER';
begin
  if dbms_xdb.existsResource(targetPath) then
    if not dbms_xdb.existsResource(targetPath || '/index.html') then
      dbms_xdb.link('/home/XFILES/src/WebDemo/webDemo.html',targetPath,'index.html',DBMS_XDB.LINK_TYPE_WEAK);
    end if;
  end if;
end;
/
commit
/
quit
