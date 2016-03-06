
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
-- ************************************************
-- *           Table Creation                   *
-- ************************************************
--
--
declare
  table_exists exception;
  PRAGMA EXCEPTION_INIT( table_exists , -00955 );

  V_CREATE_TABLE_DDL     VARCHAR2(4000) :=
'create table XFILES_DOCUMENT_STAGING
(
   DEMONSTRATION_OWNER VARCHAR2(32),
   DEMONSTRATION_NAME  VARCHAR2(64),
   DEMONSTRATION_STEP  VARCHAR2(12),
   DOCUMENT_PATH       VARCHAR2(700),
   DOCUMENT_CONTENT    BLOB
)';

begin
  execute immediate V_CREATE_TABLE_DDL;
exception
  when table_exists  then
    null;
end;
/
--
-- ************************************************
-- *           Index Creation                   *
-- ************************************************
--
declare
  no_such_index exception;
  PRAGMA EXCEPTION_INIT( no_such_index , -01418 );
begin
--
  execute immediate 'drop index DOC_STAGING_INDEX';
exception
  when no_such_index  then
    null;
end;
/
create index DOC_STAGING_INDEX
    on XFILES_DOCUMENT_STAGING( DEMONSTRATION_OWNER, DEMONSTRATION_NAME, DEMONSTRATION_STEP)
/
grant all on XFILES_DOCUMENT_STAGING to PUBLIC
/
--
declare
  non_existant_table exception;
  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );
begin
--
  begin
    execute immediate 'DROP TABLE DOCUMENT_UPLOAD_TABLE';
  exception
    when non_existant_table  then
      null;
  end;
end;
/
CREATE TABLE DOCUMENT_UPLOAD_TABLE
(
  NAME VARCHAR2(256) UNIQUE NOT NULL,
  mime_type VARCHAR2(128),
  doc_size NUMBER,
  dad_charset VARCHAR2(128),
  last_updated DATE,
  content_type VARCHAR2(128),
  blob_content BLOB
)
/
grant ALL on DOCUMENT_UPLOAD_TABLE             
          to PUBLIC
/
show errors
--
create or replace package XFILES_DOCUMENT_UPLOAD 
AUTHID CURRENT_USER
as 
  procedure UPLOAD(TARGET_FOLDER VARCHAR2, ON_SUCCESS_REDIRECT VARCHAR2, ON_FAILURE_REDIRECT VARCHAR2, DUPLICATE_POLICY OWA.VC_ARR, FILE OWA.VC_ARR, RESOURCE_NAME OWA.VC_ARR, DESCRIPTION OWA.VC_ARR, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2);
  procedure SINGLE_DOC_UPLOAD(TARGET_FOLDER VARCHAR2, ON_SUCCESS_REDIRECT VARCHAR2, ON_FAILURE_REDIRECT VARCHAR2, DUPLICATE_POLICY VARCHAR2, FILE VARCHAR2, RESOURCE_NAME VARCHAR2, DESCRIPTION VARCHAR2, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2);
  procedure XMLHTTPREQUEST_DOC_UPLOAD(TARGET_FOLDER VARCHAR2, FILE VARCHAR2, RESOURCE_NAME VARCHAR2, DUPLICATE_POLICY VARCHAR2, DESCRIPTION VARCHAR2, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2);
  procedure VIEW_LOCAL_XML(LOCAL_FILE VARCHAR2);
