
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
--  Event manager for XFiles Authentication Events. 
--  Generates a document that indicates whether or not the current HTTP session is authenticated or not
--
create or replace package XFILES_AUTHENTICATION_EVENTS
as
  procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
create or replace package body XFILES_AUTHENTICATION_EVENTS
as    
-- 
procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_CHARSET_ID NUMBER(4);
begin
  select NLS_CHARSET_ID(VALUE)
    into V_CHARSET_ID
    from NLS_DATABASE_PARAMETERS
   where PARAMETER = 'NLS_CHARACTERSET';
   
  if (DBMS_XEVENT.GETCURRENTUSER(DBMS_XEVENT.GETXDBEVENT(P_EVENT)) = 'ANONYMOUS') then
    DBMS_XEVENT.setRenderStream(P_EVENT,XMLTYPE('<Authenticated>0</Authenticated>').getBlobVal(V_CHARSET_ID));    
  else
    DBMS_XEVENT.setRenderStream(P_EVENT,XMLTYPE('<Authenticated>1</Authenticated>').getBlobVal(V_CHARSET_ID));    
  end if;
end;   
--
end;
/
show errors
--
grant execute on XFILES_AUTHENTICATION_EVENTS to public
/
--
--  Event manager for XFiles WhoAmI Events. 
--  Generates a document that shows the username for the current HTTP session.
--
create or replace package XFILES_WHOAMI_EVENTS
as
  procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
create or replace package body XFILES_WHOAMI_EVENTS
as    
-- 
procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_CHARSET_ID NUMBER(4);
begin
  select NLS_CHARSET_ID(VALUE)
    into V_CHARSET_ID
    from NLS_DATABASE_PARAMETERS
   where PARAMETER = 'NLS_CHARACTERSET';
   
  DBMS_XEVENT.setRenderStream(P_EVENT,XMLTYPE('<CurrentUser>' || DBMS_XEVENT.GETCURRENTUSER(DBMS_XEVENT.GETXDBEVENT(P_EVENT)) ||'</CurrentUser>').getBlobVal(V_CHARSET_ID));    
end;   
--
end;
/
show errors
--
grant execute on XFILES_WHOAMI_EVENTS to public
/
--
create or replace package XFILES_INDEX_PAGE_REDIRECT
as
  procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
set define off
--
create or replace package body XFILES_INDEX_PAGE_REDIRECT
as    
-- 
  G_HTML_PAGE    VARCHAR2(32000) :=
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html dir="ltr" lang="en-US">
<head>
  <link rel="stylesheet" charset="UTF-8" type="text/css" href="/XFILES/lite/css/XFiles.css"/>
	<title>Welcome to the Oracle XML DB XFiles Application.</title>
  <script type="text/javascript" language="javascript">
function doRedirect() {
    var target="/XFILES/lite/Folder.html?target=%FOLDER%&stylesheet=/XFILES/lite/xsl/FolderBrowser.xsl&includeContent=false";
    window.location.href = target;
}
  </script>
</head>
<body onload="doRedirect()">
  <table height="100%" align="center" border="0">
		<tr align="center" valign="middle">
			<td class="x14" align="center" valign="middle">
			Welcome to the XFiles application launch page for %FOLDER%. You are current connected as %USER%.
		   <br/>
			Opening this page should automatically launch the Oracle XML DB XFiles Application
		   <br/><br/>
				<a href="#" onclick="doRedirect()">
				   <img src="/XFILES/logo.png" alt="Oracle Files" border="0"/>
				</a>
			<br/><br/>
			If the application does not launch automatically click <span class="xp"><a href="#" onClick="doRedirect();false">here</a></span> to launch the application.
			</td>	
		</tr>
   </table>
</body>
</html>';

procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_HTML_PAGE VARCHAR2(32000) := G_HTML_PAGE;

  V_TEXT_CONTENT CLOB;
  V_BINARY_CONTENT BLOB;
  V_CHARSET_ID NUMBER(4);

  V_SOURCE_OFFSET      integer := 1;
  V_TARGET_OFFSET      integer := 1;
  V_WARNING            integer;
  V_LANG_CONTEXT       integer := 0;  

  V_PARENT_FOLDER_PATH VARCHAR2(700);
  
begin
  select NLS_CHARSET_ID(VALUE)
    into V_CHARSET_ID
    from NLS_DATABASE_PARAMETERS
   where PARAMETER = 'NLS_CHARACTERSET';

  V_PARENT_FOLDER_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getParentPath(DBMS_XEVENT.getPath(P_EVENT),1));
  
  if (LENGTH(V_PARENT_FOLDER_PATH) > 1) then
    V_PARENT_FOLDER_PATH := rtrim(V_PARENT_FOLDER_PATH,'/');
  end if;

  V_HTML_PAGE := REPLACE(V_HTML_PAGE,'%OWNER%',DBMS_XDBRESOURCE.getOwner(DBMS_XEVENT.getResource(P_EVENT)));
  V_HTML_PAGE := REPLACE(V_HTML_PAGE,'%USER%',USER);
  V_HTML_PAGE := REPLACE(V_HTML_PAGE,'%FOLDER%',V_PARENT_FOLDER_PATH);
  
  V_TEXT_CONTENT := V_HTML_PAGE;
  dbms_lob.createTemporary(V_BINARY_CONTENT,true);
  dbms_lob.convertToBlob(V_BINARY_CONTENT,V_TEXT_CONTENT,dbms_lob.getLength(V_TEXT_CONTENT),V_SOURCE_OFFSET,V_TARGET_OFFSET,V_CHARSET_ID,V_LANG_CONTEXT,V_WARNING);
  DBMS_XEVENT.setRenderStream(P_EVENT,V_BINARY_CONTENT);    
  DBMS_LOB.FREETEMPORARY(V_BINARY_CONTENT);
  DBMS_LOB.FREETEMPORARY(V_TEXT_CONTENT);  
