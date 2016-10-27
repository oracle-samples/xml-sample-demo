
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
spool sqlOperations.log append
--
DEF METADATA_SCHEMA = &1
--
grant xdbadmin, create any directory, alter session, create public synonym to &METADATA_SCHEMA
/
call XDBPM.XDBPM_UTILITIES_INTERNAL.createHomeFolder('&METADATA_SCHEMA')
/
call DBMS_XDB.setACL('/home/&METADATA_SCHEMA','/sys/acls/bootstrap_acl.xml')
/
grant AQ_ADMINISTRATOR_ROLE to &METADATA_SCHEMA
/
ALTER SESSION SET CURRENT_SCHEMA = &METADATA_SCHEMA
/
update RESOURCE_VIEW 
   set RES = deleteXML
             (
                RES,
                '/r:Resource/r:Contents/mapping/contentType[contentType="image/jpeg"]',
                DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R
             )
 where equals_path(res,XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/xsl/XFilesMappings.xml') = 1
/
update RESOURCE_VIEW 
   set RES = insertChildXML
             (
                RES,
                '/r:Resource/r:Contents/mapping',
                'contentType',
                xmltype('<contentType>
		                       <contentType>image/jpeg</contentType>
		                       <stylesheet>/XFILES/Applications/imageMetadata/xsl/EXIFViewer.xsl</stylesheet>
                        	 <includeContent>false</includeContent>
	                       </contentType>'),
                DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R
             )
 where equals_path(res,XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/xsl/XFilesMappings.xml') = 1
/
update RESOURCE_VIEW 
   set RES = deleteXML
             (
                RES,
                '/r:Resource/r:Contents/mapping/contentType[contentType="image/pjpeg"]',
                DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R
             )
 where equals_path(res,XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/xsl/XFilesMappings.xml') = 1
/
update RESOURCE_VIEW 
   set RES = insertChildXML
             (
                RES,
                '/r:Resource/r:Contents/mapping',
                'contentType',
                xmltype('<contentType>
		                       <contentType>image/pjpeg</contentType>
		                       <stylesheet>/XFILES/Applications/imageMetadata/xsl/EXIFViewer.xsl</stylesheet>
                        	 <includeContent>false</includeContent>
	                       </contentType>'),
                DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R
             )
 where equals_path(res,XFILES_CONSTANTS.FOLDER_HOME || '/src/lite/xsl/XFilesMappings.xml') = 1
/
CREATE OR REPLACE PACKAGE IMAGE_EVENT_MANAGER
as
end;
/
CREATE OR REPLACE PACKAGE BODY IMAGE_EVENT_MANAGER
as
end;
/
call XDBPM.XDBPM_UTILITIES_INTERNAL.createHomeFolder('&METADATA_SCHEMA')
/
--
quit

