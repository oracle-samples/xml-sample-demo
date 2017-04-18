
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
-- XDBPM_UTILITIES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace type RESOURCE_ID_TABLE
as table of RAW(16)
/
grant execute on RESOURCE_ID_TABLE to public
/
create or replace public synonym RESOURCE_ID_TABLE for RESOURCE_ID_TABLE
/
create or replace package XDBPM_UTILITIES
authid CURRENT_USER
as
  DEFAULT_FILENAME    constant varchar2(2000) := 'ls.xml';
  DEFAULT_DIRECTORY   constant varchar2(32)   := USER;
  DEFAULT_BATCH_SIZE  constant number(10)     := 1;
   
/*
**
** Deprecated in XDB_UTILITIES. Moved to XDB_XMLSCHEMA_UTILITIES
**
** procedure renameCollectionTable (XMLTABLE varchar2, XPATH varchar2, COLLECTION_TABLE_PREFIX varchar2);
** function printNestedTables(XML_TABLE varchar2) return XMLType;
** function getDefaultTableName(P_RESOURCE_PATH VARCHAR2) return VARCHAR2;
**
*/

  function getBinaryContent(P_FILE bfile) return BLOB;
  function getBinaryContent(P_FILENAME varchar2, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY) return BLOB;
  function getBinaryContent(P_FILE bfile, P_CONTENT IN OUT BLOB) return BLOB;
  function getBinaryContent(P_FILENAME varchar2, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_CONTENT IN OUT BLOB) return BLOB;

  function getFileContent(P_FILE bfile, P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT) return CLOB;
  function getFileContent(P_FILENAME varchar2, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT) return CLOB;
  function getFileContent(P_FILE bfile, P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT, P_CONTENT IN OUT CLOB) return CLOB;
  function getFileContent(P_FILENAME varchar2, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT, P_CONTENT IN OUT CLOB) return CLOB;
  
  procedure mkdir(P_FOLDER_PATH varchar2,force varchar2 default 'FALSE');
  procedure mkdir(P_FOLDER_PATH varchar2,force boolean  default FALSE);
  procedure rmdir(P_FOLDER_PATH varchar2,force varchar2 default 'FALSE');
  procedure rmdir(P_FOLDER_PATH varchar2,force boolean  default FALSE);
   
  procedure uploadFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE);
  procedure uploadBinaryFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE);
  procedure uploadTextFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE);
  procedure uploadXMLFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE);
  procedure uploadToXMLTable(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, TABLE_NAME varchar2, P_BATCH_SIZE number default DEFAULT_BATCH_SIZE);

  procedure updateXMLContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT XMLType);
  procedure updateBinaryContent(P_RESOURCE_PATH VARCHAR2,P_CONTENT BLOB);
  procedure updateCharacterContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT VARCHAR2, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT);
  procedure updateCharacterContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB,     P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT);
   
  procedure createHomeFolder;
  procedure createPublicFolder;
  procedure setPublicIndexPageContent;

  function getXMLReference(P_RESOURCE_PATH VARCHAR2) return REF XMLType;
  function getXMLReferenceByResID(P_RESOID RAW) return REF XMLType;
  function isCheckedOutByRESID(P_RESOID RAW) return BOOLEAN;
  function getVersionsByPath(P_RESOURCE_PATH VARCHAR2) return RESOURCE_ID_TABLE pipelined;
  function getVersionsByResid(RESID RAW) return RESOURCE_ID_TABLE pipelined;

  function IS_VERSIONED(P_RESOURCE DBMS_XMLDOM.DOMDocument) return BOOLEAN;
  function IS_VERSIONED(P_RESOURCE XMLTYPE) return BOOLEAN;
  function IS_VERSIONED(P_RESOURCE_PATH VARCHAR2) return BOOLEAN;

  procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_BLOB_CHARSET VARCHAR2 DEFAULT 'AL32UTF8');
  procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB);
  procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT XMLTYPE);

  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_BLOB_CHARSET VARCHAR2 DEFAULT 'AL32UTF8', P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);
  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT XMLTYPE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR);

  procedure printXMLToFile(P_XML_CONTENT XMLType, P_TARGET_DIRECTORY varchar2, P_FILENAME VARCHAR2);
  function READ_LINES(P_RESOURCE_PATH VARCHAR2) return XDB.XDB$STRING_LIST_T pipelined;


$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN

   -- Depricated Post 10.2.x : Provided by DBMS_XDB

  procedure changeOwner(resourcePath varchar2, owner varchar2, recursive boolean default false);

$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  function IS_VERSIONED(P_RESOURCE DBMS_XDBRESOURCE.XDBResource) return BOOLEAN;
  function migrateACL(ACL XMLTYPE) return XMLTYPE;
  function migrateACLResource(resourceXML XMLTYPE) return XMLTYPE;  
$ELSE   -- Starting 11.2.x

  function IS_VERSIONED(P_RESOURCE DBMS_XDBRESOURCE.XDBResource) return BOOLEAN;
  function migrateACL(ACL XMLTYPE) return XMLTYPE;
  function migrateACLResource(resourceXML XMLTYPE) return XMLTYPE;
  
  function serializeResource(xdbResource DBMS_XDBRESOURCE.XDBResource) return xmltype;
  function serializeEvent(repositoryEvent DBMS_XEVENT.XDBRepositoryEvent) return xmltype;
  
  procedure freeResConfig(P_RESCONFIG_PATH VARCHAR2);
  
  procedure appendContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT VARCHAR2, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT);
  procedure appendContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB,     P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT);
  procedure freeAcl(P_TARGET_ACL VARCHAR2,P_REPLACEMENT_ACL VARCHAR2);
$END
--
end XDBPM_UTILITIES;
/
show errors
--
create or replace synonym XDB_UTILITIES for XDBPM_UTILITIES 
/
grant execute on XDBPM_UTILITIES to public
/
create or replace package body XDBPM_UTILITIES
as
   LOAD_ANY_RESOURCE    constant number(2) := 0;
   LOAD_BINARY_RESOURCE constant number(2) := 1;
   LOAD_CLOB_RESOURCE   constant number(2) := 2;
   LOAD_XML_RESOURCE    constant number(2) := 3;
   LOAD_XML_TABLE       constant number(2) := 5;
