
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
-- XDBPM_DOM_UTILITIES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_DOM_UTILITIES
authid CURRENT_USER
as
  function boolean_to_varchar(input boolean) return varchar2 deterministic;
  function raw_to_varchar(input raw) return varchar2 deterministic;
  function varchar_to_boolean(input varchar2) return boolean deterministic;
  function raw_to_boolean(input raw) return boolean deterministic;
  function boolean_to_raw(input boolean) return raw deterministic;
  function varchar_to_raw(input varchar2) return raw deterministic;
  function getTextNodeValue(parent DBMS_XMLDOM.DOMELEMENT,child varchar2) return varchar2 deterministic;
  function getBooleanValue(parent DBMS_XMLDOM.DOMELEMENT,child varchar2) return raw deterministic;
end;
/
show errors
--
create or replace synonym XDB_DOM_UTILITIES for XDBPM_DOM_UTILITIES
/
grant execute on XDBPM_DOM_UTILITIES to public
/
create or replace package body XDBPM_DOM_UTILITIES
as
function raw_to_varchar(input raw)
return varchar2 deterministic
is
begin
  if (input = hexToRaw('01')) then
    return 'TRUE';
  end if;
  if (input = hexToRaw('00')) then
    return 'FALSE';
  end if;
  return NULL;
end;
--
function boolean_to_varchar(input boolean)
return varchar2 deterministic
is
begin
  if (input = TRUE) then
    return 'TRUE';
  end if;
  if (input = FALSE) then
    return 'FALSE';
  end if;
  return NULL;
end;
--
function varchar_to_raw(input varchar2)
return raw deterministic
is
begin
  if (upper(input) in ('TRUE','Y','YES','1')) then
    return hexToRaw('01');
  end if;
  if (upper(input) in ('FALSE','N','NO','0')) then
    return hexToRaw('00');
  end if;
  return NULL;
end;
--
function boolean_to_raw(input boolean)
return raw deterministic
is
begin
  if (input = TRUE) then
    return hexToRaw('01');
  end if;
  if (input = FALSE) then
    return hexToRaw('00');
  end if;
  return NULL;
end;
--
function varchar_to_boolean(input varchar2)
return boolean deterministic
is
begin
  if (upper(input) in ('TRUE','Y','YES','1')) then
    return TRUE;
  end if;
  if (upper(input) in ('FALSE','N','NO','0')) then
    return FALSE;
  end if;
  return NULL;
end;
--
function raw_to_boolean(input raw)
return boolean deterministic
is
begin
  if (input = hexToRaw('01')) then
    return TRUE;
  end if;
  if (input = hexToRaw('00')) then
    return FALSE;
  end if;
  return NULL;
end;
--
function getBooleanValue(parent DBMS_XMLDOM.DOMELEMENT,child varchar2)
return raw deterministic
as
begin
  return varchar_to_raw(getTextNodeValue(parent,child));
end;
--
function getTextNodeValue(parent DBMS_XMLDOM.DOMELEMENT,child varchar2)
return varchar2 deterministic
as
  nodeList      DBMS_XMLDOM.DOMNODELIST;
  childNode     DBMS_XMLDOM.DOMNODE;
  value         varchar2(2048) := null;
begin
  nodeList := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(parent,child);
  if (dbms_xmldom.getlength(nodeList) > 0) then
    childNode := DBMS_XMLDOM.ITEM(nodeList,0);
    childNode := DBMS_XMLDOM.GETFIRSTCHILD(childNode);
    value     := DBMS_XMLDOM.GETNODEVALUE(childNode);
  end if;
  return value;
end;
--
end XDBPM_DOM_UTILITIES;
/
--
show errors
--
alter session set current_schema = SYS
/
--