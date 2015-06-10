
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
set echo on
--
-- XDBPM_DATAGUIDE_SEARCH should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_DATAGUIDE_SEARCH
authid CURRENT_USER 
as
  function getDataGuideNodeMap(P_TABLE_NAME VARCHAR2, P_COLUMN_NAME VARCHAR2) return XMLTYPE;
end;
/
show errors
--
create or replace synonym XDB_DATAGUIDE_SEARCH for XDBPM_DATAGUIDE_SEARCH
/
grant execute on XDBPM_DATAGUIDE_SEARCH to public
/
create or replace package body XDBPM_DATAGUIDE_SEARCH
as
--
function getDataGuideNodeMap(P_TABLE_NAME VARCHAR2, P_COLUMN_NAME VARCHAR2) return XMLTYPE
as
begin
  return XMLTYPE('<srch:NodeMap xmlns:srch="http://xmlns.oracle.com/xdb/pm/demo/search"><srch:Element ID="1"><srch:Name>DataGuide</srch:Name><srch:Elements/></srch:Element></srch:NodeMap>');
end;
--
end;
/
show errors
/

    