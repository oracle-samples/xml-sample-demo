
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
spool configureContainer.log
--
prompt "Please connect as a DBA when prompted"
--
connect system

--
def TARGET_PDB = &1
--
def DBA = &2
--
def DBAPWD = &3
--
def HTTP = &4
--
alter user anonymous account unlock
/
alter system set shared_servers = 25 scope = both
/
alter session set container = &TARGET_PDB
/
alter user anonymous account unlock
/
grant connect, resource, SYSDBA, DBA to &DBA identified by &DBAPWD
/
call DBMS_XDB_CONFIG.setHttpPort(&HTTP)
/
quit
