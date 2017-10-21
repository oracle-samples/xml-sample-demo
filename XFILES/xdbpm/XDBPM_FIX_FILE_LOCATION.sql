
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
-- Fix File locations in XDBPM_SOURCE_FILES.inp
--
VAR FILELIST CLOB;
--
-- Workaround for issue introduced by fix for bug #20111613 and reported in bug #21321998
--
begin
	:FILELIST := empty_clob();
end;
/ 
column FILELIST format A256
set pages 0 lines 256 long 1000000 trimspool on
-- 
GET &SCRIPT_LOCATION./XDBPM_SOURCE_FILES.inp
.
0 begin :FILELIST := '
21 ';;
22 end;;
.
L
/
begin
  select substr(:FILELIST,2,length(:FILELIST)-2)
    into :FILELIST
    from dual;
end;
/
--
set echo off  heading off feedback off timing off headsep off
--
spool &SCRIPT_LOCATION./XDBPM_SOURCE_FILES.dat
print :FILELIST
spool off
--
spool &XDBPM_LOG_FILE append
--
set echo on heading on feedback on pages 20  timing on headsep on