--
-- When using getBinaryContent() or getFileContent() the application must explicitly free the CLOB/BLOB that the function returns
--
   
   MIGRATE_ACL_10200_TO_11100 xmlType := XMLTYPE(
'<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ACL="http://xmlns.oracle.com/xdb/acl.xsd">
	<xsl:output indent="yes" encoding="utf-8"/>
	<xsl:template match="@*|node()">
		<xsl:choose>
			<xsl:when test="((name()=''ace'') and (namespace-uri()=''http://xmlns.oracle.com/xdb/acl.xsd''))">
				<xsl:element name="ACL:ace">
					<xsl:copy-of select="ACL:grant"/>
					<xsl:copy-of select="ACL:principal"/>
					<xsl:copy-of select="ACL:privilege"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>');
--
-- Depricated on XDB_UTILITIES
--
procedure renameCollectionTable (XMLTABLE varchar2, XPATH varchar2, COLLECTION_TABLE_PREFIX varchar2)
as
begin
  XDB_XMLSCHEMA_UTILITIES.renameCollectionTable(XMLTABLE,XPATH,COLLECTION_TABLE_PREFIX);
end;
--
function printNestedTables(XML_TABLE varchar2) return XMLType
as
begin
  return XDB_XMLSCHEMA_UTILITIES.printNestedTables(XML_TABLE);
end;
--
function getDefaultTableName(P_RESOURCE_PATH VARCHAR2) return VARCHAR2
as
begin
	return XDB_XMLSCHEMA_UTILITIES.getDefaultTableName(P_RESOURCE_PATH);
end;
--
-- End deprecated methods
--
function getBinaryContent(P_FILE bfile,
		          P_CONTENT IN OUT BLOB)
return BLOB
is
  targetFile      bfile;

  dest_offset     number :=  1;
  src_offset      number := 1;
  lang_context    number := 0;
  conv_warning    number := 0;
  begin
    targetFile := P_FILE;
    if (P_CONTENT is null) then
      DBMS_LOB.createTemporary(P_CONTENT,true,DBMS_LOB.SESSION);
    else 
      DBMS_LOB.trim(P_CONTENT,0);
    end if;
    DBMS_LOB.fileopen(targetFile, DBMS_LOB.file_readonly);
    DBMS_LOB.loadBlobfromFile(
       P_CONTENT,
       targetFile,
       DBMS_LOB.getLength(targetFile),
       dest_offset,
       src_offset
    );
    DBMS_LOB.fileclose(targetFile);
    return P_CONTENT;
end;
--
function getBinaryContent(P_FILE bfile)
return BLOB
is
  P_CONTENT BLOB := NULL;
begin
  return getBinaryContent(P_FILE,P_CONTENT);
end;
--
function getBinaryContent(P_FILENAME varchar2,
                          P_DIRECTORY varchar2 default DEFAULT_DIRECTORY,
		          P_CONTENT IN OUT BLOB)
return BLOB
is
   V_FILE            bfile := bfilename(P_DIRECTORY,P_FILENAME);
begin
  return getBinaryContent(V_FILE,P_CONTENT);
end;
--
function getBinaryContent(P_FILENAME varchar2,
                          P_DIRECTORY varchar2 default DEFAULT_DIRECTORY)		      
return BLOB
is
   P_CONTENT BLOB := NULL;
begin
  return getBinaryContent(P_FILENAME,P_DIRECTORY,P_CONTENT);
end;
--
function getFileContent(P_FILE bfile,
		        P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT,
		        P_CONTENT IN OUT CLOB)
return CLOB
is
  targetFile      bfile;

  dest_offset     number :=  1;
  src_offset      number := 1;
  lang_context    number := 0;
  conv_warning    number := 0;
  begin
    targetFile := P_FILE;
    if (P_CONTENT is null) then
      DBMS_LOB.createTemporary(P_CONTENT,true,DBMS_LOB.SESSION);
    else 
      DBMS_LOB.trim(P_CONTENT,0);
    end if;
    DBMS_LOB.fileopen(targetFile, DBMS_LOB.file_readonly);
    DBMS_LOB.loadClobfromFile(
       P_CONTENT,
       targetFile,
       DBMS_LOB.getLength(targetFile),
       dest_offset,
       src_offset,
       nls_charset_id(P_CHARSET),
       lang_context,
       conv_warning
    );
    DBMS_LOB.fileclose(targetFile);
    return P_CONTENT;
end;
--
function getFileContent(P_FILE bfile,
		        P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT )
return CLOB
is
  P_CONTENT CLOB := NULL;
begin
  return getFileContent(P_FILE,P_CHARSET,P_CONTENT);
end;
--
-- When using getFileContent() the application must explicitly free the CLOB that the function returns
--
function getFileContent(P_FILENAME varchar2,
                        P_DIRECTORY varchar2 default DEFAULT_DIRECTORY,
		        P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT,
		        P_CONTENT IN OUT CLOB)
return CLOB
is
   V_FILE            bfile := bfilename(P_DIRECTORY,P_FILENAME);
begin
  return getFileContent(V_FILE,P_CHARSET,P_CONTENT);
end;
--
function getFileContent(P_FILENAME varchar2,
                        P_DIRECTORY varchar2 default DEFAULT_DIRECTORY,
		        P_CHARSET varchar2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT)		      
return CLOB
is
   V_CONTENT CLOB := NULL;
begin
  return getFileContent(P_FILENAME,P_DIRECTORY,P_CHARSET,V_CONTENT);
end;
--
procedure makeFolders(P_TARGET_FOLDER varchar2,P_FILELIST XMLType)
as
  cursor getFolderList(P_FILELIST XMLType) is
  select *
    from ( 
            select extractValue(value(f),'/directory/text()') FOLDERPATH
              from table(xmlsequence(extract(P_FILELIST,'//directory'))) f
         );
begin
  for f in getFolderList(P_FILELIST) loop
    mkdir(P_TARGET_FOLDER || f.FOLDERPATH, TRUE);
  end loop;
end;
--
procedure uploadFileContent(OPERATION NUMBER, P_DIRECTORY VARCHAR2, P_FILELIST VARCHAR2, TARGET VARCHAR2, P_BATCH_SIZE NUMBER)
as
  file_not_found1 exception;
  PRAGMA EXCEPTION_INIT( file_not_found1 , -22288 );

  file_not_found2 exception;
  PRAGMA EXCEPTION_INIT( file_not_found2 , -22285 );

  cursor getFileList(P_FILELIST XMLType) is
  select *
    from ( 
            select extractValue(value(f),'/file/text()')    FILENAME,
                   nvl(extractValue(value(f),'/file/@replace'),'FALSE')  REPLACE,
                   extractValue(value(f),'/file/@encoding') ENCODING,
                   nvl(extractValue(value(f),'/file/@binary'),'FALSE')   BINARY
              from table(xmlsequence(extract(P_FILELIST,'//file'))) f
         );
   
  REPLACE_MODE boolean;
  BINARY_MODE  boolean;
  XML_MODE     boolean;
  
  REPLACE_FILE boolean;

  FILELIST_CONTENT XMLTYPE;

  FILE_ENCODING varchar2(32) := DBMS_XDB_CONSTANTS.ENCODING_DEFAULT;
  
  CLOB_CONTENT CLOB;
  BLOB_CONTENT BLOB;
  XML_CONTENT  XMLType;
  
  TARGET_RESOURCE VARCHAR2(2000);
  RES             BOOLEAN;
  STATEMENT       VARCHAR2(2000);
  FILECOUNT       pls_integer := 0;
begin
  FILELIST_CONTENT := XMLType(bfilename(P_DIRECTORY,P_FILELIST),nls_charset_id(DBMS_XDB_CONSTANTS.ENCODING_DEFAULT));

  if (OPERATION != LOAD_XML_TABLE) then
    makeFolders(TARGET,FILELIST_CONTENT);
  end if;

  REPLACE_MODE := FILELIST_CONTENT.existsNode('/Upload/files[@replace="true"]') = 1;
  BINARY_MODE := FILELIST_CONTENT.existsNode('/Upload/files[@binary="true"]') = 1;
  XML_MODE := FILELIST_CONTENT.existsNode('/Upload/files[@xml="true"]') = 1;
  
  for f in getFileList(FILELIST_CONTENT) loop
    
    TARGET_RESOURCE := TARGET || F.FILENAME;
      
    if (F.ENCODING is not null) then
      FILE_ENCODING := F.ENCODING;
    else 
      FILE_ENCODING := DBMS_XDB_CONSTANTS.ENCODING_DEFAULT;
    end if;

    begin
          
      if (OPERATION != LOAD_XML_TABLE) then
        REPLACE_FILE    := (REPLACE_MODE and (f.REPLACE <> 'false')) or (f.REPLACE = 'true');
        if (REPLACE_FILE and DBMS_XDB.existsResource(TARGET_RESOURCE)) then
          DBMS_XDB.deleteResource(TARGET_RESOURCE);
        end if;
 
        if (OPERATION = LOAD_ANY_RESOURCE or OPERATION = LOAD_BINARY_RESOURCE) then
          res := DBMS_XDB.createResource(TARGET_RESOURCE,bfilename(P_DIRECTORY,F.FILENAME));
        end if;
       
        if (OPERATION = LOAD_CLOB_RESOURCE) then 
           res := DBMS_XDB.createResource(TARGET_RESOURCE,bfilename(P_DIRECTORY,F.FILENAME),NLS_CHARSET_ID(FILE_ENCODING));
        end if;

        if (OPERATION = LOAD_XML_RESOURCE) then
          res := DBMS_XDB.createResource(TARGET_RESOURCE,xmltype(bfilename(P_DIRECTORY,F.FILENAME),nls_charset_id(FILE_ENCODING)));
        end if;
        
      else
        STATEMENT := ' insert into "' || TARGET || '" values ( xmltype ( bfilename(:1,:2), NLS_CHARSET_ID(:3) ) )';
        EXECUTE IMMEDIATE STATEMENT USING P_DIRECTORY, F.FILENAME, FILE_ENCODING;
      end if;
      
      filecount := filecount + 1;
 
      if (filecount = P_BATCH_SIZE) then
        filecount := 0;
        commit;
      end if;

    exception    
      when FILE_NOT_FOUND1 then 
        XDB_OUTPUT.createLogFile(TARGET || P_FILELIST || '.log',FALSE);
        XDB_OUTPUT.writeLogFileEntry('Error opening ' || F.FILENAME);
        XDB_OUTPUT.logException();
        XDB_OUTPUT.flushLogFile();
      when FILE_NOT_FOUND2 then 
        XDB_OUTPUT.createLogFile(TARGET || P_FILELIST || '.log',FALSE);
        XDB_OUTPUT.writeLogFileEntry('Error opening ' || F.FILENAME);
        XDB_OUTPUT.logException();
        XDB_OUTPUT.flushLogFile();
      when others then
        XDB_OUTPUT.createLogFile(TARGET || P_FILELIST || '.log',FALSE);
        XDB_OUTPUT.writeLogFileEntry('Error processing ' || F.FILENAME);
        XDB_OUTPUT.logException();
        XDB_OUTPUT.flushLogFile();
    end;
 
  end loop;
  
end;
--
procedure uploadBinaryFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE)
as
begin
  uploadFileContent(LOAD_BINARY_RESOURCE,P_DIRECTORY,P_FILELIST,P_TARGET_FOLDER,P_BATCH_SIZE);
