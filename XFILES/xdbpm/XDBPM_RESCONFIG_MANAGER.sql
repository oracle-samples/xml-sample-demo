
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

--
-- XDBPM_RESCONFIG_MANAGER should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_RESCONFIG_MANAGER
AUTHID CURRENT_USER
as
  function FIND_RESCONFIG_USAGE(P_RESCONFIG_PATH VARCHAR2) return XDB.XDB$STRING_LIST_T; 
  procedure REMOVE_RESCONFIG_USAGE(P_RESCONFIG_PATH VARCHAR2);
end;
/
show errors
--
create or replace synonym XDB_RESCONFIG_MANAGER for XDBPM_RESCONFIG_MANAGER
/
grant execute on XDBPM_RESCONFIG_MANAGER to public
/
create or replace package body XDBPM_RESCONFIG_MANAGER
as
--
function FIND_RESCONFIG_USAGE(P_RESCONFIG_PATH VARCHAR2) 
return XDB.XDB$STRING_LIST_T
as
  V_OBJECT_ID      RAW(16);
  V_RESOURCE_LIST  XDB$STRING_LIST_T := XDB$STRING_LIST_T();
begin
   select OBJECT_ID
    into V_OBJECT_ID
    from RESOURCE_VIEW, XDB.XDB$RESCONFIG c
   where XMLCAST(XMLQUERY('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; fn:data($RES/Resource/XMLRef)' passing RES as "RES" returning content) as REF XMLTYPE) = ref(c)
     and equals_path(RES,P_RESCONFIG_PATH) = 1;
     
  select any_path
    bulk collect into V_RESOURCE_LIST
  from RESOURCE_VIEW
 where XMLEXISTS('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
                  $RES/Resource/RCList[OID=xs:hexBinary($OBJECT_ID)]' passing RES as "RES", cast(V_OBJECT_ID as VARCHAR2(32)) as "OBJECT_ID");
                  
  return V_RESOURCE_LIST;  
end;
--
procedure REMOVE_RESCONFIG_USAGE(P_RESCONFIG_PATH VARCHAR2)
as
  V_RESOURCE_LIST XDB.XDB$STRING_LIST_T;
  cursor getResources 
  is
  select COLUMN_VALUE
    from TABLE(V_RESOURCE_LIST);
begin
  V_RESOURCE_LIST := FIND_RESCONFIG_USAGE(P_RESCONFIG_PATH);
  for r in getResources() loop
    DBMS_RESCONFIG.DELETERESCONFIG(P_RESCONFIG_PATH,r.COLUMN_VALUE);
  end loop;
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
--