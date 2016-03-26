
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
-- XDBPM_REGISTRATION_HELPER should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
set define on
--
create or replace package XDBPM_REGISTRATION_HELPER
authid CURRENT_USER
as

  TYPE DOCUMENT_INFO_T
    is RECORD (
         PATH                 VARCHAR2(1024),
         ELEMENT              VARCHAR2(256), 
         NAMESPACE            VARCHAR2(4000), 
         SCHEMA_LOCATION_HINT VARCHAR2(4000),
         TARGET               VARCHAR2(4000),
         OWNER                VARCHAR2(128),
         TABLE_NAME           VARCHAR2(128),
         MATCH_TYPE           VARCHAR2(16)
       );
  
  TYPE DOCUMENT_TABLE_T
    is TABLE of DOCUMENT_INFO_T;
    
  function  unpackArchive(P_ARCHIVE_PATH VARCHAR2) return NUMBER;
  function  getInstanceDocuments(P_FOLDER_PATH VARCHAR2) return DOCUMENT_TABLE_T pipelined; 
  procedure loadInstanceDocuments(P_FOLDER_PATH VARCHAR2,P_LOGFILE_NAME VARCHAR2);
  
end XDBPM_REGISTRATION_HELPER;
/
show errors
--
create or replace synonym XDB_REGISTRATION_HELPER for XDBPM_REGISTRATION_HELPER
/
grant execute on XDBPM_REGISTRATION_HELPER to public
/
create or replace package body XDBPM_REGISTRATION_HELPER
as
function unpackArchive(P_ARCHIVE_PATH VARCHAR2)
return NUMBER
--
--  Unzip the XML Schema Archive, remove redundant folders and return number of documents.
--
as 
  V_FOLDER_PATH        VARCHAR2(700) := substr(P_ARCHIVE_PATH,1,instr(P_ARCHIVE_PATH,'/',-1)-1);
  V_ARCHIVE_FILE       VARCHAR2(700) := substr(P_ARCHIVE_PATH,instr(P_ARCHIVE_PATH,'/',-1)+1);
  V_ARCHIVE_NAME       VARCHAR2(700) := substr(V_ARCHIVE_FILE,1,instr(V_ARCHIVE_FILE,'.',-1)-1);
  V_SCHEMA_FOLDER      VARCHAR2(700) := V_FOLDER_PATH || '/' || V_ARCHIVE_NAME;
  V_UNZIP_LOGFILE      VARCHAR2(700) := V_SCHEMA_FOLDER || '.log';
  V_RESULT             BOOLEAN;
  
  V_UNZIPPED_COUNT     NUMBER;
  V_RESOURCE_COUNT     NUMBER;
  V_REDUNDANT_FOLDER   VARCHAR2(700);
  V_SUBFOLDER_NAME     VARCHAR2(700);

  cursor getArchiveContents(C_TARGET_PATH VARCHAR2) 
  is
  select ANY_PATH,
         XMLCAST(
           XMLQUERY(
             'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
              /Resource/DisplayName'
             passing RES 
             returning Content
           )
           as VARCHAR2(4000)
         ) DISPLAY_NAME
    from RESOURCE_VIEW
   where under_path(RES,1,C_TARGET_PATH) = 1;


begin
	if (DBMS_XDB.existsResource(V_SCHEMA_FOLDER)) then
	  DBMS_XDB.deleteResource(V_SCHEMA_FOLDER,DBMS_XDB.DELETE_RECURSIVE);
	end if;
	
	if (DBMS_XDB.existsResource(V_UNZIP_LOGFILE)) then
	  DBMS_XDB.deleteResource(V_UNZIP_LOGFILE);
	end if;
	
	V_RESULT := DBMS_XDB.createFolder(V_SCHEMA_FOLDER);
  commit;
  
	XDB_IMPORT_UTILITIES.unZip(P_ARCHIVE_PATH,V_SCHEMA_FOLDER,V_UNZIP_LOGFILE,XDB_CONSTANTS.RAISE_ERROR);
  commit;
  
  -- Deal with scenario where the Arhcive Name is the root folder in the Archive.
  
  select count(*)
    into V_RESOURCE_COUNT
    from RESOURCE_VIEW
   where under_path(RES,1,V_SCHEMA_FOLDER) = 1;

  select count(*)
    into V_UNZIPPED_COUNT
    from RESOURCE_VIEW
   where under_path(RES,V_SCHEMA_FOLDER) = 1;

   
  if (V_RESOURCE_COUNT = 1) then  
  
    select XMLCAST(
             XMLQUERY(
               'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                /Resource/DisplayName'
               passing RES 
               returning content
             )
             as VARCHAR2(4000)
           )
      into V_SUBFOLDER_NAME
      from RESOURCE_VIEW
     where under_path(RES,1,V_SCHEMA_FOLDER) = 1;
     
     
    if (V_SUBFOLDER_NAME = V_ARCHIVE_NAME) then

      V_REDUNDANT_FOLDER := V_SCHEMA_FOLDER || '/' || V_SUBFOLDER_NAME;
      for r in getArchiveContents(V_REDUNDANT_FOLDER) loop
        DBMS_XDB.renameResource(r.ANY_PATH,V_SCHEMA_FOLDER,r.DISPLAY_NAME);
      end loop;
      commit;

      DBMS_XDB.deleteResource(V_REDUNDANT_FOLDER);
      commit;

    end if;
      
  end if;
  
  return V_UNZIPPED_COUNT;
