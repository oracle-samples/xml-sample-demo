
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
create or replace package XDB_MAP_FOLDER_CONTENT_11100
AUTHID CURRENT_USER
as
  C_CONFIG_METADATA_NAMESPACE  constant varchar2(1024)  := 'http:/xmlns.oracle.com/xdb/pm/upload';
  C_RESCONFIG_FILENAME         constant varchar2(700)   := 'ContentMappingResConfig.xml';

  procedure enableContentMapping(P_FOLDER_PATH VARCHAR2,P_OWNER VARCHAR2,P_TABLE_NAME VARCHAR2);
  procedure handlePreCreate(P_EVENT dbms_xevent.XDBRepositoryEvent);

  C_UPLOAD_RESCONFIG constant varchar2(32000) :=
'<ResConfig xmlns="http://xmlns.oracle.com/xdb/XDBResConfig.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlns.oracle.com/xdb/XDBResConfig.xsd http://xmlns.oracle.com/xdb/XDBResConfig.xsd">
   <event-listeners set-invoker="true">
     <listener>
       <description>Map Folder Content To Table</description>
       <schema>XDBPM</schema>
       <source>XDB_MAP_FOLDER_CONTENT_11100</source>
       <language>PL/SQL</language>
       <events>
         <Pre-Create/>
       </events>
     </listener>
   </event-listeners>
   <applicationData>
     <cfg:config xmlns:cfg="http:/xmlns.oracle.com/xdb/pm/upload">
       <cfg:tableOwner>XXX</cfg:tableOwner>
       <cfg:tableName>XXX</cfg:tableName>
     </cfg:config>
   </applicationData>
</ResConfig>';

end;
/
--
show errors
--
create or replace synonym XDB_MAP_FOLDER_CONTENT for XDB_MAP_FOLDER_CONTENT_11100
/
create or replace package body XDB_MAP_FOLDER_CONTENT_11100
as    
--
procedure enableContentMapping(P_FOLDER_PATH VARCHAR2, P_OWNER VARCHAR2, P_TABLE_NAME VARCHAR2)
as
  V_RESULT         BOOLEAN;
  V_RESCONFIG      XMLType        := XMLType(C_UPLOAD_RESCONFIG);
  V_RESCONFIG_PATH VARCHAR2(1024) := P_FOLDER_PATH || '/' || C_RESCONFIG_FILENAME;
begin   

  -- Update the ResConfig skeleton with the target table

  select updateXML
         (
            V_RESCONFIG,
            '/ResConfig/applicationData/cfg:config/cfg:tableOwner/text()',
            P_OWNER,
            '/ResConfig/applicationData/cfg:config/cfg:tableName/text()',
            P_TABLE_NAME,
            'xmlns="http://xmlns.oracle.com/xdb/XDBResConfig.xsd" xmlns:cfg="http:/xmlns.oracle.com/xdb/pm/upload"'
         )
    into V_RESCONFIG
    from DUAL;
    
  if DBMS_XDB.existsResource(V_RESCONFIG_PATH) then
    DBMS_RESCONFIG.deleteResConfig(P_FOLDER_PATH,V_RESCONFIG_PATH,1);
    DBMS_XDB.deleteResource(V_RESCONFIG_PATH);
  end if;
    
  -- Create the Res Config  
  V_RESULT := DBMS_XDB.createResource(V_RESCONFIG_PATH,V_RESCONFIG);
  DBMS_XDB.CHANGEOWNER(V_RESCONFIG_PATH,P_OWNER);
  
  -- Activate the ResConfig for this folder and it's sub folders.
  DBMS_RESCONFIG.addResConfig(P_FOLDER_PATH,V_RESCONFIG_PATH);

  commit;
    
  -- xdb.xdbpm_helper.enableContentMapping(P_FOLDER_PATH,V_RESCONFIG);
 
end;
--
procedure handlePreCreate(P_EVENT dbms_xevent.XDBRepositoryEvent)
as

  V_RESOURCE         DBMS_XDBRESOURCE.xdbResource;
  V_CONTENT_TYPE     VARCHAR2(64);
  V_XMLREF           REF XMLType;
  
  V_APPLICATION_DATA XMLType;

  V_TABLE_NAME       VARCHAR2(64);

  V_OWNER            VARCHAR2(64);

  V_STATEMENT        VARCHAR2(32000);
  V_XMLREF_VARCHAR2  VARCHAR2(128);
begin
  V_RESOURCE := DBMS_XEVENT.getResource(P_EVENT);
  V_CONTENT_TYPE    := DBMS_XDBRESOURCE.getContentType(V_RESOURCE);

  if (V_CONTENT_TYPE = 'text/xml') then
 
    -- V_APPLICATION_DATA := DBMS_XEVENT.getApplicationData(P_EVENT);
    V_APPLICATION_DATA := xdb.xdbpm_helper.getApplicationData(P_EVENT);

    select OWNER, TABLE_NAME
      into V_OWNER, V_TABLE_NAME
      from xmltable
           (
             xmlnamespaces
             (
                 'http://xmlns.oracle.com/xdb/XDBResConfig.xsd' as "rc",
                 'http:/xmlns.oracle.com/xdb/pm/upload' as "cfg"
             ),
             '/rc:applicationData/cfg:config'
             passing V_APPLICATION_DATA
             columns
             OWNER               varchar2(64) path 'cfg:tableOwner',
             TABLE_NAME          varchar2(64) path 'cfg:tableName'
           );

    V_STATEMENT := 'insert into "' || V_OWNER || '"."' || V_TABLE_NAME || '" x values (:1) returning ref(x) into :2';  
    
    
    XDB_DEBUG.writeDEBUG(V_STATEMENT);
    XDB_DEBUG.writeDEBUG('ACL = ' || DBMS_XDBRESOURCE.getACL(V_RESOURCE));
    XDB_DEBUG.writeDEBUG('OWNER = ' || DBMS_XDBRESOURCE.getOwner(V_RESOURCE));
    XDB_DEBUG.writeDEBUG(V_STATEMENT);
    execute immediate V_STATEMENT using DBMS_XDBRESOURCE.getContentXML(V_RESOURCE) returning into V_XMLREF;
    select refToHex(V_XMLREF) into V_XMLREF_VARCHAR2 from dual;
    XDB_DEBUG.writeDEBUG('Content Saved. XMLREF = ' || V_XMLREF_VARCHAR2);    
    DBMS_XDBRESOURCE.setContent(V_RESOURCE,V_XMLREF,TRUE);
    -- DBMS_XDBRESOURCE.save(V_RESOURCE);
    
  end if;

end;
--  
end;
/
--
show errors
--
grant execute on XDB_MAP_FOLDER_CONTENT_11100 to public
/
alter session set current_schema = SYS
/
