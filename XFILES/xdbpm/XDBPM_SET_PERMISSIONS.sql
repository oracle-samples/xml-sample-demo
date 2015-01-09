
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
 * ================================================ */

--
grant XDBADMIN to XDBPM
/
grant RESOURCE to XDBPM
/
grant CREATE ANY DIRECTORY to XDBPM
/
grant UNLIMITED TABLESPACE to XDBPM
/
grant SELECT ANY DICTIONARY to XDBPM
/
grant execute on SYS.DBMS_SYSTEM to XDBPM
/
--
-- Explicit grants on XDB Owned objects. Requires use of USER SYSTEM or SYSDBA connection.
-- WITH GRANT OPTION is explicitly not provided to ROLE DBA on these objects.
--
grant all on XDB.XDB$RESOURCE       to XDBPM
/
grant all on XDB.XDB$NLOCKS         to XDBPM
/
grant all on XDB.XDB$CHECKOUTS      to XDBPM
/
grant all on XDB.XDB$ROOT_INFO      to XDBPM
/
grant all on XDB.XDB$SCHEMA         to XDBPM
/
grant all on XDB.XDB$COMPLEX_TYPE   to XDBPM
/
grant all on XDB.XDB$ELEMENT        to XDBPM
/
grant all on XDB.XDB$ANY            to XDBPM
/
grant all on XDB.XDB$ATTRIBUTE      to XDBPM
/
grant all on XDB.XDB$ANYATTR        to XDBPM
/
set define on
--
@@&XDBPM_12100_PERMISSIONS
--