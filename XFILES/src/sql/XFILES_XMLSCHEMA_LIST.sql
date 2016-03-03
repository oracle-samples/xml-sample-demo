
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
create or replace view XMLSCHEMA_LIST of XMLTYPE
with object id(
  'XMLSCHMEA_LIST'
)
as 
select xmlElement(
         "schemaList",
         ( 
           select xmlElement(
                    "localSchemas",
                    xmlAgg(
                      xmlElement(
                        "localSchema",
                        xmlElement("URL",SCHEMA_URL),
                        xmlElement("OWNER",OWNER),
                        xmlElement("schemaType",HIER_TYPE),
                        xmlElement(
                          "globalElements",
                          xmlAgg(
                            xmlElement(
                              "globalElement",
                         	    xmlAttributes(
                                TABLE_NAME as "defaultTable",
                                TABLE_OWNER as "defaultTableOwner"
                              ),
                              ELEMENT_NAME
                            )
                          )
                        )   
                      )
                    )
                  )
             from all_xml_schemas, 
                  XMLTable(
                    xmlNamespaces(
                      'http://www.w3.org/2001/XMLSchema' as "xs",
                      'http://xmlns.oracle.com/xdb' as "xdb"
                    ),
                    '/xs:schema/xs:element[@xdb:defaultTable]'
                    passing SCHEMA
                    columns
                      ELEMENT_NAME varchar2(256) path '@name',
                      TABLE_NAME   varchar2(32)  path '@xdb:defaultTable',
                      TABLE_OWNER  varchar2(32)  path '@xdb:defaultTableSchema'
                  )
            where local = 'YES' 
              and TABLE_NAME  is not null
              and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBSchema.xsd'
              and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBResource.xsd'
       	    group by OWNER, HIER_TYPE, SCHEMA_URL
         ),
         (
           select xmlElement(
                    "globalSchemas",
                    xmlAgg(
                      xmlElement(
                        "globalSchema",
                        xmlElement("URL",SCHEMA_URL),
                        xmlElement("OWNER",OWNER),
                        xmlElement("schemaType",HIER_TYPE),
                        xmlElement(
                          "globalElements",
                          xmlAgg(
                            xmlElement(
                              "globalElement",
                         	    xmlAttributes(
                                TABLE_NAME as "defaultTable",
                                TABLE_OWNER as "defaultTableOwner"
                              ),
                              ELEMENT_NAME
                            )
                          )
                        )   
                      )
                    )
                  )
             from all_xml_schemas, 
                  XMLTable(
                    xmlNamespaces(
                      'http://www.w3.org/2001/XMLSchema' as "xs",
                      'http://xmlns.oracle.com/xdb' as "xdb"
                    ),
                    '/xs:schema/xs:element[@xdb:defaultTable]'
                    passing SCHEMA
                    columns
                      ELEMENT_NAME varchar2(256) path '@name',
                      TABLE_NAME   varchar2(32)  path '@xdb:defaultTable',
                      TABLE_OWNER  varchar2(32)  path '@xdb:defaultTableSchema'
                  )
            where local = 'NO' 
              and TABLE_NAME  is not null
              and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBSchema.xsd'
              and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBResource.xsd'
       	    group by OWNER, HIER_TYPE, SCHEMA_URL
         )
       ) 
  from dual
/
create or replace trigger XMLSCHEMA_LIST_DML
instead of INSERT or UPDATE or DELETE on XMLSCHEMA_LIST
begin
 null;
end;
/
grant select on XMLSCHEMA_LIST 
             to XFILES_USER
/
create or replace view XMLSCHEMA_OBJECT_LIST of XMLTYPE
with object id(
  'XMLSCHEMA_OBJECT_LIST'
)
as 
select xmlElement(
         "xmlObjectList",
         xmlAttributes(SYS_CONTEXT ('USERENV', 'SESSION_USER') as "currentUser"),
         xmlAgg(
           xmlElement(
             "xmlObject",
             xmlElement("owner",TABLE_OWNER),
             xmlElement("tableName",TABLE_NAME),
             xmlElement("column",COLUMN_NAME),
             xmlElement("schemaOwner",SCHEMA_OWNER),
             xmlElement("schemaLocationHint",SCHEMA_URL),
             xmlElement("elementName",ELEMENT_NAME),
             xmlElement("schemaType",HIER_TYPE)
           )
         )
       )
  from (
   select OWNER TABLE_OWNER, TABLE_NAME TABLE_NAME, 'OBJECT_VALUE' COLUMN_NAME, SCHEMA_OWNER, XMLSCHEMA SCHEMA_LOCATION_HINT, ELEMENT_NAME
     from ALL_XML_TABLES 
    where XMLSCHEMA is not NULL
   union all
   select OWNER, TABLE_NAME, COLUMN_NAME, SCHEMA_OWNER, XMLSCHEMA, ELEMENT_NAME
     from ALL_XML_TAB_COLS
    where XMLSCHEMA is not null
       ) xo, ALL_XML_SCHEMAS axs
 where SCHEMA_URL = SCHEMA_LOCATION_HINT
   and OWNER      = SCHEMA_OWNER
   and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBSchema.xsd'
   and SCHEMA_URL != 'http://xmlns.oracle.com/xdb/xdbpm/XDBResource.xsd'
 order by OWNER, SCHEMA_LOCATION_HINT, TABLE_OWNER, TABLE_NAME, ELEMENT_NAME, COLUMN_NAME
/
create or replace trigger XMLSCHEMA_OBJECT_LIST_DML
instead of INSERT or UPDATE or DELETE on XMLSCHEMA_OBJECT_LIST
begin
 null;
end;
/
grant select on XMLSCHEMA_OBJECT_LIST 
             to XFILES_USER
/
