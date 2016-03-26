
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
--
set define on
--
create or replace package XDBPM_ORDER_XMLSCHEMAS
authid CURRENT_USER
as

  function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH_LIST XDB.XDB$STRING_LIST_T DEFAULT XDB.XDB$STRING_LIST_T(), P_LOCATION_PREFIX VARCHAR2 DEFAULT '') return XMLTYPE;
  function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2 DEFAULT '') return XMLTYPE;
  function getGlobalElementList(P_XML_SCHEMA_CONFIGURATION XMLTYPE) return XMLType;
	function getGlobalElementList(P_PATH VARCHAR2) return XMLTYPE;
  
end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
create or replace synonym XDB_ORDER_XML_SCHEMAS for XDBPM_ORDER_XMLSCHEMAS
/
create or replace synonym XDB_ORDER_SCHEMAS for XDBPM_ORDER_XMLSCHEMAS
/
grant execute on XDBPM_ORDER_XMLSCHEMAS to public
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
  TYPE XMLSCHEMA_INFORMATION_REC 
  IS RECORD ( 

     REPOSITORY_PATH                VARCHAR2(700),
     SCHEMA_LOCATION_HINT           VARCHAR2(700),
     TARGET_NAMESPACE               VARCHAR2(700),
     DEPENDENT_SCHEMA_LIST          SCHEMA_LOCATION_LIST_T,
     CHECKED                        BOOLEAN
  );
--
  TYPE XMLSCHEMA_INFORMATION_LIST_T 
    IS TABLE of XMLSCHEMA_INFORMATION_REC;
--
function normalizePath(P_TARGET_PATH VARCHAR2, P_RELATIVE_PATH VARCHAR2)
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
  
  return V_RELATIVE_PATH;

end;
--
function getDependantList(P_XML_SCHEMA XMLTYPE, P_XML_SCHEMA_PATH VARCHAR2)
return SCHEMA_LOCATION_LIST_T
/*
**
** Get the List of Includes and Imports for the current XML Schema.
**
*/
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

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.getDependantList():  Processing Include and Import nodes');
$END

	for i in getSchemaLocationList(P_XML_SCHEMA)loop
	  V_SCHEMA_LOCATION_LIST.extend();
	  V_SCHEMA_LOCATION_LIST(V_SCHEMA_LOCATION_LIST.LAST) := NORMALIZEPATH(P_XML_SCHEMA_PATH,i.SCHEMA_LOCATION);
  end loop;

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.getDependantList():    Referenced Schema count  = ' || V_SCHEMA_LOCATION_LIST.count());
$END

  return V_SCHEMA_LOCATION_LIST;
end;
--
procedure addSchema(P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T, P_XML_SCHEMA_PATH VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2) 
as

  V_XMLSCHEMA_INFORMATION_REC  XMLSCHEMA_INFORMATION_REC;
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
	--
  -- Check if this schema has already been processed..   
  --
  
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.addSchema(): Checking XML Schema : "' || P_XML_SCHEMA_PATH|| '".');
$END

  for s in schemaRegistered loop
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.addSchema():  Schema already Registered.');
$END
    return;
  end loop;
  
  for i in 1..P_XMLSCHEMA_INFORMATION_LIST.count() loop
    if ((P_XML_SCHEMA_PATH = P_XMLSCHEMA_INFORMATION_LIST(i).REPOSITORY_PATH) or (P_XML_SCHEMA_PATH = P_XMLSCHEMA_INFORMATION_LIST(i).SCHEMA_LOCATION_HINT))then
$IF $$DEBUG $THEN
      XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.addSchema():  Schema already Processed.');