end;
/
show errors
--
create or replace package body XFILES_DOCUMENT_UPLOAD as 
--
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/sys/servlets/&XFILES_SCHEMA/FileUpload/XFILES_DOCUMENT_UPLOAD/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/sys/servlets/&XFILES_SCHEMA/FileUpload/XFILES_DOCUMENT_UPLOAD/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
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
procedure UPLOAD(TARGET_FOLDER VARCHAR2, ON_SUCCESS_REDIRECT VARCHAR2, ON_FAILURE_REDIRECT VARCHAR2, DUPLICATE_POLICY OWA.VC_ARR, FILE OWA.VC_ARR, RESOURCE_NAME OWA.VC_ARR, DESCRIPTION OWA.VC_ARR, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2)
as  
  V_REDIRECT_URL          VARCHAR2(1024);
  V_RESULT                BOOLEAN;
  V_CONTENT               BLOB;
  V_PARAMETERS            XMLType;
  V_INIT                  TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE_PATH         VARCHAR2(4000);
  V_CONTENT_TYPE          VARCHAR2(128);
  V_DUPLICATE_POLICY_LIST XMLSEQUENCETYPE := new XMLSEQUENCETYPE();
  V_RESOURCE_NAME_LIST    XMLSEQUENCETYPE := new XMLSEQUENCETYPE();
  V_DESCRIPTION_LIST      XMLSEQUENCETYPE := new XMLSEQUENCETYPE();
  V_FILE_LIST             XMLSEQUENCETYPE := new XMLSEQUENCETYPE();
  V_TARGET_FOLDER         VARCHAR2(700)   := TARGET_FOLDER;
  
  V_RESPONSE_HTML         VARCHAR2(32000);
  V_CONTENT_SIZE          NUMBER;
  V_ERROR_MESSAGE         VARCHAR2(32000);
begin
  V_DUPLICATE_POLICY_LIST.extend(DUPLICATE_POLICY.count);
	for i in DUPLICATE_POLICY.first .. DUPLICATE_POLICY.last LOOP
	  select XMLElement("Entry",DUPLICATE_POLICY(i))
	    into V_DUPLICATE_POLICY_LIST(i)
	    from DUAL;
  end loop;

  V_RESOURCE_NAME_LIST.extend(RESOURCE_NAME.count);
	for i in RESOURCE_NAME.first .. RESOURCE_NAME.last LOOP
	  select XMLElement("Entry",RESOURCE_NAME(i))
	    into V_RESOURCE_NAME_LIST(i)
	    from DUAL;
  end loop;

  V_DESCRIPTION_LIST.extend(DESCRIPTION.count);
	for i in DESCRIPTION.first .. DESCRIPTION.last LOOP
	  select XMLElement("Entry",DESCRIPTION(i))
	    into V_DESCRIPTION_LIST(i)
	    from DUAL;
  end loop;

  V_FILE_LIST.extend(FILE.count);
	for i in FILE.first .. FILE.last LOOP
	  select XMLElement("Entry",FILE(i))
	    into V_FILE_LIST(i)
	    from DUAL;
  end loop;

  select xmlConcat(
           xmlElement("TargetFolder",TARGET_FOLDER),
           xmlElement("OnSuccess",ON_SUCCESS_REDIRECT),
           xmlElement("OnFailure",ON_FAILURE_REDIRECT),
           xmlElement(
             "File",
             ( select XMLAGG(COLUMN_VALUE) from TABLE(V_FILE_LIST))
           ),
           xmlElement(
             "DuplicatePolicy",
             ( select XMLAGG(COLUMN_VALUE) from TABLE(V_DUPLICATE_POLICY_LIST))
           ),
           xmlElement(
             "ResourceName",
             ( select XMLAGG(COLUMN_VALUE) from TABLE(V_RESOURCE_NAME_LIST))
           ),
           xmlElement (
             "Description",
             ( select XMLAGG(COLUMN_VALUE) from TABLE(V_DESCRIPTION_LIST))
           ),
           xmlElement("Language",LANGUAGE),
           xmlElement("CharacterSet",CHARACTER_SET)
         )
    into V_PARAMETERS
    from dual;

	begin

	  if (INSTR(TARGET_FOLDER,'/',-1) <> LENGTH(TARGET_FOLDER)) then
	    V_TARGET_FOLDER := V_TARGET_FOLDER || '/';
	  end if;		

    for i in 1..FILE.count() loop
		
		  if (FILE(i) is not null) then
      	select BLOB_CONTENT, MIME_TYPE
	        into V_CONTENT, V_CONTENT_TYPE
	        from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
	       where NAME = FILE(i);
	    
	      if (RESOURCE_NAME(i) is not NULL) then
	        V_RESOURCE_PATH := TARGET_FOLDER || '/' || RESOURCE_NAME(i);
	      else
  	      V_RESOURCE_PATH := TARGET_FOLDER || '/' || SUBSTR(FILE(i),INSTR(FILE(i),'/')+1);
  	    end if;

        XDB_REPOSITORY_SERVICES.UPLOADRESOURCE(V_RESOURCE_PATH, V_CONTENT, V_CONTENT_TYPE, DESCRIPTION(i), LANGUAGE, CHARACTER_SET, DUPLICATE_POLICY(i));
        
        delete from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
         where NAME = FILE(i);
      end if;
    end loop;    	 

    V_RESPONSE_HTML := xdburitype(ON_SUCCESS_REDIRECT).getClob();
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%STATUS%','201');
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%REPOSITORY_PATH%',V_RESOURCE_PATH);
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_SUCCESS%',ON_SUCCESS_REDIRECT);
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_FAILURE%',ON_FAILURE_REDIRECT);

    writeLogRecord('UPLOAD',V_INIT,V_PARAMETERS);

  exception
    when others then
      V_ERROR_MESSAGE := SQLERRM;
      V_ERROR_MESSAGE := replace(V_ERROR_MESSAGE,chr(10),' ');
      V_ERROR_MESSAGE := replace(V_ERROR_MESSAGE,'"','');
      V_RESPONSE_HTML := xdburitype(ON_FAILURE_REDIRECT).getClob();
     	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%STATUS%','500');
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%ERROR_CODE%',SQLCODE);
     	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%ERROR_MESSAGE%',V_ERROR_MESSAGE);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%REPOSITORY_PATH%',V_RESOURCE_PATH);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_SUCCESS%',ON_SUCCESS_REDIRECT);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_FAILURE%',ON_FAILURE_REDIRECT);
      handleException('UPLOAD',V_INIT,V_PARAMETERS);
  end;

	OWA_UTIL.MIME_HEADER('text/html',FALSE);
	V_CONTENT_SIZE := LENGTH(V_RESPONSE_HTML);
  htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;
  htp.prn(V_RESPONSE_HTML);
  htp.flush();
 
