set echo on
spool registerSchema.log
--
set pages 0
set lines 256
set long  10000000
set trimspool on
--
def USERNAME = '&1'
--
DEF TARGET_DIRECTORY = '&2'
--
def SCHEMA_ARCHIVE = '&3'
--
@&TARGET_DIRECTORY/setVariables
--
drop user &USERNAME cascade
/
grant create any directory, drop any directory, connect, resource, alter session, create view, unlimited tablespace to &USERNAME identified by &PASSWORD
/
alter user &USERNAME identified by &PASSWORD DIGEST ENABLE
/
grant XFILES_USER to &USERNAME
/
alter user &USERNAME default tablespace &USER_TABLESPACE temporary tablespace &TEMP_TABLESPACE
/
--
VAR USERNAME VARCHAR2(128)
--
VAR PASSWORD VARCHAR2(128)
--
VAR USER_TABLESPACE VARCHAR2(128)
--
VAR TEMP_TABLESPACE VARCHAR2(128)
--
VAR TARGET_DIRECTORY VARCHAR2(1024)
--
VAR SCHEMA_ARCHIVE VARCHAR2(1024)
--
VAR DELETE_SCHEMAS VARCHAR2(5)
--
VAR CREATE_TABLES  VARCHAR2(5)
--
VAR LOAD_INSTANCES VARCHAR2(5)
--
VAR LOCAL VARCHAR2(5)
--
VAR BINARY_XML VARCHAR2(5)
--
VAR DISABLE_DOM_FIDELITY VARCHAR2(5)
--
VAR REPOSITORY_USAGE NUMBER
--
VAR REPOS_FOLDER VARCHAR2(4000)
--
VAR CONFIG_FILENAME VARCHAR2(4000)
--
VAR SCHEMA_FOLDER VARCHAR2(4000)
--
VAR TARGET_SCHEMA VARCHAR2(4000)
--
VAR ARCHIVE_NAME VARCHAR2(4000)
--
VAR SCHEMA_LOCATION_PREFIX VARCHAR2(700)
--
VAR SCRIPT_FILE_PATH VARCHAR2(700)
--
begin
  :USERNAME               := '&USERNAME';
  :PASSWORD               := '&PASSWORD';
  :USER_TABLESPACE        := '&USER_TABLESPACE';
  :TEMP_TABLESPACE        := '&TEMP_TABLESPACE';
  :TARGET_DIRECTORY       := '&TARGET_DIRECTORY';
  :SCHEMA_ARCHIVE         := '&SCHEMA_ARCHIVE';
  :DELETE_SCHEMAS         := '&DELETE_SCHEMAS';
  :CREATE_TABLES          := '&CREATE_TABLES';
  :LOAD_INSTANCES         := '&LOAD_INSTANCES';
  :LOCAL                  := '&LOCAL';
  :BINARY_XML             := '&BINARY_XML';
  :DISABLE_DOM_FIDELITY   := '&DISABLE_DOM_FIDELITY';
  :REPOSITORY_USAGE       := &REPOSITORY_USAGE;
  :SCHEMA_FOLDER          := '&SCHEMA_FOLDER';
  :TARGET_SCHEMA          := '&TARGET_SCHEMA';
  :SCHEMA_LOCATION_PREFIX := '&SCHEMA_LOCATION_PREFIX';
end;
/
print :USERNAME             
print :PASSWORD             
print :USER_TABLESPACE      
print :TEMP_TABLESPACE      
print :TARGET_DIRECTORY     
print :SCHEMA_ARCHIVE       
print :DELETE_SCHEMAS       
print :CREATE_TABLES        
print :LOAD_INSTANCES       
print :BINARY_XML           
print :REPOSITORY_USAGE     
print :DISABLE_DOM_FIDELITY 
print :SCHEMA_FOLDER
print :TARGET_SCHEMA
print :SCHEMA_LOCATION_PREFIX
--
declare
  V_ARCHIVE_FILE_NAME  VARCHAR2(700) := :SCHEMA_ARCHIVE;
  V_TARGET_SCHEMA VARCHAR2(700);
begin

  if (INSTR(V_ARCHIVE_FILE_NAME,'/') > 0) then
    V_ARCHIVE_FILE_NAME := substr(V_ARCHIVE_FILE_NAME,instr(V_ARCHIVE_FILE_NAME,'/',-1)+1);
  end if;

  V_ARCHIVE_FILE_NAME := substr(V_ARCHIVE_FILE_NAME,1,instr(V_ARCHIVE_FILE_NAME,'.',-1)-1);

  :REPOS_FOLDER := '/home/&USERNAME/' || V_ARCHIVE_FILE_NAME;
  
  if (:SCHEMA_FOLDER = '') OR (:SCHEMA_FOLDER IS NULL) then
    :SCHEMA_FOLDER := :REPOS_FOLDER;
  else
    :SCHEMA_FOLDER := :REPOS_FOLDER || '/' || :SCHEMA_FOLDER;
  end if;
   
 :ARCHIVE_NAME := V_ARCHIVE_FILE_NAME;
