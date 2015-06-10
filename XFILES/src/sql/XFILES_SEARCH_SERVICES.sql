
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
create or replace package XFILES_SEARCH_SERVICES
AUTHID CURRENT_USER
as
  function getXMLIndexRootNodeMap(P_PATH_TABLE_NAME VARCHAR2, P_PATH_TABLE_OWNER VARCHAR2) return XMLType;
  function getXMLIndexChildNodeMap(P_PATHID VARCHAR2, P_PATH_TABLE_NAME VARCHAR2, P_PATH_TABLE_OWNER VARCHAR2) return XMLType;

  function getXMLSchemaRootNodeMap(P_SCHEMA_URL varchar2, P_SCHEMA_OWNER varchar2 default USER, P_GLOBAL_ELEMENT varchar2) return XMLType;
  function getXMLSchemaChildNodeMap(P_PROPERTY_NUMBER number) return XMLType;
  function getSubstitutionGroup(P_HEAD_ELEMENT NUMBER)  return XMLType;
  
  function getRepositoryNodeMap return XMLType;
  function getDataGuideNodeMap(P_TABLE_NAME VARCHAR2, P_COLUMN_NAME VARCHAR2) return xmlType;

end;
/
show errors
--
create or replace package body XFILES_SEARCH_SERVICES
as
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/XFILES/XFILES_SEARCH_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/XFILES/XFILES_SEARCH_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure handleException(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)
as
  V_STACK_TRACE XMLType;
  V_RESULT      boolean;
begin
  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
  rollback; 
  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);
end;
--
function GETXMLINDEXROOTNODEMAP(P_PATH_TABLE_NAME VARCHAR2, P_PATH_TABLE_OWNER VARCHAR2) 
return xmlType
as  
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("pathTable",P_PATH_TABLE_NAME),
           xmlElement("pathTableOwner",P_PATH_TABLE_OWNER)
         )
    into V_PARAMETERS
    from dual;
  
  V_RESULT := XDB_XMLINDEX_SEARCH.getRootNodeMap(P_PATH_TABLE_NAME,P_PATH_TABLE_OWNER);  
  writeLogRecord('GETXMLINDEXROOTNODEMAP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETXMLINDEXROOTNODEMAP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETXMLINDEXCHILDNODEMAP(P_PATHID VARCHAR2, P_PATH_TABLE_NAME VARCHAR2, P_PATH_TABLE_OWNER VARCHAR2)
return xmlType
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("pathId",P_PATHID),
           xmlElement("pathTable",P_PATH_TABLE_NAME),
           xmlElement("pathTableOwner",P_PATH_TABLE_OWNER)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_XMLINDEX_SEARCH.getChildNodeMap(P_PATHID,P_PATH_TABLE_NAME,P_PATH_TABLE_OWNER);  
  writeLogRecord('GETXMLINDEXCHILDNODEMAP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETXMLINDEXCHILDNODEMAP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETXMLSCHEMAROOTNODEMAP(P_SCHEMA_URL varchar2, P_SCHEMA_OWNER varchar2 default USER, P_GLOBAL_ELEMENT varchar2)
return xmlType
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("schemaURL",P_SCHEMA_URL),
           xmlElement("schemaOwner",P_SCHEMA_OWNER),
           xmlElement("globalElement",P_GLOBAL_ELEMENT)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_XMLSCHEMA_SEARCH.getRootNodeMap(P_SCHEMA_URL,P_SCHEMA_OWNER,P_GLOBAL_ELEMENT);
  writeLogRecord('GETXMLSCHEMAROOTNODEMAP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETXMLSCHEMAROOTNODEMAP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETXMLSCHEMACHILDNODEMAP(P_PROPERTY_NUMBER number)
return xmlType
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("propertyNumber",P_PROPERTY_NUMBER)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_XMLSCHEMA_SEARCH.getChildNodeMap(P_PROPERTY_NUMBER);
  writeLogRecord('GETXMLSCHEMACHILDNODEMAP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETXMLSCHEMACHILDNODEMAP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETSUBSTITUTIONGROUP(P_HEAD_ELEMENT number)
return xmlType
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("headElementId",P_HEAD_ELEMENT)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_XMLSCHEMA_SEARCH.getSubstitutionGroup(P_HEAD_ELEMENT);
  writeLogRecord('GETSUBSTITUTIONGROUP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETSUBSTITUTIONGROUP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETREPOSITORYNODEMAP
return xmlType
as 
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  V_RESULT := XDB_REPOSITORY_SEARCH.getNodeMap();
  writeLogRecord('GETREPOSITORYNODEMAP',V_INIT,NULL);
  return V_RESULT;
exception
  when others then
    handleException('GETREPOSITORYNODEMAP',V_INIT,NULL);
    raise;
end;
--
function getDataGuideNodeMap(P_TABLE_NAME VARCHAR2, P_COLUMN_NAME VARCHAR2) 
return xmlType
as  
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP; 
  V_RESULT            XMLType;
begin
  select xmlConcat
         (
           xmlElement("table",P_TABLE_NAME),
           xmlElement("column",P_COLUMN_NAME)
         )
    into V_PARAMETERS
    from dual;
  
  V_RESULT := XDB_DATAGUIDE_SEARCH.getDataGuideNodeMap(P_TABLE_NAME,P_COLUMN_NAME);  
  writeLogRecord('GETDATAGUIDENODEMAP',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GETDATAGUIDENODEMAP',V_INIT,V_PARAMETERS);
    raise;
end;
--
end;
/
show errors
--
