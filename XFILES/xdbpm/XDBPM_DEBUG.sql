
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
-- XDBPM_DEBUG should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_DEBUG
authid CURRENT_USER
as
  C_WRITE_TO_TRACE_FILE constant binary_integer := 1;

  C_OPEN_QUERY_REWRITE      CONSTANT VARCHAR2(4000) := '<xdbpm:XQUERY_REWRITE xmlns:xdbpm="http://xmlns.oracle.com/xdbpm" timestamp="%TIMESTAMP%">';
  C_CLOSE_QUERY_REWRITE     CONSTANT VARCHAR2(4000) := '</xdbpm:XQUERY_REWRITE>';
  C_BEGIN_XQUERY_DIAGNOSTIC CONSTANT VARCHAR2(128) := 'XML Performance Diagnosis:';
  C_END_XQUERY_DIAGNOSTIC   CONSTANT VARCHAR2(128) := '===============================================================================';

  C_TRACE_FOLDER  VARCHAR2(128) := XDB_CONSTANTS.FOLDER_USER_DEBUG || '/traceFiles';

  function getTraceFileContents return CLOB;
  
  procedure startXQueryTrace;
  function  getXQueryTrace return CLOB;
  function getXQueryOptimizationTrace return CLOB;

  procedure startRewriteTrace(P_COMMENT VARCHAR2);
  function  getRewriteTrace return XMLType;  

  function TRACE_FOLDER return VARCHAR2 deterministic;
  function DEBUG_FILE return VARCHAR2;


  procedure saveTraceFile;
 
  procedure createDebugFile;
  procedure switchDebugOutputFile;
  procedure writeDebug(P_LOG_MESSAGE VARCHAR2);
  procedure writeDebug(P_LOG_MESSAGE CLOB);
  procedure writeDebug(P_XML XMLType);

  function getDebugOutput return CLOB;
    
end;
/
show errors
--
create or replace synonym XDB_DEBUG for XDBPM_DEBUG
/
grant execute on XDBPM_DEBUG to public
/
create or replace package body XDBPM_DEBUG
as
--  
  not_current_owner exception;
  PRAGMA EXCEPTION_INIT( not_current_owner , -31003 );
  
  FILE_NOT_FOUND     EXCEPTION;
  PRAGMA EXCEPTION_INIT (FILE_NOT_FOUND, -22288);

  G_CURRENT_OFFSET       NUMBER;
  G_CURRENT_TIMESTAMP    TIMESTAMP;
  G_CURRENT_MARKER       VARCHAR2(4000);

  G_DEBUG_SEQUENCE_ID    NUMBER := 1;
  G_DEBUG_FILE    VARCHAR2(700) := XDB_CONSTANTS.FOLDER_USER_DEBUG || '/logFiles/' || to_char(systimestamp,'YYYY-MM-DD') || '.' || lpad(XDBPM_HELPER.getSessionID(),6,'0') || '.' || lpad(G_DEBUG_SEQUENCE_ID,6,'0') || '.txt';

--
function getTraceFileContents
return CLOB
as
begin
	return XDBPM_HELPER.getTraceFileContents();
exception
  when FILE_NOT_FOUND then
    return 'Trace File  "' || XDBPM_HELPER.getTraceFileName() || '" not found.';
end;
--
procedure setTraceFileOffset
as
  V_TRACE_FILE CLOB;
begin
  begin
    V_TRACE_FILE := XDBPM_HELPER.getTraceFileContents();
    G_CURRENT_OFFSET := DBMS_LOB.getLength(V_TRACE_FILE);
    DBMS_LOB.freeTemporary(V_TRACE_FILE);
  exception
    when FILE_NOT_FOUND then
      G_CURRENT_OFFSET := 1;
  end; 
end;
--
procedure writeToTraceFile(P_COMMENT VARCHAR2)
as
begin
  sys.dbms_system.KSDWRT(C_WRITE_TO_TRACE_FILE,P_COMMENT);
  sys.dbms_system.KSDFLS();
end;
--  
procedure writeMarker(P_MARKER VARCHAR2)
as
begin
	G_CURRENT_MARKER := P_MARKER;
	writeToTraceFile(P_MARKER);
end;
--  
procedure writeMarker
as
begin
	writeMarker(SYS_GUID());
end;
--
procedure startXQueryTrace
as
  V_TRACE_FILE       CLOB;
begin
	writeMarker();
  setTraceFileOffset();	
  execute immediate 'alter session set events =''19021 trace name context forever, level 0x1001''';
  execute immediate 'alter session set events =''19027 trace name context forever, level 0x2000''';
end;
--
function getXQueryTrace
return CLOB
as
  V_TRACE_FILE        CLOB;
  V_XQUERY_TRACE      CLOB;
  V_TRACE_FILE_SIZE   NUMBER;  
