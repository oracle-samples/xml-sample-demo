
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
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
declare
  V_RESULT BOOLEAN;
begin
	if (DBMS_XDB.existsResource(XDB_METADATA_CONSTANTS.FOLDER_CATEGORIZED_IMAGES)) then
	  DBMS_XDB.deleteResource(XDB_METADATA_CONSTANTS.FOLDER_CATEGORIZED_IMAGES,DBMS_XDB.DELETE_RECURSIVE);
	end if;
  V_RESULT := DBMS_XDB.createFolder(XDB_METADATA_CONSTANTS.FOLDER_CATEGORIZED_IMAGES);
  DBMS_RESCONFIG.addResConfig(XDB_METADATA_CONSTANTS.FOLDER_CATEGORIZED_IMAGES,XDB_METADATA_CONSTANTS.RESCONFIG_IMAGE_GALLERY);
  V_RESULT := DBMS_XDB.createFolder(XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_MANUFACTURER);
  V_RESULT := DBMS_XDB.createFolder(XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_DATE_TAKEN);  
  commit;
end;
/
--
quit
