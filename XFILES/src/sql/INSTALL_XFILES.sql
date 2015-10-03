
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

set echo on
spool INSTALL_XFILES.log
--
def XFILES_SCHEMA = &1
--
call XDB_UTILITIES.createHomeFolder()
/
commit
/
declare
  text_exception exception;
  PRAGMA EXCEPTION_INIT( text_exception , -20000);
begin
--
  begin
    ctxsys.ctx_ddl.create_policy(policy_name=>'XFILES_HTML_GENERATION', filter=>'ctxsys.auto_filter');
  exception
    when text_exception  then
      null;
  end;
end;
/
@@XFILES_CONSTANTS
--
grant execute on XFILES_CONSTANTS        
              to PUBLIC
/
--
@@XFILES_LOG_TABLE
--
@@XFILES_LOGWRITER
--
grant execute on XFILES_LOGWRITER       
              to PUBLIC
/
@@XFILES_LOGGING
--
grant execute on XFILES_LOGGING         
              to PUBLIC
/
@@XFILES_USER_MANAGEMENT
--
grant execute on XFILES_ADMIN_SERVICES
              to XFILES_ADMINISTRATOR
/              
grant execute on XFILES_USER_SERVICES
              to PUBLIC
/
@@XFILES_RENDERING_SUPPORT
--
@@XFILES_UTILITIES
--
grant execute on XFILES_UTILITIES        
              to PUBLIC
/
@@XFILES_WIKI_SERVICES
--
grant execute on XFILES_WIKI_SERVICES   
              to PUBLIC
/
@@XDB_REPOSITORY_SERVICES
--
grant execute on XDB_REPOSITORY_SERVICES
              to PUBLIC
/
@@XFILES_DOCUMENT_UPLOAD
--
grant execute on XFILES_DOCUMENT_UPLOAD 
              to PUBLIC
/
@@XFILES_SOAP_SERVICES
--
grant execute on XFILES_SOAP_SERVICES   
              to PUBLIC
/
@@XFILES_SEARCH_SERVICES
--
grant execute on XFILES_SEARCH_SERVICES 
              to PUBLIC
/
@@XFILES_REST_SERVICES
--
grant execute on XFILES_REST_SUPPORT 
              to PUBLIC
/
grant execute on XFILES_REST_SERVICES   
              to PUBLIC
/
@@XFILES_APEX_SERVICES
--
--
begin
  dbms_utility.compile_schema('&XFILES_SCHEMA',TRUE);
end;
/
select object_name, object_type, status 
  from all_objects
 where owner= '&XFILES_SCHEMA' 
   and OBJECT_TYPE not in ('LOB')
 order by status, object_type, object_name
/
@@XFILES_XMLINDEX_LIST
--
@@XFILES_XMLSCHEMA_LIST
--
@@XFILES_CREATE_FOLDERS
--
@@XFILES_EVENT_MANAGERS
--
@@XFILES_ADMIN
--
call XFILES_LOGWRITER.CREATELOGGINGFOLDERS()
--
-- RESETLOGGINGFOLDERS should be run as a post instal step as it can take a long time...
--
-- call XFILES_LOGWRITER.RESETLOGGINGFOLDERS()
/
commit
/
spool off
exit
