
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
-- XDB_MONITOR should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_MONITOR
authid DEFINER
as

  TYPE SESSION_STATISTICS_T is RECORD (
    TIME                   timestamp,
    ORA_PID                number,
    ORA_SID                number,
    OS_PID                 number,
    PGA_MEMORY             number,
    MAX_PGA_MEMORY         number,
    UGA_MEMORY             number,
    MAX_UGA_MEMORY         number,
    PGA_ALLOCATED_MEMORY   number,
    PGA_USED_MEMORY        number,
    PGA_FREEABLE_MEMORY    number,
    CACHE_LOBS             number,
    NO_CACHE_LOBS          number,
    ABSTRACT_LOBS          number,
    TEMP_SPACE_USAGE	     number
  );
 
  TYPE SESSION_STATISTICS_TABLE is TABLE of SESSION_STATISTICS_T;

  function getSessionStatistics 
  return SESSION_STATISTICS_TABLE
  pipelined;

  function getStatistics return XMLType;
  function getLOBUsage(stats XMLTYPE) return XMLType;
  function getTime(stats XMLTYPE) return timestamp;
  procedure initializeTimer;
  function  getElapsedTime return INTERVAL DAY TO SECOND;
end;
/
show errors
--
create or replace synonym XDB_MONITOR for XDBPM_MONITOR
/
grant execute on XDBPM_MONITOR to public
/
create or replace package body XDBPM_MONITOR
as
--
  START_TIME timestamp;
--  
function loadStatistics
return SESSION_STATISTICS_T
as
  V_SESSION_STATISTICS SESSION_STATISTICS_T;
begin
  V_SESSION_STATISTICS.TIME := SYSTIMESTAMP;

  select distinct SID 
    into V_SESSION_STATISTICS.ORA_SID 
    from V$MYSTAT;
	
  select PID,SPID, PGA_USED_MEM, PGA_ALLOC_MEM, PGA_FREEABLE_MEM, PGA_MAX_MEM
    into V_SESSION_STATISTICS.ORA_PID, 
         V_SESSION_STATISTICS.OS_PID, 
         V_SESSION_STATISTICS.PGA_USED_MEMORY, 
         V_SESSION_STATISTICS.PGA_ALLOCATED_MEMORY, 
         V_SESSION_STATISTICS.PGA_FREEABLE_MEMORY, 
         V_SESSION_STATISTICS.MAX_PGA_MEMORY
    from V$PROCESS p, V$SESSION s
   where p.addr = s.paddr
     and s.sid =  V_SESSION_STATISTICS.ORA_SID;
 
 select value 
   into V_SESSION_STATISTICS.PGA_MEMORY
   from v$mystat st,v$statname n
  where n.name = 'session pga memory'
    and n.statistic# = st.statistic#;

 select value 
   into V_SESSION_STATISTICS.MAX_PGA_MEMORY
   from v$mystat st,v$statname n
  where n.name = 'session pga memory max'
    and n.statistic# = st.statistic#;

 select value 
   into V_SESSION_STATISTICS.UGA_MEMORY
   from v$mystat st,v$statname n
  where n.name = 'session uga memory'
    and n.statistic# = st.statistic#;

 select value 
   into V_SESSION_STATISTICS.MAX_UGA_MEMORY
   from v$mystat st,v$statname n
  where n.name = 'session uga memory max'
    and n.statistic# = st.statistic#;

  begin
    select l.cache_lobs, l.nocache_lobs, l.abstract_lobs
      into V_SESSION_STATISTICS.CACHE_LOBS, V_SESSION_STATISTICS.NO_CACHE_LOBS, V_SESSION_STATISTICS.ABSTRACT_LOBS
      from v$temporary_lobs l, v$session s
     where s.audsid = SYS_CONTEXT('USERENV', 'SESSIONID')
       and s.sid = l.sid;
  exception
    when others then
      null;
  end;

  select sum(USER_BYTES) 
   into V_SESSION_STATISTICS.TEMP_SPACE_USAGE 
   from SYS.DBA_TEMP_FILES;

  return V_SESSION_STATISTICS;

