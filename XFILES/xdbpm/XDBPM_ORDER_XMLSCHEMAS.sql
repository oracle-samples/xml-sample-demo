
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
-- XDPBM_XML_SCHEMA_WIZARD should be created under XDBPM
--
alter session set current_schema = XDBPM
/
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
--
set define on
--
create or replace package XDBPM_ORDER_XMLSCHEMAS
authid CURRENT_USER
as

  function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2 DEFAULT '') return XMLType;
  function getGlobalElementList(P_XML_SCHEMA_CONFIGURATION XMLTYPE) return XMLType;
  
end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
create or replace synonym XDB_ORDER_XML_SCHEMAS for XDBPM_ORDER_XMLSCHEMAS
/
create or replace synonym XDB_ORDER_SCHEMAS for XDBPM_ORDER_XMLSCHEMAS
/
create or replace package body XDBPM_ORDER_XMLSCHEMAS
as
--
  C_NEW_LINE   constant VARCHAR2(2) := CHR(10);
  C_BLANK_LINE constant VARCHAR2(4) := C_NEW_LINE || C_NEW_LINE;
--
  TYPE SCHEMA_LOCATION_LIST_T 
    is TABLE of VARCHAR2(700); 
--  
  TYPE SCHEMA_DEPENDENCY_REC 
  IS RECORD 
  ( 
     SCHEMA_PATH              VARCHAR2(700),
     TARGET_NAMESPACE         VARCHAR2(700),
     DEPENDENCY_LIST          SCHEMA_LOCATION_LIST_T,
     EXTENDED_DEPENDENCY_LIST SCHEMA_LOCATION_LIST_T,
     RECURSIVE_PATH_COUNT     NUMBER
  );
--
  TYPE SCHEMA_DEPENDENCY_LIST_T 
    IS TABLE of SCHEMA_DEPENDENCY_REC;
--
function normalizePath(P_TARGET_PATH VARCHAR2, P_RELATIVE_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2)
return VARCHAR2
as
  V_BASE_FOLDER    VARCHAR2(700);
  V_TARGET_FOLDER  VARCHAR2(700);
  V_RELATIVE_PATH  VARCHAR2(700);
begin

  V_BASE_FOLDER := NULL;
  
  if instr(P_TARGET_PATH,'/',-1) > 1 then
    --
    -- The base URL for any relative locations in import or include elements is everything to the left of the last '/' 
    --
    V_BASE_FOLDER := substr(P_TARGET_PATH,1,instr(P_TARGET_PATH,'/',-1)-1);
  end if;

  V_RELATIVE_PATH := P_RELATIVE_PATH;
  V_TARGET_FOLDER := V_BASE_FOLDER;

  -- The following are treated as relative URLs
  -- URLs with no '/' character
  -- URLs which do not start with '/' and which do not contain '://'
  -- URLS which start with ./

  if ( ( (instr(V_RELATIVE_PATH,'://') = 0) and (instr(V_RELATIVE_PATH,'/') <> 1) )  or (instr(V_RELATIVE_PATH,'./') = 1)) then
  
    if (instr(V_RELATIVE_PATH,'..')  = 1 ) then
      while instr(V_RELATIVE_PATH,'..') = 1 loop
        V_RELATIVE_PATH := substr(V_RELATIVE_PATH,4);
        if (V_TARGET_FOLDER is not NULL) then
          V_TARGET_FOLDER := substr(V_TARGET_FOLDER,1,instr(V_TARGET_FOLDER,'/',-1)-1);
        end if;
      end loop;
    else    
      if (instr(V_RELATIVE_PATH,'./') = 1) then
        V_RELATIVE_PATH := substr(V_RELATIVE_PATH,3);
      end if;
    end if; 

    if (V_TARGET_FOLDER is not NULL) then
      V_RELATIVE_PATH := V_TARGET_FOLDER || '/' || V_RELATIVE_PATH;
    end if;

  end if;     
  
  if ((P_LOCATION_PREFIX is not null) and (P_LOCATION_PREFIX <> '')) THEN
    if (INSTR(P_RELATIVE_PATH,P_LOCATION_PREFIX)=1) THEN
      V_RELATIVE_PATH := V_TARGET_FOLDER || SUBSTR(V_RELATIVE_PATH,LENGTH(P_LOCATION_PREFIX)+1);
    end if;
  end if;
  
  return V_RELATIVE_PATH;

