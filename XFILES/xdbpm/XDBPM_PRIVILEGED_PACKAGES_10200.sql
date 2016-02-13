
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "as IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
create or replace package XDBPM_RV_HELPER
AUTHID &RIGHTS
as
  procedure deleteResource(P_RESOURCE_PATH VARCHAR2);
  procedure deleteResource(P_XMLREF REF XMLType);

  function existsResource(P_RESOURCE_PATH VARCHAR2) return BOOLEAN;
  function existsResource(P_XMLREF REF XMLType) return BOOLEAN;
  --
end;
/
show errors 
--
create or replace package body XDBPM_RV_HELPER
as
procedure deleteResource(P_RESOURCE_PATH VARCHAR2)
as
begin
	XDB.XDBPM_RV_HELPER.deleteResource(P_RESOURCE_PATH) ;
end;
--
procedure deleteResource(P_XMLREF REF XMLType)
as
begin
	XDB.XDBPM_RV_HELPER.deleteResource(P_XMLREF) ;
end;  
--
function existsResource(P_RESOURCE_PATH VARCHAR2)
return BOOLEAN
as
begin 
  return XDB.XDBPM_RV_HELPER.existsResource(P_RESOURCE_PATH);
end;
--
function existsResource(P_XMLREF REF XMLType)
return BOOLEAN
as
begin
  return XDB.XDBPM_RV_HELPER.existsResource(P_XMLREF);
end;
--
end;
/
show errors
--
create or replace package XDBPM_RESCONFIG_HELPER
AUTHID &RIGHTS
as
  function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) return VARCHAR2;
end;
/
show errors
--
create or replace package body XDBPM_RESCONFIG_HELPER
as
function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) 
return VARCHAR2
as
begin
  return XDB.XDBPM_RESCONFIG_HELPER.getUploadFolderPath(P_TABLE_NAME, P_OWNER); 
end;
--
end;
/
show errors
--
