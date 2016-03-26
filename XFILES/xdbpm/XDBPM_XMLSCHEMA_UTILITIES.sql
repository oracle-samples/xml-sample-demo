
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
-- XDBPM_XMLSCHEMA_UTILITIES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
set define on
--
create or replace package XDBPM_XMLSCHEMA_UTILITIES
authid CURRENT_USER
as

  TYPE DOCUMENT_INFO_T
    is RECORD (
         PATH                 VARCHAR2(1024),
         ELEMENT              VARCHAR2(256), 
         NAMESPACE            VARCHAR2(4000), 
         SCHEMA_LOCATION_HINT VARCHAR2(4000),
         TARGET               VARCHAR2(4000),
         OWNER                VARCHAR2(128),
         TABLE_NAME           VARCHAR2(128),
         MATCH_TYPE           VARCHAR2(16)
       );
  
  TYPE DOCUMENT_TABLE_T
    is TABLE of DOCUMENT_INFO_T;
    
  procedure scopeXMLReferences;
  procedure indexXMLReferences(INDEX_NAME VARCHAR2);
  procedure prepareBulkLoad(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER);
  procedure completeBulkLoad(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER);
  procedure renameCollectionTable (XMLTABLE VARCHAR2, XPATH VARCHAR2, COLLECTION_TABLE_PREFIX VARCHAR2);
 
  function printNestedTables(XML_TABLE VARCHAR2) return XMLType;
  function getDefaultTableName(P_RESOURCE_PATH VARCHAR2) return VARCHAR2;

  procedure cleanupSchema(P_OWNER VARCHAR2);
  procedure cleanXMLSchemaArtifacts(P_XML_SCHEMA XMLTYPE);
  procedure deleteOrphanTypes(P_REGISTRATION_DATE TIMESTAMP);
  
  function generateSchemaFromTable(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 default USER) return XMLTYPE;  
  function generateCreateTableStatement(XML_TABLE_NAME VARCHAR2, NEW_TABLE_NAME VARCHAR2) return CLOB;

  function  matchRelativeURL(P_RELATIVE_URL VARCHAR2) return VARCHAR2;

  procedure disableTableReferencedElements(P_XML_SCHEMA IN OUT XMLTYPE);
  procedure disableTableSubgroupMembers(P_XML_SCHEMA IN OUT XMLTYPE);
  procedure disableTableNonRootElements(P_XML_SCHEMA IN OUT XMLTYPE);

end XDBPM_XMLSCHEMA_UTILITIES;
/
show errors
--
create or replace synonym XDB_XML_SCHEMA_UTILITIES for XDBPM_XMLSCHEMA_UTILITIES
/
grant execute on XDBPM_XMLSCHEMA_UTILITIES to public
/
create or replace package body XDBPM_XMLSCHEMA_UTILITIES
as
  TYPE SCHEMA_URL_CACHE_T
  IS TABLE of VARCHAR2(700)
     INDEX BY VARCHAR2(700);
     
  G_SCHEMA_URL_CACHE SCHEMA_URL_CACHE_T;   
     
procedure scopeXMLReferences
as
begin
  XDB.DBMS_XMLSTORAGE_MANAGE.scopeXMLReferences;
end;
--
procedure indexXMLReferences(INDEX_NAME VARCHAR2)
as
  cursor getTables
  is
  select distinct TABLE_NAME
    from USER_REFS
   where IS_SCOPED = 'NO';
   
begin
  for t in getTables loop
    XDB.DBMS_XMLSTORAGE_MANAGE.indexXMLReferences(USER,t.TABLE_NAME,null,INDEX_NAME);
  end loop;
end;
--  
procedure renameCollectionTable (XMLTABLE VARCHAR2, XPATH VARCHAR2, COLLECTION_TABLE_PREFIX VARCHAR2)
as
begin
  XDB.DBMS_XMLSTORAGE_MANAGE.renameCollectionTable(USER,XMLTABLE,NULL,XPATH,COLLECTION_TABLE_PREFIX || 'TABLE');
