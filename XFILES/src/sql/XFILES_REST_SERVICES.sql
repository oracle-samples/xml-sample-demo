
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
create or replace package XFILES_REST_SUPPORT
as
   function transformCacheToHTML(P_GUID RAW,P_XSL_PATH VARCHAR2) return CLOB;

  procedure writeLogRecord(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType);
  procedure writeErrorRecord(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType);

  procedure handleException(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE);

  procedure writeServletOutputStream(P_CONTENT VARCHAR2,P_CONTENT_TYPE VARCHAR2);
  procedure writeServletOutputStream(P_CONTENT IN OUT CLOB,P_CONTENT_TYPE VARCHAR2);
  procedure writeServletOutputStream(P_XML XMLTYPE, P_CONTENT_TYPE BOOLEAN DEFAULT TRUE);
end;
/
show errors
--
create or replace package body XFILES_REST_SUPPORT
as
--
function transformCacheToHTML(P_GUID RAW,P_XSL_PATH VARCHAR2) 
return CLOB
as
  V_RESULT CLOB;
begin
	select rc.RESULT.transform(xdburitype(P_XSL_PATH).getXML()).getClobVal()
    into V_RESULT
    from XFILES_RESULT_CACHE rc
   where GUID = P_GUID;
    
  delete
    from XFILES_RESULT_CACHE
   where GUID = P_GUID;
   
  return V_RESULT;
