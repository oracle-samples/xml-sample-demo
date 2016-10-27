
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
create or replace package IMAGE_PROCESSOR
as

    procedure HANDLE_EVENT(P_PAYLOAD XMLType);
    procedure insertImageMetadata(P_TARGET_RESOURCE VARCHAR2);
    procedure updateImageMetadata(P_TARGET_RESOURCE VARCHAR2, P_METADATA_TARGET REF XMLType);
    procedure deleteImageMetadata(P_RESOURCE_PATH VARCHAR2);

end;
/
show errors 
--
create or replace public synonym IMAGE_PROCESSOR for IMAGE_PROCESSOR
/
--
create or replace package body IMAGE_PROCESSOR
as
--
procedure createCategoryFolder(CATEGORY_FOLDER varchar2, CATEGORY_ROOT varchar2)
as
  pragma autonomous_transaction;
  xdbResource XMLType;
begin

  -- Lock the Root of the Category Tree

  select res
    into xdbResource
    from resource_view
   where equals_path(res,CATEGORY_ROOT) = 1
     for update;
     
  -- XDB_UTILITIES.mkdir(CATEGORY_FOLDER,TRUE);
  -- XDBPM.XDBPM_DBMS_XDB.setAcl(CATEGORY_FOLDER,XDB_METADATA_CONSTANTS.ACL_CATEGORIZED_IMAGE_FOLDER);

  XDBPM.XDBPM_UTILITIES_INTERNAL.mkdir(CATEGORY_FOLDER,TRUE);
  XDBPM.XDBPM_DBMS_XDB.SETACL(CATEGORY_FOLDER,XDB_METADATA_CONSTANTS.ACL_CATEGORIZED_IMAGE_FOLDER);
  commit;
end;
--
procedure createWeakLink(TARGET_RESOURCE VARCHAR2,TARGET_FOLDER VARCHAR2,FILENAME VARCHAR2)
as
begin 
  if not XDBPM.XDBPM_DBMS_XDB.existsResource(TARGET_FOLDER || '/' || FILENAME) then
    -- XDBPM.XDBPM_DBMS_XDB.link(TARGET_RESOURCE,TARGET_FOLDER,FILENAME,DBMS_XDB.LINK_TYPE_WEAK);
    XDBPM.XDBPM_DBMS_XDB.link(TARGET_RESOURCE,TARGET_FOLDER,FILENAME,DBMS_XDB.LINK_TYPE_WEAK);
  end if;
end;
--
function extractImageMetadata(P_TARGET_RESOURCE VARCHAR2)
return XMLType
as

  METADATA             xmlSequenceType;
  METADATA_COUNT       number;

  IMAGE_METADATA       XMLType;

  CONTENT              BLOB;
  CSID                 BINARY_INTEGER;  
  
begin

  -- 
  -- Use ORDIMAGE to extract Meta data from XMLLOB
  --  
    
  -- CONTENT := XDBPM.XDBPM_DBMS_XDB.GETCONTENTBLOB(P_TARGET_RESOURCE,CSID);
  -- CONTENT := XDBPM.XDBPM_DBMS_XDB.GETCONTENTBLOB(P_TARGET_RESOURCE,CSID);

  CONTENT := XDBPM.XDBPM_UTILITIES_INTERNAL.GETLOBLOCATOR(P_TARGET_RESOURCE);
 
  if DBMS_LOB.GETLENGTH(CONTENT) > 0 then

    select xmlElement
           (
             "img:imageMetadata",
             xmlAttributes
             (
               XDB_METADATA_CONSTANTS.NAMESPACE_IMAGE_METADATA as "xmlns:img",
               XDB_NAMESPACES.EXIF_NAMESPACE as "xmlns",
               XDB_NAMESPACES.XMLINSTANCE_NAMESPACE  as "xmlns:xsi", 
               XDB_METADATA_CONSTANTS.NAMESPACE_IMAGE_METADATA || ' ' || XDB_METADATA_CONSTANTS.SCHEMAURL_IMAGE_METADATA as "xsi:schemaLocation"
             ),
             XMLAGG(value(m))
           )
      into IMAGE_METADATA
      from TABLE(ordsys.ordimage.getMetadata(CONTENT,'ALL')) m;

  end if; 

  return IMAGE_METADATA;

end;
--
procedure createWeakLinks(P_TARGET_RESOURCE VARCHAR2, IMAGE_METADATA XMLType)
as
  FILENAME       VARCHAR2(700);

  CAMERA_FOLDER  VARCHAR2(700) := NULL;
  CAMERA_MAKE    VARCHAR2(2000);
  CAMERA_MODEL   VARCHAR2(2000);

  DATE_FOLDER    VARCHAR2(700) := NULL;
  DATE_TAKEN     VARCHAR2(64);

  NODECHECK NUMBER;  
