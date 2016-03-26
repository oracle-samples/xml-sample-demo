
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
alter session set current_schema = XDBPM
/
create or replace view DATABASE_SUMMARY
as
select d.NAME, p.VALUE "SERVICE_NAME", i.HOST_NAME, n.VALUE "DB_CHARACTERSET" 
  from v$system_parameter p, v$database d, v$instance i, nls_database_parameters n
 where p.name = 'service_names' 
   and n.parameter='NLS_CHARACTERSET';
/
show errors
--
create or replace package XDBPM_CONFIGURATION
AUTHID CURRENT_USER
as
  function  getDatabaseSummary return XMLType;
  procedure folderDatabaseSummary; 
  procedure addSchemaMapping(P_NAMESPACE VARCHAR2, P_ROOT_ELEMENT VARCHAR2, P_SCHEMA_URL VARCHAR2);
  procedure addMimeMapping(P_EXTENSION VARCHAR2, P_MAPPING VARCHAR2);
  procedure registerXMLExtension(P_EXTENSION VARCHAR2);

  procedure addServletMapping(
              P_PATTERN VARCHAR2, 
              P_SERVLET_NAME VARCHAR2, 
              P_DISP_NAME VARCHAR2, 
              P_SERVLET_CLASS VARCHAR2, 
              P_SERVLET_SCHEMA VARCHAR2, 
              P_LANGUAGE VARCHAR2 DEFAULT 'Java', 
              P_DESCRIPTION VARCHAR2 DEFAULT '', 
              P_SECURITY_ROLE XMLType DEFAULT NULL
            );

  procedure deleteservletMapping(P_SERVLET_NAME VARCHAR2);            
  procedure setAnonymousAccess(P_STATE VARCHAR2);
end XDBPM_CONFIGURATION;
/
show errors
--
create or replace synonym XDB_CONFIGURATION for XDBPM_CONFIGURATION
/
grant execute on XDBPM_CONFIGURATION to public
/
create or replace view DATABASE_SUMMARY_XML of XMLType
with object id
(
'DATABASE_SUMMARY'
)
as select XDBPM_CONFIGURATION.getDatabaseSummary() from dual
/
create or replace trigger NO_DML_DATABASE_SUMMARY_XML
instead of insert or update or delete on DATABASE_SUMMARY_XML
begin
 null;
end;
/
grant select on DATABASE_SUMMARY_XML to public
/
create or replace package body XDBPM_CONFIGURATION as
--
function getDatabaseSummary
return XMLType
as
  V_SUMMARY XMLType;
  V_DUMMY XMLType;
begin
  select DBMS_XDB.cfg_get()
  into V_DUMMY
  from dual;

  select xmlElement
         (
           "Database",
           XMLAttributes
           (
             x.NAME as "Name",
             extractValue(config,'/xdbconfig/sysconfig/protocolconfig/httpconfig/http-port') as "HTTP",
             extractValue(config,'/xdbconfig/sysconfig/protocolconfig/ftpconfig/ftp-port') as "FTP"
           ),
           xmlElement
           (
             "Services",
             (
               xmlForest(SERVICE_NAME as "ServiceName")
             )
           ),
           xmlElement
           (
             "NLS",
             (
               XMLForest(DB_CHARACTERSET as "DatabaseCharacterSet")
             )
           ),
           xmlElement
           (
             "Hosts",
             (
               XMLForest(HOST_NAME as "HostName")
             )
           ),
           xmlElement
           (
             "VersionInformation",
             ( XMLCONCAT
                      (
                        (select XMLAGG(XMLElement
                        (
                           "ProductVersion",
                           BANNER
                        )
                        )from V$VERSION),
                        (select XMLAGG(XMLElement
                        (
                           "ProductVersion",
                           BANNER
                        )
                        ) from ALL_REGISTRY_BANNERS)
                      )
             ) 
           )
         )
  into V_SUMMARY
  from DATABASE_SUMMARY x, (select DBMS_XDB.cfg_get() config from dual);
  V_SUMMARY := XMLType(V_SUMMARY.getClobVal());
  return V_SUMMARY;
end;
--
procedure folderDatabaseSummary
as
  resource_not_found exception;
  PRAGMA EXCEPTION_INIT( resource_not_found , -31001 );

  V_TARGET_RESOURCE VARCHAR2(256) := '/sys/databaseSummary.xml';

  V_RESULT boolean;
  V_XMLREF ref XMLType;
