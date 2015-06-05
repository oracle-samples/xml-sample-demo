
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
-- XDBPM_ANNOTATE_XMLSCHEMA should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
create or replace package XDBPM_ANNOTATE_XMLSCHEMA
authid CURRENT_USER
as

  function XSD_GROUP             return VARCHAR2 deterministic;
  function XSD_ELEMENT           return VARCHAR2 deterministic;
  function XSD_ATTRIBUTE         return VARCHAR2 deterministic;
  function XSD_COMPLEX_TYPE      return VARCHAR2 deterministic;

  function ELEMENT               return VARCHAR2 deterministic;
  function COMPLEX_TYPE          return VARCHAR2 deterministic;
   
  procedure addXDBNamespace(P_XML_SCHEMA in out XMLType);
  procedure addStoreVarrayAsTable(P_XML_SCHEMA in out XMLType);

  procedure setTimeStampWithTimeZone(P_XML_SCHEMA in out xmlType);
  procedure addSQLTypeMapping(P_XML_SCHEMA in out XMLType, P_XSD_TYPE VARCHAR2, P_SQL_TYPE VARCHAR2);
  
  procedure disableDomFidelity(P_XML_SCHEMA in out XMLType);
  procedure addMaintainDom(P_XML_SCHEMA in out XMLType, P_MAINTAIN_DOM_SETTING VARCHAR2);
  procedure addMaintainDom(P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2, P_MAINTAIN_DOM_SETTING VARCHAR2);
  procedure setMaintainDomTrue(P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2);
 
  procedure addDefaultTable(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2, P_DEFAULT_TABLE_NAME VARCHAR2);
  procedure disableDefaultTables(P_XML_SCHEMA in out XMLType);
  procedure disableDefaultTable(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2);
  
  procedure addSQLName    (P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_OBJECT VARCHAR2, P_LOCAL_NAME VARCHAR2, P_SQL_NAME VARCHAR2);

  procedure addSQLType    (P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2, P_SQL_TYPE VARCHAR2);
  procedure addSQLType    (P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_OBJECT VARCHAR2, P_LOCAL_NAME VARCHAR2, P_SQL_TYPE VARCHAR2);
  procedure setAnyStorage (P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_SQL_TYPE_NAME VARCHAR2);
 
  procedure addSQLCollType(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SQL_COLLECTION_TYPE VARCHAR2);
  procedure makeOutOfLine (P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2);

  procedure addTableProps(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2, P_TABLE_PROPERTIES VARCHAR2);
  procedure addTableProps(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_TABLE_PROPERTIES VARCHAR2);

  procedure makeOutOfLine(P_XML_SCHEMA in out XMLType, P_ELEMENT_REF VARCHAR2, P_DEFAULT_TABLE VARCHAR2);
  procedure makeOutOfLine(P_XML_SCHEMA in out XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_TYPE VARCHAR2, P_DEFAULT_TABLE VARCHAR2);

  procedure addNewEnumerationValue(P_XML_SCHEMA in out XMLType, P_TARGET_XPATH VARCHAR2, P_NEW_ENUMERATION_VALUE VARCHAR2);

  procedure fixImportLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2);
  procedure fixIncludeLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2);
  procedure fixRelativeURLs(P_XML_SCHEMA in out XMLType, P_SCHEMA_LOCATION_HINT VARCHAR2);
  procedure fixWindowsURLs(P_XML_SCHEMA in out XMLType);
  procedure fixEmptyComplexType(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2);
  procedure fixComplexTypeSimpleContent(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SIMPLE_TYPE_NAME VARCHAR2);
  procedure expandGroup(P_XML_SCHEMA in out XMLType, P_GROUP_NAME VARCHAR2, P_XSD_DIRECTORY VARCHAR2);
    
  procedure removeAppInfo(P_XML_SCHEMA in out XMLType);
  
  procedure addSQLType    (P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SQL_TYPE VARCHAR2);
  procedure addSQLCollType(P_XML_SCHEMA in out XMLType, P_ELEMENT_NAME VARCHAR2, P_SQL_COLLECTION_TYPE VARCHAR2);
  procedure makeOutOfLine_(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2);
  procedure makeRefOutOfLine_(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2);

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
	function getSchemaAnnotations(xmlSchema XMLType) return XMLType;
$END
end;
/
show errors
--
create or replace synonym XDB_ANNOTATE_XMLSCHEMA for XDBPM_ANNOTATE_XMLSCHEMA
/
create or replace synonym XDB_ANNOTATE_SCHEMA for XDBPM_ANNOTATE_XMLSCHEMA
/
grant execute on XDBPM_ANNOTATE_XMLSCHEMA to public
/
create or replace package body XDBPM_ANNOTATE_XMLSCHEMA
as
--
function ELEMENT          
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_ELEMENT;
end;
--
function COMPLEX_TYPE     
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE;
end;
--
function XSD_GROUP            
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_GROUP; 
end;
--
function XSD_ELEMENT          
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_ELEMENT; 
end;
--
function XSD_ATTRIBUTE        
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_ATTRIBUTE; 
end;
--
function XSD_COMPLEX_TYPE     
return VARCHAR2 deterministic 
as 
begin 
	return DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE; 
