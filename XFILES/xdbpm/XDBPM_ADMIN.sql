
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
-- XDBPM_ADMIN should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_ADMIN
AUTHID CURRENT_USER
as
    C_BASIC_AUTHENTICATION    constant number := 1;
    C_DIGEST_AUTHENTICATION   constant number := 2;
    C_CUSTOM_AUTHENTICATION   constant number := 4;
    
    FUNCTION BASIC_AUTHENTICATION return number deterministic;
    FUNCTION DIGEST_AUTHENTICATION return number deterministic;
    FUNCTION CUSTOM_AUTHENTICATION return number deterministic;
    
    PROCEDURE resetAuthentication(P_AUTHENTICATION NUMBER DEFAULT C_DIGEST_AUTHENTICATION);   
    procedure setDigest;
    procedure setBasic;
 
    procedure releaseDavLocks;
    procedure resetResConfigs(P_RESOURCE_PATH VARCHAR2);

end;
/
show errors
--
create or replace synonym XDB_ADMIN for XDBPM_ADMIN
/
grant execute on XDBPM_ADMIN to XDBADMIN
/
create or replace package body XDBPM_ADMIN
as
FUNCTION BASIC_AUTHENTICATION 
return number deterministic
as
begin
  return C_BASIC_AUTHENTICATION;
end;
--
FUNCTION DIGEST_AUTHENTICATION 
return number deterministic
as
begin
  return C_DIGEST_AUTHENTICATION;
end;
--
FUNCTION CUSTOM_AUTHENTICATION 
return number deterministic
as
begin
  return C_CUSTOM_AUTHENTICATION;
end;
--
PROCEDURE resetAuthentication(P_AUTHENTICATION NUMBER DEFAULT C_DIGEST_AUTHENTICATION)
as
  V_CONFIG  XMLTYPE := DBMS_XDB.cfg_get();
  V_SNIPPET XMLTYPE;
begin

  select deletexml(
           V_CONFIG,
           '/cfg:xdbconfig/cfg:sysconfig/cfg:protocolconfig/cfg:httpconfig/cfg:authentication/cfg:allow-mechanism',
           'xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
         )
    into V_CONFIG
    from DUAL;
    
                
  if (P_AUTHENTICATION = C_BASIC_AUTHENTICATION) then
    V_SNIPPET := XMLTYPE('<allow-mechanism xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">basic</allow-mechanism>');
    select insertChildXML(
             V_CONFIG, 
             '/cfg:xdbconfig/cfg:sysconfig/cfg:protocolconfig/cfg:httpconfig/cfg:authentication',
             'allow-mechanism',
             V_SNIPPET,
             'xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_CONFIG
      from dual;
  end if;

  if (P_AUTHENTICATION = C_DIGEST_AUTHENTICATION) then
    V_SNIPPET := XMLTYPE('<allow-mechanism xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">digest</allow-mechanism>');
    select insertChildXML(
             V_CONFIG, 
             '/cfg:xdbconfig/cfg:sysconfig/cfg:protocolconfig/cfg:httpconfig/cfg:authentication',
             'allow-mechanism',
             V_SNIPPET,
           'xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_CONFIG
      from dual;
  end if;

  if (P_AUTHENTICATION = C_BASIC_AUTHENTICATION + C_DIGEST_AUTHENTICATION) then
    V_SNIPPET := XMLTYPE('<allow-mechanism xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">digest</allow-mechanism>');
    select insertChildXML(
             V_CONFIG, 
             '/cfg:xdbconfig/cfg:sysconfig/cfg:protocolconfig/cfg:httpconfig/cfg:authentication',
             'allow-mechanism',
             V_SNIPPET,
             'xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_CONFIG
      from dual;
    V_SNIPPET := XMLTYPE('<allow-mechanism xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">basic</allow-mechanism>');
    select insertChildXML(
             V_CONFIG, 
             '/cfg:xdbconfig/cfg:sysconfig/cfg:protocolconfig/cfg:httpconfig/cfg:authentication',
             'allow-mechanism',
             V_SNIPPET,
             'xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_CONFIG
      from dual;

  end if;

  DBMS_XDB.cfg_update(V_CONFIG);

end;
--
procedure setDigest 
as 
begin
	 resetAuthentication(DIGEST_AUTHENTICATION);
end;
--
procedure setBasic
as 
begin
	 resetAuthentication(BASIC_AUTHENTICATION);
end;
--
procedure releaseDavLocks
as
begin 
    XDBPM_SYSDBA_INTERNAL.releaseDavLocks;
end; 
--
procedure RESETRESCONFIGS(P_RESOURCE_PATH VARCHAR2) 
as
  V_RESID RAW(16);
begin
	select RESID
	  into V_RESID
	  from RESOURCE_VIEW rv,
	       XMLTable(
           'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList/OID'
           passing rv.RES as "R"
           columns
             RESCONFIG_ID RAW(16) path '.'
         ) rce
	 where equals_path(rv.RES,P_RESOURCE_PATH) = 1
     and XMLEXists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $R/Resource/RCList' 
           passing rv.RES as "R"
         )
     and not exists (SELECT 1 from XDB.XDB$RESCONFIG rc where RESCONFIG_ID = RC.OBJECT_ID);
   DBMS_OUTPUT.put_line('Processing : ' || V_RESID);
   XDBPM_SYSDBA_INTERNAL.resetResConfigs(V_RESID);
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/