end;
--
procedure writeLogRecord(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord(P_SERVLET_URL, P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord(P_SERVLET_URL ,P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure handleException(P_SERVLET_URL VARCHAR2, P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)
as
  V_STACK_TRACE XMLType;
  V_RESULT      boolean;
begin
  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
  writeErrorRecord(P_SERVLET_URL, P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);
  rollback; 
end;
--
procedure writeServletOutputStream(P_CONTENT VARCHAR2,P_CONTENT_TYPE VARCHAR2)
as
  V_CONTENT_SIZE   BINARY_INTEGER := 0;
begin
	OWA_UTIL.MIME_HEADER(P_CONTENT_TYPE,FALSE);
	V_CONTENT_SIZE := LENGTH(P_CONTENT);
  htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;
  htp.prn(P_CONTENT);
  htp.flush();
end;
--	
procedure writeServletOutputStream(P_CONTENT IN OUT CLOB,P_CONTENT_TYPE VARCHAR2)
as
  V_BUFFER         VARCHAR2(8192) ;
  V_OFFSET         BINARY_INTEGER := 1;
  V_AMOUNT         BINARY_INTEGER := 4096;
begin
	OWA_UTIL.MIME_HEADER(P_CONTENT_TYPE,FALSE);
	-- V_CONTENT_SIZE := DBMS_LOB.getLength(P_CONTENT);
  -- htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;
  
  loop
    begin
    	DBMS_LOB.read(P_CONTENT,V_AMOUNT,V_OFFSET,V_BUFFER);
    	V_OFFSET := V_OFFSET + V_AMOUNT;
    	V_AMOUNT := 4000;
      htp.prn(V_BUFFER);
    exception
      when NO_DATA_FOUND then
        exit;
    end;
  end loop;    	
  htp.flush();
  DBMS_LOB.FREETEMPORARY(P_CONTENT);
end;
--	
procedure writeServletOutputStream(P_XML XMLTYPE, P_CONTENT_TYPE BOOLEAN DEFAULT TRUE)
as
  V_SERIALIZED_XML CLOB;
begin
	if (P_CONTENT_TYPE) THEN
	  select XMLSERIALIZE(DOCUMENT P_XML AS CLOB INDENT SIZE = 2)
	    into V_SERIALIZED_XML 
	    from dual;
	else
	  select XMLSERIALIZE(DOCUMENT P_XML AS CLOB)
	    into V_SERIALIZED_XML 
	    from dual;
	end if;
	writeServletOutputStream(V_SERIALIZED_XML,'text/xml');
end;
--
end;
/
show errors
--
create or replace package XFILES_REST_SERVICES
AUTHID CURRENT_USER
as
  C_DEFAULT_TEMPLATE_PATH   constant VARCHAR2(700) := '/XFILES/lite/Folder.html';
  C_DEFAULT_STYLESHEET_PATH constant VARCHAR2(700) := '/XFILES/lite/xsl/FolderBrowser.xsl';
  
  function DEFAULT_TEMPLATE_PATH   return VARCHAR2 deterministic;
  function DEFAULT_STYLESHEET_PATH return VARCHAR2 deterministic;
  
  function getResource(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0) return XMLType;
  function getResourceWithContent(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0) return XMLType;
  function getFolderListing(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_EXTENDED_METADATA VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT NUMBER DEFAULT 0) return XMLType;
  function getVersionHistory(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT NUMBER DEFAULT 0) return XMLType;

  procedure getResource(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0);
  procedure getResourceWithContent(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0);
  procedure getFolderListing(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_EXTENDED_METADATA VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT IN NUMBER DEFAULT 0);
  procedure getVersionHistory(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT IN NUMBER DEFAULT 0);

  procedure transformDocumentToHTML(P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE);
  procedure transformCacheToHTML(P_GUID RAW, P_XSL_PATH VARCHAR2);
  procedure transformContentToHTML(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2);
  procedure xslInlineInclude(P_XSL_PATH VARCHAR2);
  
  procedure enableRSSIcon(P_FOLDER_PATH VARCHAR2);
  procedure enableRSSIcon(P_RESOURCE_PATH VARCHAR2,P_TEMPLATE_PATH VARCHAR2,P_STYLESHEET_PATH VARCHAR2,P_FORCE_AUTHENTICATION VARCHAR2);
  procedure generateRSSFeed(P_RESOURCE_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure renderDocument(P_RESOURCE_PATH VARCHAR2, P_CONTENT_TYPE VARCHAR2);

  procedure whoami;
  procedure doAuthentication;
  procedure showSourceCode(SOURCECODE VARCHAR2);

  procedure WRITELOGRECORD(LOG_RECORD VARCHAR2);

end;
/
show errors
--
create or replace package body XFILES_REST_SERVICES
as
--
  JAVA_SERVLET_URL    CONSTANT VARCHAR2(1024) := '/sys/servlets/XFILES/XFilesSupport/dbRestServices/&XFILES_SCHEMA/XFILES_REST_SERVICES/';
  EPG_SERVLET_URL     CONSTANT VARCHAR2(1024) := '/sys/servlets/XFILES/RestService/&XFILES_SCHEMA..XFILES_REST_SERVICES.';

  G_INLINE_IMPORT_XSL CONSTANT        XMLType := XMLType(
'<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0">
	<xsl:output method="xml"/>

	<!-- identity transform -->
	<xsl:template match="@*|node()">
	   <xsl:copy>
	      <xsl:apply-templates select="@*|node()"/>
	   </xsl:copy>
	</xsl:template>

	<xsl:template match="xsl:import|xsl:include">
		<xsl:param name="elementsAlreadyDefined" select="/xsl:stylesheet/*"/>

		<xsl:variable name="newDocument" select="document(@href)"/>
		<xsl:variable name="newTopLevelElements" select="$newDocument/xsl:stylesheet/*" />

		<!-- merge -->
		<!-- there may be a more general way to do this -->
		<!-- filter templates -->
		<xsl:variable name="filteredNewTemplates" 
			select="$newTopLevelElements[self::xsl:template]
							[not(@name = $elementsAlreadyDefined[self::xsl:template]/@name)]
							[not(@match = $elementsAlreadyDefined[self::xsl:template]/@match)]" />


		<!-- params -->
		<xsl:variable name="filteredNewParams" 
			select="$newTopLevelElements[self::xsl:param]
						[not( @name = $elementsAlreadyDefined[self::xsl:param]/@name )]"/>

		
		<!-- output -->
		<xsl:variable name="filteredNewOutput" 
			select="$newTopLevelElements[self::xsl:output]
						[not( $elementsAlreadyDefined[self::xsl:output] )]"/>

		<!-- variable -->
		<xsl:variable name="filteredNewVariables" 
			select="$newTopLevelElements[self::xsl:variable]
						[not( @name = $elementsAlreadyDefined[self::xsl:variable]/@name )]"/>

		<!-- filteredNewTopLevelElements -->
		<xsl:variable name="filteredNewTopLevelElements" select="$filteredNewTemplates | $filteredNewParams | $filteredNewOutput | $filteredNewVariables"/>

		<!-- combine old and new top-level elements -->
		<xsl:variable name="combinedElementsAlreadyDefined" select="$filteredNewTopLevelElements | $elementsAlreadyDefined"/>

		<!-- recursive import -->
		<xsl:apply-templates select="$newTopLevelElements[self::xsl:import|self::xsl:include]">
			<xsl:with-param name="elementsAlreadyDefined" select="$combinedElementsAlreadyDefined"/>
		</xsl:apply-templates>

		<!-- copy all other nodes -->
		<xsl:apply-templates select="$filteredNewTopLevelElements"/>

	</xsl:template>

</xsl:stylesheet>');
--	
function DEFAULT_TEMPLATE_PATH 
return VARCHAR2 deterministic
as
begin
	return C_DEFAULT_TEMPLATE_PATH;
end;
--
function DEFAULT_STYLESHEET_PATH 
return VARCHAR2 deterministic
as
begin
	return C_DEFAULT_STYLESHEET_PATH;
end;
--
function getResource(P_SERVLET_URL VARCHAR2, P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER,P_CACHE_RESULT IN NUMBER)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RESOURCE XMLType;
begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)           
         )
    into V_PARAMETERS
    from dual;
  
  XDB_REPOSITORY_SERVICES.getResource(P_RESOURCE_PATH, FALSE, P_TIMEZONE_OFFSET, V_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(V_RESOURCE);
	end if;
	XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'GETRESOURCE',V_INIT,V_PARAMETERS);
  return V_RESOURCE;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'GETRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
function getResource(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
return XMLType
as
begin
  return getResource(P_SERVLET_URL => JAVA_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
end;
-- 
procedure getResource(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
as
  V_RESOURCE XMLType;
begin
	V_RESOURCE := getResource(P_SERVLET_URL => EPG_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESOURCE, FALSE);
end;
--
function getResourceWithContent(P_SERVLET_URL VARCHAR2, P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER,P_CACHE_RESULT IN NUMBER)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RESOURCE XMLType;
begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getResource(P_RESOURCE_PATH, TRUE, P_TIMEZONE_OFFSET, V_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(V_RESOURCE);
	end if;
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'GETRESOURCEWITHCONTENT',V_INIT,V_PARAMETERS);
	return V_RESOURCE;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'GETRESOURCEWITHCONTENT',V_INIT,V_PARAMETERS);
    raise;
end;
--
function getResourceWithContent(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
return XMLType
as
begin
  return getResourceWithContent(P_SERVLET_URL => JAVA_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
end;
--
procedure getResourceWithContent(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
as
  V_RESOURCE XMLType;
begin
	V_RESOURCE := getResourceWithContent(P_SERVLET_URL => EPG_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESOURCE, FALSE);
end;
--
function getFolderListing(P_SERVLET_URL VARCHAR2, P_FOLDER_PATH in VARCHAR2, P_INCLUDE_EXTENDED_METADATA BOOLEAN, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RESOURCE XMLType;
  V_CHILDREN XMLType;
begin
  select xmlConcat
         (
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("IncludeMetadata",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_INCLUDE_EXTENDED_METADATA)),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getFolderListing(P_FOLDER_PATH, P_INCLUDE_EXTENDED_METADATA, P_TIMEZONE_OFFSET, V_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(V_RESOURCE);
	end if;
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'GETFOLDERLISTING',V_INIT,V_PARAMETERS);
  return V_RESOURCE;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'GETFOLDERLISTING',V_INIT,V_PARAMETERS);
    raise;
end;
--
function getFolderListing(P_FOLDER_PATH in VARCHAR2, P_INCLUDE_EXTENDED_METADATA VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0)
return XMLType
as
begin
  return getFolderListing(
           P_SERVLET_URL               => JAVA_SERVLET_URL, 
           P_FOLDER_PATH               => P_FOLDER_PATH, 
           P_INCLUDE_EXTENDED_METADATA => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(P_INCLUDE_EXTENDED_METADATA), 
           P_TIMEZONE_OFFSET           => P_TIMEZONE_OFFSET, 
           P_CACHE_RESULT              => P_CACHE_RESULT
         );
end;
--
procedure getFolderListing(P_FOLDER_PATH in VARCHAR2, P_INCLUDE_EXTENDED_METADATA VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT IN NUMBER DEFAULT 0)
as
  V_RESOURCE XMLType;
begin
	V_RESOURCE := getFolderListing(
	                P_SERVLET_URL               => EPG_SERVLET_URL, 
	                P_FOLDER_PATH               => P_FOLDER_PATH, 
	                P_INCLUDE_EXTENDED_METADATA => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(P_INCLUDE_EXTENDED_METADATA), 
	                P_TIMEZONE_OFFSET           => P_TIMEZONE_OFFSET, 
	                P_CACHE_RESULT              => P_CACHE_RESULT
	              );
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESOURCE, FALSE);
end;
--
function getVersionHistory(P_SERVLET_URL VARCHAR2, P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER,P_CACHE_RESULT IN NUMBER)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RESOURCE          XMLType;

begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)           
         )
    into V_PARAMETERS
    from dual;
  
  XDB_REPOSITORY_SERVICES.getVersionHistory(P_RESOURCE_PATH, P_TIMEZONE_OFFSET, V_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(V_RESOURCE);
	end if;
	XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'GETVERSIONHISTORY',V_INIT,V_PARAMETERS);
  return V_RESOURCE;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'GETVERSIONHISTORY',V_INIT,V_PARAMETERS);
    raise;
end;
--
function getVersionHistory(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
return XMLType
as
begin
  return getVersionHistory(P_SERVLET_URL => JAVA_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
end;
-- 
procedure getVersionHistory(P_RESOURCE_PATH in VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_CACHE_RESULT IN NUMBER DEFAULT 0)
as
  V_RESOURCE XMLType;
begin
	V_RESOURCE := getResource(P_SERVLET_URL => EPG_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET,P_CACHE_RESULT => P_CACHE_RESULT);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESOURCE, FALSE);
end;
--
function generateRSSFeed(P_SERVLET_URL VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) 
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RSS_DOCUMENT      DBMS_XMLDOM.DOMDocument;
  V_NODE              DBMS_XMLDOM.DOMNode;
  V_ITEM	            DBMS_XMLDOM.DOMNode;
  V_RSS_CHANNEL       DBMS_XMLDOM.DOMNode;
  V_RSS_ROOT          DBMS_XMLDOM.DOMElement;
  
  cursor getResource
  is
  select DISPLAY_NAME, DESCRIPTION
    from RESOURCE_VIEW rv,
         XMLTable
         (
           xmlNamespaces
           (
             default 'http://xmlns.oracle.com/xdb/XDBResource.xsd'
           ),
           '/Resource' passing rv.RES
           columns
           DISPLAY_NAME varchar2(128)                 path 'DisplayName',
           DESCRIPTION  varchar2(4000)                path 'Comment'
         ) r     
   where equals_path(res,P_RESOURCE_PATH) = 1;

  cursor getChildren
  is
  select ANY_PATH, DISPLAY_NAME, DESCRIPTION, AUTHOR, MODIFICATION_DATE
    from RESOURCE_VIEW rv,
         XMLTable
         (
           xmlNamespaces
           (
             default 'http://xmlns.oracle.com/xdb/XDBResource.xsd'
           ),
           '/Resource' passing rv.RES
           columns
           DISPLAY_NAME varchar2(128)                 path 'DisplayName',
           DESCRIPTION  varchar2(4000)                path 'Comment',
           AUTHOR       varchar2(128)                 path 'Author',
           MODIFICATION_DATE TIMESTAMP with TIME ZONE path 'ModificationDate'
         ) r     
   where under_path(res,1,P_RESOURCE_PATH) = 1;
begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET)
         )
    into V_PARAMETERS
    from dual;

  V_RSS_DOCUMENT := DBMS_XMLDOM.newDOMDocument();
  V_RSS_ROOT := DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'rss');
  V_RSS_ROOT := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(V_RSS_DOCUMENT),DBMS_XMLDOM.makeNode(V_RSS_ROOT)));
  DBMS_XMLDOM.setAttribute(V_RSS_ROOT,'version','2.0');
  
  V_RSS_CHANNEL := DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'channel'));
  V_RSS_CHANNEL := DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(V_RSS_ROOT),V_RSS_CHANNEL);

  for r in getResource() loop
    V_NODE := DBMS_XMLDOM.appendChild(V_RSS_CHANNEL,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'title')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,r.DISPLAY_NAME)));
    V_NODE := DBMS_XMLDOM.appendChild(V_RSS_CHANNEL,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'description')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,r.DESCRIPTION)));
  end loop;
  
  for c in getChildren() loop
    V_ITEM := DBMS_XMLDOM.appendChild(V_RSS_CHANNEL,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'item')));
    V_NODE := DBMS_XMLDOM.appendChild(V_ITEM,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'title')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,c.DISPLAY_NAME)));
    V_NODE := DBMS_XMLDOM.appendChild(V_ITEM,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'description')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,c.DESCRIPTION)));
    V_NODE := DBMS_XMLDOM.appendChild(V_ITEM,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'link')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,c.ANY_PATH)));
    V_NODE := DBMS_XMLDOM.appendChild(V_ITEM,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'author')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,c.AUTHOR)));
    V_NODE := DBMS_XMLDOM.appendChild(V_ITEM,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_RSS_DOCUMENT,'pubdata')));
    V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_RSS_DOCUMENT,c.MODIFICATION_DATE)));
  end loop;
  
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'GENERATERSSFEED',V_INIT,V_PARAMETERS);
  return DBMS_XMLDOM.getXMLType(V_RSS_DOCUMENT);
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'GENERATERSSFEED',V_INIT,V_PARAMETERS);
    raise;
