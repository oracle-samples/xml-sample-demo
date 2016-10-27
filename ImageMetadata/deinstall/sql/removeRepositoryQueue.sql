
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

set echo on
spool deinstall.log APPEND
--
DEF METADATA_OWNER = &1
--
--
-- ************************************************
-- *           STOP the Queue                     *
-- ************************************************
--
DECLARE
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );
BEGIN
  begin
    dbms_aqadm.stop_queue('&METADATA_OWNER..REPOSITORY_EVENTS_QUEUE' );
  exception
    when non_existant_queue then
        null;
  end;
END;
/
commit
/
--
-- ************************************************
-- *      DE-REGISTER the Event Handler           *
-- ************************************************
--
DECLARE 
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -25205 );

  queue_not_registered exception;
  PRAGMA EXCEPTION_INIT( queue_not_registered , -24950 );

  reginfo      sys.aq$_reg_info; 
  reginfolist  sys.aq$_reg_info_list; 
BEGIN 

  begin   
    reginfo := sys.aq$_reg_info('&METADATA_OWNER..REPOSITORY_EVENTS_QUEUE', 
                                 DBMS_AQ.NAMESPACE_AQ, 
                                 'plsql://&METADATA_OWNER..XDB_ASYNCHRONOUS_EVENTS.DEQUEUE_EVENT', 
                                HEXTORAW('FF')); 

    reginfolist := sys.aq$_reg_info_list(reginfo); 
    sys.dbms_aq.unregister(reginfolist, 1); 
  exception
    when non_existant_queue then
        null;
    when queue_not_registered then
        null;
  end;
END;
/
commit
/
--
-- ************************************************
-- *               DROP the Queue                 *
-- ************************************************
--
declare
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );
begin
  begin
    DBMS_AQADM.DROP_QUEUE ('&METADATA_OWNER..REPOSITORY_EVENTS_QUEUE');
  exception
    when non_existant_queue then
        null;
  end;
end;
/ 
commit
/
--
-- ************************************************
-- *           DROP the Queue Table               *
-- ************************************************
--
DECLARE
  non_existant_queue_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue_table , -24002 );
begin
  begin
    DBMS_AQADM.DROP_QUEUE_TABLE ('&METADATA_OWNER..REPOSITORY_EVENTS_TABLE');
  exception
    when non_existant_queue_table then
        null;
  end;
end;
/ 
commit
/
/*
--
-- ************************************************
-- *          Revoke AQ Permissions               *
-- ************************************************
--
DECLARE
  not_granted exception;
  PRAGMA EXCEPTION_INIT( not_granted , -1927 );
  not_found exception;
  PRAGMA EXCEPTION_INIT( not_found , -1917 );
begin
  begin
    execute immediate 'revoke execute on DBMS_AQ from &METADATA_OWNER';
  exception
    when not_granted then
        null;
    when not_found then
        null;
  end;
end;
/
commit
/
*/
DECLARE
  not_granted exception;
  PRAGMA EXCEPTION_INIT( not_granted , -1951 );
  not_found exception;
  PRAGMA EXCEPTION_INIT( not_found , -1917 );
begin
  begin
    execute immediate 'revoke AQ_ADMINISTRATOR_ROLE from &METADATA_OWNER';
  exception
    when not_granted then
        null;
    when not_found then
        null;
  end;
end;
/
commit
/
quit
