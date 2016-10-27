
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

spool XFILES_PUBLIC_SYNONYMS.log
set echo on
--
define XFILES_SCHEMA = &1
--
alter session set current_schema = &XFILES_SCHEMA
/
alter session set CURRENT_SCHEMA = &XFILES_SCHEMA
/
create or replace public synonym XFILES_CONSTANTS       
                             for XFILES_CONSTANTS
/
create or replace public synonym XFILES_UTILITIES        
                             for XFILES_UTILITIES
/
create or replace public synonym XFILES_LOGWRITER        
                             for XFILES_LOGWRITER
/
create or replace public synonym XFILES_LOGGING          
                             for XFILES_LOGGING
/
create or replace public synonym XDB_REPOSITORY_SERVICES 
                             for XDB_REPOSITORY_SERVICES
/
create or replace public synonym XFILES_DOCUMENT_UPLOAD  
                             for XFILES_DOCUMENT_UPLOAD
/
create or replace public synonym XFILES_WIKI_SERVICES    
                             for XFILES_WIKI_SERVICES
/
create or replace public synonym XFILES_SOAP_SERVICES    
                             for XFILES_SOAP_SERVICES
/
create or replace public synonym XFILES_SEARCH_SERVICES  
                             for XFILES_SEARCH_SERVICES
/
create or replace public synonym XFILES_REST_SERVICES    
                             for XFILES_REST_SERVICES
/
create or replace public synonym XFILES_WEBDEMO_SERVICES 
                             for XFILES_WEBDEMO_SERVICES
/
create or replace public synonym XFILES_RESULT_CACHE 
                             for XFILES_RESULT_CACHE
/
quit