end;
--   
procedure addXDBNamespace(P_XML_SCHEMA in out XMLType) 
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.addXDBNamespace(P_XML_SCHEMA); 
end;
--
procedure disableDomFidelity(P_XML_SCHEMA in out XMLType) 
as 
  begin DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(P_XML_SCHEMA); 
end;
--
procedure setMaintainDomTrue(P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2)
as 
  begin DBMS_XMLSCHEMA_ANNOTATE.enableMaintainDOM(P_XML_SCHEMA,P_GLOBAL_NAME); 
end;
--
procedure setTimeStampWithTimeZone(P_XML_SCHEMA in out xmlType) 
as
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setTimeStampWithTimeZone(P_XML_SCHEMA); 
end;
--
procedure addMaintainDom(P_XML_SCHEMA in out XMLType, P_MAINTAIN_DOM_SETTING VARCHAR2) 
as 
begin 
	if (UPPER(P_MAINTAIN_DOM_SETTING) = 'TRUE') then
    DBMS_XMLSCHEMA_ANNOTATE.enableMaintainDOM(P_XML_SCHEMA); 
	else
    DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(P_XML_SCHEMA); 
  end if;
end ;
--
procedure addMaintainDom(P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2, P_MAINTAIN_DOM_SETTING VARCHAR2) 
as 
begin 
	if (UPPER(P_MAINTAIN_DOM_SETTING) = 'TRUE') then
    DBMS_XMLSCHEMA_ANNOTATE.enableMaintainDOM(P_XML_SCHEMA,P_GLOBAL_NAME); 
	else
    DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(P_XML_SCHEMA,P_GLOBAL_NAME); 
  end if;
