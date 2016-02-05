
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
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
create or replace package XDB_REPOSITORY_SERVICES
AUTHID CURRENT_USER
as
  PRINT_SUPPRESS_CONTENT constant number := 16;

  procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKIN(P_RESOURCE_PATH VARCHAR2,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure COPYRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure CREATEFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0);
  procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  
  procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  
  procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MAKEVERSIONED(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure MOVERESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2);
  procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE);
  procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2);
  procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);
  procedure SETRSSFEED(P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNLOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);
  procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  function  UPDATEPROPERTIES(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return VARCHAR2;
  procedure setCustomViewer(P_RESOURCE_PATH VARCHAR2,P_VIEWER_PATH VARCHAR2, P_METHOD VARCHAR2 DEFAULT NULL);
  procedure getPrivileges(P_RESOURCE_PATH IN VARCHAR2, P_PRIVILEGES IN OUT XMLTYPE);

  procedure mapTableToResource(P_RESOURCE_PATH  VARCHAR2,P_SCHEMA_NAME VARCHAR2 DEFAULT USER,P_TABLE_NAME VARCHAR2, P_FILTER VARCHAR2 DEFAULT NULL);
  procedure addResConfig(P_RESOURCE_PATH VARCHAR2, P_RESCONFIG_PATH VARCHAR2);
  procedure addPageHitCounter(P_RESOURCE_PATH VARCHAR2);
  procedure createIndexPage(P_FOLDER_PATH VARCHAR2);
  
  procedure GETRESOURCE(P_RESOURCE_PATH IN VARCHAR2, P_INCLUDE_CONTENTS BOOLEAN DEFAULT FALSE, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType);
  procedure GETFOLDERLISTING(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_EXTENDED_METADATA BOOLEAN, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_FOLDER IN OUT XMLType);
  procedure GETVERSIONHISTORY(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType);
  procedure getAclList(P_ACL_LIST OUT XMLType);

  procedure cacheResult(P_RESOURCE IN OUT XMLTYPE);
end;
/
show errors
--
create or replace package body XDB_REPOSITORY_SERVICES
as
--
function cloneResource(P_RESOURCE XMLTYPE, P_NEW_PARENT DBMS_XMLDOM.DOMNode, P_INCLUDE_CONTENTS BOOLEAN, P_INCLUDE_EXTENDED_METADATA BOOLEAN, P_TIMEZONE_OFFSET NUMBER DEFAULT 0,P_ACL_PATH VARCHAR2) 
return DBMS_XMLDOM.DOMNode
as
  non_existant_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );
  
  V_RESOURCE_DOCUMENT   DBMS_XMLDOM.DOMDocument;
  V_TARGET_DOCUMENT     DBMS_XMLDOM.DOMDocument;
  V_RESOURCE_ELEMENT    DBMS_XMLDOM.DOMElement;
  V_RESOURCE_NODE       DBMS_XMLDOM.DOMNode;
  V_NAMED_NODE_MAP      DBMS_XMLDOM.DOMNamedNodeMap;
  V_NODE_LIST           DBMS_XMLDOM.DOMNodelist;
  V_SOURCE_NODE         DBMS_XMLDOM.DOMNode;
  V_TARGET_NODE         DBMS_XMLDOM.DOMNode;
  V_TEXT_NODE           DBMS_XMLDOM.DOMText;
  V_TIMESTAMP           TIMESTAMP(6);
  V_TIMEZONE_OFFSET     VARCHAR2(10);
  V_RESEXTRA_NODE       DBMS_XMLDOM.DOMNode;

begin

  if (P_TIMEZONE_OFFSET >= 0) then
    V_TIMEZONE_OFFSET := 'PT' || (P_TIMEZONE_OFFSET * 60) || 'M';
  else
    V_TIMEZONE_OFFSET := '-PT' || ((P_TIMEZONE_OFFSET * -1) * 60) || 'M';
  end if;
    
  V_RESOURCE_DOCUMENT := DBMS_XMLDOM.newDOMDocument(P_RESOURCE);
  V_RESOURCE_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_RESOURCE_DOCUMENT);

  if DBMS_XMLDOM.ISNULL(DBMS_XMLDOM.getOwnerDocument(P_NEW_PARENT)) then
    V_TARGET_DOCUMENT   := DBMS_XMLDOM.makeDocument(P_NEW_PARENT);
  else
    V_TARGET_DOCUMENT   := DBMS_XMLDOM.getOwnerDocument(P_NEW_PARENT);
  end if;

  -- Append the cloned resource node to the new parent immediately to prevent ORA-3113 when appending children
  
  V_RESOURCE_NODE     := DBMS_XMLDOM.cloneNode(DBMS_XMLDOM.makeNode(V_RESOURCE_ELEMENT),FALSE);
  V_RESOURCE_NODE     := DBMS_XMLDOM.adoptNode(V_TARGET_DOCUMENT,V_RESOURCE_NODE); 
  V_RESOURCE_NODE     := DBMS_XMLDOM.appendChild(P_NEW_PARENT,V_RESOURCE_NODE);
  
  -- Fix for Clone node not setting node values correctly.   

  V_NAMED_NODE_MAP := DBMS_XMLDOM.getAttributes(dbms_xmldom.makeNode(V_RESOURCE_ELEMENT));
  for i in 0..DBMS_XMLDOM.getLength(V_NAMED_NODE_MAP) -1 loop
    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NAMED_NODE_MAP,i);
    DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_RESOURCE_NODE),DBMS_XMLDOM.getNodeName(V_SOURCE_NODE),DBMS_XMLDOM.getNodeValue(V_SOURCE_NODE));
  end loop;
  
  $IF $$DEBUG $THEN
     XDB_OUTPUT.createOutputFile('/public/t1.log',TRUE);
	$END
  
  V_NODE_LIST         := DBMS_XMLDOM.getChildNodes(DBMS_XMLDOM.makeNode(V_RESOURCE_ELEMENT));
 
  for i in 0..DBMS_XMLDOM.getLength(V_NODE_LIST) -1 loop

    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NODE_LIST,i);
    
    $IF $$DEBUG $THEN
      XDB_OUTPUT.writeOutputFileEntry('Source Node : ' || DBMS_XMLDOM.getLocalName(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) || '. Namespace = "' || DBMS_XMLDOM.getNamespace(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) || '".');
      XDB_OUTPUT.flushOutputFile();
  	$END

    if (DBMS_XMLDOM.getNamespace(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) = XDB_NAMESPACES.RESOURCE_NAMESPACE) then
      --
      -- Elements in XDBResource Namespace...
      --

      --
      -- SKIP ACL definitions and Content Locators [Base Properties].
      --
      
      if (DBMS_XMLDOM.getNodeName(V_SOURCE_NODE) in ('ACL','Flags','XMLLob','XMLRef','SBResExtra')) then
        CONTINUE;
      end if;
      
      --
      -- Skip Content [Generated Properties]
      --

      if ((DBMS_XMLDOM.getNodeName(V_SOURCE_NODE) = 'Contents') and (NOT P_INCLUDE_CONTENTS)) then
        CONTINUE;
      end if;      

      -- 
      -- Non Schema Based Metadata : ResExtra
      -- 

      if ((DBMS_XMLDOM.getLocalName(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) in ('ResExtra')) and (P_INCLUDE_EXTENDED_METADATA)) then
   		  --
        -- Hack for Schema Based Metadata which also seems to appear as children of ResExtra, rather than as children of Resource. 
        --
        -- Issue with Schema Based Metadata when walking the DOM tree.
        --
        -- The root node of the Schema Based Metadata appears to be found by accessing the Parent Node of the child the ResExtra node.
        -- Not sure how well this works when there are multiple SB metadata nodes. Additional code may be needed to process the node and it's siblings.
        --
   
        V_RESEXTRA_NODE := V_SOURCE_NODE;
        
        V_SOURCE_NODE := DBMS_XMLDOM.getParentNode(DBMS_XMLDOM.getFirstChild(V_RESEXTRA_NODE));
                
        $IF $$DEBUG $THEN
          XDB_OUTPUT.writeOutputFileEntry('ResExtra Node : ' || DBMS_XMLDOM.getLocalName(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) || '. Namespace = "' || DBMS_XMLDOM.getNamespace(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) || '".');
          XDB_OUTPUT.writeOutputFileEntry('Has Children : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(DBMS_XMLDOM.HASCHILDNODES(V_SOURCE_NODE)) || '.');
          XDB_OUTPUT.flushOutputFile();
  	    $END

        if (DBMS_XMLDOM.getLocalName(DBMS_XMLDOM.makeElement(V_SOURCE_NODE)) is not NULL) then
          V_TARGET_NODE := DBMS_XMLDOM.adoptNode(V_TARGET_DOCUMENT,V_SOURCE_NODE);
        
          --
          -- Prefixes do not appear to always be preserved properly when schema-based metadata is the source for an adoptNode operation.
          --
        
          if (DBMS_XMLDOM.getPrefix(V_SOURCE_NODE) != DBMS_XMLDOM.getPrefix(V_TARGET_NODE)) then
            DBMS_XMLDOM.setPrefix(V_TARGET_NODE,DBMS_XMLDOM.getPrefix(V_SOURCE_NODE));
          end if;
        
          V_TARGET_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,V_TARGET_NODE);
        end if;
        CONTINUE;
      end if;

      V_TARGET_NODE := DBMS_XMLDOM.cloneNode(V_SOURCE_NODE,TRUE);
      V_TARGET_NODE := DBMS_XMLDOM.adoptNode(V_TARGET_DOCUMENT,V_TARGET_NODE);
      V_TARGET_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,V_TARGET_NODE);

      --
      -- Add derivedValue attribute for Owner, LastModifier, Creator, SchemaElement, ContentSize
      --

      if (DBMS_XMLDOM.getNodeName(V_TARGET_NODE) in ('Owner','LastModifier','Creator','SchemaElement','ContentSize')) then
         DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_TARGET_NODE),'derivedValue',DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(V_SOURCE_NODE)));
         CONTINUE;
      end if;

      --
      -- Add derivedValue attribute for ModificationDate, CreationDate
      --

      if DBMS_XMLDOM.getNodeName(V_TARGET_NODE) in ('CreationDate','ModificationDate') then
        V_TIMESTAMP := to_timestamp(DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(V_SOURCE_NODE)),'YYYY-MM-DD"T"HH24:MI:SS.FF');
        V_TIMESTAMP := V_TIMESTAMP + to_dsinterval(V_TIMEZONE_OFFSET);
        DBMS_XMLDOM.setNodeValue(DBMS_XMLDOM.getFirstChild(V_TARGET_NODE),to_char(V_TIMESTAMP,'YYYY-MM-DD"T"HH24:MI:SS.FF'));
        CONTINUE;
      end if;

      if (DBMS_XMLDOM.getNodeName(V_SOURCE_NODE) = 'ACLOID') then
        DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_TARGET_NODE),'derivedValue',P_ACL_PATH);
      end if;

      CONTINUE;
    end if;
    
   if (P_INCLUDE_EXTENDED_METADATA) then 
     begin
      	
        V_TARGET_NODE := DBMS_XMLDOM.adoptNode(V_TARGET_DOCUMENT,V_SOURCE_NODE);
        if (DBMS_XMLDOM.getPrefix(V_SOURCE_NODE) != DBMS_XMLDOM.getPrefix(V_TARGET_NODE)) then
          DBMS_XMLDOM.setPrefix(V_TARGET_NODE,DBMS_XMLDOM.getPrefix(V_SOURCE_NODE));
        end if;
        V_TARGET_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,V_TARGET_NODE);
        
      exception
        when non_existant_table then
        --
        -- SCHEMA BASED DOCUMENT where current user has no access to default table or default table has been dropped. 
        --
          CONTINUE;
        when others then
          raise;
      end;
    end if;

    -- xdb_debug.addTraceFileEntry(DBMS_XMLDOM.getXMLType(V_TARGET_DOCUMENT));
  
  end loop;
  

  return V_RESOURCE_NODE;