end;
--
procedure uploadTextFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE)
as
begin
  uploadFileContent(LOAD_CLOB_RESOURCE,P_DIRECTORY,P_FILELIST,P_TARGET_FOLDER,P_BATCH_SIZE);
end;
--
procedure uploadXMLFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE)
as
begin
  uploadFileContent(LOAD_XML_RESOURCE,P_DIRECTORY,P_FILELIST,P_TARGET_FOLDER,P_BATCH_SIZE);
end;
--
procedure uploadToXMLTable(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, TABLE_NAME varchar2, P_BATCH_SIZE number default DEFAULT_BATCH_SIZE)
as
begin
  uploadFileContent(LOAD_XML_TABLE,P_DIRECTORY, P_FILELIST, TABLE_NAME, P_BATCH_SIZE);
end;
--
-- Legacy Method.
--
procedure uploadFiles(P_FILELIST varchar2 default DEFAULT_FILENAME, P_DIRECTORY varchar2 default DEFAULT_DIRECTORY, P_TARGET_FOLDER varchar2 default XDB_CONSTANTS.FOLDER_USER_HOME , P_BATCH_SIZE number default DEFAULT_BATCH_SIZE)
as
begin
  uploadFileContent(LOAD_ANY_RESOURCE,P_DIRECTORY,P_FILELIST,P_TARGET_FOLDER,P_BATCH_SIZE);
end;
--
procedure createFolderTree(P_FOLDER_PATH varchar2)
as
  pathSeperator varchar2(1) := '/';
  parentFolderPath varchar2(256);
  result boolean;
begin
  if (not DBMS_XDB.existsResource(P_FOLDER_PATH)) then
    if instr(P_FOLDER_PATH,pathSeperator,-1) > 1 then
      parentFolderPath := substr(P_FOLDER_PATH,1,instr(P_FOLDER_PATH,pathSeperator,-1)-1);    
      createFolderTree(parentFolderPath);
    end if;
    result := DBMS_XDB.createFolder(P_FOLDER_PATH);
  end if;
