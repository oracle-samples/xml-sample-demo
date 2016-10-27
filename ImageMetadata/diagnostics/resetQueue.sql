
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
spool resetQueue.log
/*
**
** Reset the System Queue
**
*/
def OWNER = &1
--
delete from &OWNER..REPOSITORY_EVENTS_TABLE
/
alter system set job_queue_processes = 0
/
shutdown abort
--
startup
--
DECLARE
  p_opt     dbms_aqadm.aq$_purge_options_t;
BEGIN
p_opt.block := true ;
-- < 12.1 or non CDB ??? DBMS_AQADM.purge_queue_table( queue_table      => 'SYS.AQ_SRVNTFN_TABLE',
DBMS_AQADM.purge_queue_table( queue_table      => 'SYS.AQ_SRVNTFN_TABLE_1',
                              purge_condition  => null,
                              purge_options => p_opt) ;
COMMIT;
END;
/ 
shutdown abort
--
startup
--
alter system set job_queue_processes = 10
/
quit                                          