end;
--
function getResourceStatus(P_RESID RAW, P_LINK VARCHAR2, P_PATH VARCHAR2, P_TARGET_DOCUMENT DBMS_XMLDOM.DOMDocument, P_CUSTOM_VIEWER XMLTYPE)
return DBMS_XMLDOM.DOMNode
as
  V_RESOURCE_STATUS_XML  XMLType;
  V_RESOURCE_STATUS      DBMS_XMLDOM.DOMNode;


  V_HAS_LINK             BINARY_INTEGER;
  V_HAS_UPDATE           BINARY_INTEGER;

  V_LINK_PRIVILEGE       XMLType := XMLType(
  '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
              xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
     <link/>
   </privilege>');

  V_UPDATE_PRIVILEGE       XMLType := XMLType(
  '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
              xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
     <update/>
   </privilege>');
begin
  --
  -- createElement with Namespace does not appear to work..
  --
 
  -- V_RESOURCE_STATUS := DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_BINDINGS_DOCUMENT,'ResourceStatus',XFILES_CONSTANTS.NAMESPACE_XFILES));


  -- V_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_STATUS,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_BINDINGS_DOCUMENT,'Resid',XFILES_CONSTANTS.NAMESPACE_XFILES)));
  -- V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_BINDINGS_DOCUMENT,b.RESID)));

  -- V_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_STATUS,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_BINDINGS_DOCUMENT,'LinkName',XFILES_CONSTANTS.NAMESPACE_XFILES)));
  -- V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_BINDINGS_DOCUMENT,b.LINK)));

  -- V_NODE := DBMS_XMLDOM.appendChild(V_RESOURCE_STATUS,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_BINDINGS_DOCUMENT,'CurrentPath',XFILES_CONSTANTS.NAMESPACE_XFILES)));
  -- DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_NODE),'EncodedPath',b.PATH,XFILES_CONSTANTS.NAMESPACE_XFILES);
  -- V_NODE := DBMS_XMLDOM.appendChild(V_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_BINDINGS_DOCUMENT,b.PATH)));

  V_HAS_LINK   := DBMS_XDB.checkPrivileges(P_PATH,V_LINK_PRIVILEGE);
  V_HAS_UPDATE := DBMS_XDB.checkPrivileges(P_PATH,V_UPDATE_PRIVILEGE);
  
  select xmlElement
         (
           "xfiles:ResourceStatus",
           xmlAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns:xfiles"),
           xmlElement("xfiles:Resid",P_RESID),
           xmlElement("xfiles:LinkName",P_LINK),
           P_CUSTOM_VIEWER,
      	   xmlElement(
      	     "xfiles:folderPermissions",
      	     xmlAttributes('link' as "type"),
      	     decode(V_HAS_LINK, 1, 'link')
      	   ),
	         xmlElement(
	           "xfiles:folderPermissions",
      	     xmlAttributes('update' as "type"),
	           decode(V_HAS_UPDATE, 1, 'update')
	         ),
           xmlElement(
             "xfiles:CurrentPath",
             xmlAttributes(P_PATH as "xfiles:EncodedPath"),
             P_PATH
           )
         )
    into V_RESOURCE_STATUS_XML
    from DUAL;
    
  V_RESOURCE_STATUS := DBMS_XMLDOM.makeNode(DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(V_RESOURCE_STATUS_XML))); 
  V_RESOURCE_STATUS := DBMS_XMLDOM.importNode(P_TARGET_DOCUMENT,V_RESOURCE_STATUS,TRUE);

  return V_RESOURCE_STATUS;
end;    
--
function getXFilesParameters(P_TARGET_DOCUMENT DBMS_XMLDOM.DOMDocument)
return DBMS_XMLDOM.DOMNode
as
  V_XFILES_PARAMETERS_XML XMLType;
  V_XFILES_PARAMETERS     DBMS_XMLDOM.DOMNode;
begin
    
  select xmlElement
         (
           "xfiles:xfilesParameters",
           xmlAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns:xfiles"),
           -- xmlElement("xfiles:user",XDB_USERNAME.GET_USERNAME()),
           xmlElement("xfiles:user",USER),
           xmlElement("xfiles:task",NULL),
           xmlElement("xfiles:sortKey",'xfiles:LinkName'),
           xmlElement("xfiles:sortOrder",'ascending')
         )
    into V_XFILES_PARAMETERS_XML
    from DUAL;
    
  V_XFILES_PARAMETERS := DBMS_XMLDOM.makeNode(DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(V_XFILES_PARAMETERS_XML))); 
  V_XFILES_PARAMETERS := DBMS_XMLDOM.importNode(P_TARGET_DOCUMENT,V_XFILES_PARAMETERS,TRUE);

  return V_XFILES_PARAMETERS;