end;
/
print :REPOS_FOLDER
print :SCHEMA_FOLDER
print :ARCHIVE_NAME
--
begin
  if (DBMS_XDB.existsResource(:REPOS_FOLDER)) then
    DBMS_XDB.deleteResource(:REPOS_FOLDER,DBMS_XDB.DELETE_RECURSIVE);
  end if;
end;
/
commit
/
column ANY_PATH FORMAT A256
column OUTPUT FORMAT A256
set lines 256 pages 0 long 1000000
--
select ANY_PATH
  from RESOURCE_VIEW
 where under_path(RES,:REPOS_FOLDER) = 1
/
connect &USERNAME/&PASSWORD@&_CONNECT_IDENTIFIER

create or replace directory &USERNAME as '&TARGET_DIRECTORY'
/
call XDB_UTILITIES.createHomeFolder()
/
declare
  V_RESULT BOOLEAN;
  V_PATH   VARCHAR2(700);
begin
  V_PATH := :REPOS_FOLDER || '/' || :SCHEMA_ARCHIVE;
  XDB_UTILITIES.mkdir(:REPOS_FOLDER,TRUE);  
  V_RESULT := DBMS_XDB.createResource(V_PATH,bfilename('&USERNAME',:SCHEMA_ARCHIVE));
  commit;
end;
/
begin
  XDB_IMPORT_UTILITIES.UNZIP(:REPOS_FOLDER || '/' || :SCHEMA_ARCHIVE ,:REPOS_FOLDER,:REPOS_FOLDER || '/unzip_' || :SCHEMA_ARCHIVE ||' .log',XDB_CONSTANTS.RAISE_ERROR);
end;
/
select ANY_PATH
  from RESOURCE_VIEW
 where under_path(RES,:REPOS_FOLDER) = 1
/
declare
  V_RESULT            XMLTYPE;  
begin
  V_RESULT := XDB_ORDER_XMLSCHEMAS.createSchemaOrderingDocument(:REPOS_FOLDER, :REPOS_FOLDER, XDB.XDB$STRING_LIST_T(), :SCHEMA_LOCATION_PREFIX);
  :CONFIG_FILENAME := V_RESULT.extract('/SchemaRegistrationConfiguration/FileNames/registrationConfigurationFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration"').getStringVal();
end;
/
print :CONFIG_FILENAME
--
column CONFIG format A256
--
select xdburitype(:CONFIG_FILENAME).getXML() CONFIG
  from dual
/

declare
  C_SQLTYPE_MAPPINGS VARCHAR2(4000) := 
'<xdbpm:SQLTypeMappings xmlns:xdbpm="http://xmlns.oracle.com/xdb/xdbpm">
  <xdbpm:SQLTypeMapping>            
   <xdbpm:xsdType>dateTime</xdbpm:xsdType>
   <xdbpm:SQLType>TIMESTAMP WITH TIME ZONE</xdbpm:SQLType>
  </xdbpm:SQLTypeMapping>            
</xdbpm:SQLTypeMappings>';

  G_SQLTYPE_MAPPINGS XMLTYPE := XMLTYPE(C_SQLTYPE_MAPPINGS);
  
  V_SCRIPT_NAME VARCHAR2(700);
  V_XML_SCHEMA_CONFIGURATION XMLTYPE := xdburitype(:CONFIG_FILENAME).getXML();
  V_XML_SCHEMA XMLTYPE;
  V_RESULT BOOLEAN;
  
  cursor getSchemaDetails 
  is
  select SCHEMA_LOCATION_HINT,
         FORCE,
         REPOSITORY_PATH 
    from XMLTable(
           xmlNamespaces(
              default 'http://xmlns.oracle.com/xdb/pm/registrationConfiguration'
           ),
           '/SchemaRegistrationConfiguration/SchemaInformation'
           passing V_XML_SCHEMA_CONFIGURATION
           columns
           SCHEMA_INDEX         FOR ORDINALITY,
           SCHEMA_LOCATION_HINT VARCHAR2(700) PATH 'schemaLocationHint',
           FORCE                VARCHAR2(5)   PATH 'force',
           REPOSITORY_PATH      VARCHAR2(700) PATH 'repositoryPath'
         )
   order by SCHEMA_INDEX;
       
