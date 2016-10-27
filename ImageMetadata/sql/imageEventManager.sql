
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

set echo on
spool sqlOperations.log APPEND
--
def METADATA_OWNER = &1
--
def XFILES_SCHEMA = &2
--
def DEBUG = &3
--
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:&DEBUG';
/
ALTER SESSION SET CURRENT_SCHEMA = &METADATA_OWNER
/
--
--  Create the package to handle events related to contentType 'image/jpeg'
--
CREATE OR REPLACE PACKAGE IMAGE_EVENT_MANAGER
as
  C_IMAGE_EVENT_LOG_FILE   CONSTANT VARCHAR2(700) := '/public/IMAGE_EVENT_MANAGER.log';
  
  procedure handlePreCreate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent);
  procedure handlePostCreate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent);
  procedure handlePostUpdate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent);
  procedure handlePostUnlock(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent);
  procedure handlePreDelete(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent);
end;
/
show errors
--
create or replace public synonym IMAGE_EVENT_MANAGER for IMAGE_EVENT_MANAGER
/
CREATE OR REPLACE PACKAGE BODY IMAGE_EVENT_MANAGER
as
--
  G_CONTENT_SIZE NUMBER := -1;
--
function getEventSummary(P_RESOURCE_PATH VARCHAR2, P_XDB_REPOS_EVENT DBMS_XEVENT.XDBEvent) 
return xmltype
as
  V_DOCUMENT     DBMS_XMLDOM.DOMDocument;
  V_ROOT_NODE    DBMS_XMLDOM.DOMNode;
  V_ELEMENT_NODE DBMS_XMLDOM.DOMNode;
  V_TEXT_NODE    DBMS_XMLDOM.DOMNode;
begin
  V_DOCUMENT     := DBMS_XMLDOM.newDOMDocument();
  V_ROOT_NODE    := DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(V_DOCUMENT),DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_DOCUMENT,'EventDetail',XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE)));
  DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_ROOT_NODE),'xmlns',XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE);
  
  V_ELEMENT_NODE := DBMS_XMLDOM.appendChild(V_ROOT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_DOCUMENT,'currentUser', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE))); 
  V_TEXT_NODE    := DBMS_XMLDOM.appendChild(V_ELEMENT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_DOCUMENT,DBMS_XEVENT.getCurrentUser(P_XDB_REPOS_EVENT))));
    
  V_ELEMENT_NODE := DBMS_XMLDOM.appendChild(V_ROOT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_DOCUMENT,'eventType', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE))); 
  V_TEXT_NODE    := DBMS_XMLDOM.appendChild(V_ELEMENT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_DOCUMENT,DBMS_XEVENT.getEvent(P_XDB_REPOS_EVENT))));

  V_ELEMENT_NODE := DBMS_XMLDOM.appendChild(V_ROOT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createElement(V_DOCUMENT,'resourcePath', XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE))); 
  V_TEXT_NODE    := DBMS_XMLDOM.appendChild(V_ELEMENT_NODE,DBMS_XMLDOM.makeNode(DBMS_XMLDOM.createTextNode(V_DOCUMENT,P_RESOURCE_PATH)));
  
  return DBMS_XMLDOM.getXMLType(V_DOCUMENT);

end;
--
PROCEDURE handlePreCreate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent)
IS
  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       xmlType;
  V_EVENT_SUMMARY     xmlType;

  V_RESOURCE_PATH     VARCHAR2(700);
  V_XDB_EVENT         DBMS_XEVENT.XDBEvent;

  V_XDB_RESOURCE      DBMS_XDBRESOURCE.XDBResource;
  V_CONTENT_BLOB      BLOB;
  V_CONTENT_CSID      BINARY_INTEGER;
    