end;    
--
procedure getResource(P_RESOURCE_PATH IN VARCHAR2, P_INCLUDE_CONTENTS BOOLEAN, P_TIMEZONE_OFFSET NUMBER, P_RESOURCE IN OUT XMLType, P_RESID IN OUT RAW)
as
  V_LINK              VARCHAR2(256);
  V_ACL_PATH          VARCHAR2(700);
  
  V_RESOURCE          XMLType;
  V_RESOURCE_DOCUMENT DBMS_XMLDOM.DOMDocument;
  V_RESOURCE_NODE     DBMS_XMLDOM.DOMNode;
  V_NODE              DBMS_XMLDOM.DOMNode;

  /* 
  **
  ** Get ACL Path via an inner select so that we get ACL_PATH = NULL
  ** rather than "No Rows Found" if we cannot find an valid ACL Path
  **
  */


  cursor getResource
  is
  select substr('/XFILES/WebServices',instr('/XFILES/WebServices','/',-1)) LINK, 
         r.RESID, 
         r.RES,
         ( select ar.ANY_PATH 
             from RESOURCE_VIEW  ar 
            where XMLCast(
                   XMLQuery(
                    'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                     $RES/Resource/ACLOID'
                     passing r.RES as "RES"
                     returning content
                   ) as RAW(16)
                 ) = SYS_OP_R2O(
                       XMLCast(
                         XMLQuery(
                           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                            fn:data($RES/Resource/XMLRef)'
                            passing ar.RES as "RES"
                            returning content
                         ) as REF XMLType
                       )
                     )
          ) ACL_PATH
     from RESOURCE_VIEW r
   where equals_path(r.RES,P_RESOURCE_PATH) = 1;

begin  
	$IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('getResource P_RESOURCE_PATH    : ' || P_RESOURCE_PATH);
     XDB_OUTPUT.writeLogFileEntry('getResource P_INCLUDE_CONTENTS : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_INCLUDE_CONTENTS));
     XDB_OUTPUT.flushLogFile();
  $END
  
  V_RESOURCE_DOCUMENT := DBMS_XMLDOM.newDOMDocument();

  if (P_RESOURCE_PATH = '/') then
      V_LINK              := '/';
      P_RESID             := DBMS_XDB.getresoid(P_RESOURCE_PATH);
      V_RESOURCE          := DBMS_XDB_VERSION.getResourceByRESID(P_RESID);
      
      select ar.ANY_PATH
        into V_ACL_PATH
        from RESOURCE_VIEW ar
       where XMLCast(
               XMLQuery(
                'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                 $RES/Resource/ACLOID'
                 passing V_RESOURCE as "RES"
                 returning content
               ) as RAW(16)
             ) = SYS_OP_R2O (
                   XMLCast(
                     XMLQuery(
                       'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                        fn:data($RES/Resource/XMLRef)'
                        passing ar.RES as "RES"
                        returning content
                     ) as REF XMLType
                   )
                 );      
    V_RESOURCE_NODE     := cloneResource(V_RESOURCE,dbms_xmldom.makeNode(V_RESOURCE_DOCUMENT),P_INCLUDE_CONTENTS,TRUE,P_TIMEZONE_OFFSET,V_ACL_PATH);
  else
    for r in getResource loop
      V_LINK              := r.LINK;
      P_RESID             := r.RESID;
      V_RESOURCE_NODE     := cloneResource(r.RES,dbms_xmldom.makeNode(V_RESOURCE_DOCUMENT),P_INCLUDE_CONTENTS,TRUE,P_TIMEZONE_OFFSET,r.ACL_PATH);
    end loop;
  end if;

  V_NODE      := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,getResourceStatus(P_RESID,V_LINK,P_RESOURCE_PATH,V_RESOURCE_DOCUMENT,NULL));
  V_NODE      := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,getXFilesParameters(V_RESOURCE_DOCUMENT));
  DBMS_XMLDOM.setVersion(V_RESOURCE_DOCUMENT, '1.0'); 
  DBMS_XMLDOM.setCharset(V_RESOURCE_DOCUMENT, 'UTF8');
  P_RESOURCE  := DBMS_XMLDOM.getXMLType(V_RESOURCE_DOCUMENT);

	$IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('getResource P_RESOURCE :');
     XDB_OUTPUT.writeLogFileEntry(P_RESOURCE);
     XDB_OUTPUT.writeLogFileEntry('getResource : Processing Complete.');
     XDB_OUTPUT.flushLogFile();
  $END

end;
--
procedure getFolderListingInternal(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_EXTENDED_METADATA BOOLEAN, P_TIMEZONE_OFFSET NUMBER, P_CHILDREN IN OUT XMLType)
as
/*
  cursor getBindings
  is
  select PATH, 
         -- path(1) LINK, 
         XMLCAST
         (
            XMLQUERY
            (
              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBStandard"; (: :)
              $L/LINK/Name' 
              passing LINK as "L" 
              returning content
            ) as VARCHAR2(256)
         ) LINK,
         RESID, 
         RES
    from XDB.PATH_VIEW p
   where under_path(res,1,P_FOLDER_PATH,1) = 1;
*/
  cursor getBindings
  is
  select PATH, 
         SUBSTR(PATH,INSTR(PATH,'/',-1)+1) LINK, 
         RESID, 
         RES,
         XMLQUERY(
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
            declare namespace xfiles = "http://xmlns.oracle.com/xdb/xfiles"; (: :)
            $r/Resource/xfiles:CustomViewer' 
            passing RES as "r" returning CONTENT
         ) CUSTOM_VIEWER
    from (
            select PATH, 
                   RESID, 
                   RES
              from XDB.PATH_VIEW p
             where under_path(res,1,P_FOLDER_PATH,1) = 1
        );

  V_BINDINGS_DOCUMENT   DBMS_XMLDOM.DOMDocument;
  V_BINDINGS_ELEMENT    DBMS_XMLDOM.DOMElement;

  V_RESOURCE_STATUS     DBMS_XMLDOM.DOMNode;
  V_RESOURCE_NODE       DBMS_XMLDOM.DOMNode;
  
begin
  -- execute immediate 'alter session set TIME_ZONE=''-08:00''';

  P_CHILDREN := xmlType('<xfiles:DirectoryContents ' || XFILES_CONSTANTS.NSPREFIX_XFILES_XFILES || '/>');

  V_BINDINGS_DOCUMENT := DBMS_XMLDOM.newDOMDocument(P_CHILDREN);
  V_BINDINGS_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_BINDINGS_DOCUMENT);

  /*
  **
  ** ACL_PATH is only returned when fetching a single resource.
  **
  */

	$IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('getFolderListingInternal : Fetching Children.');
     XDB_OUTPUT.flushLogFile();
  $END

  for b in getBindings loop
  	$IF $$DEBUG $THEN
       XDB_OUTPUT.writeLogFileEntry('getFolderListingInternal b.PATH               : ' || b.PATH);
       XDB_OUTPUT.flushLogFile();
    $END
    begin
      V_RESOURCE_NODE     := cloneResource(b.RES,DBMS_XMLDOM.makeNode(V_BINDINGS_ELEMENT),FALSE, P_INCLUDE_EXTENDED_METADATA, P_TIMEZONE_OFFSET,NULL);
      V_RESOURCE_STATUS   := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,getResourceStatus(b.RESID,b.LINK,b.PATH,V_BINDINGS_DOCUMENT,b.CUSTOM_VIEWER));
  $IF $$DEBUG $THEN
    exception
      when others then
           XDB_OUTPUT.writeLogFileEntry('getFolderListing STACK TRACE : ');
           XDB_OUTPUT.writeLogFileEntry(XFILES_LOGGING.captureStackTrace());
           XDB_OUTPUT.flushLogFile();
        RAISE;
  $END
    end;
  end loop;
$IF $$DEBUG $THEN
exception
  when others then
    XDB_OUTPUT.writeLogFileEntry('getFolderListing STACK TRACE : ');
    XDB_OUTPUT.writeLogFileEntry(XFILES_LOGGING.captureStackTrace());
    XDB_OUTPUT.flushLogFile();
    RAISE;
