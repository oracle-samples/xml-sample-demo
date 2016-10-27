
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

declare
  non_existant_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );
begin
--
  begin
    execute immediate 'DROP TABLE XFILES_RESULT_CACHE';
  exception
    when non_existant_table  then
      null;
  end;
end;
/
create table XFILES_RESULT_CACHE(
  REQUEST_TIME   TIMESTAMP(6) WITH TIME ZONE,
  USERID         VARCHAR2(128 CHAR),
  RESULT         XMLTYPE,
  GUID           RAW(16)
)
/
--
grant all 
   on XFILES_RESULT_CACHE
   to ANONYMOUS
/
grant all 
   on XFILES_RESULT_CACHE
   to PUBLIC
/
create or replace package XFILES_UTILITIES
authid CURRENT_USER
as  
  function renderAsHTML(P_RESOURCE_PATH VARCHAR2) return CLOB;
  function renderAsText(P_RESOURCE_PATH VARCHAR2) return CLOB;
  function renderAsXHTML(P_RESOURCE_PATH VARCHAR2) return XMLType;
  function generatePreview(P_RESOURCE_PATH VARCHAR2, P_LINES NUMBER DEFAULT 10, P_LINE_SIZE NUMBER DEFAULT 132) return XMLType;

 
  function transformResource(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER) return XMLType;
  function transformResource(P_RESOURCE_PATH VARCHAR2, P_XSL_DOCUMENT XMLType, P_TIMEZONE_OFFSET NUMBER) return XMLType;

  function transformContent(P_CONTENT_PATH VARCHAR2, P_XSL_PATH VARCHAR2) return XMLType;
  function transformContent(P_CONTENT_PATH VARCHAR2, P_XSL_DOCUMENT XMLTYPE)  return XMLType;

  function transformDocument(P_XML_DOCUMENT XMLTYPE,  P_XSL_PATH VARCHAR2) return XMLType;
  function transformDocument(P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE)  return XMLType;  
  
  function transformDocumentToHTML(P_XML_DOCUMENT XMLType, P_XSL_PATH VARCHAR2) return XMLType;
  function transformDocumentToHTML(P_XML_DOCUMENT XMLType, P_XSL_DOCUMENT XMLType) return XMLType;

  procedure enableRSSFeed(P_FOLDER_PATH VARCHAR2, P_ITEMS_CHANGED_IN VARCHAR2);
  procedure disableRSSFeed(P_FOLDER_PATH VARCHAR2);
end;
/
show errors
--
create or replace package body XFILES_UTILITIES
as
--
function renderAsHTML(P_RESOURCE_PATH VARCHAR2) 
return CLOB
as
begin
  return XFILES_RENDERING.renderAsHTML(xdburitype(P_RESOURCE_PATH).getBLOB());
end;
--
function renderAsText(P_RESOURCE_PATH VARCHAR2) 
return CLOB
as
begin
  return XFILES_RENDERING.renderAsText(xdburitype(P_RESOURCE_PATH).getBLOB());
end;
--
function renderAsXHTML(P_RESOURCE_PATH VARCHAR2) 
return XMLType
as
  V_DOCUMENT CLOB;
  V_CONTENT CLOB;
  V_OFFSET  NUMBER;
begin

  -- xdb_debug.writeDebug(P_RESOURCE_PATH);

  dbms_lob.createTemporary(V_DOCUMENT,true);
  dbms_lob.open(V_DOCUMENT,dbms_lob.lob_readwrite);

  V_CONTENT := '<documentContent><![CDATA[';
  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);
  
  V_CONTENT := XFILES_RENDERING.renderAsHTML(xdburitype(P_RESOURCE_PATH).getBLOB());
  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);

  V_CONTENT := ']]></documentContent>';
  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);

  return xmlType(V_DOCUMENT);
end;
--
function generatePreview(P_RESOURCE_PATH VARCHAR2, P_LINES NUMBER DEFAULT 10, P_LINE_SIZE NUMBER DEFAULT 132) 
return XMLType
as
  V_DOCUMENT  CLOB;
  V_CONTENT   CLOB;
  V_OFFSET    NUMBER := 0;
  V_MAX_CHARS NUMBER := (P_LINES * P_LINE_SIZE);
