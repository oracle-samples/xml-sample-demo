
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
--  Drop Roles
--
declare
  role_not_found exception;
  PRAGMA EXCEPTION_INIT( role_not_found , -01919 );

begin
  execute immediate 'drop role XFILES_ADMINISTRATOR';
exception
  when role_not_found  then
    null;
end;
/
declare
  role_not_found exception;
  PRAGMA EXCEPTION_INIT( role_not_found , -01919 );

begin
  execute immediate 'drop role XFILES_USER';
exception
  when role_not_found  then
    null;
end;
/
--
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from ALL_SYNONYMS
   where OWNER = 'PUBLIC'
     and TABLE_OWNER = '&XFILES_SCHEMA'
     and SYNONYM_NAME in 
         (
            'MAP_POI',
            'MAP_POI_CAT',
            'MAP_POI_PLACEMARK',
            'MAP_POI_KML_VIEW',
            'EXIF_METADATA_TABLE',
            'KML_STORE',
            'KML_STORE_22',
            'KML_PLACEMARKS',
            'KML_DOCUMENTS'
         );
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getLocalSynonyms is
  select SYNONYM_NAME
    from ALL_SYNONYMS
   where OWNER = '&XFILES_SCHEMA'
     and TABLE_OWNER = '&XFILES_SCHEMA'
     and SYNONYM_NAME in 
         (
            'KML_SUPPORT'
         );
begin
	for s in getLocalSynonyms loop
    execute immediate 'drop synonym "&XFILES_SCHEMA"."' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from ALL_SYNONYMS
   where OWNER = 'PUBLIC'
     and TABLE_OWNER = '&XFILES_SCHEMA'
     and SYNONYM_NAME in 
         (
            'XDB_REPOSITORY_SERVICES',
            'XFILES_CONSTANTS',
            'XFILES_UTILITIES',
            'WEBDEMO_HELPER',
            'XDB_REPOSITORY_SERVICES',
            'XFILES_ADMIN_SERVICES',
            'XFILES_APEX_SERVICES',
            'XFILES_DEMO_SUPPORT',
            'XFILES_DOCUMENT_UPLOAD',
            'XFILES_LOGGING',
            'XFILES_LOGWRITER',
            'XFILES_LOG_SERVICES',
            'XFILES_RENDERING',
            'XFILES_REST_SERVICES',
            'XFILES_SEARCH_SERVICES',
            'XFILES_SOAP_SERVICES',
            'XFILES_USER_SERVICES',
            'XFILES_WEBDEMO_HELPER',
            'XFILES_WIKI_SERVICES'
         );
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getLocalSynonyms is
  select SYNONYM_NAME
    from ALL_SYNONYMS
   where OWNER = '&XFILES_SCHEMA'
     and TABLE_OWNER = '&XFILES_SCHEMA'
     and SYNONYM_NAME in 
         (
            'WEBDEMO_HELPER',
            'XDB_REPOSITORY_SERVICES',
            'XFILES_ADMIN_SERVICES',
            'XFILES_APEX_SERVICES',
            'XFILES_DEMO_SUPPORT',
            'XFILES_DOCUMENT_UPLOAD',
            'XFILES_LOGGING',
            'XFILES_LOGWRITER',
            'XFILES_LOG_SERVICES',
            'XFILES_RENDERING',
            'XFILES_REST_SERVICES',
            'XFILES_SEARCH_SERVICES',
            'XFILES_SOAP_SERVICES',
            'XFILES_USER_SERVICES',
            'XFILES_WEBDEMO_HELPER',
            'XFILES_WIKI_SERVICES'
         );