$END
end;
--
procedure getVersionHistoryInternal(P_RESID RAW, P_TIMEZONE_OFFSET NUMBER, P_VERSION_HISTORY IN OUT XMLTYPE)
as
  cursor getBindings
  is
  select DBMS_XDB.createOIDPath(RESID) PATH,
         NULL LINK,
         RESID,
         RES
    from (
         
           select RESID.COLUMN_VALUE RESID,
                  DBMS_XDB_VERSION.GETRESOURCEBYRESID(RESID.COLUMN_VALUE) RES
             from table(XDB_UTILITIES.getVersionsByResid(P_RESID)) RESID
            where RESID.COLUMN_VALUE != P_RESID
         ) v;

  V_BINDINGS_DOCUMENT   DBMS_XMLDOM.DOMDocument;
  V_BINDINGS_ELEMENT    DBMS_XMLDOM.DOMElement;

  V_RESOURCE_STATUS     DBMS_XMLDOM.DOMNode;
  V_RESOURCE_NODE       DBMS_XMLDOM.DOMNode;  
begin
  P_VERSION_HISTORY := xmlType('<xfiles:VersionHistory ' || XFILES_CONSTANTS.NSPREFIX_XFILES_XFILES || '/>');

  V_BINDINGS_DOCUMENT := DBMS_XMLDOM.newDOMDocument(P_VERSION_HISTORY);
  V_BINDINGS_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_BINDINGS_DOCUMENT);

  for b in getBindings loop
    V_RESOURCE_NODE     := cloneResource(b.RES,DBMS_XMLDOM.makeNode(V_BINDINGS_ELEMENT),FALSE,FALSE,P_TIMEZONE_OFFSET,NULL);
    V_RESOURCE_STATUS   := DBMS_XMLDOM.appendChild(V_RESOURCE_NODE,getResourceStatus(b.RESID,b.LINK,b.PATH,V_BINDINGS_DOCUMENT,NULL));
  end loop;
end;
--
function isFolder(P_RESOURCE_PATH VARCHAR2) 
return boolean
as
  V_IS_FOLDER BINARY_INTEGER := 0;
begin
  select count(*)
    into V_IS_FOLDER
    from RESOURCE_VIEW
   where equals_path(RES, P_RESOURCE_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $r/Resource[@Container=xs:boolean("true")]' passing RES as "r");
  
  return V_IS_FOLDER = 1;
end;
--
procedure setContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB) 
as
  V_LOB_LOCATOR BLOB;
  V_XMLREF      REF XMLTYPE;
begin
  select extractValue(RES,'/Resource/XMLLob'), extractValue(RES,'/Resource/XMLRef') 
    into V_LOB_LOCATOR, V_XMLREF
    from RESOURCE_VIEW
   where equals_path(RES,P_RESOURCE_PATH) = 1
     for update;

  if (V_LOB_LOCATOR is not null) then
    DBMS_LOB.TRIM(V_LOB_LOCATOR,0);
    DBMS_LOB.COPY(V_LOB_LOCATOR,P_CONTENT,DBMS_LOB.getLength(P_CONTENT),1,1);
    return;
  end if;
  
  if (V_XMLREF is not null) then
    update RESOURCE_VIEW
       set RES = updateXML(RES,'/Resource/Contents',xmltype(P_CONTENT,nls_charset_id('AL32UTF8')))
     where equals_path(RES,P_RESOURCE_PATH) = 1;
   return;
 end if;
end;
--
procedure GETRESOURCE(P_RESOURCE_PATH IN VARCHAR2, P_INCLUDE_CONTENTS BOOLEAN  DEFAULT FALSE, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType)
as
  V_RESID             RAW(16);
begin
  DBMS_XDB_PRINT.setPrintMode(PRINT_SUPPRESS_CONTENT);
  getResource(P_RESOURCE_PATH, P_INCLUDE_CONTENTS, P_TIMEZONE_OFFSET, P_RESOURCE, V_RESID);
  DBMS_XDB_PRINT.clearPrintMode(PRINT_SUPPRESS_CONTENT);
end;
--
procedure GETFOLDERLISTING(P_FOLDER_PATH IN VARCHAR2, P_INCLUDE_EXTENDED_METADATA BOOLEAN, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_FOLDER IN OUT XMLType)
as
  V_RESID             RAW(16);
  V_CHILDREN          XMLTYPE;
begin

	$IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('getFolderListing P_FOLDER_PATH               : ' || P_FOLDER_PATH);
     XDB_OUTPUT.writeLogFileEntry('getFolderListing P_INCLUDE_EXTENDED_METADATA : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_INCLUDE_EXTENDED_METADATA));
     XDB_OUTPUT.flushLogFile();
  $END

  DBMS_XDB_PRINT.setPrintMode(PRINT_SUPPRESS_CONTENT);
  getResource(P_FOLDER_PATH, FALSE, P_TIMEZONE_OFFSET, P_FOLDER, V_RESID);
  getFolderListingInternal(P_FOLDER_PATH, P_INCLUDE_EXTENDED_METADATA, P_TIMEZONE_OFFSET, V_CHILDREN);
  P_FOLDER := P_FOLDER.appendChildXML('/Resource',V_CHILDREN,'xmlns="http://xmlns.oracle.com/xdb/XDBResource.xsd"');
  DBMS_XDB_PRINT.clearPrintMode(PRINT_SUPPRESS_CONTENT);

	$IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('getFolderListing P_FOLDER :');
     XDB_OUTPUT.writeLogFileEntry(P_FOLDER);
     XDB_OUTPUT.writeLogFileEntry('getFolderListing : Processing Complete.');
     XDB_OUTPUT.flushLogFile();
  $END


end;
--
procedure GETVERSIONHISTORY(P_RESOURCE_PATH IN VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0, P_RESOURCE IN OUT XMLType)
as
  V_RESID             RAW(16);
  V_VERSION_HISTORY   XMLTYPE;
begin
  DBMS_XDB_PRINT.setPrintMode(PRINT_SUPPRESS_CONTENT);
  getResource(P_RESOURCE_PATH, FALSE, P_TIMEZONE_OFFSET, P_RESOURCE, V_RESID);
  getVersionHistoryInternal(V_RESID,P_TIMEZONE_OFFSET, V_VERSION_HISTORY);
  P_RESOURCE := P_RESOURCE.appendChildXML('/Resource',V_VERSION_HISTORY,'xmlns="http://xmlns.oracle.com/xdb/XDBResource.xsd"');
  DBMS_XDB_PRINT.clearPrintMode(PRINT_SUPPRESS_CONTENT);
end;
--
procedure updateResourceMetadata(P_RESOURCE in out DBMS_XDBRESOURCE.XDBResource, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2)
as
  V_RESOURCE_DIRTY BOOLEAN := FALSE;
begin
	if (P_CONTENT_TYPE is not NULL) then
    DBMS_XDBRESOURCE.setContentType(P_RESOURCE, P_CONTENT_TYPE);
    V_RESOURCE_DIRTY := TRUE;
  end if;
	if (P_DESCRIPTION is not NULL) then
    DBMS_XDBRESOURCE.setComment(P_RESOURCE, P_DESCRIPTION);
    V_RESOURCE_DIRTY := TRUE;
  end if;
	if (P_LANGUAGE is not NULL) then
    DBMS_XDBRESOURCE.setLanguage(P_RESOURCE, P_LANGUAGE);
    V_RESOURCE_DIRTY := TRUE;
  end if;
	if (P_CHARACTER_SET is not NULL) then
    DBMS_XDBRESOURCE.setCharacterSet(P_RESOURCE, P_CHARACTER_SET);
    V_RESOURCE_DIRTY := TRUE;
  end if;
  if (V_RESOURCE_DIRTY) then
    DBMS_XDBRESOURCE.save(P_RESOURCE);
  end if;
end;
--
procedure CREATEFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_RESULT            BOOLEAN;
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
begin
  V_RESULT := DBMS_XDB.createFolder(P_FOLDER_PATH);
    
  if (P_DESCRIPTION is not NULL) then
    V_RESOURCE := DBMS_XDB.getResource(P_FOLDER_PATH);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_DESCRIPTION);
    DBMS_XDBRESOURCE.save(V_RESOURCE);
  end if;