end;
--
function  getInstanceDocuments(P_FOLDER_PATH VARCHAR2) 
return DOCUMENT_TABLE_T pipelined
as
  cursor getDocumentInfo
  is 
  with DOCUMENT_INFO as (
    select ANY_PATH, ELEMENT, NAMESPACE, SCHEMA_LOCATION_HINT
      FROM RESOURCE_VIEW rv,
           XMLTABLE(          
              'for $DOC in $DOCUMENT/* (:[@xsi:noNamespaceSchemaLocation or @xsi:schemaLocation] :)
                   let $SEQ := fn:tokenize($DOC/@xsi:schemaLocation," ")
                   let $IND := fn:index-of($SEQ,fn:namespace-uri($DOC))+1
                   return element documentInfo {
                                    element schemaLocationHint {
                                                if (fn:namespace-uri($DOC)) then
                                   						    $SEQ[$IND] 
                                                else 
                                                  $DOC/@xsi:noNamespaceSchemaLocation
                                            },
                                    element elementName        {fn:local-name($DOC)},
                                    element namespace          {fn:namespace-uri($DOC)}
                                  }
             '
             passing xdburitype(ANY_PATH).getXML() as "DOCUMENT"
             columns 
               ELEMENT               VARCHAR2(256) PATH 'elementName',
               NAMESPACE             VARCHAR2(256) PATH 'namespace',
               SCHEMA_LOCATION_HINT  VARCHAR2(700) PATH 'schemaLocationHint'
           )
     where under_path(RES,P_FOLDER_PATH) = 1
       and XMLExists(
            'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
             $RES/Resource[ends-with(DisplayName,".xml")]' 
             passing RES as "RES"
           )
  )
  select ANY_PATH, ELEMENT, NAMESPACE, SCHEMA_LOCATION_HINT, SCHEMA_LOCATION_HINT TARGET, axt.OWNER, axt.TABLE_NAME, 'Exact' MATCH_TYPE
      -- Exact Match in USER_XML_TABLES based on ELEMENT and SCHEMA_LOCATION_HINT
    from DOCUMENT_INFO, ALL_XML_TABLES axt
   where SCHEMA_LOCATION_HINT is not NULL
     and XMLSCHEMA = SCHEMA_LOCATION_HINT
     and ELEMENT_NAME = ELEMENT
   union all
  select ANY_PATH, ELEMENT, NAMESPACE, SCHEMA_LOCATION_HINT, axt.XMLSCHEMA TARGET, axt.OWNER, axt.TABLE_NAME, 'Relative' MATCH_TYPE
      -- Relative Match in USER_XML_TABLES based on ELEMENT and SCHEMA_LOCATION_HINT
    from DOCUMENT_INFO, ALL_XML_TABLES axt
   where SCHEMA_LOCATION_HINT is not NULL
     and XMLSCHEMA = XDB_XMLSCHEMA_UTILITIES.matchRelativeURL(SCHEMA_LOCATION_HINT) 
     and ELEMENT_NAME = ELEMENT
   union all
  select ANY_PATH, ELEMENT, NAMESPACE, SCHEMA_LOCATION_HINT, axt.XMLSCHEMA TARGET, axt.OWNER, axt.TABLE_NAME, 'Namespace' MATCH_TYPE
      -- Match in USER_XML_TABLES based on ELEMENT and NAMESPACE
    from DOCUMENT_INFO, ALL_XML_TABLES axt, ALL_XML_SCHEMAS axs
   where ELEMENT = ELEMENT_NAME
     and SCHEMA_URL = XMLSCHEMA
     and axs.OWNER = axt.OWNER
     and NAMESPACE = XMLCAST(
                       XMLQUERY(
                         '$SCHEMA/xs:schema/@targetNamespace'
                         passing SCHEMA as "SCHEMA"
                         returning content
                       ) as VARCHAR2(700)
                     )
   union all
  select ANY_PATH, ELEMENT, NAMESPACE, SCHEMA_LOCATION_HINT, axt.XMLSCHEMA TARGET, axt.OWNER, axt.TABLE_NAME, 'Namespace' MATCH_TYPE
      -- Match in USER_XML_TABLES based on ELEMENT and NAMESPACE
    from DOCUMENT_INFO, ALL_XML_TABLES axt, ALL_XML_SCHEMAS axs
   where ELEMENT = ELEMENT_NAME
     and SCHEMA_URL = XMLSCHEMA
     and axs.OWNER = axt.OWNER
     and NAMESPACE is NULL
     and not XMLEXISTS(
               '$SCHEMA/xs:schema/@targetNamespace'
                passing SCHEMA as "SCHEMA"
             );