begin
	for s in getLocalSynonyms loop
    execute immediate 'drop synonym "&XFILES_SCHEMA"."' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getLocalViews is
  select VIEW_NAME
    from ALL_VIEWS
   where OWNER = '&XFILES_SCHEMA'
     and VIEW_NAME in 
         (
            'ALL_ENTRIES_MOST_RECENT',
            'ALL_ENTRIES_LAST_HOUR',
            'ALL_ENTRIES',
            'LOG_ENTRIES_MOST_RECENT',
            'LOG_ENTRIES_LAST_HOUR',
            'ALL_LOG_ENTRIES',
            'ERRORS_MOST_RECENT',
            'ERRORS_LAST_HOUR',
            'ALL_ERRORS',
            'ALL_LOGGING',
            'ALL_LOGGING_LAST_HOUR',
            'ALL_LOGGING_MOST_RECENT',
            'ALL_NORMAL_ACTIVITY',
            'ALL_XFILES_ERRORS',
            'CURRENT_SOAP_REQUESTS',
            'ERROR_LOG_VIEW',
            'ERR_RECORD_VIEW',
            'MAP_POI_KML_VIEW',
            'MAP_POI_PLACEMARK',
            'KML_PLACEMARKS',
            'KML_DOCUMENTS',
            'NORMAL_ACTIVITY_LAST_HOUR',
            'NORMAL_ACTIVITY_MOST_RECENT',
            'RECENT_ERRORS',
            'RECENT_HTTP_REQUESTS',
            'RECENT_LOG_ENTRIES',
            'RECENT_LOG_RECORDS_VIEW',
            'RECENT_LOG_VIEW',
            'RECENT_SOAP_REQUESTS',
            'SOAP_LOG_ENTRIES',
            'WIKI_LOG_ENTRIES',
            'REPOS_ERRORS',
            'REPOS_ERRORS_LAST_DAY',
            'REPOS_ERRORS_LAST_HOUR',
            'REPOS_ERRORS_MOST_RECENT',
            'SERVER_CRASHES',
            'SERVER_CRASHES_LAST_DAY',
            'SERVER_CRASHES_LAST_HOUR',
            'SERVER_CRASHES_MOST_RECENT',
            'XFILES_ACTIVITY',            
            'XFILES_ACTIVITY_LAST_HOUR',
            'XFILES_ACTIVITY_LAST_DAY',
            'XFILES_ACTIVITY_MOST_RECENT',
            'XFILES_CLIENT',
            'XFILES_CLIENT_LAST_DAY',
            'XFILES_CLIENT_LAST_HOUR',
            'XFILES_CLIENT_MOST_RECENT',
            'XFILES_ERRORS',            
            'XFILES_ERRORS_LAST_DAY',
            'XFILES_ERRORS_LAST_HOUR',
            'XFILES_ERRORS_MOST_RECENT',
            'XFILES_JSCRIPT',            
            'XFILES_JSCRIPT_LAST_HOUR',
            'XFILES_JSCRIPT_MOST_RECENT',
            'XFILES_LOG_RECORDS',            
            'XFILES_LOG_RECORDS_LAST_DAY',
            'XFILES_LOG_RECORDS_LAST_HOUR',
            'XFILES_LOG_RECORDS_MOST_RECENT',
            'XFILES_LONG_OPS',
            'XFILES_LONG_OPS_LAST_DAY',
            'XFILES_LONG_OPS_LAST_HOUR',
            'XFILES_LONG_OPS_MOST_RECENT',
            'XFILES_SCHEMA_LIST',
            'XFILES_XMLSCHEMA_LIST',
            'XFILES_XML_INDEX_LIST',
            'XMLINDEX_LIST',
            'XMLSCHEMA_LIST',
            'XFILES_PAGE_HITS',
            'XFILES_PAGE_HITS_BY_DATE'
         );
begin
	for v in getLocalViews loop
    execute immediate 'drop view "&XFILES_SCHEMA"."' || v.VIEW_NAME || '"';
	end loop;
