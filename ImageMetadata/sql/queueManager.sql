
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
spool queueManager.log
--
def OWNER = &1
--
alter session set current_schema = &OWNER
/
create or replace package QUEUE_MANAGER
as
  C_QUEUE_NAME        constant VARCHAR2(256) := '&OWNER..REPOSITORY_EVENTS_QUEUE';
  C_QUEUE_TABLE_NAME  constant VARCHAR2(256) := '&OWNER..REPOSITORY_EVENTS_TABLE';
  C_QUEUE_LOG_FILE    constant VARCHAR2(256) :=  XDB_CONSTANTS.FOLDER_HOME || '/&OWNER/emptyQueueOperation.log';
  
  procedure stopQueue;
  procedure purgeQueueTable;
  procedure startQueue;
  procedure emptyQueue;
  function  emptyQueue return CLOB;
end;
/
show errors
--
create or replace package body QUEUE_MANAGER
as  
--
procedure stopQueue
--
-- ************************************************
-- *           Stop the Queue                     *
-- ************************************************
--
as
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );
begin
  begin
    dbms_aqadm.stop_queue( XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE );
  exception
    when non_existant_queue then
        null;
  end;
end;
--
procedure purgeQueueTable
-- ************************************************
-- *           PURGE the Queue                     *
-- ************************************************
--
as
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );
  po dbms_aqadm.aq$_purge_options_t;
begin
  begin
  	 stopQueue();
     commit;
     po.block := TRUE;
     DBMS_AQADM.PURGE_QUEUE_TABLE(
       queue_table     => C_QUEUE_TABLE_NAME,
       purge_condition => NULL,
       purge_options   => po
     );
     commit;  
     startQueue();
  exception
    when non_existant_queue then
        null;
  end;
end;
--
procedure startQueue
--
-- ************************************************
-- *           Start the Queue                    *
-- ************************************************
--
as
  non_existant_queue exception;
  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );
begin
  begin
    dbms_aqadm.start_queue( XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE );
  exception
    when non_existant_queue then
        null;
  end;
end;
--
function emptyQueue 
return CLOB
as
begin
  emptyQueue();
  return xdburitype(C_QUEUE_LOG_FILE).getClob();
end;
--
procedure emptyQueue
as
  pending          number(32);  
  i                number(32);
  deq_ct           dbms_aq.dequeue_options_t;
  msg_prop         dbms_aq.message_properties_t;
  enq_msgid        raw(16);
  V_XML_PAYLOAD    XMLType;
begin
	 XDB_OUTPUT.createLogFile(C_QUEUE_LOG_FILE,TRUE);
	 XDB_OUTPUT.writeLogFileEntry('Processing Pending Entries in "' || XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE || '"');
	 XDB_OUTPUT.flushLogFile();
	 
   select count(*)
     into PENDING
     from &OWNER..REPOSITORY_EVENTS_TABLE;
     
	 XDB_OUTPUT.writeLogFileEntry('Processing ' || PENDING || ' Messages');
	 XDB_OUTPUT.flushLogFile();
          
   for i in 1..PENDING loop
     DBMS_AQ.DEQUEUE(XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE, deq_ct, msg_prop, V_XML_PAYLOAD, enq_msgid);
		 XDB_OUTPUT.writeLogFileEntry(XDB_CONSTANTS.FOLDER_HOME || 'Message [' || i || ']');
		 XDB_OUTPUT.writeLogFileEntry(V_XML_PAYLOAD);
		 XDB_OUTPUT.flushLogFile();
     &OWNER..IMAGE_PROCESSOR.HANDLE_EVENT(V_XML_PAYLOAD);
	   commit;
   end loop;
   
	 XDB_OUTPUT.writeLogFileEntry('Processing Completed');
	 XDB_OUTPUT.flushLogFile();
   
end;
--
end;
/
show errors
--
quit
