
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
spool sqlOperations.log APPEND
--
def METADATA_SCHEMA = &1
--
create or replace package XDB_ASYNCHRONOUS_EVENTS
as
    procedure ENQUEUE_EVENT(payload xmltype);
    procedure DEQUEUE_EVENT(context raw, reginfo sys.aq$_reg_info, descr sys.aq$_descriptor, payload raw, payloadl number);    

    REPOSITORY_EVENTS_QUEUE constant VARCHAR2(128) := '&METADATA_SCHEMA..REPOSITORY_EVENTS_QUEUE';
    REPOSITORY_EVENTS_TABLE constant VARCHAR2(128) := '&METADATA_SCHEMA..REPOSITORY_EVENTS_TABLE';
    EVENT_HANDLER           constant VARCHAR2(128) := 'plsql://&METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.DEQUEUE_EVENT';
end;
/
show errors 
--
create or replace public synonym XDB_ASYNCHRONOUS_EVENTS for XDB_ASYNCHRONOUS_EVENTS
/
create or replace package body XDB_ASYNCHRONOUS_EVENTS
as
procedure ENQUEUE_EVENT(payload xmlType)
as
  enq_ct             dbms_aq.enqueue_options_t;
  msg_prop           dbms_aq.message_properties_t;
  enq_msgid          raw(16); 
begin
  DBMS_AQ.ENQUEUE(REPOSITORY_EVENTS_QUEUE, enq_ct, msg_prop, payload, enq_msgid);
end;
--
procedure DEQUEUE_EVENT( context raw, 
                         reginfo sys.aq$_reg_info, 
                         descr sys.aq$_descriptor,
                         payload raw, 
                         payloadl number )
as
  deq_ct     dbms_aq.dequeue_options_t;
  msg_prop   dbms_aq.message_properties_t;
  enq_msgid  raw(16); 
  xmlPayload XMLType;
begin
  DBMS_AQ.DEQUEUE(REPOSITORY_EVENTS_QUEUE, deq_ct, msg_prop, xmlPayload, enq_msgid);
  IMAGE_PROCESSOR.HANDLE_EVENT(xmlPayload);
end;
--
end;
/
show errors
--
grant execute on XDB_ASYNCHRONOUS_EVENTS to public
/
-- Create the Queue Table
--
declare
  queue_table_exists exception;
  PRAGMA EXCEPTION_INIT( queue_table_exists , -24001 );
begin
  sys.dbms_aqadm.create_queue_table
  (                          
    queue_table        => &METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_TABLE,            
    comment            => 'XML DB repository Events for content types understood by ORDIMAGE etc', 
    multiple_consumers => FALSE,                             
    queue_payload_type => 'SYS.XMLType',                       
    compatible         => '8.1'
   );
exception
  when queue_table_exists then
    null;
end;
/
--
desc REPOSITORY_EVENTS_TABLE
--
-- Create the Queue
--
declare
  queue_exists exception;
  PRAGMA EXCEPTION_INIT( queue_exists , -24006 );
begin
  sys.dbms_aqadm.create_queue
  (                                   
    queue_name   =>  &METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE,        
    queue_table  =>  &METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_TABLE
  );
exception
  when queue_exists then
    null;
end;
/
set lines 160
select NAME, QUEUE_TABLE, ENQUEUE_ENABLED, DEQUEUE_ENABLED
  from USER_QUEUES
/
--
-- Register for the pl/sql procedure  &METADATA_SCHEMA..REPOSITORY_EVENTS_PACKAGE.DEQUEUE_REPOSITORY_EVENT
-- to be called on notification 
--
DECLARE 
  reginfo      sys.aq$_reg_info; 
  reginfolist  sys.aq$_reg_info_list; 
BEGIN 
  
  reginfo := sys.aq$_reg_info(&METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE, 
                              DBMS_AQ.NAMESPACE_AQ, 
                              &METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.EVENT_HANDLER,
                              HEXTORAW('FF')); 

  reginfolist := sys.aq$_reg_info_list(reginfo); 
  sys.dbms_aq.register(reginfolist, 1); 
END;
/ 
show errors
--
select NAME, QUEUE_TABLE, ENQUEUE_ENABLED, DEQUEUE_ENABLED
  from USER_QUEUES
/
-- start the Queue
--
BEGIN
  sys.dbms_aqadm.start_queue(&METADATA_SCHEMA..XDB_ASYNCHRONOUS_EVENTS.REPOSITORY_EVENTS_QUEUE);
END;
/
show errors
--
select NAME, QUEUE_TABLE, ENQUEUE_ENABLED, DEQUEUE_ENABLED
  from USER_QUEUES
/
quit
