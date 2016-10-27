
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
spool sqlOperations.log 
--
def METADATA_SCHEMA = &1
--
grant execute on DBMS_AQ to &METADATA_SCHEMA
/
grant execute on DBMS_AQADM to &METADATA_SCHEMA
/
grant execute on XDBPM.XDBPM_DBMS_XDB to &METADATA_SCHEMA
/
grant execute on XDBPM.XDBPM_DBMS_RESCONFIG to &METADATA_SCHEMA
/
grant execute on XDBPM.XDBPM_UTILITIES_INTERNAL to &METADATA_SCHEMA
/
grant INHERIT PRIVILEGES 
   on user XDB 
   to &METADATA_SCHEMA
/
quit
