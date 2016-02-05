
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

set echo on
spool XFILES_WEBDEMO_SERVICES.log
--
def XFILES_SCHEMA = &1
--
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
create or replace package XFILES_WEBDEMO_SERVICES
authid current_user
as
  function EXECUTESQL(P_STATEMENT XMLType) return NUMBER;
  function DESCRIBE(P_OBJECT_NAME VARCHAR2, P_OWNER VARCHAR2 default USER) return XMLType;
  function EXPLAINPLAN(P_STATEMENT XMLType) return XMLType;
end;
/
show errors
--
-- grant execute on XFILES_WEBDEMO_SERVICES to XFILES_USER
-- /
grant execute on XFILES_WEBDEMO_SERVICES to PUBLIC
/
create or replace package body XFILES_WEBDEMO_SERVICES
as
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure handleException(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE,P_TRANSACTION BOOLEAN DEFAULT TRUE)
as
  NO_ACTIVE_TRANSACTION exception;
  PRAGMA EXCEPTION_INIT( NO_ACTIVE_TRANSACTION , -14552);
  
  V_STACK_TRACE XMLType;
  V_RESULT      boolean;
begin
  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
  begin
    rollback; 
  exception
    when NO_ACTIVE_TRANSACTION then
      NULL;
  end;
  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);
end;
--
function EXECUTESQL(P_STATEMENT XMLType)
return NUMBER
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_CDATA_SECTION CLOB;
  V_STATEMENT_TEXT CLOB;
  V_RESULT BOOLEAN;
  V_ROWCOUNT NUMBER;
begin
  V_PARAMETERS := P_STATEMENT;

  V_CDATA_SECTION := P_STATEMENT.extract('//text()').getCLOBVal();
  V_STATEMENT_TEXT := DBMS_XMLGEN.CONVERT(V_CDATA_SECTION,1);
	$IF $$DEBUG $THEN
    XDB_OUTPUT.writeTraceFileEntry('EXECUTESQL: SQL Statement =');
    XDB_OUTPUT.writeTraceFileEntry(V_STATEMENT_TEXT);
    XDB_OUTPUT.flushTraceFile();
  $END

  execute immediate V_STATEMENT_TEXT;
  V_ROWCOUNT := SQL%ROWCOUNT;
  
  writeLogRecord('EXECUTESQL',V_INIT,V_PARAMETERS);
  return V_ROWCOUNT;
exception
  when others then
    handleException('EXECUTESQL',V_INIT,V_PARAMETERS);
    raise;
end;
--
function DESCRIBE(P_OBJECT_NAME VARCHAR2, P_OWNER VARCHAR2 default USER)
return XMLType
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_OBJECT_NAME         VARCHAR2(64);
  V_OWNER               VARCHAR2(64);
  
  V_RESULT              XMLType; 
  V_HNDL                NUMBER;
  V_OBJECT_TYPE         VARCHAR2(200); 
  V_TYPE_STRUCTURE      XMLType;
  V_COLL_STRUCTURE      XMLType;
  V_TYPE_HIERARCHY      XMLType;
  V_SCHEMA_DEFINITION   XMLType;
  V_VIEW_COLUMNS        XMLType;