end;
--
function getDependentList(P_XML_SCHEMA XMLTYPE, P_XML_SCHEMA_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2)
return SCHEMA_LOCATION_LIST_T
as
  V_SCHEMA_LOCATION_LIST SCHEMA_LOCATION_LIST_T := SCHEMA_LOCATION_LIST_T();
  
  cursor getSchemaLocationList(C_XML_SCHEMA XMLType)
  is
  select distinct SCHEMA_LOCATION
    from (
           select SCHEMA_LOCATION
             from XMLTable(
                    xmlNamespaces(
                      'http://xmlns.oracle.com/xdb/XDBResource.xsd' as "res",
                      'http://www.w3.org/2001/XMLSchema' as "xsd"
                    ),
                    '/xsd:schema/xsd:import'
                    passing C_XML_SCHEMA
                    columns
                    NAMESPACE       VARCHAR2(700) path '@namespace',
                    SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
                  )
            where NAMESPACE <> 'http://www.w3.org/XML/1998/namespace'
           union all  
           select SCHEMA_LOCATION
             from XMLTable(
                    xmlNamespaces(
                      'http://xmlns.oracle.com/xdb/XDBResource.xsd' as "res",
                      'http://www.w3.org/2001/XMLSchema' as "xsd"
                    ),
                    '/xsd:schema/xsd:include'
                    passing C_XML_SCHEMA
                    columns
                    SCHEMA_LOCATION VARCHAR2(700) path '@schemaLocation'
                 )
         )
   where SCHEMA_LOCATION is not NULL
     and not exists
         ( 
           select 1
             from ALL_XML_SCHEMAS alx
            where alx.SCHEMA_URL = SCHEMA_LOCATION
         );

begin
	for i in getSchemaLocationList(P_XML_SCHEMA)loop
	  V_SCHEMA_LOCATION_LIST.extend();
	  V_SCHEMA_LOCATION_LIST(V_SCHEMA_LOCATION_LIST.LAST) := NORMALIZEPATH(P_XML_SCHEMA_PATH,i.SCHEMA_LOCATION,P_LOCATION_PREFIX);
  end loop;
  return V_SCHEMA_LOCATION_LIST;
end;
--
procedure buildDependencyGraph(P_XML_SCHEMA_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2, P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T) 
as
  V_SCHEMA_DEPENDENCY_REC  SCHEMA_DEPENDENCY_REC;
  V_XML_SCHEMA_PATH        VARCHAR2(700);
  V_XML_SCHEMA             XMLType;

  cursor schemaRegistered
  is
  select 1 
    from ALL_XML_SCHEMAS
   where SCHEMA_URL = P_XML_SCHEMA_PATH;

  cursor getTargetNamespace(C_XML_SCHEMA XMLType)
  is
  select TARGET_NAMESPACE
    from XMLTable(
           xmlNamespaces(
             'http://xmlns.oracle.com/xdb/XDBResource.xsd' as "res",
             'http://www.w3.org/2001/XMLSchema' as "xsd"
           ),
           '/xsd:schema'
           passing C_XML_SCHEMA
           columns
             TARGET_NAMESPACE       VARCHAR2(700) path '@targetNamespace'
         );   
begin
  $IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('  Processing XML Schema : "' || P_XML_SCHEMA_PATH|| '".');
  $END

  -- Check if this schema has already been processed.. 
  
  for s in schemaRegistered loop
    $IF $$DEBUG $THEN
    XDB_OUTPUT.writeTraceFileEntry('Schema already Registered.');
    $END
    return;
  end loop;
  
  for i in 1..P_SCHEMA_DEPENDENCY_LIST.count() loop
    if (P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH = P_XML_SCHEMA_PATH) then
      $IF $$DEBUG $THEN
      XDB_OUTPUT.writeTraceFileEntry('Schema already Processed.');
      $END      
      return;
    end if;
  end loop;
  
	V_XML_SCHEMA := xdburitype(P_XML_SCHEMA_PATH).getXML();

  V_SCHEMA_DEPENDENCY_REC.SCHEMA_PATH := P_XML_SCHEMA_PATH;
  for n in getTargetNamespace(V_XML_SCHEMA) loop
    V_SCHEMA_DEPENDENCY_REC.TARGET_NAMESPACE := n.TARGET_NAMESPACE;
  end loop;
  V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST := getDependentList(V_XML_SCHEMA,P_XML_SCHEMA_PATH,P_LOCATION_PREFIX);

  $IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('Checking Dependencies.');
  $END
  
  P_SCHEMA_DEPENDENCY_LIST.extend();
  P_SCHEMA_DEPENDENCY_LIST(P_SCHEMA_DEPENDENCY_LIST.LAST) := V_SCHEMA_DEPENDENCY_REC;
  
  $IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('Dependency count  = ' || V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST.count());
  $END 
  if (V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST.count() > 0) then
    for i in V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST.FIRST..V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST.LAST loop
      $IF $$DEBUG $THEN
      XDB_OUTPUT.writeTraceFileEntry('Dependency [' || i || '] : = "' || V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST(i) || '".');
      $END     
      V_XML_SCHEMA_PATH:= V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST(i);
      buildDependencyGraph(V_XML_SCHEMA_PATH, P_LOCATION_PREFIX, P_SCHEMA_DEPENDENCY_LIST);
    end loop;
  end if;
  