end;
--
procedure mkdir(P_FOLDER_PATH varchar2,force boolean default false)
as
  res boolean;
begin
  if (not DBMS_XDB.existsResource(P_FOLDER_PATH)) then
    if (force) then
      createFolderTree(P_FOLDER_PATH);
    else
      res := DBMS_XDB.createFolder(P_FOLDER_PATH);
    end if;
  end if;
end;
--
procedure mkdir(P_FOLDER_PATH varchar2,force varchar2 default 'FALSE')
as
  f boolean;
begin
  mkdir(P_FOLDER_PATH,upper(force) = 'TRUE');
end;
--
procedure deleteFolderTree(P_FOLDER_PATH varchar2)
as
  cursor getSubFolders is
  select path, extractValue(res,'/Resource/RefCount') REFCOUNT
    from path_view
   where under_path(res,1,P_FOLDER_PATH) = 1;

begin
  delete 
    from path_view
   where under_path(res,1,P_FOLDER_PATH) = 1
     and existsNode(res,'/Resource[@Container = "false"]') = 1;
   
   -- At this point only subFolders should remain.
   -- Delete Recursively where REFCOUNT is 1 and remove Link where REFCOUNT > 1
   
   for folder in getSubFolders loop
     if (folder.REFCOUNT = 1 ) then
       deleteFolderTree(folder.path);
     else
       DBMS_XDB.deleteResource(folder.path);
     end if;
   end loop;

   DBMS_XDB.deleteResource(P_FOLDER_PATH);
end;
--
procedure rmdir(P_FOLDER_PATH varchar2,force boolean default FALSE)
as
begin
  if (force) then
    deleteFolderTree(P_FOLDER_PATH);
  else
    DBMS_XDB.deleteResource(P_FOLDER_PATH);
  end if;
end;
--
procedure rmdir(P_FOLDER_PATH varchar2,force varchar2 default 'FALSE')
as
begin
  rmdir(P_FOLDER_PATH,upper(force) = 'TRUE');
end;
--
procedure cloneXMLContent(P_RESOURCE_PATH varchar2)
as
begin
  update resource_view
     set res = updateXML(res,'/Resource/DisplayName',extract(res,'/Resource/DisplayName'))
   where equals_path(res, P_RESOURCE_PATH) = 1;
end; 
-- 
procedure updateXMLContent(P_RESOURCE_PATH varchar2, P_CONTENT xmltype)
as
   defaultTableName varchar2(32);
   sqlStatement varchar2(1000);
begin
   defaultTableName := XDB_XMLSCHEMA_UTILITIES.getDefaultTableName(P_RESOURCE_PATH);
   cloneXMLContent(P_RESOURCE_PATH);
   sqlStatement := 'update "' || defaultTableName || '" d set object_value = :1 where ref(d) = xdb_utilities.getXMLReference(:2)';
   execute immediate sqlStatement using P_CONTENT , P_RESOURCE_PATH;
end;
--
procedure updateBinaryContent(P_RESOURCE_PATH VARCHAR2,P_CONTENT BLOB)
is 
  xmllob BLOB;
begin
  update RESOURCE_VIEW
     set res = updateXML(res,'/Resource/DisplayName/text()',extractValue(res,'/Resource/DisplayName/text()'))
   where equals_path(res,P_RESOURCE_PATH) = 1;
  select extractValue(res,'/Resource/XMLLob') 
    into xmllob
    from RESOURCE_VIEW 
   where equals_path(res,P_RESOURCE_PATH) = 1;
  dbms_lob.open(xmllob,dbms_lob.lob_readwrite);
  dbms_lob.trim(xmllob,0);
  dbms_lob.copy(xmllob,P_CONTENT,dbms_lob.getLength(P_CONTENT),1,1);
  dbms_lob.close(xmllob);
end;
--
procedure updateCharacterContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT)
is 
  xmllob        BLOB;
  source_offset integer := 1;
  target_offset integer := 1;
  warning       integer;
  lang_context  integer := 0;
begin
  update RESOURCE_VIEW
     set res = updateXML(res,'/Resource/DisplayName/text()',extractValue(res,'/Resource/DisplayName/text()'))
   where equals_path(res,P_RESOURCE_PATH) = 1;
  select extractValue(res,'/Resource/XMLLob') 
    into xmllob
    from RESOURCE_VIEW 
   where equals_path(res,P_RESOURCE_PATH) = 1;
  dbms_lob.open(xmllob,dbms_lob.lob_readwrite);
  dbms_lob.trim(xmllob,0);
  dbms_lob.convertToBlob(xmllob,P_CONTENT,dbms_lob.getLength(P_CONTENT),source_offset,target_offset,nls_charset_id(P_DB_CHARSET),lang_context,warning);
  dbms_lob.close(xmllob);
end;
--
procedure updateCharacterContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT VARCHAR2, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT)
as
  V_CLOB_CONTENT CLOB := P_CONTENT;
begin
	updateCharacterContent(P_RESOURCE_PATH, V_CLOB_CONTENT, P_DB_CHARSET);
	DBMS_LOB.freeTemporary(V_CLOB_CONTENT);
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
procedure appendContent(P_RESOURCE_PATH VARCHAR2,P_CONTENT CLOB, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT)
as
  V_NEW_CONTENT BLOB;
  V_CURRENT_CONTENT BLOB;

  V_SOURCE_OFFSET NUMBER := 1;
  V_DEST_OFFSET NUMBER :=1;
  V_LANG_CTX NUMBER := 0;
  V_WARNING NUMBER := 0;
begin
  update RESOURCE_VIEW
     set res = updateXML(res,'/Resource/DisplayName/text()',extractValue(res,'/Resource/DisplayName/text()'))
   where equals_path(res,P_RESOURCE_PATH) = 1;
	/*
	update RESOURCE_VIEW
     set res = XMLQUERY(
                'declare namespace r = "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                 copy $NEWRES := $RES modify (
                                        let $DN := $NEWRES/r:Resource/r:DisplayName
                                        return replace value of node $DN with $RES/r:Resource/r:DisplayName/text()
                                      )
                 return $NEWRES'
                 passing RES as "RES"
                 returning content
               )
   where equals_path(res,P_RESOURCE_PATH) = 1;
  */
                
  select XMLCAST(
           XMLQUERY(
            'declare namespace r="http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
             /r:Resource/r:XMLLob'
             passing RES
             returning CONTENT
           )
           as BLOB
        ) CONTENT
    into V_CURRENT_CONTENT
    from RESOURCE_VIEW
  where equals_path(RES,P_RESOURCE_PATH) = 1
    for update;
      
  DBMS_LOB.createTemporary(V_NEW_CONTENT,FALSE);
  DBMS_LOB.convertToBlob(V_NEW_CONTENT,P_CONTENT,LENGTH(P_CONTENT),V_SOURCE_OFFSET,V_DEST_OFFSET,NLS_CHARSET_ID(P_DB_CHARSET),V_LANG_CTX,V_WARNING);
  DBMS_LOB.open(V_CURRENT_CONTENT,DBMS_LOB.lob_readwrite);
  DBMS_LOB.append(V_CURRENT_CONTENT,V_NEW_CONTENT);
  DBMS_LOB.close(V_CURRENT_CONTENT);
  DBMS_LOB.freeTemporary(V_NEW_CONTENT);
