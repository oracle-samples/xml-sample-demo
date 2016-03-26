
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
alter session set current_schema = XDBPM
/
create or replace package XDBPM_TABLE_UPLOAD
authid CURRENT_USER
as

  -- Metadata For Upload Folder : The Metadata identifies which table to load content into when a document is placed in the folder.

  C_TABLE_UPLOAD_ELEMENT      constant varchar2(1024)  := 'Target';
  C_TABLE_UPLOAD_NAMESPACE    constant varchar2(1024)  := 'http:/xmlns.oracle.com/xdb/pm/tableUpload';
  C_TABLE_UPLOAD_XPATH        constant varchar2(1024)  := '/r:Resource/x:' || C_TABLE_UPLOAD_ELEMENT;
  C_TABLE_UPLOAD_PREFIX_X     constant varchar2(1024)  := 'xmlns:x="' || C_TABLE_UPLOAD_NAMESPACE || '"';

  C_RESCONFIG_SKELETON constant varchar2(32000) :=
'<ResConfig xmlns="http://xmlns.oracle.com/xdb/XDBResConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlns.oracle.com/xdb/XDBResConfig.xsd http://xmlns.oracle.com/xdb/XDBResConfig.xsd">
   <event-listeners>
     <listener>
       <description>Table Upload</description>
       <schema>XDBPM</schema>
       <source>UPLOAD_FOLDER_EVENTS</source>
       <language>PL/SQL</language>
       <events>
         <Pre-Create/>
         <Post-LinkIn/>
       </events>
     </listener>
   </event-listeners>
   <applicationData/>   
</ResConfig>';

  function TABLE_UPLOAD_ELEMENT      return varchar2 deterministic;
  function TABLE_UPLOAD_NAMESPACE    return varchar2 deterministic;
  function TABLE_UPLOAD_XPATH        return varchar2 deterministic;
  function TABLE_UPLOAD_PREFIX_X     return varchar2 deterministic;
      
  function configureUploadFolder(P_UPLOAD_FOLDER VARCHAR2,P_OWNER VARCHAR2,P_OBJECT_NAME VARCHAR2,P_COLUMN_NAME VARCHAR2 DEFAULT 'OBJECT_VALUE') return VARCHAR2;
  function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)  return VARCHAR2;
  procedure createXMLIndexedTable(P_TABLE_NAME VARCHAR2, P_INDEX_NAME VARCHAR2,P_UPLOAD_FOLDER VARCHAR2 DEFAULT NULL);

end;
/
--
show errors
--
create or replace synonym XDB_TABLE_UPLOAD for XDBPM_TABLE_UPLOAD
/
grant execute on XDBPM_TABLE_UPLOAD to public
/
create or replace package body XDBPM_TABLE_UPLOAD
as    
--
NAMESPACE_RESOURCE_CONFIG       constant varchar2(1024)  := 'http://xmlns.oracle.com/xdb/XDBResConfig.xsd';
PREFIX_DEF_RESOURCE_CONFIG      constant varchar2(1024)  := 'xmlns:rc="' || NAMESPACE_RESOURCE_CONFIG || '"';
--  
function TABLE_UPLOAD_ELEMENT   return varchar2 deterministic as begin return C_TABLE_UPLOAD_ELEMENT; end;
--
function TABLE_UPLOAD_NAMESPACE return varchar2 deterministic as begin return C_TABLE_UPLOAD_NAMESPACE; end;
--
function TABLE_UPLOAD_XPATH     return varchar2 deterministic as begin return C_TABLE_UPLOAD_XPATH; end;
--
function TABLE_UPLOAD_PREFIX_X  return varchar2 deterministic as begin return C_TABLE_UPLOAD_PREFIX_X; end;
--
function getResConfigSkeleton 
return XMLTYPE
as
begin
  return XMLType(C_RESCONFIG_SKELETON);
end;
--
function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
return VARCHAR2
as
  V_UPLOAD_FOLDER_PATH VARCHAR2(700);
begin
	
	V_UPLOAD_FOLDER_PATH := XDBPM.XDBPM_RESCONFIG_HELPER.getUploadFolderPath(P_TABLE_NAME,P_OWNER);
  return V_UPLOAD_FOLDER_PATH;	 
	 
end;
--
function configureUploadFolder(P_UPLOAD_FOLDER VARCHAR2,P_OWNER VARCHAR2,P_OBJECT_NAME VARCHAR2,P_COLUMN_NAME VARCHAR2 DEFAULT 'OBJECT_VALUE')
return VARCHAR2
as
  V_OBJECT_TYPE          VARCHAR2(32);
  V_RESULT               BOOLEAN;
  V_DOCUMENT_FOLDER_PATH VARCHAR2(700);
  V_RESCONFIG_PATH       VARCHAR2(700);
  V_TARGET_METADATA      XMLType;
  V_RESCONFIG            XMLType;
