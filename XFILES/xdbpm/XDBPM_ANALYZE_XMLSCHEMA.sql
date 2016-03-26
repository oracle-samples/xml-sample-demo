
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
-- XDB_ANALYZE_XMLSCHEMA should be created under XDBPM
--
alter session set current_schema = XDBPM
/
set define on
--
create or replace package XDBPM_ANALYZE_XMLSCHEMA
authid CURRENT_USER
as  
  function analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME VARCHAR2) return XMLTYPE;
  function analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2) return XMLTYPE;

  function analyzeComplexType(P_COMPLEX_TYPE_NAME VARCHAR2) return XMLTYPE;  function analyzeComplexType(P_COMPLEX_TYPE_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2) return XMLTYPE;
  function analyzeGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2) return XMLTYPE;
  function analyzeGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2) return XMLTYPE;

  function getComplexTypeElementList(P_SQLTYPE VARCHAR2, P_SQLSCHEMA VARCHAR2) return XDB.XDB$XMLTYPE_REF_LIST_T;
  function showSQLTypes(schemaFolder VARCHAR2) return XMLType;
  

end XDBPM_ANALYZE_XMLSCHEMA;
/
show errors
--
create or replace synonym XDB_ANALYZE_XMLSCHEMA for XDBPM_ANALYZE_XMLSCHEMA
/
create or replace synonym XDB_ANALYZE_SCHEMA for XDBPM_ANALYZE_XMLSCHEMA
/
grant execute on XDBPM_ANALYZE_XMLSCHEMA to public
/
create or replace package body XDBPM_ANALYZE_XMLSCHEMA
as
--
  TYPE TYPE_DEFINITION_T 
  is RECORD
  (
    TYPE_NAME VARCHAR2(30),
    OWNER     VARCHAR2(30)
  );
--
  TYPE TYPE_LIST_T 
    is TABLE of TYPE_DEFINITION_T;
--
  TYPE CYCLE_LIST_ENTRY_T 
    is RECORD(
    TYPE            TYPE_DEFINITION_T,
    SUPER_TYPE_LIST TYPE_LIST_T
  );
--
  TYPE CYCLE_LIST_T
    is TABLE of CYCLE_LIST_ENTRY_T;
--  
  G_KNOWN_CYCLE_LIST TYPE_LIST_T;
--
  G_PROCESSED_TYPE_LIST TYPE_LIST_T;
--
  G_DEPTH_COUNT NUMBER(2) := 0;
--
function findStorageModel(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2, P_INCLUDE_SUBTYPES VARCHAR2 DEFAULT 'YES') return XMLType ;
--
function getLocalAttributes(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2) return XMLType;
--
function makeElement(P_NAME VARCHAR2) 
return XMLType
as
  V_NAME VARCHAR2(4000) := P_NAME;
begin
  if (P_NAME LIKE '%$') then
    V_NAME := SUBSTR(V_NAME,1,LENGTH(V_NAME) - 1);
  end if;
  
  if (P_NAME LIKE '%$%') then
    V_NAME := REPLACE(V_NAME,'$','_0x22_');
  end if;

  return XMLTYPE( '<' || V_NAME || '/>');
end;
--
function getPathToRoot(SUBTYPE VARCHAR2, SUBTYPE_OWNER VARCHAR2)
return VARCHAR2
as
  TYPE_HIERARCHY VARCHAR2(4000);
begin
          
   SELECT sys_connect_by_path( OWNER || '.' || TYPE_NAME , '/')
     INTO TYPE_HIERARCHY
     FROM XDBPM.XDBPM_ALL_TYPES
    WHERE TYPE_NAME = SUBTYPE
      AND OWNER = SUBTYPE_OWNER
          CONNECT BY SUPERTYPE_NAME = PRIOR TYPE_NAME
                 AND SUPERTYPE_OWNER = PRIOR OWNER
          START WITH SUPERTYPE_NAME IS NULL
                 AND SUPERTYPE_OWNER IS NULL;
                     
   return TYPE_HIERARCHY;
                 
end;
--
function expandSQLType(ATTR_NAME VARCHAR2, SUBTYPE VARCHAR2, SUBTYPE_OWNER VARCHAR2)
return XMLType 
as 

  STORAGE_MODEL       XMLTYPE;
  ATTRIBUTES          XMLTYPE;
  EXTENDED_TYPE       XMLTYPE;
  ATTR_COUNT          NUMBER := 0;

  CURSOR FIND_EXTENDED_TYPES 
  is 
  select TYPE_NAME, OWNER 
    from XDBPM.XDBPM_ALL_TYPES
   where SUPERTYPE_NAME  = SUBTYPE
     and SUPERTYPE_OWNER = SUBTYPE_OWNER;

begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing SQLType  : "' || SUBTYPE_OWNER || '.' || SUBTYPE || '".' );
$END
    
  STORAGE_MODEL := makeElement(ATTR_NAME);

  select insertChildXML(STORAGE_MODEL,'/' || STORAGE_MODEL.getRootElement(),'@type',SUBTYPE) 
    into STORAGE_MODEL
    from dual;

  select insertChildXML(STORAGE_MODEL,'/' || STORAGE_MODEL.getRootElement(),'@typeOwner',SUBTYPE_OWNER) 
    into STORAGE_MODEL
    from dual;

  ATTRIBUTES := getLocalAttributes(SUBTYPE, SUBTYPE_OWNER);          
  ATTR_COUNT := ATTR_COUNT + ATTRIBUTES.extract('/' || ATTRIBUTES.getRootElement() || '/@columns').getNumberVal();

  select appendChildXML(STORAGE_MODEL,'/' || STORAGE_MODEL.getRootElement(),ATTRIBUTES)
    into STORAGE_MODEL         
    from DUAL;
  
  for t in FIND_EXTENDED_TYPES loop
     EXTENDED_TYPE := expandSQLType('ExtendedType',T.TYPE_NAME,T.OWNER);
     ATTR_COUNT := ATTR_COUNT + EXTENDED_TYPE.extract('/' || EXTENDED_TYPE.getRootElement() || '/@columns').getNumberVal();
     
     select appendChildXML(STORAGE_MODEL,'/' || STORAGE_MODEL.getRootElement(),EXTENDED_TYPE)
       into STORAGE_MODEL
       from DUAL;    
  end loop;

  select insertChildXML(STORAGE_MODEL,'/' || STORAGE_MODEL.getRootElement(),'@columns',ATTR_COUNT) 
    into STORAGE_MODEL
    from dual;

  return STORAGE_MODEL;
end;
--
function getLocalAttributes(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2)
return XMLType
as
  V_ATTRIBUTE_COUNT     NUMBER := 0;
  V_TOTAL_ATTRIBUTES    NUMBER := 0;
  V_TEMP_RESULT         NUMBER;
  
  V_COLLECTION_TYPE     VARCHAR2(32);
  V_COLLECTION_OWNER    VARCHAR2(32);

  CURSOR FIND_CHILD_ATTRS 
  is
  select ATTR_NAME, ATTR_TYPE_OWNER, ATTR_TYPE_NAME, INHERITED
    from XDBPM.XDBPM_ALL_TYPE_ATTRS
   where TYPE_NAME = P_TYPE_NAME
     and OWNER = P_TYPE_OWNER
     and INHERITED = 'NO'
   order by ATTR_NO;        

  V_ATTR                    DBMS_XMLDOM.DOMATTR;

  V_ATTRIBUTE_LIST      XMLTYPE;
  V_ATTRIBUTE_LIST_DOCUMENT DBMS_XMLDOM.DOMDOCUMENT;
  V_ATTRIBUTE_LIST_ROOT     DBMS_XMLDOM.DOMELEMENT;

  V_ATTRIBUTE           XMLTYPE;
  V_ATTRIBUTE_DOCUMENT                DBMS_XMLDOM.DOMDOCUMENT;
  V_ATTRIBUTE_ROOT                    DBMS_XMLDOM.DOMELEMENT;

  V_TYPE_DEFINITION     XMLTYPE;
  V_TYPE_DEFINITION_DOCUMENT  DBMS_XMLDOM.DOMDOCUMENT;
  V_TYPE_DEFINITION_ROOT      DBMS_XMLDOM.DOMELEMENT;
begin     

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getLocalAttributes() : Processing Attributes of "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '"',TRUE);
$END

  V_ATTRIBUTE_LIST          := makeElement('Attributes');
  V_ATTRIBUTE_LIST_DOCUMENT := DBMS_XMLDOM.NEWDOMDOCUMENT(V_ATTRIBUTE_LIST);
  V_ATTRIBUTE_LIST_ROOT     := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_ATTRIBUTE_LIST_DOCUMENT);
   
  for ATTR in FIND_CHILD_ATTRS loop

$IF $$DEBUG $THEN
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getLocalAttributes() : Processing Attribute "' || ATTR.ATTR_NAME || '".  TYPE = "' || ATTR.ATTR_TYPE_OWNER || '"."' || ATTR.ATTR_TYPE_NAME || '"',TRUE);
$END
  
    -- Finding Element / Attribute Name could be tricky. Use SQLName
  
    V_ATTRIBUTE          := makeElement(ATTR.ATTR_NAME);
    V_ATTRIBUTE_DOCUMENT := DBMS_XMLDOM.NEWDOMDOCUMENT(V_ATTRIBUTE);
    V_ATTRIBUTE_ROOT     := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_ATTRIBUTE_DOCUMENT);
   
    begin

      -- Check for Attributes based on collection types, With Nested Table storage each Collection will cost 2 columns.
      
      select ELEM_TYPE_NAME, ELEM_TYPE_OWNER
        into V_COLLECTION_TYPE, V_COLLECTION_OWNER 
        from XDBPM.XDBPM_ALL_COLL_TYPES
       where TYPE_NAME = ATTR.ATTR_TYPE_NAME
         and OWNER = ATTR.ATTR_TYPE_OWNER;

