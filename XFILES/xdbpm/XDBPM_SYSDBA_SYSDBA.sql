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

grant INHERIT PRIVILEGES on user SYS to XDBPM
/
grant INHERIT PRIVILEGES on user SYSTEM to XDBPM
/
grant INHERIT PRIVILEGES on user XDB to XDBPM
/
grant execute on SYS.DBMS_SYSTEM to XDBPM
/
alter session set current_schema = XDBPM
/
grant delete on XDB.XDB$SCHEMA         to XDBPM
/
grant delete on XDB.XDB$ANY            to XDBPM
/
grant delete on XDB.XDB$ALL_MODEL      to XDBPM
/
grant delete on XDB.XDB$ANYATTR        to XDBPM
/
grant delete on XDB.XDB$ATTRGROUP_DEF  to XDBPM
/
grant delete on XDB.XDB$ATTRGROUP_REF  to XDBPM
/
grant delete on XDB.XDB$ATTRIBUTE      to XDBPM
/
grant delete on XDB.XDB$CHOICE_MODEL   to XDBPM
/
grant delete on XDB.XDB$COMPLEX_TYPE   to XDBPM
/
grant delete on XDB.XDB$ELEMENT        to XDBPM
/
grant delete on XDB.XDB$GROUP_DEF      to XDBPM
/
grant delete on XDB.XDB$GROUP_REF      to XDBPM
/
grant delete on XDB.XDB$SEQUENCE_MODEL to XDBPM
/
--
-- Explicit grants on XDB Owned objects. Requires use of USER SYSTEM or SYSDBA connection.
-- WITH GRANT OPTION is explicitly not provided to ROLE DBA on these objects.
--
grant update on XDB.XDB$RESOURCE       to XDBPM
/
grant delete on XDB.XDB$NLOCKS         to XDBPM
/
grant update on XDB.XDB$ROOT_INFO      to XDBPM
/