end;
--
procedure prepareBulkLoad(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
as
begin
  XDB.DBMS_XMLSTORAGE_MANAGE.enableIndexesAndConstraints(P_TABLE_NAME, P_OWNER);
end;
--
procedure completeBulkLoad(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
as
begin
  XDB.DBMS_XMLSTORAGE_MANAGE.enableIndexesAndConstraints(P_TABLE_NAME, P_OWNER);
end;
--
procedure cleanupSchema(P_OWNER VARCHAR2)
as
begin
	XDBPM_SYSDBA_INTERNAL.cleanupSchema(P_OWNER);
end;
--
function processNestedTable(currentLevel in out number, currentNode in out XMLType, query SYS_REFCURSOR)
return XMLType
is 
  thisLevel  number;
  thisNode   xmlType;
  result xmlType;
begin
  thisLevel := currentLevel;
  thisNode := currentNode;
  fetch query into currentLevel, currentNode;
  if (query%NOTFOUND) then 
    currentLevel := -1;
  end if;
  while (currentLevel >= thisLevel) loop
    -- Next Node is a decendant of sibling of this Node.
    if (currentLevel > thisLevel) then
      -- Next Node is a decendant of this Node. 
      result := processNestedTable(currentLevel, currentNode, query);
      select xmlElement
             (
                "Collection",
                extract(thisNode,'/Collection/*'),
                xmlElement
                (
                  "NestedCollections",
                  result
                )
              )
         into thisNode
         from dual;
    else
      -- Next node is a sibling of this Node. 
      result := processNestedTable(currentLevel, currentNode, query);
      select xmlconcat(thisNode,result) into thisNode from dual;
    end if;
  end loop;

  -- Next Node is a sibling of some ancestor of this node.

  return thisNode;
  
end;
--
function printNestedTables(XML_TABLE VARCHAR2)
return XMLType
is
   query SYS_REFCURSOR;
   result XMLType;
   rootLevel number := 0;
   rootNode xmlType; 
begin
   open query for 
        select level, xmlElement
                      (
                        "Collection",
                        xmlElement
                        (
                          "CollectionId",
                          PARENT_TABLE_COLUMN
                        )
                      ) as XML
          from USER_NESTED_TABLES
       connect by PRIOR TABLE_NAME = PARENT_TABLE_NAME
               start with PARENT_TABLE_NAME = XML_TABLE;
    fetch query into rootLevel, rootNode;
    result := processNestedTable(rootLevel, rootNode, query);
    select xmlElement
           (
              "NestedTableStructure",
              result
           )
      into result 
      from dual;
    return result;
end;
--
function getDefaultTableName(P_RESOURCE_PATH VARCHAR2)
return VARCHAR2
as 
  V_TARGET_URL          VARCHAR2(4096);
  V_SCHEMA_URL          VARCHAR2(1024);
  V_ELEMENT_NAME        VARCHAR2(2000);
  V_DEFAULT_TABLE_NAME  VARCHAR2(32);
begin
  select extractValue(res,'/Resource/SchemaElement')
    into V_TARGET_URL
    from RESOURCE_VIEW
   where equals_path(res,P_RESOURCE_PATH) = 1;

  V_SCHEMA_URL := substr(V_TARGET_URL,1,instr(V_TARGET_URL,'#')-1);
  V_ELEMENT_NAME := substr(V_TARGET_URL,instr(V_TARGET_URL,'#')+1);

  select extractValue
         (
            SCHEMA,
            '/xsd:schema/xsd:element[@name="' || V_ELEMENT_NAME || '"]/@xdb:defaultTable',
            xdb_namespaces.XMLSCHEMA_PREFIX_XSD || ' ' || xdb_namespaces.XDBSCHEMA_PREFIX_XDB
         )
    into V_DEFAULT_TABLE_NAME
    from USER_XML_SCHEMAS
   where SCHEMA_URL = V_SCHEMA_URL;
     
  return V_DEFAULT_TABLE_NAME;
end;
--
function generateSchemaFromTable(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 default USER)
return XMLTYPE
as
  xmlSchema XMLTYPE;
begin
  select xmlElement
         (
           "xsd:schema",
           xmlAttributes
           (
             'http://www.w3.org/2001/XMLSchema' as "xmlns:xsd",
             'http://xmlns.oracle.com/xdb' as "xmlns:xdb"
           ),
           xmlElement
           (
             "xsd:element",
             xmlAttributes
             (
               'ROWSET' as "name",
               'rowset' as "type"
             )
           ),
           xmlElement 
           (
             "xsd:complexType",
             xmlAttributes
             (
               'rowset' as "name"
             ),
             xmlElement
             (
               "xsd:sequence",
               xmlElement
               (
                  "xsd:element",
                  xmlAttributes
                  (
                    'ROW' as "name",
                    table_name || '_T' as "type",
                    'unbounded' as "maxOccurs"
                  )
                )
              )
           ),
           xmlElement
           (
             "xsd:complexType",
             xmlAttributes
             (
               table_name || '_T' as "name"
             ),
             xmlElement
             (
               "xsd:sequence",
               (
                 xmlAgg(ELEMENT order by INTERNAL_COLUMN_ID)
               )
             )
           )
         )
    into xmlSchema
    from (select TABLE_NAME, INTERNAL_COLUMN_ID,
                 case 
                   when DATA_TYPE in ('VARCHAR2','CHAR') then
                     xmlElement
                     (
                       "xsd:element",
                       xmlattributes
                       (
                         column_name as "name", 
                         decode(NULLABLE, 'Y', 0, 1) as "minOccurs",
                         column_name as "xdb:SQLName", 
                         DATA_TYPE as "xdb:SQLType"
                       ),
                       xmlElement
                       (
                         "xsd:simpleType",
                         xmlElement
                         (
                           "xsd:restriction",
                           xmlAttributes
                           (
                             'xsd:string' as "base"
                           ),
                           xmlElement
                           (
                             "xsd:maxLength",
                             xmlAttributes
                             (
                               DATA_LENGTH  as "value"
                             )
                           )
                         )
                       )
                     )
                   when DATA_TYPE = 'NUMBER' then
                     xmlElement
                     (
                       "xsd:element",
                       xmlattributes
                       (
                         column_name as "name", 
                         decode(NULLABLE, 'Y', 0, 1) as "minOccurs",
                         column_name as "xdb:SQLName", 
                         DATA_TYPE as "xdb:SQLType"
                       ),
                       xmlElement
                       (
                         "xsd:simpleType",
                         xmlElement
                         (
                           "xsd:restriction",
                           xmlAttributes
                           (
                              decode(DATA_SCALE, 0, 'xsd:integer', 'xsd:double') as "base"
                           ),
                           xmlElement
                           (
                             "xsd:totalDigits",
                             xmlAttributes
                             (
                               DATA_PRECISION  as "value"
                             )
                           )
                         )
                       )
                     )
                   when DATA_TYPE = 'DATE' then
                     xmlElement
                     (
                       "xsd:element",
                       xmlattributes
                       (
                         column_name as "name", 
                         decode(NULLABLE, 'Y', 0, 1) as "minOccurs",
                         'xsd:date' as "type",
                         column_name as "xdb:SQLName", 
                         DATA_TYPE as "xdb:SQLType"
                       )
                     )
                   when DATA_TYPE like 'TIMESTAMP%WITH TIME ZONE' then
                     xmlElement
                     (
                       "xsd:element",
                       xmlattributes
                       (
                         column_name as "name", 
                         decode(NULLABLE, 'Y', 0, 1) as "minOccurs",
                         'xsd:dateTime' as "type",
                         column_name as "xdb:SQLName", 
                         DATA_TYPE as "xdb:SQLType"
                       )
                     )
                   else
                     xmlElement
                     (
                       "xsd:element",
                       xmlattributes
                       (
                         column_name as "name", 
                         decode(NULLABLE, 'Y', 0, 1) as "minOccurs",
                         'xsd:anySimpleType' as "type",
                         column_name as "xdb:SQLName", 
                         DATA_TYPE as "xdb:SQLType"
                       )
                     )
                 end ELEMENT
            from all_tab_cols c 
           where c.TABLE_NAME = P_TABLE_NAME
             and c.OWNER = P_OWNER
          )
    group by TABLE_NAME;
  return xmlSchema;
end;
--
function generateCreateTableStatement(XML_TABLE_NAME VARCHAR2, NEW_TABLE_NAME VARCHAR2)
return CLOB
is
  DDL_STATEMENT CLOB;
  cursor getStructure (XML_TABLE_NAME VARCHAR2) is
  select level, PARENT_TABLE_NAME, PARENT_TABLE_COLUMN, TABLE_TYPE_NAME, TABLE_NAME
    from USER_NESTED_TABLES
         connect by PRIOR TABLE_NAME = PARENT_TABLE_NAME
                 start with PARENT_TABLE_NAME = XML_TABLE_NAME;
  current_level pls_integer := 0;
  clause VARCHAR2(4000);
  indent VARCHAR2(4000); 
  table_number pls_integer := 0;
  
  XMLSCHEMA VARCHAR2(700);
  ELEMENT   VARCHAR2(2000);
  
begin
  dbms_lob.createTemporary(DDL_STATEMENT,FALSE,DBMS_LOB.SESSION);
  current_level := 0;

  select XMLSCHEMA, ELEMENT_NAME 
    into XMLSCHEMA, ELEMENT
    from USER_XML_TABLES
   where TABLE_NAME = XML_TABLE_NAME;

  clause := 'create table "' || NEW_TABLE_NAME ||'" of XMLType' || chr(10) ||
            'XMLSCHEMA "' || XMLSCHEMA || '" ELEMENT "' || ELEMENT || '"' || CHR(10);
  dbms_lob.writeAppend(DDL_STATEMENT,length(clause),clause);            
  for nt in getStructure(XML_TABLE_NAME) loop
     clause := null;
     if nt.level <= current_level then
       while current_level  >= nt.level loop
         indent := lpad(' ',current_level * 2,' ');
         clause := clause || indent || ')' || chr(10);
         current_level := current_level - 1;
       end loop;
     end if;
     current_level := nt.level;
     table_number := table_number + 1;
     indent := lpad(' ',nt.level * 2,' ');
     clause := clause ||
               indent || 'varray ' || nt.PARENT_TABLE_COLUMN || chr(10) || 
               indent || 'store as table "' || NEW_TABLE_NAME || '_NT' || lpad(table_number,4,'0') || '"' || chr(10) ||
               indent || '(' || chr(10) ||
               indent || '  ( constraint "' || NEW_TABLE_NAME || '_NT' || lpad(table_number,4,'0') || '_PKEY" primary key (NESTED_TABLE_ID, SYS_NC_ARRAY_INDEX$))' || chr(10);
     dbms_lob.writeAppend(DDL_STATEMENT,length(clause),clause);
  end loop;
  clause := null;
  while current_level  > 0 loop
    indent := lpad(' ',current_level * 2,' ');
    clause := clause || indent || ')' || chr(10);
    current_level := current_level - 1;
  end loop;
  if clause is not null then
    dbms_lob.writeAppend(DDL_STATEMENT,length(clause),clause);
  end if;
  return DDL_STATEMENT;
end;
--
procedure disableTableReferencedElements(P_XML_SCHEMA IN OUT XMLTYPE)
as
	cursor getElementReferences
	is
	select REF
    from XMLTABLE
         (
            xmlNamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd"
            ),
            '/xsd:schema//xsd:element[@ref]'
            passing P_XML_SCHEMA
            columns REF VARCHAR2(4000) path '@ref'
        );
begin 
  for ge in getElementReferences loop
    DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(P_XML_SCHEMA,ge.REF); 
  end loop;
end;
--
procedure disableTableSubgroupMembers(P_XML_SCHEMA IN OUT XMLTYPE)
as
	cursor getSubstitutionMembers
	is
	select NAME
    from XMLTABLE
         (
            xmlNamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd"
            ),
            '/xsd:schema/xsd:element[@substitutionGroup]/@name'
            passing P_XML_SCHEMA
            columns NAME VARCHAR2(4000) path '@name'
        );
        