end;
--
$END
--
procedure appendContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT VARCHAR2, P_DB_CHARSET VARCHAR2 default DBMS_XDB_CONSTANTS.ENCODING_DEFAULT)
as
  V_CLOB_CONTENT CLOB := P_CONTENT;
begin
	appendContent(P_RESOURCE_PATH, V_CLOB_CONTENT, P_DB_CHARSET);
	DBMS_LOB.freeTemporary(V_CLOB_CONTENT);
end;
--
function getXMLReferenceByResID(P_RESOID RAW)
return REF XMLType
as
begin
  return XDB_HELPER.getXMLReferenceByResID(P_RESOID);
end;
--
function getXMLReference(P_RESOURCE_PATH varchar2)
return REF XMLType
as
begin
  return XDB_HELPER.getXMLReference(P_RESOURCE_PATH);
end;
--
function isCheckedOutbyRESID(P_RESOID RAW)
return BOOLEAN
as 
begin
  return XDB_HELPER.isCheckedOutByRESID(P_RESOID);
end;
--
procedure createHomeFolder
as
begin
  XDBPM_UTILITIES_INTERNAL.createHomeFolder(XDB_USERNAME.GET_USERNAME());
end;
--
procedure createPublicFolder
as
begin
  XDBPM_UTILITIES_INTERNAL.createPublicFolder(XDB_USERNAME.GET_USERNAME());
end;
--
function getVersionsByPath(P_RESOURCE_PATH VARCHAR2)
return RESOURCE_ID_TABLE pipelined
as
  RESOURCE_ID raw(16);
  SOURCE_LIST DBMS_XDB_VERSION.RESID_LIST_TYPE;
begin
  select resid 
    into RESOURCE_ID
    from resource_view
   where equals_path(res,P_RESOURCE_PATH) = 1;
  pipe row (RESOURCE_ID);
  SOURCE_LIST := DBMS_XDB_VERSION.GETPREDECESSORS(P_RESOURCE_PATH); 
  while SOURCE_LIST.COUNT > 0 loop
    pipe row (SOURCE_LIST(1));
    SOURCE_LIST := DBMS_XDB_VERSION.GETPREDSBYRESID(SOURCE_LIST(1));
  end loop;
  return;
end;
--
function getVersionsByResid(RESID RAW)
return RESOURCE_ID_TABLE pipelined
as
  SOURCE_LIST DBMS_XDB_VERSION.RESID_LIST_TYPE;
begin
  pipe row (RESID);
  SOURCE_LIST := DBMS_XDB_VERSION.GETPREDSBYRESID(RESID); 
  while SOURCE_LIST.COUNT > 0 loop
    pipe row (SOURCE_LIST(1));
    SOURCE_LIST := DBMS_XDB_VERSION.GETPREDSBYRESID(SOURCE_LIST(1));
  end loop;
  return;
end;
--
procedure printXMLToFile(P_XML_CONTENT XMLType, P_TARGET_DIRECTORY varchar2, P_FILENAME VARCHAR2)
is
   fHandle utl_file.File_Type;
   
   xmlText CLOB := P_XML_CONTENT.getClobVal();
   xmlTextCopy CLOB;
   xmlTextSize binary_integer := dbms_lob.getLength(xmlText) + 1;

   offset    binary_integer := 1;
   buffer    varchar2(32767);
   linesize  binary_integer := 32767;
   byteCount binary_integer; 
   lob1 clob;
begin
   dbms_lob.createtemporary(xmlTextCopy,TRUE);
   dbms_lob.copy(xmlTextCopy, xmlText, xmlTextSize);
   fhandle  := utl_file.fopen(P_TARGET_DIRECTORY,P_FILENAME,'w',linesize);

   while (offset < xmlTextSize)  loop
     if (xmlTextSize - offset > linesize) then
       byteCount := linesize;
     else
       byteCount := xmlTextSize - offset;
     end if;
     dbms_lob.read(xmlTextCopy, byteCount, offset, buffer);
     offset := offset + byteCount;
     utl_file.put(fHandle, buffer);
     utl_file.fflush(fHandle);
   end loop;
   utl_file.new_line(fhandle);
   utl_file.fclose(fhandle);
   dbms_lob.freeTemporary(xmlTextCopy);
end;
--
procedure setPublicIndexPageContent
as
begin
  XDBPM_UTILITIES_INTERNAL.setPublicIndexPageContent(XDB_USERNAME.GET_USERNAME());
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
--
procedure changeOwner(resourcePath varchar2, owner varchar2, recursive boolean default false)
as
  cursor recursiveOperation is
    select path 
      from path_view 
     where under_path(res,resourcePath) = 1;
begin
  update resource_view
     set res = updateXml(res,'/Resource/Owner/text()',owner)
  where equals_path(res,resourcePath) = 1;
  
  if (recursive) then
    for res in recursiveOperation loop
     update resource_view
        set res = updateXml(res,'/Resource/Owner/text()',owner)
      where equals_path(res,res.path) = 1;
    end loop;
  end if;
end;
--
$ELSE
--
function migrateACL(ACL XMLTYPE)
return XMLTYPE
as
  newACL         XMLTYPE;
begin 
  newACL := ACL;
  if (newACL.isSchemaValid() = 0) then
    newACL := newACL.TRANSFORM(MIGRATE_ACL_10200_TO_11100);
  end if;
  return newACL;
end;
--
function migrateACLResource(resourceXML XMLTYPE)
return XMLTYPE
as
  ACL         XMLTYPE;
  newResource XMLTYPE;
begin
  newResource := resourceXML;
  ACL := RESOURCEXML.extract('/r:Resource/r:Contents/*', XDB_NAMESPACES.RESOURCE_PREFIX_R);
  if (ACL.isSchemaValid() = 0) then
    ACL := ACL.TRANSFORM(MIGRATE_ACL_10200_TO_11100);
    select UPDATEXML
           (
             RESOURCEXML,
             '/r:Resource/r:Contents/*', 
             ACL,
             XDB_NAMESPACES.RESOURCE_PREFIX_R
            )
       into NEWRESOURCE 
       from DUAL;
  end if;
  return NEWRESOURCE;   
