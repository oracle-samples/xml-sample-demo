
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
declare
   V_XMLSCHEMA  XMLType := XMLType(
'<?xml version="1.0" encoding="UTF-8"?>
<xs:schema targetNamespace="http://xmlns.oracle.com/xdb/xfiles/wiki" xmlns="http://xmlns.oracle.com/xdb/xfiles/wiki" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xdb="http://xmlns.oracle.com/xdb" elementFormDefault="qualified" attributeFormDefault="unqualified">
	<xs:element name="XFilesWikiPage" xdb:defaultTable="XFILES_WIKI_TABLE" xdb:defaultTableSchema="&XFILES_SCHEMA">
		<xs:complexType mixed="true">
			<xs:sequence>
				<xs:any namespace="http://www.w3.org/1999/xhtml" minOccurs="0" maxOccurs="unbounded" processContents="skip"/>
			</xs:sequence>
			<xs:anyAttribute/>
		</xs:complexType>
	</xs:element>
</xs:schema>'); 

  V_SCHEMA_LOCATION_HINT VARCHAR2(1024) := 'http://xmlns.oracle.com/xdb/xfiles/XFilesWiki.xsd';

  V_SCHEMA_REGISTERED    BOOLEAN := FALSE;
  cursor registeredSchema
  is
  select schema_url
    from ALL_XML_SCHEMAS
   where schema_url = V_SCHEMA_LOCATION_HINT
     and OWNER = '&XFILES_SCHEMA';

begin
	for s in registeredSchema loop
	   V_SCHEMA_REGISTERED := TRUE;
  end loop;

  if (not V_SCHEMA_REGISTERED) then	
    dbms_xmlschema.registerSchema
    (
      schemaurl => V_SCHEMA_LOCATION_HINT
     ,schemadoc => V_XMLSCHEMA
     ,local     => FALSE
     ,genBean   => FALSE
     ,genTypes  => FALSE
     ,genTables => FALSE
     ,OPTIONS   => DBMS_XMLSCHEMA.REGISTER_BINARYXML
    );
  end if;
end;
/
--
-- ************************************************
-- *           Table Creation                   *
-- ************************************************
--
declare
  table_exists exception;
  PRAGMA EXCEPTION_INIT( table_exists , -00955 );

  V_CREATE_TABLE_DDL     VARCHAR2(4000) :=
'create table XFILES_WIKI_TABLE of XMLTYPE
XMLTYPE store as SECUREFILE BINARY XML
XMLSCHEMA "http://xmlns.oracle.com/xdb/xfiles/XFilesWiki.xsd" element "XFilesWikiPage"';

begin
  execute immediate V_CREATE_TABLE_DDL;
exception
  when table_exists  then
    null;
end;
/
begin
  dbms_xdbz.enable_hierarchy('&XFILES_SCHEMA','XFILES_WIKI_TABLE',DBMS_XDBZ.ENABLE_CONTENTS);
end;
/
grant all on XFILES_WIKI_TABLE 
          to XFILES_USER
/
--
-- ************************************************
-- *           Index Creation                   *
-- ************************************************
--
declare
  no_such_index exception;
  PRAGMA EXCEPTION_INIT( no_such_index , -01418 );
begin
  execute immediate 'drop index XFILES_WIKI_INDEX';
exception
  when no_such_index  then
    null;
end;
/
create index XFILES_WIKI_INDEX
          on XFILES_WIKI_TABLE (OBJECT_VALUE) 
             indexType is xdb.xmlIndex
                          parameters ('PATH TABLE XFILES_WIKI_PATH_TABLE')
/
-- 
-- Create the Parent Value Index on the PATH Table
--
CREATE INDEX XFILES_WIKI_PARENT_INDEX
          ON XFILES_WIKI_PATH_TABLE (RID, SYS_ORDERKEY_PARENT(ORDER_KEY))
/
--
-- Create Depth Index on the PATH Table
--
CREATE INDEX XFILES_WIKI_DEPTH_INDEX
          ON XFILES_WIKI_PATH_TABLE (RID, SYS_ORDERKEY_DEPTH(ORDER_KEY),ORDER_KEY)
/
--