end;
--
procedure dumpDependencyGraph(P_SCHEMA_DEPENDENCY_LIST SCHEMA_DEPENDENCY_LIST_T)
as
begin
	for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST LOOP
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      XDB_OUTPUT.writeTraceFileEntry('Schema "' || P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH  || '".');
  	  if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.count() > 0) THEN
      	for j in P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.LAST  LOOP
          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.exists(j)) THEN
            XDB_OUTPUT.writeTraceFileEntry('>> "' || P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST(j) || '".');
  	      end if;
  	    end loop;
  	  end if;
  	end if;
  end loop;
end;
--
procedure dumpExtendedGraph(P_SCHEMA_DEPENDENCY_LIST SCHEMA_DEPENDENCY_LIST_T)
as
begin
	for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST LOOP
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      XDB_OUTPUT.writeTraceFileEntry('Schema "' || P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH  || '". Recursive Path count = ' || P_SCHEMA_DEPENDENCY_LIST(i).RECURSIVE_PATH_COUNT || '. Extended Path Count = ' || P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST.count() || '.' );
  	  if (P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST.count() > 0) THEN
      	for j in P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST.LAST  LOOP
          if (P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST.exists(j)) THEN
            XDB_OUTPUT.writeTraceFileEntry('>> "' || P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST(j) || '".');
            NULL;
  	      end if;
  	    end loop;
  	  end if;
  	end if;
  end loop;
end;
--
procedure addDependancies(P_CURRENT_SCHEMA VARCHAR2, P_DEPENDENCY_LOCATION VARCHAR2,P_SCHEMA_LOCATION_LIST IN OUT SCHEMA_LOCATION_LIST_T, P_SCHEMA_DEPENDENCY_LIST SCHEMA_DEPENDENCY_LIST_T,P_RECURSIVE_PATH_COUNT IN OUT NUMBER)
as
begin
	--
	-- Do not reprocess the current schema
	--
$IF $$DEBUG $THEN
	XDB_OUTPUT.writeTraceFileEntry('"' || P_CURRENT_SCHEMA || '" : Checking Dependency "' || P_DEPENDENCY_LOCATION || '".');
$END

  if (P_CURRENT_SCHEMA = P_DEPENDENCY_LOCATION) then
$IF $$DEBUG $THEN
   	XDB_OUTPUT.writeTraceFileEntry('"' || P_CURRENT_SCHEMA || '" : Skipping recursive dependency.');
$END   	
   	P_RECURSIVE_PATH_COUNT := P_RECURSIVE_PATH_COUNT + 1;
    return;
  end if;
  
	--
	-- If the current schema is already in the extended dependency list do not process it again.
	--
	if P_SCHEMA_LOCATION_LIST.count() > 0 then
	  for i in P_SCHEMA_LOCATION_LIST.FIRST .. P_SCHEMA_LOCATION_LIST.LAST loop
	    if (P_SCHEMA_LOCATION_LIST.exists(i)) then
  	    if (P_SCHEMA_LOCATION_LIST(i) = P_DEPENDENCY_LOCATION) then 
$IF $$DEBUG $THEN
        	XDB_OUTPUT.writeTraceFileEntry('"' || P_CURRENT_SCHEMA || '" : Skipping known dependency.');
$END        	
	        return;
	      end if;
	    end if;
    end loop;
  end if;
  
