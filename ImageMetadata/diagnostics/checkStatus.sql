
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
--
spool checkStatus.log
--
@@setvars
--
connect &DBA/&DBAPASSWORD@&TNSALIAS
--
select count(*) from &METADATAOWNER..REPOSITORY_EVENTS_TABLE
/
select count(*) from &METADATAOWNER..IMAGE_METADATA_ERROR_TABLE
/
select count(*) from &METADATAOWNER..IMAGE_METADATA_TABLE
/
set pages 0 long 10000
--
set termout off
select * from &METADATAOWNER..IMAGE_METADATA_ERROR_TABLE
 order by xmlcast( xmlquery('$p/ImageProcessingError/TimeStamp/text()' passing object_value as "p" returning content) as TIMESTAMP)
/
set termout on
--
spool off
--

