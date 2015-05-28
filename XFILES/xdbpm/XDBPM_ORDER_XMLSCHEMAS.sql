
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
-- XDPBM_XMLSCHEMA_WIZARD should be created under XDBPM
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

  procedure schemaOrderingScript(P_OUTPUT_FOLDER VARCHAR2, P_XMLSCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2, P_XMLSCHEMA_PATH VARCHAR2 DEFAULT NULL);
  function orderSchemas(P_XMLSCHEMA_FOLDER VARCHAR2, P_XMLSCHEMA_PATH VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2) return XMLType;
  function listGlobalElements(P_XMLSCHEMA_PATHS XMLTYPE) return XMLTYPE;

end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
create or replace synonym XDB_ORDER_XMLSCHEMAS for XDBPM_ORDER_XMLSCHEMAS
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
  V_BASE_FOLDER   VARCHAR2(700);
  V_TARGET_FOLDER  VARCHAR2(700);
  V_RELATIVE_PATH VARCHAR2(700);
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
  
  if (P_LOCATION_PREFIX is not null) THEN
    if (INSTR(P_RELATIVE_PATH,P_LOCATION_PREFIX)=1) THEN
      V_RELATIVE_PATH := V_TARGET_FOLDER || SUBSTR(V_RELATIVE_PATH,LENGTH(P_LOCATION_PREFIX)+1);
    end if;
  end if;
  
  return V_RELATIVE_PATH;