begin
	for d in getDocumentInfo() loop	
	  pipe row (d);
  end loop;
end;
--
procedure loadInstanceDocuments(P_FOLDER_PATH VARCHAR2,P_LOGFILE_NAME VARCHAR2) 
as	
  V_STATEMENT     VARCHAR2(4000);
  
  V_DOCUMENT_COUNT  NUMBER := 0;
  V_SUCCESS_COUNT   NUMBER := 0;
  V_FAILED_COUNT    NUMBER := 0;
  
  cursor getDocuments 
  is
  select * 
    from TABLE(
           XDB_REGISTRATION_HELPER.getInstanceDocuments(P_FOLDER_PATH)
         ) d
   where d.TABLE_NAME is not NULL;
  
   V_XML_INSTANCE XMLTYPE;
begin
   
  XDB_OUTPUT.createLogFile(P_FOLDER_PATH || '/' || P_LOGFILE_NAME,TRUE);

  for doc in getDocuments loop
  
    V_DOCUMENT_COUNT := V_DOCUMENT_COUNT + 1;

    XDB_OUTPUT.writeLogFileEntry('Processing "' || doc.PATH || '.' );
    XDB_OUTPUT.flushLogFile();

   	V_STATEMENT := 'insert into "' || doc.OWNER || '"."' || doc.TABLE_NAME || '" values (:1)';
   	
    begin
    	V_XML_INSTANCE := xdburitype(doc.PATH).getXML();
    	
    	if (doc.SCHEMA_LOCATION_HINT <> doc.TARGET) then
  	    select case 
         	       WHEN doc.NAMESPACE is NULL THEN
          	        XMLQUERY(
          	          'copy $NEWDOC := $DOC modify (
          	                 	           let $ROOT := $NEWDOC/*
          	                 	           return (
          	                 	             replace value of node $ROOT/@xsi:noNamespaceSchemaLocation with $SLH
          	                             )
          	                           )
          	           return $NEWDOC'
          	           passing V_XML_INSTANCE as "DOC", 
          	                   doc.TARGET as "SLH"
          	           returning content
          	       )
          	     ELSE 
         	        XMLQUERY(
          	          'copy $NEWDOC := $DOC modify (
          	                 	           let $ROOT := $NEWDOC/*
          	                 	           return (
          	                 	             replace value of node $ROOT/@xsi:schemaLocation with $SLH
          	                             )
          	                           )
          	           return $NEWDOC'
          	           passing V_XML_INSTANCE as "DOC", 
          	                   doc.NAMESPACE || ' ' || doc.TARGET as "SLH"
          	           returning content
          	       )
          	   END
  	      into V_XML_INSTANCE
  	      from dual;
      end if;    	    
    	execute immediate V_STATEMENT using V_XML_INSTANCE;
      V_SUCCESS_COUNT := V_SUCCESS_COUNT + 1;
    exception
      when OTHERS then
         XDB_OUTPUT.writeLogFileEntry('SQL: "' || V_STATEMENT || '".');
         XDB_OUTPUT.writeLogFileEntry('Element: "' || doc.ELEMENT || '" in namespace: "' || doc.NAMESPACE || '" defined by XMLSchema: "' || doc.TARGET || '".');
         XDB_OUTPUT.writeLogFileEntry('Match Basis: "' || doc.MATCH_TYPE || '".');
         XDB_OUTPUT.writeLogFileEntry(SQLERRM);
         XDB_OUTPUT.writeLogFileEntry('--');   
				 XDB_OUTPUT.logException();
         XDB_OUTPUT.flushLogFile();
         V_FAILED_COUNT := V_FAILED_COUNT + 1;
    end;     
             
    XDB_OUTPUT.flushLogFile();

    commit;

  end loop;

  XDB_OUTPUT.writeLogFileEntry('Document Count = ' || V_DOCUMENT_COUNT);   
  XDB_OUTPUT.writeLogFileEntry('Loaded         = ' || V_SUCCESS_COUNT);   
  XDB_OUTPUT.writeLogFileEntry('Failed         = ' || V_FAILED_COUNT);   
  XDB_OUTPUT.flushLogFile();
end;
--
end XDBPM_REGISTRATION_HELPER;
/
show errors
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--