begin

  -- xdb_debug.writeDebug(P_RESOURCE_PATH);

  dbms_lob.createTemporary(V_DOCUMENT,true);
  dbms_lob.open(V_DOCUMENT,dbms_lob.lob_readwrite);

  V_CONTENT := '<documentContent><![CDATA[';
  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);
 
  V_CONTENT := XFILES_RENDERING.renderAsText(xdburitype(P_RESOURCE_PATH).getBLOB());
  if (P_LINES > 0) then
    V_OFFSET  := dbms_lob.instr(V_CONTENT,chr(10),1,P_LINES);
    if (V_OFFSET > 0) then
      DBMS_LOB.trim(V_CONTENT,V_OFFSET);
    end if;
  end if;

  if (DBMS_LOB.getLength(V_CONTENT) > V_MAX_CHARS) then
    DBMS_LOB.trim(V_CONTENT,V_MAX_CHARS);
  end if;

  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);

  V_CONTENT := ']]></documentContent>';
  dbms_lob.append(V_DOCUMENT,V_CONTENT);
  dbms_lob.freeTemporary(V_CONTENT);

  return xmlType(V_DOCUMENT);
end;
--
function xmlToHTML(P_XML_DOCUMENT XMLType, P_XSL_DOCUMENT XMLType) 
return CLOB
as
  V_OUTPUT_HTML CLOB;
begin
	/*
	**
	** return P_XML_DOCUMENT.transform(P_XSL_DOCUMENT).getClobVal();
	**
	** Will Fail with XML Parsing errors...
	**
	*/
	select P_XML_DOCUMENT.transform(P_XSL_DOCUMENT).getClobVal()
	  into V_OUTPUT_HTML 
	  from dual;
	
	return V_OUTPUT_HTML;
end;
--
function outputWithCDATA(P_CLOB CLOB)
return XMLType
as
  V_CLOB   CLOB;
  V_OUTPUT XMLType;
begin
	DBMS_LOB.createTemporary(V_CLOB,FALSE);
	DBMS_LOB.append(V_CLOB,'<![CDATA[');
	DBMS_LOB.append(V_CLOB, P_CLOB);
	DBMS_LOB.append(V_CLOB,']]>');

  select XMLElement(
           "output",
           -- XMLCData(P_CLOB),
           V_CLOB
         )
    into V_OUTPUT
    from dual;

  DBMS_LOB.FREETEMPORARY(V_CLOB);
  return V_OUTPUT;
end;
--
function transformDocumentToHTML(P_XML_DOCUMENT XMLType, P_XSL_DOCUMENT XMLType) 
return XMLType
as
  V_HTML   CLOB;
  V_RESULT XMLType;
begin
	V_HTML := xmlToHTML(P_XML_DOCUMENT,P_XSL_DOCUMENT);
	V_RESULT := outputWithCDATA(V_HTML);
	DBMS_LOB.freeTemporary(V_HTML);
	return V_RESULT;
end;
--
function transformDocumentToHTML(P_XML_DOCUMENT XMLType, P_XSL_PATH VARCHAR2) 
return XMLType
as
begin
	return transformDocumentToHTML(P_XML_DOCUMENT,xdburitype(P_XSL_PATH).getXML());
end;
--
function outputAsCData(P_XML_DOCUMENT XMLType, P_XSL_DOCUMENT XMLType) 
return XMLType
as
  V_RESULT XMLTYPE;
  V_CLOB   CLOB;
begin
	DBMS_LOB.createTemporary(V_CLOB,FALSE);
	DBMS_LOB.append(V_CLOB,'<![CDATA[');
	DBMS_LOB.append(V_CLOB, P_XML_DOCUMENT.transform(P_XML_DOCUMENT).getClobVal());
	DBMS_LOB.append(V_CLOB,']]>');

  select XMLElement(
           "output",
           -- XMLCData(P_XMLDOC.transform(P_XSLDOC))
           -- '<![CDATA[' || P_XMLDOC.transform(P_XSLDOC) || ']]>'
           V_CLOB
         )
    into V_RESULT
    from dual;
    
  DBMS_LOB.FREETEMPORARY(V_CLOB);
  
  return V_RESULT;
end;
--
procedure enableRSSFeed(P_FOLDER_PATH VARCHAR2, P_ITEMS_CHANGED_IN VARCHAR2)
as 
  V_RSS_METADATA  XMLType;
  V_TEMP           NUMBER(1);