end;
--
function getDependentList(P_TARGET_SCHEMA VARCHAR2, P_LOCATION_PREFIX VARCHAR2)
return SCHEMA_LOCATION_LIST_T
as
  V_XML_SCHEMA           XMLType;
  V_SCHEMA_LOCATION_LIST SCHEMA_LOCATION_LIST_T;
  
  cursor getSchemaLocationList(C_XML_SCHEMA XMLType)
  is
  select distinct SCHEMA_LOCATION
    from (
           select SCHEMA_LOCATION
             from XMLTable
                  (
                    xmlNamespaces
                    (
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
             from XMLTable
                  (
                    xmlNamespaces
                    (
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
	DBMS_OUTPUT.PUT_LINE(P_TARGET_SCHEMA);
	V_XML_SCHEMA := xdburitype(P_TARGET_SCHEMA).getXML();
	V_SCHEMA_LOCATION_LIST := SCHEMA_LOCATION_LIST_T();
	for i in getSchemaLocationList(V_XML_SCHEMA)loop
	  V_SCHEMA_LOCATION_LIST.extend();
	  V_SCHEMA_LOCATION_LIST(V_SCHEMA_LOCATION_LIST.LAST) := NORMALIZEPATH(P_TARGET_SCHEMA,i.SCHEMA_LOCATION,P_LOCATION_PREFIX);
  end loop;
  return V_SCHEMA_LOCATION_LIST;
end;
--
procedure buildDependencyGraph(P_TARGET_SCHEMA VARCHAR2, P_LOCATION_PREFIX VARCHAR2, P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T) 
as
  V_SCHEMA_DEPENDENCY_REC  SCHEMA_DEPENDENCY_REC;
  V_TARGET_SCHEMA          VARCHAR2(700);
  
  cursor schemaRegistered
  is
  select 1 
    from ALL_XML_SCHEMAS
   where SCHEMA_URL = P_TARGET_SCHEMA;
   
begin
$IF $$DEBUG $THEN
   XDB_OUTPUT.writeTraceFileEntry('  Processing XML Schema : "' || P_TARGET_SCHEMA|| '".');
$END

  -- Check if this schema has already been processed.. 
  
  for s in schemaRegistered loop
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeTraceFileEntry('Schema already Registered.');
$END
    return;
  end loop;
  

  for i in 1..P_SCHEMA_DEPENDENCY_LIST.count() loop
    if (P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH = P_TARGET_SCHEMA) then
$IF $$DEBUG $THEN
      XDB_OUTPUT.writeTraceFileEntry('Schema already Processed.');
$END      
      return;
    end if;
  end loop;
  
  V_SCHEMA_DEPENDENCY_REC.SCHEMA_PATH := P_TARGET_SCHEMA;
  V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST := getDependentList(P_TARGET_SCHEMA,P_LOCATION_PREFIX);

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
      V_TARGET_SCHEMA := V_SCHEMA_DEPENDENCY_REC.DEPENDENCY_LIST(i);
      buildDependencyGraph(V_TARGET_SCHEMA, P_LOCATION_PREFIX, P_SCHEMA_DEPENDENCY_LIST);
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
function processSchema(P_CURRENT_SCHEMA VARCHAR2, P_SCHEMA_FOLDER VARCHAR2, P_LOCATION_HINT_PREFIX VARCHAR2, P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T, P_FORCE BOOLEAN)
return XMLType
as
  V_BUFFER               VARCHAR2(32000);
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
  V_NEXT_SCHEMA          XMLType;
  V_FORCE_OPTION         VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
begin
	
	V_SCHEMA_LOCATION_HINT := P_LOCATION_HINT_PREFIX || SUBSTR(P_CURRENT_SCHEMA,LENGTH(P_SCHEMA_FOLDER)+1);
	
	-- Remove leading '/' if the only '/' is the leading '/'
	
	if ((INSTR(V_SCHEMA_LOCATION_HINT,'/') = 1) and (INSTR(V_SCHEMA_LOCATION_HINT,'/',-1) = 1)) then
	  V_SCHEMA_LOCATION_HINT := SUBSTR(V_SCHEMA_LOCATION_HINT,2);
	end if;

  select xmlElement
         (
           "Schema",
 					 xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
           xmlElement
           (
             "SchemaLocationHint",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             V_SCHEMA_LOCATION_HINT
           ),           
           xmlElement
           (
             "RepositoryPath",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA
           ),
           xmlElement
           (
             "Force",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             V_FORCE_OPTION
           )
         )
    into V_NEXT_SCHEMA
    from dual;

  for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST loop
    if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
      if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.count() > 0) then
        for j in P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.LAST loop
          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.exists(j)) THEN
	          if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST(j) = P_CURRENT_SCHEMA) THEN
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
function processExtendedDependencyList(P_SCHEMA_ORDERING IN OUT XMLType, P_LOCATION_HINT_PREFIX VARCHAR2, P_SCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_LIST SCHEMA_LOCATION_LIST_T,P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T)
return XMLType
as
  V_NEXT_SCHEMA       XMLType;
begin
  for i in P_SCHEMA_LOCATION_LIST.FIRST..P_SCHEMA_LOCATION_LIST.LAST  LOOP
    for j in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST  LOOP
      if (P_SCHEMA_DEPENDENCY_LIST.exists(j)) THEN
        if (P_SCHEMA_LOCATION_LIST(i) = P_SCHEMA_DEPENDENCY_LIST(j).SCHEMA_PATH) THEN
          if j < P_SCHEMA_DEPENDENCY_LIST.LAST then
            V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(j).SCHEMA_PATH,P_SCHEMA_FOLDER,P_LOCATION_HINT_PREFIX,P_SCHEMA_DEPENDENCY_LIST,TRUE);
            select appendChildXML
                   (
                     P_SCHEMA_ORDERING,
                     '/RegistrationList',
										 V_NEXT_SCHEMA,
										 'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
                   )
              into P_SCHEMA_ORDERING
              from DUAL;
          else
            V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(j).SCHEMA_PATH,P_SCHEMA_FOLDER,P_LOCATION_HINT_PREFIX,P_SCHEMA_DEPENDENCY_LIST,FALSE);
            select appendChildXML
                   (
                     P_SCHEMA_ORDERING,
                     '/RegistrationList',
										 V_NEXT_SCHEMA,
										 'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                                         
                   )
              into P_SCHEMA_ORDERING
              from DUAL;
          end if;
          P_SCHEMA_DEPENDENCY_LIST.delete(j);
        end if;
      end if;
    end loop;
  end loop;
  return P_SCHEMA_ORDERING;