$IF $$DEBUG $THEN
     XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Adding "' || ATTR.ATTR_NAME || '". Collection of "' || ATTR.ATTR_TYPE_OWNER || '"."' || ATTR.ATTR_TYPE_NAME || '".',TRUE);
$END
      -- Attribute is a Collection Type. 
      -- Assume Collection will be managed as a NESTED TABLE
      -- Each Collection costs 2 columns.
      -- May want to count the number of columns in the NESTED_TABLE at a later date.

      V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLCollType');
                     DBMS_XMLDOM.SETVALUE(V_ATTR,ATTR.ATTR_TYPE_NAME);
      V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
             
      V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLCollTypeOwner');
                     DBMS_XMLDOM.SETVALUE(V_ATTR,ATTR.ATTR_TYPE_OWNER);
      V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);

      V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLType');
                     DBMS_XMLDOM.SETVALUE(V_ATTR,V_COLLECTION_TYPE);
      V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);

      V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLTypeOwner');
                     DBMS_XMLDOM.SETVALUE(V_ATTR,V_COLLECTION_OWNER);
      V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);

      if ((ATTR.ATTR_NAME = 'SYS_XDBPD$') and (ATTR.ATTR_TYPE_NAME = 'XDB$RAW_LIST_T') and (ATTR.ATTR_TYPE_OWNER='XDB')  and (V_COLLECTION_TYPE='RAW')) then      
        V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'columns');
                       DBMS_XMLDOM.SETVALUE(V_ATTR,1);
        V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
      else
        V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'columns');
                       DBMS_XMLDOM.SETVALUE(V_ATTR,2);
        V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
      end if;
      
    exception
      when no_data_found then
        
        -- Attribute is not a collection type.
      
        begin
          
          -- Check for Attributes based on non-scalar types. 
          
          select 1
            into V_TEMP_RESULT
            from XDBPM.XDBPM_ALL_TYPES
           where not (TYPE_NAME = 'XMLTYPE' and OWNER = 'SYS')
             and not (TYPE_NAME = 'XDB$ENUM_T' and OWNER = 'XDB')
             and TYPE_NAME = ATTR.ATTR_TYPE_NAME
             and OWNER = ATTR.ATTR_TYPE_OWNER;
          
          -- Attribute is based on a non-scalar type. Find the Storage Model for this type.
          
          V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLType');
                         DBMS_XMLDOM.SETVALUE(V_ATTR,ATTR.ATTR_TYPE_NAME);
          V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);

          V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLTypeOwner');
                         DBMS_XMLDOM.SETVALUE(V_ATTR,ATTR.ATTR_TYPE_OWNER);
          V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);

          V_TYPE_DEFINITION            := findStorageModel(ATTR.ATTR_TYPE_NAME, ATTR.ATTR_TYPE_OWNER, 'YES');    
          
          V_TYPE_DEFINITION_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_TYPE_DEFINITION);
          V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_TYPE_DEFINITION_DOCUMENT);
          V_ATTRIBUTE_COUNT            := DBMS_XMLDOM.GETATTRIBUTE(V_TYPE_DEFINITION_ROOT,'columns');

          V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_ATTRIBUTE_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT),TRUE));
          V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_ROOT),DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT)));
                                  
          DBMS_XMLDOM.FREEDOCUMENT(V_TYPE_DEFINITION_DOCUMENT);
                                  
          if (ATTR.ATTR_TYPE_NAME = 'XDB$ENUM_T' and ATTR.ATTR_TYPE_OWNER = 'XDB') then
            -- The cost of a XDB$ENUM_T is 2 columns
            V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'columns');
                           DBMS_XMLDOM.SETVALUE(V_ATTR,2);
            V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
          else
            -- The cost of a non scalar Type is the number of attributes plus one for Type and one for the TYPEID.
           
            V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'columns');
                           DBMS_XMLDOM.SETVALUE(V_ATTR,V_ATTRIBUTE_COUNT + 2);
            V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
          end if;
        
        exception
          when no_data_found then
           
             -- Attribute is based on a scalar type
          
             V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'SQLType');
                            DBMS_XMLDOM.SETVALUE(V_ATTR,ATTR.ATTR_TYPE_NAME);
             V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
              
             V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_DOCUMENT,'columns');
                            DBMS_XMLDOM.SETVALUE(V_ATTR,1);
             V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_ROOT,V_ATTR);
          when others then
            raise;
        end;
      when others then
        raise;
    end;

    V_TOTAL_ATTRIBUTES     := V_TOTAL_ATTRIBUTES + DBMS_XMLDOM.GETATTRIBUTE(V_ATTRIBUTE_ROOT,'columns');
    
    V_ATTRIBUTE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_ATTRIBUTE_LIST_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_ROOT),TRUE));
    V_ATTRIBUTE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_LIST_ROOT),DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_ROOT)));
    
    DBMS_XMLDOM.FREEDOCUMENT(V_ATTRIBUTE_DOCUMENT);

    if (V_TOTAL_ATTRIBUTES > 25000) then
      exit;
    end if;

  end loop; 

  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_ATTRIBUTE_LIST_DOCUMENT,'columns');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,V_TOTAL_ATTRIBUTES);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ATTRIBUTE_LIST_ROOT,V_ATTR);

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getLocalAttributes() : Local Attributes Processed.',TRUE);
$END

  return V_ATTRIBUTE_LIST;

end;
--
function getSubTypes(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2) 
return XMLType
as
  CURSOR FIND_SUBTYPES
  is 
  select TYPE_NAME, OWNER 
    from XDBPM.XDBPM_ALL_TYPES
   where SUPERTYPE_NAME  = P_TYPE_NAME
     and SUPERTYPE_OWNER = P_TYPE_OWNER;  

  CURSOR FIND_SUBTYPE_HEIRARCHY
  is 
  select LEVEL, TYPE_NAME, OWNER 
    from XDBPM.XDBPM_ALL_TYPES
   where TYPE_NAME <> P_TYPE_NAME
     and OWNER <> P_TYPE_OWNER
         connect by SUPERTYPE_NAME = PRIOR TYPE_NAME
                and SUPERTYPE_OWNER = PRIOR OWNER
         start with TYPE_NAME = P_TYPE_NAME
                and OWNER = P_TYPE_OWNER;

  V_SUBTYPE_LIST                 XMLType;
  V_SUBTYPE_LIST_DOCUMENT        DBMS_XMLDOM.DOMDOCUMENT;
  V_SUBTYPE_LIST_ROOT            DBMS_XMLDOM.DOMELEMENT;

  V_TYPE_DEFINITION              XMLType;
  V_TYPE_DEFINITION_DOCUMENT     DBMS_XMLDOM.DOMDOCUMENT;
  V_TYPE_DEFINITION_ROOT         DBMS_XMLDOM.DOMELEMENT;

  V_SUBTYPE_DEFINITIONS          XMLType;
  V_SUBTYPE_DEFINITIONS_DOCUMENT DBMS_XMLDOM.DOMDOCUMENT;
  V_SUBTYPE_DEFINITIONS_ROOT     DBMS_XMLDOM.DOMELEMENT;

  V_ATTRIBUTE_LIST               XMLType;
  V_ATTRIBUTE_LIST_DOCUMENT      DBMS_XMLDOM.DOMDOCUMENT;
  V_ATTRIBUTE_LIST_ROOT          DBMS_XMLDOM.DOMELEMENT;
  
  V_SUBTYPES_EXIST               BOOLEAN := FALSE;
  V_TOTAL_columns                number;
  V_ATTRIBUTE_COUNT              number;
  
  V_ATTR                         DBMS_XMLDOM.DOMATTR;
  V_COMPLEX_TYPE                 VARCHAR2(2000);
  
begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getSubTypes() : Processing Subtypes of "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '"',TRUE);
$END

  V_SUBTYPE_LIST          := makeElement('SubTypeDefinitions');
  V_SUBTYPE_LIST_DOCUMENT := DBMS_XMLDOM.NEWDOMDOCUMENT(V_SUBTYPE_LIST);
  V_SUBTYPE_LIST_ROOT     := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_SUBTYPE_LIST_DOCUMENT);

  V_TOTAL_columns := 0;
  
  for t in FIND_SUBTYPES() loop

    V_SUBTYPES_EXIST  := TRUE;