end;
--
function getStatistics 
return XMLType
as
    V_SESSION_STATISTICS   SESSION_STATISTICS_T := loadStatistics();
    V_STATISTICS             XMLType;
begin
  
   select xmlElement(
      	    "statisticsSnapshot",
            xmlForest(
	            V_SESSION_STATISTICS.OS_PID as "operatingSystemPID",
       	      V_SESSION_STATISTICS.ORA_PID as "databasePID",
       	      V_SESSION_STATISTICS.ORA_SID as "databaseSID",
              V_SESSION_STATISTICS.TIME as "snapshotTimestamp",
              V_SESSION_STATISTICS.TEMP_SPACE_USAGE as "tempSpaceUsed"
            ),
            xmlElement(
              "PGA",
              xmlForest(
                V_SESSION_STATISTICS.PGA_MEMORY as "Current",
                V_SESSION_STATISTICS.MAX_PGA_MEMORY as "Maximum",
                V_SESSION_STATISTICS.PGA_USED_MEMORY as "Used",
                V_SESSION_STATISTICS.PGA_ALLOCATED_MEMORY as "Allocated",
                V_SESSION_STATISTICS.PGA_FREEABLE_MEMORY as "Freeable",
                V_SESSION_STATISTICS.MAX_PGA_MEMORY as "Max"
              )
            ),
            xmlElement(
              "UGA",
              xmlForest(
                V_SESSION_STATISTICS.UGA_MEMORY as "Current",
                V_SESSION_STATISTICS.MAX_UGA_MEMORY as "Maximum"
              ) 
            ),
            xmlElement(
              "LOBS",
              xmlForest(
                V_SESSION_STATISTICS.CACHE_LOBS as "Cached",
                V_SESSION_STATISTICS.NO_CACHE_LOBS as "nonCached",
                V_SESSION_STATISTICS.ABSTRACT_LOBS as "Abstract"
              ) 
            )
          )
     into V_STATISTICS
     from dual;

   return V_STATISTICS;
end;
--
function getSessionStatistics
return SESSION_STATISTICS_TABLE
pipelined
as
begin
  	pipe row (loadStatistics);
end; 
--
function getLOBUsage(stats XMLTYPE) return xmltype
as
   val xmltype;
begin
  return stats.extract('/statisticsSnapshot/LOBS');
end;
--
function getTime(stats XMLTYPE) return timestamp
as
begin
   return to_Timestamp(stats.extract('/statisticsSnapshot/snapshotTimestamp/text()').getStringVal());
end;               
--
procedure initializeTimer
as
begin
  START_TIME := sysTimeStamp;
end;
--
function getElapsedTime return interval DAY TO SECOND
as
  END_TIME timestamp;
  ELAPSED_TIME INTERVAL DAY (2) TO SECOND (6);
begin
  END_TIME := sysTimeStamp;
  ELAPSED_TIME := END_TIME - START_TIME;
  START_TIME := sysTimeStamp;
  return ELAPSED_TIME;
end;
--
end;
/
show errors
--
set pages 50
set long 2048
--
var XDBPM_MONITOR VARCHAR2(120)
--
declare
  V_XDBPM_MONITOR VARCHAR2(120);
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  V_XDBPM_MONITOR := 'XDBPM_MONITOR_10200.sql';
$ELSE
  V_XDBPM_MONITOR := 'XDBPM_MONITOR_11100.sql';
$END
  :XDBPM_MONITOR := V_XDBPM_MONITOR;
end;
/
undef XDBPM_MONITOR
--
column XDBPM_MONITOR new_value XDBPM_MONITOR
--
select :XDBPM_MONITOR XDBPM_MONITOR 
  from dual
/
select '&XDBPM_MONITOR'
  from DUAL
/
set define on
--
@@&XDBPM_MONITOR

alter session set current_schema = SYS
/