$IF $$DEBUG $THEN
 	XDB_OUTPUT.writeTraceFileEntry('"' || P_CURRENT_SCHEMA || '" : Adding dependancy on "' || P_DEPENDENCY_LOCATION || '".');
$END
  P_SCHEMA_LOCATION_LIST.extend();
  P_SCHEMA_LOCATION_LIST(P_SCHEMA_LOCATION_LIST.LAST) := P_DEPENDENCY_LOCATION;
  
  --
  -- Find the Dependency List for the current schema.
  --   
  for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST loop
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      if (P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH = P_DEPENDENCY_LOCATION) then 
        --
        -- Add each dependent schema to the extended dependancies list
        --
        for j in P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.FIRST .. P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.LAST loop
          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.exists(j)) then
            addDependancies(P_CURRENT_SCHEMA,P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST(j),P_SCHEMA_LOCATION_LIST,P_SCHEMA_DEPENDENCY_LIST,P_RECURSIVE_PATH_COUNT);
          end if;
        end loop;
      end if;
    end if;	
  end loop;
        
end;
--
procedure extendDependencyGraph(P_SCHEMA_DEPENDENCY_LIST  IN OUT SCHEMA_DEPENDENCY_LIST_T)
as
  V_SCHEMA_LOCATION_LIST SCHEMA_LOCATION_LIST_T;
  V_RECURSIVE_PATH_COUNT NUMBER := 0;
begin
  for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST loop
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      V_SCHEMA_LOCATION_LIST := SCHEMA_LOCATION_LIST_T();
      V_RECURSIVE_PATH_COUNT := 0;
      for j in P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.FIRST .. P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.LAST loop
        if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.exists(j)) then
          addDependancies(P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH,P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST(j),V_SCHEMA_LOCATION_LIST,P_SCHEMA_DEPENDENCY_LIST,V_RECURSIVE_PATH_COUNT);
          P_SCHEMA_DEPENDENCY_LIST(i).EXTENDED_DEPENDENCY_LIST := V_SCHEMA_LOCATION_LIST;
          P_SCHEMA_DEPENDENCY_LIST(i).RECURSIVE_PATH_COUNT := V_RECURSIVE_PATH_COUNT;
        end if;
      end loop;
    end if;	
  end loop;
end;
--
function processSchema(P_CURRENT_SCHEMA SCHEMA_DEPENDENCY_REC, P_SCHEMA_FOLDER VARCHAR2, P_LOCATION_PREFIX VARCHAR2, P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T, P_FORCE BOOLEAN)
return XMLType
as
  V_BUFFER               VARCHAR2(32000);
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
  V_NEXT_SCHEMA          XMLType;
begin
	
	V_SCHEMA_LOCATION_HINT := P_LOCATION_PREFIX || SUBSTR(P_CURRENT_SCHEMA.SCHEMA_PATH,LENGTH(P_SCHEMA_FOLDER)+1);
	
	-- Remove leading '/' if the only '/' is the leading '/'
	
	if ((INSTR(V_SCHEMA_LOCATION_HINT,'/') = 1) and (INSTR(V_SCHEMA_LOCATION_HINT,'/',-1) = 1)) then
	  V_SCHEMA_LOCATION_HINT := SUBSTR(V_SCHEMA_LOCATION_HINT,2);
	end if;

  select xmlElement(
           "SchemaInformation",
 					 xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
           xmlElement(
             "schemaLocationHint",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             V_SCHEMA_LOCATION_HINT
           ),           
           xmlElement(
             "targetNamespace",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA.TARGET_NAMESPACE
           ),
           xmlElement(
             "repositoryPath",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA.SCHEMA_PATH
           ),
           xmlElement(
             "force",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE)
           )
         )
    into V_NEXT_SCHEMA
    from dual;

  for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST loop
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.count() > 0) then
        for j in P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.LAST loop
          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.exists(j)) THEN
	          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST(j) = P_CURRENT_SCHEMA.SCHEMA_PATH) THEN
	             P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.delete(j);
	             EXIT;
	          end if;
	        end if;
  	    end loop;
  	  end if;
	  end if;
  end loop;
  
  return V_NEXT_SCHEMA;
end;
--
function processExtendedDependencyList(P_XML_SCHEMA_CONFIGURATION IN OUT XMLType, P_LOCATION_PREFIX VARCHAR2, P_SCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_LIST SCHEMA_LOCATION_LIST_T,P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T)
return XMLType
as
  V_NEXT_SCHEMA       XMLType;
