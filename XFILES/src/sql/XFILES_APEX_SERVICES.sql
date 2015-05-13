
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
    execute immediate 'DROP TABLE TREE_STATE_TABLE';
  exception
    when non_existant_table  then
      null;
  end;
end;
/
create table TREE_STATE_TABLE
(
  SESSION_ID    number(38),
  PAGE_NUMBER   number(38),
  TREE_STATE    XMLTYPE
)
XMLTYPE column TREE_STATE store as SECUREFILE BINARY XML
/
create or replace package XFILES_APEX_SERVICES
AUTHID CURRENT_USER
as
  FILLER_ICON                  constant VARCHAR2(700) := '/XFILES/APEX/lib/graphics/t.gif';

  FILE_PROPERTIES_ICON         constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/pageProperties.png';
  FILE_CHECKED_OUT_ICON        constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/checkedOutDocument.png';
  FILE_VERSIONED_ICON          constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/versionedDocument.png';
  FILE_LOCKED_ICON             constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/lockedDocument.png';

  REPOSITORY_ICON              constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/sql.png';
  FOLDER_ICON                  constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/readOnlyFolderClosed.png';
  IMAGE_JPEG_ICON              constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/imageJPEG.png';
  IMAGE_GIF_ICON               constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/imageGIF.png';
  XML_ICON                     constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/xmlDocument.png';
  TEXT_ICON                    constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/xmlDocument.png';
  DEFAULT_ICON                 constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/textDocument.png';  
  
  READONLY_FOLDER_OPEN_ICON    constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/readOnlyFolderOpen.png';
  READONLY_FOLDER_CLOSED_ICON  constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/readOnlyFolderClosed.png';
  WRITE_FOLDER_OPEN_ICON       constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/writeFolderOpen.png';
  WRITE_FOLDER_CLOSED_ICON     constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/writeFolderClosed.png';
  SHOW_CHILDREN_ICON           constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/showChildren.png' ;
  HIDE_CHILDREN_ICON           constant VARCHAR2(700) := '/XFILES/APEX/lib/icons/hideChildren.png' ;

  FOLDER_TREE_STYLESHEET constant VARCHAR2(700) := '/XFILES/APEX/lib/xsl/showTree.xsl';  
  
  CONTENT_TYPE_JPEG      constant VARCHAR2(32) := 'image/jpeg';
  CONTENT_TYPE_GIF       constant VARCHAR2(32) := 'image/gif';
  CONTENT_TYPE_XML_CSX   constant VARCHAR2(32) := 'application/vnd.oracle-csx';
  CONTENT_TYPE_XML_TEXT  constant VARCHAR2(32) := 'text/xml';

  TYPE FOLDER_INFO IS RECORD
  (
    NAME VARCHAR2(700),
    PATH VARCHAR2(700),
    ICON VARCHAR2(700)
  );

  TYPE FOLDER_INFO_TABLE IS TABLE OF FOLDER_INFO;
   
  TYPE DIRECTORY_ITEM is RECORD
  (  
    nPATH                                               VARCHAR2(1024 CHAR),
    nRESID                                              RAW(16),
    nIS_FOLDER                                          VARCHAR2(5),
    nVERSION_ID                                         NUMBER(38),
    nCHECKED_OUT                                        VARCHAR2(5),
    nCREATION_DATE                                      TIMESTAMP(6),
    nMODIFICATION_DATE                                  TIMESTAMP(6),
    nAUTHOR                                             VARCHAR2(128),
    nDISPLAY_NAME                                       VARCHAR2(128),
    nCOMMENT                                            VARCHAR2(128),
    nLANGUAGE                                           VARCHAR2(128),
    nCHARACTER_SET                                      VARCHAR2(128),
    nCONTENT_TYPE                                       VARCHAR2(128),
    nOWNED_BY                                           VARCHAR2(64),
    nCREATED_BY                                         VARCHAR2(64),
    nLAST_MODIFIED_BY                                   VARCHAR2(64),
    nCHECKED_OUT_BY                                     VARCHAR2(700),
    nLOCK_BUFFER                                        VARCHAR2(128),
    nVERSION_SERIES_ID                                  RAW(16),
    nACL_OID                                            RAW(16),
    nSCHEMA_OID                                         RAW(16),
    nGLOBAL_ELEMENT_ID                                  NUMBER(38),
    nLINK_NAME                                          VARCHAR2(128),
    nCHILD_PATH                                         VARCHAR2(1024 CHAR),
    nICON_PATH                                          VARCHAR2(1024 CHAR),
    nTARGET_URL                                         VARCHAR2(1024 CHAR),
    nRESOURCE_STATUS                                    VARCHAR2(1024 CHAR)
  );
  
  TYPE DIRECTORY_LISTING IS TABLE OF DIRECTORY_ITEM;
   
  procedure CHANGEOWNER(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKIN(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKOUT(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure COPYRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CREATEFOLDER(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure CREATEWIKIPAGE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure CREATEZIPFILE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure DELETERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  
  procedure LINKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  
  procedure LOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MAKEVERSIONED(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MOVERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2);
  procedure PUBLISHRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure RENAMERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2);
  procedure SETACL(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);
  procedure SETRSSFEED(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNLOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNZIP(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2);
  procedure UPLOADRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2);
  procedure UPDATEPROPERTIES(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);

  function ICONFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2) return VARCHAR2;
  function URLFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2, P_PATH VARCHAR2, P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT 'NO', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL ) return VARCHAR2;
  function ICONSFORSTATUS(P_VERSION_ID NUMBER, P_IS_CHECKED_OUT VARCHAR2, P_LOCK_BUFFER VARCHAR2) return varchar2;
  
  
  function GETVISABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER,P_CURRENT_FOLDER VARCHAR2 DEFAULT '/') return XMLType;
  function GETWRITABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER,P_CURRENT_FOLDER VARCHAR2 DEFAULT '/') return XMLType;
  function SHOWCHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) return XMLType;
  function HIDECHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) return XMLType;
  function OPENFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER,P_PAGE_NUMBER NUMBER ,P_ID VARCHAR2) return XMLType;
  function CLOSEFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER) return XMLType; 

  function pathAsTable(P_CURRENT_FOLDER VARCHAR2) return FOLDER_INFO_TABLE PIPELINED;
  function LISTDIRECTORY(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2,P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT 'NO', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL) return DIRECTORY_LISTING PIPELINED;

  function GETIMAGELIST return  XDB.XDB$STRING_LIST_T;
  