begin
  if (XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:BINARY_XML)) then
    XDB_OPTIMIZE_XMLSCHEMA.setSchemaRegistrationOptions(
                             P_LOCAL            => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:LOCAL)
                            ,P_OWNER            => USER 
                            ,P_ENABLE_HIERARCHY => :REPOSITORY_USAGE
                            ,P_OPTIONS          => DBMS_XMLSCHEMA.REGISTER_BINARYXML
    );
  else
  
    for s in getSchemaDetails() loop
      V_XML_SCHEMA := xdburitype(s.REPOSITORY_PATH).getXML();
    
      /*
      **
      ** if (P_TYPE_MAPPINGS is NULL) then
      **  XDB_EDIT_XMLSCHEMA.setSQLTypeMappings(G_SQLTYPE_MAPPINGS);
      ** else
      **   XDB_EDIT_XMLSCHEMA.setSQLTypeMappings(P_TYPE_MAPPINGS);
      **  end if;
      **
      */
    
      XDB_EDIT_XMLSCHEMA.setSQLTypeMappings(G_SQLTYPE_MAPPINGS);
    
      XDB_EDIT_XMLSCHEMA.fixRelativeURLs(V_XML_SCHEMA,s.SCHEMA_LOCATION_HINT);
      XDB_EDIT_XMLSCHEMA.removeAppInfo(V_XML_SCHEMA);
      XDB_EDIT_XMLSCHEMA.applySQLTypeMappings(V_XML_SCHEMA);

      DBMS_XMLSCHEMA_ANNOTATE.printWarnings(FALSE);
      DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(V_XML_SCHEMA);
  
      if ((XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:DISABLE_DOM_FIDELITY)) and (V_XML_SCHEMA.existsNode('//xsd:complexType','xmlns:xsd="http://www.w3.org/2001/XMLSchema"') = 1)) then
        DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDOM(V_XML_SCHEMA);
      end if;
  
      DBMS_XMLSCHEMA.registerSchema(
        SCHEMAURL        => s.SCHEMA_LOCATION_HINT,
        SCHEMADOC        => V_XML_SCHEMA,
        LOCAL            => TRUE,
        GENBEAN          => FALSE,
        GENTYPES         => TRUE,
        GENTABLES        => FALSE,
        FORCE            => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(s.FORCE),
        OWNER            => USER,
        ENABLEHIERARCHY  => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE
      );

    end loop;
  
  
    V_RESULT := XDB_OPTIMIZE_XMLSCHEMA.doTypeAnalysis(V_XML_SCHEMA_CONFIGURATION,:SCHEMA_LOCATION_PREFIX,USER);
    IF (V_RESULT) then
      XDB_OPTIMIZE_XMLSCHEMA.setSchemaRegistrationOptions(
                               P_LOCAL                 => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:LOCAL)
                              ,P_OWNER                 => USER 
                              ,P_ENABLE_HIERARCHY      => :REPOSITORY_USAGE
                              ,P_OPTIONS               => 0
      );

      XDB_OPTIMIZE_XMLSCHEMA.setRegistrationScriptOptions(
        P_DISABLE_DOM_FIDELITY  => XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:DISABLE_DOM_FIDELITY)
      );
    end if;
  end if;           

  V_SCRIPT_NAME := XDB_OPTIMIZE_SCHEMA.createScriptFile(V_XML_SCHEMA_CONFIGURATION);
  
  if (XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:DELETE_SCHEMAS)) then
    V_SCRIPT_NAME := XDB_OPTIMIZE_SCHEMA.appendDeleteSchemaScript(V_XML_SCHEMA_CONFIGURATION);
  end if;
  
  V_SCRIPT_NAME := XDB_OPTIMIZE_XMLSCHEMA.appendRegisterSchemaScript(V_XML_SCHEMA_CONFIGURATION);

  if ((:REPOSITORY_USAGE = DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE) and (XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:CREATE_TABLES))) then  
    V_SCRIPT_NAME := XDB_OPTIMIZE_SCHEMA.appendCreateTablesScript(V_XML_SCHEMA_CONFIGURATION);
  end if;

  if (XDB_DOM_UTILITIES.VARCHAR_TO_BOOLEAN(:LOAD_INSTANCES)) then
    V_SCRIPT_NAME := XDB_OPTIMIZE_SCHEMA.appendLoadInstancesScript(V_XML_SCHEMA_CONFIGURATION);
  end if;
  :SCRIPT_FILE_PATH := V_SCRIPT_NAME;
end;
/
--
print :SCRIPT_FILE_PATH
--
column SCRIPT FORMAT A256
set pages 0 lines 256 long 10000000
set echo off
spool &TARGET_DIRECTORY/registerSchema.sql
select xdburitype(:SCRIPT_FILE_PATH).getClob() SCRIPT
  from dual
/
spool registerSchema.log append
set echo on
@&TARGET_DIRECTORY/registerSchema.sql
--
quit
