
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
create or replace package XFILES_WIKI_SERVICES 
AUTHID CURRENT_USER
as
  C_NAMESPACE_XFILES_WIKI     constant VARCHAR2(128) := XFILES_CONSTANTS.NAMESPACE_XFILES || '/wiki';
  C_NSPREFIX_XFILES_WIKI_WIKI constant VARCHAR2(128) := 'xmlns:wiki="' || C_NAMESPACE_XFILES_WIKI || '"';
  C_SCHEMAURL_XFILES_WIKI     constant VARCHAR2(128) := XFILES_CONSTANTS.NAMESPACE_XFILES || '/XFilesWiki.xsd';
  C_NAMESPACE_XHTML           constant VARCHAR2(128) := 'http://www.w3.org/1999/xhtml';
  C_NSPREFIX_XHMTL_DEFAULT    constant VARCHAR2(128) := 'xmlns="' || C_NAMESPACE_XHTML || '"';
  C_ELEMENT_WIKI              constant VARCHAR2(256) := 'XFilesWikiPage';

  function  NAMESPACE_XFILES_WIKI     return VARCHAR2 deterministic;
  function  NSPREFIX_XFILES_WIKI_WIKI return VARCHAR2 deterministic;
  function  SCHEMAURL_XFILES_WIKI     return VARCHAR2 deterministic;
  function  NAMESPACE_XHTML           return VARCHAR2 deterministic;
  function  NSPREFIX_XHTML_DEFAULT    return VARCHAR2 deterministic;
  function  ELEMENT_WIKI              return VARCHAR2 deterministic;

  procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_COMMENT VARCHAR2);
  procedure UPDATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_CONTENTS XMLTYPE);
  
end;
/
show errors
--
create or replace package body XFILES_WIKI_SERVICES
as
function NAMESPACE_XFILES_WIKI     return VARCHAR2 deterministic as begin return C_NAMESPACE_XFILES_WIKI; end;
--
function NSPREFIX_XFILES_WIKI_WIKI return VARCHAR2 deterministic as begin return C_NSPREFIX_XFILES_WIKI_WIKI; end;
--
function SCHEMAURL_XFILES_WIKI     return VARCHAR2 deterministic as begin return C_SCHEMAURL_XFILES_WIKI; end;
--
function NAMESPACE_XHTML           return VARCHAR2 deterministic as begin return C_NAMESPACE_XHTML; end;
--
function NSPREFIX_XHTML_DEFAULT    return VARCHAR2 deterministic as begin return C_NSPREFIX_XHMTL_DEFAULT; end;
--
function ELEMENT_WIKI              return VARCHAR2 deterministic as begin return C_ELEMENT_WIKI; end;
--
procedure writeLogRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/XFILES/XFILES_WIKI_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/XFILES/XFILES_WIKI_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
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
function createEmptyWikiPage 
return XMLType deterministic
as
begin
  return XMLType('<wiki:' || ELEMENT_WIKI || ' ' || NSPREFIX_XFILES_WIKI_WIKI || ' ' || NSPREFIX_XHTML_DEFAULT || ' ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI || ' xsi:schemaLocation="' || NAMESPACE_XFILES_WIKI || ' ' || SCHEMAURL_XFILES_WIKI || '"/>');
end;
--
procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_COMMENT VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_STACK_TRACE       XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            BOOLEAN;
  V_RESID             RAW(16);
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
begin
  select XMLConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Comment",P_COMMENT)
         )
    into V_PARAMETERS
    from dual;
    
  V_RESULT := DBMS_XDB.CREATERESOURCE(P_RESOURCE_PATH,createEmptyWikiPage());

  if (P_COMMENT is not NULL) then
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);
    DBMS_XDBRESOURCE.save(V_RESOURCE);
  end if;

  V_RESID := DBMS_XDB_VERSION.MAKEVERSIONED(P_RESOURCE_PATH);
  writeLogRecord('CREATEWIKIPAGE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CREATEWIKIPAGE',V_INIT,V_PARAMETERS);
    raise;  
end;
--
procedure UPDATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_CONTENTS XMLTYPE)
as
  V_PARAMETERS        XMLType;
  V_STACK_TRACE       XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
 
  V_RESULT BOOLEAN;   
  V_RESID             RAW(16); 
begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("WikiPage",P_CONTENTS)
         )
    into V_PARAMETERS
    from dual;

  DBMS_XDB_VERSION.CheckOut(P_RESOURCE_PATH);  

  update RESOURCE_VIEW 
      set res = updateXML
                (
                  res,
                  '/Resource/DisplayName/text()',
                  extractValue(res,'/Resource/DisplayName')
                ) 
    where equals_path(res,P_RESOURCE_PATH) = 1;
  
  update &XFILES_SCHEMA..XFILES_WIKI_TABLE w     
     set object_value = P_CONTENTS
   where ref(w) = ( 
                    select extractValue(res,'/Resource/XMLRef') 
                      from RESOURCE_VIEW
                     where equals_path(res,P_RESOURCE_PATH) = 1
                  );

  V_RESID := DBMS_XDB_VERSION.CheckIn(P_RESOURCE_PATH);
  writeLogRecord('UPDATEWIKIPAGE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UPDATEWIKIPAGE',V_INIT,V_PARAMETERS);
    raise;  
end;
--
end;
/
show errors
--