end;
/
create or replace package body XFILES_APEX_SERVICES
as
  G_TREE          XMLType;
  G_TREE_DOM      DBMS_XMLDOM.DOMDOCUMENT;
  G_NODE_COUNT    number(38) := 1;  
  G_REPOSITORY_ID VARCHAR2(50);
--
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('XFILES.XFILES_APEX_SERVICES.',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('XFILES.XFILES_APEX_SERVICES.',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
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
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END

end;

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
                 READONLY_FOLDER_OPEN_ICON as "openIcon",
                 READONLY_FOLDER_CLOSED_ICON as "closedIcon",
                 'hidden' as "children",
                 HIDE_CHILDREN_ICON as "hideChildren",
                 SHOW_CHILDREN_ICON as "showChildren"
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
                 WRITE_FOLDER_OPEN_ICON as "openIcon",
                 WRITE_FOLDER_CLOSED_ICON as "closedIcon",
                 'hidden' as "children",
                 HIDE_CHILDREN_ICON as "hideChildren",
                 SHOW_CHILDREN_ICON as "showChildren"
               )
             )
        into V_CHILD_FOLDER_XML
        from dual;
    end if;
    
    V_CHILD_FOLDER := DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(V_CHILD_FOLDER_XML));
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.importNode(G_TREE_DOM, DBMS_XMLDOM.makeNode(V_CHILD_FOLDER), true));    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),DBMS_XMLDOM.makeNode(V_CHILD_FOLDER)));

  else
    --  Target is already in the tree. 
    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.item(V_NODE_LIST,0));

    if (V_DESCENDANT_PATH is NULL) then      
       -- We are at the bottom of the path, Make sure folder is shown as writeable
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'openIcon',WRITE_FOLDER_OPEN_ICON);
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'closedIcon',WRITE_FOLDER_CLOSED_ICON);
     end if;
  end if;
  
  -- Process remainder of path

  if (V_DESCENDANT_PATH is not null) then
    addChildToTree(V_DESCENDANT_PATH, V_CHILD_FOLDER);
  end if;
  
end;
--
procedure addPathToTree(P_PATH  VARCHAR2)
as
  V_PARENT_FOLDER DBMS_XMLDOM.DOMElement;
begin
  V_PARENT_FOLDER := DBMS_XMLDOM.getDocumentElement(G_TREE_DOM);
  addChildToTree(P_PATH, V_PARENT_FOLDER);