end;
--
procedure SINGLE_DOC_UPLOAD(TARGET_FOLDER VARCHAR2, ON_SUCCESS_REDIRECT VARCHAR2, ON_FAILURE_REDIRECT VARCHAR2, DUPLICATE_POLICY VARCHAR2, FILE VARCHAR2, RESOURCE_NAME VARCHAR2, DESCRIPTION VARCHAR2, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2)
as  
  V_REDIRECT_URL          VARCHAR2(1024);
  V_RESULT                BOOLEAN;
  V_CONTENT               BLOB;
  V_PARAMETERS            XMLType;
  V_INIT                  TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE_PATH         VARCHAR2(4000);
  V_CONTENT_TYPE          VARCHAR2(128);  
  V_TARGET_FOLDER         VARCHAR2(700) := TARGET_FOLDER;
  
  V_RESPONSE_HTML         VARCHAR2(32000);
  V_CONTENT_SIZE          NUMBER;
begin
 select xmlConcat(
           xmlElement("TargetFolder",TARGET_FOLDER),
           xmlElement("OnSuccess",ON_SUCCESS_REDIRECT),
           xmlElement("OnFailure",ON_FAILURE_REDIRECT),
           xmlElement("File",FILE),
           xmlElement("DuplicatePolicy",DUPLICATE_POLICY),
           xmlElement("ResourceName",RESOURCE_NAME),
           xmlElement("Description",DESCRIPTION),
           xmlElement("Language",LANGUAGE),
           xmlElement("CharacterSet",CHARACTER_SET)
         )
    into V_PARAMETERS
    from dual;

	begin
		
   	select BLOB_CONTENT, MIME_TYPE
      into V_CONTENT, V_CONTENT_TYPE
	    from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
	   where NAME = FILE;
	    
	   if (INSTR(TARGET_FOLDER,'/',-1) <> LENGTH(TARGET_FOLDER)) then
	     V_TARGET_FOLDER := V_TARGET_FOLDER || '/';
	   end if;
	    
    if (RESOURCE_NAME is not NULL) then
      V_RESOURCE_PATH := V_TARGET_FOLDER || RESOURCE_NAME;
    else
	    V_RESOURCE_PATH := V_TARGET_FOLDER || SUBSTR(FILE,INSTR(FILE,'/')+1);
    end if;

    XDB_REPOSITORY_SERVICES.UPLOADRESOURCE(V_RESOURCE_PATH, V_CONTENT, V_CONTENT_TYPE, DESCRIPTION, LANGUAGE, CHARACTER_SET, DUPLICATE_POLICY);
        
    delete from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
     where NAME = FILE;

    V_RESPONSE_HTML := xdburitype(ON_SUCCESS_REDIRECT).getClob();
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%STATUS%','201');
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%REPOSITORY_PATH%',V_RESOURCE_PATH);
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_SUCCESS%',ON_SUCCESS_REDIRECT);
   	V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_FAILURE%',ON_FAILURE_REDIRECT);

    writeLogRecord('SINGLE_DOC_UPLOAD',V_INIT,V_PARAMETERS);
   
  exception
    when others then
      V_RESPONSE_HTML := xdburitype(ON_FAILURE_REDIRECT).getClob();
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%STATUS%','500');
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%ERROR_CODE%',SQLCODE);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%ERROR_MESSAGE%',SQLERRM);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%REPOSITORY_PATH%',V_RESOURCE_PATH);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_SUCCESS%',ON_SUCCESS_REDIRECT);
   	  V_RESPONSE_HTML := REPLACE(V_RESPONSE_HTML,'%URL_FAILURE%',ON_FAILURE_REDIRECT);
      handleException('SINGLE_DOC_UPLOAD',V_INIT,V_PARAMETERS);
  end;

	OWA_UTIL.MIME_HEADER('text/html',FALSE);
	V_CONTENT_SIZE := LENGTH(V_RESPONSE_HTML);
  htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;
  htp.prn(V_RESPONSE_HTML);
  htp.flush();