$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getSubTypes() : Processing Subtype : "' || t.OWNER || '"."' || t.TYPE_NAME || '"',TRUE);
$END
        
    V_TYPE_DEFINITION            := makeElement(t.TYPE_NAME);
    V_TYPE_DEFINITION_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_TYPE_DEFINITION);
    V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_TYPE_DEFINITION_DOCUMENT);
    
    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_TYPE_DEFINITION_DOCUMENT,'SQLTypeOwner');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,t.OWNER);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_TYPE_DEFINITION_ROOT,V_ATTR);

    begin
      select x.XMLDATA.NAME 
        into V_COMPLEX_TYPE 
        from XDB.XDB$COMPLEX_TYPE x
       where x.XMLDATA.SQLTYPE = t.TYPE_NAME
         and x.XMLDATA.SQLSCHEMA = t.OWNER;
   
      V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_TYPE_DEFINITION_DOCUMENT,'type');
                     DBMS_XMLDOM.SETVALUE(V_ATTR,V_COMPLEX_TYPE);
      V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_TYPE_DEFINITION_ROOT,V_ATTR);

      -- Consider adding Schema URL Attribute
    
    exception
      when no_data_found then
        null;
      when others then
        raise;
    end;
             
    V_ATTRIBUTE_LIST            := getLocalAttributes(t.TYPE_NAME, t.OWNER);   
    V_ATTRIBUTE_LIST_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_ATTRIBUTE_LIST);
    V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_ATTRIBUTE_LIST_DOCUMENT);
    V_ATTRIBUTE_COUNT           := DBMS_XMLDOM.GETATTRIBUTE(V_ATTRIBUTE_LIST_ROOT,'columns');
  
    V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_TYPE_DEFINITION_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_LIST_ROOT),TRUE));
    V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT),DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_LIST_ROOT)));

    DBMS_XMLDOM.FREEDOCUMENT(V_ATTRIBUTE_LIST_DOCUMENT);

    V_SUBTYPE_DEFINITIONS       := getSubTypes(t.TYPE_NAME,t.OWNER);

    if (V_SUBTYPE_DEFINITIONS is not NULL) then
      V_SUBTYPE_DEFINITIONS_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_SUBTYPE_DEFINITIONS);
      V_SUBTYPE_DEFINITIONS_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_SUBTYPE_DEFINITIONS_DOCUMENT);
      V_ATTRIBUTE_COUNT                := V_ATTRIBUTE_COUNT + DBMS_XMLDOM.GETATTRIBUTE(V_SUBTYPE_DEFINITIONS_ROOT,'columns');
  
      V_SUBTYPE_DEFINITIONS_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_TYPE_DEFINITION_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_SUBTYPE_DEFINITIONS_ROOT),TRUE));
      V_SUBTYPE_DEFINITIONS_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT),DBMS_XMLDOM.MAKENODE(V_SUBTYPE_DEFINITIONS_ROOT)));
    end if;

    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_TYPE_DEFINITION_DOCUMENT,'columns');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,V_ATTRIBUTE_COUNT);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_TYPE_DEFINITION_ROOT,V_ATTR);
    
    V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_SUBTYPE_LIST_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT),TRUE));
    V_TYPE_DEFINITION_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_SUBTYPE_LIST_ROOT),DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION_ROOT)));

    V_TOTAL_columns := V_TOTAL_columns + V_ATTRIBUTE_COUNT;
        
  end loop;
  
  if (V_SUBTYPES_EXIST) then
    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_SUBTYPE_LIST_DOCUMENT,'columns');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,V_TOTAL_columns);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_SUBTYPE_LIST_ROOT,V_ATTR);

$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getLocalAttributes() : SubType Processing complete.',TRUE);
$END
    return V_SUBTYPE_LIST;
  else
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getLocalAttributes() : No SubTypes found.',TRUE);
$END
    return NULL;
  end if;

end;
--
function findSuperTypeModel(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2)
return XMLType
as
begin
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing Super Type : "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '"',TRUE);
$END
  return findStorageModel(P_TYPE_NAME, P_TYPE_OWNER,'NO');
end;
--
function getStorageModel(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2, P_INCLUDE_SUBTYPES VARCHAR2 DEFAULT 'YES') 
return XMLType
as
  V_TYPE_DEFINITION      XMLTYPE;
  V_ATTRIBUTE_COUNT      NUMBER := 0;
  SUBTYPE_STORAGE_MODEL  XMLTYPE;

  V_SUPERTYPE_DEFINITION XMLTYPE;
  V_SUPERTYPE_DOCUMENT   DBMS_XMLDOM.DOMDOCUMENT;
  V_SUPERTYPE_ROOT       DBMS_XMLDOM.DOMELEMENT;

  V_SUBTYPE_DEFINITION XMLTYPE;
  V_SUBTYPE_DOCUMENT   DBMS_XMLDOM.DOMDOCUMENT;
  V_SUBTYPE_ROOT       DBMS_XMLDOM.DOMELEMENT;

  V_ATTRIBUTE_LIST          XMLTYPE;
  V_ATTRIBUTE_LIST_DOCUMENT DBMS_XMLDOM.DOMDOCUMENT;
  V_ATTRIBUTE_LIST_ROOT     DBMS_XMLDOM.DOMELEMENT;

  cursor FIND_SUPERTYPE_HEIRARCHY 
  is
  select TYPE_NAME, OWNER
    from XDBPM.XDBPM_ALL_TYPES 
   where TYPE_NAME <> P_TYPE_NAME
     and OWNER <> P_TYPE_OWNER
         connect by TYPE_NAME = PRIOR SUPERTYPE_NAME
                and OWNER = PRIOR SUPERTYPE_OWNER
         start with TYPE_NAME = P_TYPE_NAME
                and OWNER = P_TYPE_OWNER
   order by LEVEL;

  V_COMPLEX_TYPE        VARCHAR2(2000);
  V_SUPERTYPE_NAME      VARCHAR2(30);
  v_SUPERTYPE_OWNER     VARCHAR2(30);
  
  V_DOCUMENT            DBMS_XMLDOM.DOMDOCUMENT;
  V_ROOT                DBMS_XMLDOM.DOMELEMENT;
  V_ATTR                DBMS_XMLDOM.DOMATTR;
  
begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getStorageModel() : Processing "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '"',TRUE);
$END
  
  V_TYPE_DEFINITION := makeElement(P_TYPE_NAME);

  V_DOCUMENT  := DBMS_XMLDOM.NEWDOMDOCUMENT(V_TYPE_DEFINITION);
  V_ROOT      := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_DOCUMENT);

  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'SQLTypeOwner');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,P_TYPE_OWNER);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);

  begin
    select x.XMLDATA.NAME 
      into V_COMPLEX_TYPE 
      from XDB.XDB$COMPLEX_TYPE x
     where x.XMLDATA.SQLTYPE = P_TYPE_NAME
       and x.XMLDATA.SQLSCHEMA = P_TYPE_OWNER;
   
    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'type');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,V_COMPLEX_TYPE);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);

    -- Consider adding Schema URL Attribute
    
  exception
    when no_data_found then
      null;
    when others then
      raise;
  end;
             
  select SUPERTYPE_NAME, SUPERTYPE_OWNER
    into V_SUPERTYPE_NAME, V_SUPERTYPE_OWNER
    from XDBPM.XDBPM_ALL_TYPES
   where TYPE_NAME = P_TYPE_NAME
     and OWNER = P_TYPE_OWNER;
    
  -- Process SuperType.  
    
  if (V_SUPERTYPE_NAME is not null) then

$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getStorageModel() : Processing Supertypes of "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '"',TRUE);
$END

    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'SQLParentType');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,V_SUPERTYPE_NAME);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);
             
    V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'SQLParentTypeOwner');
                   DBMS_XMLDOM.SETVALUE(V_ATTR,V_SUPERTYPE_OWNER);
    V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);
    
    -- Find the Definition for the super type. Do not include the definition of it's subtypes.
    
    V_SUPERTYPE_DEFINITION := findSuperTypeModel(V_SUPERTYPE_NAME, V_SUPERTYPE_OWNER);
    
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||dbms_lob.substr(V_SUPERTYPE_DEFINITION.getClobVal(),1000,1),TRUE);
$END
    
    V_SUPERTYPE_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_SUPERTYPE_DEFINITION);
    V_SUPERTYPE_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_SUPERTYPE_DOCUMENT);
    V_ATTRIBUTE_COUNT      := V_ATTRIBUTE_COUNT + DBMS_XMLDOM.GETATTRIBUTE(V_SUPERTYPE_ROOT,'columns');
  
    V_SUPERTYPE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_SUPERTYPE_ROOT),TRUE));
    V_SUPERTYPE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ROOT),DBMS_XMLDOM.MAKENODE(V_SUPERTYPE_ROOT)));
    
    DBMS_XMLDOM.FREEDOCUMENT(V_SUPERTYPE_DOCUMENT);

$IF $$DEBUG $THEN
   XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'getStorageModel() : Supertype Processing Complete.',TRUE);
$END
    
  end if;
  
  -- Process Attributes defined directly by the Type.

  V_ATTRIBUTE_LIST            := getLocalAttributes(P_TYPE_NAME, P_TYPE_OWNER);   
  V_ATTRIBUTE_LIST_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_ATTRIBUTE_LIST);
  V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_ATTRIBUTE_LIST_DOCUMENT);
  V_ATTRIBUTE_COUNT           := V_ATTRIBUTE_COUNT + DBMS_XMLDOM.GETATTRIBUTE(V_ATTRIBUTE_LIST_ROOT,'columns');
  
  V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_LIST_ROOT),TRUE));
  V_ATTRIBUTE_LIST_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ROOT),DBMS_XMLDOM.MAKENODE(V_ATTRIBUTE_LIST_ROOT)));

  DBMS_XMLDOM.FREEDOCUMENT(V_ATTRIBUTE_LIST_DOCUMENT);

  if (P_INCLUDE_SUBTYPES = 'YES') then
  
    -- Process any Sub-Types...

    V_SUBTYPE_DEFINITION := getSubTypes(P_TYPE_NAME, P_TYPE_OWNER);
    if (V_SUBTYPE_DEFINITION is not null) then
      V_SUBTYPE_DOCUMENT   := DBMS_XMLDOM.NEWDOMDOCUMENT(V_SUBTYPE_DEFINITION);
      V_SUBTYPE_ROOT       := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_SUBTYPE_DOCUMENT);
      V_ATTRIBUTE_COUNT    := V_ATTRIBUTE_COUNT + DBMS_XMLDOM.GETATTRIBUTE(V_SUBTYPE_ROOT,'columns');
  
      V_SUBTYPE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_SUBTYPE_ROOT),TRUE));
      V_SUBTYPE_ROOT       := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ROOT),DBMS_XMLDOM.MAKENODE(V_SUBTYPE_ROOT)));    

      DBMS_XMLDOM.FREEDOCUMENT(V_SUBTYPE_DOCUMENT);

    end if;
  
  end if;

  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'columns');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,V_ATTRIBUTE_COUNT);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);

  -- Cache the type definition.
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Cached Storage Model for "' || P_TYPE_OWNER || '.' || P_TYPE_NAME || '".',TRUE);
$END
  insert into XDBPM.STORAGE_MODEL_CACHE (TYPE_NAME, TYPE_OWNER, EXTENDED_DEFINITION, STORAGE_MODEL) VALUES (P_TYPE_NAME, P_TYPE_OWNER, P_INCLUDE_SUBTYPES, V_TYPE_DEFINITION);
    
  return V_TYPE_DEFINITION;
