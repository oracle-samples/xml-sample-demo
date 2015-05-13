
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
-- ************************************************
-- *             View Creation                    *
-- *                                              *
-- *  Views of the XFILES_LOG_TABLE               *
-- *  Make it easier to find specifc log records  *
-- *                                              *
-- ************************************************
--
/*
**
** All log records ordered by date
**
*/
create or replace view XFILES_LOG_RECORDS
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LOG_RECORDS_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LOG_RECORDS_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE))  < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LOG_RECORDS_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE))  < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** Normal activity ordered by date 
**
*/
create or replace view XFILES_ACTIVITY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesLogRecord' passing OBJECT_VALUE)
 order by XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ACTIVITY_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
  where XMLExists('/XFilesLogRecord' passing OBJECT_VALUE)
   and (systimestamp - XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ACTIVITY_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesLogRecord' passing OBJECT_VALUE)
   and (systimestamp - XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ACTIVITY_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesLogRecord' passing OBJECT_VALUE)
   and (systimestamp - XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/XFilesLogRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** Errors ordered by date
**
*/
create or replace view XFILES_ERRORS
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesErrorRecord' passing OBJECT_VALUE  )
 order by XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ERRORS_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesErrorRecord' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ERRORS_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesErrorRecord' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_ERRORS_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesErrorRecord' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/XFilesErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** Possible Server Side Crashes ordered by date
**
** Typically caused by the server failing to respond or 
** failing to respond in a timely manner.
**
** Check the Database's Alert log for corresponding errors
**
*/
create or replace view SERVER_CRASHES
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException[XFilesException[id="13" or (id="3" and (number="12019" or number = "502"))]]' passing OBJECT_VALUE  )
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view SERVER_CRASHES_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException[XFilesException[id="13" or (id="3" and (number="12019" or number = "502"))]]' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view SERVER_CRASHES_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException[XFilesException[id="13" or (id="3" and (number="12019" or number = "502"))]]' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view SERVER_CRASHES_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException[XFilesException[id="13" or (id="3" and (number="12019" or number = "502"))]]' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** Repository Event Errors ordered by date
**
*/
create or replace view REPOS_ERRORS
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/RepositoryEventError' passing OBJECT_VALUE  )
 order by XMLCAST(XMLQuery('/eventRepositoryEventErrorErrorRecord/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view REPOS_ERRORS_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/RepositoryEventError' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view REPOS_ERRORS_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/RepositoryEventError' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view REPOS_ERRORS_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/RepositoryEventError' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/RepositoryEventError/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** XFiles Client Application Errors ordered by date
**
** Typically Javacsript coding errors detected by the Browser
**
*/
create or replace view XFILES_CLIENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException' passing OBJECT_VALUE  )
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_CLIENT_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_CLIENT_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 01:00:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_CLIENT_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLExists('/XFilesClientException' passing OBJECT_VALUE  )
   and (systimestamp - XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('001 00:00:00')
 order by XMLCAST(XMLQuery('/XFilesClientException/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** XFiles Long Running Operations (Over 2 mins) ordered by date
**
*/
create or replace view XFILES_LONG_OPS
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where XMLCAST(XMLQuery('/*/Timestamps/Complete/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) -
       XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) >  TO_DSINTERVAL('000 00:0:02')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LONG_OPS_MOST_RECENT
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE)) < TO_DSINTERVAL('000 00:05:00')
   and XMLCAST(XMLQuery('/*/Timestamps/Complete/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) -
       XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) > TO_DSINTERVAL('000 00:0:02')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LONG_OPS_LAST_HOUR
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE))  < TO_DSINTERVAL('000 01:00:00')
   and XMLCAST(XMLQuery('/*/Timestamps/Complete/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) -
       XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) > TO_DSINTERVAL('000 00:0:02')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
create or replace view XFILES_LONG_OPS_LAST_DAY
of XMLType
as 
select OBJECT_VALUE
  from XFILES_LOG_TABLE
 where (systimestamp - XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE))  < TO_DSINTERVAL('001 00:00:00')
   and XMLCAST(XMLQuery('/*/Timestamps/Complete/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) -
       XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) > TO_DSINTERVAL('000 00:0:02')
 order by XMLCAST(XMLQuery('/*/Timestamps/Init/text()' passing OBJECT_VALUE returning CONTENT) as TIMESTAMP WITH TIME ZONE) DESC
/
/*
**
** Page Hits
**
*/ 
create or replace view XFILES_PAGE_HITS
as
select TARGET, COUNT(*) HITS
  from XFILES_LOG_TABLE,
       XMLTABLE(
         '/Page'
          passing OBJECT_VALUE
          columns
          TARGET varchar2(2000) path 'Target'
       )
 group by TARGET
/
create or replace view XFILES_PAGE_HITS_BY_DATE
as
select TARGET, "DATE", COUNT(*) HITS
  from ( 
    select TARGET, TIME, TRUNC (to_timestamp_tz(TIME,'YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'))  "DATE"
      from XFILES_LOG_TABLE,
           XMLTABLE(
            '/Page'
             passing OBJECT_VALUE
             columns
             TARGET varchar2(2000) path 'Target',
             TIME   varchar2(64)   path 'Timestamps/Init'
           )
    )
 group by TARGET, "DATE"
 order by TARGET
/