$END
      return;
    end if;
  end loop;
  
  --
  -- Process XML Schema..
  --

  XDB_OUTPUT.writeLogFileEntry('Processing Schema "' || P_XML_SCHEMA_PATH|| '".',TRUE);

	-- Locate the XML Schema.

  V_XMLSCHEMA_INFORMATION_REC.SCHEMA_LOCATION_HINT := P_XML_SCHEMA_PATH;

  if (DBMS_XDB.existsResource(P_XML_SCHEMA_PATH)) then
    V_XMLSCHEMA_INFORMATION_REC.REPOSITORY_PATH := P_XML_SCHEMA_PATH;
  else
    begin
    	--
	    -- Match by XSD Name within the XML Schema Folder Stucture
      --
  	  select ANY_PATH
        into V_XMLSCHEMA_INFORMATION_REC.REPOSITORY_PATH 
        from RESOURCE_VIEW
       where under_path(res,P_XML_SCHEMA_FOLDER) = 1
         and XMLExists(
              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :) 
               $R/Resource[DisplayName=$NAME]'
               passing RES as "R",
               substr(P_XML_SCHEMA_PATH,instr(P_XML_SCHEMA_PATH,'/',-1)+1) as "NAME"
             );
            
      --
      -- Check if Schema was already processed using repository_path rather then schema location hint.
      --      
             
      for i in 1..P_XMLSCHEMA_INFORMATION_LIST.count() loop
        if (V_XMLSCHEMA_INFORMATION_REC.REPOSITORY_PATH = P_XMLSCHEMA_INFORMATION_LIST(i).REPOSITORY_PATH)then
         P_XMLSCHEMA_INFORMATION_LIST(i).SCHEMA_LOCATION_HINT := P_XML_SCHEMA_PATH;
         return;
       end if;
      end loop;
      
    exception
      when NO_DATA_FOUND then
        -- Throw 31001 Error
				V_XML_SCHEMA := xdburitype(P_XML_SCHEMA_PATH).getXML();
		  when TOO_MANY_ROWS then
        -- Throw 31001 Error
				V_XML_SCHEMA := xdburitype(P_XML_SCHEMA_PATH).getXML();
      when OTHERS then
        raise;
    end;
 
  end if;
  
  V_XML_SCHEMA := xdburitype(V_XMLSCHEMA_INFORMATION_REC.REPOSITORY_PATH).getXML();
	
  for n in getTargetNamespace(V_XML_SCHEMA) loop
    V_XMLSCHEMA_INFORMATION_REC.TARGET_NAMESPACE := n.TARGET_NAMESPACE;
  end loop;
  
  V_XMLSCHEMA_INFORMATION_REC.DEPENDENT_SCHEMA_LIST := getDependantList(V_XML_SCHEMA, V_XMLSCHEMA_INFORMATION_REC.REPOSITORY_PATH);

  P_XMLSCHEMA_INFORMATION_LIST.extend();  
  P_XMLSCHEMA_INFORMATION_LIST(P_XMLSCHEMA_INFORMATION_LIST.LAST) := V_XMLSCHEMA_INFORMATION_REC;
  
  if (V_XMLSCHEMA_INFORMATION_REC.DEPENDENT_SCHEMA_LIST.count() > 0) then
    for i in V_XMLSCHEMA_INFORMATION_REC.DEPENDENT_SCHEMA_LIST.FIRST..V_XMLSCHEMA_INFORMATION_REC.DEPENDENT_SCHEMA_LIST.LAST loop
      V_XML_SCHEMA_PATH:= V_XMLSCHEMA_INFORMATION_REC.DEPENDENT_SCHEMA_LIST(i);
      /*
      ** if (instr(V_XML_SCHEMA_PATH,P_LOCATION_PREFIX) = 1) then
      **    V_XML_SCHEMA_PATH := P_XML_SCHEMA_FOLDER || '/' || substr(V_XML_SCHEMA_PATH,length(P_LOCATION_PREFIX)+2);
      ** end if;
      */
      addSchema(P_XMLSCHEMA_INFORMATION_LIST, V_XML_SCHEMA_PATH, P_XML_SCHEMA_FOLDER);
    end loop;
  end if;
  

end;
--
procedure dumpRequiredSchemaList(P_XMLSCHEMA_INFORMATION_LIST XMLSCHEMA_INFORMATION_LIST_T)
as
begin
	for i in P_XMLSCHEMA_INFORMATION_LIST.FIRST..P_XMLSCHEMA_INFORMATION_LIST.LAST LOOP
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.dumpRequiredSchemaList(): Schema "' || P_XMLSCHEMA_INFORMATION_LIST(i).SCHEMA_LOCATION_HINT || '".');
	  if (P_XMLSCHEMA_INFORMATION_LIST(i).DEPENDENT_SCHEMA_LIST.count() > 0) THEN
    	for j in P_XMLSCHEMA_INFORMATION_LIST(i).DEPENDENT_SCHEMA_LIST.FIRST..P_XMLSCHEMA_INFORMATION_LIST(i).DEPENDENT_SCHEMA_LIST.LAST  LOOP
        XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '--> "' || P_XMLSCHEMA_INFORMATION_LIST(i).DEPENDENT_SCHEMA_LIST(j) || '".');
	    end loop;
	  end if;
  end loop;
end;
--
function getSchemaIndex(P_SCHEMA_LOCATION_HINT VARCHAR2, P_XMLSCHEMA_INFORMATION_LIST XMLSCHEMA_INFORMATION_LIST_T)
return PLS_INTEGER
as
--
-- Return the Index of the specified Schema Location Hint.
--
  V_XIL_INDEX            PLS_INTEGER;
