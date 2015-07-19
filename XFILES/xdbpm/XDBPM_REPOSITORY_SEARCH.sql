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
-- XDBPM_REPOSITORY_SEARCH should be created under XDBPM
--
alter session set current_schema = XDBPM
/
--
set define off
--
create or replace package XDBPM_REPOSITORY_SEARCH 
authid CURRENT_USER 
as
  function getNodeMap return XMLType;
  procedure initializeNodeMap;
end;
/
--
show errors
--
create or replace synonym XDB_REPOSITORY_SEARCH for XDBPM_REPOSITORY_SEARCH
/
grant execute on XDBPM_REPOSITORY_SEARCH to public
/
create or replace package body XDBPM_REPOSITORY_SEARCH
as
--
  G_NODE_MAP XMLType;
--
function getAclPaths
return XMLType
as
  V_ACL_REF_LIST XDB.XDB$XMLTYPE_REF_LIST_T;
  V_RESULT XMLType;
begin
  select ref(a) 
    bulk collect into V_ACL_REF_LIST
    from XDB.XDB$ACL a;

  select xmlElement(
          "ACLS",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg(
             xmlElement(
               "Path",
               xmlAttributes(SYS_OP_R2O(value(ar)) as "ACLOID"),
               ANY_PATH
             ) 
           )
         )
    into V_RESULT
    from RESOURCE_VIEW rv, 
         TABLE(V_ACL_REF_LIST) ar
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   where HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)) = value(ar);
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
   where HEXTOREF(extractValue(rv.RES,'/r:Resource/r:XMLRef',DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R)) = value(ar);
$ELSE   
   where XMLCast(
             XMLQuery(
              'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
               fn:data($RES/Resource/XMLRef)'
               passing rv.RES as "RES"
               returning content
             ) as REF XMLType
           ) = value(ar);
$END   
   return V_RESULT;
         
end;
--
procedure appendDropDowns(P_NODE_MAP in out XMLType)
as
  V_RESULT                XMLType;
  
  V_CONTENT_SCHEMA_OID    VARCHAR2(64);
  V_METADATA_SCHEMA_OID   VARCHAR2(64);
  V_CONTENT_SCHEMA_ELNUM  VARCHAR2(64);
  V_METADATA_SCHEMA_ELNUM VARCHAR2(64);
  