end;
--
procedure addWriteableFolders
as
  cursor getFolderList
  is
  select path
    from PATH_VIEW
   where existsNode(res,'/Resource[@Container="true"]') = 1
     and sys_checkacl
         (
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
         ) = 1    ;
     
  V_FOLDER DBMS_XMLDOM.DOMElement;
begin
  for f in getFolderList() loop  
    addPathToTree(F.PATH);   
  end loop;
end;
--
procedure addAllFolders
as
  cursor getFolderList
  is
  select path
    from PATH_VIEW
   where existsNode(res,'/Resource[@Container="true"]') = 1;
     
  V_FOLDER DBMS_XMLDOM.DOMElement;
begin
  for f in getFolderList() loop  
    addPathToTree(F.PATH);   
  end loop;
end;
--
procedure initTree
as
begin
  
  select xmlElement
           (
             "root",
             xmlAttributes
             (
               '/' as "name",
               G_NODE_COUNT as "id",
               '/' as "currentPath",
               'null' as "isSelected",
               'open' as "isOpen",
               READONLY_FOLDER_OPEN_ICON as "openIcon",
               READONLY_FOLDER_CLOSED_ICON as "closedIcon",
               'visible' as "children",
               HIDE_CHILDREN_ICON as "hideChildren",
               SHOW_CHILDREN_ICON as "showChildren",
               FILLER_ICON as "fillerIcon"
             )
           )
    into G_TREE
    from DUAL;

  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);

end;
--
procedure cacheTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_TREE_STATE XMLType)
as
begin
  insert into TREE_STATE_TABLE values (P_SESSION_ID, P_PAGE_NUMBER, G_TREE);
end;
--
procedure preserveTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_TREE_STATE XMLType)
as
begin
  update TREE_STATE_TABLE
     set TREE_STATE = P_TREE_STATE
   where SESSION_ID = P_SESSION_ID;
end;
--
procedure restoreTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
as
begin
  select TREE_STATE 
    into G_TREE
    from TREE_STATE_TABLE
   where SESSION_ID = P_SESSION_ID;

  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);
end;
--
procedure deleteTree(P_SESSION_ID NUMBER)
as
begin
  delete from TREE_STATE_TABLE 
   where SESSION_ID = P_SESSION_ID;
end;
--
procedure openFolderInternal(P_ID NUMBER)
as
  V_NODE DBMS_XMLDOM.DOMNode;
  V_PATH VARCHAR2(700);
begin
  select updateXML
         (
           G_TREE,
           '//*[@isOpen="open"]/@children',
           'hidden'
         )
    into G_TREE
    from dual;

  select updateXML
         (
           G_TREE,
           '//*[@isOpen="open"]/@isOpen',
           'closed'
         )
    into G_TREE
    from dual;

  select updateXML
         (
           G_TREE,
           '//*[@id="' || P_ID || '"]/@isOpen',
           'open'
         )
    into G_TREE
    from dual;

  select updateXML
         (
           G_TREE,
           '//*[@id="' || P_ID || '"]/@children',
           'visible'
         )
    into G_TREE
    from dual;

  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);
   
  V_NODE := DBMS_XMLDOM.item(DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(G_TREE_DOM),'//*[@id="' || P_ID || '"]'),0);   
  V_PATH := DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_NODE),'name');
  V_NODE := DBMS_XMLDOM.getParentNode(V_NODE);
  while (DBMS_XMLDOM.getNodeType(V_NODE) <> DBMS_XMLDOM.DOCUMENT_NODE) loop
    V_PATH := DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_NODE),'name') || '/' || V_PATH;
    DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_NODE),'children','visible');
    V_NODE := DBMS_XMLDOM.getParentNode(V_NODE);
  end loop;
  
  -- Remove extra '/' from currentPath
  V_PATH := substr(V_PATH,2);
  DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.makeDocument(V_NODE)),'currentPath',V_PATH);  
end;
--
procedure showChildrenInternal(P_ID NUMBER)
as
begin
	  select updateXML
         (
           G_TREE,
           '//*[@id="' || P_ID || '"]/@children',
           'visible'
         )
    into G_TREE
    from dual;
end;
--
procedure openBranch(P_CURRENT_FOLDER VARCHAR2)
as
  V_BRANCH_ID      NUMBER;
  V_CURRENT_FOLDER VARCHAR2(700) := P_CURRENT_FOLDER;
  V_FOLDER_NAME    VARCHAR2(700);
  V_BRANCH         XMLTYPE       := G_TREE;