end;
--
procedure XMLHTTPREQUEST_DOC_UPLOAD(TARGET_FOLDER VARCHAR2, FILE VARCHAR2, RESOURCE_NAME VARCHAR2, DUPLICATE_POLICY VARCHAR2, DESCRIPTION VARCHAR2, LANGUAGE VARCHAR2, CHARACTER_SET VARCHAR2)
as  
  V_RESULT                BOOLEAN;
  V_CONTENT               BLOB;
  V_PARAMETERS            XMLType;
  V_INIT                  TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_RESOURCE_PATH         VARCHAR2(4000);
  V_CONTENT_TYPE          VARCHAR2(128);  
  V_TARGET_FOLDER         VARCHAR2(700) := TARGET_FOLDER;
  
  V_RESPONSE_HTML         VARCHAR2(32000);
  V_CONTENT_SIZE          NUMBER;
begin
  select xmlConcat(
           xmlElement("TargetFolder",TARGET_FOLDER),
           xmlElement("File",FILE),
           xmlElement("DuplicatePolicy",DUPLICATE_POLICY),
           xmlElement("ResourceName",RESOURCE_NAME),
           xmlElement("Description",DESCRIPTION),
           xmlElement("Language",LANGUAGE),
           xmlElement("CharacterSet",CHARACTER_SET)
         )
    into V_PARAMETERS
    from dual;

	begin
		
   	select BLOB_CONTENT, MIME_TYPE
      into V_CONTENT, V_CONTENT_TYPE
	    from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
	   where NAME = FILE;
	    
	   if (INSTR(TARGET_FOLDER,'/',-1) <> LENGTH(TARGET_FOLDER)) then
	     V_TARGET_FOLDER := V_TARGET_FOLDER || '/';
	   end if;
	    
    if (RESOURCE_NAME is not NULL) then
      V_RESOURCE_PATH := V_TARGET_FOLDER || RESOURCE_NAME;
    else
	    V_RESOURCE_PATH := V_TARGET_FOLDER || SUBSTR(FILE,INSTR(FILE,'/')+1);
    end if;

    XDB_REPOSITORY_SERVICES.UPLOADRESOURCE(V_RESOURCE_PATH, V_CONTENT, V_CONTENT_TYPE, DESCRIPTION, LANGUAGE, CHARACTER_SET, DUPLICATE_POLICY);
        
    delete from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
     where NAME = FILE;

    writeLogRecord('XMLHTTPREQUEST_DOC_UPLOAD',V_INIT,V_PARAMETERS);
    V_RESPONSE_HTML := '{ "path" : "' || V_RESOURCE_PATH || '", "status" : 1}';
   
  exception
    when others then
      V_RESPONSE_HTML := '{ "path" : "' || V_RESOURCE_PATH || '", "status" : -1, "SQLError" : ' || SQLCODE || ', "SQLErrorMessage" : "' || SQLERRM  || '"}';
      handleException('XMLHTTPREQUEST_DOC_UPLOAD',V_INIT,V_PARAMETERS);
  end;

	OWA_UTIL.MIME_HEADER('application/json',FALSE);
	V_CONTENT_SIZE := LENGTH(V_RESPONSE_HTML);
  htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;
  htp.prn(V_RESPONSE_HTML);
  htp.flush();

