
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
DEF SCHEMA_LOCATION = &1
--
declare

  V_SCHEMA_REGISTERED    BOOLEAN := FALSE;
  cursor registeredSchema
  is
  select schema_url
    from USER_XML_SCHEMAS
   where schema_url = XDB_METADATA_CONSTANTS.SCHEMAURL_IMAGE_METADATA;

begin
	for s in registeredSchema loop
	   V_SCHEMA_REGISTERED := TRUE;
  end loop;

  if (not V_SCHEMA_REGISTERED) then
    dbms_xmlschema.registerSchema
    (
      schemaURL       => XDB_METADATA_CONSTANTS.SCHEMAURL_IMAGE_METADATA,
      schemaDoc       => xdbURIType('&SCHEMA_LOCATION').getClob(),
      local           => FALSE,
      genTypes        => TRUE,
      genTables       => TRUE,
      enableHierarchy => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA
    ); 
  end if;
end;
/
create or replace public synonym IMAGE_METADATA_TABLE 
                             for IMAGE_METADATA_TABLE
/
grant select,insert,update,delete 
   on IMAGE_METADATA_TABLE 
   to public
/
create or replace public synonym DICOM_METADATA_TABLE 
                             for DICOM_METADATA_TABLE
/
grant select,insert,update,delete 
   on DICOM_METADATA_TABLE 
   to public
/
create or replace public synonym EXIF_METADATA_TABLE 
                             for EXIF_METADATA_TABLE
/
grant select,insert,update,delete 
   on EXIF_METADATA_TABLE 
   to public
/
create or replace public synonym IPTC_METADATA_TABLE 
                             for IPTC_METADATA_TABLE
/
grant select,insert,update,delete 
   on IPTC_METADATA_TABLE 
   to public
/
create or replace public synonym ORDIMAGE_METADATA_TABLE 
                             for ORDIMAGE_METADATA_TABLE
/
grant select,insert,update,delete 
   on ORDIMAGE_METADATA_TABLE 
   to public
/
create or replace public synonym XMP_METADATA_TABLE 
                             for XMP_METADATA_TABLE
/
grant select,insert,update,delete 
   on XMP_METADATA_TABLE 
   to public
/
--
quit