begin
  for i in P_SCHEMA_LOCATION_LIST.FIRST..P_SCHEMA_LOCATION_LIST.LAST  LOOP
    for j in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST  LOOP
      if (P_SCHEMA_DEPENDENCY_LIST.exists(j)) THEN
        if (P_SCHEMA_LOCATION_LIST(i) = P_SCHEMA_DEPENDENCY_LIST(j).SCHEMA_PATH) THEN
          if j < P_SCHEMA_DEPENDENCY_LIST.LAST then
            V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(j),P_SCHEMA_FOLDER,P_LOCATION_PREFIX,P_SCHEMA_DEPENDENCY_LIST,TRUE);
            select appendChildXML
                   (
                     P_XML_SCHEMA_CONFIGURATION,
                     '/SchemaRegistrationConfiguration',
										 V_NEXT_SCHEMA,
										 'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
                   )
              into P_XML_SCHEMA_CONFIGURATION
              from DUAL;
          else
            V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(j),P_SCHEMA_FOLDER,P_LOCATION_PREFIX,P_SCHEMA_DEPENDENCY_LIST,FALSE);
            select appendChildXML
                   (
                     P_XML_SCHEMA_CONFIGURATION,
                     '/SchemaRegistrationConfiguration',
										 V_NEXT_SCHEMA,
										 'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                                         
                   )
              into P_XML_SCHEMA_CONFIGURATION
              from DUAL;
          end if;
          P_SCHEMA_DEPENDENCY_LIST.delete(j);
        end if;
      end if;
    end loop;
  end loop;
  return P_XML_SCHEMA_CONFIGURATION;
end;
--
function  processDependencyGraph(P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T,P_XML_SCHEMA_CONFIGURATION IN OUT XMLTYPE,P_SCHEMA_FOLDER VARCHAR2, P_LOCATION_PREFIX VARCHAR2)
return XMLType
as
  V_SCHEMA_PROCESSED  BOOLEAN := TRUE;
  V_INDEX             BINARY_INTEGER;
  V_NEXT_SCHEMA       XMLType;
begin

	
	WHILE (P_SCHEMA_DEPENDENCY_LIST.count() > 0) loop
  	WHILE (V_SCHEMA_PROCESSED) LOOP
	    V_SCHEMA_PROCESSED := FALSE;
      if (P_SCHEMA_DEPENDENCY_LIST.count() > 0) then
  	    for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST  LOOP
          if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
            if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.count() = 0) THEN
              V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(i),P_SCHEMA_FOLDER,P_LOCATION_PREFIX,P_SCHEMA_DEPENDENCY_LIST,FALSE);
              select appendChildXML
                     (
                       P_XML_SCHEMA_CONFIGURATION,
                       '/SchemaRegistrationConfiguration',
                       V_NEXT_SCHEMA,
										   'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
                     )
                into P_XML_SCHEMA_CONFIGURATION
                from DUAL;
  	          P_SCHEMA_DEPENDENCY_LIST.delete(i);
	            V_SCHEMA_PROCESSED := TRUE;
	            exit;
	          end if;
	        end if;
  	    end LOOP;
  	  end if;
    end LOOP;
   
    if (P_SCHEMA_DEPENDENCY_LIST.count() > 0) THEN
      --
      -- Calculate the complete dependancy list for all remaining schemas.
      --
  	  extendDependencyGraph(P_SCHEMA_DEPENDENCY_LIST);
  	  --
  	  -- Pick the first schema in the list and register it and all but the last dependent schemas with FORCE = TRUE;
  	  -- Register the last dependent schema with FORCE = FALSE, since all cycles should be resolvable.
  	  --
  	  V_INDEX := P_SCHEMA_DEPENDENCY_LIST.FIRST;
  	  V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(V_INDEX),P_SCHEMA_FOLDER,P_LOCATION_PREFIX,P_SCHEMA_DEPENDENCY_LIST,TRUE);
      select appendChildXML
             (
               P_XML_SCHEMA_CONFIGURATION,
               '/SchemaRegistrationConfiguration',
               V_NEXT_SCHEMA,
						   'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
             )
        into P_XML_SCHEMA_CONFIGURATION
        from DUAL;
  	  P_XML_SCHEMA_CONFIGURATION := processExtendedDependencyList(P_XML_SCHEMA_CONFIGURATION, P_LOCATION_PREFIX, P_SCHEMA_FOLDER, P_SCHEMA_DEPENDENCY_LIST(V_INDEX).EXTENDED_DEPENDENCY_LIST,P_SCHEMA_DEPENDENCY_LIST);
      P_SCHEMA_DEPENDENCY_LIST.delete(V_INDEX);
      V_SCHEMA_PROCESSED := TRUE;
    end if; 	  
  end loop;
  return P_XML_SCHEMA_CONFIGURATION;
