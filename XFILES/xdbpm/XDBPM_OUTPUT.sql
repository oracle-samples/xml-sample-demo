
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
-- XDBPM_OUTPUT should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
-- Set mime-type to text/plain for common extensions
--
call DBMS_XDB.addMimeMapping('log','text/plain')
/
call DBMS_XDB.addMimeMapping('trc','text/plain')
/
call DBMS_XDB.addMimeMapping('trace','text/plain')
/
create or replace package XDBPM_OUTPUT
authid CURRENT_USER
as

  procedure writeOutputFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeOutputFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeOutputFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure createOutputFile(P_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushOutputFile;

  procedure writeTraceFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeTraceFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeTraceFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure traceException(P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure createTraceFile(P_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushTraceFile;

  procedure writeLogFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeLogFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeLogFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure logException(P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure createLogFile(P_TRACE_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushLogFile;
  
  procedure createFile(P_RESOURCE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure writeToFile(P_RESOURCE_PATH VARCHAR2, P_CONTENT IN OUT CLOB);
end;
/
create or replace synonym XDB_OUTPUT for XDBPM_OUTPUT
/
grant execute on XDBPM_OUTPUT to public
/
show errors
--
create or replace package body XDBPM_OUTPUT
as
  G_OUTPUT_FILE_PATH   VARCHAR2(700) := NULL;
  G_OUTPUT_FILE_BUFFER CLOB;
  G_TRACE_FILE_PATH   VARCHAR2(700) := NULL;
  G_TRACE_FILE_BUFFER CLOB;
  G_LOG_FILE_PATH   VARCHAR2(700) := NULL;
  G_LOG_FILE_BUFFER CLOB;
--
procedure writeToFile(P_RESOURCE_PATH VARCHAR2, P_CONTENT IN OUT CLOB)
as
  pragma autonomous_transaction;
    
  V_BINARY_CONTENT   BLOB;
  V_EXISTING_CONTENT BLOB;

  V_SOURCE_OFFSET    integer := 1;
  V_TARGET_OFFSET    integer := 1;
  V_WARNING          integer;
  V_LANG_CONTEXT     integer := 0;

begin	
  dbms_lob.createTemporary(V_BINARY_CONTENT,true);
  dbms_lob.convertToBlob(V_BINARY_CONTENT,P_CONTENT,dbms_lob.getLength(P_CONTENT),V_SOURCE_OFFSET,V_TARGET_OFFSET,nls_charset_id('AL32UTF8'),V_LANG_CONTEXT,V_WARNING);

  DBMS_XDB.touchResource(P_RESOURCE_PATH);
   
  select extractValue(res,'/Resource/XMLLob') 
    into V_EXISTING_CONTENT
    from RESOURCE_VIEW 
   where equals_path(res,P_RESOURCE_PATH) = 1
     for update;
  
  dbms_lob.open(V_EXISTING_CONTENT,dbms_lob.lob_readwrite);
  dbms_lob.append(V_EXISTING_CONTENT,V_BINARY_CONTENT);
  dbms_lob.close(V_EXISTING_CONTENT);
  commit;

  dbms_lob.freeTemporary(V_BINARY_CONTENT);
  dbms_lob.freeTemporary(P_CONTENT);
  P_CONTENT := NULL;
end;
--
procedure createFile(P_RESOURCE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  pragma autonomous_transaction;
  V_RESULT BOOLEAN;
begin
  if (DBMS_XDB.EXISTSRESOURCE(P_RESOURCE_PATH)) then
    if (P_OVERWRITE) then
      DBMS_XDB.DELETERESOURCE(P_RESOURCE_PATH,DBMS_XDB.DELETE_FORCE);
      V_RESULT := DBMS_XDB.CREATERESOURCE(P_RESOURCE_PATH,'');
    end if;
  else
      V_RESULT := DBMS_XDB.CREATERESOURCE(P_RESOURCE_PATH,'');
  end if;
  commit;
end;
--
procedure writeEntry(P_CONTENT VARCHAR2,P_BUFFER IN OUT CLOB) 
as
  V_BUFFER            VARCHAR2(32000);    
begin
	if (P_BUFFER IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(P_BUFFER,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(P_BUFFER,2, CHR(13) || CHR(10));
	end if;
	DBMS_LOB.WRITEAPPEND(P_BUFFER,LENGTH(P_CONTENT),P_CONTENT);
end;
--
procedure writeEntry(P_CONTENT CLOB,P_BUFFER IN OUT CLOB) 
as
begin
	if (P_BUFFER IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(P_BUFFER,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(P_BUFFER,2, CHR(13) || CHR(10));
	end if;
  DBMS_LOB.APPEND(P_BUFFER,P_CONTENT);
end;
--
procedure writeEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN,P_BUFFER IN OUT CLOB) 
as
  V_BUFFER            VARCHAR2(32000);    
  V_SERIALIZED_XML    CLOB;
begin
	if (P_BUFFER IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(P_BUFFER,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(P_BUFFER,2,CHR(13) || CHR(10));
	end if;
  if (P_PRETTY_PRINT) then
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
    select P_CONTENT.getClobVal()
      into V_SERIALIZED_XML
      from DUAL;
$ELSE
    select XMLSERIALIZE(DOCUMENT P_CONTENT AS CLOB INDENT SIZE = 2)
      into V_SERIALIZED_XML
      from DUAL;
$END
  else
    select XMLSERIALIZE(DOCUMENT P_CONTENT AS CLOB)
      into V_SERIALIZED_XML
      from DUAL;
  end if;
  
  DBMS_LOB.APPEND(P_BUFFER,V_SERIALIZED_XML);
end;
--
procedure writeException(P_BUFFER IN OUT CLOB)
as
  V_BUFFER            VARCHAR2(32000);
begin
	if (P_BUFFER IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(P_BUFFER,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(P_BUFFER,2,CHR(13) || CHR(10));
	end if;

  V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : Exception Details' || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(P_BUFFER,LENGTH(V_BUFFER),V_BUFFER);

  V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_STACK() || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(P_BUFFER,LENGTH(V_BUFFER),V_BUFFER);

  V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(P_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
end;
--
procedure flushFile(P_RESOURCE_PATH VARCHAR2,P_BUFFER IN OUT CLOB)
as
begin
	if (P_BUFFER IS NOT NULL) THEN
  	DBMS_LOB.WRITEAPPEND(P_BUFFER, 2, CHR(13) || CHR(10));
    writeToFile(P_RESOURCE_PATH,P_BUFFER);
  end if;
end;
--
--
-- Output File
--
procedure createOutputFile(P_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  pragma autonomous_transaction;
  V_RESULT BOOLEAN;
begin
	G_OUTPUT_FILE_PATH := P_FILE_PATH;
  createFile(G_OUTPUT_FILE_PATH,P_OVERWRITE);
end;
--
procedure flushOutputFile
as
begin
	flushFile(G_OUTPUT_FILE_PATH,G_OUTPUT_FILE_BUFFER);
end;
--
procedure writeOutputFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,G_OUTPUT_FILE_BUFFER);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
procedure writeOutputFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,G_OUTPUT_FILE_BUFFER);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
procedure writeOutputFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,P_PRETTY_PRINT,G_OUTPUT_FILE_BUFFER);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
-- Trace File
--
procedure createTraceFile(P_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  pragma autonomous_transaction;
  V_RESULT BOOLEAN;
begin
	G_TRACE_FILE_PATH := P_FILE_PATH;
  createFile(G_TRACE_FILE_PATH,P_OVERWRITE);
end;
--
procedure flushTraceFile
as
begin
	flushFile(G_TRACE_FILE_PATH,G_TRACE_FILE_BUFFER);
end;
--
procedure writeTraceFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,G_TRACE_FILE_BUFFER);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure writeTraceFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,G_TRACE_FILE_BUFFER);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure writeTraceFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(P_CONTENT,P_PRETTY_PRINT,G_TRACE_FILE_BUFFER);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure traceException(P_FLUSH BOOLEAN DEFAULT TRUE) 
as  
begin
	writeException(G_TRACE_FILE_BUFFER);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
-- Log File
--
procedure createLogFile(P_TRACE_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  V_RESULT BOOLEAN;
begin
	G_LOG_FILE_PATH := P_TRACE_FILE_PATH;
	if (G_LOG_FILE_PATH is NULL) then
	  G_LOG_FILE_PATH := '/public/' || USER || '_' || to_char(systimestamp,'YYYY-MM-DD"T"HH24.MI.SS.FF') || '.log';
  end if;
  createFile(G_LOG_FILE_PATH,P_OVERWRITE);
end;
--
procedure flushLogFile
as
begin
	flushFile(G_LOG_FILE_PATH,G_LOG_FILE_BUFFER);
end;
--
procedure writeLogFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || P_CONTENT,G_LOG_FILE_BUFFER);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure writeLogFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeLogFileEntry('CLOB Content',FALSE);
	writeEntry(P_CONTENT,G_LOG_FILE_BUFFER);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure writeLogFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeLogFileEntry('XML Content',FALSE);
	writeEntry(P_CONTENT,P_PRETTY_PRINT,G_LOG_FILE_BUFFER);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure logException(P_FLUSH BOOLEAN DEFAULT TRUE) 
as  
begin
	writeException(G_LOG_FILE_BUFFER);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
end;
/
show errors
--
grant execute on XDBPM_OUTPUT to public
/
alter session set current_schema = SYS
/