begin
  V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
  while (V_XIL_INDEX is not NULL) loop
    if (P_SCHEMA_LOCATION_HINT = P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).SCHEMA_LOCATION_HINT) then
      return V_XIL_INDEX;
    end if; 
    V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_XIL_INDEX);
  end loop; 	
  return NULL;
end;
--
function isCyclicSchema(P_SCHEMA_LOCATION_HINT VARCHAR2, P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T, P_XIL_INDEX PLS_INTEGER)
return BOOLEAN
as
  V_DSL_INDEX             PLS_INTEGER;
  V_DEPENDENT_SCHEMA_LIST SCHEMA_LOCATION_LIST_T;
begin 
	if NOT(P_XMLSCHEMA_INFORMATION_LIST(P_XIL_INDEX).CHECKED) THEN
  	P_XMLSCHEMA_INFORMATION_LIST(P_XIL_INDEX).CHECKED := TRUE;
  	V_DEPENDENT_SCHEMA_LIST := P_XMLSCHEMA_INFORMATION_LIST(P_XIL_INDEX).DEPENDENT_SCHEMA_LIST;
  	
  	-- 
  	-- Check the Dependent Schema List for the specified Schema.
  	--
  
  	V_DSL_INDEX := V_DEPENDENT_SCHEMA_LIST.first;
  	while (V_DSL_INDEX is not NULL) loop
      XDB_OUTPUT.writeLogFileEntry('  Checking Schema : "' || V_DEPENDENT_SCHEMA_LIST(V_DSL_INDEX) ||'"',TRUE);
  	  if (P_SCHEMA_LOCATION_HINT = V_DEPENDENT_SCHEMA_LIST(V_DSL_INDEX)) then
        return TRUE;
      end if;
      V_DSL_INDEX := V_DEPENDENT_SCHEMA_LIST.next(V_DSL_INDEX);
    end loop;
     
  	-- 
  	-- Recusively check the Dependent Schema List for anything required by this Schema.
  	--
  
  	V_DSL_INDEX := V_DEPENDENT_SCHEMA_LIST.first;
  	while (V_DSL_INDEX is not NULL) loop
      XDB_OUTPUT.writeLogFileEntry('  Checking dependent Schemas for : "' || V_DEPENDENT_SCHEMA_LIST(V_DSL_INDEX) ||'"',TRUE);
  		if (isCyclicSchema(P_SCHEMA_LOCATION_HINT,P_XMLSCHEMA_INFORMATION_LIST,getSchemaIndex(V_DEPENDENT_SCHEMA_LIST(V_DSL_INDEX),P_XMLSCHEMA_INFORMATION_LIST))) then
  		  return TRUE;
  		end if;
  		V_DSL_INDEX := V_DEPENDENT_SCHEMA_LIST.next(V_DSL_INDEX);
  	end loop;
  end if;  	
  return FALSE;
end;
--
procedure resetCycleDetectionFlags(P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T) 
as
  V_XIL_INDEX            PLS_INTEGER;
begin

  V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
  WHILE (V_XIL_INDEX is not NULL) loop
    P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).CHECKED := FALSE;
    V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_XIL_INDEX);
  end	 LOOP;
end;
--
function locateCycle(P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T) 
return number
as
-- 
-- Return the index of one of the XML Schemas that form the cycle that is preventing further processing of the set of XML Schemas.
-- 
  V_XIL_INDEX            PLS_INTEGER;
  V_DSL_INDEX            PLS_INTEGER;
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
begin

  V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
  WHILE (V_XIL_INDEX is not NULL) loop
  	resetCycleDetectionFlags(P_XMLSCHEMA_INFORMATION_LIST);
    V_SCHEMA_LOCATION_HINT := P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).SCHEMA_LOCATION_HINT;
    XDB_OUTPUT.writeLogFileEntry('Checking cyclic dependency chain for Schema : "' || V_SCHEMA_LOCATION_HINT ||'"',TRUE);
    if (isCyclicSchema(V_SCHEMA_LOCATION_HINT,P_XMLSCHEMA_INFORMATION_LIST,V_XIL_INDEX)) then
      XDB_OUTPUT.writeLogFileEntry('Schema "' || V_SCHEMA_LOCATION_HINT ||'" belongs to a cyclic dependency chain',TRUE);
      return V_XIL_INDEX;
    end if;
    V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_XIL_INDEX);
  end	 LOOP;

  XDB_OUTPUT.writeLogFileEntry('Failed to detect a cyclic dependency chain',TRUE);
	return P_XMLSCHEMA_INFORMATION_LIST.first;
