
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
create or replace package XFILES_CONSTANTS
authid DEFINER
as
  C_FOLDER_ROOT                         constant VARCHAR2(700) := '/XFILES';
  C_FOLDER_HOME                         constant VARCHAR2(700) := '/home/&XFILES_SCHEMA';
  C_FOLDER_APPLICATIONS_PRIVATE         constant VARCHAR2(700) := C_FOLDER_HOME           || '/Applications';
  C_FOLDER_APPLICATIONS_PUBLIC          constant VARCHAR2(700) := C_FOLDER_ROOT           || '/Applications';                                    
  C_FOLDER_FRAMEWORKS_PRIVATE           constant VARCHAR2(700) := C_FOLDER_HOME           || '/Frameworks';
  C_FOLDER_FRAMEWORKS_PUBLIC            constant VARCHAR2(700) := C_FOLDER_ROOT           || '/Frameworks';
  C_FOLDER_VIEWERS_PUBLIC               constant VARCHAR2(700) := C_FOLDER_ROOT           || '/Viewers';
 
  C_NAMESPACE_XFILES                    constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB || '/xfiles';
  C_NAMESPACE_XFILES_RSS                constant VARCHAR2(128) := C_NAMESPACE_XFILES      || '/rss';
  C_NAMESPACE_XFILES_RC                 constant VARCHAR2(128) := C_NAMESPACE_XFILES      || '/resConfig';
                                       
  C_NSPREFIX_XFILES_XFILES              constant VARCHAR2(128) := 'xmlns:xfiles="'        || C_NAMESPACE_XFILES || '"';
  C_NSPREFIX_XFILES_RSS_RSS             constant VARCHAR2(128) := 'xmlns:rss="'           || C_NAMESPACE_XFILES_RSS || '"';
  C_NSPREFIX_XFILES_RC_XRC              constant VARCHAR2(128) := 'xmlns:xrc="'           || C_NAMESPACE_XFILES_RC || '"';
                                       
  C_ELEMENT_RSS                         constant VARCHAR2(256) := 'enableRSS';
                                       
                                       
  C_ACL_XFILES_USERS                    constant VARCHAR2(700) := C_FOLDER_HOME           || '/src/acls/xfilesUserAcl.xml';
  C_ACL_DENY_XFILES_USERS               constant VARCHAR2(700) := C_FOLDER_HOME           || '/src/acls/denyXFilesUserAcl.xml';
                                       
  C_DOCUMENT_XMLINDEX_LIST              constant VARCHAR2(700) := C_FOLDER_HOME           || '/configuration/xmlIndexList.xml';
  C_DOCUMENT_XMLSCHEMA_LIST             constant VARCHAR2(700) := C_FOLDER_HOME           || '/configuration/xmlSchemaList.xml';
  C_DOCUMENT_XMLSCHEMA_OBJ_LIST         constant VARCHAR2(700) := C_FOLDER_HOME           || '/configuration/xmlSchemaObjectList.xml';
  
  C_FOLDER_RESCONFIG_INT                constant VARCHAR2(700) := C_FOLDER_HOME           || '/src/resConfig';

  C_FOLDER_LOGGING                      constant VARCHAR2(700) := C_FOLDER_HOME           || '/Logs';
  C_FOLDER_CURRENT_LOGGING              constant VARCHAR2(700) := C_FOLDER_LOGGING        || '/Current';
  C_FOLDER_ERROR_LOGGING                constant VARCHAR2(700) := C_FOLDER_LOGGING        || '/Errors';
  C_FOLDER_CURRENT_ERRORS               constant VARCHAR2(700) := C_FOLDER_ERROR_LOGGING  || '/Current';
  C_FOLDER_CLIENT_LOGGING               constant VARCHAR2(700) := C_FOLDER_LOGGING        || '/Client';
  C_FOLDER_CURRENT_CLIENT               constant VARCHAR2(700) := C_FOLDER_CLIENT_LOGGING || '/Current';

  -- Path to the public location, not the private location.
                           
  C_DOCUMENT_UNAUTHENTICATED            constant VARCHAR2(700) := C_FOLDER_ROOT           || '/unauthenticated.xml';                                    
  C_DOCUMENT_WHOAMI                     constant VARCHAR2(700) := C_FOLDER_ROOT           || '/whoami.xml';                                       
  C_DOCUMENT_AUTH_STATUS                constant VARCHAR2(700) := C_FOLDER_ROOT           || '/authenticationStatus.xml';

  C_FOLDER_RESCONFIG_EXT                constant VARCHAR2(700) := C_FOLDER_ROOT           || '/resConfig';
  C_RESCONFIG_WHOAMI                    constant VARCHAR2(700) := C_FOLDER_RESCONFIG_EXT  || '/whoamiResConfig.xml';
  C_RESCONFIG_AUTH_STATUS               constant VARCHAR2(700) := C_FOLDER_RESCONFIG_EXT  || '/authStatusResConfig.xml';                                            
  C_RESCONFIG_INDEX_PAGE                constant VARCHAR2(700) := C_FOLDER_RESCONFIG_EXT  || '/indexPageResConfig.xml';
  C_RESCONFIG_PAGE_COUNT                constant VARCHAR2(700) := C_FOLDER_RESCONFIG_EXT  || '/pageHitsResConfig.xml';
  C_RESCONFIG_RENDER_TABLE              constant VARCHAR2(700) := C_FOLDER_RESCONFIG_EXT  || '/tableContentResConfig.xml';
  
  C_ELEMENT_CUSTOM_VIEWER               constant VARCHAR2(700) := 'CustomViewer';

  function FOLDER_ROOT                  return VARCHAR2 deterministic;
  function FOLDER_HOME                  return VARCHAR2 deterministic;
  function FOLDER_APPLICATIONS_PRIVATE  return VARCHAR2 deterministic;
  function FOLDER_APPLICATIONS_PUBLIC   return VARCHAR2 deterministic;
  function FOLDER_FRAMEWORKS_PRIVATE    return VARCHAR2 deterministic;
  function FOLDER_FRAMEWORKS_PUBLIC     return VARCHAR2 deterministic;
  function FOLDER_VIEWERS_PUBLIC        return VARCHAR2 deterministic;
                                       
  function NAMESPACE_XFILES             return VARCHAR2 deterministic;
  function NAMESPACE_XFILES_RSS         return VARCHAR2 deterministic;
  function NAMESPACE_XFILES_RC          return VARCHAR2 deterministic;
  function NSPREFIX_XFILES_XFILES       return VARCHAR2 deterministic;
  function NSPREFIX_XFILES_RSS_RSS      return VARCHAR2 deterministic;
  function NSPREFIX_XFILES_RC_XRC       return VARCHAR2 deterministic;
  function ELEMENT_RSS                  return VARCHAR2 deterministic;
                                       
  function ACL_XFILES_USERS             return VARCHAR2 deterministic;
  function ACL_DENY_XFILES_USERS        return VARCHAR2 deterministic;
                                                                              
  function DOCUMENT_WHOAMI              return VARCHAR2 deterministic;
  function DOCUMENT_AUTH_STATUS         return VARCHAR2 deterministic;
  function DOCUMENT_UNAUTHENTICATED     return VARCHAR2 deterministic;        
  
  function RESCONFIG_WHOAMI             return VARCHAR2 deterministic;
  function RESCONFIG_AUTH_STATUS        return VARCHAR2 deterministic;
  function RESCONFIG_INDEX_PAGE         return VARCHAR2 deterministic;  
  function RESCONFIG_PAGE_COUNT         return VARCHAR2 deterministic;  
  function RESCONFIG_RENDER_TABLE       return VARCHAR2 deterministic;  
  
  function DOCUMENT_XMLINDEX_LIST       return VARCHAR2 deterministic;
  function DOCUMENT_XMLSCHEMA_LIST      return VARCHAR2 deterministic;
  function DOCUMENT_XMLSCHEMA_OBJ_LIST  return VARCHAR2 deterministic;

  function FOLDER_LOGGING               return VARCHAR2 deterministic;
  function FOLDER_CURRENT_LOGGING       return VARCHAR2 deterministic;
  function FOLDER_ERROR_LOGGING         return VARCHAR2 deterministic;
  function FOLDER_CURRENT_ERRORS        return VARCHAR2 deterministic;
  function FOLDER_CLIENT_LOGGING        return VARCHAR2 deterministic;
  function FOLDER_CURRENT_CLIENT        return VARCHAR2 deterministic;

  function ELEMENT_CUSTOM_VIEWER        return VARCHAR2 deterministic;
