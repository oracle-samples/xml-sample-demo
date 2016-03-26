
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
-- XDBPM_EDIT_XMLSCHEMA should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
declare
  cursor getSequence
  is
  select 1 
    from all_sequences
   where SEQUENCE_OWNER = 'XDBPM' and SEQUENCE_NAME = 'XDBPM$TYPE_ID';
begin
	for s in getSequence loop
	  execute immediate 'drop sequence XDBPM$TYPE_ID';
	end loop;
end;
/
create sequence XDBPM$TYPE_ID
/
grant select on XDBPM$TYPE_ID to public
/
create or replace package XDBPM_EDIT_XMLSCHEMA
authid CURRENT_USER
as
  procedure addNewEnumerationValue(P_XML_SCHEMA in out XMLType, P_TARGET_XPATH VARCHAR2, P_NEW_ENUMERATION_VALUE VARCHAR2);
  procedure fixImportLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2);
  procedure fixIncludeLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2);
  procedure fixRelativeURLs(P_XML_SCHEMA in out XMLType, P_SCHEMA_LOCATION_HINT VARCHAR2);
  procedure fixWindowsURLs(P_XML_SCHEMA in out XMLType);
  procedure fixSchemaLocationHint(P_XML in out XMLType);
  procedure fixEmptyComplexType(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2);
  procedure fixComplexTypeSimpleContent(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SIMPLE_TYPE_NAME VARCHAR2);
  procedure mapAnyToClob(P_XML_SCHEMA in out XMLType);
  procedure removeAppInfo(P_XML_SCHEMA in out XMLType);
  procedure setSQLTypeMappings(P_SQLTYPE_MAPPINGS XMLTYPE);
  
  procedure applySQLTypeMappings(P_XML_SCHEMA in out XMLTYPE);
  procedure setSchemaDataType(P_XML_SCHEMA in out XMLType,P_XML_DATATYPE VARCHAR2,P_SQL_DATATYPE VARCHAR2);
  procedure setMaintainDOM(P_XML_SCHEMA in out XMLType, P_PATH_EXPRESSION VARCHAR2, P_VALUE VARCHAR2);

  procedure loadGroupDefinitions(P_SCHEMA_FOLDER varchar2);
  procedure expandAllGroups(P_XML_SCHEMA in out XMLType);
  procedure expandAllGroups(P_SCHEMA_FOLDER VARCHAR2);
  procedure expandRepeatingGroups(P_XML_SCHEMA in out XMLType);

  function  getGroupDefinitions return XMLTYPE;
  function  getGroupDefinitions(P_SCHEMA_FOLDER VARCHAR2) return XMLTYPE;

  procedure saveAnnotatedSchema(P_XML_SCHEMA_PATH VARCHAR2,P_XML_SCHEMA XMLTYPE,P_COMMENT VARCHAR2 DEFAULT NULL);

  function appendPath(P_LEFT_EXPRESSION VARCHAR2, P_RIGHT_EXPRESSION VARCHAR2) return VARCHAR2;
  
  function  DIFF_XML_SCHEMAS(P_OLD_SCHEMA XMLTYPE, P_NEW_SCHEMA XMLTYPE) return XMLTYPE;
  function  generateAnnotationScript(P_SCHEMA_URL VARCHAR2, P_OWNER VARCHAR2) return CLOB;
  function  generateAnnotationScript(P_XML_SCHEMA XMLTYPE) return CLOB;
end;
/
show errors
--
create or replace synonym XDB_EDIT_XMLSCHEMA for XDBPM_EDIT_XMLSCHEMA
/
grant execute on XDBPM_EDIT_XMLSCHEMA to public
/
create or replace package body XDBPM_EDIT_XMLSCHEMA
as
--
  G_SQLTYPE_MAPPINGS         XMLType := XMLTYPE('<xdbpm:SQLTypeMappings xmlns:xdbpm="http://xmlns.oracle.com/xdb/xdbpm"/>');
  G_GROUP_DEFINITIONS        XMLType;
--
function getDocumentElementPrefix(P_XML_DOCUMENT XMLTYPE)
return VARCHAR2
as
  V_PREFIX VARCHAR2(32) := '';
  cursor getDocumentElementPrefix
  is
  select /*+ NO_XML_QUERY_REWRITE */ PREFIX 
		  from XMLTABLE
		       (
		         '<PREFIX>{fn:prefix-from-QName(fn:node-name($DOC/*))}</PREFIX>' 
		         passing P_XML_DOCUMENT as "DOC"
		         columns
	           PREFIX VARCHAR2(32) PATH 'text()'
		       );
begin
	for p in getDocumentElementPrefix loop
	  V_PREFIX := p.PREFIX;
	end loop;
  return V_PREFIX;
end;
--
procedure setSchemaDataType(P_XML_SCHEMA in out XMLType,P_XML_DATATYPE VARCHAR2,P_SQL_DATATYPE VARCHAR2)
as
  V_SCHEMA_NAMESPACE_PREFIX VARCHAR2(32);
  V_XML_DATATYPE            VARCHAR2(64) := P_XML_DATATYPE;
begin
  V_SCHEMA_NAMESPACE_PREFIX := getDocumentElementPrefix(P_XML_SCHEMA);
  if (V_SCHEMA_NAMESPACE_PREFIX is not null) then
    V_XML_DATATYPE := V_SCHEMA_NAMESPACE_PREFIX || ':' || V_XML_DATATYPE;
  end if;
  DBMS_XMLSCHEMA_ANNOTATE.SETSQLTYPEMAPPING(P_XML_SCHEMA,V_XML_DATATYPE,P_SQL_DATATYPE);
end;
--
procedure setSQLTypeMappings(P_SQLTYPE_MAPPINGS XMLTYPE)
as
begin
	G_SQLTYPE_MAPPINGS := P_SQLTYPE_MAPPINGS;
end;
--
procedure applySQLTypeMappings(P_XML_SCHEMA in out XMLTYPE)
as
  GENERIC_ERROR exception;
  PRAGMA EXCEPTION_INIT( GENERIC_ERROR , -31061 );

  NO_MATCHING_NODES exception;
  PRAGMA EXCEPTION_INIT( NO_MATCHING_NODES , -64405 );

  V_SCHEMA_NAMESPACE_PREFIX VARCHAR2(32) := '';
  V_TARGET_NAMESPACE_PREFIX VARCHAR2(32) := '';
  V_XML_DATATYPE            VARCHAR2(64);
  V_EXTENDED_DATATYPE       VARCHAR2(128);
  V_SEQUENCE                NUMBER;

  cursor getSQLTypeMappings
  is
  select XML_DATATYPE, SQL_DATATYPE 
    from XMLTABLE
         (
           xmlnamespaces
           (
             default 'http://xmlns.oracle.com/xdb/xdbpm'
           ),
           '/SQLTypeMappings/SQLTypeMapping'
           passing G_SQLTYPE_MAPPINGS
           COLUMNS
           XML_DATATYPE VARCHAR2(256) path 'xsdType',
           SQL_DATATYPE VARCHAR2(256) path 'SQLType'
         );
         
  cursor getTargetNamespacePrefix
  is
  select /*+ NO_XML_QUERY_REWRITE */ PREFIX 
		  from XMLTABLE
		       (
		         'for $i in $SCHEMA/xs:schema/@targetNamespace, $j in fn:in-scope-prefixes($SCHEMA/xs:schema)
		            where $i = fn:namespace-uri-for-prefix($j,$SCHEMA/xs:schema) and $j != ""
		            return <PREFIX>{fn:data($j)}</PREFIX>' 
		         passing P_XML_SCHEMA as "SCHEMA"
		         columns
	           PREFIX VARCHAR2(32) PATH 'text()'
		       );