begin
	if (G_CURRENT_OFFSET is null) then
	  G_CURRENT_OFFSET := 1;
	end if;
  execute immediate 'alter session set events =''19021 trace name context off''';
  sys.dbms_system.KSDFLS();

  V_TRACE_FILE := XDBPM_HELPER.getTraceFileContents();
  V_TRACE_FILE_SIZE := DBMS_LOB.getLength(V_TRACE_FILE);
  if (V_TRACE_FILE_SIZE > G_CURRENT_OFFSET) then
    dbms_lob.createTemporary(V_XQUERY_TRACE,TRUE,dbms_lob.session);
    dbms_lob.copy(V_XQUERY_TRACE,V_TRACE_FILE,V_TRACE_FILE_SIZE - G_CURRENT_OFFSET,1,G_CURRENT_OFFSET);  
    dbms_lob.freeTemporary(V_TRACE_FILE);
    return V_XQUERY_TRACE;  
  else
    return 'No XQuery Tracing in trace file "' || XDBPM_HELPER.getTraceFileName() || '" at offset : ' || G_CURRENT_OFFSET;
  end if;
end;
--	
function getXQueryOptimizationTrace
return CLOB
as
  V_TRACE_FILE       CLOB;
  V_START_OFFSET     NUMBER;
  V_END_OFFSET       NUMBER;
  V_DIAGNOSTIC_TRACE CLOB;
begin
	if (G_CURRENT_OFFSET is null) then
	  G_CURRENT_OFFSET := 1;
	end if;
	
  V_TRACE_FILE := XDBPM_HELPER.getTraceFileContents();
  V_START_OFFSET := dbms_lob.instr(V_TRACE_FILE,C_BEGIN_XQUERY_DIAGNOSTIC,G_CURRENT_OFFSET);

  if (V_START_OFFSET > 0) then
    dbms_lob.createTemporary(V_DIAGNOSTIC_TRACE,TRUE,dbms_lob.session);
    while (V_START_OFFSET > 0) loop
      V_END_OFFSET := dbms_lob.instr(V_TRACE_FILE,C_END_XQUERY_DIAGNOSTIC,V_START_OFFSET) + length(C_END_XQUERY_DIAGNOSTIC);
      dbms_lob.copy(V_DIAGNOSTIC_TRACE,V_TRACE_FILE,V_END_OFFSET - V_START_OFFSET,1,V_START_OFFSET);
      V_START_OFFSET := dbms_lob.instr(V_TRACE_FILE,C_BEGIN_XQUERY_DIAGNOSTIC,V_END_OFFSET);
    end loop;
  else
    V_DIAGNOSTIC_TRACE := 'No XML Optimization Information found in trace file "' || XDBPM_HELPER.getTraceFileName() || '"';
  end if;
  
  dbms_lob.freeTemporary(V_TRACE_FILE);
  return V_DIAGNOSTIC_TRACE;  
end;
--
procedure startRewriteTrace(P_COMMENT VARCHAR2) 
as
  V_OPEN_QUERY_REWRITE VARCHAR2(4000);
begin
  G_CURRENT_TIMESTAMP := systimestamp;
  V_OPEN_QUERY_REWRITE := replace(C_OPEN_QUERY_REWRITE,'%TIMESTAMP%',to_char(G_CURRENT_TIMESTAMP,'YYYY-MM-DD"T"HH24:MI:SS.FF'));
  V_OPEN_QUERY_REWRITE := replace(V_OPEN_QUERY_REWRITE,'>',' comment="' || P_COMMENT || '"><![CDATA[');
  writeToTraceFile(V_OPEN_QUERY_REWRITE);
  execute immediate 'alter session set events =''19021 trace name context forever, level 0x1001''';
  execute immediate 'alter session set events =''19027 trace name context forever, level 0x2000''';
end;
--
procedure endRewriteTrace
as
begin
  execute immediate 'alter session set events =''19021 trace name context off''';
  writeToTraceFile(C_CLOSE_QUERY_REWRITE);
end;
--
function getRewriteTrace(P_STATEMENT_TIMESTAMP TIMESTAMP)
return XMLType
as
  V_OPEN_QUERY_REWRITE VARCHAR2(4000);
  
  V_TRACE_FILE      CLOB;
  V_START_OFFSET    NUMBER;
  V_END_OFFSET      NUMBER;
  V_STATEMENT_TEXT  CLOB;
  V_STATEMENT_TRACE XMLTYPE;
begin
  endRewriteTrace();

  V_OPEN_QUERY_REWRITE := replace(C_OPEN_QUERY_REWRITE,'%TIMESTAMP%',to_char(G_CURRENT_TIMESTAMP,'YYYY-MM-DD"T"HH24:MI:SS.FF'));
  V_OPEN_QUERY_REWRITE := substr(V_OPEN_QUERY_REWRITE,1,length(V_OPEN_QUERY_REWRITE)-1);

  dbms_lob.createTemporary(V_STATEMENT_TEXT,TRUE,dbms_lob.session);
  V_TRACE_FILE := XDBPM_HELPER.getTraceFileContents();
  V_START_OFFSET := dbms_lob.instr(V_TRACE_FILE,V_OPEN_QUERY_REWRITE);
  V_END_OFFSET := dbms_lob.instr(V_TRACE_FILE,C_CLOSE_QUERY_REWRITE,V_START_OFFSET) + length(C_CLOSE_QUERY_REWRITE);
  dbms_lob.copy(V_STATEMENT_TEXT,V_TRACE_FILE,V_END_OFFSET - V_START_OFFSET,1,V_START_OFFSET);
  V_STATEMENT_TRACE := XMLType(V_STATEMENT_TEXT);
  dbms_lob.freeTemporary(V_STATEMENT_TEXT);
  dbms_lob.freeTemporary(V_TRACE_FILE);
  return V_STATEMENT_TRACE;  
