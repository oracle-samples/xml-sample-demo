
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
def XFILES_SCHEMA = &1
--
select count(*) 
  from &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE
/
select count(*) 
  from &XFILES_SCHEMA..XFILES_LOG_RECORDS
/
declare 
  pending     number(32);  
  i           number(32);
  deq_ct      dbms_aq.dequeue_options_t;
  msg_prop    dbms_aq.message_properties_t;
  enq_msgid   raw(16);
   xmlPayload XMLType;
begin
   select count(*)
     into PENDING
     from &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE;
     
   for i in 1..PENDING loop
     DBMS_AQ.DEQUEUE('&XFILES_SCHEMA..LOG_RECORD_Q', deq_ct, msg_prop, xmlPayload, enq_msgid);
     &XFILES_SCHEMA..XFILES_LOGWRITER.FOLDER_LOG_RECORD(xmlPayload);
   end loop;
end;
/
select count(*) 
  from &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE
/
select count(*) 
  from &XFILES_SCHEMA..XFILES_LOG_RECORDS
/
--