end;
--
function processSchema(P_CURRENT_SCHEMA IN OUT XMLSCHEMA_INFORMATION_REC, P_SCHEMA_FOLDER VARCHAR2, P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T, P_FORCE BOOLEAN)
return XMLType
as
  V_BUFFER               VARCHAR2(32000);
  V_NEXT_SCHEMA          XMLType;
  V_XIL_INDEX            PLS_INTEGER;
  V_DSL_INDEX            PLS_INTEGER;

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  -- Workaround for problem with using XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR directly in the select statement below  
  V_FORCE                VARCHAR2(5) :=  XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
  -- Workaround for problem with using XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR directly in the select statement below  
  V_FORCE                VARCHAR2(5) :=  XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
  -- Workaround for problem with using XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR directly in the select statement below  
  V_FORCE                VARCHAR2(5) :=  XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);
$ELSE 
$END

begin
	
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT || '.prcoessSchema(): "' || P_CURRENT_SCHEMA.SCHEMA_LOCATION_HINT ||'"',TRUE);
$END

  select xmlElement(
           "SchemaInformation",
 					 xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
           xmlElement(
             "schemaLocationHint",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA.SCHEMA_LOCATION_HINT
           ),           
           xmlElement(
             "targetNamespace",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA.TARGET_NAMESPACE
           ),
           xmlElement(
             "repositoryPath",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
             P_CURRENT_SCHEMA.REPOSITORY_PATH
           ),
           xmlElement(
             "force",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns"),
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
             V_FORCE
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
             V_FORCE
$ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
             V_FORCE
$ELSE 
             XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE)
$END
           )
         )
    into V_NEXT_SCHEMA
    from dual;

  V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
  WHILE (V_XIL_INDEX is not NULL) loop
    V_DSL_INDEX := P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).DEPENDENT_SCHEMA_LIST.first;
    WHILE (V_DSL_INDEX is not NULL) loop
      if (P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).DEPENDENT_SCHEMA_LIST(V_DSL_INDEX) = P_CURRENT_SCHEMA.SCHEMA_LOCATION_HINT) THEN
        P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).DEPENDENT_SCHEMA_LIST.delete(V_DSL_INDEX);
        EXIT;
	    end if;
	    V_DSL_INDEX := P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).DEPENDENT_SCHEMA_LIST.next(V_DSL_INDEX);
    end loop;
    V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_XIL_INDEX);
  end loop;
  
  return V_NEXT_SCHEMA;
end;
--
function  processSchemaList(P_XMLSCHEMA_INFORMATION_LIST IN OUT XMLSCHEMA_INFORMATION_LIST_T, P_XML_SCHEMA_CONFIGURATION IN OUT XMLTYPE, P_SCHEMA_FOLDER VARCHAR2)
return XMLType
as
  V_FORCE_MODE               BOOLEAN := TRUE;
  V_INDEX                    PLS_INTEGER;
  V_XIL_INDEX                PLS_INTEGER;
  V_MSL_INDEX                PLS_INTEGER;
  V_DSL_INDEX                PLS_INTEGER;
 
  V_NEXT_SCHEMA              XMLType;
	V_CYCLIC_DEPENDANCY_LIST   SCHEMA_LOCATION_LIST_T := SCHEMA_LOCATION_LIST_T();
