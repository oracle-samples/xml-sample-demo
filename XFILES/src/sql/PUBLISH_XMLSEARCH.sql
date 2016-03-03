
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
declare
  V_SOURCE_FOLDER varchar2(700) := XFILES_CONSTANTS.FOLDER_HOME || '/src/XMLSearch';
  V_TARGET_FOLDER varchar2(700) := XFILES_CONSTANTS.FOLDER_ROOT || '/XMLSearch';
  V_RESULT        boolean;
begin 
  if dbms_xdb.existsResource(V_TARGET_FOLDER) then
    dbms_xdb.deleteResource(V_TARGET_FOLDER,DBMS_XDB.DELETE_RECURSIVE_FORCE);
  end if;

  V_RESULT := dbms_xdb.createFolder(V_TARGET_FOLDER);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/xmlSchema.html',V_TARGET_FOLDER,'xmlSchema.html',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/xmlIndex.html',V_TARGET_FOLDER,'xmlIndex.html',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/reposSearch.html',V_TARGET_FOLDER,'reposSearch.html',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/resourceSearch.html',V_TARGET_FOLDER,'resourceSearch.html',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/js',V_TARGET_FOLDER,'js',DBMS_XDB.LINK_TYPE_WEAK);
  dbms_xdb.link(V_SOURCE_FOLDER ||'/xsl',V_TARGET_FOLDER,'xsl',DBMS_XDB.LINK_TYPE_WEAK);

end;
/
--
-- Create and Publish XMLSCHEMA List document
--
declare
  XMLREF REF xmlType;
  result boolean;
  filename          varchar2(256) := 'xmlSchemaList.xml';
  folder            varchar2(256) := 'xmlSchema';
  publicDirectory   varchar2(256) := XFILES_CONSTANTS.FOLDER_ROOT || '/XMLSearch';
  publicLink        varchar2(256) := publicDirectory  || '/' || folder;
  privateDirectory  varchar2(256) := XFILES_CONSTANTS.FOLDER_HOME || '/configuration/' || folder;
  privateLink       varchar2(256) := privateDirectory || '/' || filename;
begin
  select ref(x) 
    into xmlref
    from XMLSCHEMA_LIST x;
  xdb_utilities.mkdir(privateDirectory,TRUE);
  if (dbms_xdb.existsResource(publicLink)) then
    dbms_xdb.deleteResource(publicLink,DBMS_XDB.DELETE_FORCE);
  end if;
  if (dbms_xdb.existsResource(privateLink)) then
    dbms_xdb.deleteResource(privateLink,DBMS_XDB.DELETE_FORCE);
  end if;
  result :=  dbms_xdb.createResource(privateLink,xmlref,false);
  dbms_xdb.link(privateDirectory,publicDirectory,folder,DBMS_XDB.LINK_TYPE_WEAK);
end;
/
--
-- Create and Publish XMLSCHEMA_OBJECT List document
--
declare
  XMLREF REF xmlType;
  result boolean;
  filename          varchar2(256) := 'xmlSchemaObjectList.xml';
  folder            varchar2(256) := 'xmlSchema';
  publicDirectory   varchar2(256) := XFILES_CONSTANTS.FOLDER_ROOT || '/XMLSearch';
  publicLink        varchar2(256) := publicDirectory  || '/' || folder;
  privateDirectory  varchar2(256) := XFILES_CONSTANTS.FOLDER_HOME || '/configuration/' || folder;
  privateLink       varchar2(256) := privateDirectory || '/' || filename;
begin
  select ref(x) 
    into xmlref
    from XMLSCHEMA_OBJECT_LIST x;
  xdb_utilities.mkdir(privateDirectory,TRUE);
  if (dbms_xdb.existsResource(publicLink)) then
    dbms_xdb.deleteResource(publicLink,DBMS_XDB.DELETE_FORCE);
  end if;
  if (dbms_xdb.existsResource(privateLink)) then
    dbms_xdb.deleteResource(privateLink,DBMS_XDB.DELETE_FORCE);
  end if;
  result :=  dbms_xdb.createResource(privateLink,xmlref,false);
  dbms_xdb.link(privateDirectory,publicDirectory,folder,DBMS_XDB.LINK_TYPE_WEAK);
end;
/
--
-- Create and Publish XMLINDEX List document
--
declare
  XMLREF REF xmlType;
  result  boolean;
  filename          varchar2(256) := 'xmlIndexList.xml';
  folder            varchar2(256) := 'xmlIndex';
  publicDirectory   varchar2(256) := XFILES_CONSTANTS.FOLDER_ROOT || '/XMLSearch';
  publicLink        varchar2(256) := publicDirectory  || '/' || folder;
  privateDirectory  varchar2(256) := XFILES_CONSTANTS.FOLDER_HOME || '/configuration/' || folder;
  privateLink       varchar2(256) := privateDirectory || '/' || filename;
begin
  select ref(x) 
    into xmlref
    from XFILES.XMLINDEX_LIST x;
  xdb_utilities.mkdir(privateDirectory,TRUE);
  if (dbms_xdb.existsResource(publicLink)) then
    dbms_xdb.deleteResource(publicLink,DBMS_XDB.DELETE_FORCE);
  end if;
  if (dbms_xdb.existsResource(privateLink)) then
    dbms_xdb.deleteResource(privateLink,DBMS_XDB.DELETE_FORCE);
  end if;
  result := dbms_xdb.createResource(privateLink,xmlref,false);
  dbms_xdb.link(privateDirectory,publicDirectory,folder,dbms_xdb.LINK_TYPE_WEAK);
end;
/
--
