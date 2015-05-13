
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

procedure addChildToTree(P_PATH VARCHAR2, P_PARENT_FOLDER DBMS_XMLDOM.DOMElement)
as
  V_CHILD_FOLDER_NAME VARCHAR2(256);
  V_DESCENDANT_PATH   VARCHAR2(700);
  
  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_CHILD_FOLDER      DBMS_XMLDOM.DOMElement;

  V_CHILD_FOLDER_XML  XMLType;

begin
   
  dbms_output.put_line(P_PATH);
    
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
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.importNode(G_TREE_DOM, DBMS_XMLDOM.makeNode(V_CHILD_FOLDER), true));    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),DBMS_XMLDOM.makeNode(V_CHILD_FOLDER)));

  else
    --  Target is already in the tree. 
    
    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.item(V_NODE_LIST,0));

    if (V_DESCENDANT_PATH is NULL) then      
       -- We are at the bottom of the path, Make sure folder is shown as writeable
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'openIcon','/XFILES/lib/icons/writeFolderOpen.png');
       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,'closedIcon','/XFILES/lib/icons/writeFolderClosed.png');
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
               '/XFILES/lib/icons/readOnlyFolderOpen.png' as "openIcon",
               '/XFILES/lib/icons/readOnlyFolderClosed.png' as "closedIcon",
               'visible' as "children",
               '/XFILES/lib/icons/hideChildren.png' as "hideChildren",
               '/XFILES/lib/icons/showChildren.png' as "showChildren"
             )
           )
    into G_TREE
    from DUAL;

  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);

end;
--
function getLinkFolderTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
return XMLType
as
begin

  delete from XDBPM.TREE_STATE_TABLE 
   where SESSION_ID = P_SESSION_ID;

  initTree();
  addWriteableFolders();

  insert into XDBPM.TREE_STATE_TABLE values (P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
end;
--
function getAllFoldersTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
return XMLType
as
begin

  delete from XDBPM.TREE_STATE_TABLE 
   where SESSION_ID = P_SESSION_ID;

  initTree();
  addAllFolders();

  insert into XDBPM.TREE_STATE_TABLE values (P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
end;
--
procedure preserveTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_TREE_STATE XMLType)
as
begin
  update XDBPM.TREE_STATE_TABLE
     set TREE_STATE = P_TREE_STATE
   where SESSION_ID = P_SESSION_ID;
end;
--
procedure restoreTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
as
begin
  select TREE_STATE 
    into G_TREE
    from XDBPM.TREE_STATE_TABLE
   where SESSION_ID = P_SESSION_ID;

  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);
end;
--
function showChildren(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) 
return XMLType
as 
begin
  
  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);
   
  select updateXML
         (
           G_TREE,
           '//*[@id="' || P_ID || '"]/@children',
           'visible'
         )
    into G_TREE
    from dual;
  
  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);
  
  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
end;
--
function hideChildren(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) 
return XMLType
as 
begin


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

  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
end;
--
function makeOpen(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2)
return XMLType
as
  V_NODE DBMS_XMLDOM.DOMNode;
  V_PATH VARCHAR2(700);
begin

  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);

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
  
  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);

  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
end;
--
function makeClosed(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)
return XMLType
as
begin

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

  return G_TREE.transform(xdburitype('/XFILES/common/xsl/showTree.xsl').getXML());