end;
--
function getRewriteTrace
return XMLType
as
begin
  return getRewriteTrace(G_CURRENT_TIMESTAMP);
end;
--
function DEBUG_FILE
return VARCHAR2
as
begin
  return G_DEBUG_FILE;
end;
--
function TRACE_FOLDER 
return VARCHAR2 deterministic
as 
begin
  return C_TRACE_FOLDER;
end;
--
procedure createDebugFolders
as
  pragma autonomous_transaction;
begin
  XDB_HELPER.createDebugFolders(XDB_USERNAME.GET_USERNAME());
  commit;
end;
--
procedure createDebugFile
as 
  pragma autonomous_transaction;
  V_RESULT BOOLEAN;
begin
  if (not dbms_xdb.existsResource(G_DEBUG_FILE)) then
    V_RESULT := dbms_xdb.createResource(G_DEBUG_FILE,to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : Trace File Created.');
    G_DEBUG_SEQUENCE_ID := G_DEBUG_SEQUENCE_ID + 1;
    commit;
  end if;  
end;
--
procedure switchDebugOutputFile
as 
  V_RESULT BOOLEAN;
begin
  G_DEBUG_FILE := XDB_CONSTANTS.FOLDER_USER_DEBUG || '/logFiles/' || to_char(systimestamp,'YYYY-MM-DD') || '.' || lpad(XDB_HELPER.getSessionID(),6,'0') || '.' || lpad(G_DEBUG_SEQUENCE_ID,6,'0') || '.txt';
  createDebugFile();
end;
--
procedure writeDebug(P_LOG_MESSAGE VARCHAR2)
as
  V_LOG_MESSAGE CLOB;
  V_TIMESTAMP_INFO VARCHAR2(1024) := chr(13) || chr(10) || to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' :';
begin
	 
  createDebugFile();

  dbms_lob.createTemporary(V_LOG_MESSAGE,true);
  DBMS_LOB.WRITEAPPEND(V_LOG_MESSAGE,LENGTH(V_TIMESTAMP_INFO),V_TIMESTAMP_INFO);
  DBMS_LOB.WRITEAPPEND(V_LOG_MESSAGE,LENGTH(P_LOG_MESSAGE),P_LOG_MESSAGE);
  XDB_OUTPUT.writeToFile(G_DEBUG_FILE,V_LOG_MESSAGE);

end;
--
procedure writeDebug(P_LOG_MESSAGE CLOB)
as
  V_LOG_MESSAGE CLOB;
  V_TIMESTAMP_INFO VARCHAR2(1024) := chr(13) || chr(10) || to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' :' || chr(13) || chr(10);
begin
	 
  createDebugFile();

  dbms_lob.createTemporary(V_LOG_MESSAGE,true);
  DBMS_LOB.WRITEAPPEND(V_LOG_MESSAGE,LENGTH(V_TIMESTAMP_INFO),V_TIMESTAMP_INFO);
  dbms_lob.append(V_LOG_MESSAGE,P_LOG_MESSAGE);
  XDB_OUTPUT.writeToFile(G_DEBUG_FILE,V_LOG_MESSAGE);

end;
--
procedure writeDebug(P_XML XMLType)
as
  V_SERIALIZED_XML CLOB;
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  select P_XML.getClobVal()
    into V_SERIALIZED_XML
    from DUAL;
$ELSE
  select XMLSERIALIZE(DOCUMENT P_XML AS CLOB INDENT SIZE = 2)
    into V_SERIALIZED_XML
    from DUAL;
$END 

  writeDebug(V_SERIALIZED_XML);	 
end;
--
function getDebugOutput
return CLOB
as
begin
  return xdburitype(G_DEBUG_FILE).getCLOB();
end;
--
procedure saveTraceFile
as
  pragma autonomous_transaction;
  V_RESULT              BOOLEAN;
  V_TRACE_FILE_PATH     VARCHAR2(255);
  V_TRACE_FILE_CONTENTS CLOB;
begin
  V_TRACE_FILE_CONTENTS := XDBPM_HELPER.getTraceFileContents();
  V_TRACE_FILE_PATH := TRACE_FOLDER || '/' || XDBPM_HELPER.getTraceFileName();
  if (dbms_xdb.existsResource(V_TRACE_FILE_PATH)) then
    dbms_xdb.deleteResource(V_TRACE_FILE_PATH);
  end if;
  V_RESULT := dbms_xdb.createResource(V_TRACE_FILE_PATH,V_TRACE_FILE_CONTENTS);
  dbms_lob.freeTemporary(V_TRACE_FILE_CONTENTS);
  commit;
end;
--
--
begin
  createDebugFolders();
end;
/
show errors
--
alter session set current_schema = SYS
/
--