begin
	
	WHILE (P_XMLSCHEMA_INFORMATION_LIST.first is not NULL) loop

    V_FORCE_MODE := TRUE;
	
	  -- First check if a cyclic dependancy has been detected. 
	  -- Any schemas in this list must be registered FORCE before looking elsewhere 
	  -- Choose first Schema from list
	
	  if (V_CYCLIC_DEPENDANCY_LIST.first is not NULL) then
      V_MSL_INDEX := V_CYCLIC_DEPENDANCY_LIST.first;
      V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
      while (V_XIL_INDEX is not NULL) loop
        if (P_XMLSCHEMA_INFORMATION_LIST(V_XIL_INDEX).SCHEMA_LOCATION_HINT = V_CYCLIC_DEPENDANCY_LIST(V_MSL_INDEX)) then
          V_INDEX := V_XIL_INDEX;
          XDB_OUTPUT.writeLogFileEntry('Processing Dependant Schema "' || P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).SCHEMA_LOCATION_HINT || '" (FORCE).',TRUE);
          EXIT;
        end if;
        V_XIL_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_XIL_INDEX);
      end loop;
      V_CYCLIC_DEPENDANCY_LIST.delete(V_MSL_INDEX);
    else
    
      --
      -- Search for schemas with empty dependant schema lists
      -- Choose first schema that meets the criteria
      --

  	  V_INDEX := P_XMLSCHEMA_INFORMATION_LIST.first;
    	WHILE (V_INDEX is not null) loop
      	if (P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).DEPENDENT_SCHEMA_LIST.count = 0) THEN
		      V_FORCE_MODE := FALSE;
          XDB_OUTPUT.writeLogFileEntry('Processing Schema "' || P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).SCHEMA_LOCATION_HINT || '".',TRUE);
  	      EXIT;
    	  end if;
      	V_INDEX := P_XMLSCHEMA_INFORMATION_LIST.next(V_INDEX);
    	end LOOP;
    
    	-- If V_FORCE_MODE is TRUE at this point then we have a cyclic dependancy somewhere in the remaining schemas.
    	-- Locate the set of XML Schemas that form the cycle and register the first schema in the cycle with FORCE = TRUE.
    
	    if (V_FORCE_MODE) THEN
	      V_INDEX := locateCycle(P_XMLSCHEMA_INFORMATION_LIST);
        XDB_OUTPUT.writeLogFileEntry('Processing Schema "' || P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).SCHEMA_LOCATION_HINT || '" (FORCE).',TRUE);
      end if;
  	end if;

    if (V_FORCE_MODE) then
      --
	    -- Add all dependant schema list entries for the chosen schema to the Missing Schema List.
  	  --    	  
   	  V_DSL_INDEX := P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).DEPENDENT_SCHEMA_LIST.first;
  		while (V_DSL_INDEX is not NULL) loop
      	V_MSL_INDEX := V_CYCLIC_DEPENDANCY_LIST.first;
      	while (V_MSL_INDEX is not null) loop
        	if (V_CYCLIC_DEPENDANCY_LIST(V_MSL_INDEX) = P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).DEPENDENT_SCHEMA_LIST(V_DSL_INDEX)) then
          	EXIT;
        	end if;
        	V_MSL_INDEX := V_CYCLIC_DEPENDANCY_LIST.next(V_MSL_INDEX);
      	end loop;
      	if (V_MSL_INDEX is NULL) then
        	V_CYCLIC_DEPENDANCY_LIST.extend();
        	V_CYCLIC_DEPENDANCY_LIST(V_CYCLIC_DEPENDANCY_LIST.last) := P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).DEPENDENT_SCHEMA_LIST(V_DSL_INDEX);
      	end if;
      	V_DSL_INDEX := P_XMLSCHEMA_INFORMATION_LIST(V_INDEX).DEPENDENT_SCHEMA_LIST.next(V_DSL_INDEX);
    	end loop;     
		end if;

  	V_NEXT_SCHEMA := processSchema(P_XMLSCHEMA_INFORMATION_LIST(V_INDEX),P_SCHEMA_FOLDER,P_XMLSCHEMA_INFORMATION_LIST,V_FORCE_MODE);
    select appendChildXML(
             P_XML_SCHEMA_CONFIGURATION,
             '/SchemaRegistrationConfiguration',
             V_NEXT_SCHEMA,
						 'xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"'                     
           )
      into P_XML_SCHEMA_CONFIGURATION
      from DUAL;

    P_XMLSCHEMA_INFORMATION_LIST.delete(V_INDEX);

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
  if ((instr(V_FILENAME,'.',-1) > 1) and (instr(V_FILENAME,'.',-1) > instr(V_FILENAME,'/',-1))) then
    V_FILENAME := substr(V_FILENAME,1,instr(V_FILENAME,'.',-1)-1);
	end if;
	
  if instr(V_FILENAME,'/',-1) > 1 then
	  V_FILENAME := substr(V_FILENAME,instr(V_FILENAME,'/',-1)+1);
	end if;
	
	return V_FILENAME;
end;
--
procedure uploadResource(P_FILENAME VARCHAR2,P_CONTENT XMLTYPE)
as
  pragma autonomous_transaction;
begin
  XDB_UTILITIES.uploadResource(P_FILENAME, P_CONTENT, XDB_CONSTANTS.VERSION);
  commit;
end;
--
function generateOutputFilename(P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2,P_FILENAME_PREFIX VARCHAR2,P_FILENAME_SUFFIX VARCHAR2) 
return VARCHAR2
as
  V_FILENAME VARCHAR2(4000);