end;
/
show errors
--
create or replace package body XFILES_CONSTANTS
as
--
function FOLDER_ROOT      
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_ROOT;
end;
--
function FOLDER_HOME       
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_HOME;
end;
--
function FOLDER_APPLICATIONS_PRIVATE
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_APPLICATIONS_PRIVATE;
end;
--
function FOLDER_APPLICATIONS_PUBLIC
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_APPLICATIONS_PUBLIC;
end;
--
function FOLDER_FRAMEWORKS_PRIVATE
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_FRAMEWORKS_PRIVATE;
end;
--
function FOLDER_FRAMEWORKS_PUBLIC
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_FRAMEWORKS_PUBLIC;
end;
--
function FOLDER_VIEWERS_PUBLIC
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_VIEWERS_PUBLIC;
end;
--
function NAMESPACE_XFILES
return VARCHAR2 deterministic
as 
begin
  return C_NAMESPACE_XFILES;
end;
--
function NAMESPACE_XFILES_RSS   
return VARCHAR2 deterministic
as 
begin
  return C_NAMESPACE_XFILES_RSS;
end;
--
function NAMESPACE_XFILES_RC   
return VARCHAR2 deterministic
as 
begin
  return C_NAMESPACE_XFILES_RC;
end;
--
function NSPREFIX_XFILES_XFILES   
return VARCHAR2 deterministic
as 
begin
  return C_NSPREFIX_XFILES_XFILES;