begin
  V_SCHEMA_NAMESPACE_PREFIX := getDocumentElementPrefix(P_XML_SCHEMA);
  
  -- Check for a targetNamespace attribute
	-- Find the namespace prefix for the targetNamespace.
	
	for p in getTargetNamespacePrefix loop
    V_TARGET_NAMESPACE_PREFIX := p.PREFIX || ':';
  end loop;
  
	for d in getSQLTypeMappings loop

    V_XML_DATATYPE := d.XML_DATATYPE;

    if (V_SCHEMA_NAMESPACE_PREFIX is not null) then
      V_XML_DATATYPE := V_SCHEMA_NAMESPACE_PREFIX || ':' || V_XML_DATATYPE;
    end if;

    if (P_XML_SCHEMA.existsNode('/xsd:schema//xsd:element[@type="' || V_XML_DATATYPE || '" and not (xdb:SQLType)]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1) then
      DBMS_XMLSCHEMA_ANNOTATE.addXDBNamespace(P_XML_SCHEMA);
      select insertChildXML
             (
               P_XML_SCHEMA,
               '/xsd:schema//xsd:element[@type="' || V_XML_DATATYPE || '" and not (xdb:SQLType)]',
               '@xdb:SQLType',
               d.SQL_DATATYPE,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
    end if;

    if (P_XML_SCHEMA.existsNode('/xsd:schema//xsd:attribute[@type="' || V_XML_DATATYPE || '" and not (xdb:SQLType)]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1) then
      DBMS_XMLSCHEMA_ANNOTATE.addXDBNamespace(P_XML_SCHEMA);
      select insertChildXML
             (
               P_XML_SCHEMA,
               '/xsd:schema//xsd:attribute[@type="' || V_XML_DATATYPE || '" and not (xdb:SQLType)]',
               '@xdb:SQLType',
               d.SQL_DATATYPE,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
    end if;
    
    -- Fix up any restrictions of the base type.

    if (P_XML_SCHEMA.existsNode('/xsd:schema//xsd:simpleType[xsd:restriction[@base="' || V_XML_DATATYPE || '"] and not (xdb:SQLType)]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1) then
      DBMS_XMLSCHEMA_ANNOTATE.addXDBNamespace(P_XML_SCHEMA);
      select insertChildXML
             (
               P_XML_SCHEMA,
               '/xsd:schema//xsd:simpleType[xsd:restriction[@base="' || V_XML_DATATYPE || '"] and not (xdb:SQLType)]',
               '@xdb:SQLType',
               d.SQL_DATATYPE,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
    end if;

    -- Fix up extensions of the base type.

    -- 1. Add a global simple type that maps the schema type to the SQLType
    -- 2. Replace the reference to the schematype with a reference to the globalType
    -- 3. SimpleType names need to be unique in case they are introduced into multiple schema that are in the same namespace.
    
    if (P_XML_SCHEMA.existsNode('/xsd:schema//xsd:simpleContent[xsd:extension[@base="' || V_XML_DATATYPE || '"]]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1) then
     
      select XDBPM.XDBPM$TYPE_ID.NEXTVAL
        into V_SEQUENCE
        from dual;
        
      V_EXTENDED_DATATYPE := replace(d.XML_DATATYPE || '.' || d.SQL_DATATYPE, ' ','.') || '-' || lpad(V_SEQUENCE,6,'0');

      DBMS_XMLSCHEMA_ANNOTATE.addXDBNamespace(P_XML_SCHEMA);

      select insertChildXML
             (
               P_XML_SCHEMA,
               '/xsd:schema',
               'xsd:simpleType',
               xmlElement
               (
                 "xsd:simpleType",
                 xmlAttributes
                 (
                   DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA as "xmlns:xsd",
                   DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB as "xmlns:xdb",
                   V_EXTENDED_DATATYPE as "name",
                   d.SQL_DATATYPE as "xdb:SQLType"
                 ),
                 xmlElement
                 (
                   "xsd:restriction",
                   xmlAttributes
                   (
                     'xsd:' || d.XML_DATATYPE as "base"
                   )
                 )
               ),
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )               
        into P_XML_SCHEMA
        from DUAL;
                       
      select updateXML
             (
               P_XML_SCHEMA,
               '/xsd:schema//xsd:simpleContent/xsd:extension[@base="' || V_TARGET_NAMESPACE_PREFIX || V_XML_DATATYPE || '"]/@base',
               V_EXTENDED_DATATYPE,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;

    end if;
   
  end loop;
end;
--

procedure fixIncludeLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2)
as
begin
  select updateXML
         (
           P_XML_SCHEMA,
           '/xsd:schema/xsd:include[@schemaLocation="' || P_OLD_LOCATION || '"]/@schemaLocation',
           P_NEW_LOCATION,
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA
    from dual;
end;
--
procedure fixImportLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2)
as
begin
  select updateXML
         (
           P_XML_SCHEMA,
           '/xsd:schema/xsd:import[@schemaLocation="' || P_OLD_LOCATION || '"]/@schemaLocation',
           P_NEW_LOCATION,
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA
    from dual;
end;
--
procedure fixWindowsURLs(P_XML_SCHEMA in out XMLType)
as
  V_SCHEMA_LOCATION VARCHAR2(700);

  cursor getImports is
    select SCHEMA_LOCATION
      from xmlTable
           (
             xmlnamespaces
             (
               default 'http://www.w3.org/2001/XMLSchema'
             ),
             '/schema/import'
             passing P_XML_SCHEMA
             columns
             SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
           );
           
  cursor getIncludes is
    select SCHEMA_LOCATION
      from xmlTable
           (
             xmlnamespaces
             (
               default 'http://www.w3.org/2001/XMLSchema'
             ),
             '/schema/include'
             passing P_XML_SCHEMA
             columns
             SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
           );

begin 
  for import in getImports loop
    
    if (instr(import.SCHEMA_LOCATION,'\')  <> 0 ) then
      V_SCHEMA_LOCATION := replace(import.SCHEMA_LOCATION,'\','/');
      select updateXML
             (
               P_XML_SCHEMA,
               '/xsd:schema/xsd:import[@schemaLocation="' || import.SCHEMA_LOCATION || '"]/@schemaLocation',
               V_SCHEMA_LOCATION,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
            
    end if;
  end loop;

  for include in getIncludes loop
    if (instr(include.SCHEMA_LOCATION,'\')  <> 0 ) then
      V_SCHEMA_LOCATION := replace(include.SCHEMA_LOCATION,'\','/');
      select updateXML
             (
               P_XML_SCHEMA,
               '/xsd:schema/xsd:include[@schemaLocation="' || include.SCHEMA_LOCATION || '"]/@schemaLocation',
               V_SCHEMA_LOCATION,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
            
    end if;
  end loop;
  
end;
--
function appendPath(P_LEFT_EXPRESSION VARCHAR2, P_RIGHT_EXPRESSION VARCHAR2) 
return VARCHAR2 
as
  V_LEFT_EXPRESSION VARCHAR2(4000) := P_LEFT_EXPRESSION;
  V_RIGHT_EXPRESSION VARCHAR2(4000) := P_RIGHT_EXPRESSION;
begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'.appendPath(): P_LEFT_EXPRESSION="' || P_LEFT_EXPRESSION || '". P_RIGHT_EXPRESSION="' || P_RIGHT_EXPRESSION || '".',TRUE);
$END

	if instr(V_LEFT_EXPRESSION,'/',-1) = length(V_LEFT_EXPRESSION) then
	  V_LEFT_EXPRESSION := SUBSTR(V_LEFT_EXPRESSION,1,LENGTH(V_LEFT_EXPRESSION)-1);
	end if;

	if instr(V_RIGHT_EXPRESSION,'/') = 1 then
	  V_RIGHT_EXPRESSION := SUBSTR(V_RIGHT_EXPRESSION,2);
	end if;

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'appendPath():: Path="' || V_LEFT_EXPRESSION || '/' || V_RIGHT_EXPRESSION || '".',TRUE);
$END

  return V_LEFT_EXPRESSION || '/' || V_RIGHT_EXPRESSION;

end;
--	
procedure fixRelativeURLs(P_XML_SCHEMA in out XMLType, P_SCHEMA_LOCATION_HINT VARCHAR2)
as
  cursor getImports is
    select NAMESPACE, SCHEMA_LOCATION
      from xmlTable
           (
             xmlnamespaces
             (
               default 'http://www.w3.org/2001/XMLSchema'
             ),
             '/schema/import'
             passing P_XML_SCHEMA
             columns
             NAMESPACE       VARCHAR2(700) path '@namespace',
             SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
           );
           
  cursor getIncludes is
    select SCHEMA_LOCATION
      from xmlTable
           (
             xmlnamespaces
             (
               default 'http://www.w3.org/2001/XMLSchema'
             ),
             '/schema/include'
             passing P_XML_SCHEMA
             columns
             SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
           );
 
  V_BASE_URL        VARCHAR2(700);
  V_SCHEMA_LOCATION VARCHAR2(700);
  V_TARGET_URL      VARCHAR2(700);
begin

  V_BASE_URL := NULL;

  if instr(P_SCHEMA_LOCATION_HINT,'/',-1) > 1 then
    --
    -- The Schema Location Hint for the current XML Schema '/' somewhere other than the first character 
    -- The base URL for any relative locations in import or include elements is everything to the left of the last '/' 
    --
    V_BASE_URL := substr(P_SCHEMA_LOCATION_HINT,1,instr(P_SCHEMA_LOCATION_HINT,'/',-1)-1);
  end if;

  for import in getImports loop

    V_TARGET_URL := V_BASE_URL;
    V_SCHEMA_LOCATION := import.SCHEMA_LOCATION;
    
    -- Check for any attempt to import xml.xsd and fix the URL as "http://www.w3.org/2001/xml.xsd"

    -- The following are treated as relative URLs
    -- URLs with no '/' character
    -- URLs which do not start with '/' and which do not contain '://'
    -- URLS which start with ./

    if ((import.NAMESPACE = 'http://www.w3.org/XML/1998/namespace') and (V_SCHEMA_LOCATION = 'xml.xsd' or V_SCHEMA_LOCATION like '%/xml.xsd')) then
      V_SCHEMA_LOCATION := 'http://www.w3.org/2001/xml.xsd';
    else
      if ( ( (instr(V_SCHEMA_LOCATION,'://') = 0) and (instr(V_SCHEMA_LOCATION,'/') <> 1) )  or (instr(V_SCHEMA_LOCATION,'./') = 1)) then
         
        if (instr(V_SCHEMA_LOCATION,'..')  = 1 ) then
          while instr(V_SCHEMA_LOCATION,'..') = 1 loop
            V_SCHEMA_LOCATION := substr(V_SCHEMA_LOCATION,4);
            if (V_TARGET_URL is not NULL) then
              V_TARGET_URL := substr(V_TARGET_URL,1,instr(V_TARGET_URL,'/',-1)-1);
            end if;
          end loop;
        else    
          if (instr(V_SCHEMA_LOCATION,'./') = 1) then
            V_SCHEMA_LOCATION := substr(V_SCHEMA_LOCATION,3);
          end if;
        end if; 

        if (V_TARGET_URL is not NULL) then
          V_SCHEMA_LOCATION := appendPath(V_TARGET_URL,V_SCHEMA_LOCATION);
        end if;
      end if;
    end if;
 
    if (V_SCHEMA_LOCATION <> import.SCHEMA_LOCATION) then
       
      select updateXML
             (
               P_XML_SCHEMA,
               '/xsd:schema/xsd:import[@schemaLocation="' || import.SCHEMA_LOCATION || '"]/@schemaLocation',
               V_SCHEMA_LOCATION,
              DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
           )  
      into P_XML_SCHEMA
      from dual;
    end if;

  end loop;

  for include in getIncludes loop
    V_TARGET_URL := V_BASE_URL;
    V_SCHEMA_LOCATION := include.SCHEMA_LOCATION;

    -- The following are treated as relative URLs
    -- URLs with no '/' character
    -- URLs which do not start with '/' and which do not contain '://'
    -- URLS which start with ./

    if ( ( (instr(V_SCHEMA_LOCATION,'://') = 0) and (instr(V_SCHEMA_LOCATION,'/') <> 1) )  or (instr(V_SCHEMA_LOCATION,'./') = 1)) then
       
      if (instr(V_SCHEMA_LOCATION,'..')  = 1 ) then
        while instr(V_SCHEMA_LOCATION,'..') = 1 loop
          V_SCHEMA_LOCATION := substr(V_SCHEMA_LOCATION,4);
          if (V_TARGET_URL is not NULL) then
            V_TARGET_URL := substr(V_TARGET_URL,1,instr(V_TARGET_URL,'/',-1)-1);
          end if;
        end loop;
      else    
        if (instr(V_SCHEMA_LOCATION,'./') = 1) then
          V_SCHEMA_LOCATION := substr(V_SCHEMA_LOCATION,3);
        end if;
      end if; 

      if (V_TARGET_URL is not NULL) then
        V_SCHEMA_LOCATION := appendPath(V_TARGET_URL,V_SCHEMA_LOCATION);
      end if;

      select updateXML
             (
               P_XML_SCHEMA,
               '/xsd:schema/xsd:include[@schemaLocation="' || include.SCHEMA_LOCATION || '"]/@schemaLocation',
               V_SCHEMA_LOCATION,
               DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
             )
        into P_XML_SCHEMA
        from dual;
    end if;

  end loop;
  
end;
--
function expandSchemaLocationHint(P_SCHEMA_LOCATION_HINT VARCHAR2, P_ELEMENT VARCHAR2, P_NAMESPACE VARCHAR2)
return VARCHAR2
as
--
-- TODO : verify that the targetNamespace of the selected XML Schema matches P_NAMESPACE
--
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
begin
  V_SCHEMA_LOCATION_HINT := REPLACE(P_SCHEMA_LOCATION_HINT,'\','/');
  
  -- Fix the '    

  if INSTR(V_SCHEMA_LOCATION_HINT,'../') > 0 then
    V_SCHEMA_LOCATION_HINT := SUBSTR(V_SCHEMA_LOCATION_HINT,INSTR(V_SCHEMA_LOCATION_HINT,'../',-1) + 2);
  end if;

  if INSTR(V_SCHEMA_LOCATION_HINT,'./') > 0 then
    V_SCHEMA_LOCATION_HINT := SUBSTR(V_SCHEMA_LOCATION_HINT,INSTR(V_SCHEMA_LOCATION_HINT,'./',-1) + 1);
  end if;

  begin
    select XMLSCHEMA 
      into V_SCHEMA_LOCATION_HINT
      from USER_XML_TABLES
     where ELEMENT_NAME = P_ELEMENT
       and XMLSCHEMA like '%' || V_SCHEMA_LOCATION_HINT;
 
	  return V_SCHEMA_LOCATION_HINT;
	exception
	  when NO_DATA_FOUND then
	    return NULL;
	end;
end;
--
function getSchemaLocationHint(P_LOCATION VARCHAR2, P_NAMESPACE  VARCHAR2)
return VARCHAR2
as
  V_LOCATION_OFFSET      NUMBER(4);
  V_LOCATION             VARCHAR2(4000) := NULL;
begin
  V_LOCATION_OFFSET := instr(P_LOCATION,P_NAMESPACE || ' ');

  if (V_LOCATION_OFFSET > 0) then
    --
    -- Schema Location Tag contains entry for Namespace : get the associated schema location hint
    --
    V_LOCATION_OFFSET := V_LOCATION_OFFSET + length(P_NAMESPACE) + 1;
    V_LOCATION := substr(P_LOCATION,V_LOCATION_OFFSET);
    if (INSTR(V_LOCATION,' ') > 0) then
      V_LOCATION := substr(V_LOCATION,1,INSTR(V_LOCATION,' '));
    end if;
  end if;
      
  return V_LOCATION;
end;
--
procedure fixSchemaLocationHint(P_XML in out XMLTYPE)
as
  V_ELEMENT_NAME            VARCHAR2(256);
  V_NAMESPACE               VARCHAR2(700);

  V_SCHEMA_LOCATION_MAPPING VARCHAR2(4000);

  V_SCHEMA_LOCATION_HINT    VARCHAR2(700);
  V_CURRENT_HINT            VARCHAR2(700);

  V_GLOBAL_ELEMENT_COUNT    NUMBER(4);

begin
	if (P_XML.isSchemaBased() = 0) then
    --
    -- XDB was unable to automatically identify the XML Schema from the instance...
    --
  
    --
    -- Get the name and namespace for the root element
    --
  
    select /*+ NO_XML_QUERY_REWRITE */ *
      into V_ELEMENT_NAME, V_NAMESPACE, V_SCHEMA_LOCATION_MAPPING
      from XMLTABLE
          (
            '<Result>
               <ELEMENT_NAME>{fn:local-name($XML/*)}</ELEMENT_NAME>
               <NAMESPACE>{fn:namespace-uri($XML/*)}</NAMESPACE>
               {
    	           if ($XML/*/@xsi:noNamespaceSchemaLocation) then
    	             <SCHEMA_LOCATION>{fn:data($XML/*/@xsi:noNamespaceSchemaLocation)}</SCHEMA_LOCATION>
    	           else
    	             if ($XML/*/@xsi:schemaLocation) then
                     <SCHEMA_LOCATION>{fn:data($XML/*/@xsi:schemaLocation)}</SCHEMA_LOCATION>
                   else
                     <SCHEMA_LOCATION/>
               }
    	       </Result>'
    	       passing P_XML as "XML"
    	       columns
             ELEMENT_NAME    VARCHAR2(256),
             NAMESPACE       VARCHAR2(700),
             SCHEMA_LOCATION VARCHAR2(4000)
          );
          
    --
    -- Check to see if the Namespace / Element combination matches exactly one Global Element Definition
    --

    V_SCHEMA_LOCATION_HINT := null;

   	if (V_NAMESPACE is null) then

   	  select count(*) 
 	      into V_GLOBAL_ELEMENT_COUNT
  	    from ALL_XML_SCHEMAS
  	   where XMLEXISTS('$SCH/xs:schema[not(@targetNamespace) and xs:element[@name=$ELEMENT]]' passing SCHEMA as "SCH", V_ELEMENT_NAME as "ELEMENT");

      if (V_GLOBAL_ELEMENT_COUNT = 1) then
  	     
  	     select SCHEMA_URL
   	       into V_SCHEMA_LOCATION_HINT
      	   from ALL_XML_SCHEMAS
      	  where XMLEXISTS('$SCH/xs:schema[not(@targetNamespace) and xs:element[@name=$ELEMENT]]' passing SCHEMA as "SCH", V_ELEMENT_NAME as "ELEMENT");

      else
        --
        -- Try a partial match on the schemaLocationHint
        --

        V_SCHEMA_LOCATION_HINT := expandSchemaLocationHint(V_SCHEMA_LOCATION_MAPPING, V_ELEMENT_NAME, V_NAMESPACE);
        
      end if;
      
      if (V_SCHEMA_LOCATION_HINT is not NULL) then

        select deleteXML
               (               
                 P_XML,
                 '/*/@xsi:noNamespaceSchemaLocation',
     	           DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI
     	         )
     	    into P_XML 
       	  from DUAL;         
       
        P_XML := P_XML.createSchemaBasedXML(V_SCHEMA_LOCATION_HINT);

--
--        if (V_SCHEMA_LOCATION_MAPPING is NULL) then
--          P_XML := P_XML.createSchemaBasedXML(V_SCHEMA_LOCATION_HINT); 	  
--       	else
--          select updateXML
--                 (               
--                   P_XML,
--                  '/*/@xsi:noNamespaceSchemaLocation',
--      	           V_SCHEMA_LOCATION_HINT,
--      	           DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI
--      	         )
--      	    into P_XML 
--        	  from DUAL;         
--
--       	   
--      	  P_XML := P_XML.createSchemaBasedXML();
--       	   
--       end if;
--
      else
        raise_application_error(-20001, 'Unable to determine the table for Element "' || V_ELEMENT_NAME || '" (Schema Location "' || V_SCHEMA_LOCATION_MAPPING || '").' );
      end if;

    else      
    
      V_CURRENT_HINT := getSchemaLocationHint(V_SCHEMA_LOCATION_MAPPING, V_NAMESPACE);

      select count(*) 
 	      into V_GLOBAL_ELEMENT_COUNT
  	    from ALL_XML_SCHEMAS
   	   where XMLEXISTS('$SCH/xs:schema[@targetNamespace=$NS and xs:element[@name=$ELEMENT]]' passing SCHEMA as "SCH", V_ELEMENT_NAME as "ELEMENT", V_NAMESPACE as "NS");

      if (V_GLOBAL_ELEMENT_COUNT = 1) then
  	     
  	     select SCHEMA_URL
   	       into V_SCHEMA_LOCATION_HINT
      	   from ALL_XML_SCHEMAS
      	  where XMLEXISTS('$SCH/xs:schema[@targetNamespace=$NS and xs:element[@name=$ELEMENT]]' passing SCHEMA as "SCH", V_ELEMENT_NAME as "ELEMENT", V_NAMESPACE as "NS");
      else
        --
        -- Try a partial match on the schemaLocationHint
        --
        V_SCHEMA_LOCATION_HINT := expandSchemaLocationHint(V_CURRENT_HINT, V_ELEMENT_NAME, V_NAMESPACE);
      end if;
     
      if (V_SCHEMA_LOCATION_HINT is not NULL) then

        select deleteXML
               (               
                 P_XML,
                 '/*/@xsi:schemaLocation',
   	             DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI
    	         )
      	  into P_XML 
          from DUAL;         

        P_XML := P_XML.createSchemaBasedXML(V_SCHEMA_LOCATION_HINT);

--          
--        if (V_SCHEMA_LOCATION_MAPPING is NULL) then
--       	  P_XML := P_XML.createSchemaBasedXML(V_SCHEMA_LOCATION_HINT);
--     	  else
--       	
--       	  V_SCHEMA_LOCATION_MAPPING := replace(V_SCHEMA_LOCATION_MAPPING,' ' || V_CURRENT_HINT,' ' || V_SCHEMA_LOCATION_HINT);
--       	  
--          select updateXML
--                 (               
--                   P_XML,
--                   '/*/@xsi:schemaLocation',
--      	           V_SCHEMA_LOCATION_MAPPING,
--    	             DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI
--      	         )
--        	  into P_XML 
--            from DUAL;         
--      	   
--         	P_XML := P_XML.createSchemaBasedXML();
--       	   
--        end if;
--
      else
        raise_application_error(-20001, 'Unable to determine the table for Element "' || V_ELEMENT_NAME || '", in Namespace "' || V_NAMESPACE || '" (Schema Location "' || V_SCHEMA_LOCATION_MAPPING || '").' );
      end if;       

    end if;
    
  end if;
      
exception
  when OTHERS then
    raise_application_error(-20002, 'Error processing Element "' || V_ELEMENT_NAME || '" in Namespace "' || V_NAMESPACE || '" (Schema Location "' || V_SCHEMA_LOCATION_MAPPING || '") : ' || SQLERRM);
end;
--
procedure fixEmptyComplexType(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2)
as
  dummyAttribute XMLType := xmlType('<xsd:attribute xmlns:xsd="http://www.w3.org/2001/XMLSchema" name="DUMMY" type="xsd:boolean" use="prohibited"/>');
begin
  select insertChildXML
         (
           P_XML_SCHEMA,
           '/xsd:schema/xsd:complexType[@name="' || P_COMPLEX_TYPE_NAME || '"]',
           'xsd:attribute',
           dummyAttribute,
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA 
    from dual;
end;
--
procedure fixComplexTypeSimpleContent(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SIMPLE_TYPE_NAME VARCHAR2)
as
  complexTypeSimpleContent XMLType := xmlType(
'<xsd:complexType xmlns:xsd="http://www.w3.org/2001/XMLSchema">
   <xsd:simpleContent>
     <xsd:extension base="xsd:anySimpleType">
       <xsd:attribute name="DUMMY" type="xsd:boolean" use="prohibited"/>
     </xsd:extension>
   </xsd:simpleContent>
 </xsd:complexType>');
begin

  select updateXML
         (
           complexTypeSimpleContent,
           '/xsd:complexType/xsd:simpleContent/xsd:extension/@base',
           P_SIMPLE_TYPE_NAME,
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into complexTypeSimpleContent
    from dual;
    
  select insertChildXML
         (
           P_XML_SCHEMA,
           '/xsd:schema/xsd:' || P_GLOBAL_OBJECT || '[@name="' || P_GLOBAL_NAME || '"]//xsd:element[@name = "'|| P_LOCAL_ELEMENT_NAME || '" and @type="' || P_SIMPLE_TYPE_NAME || '"]',
           'xsd:complexType',
           complexTypeSimpleContent,
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA 
    from dual;
    
  select deleteXML
         (
           P_XML_SCHEMA,
           '/xsd:schema/xsd:' || P_GLOBAL_OBJECT || '[@name="' || P_GLOBAL_NAME || '"]//xsd:element[@name = "'|| P_LOCAL_ELEMENT_NAME || '" and @type="' || P_SIMPLE_TYPE_NAME || '"]/@type',
           DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA 
    from dual;

end;
--
procedure addNewEnumerationValue(P_XML_SCHEMA in out XMLType, P_TARGET_XPATH VARCHAR2, P_NEW_ENUMERATION_VALUE VARCHAR2)
is
begin
  if P_XML_SCHEMA.existsNode(P_TARGET_XPATH || '/xsd:simpleType/xsd:restriction',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1 then
    select insertChildXML
           (
             P_XML_SCHEMA,
             P_TARGET_XPATH || '/xsd:simpleType/xsd:restriction',
             'xsd:enumeration',
             XMLType('<xsd:enumeration ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD || ' value="' || P_NEW_ENUMERATION_VALUE || '"/>'),
             DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
           )
      into P_XML_SCHEMA 
      from dual;
  end if;
end;
--
procedure removeAppInfo(P_XML_SCHEMA in out XMLTYPE)
as
begin
  select deleteXML
         (
            P_XML_SCHEMA,
            '/xsd:schema//xsd:annotation/xsd:appinfo',
            DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
         )
    into P_XML_SCHEMA
    from dual;
end;
--
procedure setMaintainDOM(P_XML_SCHEMA in out XMLType, P_PATH_EXPRESSION VARCHAR2, P_VALUE VARCHAR2) 
as
begin
	if (P_XML_SCHEMA.existsNode(P_PATH_EXPRESSION || '/@xdb:maintainDOM',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES)) = 1 then
  select updateXML
         (
            P_XML_SCHEMA,
            P_PATH_EXPRESSION || '/@xdb:maintainDOM',
            lower(P_VALUE),
            DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
          )
     into P_XML_SCHEMA 
     from dual;  
	else
    select insertChildXML
           (
             P_XML_SCHEMA,
             P_PATH_EXPRESSION,
             '@xdb:maintainDOM',
             lower(P_VALUE),
             DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
            )
       into P_XML_SCHEMA 
       from dual;  
  end if;
end;
--
procedure expandAllGroups(P_XML_SCHEMA in out XMLType)
as
  V_GROUP_USAGE         XMLType;
  V_GROUP_USAGE_COMMENT XMLType;
  V_GROUP_DEFINITION    XMLType;
  V_GROUP_MEMBER        XMLType;
  V_EXPANDED_DEFINITION XMLType;
  
  cursor getGroupUsage(XML_SCHEMA XMLType)
  is
  select replace(XPATH,'xs:','xsd:') XPATH, NAMESPACE_PREFIXES, MINOCCURS, MAXOCCURS, NAMESPACE, NAME
    from XMLTABLE
         (
           'declare namespace functx = "http://www.functx.com";
            declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; (: :)
            
            declare function functx:index-of-node ( $nodes as node()* , $nodeToFind as node() ) as xs:integer* 
            {
              for $seq in (1 to count($nodes))
              return $seq[$nodes[$seq] is $nodeToFind]
            };
            
            declare function functx:path-to-node-with-pos ( $node as node()? )  as xs:string 
            {     
              string-join
              (
                for $ancestor in $node/ancestor-or-self::*
                  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
                  return concat
                         (
                           name($ancestor),
       
                           if (count($sibsOfSameName) <= 1) then 
                             ''''
                           else 
                             concat
                             (
                               ''['',
                               functx:index-of-node($sibsOfSameName,$ancestor),
                               '']''
                             )
                         ),
                ''/''
              )
            };
                       
            for $gr in $SCHEMA/xs:schema//xs:group[@ref]
              return
                <Result>
                	<XPATH>{functx:path-to-node-with-pos($gr)}</XPATH>
                	<NAMESPACE_PREFIXES>
                	  { 
                	    for $prefix in fn:distinct-values(fn:in-scope-prefixes($gr))
                	      return 
                           if ($prefix = "") then
                             concat("declare default element namespace """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                           else
                             if ($prefix = "xml") then
                               " "
                             else
                               if ($prefix = "xs") then
                               " "
                               else 
                	               concat("declare namespace ",$prefix," = """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                	  }
                	</NAMESPACE_PREFIXES>
                  <MINOCCURS>{fn:data($gr/@minOccurs)}</MINOCCURS>
                  <MAXOCCURS>{fn:data($gr/@maxOccurs)}</MAXOCCURS>
                  <NAME>{fn:local-name-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAME>
                  <NAMESPACE>{fn:namespace-uri-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAMESPACE>
                </Result>' 
            passing XML_SCHEMA as "SCHEMA"
            columns 
            XPATH               varchar2(1024),
            NAMESPACE_PREFIXES  varchar2(1024),
            MINOCCURS           varchar2(12),
            MAXOCCURS           varchar2(12),
            NAME                varchar2(256),
            NAMESPACE           varchar2(256)  
         )
   order by XPATH desc;

   V_XQUERY VARCHAR2(4000);

begin
   
  for g in getGroupUsage(P_XML_SCHEMA) loop
       
    --
    -- Find the group usage :  </xsd:group//xsd:group ref="name"/>
    --
    
    --
    --
    -- Code needs to be enhanced to deal with schema in namespace other than xs or xsd...
    --
    
    V_XQUERY := g.NAMESPACE_PREFIXES;
    if (instr(V_XQUERY,' namespace xsd = ') = 0) then 
      V_XQUERY := V_XQUERY || ' declare namespace xsd = "http://www.w3.org/2001/XMLSchema"; ';
    end if;
    V_XQUERY := V_XQUERY || g.XPATH;
    
    select XMLQUERY
           (
             V_XQUERY
             passing P_XML_SCHEMA 
             returning CONTENT
           )
      into V_GROUP_USAGE
      from DUAL;

    --
    -- Convert the group usage into a comment and combine with the group definition.
    --

   select XMLCOMMENT(XMLSERIALIZE(DOCUMENT V_GROUP_USAGE AS CLOB))
     into V_GROUP_USAGE_COMMENT
     from DUAL;                    
     
   --
   -- Replace the group usage with a sequence containing the group definition.
   --
    
   select xmlElement
          (
            "xsd:sequence",
            xmlAttributes(DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA  as "xmlns:xsd"),
            V_GROUP_USAGE_COMMENT,
            XMLQuery
            (
              '$GROUPS/xs:schema[@targetNamespace=$NAMESPACE]/xs:group[@name=$NAME]/*'
              passing G_GROUP_DEFINITIONS as "GROUPS",
                      g.NAMESPACE as "NAMESPACE",
                      g.NAME as "NAME"
              returning CONTENT
            )
          )
     into V_EXPANDED_DEFINITION
     from DUAL;       
      
   --
   -- Apply the maxOccurs setting from the group usage to the model from the definition.
   --
       
   if (g.MINOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@minOccurs',
              g.MINOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;
   
   if (g.MAXOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@maxOccurs',
              g.MAXOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;

   select updateXML
          (
            P_XML_SCHEMA ,
            g.XPATH,
            V_EXPANDED_DEFINITION,
            DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
          )
     into P_XML_SCHEMA 
     from DUAL;
    
 end loop;

end;
--
procedure expandRepeatingGroups(P_XML_SCHEMA in out XMLType)
as
  V_GROUP_USAGE         XMLType;
  V_GROUP_USAGE_COMMENT XMLType;
  V_GROUP_DEFINITION    XMLType;
  V_GROUP_MEMBER        XMLType;
  V_EXPANDED_DEFINITION XMLType;
  
  cursor getGroupUsage(XML_SCHEMA XMLType)
  is
  select replace(XPATH,'xs:','xsd:') XPATH, NAMESPACE_PREFIXES, MINOCCURS, MAXOCCURS, NAMESPACE, NAME
    from XMLTABLE
         (
           'declare namespace functx = "http://www.functx.com";
            declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; (: :)
            
            declare function functx:index-of-node ( $nodes as node()* , $nodeToFind as node() ) as xs:integer* 
            {
              for $seq in (1 to count($nodes))
              return $seq[$nodes[$seq] is $nodeToFind]
            };
            
            declare function functx:path-to-node-with-pos ( $node as node()? )  as xs:string 
            {     
              string-join
              (
                for $ancestor in $node/ancestor-or-self::*
                  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
                  return concat
                         (
                           name($ancestor),
       
                           if (count($sibsOfSameName) <= 1) then 
                             ''''
                           else 
                             concat
                             (
                               ''['',
                               functx:index-of-node($sibsOfSameName,$ancestor),
                               '']''
                             )
                         ),
                ''/''
              )
            };
                       
            for $gr in $SCHEMA/xs:schema//xs:group[@ref and ( @maxOccurs="unbounded" or xs:decimal(@maxOccurs) > 1)]
              return
                <Result>
                	<XPATH>{functx:path-to-node-with-pos($gr)}</XPATH>
                	<NAMESPACE_PREFIXES>
                	  { 
                	    for $prefix in fn:distinct-values(fn:in-scope-prefixes($gr))
                	      return 
                           if ($prefix = "") then
                             concat("declare default element namespace """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                           else
                             if ($prefix = "xml") then
                               " "
                             else
                               if ($prefix = "xs") then
                               " "
                               else 
                	               concat("declare namespace ",$prefix," = """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                	  }
                	</NAMESPACE_PREFIXES>
                  <MINOCCURS>{fn:data($gr/@minOccurs)}</MINOCCURS>
                  <MAXOCCURS>{fn:data($gr/@maxOccurs)}</MAXOCCURS>
                  <NAME>{fn:local-name-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAME>
                  <NAMESPACE>{fn:namespace-uri-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAMESPACE>
                </Result>' 
            passing XML_SCHEMA as "SCHEMA"
            columns 
            XPATH               varchar2(1024),
            NAMESPACE_PREFIXES  varchar2(1024),
            MINOCCURS           varchar2(12),
            MAXOCCURS           varchar2(12),
            NAME                varchar2(256),
            NAMESPACE           varchar2(256)  
         )
   order by XPATH desc;

   V_XQUERY VARCHAR2(4000);

begin
   
  for g in getGroupUsage(P_XML_SCHEMA) loop
       
    --
    -- Find the group usage :  </xsd:group//xsd:group ref="name"/>
    --
    
    --
    --
    -- Code needs to be enhanced to deal with schema in namespace other than xs or xsd...
    --
    
    V_XQUERY := g.NAMESPACE_PREFIXES;
    if (instr(V_XQUERY,' namespace xsd = ') = 0) then 
      V_XQUERY := V_XQUERY || ' declare namespace xsd = "http://www.w3.org/2001/XMLSchema"; ';
    end if;
    V_XQUERY := V_XQUERY || g.XPATH;
    
    select XMLQUERY
           (
             V_XQUERY
             passing P_XML_SCHEMA 
             returning CONTENT
           )
      into V_GROUP_USAGE
      from DUAL;

    --
    -- Convert the group usage into a comment and combine with the group definition.
    --

   select XMLCOMMENT(XMLSERIALIZE(DOCUMENT V_GROUP_USAGE AS CLOB))
     into V_GROUP_USAGE_COMMENT
     from DUAL;                    
     
   --
   -- Replace the group usage with a sequence containing the group definition.
   --
    
   select xmlElement
          (
            "xsd:sequence",
            xmlAttributes(DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA  as "xmlns:xsd"),
            V_GROUP_USAGE_COMMENT,
            XMLQuery
            (
              '$GROUPS/xs:schema[@targetNamespace=$NAMESPACE]/xs:group[@name=$NAME]/*'
              passing G_GROUP_DEFINITIONS as "GROUPS",
                      g.NAMESPACE as "NAMESPACE",
                      g.NAME as "NAME"
              returning CONTENT
            )
          )
     into V_EXPANDED_DEFINITION
     from DUAL;       
      
   --
   -- Apply the maxOccurs setting from the group usage to the model from the definition.
   --
       
   if (g.MINOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@minOccurs',
              g.MINOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;
   
   if (g.MAXOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@maxOccurs',
              g.MAXOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;

   select updateXML
          (
            P_XML_SCHEMA ,
            g.XPATH,
            V_EXPANDED_DEFINITION,
            DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
          )
     into P_XML_SCHEMA 
     from DUAL;
    
 end loop;

end;
--
procedure expandGroupGroups(P_XML_SCHEMA in out XMLType)
as
  V_GROUP_USAGE         XMLType;
  V_GROUP_USAGE_COMMENT XMLType;
  V_GROUP_DEFINITION    XMLType;
  V_GROUP_MEMBER        XMLType;
  V_EXPANDED_DEFINITION XMLType;
  
  cursor getGroupUsage(XML_SCHEMA XMLType)
  is
  select replace(XPATH,'xs:','xsd:') XPATH, NAMESPACE_PREFIXES, MINOCCURS, MAXOCCURS, NAMESPACE, NAME
    from XMLTABLE
         (
           'declare namespace functx = "http://www.functx.com";
            declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; (: :)
            
            declare function functx:index-of-node ( $nodes as node()* , $nodeToFind as node() ) as xs:integer* 
            {
              for $seq in (1 to count($nodes))
              return $seq[$nodes[$seq] is $nodeToFind]
            };
            
            declare function functx:path-to-node-with-pos ( $node as node()? )  as xs:string 
            {     
              string-join
              (
                for $ancestor in $node/ancestor-or-self::*
                  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
                  return concat
                         (
                           name($ancestor),
       
                           if (count($sibsOfSameName) <= 1) then 
                             ''''
                           else 
                             concat
                             (
                               ''['',
                               functx:index-of-node($sibsOfSameName,$ancestor),
                               '']''
                             )
                         ),
                ''/''
              )
            };
                       
            for $gr in $GROUPS/xs:schema/xs:group//xs:group[@ref]
              return
                <Result>
                	<XPATH>{functx:path-to-node-with-pos($gr)}</XPATH>
                	<NAMESPACE_PREFIXES>
                	  { 
               	      for $prefix in fn:distinct-values(fn:in-scope-prefixes($gr))
              	        return 
                          if ($prefix = "") then
                            concat("declare default element namespace """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                          else
                            if ($prefix = "xml") then
                              " "
                            else
                              if ($prefix = "xs") then
                                " "
                              else 
                  	            concat("declare namespace ",$prefix," = """,fn:namespace-uri-for-prefix($prefix,$gr),""";")
                  	  }
                  	</NAMESPACE_PREFIXES>
                    <MINOCCURS>{fn:data($gr/@minOccurs)}</MINOCCURS>
                    <MAXOCCURS>{fn:data($gr/@maxOccurs)}</MAXOCCURS>
                    <NAME>{fn:local-name-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAME>
                    <NAMESPACE>{fn:namespace-uri-from-QName(fn:resolve-QName( $gr/@ref, $gr))}</NAMESPACE>
                  </Result>' 
            passing XML_SCHEMA as "GROUPS"
            columns 
            XPATH               varchar2(1024),
            NAMESPACE_PREFIXES  varchar2(1024),
            MINOCCURS           varchar2(12),
            MAXOCCURS           varchar2(12),
            NAME                varchar2(256),
            NAMESPACE           varchar2(256)  
         )
   order by XPATH desc;

begin
   
  for g in getGroupUsage(P_XML_SCHEMA) loop
       
    --
    -- Find the group usage :  </xsd:group//xsd:group ref="name"/>
    --
    
    select XMLQUERY
           (
             g.NAMESPACE_PREFIXES || ' ' || g.XPATH 
             passing P_XML_SCHEMA 
             returning CONTENT
           )
      into V_GROUP_USAGE
      from DUAL;

    --
    -- Convert the group usage into a comment and combine with the group definition.
    --

   select XMLCOMMENT(XMLSERIALIZE(DOCUMENT V_GROUP_USAGE AS CLOB))
     into V_GROUP_USAGE_COMMENT
     from DUAL;                    
     
   --
   -- Replace the group usage with a sequence containing the group definition.
   --
    
   select xmlElement
          (
            "xsd:sequence",
            xmlAttributes(DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA  as "xmlns:xsd"),
            V_GROUP_USAGE_COMMENT,
            XMLQuery
            (
              '$GROUPS/xs:schema[@targetNamespace=$NAMESPACE]/xs:group[@name=$NAME]/*'
              passing G_GROUP_DEFINITIONS as "GROUPS",
                      g.NAMESPACE as "NAMESPACE",
                      g.NAME as "NAME"
              returning CONTENT
            )
          )
     into V_EXPANDED_DEFINITION
     from DUAL;       
      
   --
   -- Apply the maxOccurs setting from the group usage to the model from the definition.
   --
       
   if (g.MINOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@minOccurs',
              g.MINOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;
   
   if (g.MAXOCCURS is not NULL) then
     select insertChildXML
            (
              V_EXPANDED_DEFINITION,
              '/xsd:sequence',
              '@maxOccurs',
              g.MAXOCCURS,
              DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
            )
       into V_EXPANDED_DEFINITION
       from dual;
   end if;

   select updateXML
          (
            P_XML_SCHEMA ,
            g.XPATH,
            V_EXPANDED_DEFINITION,
            DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD
          )
     into P_XML_SCHEMA 
     from DUAL;
    
 end loop;

end;
--
procedure loadGroupDefinitions(P_SCHEMA_FOLDER VARCHAR2) 
as
begin

  select /*+ NO_XML_QUERY_REWRITE */
         XMLAGG(COLUMN_VALUE)
    into G_GROUP_DEFINITIONS 
    from XMLTABLE
         (
           'declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; 
                        
           declare function xdbpm:group-defs ( $schemaList as  node() * ) as node()*
           {           
             let $groupList := for $schema in $schemaList
                                 for $group in $schema/xs:group
                                   return
                               		   <xs:schema>
                               		     {$schema/@targetNamespace,$group}
                               		   </xs:schema>
                                   return $groupList
           }; 
                        
           let $schemaList := fn:collection($XSD_FOLDER_PATH)/xs:schema
           let $groupList := xdbpm:group-defs($schemaList)
           return $groupList'
           passing P_SCHEMA_FOLDER as "XSD_FOLDER_PATH"
         );
 
 	if (G_GROUP_DEFINITIONS is not NULL) then
 	  while G_GROUP_DEFINITIONS.existsNode('/xsd:schema/xsd:group//xsd:group[@ref]','xmlns:xdbpm="http://xmlns.oracle.com/xdb/xdbpm"' || ' ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD) = 1 loop
      expandGroupGroups(G_GROUP_DEFINITIONS);
    end loop;
  else 
    G_GROUP_DEFINITIONS := XMLType('<xsd:schema ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD || '/>');
  end if;  
end;
--
function getGroupDefinitions 
return XMLTYPE
as
begin
  return G_GROUP_DEFINITIONS;
end;
--
procedure saveAnnotatedSchema(P_XML_SCHEMA_PATH VARCHAR2, P_XML_SCHEMA XMLTYPE,P_COMMENT VARCHAR2 DEFAULT NULL)
as
  NOT_VERSIONED exception;
  PRAGMA EXCEPTION_INIT( NOT_VERSIONED , -31190 );

  V_RESOURCE              DBMS_XDBRESOURCE.XDBResource;

  V_RESULT                BOOLEAN;
  V_RESID                 RAW(16);
  V_LOB_LOCATOR           BLOB;
begin
	if (not DBMS_XDB.existsResource(P_XML_SCHEMA_PATH)) then
	  V_RESULT := DBMS_XDB.createResource(P_XML_SCHEMA_PATH,P_XML_SCHEMA);
	else
	  begin
		  DBMS_XDB_VERSION.CHECKOUT(P_XML_SCHEMA_PATH);
    exception
      WHEN NOT_VERSIONED then
        V_RESID := DBMS_XDB_VERSION.makeVersioned(P_XML_SCHEMA_PATH);
        DBMS_XDB_VERSION.checkOut(P_XML_SCHEMA_PATH);
      WHEN OTHERS THEN
        RAISE;
    end;

    -- update RESOURCE_VIEW
    --    set RES = updateXML(RES,'/r:Resource/r:Contents/xsd:schema',P_XML_SCHEMA,DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R || ' ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD)
    --  where equals_path(RES,P_XML_SCHEMA_PATH) = 1;

    V_RESOURCE := DBMS_XDB.getResource(P_XML_SCHEMA_PATH);
    DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_XML_SCHEMA);
    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);
    DBMS_XDBRESOURCE.save(V_RESOURCE);

    V_RESID := DBMS_XDB_VERSION.checkIn(P_XML_SCHEMA_PATH);
  end if;
end;
--     
procedure mapAnyToClob(P_XML_SCHEMA in out XMLType)
as
begin
	 select insertChildXML
          (
             P_XML_SCHEMA,
             '//xsd:any[not(@xdb:SQLTYPE)]',
             '@xdb:SQLType',
             'CLOB',
             DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES
          )
     into P_XML_SCHEMA
     from dual;
end;
--
function DIFF_XML_SCHEMAS(P_OLD_SCHEMA XMLTYPE, P_NEW_SCHEMA XMLTYPE)
return XMLTYPE
as
  V_XMLDIFF XMLTYPE;
begin
  select XMLDIFF(
           XMLQUERY(
            'declare function local:normalizeForDiff($sch as element()) as element() { 
               copy $NEWSCHEMA := $sch modify (
                                         for $ENUM in $NEWSCHEMA//xs:enumeration[text()] return (
                                           delete node $ENUM/text()
                                         ),
                                         for $EXTN in $NEWSCHEMA//xs:extension[text()] return (
                                           delete node $EXTN/text()
                                         )
                                       )   
               return $NEWSCHEMA
             }; (: :)
             local:normalizeForDiff($XMLSCHEMA/xs:schema)'                  
             passing P_OLD_SCHEMA as "XMLSCHEMA"
             returning content
           ),
           XMLQUERY(
            'declare function local:normalizeForDiff($sch as element()) as element() { 
               copy $NEWSCHEMA := $sch modify (
                                         for $ENUM in $NEWSCHEMA//xs:enumeration[text()] return (
                                           delete node $ENUM/text()
                                         ),
                                         for $EXTN in $NEWSCHEMA//xs:extension[text()] return (
                                           delete node $EXTN/text()
                                         )
                                       )   
               return $NEWSCHEMA
             }; (: :)
             local:normalizeForDiff($XMLSCHEMA/xs:schema)'                  
             passing P_NEW_SCHEMA as "XMLSCHEMA"
             returning content
           )
         )
  into V_XMLDIFF
  from DUAL;
  
  return V_XMLDIFF;
end;
--
function generateAnnotationScript(P_XML_SCHEMA XMLTYPE) 
return CLOB
as
  V_SCRIPT CLOB;
  V_XQUERY CLOB := 
'xquery version "1.0";
declare  namespace xdb = "http://xmlns.oracle.com/xdb";
         						 
                    declare function xdb:index-of-node ( $nodes as node()* , $nodeToFind as node() )  
                    as xs:integer* 
                     {
                       for $seq in (1 to count($nodes))
                       return $seq[$nodes[$seq] is $nodeToFind]
                     };
                     
                    declare function xdb:path-to-node-with-pos ( $node as node()? ) 
                    as xs:string 
                     {     
                       string-join
                       (
                         for $ancestor in $node/ancestor-or-self::*
                           let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
                           return concat
                                  (
                                    name($ancestor),
                                    if ($ancestor/@name) then
                                      concat(''[@name="'',$ancestor/@name,''"]'')
                                    else if ($ancestor/@ref) then
                                      concat(''[@name="'',$ancestor/@ref,''"]'')
                                    else if (count($sibsOfSameName) <= 1) then 
                                      ''''
                                    else 
                                      concat(''['',xdb:index-of-node($sibsOfSameName,$ancestor),'']'')
                                  ),
                         ''/''
                       )
                     };
<result>{                     
''declare namespace xdb = "http://xmlns.oracle.com/xdb"; (: :)
copy $NEWSCHEMA := $SCHEMA modify (&#xa;'',
for $schemaNode at $i in //*[@xdb:SQLName]
   return concat(''insert node attribute xdb:SQLName {"'',$schemaNode/@xdb:SQLName,''"} into $NEWSCHEMA/'',xdb:path-to-node-with-pos($schemaNode),'',&#xa;''),
for $schemaNode at $i in //*[@xdb:SQLType]
   return  concat(''insert node attribute xdb:SQLType {"'',$schemaNode/@xdb:SQLType,''"} into $NEWSCHEMA/'',xdb:path-to-node-with-pos($schemaNode),'',&#xa;''),
for $schemaNode at $i in //*[@xdb:SQLCollType]
   return  concat(''insert node attribute xdb:SQLCollType {"'',$schemaNode/@xdb:SQLCollType,''"} into $NEWSCHEMA/'',xdb:path-to-node-with-pos($schemaNode),'',&#xa;''),
for $schemaNode at $i in //*[@xdb:defaultTable]
   return  concat(''insert node attribute xdb:defaultTable {"'',$schemaNode/@xdb:defaultTable,''"} into $NEWSCHEMA/'',xdb:path-to-node-with-pos($schemaNode),'',&#xa;''),
 '') return $NEWSCHEMA''}</result>  ';
begin
  select SCRIPT
    into V_SCRIPT
    from XMLTABLE(
           V_XQUERY 
           passing P_XML_SCHEMA
           columns
             SCRIPT CLOB PATH 'text()'
        );
 	return V_SCRIPT;
end;
--
function generateAnnotationScript(P_SCHEMA_URL VARCHAR2, P_OWNER VARCHAR2) 
return CLOB
as
  V_XMLSCHEMA XMLTYPE;
begin
	 select SCHEMA
     into V_XMLSCHEMA
     from all_xml_schemas
    where SCHEMA_URL = P_SCHEMA_URL
     and OWNER = P_OWNER;
     
	return generateAnnotationScript(V_XMLSCHEMA);
end;
--
procedure expandAllGroups(P_SCHEMA_FOLDER VARCHAR2) 
as
  cursor getSchemas(C_TARGET_FOLDER VARCHAR2) is
  select ANY_PATH, xdburitype(ANY_PATH).getXML() XML_SCHEMA
    from RESOURCE_VIEW
 where under_path(RES,C_TARGET_FOLDER) = 1
   and XMLExists
       (
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
           $RES/Resource[ends-with(DisplayName,".xsd")]'
           passing RES as "RES"
       );
  V_XML_SCHEMA XMLTYPE;
begin
  loadGroupDefinitions(P_SCHEMA_FOLDER);
  for xsd in getSchemas(P_SCHEMA_FOLDER) loop
     --     
     -- Expand any groups in the XML Schema and save the result as the '.xsd' file.
     --
     V_XML_SCHEMA := xsd.XML_SCHEMA;
     XDB_EDIT_XMLSCHEMA.expandAllGroups(V_XML_SCHEMA);
     XDB_EDIT_XMLSCHEMA.saveAnnotatedSchema(xsd.ANY_PATH,V_XML_SCHEMA,'Expanded Groups');
	   commit;
  end loop;
end;
--
function getGroupDefinitions(P_SCHEMA_FOLDER VARCHAR2) 
return XMLTYPE
as
begin
	loadGroupDefinitions(P_SCHEMA_FOLDER);
	return getGroupDefinitions();
end;
--
end;
/
show errors
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--