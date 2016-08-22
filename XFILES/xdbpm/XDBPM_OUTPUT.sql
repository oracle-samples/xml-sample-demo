
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
create or replace package XDBPM_OUTPUT
authid CURRENT_USER
as

  procedure writeOutputFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeOutputFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeOutputFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure createOutputFile(P_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushOutputFile;
  function  getOutputFileContent return CLOB;
  function  getOutputFilePath return VARCHAR2;

  procedure writeTraceFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeTraceFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeTraceFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure traceException(P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure createTraceFile(P_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushTraceFile;
  function  getTraceFileContent return CLOB;
  function  getTraceFilePath return VARCHAR2;

  procedure writeLogFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeLogFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure writeLogFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE);
  procedure logException(P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure createLogFile(P_TRACE_FILE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE);
  procedure flushLogFile;
  function  getLogFileContent return CLOB;
  function  getLogFilePath return VARCHAR2;
  
  procedure writeDebugFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure writeDebugFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure writeDebugFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure debugException(P_FLUSH BOOLEAN DEFAULT TRUE);
  procedure createDebugFile;
  procedure switchDebugFile;
  procedure flushDebugFile;
  function  getDebugFileContent return CLOB;
  function  getDebugFilePath return VARCHAR2;

  procedure createFile(P_RESOURCE_PATH VARCHAR2, P_OVERWRITE BOOLEAN DEFAULT FALSE);
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
  TYPE FILE_HANDLE_T is RECORD (
     PATH    VARCHAR2(700),
     CONTENT CLOB
  );
  
  TYPE FILE_HANDLE_LIST_T 
    is TABLE of FILE_HANDLE_T 
       INDEX by VARCHAR2(32);
                        
  G_FILE_HANDLE_LIST FILE_HANDLE_LIST_T;
  
  C_DEBUG_FILE    CONSTANT  VARCHAR2(32) := SYS_GUID();
  C_OUTPUT_FILE   CONSTANT  VARCHAR2(32) := SYS_GUID();
  C_TRACE_FILE    CONSTANT  VARCHAR2(32) := SYS_GUID();
  C_LOG_FILE      CONSTANT  VARCHAR2(32) := SYS_GUID();
  
  G_VERSION NUMBER := 0;
  
  G_CREATING_DEBUG_FOLDERS BOOLEAN := FALSE;

--
procedure createFileInternal(P_RESOURCE_PATH VARCHAR2, P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  V_RESULT BOOLEAN;
begin
  -- DBMS_OUTPUT.put_line($$PLSQL_UNIT || '.createFileInternal : ' || P_RESOURCE_PATH);
  if (DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    if (P_OVERWRITE) then
      DBMS_XDB.deleteResource(P_RESOURCE_PATH,DBMS_XDB.DELETE_FORCE);
    end if;
  else
    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,'');
  end if;
end;
--
procedure createFile(P_RESOURCE_PATH VARCHAR2, P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  pragma autonomous_transaction;
begin
	createFileInternal(P_RESOURCE_PATH, P_OVERWRITE);
	commit;
end;
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

$IF DBMS_DB_VERSION.VER_LE_10_2 
$THEN
  V_RESULT           boolean;
$END

begin	
  DBMS_LOB.createTemporary(V_BINARY_CONTENT,true);
  DBMS_LOB.convertToBlob(V_BINARY_CONTENT,P_CONTENT,DBMS_LOB.getLength(P_CONTENT),V_SOURCE_OFFSET,V_TARGET_OFFSET,nls_charset_id('AL32UTF8'),V_LANG_CONTEXT,V_WARNING);

  -- 
  -- Ensure File Exists 
  -- 
  createFileInternal(P_RESOURCE_PATH,FALSE);

  -- Ensure Transaction in progress. The Select for Update is not enought to allow the LOB update (readwrite) operation.

  -- DBMS_OUTPUT.put_line($$PLSQL_UNIT || '.writeToFile : ' || P_RESOURCE_PATH || '(' || USER || ')');
  -- DBMS_OUTPUT.put_line($$PLSQL_UNIT || '.writeToFile : ' || DBMS_UTILITY.FORMAT_CALL_STACK());

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  update RESOURCE_VIEW
     set RES = updateXML(RES,'/Resource/DisplayName',extract(res,'/Resource/DisplayName'))
   where equals_path(res, P_RESOURCE_PATH) = 1;
$ELSE
  DBMS_XDB.touchResource(P_RESOURCE_PATH);
$END  

  select extractValue(res,'/Resource/XMLLob') 
    into V_EXISTING_CONTENT
    from RESOURCE_VIEW 
   where equals_path(res,P_RESOURCE_PATH) = 1
     for update;
 
  DBMS_LOB.open(V_EXISTING_CONTENT,DBMS_LOB.lob_readwrite);
  DBMS_LOB.append(V_EXISTING_CONTENT,V_BINARY_CONTENT);
  DBMS_LOB.close(V_EXISTING_CONTENT);
  commit;

  DBMS_LOB.freeTemporary(V_BINARY_CONTENT);
  DBMS_LOB.freeTemporary(P_CONTENT);
  P_CONTENT := NULL;
end;
--
procedure createFile(P_FILE_ID VARCHAR2, P_RESOURCE_PATH VARCHAR2 DEFAULT NULL, P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
begin
	G_FILE_HANDLE_LIST(P_FILE_ID).PATH := P_RESOURCE_PATH;
	createFile(P_RESOURCE_PATH,P_OVERWRITE);
end;
--
procedure writeEntry(P_FILE_ID VARCHAR2, P_CONTENT VARCHAR2) 
as
  V_BUFFER            VARCHAR2(32000);    
begin
	if (G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,2,CHR(13) || CHR(10));
	end if;
	DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,LENGTH(P_CONTENT),P_CONTENT);
end;
--
procedure writeEntry(P_FILE_ID VARCHAR2, P_CONTENT CLOB) 
as
begin
	if (G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,2,CHR(13) || CHR(10));
	end if;
  DBMS_LOB.APPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,P_CONTENT);
end;
--
procedure writeEntry(P_FILE_ID VARCHAR2, P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN) 
as
  V_BUFFER            VARCHAR2(32000);    
  V_SERIALIZED_XML    CLOB;
begin
	if (G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,2,CHR(13) || CHR(10));
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
  
  DBMS_LOB.APPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,V_SERIALIZED_XML);
end;
--
procedure writeException(P_FILE_ID VARCHAR2)
as
  V_BUFFER      VARCHAR2(32000);
begin
	if (G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT IS NULL) THEN
	  DBMS_LOB.CREATETEMPORARY(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,TRUE);
	else
    DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,2,CHR(13) || CHR(10));
	end if;

  V_BUFFER := to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : Exception Details' || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_STACK() || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() || CHR(13) || CHR(10);
  DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT,LENGTH(V_BUFFER),V_BUFFER);
end;
--
procedure flushFile(P_FILE_ID VARCHAR2)
as
begin
	if (G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT IS NOT NULL) THEN
  	DBMS_LOB.WRITEAPPEND(G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT, 2, CHR(13) || CHR(10));
    writeToFile(G_FILE_HANDLE_LIST(P_FILE_ID).PATH,G_FILE_HANDLE_LIST(P_FILE_ID).CONTENT);
  end if;
end;
--
function getFilePath(P_FILE_ID VARCHAR2) 
return VARCHAR2
as
begin
	return G_FILE_HANDLE_LIST(P_FILE_ID).PATH;
end;
--
function getFileContent(P_FILE_ID VARCHAR2) return CLOB
as
begin
	return xdburitype(G_FILE_HANDLE_LIST(P_FILE_ID).PATH).getClob();
end;
--
-- Output File
--
procedure createOutputFile(P_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
begin
  createFile(C_OUTPUT_FILE,P_FILE_PATH,P_OVERWRITE);
end;
--
function getOutputFilePath
return VARCHAR2
as
begin
	return getFilePath(C_OUTPUT_FILE);
end;
--
procedure flushOutputFile
as
begin
	flushFile(C_OUTPUT_FILE);
end;
--
procedure writeOutputFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(C_OUTPUT_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
procedure writeOutputFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeOutputFileEntry('Clob Content',FALSE);
	writeEntry(C_OUTPUT_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
procedure writeOutputFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeOutputFileEntry('XML Content',FALSE);
	writeEntry(C_OUTPUT_FILE,P_CONTENT,P_PRETTY_PRINT);
	if (P_FLUSH) then
	  flushOutputFile();
	end if;
end;
--
function getOutputFileContent return CLOB
as
begin
	return getFileContent(C_OUTPUT_FILE);
end;
--
-- Trace File
--
procedure createTraceFile(P_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
begin
  createFile(C_TRACE_FILE,P_FILE_PATH,P_OVERWRITE);
end;
--
function getTraceFilePath
return VARCHAR2
as
begin
	return getFilePath(C_TRACE_FILE);
end;
--
procedure flushTraceFile
as
begin
	flushFile(C_TRACE_FILE);
end;
--
procedure writeTraceFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(C_TRACE_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure writeTraceFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeTraceFileEntry('CLOB Content',FALSE);
	writeEntry(C_TRACE_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure writeTraceFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeTraceFileEntry('XML Content',FALSE);
	writeEntry(C_TRACE_FILE,P_CONTENT,P_PRETTY_PRINT);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
procedure traceException(P_FLUSH BOOLEAN DEFAULT TRUE) 
as  
begin
	writeException(C_TRACE_FILE);
	if (P_FLUSH) then
	  flushTraceFile();
	end if;
end;
--
function getTraceFileContent return CLOB
as
begin
	return getFileContent(C_TRACE_FILE);
end;
--
-- Log File
--
procedure createLogFile(P_TRACE_FILE_PATH VARCHAR2 DEFAULT NULL,P_OVERWRITE BOOLEAN DEFAULT FALSE)
as
  V_PATH VARCHAR2(700) := P_TRACE_FILE_PATH;
begin
	if (V_PATH is NULL) then
	  V_PATH := '/public/' || USER || '_' || XDBPM_INTERNAL_CONSTANTS.getTraceFileId() || '.log';
  end if;
  createFile(C_LOG_FILE,V_PATH,P_OVERWRITE);
end;
--
function getLogFilePath
return VARCHAR2
as
begin
	return getFilePath(C_LOG_FILE);
end;
--
procedure flushLogFile
as
begin
	flushFile(C_LOG_FILE);
end;
--
procedure writeLogFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeEntry(C_LOG_FILE,to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || P_CONTENT);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure writeLogFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeLogFileEntry(to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'CLOB Content',FALSE);
	writeEntry(C_LOG_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure writeLogFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT FALSE) 
as
begin
	writeLogFileEntry(to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'XML Content',FALSE);
	writeEntry(C_LOG_FILE,P_CONTENT,P_PRETTY_PRINT);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
procedure logException(P_FLUSH BOOLEAN DEFAULT TRUE) 
as  
begin
	writeException(C_LOG_FILE);
	if (P_FLUSH) then
	  flushLogFile();
	end if;
end;
--
function getLogFileContent return CLOB
as
begin
	return getFileContent(C_LOG_FILE);
end;
--
-- Debug File
--
function  generateDebugFileName
return VARCHAR2
as
  V_PATH VARCHAR2(700);
begin
  V_PATH := XDBPM_CONSTANTS.FOLDER_USER_DEBUG || '/XDBPM_DEBUG_' || lpad(XDBPM_INTERNAL_CONSTANTS.getTraceFileId(),6,'0');
  if (G_VERSION > 0) then
    V_PATH := V_PATH || '.' || lpad(G_VERSION,6,'0');
  end if;
  V_PATH := V_PATH || '.log';
  return V_PATH;
end;
--
procedure createDebugFolders
as
  pragma autonomous_transaction;
begin
	if (not G_CREATING_DEBUG_FOLDERS) then
		G_CREATING_DEBUG_FOLDERS := TRUE;
    XDBPM_UTILITIES_INTERNAL.createDebugFolders(XDB_USERNAME.GET_USERNAME());
	  G_CREATING_DEBUG_FOLDERS := FALSE;
	end if;
  commit;
end;
--
procedure createDebugFile
as
  V_PATH VARCHAR2(700) := generateDebugFileName;
begin
	begin
    createFile(C_DEBUG_FILE,V_PATH,FALSE);
  exception 
    when OTHERS then
      -- DBMS_OUTPUT.put_line($$PLSQL_UNIT || '.createDebugFile : [' || SQLCODE || '] "' || SQLERRM || '".');
      createFile(C_DEBUG_FILE,V_PATH,FALSE);
	end;	 	
end;
--
procedure switchDebugFile
as 
begin
	G_VERSION := G_VERSION + 1;
  createDebugFile();
end;
--
function getDebugFilePath
return VARCHAR2
as
begin
	return getFilePath(C_DEBUG_FILE);
end;
--
procedure flushDebugFile
as
begin
	flushFile(C_DEBUG_FILE);
end;
--
procedure writeDebugFileEntry(P_CONTENT VARCHAR2,P_FLUSH BOOLEAN DEFAULT TRUE) 
as
begin
	createDebugFile();
	writeEntry(C_DEBUG_FILE,to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || P_CONTENT);
	if (P_FLUSH) then
	  flushDebugFile();
	end if;
end;
--
procedure writeDebugFileEntry(P_CONTENT CLOB,P_FLUSH BOOLEAN DEFAULT TRUE) 
as
begin
	createDebugFile();
	writeDebugFileEntry(to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'CLOB Content');
	writeEntry(C_DEBUG_FILE,P_CONTENT);
	if (P_FLUSH) then
	  flushDebugFile();
	end if;
end;
--
procedure writeDebugFileEntry(P_CONTENT XMLTYPE, P_PRETTY_PRINT BOOLEAN DEFAULT TRUE,P_FLUSH BOOLEAN DEFAULT TRUE) 
as
begin
	createDebugFile();
	writeDebugFileEntry(to_char(systimestamp,'YYYY-MM-DD"T"HH24:MI:SS.FF') || ' : ' || 'XML Content');
	writeEntry(C_DEBUG_FILE,P_CONTENT,P_PRETTY_PRINT);
	if (P_FLUSH) then
	  flushDebugFile();
	end if;
end;
--
procedure debugException(P_FLUSH BOOLEAN DEFAULT TRUE) 
as  
begin
	writeException(C_DEBUG_FILE);
	if (P_FLUSH) then
	  flushDebugFile();
	end if;
end;
--
function getDebugFileContent return CLOB
as
begin
	return getFileContent(C_DEBUG_FILE);
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