BEGIN
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_XDB_REPOS_EVENT));
  V_XDB_RESOURCE  := DBMS_XEVENT.getResource(P_XDB_REPOS_EVENT);

  $IF $$DEBUG $THEN
    V_XDB_EVENT     := DBMS_XEVENT.getXDBEvent(P_XDB_REPOS_EVENT);
   	V_EVENT_SUMMARY := getEventSummary(V_RESOURCE_PATH, V_XDB_EVENT);
    XDB_OUTPUT.writeLogFileEntry(XDB_EVENT_HELPER.getEventName(DBMS_XEVENT.getEvent(V_XDB_EVENT)));
    XDB_OUTPUT.writeLogFileEntry(V_EVENT_SUMMARY);
	  XDB_OUTPUT.flushLogFile();
  $END

  V_CONTENT_BLOB  := DBMS_XDBRESOURCE.getContentBLOB(V_XDB_RESOURCE,V_CONTENT_CSID);
  G_CONTENT_SIZE  := DBMS_LOB.getLength(V_CONTENT_BLOB);
    
exception
  when others then
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_EVENT_MANAGER.' ,'HANDLEPOSTCREATE', V_INIT_TIME, V_EVENT_SUMMARY, V_STACK_TRACE);
    rollback; 
END handlePreCreate;
--
PROCEDURE handlePostCreate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent)
IS
  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       xmlType;
  V_EVENT_SUMMARY     xmlType;

  V_RESOURCE_PATH     VARCHAR2(700);
  V_XDB_EVENT         DBMS_XEVENT.XDBEvent;

  V_XDB_RESOURCE      DBMS_XDBRESOURCE.XDBResource;
  V_CONTENT_BLOB      BLOB;
  V_CONTENT_CSID      BINARY_INTEGER;
    
BEGIN
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_XDB_REPOS_EVENT));
  V_XDB_EVENT     := DBMS_XEVENT.getXDBEvent(P_XDB_REPOS_EVENT);
	V_EVENT_SUMMARY := getEventSummary(V_RESOURCE_PATH, V_XDB_EVENT);

  $IF $$DEBUG $THEN
    XDB_OUTPUT.writeLogFileEntry(XDB_EVENT_HELPER.getEventName(DBMS_XEVENT.getEvent(V_XDB_EVENT)));
    XDB_OUTPUT.writeLogFileEntry(V_EVENT_SUMMARY);
	  XDB_OUTPUT.flushLogFile();
  $END
	  
  V_XDB_RESOURCE  := DBMS_XEVENT.getResource(P_XDB_REPOS_EVENT);
  V_CONTENT_BLOB  := DBMS_XDBRESOURCE.getContentBLOB(V_XDB_RESOURCE,V_CONTENT_CSID);
  G_CONTENT_SIZE  := DBMS_LOB.getLength(V_CONTENT_BLOB);

  $IF $$DEBUG $THEN
    XDB_OUTPUT.writeLogFileEntry('Content Size: '|| G_CONTENT_SIZE);
    XDB_OUTPUT.flushLogFile();
  $END

  if (G_CONTENT_SIZE > 0) then
    $IF $$DEBUG $THEN
      XDB_OUTPUT.writeLogFileEntry('Queuing Event');
	    XDB_OUTPUT.flushLogFile();
    $END
    xdb_asynchronous_events.enqueue_event(V_EVENT_SUMMARY);
  end if;
  G_CONTENT_SIZE := -1;    
exception
  when others then
    G_CONTENT_SIZE := -1;    
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_EVENT_MANAGER.' ,'HANDLEPOSTCREATE', V_INIT_TIME, V_EVENT_SUMMARY, V_STACK_TRACE);
    rollback; 
END handlePostCreate;
--
PROCEDURE handlePostUpdate(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent)
IS
  
  /*
  **
  ** Post event processing is deferred to to unlock if resource is Locked
  **
  */

  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       xmlType;
  V_EVENT_SUMMARY     xmlType;
  V_LOCKTOKEN         VARCHAR2(4000);
  
  V_RESOURCE_PATH     VARCHAR2(700);
  V_XDB_EVENT         DBMS_XEVENT.XDBEvent;

  V_XDB_RESOURCE      DBMS_XDBRESOURCE.XDBResource;
  V_XML_REF           REF xmlType;

  V_LOCKED_RESOURCE   BOOLEAN := FALSE;    

  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;
  V_XDB_DOCUMENT      DBMS_XMLDOM.DOMDocument;