end;
--
procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
begin
  XFILES_WIKI_SERVICES.createWikiPage(P_RESOURCE_PATH,P_DESCRIPTION);
end;
--
procedure setACLInternal(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN)
as

  cursor getListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH) = 1;

begin

  DBMS_XDB.setACL(P_RESOURCE_PATH,P_ACL_PATH);
 
  if (isFolder(P_RESOURCE_PATH) and P_DEEP) then
	  for r in getListing loop
  	  DBMS_XDB.setACL(r.PATH,P_ACL_PATH);
  	end loop;
  end if;

end;
--
procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
begin
  setACLInternal(P_RESOURCE_PATH,P_ACL_PATH,P_DEEP);
end;
--
procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
begin
  DBMS_XDB.CHANGEOWNER(P_RESOURCE_PATH,P_NEW_OWNER,P_DEEP);
end;
--
procedure makeFolderVersionedInternal(P_FOLDER_PATH VARCHAR2)
as
  V_RESID             RAW(16);

  cursor getDocumentListing
  is
  select path
    from PATH_VIEW
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false" and @IsVersioned="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
    
  for d in getDocumentListing loop
    V_RESID := DBMS_XDB_VERSION.makeVersioned(d.PATH);
  end loop;
  
end;
--
procedure MAKEVERSIONED(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESID             RAW(16);

  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");

begin
  if (not isFolder(P_RESOURCE_PATH)) then    
    V_RESID := DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);
  else
    -- Version all documents in the current folder
    makeFolderVersionedInternal(P_RESOURCE_PATH);
    if (P_DEEP) then
      for f in getFolderListing loop
        makeFolderVersionedInternal(f.PATH);
      end loop;
    end if;
  end if;

end;
--
procedure checkOutFolderInternal(P_FOLDER_PATH VARCHAR2)
as
  V_RESID             RAW(16);

  cursor getDocumentListing
  is
  select path
    from PATH_VIEW
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
    
  for d in getDocumentListing loop
    DBMS_XDB_VERSION.checkOut(d.PATH);
  end loop;
  
end;
--
procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");
begin
  if (not isFolder(P_RESOURCE_PATH)) then    
    DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);
  else
    -- Check Out all documents in the current folder
    checkOutFolderInternal(P_RESOURCE_PATH);
    if (P_DEEP) then
      for f in getFolderListing loop
        checkOutFolderInternal(f.PATH);
      end loop;
    end if;
  end if;
end;
--
procedure checkInFolderInternal(P_FOLDER_PATH VARCHAR2, P_COMMENT VARCHAR2)
as
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESID             RAW(16);

  cursor getDocumentListing
  is
  select path
    from PATH_VIEW
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
    
  for d in getDocumentListing loop
    if (P_COMMENT is not NULL) then
      V_RESOURCE := DBMS_XDB.getResource(d.PATH);
      DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);
      DBMS_XDBRESOURCE.save(V_RESOURCE);
     end if;
    V_RESID := DBMS_XDB_VERSION.checkIn(d.PATH);
  end loop;
  
end;
--
procedure CHECKIN(P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)
as
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESID             RAW(16);

  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");

begin
  if (not isFolder(P_RESOURCE_PATH)) then    
    if (P_COMMENT is not NULL) then
      V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
      DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);
      DBMS_XDBRESOURCE.save(V_RESOURCE);
     end if;
    V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);
  else
    -- Check In all documents in the current folder
    checkInFolderInternal(P_RESOURCE_PATH,P_COMMENT);
    if (P_DEEP) then
      for f in getFolderListing loop
        checkInFolderInternal(f.PATH,P_COMMENT);
      end loop;
    end if;
  end if;
end;
--
procedure lockFolderInternal(P_FOLDER_PATH VARCHAR2)
as
  V_RESULT            BOOLEAN;

  cursor getDocumentListing
  is
  select path
    from PATH_VIEW
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
   
  V_RESULT := DBMS_XDB.lockResource(P_FOLDER_PATH,FALSE,FALSE);

  for d in getDocumentListing loop
    V_RESULT := DBMS_XDB.lockResource(d.PATH,FALSE,FALSE);
  end loop;

end;
--
procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_RESULT            BOOLEAN;

  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");

begin
  if (not isFolder(P_RESOURCE_PATH)) then    
    V_RESULT := DBMS_XDB.lockResource(P_RESOURCE_PATH,FALSE,FALSE);
  else
    lockFolderInternal(P_RESOURCE_PATH);
    if (P_DEEP) then
      for f in getFolderListing loop
        lockFolderInternal(f.PATH);
      end loop;
    end if;
  end if;
end;
--
procedure unlockFolderInternal(P_FOLDER_PATH VARCHAR2)
as
  V_TOKEN             VARCHAR2(64);
  V_RESULT            BOOLEAN;

  cursor getDocumentListing
  is
  select path
    from PATH_VIEW
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
    
  DBMS_XDB.getlocktoken(P_FOLDER_PATH,V_TOKEN); 
  V_RESULT := DBMS_XDB.unlockresource(P_FOLDER_PATH,V_TOKEN);

  for d in getDocumentListing loop
    DBMS_XDB.getlocktoken(d.PATH,V_TOKEN); 
    V_RESULT := DBMS_XDB.unlockresource(d.PATH,V_TOKEN);
  end loop;

    DBMS_XDB.getlocktoken(P_FOLDER_PATH,V_TOKEN); 
  V_RESULT := DBMS_XDB.lockResource(P_FOLDER_PATH,FALSE,FALSE);
  
end;
--
procedure UNLOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)
as
  V_TOKEN             VARCHAR2(64);
  V_RESULT            BOOLEAN;

  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");

begin
   if (not isFolder(P_RESOURCE_PATH)) then    
    DBMS_XDB.getlocktoken(P_RESOURCE_PATH,V_TOKEN); 
    V_RESULT := DBMS_XDB.unlockresource(P_RESOURCE_PATH,V_TOKEN);
  else
    unlockFolderInternal(P_RESOURCE_PATH);
    if (P_DEEP) then
      for f in getFolderListing loop
        unlockFolderInternal(f.PATH);
      end loop;
    end if;
  end if;
end;
--
procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN, P_FORCE BOOLEAN)
as
  V_RESID             RAW(16);
begin
  if (P_DEEP) then
    if (P_FORCE) then
      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RECURSIVE_FORCE);
    else
      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RECURSIVE);
    end if;
  else
    if (P_FORCE) then
      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_FORCE);
    else
      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RESOURCE);
    end if;
  end if;
end;
--
procedure SETRSSFEED(P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN)
as  
  cursor getFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_FOLDER_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res");
  
begin
  if (P_ENABLE) THEN
    XFILES_UTILITIES.enableRSSFeed(P_FOLDER_PATH,P_ITEMS_CHANGED_IN);
  ELSE
    XFILES_UTILITIES.disableRSSFeed(P_FOLDER_PATH);
  END IF;

  if (P_DEEP) then
    if (P_ENABLE) THEN
      XFILES_UTILITIES.enableRSSFeed(P_FOLDER_PATH,P_ITEMS_CHANGED_IN);
      for f in getFolderListing loop
        XFILES_UTILITIES.enableRSSFeed(f.PATH,P_ITEMS_CHANGED_IN);
      end loop;
    ELSE
      XFILES_UTILITIES.disableRSSFeed(P_FOLDER_PATH);
      for f in getFolderListing loop
        XFILES_UTILITIES.disableRSSFeed(f.PATH);
      end loop;
    END IF;
  end if;
end;
--
procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)
as
begin
  DBMS_XDB.link(P_RESOURCE_PATH,P_TARGET_FOLDER,substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,'/',-1)+1),P_LINK_TYPE);
end;
--
procedure MOVERESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)
as
begin
  DBMS_XDB.renameResource(P_RESOURCE_PATH,P_TARGET_FOLDER,substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,'/',-1)+1));
end;
--
procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2)
as
begin
  DBMS_XDB.renameResource(P_RESOURCE_PATH,substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1),P_NEW_NAME);
end;
--
procedure copyCreateDocument(P_TARGET_PATH VARCHAR2, P_SOURCE_PATH VARCHAR2, P_DUPLICATE_POLICY VARCHAR2)
as
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
  V_RESID             RAW(16);
  V_RESULT            BOOLEAN;
