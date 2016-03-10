
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
alter session set current_schema = XDBPM
/
--
create or replace package XDBPM_SYSDBA_HELPER
as
  procedure writeToTraceFile(P_COMMENT VARCHAR2);
  procedure flushTraceFile;

  function getXMLReference(P_PATH VARCHAR2) return REF XMLType;
  function getXMLReferenceByResID(P_RESOID RAW) return REF XMLType;

  procedure resetLobLocator(P_RESID RAW);
  procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER);
  procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER);
  procedure setXMLContent(P_RESID RAW);
  procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE);
  procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER);

  procedure releaseDavLocks;
  procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2);
  
  procedure cleanupSchema(P_OWNER VARCHAR2);
  
  function hasTraceFileAccess return BOOLEAN;
  procedure createTraceFileDirectory;

end;
/
show errors
--
create or replace package body XDBPM_SYSDBA_HELPER
as
--
  UNIMPLEMENTED_FEATURE EXCEPTION;
  PRAGMA EXCEPTION_INIT( UNIMPLEMENTED_FEATURE , -03001 );
--
procedure flushTraceFile
as
begin
  NULL;
end;
--
procedure writeToTraceFile(P_COMMENT VARCHAR2)
as
begin
  NULL;
end;
--  
function getXMLReferenceByResID(P_RESOID RAW)
return REF XMLType
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
function getXMLReference(P_PATH VARCHAR2)
return REF XMLType
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure resetLobLocator(P_RESID RAW)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure setBinaryContent(P_RESID RAW, P_SCHEMA_OID RAW, P_BINARY_ELEMENT_ID NUMBER)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure setTextContent(P_RESID RAW, P_SCHEMA_OID RAW, P_TEXT_ELEMENT_ID NUMBER)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure setXMLContent(P_RESID RAW)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure setXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure setSBXMLContent(P_RESID RAW, P_XMLREF REF XMLTYPE, P_SCHEMA_OID RAW, P_GLOBAL_ELEMENT_ID NUMBER)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure releaseDavLocks
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure updateRootInfoRCList(P_NEW_OIDLIST VARCHAR2)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
procedure cleanupSchema(P_OWNER VARCHAR2)
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
function hasTraceFileAccess
return BOOLEAN
as
begin
	return FALSE;
end;
--
procedure createTraceFileDirectory
as
begin
  raise UNIMPLEMENTED_FEATURE;
end;
--
end;
/
show errors 
--