begin
   begin
     DBMS_XDB.deleteResource(V_TARGET_RESOURCE,DBMS_XDB.DELETE_FORCE);
   exception
     when resource_not_found then
       null;
   end;

   select make_ref(XDBPM.DATABASE_SUMMARY_XML,'DATABASE_SUMMARY')
   into V_XMLREF
   from dual;

   V_RESULT := DBMS_XDB.createResource(V_TARGET_RESOURCE,V_XMLREF);
   
   DBMS_XDB.setAcl(V_TARGET_RESOURCE,'/sys/acls/bootstrap_acl.xml');
end;
--
procedure addServletMapping(
            P_PATTERN VARCHAR2, 
            P_SERVLET_NAME VARCHAR2, 
            P_DISP_NAME VARCHAR2, 
            P_SERVLET_CLASS VARCHAR2, 
            P_SERVLET_SCHEMA VARCHAR2, 
            P_LANGUAGE VARCHAR2 DEFAULT 'Java', 
            P_DESCRIPTION VARCHAR2 DEFAULT '', 
            P_SECURITY_ROLE XMLType DEFAULT NULL
          )
as
  V_XDB_CONFIG XMLType; 
begin
   V_XDB_CONFIG := DBMS_XDB.cfg_get();
   select deleteXML
          (
            V_XDB_CONFIG,
            '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list/servlet[servlet-name="' || P_SERVLET_NAME || '"]'
          )
          into V_XDB_CONFIG
          from dual;

   if (P_LANGUAGE = 'C') then
     select insertChildXML
            (
              V_XDB_CONFIG,
              '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list',
              'servlet',
              xmlElement
              (
                "servlet",
                xmlAttributes('http://xmlns.oracle.com/xdb/xdbconfig.xsd' as "xmlns"),
                xmlForest
                (
                   P_SERVLET_NAME as "servlet-name",
                   P_LANGUAGE as "servlet-language",
                   P_DISP_NAME as "display-name",
                   P_DESCRIPTION as "description"
                ),
                P_SECURITY_ROLE            
              )
            )
       into V_XDB_CONFIG
       from dual;
   else
     select insertChildXML
            (
              V_XDB_CONFIG,
              '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list',
              'servlet',
              xmlElement
              (
                "servlet",
                xmlAttributes('http://xmlns.oracle.com/xdb/xdbconfig.xsd' as "xmlns"),
                xmlForest
                (
                   P_SERVLET_NAME as "servlet-name",
                   P_LANGUAGE as "servlet-language",
                   P_DISP_NAME as "display-name",
                   P_DESCRIPTION as "description",
                   P_SERVLET_CLASS as "servlet-class",
                   P_SERVLET_SCHEMA as "servlet-schema"
                ),
                P_SECURITY_ROLE            
              )
            )
       into V_XDB_CONFIG
       from dual;
   end if;
     
   select deleteXML
          (
            V_XDB_CONFIG,
            '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-mappings/servlet-mapping[servlet-name="' || P_SERVLET_NAME || '"]'
          )
          into V_XDB_CONFIG
          from dual;
   
   select insertChildXML
          (
            V_XDB_CONFIG,
            '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-mappings',
            'servlet-mapping',
            XMLType
            (
               '<servlet-mapping xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">
                  <servlet-pattern>'||P_PATTERN||'</servlet-pattern>
                  <servlet-name>'||P_SERVLET_NAME||'</servlet-name>
                </servlet-mapping>'
            )            
          )
     into V_XDB_CONFIG
     from dual;

  DBMS_XDB.cfg_update(V_XDB_CONFIG);

end;
--
procedure deleteservletMapping (P_SERVLET_NAME VARCHAR2) 
as
  V_XDB_CONFIG XMLType; 
begin
   V_XDB_CONFIG := DBMS_XDB.cfg_get();
   select deleteXML
          (
            V_XDB_CONFIG,
            '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-list/servlet[servlet-name="' || P_SERVLET_NAME || '"]'
          )
          into V_XDB_CONFIG
          from dual;
     
   select deleteXML
          (
            V_XDB_CONFIG,
            '/xdbconfig/sysconfig/protocolconfig/httpconfig/webappconfig/servletconfig/servlet-mappings/servlet-mapping[servlet-name="' || P_SERVLET_NAME || '"]'
          )
          into V_XDB_CONFIG
          from dual;
   
  DBMS_XDB.cfg_update(V_XDB_CONFIG);

end;
--
procedure addSchemaMapping(P_NAMESPACE VARCHAR2, P_ROOT_ELEMENT VARCHAR2, P_SCHEMA_URL VARCHAR2)
is
  V_XDB_CONFIG XMLType;