end;
--    
function findStorageModel(P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2, P_INCLUDE_SUBTYPES VARCHAR2 DEFAULT 'YES')
--
-- Find the Storage Model for the Base Type.
--
-- If the type is derived from another type we need the storage model of the Base Type
-- 
-- As storage models are calculated they are cached in the global temporary table STORAGE_MODEL_CACHE. This makes
-- the process much more efficient. A global temporary table is used to minimize memory usage.
--
return XMLType 
as
  V_STORAGE_MODEL          XMLType;
  V_STORAGE_MODEL_DOCUMENT DBMS_XMLDOM.DOMDOCUMENT;
  V_STORAGE_MODEL_ROOT     DBMS_XMLDOM.DOMELEMENT;
  V_ATTRIBUTE_COUNT        VARCHAR2(10);
begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'findStorageModel() [' || G_DEPTH_COUNT || '] : Processing "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '".' ,TRUE);
$END
                
  begin
    SELECT STORAGE_MODEL 
      into V_STORAGE_MODEL
      from XDBPM.STORAGE_MODEL_CACHE
     where TYPE_NAME = P_TYPE_NAME
       and TYPE_OWNER = P_TYPE_OWNER
       and EXTENDED_DEFINITION = P_INCLUDE_SUBTYPES;

$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Resolved Storage Model from cache.',TRUE);
$END
       
  exception
    when no_data_found then
      G_DEPTH_COUNT := G_DEPTH_COUNT + 1;
      V_STORAGE_MODEL := getStorageModel(P_TYPE_NAME,P_TYPE_OWNER, P_INCLUDE_SUBTYPES);
      G_DEPTH_COUNT := G_DEPTH_COUNT - 1;  
    when others then
      raise;
  end;

  V_STORAGE_MODEL_DOCUMENT := DBMS_XMLDOM.NEWDOMDOCUMENT(V_STORAGE_MODEL);
  V_STORAGE_MODEL_ROOT     := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_STORAGE_MODEL_DOCUMENT);
  V_ATTRIBUTE_COUNT        := DBMS_XMLDOM.GETATTRIBUTE(V_STORAGE_MODEL_ROOT,'columns');
  
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'findStorageModel : Attribute Count for "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '" = ' || V_ATTRIBUTE_COUNT || '.' ,TRUE);
$END

  return V_STORAGE_MODEL;
  
  
end;
--
function analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME VARCHAR2, P_TYPE_NAME VARCHAR2, P_TYPE_OWNER VARCHAR2)
--
-- Generates a map showing the number of columns required to persist an instance a global complex type or global elemnent, 
-- including those introduced by of all of its subtypes.
--
return XMLType 
as 
  V_STORAGE_MODEL       XMLTYPE;
  V_COUNT               NUMBER := 0;

  V_DOCUMENT            DBMS_XMLDOM.DOMDOCUMENT;
  V_ROOT                DBMS_XMLDOM.DOMELEMENT;
  V_ATTR                DBMS_XMLDOM.DOMATTR;
  V_MODEL               DBMS_XMLDOM.DOMELEMENT;
  V_TYPE_DEFINITION     DBMS_XMLDOM.DOMELEMENT;
begin
	
$IF $$DEBUG $THEN
 	XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'"' || P_GLOBAL_OBJECT_NAME || '" mapped to "' || P_TYPE_OWNER || '"."' || P_TYPE_NAME || '".',TRUE);
$END

  V_STORAGE_MODEL := makeElement(P_GLOBAL_OBJECT_NAME);

  V_DOCUMENT  := DBMS_XMLDOM.NEWDOMDOCUMENT(V_STORAGE_MODEL);
  V_ROOT      := DBMS_XMLDOM.GETDOCUMENTELEMENT(V_DOCUMENT);

  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'SQLType');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,P_TYPE_NAME);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);
             
  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'SQLTypeOwner');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,P_TYPE_OWNER);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);
 
  V_TYPE_DEFINITION   := DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(findStorageModel(P_TYPE_NAME, P_TYPE_OWNER, 'YES')));
  V_TYPE_DEFINITION   := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.IMPORTNODE(V_DOCUMENT,DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION),TRUE));
  V_TYPE_DEFINITION   := DBMS_XMLDOM.MAKEELEMENT(DBMS_XMLDOM.APPENDCHILD(DBMS_XMLDOM.MAKENODE(V_ROOT),DBMS_XMLDOM.MAKENODE(V_TYPE_DEFINITION)));

  V_ATTR      := DBMS_XMLDOM.CREATEATTRIBUTE(V_DOCUMENT,'columns');
                 DBMS_XMLDOM.SETVALUE(V_ATTR,DBMS_XMLDOM.GETATTRIBUTE(V_TYPE_DEFINITION,'columns')+2);
  V_ATTR      := DBMS_XMLDOM.SETATTRIBUTENODE(V_ROOT,V_ATTR);

  return  V_STORAGE_MODEL;

end;
--
function analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME VARCHAR2) 
return XMLTYPE
--
-- Generates a map showing the number of columns required to persist an instance a global complex type or global elemnent, 
-- including those introduced by of all of its subtypes.
--
as
  pragma autonomous_transaction;
  
  V_SQLTYPE           VARCHAR2(128);
  V_SQLSCHEMA         VARCHAR2(32);
  V_RESULT            XMLType;
begin

 G_DEPTH_COUNT := 0;
 	
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing "' || P_GLOBAL_OBJECT_NAME || '".',TRUE);
$END

  begin 
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN 
  select ct.XMLDATA.SQLTYPE, ct.XMLDATA.SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from XDB.XDB$COMPLEX_TYPE ct, XDB.XDB$SCHEMA s
   where ct.XMLDATA.NAME = P_GLOBAL_OBJECT_NAME
     and ref(s) = ct.XMLDATA.PARENT_SCHEMA
     and s.XMLDATA.SCHEMA_OWNER = USER;
  exception
    when no_data_found then
		 select e.XMLDATA.PROPERTY.SQLTYPE, e.XMLDATA.PROPERTY.SQLSCHEMA
    	 into V_SQLTYPE, V_SQLSCHEMA
    	 from XDB.XDB$ELEMENT e, XDB.XDB$SCHEMA s
   where e.XMLDATA.PROPERTY.NAME = P_GLOBAL_OBJECT_NAME
     and e.XMLDATA.PROPERTY.GLOBAL = HEXTORAW('01')
     and ref(s) = e.XMLDATA.PROPERTY.PARENT_SCHEMA
     and s.XMLDATA.SCHEMA_OWNER = USER;
$ELSE      	 
   select SQLTYPE, SQLSCHEMA
     into V_SQLTYPE, V_SQLSCHEMA
     from USER_XML_SCHEMAS,
          xmlTable
          (
             xmlnamespaces
             (
               'http://www.w3.org/2001/XMLSchema' as "xsd",
               'http://xmlns.oracle.com/xdb' as "xdb"
             ),
             '$SCH/xsd:schema/xsd:complexType[@name=$OBJ]'
             passing SCHEMA as "SCH", P_GLOBAL_OBJECT_NAME as "OBJ"
             columns
             SQLTYPE       VARCHAR2(128)  path '@xdb:SQLType',
             SQLSCHEMA     VARCHAR2(32)   path '@xdb:SQLSchema'
          )
    where existsNode(SCHEMA,'/xsd:schema/xsd:complexType[@name="' || P_GLOBAL_OBJECT_NAME || '"]',XDB_NAMESPACES.XMLSCHEMA_PREFIX_XSD) = 1;
  exception
    when no_data_found then
      select SQLTYPE, SQLSCHEMA
        into V_SQLTYPE, V_SQLSCHEMA
        from USER_XML_SCHEMAS,
             xmlTable
             (
                xmlnamespaces
                (
                  'http://www.w3.org/2001/XMLSchema' as "xsd",
                  'http://xmlns.oracle.com/xdb' as "xdb"
                ),
                '$SCH/xsd:schema/xsd:element[@name=$OBJ]'
                passing SCHEMA as "SCH", P_GLOBAL_OBJECT_NAME as "OBJ"
                columns
                SQLTYPE       VARCHAR2(128)  path '@xdb:SQLType',
                SQLSCHEMA     VARCHAR2(32)   path '@xdb:SQLSchema'
             )
       where existsNode(SCHEMA,'/xsd:schema/xsd:element[@name="' || P_GLOBAL_OBJECT_NAME || '"]',XDB_NAMESPACES.XMLSCHEMA_PREFIX_XSD) = 1;