begin	

  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('copyCreateDocument P_TARGET_PATH :' || P_TARGET_PATH );
     XDB_OUTPUT.writeLogFileEntry('copyCreateDocument P_SOURCE_PATH :' || P_SOURCE_PATH );
     XDB_OUTPUT.flushLogFile();
	$END


  if (not DBMS_XDB.existsResource(P_TARGET_PATH)) then
    V_RESULT := DBMS_XDB.createResource(P_TARGET_PATH,xdburitype(P_SOURCE_PATH).getBlob());
    return;
  end if;      


	if (P_DUPLICATE_POLICY = XDB_CONSTANTS.SKIP) then
	  return;
	end if;

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) then
    -- Error will be thrown if item exists
    V_RESULT := DBMS_XDB.createResource(P_TARGET_PATH,xdburitype(P_SOURCE_PATH).getBlob());
    return;
  end if;
    
  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
    V_RESOURCE := DBMS_XDB.getResource(P_TARGET_PATH);
    setContent(P_TARGET_PATH,xdburitype(P_SOURCE_PATH).getBlob());
    DBMS_XDB.refreshContentSize(P_TARGET_PATH);
  end if;

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
    V_RESOURCE := DBMS_XDB.getResource(P_TARGET_PATH);
    V_RESOURCE_ELEMENT := DBMS_XMLDOM.getDocumentElement(DBMS_XDBRESOURCE.makeDocument(V_RESOURCE));
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsVersion') = 'false') then
      V_RESID := DBMS_XDB_VERSION.makeVersioned(P_TARGET_PATH);
    end if;
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsCheckedOut') = 'true') then
      setContent(P_TARGET_PATH,xdburitype(P_SOURCE_PATH).getBlob());
      DBMS_XDB.refreshContentSize(P_TARGET_PATH);
    else
      DBMS_XDB_VERSION.checkOut(P_TARGET_PATH);
      setContent(P_TARGET_PATH,xdburitype(P_SOURCE_PATH).getBlob());
      V_RESID := DBMS_XDB_VERSION.checkIn(P_TARGET_PATH);
      DBMS_XDB.refreshContentSize(P_TARGET_PATH);
    end if;	         
    return;
  end if;
end;    
--
procedure copyCreateFolder(P_TARGET_FOLDER VARCHAR2,P_SOURCE_PATH VARCHAR2)
as
  V_RESOURCE    DBMS_XDBRESOURCE.XDBResource;
  V_RESULT      BOOLEAN;
  
begin

  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('copyCreateFolder P_TARGET_FOLDER : ' || P_TARGET_FOLDER );
     XDB_OUTPUT.flushLogFile();
	$END
  
  if (not DBMS_XDB.existsResource(P_TARGET_FOLDER)) then
    V_RESULT := DBMS_XDB.createFolder(P_TARGET_FOLDER);
    V_RESOURCE := DBMS_XDB.getResource(P_TARGET_FOLDER);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,'Copy of ' || P_SOURCE_PATH);
    DBMS_XDBRESOURCE.save(V_RESOURCE);
  end if;
  
end;
--
procedure COPYRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
  V_TARGET_PATH       VARCHAR2(1024);
  V_PARENT_PATH       VARCHAR2(1024) := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1);

  cursor deepFolderListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="true"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]' passing RES as "res")
   order by DEPTH(1);
  
  cursor deepDocumentListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
     and existsNode(res,'/r:Resource[@Container="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res")
   order by DEPTH(1);

  cursor shallowDocumentListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,1,P_RESOURCE_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
	
	-- ToDo : Code to handle '/' as SOURCE.
	-- ToDo : Code to handle Source == Target.
	
  -- If the target is a document copy the content to the target folder.
  -- If the target is a folder and deep is false do a shallow copy.
  -- If the target is a folder and deep is true to a deep copy.

  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('copyResource P_RESOURCE_PATH    : ' || P_RESOURCE_PATH);
     XDB_OUTPUT.writeLogFileEntry('copyResource P_TARGET_FOLDER    : ' || P_TARGET_FOLDER);
     XDB_OUTPUT.writeLogFileEntry('copyResource P_DEEP             : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP));
     XDB_OUTPUT.writeLogFileEntry('copyResource P_DUPLICATE_POLICY : ' || P_DUPLICATE_POLICY);
     XDB_OUTPUT.writeLogFileEntry('copyResource V_PARENT_PATH      : ' || V_PARENT_PATH);
     XDB_OUTPUT.flushLogFile();
	$END
  
  if (isFolder(P_RESOURCE_PATH)) then  
    V_TARGET_PATH := P_TARGET_FOLDER || '/' || substr(P_RESOURCE_PATH,length(V_PARENT_PATH) + 1);
    copyCreateFolder(V_TARGET_PATH, P_RESOURCE_PATH);
    if (P_DEEP) then
      for f in deepFolderListing loop
        V_TARGET_PATH := P_TARGET_FOLDER || '/' || substr(f.PATH,length(V_PARENT_PATH) + 1);
        copyCreateFolder(V_TARGET_PATH,f.PATH);
    	end loop;
      for d in deepDocumentListing loop
        V_TARGET_PATH := P_TARGET_FOLDER ||  substr(d.PATH,length(V_PARENT_PATH) + 1);
		    copyCreateDocument(V_TARGET_PATH,d.PATH,P_DUPLICATE_POLICY);
      end loop;  
    else
      for d in shallowDocumentListing loop
        V_TARGET_PATH := P_TARGET_FOLDER ||  substr(d.PATH,length(V_PARENT_PATH) + 1);
		    copyCreateDocument(V_TARGET_PATH,d.PATH,P_DUPLICATE_POLICY);
			end loop;      
    end if;    
  else  
    V_TARGET_PATH := P_TARGET_FOLDER || '/' || substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,'/',-1)+1);
    copyCreateDocument(V_TARGET_PATH,P_RESOURCE_PATH,P_DUPLICATE_POLICY);
  end if;


  $IF $$DEBUG $THEN
	  XDB_OUTPUT.flushLogFile();
	$END  
end;
--
procedure publishFolder(P_TARGET_FOLDER VARCHAR2,P_SOURCE_PATH VARCHAR2,P_MAKE_PUBLIC BOOLEAN)
as
  V_RESOURCE    DBMS_XDBRESOURCE.XDBResource;
  V_RESULT      BOOLEAN;
  
begin

  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('copyCreateFolder P_TARGET_FOLDER : ' || P_TARGET_FOLDER );
     XDB_OUTPUT.flushLogFile();
	$END
  
  if (not DBMS_XDB.existsResource(P_TARGET_FOLDER)) then
    V_RESULT := DBMS_XDB.createFolder(P_TARGET_FOLDER);
    V_RESOURCE := DBMS_XDB.getResource(P_TARGET_FOLDER);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,'Published Version of ' || P_SOURCE_PATH);
    DBMS_XDBRESOURCE.save(V_RESOURCE);
  end if;

  if (P_MAKE_PUBLIC) then
	  DBMS_XDB.setACL(P_SOURCE_PATH,'/sys/acls/bootstrap_acl.xml');
	end if;
  
end;
--
procedure publishResourceInternal(P_TARGET_PATH VARCHAR2, P_SOURCE_PATH VARCHAR2, P_MAKE_PUBLIC BOOLEAN)
as
  V_TARGET_NAME   VARCHAR2(256);
  V_TARGET_FOLDER VARCHAR2(1024);
begin
  V_TARGET_NAME   := substr(P_TARGET_PATH,instr(P_TARGET_PATH,'/',-1)+1);
  V_TARGET_FOLDER := substr(P_TARGET_PATH,1,instr(P_TARGET_PATH,'/',-1)-1);
  if (not DBMS_XDB.existsResource(P_TARGET_PATH)) then
    DBMS_XDB.link(P_SOURCE_PATH,V_TARGET_FOLDER,V_TARGET_NAME,DBMS_XDB.LINK_TYPE_WEAK);
    if (P_MAKE_PUBLIC) then
      DBMS_XDB.setACL(P_SOURCE_PATH,'/sys/acls/bootstrap_acl.xml');
    end if;
  end if;