end;
/
declare
  cursor getOldPackages is
  select OBJECT_NAME PACKAGE_NAME
    from ALL_OBJECTS 
   where OWNER = '&XFILES_SCHEMA'
     and OBJECT_NAME in 
         (
           'XFILES_WIKI_SERVICES_11201',
           'XFILES_WIKI_SERVICES_11107',
           'XFILES_WEBDEMO_HELPER_11201',
           'XFILES_UTILITIES_11201',
           'XFILES_USER_SERVICES_11201',
           'XFILES_SOAP_SERVICES_11201',
           'XFILES_SOAP_SERVICES_11107',
           'XFILES_SEARCH_SERVICES_11201',
           'XFILES_SEARCH_SERVICES_11107',
           'XFILES_REST_SERVICES_11201',
           'XFILES_REST_SERVICES_11107',
           'XFILES_RENDERING_11201',
           'XFILES_LOG_SERVICES_11107',
           'XFILES_LOGWRITER_11201',
           'XFILES_LOGGING_11201',
           'XFILES_DOCUMENT_UPLOAD_11201',
           'XFILES_DEMO_SUPPORT_11100',
           'XFILES_DEMO_SUPPORT_10200',
           'XFILES_APEX_SERVICES_11201',
           'XFILES_ADMIN_SERVICES_11201',
           'XDB_REPOSITORY_SERVICES_11201',
           'WEBDEMO_HELPER_11100',
           'KML_SUPPORT_11201'
         )
     and object_type = 'PACKAGE';
begin
	for p in getOldPackages loop
    execute immediate 'drop package "&XFILES_SCHEMA"."' || p.PACKAGE_NAME || '"';
	end loop;
end;
/
declare
  cursor getOldJavaClasses is
  select SOURCE
    from ALL_JAVA_CLASSES
   where OWNER = '&XFILES_SCHEMA'
     and SOURCE in 
         (
           'MultipartProcessor',
           'MultipartInputStream',
           'InputStreamProcessor',
           'MultipartProcessorImpl',
           'MultipartProcessorImp;',
           'ExternalConnectionProvider',
           'RepositoryImport',
           'RepositoryExport',
           'XFilesZipManager',
           'XFilesServlet',
           'RepositoryInterface',
           'XFilesServiceProvider',
           'GenericXFilesServlet',
           'SelectionProcessor',
           'NewFolder ',
           'FolderProcessor',
           'UploadFiles',
           'VersionHistory',
           'XFilesLogoff',
           'SQLCache        ',
           'GenericSQLServices',
           'XDBNamingEnumeration',
           'NotImplementedException',
           'DocumentExtensions',
           'ResourceExtensions',
           'JNDIBinaryDocument',
           'JNDIXMLDocument',
           'JNDIResource ',
           'JNDIContext  ',
           'JNDIInitialContext',
           'DocumentImpl ',
           'ResourceImpl ',
           'ResourceContextImpl',
           'JDBCResourceImpl',
           'JDBCBinaryDocumentImpl',
           'JDBCXMLDocumentImpl',
           'JDBCContextImpl',
           'JDBCInitialContextImpl',
           'JDBCContextFactoryImpl',
           'XDBZipUtilities',
           'SQLContext'
         );
begin
	for c in getOldJavaClasses loop
    execute immediate 'drop java source "&XFILES_SCHEMA"."' || c.SOURCE || '"';
	end loop;
end;
/
declare
  cursor getOldTables is
  select TABLE_NAME
    from ALL_TABLES
   where OWNER = '&XFILES_SCHEMA'
     and TABLE_NAME in 
         (
            'LOG_RECORD_ORDERING',
            'NEXT_LOG_RECORD'
         );
begin
	for v in getOldTables loop
    execute immediate 'drop table "&XFILES_SCHEMA"."' || v.TABLE_NAME || '"';
	end loop;
end;
/
declare
  cursor getOldTables is
  select TABLE_NAME
    from ALL_OBJECT_TABLES
   where OWNER = '&XFILES_SCHEMA'
     and TABLE_NAME in 
         (
            'RECENT_LOG_RECORDS',
            'ERROR_LOG_RECORDS'
         );
begin
	for v in getOldTables loop
    execute immediate 'drop table "&XFILES_SCHEMA"."' || v.TABLE_NAME || '"';
	end loop;
end;
/
declare
  cursor getOldTypes is
  select TYPE_NAME
    from ALL_TYPES
   where OWNER = '&XFILES_SCHEMA'
     and TYPE_NAME in 
         (
            'LOG_RECORD_REFERENCE'
         );
begin
	for v in getOldTypes loop
    execute immediate 'drop type "&XFILES_SCHEMA"."' || v.TYPE_NAME || '"';
	end loop;
end;
/