begin
  V_XDB_CONFIG := DBMS_XDB.cfg_get();
  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/schemaLocation-mappings','xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') = 0) then
    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig',
       	     'schemaLocation-mappings',
       	     XMLType('<schemaLocation-mappings xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"/>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  end if;
  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/schemaLocation-mappings/schemaLocation-mapping[namespace="'|| P_NAMESPACE ||'" and element="'|| P_ROOT_ELEMENT ||'"]','xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') = 0) then
    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig/schemaLocation-mappings',
       	     'schemaLocation-mapping',
       	     XMLType('<schemaLocation-mapping xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"><namespace>' || P_NAMESPACE || '</namespace><element>' || P_ROOT_ELEMENT || '</element><schemaURL>'|| P_SCHEMA_URL ||'</schemaURL></schemaLocation-mapping>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  else
    select updateXML
           (
             V_XDB_CONFIG,
             '/xdbconfig/sysconfig/schemaLocation-mappings/schemaLocation-mapping[namespace="'|| P_NAMESPACE ||'" and element="'|| P_ROOT_ELEMENT ||'"]/schemaURL/text()',
             P_SCHEMA_URL,
             'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_XDB_CONFIG
      from dual;
  end if;

  DBMS_XDB.cfg_update(V_XDB_CONFIG);

end;
--
procedure addMimeMapping(P_EXTENSION VARCHAR2, P_MAPPING VARCHAR2)
is
  V_XDB_CONFIG XMLType;
begin
  V_XDB_CONFIG := DBMS_XDB.cfg_get();
  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/mime-mappings/mime-mapping[extension="' || P_EXTENSION || '"]','xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') = 0) then
    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/mime-mappings',
       	     'mime-mapping',
       	     XMLType('<mime-mapping xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">
		  <extension>' || P_EXTENSION || '</extension> 
		  <mime-type>' || P_MAPPING   || '</mime-type> 
  		</mime-mapping>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  else
    select updateXML
           (
             V_XDB_CONFIG,
             '/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/mime-mappings/mime-mapping[extension="' || P_EXTENSION || '"]/mime-type/text()',
             P_MAPPING,
             'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_XDB_CONFIG
      from dual;
  end if;

  DBMS_XDB.cfg_update(V_XDB_CONFIG);

end;
--
procedure registerXMLExtension(P_EXTENSION VARCHAR2)
is
  V_XDB_CONFIG XMLType;
begin
  V_XDB_CONFIG := DBMS_XDB.cfg_get();
  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/xml-extensions','xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') = 0) then

    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig/protocolconfig/common/extension-mappings',
       	     'xml-extensions',
       	     XMLType('<xml-extensions xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"/>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  end if;

  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/xml-extensions[extension="' || P_EXTENSION || '"]','xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"') = 0) then
    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig/protocolconfig/common/extension-mappings/xml-extensions',
       	     'extension',
       	     XMLType('<extension xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">' || P_EXTENSION || '</extension>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  end if;

  DBMS_XDB.cfg_update(V_XDB_CONFIG);

end;
--
procedure setAnonymousAccess(P_STATE VARCHAR2)
is
  V_XDB_CONFIG XMLType;
begin
  V_XDB_CONFIG := DBMS_XDB.cfg_get();
  if (V_XDB_CONFIG.existsNode('/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access') = 0) then
    select insertChildXML
           (
       	     V_XDB_CONFIG,
       	     '/xdbconfig/sysconfig/protocolconfig/httpconfig',
       	     'allow-repository-anonymous-access',
       	     XMLType('<allow-repository-anonymous-access xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd">' || lower(P_STATE) || '</allow-repository-anonymous-access>'),
       	     'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
       	   )
      into V_XDB_CONFIG
      from dual;
  else
    select updateXML
           (
             V_XDB_CONFIG,
             '/xdbconfig/sysconfig/protocolconfig/httpconfig/allow-repository-anonymous-access/text()',
             lower(P_STATE),
             'xmlns="http://xmlns.oracle.com/xdb/xdbconfig.xsd"'
           )
      into V_XDB_CONFIG
      from dual;
  end if;

  DBMS_XDB.cfg_update(V_XDB_CONFIG);
end;
--
end XDBPM_CONFIGURATION;
/
show errors
--
call XDBPM_CONFIGURATION.folderDatabaseSummary()
/
set echo on
set pages 100
set long 10000
--
select xdburitype('/sys/databaseSummary.xml').getXML() from dual
/
--
alter session set current_schema = SYS
/