begin
  select xmlConcat
         (
           xmlElement("ObjectName",P_OBJECT_NAME),
           xmlElement("Owner",P_OWNER)
         )
    into V_PARAMETERS
    from dual;


  V_OBJECT_NAME := p_object_name;
  if instr(V_OBJECT_NAME,'"') != 1 then
    V_OBJECT_NAME := upper(V_OBJECT_NAME);
  else
    V_OBJECT_NAME := substr(V_OBJECT_NAME,2,length(V_OBJECT_NAME) - 1);
  end if;
  
  V_OWNER := p_owner;
  if instr(V_OWNER,'"') != 1 then
    V_OWNER := upper(V_OWNER);
  else
    V_OWNER := substr(V_OWNER,2,length(V_OWNER) - 1);
  end if;

  select object_type
    into V_OBJECT_TYPE
    from all_objects
   where object_name = V_OBJECT_NAME 
     and owner = V_OWNER 
     and subobject_name is null;
     
  $IF $$DEBUG $THEN
     XDB_OUTPUT.writeTraceFileEntry('Object Type = "' || V_OBJECT_TYPE || '"',TRUE);
  $END
  
  V_HNDL := DBMS_METADATA.OPEN(V_OBJECT_TYPE); 
  DBMS_METADATA.SET_FILTER(V_HNDL,'SCHEMA',V_OWNER); 
  DBMS_METADATA.SET_FILTER(V_HNDL,'NAME',V_OBJECT_NAME); 
  V_RESULT := XMLType(DBMS_METADATA.FETCH_CLOB(V_HNDL)); 
  DBMS_METADATA.CLOSE(V_hndl);
      
  if V_OBJECT_TYPE = 'TYPE' then

    V_COLL_STRUCTURE := dbms_xmlgen.getxmlType('select * from all_coll_types where type_name = ''' || V_OBJECT_NAME || ''' and owner = ''' || V_OWNER || '''');     

    if V_COLL_STRUCTURE is not null then
      V_OBJECT_NAME := V_COLL_STRUCTURE.extract('/ROWSET/ROW/ELEM_TYPE_NAME/text()').getStringVal();
      V_OWNER := V_COLL_STRUCTURE.extract('/ROWSET/ROW/ELEM_TYPE_OWNER/text()').getStringVal();

      V_RESULT := V_RESULT.insertXMLBefore
                ( 
                 '/ROWSET/ROW/FULL_TYPE_T/TYPE_T/HASHCODE',
                 V_COLL_STRUCTURE
                );   
    end if; 
    
    V_TYPE_STRUCTURE := dbms_xmlgen.getxmlType('select * from all_type_attrs where type_name = ''' || V_OBJECT_NAME || ''' and owner = ''' || V_OWNER || ''' order by ATTR_NO');     
        
    V_TYPE_HIERARCHY := dbms_xmlgen.getxmlType('select * from all_types connect by type_name = prior supertype_name and owner = supertype_owner start with type_name = ''' || V_OBJECT_NAME || ''' and owner =  ''' || V_OWNER || '''');
   
    begin
      select extract(schema,'//xsd:complexType[@xdb:SQLType="' || V_OBJECT_NAME || '" and @xdb:SQLSchema="'|| V_OWNER ||'"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES)
        into V_SCHEMA_DEFINITION
        from all_xml_schemas
       where existsNode(schema,'//xsd:complexType[@xdb:SQLType="' || V_OBJECT_NAME || '" and @xdb:SQLSchema="'|| V_OWNER ||'"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1;
  
      V_RESULT := V_RESULT.insertXMLBefore
                ( 
                 '/ROWSET/ROW/FULL_TYPE_T/TYPE_T/HASHCODE',
                 V_TYPE_STRUCTURE
                );
  
      V_RESULT := V_RESULT.insertXMLBefore
                ( 
                 '/ROWSET/ROW/FULL_TYPE_T/TYPE_T/HASHCODE',
                 V_TYPE_HIERARCHY
                );
  
      V_RESULT := V_RESULT.insertXMLBefore
                (
                 '/ROWSET/ROW/FULL_TYPE_T/TYPE_T/HASHCODE',
                  xmlType('<SCHEMA_DEFINITION/>')
                ); 
              
      V_RESULT := V_RESULT.appendChildXML
                (
                 '/ROWSET/ROW/FULL_TYPE_T/TYPE_T/SCHEMA_DEFINITION',
                 V_SCHEMA_DEFINITION
                ); 
    exception
      WHEN NO_DATA_FOUND THEN
        NULL;
    end; 
  end if;

  if V_OBJECT_TYPE = 'VIEW' then
    V_VIEW_COLUMNS := dbms_xmlgen.getxmlType('select * from all_tab_cols where table_name = ''' || V_OBJECT_NAME || ''' and owner = ''' || V_OWNER || ''' order by INTERNAL_COLUMN_ID'); 
    select updateXML
           (
             V_RESULT,
             '/ROWSET/ROW/VIEW_T/COL_LIST',
             V_VIEW_COLUMNS
           )
           into V_RESULT
      from dual;
  end if;

  -- Get rid of the XML declaration
  
  V_RESULT := V_RESULT.extract('/*');
  writeLogRecord('DESCRIBE',V_INIT,V_PARAMETERS);
 return V_RESULT;
exception
  when others then
    handleException('DESCRIBE',V_INIT,V_PARAMETERS);
    raise;  
end; 
--
function EXPLAINPLAN(P_STATEMENT XMLType) 
return XMLType 
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_CDATA_SECTION CLOB;
  V_STATEMENT_TEXT CLOB;
  res boolean;
begin
  V_PARAMETERS := P_STATEMENT;

  V_CDATA_SECTION := P_STATEMENT.extract('//text()').getCLOBVal();
  V_STATEMENT_TEXT := 'explain plan for ' || DBMS_XMLGEN.CONVERT(V_CDATA_SECTION,1);
  dbms_lob.freeTemporary(V_CDATA_SECTION);

  execute immediate V_STATEMENT_TEXT;
  dbms_lob.freeTemporary(V_STATEMENT_TEXT);

  writeLogRecord('EXPLAINPLAN',V_INIT,V_PARAMETERS);
  return dbms_xplan.build_plan_xml();
exception
  when others then
    handleException('EXPLAINPLAN',V_INIT,V_PARAMETERS);
    raise; 
end;
--
begin
	NULL;
	$IF $$DEBUG $THEN
    XDB_OUTPUT.createTraceFile('/public/XFILES_WEBDEMO_SERVICES.log');
  $END
end XFILES_WEBDEMO_SERVICES;
/
show errors
--
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
quit