begin
  if (P_LOCAL_PATH is null) then
    V_FILENAME := getFileName(P_XML_SCHEMA_FOLDER);
  else
    V_FILENAME := getFileName(P_LOCAL_PATH);
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
  
  declare function xdbpm:getSchemaElement( $schemaList as node()*, $schemaInfo as node()*, $e as xs:string) as node()* {
    let $schemas := if (fn:substring-after($e,":") = "") then 
                      $schemaList/xs:schema[not(@targetNamespace) and xs:element[@name=fn:substring-before($e,":")]]
                   else
                      $schemaList/xs:schema[@targetNamespace=fn:substring-after($e,":") and xs:element[@name=fn:substring-before($e,":")]]
    for $sch in $schemas
        let $schemaIndex        := xdb:index-of-node($schemaList/xs:schema,$sch)
        let $schema             := $schemaInfo/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[$schemaIndex]
        let $repositoryPath     := $schema/rc:repositoryPath/text()
        let $schemaLocationHint := $schema/rc:schemaLocationHint/text()
        let $targetNamespace    := fn:data($sch/@targetNamespace)
        order by $targetNamespace, $repositoryPath
        return element rc:element {
                 element rc:repositoryPath {$repositoryPath}
                ,element rc:schemaLocationHint {$schemaLocationHint}
                ,element rc:namespace {$targetNamespace}
                ,element rc:name{ fn:substring-before($e,":")} 
               } 
  };
  
  let $schemaList := for $path in $schemaInfo/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:repositoryPath
                       return fn:doc($path/text())

  let $complexTypeList := for $schema in $schemaList/xs:schema
                            for $ct in $schema/xs:complexType                          
                              return if ($schema/@targetNamespace) then
  		                                 concat($ct/@name,":",$schema/@targetNamespace)
  		                               else
  		                                concat($ct/@name,":")

  let $globalElements := xdbpm:global-elements($schemaList,$complexTypeList)
  let $refs := xdbpm:ref-elements($schemaList)
  
  let $results := for $e in $globalElements
                    where not ($e = $refs) 
                    return xdbpm:getSchemaElement($schemaList, $schemaInfo, $e)
    
   return element rc:elements{$results}
  ';
    
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
function orderSchemas(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATHS XDB$STRING_LIST_T) 
return XMLType
as
  V_XMLSCHEMA_INFORMATION_LIST           XMLSCHEMA_INFORMATION_LIST_T   := XMLSCHEMA_INFORMATION_LIST_T();
  V_XML_SCHEMA_CONFIGURATION        XMLTYPE;
  V_GLOBAL_ELEMENT_LIST             XMLTYPE;
  V_TARGET_PATH                     VARCHAR2(4000);
  
  cursor getXMLSchemas
  is
  select ANY_PATH
	  from RESOURCE_VIEW
	 where under_path(res,P_XML_SCHEMA_FOLDER) = 1
	   and XMLExists('declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :) $R/Resource[ends-with(DisplayName,".xsd") and not(ends-with(DisplayName,".xdb.xsd"))]' passing RES as "R");

  V_SCRIPT_FILENAME   VARCHAR2(700);
  V_TRACE_FILENAME             VARCHAR2(700);
  V_CONFIGURATION_FILENAME     VARCHAR2(700);
  V_DELETE_SCRIPT_FILENAME     VARCHAR2(700);
  V_TYPE_OPTIMIZATION_FILENAME VARCHAR2(700);
  V_DOCUMENT_UPLOAD_FILENAME   VARCHAR2(700);
  
  V_LOCATION_PREFIX            VARCHAR2(700);