begin

  select xmlElement
         (
           evalname(XFILES_CONSTANTS.ELEMENT_RSS),
           xmlAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES_RSS as "xmlns"),
           xmlElement("ItemsChangedIn", P_ITEMS_CHANGED_IN)
         )
    into V_RSS_METADATA
    from dual;

  begin
    select 1 
      into V_TEMP
      from RESOURCE_VIEW
     where equals_path(RES,P_FOLDER_PATH) = 1
       and existsNode(RES,'/r:Resource/rss:' || XFILES_CONSTANTS.ELEMENT_RSS, DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R || ' ' || XFILES_CONSTANTS.NSPREFIX_XFILES_RSS_RSS) = 1;
     dbms_xdb.updateResourceMetadata(P_FOLDER_PATH, XFILES_CONSTANTS.NAMESPACE_XFILES_RSS, XFILES_CONSTANTS.ELEMENT_RSS, V_RSS_METADATA);
  exception
    when no_data_found then
      dbms_xdb.appendResourceMetadata(P_FOLDER_PATH, V_RSS_METADATA);
    when others then
      raise;
  end;

end;
--
procedure disableRSSFeed(P_FOLDER_PATH VARCHAR2)
as
begin
  dbms_xdb.deleteResourceMetadata(P_FOLDER_PATH, XFILES_CONSTANTS.NAMESPACE_XFILES_RSS, XFILES_CONSTANTS.ELEMENT_RSS);
end;
--
function transformDocumentAsXML(P_XML_DOCUMENT XMLTYPE, P_XSL_DOCUMENT XMLTYPE)
return XMLType
as
  V_TRANSFORMATION XMLTYPE;
begin
  select XMLELEMENT(
           "XMLTRANSFORM",
            XMLTRANSFORM(P_XML_DOCUMENT,P_XSL_DOCUMENT)
         )
     into V_TRANSFORMATION
     from DUAL;
     
  return V_TRANSFORMATION;
end;
--
function transformDocumentAsCLOB(P_XML_DOCUMENT XMLTYPE, P_XSL_DOCUMENT XMLTYPE)
return XMLType
as
  V_TRANSFORMATION XMLTYPE;
begin
  select XMLELEMENT(
           "XMLTRANSFORM",
           XMLSERIALIZE(
             DOCUMENT
             XMLTRANSFORM(P_XML_DOCUMENT,P_XSL_DOCUMENT)
             AS CLOB NO INDENT
           )
         )
     into V_TRANSFORMATION
     from DUAL;
     
  return V_TRANSFORMATION;
end;
--
function transformResource(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER)
return XMLType
as
begin
  return transformResource(P_RESOURCE_PATH,xdburitype(P_XSL_PATH).getXML(), P_TIMEZONE_OFFSET);
end;
--
function transformResource(P_RESOURCE_PATH VARCHAR2, P_XSL_DOCUMENT XMLTYPE, P_TIMEZONE_OFFSET NUMBER)
return XMLType
as
  V_RESOURCE XMLType;
begin
  XDB_REPOSITORY_SERVICES.getResource(P_RESOURCE_PATH, FALSE, P_TIMEZONE_OFFSET, V_RESOURCE);
  return transformDocument(V_RESOURCE,P_XSL_DOCUMENT);
end;
--
function transformContent(P_CONTENT_PATH VARCHAR2, P_XSL_PATH VARCHAR2)
return XMLType
as
begin
  return transformContent(P_CONTENT_PATH, xdburitype(P_XSL_PATH).getXML());
end;
--
function transformContent(P_CONTENT_PATH VARCHAR2, P_XSL_DOCUMENT XMLTYPE)
return XMLType
as
begin
  return transformDocument(xdburitype(P_CONTENT_PATH).getXML(),P_XSL_DOCUMENT);
end;
--
function transformDocument(P_XML_DOCUMENT XMLType, P_XSL_PATH VARCHAR2)
return XMLType
as
begin
  return transformDocument(P_XML_DOCUMENT,xdburitype(P_XSL_PATH).getXML());
end;
--
function transformDocument(P_XML_DOCUMENT XMLTYPE, P_XSL_DOCUMENT XMLTYPE)
return XMLType
as
begin
	return transformDocumentAsCLOB(P_XML_DOCUMENT,P_XSL_DOCUMENT);
end;
--
end;
/
show errors
--