begin
  select xmlelement(
           "Users",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg(
             xmlElement("User",username) 
           )
         ) 
    into V_RESULT
    from ALL_USERS;


  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           V_RESULT,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;

  /*
  ** 
  ** select xmlElement(
  **         "ACLS",
  **          xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
  **          xmlAgg(
  **            xmlElement(
  **              "Path",
  **              xmlAttributes(a.OBJECT_ID as "ACLOID"),
  **              ANY_PATH
  **            ) 
  **          )
  **        )
  **   into V_RESULT
  **   from RESOURCE_VIEW rv, XDB.XDB$ACL a
  **  where SYS_OP_R2O(
  **          XMLCast(
  **            XMLQuery(
  **             'declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; (: :)
  **              fn:data($RES/Resource/XMLRef)'
  **              passing rv.RES as "RES"
  **              returning content
  **            ) as REF XMLType
  **          )
  **        ) = a.OBJECT_ID      
  ** 
  */
  
  V_RESULT := getAclPaths();
     
  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           V_RESULT,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
    
  select xmlElement
         (
           "ResConfigDocuments",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           (
             select xmlAgg
                    (
                      xmlElement
                      (
                        "Path",
                        xmlAttributes(rc.OBJECT_ID as "RCID"),
                        ANY_PATH
                      ) 
                    )
               from RESOURCE_VIEW, XDB.XDB$RESCONFIG rc
              where extractValue(RES,'/Resource/XMLRef') = ref(rc)
           )
         )
    into V_RESULT
    from dual;
     
  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           V_RESULT,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
    
  select xmlElement
         (
           "MimeTypes",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg
           (
             XMLElement
             (
                "mime-type",
                xmlAttributes('http://xmlns.oracle.com/xdb/xdbconfig.xsd' as "xmlns"),
                MIME_TYPE
             ) 
           )
        )
   into V_RESULT
   from (
           select DISTINCT MIME_TYPE 
             from XMLTable
                  (
                     xmlNamespaces
                     (
                       default 'http://xmlns.oracle.com/xdb/xdbconfig.xsd'
                     ),
                     '//mime-type'
                     passing DBMS_XDB.CFG_GET
                     columns
                     MIME_TYPE varchar2(256) path '.'
                   )
             order by MIME_TYPE
        );
        
  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           V_RESULT,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
    
  select xmlElement
         (
           "Schemas",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg
           (
             xmlElement
             (
               "Schema",
               xmlAttributes(SCHEMA_ID as "SCHOID", SCHEMA_URL as "Location", axt.OWNER as "Owner", HIER_TYPE as "Type", LOCAL as "Local"),
               xmlElement
               (
                 "GlobalElementList",
                 xmlAgg
                 (
                   xmlElement
                   (
                     "GlobalElement",
                     xmlAttributes(PROPERTY_NUMBER as "ElNum", DEFAULT_TABLE as "defaultTable", DEFAULT_TABLE_SCHEMA as "defaultTableSchema"),
                     NAME
                   )
                 )
               )
             )
           )
         )
    into V_RESULT
    from ALL_XML_SCHEMAS, 
         All_XML_TABLES axt, 
         XMLTable
         (
           xmlNamespaces
          (
            default 'http://www.w3.org/2001/XMLSchema',
            'http://xmlns.oracle.com/xdb'      as "xdb" ,
            'http://xmlns.oracle.com/2004/CSX' as "csx"             
          ),
          '/schema/element[@xdb:defaultTable and string-length(@xdb:defaultTable)>0]'
          passing SCHEMA
          columns
          NAME                 varchar2(256) path '@name',
          DEFAULT_TABLE        varchar2(32)  path '@xdb:defaultTable',
          DEFAULT_TABLE_SCHEMA varchar2(32)  path '@xdb:defaultTableSchema',
          PROPERTY_NUMBER        number(38)  path '@xdb:propNumber | @csx:propertyID'
        ) t
  where t.DEFAULT_TABLE = axt.TABLE_NAME
    and t.DEFAULT_TABLE_SCHEMA = axt.OWNER 
  group by HIER_TYPE, axt.OWNER, LOCAL, SCHEMA_URL, SCHEMA_ID  
  order by HIER_TYPE, axt.OWNER, LOCAL, SCHEMA_URL;
        
  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           V_RESULT,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
     
  select appendChildXML
         (
           P_NODE_MAP,
           '/NodeMap',
           xmlElement
           (
             "ExtraData",
             xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
             xmlElement
             (
               "Element",
               xmlAttributes('FullTextSearch' as "ID",'false' as "isSelected",'hidden' as "valueVisible",'' as "value")
             ),
             xmlElement
             (
               
               "Element",
               xmlAttributes('FolderRestriction' as "ID",'false' as "isSelected",'hidden' as "valueVisible",'REPOSITORY' as "value")
             ),
             xmlElement
             (
               
               "Element",
               xmlAttributes('MetadataSchema' as "ID",'false' as "isSelected",'hidden' as "valueVisible",' ' as "value", ' ' as "childValue")
             )
         	 ),
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
        
end;
--
procedure setDefaults(P_NODE_MAP in out XMLType)
as
  V_DEFAULT_ACL       RAW(16);
  V_DEFAULT_RESCONFIG RAW(16);
  V_CONTENT_SCHOID    RAW(16);
  V_CONTENT_ELNAME    VARCHAR2(256);
  V_METADATA_SCHOID   RAW(16);
  V_METADATA_ELNAME   VARCHAR2(256);
begin

  -- Default ACL is the Bootstrap ACL
  
  begin
    select OBJECT_ID
      into V_DEFAULT_ACL
      from XDB.XDB$ACL a, RESOURCE_VIEW
     where ref(a) = extractValue(RES,'/Resource/XMLRef')
       and equals_path(RES,'/sys/acls/bootstrap_acl.xml') = 1;
  exception
    when no_data_found then
      null;
    when others then
      raise;
  end;

   -- Default Content Schema and Element is the first CONTENTS schema in the Schema List

  begin
    select SCHOID, ELNAME
     into V_CONTENT_SCHOID, V_CONTENT_ELNAME
     from XMLTable
          (
             xmlNamespaces
             (
               default 'http://xmlns.oracle.com/xdb/pm/demo/search' 
             ),
             '/NodeMap/Schemas/Schema[@Type="CONTENTS"][1]'
             passing P_NODE_MAP
             COLUMNS
             SCHOID        RAW(16) path '@SCHOID',
             ELNAME  VARCHAR2(256) path 'GlobalElementList/GlobalElement[1]'
          );
  exception
    when no_data_found then
      null;
    when others then
      raise;
  end;

   -- Default Metadata Schema and Element is the first RESMETADATA schema in the Schema List
                       
  begin
    select SCHOID, ELNAME
      into V_METADATA_SCHOID, V_METADATA_ELNAME
      from XMLTable
           (
              xmlNamespaces
              (
                default 'http://xmlns.oracle.com/xdb/pm/demo/search' 
              ),
              '/NodeMap/Schemas/Schema[@Type="RESMETADATA"][1]'
              passing P_NODE_MAP
              COLUMNS
              SCHOID       RAW(16) path '@SCHOID',
              ELNAME VARCHAR2(256) path 'GlobalElementList/GlobalElement[1]'
           );             
  exception
    when no_data_found then
      null;
    when others then
      raise;
  end;

  -- Default RESCONFIG is the first RESCONFIG document in the NodeMap.

  begin
    select RCID
      into V_DEFAULT_RESCONFIG
      from XMLTable
           (
              xmlNamespaces
              (
                default 'http://xmlns.oracle.com/xdb/pm/demo/search' 
              ),
              '/NodeMap/ResConfigDocuments/Path[1]'
              passing P_NODE_MAP
              COLUMNS
              RCID   RAW(16) path '@RCID'
          );             
  exception
    when no_data_found then
      null;
    when others then
      raise;
    end;

  select updateXML
         (
           P_NODE_MAP,
           '/NodeMap//Element[@value="%USER%"]/@value',
           USER,
           '/NodeMap/Element/Elements/Element[substring-after(Name,'':'')="ACLOID"]/@value',
           V_DEFAULT_ACL,
           '/NodeMap/Element/Elements/Element[substring-after(Name,'':'')="SchOID"]/@value',
           V_CONTENT_SCHOID,
           '/NodeMap/Element/Elements/Element[substring-after(Name,'':'')="SchOID"]/@childValue',
           V_CONTENT_ELNAME,
           '/NodeMap/ExtraData/Element[@ID="MetadataSchema"]/@value',
           V_METADATA_SCHOID,
           '/NodeMap/ExtraData/Element[@ID="MetadataSchema"]/@childValue',
           V_METADATA_ELNAME,
           '/NodeMap/Element/Elements/Element[substring-after(Name,'':'')="RCList"]/Elements/Element[substring-after(Name,'':'')="RCList"]/@value',
           V_DEFAULT_RESCONFIG,
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
         )
    into P_NODE_MAP
    from dual;
  
end;
--
function getNodeMap return XMLType
as
  V_NODE_MAP XMLType;
begin
  V_NODE_MAP := G_NODE_MAP;
  appendDropDowns(V_NODE_MAP);
  setDefaults(V_NODE_MAP);
  return V_NODE_MAP;
end;
--
function generateNodeMap
return XMLType
as
  V_NODE_MAP XMLType;
  V_EXPANDED_NODE XMLType;
  V_GLOBAL_ELEMENT_ID number;
  
  cursor getUnknownElements(C_NODE_MAP XMLType)
  is
  select ID
    from XMLTable
         (
           xmlNamespaces
           (
             default 'http://xmlns.oracle.com/xdb/pm/demo/search' 
           ),
           '//Element[not(Name)]'
           passing C_NODE_MAP
           columns
           ID number(38) path '@ID'
        );
begin
  V_NODE_MAP := XDB_XMLSCHEMA_SEARCH.getRootNodeMap(XDB_NAMESPACES.RESOURCE_LOCATION,'XDB','Resource');

  select insertChildXML
         (
           V_NODE_MAP,
           '/NodeMap/Element',
           '@pathSearch',
           'true',
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
           ) 
    into V_NODE_MAP
    from dual;

  select insertChildXML
         (
           V_NODE_MAP,
           '/NodeMap/Element',
           '@folderRestriction',
           'REPOSITORY',
           'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
           ) 
    into V_NODE_MAP
    from dual;

  while (V_NODE_MAP.existsNode('//Element[not(Name)]','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"') = 1) loop
    for e in getUnknownElements(V_NODE_MAP) loop
      V_EXPANDED_NODE := XDB_XMLSCHEMA_SEARCH.getChildNodeMap(e.ID);
      select updateXML
             (
               V_NODE_MAP, 
               '//Element[@ID="' || e.ID || '"]',
               V_EXPANDED_NODE,
               'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
             ) 
        into V_NODE_MAP
        from DUAL;
    end loop;
  end loop;
  return V_NODE_MAP;
end;
--
procedure initializeNodeMap 
as  
begin
  G_NODE_MAP := xdburitype('/publishedContent/XDBPM/lib/XDBResource.xml').getXML();
end;
--
begin
  initializeNodeMap();
end;
/
show errors
--
set define on
--

