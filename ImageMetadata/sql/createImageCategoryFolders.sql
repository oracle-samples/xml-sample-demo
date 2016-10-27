
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
set serveroutput on
--
-- Look for resources with a RESCONFIG that will result in a dangling REF. This can arise if earlier versions of this demo were installed in the 
-- target database.
--      
select rv.ANY_PATH, rv.RESID, RESCONFIG_ID
  from RESOURCE_VIEW rv,
       XMLTable(
        'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
         $R/Resource/RCList/OID'
         passing rv.RES as "R"
         columns
           RESCONFIG_ID RAW(16) path '.'
       ) rce
 where XMLEXists(
        'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
         $R/Resource/RCList/OID' 
         passing rv.RES as "R"
       )
   and not exists (SELECT 1 from XDB.XDB$RESCONFIG rc where RCE.RESCONFIG_ID = RC.OBJECT_ID)
/
--
-- Remove RESCONFIG list from Resources with a RESCONFIG that will result in a dangling REF
--      
declare
  cursor getResourceList 
  is
  select rv.ANY_PATH
    from RESOURCE_VIEW rv,
         XMLTable(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             OBJECT_ID RAW(16) path '.'
         ) rce
   where XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID' 
           passing rv.RES as "R"
         )
     and not exists (SELECT 1 from XDB.XDB$RESCONFIG rc where RCE.OBJECT_ID = RC.OBJECT_ID);
begin
  for r in getResourceList() loop
    DBMS_OUTPUT.put_line('Processing : ' || r.ANY_PATH);
    /*
      update RESOURCE_VIEW
	       set RES = deleteXML(RES,'/Resource/RCList')
       where equals_path(RES,r.ANY_PATH) = 1;
    */
    XDB_ADMIN.resetResConfigs(r.ANY_PATH);
  end loop;
  commit;
end;
/
--
-- Verify Cleanup was successful. The following query should return no rows.
--
select rv.ANY_PATH, rv.RESID, RESCONFIG_ID
  from RESOURCE_VIEW rv,
       XMLTable(
        'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
         $R/Resource/RCList/OID'
         passing rv.RES as "R"
         columns
           RESCONFIG_ID RAW(16) path '.'
       ) rce
 where XMLEXists(
        'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
         $R/Resource/RCList/OID' 
         passing rv.RES as "R"
       )
   and not exists (SELECT 1 from XDB.XDB$RESCONFIG rc where RCE.RESCONFIG_ID = RC.OBJECT_ID)
/
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