$END                   
    when others then
      raise;
  end;

  delete from XDBPM.STORAGE_MODEL_CACHE;
  V_RESULT := analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME,V_SQLTYPE,V_SQLSCHEMA);
  COMMIT;

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing Complete "' || P_GLOBAL_OBJECT_NAME || '".',TRUE);
$END  
  return V_RESULT;
exception
  when no_data_found then
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Unable to find SQLType mapping for complexType : "' || USER || '"."' || P_GLOBAL_OBJECT_NAME || '".',TRUE );
$END  
    rollback;
    return null; 
  when others then
$IF $$DEBUG $THEN
    XDB_OUTPUT.traceException(TRUE);
$END  
    rollback;
    raise;
end;
--
function analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2) 
return XMLTYPE
--
-- Generate a map showing the number of columns required to persist an instance of the complex type.
--
as
  pragma autonomous_transaction;
  
  V_SQLTYPE           VARCHAR2(128);
  V_SQLSCHEMA         VARCHAR2(32);
  V_RESULT            XMLType;
begin

 G_DEPTH_COUNT := 0;

 begin 
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN 
  select ct.XMLDATA.SQLTYPE, ct.XMLDATA.SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from XDB.XDB$COMPLEX_TYPE ct, XDB.XDB$SCHEMA s
   where ct.XMLDATA.NAME = P_GLOBAL_OBJECT_NAME
     and ref(s) = ct.XMLDATA.PARENT_SCHEMA
     and s.XMLDATA.SCHEMA_OWNER = USER
     and s.XMLDATA.SCHEMA_URL = P_SCHEMA_URL;
  exception
    when no_data_found then
		 select e.XMLDATA.PROPERTY.SQLTYPE, e.XMLDATA.PROPERTY.SQLSCHEMA
    	 into V_SQLTYPE, V_SQLSCHEMA
    	 from XDB.XDB$ELEMENT e, XDB.XDB$SCHEMA s
   where e.XMLDATA.PROPERTY.NAME = P_GLOBAL_OBJECT_NAME
     and e.XMLDATA.PROPERTY.GLOBAL = HEXTORAW('01')
     and ref(s) = e.XMLDATA.PROPERTY.PARENT_SCHEMA
     and s.XMLDATA.SCHEMA_OWNER = USER
     and s.XMLDATA.SCHEMA_URL = P_SCHEMA_URL;
$ELSE      	 
   select SQLTYPE, SQLSCHEMA
     into V_SQLTYPE, V_SQLSCHEMA
     from USER_XML_SCHEMAS,
          xmlTable
          (
             xmlnamespaces
             (
               'http://www.w3.org/2001/XMLSchema' as "xsd",
               'http://xmlns.oracle.com/xdb' as "xdb"
             ),
             '$SCH/xsd:schema/xsd:complexType[@name=$OBJ]'
             passing SCHEMA as "SCH", P_GLOBAL_OBJECT_NAME as "OBJ"
             columns
             SQLTYPE       VARCHAR2(128)  path '@xdb:SQLType',
             SQLSCHEMA     VARCHAR2(32)   path '@xdb:SQLSchema'
          )
    where existsNode(SCHEMA,'/xsd:schema/xsd:complexType[@name="' || P_GLOBAL_OBJECT_NAME || '"]',XDB_NAMESPACES.XMLSCHEMA_PREFIX_XSD) = 1
      and SCHEMA_URL = P_SCHEMA_URL;
  exception
    when no_data_found then
      select SQLTYPE, SQLSCHEMA
        into V_SQLTYPE, V_SQLSCHEMA
        from USER_XML_SCHEMAS,
             xmlTable
             (
                xmlnamespaces
                (
                  'http://www.w3.org/2001/XMLSchema' as "xsd",
                  'http://xmlns.oracle.com/xdb' as "xdb"
                ),
                '$SCH/xsd:schema/xsd:element[@name=$OBJ]'
                passing SCHEMA as "SCH", P_GLOBAL_OBJECT_NAME as "OBJ"
                columns
                SQLTYPE       VARCHAR2(128)  path '@xdb:SQLType',
                SQLSCHEMA     VARCHAR2(32)   path '@xdb:SQLSchema'
             )
       where existsNode(SCHEMA,'/xsd:schema/xsd:element[@name="' || P_GLOBAL_OBJECT_NAME || '"]',XDB_NAMESPACES.XMLSCHEMA_PREFIX_XSD) = 1
         and SCHEMA_URL = P_SCHEMA_URL;
$END
    when others then
      raise;
  end;
     
  delete from XDBPM.STORAGE_MODEL_CACHE;
  V_RESULT := analyzeTypeHierarchy(P_GLOBAL_OBJECT_NAME,V_SQLTYPE,V_SQLSCHEMA);
  COMMIT;

$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing Complete "' || P_GLOBAL_OBJECT_NAME || '".',TRUE);
$END  
  return V_RESULT;
exception
  when no_data_found then
$IF $$DEBUG $THEN
    XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Unable to find SQLType mapping for complexType : "' || USER || '"."' || P_GLOBAL_OBJECT_NAME || '".',TRUE);
$END  
    rollback;
    return null; 
  when others then
$IF $$DEBUG $THEN
    XDB_OUTPUT.traceException(TRUE);
$END  
    rollback;
    raise;
end;
--
function analyzeSQLType(ATTR_NAME VARCHAR2, TARGET_TYPE_NAME VARCHAR2, TARGET_TYPE_OWNER VARCHAR2)
return XMLType 
as 
   ROOT_NODE_NAME   VARCHAR2(128);
   ATTR_DETAIL      XMLTYPE;
   XPATH_EXPRESSION VARCHAR2(129);
   
   CURSOR FIND_CHILD_ATTRS is
     select ATTR_NAME, ATTR_TYPE_OWNER, ATTR_TYPE_NAME, INHERITED
       from XDBPM.XDBPM_ALL_TYPE_ATTRS
      where OWNER = TARGET_TYPE_OWNER
        and TYPE_NAME = TARGET_TYPE_NAME
      order by ATTR_NO;        
   
   CHILD_ATTR  XMLTYPE;
   ATTR_COUNT NUMBER := 0;
   TEMP number;
   
   COLLECTION_TYPE_NAME  VARCHAR2(30);
   COLLECTION_TYPE_OWNER VARCHAR2(30);
   
begin

$IF $$DEBUG $THEN
  XDB_OUTPUT.writeDebugFileEntry($$PLSQL_UNIT ||'Processing Attribute ' || ATTR_NAME || ' of ' || TARGET_TYPE_OWNER || '.' || TARGET_TYPE_NAME );
$END
  
  ATTR_DETAIL := makeElement(ATTR_NAME);
  XPATH_EXPRESSION := '/' || ATTR_DETAIL.GETROOTELEMENT();

  for ATTR in FIND_CHILD_ATTRS loop
   
    begin
      select ELEM_TYPE_NAME, ELEM_TYPE_OWNER
        into COLLECTION_TYPE_NAME, COLLECTION_TYPE_OWNER 
        from XDBPM.XDBPM_ALL_COLL_TYPES
       where TYPE_NAME = ATTR.ATTR_TYPE_NAME
         and OWNER = ATTR.ATTR_TYPE_OWNER;
            
      CHILD_ATTR := analyzeSQLType(ATTR.ATTR_NAME, COLLECTION_TYPE_NAME, COLLECTION_TYPE_OWNER );
      ATTR_COUNT := ATTR_COUNT + CHILD_ATTR.extract('/' || CHILD_ATTR.GETROOTELEMENT()  || '/@sqlAttrs').getNumberVal();

      select appendChildXML(ATTR_DETAIL,XPATH_EXPRESSION,CHILD_ATTR)
        into ATTR_DETAIL
        from DUAL;
    exception
      when no_data_found then
        begin
          select 1 
            into TEMP
            from XDBPM.XDBPM_ALL_TYPES
           where TYPE_NAME = ATTR.ATTR_TYPE_NAME
            and OWNER = ATTR.ATTR_TYPE_OWNER;
          
          CHILD_ATTR := analyzeSQLType(ATTR.ATTR_NAME, ATTR.ATTR_TYPE_NAME, ATTR.ATTR_TYPE_OWNER );
          ATTR_COUNT := ATTR_COUNT + CHILD_ATTR.extract('/' || CHILD_ATTR.GETROOTELEMENT() || '/@sqlAttrs').getNumberVal();

          select appendChildXML(ATTR_DETAIL,XPATH_EXPRESSION,CHILD_ATTR)
            into ATTR_DETAIL
            from DUAL;
        exception
         when no_data_found then
           ATTR_COUNT := ATTR_COUNT + 1; 
         when others then
           raise;
        end;
    when others then
      raise;
    end;
  end loop; 
   
  select insertChildXML(ATTR_DETAIL,XPATH_EXPRESSION,'@sqlAttrs',ATTR_COUNT) 
    into ATTR_DETAIL
    from dual;
 
  return ATTR_DETAIL;
end;
--
function analyzeComplexType(P_COMPLEX_TYPE_NAME VARCHAR2)
return XMLType
as
  V_RESULT       XMLType;
  V_SQLTYPE      VARCHAR2(128);
  V_SQLSCHEMA    VARCHAR2(32);