end;
--
function addResource(root in out DBMS_XMLDOM.DOMELEMENT, xdbResource dbms_xdbResource.XDBResource)
return DBMS_XMLDOM.DOMELEMENT
as
  doc          dbms_xmldom.DOMDocument;
  elem         dbms_xmldom.DOMElement;
  text         dbms_xmldom.DOMText;
begin
/*
  doc  := dbms_xdbResource.makeDocument(xdbResource);
  elem := dbms_xmldom.getDocumentElement(doc);
  doc  := dbms_xmldom.getOwnerDocument(dbms_xmldom.makeNode(root));
  elem := dbms_xmldom.makeElement(dbms_xmldom.importNode(doc,dbms_xmldom.makeNode(elem),TRUE));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(elem)));
*/  
  doc  := dbms_xmldom.getOwnerDocument(dbms_xmldom.makeNode(root));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'ACL', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getACL(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'Author', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getAuthor(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'CharacterSet', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getCharacterSet(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'Comment', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getComment(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'ContentType', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getContentType(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'CreationDate', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getCreationDate(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'Creator', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getCreator(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'DisplayName', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getDisplayName(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'Language', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getLanguage(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'ModificationDate', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getModificationDate(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'LastModifier', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getLastModifier(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'Owner', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getOwner(xdbResource)))));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'RefCount', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xdbResource.getRefCOunt(xdbResource)))));
  
  return root;
end;
--
function serializeResource(xdbResource dbms_xdbResource.XDBResource)
return xmltype
as
  userMetadata XMLType;
  doc          dbms_xmldom.DOMDocument;
  root         dbms_xmldom.DOMElement;
  elem         dbms_xmldom.DOMElement;
  text         dbms_xmldom.DOMText;
begin
  doc  := dbms_xmldom.newDOMDocument();
  root := dbms_xmldom.createElement(doc,'Resource',XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE);
  root := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(doc),dbms_xmldom.makeNode(root)));
  root := addResource(root,xdbResource);
  return dbms_xmldom.getXMLType(doc);
end;
--
function serializeEvent(repositoryEvent dbms_xevent.XDBRepositoryEvent) 
return xmltype
as
  doc          dbms_xmldom.DOMDocument;
  root         dbms_xmldom.DOMElement;
  elem         dbms_xmldom.DOMElement;
  text         dbms_xmldom.DOMText;
  textValue    varchar2(2000);
  xdbEvent     dbms_xevent.XDBEvent;

  resourcePath varchar2(700);
  
begin
  xdbEvent := dbms_xevent.getXDBEvent(repositoryEvent);
  doc  := dbms_xmldom.newDOMDocument();
  root := dbms_xmldom.createElement(doc,'ResourceEvent',XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE);
  root := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(doc),dbms_xmldom.makeNode(root)));
  DBMS_XMLDOM.SETATTRIBUTE(root,'xmlns',XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE);

  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'CurrentUser', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xevent.getCurrentUser(xdbEvent)))));

/*  
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'DAVOwner', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xevent.getDAVOwner(repositoryEvent)))));

  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'DAVToken', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xevent.getDAVToken(repositoryEvent)))));

  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'ExpiryDate', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xevent.getExpiry(repositoryEvent)))));
*/
  
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'EventType', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,dbms_xevent.getEvent(xdbEvent)))));

  resourcePath := dbms_xevent.getName(dbms_xevent.getPath(repositoryEvent));
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'resourcePath', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,resourcePath))));

  -- Append Resource ID to Payload
  
/*
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'ResourceID', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  text := dbms_xmldom.makeText(dbms_xmldom.appendChild(dbms_xmldom.makeNode(elem),dbms_xmldom.makeNode(dbms_xmldom.createTextNode(doc,DBMS_XDB.getResOID(resourcePath)))));
*/
  
  -- Append Old Resource details to Payload
   
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'new', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  elem := addResource(elem, dbms_xevent.getResource(repositoryEvent));

  -- Append New Resource details to Payload
  
/*
  elem := dbms_xmldom.makeElement(dbms_xmldom.appendChild(dbms_xmldom.makeNode(root),dbms_xmldom.makeNode(dbms_xmldom.createElement(doc,'old', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)))); 
  elem := addResource(elem, dbms_xevent.getOldResource(repositoryEvent));
*/
  return dbms_xmldom.getXMLType(doc);

end;
--
$END
--
-- From a DBMS_XMLDOM.DOMDocument object
--
function IS_VERSIONED(P_RESOURCE DBMS_XMLDOM.DOMDocument) 
return BOOLEAN
as
  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;
begin
  V_RESOURCE_ELEMENT := DBMS_XMLDOM.getDocumentElement(P_RESOURCE);
  return DBMS_XMLDOM.hasAttribute(V_RESOURCE_ELEMENT,'VersionID');
end;
--
-- From an XMLType object
--
function IS_VERSIONED(P_RESOURCE XMLTYPE) 
return BOOLEAN
as
begin
  return IS_VERSIONED(DBMS_XMLDOM.NEWDOMDocument(P_RESOURCE));
end;
--
-- From a Path
--
function IS_VERSIONED(P_RESOURCE_PATH VARCHAR2) 
return BOOLEAN
as
  V_RESOURCE          XMLType; 
begin
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  select RES 
    into V_RESOURCE
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1;
  return IS_VERSIONED(V_RESOURCE);
$ELSE
  return IS_VERSIONED(DBMS_XDB.getResource(P_RESOURCE_PATH));
$END
--
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
--
-- From an XDB.XDB$RESOURCE object (11.1.x and Greater) 
--
function IS_VERSIONED(P_RESOURCE DBMS_XDBRESOURCE.XDBRESOURCE) 
return BOOLEAN
as
begin
  return IS_VERSIONED(DBMS_XDBRESOURCE.makeDocument(P_RESOURCE));
end;
--
$END
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
procedure freeResConfig(P_RESCONFIG_PATH VARCHAR2)
as
  cursor getResConfigUsage(C_RESCONFIG_PATH VARCHAR2)
  is             
  select RV.ANY_PATH 
    from RESOURCE_VIEW RV, RESOURCE_VIEW rcrv,
         XMLTable(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             OBJECT_ID RAW(16) path '.'
         ) rce
   where XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList' 
           passing rv.RES as "R"
         )
     and equals_path(rcrv.RES,C_RESCONFIG_PATH) = 1
     and SYS_OP_R2O(
           XMLCast(
             XMLQuery(
               'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                fn:data($RES/Resource/XMLRef)'
                passing rcrv.RES as "RES"
                returning content
              ) as REF XMLType
            )
          ) = rce.OBJECT_ID;