end;
--
function getFileName(P_PATH VARCHAR2)
return VARCHAR2
as
  V_FILENAME VARCHAR2(4000);
begin
  V_FILENAME := P_PATH;
  V_FILENAME := substr(V_FILENAME,1,instr(V_FILENAME,'.',-1)-1);
	
  if instr(V_FILENAME,'/',-1) > 1 then
	  V_FILENAME := substr(V_FILENAME,instr(V_FILENAME,'/',-1)+1);
	end if;
	
	return V_FILENAME;
end;
--
function generateOutputFilename(P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2,P_FILENAME_PREFIX VARCHAR2,P_FILENAME_SUFFIX VARCHAR2) 
return VARCHAR2
as
  V_FILENAME VARCHAR2(4000);
begin
  if (P_LOCAL_PATH is not null) then
    V_FILENAME := getFileName(P_LOCAL_PATH);
  else
    V_FILENAME := getFileName(P_XML_SCHEMA_FOLDER);
  end if;
  V_FILENAME := P_FILENAME_PREFIX || '.' || V_FILENAME || '.' || P_FILENAME_SUFFIX;
  if (SUBSTR(V_FILENAME,1,1) != '/') then
    V_FILENAME := '/' || V_FILENAME;
  end if;
  return V_FILENAME;
end;
--
function getGlobalElementList(P_XML_SCHEMA_CONFIGURATION XMLTYPE) 
return XMLTYPE
as
  C_XQUERY CONSTANT VARCHAR2(32000)  :=
 'declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; 
  declare namespace xdb = "http://xmlns.oracle.com/xdb";
  declare namespace rc   = "http://xmlns.oracle.com/xdb/pm/registrationConfiguration";

	declare function xdb:index-of-node( $nodes as node()* , $nodeToFind as node()) as xs:integer* {
  	for $seq in (1 to count($nodes))
  	return $seq[$nodes[$seq] is $nodeToFind]
 	} ;
             
  declare function xdbpm:qname-to-string ( $qname as xs:string, $context as node()) as xs:string* { 
    let $qn := fn:resolve-QName( $qname, $context)
    return concat(fn:local-name-from-QName($qn),":",fn:namespace-uri-from-QName($qn))
  }; 
  
  declare function xdbpm:global-elements ( $schemaList as  node() *,  $complexTypeList as  xs:string*) as xs:string* {           
     let $elementList := for $schema in $schemaList/xs:schema
                           for $element in $schema/xs:element[not(@substitutionGroup) and not(@abstract="true") and not(xs:simpleType)]
                             where (($element/@type and (xdbpm:qname-to-string($element/@type,$element) = $complexTypeList)) or $element/xs:complexType)
                     	     return if ($schema/@targetNamespace) then
  		                         concat($element/@name,":",$schema/@targetNamespace)
  		                       else
  		                         concat($element/@name,":")
     let $elementList := fn:distinct-values($elementList)
     return $elementList
  }; 
                      
  declare function xdbpm:ref-elements ( $schemaList as  node()*) as xs:string* {           
    let $refElementList := for $e in $schemaList//xs:element[@ref]
                               return xdbpm:qname-to-string($e/@ref,$e)
    let $refElementList := fn:distinct-values($refElementList)
    return $refElementList
  }; 
  
  declare function xdbpm:getSchemaElement( $schemaList as node()*, $schemaInfo as node()*, $e as xs:string) as node() {
    let $schemas := if (fn:substring-after($e,":") = "") then 
                      $schemaList/xs:schema[not(@targetNamespace) and xs:element[@name=fn:substring-before($e,":")]]
                   else
                      $schemaList/xs:schema[@targetNamespace=fn:substring-after($e,":") and xs:element[@name=fn:substring-before($e,":")]]
    for $sch in $schemas
        let $schemaIndex        := xdb:index-of-node($schemaList/xs:schema,$sch)
        let $schema             := $schemaInfo/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[$schemaIndex]
        let $schemaLocationHint := $schema/rc:schemaLocationHint/text()
        let $repositoryPath     := $schema/rc:repositoryPath/text()
        let $targetNamespace    := fn:data($sch/@targetNamespace)
        order by $targetNamespace, $repositoryPath
        return element rc:Table {
                 element rc:repositoryPath {$repositoryPath},
                 element rc:schemaLocationHint {$schemaLocationHint},
                 element rc:namespace {$targetNamespace},
                 element rc:globalElement{ fn:substring-before($e,":")}
               }
  };
  
  let $schemaList := for $path in $schemaInfo/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:repositoryPath
                       return fn:doc($path/text())

  (: return $schemaList :)
  
  let $complexTypeList := for $schema in $schemaList/xs:schema
                            for $ct in $schema/xs:complexType                          
                              return if ($schema/@targetNamespace) then
  		                                 concat($ct/@name,":",$schema/@targetNamespace)
  		                               else
  		                                concat($ct/@name,":")

  (: return $complexTypeList :)
  
  let $globalElements := xdbpm:global-elements($schemaList,$complexTypeList)

  (: return $globalElements :)
                              
  let $refs := xdbpm:ref-elements($schemaList)
  for $e in $globalElements
    where not ($e = $refs) 
    return xdbpm:getSchemaElement($schemaList, $schemaInfo, $e)';  
    
  V_GLOBAL_ELEMENT_LIST XMLTYPE;