end;
--
function  processDependencyGraph(P_SCHEMA_DEPENDENCY_LIST IN OUT SCHEMA_DEPENDENCY_LIST_T,P_SCHEMA_FOLDER VARCHAR2, P_LOCATION_HINT_PREFIX VARCHAR2)
return XMLType
as
  V_SCHEMA_PROCESSED  BOOLEAN := TRUE;
  V_INDEX             BINARY_INTEGER;
  V_SCHEMA_ORDERING   XMLType;
  V_NEXT_SCHEMA       XMLType;
begin

	select XMLElement("RegistrationList", xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns")) 
	  into V_SCHEMA_ORDERING
	  from DUAL;
	
	WHILE (P_SCHEMA_DEPENDENCY_LIST.count() > 0) loop
  	WHILE (V_SCHEMA_PROCESSED) LOOP
	    V_SCHEMA_PROCESSED := FALSE;
      if (P_SCHEMA_DEPENDENCY_LIST.count() > 0) then
  	    for i in P_SCHEMA_DEPENDENCY_LIST.FIRST..P_SCHEMA_DEPENDENCY_LIST.LAST  LOOP
          if (P_SCHEMA_DEPENDENCY_LIST.exists(i)) THEN
            if (P_SCHEMA_DEPENDENCY_LIST(i).DEPENDENCY_LIST.count() = 0) THEN
              V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(i).SCHEMA_PATH,P_SCHEMA_FOLDER,P_LOCATION_HINT_PREFIX,P_SCHEMA_DEPENDENCY_LIST,FALSE);
              select appendChildXML
                     (
                       V_SCHEMA_ORDERING,
                       '/RegistrationList',
                       V_NEXT_SCHEMA,
										   'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
                     )
                into V_SCHEMA_ORDERING
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
  	  V_NEXT_SCHEMA := processSchema(P_SCHEMA_DEPENDENCY_LIST(V_INDEX).SCHEMA_PATH,P_SCHEMA_FOLDER,P_LOCATION_HINT_PREFIX,P_SCHEMA_DEPENDENCY_LIST,TRUE);
      select appendChildXML
             (
               V_SCHEMA_ORDERING,
               '/RegistrationList',
               V_NEXT_SCHEMA,
						   'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
             )
        into V_SCHEMA_ORDERING
        from DUAL;
  	  V_SCHEMA_ORDERING := processExtendedDependencyList(V_SCHEMA_ORDERING, P_LOCATION_HINT_PREFIX, P_SCHEMA_FOLDER, P_SCHEMA_DEPENDENCY_LIST(V_INDEX).EXTENDED_DEPENDENCY_LIST,P_SCHEMA_DEPENDENCY_LIST);
      P_SCHEMA_DEPENDENCY_LIST.delete(V_INDEX);
      V_SCHEMA_PROCESSED := TRUE;
    end if; 	  
  end loop;
  return V_SCHEMA_ORDERING;
end;
--
function orderSchemas(P_XMLSCHEMA_FOLDER VARCHAR2, P_XMLSCHEMA_PATH VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2) 
return XMLType
as
  V_SCHEMA_DEPENDENCY_LIST SCHEMA_DEPENDENCY_LIST_T   := SCHEMA_DEPENDENCY_LIST_T();
  V_SCHEMA_ORDERING        XMLTYPE;
begin  	

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('Processing XML Schema "' || P_XMLSCHEMA_FOLDER || '/' || P_XMLSCHEMA_PATH || '".');
$END
  buildDependencyGraph(P_XMLSCHEMA_FOLDER || '/' || P_XMLSCHEMA_PATH, P_SCHEMA_LOCATION_PREFIX, V_SCHEMA_DEPENDENCY_LIST);  

$IF $$DEBUG $THEN
  dumpDependencyGraph(V_SCHEMA_DEPENDENCY_LIST);
  XDB_OUTPUT.flushTraceFile();
$END
  V_SCHEMA_ORDERING := processDependencyGraph(V_SCHEMA_DEPENDENCY_LIST, P_XMLSCHEMA_FOLDER, P_SCHEMA_LOCATION_PREFIX);
  return V_SCHEMA_ORDERING;