begin

	if (P_CURRENT_FOLDER = '/') then
	  V_BRANCH_ID := 1;
	else
	  V_BRANCH := V_BRANCH.EXTRACT('/root/folder');
	  while INSTR(V_CURRENT_FOLDER,'/') > 0 loop
	    V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,2);
	    if INSTR(V_CURRENT_FOLDER,'/') > 0 THEN
 	       V_FOLDER_NAME := SUBSTR(V_CURRENT_FOLDER,1,INSTR(V_CURRENT_FOLDER,'/')-1);
	       V_BRANCH := V_BRANCH.EXTRACT('/folder[@name="' || V_FOLDER_NAME || '"]/folder');
	       V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,INSTR(V_CURRENT_FOLDER,'/'));
	    else
	      V_FOLDER_NAME := V_CURRENT_FOLDER;
	      V_BRANCH_ID := V_BRANCH.extract('/folder[@name="' || V_FOLDER_NAME || '"]/@id').getNumberVal();
	    end if;
	  end loop;
  end if;

  openFolderInternal(V_BRANCH_ID);
  showChildrenInternal(V_BRANCH_ID);

end;

procedure UPDATEPROPERTIES(P_APEX_USER VARCHAR2, P_RESOURCE_PATH  VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE_PATH     VARCHAR2(1024);
begin  
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           P_NEW_VALUES          
         )
    into V_PARAMETERS
    from dual;

  V_RESOURCE_PATH := XDB_REPOSITORY_SERVICES.UPDATEPROPERTIES(P_RESOURCE_PATH,P_NEW_VALUES,P_TIMEZONE_OFFSET);
      
  writeLogRecord('UPDATEPROPERTIES',V_INIT,V_PARAMETERS);
	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('UPDATEPROPERTIES',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATEWIKIPAGE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select XMLConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEWIKIPAGE(P_RESOURCE_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);
  writeLogRecord('CREATENEWWIKIPAGE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CREATEWIKIPAGE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATEFOLDER(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select XMLConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEFOLDER(P_FOLDER_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);
  writeLogRecord('CREATENEWFOLDER',V_INIT,V_PARAMETERS);
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CREATENEWFOLDER',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure SETACL(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("ACL",P_ACL_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.SETACL(P_RESOURCE_PATH, P_ACL_PATH, P_DEEP);
  writeLogRecord('SETACL',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('SETACL',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure CHANGEOWNER(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("NewOwner",P_NEW_OWNER),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CHANGEOWNER(P_RESOURCE_PATH,P_NEW_OWNER,P_DEEP);  
  writeLogRecord('CHANGEOWNER',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CHANGEOWNER',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure MAKEVERSIONED(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.MAKEVERSIONED(P_RESOURCE_PATH, P_DEEP);
  writeLogRecord('MAKEVERSIONED',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('MAKEVERSIONED',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure CHECKOUT(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
 
  XDB_REPOSITORY_SERVICES.CHECKOUT(P_RESOURCE_PATH, P_DEEP);
  writeLogRecord('CHECKOUT',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CHECKOUT',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure CHECKIN(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Comment",P_COMMENT)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CHECKIN(P_RESOURCE_PATH, P_COMMENT, P_DEEP);
  writeLogRecord('CHECKIN',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CHECKIN',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure LOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
    
  XDB_REPOSITORY_SERVICES.LOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);
  writeLogRecord('LOCKRESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('LOCKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure UNLOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
  
  XDB_REPOSITORY_SERVICES.UNLOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);
  writeLogRecord('UNLOCKRESOURCE',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('UNLOCKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure DELETERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN, P_FORCE BOOLEAN)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESID             RAW(16);
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  V_FORCE             VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Force",V_FORCE)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.DELETERESOURCE(P_RESOURCE_PATH, P_DEEP, P_FORCE);  
  writeLogRecord('DELETERESOURCE',V_INIT,V_PARAMETERS);
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('DELETERESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure SETRSSFEED(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
  V_ENABLE            VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_ENABLE);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("Deep",V_DEEP),
           xmlElement("Enable",V_ENABLE),
           xmlElement("ItemsChanged",P_ITEMS_CHANGED_IN)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.SETRSSFEED(P_FOLDER_PATH, P_ENABLE, P_ITEMS_CHANGED_IN, P_DEEP);
  writeLogRecord('SETRSSFEED',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END

exception
  when others then
    handleException('SETRSSFEED',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure LINKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("LinkType",P_LINK_TYPE)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.LINKRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER,P_LINK_TYPE);  
  writeLogRecord('LINKRESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('LINKRESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure MOVERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.MOVERESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER);
  writeLogRecord('MOVERESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('MOVERESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure RENAMERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("NewName",P_NEW_NAME)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.RENAMERESOURCE(P_RESOURCE_PATH, P_NEW_NAME);
  writeLogRecord('RENAMERESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('RENAMERESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure COPYRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TargetFolder",P_TARGET_FOLDER),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;
   
  XDB_REPOSITORY_SERVICES.COPYRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER);
  writeLogRecord('COPYRESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('COPYRESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure PUBLISHRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);  
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("Deep",V_DEEP)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.PUBLISHRESOURCE(P_RESOURCE_PATH, P_DEEP);
  writeLogRecord('PUBLISHESOURCE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('PUBLISHESOURCE',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
procedure UPLOADRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
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
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('UPLOADRESOURCE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure CREATEZIPFILE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("Description",P_DESCRIPTION),
           P_RESOURCE_LIST
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.CREATEZIPFILE(P_RESOURCE_PATH, P_DESCRIPTION, P_RESOURCE_LIST,  P_TIMEZONE_OFFSET);
  writeLogRecord('CREATEZIPFILE',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('CREATEZIPFILE',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure UNZIP(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2)
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("ResourcePath",P_RESOURCE_PATH),
           xmlElement("DuplicateAction",P_DUPLICATE_ACTION)
         )
    into V_PARAMETERS
    from dual;

  XDB_REPOSITORY_SERVICES.unzip(P_FOLDER_PATH, P_RESOURCE_PATH, P_DUPLICATE_ACTION);
  writeLogRecord('UNZIP',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('UNZIP',V_INIT,V_PARAMETERS);
    raise;
end;
--
function ICONFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2)  
return VARCHAR2
as
begin
	
 if (P_IS_FOLDER = 'true') then
     return FOLDER_ICON;
   end if;
 
   if P_CONTENT_TYPE in (CONTENT_TYPE_JPEG) then
     return IMAGE_JPEG_ICON;
   end if;
   
   if P_CONTENT_TYPE in (CONTENT_TYPE_GIF) then
     return IMAGE_GIF_ICON;
   end if;

   if P_CONTENT_TYPE in (CONTENT_TYPE_XML_CSX) then
     return XML_ICON;
   end if;

   if P_CONTENT_TYPE in (CONTENT_TYPE_XML_TEXT) then
     return XML_ICON;
   end if;

   return DEFAULT_ICON;
end;
--
function URLFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2, P_PATH VARCHAR2, P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT 'NO', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL )
return VARCHAR2
as
begin

  if (P_IS_FOLDER = 'true') then
    return 'f?p=' || P_APEX_APPLICATION_ID || ':' || P_APEX_TARGET_PAGE || ':'  || P_APEX_APP_SESSION_ID || ':' || P_APEX_REQUEST || ':' || P_APEX_DEBUG || ':' || P_APEX_CACHE_OPTIONS || ':P1_CURRENT_FOLDER:' || P_PATH;
  end if;

  return P_PATH;
end;
--
function ICONSFORSTATUS(P_VERSION_ID NUMBER, P_IS_CHECKED_OUT VARCHAR2, P_LOCK_BUFFER VARCHAR2)
return VARCHAR2
as
  V_PROPERTIES_ICON VARCHAR2(128);
  V_VERSIONED_ICON VARCHAR2(128);
  V_LOCKED_ICON VARCHAR2(128);
begin
  V_PROPERTIES_ICON := '<span width="18"><img src="' || FILE_PROPERTIES_ICON || '" alt="View Properties" width="16" height="16"/></span>';
   
  if (P_VERSION_ID is not NULL) then
    if (P_IS_CHECKED_OUT = 'false') then
      V_VERSIONED_ICON := '<span width="18"><img src="' || FILE_VERSIONED_ICON || '" alt="View Properties" width="16" height="16"/></span>';
    else
      V_VERSIONED_ICON := '<span width="18"><img src="' || FILE_CHECKED_OUT_ICON || '" alt="View Properties" width="16" height="16"/></span>';
    end if;
  else
    V_VERSIONED_ICON := '<span width="18"><img src="' || FILLER_ICON || '" alt="View Properties" width="16" height="16"/></span>';
  end if;
  
  if (length(P_LOCK_BUFFER) > 44) then
    V_LOCKED_ICON :=  '<span width="18"><img src="' || FILE_LOCKED_ICON || '" alt="View Properties" width="16" height="16"/></span>';
  else
    V_LOCKED_ICON := '<span width="18"><img src="' || FILLER_ICON || '" alt="View Properties" width="16" height="16"/></span>';
  end if;
  
  return V_PROPERTIES_ICON || V_VERSIONED_ICON || V_LOCKED_ICON;
end;
--
function GETWRITABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_CURRENT_FOLDER VARCHAR2 DEFAULT '/')
return XMLType
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin

$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER),
           xmlElement("CurrentFolder",P_CURRENT_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  deleteTree(P_SESSION_ID);
  initTree();
  addWriteableFolders();
  openBranch(P_CURRENT_FOLDER);
  cacheTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);
  writeLogRecord('GETWRITABLEFOLDERSTREE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('GETWRITABLEFOLDERSTREE',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GETVISABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_CURRENT_FOLDER VARCHAR2 DEFAULT '/')
return XMLType
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin

$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER),
           xmlElement("CurrentFolder",P_CURRENT_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  deleteTree(P_SESSION_ID);
  initTree();
  addAllFolders();
  openBranch(P_CURRENT_FOLDER);
  cacheTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);
  writeLogRecord('GETVISABLEFOLDERSTREE',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('GETVISABLEFOLDERSTREE',V_INIT,V_PARAMETERS);
    raise;
end;
--
function SHOWCHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) 
return XMLType
as 
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER),
           xmlElement("Id",P_ID)
         )
    into V_PARAMETERS
    from dual;

  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);
  showChildrenInternal(P_ID);
  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);  

  writeLogRecord('SHOWCHILDREN',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('SHOWCHILDREN',V_INIT,V_PARAMETERS);
    raise;
end;
--
function HIDECHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) 
return XMLType
as 
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin

$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER),
           xmlElement("Id",P_ID)
         )
    into V_PARAMETERS
    from dual;

  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);

  select updateXML
         (
           G_TREE,
           '//*[@id="' || P_ID || '"]/@children',
           'hidden'
         )
    into G_TREE
    from dual;

  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  writeLogRecord('HIDECHILDREN',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('HIDECHILDREN',V_INIT,V_PARAMETERS);
    raise;
end;
--
function OPENFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2)
return XMLType
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin

$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER),
           xmlElement("Id",P_ID)
         )
    into V_PARAMETERS
    from dual;
      
  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);
  openFolderInternal(P_ID);
  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  writeLogRecord('OPENFOLDER',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('OPENFOLDER',V_INIT,V_PARAMETERS);
    raise;
end;
--
function CLOSEFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
return XMLType
as
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("SessionId",P_SESSION_ID),
           xmlElement("PageNumber",P_PAGE_NUMBER)
         )
    into V_PARAMETERS
    from dual;
      
  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);

  select updateXML
         (
           G_TREE,
           '//*[@isOpen="open"]/@isOpen',
           'closed'
         )
    into G_TREE
    from dual;

  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  writeLogRecord('CLOSEFOLDER',V_INIT,V_PARAMETERS);	
  
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());
	
exception
  when others then
    handleException('CLOSEFOLDER',V_INIT,V_PARAMETERS);
    raise;
end;
--
function pathAsTable(P_CURRENT_FOLDER VARCHAR2)
return FOLDER_INFO_TABLE PIPELINED
as
  V_CURRENT_FOLDER VARCHAR2(700) := P_CURRENT_FOLDER;
  V_FOLDER_INFO    FOLDER_INFO;
begin
	
  V_FOLDER_INFO.NAME := G_REPOSITORY_ID;
  V_FOLDER_INFO.PATH := '/';
  V_FOLDER_INFO.ICON := REPOSITORY_ICON;

	pipe row (V_FOLDER_INFO);

  V_FOLDER_INFO.ICON := FOLDER_ICON;
  V_FOLDER_INFO.PATH := '';

	if (P_CURRENT_FOLDER = '/') then
	  return;
	else
	  while INSTR(V_CURRENT_FOLDER,'/') > 0 loop
	    V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,2);
	    if INSTR(V_CURRENT_FOLDER,'/') > 0 THEN
         V_FOLDER_INFO.NAME := SUBSTR(V_CURRENT_FOLDER,1,INSTR(V_CURRENT_FOLDER,'/')-1);
         V_FOLDER_INFO.PATH := V_FOLDER_INFO.PATH || '/' || V_FOLDER_INFO.NAME; 	       
         pipe row (V_FOLDER_INFO);
	       V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,INSTR(V_CURRENT_FOLDER,'/'));
	    else
        V_FOLDER_INFO.NAME := V_CURRENT_FOLDER;
        V_FOLDER_INFO.PATH := V_FOLDER_INFO.PATH || '/' || V_FOLDER_INFO.NAME; 	       
       	pipe row (V_FOLDER_INFO);
	    end if;
	  end loop;
	  return;
  end if;
