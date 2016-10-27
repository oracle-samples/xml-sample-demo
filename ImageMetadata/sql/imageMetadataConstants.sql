
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
DEF METADATA_OWNER = &1
--
DEF EVENT_RESCONFIG = &2
--
DEF GALLERY_RESCONFIG = &3
--
create or replace package XDB_METADATA_CONSTANTS
as

  C_NAMESPACE_IMAGE_METADATA       constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB || '/metadata/ImageMetadata';
  C_SCHEMAURL_IMAGE_METADATA       constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB || '/metadata/ImageMetadata.xsd';
  C_NSPREFIX_IMAGE_METADATA_IMG    constant VARCHAR2(128) := 'xmlns:img="' || C_NAMESPACE_IMAGE_METADATA || '"';

  C_NSMAPPINGS_IMAGE_METADATA      constant VARCHAR2(256) := XDB_NAMESPACES.RESOURCE_PREFIX_R || ' ' || XDB_NAMESPACES.EXIF_PREFIX_EXIF || ' ' || C_NSPREFIX_IMAGE_METADATA_IMG;

  C_FOLDER_IMAGE_METADATA          constant VARCHAR2(700) := XDB_CONSTANTS.FOLDER_HOME || '/' || '&METADATA_OWNER' || '/' || 'imageMetadata';
  C_RESCONFIG_IMAGE_METADATA       constant VARCHAR2(700) := '&EVENT_RESCONFIG';
  C_RESCONFIG_IMAGE_GALLERY        constant VARCHAR2(700) := '&GALLERY_RESCONFIG';
  
  C_ACL_CATEGORIZED_IMAGE_FOLDER   constant VARCHAR2(700) := XDB_CONSTANTS.FOLDER_SYSTEM_ACLS || '/' || 'categorized_image_folder_acl.xml';
  C_ACL_CATEGORIZED_IMAGE          constant VARCHAR2(700) := XDB_CONSTANTS.FOLDER_SYSTEM_ACLS || '/' || 'categorized_image_acl.xml';
  
  
  C_PATH_CATEGORIZED_CONTENT       constant VARCHAR2(700) := XDB_CONSTANTS.FOLDER_PUBLIC || '/categorization'; 
  C_PATH_CATEGORIZED_IMAGES        constant VARCHAR2(700) := C_PATH_CATEGORIZED_CONTENT  || '/images'; 
  C_PATH_IMAGES_BY_MANUFACTURER    constant VARCHAR2(700) := C_PATH_CATEGORIZED_IMAGES   || '/manufacturer'; 
  C_PATH_IMAGES_BY_DATE_TAKEN      constant VARCHAR2(700) := C_PATH_CATEGORIZED_IMAGES   || '/dateTaken'; 

  C_PATH_XSL_IMAGE_GALLERY         constant VARCHAR2(700) := XFILES_CONSTANTS.FOLDER_APPLICATIONS_PUBLIC   || '/imageMetadata/xsl/ImageGallery.xsl'; 

  function FOLDER_IMAGE_METADATA        return VARCHAR2 deterministic;
  function RESCONFIG_IMAGE_METADATA     return VARCHAR2 deterministic;
  function RESCONFIG_IMAGE_GALLERY      return VARCHAR2 deterministic;

  function NAMESPACE_IMAGE_METADATA     return VARCHAR2 deterministic;
  function SCHEMAURL_IMAGE_METADATA     return VARCHAR2 deterministic;
  function NSPREFIX_IMAGE_METADATA_IMG  return VARCHAR2 deterministic;
  function NSMAPPINGS_IMAGE_METADATA    return VARCHAR2 deterministic;

  function FOLDER_CATEGORIZED_CONTENT     return VARCHAR2 deterministic;
  function FOLDER_CATEGORIZED_IMAGES      return VARCHAR2 deterministic;
  function FOLDER_IMAGES_BY_MANUFACTURER  return VARCHAR2 deterministic;
  function FOLDER_IMAGES_BY_DATE_TAKEN    return VARCHAR2 deterministic;

  function ACL_CATEGORIZED_IMAGE          return VARCHAR2 deterministic;
  function ACL_CATEGORIZED_IMAGE_FOLDER   return VARCHAR2 deterministic;

  function XSL_IMAGE_GALLERY              return VARCHAR2 deterministic;

end;
/
show errors
--
grant execute on XDB_METADATA_CONSTANTS to public
/
create or replace public synonym XDB_METADATA_CONSTANTS for XDB_METADATA_CONSTANTS
/
create or replace package body XDB_METADATA_CONSTANTS
as
  function NAMESPACE_IMAGE_METADATA       return VARCHAR2 deterministic as begin return C_NAMESPACE_IMAGE_METADATA;  end;
  function SCHEMAURL_IMAGE_METADATA       return VARCHAR2 deterministic as begin return C_SCHEMAURL_IMAGE_METADATA; end;
  function NSPREFIX_IMAGE_METADATA_IMG    return VARCHAR2 deterministic as begin return C_NSPREFIX_IMAGE_METADATA_IMG; end;
  function NSMAPPINGS_IMAGE_METADATA      return VARCHAR2 deterministic as begin return C_NSMAPPINGS_IMAGE_METADATA; end;

  function FOLDER_IMAGE_METADATA          return VARCHAR2 deterministic as begin return C_FOLDER_IMAGE_METADATA; end;
  function RESCONFIG_IMAGE_METADATA       return VARCHAR2 deterministic as begin return C_RESCONFIG_IMAGE_METADATA; end;
  function RESCONFIG_IMAGE_GALLERY        return VARCHAR2 deterministic as begin return C_RESCONFIG_IMAGE_GALLERY; end;

  function FOLDER_CATEGORIZED_CONTENT     return VARCHAR2 deterministic as begin return C_PATH_CATEGORIZED_CONTENT;  end;
  function FOLDER_CATEGORIZED_IMAGES      return VARCHAR2 deterministic as begin return C_PATH_CATEGORIZED_IMAGES;  end;
  function FOLDER_IMAGES_BY_MANUFACTURER  return VARCHAR2 deterministic as begin return C_PATH_IMAGES_BY_MANUFACTURER;  end;
  function FOLDER_IMAGES_BY_DATE_TAKEN    return VARCHAR2 deterministic as begin return C_PATH_IMAGES_BY_DATE_TAKEN;  end;

  function ACL_CATEGORIZED_IMAGE          return VARCHAR2 deterministic as begin return C_ACL_CATEGORIZED_IMAGE;  end;
  function ACL_CATEGORIZED_IMAGE_FOLDER   return VARCHAR2 deterministic as begin return C_ACL_CATEGORIZED_IMAGE_FOLDER;  end;
  
  function XSL_IMAGE_GALLERY              return VARCHAR2 deterministic as begin return C_PATH_XSL_IMAGE_GALLERY;  end;
  
end;
/
show errors
--
quit
