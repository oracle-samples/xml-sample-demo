
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
create or replace package XFILES_SOAP_SERVICES
AUTHID CURRENT_USER
as
  procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHANGEOWNERLIST(P_RESOURCE_LIST XMLTYPE, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKIN(P_RESOURCE_PATH VARCHAR2,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKINLIST(P_RESOURCE_LIST XMLTYPE,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKOUTLIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure COPYRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure COPYRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);

  procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  
  procedure DELETERESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  
  procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  
  procedure LINKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2, P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  
  procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure LOCKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MAKEVERSIONED(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MAKEVERSIONEDLIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MOVERESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2);
  procedure MOVERESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2);
  procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE);
  procedure PUBLISHRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE);
  procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2);
  procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);
  procedure SETACLLIST(P_RESOURCE_LIST XMLTYPE, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);
  procedure SETRSSFEED(P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure SETCUSTOMVIEWER(P_RESOURCE_PATH VARCHAR2, P_VIEWER_PATH VARCHAR2, P_METHOD VARCHAR2 DEFAULT NULL);
  procedure SETCUSTOMVIEWERLIST(P_RESOURCE_LIST XMLTYPE, P_VIEWER_PATH VARCHAR2, P_METHOD VARCHAR2 DEFAULT NULL);
  procedure ADDPAGEHITCOUNTER(P_RESOURCE_PATH VARCHAR2);
  procedure ADDPAGEHITCOUNTERLIST(P_RESOURCE_LIST XMLTYPE);
  procedure UNLOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNLOCKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UNZIPLIST(P_FOLDER_PATH VARCHAR2, P_RESOURCE_LIST XMLTYPE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UPDATEPROPERTIES(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType);

  procedure CREATENEWFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType);
  procedure CREATENEWWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType);
  procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType);
  procedure CREATEINDEXPAGE(P_FOLDER_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType);

  procedure getResourceWithContent(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0,P_RESOURCE IN OUT XMLType);
  procedure getResource(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType);
  procedure getFolderListing(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_METADATA VARCHAR2 DEFAULT 'FALSE', P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_FOLDER IN OUT XMLType);
  procedure getVersionHistory(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType);
  procedure getACLList(P_ACL_LIST out XMLType);

  function getPrivileges(P_RESOURCE_PATH VARCHAR2) return XMLTYPE;
  
  function GENERATEPREVIEW(P_RESOURCE_PATH VARCHAR2, P_LINES number) return XMLType;
  function renderAsXHTML(P_RESOURCE_PATH VARCHAR2) return XMLType;

  procedure getTargetFolderTree(P_TREE IN OUT XMLType);

  procedure SETPASSWORD(P_PASSWORD VARCHAR2);  

	/*
	**
	** '1' versions take a VARCHAR2 with the PATH to an XSL document, '2' versions take an XMLTYPE with the XSL document. 
	** Workaround for a bug where the WSDL is generated incorrectly for an overloaded function.
	**
	*/
  
  function transformResource1(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER) return XMLType;
  function transformResource2(P_RESOURCE_PATH VARCHAR2, P_XSL_DOCUMENT XMLTYPE, P_TIMEZONE_OFFSET NUMBER) return XMLType;

  function transformContent1(P_CONTENT_PATH VARCHAR2, P_XSL_PATH VARCHAR2) return XMLType;
  function transformContent2(P_CONTENT_PATH VARCHAR2, P_XSL_DOCUMENT XMLTYPE)  return XMLType;

  function transformDocument1(P_XML_DOCUMENT XMLTYPE,  P_XSL_PATH VARCHAR2) return XMLType;
  function transformDocument2(P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE)  return XMLType;  

  function transformDocumentToHTML1(P_XML_DOCUMENT XMLTYPE,  P_XSL_PATH VARCHAR2) return XMLType;
  function transformDocumentToHTML2(P_XML_DOCUMENT XMLTYPE,  P_XSL_DOCUMENT XMLTYPE) return XMLType;

  procedure writeLogRecord(P_LOG_RECORD XMLTYPE);
  
  function testResource(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return XMLType;
  function testResourceWithContent(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return XMLType;
  function testFolderListing(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_METADATA NUMBER DEFAULT 0, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return XMLType;
  function testVersionHistory(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return XMLType;
end;
/
show errors
--
create or replace package body XFILES_SOAP_SERVICES
as
  G_NODE_COUNT number(38) := 1;
--
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/XFILES/XFILES_SOAP_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/XFILES/XFILES_SOAP_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
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
procedure GETRESOURCE(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getResource(P_RESOURCE_PATH, FALSE, P_TIMEZONE_OFFSET, P_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_RESOURCE);
	end if;  
  writeLogRecord('GETRESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('GETRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure GETRESOURCEWITHCONTENT(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getResource(P_RESOURCE_PATH, TRUE, P_TIMEZONE_OFFSET, P_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_RESOURCE);
	end if;
  writeLogRecord('GETRESOURCEWITHCONTENT',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('GETRESOURCEWITHCONTENT',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure GETFOLDERLISTING(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_METADATA VARCHAR2 DEFAULT 'FALSE', P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_FOLDER IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("IncludeMetadata",P_INCLUDE_METADATA),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getFolderListing(P_FOLDER_PATH, XDB_DOM_UTILITIES.varchar_To_Boolean(P_INCLUDE_METADATA), P_TIMEZONE_OFFSET, P_FOLDER);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_FOLDER);
	end if;
  writeLogRecord('GETFOLDERLISTING',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('GETFOLDERLISTING',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure GETVERSIONHISTORY(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE          XMLType;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.getVersionHistory(P_RESOURCE_PATH, P_TIMEZONE_OFFSET, P_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_RESOURCE);
	end if;

  writeLogRecord('GETVERSIONHISTORY',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('GETVERSIONHISTORY',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure GETACLLIST(P_ACL_LIST OUT XMLType)
as
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE          XMLTYPE;
begin
  XDB_REPOSITORY_SERVICES.getAclList(P_ACL_LIST);
  writeLogRecord('GETACLLIST',V_INIT,NULL);
exception
  when others then
    handleException('GETACLLIST',V_INIT,NULL);
    raise;
end;
--
procedure UPDATEPROPERTIES(P_RESOURCE_PATH  VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE_PATH     VARCHAR2(1024);
begin  
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT),
           P_NEW_VALUES          
         )
    into V_PARAMETERS
    from dual;

  V_RESOURCE_PATH := XDB_REPOSITORY_SERVICES.UPDATEPROPERTIES(P_RESOURCE_PATH,P_NEW_VALUES,P_TIMEZONE_OFFSET);      
  XDB_REPOSITORY_SERVICES.getResource(V_RESOURCE_PATH, FALSE, P_TIMEZONE_OFFSET, P_UPDATED_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_UPDATED_RESOURCE);
	end if;
	writeLogRecord('UPDATEPROPERTIES',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UPDATEPROPERTIES',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATENEWWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,'/',-1) -1);
begin
  select XMLConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEWIKIPAGE(P_RESOURCE_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);
  XDB_REPOSITORY_SERVICES.getFolderListing(V_PARENT_FOLDER, FALSE, P_TIMEZONE_OFFSET, P_UPDATED_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_UPDATED_RESOURCE);
	end if;  
  writeLogRecord('CREATENEWWIKIPAGE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CREATENEWWIKIPAGE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATENEWFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_FOLDER_PATH,1,INSTR(P_FOLDER_PATH,'/',-1) -1);
begin
  -- execute immediate 'alter session set TIME_ZONE=''-08:00''';
  -- V_INIT := SYSTIMESTAMP;
  select XMLConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEFOLDER(P_FOLDER_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);
  XDB_REPOSITORY_SERVICES.getFolderListing(P_FOLDER_PATH, FALSE, P_TIMEZONE_OFFSET, P_UPDATED_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_UPDATED_RESOURCE);
	end if;  
  writeLogRecord('CREATENEWFOLDER',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CREATENEWFOLDER',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("ACL",P_ACL_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.SETACL(P_RESOURCE_PATH, P_ACL_PATH, P_DEEP);
  
  writeLogRecord('SETACL',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('SETACL',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETACLLIST(P_RESOURCE_LIST XMLTYPE, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("ACL",P_ACL_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.SETACL(r.RESOURCE_PATH, P_ACL_PATH, P_DEEP);
  end loop;
  
  writeLogRecord('SETACLLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('SETACLLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("NewOwner",P_NEW_OWNER),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CHANGEOWNER(P_RESOURCE_PATH,P_NEW_OWNER,P_DEEP);
  
  writeLogRecord('CHANGEOWNER',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHANGEOWNER',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHANGEOWNERLIST(P_RESOURCE_LIST XMLTYPE, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("NewOwner",P_NEW_OWNER),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

    for r in getResources loop
      XDB_REPOSITORY_SERVICES.CHANGEOWNER(r.RESOURCE_PATH,P_NEW_OWNER,P_DEEP);
    end loop;
  
  writeLogRecord('CHANGEOWNERLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHANGEOWNERLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETCUSTOMVIEWER(P_RESOURCE_PATH VARCHAR2, P_VIEWER_PATH VARCHAR2, P_METHOD VARCHAR2 DEFAULT NULL)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("ViewerPath",P_VIEWER_PATH),
           xmlElement("Method",P_METHOD)
         )
    into V_PARAMETERS
    from dual;
    
  XDB_REPOSITORY_SERVICES.setCustomViewer(P_RESOURCE_PATH,P_VIEWER_PATH,P_METHOD); 
  writeLogRecord('SETCUSTOMVIEWER',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('SETCUSTOMVIEWER',V_INIT,V_PARAMETERS);
    raise;  
end;
--
procedure SETCUSTOMVIEWERLIST(P_RESOURCE_LIST XMLTYPE, P_VIEWER_PATH VARCHAR2, P_METHOD VARCHAR2 DEFAULT NULL)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Viewer",P_VIEWER_PATH),
           xmlElement("Method",P_METHOD)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.setCustomViewer(r.RESOURCE_PATH, P_VIEWER_PATH,P_METHOD);
  end loop;
  
  writeLogRecord('SETCUSTOMVIEWERLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('SETCUSTOMVIEWERLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure MAKEVERSIONED(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.MAKEVERSIONED(P_RESOURCE_PATH, P_DEEP);

  writeLogRecord('MAKEVERSIONED',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('MAKEVERSIONED',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure MAKEVERSIONEDLIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.MAKEVERSIONED(r.RESOURCE_PATH, P_DEEP);
  end loop;

  writeLogRecord('MAKEVERSIONEDLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('MAKEVERSIONEDLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
 
  XDB_REPOSITORY_SERVICES.CHECKOUT(P_RESOURCE_PATH, P_DEEP);

  writeLogRecord('CHECKOUT',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHECKOUT',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHECKOUTLIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
 
    for r in getResources loop
      XDB_REPOSITORY_SERVICES.CHECKOUT(r.RESOURCE_PATH, P_DEEP);
    end loop;

  writeLogRecord('CHECKOUTLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHECKOUTLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHECKIN(P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Comment",P_COMMENT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CHECKIN(P_RESOURCE_PATH, P_COMMENT, P_DEEP);
  writeLogRecord('CHECKIN',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHECKIN',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CHECKINLIST(P_RESOURCE_LIST XMLTYPE, P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP),
           xmlElement("Comment",P_COMMENT)
         )
    into V_PARAMETERS
    from dual;

    for r in getResources loop
      XDB_REPOSITORY_SERVICES.CHECKIN(r.RESOURCE_PATH, P_COMMENT, P_DEEP);
    end loop;
    
  writeLogRecord('CHECKINLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CHECKINLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
    
  XDB_REPOSITORY_SERVICES.LOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);

  writeLogRecord('LOCKRESOURCE',V_INIT,V_PARAMETERS);

exception
  when others then
    handleException('LOCKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure LOCKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
    
  for r in getResources loop
    XDB_REPOSITORY_SERVICES.LOCKRESOURCE(r.RESOURCE_PATH, P_DEEP);
  end loop;

  writeLogRecord('LOCKRESOURCELIST',V_INIT,V_PARAMETERS);

exception
  when others then
    handleException('LOCKRESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure UNLOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
  
  XDB_REPOSITORY_SERVICES.UNLOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);

  writeLogRecord('UNLOCKRESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UNLOCKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure UNLOCKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
  
  for r in getResources loop
   XDB_REPOSITORY_SERVICES.UNLOCKRESOURCE(r.RESOURCE_PATH, P_DEEP);
  end loop;
  
  writeLogRecord('UNLOCKRESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UNLOCKRESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN, P_FORCE BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  V_FORCE             VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Force",V_FORCE)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.DELETERESOURCE(P_RESOURCE_PATH, P_DEEP, P_FORCE);  
  writeLogRecord('DELETERESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('DELETERESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure DELETERESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN, P_FORCE BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  V_FORCE             VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP),
           xmlElement("Force",V_FORCE)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.DELETERESOURCE(r.RESOURCE_PATH, P_DEEP, P_FORCE);  
  end loop;
  
  writeLogRecord('DELETERESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('DELETERESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETRSSFEED(P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  V_ENABLE            VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_ENABLE);
begin
  select xmlConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Enable",V_ENABLE),
           xmlElement("ItemsChanged",P_ITEMS_CHANGED_IN)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.SETRSSFEED(P_FOLDER_PATH, P_ENABLE, P_ITEMS_CHANGED_IN, P_DEEP);

  writeLogRecord('SETRSSFEED',V_INIT,V_PARAMETERS);

exception
  when others then
    handleException('SETRSSFEED',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("LinkType",P_LINK_TYPE)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.LINKRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER,P_LINK_TYPE);
  
  writeLogRecord('LINKRESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('LINKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure LINKRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("LinkType",P_LINK_TYPE)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.LINKRESOURCE(r.RESOURCE_PATH, P_TARGET_FOLDER,P_LINK_TYPE);
  end loop;
  
  writeLogRecord('LINKRESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('LINKRESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure MOVERESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.MOVERESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER);

  writeLogRecord('MOVERESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('MOVERESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure MOVERESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("TargetFolder",P_TARGET_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.MOVERESOURCE(r.RESOURCE_PATH, P_TARGET_FOLDER);
  end loop;

  writeLogRecord('MOVERESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('MOVERESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("New Name",P_NEW_NAME)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.RENAMERESOURCE(P_RESOURCE_PATH, P_NEW_NAME);

  writeLogRecord('RENAMERESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('RENAMERESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure COPYRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("Deep",V_DEEP),
           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)
         )
    into V_PARAMETERS
    from dual;
   
  XDB_REPOSITORY_SERVICES.COPYRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER, P_DEEP, P_DUPLICATE_POLICY);

  writeLogRecord('COPYRESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('COPYRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure COPYRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  
  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("Deep",V_DEEP),
           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)
         )
    into V_PARAMETERS
    from dual;
   
   for r in getResources loop
     XDB_REPOSITORY_SERVICES.COPYRESOURCE(r.RESOURCE_PATH, P_TARGET_FOLDER, P_DEEP, P_DUPLICATE_POLICY);
   end loop;
  
  writeLogRecord('COPYRESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('COPYRESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE)
as

  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);  
  V_MAKE_PUBLIC       VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_MAKE_PUBLIC);  
begin

  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("MakePublic",V_MAKE_PUBLIC)
         )
    into V_PARAMETERS
    from dual;

   XDB_REPOSITORY_SERVICES.PUBLISHRESOURCE(P_RESOURCE_PATH, P_DEEP, P_MAKE_PUBLIC);

  writeLogRecord('PUBLISHESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('PUBLISHESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure PUBLISHRESOURCELIST(P_RESOURCE_LIST XMLTYPE, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE)
as

  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);  
  V_MAKE_PUBLIC       VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_MAKE_PUBLIC);  

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin

  select xmlConcat(
           P_RESOURCE_LIST,
           xmlElement("Deep",V_DEEP),
           xmlElement("MakePublic",V_MAKE_PUBLIC)
         )
    into V_PARAMETERS
    from dual;

   for r in getResources loop
     XDB_REPOSITORY_SERVICES.PUBLISHRESOURCE(r.RESOURCE_PATH, P_DEEP, P_MAKE_PUBLIC);
   end loop;
   
  writeLogRecord('PUBLISHESOURCELIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('PUBLISHESOURCELIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure ADDPAGEHITCOUNTERLIST(P_RESOURCE_LIST XMLTYPE)
as

  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin

  select xmlConcat(
           P_RESOURCE_LIST
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
    XDB_REPOSITORY_SERVICES.ADDPAGEHITCOUNTER(r.RESOURCE_PATH);
  end loop;
   
  writeLogRecord('ADDPAGEHITCOUNTER',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('ADDPAGEHITCOUNTER',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure ADDPAGEHITCOUNTER(P_RESOURCE_PATH VARCHAR2)
as

  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

begin

  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.ADDPAGEHITCOUNTER(P_RESOURCE_PATH);
   
  writeLogRecord('ADDPAGEHITCOUNTER',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('ADDPAGEHITCOUNTER',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATEINDEXPAGE(P_FOLDER_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin

  select xmlConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEINDEXPAGE(P_FOLDER_PATH);
  XDB_REPOSITORY_SERVICES.getFolderListing(P_FOLDER_PATH, FALSE, P_TIMEZONE_OFFSET, P_UPDATED_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_UPDATED_RESOURCE);
	end if;  

  writeLogRecord('CREATEINDEXPAGE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CREATEINDEXPAGE',V_INIT,V_PARAMETERS);
    raise;  
end;
--

procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("ContentLength",DBMS_LOB.GETLENGTH(P_CONTENT)),
           xmlElement("ContentType",P_CONTENT_TYPE),
           xmlElement("Description",P_DESCRIPTION),
           xmlElement("Language",P_LANGUAGE),
           xmlElement("CharacterSet",P_CHARACTER_SET),
           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)
         )
    into V_PARAMETERS
    from dual;
      
  XDB_REPOSITORY_SERVICES.UPLOADRESOURCE(P_RESOURCE_PATH, P_CONTENT, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET, P_DUPLICATE_POLICY);
        
  writeLogRecord('UPLOADRESOURCE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UPLOADRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_CACHE_RESULT NUMBER DEFAULT 0, P_UPDATED_RESOURCE IN OUT XMLType)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,'/',-1) -1);
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION),
           P_RESOURCE_LIST,
           xmlElement("CacheResult",P_CACHE_RESULT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEZIPFILE(P_RESOURCE_PATH, P_DESCRIPTION, P_RESOURCE_LIST,  P_TIMEZONE_OFFSET);    
  XDB_REPOSITORY_SERVICES.getFolderListing(V_PARENT_FOLDER, FALSE, P_TIMEZONE_OFFSET, P_UPDATED_RESOURCE);
  if (P_CACHE_RESULT = 1) then
	  XDB_REPOSITORY_SERVICES.cacheResult(P_UPDATED_RESOURCE);
	end if;  
  writeLogRecord('CREATEZIPFILE',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('CREATEZIPFILE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.unzip(P_FOLDER_PATH, P_RESOURCE_PATH, P_DUPLICATE_POLICY);
  writeLogRecord('UNZIP',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UNZIP',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure UNZIPLIST(P_FOLDER_PATH VARCHAR2, P_RESOURCE_LIST XMLTYPE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  cursor getResources 
  is
  select RESOURCE_PATH 
    from XMLTABLE(
            'ResourceList/Resource'
            passing P_RESOURCE_LIST
            columns
            RESOURCE_PATH VARCHAR2(700) PATH '.'
         );
begin
  select xmlConcat(
           xmlElement("FolderPath",P_FOLDER_PATH),
           P_RESOURCE_LIST,
           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)
         )
    into V_PARAMETERS
    from dual;

  for r in getResources loop
   XDB_REPOSITORY_SERVICES.unzip(P_FOLDER_PATH, r.RESOURCE_PATH, P_DUPLICATE_POLICY);
  end loop;
  
  writeLogRecord('UNZIPLIST',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('UNZIPLIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure addChildToTree(P_PATH VARCHAR2, P_PARENT_FOLDER DBMS_XMLDOM.DOMElement)
as
  V_CHILD_FOLDER_NAME VARCHAR2(256);
  V_DESCENDANT_PATH   VARCHAR2(700);
  
  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_CHILD_FOLDER      DBMS_XMLDOM.DOMElement;

  V_CHILD_FOLDER_XML  XMLType;

begin
       
  if (INSTR(P_PATH,'/',2) > 0) then
    V_CHILD_FOLDER_NAME := SUBSTR(P_PATH,2,INSTR(P_PATH,'/',2)-2);
    V_DESCENDANT_PATH   := SUBSTR(P_PATH,INSTR(P_PATH,'/',2));
  else
    V_CHILD_FOLDER_NAME := SUBSTR(P_PATH,2);
    V_DESCENDANT_PATH   := NULL;
  end if;
  
  V_NODE_LIST         := DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),'folder[@name="' || V_CHILD_FOLDER_NAME || '"]');

  if (DBMS_XMLDOM.getLength(V_NODE_LIST) = 0) then

    -- Target is not already in the tree - add it..

    G_NODE_COUNT := G_NODE_COUNT + 1;

    if (V_DESCENDANT_PATH is not NULL) then
      -- We are not at the bottom of the path so assume this is a read-only folder for now
      select xmlElement
             (
               "folder",
               xmlAttributes
               (
                 V_CHILD_FOLDER_NAME as "name",
                 G_NODE_COUNT as "id",
                 'null' as "isSelected",
                 'closed' as "isOpen",
                 'false' as "isWriteable",
                 '/XFILES/lib/icons/readOnlyFolderOpen.png' as "openIcon",
                 '/XFILES/lib/icons/readOnlyFolderClosed.png' as "closedIcon",
                 'hidden' as "children",
                 '/XFILES/lib/icons/hideChildren.png' as "hideChildren",
                 '/XFILES/lib/icons/showChildren.png' as "showChildren"
               )
             )
        into V_CHILD_FOLDER_XML
        from dual;
    else
      -- We are at the bottom of the path so we can link items into this folder.
      select xmlElement
             (
               "folder",
               xmlAttributes
               (
                 V_CHILD_FOLDER_NAME as "name",
                 G_NODE_COUNT as "id",
                 'null' as  "isSelected",
                 'closed' as "isOpen",
                 'true' as "isWriteable",
                 '/XFILES/lib/icons/writeFolderOpen.png' as "openIcon",
                 '/XFILES/lib/icons/writeFolderClosed.png' as "closedIcon",
                 'hidden' as "children",
                 '/XFILES/lib/icons/hideChildren.png' as "hideChildren",
                 '/XFILES/lib/icons/showChildren.png' as "showChildren"
               )
             )
        into V_CHILD_FOLDER_XML
        from dual;
    end if;
    
    V_CHILD_FOLDER := DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(V_CHILD_FOLDER_XML));
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.importNode(DBMS_XMLDOM.getOwnerDocument(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER)), DBMS_XMLDOM.makeNode(V_CHILD_FOLDER), true));    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),DBMS_XMLDOM.makeNode(V_CHILD_FOLDER)));

  else
    --  Target is already in the tree. 
    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.item(V_NODE_LIST,0));

    if (V_DESCENDANT_PATH is NULL) then      
       -- We are at the bottom of the path, Make sure folder is shown as writeable
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'openIcon','/XFILES/lib/icons/writeFolderOpen.png');
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'closedIcon','/XFILES/lib/icons/writeFolderClosed.png');
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'isWriteable','true');
     end if;
  end if;
  
  -- Process remainder of path

  if (V_DESCENDANT_PATH is not null) then
    addChildToTree(V_DESCENDANT_PATH, V_CHILD_FOLDER);
  end if;
end;
--
procedure addPathToTree(P_TREE XMLType, P_PATH VARCHAR2)
as
  V_PARENT_FOLDER DBMS_XMLDOM.DOMElement;
begin
  dbms_output.put_line(P_PATH);
  V_PARENT_FOLDER := DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.NewDOMDocument(P_TREE));
  addChildToTree(P_PATH, V_PARENT_FOLDER);
end;
--
function addWriteableFolders(P_TREE XMLType)
return XMLType
as
  cursor getFolderList
  is
  select path
    from PATH_VIEW
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
   where existsNode(res,'/Resource[@Container="true"]','xmlns="http://xmlns.oracle.com/xdb/XDBResource.xsd"') = 1
$ELSE
   where XMLExists(
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
            $R/Resource[@Container=xs:boolean("true")]'
           passing RES as "R"
         )
$END
     and sys_checkacl(
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <link/>
             </privilege>'
           )
         ) = 1;     
begin
  for f in getFolderList() loop  
    addPathToTree(P_TREE,F.PATH);   
  end loop;
  return P_TREE;
end;
--
function initTree
return XMLType
as
  V_TREE XMLType;
begin
  
  select xmlElement
           (
             "root",
             xmlAttributes
             (
               'targetFolderTree' as "controlName",
               '/' as "name",
               G_NODE_COUNT as "id",
               '/' as "currentPath",
               'null' as "isSelected",
               'open' as "isOpen",
               '/XFILES/lib/icons/readOnlyFolderOpen.png' as "openIcon",
               '/XFILES/lib/icons/readOnlyFolderClosed.png' as "closedIcon",
               'visible' as "children",
               '/XFILES/lib/icons/hideChildren.png' as "hideChildren",
               '/XFILES/lib/icons/showChildren.png' as "showChildren"
             )
           )
    into V_TREE
    from DUAL;

  return V_TREE;
end;
--
procedure getTargetFolderTree(P_TREE IN OUT XMLType)
as
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
   P_TREE := initTree();
   P_TREE := addWriteableFolders(P_TREE);
   writeLogRecord('GETTARGETFOLDERTREE',V_INIT,NULL);
exception
  when others then
    handleException('GETTARGETFOLDERTREE',V_INIT,NULL);
    raise;
end;
--
function getPrivileges(P_RESOURCE_PATH VARCHAR2) 
return XMLTYPE 
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_PRIVILEGES XMLTYPE;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH)
         )
    into V_PARAMETERS
    from dual;
    
  XDB_REPOSITORY_SERVICES.getPrivileges(P_RESOURCE_PATH,V_PRIVILEGES);
  writeLogRecord('GETPRIVILEGES',V_INIT,V_PARAMETERS);
  return V_PRIVILEGES;
exception
  when others then
    handleException('GETPRIVILEGES',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GENERATEPREVIEW(P_RESOURCE_PATH VARCHAR2, P_LINES number) 
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Lines",P_LINES)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.generatePreview(P_RESOURCE_PATH,P_LINES);
   
   writeLogRecord('GENERATEPREVIEW',V_INIT,V_PARAMETERS);
   return V_RESULT;
exception
  when others then
    handleException('GENERATEPREVIEW',V_INIT,V_PARAMETERS);
    raise;
end;
--
function RENDERASXHTML(P_RESOURCE_PATH VARCHAR2) 
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("ResourcePath",P_RESOURCE_PATH)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.renderAsXHTML(P_RESOURCE_PATH);
   
   writeLogRecord('RENDERASXHTML',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('RENDERASXHTML',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETPASSWORD(P_PASSWORD VARCHAR2)
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STATEMENT         VARCHAR2(4000) :=null;
begin
  V_STATEMENT := 'alter user "' || USER || '" identified by ' || DBMS_ASSERT.ENQUOTE_NAME(P_PASSWORD,false);
  select xmlConcat(
           xmlElement("User",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement("Password",V_STATEMENT)
         )
    into V_PARAMETERS
    from dual;
    
  -- Add Code to check P_PASSWORD for '"' characters to prevent SQL Injection...  
 
  writeLogRecord('SETPASSWORD',V_INIT,V_PARAMETERS);
  execute immediate V_STATEMENT;

exception
  when others then
    handleException('SETPASSWORD',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformResource1(P_RESOURCE_PATH VARCHAR2, P_XSL_PATH VARCHAR2, P_TIMEZONE_OFFSET NUMBER)
return XMLType
/*
** 
** Transform the Resource identified by P_RESOURCE_PATH using the Style Sheet identified by P_XSL_PATH
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE          XMLType;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("resourcePath",P_RESOURCE_PATH),
           xmlElement("xslPath",P_XSL_PATH),
           xmlElement("timezoneOffset",P_TIMEZONE_OFFSET)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformResource(P_RESOURCE_PATH,P_XSL_PATH,P_TIMEZONE_OFFSET);
   writeLogRecord('TRANSFORMRESOURCE1',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMRESOURCE1',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformResource2(P_RESOURCE_PATH VARCHAR2, P_XSL_DOCUMENT XMLType, P_TIMEZONE_OFFSET NUMBER)
return XMLType
/*
** 
** Transform the Resource identified by P_RESOURCE_PATH using the supplied Style Sheet.
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE          XMLType;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("resourcePath",P_RESOURCE_PATH),
           xmlElement("xslDocument",P_XSL_DOCUMENT),
           xmlElement("timezoneOffset",P_TIMEZONE_OFFSET)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformResource(P_RESOURCE_PATH,P_XSL_DOCUMENT,P_TIMEZONE_OFFSET);
   writeLogRecord('TRANSFORMRESOURCE2',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMRESOURCE2',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformContent1(P_CONTENT_PATH VARCHAR2, P_XSL_PATH VARCHAR2)
return XMLType
/*
** 
** Transform the content of the Resource identified by P_CONTENT_PATH using the Style Sheet identified by P_XSL_PATH
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("contentPath",P_CONTENT_PATH),
           xmlElement("xslPath",P_XSL_PATH)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformContent(P_CONTENT_PATH,P_XSL_PATH);
   writeLogRecord('TRANSFORMCONTENT1',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMCONTENT1',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformContent2(P_CONTENT_PATH VARCHAR2, P_XSL_DOCUMENT XMLType)
return XMLType
/*
** 
** Transform the content of the Resource identified by P_CONTENT_PATH using the Style Sheet identified by P_XSL_PATH
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("contentPath",P_CONTENT_PATH),
           xmlElement("xslDocument",P_XSL_DOCUMENT)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformContent(P_CONTENT_PATH,P_XSL_DOCUMENT);
   writeLogRecord('TRANSFORMCONTENT2',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMCONTENT2',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformDocument1(P_XML_DOCUMENT XMLTYPE, P_XSL_PATH VARCHAR2)
return XMLType
/*
** 
** Transform the supplied XML document using the Style Sheet identified by P_XSL_PATH
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("xmlDocument",P_XML_DOCUMENT),
           xmlElement("xslPath",P_XSL_PATH)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformDocument(P_XML_DOCUMENT,P_XSL_PATH);
   writeLogRecord('TRANSFORMDOCUMENT1',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMDOCUMENT1',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformDocument2(P_XML_DOCUMENT XMLTYPE, P_XSL_DOCUMENT XMLTYPE)
return XMLType
/*
** 
** Transform the supplied XML document using the supplied Style Sheet
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("xmlDocument",P_XML_DOCUMENT),
           xmlElement("xslDocument",P_XSL_DOCUMENT)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformDocument(P_XML_DOCUMENT,P_XSL_DOCUMENT);
   writeLogRecord('TRANSFORMDOCUMENT2',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMDOCUMENT2',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformDocumentToHTML1(P_XML_DOCUMENT XMLTYPE, P_XSL_PATH VARCHAR2)
return XMLType
/*
** 
** Transform the supplied XML document using the Style Sheet identified by P_XSL_PATH
** Return the result as an 'output' element with the HTML wrapped in a CDATA section
** Use when the result of the transform is not valid XML
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("xmlDocument",P_XML_DOCUMENT),
           xmlElement("xslPath",P_XSL_PATH)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformDocumentToHTML(P_XML_DOCUMENT,P_XSL_PATH);
   writeLogRecord('TRANSFORMDOCUMENTTOHTML1',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMDOCUMENTTOHTML1',V_INIT,V_PARAMETERS);
    raise;
end;
--
function transformDocumentToHTML2(P_XML_DOCUMENT XMLTYPE, P_XSL_DOCUMENT XMLTYPE)
return XMLType
/*
** 
** Transform the supplied XML document using the supplied Style Sheet
** Return the result as an 'output' element with the HTML wrapped in a CDATA section
** Use when the result of the transform is not valid XML
**
*/
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            XMLType;
begin
  select xmlConcat(
           xmlElement("xmlDocument",P_XML_DOCUMENT),
           xmlElement("xslDocument",P_XSL_DOCUMENT)
         )
    into V_PARAMETERS
    from dual;
    
   V_RESULT := XFILES_UTILITIES.transformDocumentToHTML(P_XML_DOCUMENT,P_XSL_DOCUMENT);
   writeLogRecord('TRANSFORMDOCUMENTTOHTML2',V_INIT,V_PARAMETERS);
   return V_RESULT;  
exception
  when others then
    handleException('TRANSFORMDOCUMENTTOHTML2',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure writeLogRecord(P_LOG_RECORD XMLType) 
as
begin
  &XFILES_SCHEMA..XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(P_LOG_RECORD);
end;
--
function testResource(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) 
return XMLType
as
  V_RESOURCE XMLTYPE;
begin
  getResource(P_RESOURCE_PATH, P_TIMEZONE_OFFSET, 0, V_RESOURCE);
  return V_RESOURCE;
end;
--
function testResourceWithContent(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) 
return XMLType
as
  V_RESOURCE XMLTYPE;
begin
  getResourceWithContent(P_RESOURCE_PATH, P_TIMEZONE_OFFSET, 0, V_RESOURCE);
  return V_RESOURCE;
end;
--
function testFolderListing(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_METADATA NUMBER DEFAULT 0, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
return XMLType
as
  V_RESOURCE XMLTYPE;
begin
	if (P_INCLUDE_METADATA = 0) then
    getFolderListing(P_FOLDER_PATH, 'FALSE', P_TIMEZONE_OFFSET, 0, V_RESOURCE);
  else
    getFolderListing(P_FOLDER_PATH, 'TRUE', P_TIMEZONE_OFFSET, 0, V_RESOURCE);
  end if;  
  return V_RESOURCE;
end;
--
function testVersionHistory(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
return XMLType
as
  V_RESOURCE XMLTYPE;
begin
  getVersionHistory(P_RESOURCE_PATH, P_TIMEZONE_OFFSET, 0, V_RESOURCE);
  return V_RESOURCE;
end;
--
end;
/
show errors
--
