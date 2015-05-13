
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
-- Drop and Recreate the XFiles Log Writer Queue, Queue Table and Package.
--
-- ************************************************
-- *           STOP the Queue                     *
-- ************************************************
--
DECLARE
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );

  V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';
  
BEGIN
  begin
    dbms_aqadm.stop_queue( V_QUEUE_NAME );
  exception
    when non_existant_queue then
        null;
  end;
END;
/
--
-- ************************************************
-- *      DE-REGISTER the Event Handler           *
-- ************************************************
--
DECLARE 
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -25205 );
  not_registered exception;
  PRAGMA EXCEPTION_INIT( not_registered , -24950 );

  reginfo             sys.aq$_reg_info; 
  reginfolist         sys.aq$_reg_info_list; 
  
   V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';
   V_EVENT_URL        VARCHAR2(128) := 'plsql://' || sys_context('USERENV','CURRENT_SCHEMA') || '.XFILES_LOGWRITER.DEQUEUE_LOG_RECORD';

begin
  begin
    reginfo := sys.aq$_reg_info(V_QUEUE_NAME, 
                                DBMS_AQ.NAMESPACE_AQ, 
                                V_EVENT_URL, 
                                HEXTORAW('FF')); 

    reginfolist := sys.aq$_reg_info_list(reginfo); 
    dbms_aq.unregister(reginfolist, 1); 
  exception
    when non_existant_queue then
        null;
    when not_registered then
        null;
  end;END;
/
--
-- ************************************************
-- *           Delete the Queue                   *
-- ************************************************
--
DECLARE
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );

  V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';

begin
  begin
    DBMS_AQADM.DROP_QUEUE (V_QUEUE_NAME);
  exception
    when non_existant_queue then
        null;
  end;
end;
/ 
--
-- ************************************************
-- *           Drop the Queue Table               *
-- ************************************************
--
DECLARE
  non_existant_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_table , -00942 );

  non_existant_queue_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue_table , -24002 );

  V_QUEUE_TABLE   VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_QUEUE_TABLE';

begin
  begin
    DBMS_AQADM.DROP_QUEUE_TABLE (V_QUEUE_TABLE);
  exception
    when non_existant_queue_table then
        null;
    when non_existant_table then
        null;
  end;
end;
/
--
-- ************************************************
-- *          Create the Queue Table              *
-- ************************************************
--
declare
  queue_table_exists exception;
  PRAGMA EXCEPTION_INIT( queue_table_exists , -24001 );

  V_QUEUE_TABLE   VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_QUEUE_TABLE';
  V_COMMENT       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || ' Asynchronous Logging';
  V_STORAGE       VARCHAR2(128);

begin
	
	select 'TABLESPACE "' || default_tablespace || '"' 
	  into V_STORAGE
	  from dba_users
	 where username = '&XFILES_SCHEMA';
	
  dbms_aqadm.create_queue_table
  (                          
    queue_table        => V_QUEUE_TABLE,            
    comment            => V_COMMENT,
    multiple_consumers => FALSE,                             
    queue_payload_type => 'SYS.XMLType',                       
    compatible         => '8.1',
    storage_clause     => V_STORAGE
   );
exception
  when queue_table_exists then
    null;
end;
/
--
-- ************************************************
-- *             Create the Queue                 *
-- ************************************************
--
declare
  queue_exists exception;
  PRAGMA EXCEPTION_INIT( queue_exists , -24006 );

  V_QUEUE_NAME    VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';
  V_QUEUE_TABLE   VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_QUEUE_TABLE';

begin
  dbms_aqadm.create_queue
  (                                   
    queue_name   =>  V_QUEUE_NAME,        
    queue_table  =>  V_QUEUE_TABLE
  );
exception
  when queue_exists then
    null;
end;
/
--
-- ************************************************
-- *         REGISTER the Event Handler           *
-- ************************************************
--
DECLARE 
  reginfo            sys.aq$_reg_info; 
  reginfolist        sys.aq$_reg_info_list; 

  V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';
  V_EVENT_URL        VARCHAR2(128) := 'plsql://' || sys_context('USERENV','CURRENT_SCHEMA') || '.XFILES_LOGWRITER.DEQUEUE_LOG_RECORD';

BEGIN 
  reginfo := sys.aq$_reg_info( V_QUEUE_NAME, 
                               DBMS_AQ.NAMESPACE_AQ, 
                               V_EVENT_URL, 
                               HEXTORAW('FF')); 

  reginfolist := sys.aq$_reg_info_list(reginfo); 
  sys.dbms_aq.register(reginfolist, 1); 
END;
/ 
--
-- ************************************************
-- *           Start the Queue                    *
-- ************************************************
--
declare
  V_QUEUE_NAME       VARCHAR2(128) := sys_context('USERENV','CURRENT_SCHEMA') || '.LOG_RECORD_Q';
BEGIN
  dbms_aqadm.start_queue
  (                                   
    queue_name   =>  V_QUEUE_NAME        
  );
END;
/
--
