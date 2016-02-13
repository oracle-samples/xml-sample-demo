
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "as IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
create or replace package XDBPM_RV_HELPER
AUTHID &RIGHTS
as
  procedure deleteResource(P_RESOURCE_PATH VARCHAR2);
  procedure deleteResource(P_XMLREF REF XMLType);

  function existsResource(P_RESOURCE_PATH VARCHAR2) return BOOLEAN;
  function existsResource(P_XMLREF REF XMLType) return BOOLEAN;
  --
end;
/
show errors 
--
create or replace package body XDBPM_RV_HELPER
as
procedure deleteResource(P_RESOURCE_PATH VARCHAR2)
as
begin
 
  delete 
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <unlink-from/>
             </privilege>'
           )
         ) = 1;

end;
--
procedure deleteResource(P_XMLREF REF XMLType)
as
begin
 
  delete 
    from RESOURCE_VIEW
   where extractValue(res,'/Resource/XMLRef') = P_XMLREF
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <unlink-from/>
             </privilege>'
           )
         ) = 1;

end;  
--
function existsResource(P_RESOURCE_PATH VARCHAR2)
return BOOLEAN
as
  V_RESULT BOOLEAN := FALSE;
  V_TEMP   NUMBER;
begin
	select 1
	  into V_TEMP
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <read-properties/>
              <read-content/>
             </privilege>'
           )
         ) = 1;
  return TRUE;
exception
  when no_data_found then
    return FALSE;
  when others then
     RAISE;
end;
--
function existsResource(P_XMLREF REF XMLType)
return BOOLEAN
as
  V_RESULT BOOLEAN := FALSE;
  V_TEMP   NUMBER;
begin
	select 1
	  into V_TEMP
    from RESOURCE_VIEW
   where extractValue(res,'/Resource/XMLRef') = P_XMLREF
     and sys_checkacl
         (
           extractValue(res,'/Resource/ACLOID/text()'),
           extractValue(res,'/Resource/OwnerID/text()'),
           XMLTYPE
           (
             '<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                         xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">
              <read-properties/>
              <read-content/>
             </privilege>'
           )
         ) = 1;
  return TRUE;
exception
  when no_data_found then
    return FALSE;
  when others then
     RAISE;
end;
--
end;
/
show errors
--
create or replace package XDBPM_RESCONFIG_HELPER
AUTHID &RIGHTS
as
  function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) return VARCHAR2;
end;
/
show errors
--
create or replace package body XDBPM_RESCONFIG_HELPER
as
function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
return VARCHAR2
as
  V_UPLOAD_FOLDER_PATH VARCHAR2(700);
begin
  select ANY_PATH 
    into V_UPLOAD_FOLDER_PATH
	  from RESOURCE_VIEW rv, 
	       XDB.XDB$RESCONFIG cfg,
	       XDB.XDB$RESOURCE r,
	       TABLE(r.XMLDATA.RCLIST.OID) rc
	 where rv.RESID = r.OBJECT_ID
	   and rc.COLUMN_VALUE = cfg.OBJECT_ID
	   and XMLExists
         (
           'declare namespace rc = "http://xmlns.oracle.com/xdb/XDBResConfig.xsd"; (::)
            declare namespace tu = "http:/xmlns.oracle.com/xdb/pm/tableUpload"; (::)
            $RC/rc:ResConfig/rc:applicationData/tu:Target[tu:Owner=$OWNER and tu:Table=$TABLE]'
            passing cfg.OBJECT_VALUE as "RC", P_OWNER as "OWNER", P_TABLE_NAME as "TABLE"
         );
         
  return V_UPLOAD_FOLDER_PATH;
end;
--
end;
/
show errors
--