end;
--
function generateRSSFeed(P_RESOURCE_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) 
return XMLType
as
begin
	return generateRSSFeed(P_SERVLET_URL => JAVA_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET);
end;
--
procedure generateRSSFeed(P_RESOURCE_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) 
as
  V_FOLDER_RSS XMLType;
begin
	V_FOLDER_RSS := generateRSSFeed(P_SERVLET_URL => EPG_SERVLET_URL, P_RESOURCE_PATH => P_RESOURCE_PATH, P_TIMEZONE_OFFSET => P_TIMEZONE_OFFSET);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_FOLDER_RSS, FALSE);
end;
--
function WHOAMI(P_SERVLET_URL VARCHAR2) 
return XMLType  
as
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_WHOAMI            XMLType;
begin
  select xmlElement("User",sys_context('USERENV', 'CURRENT_USER')) into V_WHOAMI from DUAL;
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'WHOAMI',V_INIT,NULL);
  return V_WHOAMI;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'WHOAMI',V_INIT,null);
    raise;
end;
--
function WHOAMI
return XMLType
as
begin
	 return WHOAMI(P_SERVLET_URL => JAVA_SERVLET_URL);
end;
--
procedure WHOAMI
as
  V_RESULT XMLType;
begin
	V_RESULT := WHOAMI(P_SERVLET_URL => EPG_SERVLET_URL);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESULT, FALSE);