begin
	select XMLQUERY(
	         C_XQUERY 
	         passing P_XML_SCHEMA_CONFIGURATION as "schemaInfo" 
	         returning content
	       )
	  into V_GLOBAL_ELEMENT_LIST
    from dual;
  return V_GLOBAL_ELEMENT_LIST;
end;
--
function orderSchemas(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2) 
return XMLType
as
  V_SCHEMA_DEPENDENCY_LIST          SCHEMA_DEPENDENCY_LIST_T   := SCHEMA_DEPENDENCY_LIST_T();
  V_XML_SCHEMA_CONFIGURATION        XMLTYPE;
  V_GLOBAL_ELEMENT_LIST             XMLTYPE;
  V_TARGET_PATH                     VARCHAR2(4000);
  
  cursor getXMLSchemas
  is
  select ANY_PATH
	  from RESOURCE_VIEW
	 where under_path(res,P_XML_SCHEMA_FOLDER) = 1
	   and XMLExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :) $R/Resource[ends-with(DisplayName,".xsd")]' passing RES as "R");

  V_TRACE_FILENAME             VARCHAR2(700);
  V_CONFIGURATION_FILENAME     VARCHAR2(700);
  V_DELETE_SCRIPT_FILENAME     VARCHAR2(700);
  V_TYPE_OPTIMIZATION_FILENAME VARCHAR2(700);
  V_REGISTER_SCRIPT_FILENAME   VARCHAR2(700);
  V_DOCUMENT_UPLOAD_FILENAME   VARCHAR2(700);
