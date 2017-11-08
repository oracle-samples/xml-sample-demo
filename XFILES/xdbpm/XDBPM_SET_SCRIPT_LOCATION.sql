
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

set APPINFO ON
--
def SCRIPT_LOCATION
--
var CONTROL_FILE_LOCATION varchar2(120)
var DATA_FILE_LOCATION    varchar2(120)
--
declare
  V_APPINFO               varchar2(256);
  V_CONTROL_FILE_LOCATION varchar2(120);
begin
  V_APPINFO := SYS_CONTEXT('USERENV','MODULE');
  if (INSTR(V_APPINFO,'\',-1) > 0) then
     V_CONTROL_FILE_LOCATION := '&SCRIPT_LOCATION' || '\';
  else
    V_CONTROL_FILE_LOCATION := '&SCRIPT_LOCATION' || '/';
  end if;
  :CONTROL_FILE_LOCATION := V_CONTROL_FILE_LOCATION || 'XDBPM_SOURCE_FILES.ctl';
  :DATA_FILE_LOCATION    := V_CONTROL_FILE_LOCATION || 'XDBPM_SOURCE_FILES.dat';
end;
/
undef CONTROL_FILE_LOCATION 
undef DATA_FILE_LOCATION
--
column CONTROL_FILE_LOCATION new_value CONTROL_FILE_LOCATION 
column DATA_FILE_LOCATION new_value DATA_FILE_LOCATION 
--
select :CONTROL_FILE_LOCATION CONTROL_FILE_LOCATION,
       :DATA_FILE_LOCATION    DATA_FILE_LOCATION  
  from dual
/
set APPINFO OFF
--
def CONTROL_FILE_LOCATION
--
def DATA_FILE_LOCATION
--
