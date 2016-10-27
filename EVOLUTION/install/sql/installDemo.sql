
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
spool installDemo.log
--
def USERNAME = &1
--
-- Grant Required permissions for Schema Registration etc to the demo user
--
grant ALTER SESSION, CREATE VIEW, XFILES_USER to &USERNAME
/
grant all on HR.COUNTRIES to &USERNAME
/
grant all on HR.LOCATIONS to &USERNAME
/
grant all on HR.DEPARTMENTS to &USERNAME
/
grant all on HR.EMPLOYEES to &USERNAME
/
grant all on HR.JOBS to &USERNAME
/
grant all on HR.JOB_HISTORY to &USERNAME
/
call DBMS_XDB.addMimeMapping('sql','text/plain')
/
call DBMS_XDB.addMimeMapping('log','text/plain')
/
call DBMS_XDB.addMimeMapping('ctl','text/plain')
/
quit