end;
--
function orderSchemas(P_XMLSCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2) 
return XMLType
as
  V_SCHEMA_DEPENDENCY_LIST SCHEMA_DEPENDENCY_LIST_T   := SCHEMA_DEPENDENCY_LIST_T();
  V_SCHEMA_ORDERING        XMLTYPE;
  
  cursor getXMLSchemas
  is
  select ANY_PATH
	  from RESOURCE_VIEW
	 where under_path(res,P_XMLSCHEMA_FOLDER) = 1
	   and XMLExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :) $R/Resource[ends-with(DisplayName,".xsd")]' passing RES as "R");

begin
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('Processing XML Schemas for folder "' || P_XMLSCHEMA_FOLDER || '".');
$END  
  
	for x in getXMLSchemas() loop
	  buildDependencyGraph(x.ANY_PATH, P_SCHEMA_LOCATION_PREFIX, V_SCHEMA_DEPENDENCY_LIST);  
	end loop;

$IF $$DEBUG $THEN
  dumpDependencyGraph(V_SCHEMA_DEPENDENCY_LIST);
  XDB_OUTPUT.flushTraceFile();
$END
  
  V_SCHEMA_ORDERING := processDependencyGraph(V_SCHEMA_DEPENDENCY_LIST, P_XMLSCHEMA_FOLDER, P_SCHEMA_LOCATION_PREFIX);
  return V_SCHEMA_ORDERING;
end;
--
procedure declareExceptions(P_SCRIPT IN OUT CLOB)
as
  V_BUFFER     VARCHAR2(32000);
begin
    V_BUFFER := '  GENERIC_ERROR exception;' || C_NEW_LINE;
    DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

    V_BUFFER := '  PRAGMA EXCEPTION_INIT( GENERIC_ERROR , -31061 ); ' || C_BLANK_LINE;
    DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

    V_BUFFER := '  NO_MATCHING_NODES exception;' || C_NEW_LINE;
    DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

    V_BUFFER := '  PRAGMA EXCEPTION_INIT( NO_MATCHING_NODES , -64405 ); ' || C_BLANK_LINE;
    DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
end;
--
procedure addExceptionBlock(P_SCRIPT IN OUT CLOB,P_STATEMENT VARCHAR2)
as
  V_BUFFER     VARCHAR2(32000);
