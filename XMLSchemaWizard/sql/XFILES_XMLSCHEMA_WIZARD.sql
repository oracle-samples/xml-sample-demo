set echo on
spool INSTALL_XML_SCHEMAWIZARD.log
--
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
--
set define on
--
create or replace package XFILES_XMLSCHEMA_WIZARD
authid CURRENT_USER
as
  
  function  UNPACK_ARCHIVE(P_ARCHIVE_PATH VARCHAR2) return NUMBER;

  function  ORDER_SCHEMA(P_XML_SCHEMA_FOLDER VARCHAR2, P_ROOT_XML_SCHEMA VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2 DEFAULT '') return XMLTYPE;
  function  ORDER_SCHEMAS_IN_FOLDER(P_XML_SCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2 DEFAULT '') return XMLTYPE;
  function  ORDER_SCHEMA_LIST(P_XML_SCHEMA_FOLDER VARCHAR2, P_XML_SCHEMAS XMLTYPE, P_SCHEMA_LOCATION_PREFIX VARCHAR2 DEFAULT '')  return XMLTYPE;

  function  GET_GLOBAL_ELEMENT_LIST(P_XML_SCHEMA_FOLDER VARCHAR2) return XMLTYPE;
  function  DO_TYPE_ANALYSIS(P_XML_SCHEMA_CONFIG IN OUT XMLTYPE, P_SCHEMA_LOCATION_HINT  VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) return BOOLEAN;

  function  CREATE_SCRIPT(
              P_XML_SCHEMA_CONFIGURATION XMLTYPE, 
              P_BINARY_XML BOOLEAN DEFAULT FALSE, 
              P_LOCAL BOOLEAN DEFAULT TRUE, 
              P_DISABLE_DOM_FIDELITY BOOLEAN DEFAULT TRUE,  
              P_REPOSITORY_USAGE VARCHAR2, 
              P_DELETE_SCHEMAS BOOLEAN DEFAULT FALSE,
              P_CREATE_TABLES BOOLEAN DEFAULT FALSE,
              P_LOAD_INSTANCES BOOLEAN DEFAULT FALSE
            ) return VARCHAR2;

  procedure REGISTER_SCHEMA(
              P_SCHEMA_LOCATION_HINT   VARCHAR2, 
              P_SCHEMA_PATH            VARCHAR2, 
              P_FORCE                  BOOLEAN        DEFAULT FALSE,
              P_OWNER                  VARCHAR2       DEFAULT USER,
              P_DISABLE_DOM_FIDELITY   BOOLEAN        DEFAULT TRUE,
              P_TYPE_MAPPINGS          XMLTYPE        DEFAULT NULL
            );
--

end XFILES_XMLSCHEMA_WIZARD;
/
show errors
--
create or replace package body XFILES_XMLSCHEMA_WIZARD
as
--
  C_SQLTYPE_MAPPINGS VARCHAR2(4000) := 
'<xdbpm:SQLTypeMappings xmlns:xdbpm="http://xmlns.oracle.com/xdb/xdbpm">
  <xdbpm:SQLTypeMapping>            
	 <xdbpm:xsdType>dateTime</xdbpm:xsdType>
	 <xdbpm:SQLType>TIMESTAMP WITH TIME ZONE</xdbpm:SQLType>
  </xdbpm:SQLTypeMapping>            
</xdbpm:SQLTypeMappings>';

  G_SQLTYPE_MAPPINGS XMLTYPE := XMLTYPE(C_SQLTYPE_MAPPINGS);
  
procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/XFILES/XFILES_XMLSCHEMA_WIZARD/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/XFILES/XFILES_XMLSCHEMA_WIZARD/',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure handleException(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)
as
  V_STACK_TRACE XMLType;
  V_RESULT      boolean;
begin
  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
  rollback; 
  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);
end;
--
function UNPACK_ARCHIVE(P_ARCHIVE_PATH VARCHAR2)
return NUMBER
--
--  Unzip the XML Schema Archive, remove redundant folders and return number of documents.
--
as 
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  
  V_RESOURCE_COUNT    NUMBER;
begin
  select xmlElement("archivePath",P_ARCHIVE_PATH)
    into V_PARAMETERS
    from dual;

  V_RESOURCE_COUNT := XDB_REGISTRATION_HELPER.unpackArchive(P_ARCHIVE_PATH);
    
  writeLogRecord('UNPACK_ARCHIVE',V_INIT,V_PARAMETERS);
	return V_RESOURCE_COUNT;