end;
--
procedure addDefaultTable(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2, P_DEFAULT_TABLE_NAME VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setDefaultTable(P_XML_SCHEMA,P_GLOBAL_ELEMENT,P_DEFAULT_TABLE_NAME); 
end;
--
procedure disableDefaultTables(P_XML_SCHEMA in out XMLType)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(P_XML_SCHEMA); 
end;
--
procedure disableDefaultTable(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(P_XML_SCHEMA,P_GLOBAL_ELEMENT); 
end;
--
procedure addSQLName(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_OBJECT VARCHAR2, P_LOCAL_NAME VARCHAR2, P_SQL_NAME VARCHAR2)
as 
begin
  DBMS_XMLSCHEMA_ANNOTATE.setSQLName(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_OBJECT,P_LOCAL_NAME,P_SQL_NAME);
end;
--
procedure addSQLType(P_XML_SCHEMA in out XMLType, P_GLOBAL_NAME VARCHAR2, P_SQL_TYPE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(P_XML_SCHEMA,P_GLOBAL_NAME,P_SQL_TYPE); 
end;
--
procedure addSQLType(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_OBJECT VARCHAR2, P_LOCAL_NAME VARCHAR2, P_SQL_TYPE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_OBJECT,P_LOCAL_NAME,P_SQL_TYPE); 
end;
--
procedure addSQLCollType(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SQL_COLLECTION_TYPE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setSQLCollType(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_ELEMENT_NAME,P_SQL_COLLECTION_TYPE); 
end;
--
procedure makeOutOfLine (P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_ELEMENT_NAME,P_DEFAULT_TABLE); 
end;
--
procedure addTableProps(P_XML_SCHEMA in out XMLType, P_GLOBAL_ELEMENT VARCHAR2, P_TABLE_PROPERTIES VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setTableProps(P_XML_SCHEMA,P_GLOBAL_ELEMENT,P_TABLE_PROPERTIES); 
end;
--
procedure addTableProps(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_TABLE_PROPERTIES VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setTableProps(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_ELEMENT_NAME,P_TABLE_PROPERTIES); 
end;
--
procedure addSQLTypeMapping(P_XML_SCHEMA in out XMLType, P_XSD_TYPE VARCHAR2, P_SQL_TYPE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setSQLTypeMapping(P_XML_SCHEMA,P_XSD_TYPE,P_SQL_TYPE); 
end;
--
procedure makeOutOfLine(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(P_XML_SCHEMA,P_COMPLEX_TYPE_NAME,P_LOCAL_ELEMENT_NAME,P_DEFAULT_TABLE); 
end;
--
procedure makeOutOfLine(P_XML_SCHEMA in out XMLType, P_ELEMENT_REF VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(P_XML_SCHEMA,P_ELEMENT_REF,P_DEFAULT_TABLE); 
end;
--
procedure makeOutOfLine(P_XML_SCHEMA in out XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_TYPE VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as
begin
  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(P_XML_SCHEMA,P_ELEMENT_NAME,P_ELEMENT_TYPE,P_DEFAULT_TABLE); 
end;
--
procedure addSQLCollType(P_XML_SCHEMA in out XMLType, P_ELEMENT_NAME VARCHAR2, P_SQL_COLLECTION_TYPE VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setSQLCollType(P_XML_SCHEMA,P_ELEMENT_NAME,P_SQL_COLLECTION_TYPE); 
end;
--
procedure setAnyStorage(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_SQL_TYPE_NAME VARCHAR2)
as 
begin 
  DBMS_XMLSCHEMA_ANNOTATE.setAnyStorage(P_XML_SCHEMA,P_COMPLEX_TYPE_NAME,P_SQL_TYPE_NAME); 
end;
--
procedure addNewEnumerationValue(P_XML_SCHEMA in out XMLType, P_TARGET_XPATH VARCHAR2, P_NEW_ENUMERATION_VALUE VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.addNewEnumerationValue(P_XML_SCHEMA,P_TARGET_XPATH,P_NEW_ENUMERATION_VALUE); 
end;
--
procedure fixImportLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixImportLocation(P_XML_SCHEMA,P_OLD_LOCATION,P_NEW_LOCATION); 
end;
--
procedure fixIncludeLocation(P_XML_SCHEMA in out XMLType, P_OLD_LOCATION VARCHAR2, P_NEW_LOCATION VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixIncludeLocation(P_XML_SCHEMA,P_OLD_LOCATION,P_NEW_LOCATION); 
end;
--
procedure fixRelativeURLs(P_XML_SCHEMA in out XMLType, P_SCHEMA_LOCATION_HINT VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixRelativeURLs(P_XML_SCHEMA,P_SCHEMA_LOCATION_HINT); 
end;
--
procedure fixWindowsURLs(P_XML_SCHEMA in out XMLType)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixWindowsURLs(P_XML_SCHEMA); 
end;
--
procedure fixEmptyComplexType(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixEmptyComplexType(P_XML_SCHEMA,P_COMPLEX_TYPE_NAME); 
end;
--
procedure fixComplexTypeSimpleContent(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SIMPLE_TYPE_NAME VARCHAR2)
as 
begin 
  XDB_EDIT_XMLSCHEMA.fixComplexTypeSimpleContent(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,P_LOCAL_ELEMENT_NAME,P_SIMPLE_TYPE_NAME); 
end;
--
procedure removeAppInfo(P_XML_SCHEMA in out XMLType)
as
begin
  XDB_EDIT_XMLSCHEMA.removeAppInfo(P_XML_SCHEMA);
end;
--
procedure expandGroup(P_XML_SCHEMA in out XMLType, P_GROUP_NAME VARCHAR2, P_XSD_DIRECTORY VARCHAR2)
as
begin
	XDB_EDIT_XMLSCHEMA.loadGroupDefinitions(P_XSD_DIRECTORY);
	XDB_EDIT_XMLSCHEMA.expandRepeatingGroups(P_XML_SCHEMA);
end;
--
procedure makeOutOfLine_(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as
begin
  makeOutOfLine(P_XML_SCHEMA,XDBPM_ANNOTATE_XMLSCHEMA.XSD_COMPLEX_TYPE,P_COMPLEX_TYPE_NAME,P_LOCAL_ELEMENT_NAME,P_DEFAULT_TABLE);
end;
--
procedure makeRefOutOfLine_(P_XML_SCHEMA in out XMLType, P_COMPLEX_TYPE_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_DEFAULT_TABLE VARCHAR2)
as
begin
  makeOutOfLine(P_XML_SCHEMA,XDBPM_ANNOTATE_XMLSCHEMA.XSD_COMPLEX_TYPE,P_COMPLEX_TYPE_NAME,P_LOCAL_ELEMENT_NAME,P_DEFAULT_TABLE);
end;
--
procedure addSQLType(P_XML_SCHEMA in out XMLType, P_GLOBAL_OBJECT VARCHAR2, P_GLOBAL_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_SQL_TYPE VARCHAR2)
is
begin
  addSQLType(P_XML_SCHEMA,P_GLOBAL_OBJECT,P_GLOBAL_NAME,XDBPM_ANNOTATE_XMLSCHEMA.XSD_ELEMENT,P_LOCAL_ELEMENT_NAME,P_SQL_TYPE);
end;
--
procedure addStoreVarrayAsTable(P_XML_SCHEMA in out XMLType)
as   
begin
  if P_XML_SCHEMA.existsNode('/xsd:schema[@xdb:storeVarrayAsTable]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 0 then 
    select insertChildXML
           (
             P_XML_SCHEMA,
             '/xsd:schema',
             '@xdb:storeVarrayAsTable',
             'true',
             XDB_NAMESPACES.XDBSCHEMA_PREFIXES
           )
      into P_XML_SCHEMA 
      from dual;
  end if;
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
$ELSE
function getSchemaAnnotations(xmlSchema XMLType)
return XMLType
as
begin
  return DBMS_XMLSCHEMA_ANNOTATE.getSchemaAnnotations(XMLSCHEMA);
end;
--
$END
end XDBPM_ANNOTATE_XMLSCHEMA;
/
show errors
--
alter session set current_schema = SYS
/

