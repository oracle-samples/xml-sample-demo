
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
spool deinstall.log APPEND
--
-- Delete the any Global XML Schema that defines IMAGE_METADATA_TABLE
--
-- May need to add code to remove all refs to the rows in this table.
--
DEF METADATA_OWNER = &1
--
set serveroutput on
--
declare
  table_does_not_exist exception;
  PRAGMA EXCEPTION_INIT( table_does_not_exist , -942 );
  
  cursor getXMLSchemas
  is
  select /*+ NO_XML_QUERY_REWRITE */ QUAL_SCHEMA_URL, OWNER
    from DBA_XML_SCHEMAS
   where XMLExists
         (
            'declare namespace xsd = "http://www.w3.org/2001/XMLSchema"; (: :)
             declare namespace xdb = "http://xmlns.oracle.com/xdb"; (: :)
             $s/xsd:schema/xsd:element[@xdb:defaultTable="IMAGE_METADATA_TABLE"]'
             passing schema as "s"
         )
     and LOCAL = 'NO'
     and SCHEMA_URL <> &METADATA_OWNER..XDB_METADATA_CONSTANTS.SCHEMAURL_IMAGE_METADATA;
     
begin
  for s in getXMLSchemas loop
    dbms_output.put_line('Deleting Global XML Schema ' || s.qual_schema_url || '. Owner = ' || s.OWNER);
    execute immediate 'alter session set current_schema = ' || s.OWNER;
    dbms_xmlschema.deleteSchema
    (
       s.QUAL_SCHEMA_URL,
       dbms_xmlschema.DELETE_CASCADE_FORCE
    );
  end loop;
end;
/
set serveroutput off
--
quit