begin

  V_BUFFER := '  begin ' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(P_STATEMENT),P_STATEMENT);
     
  V_BUFFER := '  exception ' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  V_BUFFER := '    when GENERIC_ERROR or NO_MATCHING_NODES then' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  V_BUFFER := '      NULL;' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  V_BUFFER := '    when OTHERS then ' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  V_BUFFER := '      RAISE;' || C_NEW_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  V_BUFFER := '  end;' || C_BLANK_LINE;
  DBMS_LOB.WRITEAPPEND(P_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

end;
--
procedure schemaOrderingScript(P_OUTPUT_FOLDER VARCHAR2, P_XMLSCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2, P_XMLSCHEMA_PATH VARCHAR2 DEFAULT NULL) 
--
-- Generate the Schema Ordering Script for a particular XML Schema. 
-- 
-- P_OUTPUT_FOLDER          : The target folder for all scripts and log files.
--                       
-- P_XMLSCHEMA_FOLDER       : The folder containing all the XML Schemas required to successfully register the specified XML Schema.
--
-- P_XMLSCHEMA_PATH         : The relative path (from P_XMLSCHEMA_FOLDER) to the xsd file to be registered.
--
-- P_SCHEMA_LOCATION_PREFIX : The prefix for the schema location hint to be used when registering the XML Schema. The prefix will be concatenated 
--                            with the value of P_XMLSCHEMA_PATH to create the schema location hint. 
--                            
as
  V_SCHEMA_ORDERING        XMLTYPE;
  V_SCHEMA_FILE            VARCHAR2(700);
  V_SCHEMA_NAME            VARCHAR2(700);
  V_SCRIPT_FILE            VARCHAR2(700);
  V_TRACE_FILE             VARCHAR2(700);
  V_CONFIGURATION_FILE     VARCHAR2(700);
  V_COMMENT                VARCHAR2(4000);
  V_RESULT                 BOOLEAN;
begin

	if (P_XMLSCHEMA_PATH is NULL) then
	  V_SCHEMA_NAME := P_XMLSCHEMA_FOLDER;
  else
    --
    -- Assume Schema Path ends in ".xsd"
    --
    V_SCHEMA_NAME := P_XMLSCHEMA_PATH;
    V_SCHEMA_NAME := substr(V_SCHEMA_NAME,1,instr(V_SCHEMA_NAME,'.',-1)-1);
  end if;

  if instr(V_SCHEMA_NAME,'/',-1) > 1 then
	  V_SCHEMA_NAME := substr(V_SCHEMA_NAME,instr(V_SCHEMA_NAME,'/',-1)+1);
	end if;

  V_TRACE_FILE         := P_OUTPUT_FOLDER || '/' || V_SCHEMA_NAME || '.log';
  V_SCRIPT_FILE        := P_OUTPUT_FOLDER || '/' || V_SCHEMA_NAME || '.sql';
  V_CONFIGURATION_FILE := P_OUTPUT_FOLDER || '/' || V_SCHEMA_NAME || '.xml';
  
	XDB_OUTPUT.createOutputFile(V_TRACE_FILE,true);

  if (P_XMLSCHEMA_PATH is not null) then
    V_SCHEMA_ORDERING := orderSchemas(P_XMLSCHEMA_FOLDER, P_XMLSCHEMA_PATH, P_SCHEMA_LOCATION_PREFIX);
  else
    V_SCHEMA_ORDERING := orderSchemas(P_XMLSCHEMA_FOLDER, P_SCHEMA_LOCATION_PREFIX);
  end if;

  if DBMS_XDB.existsResource(V_CONFIGURATION_FILE) then
    DBMS_XDB.deleteResource(V_CONFIGURATION_FILE);
  end if;
  
  V_RESULT := DBMS_XDB.createResource(V_CONFIGURATION_FILE,V_SCHEMA_ORDERING); 
  commit;
  
  if (P_XMLSCHEMA_PATH is NULL) then
    V_COMMENT :=  '--' ||  C_NEW_LINE || '-- Schema Registration Script for folder "' || P_XMLSCHEMA_FOLDER || C_NEW_LINE || '--' || C_NEW_LINE;
  else
    V_COMMENT :=  '--' ||  C_NEW_LINE || '-- Schema Registration Script for XMLSchema "' || P_XMLSCHEMA_FOLDER || '/' || P_XMLSCHEMA_PATH || C_NEW_LINE || '--' || C_NEW_LINE;
  end if;

  XDB_OPTIMIZE_XMLSCHEMA.printSchemaRegistrationScript(V_SCRIPT_FILE, V_COMMENT, V_SCHEMA_ORDERING, P_XMLSCHEMA_FOLDER);	

end;
--
function listGlobalElements(P_XMLSCHEMA_PATHS XMLTYPE) 
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
        let $schema             := $schemaInfo/rc:RegistrationList/rc:Schema[$schemaIndex]
        let $schemaLocationHint := $schema/rc:SchemaLocationHint/text()
        let $repositoryPath     := $schema/rc:RepositoryPath/text()
        let $targetNamespace    := fn:data($sch/@targetNamespace)
        order by $targetNamespace, $repositoryPath
        return element table {
                 element repositoryPath {$repositoryPath},
                 element schemaLocationHint {$schemaLocationHint},
                 element namespace {$targetNamespace},
                 element globalElement{ fn:substring-before($e,":")}
               }
  };
  
  let $schemaList := for $path in $schemaInfo/rc:RegistrationList/rc:Schema/rc:RepositoryPath
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
	         passing P_XMLSCHEMA_PATHS as "schemaInfo" 
	         returning content
	       )
	  into V_GLOBAL_ELEMENT_LIST
    from dual;
  return V_GLOBAL_ELEMENT_LIST;
end;
--
end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
grant execute on XDBPM_ORDER_XMLSCHEMAS to public
/