end;
--
procedure ENABLERSSICON(P_RESOURCE_PATH VARCHAR2,P_TEMPLATE_PATH VARCHAR2,P_STYLESHEET_PATH VARCHAR2,P_FORCE_AUTHENTICATION VARCHAR2)
--
-- Generates a HTML Page which will enable the Browser's RSS Icon. To enable the ICON the pages HEAD element has to contain a 
-- <link rel="alternate" type="application/rss+xml".. element that provides the link to RSS feed for the page
--
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_HTML_PAGE VARCHAR2(32000);
begin
	  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TemplatePath",P_TEMPLATE_PATH),
           xmlElement("StylesheetPath",P_STYLESHEET_PATH),
           xmlElement("forceAuthentication",P_FORCE_AUTHENTICATION)
         )
    into V_PARAMETERS
    from dual;

  V_HTML_PAGE := xdburitype(P_TEMPLATE_PATH).getClob();
	V_HTML_PAGE := REPLACE(V_HTML_PAGE,'<link id="enableRSSIcon"/>','<link id="rssEnabled" rel="alternate" type="application/rss+xml" title="RSS Feed for %P_RESOURCE_PATH%" href="/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.GENERATERSSFEED?P_RESOURCE_PATH=%P_RESOURCE_PATH%"/>');
  V_HTML_PAGE := REPLACE(V_HTML_PAGE,'%P_RESOURCE_PATH%',P_RESOURCE_PATH);
  V_HTML_PAGE := REPLACE(V_HTML_PAGE,'%INIT%','initRSS(document.getElementById(''pageContent''),''' || P_RESOURCE_PATH || ''',''' || P_STYLESHEET_PATH || ''',''' || P_FORCE_AUTHENTICATION || ''');');

 	XFILES_REST_SUPPORT.writeServletOutputStream(V_HTML_PAGE, 'text/html');
	XFILES_REST_SUPPORT.writeLogRecord(EPG_SERVLET_URL,'ENABLERSSICON',V_INIT,V_PARAMETERS);
exception
  when others then
    XFILES_REST_SUPPORT.handleException(EPG_SERVLET_URL,'ENABLERSSICON',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure ENABLERSSICON(P_FOLDER_PATH VARCHAR2)
--
-- Generates a HTML Page which will enable the Browser's RSS Icon. To enable the ICON the pages HEAD element has to contain a 
-- <link rel="alternate" type="application/rss+xml".. element that provides the link to RSS feed for the page
--
as
begin
	ENABLERSSICON(P_FOLDER_PATH,XFILES_REST_SERVICES.DEFAULT_TEMPLATE_PATH,XFILES_REST_SERVICES.DEFAULT_STYLESHEET_PATH,'false');
end;
--
procedure DOAUTHENTICATION 
as
  V_PARAMETERS        XMLType;
  
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_WHOAMI            XMLType := NULL;
begin
	select xmlElement("currentUser",sys_context('USERENV', 'CURRENT_USER'))
	  into V_PARAMETERS
	  from DUAL;
         
	if (USER = 'ANONYMOUS') then
	  -- htp.p('WWW-Authenticate: Basic realm="XDB"');
		owa_util.status_line(401,'Authorization Required',TRUE);
  else	
    select xmlElement("User",sys_context('USERENV', 'CURRENT_USER')) into V_WHOAMI from DUAL;
   	XFILES_REST_SUPPORT.writeServletOutputStream(V_WHOAMI, FALSE);
  end if;

  XFILES_REST_SUPPORT.writeLogRecord(EPG_SERVLET_URL,'DOAUTHENTICATION',V_INIT,V_PARAMETERS);
exception
  when others then
    XFILES_REST_SUPPORT.handleException(EPG_SERVLET_URL,'DOAUTHENTICATION',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SHOWSOURCECODE(SOURCECODE VARCHAR2)
as
begin
	OWA_UTIL.MIME_HEADER('text/xml',FALSE);
  htp.p('Content-Length: ' || length(SOURCECODE));
  owa_util.http_header_close;
  htp.print(SOURCECODE);
  htp.flush();
end;
--	
procedure RENDERDOCUMENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT_TYPE VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RENDERING         CLOB;

begin
  select xmlConcat
         (
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("ContentType",P_CONTENT_TYPE)
         )
    into V_PARAMETERS
    from dual;
    
  if (P_CONTENT_TYPE = 'text/plain') THEN  
    V_RENDERING := XFILES_UTILITIES.RENDERASTEXT(P_RESOURCE_PATH);
  else
    V_RENDERING := XFILES_UTILITIES.RENDERASHTML(P_RESOURCE_PATH);
  end if;  
  
  XFILES_REST_SUPPORT.writeServletOutputStream(V_RENDERING,P_CONTENT_TYPE);
  -- DBMS_LOB.freeTemporary(V_RENDERING);

  XFILES_REST_SUPPORT.writeLogRecord(EPG_SERVLET_URL,'RENDERDOCUMENT',V_INIT,V_PARAMETERS);
exception
  when others then
    XFILES_REST_SUPPORT.handleException(EPG_SERVLET_URL,'RENDERDOCUMENT',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure WRITELOGRECORD(LOG_RECORD VARCHAR2)
as
begin
  &XFILES_SCHEMA..XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(XMLTYPE(LOG_RECORD));
  XFILES_REST_SUPPORT.writeServletOutputStream('Success','text/plain');
end;
--
function transformDocumentToHTML(P_SERVLET_URL VARCHAR2, P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_RESULT XMLType;
  V_CHILDREN XMLType;
begin
  select xmlConcat(
           xmlElement("xmlDocument",P_XML_DOCUMENT),
           xmlElement("xslDocument",P_XSL_DOCUMENT)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XFILES_UTILITIES.transformDocumentToHTML(P_XML_DOCUMENT,P_XSL_DOCUMENT);
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'TRANSFORMDOCUMENTTOHTML',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'TRANSFORMDOCUMENTTOHTML',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure transformDocumentToHTML(P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE)
as
  V_RESULT XMLType;
begin
	V_RESULT := transformDocumentToHTML(P_SERVLET_URL => EPG_SERVLET_URL, P_XML_DOCUMENT => P_XML_DOCUMENT, P_XSL_DOCUMENT => P_XSL_DOCUMENT);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESULT, FALSE);
end;
--
function xslInlineInclude(P_SERVLET_URL VARCHAR2, P_XSL_PATH VARCHAR2)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
     
  V_RESULT XMLType;
begin
  select xmlElement("xslPath",P_XSL_PATH)
    into V_PARAMETERS
    from dual;

  select XMLTransform(
           xdburitype(P_XSL_PATH).getXML(),
           G_INLINE_IMPORT_XSL
         )
    into V_RESULT from dual;
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'XSLINLINEINCLUDE',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'XSLINLINEINCLUDE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure xslInlineInclude(P_XSL_PATH VARCHAR2) 
as
  V_STYLESHEET XMLTYPE;
begin
	V_STYLESHEET := xslInlineInclude(EPG_SERVLET_URL, P_XSL_PATH);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_STYLESHEET, FALSE);
end;
--
function transformCacheToHTML(P_SERVLET_URL VARCHAR2, P_GUID RAW, P_XSL_PATH VARCHAR2)
return CLOB
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
   
  V_RESULT CLOB;
begin
  select xmlConcat(
            xmlElement("GUID",P_GUID),
            xmlElement("xslPath",P_XSL_PATH)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XFILES_REST_SUPPORT.transformCacheToHTML(P_GUID,P_XSL_PATH);
  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'TRANSFORMCACHETOHTML',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'TRANSFORMCACHETOHTML',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure transformCacheToHTML(P_GUID RAW, P_XSL_PATH VARCHAR2) 
as
  V_RESULT CLOB;
begin
	V_RESULT := transformCacheToHTML(EPG_SERVLET_URL, P_GUID, P_XSL_PATH);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESULT, 'text/html');
end;
--
function transformContentToHTML(P_SERVLET_URL VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2)
return CLOB
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
   
  V_RESULT CLOB;
begin
  select xmlConcat(
            xmlElement("resourcePath",P_RESOURCE_PATH),
            xmlElement("xslPath",P_XSL_PATH)
         )
    into V_PARAMETERS
    from dual;
    
  select xdburitype(P_RESOURCE_PATH).getXML().transform(xdbUriType(P_XSL_PATH).getXML()).getClobVal()
    into V_RESULT
    from DUAL;

  XFILES_REST_SUPPORT.writeLogRecord(P_SERVLET_URL,'TRANSFORMCONTENTTOHTML',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    XFILES_REST_SUPPORT.handleException(P_SERVLET_URL,'TRANSFORMCONTENTTOHTML',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure transformContentToHTML(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2) 
as
  V_RESULT CLOB;
begin
	V_RESULT := transformContentToHTML(EPG_SERVLET_URL, P_RESOURCE_PATH, P_XSL_PATH);
	XFILES_REST_SUPPORT.writeServletOutputStream(V_RESULT, 'text/html');
end;
--
end;
/
show errors
--