end;
--
procedure VIEW_LOCAL_XML(LOCAL_FILE VARCHAR2)
as  
  V_PARAMETERS            XMLType;
  V_INIT                  TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_CONTENT               CLOB;
  V_CONTENT_SIZE          NUMBER;
  V_BUFFER                VARCHAR2(8192) ;
  V_OFFSET                BINARY_INTEGER := 1;
  V_AMOUNT                BINARY_INTEGER := 4096;    
begin
  select xmlElement("File",LOCAL_FILE)
    into V_PARAMETERS
    from dual;

	begin
		
   	select XMLSERIALIZE(DOCUMENT XMLTYPE(BLOB_CONTENT,nls_charset_id('AL32UTF8')) AS CLOB)
   	  into V_CONTENT
	    from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
	   where NAME = LOCAL_FILE;
	    
    delete from &XFILES_SCHEMA..DOCUMENT_UPLOAD_TABLE
     where NAME = LOCAL_FILE;

    writeLogRecord('VIEW_LOCAL_XML',V_INIT,V_PARAMETERS);   
  exception
    when others then
      V_CONTENT := '{ "Name" : "' || LOCAL_FILE || '", "status" : -1, "SQLError" : ' || SQLCODE || ', "SQLErrorMessage" : "' || SQLERRM  || '"}';
      handleException('VIEW_LOCAL_XML',V_INIT,V_PARAMETERS);
  end;

	OWA_UTIL.MIME_HEADER('text/xml',FALSE);
	V_CONTENT_SIZE := dbms_lob.getlength(V_CONTENT);
  htp.p('Content-Length: ' || V_CONTENT_SIZE);
  owa_util.http_header_close;

  loop
    begin
    	DBMS_LOB.read(V_CONTENT,V_AMOUNT,V_OFFSET,V_BUFFER);
    	V_OFFSET := V_OFFSET + V_AMOUNT;
    	V_AMOUNT := 4000;
      htp.prn(V_BUFFER);
    exception
      when NO_DATA_FOUND then
        exit;
    end;
  end loop;    	
  htp.flush();
  DBMS_LOB.FREETEMPORARY(V_CONTENT);

end;
--
end;
/
show errors
--