begin 
  for ge in getSubstitutionMembers loop
    DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(P_XML_SCHEMA,ge.NAME); 
  end loop;
end;
--
procedure disableTableNonRootElements(P_XML_SCHEMA IN OUT XMLTYPE)
as
begin
	 XDB_XML_SCHEMA_UTILITIES.disableTableSubgroupMembers(P_XML_SCHEMA);
	 XDB_XML_SCHEMA_UTILITIES.disableTableReferencedElements(P_XML_SCHEMA);
end;
--
function initializeSchemaAnnotations(P_SCHEMA_LOCATION_HINT VARCHAR2)
return CLOB
as
  V_BUFFER  VARCHAR2(4000);
  V_CONTENT CLOB;
begin
	  
	return V_CONTENT;
end;
--
procedure deleteOrphanTypes(P_REGISTRATION_DATE TIMESTAMP)
as
  cursor getOrphanTypes 
  is
  select OBJECT_NAME 
    from USER_OBJECTS
   where OBJECT_TYPE = 'TYPE'
     and to_timestamp(TIMESTAMP,'YYYY-MM-DD:HH24:MI:SS') > P_REGISTRATION_DATE
     and not exists
         (
           select 1
             from XDB.XDB$COMPLEX_TYPE ct, XDB.XDB$SCHEMA s
            where ct.XMLDATA.SQLTYPE = OBJECT_NAME
              and ref(s) = ct.XMLDATA.PARENT_SCHEMA 
              and s.XMLDATA.SCHEMA_OWNER = USER           
            union all
           select 1
             from XDB.XDB$ELEMENT e, XDB.XDB$SCHEMA s
            where e.XMLDATA.PROPERTY.SQLCOLLTYPE = OBJECT_NAME
              and ref(s) = e.XMLDATA.PROPERTY.PARENT_SCHEMA 
              and s.XMLDATA.SCHEMA_OWNER = USER     
         );