end;
--
function LISTDIRECTORY(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2,P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT 'NO', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL)
return DIRECTORY_LISTING PIPELINED
as
  V_EMPTY_FOLDER      boolean := TRUE;
  V_RESULT            boolean;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_PARENT_PATH       VARCHAR2(700) := P_FOLDER_PATH;

  V_DIRECTORY_ITEM    DIRECTORY_ITEM ;

  cursor getFolderListing is
  select PATH, RESID, RES, R.*, L.*
    from PATH_VIEW,
         XMLTable 
         (
           xmlNamespaces
           (
             default 'http://xmlns.oracle.com/xdb/XDBResource.xsd'
           ),
           '$RES/Resource' passing RES as "RES"
           columns
           IS_FOLDER           VARCHAR2(5)      PATH  '@Container',
           VERSION_ID          NUMBER(38)       PATH  '@VersionID',
           CHECKED_OUT         VARCHAR2(5)      PATH  '@IsCheckedOut',
           CREATION_DATE       TIMESTAMP(6)     PATH  'CreationDate',
           MODIFICATION_DATE   TIMESTAMP(6)     PATH  'ModificationDate',
           AUTHOR              VARCHAR2(128)    PATH  'Author',
           DISPLAY_NAME        VARCHAR2(128)    PATH  'DisplayName',
           "COMMENT"           VARCHAR2(128)    PATH  'Comment',
           LANGUAGE            VARCHAR2(128)    PATH  'Language',
           CHARACTER_SET       VARCHAR2(128)    PATH  'CharacterSet',
           CONTENT_TYPE        VARCHAR2(128)    PATH  'ContentType',
           OWNED_BY            VARCHAR2(64)     PATH  'Owner',      
           CREATED_BY          VARCHAR2(64)     PATH  'Creator',
           LAST_MODIFIED_BY    VARCHAR2(64)     PATH  'LastModifier',
           CHECKED_OUT_BY      VARCHAR2(700)    PATH  'CheckedOutBy',
           LOCK_BUFFER         VARCHAR2(128)    PATH  'LockBuf',
           VERSION_SERIES_ID   RAW(16)          PATH  'VCRUID',
           ACL_OID             RAW(16)          PATH  'ACLOID',
           SCHEMA_OID          RAW(16)          PATH  'SchOID',
           GLOBAL_ELEMENT_ID   NUMBER(38)       PATH  'ElNum'
        ) R,
        XMLTable
        (
           xmlNamespaces
           (
             default 'http://xmlns.oracle.com/xdb/XDBStandard'
           ),
           '$LINK/LINK' passing LINK as "LINK"
           columns
           LINK_NAME          VARCHAR2(128)    PATH 'Name'
        ) L
  where under_path(RES,1,P_FOLDER_PATH) = 1;
 