end;    
--
procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_MAKE_PUBLIC BOOLEAN DEFAULT FALSE)
as
  V_TARGET_PATH       VARCHAR2(1024);
  V_TARGET_FOLDER     VARCHAR2(1024);
  V_PARENT_PATH       VARCHAR2(1024) := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1);
  
  cursor deepResourceListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,P_RESOURCE_PATH,1) = 1
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res")
   order by DEPTH(1);

  cursor shallowDocumentListing
  is
  select PATH
    from PATH_VIEW
   where under_path(res,1,P_RESOURCE_PATH) = 1
     and existsNode(res,'/r:Resource[@Container="false"]',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;
  -- and xmlExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]' passing RES as "res");

begin
	
	-- ToDo : Code to handle '/' as SOURCE.
	-- ToDo : Code to handle Source == Target.
	
  -- If the target is a document create a link to the document in the User's publishedContent Folder.
  -- If the target is a folder and deep is false create a copy of the Folder in the User's publishedContent Folder and soft link the documents from the source file.
  -- If the target is a folder and deep is true create a link to the Folder in the User's publishedContentFolder
  
  -- If MakePublic is true for a shallow copy alter the ACL of all documents in the sourceFolder;
  -- If MakePublic is true for a deep copy alter the ACL of all documents and folders under the sourceFolder

  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeLogFileEntry('publishResource P_RESOURCE_PATH  : ' || P_RESOURCE_PATH);
     XDB_OUTPUT.writeLogFileEntry('publishResource P_DEEP           : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP));
     XDB_OUTPUT.writeLogFileEntry('publishResource P_MAKE_PUBLIC    : ' || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_MAKE_PUBLIC));
     XDB_OUTPUT.flushLogFile();
	$END
  
  if (not DBMS_XDB.existsResource(XDB_CONSTANTS.FOLDER_USER_PUBLIC)) then
    XDB_UTILITIES.createPublicFolder();
  else
    XDB_UTILITIES.setPublicIndexPageContent();
  end if;
  
  if (isFolder(P_RESOURCE_PATH)) then  
    V_TARGET_PATH := XDB_CONSTANTS.FOLDER_USER_PUBLIC || '/' || substr(P_RESOURCE_PATH,length(V_PARENT_PATH) + 1);
    if (P_DEEP) then
	    publishResourceInternal(V_TARGET_PATH,P_RESOURCE_PATH,P_MAKE_PUBLIC);
	    if (P_MAKE_PUBLIC) then
	      for r in deepResourceListing loop
		      DBMS_XDB.setACL(r.PATH,'/sys/acls/bootstrap_acl.xml');
	      end loop;
	    end if;	      
    else
    	publishFolder(V_TARGET_PATH,P_RESOURCE_PATH,P_MAKE_PUBLIC);
    	V_TARGET_FOLDER := V_TARGET_PATH;
      for d in shallowDocumentListing loop
	    	V_TARGET_PATH := V_TARGET_FOLDER || substr(d.PATH,instr(d.PATH,'/',-1)+1);
		    publishResourceInternal(V_TARGET_PATH,d.PATH,P_MAKE_PUBLIC);
      end loop;  
    end if;    
  else  
    V_TARGET_PATH := XDB_CONSTANTS.FOLDER_USER_PUBLIC || '/' || substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,'/',-1)+1);
    publishResourceInternal(V_TARGET_PATH,P_RESOURCE_PATH,P_MAKE_PUBLIC);
  end if;


  $IF $$DEBUG $THEN
	  XDB_OUTPUT.flushLogFile();
	$END  
end;
--
procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
/*
    Positibilites
       1. Item does not exist or Item Exists and duplicate policy is RAISE;

       2 . Item is not versioned
    //     - Version it
    //     - Check it out
    //     - Update it
    //     - Check it back in
    // 2. Item is versioned but is not checked out
    //    - Check it out
    //    - Update it
    //    - Check it back in
    // 3. Item exists and is checked out
    //    - Update it. 
    //    - Do not check it back in.
*/

  V_PARAMETERS        XMLType;
  V_STACK_TRACE       XMLType;
  V_RESID             RAW(16);
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESULT            BOOLEAN;
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
begin
  if (not DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT);
    if DBMS_XDB.existsResource(P_RESOURCE_PATH) then
      -- 
      -- Corner case - Bit Bucket Folders where the resource is deleted by a repository event.
      -- 
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
      V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
      updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);
    end if;
    return;
  end if;      

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) then
    -- Error will be thrown if item exists
    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT);
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);
    return;
  end if;
    
  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);
    setContent(P_RESOURCE_PATH,P_CONTENT);
    -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);
    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
  end if;

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    V_RESOURCE_ELEMENT := DBMS_XMLDOM.getDocumentElement(DBMS_XDBRESOURCE.makeDocument(V_RESOURCE));
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsVersion') = 'false') then
      V_RESID := DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);
    end if;
    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,'IsCheckedOut') = 'true') then
      updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);
      setContent(P_RESOURCE_PATH,P_CONTENT);
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
      -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);
    else
      DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);
      updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);
      setContent(P_RESOURCE_PATH,P_CONTENT);
      -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);
      V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
    end if;	         
    return;
  end if;
end;
--
procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
as
  V_ZIP_PARAMETERS    XMLtype;
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,'/',-1) -1);
  V_RESID             RAW(16);

  V_SAFE_TIMESTAMP    VARCHAR2(64)   := substr(to_char(SYSTIMESTAMP,'YYYY-MM-DD"T"HH24.MI.SS.FF'),1,23);
  V_LOGFILE_PATH      VARCHAR2(700)  := V_PARENT_FOLDER || '/ZIP-' || V_SAFE_TIMESTAMP || '.log';

begin
  select xmlElement
         (
           "Parameters",
           xmlElement("ZipFileName",P_RESOURCE_PATH),
           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),
           xmlElement("LogFileName",V_LOGFILE_PATH),
           P_RESOURCE_LIST,
           xmlElement("RecursiveOperation",'TRUE')
         )
    into V_ZIP_PARAMETERS 
    from DUAL;
    
  XDB_IMPORT_UTILITIES.zip(V_ZIP_PARAMETERS);
    
  if (not dbms_xdb.existsResource(P_RESOURCE_PATH)) then
    commit;
    raise_application_error( -20000 , 'Zip Operation Failed - See "' || V_LOGFILE_PATH || '" for details');
  end if;  
    
  if (P_DESCRIPTION is not NULL) then
    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_DESCRIPTION);
    DBMS_XDBRESOURCE.save(V_RESOURCE);
  end if;
  
end;
--
procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
begin
  XDB_IMPORT_UTILITIES.unzip(P_RESOURCE_PATH,P_FOLDER_PATH,NULL,P_DUPLICATE_POLICY);
end;
--
procedure createIndexPage(P_FOLDER_PATH VARCHAR2) 
as
  V_RESULT            BOOLEAN;
  V_INDEX_PATH        VARCHAR2(700) := P_FOLDER_PATH || '/index.html';
begin
  if (DBMS_XDB.existsResource(V_INDEX_PATH)) then
    DBMS_XDB.deleteResource(V_INDEX_PATH,DBMS_XDB.DELETE_FORCE);
  end if;
  V_RESULT := DBMS_XDB.createResource(V_INDEX_PATH,'<html/>');
  DBMS_RESCONFIG.ADDRESCONFIG(V_INDEX_PATH,XFILES_CONSTANTS.RESCONFIG_INDEX_PAGE);
end;
--
procedure MAPTABLETORESOURCE(P_RESOURCE_PATH VARCHAR2,P_SCHEMA_NAME VARCHAR2 DEFAULT USER,P_TABLE_NAME VARCHAR2, P_FILTER VARCHAR2 DEFAULT NULL)
as
  V_RESULT BOOLEAN;
  V_METADATA XMLTYPE;