begin
  select SQLTYPE, SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from USER_XML_SCHEMAS,
         xmlTable
         (
            xmlnamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd",
              'http://xmlns.oracle.com/xdb' as "xdb"
            ),
            '/xsd:schema/xsd:complexType'
            passing Schema
            columns
            COMPLEX_TYPE_NAME VARCHAR2(4000) path '@name',
            SQLTYPE           VARCHAR2(128)  path '@xdb:SQLType',
            SQLSCHEMA         VARCHAR2(32)   path '@xdb:SQLSchema'
         )
   where COMPLEX_TYPE_NAME = P_COMPLEX_TYPE_NAME;
      
  V_RESULT := analyzeSQLType(P_COMPLEX_TYPE_NAME,V_SQLTYPE,V_SQLSCHEMA);
 
  select insertChildXML(V_RESULT,'/' || P_COMPLEX_TYPE_NAME,'@SQLType',V_SQLTYPE) 
    into V_RESULT
    from dual;
    
  return V_RESULT;
end;
--
function analyzeComplexType(P_COMPLEX_TYPE_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2)
return XMLType
as
  V_RESULT       XMLType;
  V_SQLTYPE      VARCHAR2(128);
  V_SQLSCHEMA    VARCHAR2(32);
begin
  select SQLTYPE, SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from USER_XML_SCHEMAS,
         xmlTable
         (
            xmlnamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd",
              'http://xmlns.oracle.com/xdb' as "xdb"
            ),
            '/xsd:schema/xsd:complexType'
            passing Schema
            columns
            COMPLEX_TYPE_NAME VARCHAR2(4000) path '@name',
            SQLTYPE           VARCHAR2(128)  path '@xdb:SQLType',
            SQLSCHEMA         VARCHAR2(32)   path '@xdb:SQLSchema'
         )
   where COMPLEX_TYPE_NAME = P_COMPLEX_TYPE_NAME
     and SCHEMA_URL = P_SCHEMA_URL;
      
      
      
  V_RESULT := analyzeSQLType(P_COMPLEX_TYPE_NAME,V_SQLTYPE,V_SQLSCHEMA);
 
  select insertChildXML(V_RESULT,'/' || P_COMPLEX_TYPE_NAME,'@SQLType',V_SQLTYPE) 
    into V_RESULT
    from dual;
    
  return V_RESULT;
end;
--
function analyzeGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2)
return XMLType
as
  V_RESULT       XMLType;
  V_SQLTYPE      VARCHAR2(128);
  V_SQLSCHEMA    VARCHAR2(32);
begin
  select SQLTYPE, SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from USER_XML_SCHEMAS,
         xmlTable
         (
            xmlnamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd",
              'http://xmlns.oracle.com/xdb' as "xdb"
            ),
            '/xsd:schema/xsd:element'
            passing Schema
            columns
            GLOBAL_ELEMENT_NAME VARCHAR2(4000) path '@name',
            SQLTYPE             VARCHAR2(128)  path '@xdb:SQLType',
            SQLSCHEMA           VARCHAR2(32)   path '@xdb:SQLSchema'
         )
   where GLOBAL_ELEMENT_NAME = P_GLOBAL_ELEMENT_NAME;
      
  V_RESULT := analyzeSQLType(P_GLOBAL_ELEMENT_NAME,V_SQLTYPE,V_SQLSCHEMA);
 
  select insertChildXML(V_RESULT,'/' || P_GLOBAL_ELEMENT_NAME,'@SQLType',V_SQLTYPE) 
    into V_RESULT
    from dual;
    
  return V_RESULT;
end;
--
function analyzeGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2, P_SCHEMA_URL VARCHAR2)
return XMLType
as
  V_RESULT       XMLType;
  V_SQLTYPE      VARCHAR2(128);
  V_SQLSCHEMA    VARCHAR2(32);
begin
  select SQLTYPE, SQLSCHEMA
    into V_SQLTYPE, V_SQLSCHEMA
    from USER_XML_SCHEMAS,
         xmlTable
         (
            xmlnamespaces
            (
              'http://www.w3.org/2001/XMLSchema' as "xsd",
              'http://xmlns.oracle.com/xdb' as "xdb"
            ),
            '/xsd:schema/xsd:element'
            passing Schema
            columns
            GLOBAL_ELEMENT_NAME VARCHAR2(4000) path '@name',
            SQLTYPE             VARCHAR2(128)  path '@xdb:SQLType',
            SQLSCHEMA           VARCHAR2(32)   path '@xdb:SQLSchema'
         )
   where GLOBAL_ELEMENT_NAME = P_GLOBAL_ELEMENT_NAME
     and SCHEMA_URL = P_SCHEMA_URL;
         
  V_RESULT := analyzeSQLType(P_GLOBAL_ELEMENT_NAME,V_SQLTYPE,V_SQLSCHEMA);
 
  select insertChildXML(V_RESULT,'/' || P_GLOBAL_ELEMENT_NAME,'@SQLType',V_SQLTYPE) 
    into V_RESULT
    from dual;
    
  return V_RESULT;
end;
--
function appendElementList(V_ELEMENT_LIST IN OUT XDB.XDB$XMLTYPE_REF_LIST_T, V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T) return XDB.XDB$XMLTYPE_REF_LIST_T;
function expandModel(P_MODEL XDB.XDB$MODEL_T) return XDB.XDB$XMLTYPE_REF_LIST_T;
function expandChoiceList(P_CHOICE_LIST XDB.XDB$XMLTYPE_REF_LIST_T) return XDB.XDB$XMLTYPE_REF_LIST_T;
function expandSequenceList(P_SEQUENCE_LIST XDB.XDB$XMLTYPE_REF_LIST_T) return XDB.XDB$XMLTYPE_REF_LIST_T;
function expandGroupList(P_GROUP_LIST XDB.XDB$XMLTYPE_REF_LIST_T) return XDB.XDB$XMLTYPE_REF_LIST_T;
--
function appendElementList(V_ELEMENT_LIST IN OUT XDB.XDB$XMLTYPE_REF_LIST_T, V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T) 
return XDB.XDB$XMLTYPE_REF_LIST_T
as
begin
  SELECT CAST
         ( 
           SET 
           ( 
             CAST(V_ELEMENT_LIST as XDBPM.XMLTYPE_REF_TABLE_T) 
             MULTISET UNION
             CAST(V_CHILD_ELEMENT_LIST as XDBPM.XMLTYPE_REF_TABLE_T) 
           )
           as XDB.XDB$XMLTYPE_REF_LIST_T
         )
    into V_ELEMENT_LIST
    from DUAL;
    return V_ELEMENT_LIST;      
end;
--
function expandModel(P_MODEL XDB.XDB$MODEL_T)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_ELEMENT_LIST       XDB.XDB$XMLTYPE_REF_LIST_T;
  V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T;
begin

  V_ELEMENT_LIST := XDB.XDB$XMLTYPE_REF_LIST_T();
  if P_MODEL.ELEMENTS is not null then
    V_ELEMENT_LIST := P_MODEL.ELEMENTS;
  end if;
  
  if (P_MODEL.CHOICE_KIDS is not NULL) then
    V_CHILD_ELEMENT_LIST := expandChoiceList(P_MODEL.CHOICE_KIDS);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end if;
  
  if (P_MODEL.SEQUENCE_KIDS is not NULL) then
    V_CHILD_ELEMENT_LIST := expandSequenceList(P_MODEL.SEQUENCE_KIDS);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end if;

  -- Process ANYS
  
  if (P_MODEL.GROUPS is not NULL) then
    V_CHILD_ELEMENT_LIST := expandGroupList(P_MODEL.GROUPS);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end if;

  return V_ELEMENT_LIST;
end;
--
function expandChoiceList(P_CHOICE_LIST XDB.XDB$XMLTYPE_REF_LIST_T)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_ELEMENT_LIST       XDB.XDB$XMLTYPE_REF_LIST_T;
  V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T;

  cursor getChoices is
  select c.XMLDATA MODEL
    from XDB.XDB$CHOICE_MODEL c, TABLE(P_CHOICE_LIST) cl
   where ref(c) = value(cl);
begin

  V_ELEMENT_LIST := XDB.XDB$XMLTYPE_REF_LIST_T();

  for c in getChoices loop
    V_CHILD_ELEMENT_LIST := expandModel(c.MODEL);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end loop;

  return V_ELEMENT_LIST;
end;
--
function expandSequenceList(P_SEQUENCE_LIST XDB.XDB$XMLTYPE_REF_LIST_T)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_ELEMENT_LIST       XDB.XDB$XMLTYPE_REF_LIST_T;
  V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T;

  cursor getSequences is
  select s.XMLDATA MODEL
    from XDB.XDB$SEQUENCE_MODEL s, TABLE(P_SEQUENCE_LIST) sl
   where ref(s) = value(sl);
begin

  V_ELEMENT_LIST := XDB.XDB$XMLTYPE_REF_LIST_T();

  for s in getSequences loop
    V_CHILD_ELEMENT_LIST := expandModel(s.MODEL);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end loop;

  return V_ELEMENT_LIST;
