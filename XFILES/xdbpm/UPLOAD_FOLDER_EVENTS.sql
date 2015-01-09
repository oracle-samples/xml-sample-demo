
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
 * ================================================ */

create or replace package body UPLOAD_FOLDER_EVENTS
as    
-- 
procedure handlePreLinkIn(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_TABLE_NAME       VARCHAR2(64);
  V_OWNER            VARCHAR2(64);
  V_COLUMN_NAME      VARCHAR2(64);
  V_CONTENT_TYPE     VARCHAR2(6);

  V_RESOURCE_PATH    DBMS_XEVENT.xdbPath;
  V_TARGET_RESOURCE  DBMS_XDBRESOURCE.xdbResource;

  V_STATEMENT        VARCHAR2(32000);
  
  V_XML_CONTENT      XMLType;
  V_BLOB_CONTENT     BLOB;
  V_CONTENT_CSID		 NUMBER;
  V_CLOB_CONTENT     CLOB;

begin

  select OWNER, TABLE_NAME, COLUMN_NAME, CONTENT_TYPE
    into V_OWNER, V_TABLE_NAME, V_COLUMN_NAME, V_CONTENT_TYPE
    from xmltable
         (
           xmlnamespaces
           (
             'http://xmlns.oracle.com/xdb/XDBResConfig.xsd' as "rc",
             'http:/xmlns.oracle.com/xdb/pm/tableUpload' as "tu"
           ),
           '/rc:applicationData/tu:Target'
           passing DBMS_XEVENT.getApplicationData(P_EVENT)
           columns
           OWNER               varchar2(64) path 'tu:Owner',
           TABLE_NAME          varchar2(64) path 'tu:Table',
           COLUMN_NAME         varchar2(64) path 'tu:Column',
           CONTENT_TYPE        varchar2(6)  path 'tu:ContentType'
         );

  V_STATEMENT := 'insert into "' || V_OWNER || '"."' || V_TABLE_NAME || '" ("' || V_COLUMN_NAME || '") values (:1)';

  V_TARGET_RESOURCE := dbms_xevent.getResource(P_EVENT);

  if (V_CONTENT_TYPE = XDB_TABLE_UPLOAD.XML_CONTENT) then
    V_XML_CONTENT :=  dbms_xdbResource.getContentXML(V_TARGET_RESOURCE);
    if V_XML_CONTENT is not null then
       execute immediate V_STATEMENT using V_XML_CONTENT;
    end if;
    V_XML_CONTENT := NULL;
    dbms_xdbResource.setContent(V_TARGET_RESOURCE,V_XML_CONTENT);
  end if;

  if (V_CONTENT_TYPE = XDB_TABLE_UPLOAD.BINARY_CONTENT) then
    V_BLOB_CONTENT :=  dbms_xdbResource.getContentBLOB(V_TARGET_RESOURCE,V_CONTENT_CSID);
    if V_BLOB_CONTENT is not null then
      execute immediate V_STATEMENT using V_BLOB_CONTENT;
    end if;
    V_BLOB_CONTENT := NULL;
    dbms_xdbResource.setContent(V_TARGET_RESOURCE,V_BLOB_CONTENT,NULL);
  end if;

  if (V_CONTENT_TYPE = XDB_TABLE_UPLOAD.TEXT_CONTENT) then
    V_CLOB_CONTENT :=  dbms_xdbResource.getContentCLOB(V_TARGET_RESOURCE);
    if V_CLOB_CONTENT is not null then
      execute immediate V_STATEMENT using V_CLOB_CONTENT;
    end if;
    V_CLOB_CONTENT := NULL;
    dbms_xdbResource.setContent(V_TARGET_RESOURCE,V_CLOB_CONTENT);
  end if;
--  
end;
--
procedure handlePostLinkIn(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_RESOURCE_PATH    DBMS_XEVENT.xdbPath;  
begin
  V_RESOURCE_PATH   := dbms_xevent.getPath(P_EVENT);  
  dbms_xdb.deleteResource(dbms_xevent.getName(V_RESOURCE_PATH));
end;
--  
end;