exception
  when others then
    handleException('UNPACK_ARCHIVE',V_INIT,V_PARAMETERS);
    raise;
end;
--
function GET_GLOBAL_ELEMENT_LIST(P_XML_SCHEMA_FOLDER VARCHAR2) 
return XMLTYPE
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_CHARSET_ID        NUMBER(4);
  V_RESULT            XMLTYPE;
  
begin
  select xmlConcat(
           xmlElement("folderPath",P_XML_SCHEMA_FOLDER)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_ORDER_XMLSCHEMAS.getGlobalElementList(P_XML_SCHEMA_FOLDER);
  writeLogRecord('GET_GLOBAL_ELEMENT_LIST',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('GET_GLOBAL_ELEMENT_LIST',V_INIT,V_PARAMETERS);
    raise;
end;
--
function ORDER_SCHEMAS_IN_FOLDER(P_XML_SCHEMA_FOLDER VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2 DEFAULT '') 
return XMLTYPE
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_CHARSET_ID        NUMBER(4);
  V_RESULT            XMLTYPE;
  
begin
  select xmlConcat(
           xmlElement("folderPath",P_XML_SCHEMA_FOLDER),
           xmlElement("schemaLocationPrefix",P_SCHEMA_LOCATION_PREFIX)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_ORDER_XMLSCHEMAS.createSchemaOrderingDocument(P_XML_SCHEMA_FOLDER, P_XML_SCHEMA_FOLDER, XDB.XDB$STRING_LIST_T(), P_SCHEMA_LOCATION_PREFIX);
  writeLogRecord('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
    raise;
end;
--
function ORDER_SCHEMA_LIST(P_XML_SCHEMA_FOLDER VARCHAR2, P_XML_SCHEMAS XMLTYPE, P_SCHEMA_LOCATION_PREFIX VARCHAR2  DEFAULT '') 
return XMLTYPE
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_CHARSET_ID        NUMBER(4);
  V_RESULT            XMLTYPE;
  
  V_XMLSCHEMA_PATHS   XDB.XDB$STRING_LIST_T :=  XDB.XDB$STRING_LIST_T();
begin
  select xmlConcat(
           xmlElement("folderPath",P_XML_SCHEMA_FOLDER),
           xmlElement("xmlSchemas",P_XML_SCHEMAS),
           xmlElement("schemaLocationPrefix",P_SCHEMA_LOCATION_PREFIX)           
         )
    into V_PARAMETERS
    from dual;

  select FOLDER_PATH 
    BULK COLLECT into V_XMLSCHEMA_PATHS
    from XMLTABLE(
         '/schemas/schema'
         passing P_XML_SCHEMAS
         columns
           FOLDER_PATH VARCHAR2(4000) PATH 'text()'
         );
        
  V_RESULT := XDB_ORDER_XMLSCHEMAS.createSchemaOrderingDocument(P_XML_SCHEMA_FOLDER, P_XML_SCHEMA_FOLDER, V_XMLSCHEMA_PATHS, P_SCHEMA_LOCATION_PREFIX);
  writeLogRecord('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
    raise;
end;
--
function ORDER_SCHEMA(P_XML_SCHEMA_FOLDER VARCHAR2, P_ROOT_XML_SCHEMA VARCHAR2, P_SCHEMA_LOCATION_PREFIX VARCHAR2  DEFAULT '') 
return XMLTYPE
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_CHARSET_ID        NUMBER(4);
  V_RESULT            XMLTYPE;
  
  V_XMLSCHEMA_PATHS   XDB.XDB$STRING_LIST_T :=  XDB.XDB$STRING_LIST_T();
begin
  select xmlConcat(
           xmlElement("folderPath",P_XML_SCHEMA_FOLDER),
           xmlElement("xmlSchema",P_ROOT_XML_SCHEMA),
           xmlElement("schemaLocationPrefix",P_SCHEMA_LOCATION_PREFIX)           
         )
    into V_PARAMETERS
    from dual;

  V_XMLSCHEMA_PATHS(1) := P_ROOT_XML_SCHEMA;
  V_RESULT := XDB_ORDER_XMLSCHEMAS.createSchemaOrderingDocument(P_XML_SCHEMA_FOLDER,P_XML_SCHEMA_FOLDER,V_XMLSCHEMA_PATHS,P_SCHEMA_LOCATION_PREFIX);
  writeLogRecord('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('ORDER_SCHEMAS',V_INIT,V_PARAMETERS);
    raise;
end;
--
function DO_TYPE_ANALYSIS(P_XML_SCHEMA_CONFIG IN OUT XMLTYPE, P_SCHEMA_LOCATION_HINT  VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
return BOOLEAN
as
  V_RESULT                       BOOLEAN;
  V_PARAMETERS                   XMLType;
  V_INIT                         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
begin
  select xmlConcat
         (
           xmlElement("schemaConfiguration",P_XML_SCHEMA_CONFIG),
           xmlElement("schemaLocationHint",P_SCHEMA_LOCATION_HINT),
           xmlElement("owner",P_OWNER)
         )
    into V_PARAMETERS
    from dual;

  V_RESULT := XDB_OPTIMIZE_XMLSCHEMA.doTypeAnalysis(P_XML_SCHEMA_CONFIG,P_SCHEMA_LOCATION_HINT,P_OWNER);
  writeLogRecord('DO_TYPE_ANALYSIS',V_INIT,V_PARAMETERS);
  return V_RESULT;
exception
  when others then
    handleException('DO_TYPE_ANALYSIS',V_INIT,V_PARAMETERS);
    raise;
end;
--
procedure REGISTER_SCHEMA(
            P_SCHEMA_LOCATION_HINT   VARCHAR2, 
            P_SCHEMA_PATH            VARCHAR2, 
            P_FORCE                  BOOLEAN        DEFAULT FALSE,
            P_OWNER                  VARCHAR2       DEFAULT USER,
            P_DISABLE_DOM_FIDELITY   BOOLEAN        DEFAULT TRUE,
            P_TYPE_MAPPINGS          XMLTYPE        DEFAULT NULL
        )
as
  NO_MATCHING_NODE exception;
  PRAGMA EXCEPTION_INIT( NO_MATCHING_NODE , -31061 );

  V_PARAMETERS                   XMLType;
  V_INIT                         TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_XML_SCHEMA                    XMLType;

begin
  select xmlConcat
         (
           xmlElement("schemaLocationHint",P_SCHEMA_LOCATION_HINT),
           xmlElement("schemaPath",P_SCHEMA_PATH),
           xmlElement("force",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE)),
           xmlElement("owner",P_OWNER),
           xmlElement("disableDOMFidelity",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DISABLE_DOM_FIDELITY)),
           xmlElement("typeMappings",P_TYPE_MAPPINGS)
         )
    into V_PARAMETERS
    from dual;

  V_XML_SCHEMA := xdburitype(P_SCHEMA_PATH).getXML();
    
  if (P_TYPE_MAPPINGS is NULL) then
    XDB_EDIT_XMLSCHEMA.setSQLTypeMappings(G_SQLTYPE_MAPPINGS);
  else
    XDB_EDIT_XMLSCHEMA.setSQLTypeMappings(P_TYPE_MAPPINGS);
  end if;

  XDB_EDIT_XMLSCHEMA.fixRelativeURLs(V_XML_SCHEMA,P_SCHEMA_LOCATION_HINT);
  XDB_EDIT_XMLSCHEMA.removeAppInfo(V_XML_SCHEMA);
  XDB_EDIT_XMLSCHEMA.applySQLTypeMappings(V_XML_SCHEMA);

  DBMS_XMLSCHEMA_ANNOTATE.printWarnings(FALSE);
  DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(V_XML_SCHEMA);
  
  if ((P_DISABLE_DOM_FIDELITY) and (V_XML_SCHEMA.existsNode('//xsd:complexType','xmlns:xsd="http://www.w3.org/2001/XMLSchema"') = 1)) then
    DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_XML_SCHEMA);
  end if;
  
  DBMS_XMLSCHEMA.registerSchema(
    SCHEMAURL        => P_SCHEMA_LOCATION_HINT,
    SCHEMADOC        => V_XML_SCHEMA,
    LOCAL            => TRUE,
    GENBEAN          => FALSE,
    GENTYPES         => TRUE,
    GENTABLES        => FALSE,
    FORCE            => P_FORCE,
    OWNER            => P_OWNER,
    ENABLEHIERARCHY  => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE
  );

  writeLogRecord('REGISTER_SCHEMA',V_INIT,V_PARAMETERS);
exception
  when others then
    handleException('REGISTER_SCHEMA',V_INIT,V_PARAMETERS);
    raise;
end;
--
function  CREATE_SCRIPT(
            P_XML_SCHEMA_CONFIGURATION XMLTYPE, 
            P_BINARY_XML BOOLEAN DEFAULT FALSE, 
            P_LOCAL BOOLEAN DEFAULT TRUE, 
            P_DISABLE_DOM_FIDELITY BOOLEAN DEFAULT TRUE,  
            P_REPOSITORY_USAGE VARCHAR2, 
            P_DELETE_SCHEMAS BOOLEAN DEFAULT FALSE,
            P_CREATE_TABLES BOOLEAN DEFAULT FALSE,
            P_LOAD_INSTANCES BOOLEAN DEFAULT FALSE
          )
return VARCHAR2
as
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  
  V_ENABLE_HEIRARCHY  NUMBER;
  V_SCRIPT_FILENAME   VARCHAR2(700);
  
begin
	 select xmlConcat(
	          xmlElement("xmlSchemaCOnfiguration",P_XML_SCHEMA_CONFIGURATION),
	          xmlElement("binaryXML",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_BINARY_XML)),
	          xmlElement("localSchema",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_LOCAL)),
	          xmlElement("disableDOMFidelity",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DISABLE_DOM_FIDELITY)),
	          xmlElement("repositoryUsage",P_REPOSITORY_USAGE),
	          xmlElement("deleteSchemas",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DELETE_SCHEMAS)),
	          xmlElement("createTables",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_CREATE_TABLES)),
	          xmlElement("loadInstances",XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_LOAD_INSTANCES))
	       )
    into V_PARAMETERS
    from dual;

  if (P_REPOSITORY_USAGE = 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE') then
    V_ENABLE_HEIRARCHY := DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE;
  end if;
 
  if (P_REPOSITORY_USAGE = 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_CONTENTS') then
    V_ENABLE_HEIRARCHY := DBMS_XMLSCHEMA.ENABLE_HIERARCHY_CONTENTS;
  end if;

  if (P_REPOSITORY_USAGE = 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA') then
    V_ENABLE_HEIRARCHY := DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA;
  end if;

  if (P_BINARY_XML) then
    XDB_OPTIMIZE_XMLSCHEMA.setSchemaRegistrationOptions(
                             P_LOCAL            => P_LOCAL
                            ,P_OWNER            => USER 
                            ,P_ENABLE_HIERARCHY => V_ENABLE_HEIRARCHY
                            ,P_OPTIONS          => DBMS_XMLSCHEMA.REGISTER_BINARYXML
    );
  else
    XDB_OPTIMIZE_XMLSCHEMA.setSchemaRegistrationOptions(
                             P_LOCAL                 => P_LOCAL 
                            ,P_OWNER                 => USER 
                            ,P_ENABLE_HIERARCHY      => V_ENABLE_HEIRARCHY
                            ,P_OPTIONS               => 0
    );

    XDB_OPTIMIZE_XMLSCHEMA.setRegistrationScriptOptions(
      P_DISABLE_DOM_FIDELITY  => P_DISABLE_DOM_FIDELITY 
    );

  end if;           

  V_SCRIPT_FILENAME := XDB_OPTIMIZE_SCHEMA.createScriptFile(P_XML_SCHEMA_CONFIGURATION);
  
  if (P_DELETE_SCHEMAS) then
	  V_SCRIPT_FILENAME := XDB_OPTIMIZE_SCHEMA.appendDeleteSchemaScript(P_XML_SCHEMA_CONFIGURATION);
  end if;
  
  V_SCRIPT_FILENAME := XDB_OPTIMIZE_XMLSCHEMA.appendRegisterSchemaScript(P_XML_SCHEMA_CONFIGURATION);

  if ((P_REPOSITORY_USAGE = 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE') and (P_CREATE_TABLES)) then  
    V_SCRIPT_FILENAME := XDB_OPTIMIZE_SCHEMA.appendCreateTablesScript(P_XML_SCHEMA_CONFIGURATION);
  end if;

	if (P_LOAD_INSTANCES) then
    V_SCRIPT_FILENAME := XDB_OPTIMIZE_SCHEMA.appendLoadInstancesScript(P_XML_SCHEMA_CONFIGURATION);
  end if;

  writeLogRecord('CREATE_REGISTER_SCHEMA_SCRIPT',V_INIT,V_PARAMETERS);
	return V_SCRIPT_FILENAME;
exception
  when others then
    handleException('CREATE_REGISTER_SCHEMA_SCRIPT',V_INIT,V_PARAMETERS);
    raise;
end;
--
end XFILES_XMLSCHEMA_WIZARD;
/
show errors
--
grant execute on XFILES_XMLSCHEMA_WIZARD to public
/
--
quit