end;
--
function expandGroupList(P_GROUP_LIST XDB.XDB$XMLTYPE_REF_LIST_T)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_ELEMENT_LIST       XDB.XDB$XMLTYPE_REF_LIST_T;
  V_CHILD_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T;  V_MODEL  XDB.XDB$MODEL_T;

  cursor getGroups is
  SELECT CASE 
           -- Return The MODEL Definition for the CHOICE, ALL or SEQUENCE
           WHEN gd.XMLDATA.ALL_KID is not NULL
             THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = gd.XMLDATA.ALL_KID)
           WHEN gd.XMLDATA.SEQUENCE_KID is not NULL
             THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = gd.XMLDATA.SEQUENCE_KID)
           WHEN gd.XMLDATA.CHOICE_KID is not NULL
             THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = gd.XMLDATA.CHOICE_KID)
          END MODEL
     FROM XDB.XDB$GROUP_DEF gd, XDB.XDB$GROUP_REF gr, TABLE(P_GROUP_LIST) gl
    WHERE ref(gd) = gr.XMLDATA.GROUPREF_REF
      and ref(gr) = value(gl);
begin
    
  V_ELEMENT_LIST := XDB.XDB$XMLTYPE_REF_LIST_T();

  for g in getGroups loop
    V_CHILD_ELEMENT_LIST := expandModel(g.MODEL);
    V_ELEMENT_LIST := appendElementList(V_ELEMENT_LIST,V_CHILD_ELEMENT_LIST);
  end loop;

  return V_ELEMENT_LIST;
end;
--
function getComplexTypeElementList(P_COMPLEX_TYPE_REF REF XMLTYPE)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_MODEL        XDB.XDB$MODEL_T;
  V_BASE_TYPE    REF XMLTYPE;
  V_ELEMENT_LIST XDB.XDB$XMLTYPE_REF_LIST_T := XDB.XDB$XMLTYPE_REF_LIST_T();
begin
  SELECT ct.XMLDATA.BASE_TYPE, 
         CASE 
           -- Return The MODEL Definition for the CHOICE, ALL or SEQUENCE
           WHEN ct.XMLDATA.ALL_KID is not NULL
             THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = ct.XMLDATA.ALL_KID)
           WHEN ct.XMLDATA.SEQUENCE_KID is not NULL
             THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = ct.XMLDATA.SEQUENCE_KID)
           WHEN ct.XMLDATA.CHOICE_KID is not NULL
             THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = ct.XMLDATA.CHOICE_KID)
           WHEN ct.XMLDATA.GROUP_KID is not NULL
             -- COMPLEXTYPE is based on a GROUP. 
             THEN ( 
                     -- RETURN The CHOICE, ALL or SEQUENCE for GROUP
                     SELECT CASE
                              WHEN gd.XMLDATA.ALL_KID is not NULL
                                THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = gd.XMLDATA.ALL_KID)
                              WHEN gd.XMLDATA.SEQUENCE_KID is not NULL
                                THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = gd.XMLDATA.SEQUENCE_KID)
                              WHEN gd.XMLDATA.CHOICE_KID is not NULL
                                THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = gd.XMLDATA.CHOICE_KID)
                              END
                         FROM XDB.XDB$GROUP_DEF gd, xdb.xdb$GROUP_REF gr
                        WHERE ref(gd) = gr.XMLDATA.GROUPREF_REF
                          and ref(gr) = ct.XMLDATA.GROUP_KID
                  )
--           WHEN ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.ALL_KID is not NULL
--             THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.ALL_KID)
--           WHEN ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.SEQUENCE_KID is not NULL
--            THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.SEQUENCE_KID)
--           WHEN ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.CHOICE_KID is not NULL
--             THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.CHOICE_KID)
--           WHEN ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.GROUP_KID is not NULL
--             -- COMPLEXTYPE is based on a GROUP. 
--             THEN ( 
--                     -- RETURN The CHOICE, ALL or SEQUENCE for GROUP
--                     SELECT CASE
--                              WHEN gd.XMLDATA.ALL_KID is not NULL
--                                THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = gd.XMLDATA.ALL_KID)
--                              WHEN gd.XMLDATA.SEQUENCE_KID is not NULL
--                                THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = gd.XMLDATA.SEQUENCE_KID)
--                              WHEN gd.XMLDATA.CHOICE_KID is not NULL
--                                THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = gd.XMLDATA.CHOICE_KID)
--                              END
--                         FROM XDB.XDB$GROUP_DEF gd, xdb.xdb$GROUP_REF gr
--                       WHERE ref(gd) = gr.XMLDATA.GROUPREF_REF
--                          and ref(gr) = ct.XMLDATA.COMPLEXCONTENT.RESTRICTION.GROUP_KID
--                  )
           WHEN ct.XMLDATA.COMPLEXCONTENT.EXTENSION.ALL_KID is not NULL
             THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = ct.XMLDATA.COMPLEXCONTENT.EXTENSION.ALL_KID)
           WHEN ct.XMLDATA.COMPLEXCONTENT.EXTENSION.SEQUENCE_KID is not NULL
             THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = ct.XMLDATA.COMPLEXCONTENT.EXTENSION.SEQUENCE_KID)
           WHEN ct.XMLDATA.COMPLEXCONTENT.EXTENSION.CHOICE_KID is not NULL
             THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = ct.XMLDATA.COMPLEXCONTENT.EXTENSION.CHOICE_KID)
           WHEN ct.XMLDATA.COMPLEXCONTENT.EXTENSION.GROUP_KID is not NULL
             -- COMPLEXTYPE is based on a GROUP. 
             THEN ( 
                     -- RETURN The CHOICE, ALL or SEQUENCE for GROUP
                     SELECT CASE
                              WHEN gd.XMLDATA.ALL_KID is not NULL
                                THEN ( SELECT a.XMLDATA  from XDB.XDB$ALL_MODEL a where ref(a) = gd.XMLDATA.ALL_KID)
                              WHEN gd.XMLDATA.SEQUENCE_KID is not NULL
                                THEN ( SELECT s.XMLDATA  from XDB.XDB$SEQUENCE_MODEL s where ref(s) = gd.XMLDATA.SEQUENCE_KID)
                              WHEN gd.XMLDATA.CHOICE_KID is not NULL
                                THEN ( SELECT c.XMLDATA  from XDB.XDB$CHOICE_MODEL c where ref(c) = gd.XMLDATA.CHOICE_KID)
                              END
                         FROM XDB.XDB$GROUP_DEF gd, xdb.xdb$GROUP_REF gr
                        WHERE ref(gd) = gr.XMLDATA.GROUPREF_REF
                          and ref(gr) = ct.XMLDATA.COMPLEXCONTENT.EXTENSION.GROUP_KID
                  )
          END MODEL
     INTO V_BASE_TYPE, V_MODEL 
     FROM XDB.XDB$COMPLEX_TYPE ct
    WHERE ref(ct) = P_COMPLEX_TYPE_REF;
    
  -- Deal with Base Type and Base on REF...  
  
  if (V_BASE_TYPE is not null) then
    V_ELEMENT_LIST := getComplexTypeElementList(V_BASE_TYPE);
    return appendElementList(V_ELEMENT_LIST,expandModel(V_MODEL));
  else
    return expandModel(V_MODEL);
  end if;
end;
--
function getComplexTypeElementList(P_SQLTYPE VARCHAR2, P_SQLSCHEMA VARCHAR2)
return XDB.XDB$XMLTYPE_REF_LIST_T
as
  V_COMPLEX_TYPE_REF REF XMLTYPE;
begin
  select ref(ct)
    into V_COMPLEX_TYPE_REF
    from XDB.XDB$COMPLEX_TYPE ct
   where ct.XMLDATA.SQLTYPE = P_SQLTYPE
     and ct.XMLDATA.SQLSCHEMA = P_SQLSCHEMA;
       
  return getComplexTypeElementList(V_COMPLEX_TYPE_REF);
end;
--
function showSQLTypes(schemaFolder VARCHAR2) return XMLType
is
  xmlSchema XMLTYPE;
