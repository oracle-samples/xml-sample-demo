
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

--
function getTraceFileContents
return CLOB
as
begin
	return XDBPM_HELPER.getTraceFileContents();
end;
--
procedure saveTraceFile
as
  pragma autonomous_transaction;
  V_RESULT              BOOLEAN;
  V_TRACE_FILE_PATH     VARCHAR2(255);
  V_TRACE_FILE_CONTENTS CLOB;
begin
  V_TRACE_FILE_CONTENTS := getTraceFileContents();
  V_TRACE_FILE_PATH := TRACE_FOLDER || '/' || XDBPM_HELPER.getTraceFileName();
  if (DBMS_XDB.existsResource(V_TRACE_FILE_PATH)) then
    DBMS_XDB.deleteResource(V_TRACE_FILE_PATH);
  end if;
  V_RESULT := DBMS_XDB.createResource(V_TRACE_FILE_PATH,V_TRACE_FILE_CONTENTS);
  dbms_lob.freeTemporary(V_TRACE_FILE_CONTENTS);
  commit;
end;
--
procedure setTraceFileOffset
as
  V_TRACE_FILE CLOB;
begin
  begin
    V_TRACE_FILE := getTraceFileContents();
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
  XDBPM_SYSDBA_INTERNAL.writeToTraceFile(P_COMMENT);
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
  XDBPM_SYSDBA_INTERNAL.flushTraceFile();

  V_TRACE_FILE := getTraceFileContents();
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
	
  V_TRACE_FILE := getTraceFileContents();
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
  V_TRACE_FILE := getTraceFileContents();
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
function TRACE_FOLDER 
return VARCHAR2 deterministic
as 
begin
  return C_TRACE_FOLDER;
end;
--
procedure createDebugFile
as 
begin
  XDB_OUTPUT.createDebugFile;
end;
--
procedure switchDebugOutputFile
as 
begin
  XDB_OUTPUT.switchDebugFile;
end;
--
procedure writeDebug(P_LOG_MESSAGE VARCHAR2)
as
begin	 
  createDebugFile();
  XDB_OUTPUT.writeDebugFileEntry(P_LOG_MESSAGE);
end;
--
procedure writeDebug(P_LOG_MESSAGE CLOB)
as
begin
	createDebugFile();
  XDB_OUTPUT.writeDebugFileEntry(P_LOG_MESSAGE);
end;
--
procedure writeDebug(P_XML XMLType)
as
begin
	createDebugFile();
  XDB_OUTPUT.writeDebugFileEntry(P_XML);
end;
--
function getDebugOutput
return CLOB
as
begin
  return XDBPM_OUTPUT.getDebugFileContent();
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
--