begin
  for r in getResConfigUsage(P_RESCONFIG_PATH) loop
    DBMS_RESCONFIG.deleteResConfig(r.ANY_PATH,P_RESCONFIG_PATH,DBMS_RESCONFIG.DELETE_RESOURCE);
  end loop;
end;
--
$END
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
$ELSE
procedure freeAcl(P_TARGET_ACL VARCHAR2,P_REPLACEMENT_ACL VARCHAR2)
as
  cursor getAclUsage(C_ACL_PATH VARCHAR2)
  is
  select r.ANY_PATH RESOURCE_PATH
    from XDB.RESOURCE_VIEW r, RESOURCE_VIEW ar
   where equals_path(ar.res,C_ACL_PATH) = 1
     and XMLCast(
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
             );
begin
  for r in getAclUsage(P_TARGET_ACL) loop
  	DBMS_XDB.setAcl(r.RESOURCE_PATH,P_REPLACEMENT_ACL);
  end loop;
end;
--
$END
--
procedure UPDATECONTENT_IMPL(P_RESOURCE_PATH VARCHAR2, P_CONTENT_BLOB BLOB, P_CONTENT_CLOB CLOB, P_CONTENT_XML XMLTYPE, P_BLOB_CHARSET VARCHAR2 DEFAULT 'AL32UTF8')
as
  V_LOB_LOCATOR   BLOB;
  V_XMLREF        REF XMLTYPE;
  V_CONTENT_BLOB  BLOB;
  V_CONTENT_CLOB  CLOB;
  V_CONTENT_XML   XMLTYPE;
  
  V_DEST_OFFSET       NUMBER(38) := 1;  
  V_SRC_OFFSET        NUMBER(38) := 1;  
  V_LANG_CONTEXT      NUMBER(38) := 0;  
  V_WARNING           NUMBER(38) := 0;  

  V_CHARSET_ID        NUMBER(4);
  V_RESID             RAW(16);
begin

  select RESID, extractValue(RES,'/Resource/XMLLob'), extractValue(RES,'/Resource/XMLRef') 
    into V_RESID, V_LOB_LOCATOR, V_XMLREF
    from RESOURCE_VIEW
   where equals_path(RES,P_RESOURCE_PATH) = 1
     for update;
   
$IF $$DEBUG $THEN

  if (V_LOB_LOCATOR is NULL) then
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPDATECONTENT_IMPL(): Current Lob Locator is NULL',TRUE);
  end if;
  
  if (V_XMLREF is null) then
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPDATECONTENT_IMPL(): Current XMLRef is NULL',TRUE);
  end if;

  if (P_CONTENT_BLOB is not NULL) then
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPDATECONTENT_IMPL(): Revised content is BLOB. Length ' || DBMS_LOB.getLength(P_CONTENT_BLOB),TRUE);
  end if;

  if (P_CONTENT_CLOB is not NULL) then
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPDATECONTENT_IMPL(): Revised content is CLOB. Length ' || DBMS_LOB.getLength(P_CONTENT_CLOB),TRUE);
  end if;
  
  if (P_CONTENT_XML is not NULL) then
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.UPDATECONTENT_IMPL(): Revised content is XML.',TRUE);
  end if;
  
$END 

  if (V_XMLREF is not null) then
    if (P_CONTENT_XML is not null) then
      updateXMLContent(P_RESOURCE_PATH, P_CONTENT_XML);
    else 
      if (P_CONTENT_BLOB IS NOT NULL) then
        V_CONTENT_XML := xmltype(P_CONTENT_BLOB,nls_charset_id(P_BLOB_CHARSET));
      else
        V_CONTENT_XML := xmltype(P_CONTENT_CLOB);
      end if;
      updateXMLContent(P_RESOURCE_PATH, V_CONTENT_XML);
    end if;
  else
		if (V_LOB_LOCATOR is NULL) then    
      XDBPM_SYSDBA_INTERNAL.resetLobLocator(V_RESID);
    end if;

    update RESOURCE_VIEW
       set res = updateXML(res,'/Resource/DisplayName/text()',extractValue(res,'/Resource/DisplayName/text()'))
     where equals_path(res,P_RESOURCE_PATH) = 1;

    select extractValue(RES,'/Resource/XMLLob')
      into V_LOB_LOCATOR
      from RESOURCE_VIEW
     where equals_path(RES,P_RESOURCE_PATH) = 1;
        		  
	  DBMS_LOB.OPEN(V_LOB_LOCATOR,DBMS_LOB.LOB_READWRITE);     
    DBMS_LOB.TRIM(V_LOB_LOCATOR,0);
    
    if (P_CONTENT_BLOB IS NOT NULL) then
      DBMS_LOB.COPY(V_LOB_LOCATOR,P_CONTENT_BLOB,DBMS_LOB.getLength(P_CONTENT_BLOB),1,1);
    else 
   
      select NLS_CHARSET_ID(VALUE)
        into V_CHARSET_ID
        from NLS_DATABASE_PARAMETERS
       where PARAMETER = 'NLS_CHARACTERSET';
       
      if (P_CONTENT_CLOB IS NOT NULL) then
        DBMS_LOB.convertToBlob(V_LOB_LOCATOR,P_CONTENT_CLOB,DBMS_LOB.GETLENGTH(P_CONTENT_CLOB),V_DEST_OFFSET,V_SRC_OFFSET,V_CHARSET_ID,V_LANG_CONTEXT,V_WARNING);
      else
        V_CONTENT_CLOB := P_CONTENT_XML.getClobVal();
        DBMS_LOB.convertToBlob(V_LOB_LOCATOR,V_CONTENT_CLOB,DBMS_LOB.GETLENGTH(V_CONTENT_CLOB),V_DEST_OFFSET,V_SRC_OFFSET,V_CHARSET_ID,V_LANG_CONTEXT,V_WARNING);
      end if;

    end if;
    DBMS_LOB.CLOSE(V_LOB_LOCATOR);
  end if;
end;       
--
procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_BLOB_CHARSET VARCHAR2 DEFAULT 'AL32UTF8') 
as
begin
  UPDATECONTENT_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_CONTENT_BLOB => P_CONTENT, P_BLOB_CHARSET => P_BLOB_CHARSET, P_CONTENT_CLOB => NULL, P_CONTENT_XML => NULL);