begin  	

  V_TARGET_PATH := NULL;
  if (P_LOCAL_PATHS.count = 1) then
     V_TARGET_PATH := P_LOCAL_PATHS(1);
  end if;     
   
  V_SCRIPT_FILENAME            := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,V_TARGET_PATH,'scriptFile','sql');
  V_TRACE_FILENAME             := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,V_TARGET_PATH,'schemaOrdering','log');
  V_CONFIGURATION_FILENAME     := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,V_TARGET_PATH,'registrationConfiguration','xml');
	V_TYPE_OPTIMIZATION_FILENAME := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,V_TARGET_PATH,'typeOptimization','log');
  V_DOCUMENT_UPLOAD_FILENAME   := P_OUTPUT_FOLDER || generateOutputFileName(P_XML_SCHEMA_FOLDER,V_TARGET_PATH,'loadInstances','log');

	select XMLElement("SchemaRegistrationConfiguration", 
	         xmlAttributes(
	            'http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "xmlns",
	            P_XML_SCHEMA_FOLDER as "repositoryFolder",
	            P_XML_SCHEMA_FOLDER as "schemaLocationPrefix"
	         ),
	         xmlElement("FileNames",
	           xmlElement("registrationConfigurationFile",V_CONFIGURATION_FILENAME),
	           xmlElement("scriptFilename",V_SCRIPT_FILENAME),
             xmlElement("schemaOrderingLogFile",V_TRACE_FILENAME),
	           xmlElement("typeOptimizationLogFile",V_TYPE_OPTIMIZATION_FILENAME),
	           xmlElement("instanceLogFile",V_DOCUMENT_UPLOAD_FILENAME)
           )
	       )
	  into V_XML_SCHEMA_CONFIGURATION
	  from DUAL;

 	XDB_OUTPUT.createLogFile(V_TRACE_FILENAME,true);
  XDB_OUTPUT.writeLogFileEntry('Folder: "' || P_XML_SCHEMA_FOLDER || '".');	
  XDB_OUTPUT.writeLogFileEntry('Phase 1 [Generating Schema List]: Started.',TRUE);
 
  if (P_LOCAL_PATHS.count = 0) then
  	for x in getXMLSchemas() loop
	    addSchema(V_XMLSCHEMA_INFORMATION_LIST, x.ANY_PATH, P_XML_SCHEMA_FOLDER);  
	  end loop;
  else
    for i in 1..P_LOCAL_PATHS.count loop
      V_TARGET_PATH := P_XML_SCHEMA_FOLDER || '/' || P_LOCAL_PATHS(i);
      addSchema(V_XMLSCHEMA_INFORMATION_LIST, V_TARGET_PATH, P_XML_SCHEMA_FOLDER);  
    end loop;
  end if;

  XDB_OUTPUT.writeLogFileEntry('Phase 1 [Generating Schema List]: Complete.',TRUE);
   
$IF $$DEBUG $THEN
  dumpRequiredSchemaList(V_XMLSCHEMA_INFORMATION_LIST);
$END
  
  XDB_OUTPUT.writeLogFileEntry('Phase 2 [Processing Schema List]: Started.',TRUE);
	
	if (V_XMLSCHEMA_INFORMATION_LIST.count > 0) then
    V_XML_SCHEMA_CONFIGURATION := processSchemaList(V_XMLSCHEMA_INFORMATION_LIST, V_XML_SCHEMA_CONFIGURATION, P_XML_SCHEMA_FOLDER);
  end if;

  XDB_OUTPUT.writeLogFileEntry('Phase 2 [Processing Schema List]: Completed.',TRUE);
  XDB_OUTPUT.writeLogFileEntry('Phase 3 [Global Element Analysis]: Started.',TRUE);
  V_GLOBAL_ELEMENT_LIST := getGlobalElementList(V_XML_SCHEMA_CONFIGURATION) ;
  XDB_OUTPUT.writeLogFileEntry('Phase 3 [Global Element Analysis]: Completed.',TRUE);

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
    
  uploadResource(V_CONFIGURATION_FILENAME,V_XML_SCHEMA_CONFIGURATION);
  XDB_OUTPUT.flushLogFile();
  
  return V_XML_SCHEMA_CONFIGURATION;
end;
--
function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH_LIST XDB.XDB$STRING_LIST_T DEFAULT XDB.XDB$STRING_LIST_T(), P_LOCATION_PREFIX VARCHAR2 DEFAULT '')
return XMLType
--
-- Generate the Schema Ordering Document for a particular XML Schema, a set of XML Schemas or all the schemas in a particular folder.
-- 
-- P_OUTPUT_FOLDER          : The target folder for the Ordering document and log file. 
--                       
-- P_XML_SCHEMA_FOLDER      : The folder containing all the XML Schemas required to successfully register the specified XML Schema.
--
-- P_LOCAL_PATHS            : The relative path (from P_XML_SCHEMA_FOLDER) of a set of XML Schemas.
--
-- P_LOCATION_PREFIX        : The prefix for the schema location hint to be used when registering the XML Schema. The prefix will be concatenated 
--                            with the value of P_LOCAL_PATH to create the schema location hint. 
--                            
as
  V_XML_SCHEMA_CONFIGURATION        XMLTYPE;
begin	         
  V_XML_SCHEMA_CONFIGURATION := orderSchemas(P_OUTPUT_FOLDER, P_XML_SCHEMA_FOLDER, P_LOCAL_PATH_LIST); 
  return V_XML_SCHEMA_CONFIGURATION;