begin
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);
$END
	
  select xmlConcat
         (
           xmlElement("ApexUser",P_APEX_USER),
           xmlElement("FolderPath",P_FOLDER_PATH),
           xmlElement("ApplicationId",P_APEX_APPLICATION_ID),
           xmlElement("Page",P_APEX_TARGET_PAGE),
           xmlElement("SessionId",P_APEX_APP_SESSION_ID),
           xmlElement("Request",P_APEX_REQUEST),
           xmlElement("Debug",P_APEX_DEBUG),
           xmlElement("CacheOptions",P_APEX_CACHE_OPTIONS)
         )
    into V_PARAMETERS
    from dual;
    
  if (P_FOLDER_PATH != '/') then
    V_PARENT_PATH := V_PARENT_PATH || '/';
  end if;

  for r in getFolderListing() loop
   
    V_EMPTY_FOLDER := FALSE;
  
    V_DIRECTORY_ITEM.nPATH               := R.PATH;
    V_DIRECTORY_ITEM.nRESID              := R.RESID;                                       
    V_DIRECTORY_ITEM.nIS_FOLDER          := R.IS_FOLDER;                                   
    V_DIRECTORY_ITEM.nVERSION_ID         := R.VERSION_ID;                                  
    V_DIRECTORY_ITEM.nCHECKED_OUT        := R.CHECKED_OUT;                                 
    V_DIRECTORY_ITEM.nCREATION_DATE      := R.CREATION_DATE;                               
    V_DIRECTORY_ITEM.nMODIFICATION_DATE  := R.MODIFICATION_DATE;                           
    V_DIRECTORY_ITEM.nAUTHOR             := R.AUTHOR;                                      
    V_DIRECTORY_ITEM.nDISPLAY_NAME       := R.DISPLAY_NAME;                                
    V_DIRECTORY_ITEM.nCOMMENT            := R.COMMENT;                                     
    V_DIRECTORY_ITEM.nLANGUAGE           := R.LANGUAGE;                                    
    V_DIRECTORY_ITEM.nCHARACTER_SET      := R.CHARACTER_SET;                               
    V_DIRECTORY_ITEM.nCONTENT_TYPE       := R.CONTENT_TYPE;                                
    V_DIRECTORY_ITEM.nOWNED_BY           := R.OWNED_BY;                                    
    V_DIRECTORY_ITEM.nCREATED_BY         := R.CREATED_BY;                                  
    V_DIRECTORY_ITEM.nLAST_MODIFIED_BY   := R.LAST_MODIFIED_BY;                            
    V_DIRECTORY_ITEM.nCHECKED_OUT_BY     := R.CHECKED_OUT_BY;                             
    V_DIRECTORY_ITEM.nLOCK_BUFFER        := R.LOCK_BUFFER;                                 
    V_DIRECTORY_ITEM.nVERSION_SERIES_ID  := R.VERSION_SERIES_ID;                           
    V_DIRECTORY_ITEM.nACL_OID            := R.ACL_OID;                                     
    V_DIRECTORY_ITEM.nSCHEMA_OID         := R.SCHEMA_OID;                                  
    V_DIRECTORY_ITEM.nGLOBAL_ELEMENT_ID  := R.GLOBAL_ELEMENT_ID;                           
    V_DIRECTORY_ITEM.nLINK_NAME          := R.LINK_NAME;    
    V_DIRECTORY_ITEM.nCHILD_PATH         := V_PARENT_PATH || R.LINK_NAME;
    V_DIRECTORY_ITEM.nICON_PATH          := ICONFROMCONTENTTYPE(R.IS_FOLDER, R.CONTENT_TYPE);
    V_DIRECTORY_ITEM.nTARGET_URL         := URLFROMCONTENTTYPE(R.IS_FOLDER, R.CONTENT_TYPE,R.PATH, P_APEX_APPLICATION_ID, P_APEX_TARGET_PAGE, P_APEX_APP_SESSION_ID, P_APEX_REQUEST, P_APEX_DEBUG,P_APEX_CACHE_OPTIONS);
    V_DIRECTORY_ITEM.nRESOURCE_STATUS    := ICONSFORSTATUS(R.VERSION_ID, R.CHECKED_OUT, R.LOCK_BUFFER);
  
   	pipe row (V_DIRECTORY_ITEM);
	end loop; 
	
	if (V_EMPTY_FOLDER) then
    V_DIRECTORY_ITEM.nICON_PATH          := FILLER_ICON;
	  pipe row (V_DIRECTORY_ITEM);
	end if;
	
  writeLogRecord('LISTDIRECTORY',V_INIT,V_PARAMETERS);
	
