
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
def OWNER = &1
--
alter session set CURRENT_SCHEMA = &OWNER
/
create or replace package ENABLE_IMAGE_GALLERY
authid CURRENT_USER
as
  procedure handlePostLinkTo(P_EVENT dbms_xevent.XDBRepositoryEvent);
end;
/
show errors
--
set define off
--
create or replace package body ENABLE_IMAGE_GALLERY
as    
-- 
procedure handlePostLinkTo(P_EVENT dbms_xevent.XDBRepositoryEvent)
as
  V_RESOURCE_PATH     VARCHAR2(700);
  V_METADATA          XMLTYPE;
  V_VIEWER_PATH       VARCHAR2(200) := XDB_METADATA_CONSTANTS.XSL_IMAGE_GALLERY;
  V_NAMESPACE         VARCHAR2(200) := 'xmlns="' || XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER || '"';
begin
	
	V_RESOURCE_PATH     := DBMS_XEVENT.getName(DBMS_XEVENT.getPath(P_EVENT));  
	
  select XMLElement( 
           evalname(XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER),
           xmlAttributes(
             XFILES_CONSTANTS.NAMESPACE_XFILES as "xmlns",
             'getFolderWithMetadata' as "method"
           ),
           V_VIEWER_PATH
         )
    into V_METADATA
    from DUAL;
   
  DBMS_XDB.deleteResourceMetadata(V_RESOURCE_PATH,XFILES_CONSTANTS.NAMESPACE_XFILES,XFILES_CONSTANTS.ELEMENT_CUSTOM_VIEWER);
  DBMS_XDB.appendResourceMetadata(V_RESOURCE_PATH,V_METADATA);
   
end;   
--
end;
/
show errors
--
--
  -- Remove Resource configurations from any documents that are protected by the Resource Configuration 
--
declare
  cursor getResConfigUsage(C_RESCONFIG_PATH VARCHAR2)
  is             
  select RV.ANY_PATH RESOURCE_PATH
    from RESOURCE_VIEW RV, RESOURCE_VIEW rcrv,
         XMLTable(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             OBJECT_ID RAW(16) path '.'
         ) rce
   where equals_path(rcrv.RES,C_RESCONFIG_PATH) = 1
     and SYS_OP_R2O(
           XMLCast(
             XMLQuery(
              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
               fn:data($RES/Resource/XMLRef)'
               passing rcrv.RES as "RES"
               returning content
             ) as REF XMLType
           )
         ) = rce.OBJECT_ID
     and XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList' 
           passing rv.RES as "R"
         );
begin
  for r in getResConfigUsage(XDB_METADATA_CONSTANTS.RESCONFIG_IMAGE_GALLERY) loop
    DBMS_RESCONFIG.deleteResConfig(r.RESOURCE_PATH,XDB_METADATA_CONSTANTS.RESCONFIG_IMAGE_GALLERY,DBMS_RESCONFIG.DELETE_RESOURCE );
  end loop;
  commit;
end;
/
set define on
--
GRANT EXECUTE 
   on ENABLE_IMAGE_GALLERY 
   to public;
/
grant INHERIT PRIVILEGES 
   on user SYSTEM 
   to &OWNER
/
quit