begin
	for t in getOrphanTypes loop
	  execute immediate 'drop type "' || t.OBJECT_NAME || '" force';
	end loop;
end;
--
procedure cleanXMLSchemaArtifacts(P_XML_SCHEMA XMLTYPE)
as
 	cursor getTables
 	is
 	select TABLE_NAME
 	  from USER_XML_TABLES
 	 where TABLE_NAME in (
 	         select TABLE_NAME 
 	           from XMLTABLE(
 	                  '//xs:element[@defaultTable]'
 	                  passing P_XML_SCHEMA
 	                  columns
 	                    TABLE_NAME VARCHAR2(128) PATH '@defaultTable'
 	                ) 
 	       );
 	       
 	cursor getCollTypes
 	is
 	select TYPE_NAME
 	  from USER_COLL_TYPES
 	 where TYPE_NAME in (
 	         select TYPE_NAME
 	           from XMLTABLE(
 	                  '//xs:complexType[@SQLCollType]'
 	                  passing P_XML_SCHEMA
 	                  columns
 	                    TYPE_NAME VARCHAR2(128) PATH '@SQLCollType'
 	                ) 
 	       );
 	       
 	cursor getTypes
 	is
 	select TYPE_NAME
 	  from USER_TYPES
 	 where TYPE_NAME in (
 	         select TYPE_NAME
 	           from XMLTABLE( 
 	                  '//xs:complexType[@SQLType]' 
 	                  passing P_XML_SCHEMA
 	                  columns
 	                    TYPE_NAME VARCHAR2(128) PATH '@SQLType'  
 	                )
 	       );