$IF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();
$END
	
exception
  when others then
    handleException('LISTDIRECTORY',V_INIT,V_PARAMETERS);
    raise;
  
end;
--
function GETIMAGELIST
return XDB.XDB$STRING_LIST_T
as
  RESOURCE_LIST XDB.XDB$STRING_LIST_T;
begin
	RESOURCE_LIST := XDB.XDB$STRING_LIST_T();
	RESOURCE_LIST.extend();
	RESOURCE_LIST(RESOURCE_LIST.count) := FILLER_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_PROPERTIES_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_CHECKED_OUT_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_VERSIONED_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_LOCKED_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := REPOSITORY_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FOLDER_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := IMAGE_JPEG_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := IMAGE_GIF_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := XML_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := TEXT_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := DEFAULT_ICON;
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := READONLY_FOLDER_OPEN_ICON;   
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := READONLY_FOLDER_CLOSED_ICON; 
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := WRITE_FOLDER_OPEN_ICON;      
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := WRITE_FOLDER_CLOSED_ICON;    
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := SHOW_CHILDREN_ICON;          
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := HIDE_CHILDREN_ICON;          
	RESOURCE_LIST.extend();
  RESOURCE_LIST(RESOURCE_LIST.count) := FOLDER_TREE_STYLESHEET;
  return RESOURCE_LIST;
end;
--
begin
	select SUBSTR(GLOBAL_NAME,1,INSTR(GLOBAL_NAME,'.')-1)
	  into G_REPOSITORY_ID
	  from GLOBAL_NAME;
end;
/
show errors
--