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
 * ================================================ */

set echo on
spool configureDatabase.log
--
def TARGET_PDB = &1
--
prompt "Please enter password for SYS/ as SYSDBA when prompted"
--
@@connect.sql
--
def DBA = &2
--
def DBAPWD = &3
--
def HTTP = &4
--
def USERNAME = &5
--
def USERPWD = &6 
--
-- Determine correct setup script..
--
var SET_CDB_SCRIPT VARCHAR2(120);
var SET_PDB_SCRIPT VARCHAR2(120);
--
declare
  V_CON_ID NUMBER(2):= 0;
  V_SET_CDB_SCRIPT VARCHAR2(120);
  V_SET_PDB_SCRIPT VARCHAR2(120);
begin
$IF DBMS_DB_VERSION.VER_LE_11_2 $THEN
$ELSE
  -- In a 12.1 database
  -- CON_ID = 0: Standalone
  -- CON_ID = 1: CDB
  -- CON_ID > 1: PDB
  select min(CON_ID)
    into V_CON_ID
    from V$CONTAINERS;
$END
  V_SET_CDB_SCRIPT := 'doNothing.sql';
  V_SET_PDB_SCRIPT := 'doNothing.sql';
  if (V_CON_ID > 0) then
    V_SET_CDB_SCRIPT := 'setContainerCDB.sql';
    V_SET_PDB_SCRIPT := 'setContainerPDB.sql';
  end if; 
  :SET_CDB_SCRIPT := V_SET_CDB_SCRIPT;
  :SET_PDB_SCRIPT := V_SET_PDB_SCRIPT;
end;
/
undef SET_CDB_SCRIPT
undef SET_PDB_SCRIPT
--
column SET_CDB_SCRIPT new_value SET_CDB_SCRIPT 
column SET_PDB_SCRIPT new_value SET_PDB_SCRIPT 
--
select :SET_CDB_SCRIPT SET_CDB_SCRIPT,
       :SET_PDB_SCRIPT SET_PDB_SCRIPT
  from dual
/
def SET_CDB_SCRIPT
def SET_PDB_SCRIPT
--
@@&SET_CDB_SCRIPT
--
alter user anonymous account unlock
/
alter system set shared_servers = 25 scope = both
/
@@&SET_PDB_SCRIPT
--
alter user anonymous account unlock
/
call DBMS_XDB_CONFIG.setHttpPort(&HTTP)
/
grant connect, resource, SYSDBA, DBA to &DBA identified by &DBAPWD
/
grant connect, resource, unlimited tablespace to &USERNAME identified by &USERPWD
/
alter user &USERNAME identified by &USERPWD account unlock
/
@@setDigestAuthScript
--
@@&DIGEST_AUTH_SCRIPT &DBA &DBAPWD
--
@@&DIGEST_AUTH_SCRIPT &USERNAME &USERPWD
--
quit