end;
--
function NSPREFIX_XFILES_RSS_RSS  
return VARCHAR2 deterministic
as 
begin
  return C_NSPREFIX_XFILES_RSS_RSS;
end;
--
function NSPREFIX_XFILES_RC_XRC  
return VARCHAR2 deterministic
as 
begin
  return C_NSPREFIX_XFILES_RC_XRC;
end;
--
function ELEMENT_RSS
return VARCHAR2 deterministic
as 
begin
  return C_ELEMENT_RSS;
end;
--
function ACL_XFILES_USERS
return VARCHAR2 deterministic
as 
begin
  return C_ACL_XFILES_USERS;
end;
--
function ACL_DENY_XFILES_USERS
return VARCHAR2 deterministic
as 
begin
  return C_ACL_DENY_XFILES_USERS;
end;
--
function DOCUMENT_UNAUTHENTICATED    
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_UNAUTHENTICATED;
end;
--
function DOCUMENT_AUTH_STATUS    
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_AUTH_STATUS;
end;
--
function RESCONFIG_AUTH_STATUS
return VARCHAR2 deterministic
as 
begin
  return C_RESCONFIG_AUTH_STATUS;
end;
--
function DOCUMENT_WHOAMI
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_WHOAMI;
end;
--
function RESCONFIG_WHOAMI       
return VARCHAR2 deterministic
as 
begin
  return C_RESCONFIG_WHOAMI;
end;
--  
function RESCONFIG_INDEX_PAGE
return VARCHAR2 deterministic
as 
begin
  return C_RESCONFIG_INDEX_PAGE;
end;
--
function RESCONFIG_PAGE_COUNT
return VARCHAR2 deterministic
as 
begin
  return C_RESCONFIG_PAGE_COUNT;
end;
--
function RESCONFIG_RENDER_TABLE
return VARCHAR2 deterministic
as 
begin
  return C_RESCONFIG_RENDER_TABLE;
end;
--
function DOCUMENT_XMLINDEX_LIST       
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_XMLINDEX_LIST;   
end;
--  
function DOCUMENT_XMLSCHEMA_LIST          
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_XMLSCHEMA_LIST;
end;
--  
function DOCUMENT_XMLSCHEMA_OBJ_LIST          
return VARCHAR2 deterministic
as 
begin
  return C_DOCUMENT_XMLSCHEMA_OBJ_LIST;
end;
--  
function FOLDER_LOGGING
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_LOGGING;
end;
--  
function FOLDER_CURRENT_LOGGING
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_CURRENT_LOGGING;
end;
--  
function FOLDER_ERROR_LOGGING
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_ERROR_LOGGING;
end;
--  
function FOLDER_CURRENT_ERRORS
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_CURRENT_ERRORS;
end;
--  
function FOLDER_CLIENT_LOGGING
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_CLIENT_LOGGING;
end;
--  
function FOLDER_CURRENT_CLIENT
return VARCHAR2 deterministic
as 
begin
  return C_FOLDER_CURRENT_CLIENT;
end;
--  
function ELEMENT_CUSTOM_VIEWER
return VARCHAR2 deterministic
as 
begin
  return C_ELEMENT_CUSTOM_VIEWER;
end;
--  
end;
/
show errors
--