end;
--
function createSchemaOrderingDocument(P_OUTPUT_FOLDER VARCHAR2, P_XML_SCHEMA_FOLDER VARCHAR2, P_LOCAL_PATH VARCHAR2, P_LOCATION_PREFIX VARCHAR2 DEFAULT '') 
return XMLTYPE
as
  V_LOCAL_PATH_LIST XDB.XDB$STRING_LIST_T := XDB.XDB$STRING_LIST_T();
begin
	V_LOCAL_PATH_LIST(1) := P_LOCAL_PATH;
	return createSchemaOrderingDocument(P_OUTPUT_FOLDER, P_XML_SCHEMA_FOLDER, V_LOCAL_PATH_LIST) ;
end;
--	
function getGlobalElementList(P_PATH VARCHAR2)
return XMLTYPE
as
  C_XQUERY CONSTANT VARCHAR2(32000)  :=
 'declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; 
  declare namespace xdb = "http://xmlns.oracle.com/xdb";
             
  declare function xdbpm:qname-to-string ( $qname as xs:string, $context as node()) as xs:string* { 
    let $qn := fn:resolve-QName( $qname, $context)
    return concat(fn:namespace-uri-from-QName($qn),":",fn:local-name-from-QName($qn))
  }; 
  
  declare function xdbpm:getGlobalElements ( $schemaList as  node() *,  $complexTypeList as  xs:string*) as xs:string* {           
     let $elementList := for $schema in $schemaList/xs:schema
                           for $element in $schema/xs:element[not(@substitutionGroup) and not(@abstract="true") and not(xs:simpleType)]
                               where (($element/@type and (xdbpm:qname-to-string($element/@type,$element) = $complexTypeList)) or $element/xs:complexType)
                     	         return concat($schema/@targetNamespace,":",$element/@name)
     let $elementList := fn:distinct-values($elementList)
     return $elementList
  }; 
                      
  declare function xdbpm:getRefBasedElements ( $schemaList as  node()*) as xs:string* {           
    let $refElementList := for $e in $schemaList//xs:element[@ref]
                               return xdbpm:qname-to-string($e/@ref,$e)
    let $refElementList := fn:distinct-values($refElementList)
    return $refElementList
  }; 
  
  let $schemaList := for $doc in fn:collection($schemaFolder)[/xs:schema]
                         return $doc

  let $complexTypeList := for $schema in $schemaList/xs:schema
                            for $ct in $schema/xs:complexType                          
                              return concat($schema/@targetNamespace,":",$ct/@name)
  
  let $globalElementList := xdbpm:getGlobalElements($schemaList,$complexTypeList)

  let $refBasedElementList := xdbpm:getRefBasedElements($schemaList)

  let $elementList := for $e in $globalElementList
  									      		  where not ($e = $refBasedElementList) 
                                return element GlobalElement {$e}

	
  return element GlobalElementList {$elementList}';
    
  V_GLOBAL_ELEMENT_LIST XMLTYPE;
begin   
	select XMLQUERY(
	         C_XQUERY 
	         passing P_PATH as "schemaFolder"
	         returning content
	       )
	  into V_GLOBAL_ELEMENT_LIST
    from dual;
    
  select xmlElement(
           "GlobalElementList",
           xmlAgg(
             xmlElement(
               "GlobalElement",
               xmlElement("name",SUBSTR(QNAME,INSTR(QNAME,':',-1)+1)),
               xmlElement("namespace",SUBSTR(QNAME,1,INSTR(QNAME,':',-1)-1)),
               xmlElement("repositoryPath",ANY_PATH)
             )
           )
         )
    into V_GLOBAL_ELEMENT_LIST
    from RESOURCE_VIEW,
         XMLTABLE(
           '/GlobalElementList/GlobalElement'
           passing V_GLOBAL_ELEMENT_LIST 
           columns
             QNAME VARCHAR2(4000) path '.'
         ) 
   where under_path(RES,P_PATH) = 1
     and XMLExists(
          'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :) 
           $R/Resource[ends-with(DisplayName,".xsd") and not(ends-with(DisplayName,".xdb.xsd"))]' 
           passing RES as "R"
         )
     and XMLEXISTS(
           '$SCHEMA/xs:schema[@targetNamespace=$TNS]/xs:element[@name=$NAME]'
           passing xdburitype(ANY_PATH).getXML() as "SCHEMA",
                   SUBSTR(QNAME,INSTR(QNAME,':',-1)+1) as "NAME",
                   SUBSTR(QNAME,1,INSTR(QNAME,':',-1)-1) as "TNS"
         );
             
  return V_GLOBAL_ELEMENT_LIST;
end;
--
end XDBPM_ORDER_XMLSCHEMAS;
/
show errors
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--