begin  	
 
  V_TRACE_FILENAME             := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'SchemaRegistrationOrdering','log');
  V_CONFIGURATION_FILENAME     := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'SchemaRegistrationConfiguration','xml');
  V_DELETE_SCRIPT_FILENAME     := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'DeleteSchemas','sql');
	V_TYPE_OPTIMIZATION_FILENAME := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'TypeOptimization','log');
  V_REGISTER_SCRIPT_FILENAME   := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'RegisterSchema','sql');
  V_DOCUMENT_UPLOAD_FILENAME   := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,P_LOCAL_PATH,'InstanceUpload','log');

 	XDB_OUTPUT.createOutputFile(V_TRACE_FILENAME,true);
 
  if (P_LOCAL_PATH is NULL) then
    V_TARGET_PATH := P_XML_SCHEMA_FOLDER;
    $IF $$DEBUG $THEN
       XDB_OUTPUT.writeTraceFileEntry('Processing XML Schemas for folder "' || V_TARGET_PATH || '".');
    $END  

  	for x in getXMLSchemas() loop
	    buildDependencyGraph(x.ANY_PATH, P_LOCATION_PREFIX, V_SCHEMA_DEPENDENCY_LIST);  
	  end loop;
  else
    V_TARGET_PATH := P_XML_SCHEMA_FOLDER || '/' || P_LOCAL_PATH;
    $IF $$DEBUG $THEN
       XDB_OUTPUT.writeTraceFileEntry('Processing XML Schema "' || V_TARGET_PATH || '".');
    $END
    
    buildDependencyGraph(P_XML_SCHEMA_FOLDER || '/' || P_LOCAL_PATH, P_LOCATION_PREFIX, V_SCHEMA_DEPENDENCY_LIST);  
  end if;
   
  $IF $$DEBUG $THEN
    dumpDependencyGraph(V_SCHEMA_DEPENDENCY_LIST);
    XDB_OUTPUT.flushTraceFile();
  $END
  
	select XMLElement("SchemaRegistrationConfiguration", 
	         xmlAttributes(
	            'http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns",
	            P_LOCATION_PREFIX as "schemaLocationPrefix",
	            V_TARGET_PATH as "target"
	         ),
	         xmlElement("FileNames",
	           xmlElement("registrationConfigurationFile",V_CONFIGURATION_FILENAME),
	           xmlElement("registrationScriptFile",V_REGISTER_SCRIPT_FILENAME),
	           xmlElement("deleteScriptFile",V_DELETE_SCRIPT_FILENAME),
             xmlElement("schemaOrderingTraceFile",V_TRACE_FILENAME),
	           xmlElement("typeOptimizationTraceFile",V_TYPE_OPTIMIZATION_FILENAME),
	           xmlElement("instanceUploadLog",V_DOCUMENT_UPLOAD_FILENAME)
           )
	       )
	  into V_XML_SCHEMA_CONFIGURATION
	  from DUAL;
	
  V_XML_SCHEMA_CONFIGURATION := processDependencyGraph(V_SCHEMA_DEPENDENCY_LIST, V_XML_SCHEMA_CONFIGURATION, P_XML_SCHEMA_FOLDER, P_LOCATION_PREFIX);
  V_GLOBAL_ELEMENT_LIST := getGlobalElementList(V_XML_SCHEMA_CONFIGURATION) ;

  select XMLQUERY(
          'declare default element namespace "http://xmlns.oracle.com/xdb/pm/registrationConfiguration"; (: :)
           copy $NEWXML := $CONFIG modify (
                                     for $TARGET in $NEWXML/SchemaRegistrationConfiguration
                                         return insert nodes $TABLES as last into $TARGET
                                   )
                 return $NEWXML'
           passing V_XML_SCHEMA_CONFIGURATION as "CONFIG",
                   V_GLOBAL_ELEMENT_LIST as "TABLES"
           returning content
         )
    into V_XML_SCHEMA_CONFIGURATION
    from dual;
    
  XDB_UTILITIES.uploadResource(V_CONFIGURATION_FILENAME,V_XML_SCHEMA_CONFIGURATION,XDB_CONSTANTS.VERSION);
  XDB_OUTPUT.flushOutputFile();
  
  return V_XML_SCHEMA_CONFIGURATION;
end;
--
function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2 DEFAULT '')
return XMLType
--
-- Generate the Schema Ordering Document for a particular XML Schema or all the schemas in a particular folder.
-- 
-- P_OUTPUT_FOLDER          : The target folder for the Ordering document and log file. 
--                       
-- P_XML_SCHEMA_FOLDER       : The folder containing all the XML Schemas required to successfully register the specified XML Schema.
--
-- P_LOCAL_PATH             : The relative path (from P_XML_SCHEMA_FOLDER) to the primary XML Schema.
--
-- P_LOCATION_PREFIX        : The prefix for the schema location hint to be used when registering the XML Schema. The prefix will be concatenated 
--                            with the value of P_LOCAL_PATH to create the schema location hint. 
--                            
as
  V_XML_SCHEMA_CONFIGURATION        XMLTYPE;
begin
  V_XML_SCHEMA_CONFIGURATION := orderSchemas(P_OUTPUT_FOLDER, P_XML_SCHEMA_FOLDER, P_LOCAL_PATH, P_LOCATION_PREFIX); 
  return V_XML_SCHEMA_CONFIGURATION;
end;
--
begin
	NULL;
	$IF $$DEBUG $THEN
    XDB_OUTPUT.createTraceFile('/public/XDBPM_ORDER_XMLSCHEMAS.log');
  $END
end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
grant execute on XDBPM_ORDER_XMLSCHEMAS to public
/