begin
  select CAMERA_MAKE, CAMERA_MODEL, DATE_TAKEN
    into CAMERA_MAKE, CAMERA_MODEL, DATE_TAKEN
    from xmltable
         (
           xmlnamespaces
           (
--           NAMESPACE_IMAGE_METADATA as "img",
--           XDB_NAMESPACES.EXIF_NAMESPACE as "exif"    
             'http://xmlns.oracle.com/xdb/metadata/ImageMetadata' as "img",
             'http://xmlns.oracle.com/ord/meta/exif' as "exif"
           ),
           '/img:imageMetadata/exif:exifMetadata'
           passing IMAGE_METADATA
           columns
           CAMERA_MAKE  varchar2(128) path 'exif:TiffIfd/exif:Make/text()',
           CAMERA_MODEL varchar2(128) path 'exif:TiffIfd/exif:Model/text()',
	         DATE_TAKEN   varchar2(128) path 'exif:ExifIfd/exif:DateTimeOriginal/text()'
	 );

  FILENAME := SUBSTR(P_TARGET_RESOURCE,INSTR(P_TARGET_RESOURCE,'/',-1)+1);  
	 
	/*
	**
	** Create the Category Folders. Use an Autonmous Transaction for each folder to reduce concurrency with other AQ Notifcation processes that may be running in parallel.
	**
	** Do not inter-mingle the autonomous transactions with other repository updates, doing so may lead to incosistant state of the heirarchical index if the containing transcation is subsequently rolled back.
	**
	*/
	
	 
  if (CAMERA_MAKE is not NULL and CAMERA_MODEL is not NULL) then
    CAMERA_FOLDER := XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_MANUFACTURER || '/' || CAMERA_MAKE ||  '/' || CAMERA_MODEL;
    createCategoryFolder(CAMERA_FOLDER, XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_MANUFACTURER);
  end if;
     
  if (DATE_TAKEN is not NULL) then
    DATE_FOLDER :=  XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_DATE_TAKEN ||'/' || SUBSTR(DATE_TAKEN,1,4)  || '/' || SUBSTR(DATE_TAKEN,6,2);
    createCategoryFolder(DATE_FOLDER, XDB_METADATA_CONSTANTS.FOLDER_IMAGES_BY_DATE_TAKEN);
  end if;    
  
  if (CAMERA_FOLDER is not NULL) then
    createWeakLink(P_TARGET_RESOURCE,CAMERA_FOLDER,FILENAME);
  end if;

  if (DATE_FOLDER is not NULL) then
    createWeakLink(P_TARGET_RESOURCE,DATE_FOLDER,FILENAME);
  end if;    

  -- XDBPM.XDBPM_DBMS_XDB.setAcl(P_TARGET_RESOURCE,XDB_METADATA_CONSTANTS.ACL_CATEGORIZED_IMAGE);
  XDBPM.XDBPM_DBMS_XDB.SETACL(P_TARGET_RESOURCE,XDB_METADATA_CONSTANTS.ACL_CATEGORIZED_IMAGE);

exception
  when no_data_found then
    null;
end;
--
procedure insertImageMetadata(P_TARGET_RESOURCE VARCHAR2)
as
  V_IMAGE_METADATA XMLType;
begin

  V_IMAGE_METADATA := extractImageMetadata(P_TARGET_RESOURCE);

  if (V_IMAGE_METADATA is not null) then

    -- 
    -- XDBPM.XDBPM_DBMS_XDB.appendResourceMetadata(P_TARGET_RESOURCE,imageMetadata);
    -- 
    
    --
    -- Workaround for the fact that XDBADMIN role and ACL evalution issues when executing in the context of an AQ Notification package
    --

    XDBPM.XDBPM_DBMS_XDB.APPENDRESOURCEMETADATA(P_TARGET_RESOURCE,V_IMAGE_METADATA);
    createWeakLinks(P_TARGET_RESOURCE,V_IMAGE_METADATA);

  end if;
  
end;
--
procedure updateImageMetadata(P_TARGET_RESOURCE VARCHAR2, P_METADATA_TARGET REF XMLType)
as
  V_IMAGE_METADATA  XMLType;
begin

  V_IMAGE_METADATA := extractImageMetadata(P_TARGET_RESOURCE);

  if (V_IMAGE_METADATA is not null) then

    -- 
    -- XDBPM.XDBPM_DBMS_XDB.appendResourceMetadata(P_TARGET_RESOURCE,imageMetadata);
    -- 
    
    --
    -- Workaround for the fact that XDBADMIN role and ACL evalution issues when executing in the context of an AQ Notification package
    --
   
    if (P_METADATA_TARGET is NULL) then
      XDBPM.XDBPM_DBMS_XDB.APPENDRESOURCEMETADATA(P_TARGET_RESOURCE,V_IMAGE_METADATA);
      createWeakLinks(P_TARGET_RESOURCE,V_IMAGE_METADATA);
    else
      XDBPM.XDBPM_DBMS_XDB.UPDATERESOURCEMETADATA(P_TARGET_RESOURCE,P_METADATA_TARGET,V_IMAGE_METADATA);
    end if;
  
  end if;
  