end;
--
procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB) 
as
begin
  UPDATECONTENT_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_CONTENT_CLOB => P_CONTENT, P_CONTENT_BLOB => NULL, P_BLOB_CHARSET => NULL, P_CONTENT_XML => NULL);
end;
--
procedure UPDATECONTENT(P_RESOURCE_PATH VARCHAR2, P_CONTENT XMLTYPE) 
as
begin
  UPDATECONTENT_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_CONTENT_XML => P_CONTENT, P_CONTENT_BLOB => NULL, P_BLOB_CHARSET => NULL, P_CONTENT_CLOB => NULL);
end;
--
procedure UPLOADRESOURCE_IMPL(P_RESOURCE_PATH VARCHAR2, P_CONTENT_BLOB BLOB, P_CONTENT_CLOB CLOB, P_CONTENT_XML XMLTYPE, P_BLOB_CHARSET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
/*
    Positibilites :

       1. Resource does not exist or Item Exists and duplicate policy is RAISE;

       2. Resource is not versioned
          - Version it
          - Check it out
          - Update it
          - Check it back in

       3. Resource is versioned but is not checked out
          - Check it out
          - Update it
          - Check it back in
   
       4. Resource already checked out
          - Update it. 
*/

  V_RESULT                BOOLEAN;
  V_CURRENTLY_CHECKED_OUT BOOLEAN;
  V_RESID                 RAW(16);
begin

  if ((not DBMS_XDB.existsResource(P_RESOURCE_PATH)) or (P_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR)) then

    if (P_CONTENT_BLOB is not NULL) then
      V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT_BLOB);
    else
	    if (P_CONTENT_CLOB is not NULL) then
	      V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT_CLOB);
	    else
	      V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT_XML);
	    end if;
	  end if;
	        
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
    -- 
    -- Corner case - /dev/null type folder where the resource is deleted by a repository event.
    -- 
    if DBMS_XDB.existsResource(P_RESOURCE_PATH) then
      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
    end if;
$END
    return;
  end if;      
    
  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then
    UPDATECONTENT_IMPL(P_RESOURCE_PATH,P_CONTENT_BLOB,P_CONTENT_CLOB,P_CONTENT_XML,P_BLOB_CHARSET);
    -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
$END
  end if;

  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then
    if (not IS_VERSIONED(P_RESOURCE_PATH)) then
      V_RESID := DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);
    end if;

    V_CURRENTLY_CHECKED_OUT := TRUE;
    if (not DBMS_XDB_VERSION.isCheckedOut(P_RESOURCE_PATH)) then
      V_CURRENTLY_CHECKED_OUT := FALSE;
      DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);
    end if;

    -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);
    UPDATECONTENT_IMPL(P_RESOURCE_PATH,P_CONTENT_BLOB,P_CONTENT_CLOB,P_CONTENT_XML,P_BLOB_CHARSET);

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);
$END

    if (not V_CURRENTLY_CHECKED_OUT) then
      V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);
    end if;	         

    return;
  end if;
end;
--
procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_BLOB_CHARSET VARCHAR2 DEFAULT 'AL32UTF8', P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
begin
  UPLOADRESOURCE_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_DUPLICATE_POLICY => P_DUPLICATE_POLICY, P_CONTENT_BLOB => P_CONTENT, P_BLOB_CHARSET => P_BLOB_CHARSET, P_CONTENT_CLOB => NULL, P_CONTENT_XML => NULL);
end;
--
procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT CLOB, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
begin
  UPLOADRESOURCE_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_DUPLICATE_POLICY => P_DUPLICATE_POLICY, P_CONTENT_CLOB => P_CONTENT, P_CONTENT_BLOB => NULL, P_BLOB_CHARSET => NULL, P_CONTENT_XML => NULL);
end;
--
procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT XMLTYPE, P_DUPLICATE_POLICY VARCHAR2 DEFAULT XDB_CONSTANTS.RAISE_ERROR)
as
begin
  UPLOADRESOURCE_IMPL(P_RESOURCE_PATH => P_RESOURCE_PATH, P_DUPLICATE_POLICY => P_DUPLICATE_POLICY, P_CONTENT_XML => P_CONTENT, P_CONTENT_BLOB => NULL, P_BLOB_CHARSET => NULL, P_CONTENT_CLOB => NULL);
end;
--
function READ_LINES(P_RESOURCE_PATH VARCHAR2)
return XDB.XDB$STRING_LIST_T pipelined
as
  V_CONTENT           CLOB          := XDBURITYPE(P_RESOURCE_PATH).getClob();
  V_CONTENT_LENGTH    PLS_INTEGER   := DBMS_LOB.getLength(V_CONTENT);
  V_AMOUNT            PLS_INTEGER   := 32767;
  V_OFFSET            PLS_INTEGER   := 1;

  V_BUFFER            VARCHAR2(32767);
  V_BUFFER_LENGTH     PLS_INTEGER;
  V_BUFFER_OFFSET     PLS_INTEGER   := 1;
  V_NEWLINE_INDEX     PLS_INTEGER   := 0;
  V_NEXT_LINE         VARCHAR2(32767);
begin
  while (V_OFFSET < V_CONTENT_LENGTH ) loop
    DBMS_LOB.READ(V_CONTENT,V_AMOUNT,V_OFFSET,V_BUFFER);
  	V_OFFSET := V_OFFSET + V_AMOUNT;
    V_BUFFER_LENGTH := V_AMOUNT;
    V_AMOUNT := 32767;
    V_BUFFER_OFFSET := 1;
    V_NEWLINE_INDEX := INSTR(V_BUFFER,CHR(10),V_BUFFER_OFFSET);
    WHILE (V_NEWLINE_INDEX > 0) loop
      V_NEXT_LINE := V_NEXT_LINE || SUBSTR(V_BUFFER,V_BUFFER_OFFSET,(V_NEWLINE_INDEX-V_BUFFER_OFFSET));
      pipe row (V_NEXT_LINE);
      V_NEXT_LINE := NULL;
      V_BUFFER_OFFSET := V_NEWLINE_INDEX + 1;
      if (SUBSTR(V_BUFFER,V_BUFFER_OFFSET,1) = CHR(13)) then
        V_BUFFER_OFFSET := V_BUFFER_OFFSET + 1;
      end if;
      V_NEWLINE_INDEX := INSTR(V_BUFFER,CHR(10),V_BUFFER_OFFSET);
    end loop;
    V_NEXT_LINE := SUBSTR(V_BUFFER,V_BUFFER_OFFSET);
  end loop;	
  if (length(V_NEXT_LINE) > 0) then
    pipe row (V_NEXT_LINE);
  end if;
end;  
--
end XDBPM_UTILITIES;
/
show errors 
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--