end;   
--
end;
/
--
set define on
--
show errors
--
grant execute on XFILES_INDEX_PAGE_REDIRECT to public
/
create or replace package XFILES_PAGE_COUNTER
as
  procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
create or replace package body XFILES_PAGE_COUNTER
as    
-- 
procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent)
as

  V_RESOURCE_PATH     VARCHAR2(700);
  V_STACK_TRACE       XMLTYPE;
  V_PARAMETERS        XMLTYPE;


  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_PAYLOAD           xmlType;

  V_XDB_RESOURCE   DBMS_XDBRESOURCE.XDBResource;
  V_BINARY_CONTENT BLOB;
  V_CONTENT_CSID   NUMBER(4);
  
begin
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_EVENT));
  
  V_XDB_RESOURCE    := DBMS_XEVENT.getResource(P_EVENT);
  V_BINARY_CONTENT  := DBMS_XDBRESOURCE.getContentBLOB(V_XDB_RESOURCE,V_CONTENT_CSID);
  DBMS_XEVENT.setRenderStream(P_EVENT,V_BINARY_CONTENT);    
  
  &XFILES_SCHEMA..XFILES_LOGGING.logPageHit(V_INIT_TIME, V_RESOURCE_PATH);
exception
  when others then
    select XMLELEMENT("resourcePath", V_RESOURCE_PATH)
      into V_PARAMETERS
      from dual;
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&XFILES_SCHEMA..XFILES_PAGE_COUNTER' ,'HANDLERENDER', V_INIT_TIME, V_PARAMETERS, V_STACK_TRACE);
end;   
--
end;
/
--
show errors
--
grant execute on XFILES_PAGE_COUNTER to public
/
create or replace package XFILES_TABLE_CONTENTS
authid current_user
as
  procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
create or replace package body XFILES_TABLE_CONTENTS
as    
-- 
procedure handleRender(P_EVENT dbms_xevent.XDBRepositoryEvent)
as

  V_RESOURCE_PATH     VARCHAR2(700);
  V_STACK_TRACE       XMLTYPE;
  V_PARAMETERS        XMLTYPE;

  V_TABLE_NAME        VARCHAR2(128);
  V_SCHEMA_NAME       VARCHAR2(128);
  V_METADATA          XMLTYPE;

  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_XDB_RESOURCE   DBMS_XDBRESOURCE.XDBResource;
  V_BINARY_CONTENT BLOB;
  V_CONTENT_CSID   NUMBER(4);
  
begin
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_EVENT));
  V_XDB_RESOURCE  := DBMS_XEVENT.getResource(P_EVENT);
  V_METADATA := DBMS_XDBRESOURCE.getCustomMetadata(V_XDB_RESOURCE,'/r:Resource/xrc:ContentDefinition',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R || ' ' || XFILES_CONSTANTS.NSPREFIX_XFILES_RC_XRC);
  if (V_METADATA is not NULL) then
    select SCHEMA_NAME, TABLE_NAME
      into V_SCHEMA_NAME, V_TABLE_NAME
      from XMLTABLE(
             XMLNAMESPACES(
               default 'http://xmlns.oracle.com/xdb/xfiles/resConfig'
             ),
             '/ContentDefinition/DBURIType'
             passing V_METADATA
             columns
               SCHEMA_NAME VARCHAR2(128) path  'Schema',
               TABLE_NAME  VARCHAR2(128) path  'Table',
               FILTER      VARCHAR2(4000) path 'Filter'
           );
  else
    -- Assume that anything to the left of the last . is a file extension and should be remove
    -- Assume that the filename (minus any extension) is the table name
    -- Assume that the folder name is the schema name
    -- Use DBURITYPE to render content

    if (instr(V_RESOURCE_PATH,'/',-1) > 1) then
      V_TABLE_NAME := substr(V_RESOURCE_PATH,instr(V_RESOURCE_PATH,'/',-1)+1);  
      V_SCHEMA_NAME := substr(V_RESOURCE_PATH,1,length(V_RESOURCE_PATH)-(length(V_TABLE_NAME)+1));
      if (instr(V_TABLE_NAME,'.') > 0) then
        V_TABLE_NAME := substr(V_TABLE_NAME,1,instr(V_TABLE_NAME,'.',-1)-1);
      end if;
      if (instr(V_SCHEMA_NAME,'/',-1) > 1) then
        V_SCHEMA_NAME := substr(V_SCHEMA_NAME,instr(V_SCHEMA_NAME,'/',-1)+1);
      end if;
    end if;
    
  end if;
  
  DBMS_XEVENT.setRenderStream(P_EVENT,DBURITYPE('/' || V_SCHEMA_NAME || '/' || V_TABLE_NAME).getBlob() );    
  &XFILES_SCHEMA..XFILES_LOGGING.logPageHit(V_INIT_TIME, V_RESOURCE_PATH);
exception
  when others then
    select XMLELEMENT("resourcePath", V_RESOURCE_PATH)
      into V_PARAMETERS
      from dual;
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&XFILES_SCHEMA..XFILES_PAGE_COUNTER' ,'HANDLERENDER', V_INIT_TIME, V_PARAMETERS, V_STACK_TRACE);
end;   
--
end;
/
--
show errors
--
grant execute on XFILES_TABLE_CONTENTS to public
/
