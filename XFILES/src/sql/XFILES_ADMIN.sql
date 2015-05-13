
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
create or replace package XFILES_QUEUE_MANAGER
as
  C_QUEUE_NAME        constant VARCHAR2(256) := '&XFILES_SCHEMA..LOG_RECORD_Q';
  C_QUEUE_TABLE_NAME  constant VARCHAR2(256) := '&XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE';
  
  procedure stopQueue;
  procedure purgeQueueTable;
  procedure startQueue;
  procedure emptyQueue;
end;
/
show errors
--
create or replace package body XFILES_QUEUE_MANAGER
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
    sys.dbms_aqadm.stop_queue( C_QUEUE_NAME );
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
     commit;
     po.block := TRUE;
     sys.DBMS_AQADM.PURGE_QUEUE_TABLE(
       queue_table     => C_QUEUE_TABLE_NAME,
       purge_condition => NULL,
       purge_options   => po
     );
     commit;  
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
    sys.dbms_aqadm.start_queue( C_QUEUE_NAME );
  exception
    when non_existant_queue then
        null;
  end;
end;
--
procedure emptyQueue
as
  pending          number(32);  
  i                number(32);
  deq_ct           dbms_aq.dequeue_options_t;
  msg_prop         dbms_aq.message_properties_t;
  enq_msgid        raw(16);
  V_LOG_RECORD      XMLType;
  V_LOG_RECORD_REF  REF XMLType;
  V_USER            VARCHAR2(32);
  V_TIMESTAMP       TIMESTAMP(6) WITH TIME ZONE;
  V_LOG_RECORD_TYPE VARCHAR2(256);  
begin
   select count(*)
     into PENDING
     from &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE;
     
   if (PENDING > 0) then
     for i in 1..PENDING loop
       DBMS_AQ.DEQUEUE(C_QUEUE_NAME, deq_ct, msg_prop, V_LOG_RECORD, enq_msgid);
      
       insert into &XFILES_SCHEMA..XFILES_LOG_TABLE x 
         values(V_LOG_RECORD)
         returning ref(x) INTO V_LOG_RECORD_REF;

      -- Generate the Filename from the Log Record.

      select LOG_USER, LOG_TIMESTAMP, LOG_RECORD_TYPE
        INTO V_USER,   V_TIMESTAMP, V_LOG_RECORD_TYPE
        from XMLTABLE(
               '/*'
               passing V_LOG_RECORD
               COLUMNS
               LOG_USER         VARCHAR2(32)                path 'User',
               LOG_TIMESTAMP    TIMESTAMP(6) WITH TIME ZONE path 'Timestamps/Init',
               LOG_RECORD_TYPE  VARCHAR2(32)                path 'fn:local-name(.)'
             );

	     XFILES_LOGWRITER.PROCESSLOGRECORD(V_LOG_RECORD_REF, V_USER, V_TIMESTAMP, V_LOG_RECORD_TYPE);
     end loop;
   end if;
end;
--
end;
/
show errors
--
create or replace package XFILES_QUERY_LIST
authid CURRENT_USER
as
  function executeQueryList(P_QUERY_LIST XMLTYPE)
  return XMLSEQUENCETYPE pipelined;
  function processQueryList(P_QUERY_LIST XMLTYPE)
  return XMLTYPE;
end;
/
show errors
--
create or replace package body XFILES_QUERY_LIST
as
--
function processQueryList(P_QUERY_LIST XMLTYPE)
return XMLTYPE
as
  V_RESULT XMLTYPE;
begin
  select xmlElement(
           "xfilesStatus",
           xmlAGG(
             COLUMN_VALUE
           )
         )
     into V_RESULT
     from table(
            XFILES.XFILES_QUERY_LIST.executeQueryList(P_QUERY_LIST)
          );
  return V_RESULT;
end;
--
function executeQueryList(P_QUERY_LIST XMLTYPE)
return XMLSEQUENCETYPE pipelined
as
  V_QUERY_RESULT XMLTYPE;

	cursor getQueries
	is
  select TITLE, QUERY
    from XMLTABLE(
           '/QueryList/Query'
           passing P_QUERY_LIST
           columns
             TITLE  VARCHAR2(4000) path 'title',
             QUERY  VARCHAR2(4000) path 'query'
      );
  V_STATEMENT VARCHAR2(4000);
begin
	for q in getQueries() loop
	  V_STATEMENT := 'select xmlElement(
	                             "Result",
	                              xmlAttributes(''' || q.TITLE || ''' as "title"),
	                              ( ' || q.QUERY || ') 
	                            ) 
	                       from DUAL';
	  EXECUTE IMMEDIATE V_STATEMENT into V_QUERY_RESULT;
	  PIPE ROW (V_QUERY_RESULT);
	end loop;
end;
--
end;
/
show errors
--