BEGIN
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_XDB_REPOS_EVENT));
	V_XDB_EVENT     := DBMS_XEVENT.getXDBEvent(P_XDB_REPOS_EVENT);
  V_EVENT_SUMMARY := getEventSummary(V_RESOURCE_PATH, V_XDB_EVENT);

  $IF $$DEBUG $THEN
    XDB_OUTPUT.writeLogFileEntry(XDB_EVENT_HELPER.getEventName(DBMS_XEVENT.getEvent(V_XDB_EVENT)));
    XDB_OUTPUT.writeLogFileEntry(V_EVENT_SUMMARY);
	  XDB_OUTPUT.flushLogFile();
  $END
 
  V_XDB_RESOURCE  := DBMS_XEVENT.getResource(P_XDB_REPOS_EVENT);
  
  /*
  **
  ** Only queue the event if the content has changed and we are updating an unlocked resource. 
  ** Windows XP will not lock, Windows 7 Mini Re-directory will lock resource and do lot's of prop patch operations which 
  ** translate into updates that do not change content. V_LOCKTOKEN LENGTH > 44 means record is locked
  **
  */

  if (DBMS_XDBRESOURCE.hasContentChanged(V_XDB_RESOURCE)) then
    V_XDB_DOCUMENT := DBMS_XDBRESOURCE.makeDocument(V_XDB_RESOURCE);
    V_NODE_LIST    := DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(V_XDB_DOCUMENT),'/r:Resource/r:LockBuf','xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd"');

    if (DBMS_XMLDOM.getLength(V_NODE_LIST) = 1) then 
      V_LOCKTOKEN    := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(DBMS_XMLDOM.item(V_NODE_LIST,0)));
      V_LOCKED_RESOURCE := LENGTH(V_LOCKTOKEN) > 44;
    end if;
    
    if (NOT V_LOCKED_RESOURCE) then

      begin 
    	
      	/*
       	**  
       	** Provide REF for any existing IMAGE metadata associated with this resource
       	** Easier to get the REF than in the AQ processing due to permission issues
       	**
      	*/ 
      	
        select ref(m)
          into V_XML_REF
          from RESOURCE_VIEW r, IMAGE_METADATA_TABLE m
         where r.RESID = M.RESID
           and equals_path(res,V_RESOURCE_PATH) = 1;
      
        select insertChildXML
               (
                 V_EVENT_SUMMARY,
                 '/EventDetail',
                 '/existingMetadata',
                 xmlElement("existingMetadata",xmlAttributes(XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE as "xmlns"),REFTOHEX(V_XML_REF)),
                 XDB_NAMESPACES.RESOURCE_EVENT_PREFIX_RE
               )
          into V_EVENT_SUMMARY
          from DUAL;

      exception
        when no_data_found then
           NULL;
      end;
      
      xdb_asynchronous_events.enqueue_event(V_EVENT_SUMMARY);
    
    end if;
  end if;

exception
  when others then
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_EVENT_MANAGER.' ,'HANDLEPOSTUPDATE', V_INIT_TIME, V_EVENT_SUMMARY, V_STACK_TRACE);
    rollback; 
END handlePostUpdate;
--
PROCEDURE handlePostUnlock(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent)
IS
  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       xmlType;
  V_EVENT_SUMMARY     xmlType;

  V_RESOURCE_PATH     VARCHAR2(700);
  V_XDB_EVENT         DBMS_XEVENT.XDBEvent;

  V_XDB_RESOURCE      DBMS_XDBRESOURCE.XDBResource;
  V_XML_REF           REF xmlType;
    