end;
--
procedure deleteImageMetadata(P_RESOURCE_PATH VARCHAR2)
as
  V_XML_REF REF XMLType;
begin
   
  select ref(m)
    into V_XML_REF
    from RESOURCE_VIEW r, IMAGE_METADATA_TABLE m
   where r.RESID = M.RESID
     and equals_path(res,P_RESOURCE_PATH) = 1;
 
  XDBPM.XDBPM_DBMS_XDB.deleteResourceMetadata(P_RESOURCE_PATH,V_XML_REF);
exception 
  when no_data_found then
    NULL;
end;
--
procedure HANDLE_EVENT(P_PAYLOAD XMLType)
as
  V_EVENT_TYPE        PLS_INTEGER;
  V_TARGET_RESOURCE   VARCHAR2(700);
  V_TARGET_METADATA   REF XMLType := NULL;
  
  V_INIT_TIME         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;

begin

  select xmlConcat
         (
           xmlElement("User",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement("Payload",P_PAYLOAD)
         )
    into V_PARAMETERS
    from dual;

  select EVENT_TYPE, TARGET_RESOURCE, HEXTOREF(TARGET_METADATA)
    into V_EVENT_TYPE, V_TARGET_RESOURCE, V_TARGET_METADATA
    from XMLTABLE(
           XMLNAMESPACES(
             -- XDB_NAMESPACES.RESOURCE_EVENT_PREFIX_RE as "re"
             'http://xmlns.oracle.com/xdb/pm/resourceEvent' as "re"
           ),
           '/re:EventDetail'
           passing P_PAYLOAD
           columns
             EVENT_TYPE      varchar2(4000) path 're:eventType/text()',
             TARGET_RESOURCE varchar2(4000) path 're:resourcePath/text()',
             TARGET_METADATA varchar2(4000) path 're:existingMetadata/text()'
        );
            
  CASE V_EVENT_TYPE 
    WHEN DBMS_XEVENT.POST_CREATE_EVENT THEN 
      insertImageMetadata(V_TARGET_RESOURCE);
    WHEN DBMS_XEVENT.POST_UPDATE_EVENT THEN 
      updateImageMetadata(V_TARGET_RESOURCE,V_TARGET_METADATA);
    WHEN DBMS_XEVENT.POST_UNLOCK_EVENT THEN 
      updateImageMetadata(V_TARGET_RESOURCE,V_TARGET_METADATA);
    WHEN DBMS_XEVENT.PRE_DELETE_EVENT THEN 
      deleteImageMetadata(V_TARGET_RESOURCE);
  END CASE;

  commit;
exception
  when others then
    V_STACK_TRACE := &XFILES_SCHEMA..XFILES_LOGGING.captureStackTrace();
    &XFILES_SCHEMA..XFILES_LOGGING.eventErrorRecord('&METADATA_OWNER..IMAGE_PROCESSOR' ,'HANDLE_EVENT', V_INIT_TIME, V_PARAMETERS, V_STACK_TRACE);
    rollback; 
end;
--
procedure reloadImageMetadata
as
  cursor findMissingMetadata 
  is
  select ANY_PATH
    from RESOURCE_VIEW rv
   where not exists (
           select 1 
             from XDBEXT.IMAGE_METADATA_TABLE im
            where rv.RESID = im.RESID
         )
     and XMLExists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $RES/Resource[ContentType="image/pjpeg" or ContentType="image/jpeg"]'
           passing RES as "RES"
         );
  V_IMAGE_METADATA XMLTYPE;
begin
  XDB_OUTPUT.createLogFile('/public/reloadImageMetadata.log',FALSE);
  XDB_OUTPUT.writeLogFileEntry('Processing Images.');
  XDB_OUTPUT.flushLogFile();
  for jpg in findMissingMetadata loop
    begin
      insertImageMetadata(jpg.ANY_PATH);
      XDB_OUTPUT.writeLogFileEntry('Metadata extracted for ' || jpg.ANY_PATH);
      XDB_OUTPUT.flushLogFile();
    exception
      when OTHERS then
        XDB_OUTPUT.writeLogFileEntry('Error extracting metadata for ' || jpg.ANY_PATH);
        XDB_OUTPUT.logException();
        XDB_OUTPUT.flushLogFile();
    end;
  end loop;
  XDB_OUTPUT.writeLogFileEntry('Processing Complete.');
  XDB_OUTPUT.flushLogFile();  
  commit;
end;
--
end;
/
show errors
--
GRANT EXECUTE 
   on IMAGE_PROCESSOR 
   to public;
/
quit