begin
	if (NOT DBMS_XDB.existsResource(P_RESOURCE_PATH)) then
	  V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,XMLTYPE('<ContentUnavailable ' || XFILES_CONSTANTS.NSPREFIX_XFILES_RC_XRC || '/>'));
  end if;
  
  select XMLElement(
           "xrc:ContentDefinition",
           XMLAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES_RC as "xmlns:xrc"),
           XMLElement("xrc:DBURIType",
             XMLElement("xrc:Schema",P_SCHEMA_NAME),
             XMLElement("xrc:Table",P_TABLE_NAME),
             XMLElement("xrc:Filter",P_FILTER)
           )
         )
    into V_METADATA
    from DUAL;
    

  DBMS_RESCONFIG.addResConfig(P_RESOURCE_PATH,XFILES_CONSTANTS.RESCONFIG_RENDER_TABLE,null);

  DBMS_XDB.deleteResourceMetadata(P_RESOURCE_PATH,XFILES_CONSTANTS.NAMESPACE_XFILES_RC,'ContentDefinition');
  DBMS_XDB.appendResourceMetadata(P_RESOURCE_PATH,V_METADATA);
  
  DBMS_XDB.deleteResourceMetadata(P_RESOURCE_PATH,XFILES_CONSTANTS.NAMESPACE_XFILES,XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER);
    
  select XMLElement( 
           evalname(XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER),
           xmlAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns"),
           '/XFILES/lite/xsl/TableRenderer.xsl'
         )
      into V_METADATA
      from DUAL;

  DBMS_XDB.appendResourceMetadata(P_RESOURCE_PATH,V_METADATA);
end;
--
procedure ADDRESCONFIG(P_RESOURCE_PATH VARCHAR2, P_RESCONFIG_PATH VARCHAR2)
as
begin
	DBMS_RESCONFIG.addResConfig(P_RESOURCE_PATH,P_RESCONFIG_PATH);
end;
--
procedure ADDPAGEHITCOUNTER(P_RESOURCE_PATH VARCHAR2)
as
begin
	addResConfig(P_RESOURCE_PATH,XFILES_CONSTANTS.RESCONFIG_PAGE_COUNT);
end;
--
function UPDATEPROPERTIES(P_RESOURCE_PATH  VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)
return VARCHAR2
as
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_RESOURCE_DOCUMENT DBMS_XMLDOM.DOMDocument;
  V_UPDATE_DOCUMENT   DBMS_XMLDOM.DOMDocument;

  V_DISPLAY_NAME  VARCHAR2(128);

  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
  V_UPDATE_ELEMENT    DBMS_XMLDOM.DOMElement;

  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_SOURCE_NODE       DBMS_XMLDOM.DOMNode;
  V_TARGET_NODE       DBMS_XMLDOM.DOMNode;
  
  V_NODE_MAP          DBMS_XMLDOM.DOMNamedNodeMap;
  
  V_NODE_NAME         VARCHAR2(512);
  
  V_TARGET_FOLDER     VARCHAR2(1024); 
  V_LINK_NAME         VARCHAR2(256); 
  V_NEW_VALUE         VARCHAR2(1024);
  V_RESOURCE_PATH     VARCHAR2(1024) := P_RESOURCE_PATH;

begin  
  V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);
  V_RESOURCE_DOCUMENT := DBMS_XDBRESOURCE.makeDocument(V_RESOURCE);
  V_RESOURCE_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_RESOURCE_DOCUMENT);

  V_UPDATE_DOCUMENT   := DBMS_XMLDOM.newDOMDocument(P_NEW_VALUES);
  V_UPDATE_ELEMENT    := DBMS_XMLDOM.getDocumentElement(V_UPDATE_DOCUMENT);
  
  V_NODE_LIST := DBMS_XMLDOM.getChildNodes(dbms_xmldom.makeNode(V_UPDATE_ELEMENT));
  for i in 0..DBMS_XMLDOM.getLength(V_NODE_LIST) -1 loop
    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NODE_LIST,i);
    V_NODE_NAME := DBMS_XMLDOM.getNodeName(V_SOURCE_NODE);
    V_NEW_VALUE := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(V_SOURCE_NODE));
    if (V_NODE_NAME = 'DisplayName') then
      DBMS_XDBRESOURCE.setDisplayName(V_RESOURCE,V_NEW_VALUE);
      if (DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_SOURCE_NODE),'renameLinks') = 'true') then
        V_LINK_NAME := V_NEW_VALUE;
      end if;
    end if;
    if (V_NODE_NAME = 'Author') then
      DBMS_XDBRESOURCE.setAuthor(V_RESOURCE,V_NEW_VALUE);
    end if;
    if (V_NODE_NAME = 'Comment') then
      DBMS_XDBRESOURCE.setComment(V_RESOURCE,V_NEW_VALUE);
    end if;
    if (V_NODE_NAME = 'Language') then
      DBMS_XDBRESOURCE.setLanguage(V_RESOURCE,V_NEW_VALUE);
    end if;
    if (V_NODE_NAME = 'CharacterSet') then
      DBMS_XDBRESOURCE.setCharacterSet(V_RESOURCE,V_NEW_VALUE);
    end if;
  end loop;  
  
  DBMS_XDBRESOURCE.save(V_RESOURCE);
  
  if (V_LINK_NAME is not null) then
    V_TARGET_FOLDER := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,'/',-1)-1);
    if (V_TARGET_FOLDER is NULL) then
      V_TARGET_FOLDER := '/';
    end if;
    V_RESOURCE_PATH := V_TARGET_FOLDER || '/' || V_LINK_NAME;
    DBMS_XDB.renameResource(P_RESOURCE_PATH,V_TARGET_FOLDER,V_LINK_NAME);
  end if;
  
  return V_RESOURCE_PATH;
end;
--
procedure setCustomViewer(P_RESOURCE_PATH VARCHAR2,P_VIEWER_PATH VARCHAR2,P_METHOD VARCHAR2 DEFAULT NULL)
as
  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;
  V_METADATA          XMLTYPE;
begin

  DBMS_XDB.deleteResourceMetadata(P_RESOURCE_PATH,XFILES_CONSTANTS.NAMESPACE_XFILES,XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER);

  if (P_VIEWER_PATH is not NULL) then
    
    select XMLElement( 
  	         evalname(XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER),
             xmlAttributes(
    	         XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns",
       	       P_METHOD as "method"
         	   ),
           	 P_VIEWER_PATH
           )
      into V_METADATA
    	from DUAL;

    DBMS_XDB.appendResourceMetadata(P_RESOURCE_PATH,V_METADATA);

  end if;
end;
--
procedure getAclList(P_ACL_LIST OUT XMLType)
as
  V_ACL_REF_LIST XDB.XDB$XMLTYPE_REF_LIST_T;
begin
  select ref(a) 
    bulk collect into V_ACL_REF_LIST
    from XDB.XDB$ACL a;

  select xmlAgg(
           xmlElement("ACL",ANY_PATH) 
         )
    into P_ACL_LIST
    from RESOURCE_VIEW rv, 
         TABLE(V_ACL_REF_LIST) ar
   where XMLCast(
             XMLQuery(
              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
               fn:data($RES/Resource/XMLRef)'
               passing rv.RES as "RES"
               returning content
             ) as REF XMLType
           ) = value(ar);   
end;
--
procedure getPrivileges(P_RESOURCE_PATH IN VARCHAR2, P_PRIVILEGES IN OUT XMLTYPE) 
as
begin 
	P_PRIVILEGES := DBMS_XDB.getPrivileges(P_RESOURCE_PATH);
end;
--
procedure CACHERESULT(P_RESOURCE IN OUT XMLTYPE) 
as
  V_GUID RAW(16);
begin
	V_GUID := SYS_GUID();
	select insertChildXML(
	         P_RESOURCE,
	         '/r:Resource/xfiles:xfilesParameters',
	         'cacheGUID',
	         xmlElement("cacheGUID",
	           xmlAttributes(XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns"),
	           V_GUID
	         ),
	         DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R || ' ' || XFILES_CONSTANTS.NSPREFIX_XFILES_XFILES
	       )
	  into P_RESOURCE
	  from DUAL;
	insert into XFILES_RESULT_CACHE values (SYSTIMESTAMP,sys_context('USERENV', 'CURRENT_SCHEMA'),P_RESOURCE,V_GUID);
end;
--
begin
	NULL;
  $IF $$DEBUG $THEN
     XDB_OUTPUT.createLogFile('/public/XDB_REPOSITORY_SERVICES.log',FALSE);
     XDB_OUTPUT.writeLogFileEntry('Tracing initialized for XDB_REPOSITORY_SERVICES');
     XDB_OUTPUT.flushLogFile();
  $END
end;
/
--
show errors
--