BEGIN
	V_XDB_EVENT     := DBMS_XEVENT.getXDBEvent(P_XDB_REPOS_EVENT);
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_XDB_REPOS_EVENT));

	V_EVENT_SUMMARY := getEventSummary(V_RESOURCE_PATH, V_XDB_EVENT);

  $IF $$DEBUG $THEN
    XDB_OUTPUT.writeLogFileEntry(XDB_EVENT_HELPER.getEventName(DBMS_XEVENT.getEvent(V_XDB_EVENT)));
    XDB_OUTPUT.writeLogFileEntry(V_EVENT_SUMMARY);
	  XDB_OUTPUT.flushLogFile();
  $END
 
  V_XDB_RESOURCE  := DBMS_XEVENT.getResource(P_XDB_REPOS_EVENT);

  begin 
 	
  	-- Check for REF to existing IMAGE metadata
 	
    select ref(m)
      into V_XML_REF
      from RESOURCE_VIEW r, IMAGE_METADATA_TABLE m
     where r.RESID = M.RESID
       and equals_path(res,V_RESOURCE_PATH) = 1;
     
    select insertChildXML
           (
             V_EVENT_SUMMARY,
             '/EventDetail',
             '/existingMetadata',
             xmlElement("existingMetadata",xmlAttributes(XDB_NAMESPACES.RESOURCE_EVENT_NAMESPACE as "xmlns"),REFTOHEX(V_XML_REF)),
             XDB_NAMESPACES.RESOURCE_EVENT_PREFIX_RE
           )
      into V_EVENT_SUMMARY
      from DUAL;
  exception
    when no_data_found then
      NULL;
  end;
  
  xdb_asynchronous_events.enqueue_event(V_EVENT_SUMMARY);
  
exception
  when others then
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_EVENT_MANAGER.' ,'HANDLEPOSTUNLOCK', V_INIT_TIME, V_EVENT_SUMMARY, V_STACK_TRACE);
    rollback; 
END handlePostUnlock;
--
PROCEDURE handlePreDelete(P_XDB_REPOS_EVENT DBMS_XEVENT.XDBRepositoryEvent)
IS
  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       xmlType;
  V_EVENT_SUMMARY     xmlType;

  V_RESOURCE_PATH     VARCHAR2(700);
  V_XDB_EVENT         DBMS_XEVENT.XDBEvent;
BEGIN	
  V_RESOURCE_PATH := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_XDB_REPOS_EVENT));  

  $IF $$DEBUG $THEN
  	V_XDB_EVENT     := DBMS_XEVENT.getXDBEvent(P_XDB_REPOS_EVENT);
  	V_EVENT_SUMMARY := getEventSummary(V_RESOURCE_PATH, V_XDB_EVENT);
    XDB_OUTPUT.writeLogFileEntry(XDB_EVENT_HELPER.getEventName(DBMS_XEVENT.getEvent(V_XDB_EVENT)));
    XDB_OUTPUT.writeLogFileEntry(V_EVENT_SUMMARY);
	  XDB_OUTPUT.flushLogFile();
  $END

	-- Do not use the queue mechanism for deletes as the delete processing should be part of transaction that deletes the resource.
	
  IMAGE_PROCESSOR.deleteImageMetadata(V_RESOURCE_PATH);

exception
  when others then
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_EVENT_MANAGER.' ,'HANDLEPOSTDELETE', V_INIT_TIME, V_EVENT_SUMMARY, V_STACK_TRACE);
    rollback;   
END handlePreDelete;
--
BEGIN
	 NULL;
   $IF $$DEBUG $THEN
     XDB_OUTPUT.createLogFile(C_IMAGE_EVENT_LOG_FILE,FALSE);
     XDB_OUTPUT.writeLogFileEntry(sys_context('USERENV', 'CURRENT_USER') || ': ' ||  'Package Initialization.');
	   XDB_OUTPUT.flushLogFile();
   $END

END IMAGE_EVENT_MANAGER;
/
show errors
--
grant execute on IMAGE_EVENT_MANAGER to public
/
desc IMAGE_EVENT_MANAGER
--
quit