begin
  select xmlElement                                  
         (                                           
           "TypeList",                               
           xmlAgg                                    
           (                                         
              xmlElement                              
              (                                       
                "Schema",                             
                xmlElement
                (
                  "ResourceName",
                  extractValue(res,'/Resource/DisplayName')
                ),
                xmlElement                          
                (                                   
                  "complexTypes",                   
                  (                                 
                    select xmlAgg                                
                           (                                     
                             xmlElement               
                             (                        
                               "complexType",         
                               xmlElement            
                               (                      
                                 "name",              
                                 extractValue(value(XML),'/xsd:complexType/@name',XDB_NAMESPACES.XDBSCHEMA_PREFIXES)                           
                               ),                     
                               xmlElement             
                               (                      
                                 "SQLType",           
                                 extractValue(value(XML),'/xsd:complexType/@xdb:SQLType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES)                             
                               )                      
                             )
                           )
                      from table                    
                           (                        
                             xmlsequence            
                             (                      
                               extract              
                               (                    
                                 xdburitype(p.path).getXML(),
                                 '/xsd:schema/xsd:complexType',
                                 XDB_NAMESPACES.XDBSCHEMA_PREFIXES
                               )                    
                             )                      
                           ) xml
                      -- order by extractValue(value(XML),'/xsd:complexType/@name',XDB_NAMESPACES.XDBSCHEMA_PREFIXES)
                  )                                   
                )
              )
            )                                     
          ).extract('/*')                             
     into xmlSchema
     from path_view p                                 
    where under_path(res,schemaFolder) = 1       
    order by extractValue(res,'/Resource/DisplayName');
    
  return xmlSchema;
    
end;
--
function isCyclicReference(P_TYPE_NAME VARCHAR2, P_OWNER VARCHAR2, P_ATTR_NAME VARCHAR2, P_ATTR_TYPE_NAME VARCHAR2, P_ATTR_TYPE_OWNER VARCHAR2, P_LEVEL NUMBER,  P_CYCLE_LIST CYCLE_LIST_T)
return BOOLEAN
as
begin	
	if (P_LEVEL > 50) then
	  XDB_OUTPUT.WRITEOUTPUTFILEENTRY('Level limit excceeded.',TRUE);
	  return true;
	end if;
	if P_CYCLE_LIST.count() > 0 then
	  for i in P_CYCLE_LIST.first .. P_CYCLE_LIST.last loop
	    if P_CYCLE_LIST(i).TYPE.TYPE_NAME = P_ATTR_TYPE_NAME and P_CYCLE_LIST(i).TYPE.OWNER = P_ATTR_TYPE_OWNER then
     	  XDB_OUTPUT.WRITEOUTPUTFILEENTRY('isCyclicReference [' || P_LEVEL || '] : "' || P_OWNER || '"."' || P_TYPE_NAME || '"."' || P_ATTR_NAME || '"  of type "' || P_ATTR_TYPE_OWNER || '"."' || P_ATTR_TYPE_NAME || '". Cycle Detected.',TRUE);
	      G_KNOWN_CYCLE_LIST.extend();
	      G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).TYPE_NAME := P_TYPE_NAME;
	      G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).OWNER := P_OWNER;
        return true;
      end if;
      if P_CYCLE_LIST(i).SUPER_TYPE_LIST.count() > 0 then
        for j in P_CYCLE_LIST(i).SUPER_TYPE_LIST.first .. P_CYCLE_LIST(i).SUPER_TYPE_LIST.last loop
    	    if P_CYCLE_LIST(i).SUPER_TYPE_LIST(j).TYPE_NAME = P_ATTR_TYPE_NAME and P_CYCLE_LIST(i).SUPER_TYPE_LIST(j).OWNER = P_ATTR_TYPE_OWNER then
        	  XDB_OUTPUT.WRITEOUTPUTFILEENTRY('isCyclicReference [' || P_LEVEL || '] : "' || P_OWNER || '"."' || P_TYPE_NAME || '"."' || P_ATTR_NAME || '"  of type "' || P_ATTR_TYPE_OWNER || '"."' || P_ATTR_TYPE_NAME || '". Cycle by Supertype Detected.',TRUE);
     	      G_KNOWN_CYCLE_LIST.extend();
	          G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).TYPE_NAME := P_TYPE_NAME;
	          G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).OWNER := P_OWNER;
            return true;
          end if;
        end loop;
      end if;
    end loop;
  end if;    
	return false;
end;
--
procedure processType(P_TYPE_NAME VARCHAR2, P_OWNER VARCHAR2,P_LEVEL NUMBER,  P_CYCLE_LIST CYCLE_LIST_T)
as
  V_CYCLE_LIST CYCLE_LIST_T := P_CYCLE_LIST;
  V_LEVEL NUMBER := P_LEVEL + 1;
  cursor findChildren 
  is
  select ATTR_NAME, ATTR_TYPE_NAME, ATTR_TYPE_OWNER
    from XDBPM.MISSING_TYPE_ATTRS
   where TYPE_NAME = P_TYPE_NAME
     and P_OWNER = P_OWNER;
     
  cursor findSubTypes
  is
  select TYPE_NAME, OWNER
    from XDBPM.MISSING_TYPES
   where SUPERTYPE_NAME = P_TYPE_NAME
    and SUPERTYPE_OWNER = P_OWNER;
    
  cursor findSuperTypes 
  is
  select SUPERTYPE_NAME, SUPERTYPE_OWNER
    FROM XDBPM.XDBPM_ALL_TYPES
         CONNECT BY prior SUPERTYPE_NAME = TYPE_NAME
                      and SUPERTYPE_OWNER = OWNER
         START WITH TYPE_NAME = P_TYPE_NAME
                and OWNER = P_OWNER;
                   
  V_CYCLE_DETECTED BOOLEAN := FALSE;
  
begin
	
	if G_KNOWN_CYCLE_LIST.count() > 0 then
	  for i in G_KNOWN_CYCLE_LIST.first .. G_KNOWN_CYCLE_LIST.last loop
	    if G_KNOWN_CYCLE_LIST(i).TYPE_NAME = P_TYPE_NAME and G_KNOWN_CYCLE_LIST(i).OWNER = P_OWNER then
        XDB_OUTPUT.WRITEOUTPUTFILEENTRY('Skipping known cyclic type : "' || P_OWNER || '"."' || P_TYPE_NAME || '".',TRUE);
	      return;
	    end if;
	  end loop;
  end if;
	    
	if G_PROCESSED_TYPE_LIST.count() > 0 then
	  for i in G_PROCESSED_TYPE_LIST.first .. G_PROCESSED_TYPE_LIST.last loop
	    if G_PROCESSED_TYPE_LIST(i).TYPE_NAME = P_TYPE_NAME and G_PROCESSED_TYPE_LIST(i).OWNER = P_OWNER then
        XDB_OUTPUT.WRITEOUTPUTFILEENTRY('Skipping known non-cyclic type : "' || P_OWNER || '"."' || P_TYPE_NAME || '".',TRUE);
	      return;
	    end if;
	  end loop;
  end if;
  
	V_CYCLE_LIST.extend();
	V_CYCLE_LIST(V_CYCLE_LIST.last).TYPE.TYPE_NAME := P_TYPE_NAME;
	V_CYCLE_LIST(V_CYCLE_LIST.last).TYPE.OWNER := P_OWNER;
	V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST := TYPE_LIST_T();
	for s in findSupertypes loop
	  V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST.extend();
	  V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST(V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST.last).TYPE_NAME := s.SUPERTYPE_NAME;
	  V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST(V_CYCLE_LIST(V_CYCLE_LIST.last).SUPER_TYPE_LIST.last).OWNER := s.SUPERTYPE_OWNER;
  end loop;
	  
  XDB_OUTPUT.WRITEOUTPUTFILEENTRY('processType [' || P_LEVEL || '] : Checking "' || P_OWNER || '"."' || P_TYPE_NAME || '".',TRUE);
	for c in findChildren() loop 
   	XDB_OUTPUT.WRITEOUTPUTFILEENTRY('Child : "' || c.ATTR_TYPE_OWNER || '"."' || c.ATTR_TYPE_NAME || '"."' || c.ATTR_NAME || '".',TRUE);
	  V_CYCLE_DETECTED := isCyclicReference(P_TYPE_NAME, P_OWNER, c.ATTR_NAME, c.ATTR_TYPE_NAME, c.ATTR_TYPE_OWNER, V_LEVEL,V_CYCLE_LIST);
	  if ( not V_CYCLE_DETECTED) then
   	  processType(c.ATTR_TYPE_NAME,C.ATTR_TYPE_OWNER,V_LEVEL,V_CYCLE_LIST);
	  end if;
	end loop;
	
  for st in findSubTypes() loop
    XDB_OUTPUT.WRITEOUTPUTFILEENTRY('SubType : "' || st.OWNER || '"."' || st.TYPE_NAME || '".',TRUE);
 	  processType(st.TYPE_NAME,st.OWNER,V_LEVEL,V_CYCLE_LIST);
	end loop;

  G_KNOWN_CYCLE_LIST.extend();
  G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).TYPE_NAME := P_TYPE_NAME;
  G_KNOWN_CYCLE_LIST(G_KNOWN_CYCLE_LIST.last).OWNER := P_OWNER;
	  	    
end;
--
procedure generateCycleReport(P_RESOURCE_PATH VARCHAR2 DEFAULT '/public/cycleReport.log')
as
  cursor findUnresolvedElements
  is
  select ge.XMLDATA.PROPERTY.SQLTYPE  TYPE_NAME,
         ge.XMLDATA.PROPERTY.SQLSCHEMA OWNER
    from xdb.xdb$ELEMENT ge, XDBPM.MISSING_TYPES mt
   where ge.XMLDATA.PROPERTY.SQLTYPE = mt.TYPE_NAME
     and ge.XMLDATA.PROPERTY.SQLSCHEMA = mt.OWNER
     and ge.XMLDATA.PROPERTY.GLOBAL = hexToRaw('01')
     and ge.XMLDATA.HEAD_ELEM_REF is null
     and not exists
         (
           select 1 
             from XDB.XDB$ELEMENT le
            where le.XMLDATA.PROPERTY.PROPREF_REF = ref(ge)
              and le.XMLDATA.PROPERTY.GLOBAL = hexToRaw('00')
         )
   order by ge.XMLDATA.PROPERTY.SQLTYPE;

  V_CYCLE_LIST CYCLE_LIST_T;
  V_TYPE_SUMMARY_SIZE NUMBER :=0;
  
begin
	select count(*) 
	  into V_TYPE_SUMMARY_SIZE
	  from XDBPM.TYPE_SUMMARY;
	  
	if (V_TYPE_SUMMARY_SIZE = 0) then
	  XDB_OPTIMIZE_XMLSCHEMA.generateTypeSummary();
	end if;

	XDB_OUTPUT.createOutputFile(P_RESOURCE_PATH,TRUE);
	G_KNOWN_CYCLE_LIST := TYPE_LIST_T();
	G_PROCESSED_TYPE_LIST := TYPE_LIST_T();
  for ge in findUnresolvedElements() loop
    V_CYCLE_LIST := CYCLE_LIST_T();
    processType(ge.TYPE_NAME,ge.OWNER,1,V_CYCLE_LIST);
  end loop;
end;
--
end XDBPM_ANALYZE_XMLSCHEMA;
/
show errors
--
alter SESSION SET CURRENT_SCHEMA = SYS
/
--