begin

  select OBJECT_TYPE
    into V_OBJECT_TYPE
    from ALL_OBJECTS
   where owner = P_OWNER
     and object_name = P_OBJECT_NAME
     and object_type in ('TABLE','VIEW');
  
   if (not DBMS_XDB.existsResource(P_UPLOAD_FOLDER)) then
     XDB_UTILITIES.mkdir(P_UPLOAD_FOLDER,true);
   end if;

   V_DOCUMENT_FOLDER_PATH := P_UPLOAD_FOLDER || '/' || P_OBJECT_NAME;   
   V_RESCONFIG_PATH := V_DOCUMENT_FOLDER_PATH || '.xml';

   if (DBMS_XDB.existsResource(V_DOCUMENT_FOLDER_PATH)) then
     DBMS_XDB.deleteResource(V_DOCUMENT_FOLDER_PATH);
   end if;
   
   V_RESULT := DBMS_XDB.createFolder(V_DOCUMENT_FOLDER_PATH);
   
   V_RESCONFIG := getResConfigSkeleton();
   
   select updateXML
          (
             V_RESCONFIG,
             '/rc:ResConfig/rc:event-listeners/rc:listener[rc:source="UPLOAD_FOLDER_EVENTS"]/rc:schema/text()',
             USER,
             PREFIX_DEF_RESOURCE_CONFIG
          )
     into V_RESCONFIG
     from DUAL;
     
  select xmlElement
         (
           evalname(XDB_TABLE_UPLOAD.TABLE_UPLOAD_ELEMENT),
           xmlAttributes(XDB_TABLE_UPLOAD.TABLE_UPLOAD_NAMESPACE as "xmlns"),
           xmlElement("Owner",P_OWNER),
           xmlElement("Table",P_OBJECT_NAME),
           xmlElement("ObjectType",V_OBJECT_TYPE),
           xmlElement("Column",P_COLUMN_NAME),
           xmlElement("Folder",V_DOCUMENT_FOLDER_PATH)
        )
   into V_TARGET_METADATA
   from dual;

   select insertChildXML
          (
             V_RESCONFIG,
             '/rc:ResConfig/rc:applicationData',
             XDB_TABLE_UPLOAD.TABLE_UPLOAD_ELEMENT,
             V_TARGET_METADATA,
--           DBMS_XDB_CONSTANTS.PREFIX_DEF_RESOURCE_CONFIG || ' ' || XDB_TABLE_UPLOAD.TABLE_UPLOAD_PREFIX_X
             PREFIX_DEF_RESOURCE_CONFIG || ' ' || XDB_TABLE_UPLOAD.TABLE_UPLOAD_PREFIX_X
          )
     into V_RESCONFIG
     from dual;
         
   execute immediate xdburitype('/publishedContent/XDBPM/events/UPLOAD_FOLDER_EVENTS.pkg').getClob();  
   execute immediate xdburitype('/publishedContent/XDBPM/events/UPLOAD_FOLDER_EVENTS.sql').getClob();  
   
   if (DBMS_XDB.existsResource(V_RESCONFIG_PATH)) then
     update XDB.XDB$RESCONFIG rc
        set OBJECT_VALUE = V_RESCONFIG
      where ref(rc) = ( 
                        select extractValue(RES,'/Resource/XMLRef')
                          from RESOURCE_VIEW
                         where equals_path(res,V_RESCONFIG_PATH) = 1
                      );
   else
     V_RESULT := DBMS_XDB.createResource(V_RESCONFIG_PATH,V_RESCONFIG.getClobVal());
   end if;
   
   dbms_resconfig.addResConfig(V_DOCUMENT_FOLDER_PATH,V_RESCONFIG_PATH,null);
                
   return V_DOCUMENT_FOLDER_PATH;
  
end;
--
procedure createXMLIndexedTable(P_TABLE_NAME VARCHAR2, P_INDEX_NAME VARCHAR2,P_UPLOAD_FOLDER VARCHAR2 DEFAULT NULL) 
as
  V_UPLOAD_FOLDER varchar2(700) := '/home/' || USER || '/upload/';
begin

  if (P_UPLOAD_FOLDER is not null) then
    if (instr(P_UPLOAD_FOLDER,'/') = 1) then
      V_UPLOAD_FOLDER := P_UPLOAD_FOLDER;
    else
      V_UPLOAD_FOLDER := V_UPLOAD_FOLDER || P_UPLOAD_FOLDER;
    end if;
  end if;

  execute immediate 'alter session set events = ''19054 trace name context forever, level 1''';
  execute immediate 'create table "' || P_TABLE_NAME || '" of XMLType XMLType store as BINARY XML';
  execute immediate 'alter session set events = ''19054 trace name context off''';
  execute immediate 'create index "' || P_INDEX_NAME || '" on "' || P_TABLE_NAME || '" (OBJECT_VALUE) indextype is xdb.XMLIndex';  
   
  if (P_UPLOAD_FOLDER is not NULL) then
    V_UPLOAD_FOLDER := configureUploadFolder(P_UPLOAD_FOLDER,USER,P_TABLE_NAME,'OBJECT_VALUE');
  end if;
     
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/