begin
	for t in getTables loop
	  execute immediate 'drop table "' || t.TABLE_NAME || '" force';
	end loop;
	for t in getCollTypes loop
	  execute immediate 'drop type "' || t.TYPE_NAME || '" force';
	end loop;
	for t in getTypes loop
	  execute immediate 'drop type "' || t.TYPE_NAME || '" force';
	end loop;
end;
--
function matchRelativeURL(P_RELATIVE_URL VARCHAR2) 
return VARCHAR2
as
  V_MATCHING_URL VARCHAR2(700) := P_RELATIVE_URL;
  V_URL_PATTERN  VARCHAR2(700);
  V_MATCH_COUNT  BINARY_INTEGER;
  
  cursor findMatchingURLs
  is 
  select SCHEMA_URL
    from USER_XML_SCHEMAS
   where SCHEMA_URL like '%' || V_MATCHING_URL;

begin
	
	if G_SCHEMA_URL_CACHE.exists(P_RELATIVE_URL) then
	  V_MATCHING_URL := G_SCHEMA_URL_CACHE(P_RELATIVE_URL);
	else	
    if (((instr(V_MATCHING_URL,'://') = 0) and (instr(V_MATCHING_URL,'/') <> 1) )  or (instr(V_MATCHING_URL,'./') = 1)) then
      if (instr(V_MATCHING_URL,'..')  = 1 ) then
    	  while instr(V_MATCHING_URL,'..') = 1 loop
          V_MATCHING_URL := substr(V_MATCHING_URL,4);
        end loop;
      else 
        if (instr(V_MATCHING_URL,'./') = 1) then
          V_MATCHING_URL := substr(V_MATCHING_URL,3);
        end if;
      end if;
  
      V_URL_PATTERN := '%' || V_MATCHING_URL;
    
      select count(*) 
        into V_MATCH_COUNT
        from USER_XML_SCHEMAS
       where SCHEMA_URL like V_URL_PATTERN;
   
      case V_MATCH_COUNT
        when 0 then begin
          select count(*)   
            into V_MATCH_COUNT
            from ALL_XML_SCHEMAS
           where SCHEMA_URL like V_URL_PATTERN;
   
          if (V_MATCH_COUNT = 1) then
            select SCHEMA_URL
              into V_MATCHING_URL
              from ALL_XML_SCHEMAS
             where SCHEMA_URL like V_URL_PATTERN;
          else
            V_MATCHING_URL := NULL;
          end if;
        end;
        when 1 then
          select SCHEMA_URL       
            into V_MATCHING_URL
            from USER_XML_SCHEMAS
           where SCHEMA_URL like V_URL_PATTERN;
        else
          V_MATCHING_URL := null;
      end case;   
    end if;
    G_SCHEMA_URL_CACHE(P_RELATIVE_URL) := V_MATCHING_URL;
  end if;
  return V_MATCHING_URL;
end;
--
end XDBPM_XMLSCHEMA_UTILITIES;
/
show errors
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--