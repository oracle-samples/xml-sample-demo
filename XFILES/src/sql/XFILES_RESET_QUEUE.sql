
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
spool xfllesResetQueue.log
--
def XFILES_SCHEMA = &1
--
select count(*) 
  from &XFILES_SCHEMA..XFILES_LOG_TABLE
/
select count(*) 
  from  &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE
/
declare
  po dbms_aqadm.aq$_purge_options_t;
BEGIN
   insert into &XFILES_SCHEMA..XFILES_LOG_TABLE
   select USER_DATA from &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE;
   commit;
   po.block := TRUE;
   SYS.DBMS_AQADM.PURGE_QUEUE_TABLE(
     queue_table     => '&XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE',
     purge_condition => NULL,
     purge_options   => po);
   commit;
end;
/
select count(*) 
  from &XFILES_SCHEMA..XFILES_LOG_TABLE
/
select count(*) 
  from  &XFILES_SCHEMA..LOG_RECORD_QUEUE_TABLE
/
--
