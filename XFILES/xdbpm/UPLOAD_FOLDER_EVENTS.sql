
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

create or replace package body UPLOAD_FOLDER_EVENTS
as    
-- 
procedure handlePreCreate(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_TABLE_NAME        VARCHAR2(64);
  V_OWNER             VARCHAR2(64);
  V_COLUMN_NAME       VARCHAR2(64);

  V_RESOURCE_PATH     DBMS_XEVENT.xdbPath;
  V_XDB_RESOURCE      DBMS_XDBRESOURCE.xdbResource;
  V_RESOURCE_DOCUMENT DBMS_XMLDOM.DOMDocument;
  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_SCHEMA_ELEMENT    VARCHAR2(1024);
  
  V_STATEMENT         VARCHAR2(32000);
  
  V_XML_CONTENT       XMLType;
  V_CLOB_CONTENT      CLOB;
  V_BLOB_CONTENT      BLOB;
  V_CONTENT_CSID		  NUMBER;

	V_CONTENT_LENGTH    NUMBER;
	
begin

  select OWNER, TABLE_NAME, COLUMN_NAME
    into V_OWNER, V_TABLE_NAME, V_COLUMN_NAME
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
           COLUMN_NAME         varchar2(64) path 'tu:Column'
          
         );

  V_STATEMENT := 'insert into "' || V_OWNER || '"."' || V_TABLE_NAME || '" ("' || V_COLUMN_NAME || '") values (:1)';

  V_XDB_RESOURCE := dbms_xevent.getResource(P_EVENT);

  if (not DBMS_XDBRESOURCE.ISFOLDER(V_XDB_RESOURCE)) then
    V_RESOURCE_DOCUMENT := DBMS_XDBRESOURCE.makeDocument(V_XDB_RESOURCE);
    V_NODE_LIST         := DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(V_RESOURCE_DOCUMENT),'/r:Resource/r:SchemaElement','xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd"');
 		if (DBMS_XMLDOM.getLength(V_NODE_LIST) = 1) then 
      V_SCHEMA_ELEMENT    := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(DBMS_XMLDOM.item(V_NODE_LIST,0)));
    end if;
    
    case V_SCHEMA_ELEMENT
        when DBMS_XDB_CONSTANTS.SCHEMAELEM_RESCONTENT_BINARY then
          -- Binary Content
          V_BLOB_CONTENT   := DBMS_XDBRESOURCE.getContentBLOB(V_XDB_RESOURCE,V_CONTENT_CSID); 
		      execute immediate V_STATEMENT using V_BLOB_CONTENT;
			    V_BLOB_CONTENT := NULL;
    			dbms_xdbResource.setContent(V_XDB_RESOURCE,V_BLOB_CONTENT,V_CONTENT_CSID);
        when DBMS_XDB_CONSTANTS.SCHEMAELEM_RESCONTENT_TEXT then
          -- Character Content
          V_CLOB_CONTENT   := DBMS_XDBRESOURCE.getContentCLOB(V_XDB_RESOURCE); 
          execute immediate V_STATEMENT using V_CLOB_CONTENT;
			    V_CLOB_CONTENT := NULL;
    			dbms_xdbResource.setContent(V_XDB_RESOURCE,V_CLOB_CONTENT);
        else
			    V_XML_CONTENT :=  dbms_xdbResource.getContentXML(V_XDB_RESOURCE);
			    if V_XML_CONTENT is not null then
      			execute immediate V_STATEMENT using V_XML_CONTENT;
    			end if;
			    V_XML_CONTENT := NULL;
    			dbms_xdbResource.setContent(V_XDB_RESOURCE,V_XML_CONTENT);
  	end case;
   end if;

end;
--
procedure handlePostLinkIn(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_RESOURCE_PATH    DBMS_XEVENT.xdbPath;  
begin
  V_RESOURCE_PATH   := dbms_xevent.getPath(P_EVENT);  
  DBMS_XDB.deleteResource(dbms_xevent.getName(V_RESOURCE_PATH));
end;
--  
end;