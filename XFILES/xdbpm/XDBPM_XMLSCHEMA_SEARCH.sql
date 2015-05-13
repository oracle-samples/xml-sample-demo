
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
-- XDBPM_XMLSCHEMA_SEARCH should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_XMLSCHEMA_SEARCH
authid CURRENT_USER 
as
  C_XDBPM_SCHEMAURL_XMLSCHEMA   CONSTANT VARCHAR2(1024) := 'http://xmlns.oracle.com/xdb/xdbpm/XDBSchema.xsd';
  C_XDBPM_SCHEMAURL_XDBRESOURCE CONSTANT VARCHAR2(1024) := 'http://xmlns.oracle.com/xdb/xdbpm/XDBResource.xsd';
  C_XDBPM_XMLSCHEMA_NAMESPACE   CONSTANT VARCHAR2(1024) := 'http://xmlns.oracle.com/xdb/xdbpm/XMLSchema';
  C_XMLSCHEMA_TNS_PREFIX        CONSTANT VARCHAR2(2)    := 'xs'; 
   
  function getRootNodeMap(P_SCHEMA_URL varchar2, P_SCHEMA_OWNER varchar2 default USER, P_GLOBAL_ELEMENT varchar2) return XMLType;
  function getChildNodeMap(P_PROPERTY_NUMBER number) return xmlType;
  function getSubstitutionGroup(P_HEAD_ELEMENT NUMBER)  return XMLType;

  function getGlobalPrefixForNamespace(V_NAMESPACE VARCHAR2) return VARCHAR2;
  function getGlobalAttributeType(P_GLOBAL_ATTRIBUTE_NAME VARCHAR2, P_GLOBAL_ATTRIBUTE_REFERENCE REF XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) return VARCHAR2;
  function getNodeTypeMapping(P_NODE_TYPE VARCHAR2, P_BASE_TYPE VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) return VARCHAR2;
  function getNodeNameMapping(P_NODE_NAME VARCHAR2, P_NODE_FORM VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) return VARCHAR2;
  function getNodeRefMapping(P_NODE_REF VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) return VARCHAR2;
  function getSchemaBaseType(P_TYPE_NAME VARCHAR2, P_TYPE_REFERENCE REF XMLType, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) return VARCHAR2;
  function mapGlobalPrefix(P_QNAME VARCHAR2, P_LOCAL_MAPPINGS XMLType) return VARCHAR2;

  function getXMLSchemaLocation return VARCHAR2;
end;
/
show errors
--
create or replace synonym XDB_XMLSCHEMA_SEARCH for XDBPM_XMLSCHEMA_SEARCH
/
grant execute on XDBPM_XMLSCHEMA_SEARCH to public
/
create or replace package body XDBPM_XMLSCHEMA_SEARCH
as
--
  G_NS_PREFIX_MAPPINGS             XMLType;

  G_SCHEMA_FOR_SCHEMAS             XMLType;
  G_XMLSCHEMA_NS_PREFIX_MAPPINGS   XMLType;
  G_XMLSCHEMA_DEFAULT_PREFIX       VARCHAR2(32);
  G_XMLSCHEMA_TARGET_PREFIX        VARCHAR2(32);
    
--
function getXMLSchemaLocation
return VARCHAR2
as
begin
	return C_XDBPM_SCHEMAURL_XMLSCHEMA;
end;
--
function mapGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2, P_GLOBAL_ELEMENT_REF REF XMLType, P_ELEMENT_ID number, P_ELEMENT_NAME VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return XMLType;
--
function mapComplexType(P_TYPE_NAME VARCHAR2, P_COMPLEX_TYPE XMLType, P_TYPE_REFERENCE REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID NUMBER, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return xmlType;
--
function refToHex(P_REFERENCE REF XMLType) 
return VARCHAR2
as
  V_REFERENCE VARCHAR2(256);
begin
  select REFTOHEX(P_REFERENCE)
    into V_REFERENCE
    from dual;
  return V_REFERENCE;
end;
--
function getSchemaNamespaceMappings(P_XML_SCHEMA XMLType) 
return XMLType
--
--  Get the set of namespace prefix definitions declarations from the root tag of the XML schema
--
as
  V_DOC               dbms_xmldom.DOMDocument;
  V_ROOT              dbms_xmldom.DOMElement;
  V_NODEMAP           dbms_xmldom.DOMNamedNodeMap;
  V_ATTR              dbms_xmldom.DOMAttr;
  V_PREFIX            varchar2(512);
  V_SCHEMA_NAMESPACES XMLType;
  V_NAMESPACE         XMLType;
begin
  
  V_DOC     := dbms_xmldom.newDomDocument(P_XML_SCHEMA);
  V_ROOT    := dbms_xmldom.getDocumentElement(V_DOC);
  V_NODEMAP := dbms_xmldom.getAttributes(dbms_xmldom.MakeNode(V_ROOT));

  V_SCHEMA_NAMESPACES := xmltype('<Namespaces/>');
  
  for i in 0..dbms_xmldom.getLength(V_NODEMAP) - 1 loop
    V_ATTR := dbms_xmldom.MakeAttr(dbms_xmldom.Item(V_NODEMAP,i));
    if (dbms_xmldom.getNamespace(V_ATTR) = 'http://www.w3.org/2000/xmlns/') or dbms_xmldom.getName(V_ATTR) = 'xmlns' then 
       if (dbms_xmldom.getLocalName(V_ATTR) = 'xmlns') then
         V_NAMESPACE := xmltype('<Namespace>' || dbms_xmldom.getValue(V_ATTR) || '</Namespace>');
       else
         V_NAMESPACE := xmltype('<Namespace Prefix="' || dbms_xmldom.getLocalName(V_ATTR) || '">' || dbms_xmldom.getValue(V_ATTR) || '</Namespace>');
       end if;
       select appendChildXML
              (
                V_SCHEMA_NAMESPACES,
                '/Namespaces',
                V_NAMESPACE                
              )
         into V_SCHEMA_NAMESPACES
         from dual;
    end if; 
  end loop;
  return  V_SCHEMA_NAMESPACES;
end;
--
function getNamespaceForPrefix(P_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return VARCHAR2
as 
  V_NAMESPACE VARCHAR2(700);
begin
  if (P_PREFIX is not null) then
    select NAMESPACE
      into V_NAMESPACE
      from xmltable
           ( 
       	     '/Namespaces/Namespace[@Prefix=$p]'
       	     passing P_NS_PREFIX_MAPPINGS, P_PREFIX as "p"
             columns
       	     NAMESPACE VARCHAR2(700) path 'text()'
       	   );
  else
    begin
      select NAMESPACE
        into V_NAMESPACE
        from xmltable
             ( 
       	       '/Namespaces/Namespace[not(@Prefix)]'
       	       passing P_NS_PREFIX_MAPPINGS
               columns
       	       NAMESPACE VARCHAR2(700) path 'text()'
       	     );
     exception
       when no_data_found then
         return null;
       when others then
         raise;
     end;
  end if;
  return V_NAMESPACE;
end;
--
function getPrefixForNamespace(P_NAMESPACE VARCHAR2, P_NAMESPACE_PREFIX_MAPPINGS XMLType)
return VARCHAR2
as 
  V_PREFIX VARCHAR2(32);
begin
	

	if (P_NAMESPACE is NULL) then
	  V_PREFIX := NULL;
	else	
	  if (P_NAMESPACE = C_XDBPM_XMLSCHEMA_NAMESPACE) then
	    V_PREFIX := C_XMLSCHEMA_TNS_PREFIX;
	  else
      select PREFIX
        into V_PREFIX
        from xmltable
           	 (
           	   '/Namespaces/Namespace[text()=$ns]'
         	     passing P_NAMESPACE_PREFIX_MAPPINGS, P_NAMESPACE as "ns"
         	     columns
         	     PREFIX VARCHAR2(32) path '@Prefix'
         	   );
      end if;
    end if;

    XDB_OUTPUT.writeLogFileEntry('getPrefixForNamespace() Namespace "' || P_NAMESPACE || '". Prefix "' || V_PREFIX || '"');

    return V_PREFIX;
  end;
--
function mapGlobalPrefix(P_QNAME VARCHAR2, P_LOCAL_MAPPINGS XMLType)
return VARCHAR2
--
--  Convert from the Namespace prefix used in the XML Schema to the Global Namespace Prefix.
--
as
  V_PREFIX     VARCHAR2(32);
  V_LOCAL_NAME VARCHAR2(256);
  V_NAMESPACE  VARCHAR2(700);
begin   
   V_PREFIX     := substr(P_QNAME,1,instr(P_QNAME,':')-1);
   V_LOCAL_NAME := substr(P_QNAME,instr(P_QNAME,':')+1);
   V_NAMESPACE  := getNamespaceForPrefix(V_PREFIX,P_LOCAL_MAPPINGS);
   if (V_NAMESPACE = C_XDBPM_XMLSCHEMA_NAMESPACE) then
     V_PREFIX := C_XMLSCHEMA_TNS_PREFIX;
   else
     V_PREFIX     := getPrefixForNamespace(V_NAMESPACE,G_NS_PREFIX_MAPPINGS);
   end if;
   return V_PREFIX || ':' || V_LOCAL_NAME;
end;
--
function getGlobalPrefixForNamespace(V_NAMESPACE VARCHAR2)
return VARCHAR2
--
--  Get the Global Namespace Prefix for a given Namespace
--
as
begin
  return getPrefixForNamespace(V_NAMESPACE,G_NS_PREFIX_MAPPINGS);
end;
--
function getGlobalPrefixForDefaultNS(P_LOCAL_PREFIX_MAPPINGS XMLType)
return VARCHAR2
--
--  Get the Global Namespace Prefix for the XML Schema's Default Namespace.
--
as
begin
  return getGlobalPrefixForNamespace(getNamespaceForPrefix(NULL,P_LOCAL_PREFIX_MAPPINGS));
end;
--  
function getGlobalPrefixForTargetNS(P_XML_SCHEMA XMLTYPE)
return VARCHAR2
--
-- get the Global Prefix for the target namesapce
--
as
  V_NAMESPACE     VARCHAR2(256);
  V_SCHEMA_PREFIX VARCHAR2(32) := NULL;
begin
  select TARGET_NAMESPACE 
    into V_NAMESPACE
    from xmltable
         ( 
            xmlNamespaces 
            (
              'http://xmlns.oracle.com/xdb'      as "xdb"
            ),
       	    '$s/xs:schema'
       	    passing P_XML_SCHEMA as "s"
       	    columns
       	    TARGET_NAMESPACE varchar2(256) path '@targetNamespace'
       	 );
  
  if (V_NAMESPACE is not null) then
    V_SCHEMA_PREFIX := getGlobalPrefixForNamespace(V_NAMESPACE);
  end if;

  XDB_OUTPUT.writeLogFileEntry('getGlobalPrefixForTargetNS() Namespace "' || V_NAMESPACE || '". Prefix "' || V_SCHEMA_PREFIX || '"');
  return V_SCHEMA_PREFIX;
end;
--
function getNodeTypeMapping(P_NODE_TYPE VARCHAR2, P_BASE_TYPE VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return VARCHAR2
as 
  V_NODE_TYPE VARCHAR2(256);
begin
  if ((P_NODE_TYPE is null) and (P_BASE_TYPE is null)) then
    return null;
  end if;
  
  if (P_NODE_TYPE is not null) then
    V_NODE_TYPE := P_NODE_TYPE;
  else
    V_NODE_TYPE := P_BASE_TYPE;
  end if;
    
  if instr(V_NODE_TYPE,':') = 0 then 
    if P_DEFAULT_PREFIX is not null then
      return P_DEFAULT_PREFIX || ':' || V_NODE_TYPE;
    else 
      return V_NODE_TYPE;
    end if;
  else 
    return mapGlobalPrefix(V_NODE_TYPE,P_NS_PREFIX_MAPPINGS);
  end if;

end;
--
function getNodeNameMapping(P_NODE_NAME VARCHAR2, P_NODE_FORM VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return VARCHAR2
as 
begin
  if (P_NODE_NAME is null) then
    return null;
  end if;
  
  if (P_NODE_FORM = 'qualified') then
    if (P_TARGET_PREFIX is not null) then
      return P_TARGET_PREFIX || ':' || P_NODE_NAME;
    else 
      return P_NODE_NAME;
    end if;
  else
    return P_NODE_NAME;
  end if;
end;
--
function getNodeRefMapping(P_NODE_REF VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return VARCHAR2
as 
begin
  if (P_NODE_REF is null) then
    return null;
  end if;

  if instr(P_NODE_REF,':') = 0 then
    if (P_DEFAULT_PREFIX is not null) then
      return P_DEFAULT_PREFIX || ':' || P_NODE_REF;
    else 
      return P_NODE_REF;
    end if;
  else 
    return mapGlobalPrefix(P_NODE_REF,P_NS_PREFIX_MAPPINGS);
  end if;
end;
--
function getBaseTypeName(P_XML_SCHEMA XMLType, P_TYPE_NAME VARCHAR2, P_TYPE_NAMESPACE VARCHAR2)
return VARCHAR2 
as
  V_BASE_TYPE_NAME VARCHAR2(256);
begin
  if  (P_TYPE_NAMESPACE is not null) then
    select XMLCast(XMLQuery('/xs:schema/xs:simpleType[@name=$st]//@base' passing P_XML_SCHEMA,  P_TYPE_NAME as "st" returning content) as VARCHAR2(256))
      into V_BASE_TYPE_NAME 
      from DUAL
     where XMLExists('declare namespace xdb = "http://xmlns.oracle.com/xdb"; /xs:schema[@targetNamespace=$tn]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAMESPACE as "tn", P_TYPE_NAME as "st" );
   else
     select XMLCast(XMLQuery('/xs:schema/xs:simpleType[@name=$st]//@base' passing P_XML_SCHEMA,  P_TYPE_NAME as "st" returning content) as VARCHAR2(256))
      into V_BASE_TYPE_NAME 
      from DUAL
    where XMLExists('declare namespace xdb = "http://xmlns.oracle.com/xdb"; /xs:schema[not(@targetNamespace)]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAME as "st" );
  end if;
  return V_BASE_TYPE_NAME;
end;  
--
function getSchemaBaseType(P_TYPE_NAME VARCHAR2, P_TYPE_REFERENCE REF XMLType, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return VARCHAR2
as
  V_TYPE_PREFIX      VARCHAR2(32);
  V_TYPE_NAMESPACE   VARCHAR2(700);
  V_GLOBAL_TYPE_NAME VARCHAR2(256);
  
  V_XML_SCHEMA                XMLType;
  V_BASE_TYPE_NAME            VARCHAR2(256);
  V_NS_PREFIX_MAPPINGS XMLType;
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_TARGET_PREFIX             VARCHAR2(32);
  V_EXPANDED_MAPPING          XMLType;
  
  V_TYPE_REFERENCE            REF XMLType;
begin


  if (instr(P_TYPE_NAME,':') > 0) then
    V_TYPE_PREFIX := substr(P_TYPE_NAME,1,instr(P_TYPE_NAME,':')-1);
    V_GLOBAL_TYPE_NAME := substr(P_TYPE_NAME,instr(P_TYPE_NAME,':')+1);
  else
    V_TYPE_PREFIX := null;
    V_GLOBAL_TYPE_NAME := P_TYPE_NAME;
  end if;
    
  -- Hack for pre-allocation of global namespace prefixes. If the prefix doesn't match the known prefixes for the XML Schema 
  -- match the prefix in the global list of targetNamespaces
  
  begin
    V_TYPE_NAMESPACE := getNamespaceForPrefix(V_TYPE_PREFIX,P_NS_PREFIX_MAPPINGS);
  exception
    when no_data_found then
      V_TYPE_NAMESPACE := getNamespaceForPrefix(V_TYPE_PREFIX,G_NS_PREFIX_MAPPINGS);
  end;  
  
  XDB_OUTPUT.writeLogFileEntry('SimpleType = ' || P_TYPE_NAME || '. Namespace = ' || V_TYPE_NAMESPACE);

  if (V_TYPE_NAMESPACE = XDB_NAMESPACES.XMLSCHEMA_NAMESPACE) then
    return C_XMLSCHEMA_TNS_PREFIX || ':' || V_GLOBAL_TYPE_NAME;
  else
  
    -- Find the Base Type for this type
      
    V_XML_SCHEMA      := P_XML_SCHEMA;
    V_BASE_TYPE_NAME  := NULL;

    select s.OBJECT_VALUE, 
           XMLCast(XMLQuery('/xs:schema/xs:simpleType[@name=$st]//@base' passing s.OBJECT_VALUE, V_GLOBAL_TYPE_NAME as "st" returning content) as VARCHAR2(256)),
           ref(st)
      into V_XML_SCHEMA, V_BASE_TYPE_NAME, V_TYPE_REFERENCE
      from XDB.XDB$SCHEMA s, XDB.XDB$SIMPLE_TYPE st
     where ref(st) = P_TYPE_REFERENCE 
       and st.XMLDATA.PARENT_SCHEMA = ref(s)
       and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.XDBSCHEMA_LOCATION
       and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.RESOURCE_LOCATION;
     
    V_XML_SCHEMA         := V_XML_SCHEMA.createNonSchemaBasedXML();
    V_TYPE_REFERENCE     := P_TYPE_REFERENCE;
    V_NS_PREFIX_MAPPINGS := getSchemaNamespaceMappings(V_XML_SCHEMA);
    V_DEFAULT_PREFIX     := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
    V_TARGET_PREFIX      := getGlobalPrefixForTargetNS(V_XML_SCHEMA);
  
    if (instr(V_BASE_TYPE_NAME,':') = 0) then
      V_BASE_TYPE_NAME := mapGlobalPrefix(V_BASE_TYPE_NAME,P_NS_PREFIX_MAPPINGS);
    end if;
    
    return getSchemaBaseType(V_BASE_TYPE_NAME, V_TYPE_REFERENCE, V_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
  end if;
end;
--
function mapSimpleType(P_TYPE_NAME VARCHAR2, P_SIMPLE_TYPE XMLType, P_SIMPLE_TYPE_REF REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID number, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return XMLType
as
  V_MAPPING        XMLType;
  V_BASE_TYPE      VARCHAR2(256);
begin

  XDB_OUTPUT.writeLogFileEntry('Processing simpleType ' || P_TYPE_NAME);
  
  V_BASE_TYPE := getSchemaBaseType(P_TYPE_NAME, P_SIMPLE_TYPE_REF, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);

  select XMLElement
         (
           "Element",
           xmlAttributes
           (
             P_ELEMENT_ID as "ID",
             P_TYPE_NAME  as "Type",
             V_BASE_TYPE as "BaseType",
             'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"
           ),
           xmlElement
           ( 
             "Name",
             P_ELEMENT_NAME
           )
         )           
    into V_MAPPING
    from dual;        

  return V_MAPPING;
end;
--
function convertQName(P_QNAME VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return VARCHAR2
as
begin
  if instr(P_QNAME,':') > 0 then
    return mapGlobalPrefix(P_QNAME, P_NS_PREFIX_MAPPINGS);
  else
    if (P_DEFAULT_PREFIX is not NULL) then
      return P_DEFAULT_PREFIX  || ':' || P_QNAME;     
    else
      return P_QNAME;
    end if;
  end if;
end;
--
function getGlobalAttribute(P_GLOBAL_ATTRIBUTE_NAME VARCHAR2, P_XMLSCHEMA_REFERENCE REF XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return XMLType
as
  V_GLOBAL_ATTRIBUTE XMLType;
  V_PREFIX           VARCHAR2(32);
  V_LOCAL_NAME       VARCHAR2(256);
  V_TARGET_NAMESPACE VARCHAR2(700);
begin
  V_PREFIX            := substr(P_GLOBAL_ATTRIBUTE_NAME,1,instr(P_GLOBAL_ATTRIBUTE_NAME,':')-1);
  V_LOCAL_NAME        := substr(P_GLOBAL_ATTRIBUTE_NAME,instr(P_GLOBAL_ATTRIBUTE_NAME,':')+1);
  V_TARGET_NAMESPACE  := getNamespaceForPrefix(V_PREFIX,G_NS_PREFIX_MAPPINGS);

   return V_GLOBAL_ATTRIBUTE;
end;
--
function getGlobalAttributeType(P_GLOBAL_ATTRIBUTE_NAME VARCHAR2, P_GLOBAL_ATTRIBUTE_REFERENCE REF XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return VARCHAR2
as
  V_XML_SCHEMA                XMLType;
  V_GLOBAL_ATTRIBUTE          XMLType;
  V_ATTRIBUTE_TYPE            VARCHAR2(256);
  V_LOCAL_NAME                VARCHAR2(256);
  V_NS_PREFIX_MAPPINGS XMLType;
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_TARGET_PREFIX             VARCHAR2(32);
  V_TYPE_REFERENCE            REF XMLType;
begin
  V_LOCAL_NAME        := substr(P_GLOBAL_ATTRIBUTE_NAME,instr(P_GLOBAL_ATTRIBUTE_NAME,':')+1);

  select s.OBJECT_VALUE,
         XMLCast(XMLQuery('/xs:schema/xs:attribute[@name=$an]/@type' passing s.OBJECT_VALUE, V_LOCAL_NAME as "an" returning content) as VARCHAR2(256)),
         a.XMLDATA.TYPE_REF
    into V_XML_SCHEMA, V_ATTRIBUTE_TYPE, V_TYPE_REFERENCE
    from XDB.XDB$SCHEMA s, XDB.XDB$ATTRIBUTE a
   where ref(s) = a.XMLDATA.PARENT_SCHEMA
     and ref(a) = P_GLOBAL_ATTRIBUTE_REFERENCE;

  V_XML_SCHEMA := V_XML_SCHEMA.createNonSchemaBasedXML();
  
  V_NS_PREFIX_MAPPINGS := getSchemaNamespaceMappings(V_XML_SCHEMA);
  V_DEFAULT_PREFIX     := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
  V_TARGET_PREFIX      := getGlobalPrefixForTargetNS(V_XML_SCHEMA);
  
  if (V_ATTRIBUTE_TYPE is not NULL) then
    V_ATTRIBUTE_TYPE := convertQName(V_ATTRIBUTE_TYPE, V_DEFAULT_PREFIX, V_NS_PREFIX_MAPPINGS);
    V_ATTRIBUTE_TYPE := getSchemaBaseType(V_ATTRIBUTE_TYPE, V_TYPE_REFERENCE, V_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
    return V_ATTRIBUTE_TYPE;
  end if;
  
end;
--
function mapSimpleContent(P_TYPE_NAME VARCHAR2, P_COMPLEX_TYPE XMLType, P_TYPE_REFERENCE REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID NUMBER, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return xmlType
as 
  V_MAPPING                XMLType;
  V_BASE_TYPE              VARCHAR2(256);
  V_ATTRIBUTES             XMLType;
  V_COMPLEX_TYPE           XMLType;
  V_ATTRIBUTE_FORM_DEFAULT VARCHAR2(12);
begin

  select XMLCast(XMLQuery('/xs:complexType/xs:simpleContent/xs:extension/@base' passing V_COMPLEX_TYPE returning content ) as VARCHAR2(256)) as "BaseType"
    into V_BASE_TYPE
    from dual;
 
  V_BASE_TYPE := getSchemaBaseType(V_BASE_TYPE, P_TYPE_REFERENCE, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);
  
  -- Need to add handling for flattening AttributeGroups
  
  select XMLCast(XMLQuery('/xs:schema/@attributeFormDefault' passing P_XML_SCHEMA returning content) as VARCHAR2(12)) 
    into V_ATTRIBUTE_FORM_DEFAULT
    from dual;
    
  if (V_ATTRIBUTE_FORM_DEFAULT is null) then
    V_ATTRIBUTE_FORM_DEFAULT := 'unqualified';
  end if;
  
  select xmlElement
         (
           "Attrs",
           xmlAgg
           (
             xmlelement
             (
               "Attr",
               xmlAttributes
               (
                 ID as "ID",
                 ATTR_REF as "Ref",
                 ATTR_TYPE as "Type",
                 XDBPM.XDBPM_XMLSCHEMA_SEARCH.getSchemaBaseType(ATTR_TYPE, P_TYPE_REFERENCE, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS) as "BaseType"
               ),
               case when ATTR_NAME is not null then
                 ATTR_NAME
               else
                 ATTR_REF
               end
             )
           )
         )      
    into V_ATTRIBUTES
    from (    
           select ID,
                  case when ATTR_REF is not NULL then
                    XDBPM.XDBPM_XMLSCHEMA_SEARCH.getGlobalAttributeType(ATTR_REF, a.XMLDATA.PROPREF_REF, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS)
                  else
                    XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeTypeMapping(ATTR_TYPE, ATTR_BASE_TYPE, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) 
                  end ATTR_TYPE,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeNameMapping(ATTR_NAME, V_ATTRIBUTE_FORM_DEFAULT, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS) ATTR_NAME,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeRefMapping(ATTR_REF, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) ATTR_REF
             from XDB.XDB$ATTRIBUTE a,
                  XMLTABLE
                  (
                    xmlNamespaces('http://xmlns.oracle.com/xdb' as "xdb"),
                    '/xs:complexType/xs:simpleContent/xs:extension/xs:attribute'
                    passing V_COMPLEX_TYPE
                    columns
                    ID             number(38)    path '@xdb:propNumber',
                    ATTR_TYPE      varchar2(256) path '@type',
                    ATTR_BASE_TYPE varchar2(256) path '//@base',
                    ATTR_NAME      varchar2(256) path '@name',
                    ATTR_REF       varchar2(256) path '@ref'
                 )        
           where a.XMLDATA.PROP_NUMBER = ID        
         );    
         
  select XMLElement
         (
           "Element",
           xmlAttributes
           (
             P_ELEMENT_ID as "ID",
             P_TYPE_NAME  as "Type",
             V_BASE_TYPE  as "BaseType",
             'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"
           ),            
           xmlElement
           ( 
             "Name",
             P_ELEMENT_NAME
           ),
           V_ATTRIBUTES
         )
    into V_MAPPING
    from dual;        

  return V_MAPPING;
end;
--
function mapExtendedComplexType(P_MAPPING XMLType, P_TYPE_NAME VARCHAR2, P_COMPLEX_TYPE XMLType, P_TYPE_REFERENCE REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID NUMBER, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return XMLType
as
  V_BASE_TYPE_NAME            VARCHAR2(256);
  V_BASE_TYPE_REFERENCE       REF XMLType;
  V_BASE_TYPE                 XMLType;
  
  V_XML_SCHEMA                XMLType;
  V_GLOBAL_TYPE               XMLType;
  V_NS_PREFIX_MAPPINGS XMLType;
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_TARGET_PREFIX             VARCHAR2(32);
  V_ATTRIBUTE_FORM_DEFAULT    VARCHAR2(12);
  V_ELEMENT_FORM_DEFAULT      VARCHAR2(12);


  V_SUBTYPE_MAPPING           XMLType;
  V_ATTRIBUTES                XMLType;
  V_ELEMENTS                  XMLType;

begin

  select XMLCast(XMLQuery('/xs:complexType/xs:complexContent/xs:extension/@base' passing P_COMPLEX_TYPE returning content) as VARCHAR2(256))
    into V_BASE_TYPE_NAME
    from DUAL;

  XDB_OUTPUT.writeLogFileEntry('mapExtendedComplexType() : "'|| P_TYPE_NAME || '" extends "' || V_BASE_TYPE_NAME || '"');
  XDB_OUTPUT.flushLogFile();
    
  if (instr(V_BASE_TYPE_NAME,':') > 0) then
    V_BASE_TYPE_NAME := substr(V_BASE_TYPE_NAME,instr(V_BASE_TYPE_NAME,':')+1);
  end if;
   
  /*
  **
  ** Get the XML Schema and the ComplexType definition for the Base Type.. 
  ** (May not be the same XMLSchema as the Extended Type)
  **
  */ 
  XDB_OUTPUT.writeLogFileEntry('mapExtendedComplexType() : Base Type Name = "'|| V_BASE_TYPE_NAME || '"');
  XDB_OUTPUT.writeLogFileEntry('mapExtendedComplexType() : Type Reference = "'|| refToHex(P_TYPE_REFERENCE) || '"');
  XDB_OUTPUT.flushLogFile();
   
  select s.OBJECT_VALUE,
         XMLQuery('/xs:schema/xs:complexType[@name=$ct]' passing s.OBJECT_VALUE, V_BASE_TYPE_NAME as "ct" returning CONTENT),
         ct.XMLDATA.BASE_TYPE 
    into V_XML_SCHEMA, V_BASE_TYPE, V_BASE_TYPE_REFERENCE
    from XDB.XDB$SCHEMA s, XDB.XDB$COMPLEX_TYPE bt, XDB.XDB$COMPLEX_TYPE ct
   where ref(s) = bt.XMLDATA.PARENT_SCHEMA
     and ref(bt) = ct.XMLDATA.BASE_TYPE
     and ref(ct) = P_TYPE_REFERENCE;

  V_XML_SCHEMA                 := V_XML_SCHEMA.createNonSchemaBasedXML();
  V_NS_PREFIX_MAPPINGS         := getSchemaNamespaceMappings(V_XML_SCHEMA);
  V_DEFAULT_PREFIX             := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
  V_TARGET_PREFIX              := getGlobalPrefixForTargetNS(V_XML_SCHEMA);

  V_SUBTYPE_MAPPING := mapComplexType(V_BASE_TYPE_NAME, V_BASE_TYPE, V_BASE_TYPE_REFERENCE, P_ELEMENT_NAME, P_ELEMENT_ID, V_XML_SCHEMA, V_DEFAULT_PREFIX , V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS); 

  XDB_OUTPUT.writeLogFileEntry('SubTypeMapping := ');
  XDB_OUTPUT.writeLogFileEntry(V_SUBTYPE_MAPPING);
  XDB_OUTPUT.flushLogFile();

  select XMLCast(XMLQuery('/xs:schema/@attributeFormDefault' passing P_XML_SCHEMA returning content) as VARCHAR2(12)), 
         XMLCast(XMLQuery('/xs:schema/@elementFormDefault' passing P_XML_SCHEMA returning content) as VARCHAR2(12)) 
    into V_ATTRIBUTE_FORM_DEFAULT, V_ELEMENT_FORM_DEFAULT
    from dual;
    
  if (V_ATTRIBUTE_FORM_DEFAULT is null) then
    V_ATTRIBUTE_FORM_DEFAULT := 'unqualified';
  end if;
  
  if (V_ELEMENT_FORM_DEFAULT is null) then
    V_ELEMENT_FORM_DEFAULT := 'qualified';
  end if;

  V_ATTRIBUTES := P_MAPPING.extract('/Element/Attrs','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"');
  V_ELEMENTS   := P_MAPPING.extract('/Element/Elements','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"');
  
  if (V_ATTRIBUTES is not null) then  
    if (V_SUBTYPE_MAPPING.existsNode('/Element/Attrs','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"') = 0) then
      if (V_SUBTYPE_MAPPING.existsNode('/Element/Elements','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"') = 0) then
        select appendChildXML
               (
                 V_SUBTYPE_MAPPING,
                 '/Element',
                 V_ATTRIBUTES,
                 'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
               )
          into V_SUBTYPE_MAPPING
          from DUAL;
      else
        select insertXMLBefore
               (
                 V_SUBTYPE_MAPPING,
                 '/Element/Elements',
                 V_ATTRIBUTES,
                 'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
               )
          into V_SUBTYPE_MAPPING
          from DUAL;
      end if;
    else
      select appendChildXML
             (
               V_SUBTYPE_MAPPING,
               '/Element/Attrs',
               V_ATTRIBUTES.extract('/Attrs/Attr','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'),
               'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
             )
          into V_SUBTYPE_MAPPING
          from DUAL;
    end if;    
  end if;
  
  if (V_ELEMENTS is not null) then 
    if (V_SUBTYPE_MAPPING.existsNode('/Element/Elements','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"') = 0) then
      select appendChildXML
             (
               V_SUBTYPE_MAPPING,
               '/Element',
               V_ELEMENTS,
               'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
             )
        into V_SUBTYPE_MAPPING
        from DUAL;
    else
      select appendChildXML
             (
               V_SUBTYPE_MAPPING,
               '/Element/Elements',
               V_ELEMENTS.extract('/Elements/Element','xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'),
               'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
             )
          into V_SUBTYPE_MAPPING
          from DUAL;
    end if;    
  end if;

  return V_SUBTYPE_MAPPING;
  
end;
--
function mapComplexType(P_TYPE_NAME VARCHAR2, P_COMPLEX_TYPE XMLType, P_TYPE_REFERENCE REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID NUMBER, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType) 
return xmlType
--
-- Handle Local and Global complex types. If P_TYPE_NAME is not null then P_TYPE_REFERENCE points to the global complexType.
--
as 
  V_ATTRIBUTES             XMLType;
  V_ELEMENTS               XMLType;
  V_MAPPING                XMLType;
  V_COMPLEX_TYPE           XMLType;
  V_ATTRIBUTE_FORM_DEFAULT VARCHAR2(12);
  V_ELEMENT_FORM_DEFAULT   VARCHAR2(12);
begin

  XDB_OUTPUT.writeLogFileEntry('mapComplexType() : Processing "' || P_TYPE_NAME || '".');

  if P_COMPLEX_TYPE.existsNode('/xsd:complexType/xsd:simpleContent',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1 then
    return mapSimpleContent(P_TYPE_NAME, P_COMPLEX_TYPE, P_TYPE_REFERENCE, P_ELEMENT_NAME, P_ELEMENT_ID, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);
  end if;

  V_COMPLEX_TYPE := P_COMPLEX_TYPE;

  -- Remove amy embedded complexType elements ..
  
  if (V_COMPLEX_TYPE.existsNode('/xsd:complexType//xsd:complexType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1) then 
    select deleteXML
           (
             P_COMPLEX_TYPE,
             '/xsd:complexType//xsd:complexType',
             XDB_NAMESPACES.XDBSCHEMA_PREFIXES
           )
      into V_COMPLEX_TYPE
      from dual;
  end if;
        
  select XMLCast(XMLQuery('/xs:schema/@attributeFormDefault' passing P_XML_SCHEMA returning content) as VARCHAR2(12)), 
         XMLCast(XMLQuery('/xs:schema/@elementFormDefault' passing P_XML_SCHEMA returning content) as VARCHAR2(12)) 
    into V_ATTRIBUTE_FORM_DEFAULT, V_ELEMENT_FORM_DEFAULT
    from dual;
    
  if (V_ATTRIBUTE_FORM_DEFAULT is null) then
    V_ATTRIBUTE_FORM_DEFAULT := 'unqualified';
  end if;
  
  if (V_ELEMENT_FORM_DEFAULT is null) then
    V_ELEMENT_FORM_DEFAULT := 'qualified';
  end if;

  -- Need to add handling for flattening AttributeGroups
  
  select xmlElement
         (
           "Attrs",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg
           (
             xmlelement
             (
               "Attr",
               xmlAttributes
               (
                 ID as "ID",
                 ATTR_REF as "Ref",
                 ATTR_TYPE as "Type",
                 XDBPM.XDBPM_XMLSCHEMA_SEARCH.getSchemaBaseType(ATTR_TYPE, P_TYPE_REFERENCE, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS) as "BaseType"
               ),
               case when ATTR_NAME is not null then
                 ATTR_NAME
               else
                 ATTR_REF
               end
             )
           )  
         )      
    into V_ATTRIBUTES
    from (    
           select ID,
                  case when ATTR_REF is not NULL then
                    XDBPM.XDBPM_XMLSCHEMA_SEARCH.getGlobalAttributeType(ATTR_REF, a.XMLDATA.PROPREF_REF, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS)
                  else
                    XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeTypeMapping(ATTR_TYPE, ATTR_BASE_TYPE, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) 
                  end ATTR_TYPE,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeNameMapping(ATTR_NAME, V_ATTRIBUTE_FORM_DEFAULT, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS) ATTR_NAME,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeRefMapping(ATTR_REF, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) ATTR_REF
             from XDB.XDB$ATTRIBUTE a,
                  XMLTABLE
                  (
                    xmlNamespaces('http://xmlns.oracle.com/xdb' as "xdb"),
                    '/xs:complexType//xs:attribute'
                    passing V_COMPLEX_TYPE
                    columns
                    ID                number(38) path '@xdb:propNumber',
                    ATTR_TYPE      varchar2(256) path '@type',
                    ATTR_BASE_TYPE varchar2(256) path '//@base',
                    ATTR_NAME      varchar2(256) path '@name',
                    ATTR_REF       varchar2(256) path '@ref'
                 )
           where a.XMLDATA.PROP_NUMBER = ID        
         );                 

  select xmlElement
         (
           "Elements",
           xmlAttributes('http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"),
           xmlAgg
           (
             xmlelement
             (
               "Element",
               xmlAttributes
               (
                 ID as "ID",
                 ELEMENT_REF as "Ref",
                 ELEMENT_TYPE as "Type"
               ),
               case when ELEMENT_NAME is not null then
                 ELEMENT_NAME
               else
                 ELEMENT_REF
               end
             )
           )
         )      
    into V_ELEMENTS
    from (    
           select ID,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeTypeMapping(ELEMENT_TYPE, ELEMENT_BASE_TYPE, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) ELEMENT_TYPE,                 
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeNameMapping(ELEMENT_NAME, V_ELEMENT_FORM_DEFAULT, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS) ELEMENT_NAME,
                  XDBPM.XDBPM_XMLSCHEMA_SEARCH.getNodeRefMapping(ELEMENT_REF, P_DEFAULT_PREFIX, P_NS_PREFIX_MAPPINGS) ELEMENT_REF
             from XMLTABLE
                  (
                    xmlNamespaces('http://xmlns.oracle.com/xdb' as "xdb"),
                    '/xs:complexType//xs:element'
                    passing V_COMPLEX_TYPE
                    columns
                    ID                   number(38) path '@xdb:propNumber',
                    ELEMENT_TYPE      varchar2(256) path '@type',
                    ELEMENT_BASE_TYPE varchar2(256) path '//@base',
                    ELEMENT_NAME      varchar2(256) path '@name',
                    ELEMENT_REF       varchar2(256) path '@ref'
                 )        
         );                 
  
  select XMLElement
         (
           "Element",
           xmlAttributes
           (
             P_ELEMENT_ID as "ID",
             P_TYPE_NAME  as "Type",
             'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"
           ),           
           xmlElement
           ( 
             "Name",
             P_ELEMENT_NAME
           ),
           V_ATTRIBUTES,
           V_ELEMENTS
         )
    into V_MAPPING
    from dual;        

  XDB_OUTPUT.writeLogFileEntry('Mapping := ');
  XDB_OUTPUT.writeLogFileEntry(V_MAPPING);

  if (V_COMPLEX_TYPE.existsNode('/xsd:complexType/xsd:complexContent/xsd:extension',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1) then
    return mapExtendedComplexType(V_MAPPING, P_TYPE_NAME, P_COMPLEX_TYPE, P_TYPE_REFERENCE, P_ELEMENT_NAME, P_ELEMENT_ID, P_XML_SCHEMA, P_DEFAULT_PREFIX , P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);
  end if;  

  return V_MAPPING;
end;
--
function mapLocalType(P_ELEMENT XMLType, P_INSTANCE_OF REF XMLType, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID NUMBER, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return XMLType
as
  V_LOCAL_TYPE XMLType;
begin
  if P_ELEMENT.existsNode('/xsd:element/xsd:complexType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1 then
    V_LOCAL_TYPE := P_ELEMENT.extract('/xsd:element/xsd:complexType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES);
    return mapComplexType(NULL, V_LOCAL_TYPE, P_INSTANCE_OF, P_ELEMENT_NAME, P_ELEMENT_ID, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);
  else
    V_LOCAL_TYPE := P_ELEMENT.extract('/xsd:element/xsd:simpleType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES);
    return mapSimpleType(NULL, V_LOCAL_TYPE, P_INSTANCE_OF, P_ELEMENT_NAME, P_ELEMENT_ID, P_XML_SCHEMA, P_DEFAULT_PREFIX, P_TARGET_PREFIX, P_NS_PREFIX_MAPPINGS);
  end if;
end;
--
function mapXMLSchemaType(P_ELEMENT_ID number, P_ELEMENT_NAME VARCHAR2, P_TYPE_NAME VARCHAR2,P_XML_SCHEMA XMLType)
return XMLType
as
  V_MAPPING XMLType;
  V_NS_PREFIX_MAPPINGS        XMLType;
  V_TARGET_PREFIX             VARCHAR2(32);
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_GLOBAL_TYPE               XMLType;
begin

  V_NS_PREFIX_MAPPINGS  := getSchemaNamespaceMappings(G_SCHEMA_FOR_SCHEMAS);
  V_DEFAULT_PREFIX      := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
  V_TARGET_PREFIX       := getGlobalPrefixForTargetNS(G_SCHEMA_FOR_SCHEMAS);


  if (P_TYPE_NAME <> 'anyType') then 
     if (G_SCHEMA_FOR_SCHEMAS.existsNode('/xsd:schema/xsd:complexType[@name="' || P_TYPE_NAME || '"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1 ) then
       V_GLOBAL_TYPE := G_SCHEMA_FOR_SCHEMAS.extract('/xsd:schema/xsd:complexType[@name="' || P_TYPE_NAME || '"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES);
       return mapComplexType(P_TYPE_NAME, V_GLOBAL_TYPE, NULL, P_ELEMENT_NAME, P_ELEMENT_ID, G_SCHEMA_FOR_SCHEMAS, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
     end if;

    if ( G_SCHEMA_FOR_SCHEMAS.existsNode('/xsd:schema/xsd:simpleType[@name="' || P_TYPE_NAME || '"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1 ) then
      V_GLOBAL_TYPE := G_SCHEMA_FOR_SCHEMAS.extract('/xsd:schema/xsd:simpleType[@name="' || P_TYPE_NAME || '"]',XDB_NAMESPACES.XDBSCHEMA_PREFIXES);
      return mapSimpleType(P_TYPE_NAME, V_GLOBAL_TYPE, NULL, P_ELEMENT_NAME, P_ELEMENT_ID, G_SCHEMA_FOR_SCHEMAS, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
    end if;
  end if;
 
  select XMLElement
         (
           "Element",
           xmlAttributes
           (
             P_ELEMENT_ID as "ID",
             C_XMLSCHEMA_TNS_PREFIX || ':' || P_TYPE_NAME  as "Type",
             C_XMLSCHEMA_TNS_PREFIX || ':' || P_TYPE_NAME  as "BaseType",
             'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"
           ),
           xmlElement
           ( 
             "Name",
             P_ELEMENT_NAME
           )
         )           
    into V_MAPPING
    from dual;        

  return V_MAPPING;

end;
--
function getGlobalType(P_XML_SCHEMA XMLType, P_TYPE_NAME varchar2, P_TYPE_NAMESPACE VARCHAR2)
return XMLType
as
  V_GLOBAL_TYPE XMLType;
begin
  if (P_TYPE_NAMESPACE is not null) then
    begin
      select XMLQuery('/xs:schema[@targetNamespace=$tn]/xs:complexType[@name=$ct]' passing P_XML_SCHEMA, P_TYPE_NAMESPACE as "tn", P_TYPE_NAME as "ct" returning content)
       into V_GLOBAL_TYPE
       from DUAL
      where XMLExists('/xs:schema[@targetNamespace=$tn]/xs:complexType[@name=$ct]' passing P_XML_SCHEMA, P_TYPE_NAMESPACE as "tn", P_TYPE_NAME as "ct" );        
    exception
     when no_data_found then
        select XMLQuery('/xs:schema[@targetNamespace=$tn]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAMESPACE as "tn", P_TYPE_NAME as "st" returning content )        
          into V_GLOBAL_TYPE
          from DUAL
         where XMLExists('/xs:schema[@targetNamespace=$tn]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAMESPACE as "tn", P_TYPE_NAME as "st" );        
     when others then
       raise;
     end;
   else
     begin
       select XMLQuery('/xs:schema[not(@targetNamespace)]/xs:complexType[@name=$ct]' passing P_XML_SCHEMA, P_TYPE_NAME as "ct" returning content )
          into V_GLOBAL_TYPE
          from DUAL
         where XMLExists('/xs:schema[not(@targetNamespace)]/xs:complexType[@name=$ct]' passing P_XML_SCHEMA, P_TYPE_NAME as "ct");        
     exception
       when no_data_found then
         select XMLQuery('/xs:schema[not(@targetNamespace)]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAME as "st" returning content )
           into V_GLOBAL_TYPE
           from DUAL
          where XMLExists('/xs:schema[not(@targetNamespace)]/xs:simpleType[@name=$st]' passing P_XML_SCHEMA, P_TYPE_NAME as "st" );
       when others then
         raise;
     end;  
   end if;       
   
   return V_GLOBAL_TYPE;
end;
--

function mapGlobalTypeDefinition(P_TYPE_NAME VARCHAR2, P_TYPE_REFERENCE REF XMLTYPE, P_ELEMENT_NAME VARCHAR2, P_ELEMENT_ID number, P_XML_SCHEMA XMLType, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return XMLType
as
  V_TYPE_PREFIX      VARCHAR2(32);
  V_TYPE_NAMESPACE   VARCHAR2(700);
  V_GLOBAL_TYPE_NAME VARCHAR2(256);
  
  V_XML_SCHEMA                XMLType;
  V_GLOBAL_TYPE               XMLType;
  V_NS_PREFIX_MAPPINGS XMLType;
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_TARGET_PREFIX             VARCHAR2(32);
  V_EXPANDED_MAPPING          XMLType;
begin

  if (instr(P_TYPE_NAME,':') > 0) then
    V_TYPE_PREFIX := substr(P_TYPE_NAME,1,instr(P_TYPE_NAME,':')-1);
    V_GLOBAL_TYPE_NAME := substr(P_TYPE_NAME,instr(P_TYPE_NAME,':')+1);
  else
    V_TYPE_PREFIX := null;
    V_GLOBAL_TYPE_NAME := P_TYPE_NAME;
  end if;
  
  -- Hack for conversion to global namespace prefixes. If the prefix doesn't match the known prefixes for the XML Schema 
  -- try to match the prefix in the global set of targetNamespaces
    
  begin
    V_TYPE_NAMESPACE := getNamespaceForPrefix(V_TYPE_PREFIX,P_NS_PREFIX_MAPPINGS);
  exception
    when no_data_found then
      V_TYPE_NAMESPACE := getNamespaceForPrefix(V_TYPE_PREFIX,G_NS_PREFIX_MAPPINGS);
  end;  

  if (V_TYPE_NAMESPACE = DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA) then
    V_TYPE_NAMESPACE := C_XDBPM_XMLSCHEMA_NAMESPACE;
  end if;

  XDB_OUTPUT.writeLogFileEntry('mapGlobalTypeDefinition() Type "' || V_GLOBAL_TYPE_NAME || '". Namespace "' || V_TYPE_NAMESPACE || '"');
 
  if (V_TYPE_NAMESPACE = XDB_NAMESPACES.XMLSCHEMA_NAMESPACE) then
    return mapXMLSchemaType(P_ELEMENT_ID, P_ELEMENT_NAME, V_GLOBAL_TYPE_NAME,P_XML_SCHEMA);
  else
  
    V_XML_SCHEMA   := P_XML_SCHEMA;
    V_GLOBAL_TYPE  := NULL;

    begin
      select s.OBJECT_VALUE, 
             XMLQuery('/xs:schema/xs:complexType[@name=$ct]' passing s.OBJECT_VALUE, V_GLOBAL_TYPE_NAME as "ct" returning content)
        into V_XML_SCHEMA, V_GLOBAL_TYPE
        from XDB.XDB$SCHEMA s, XDB.XDB$COMPLEX_TYPE ct
       where ref(ct) = P_TYPE_REFERENCE
         and ref(s)  = ct.XMLDATA.PARENT_SCHEMA 
         and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.XDBSCHEMA_LOCATION
         and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.RESOURCE_LOCATION;

      V_XML_SCHEMA         := V_XML_SCHEMA.createNonSchemaBasedXML();
      V_GLOBAL_TYPE        := V_GLOBAL_TYPE.createNonSchemaBasedXML();
      V_NS_PREFIX_MAPPINGS := getSchemaNamespaceMappings(V_XML_SCHEMA);
      V_DEFAULT_PREFIX     := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
      V_TARGET_PREFIX      := getGlobalPrefixForTargetNS(V_XML_SCHEMA);

    exception       
      when no_data_found then
        select s.OBJECT_VALUE, 
               XMLQuery('/xs:schema/xs:simpleType[@name=$st]' passing s.OBJECT_VALUE, V_GLOBAL_TYPE_NAME as "st" returning content)
          into V_XML_SCHEMA, V_GLOBAL_TYPE
          from XDB.XDB$SCHEMA s, XDB.XDB$SIMPLE_TYPE st
         where ref(st) = P_TYPE_REFERENCE
           and ref(s)  = st.XMLDATA.PARENT_SCHEMA 
           and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.XDBSCHEMA_LOCATION
           and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.RESOURCE_LOCATION;

        V_XML_SCHEMA         := V_XML_SCHEMA.createNonSchemaBasedXML();
        V_GLOBAL_TYPE        := V_GLOBAL_TYPE.createNonSchemaBasedXML();
        V_NS_PREFIX_MAPPINGS := getSchemaNamespaceMappings(V_XML_SCHEMA);
        V_DEFAULT_PREFIX     := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
        V_TARGET_PREFIX      := getGlobalPrefixForTargetNS(V_XML_SCHEMA);
      when others then
        raise;
    end;

    V_NS_PREFIX_MAPPINGS  := P_NS_PREFIX_MAPPINGS;
    V_DEFAULT_PREFIX      := P_DEFAULT_PREFIX ;            
    V_TARGET_PREFIX       := P_TARGET_PREFIX ;            

  end if;    

  if (V_GLOBAL_TYPE.existsNode('/xsd:complexType',XDB_NAMESPACES.XDBSCHEMA_PREFIXES) = 1) then
    V_EXPANDED_MAPPING := mapComplexType(P_TYPE_NAME, V_GLOBAL_TYPE, P_TYPE_REFERENCE, P_ELEMENT_NAME, P_ELEMENT_ID, V_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS); 
  else
    V_EXPANDED_MAPPING := mapSimpleType(P_TYPE_NAME, V_GLOBAL_TYPE, P_TYPE_REFERENCE, P_ELEMENT_NAME, P_ELEMENT_ID, V_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
  end if;
  
  return V_EXPANDED_MAPPING;
  
end;
--
function convertName(P_NAME VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return VARCHAR2
as
begin
 if (P_TARGET_PREFIX is not NULL) then
   return P_TARGET_PREFIX  || ':' || P_NAME;     
 else
   return P_NAME;
 end if;
end;
--
function mapElement( P_ELEMENT XMLType, P_XML_SCHEMA XMLType, P_HEAD_ELEMENT VARCHAR2, P_INSTANCE_OF REF XMLType default NULL, P_PROPERTY_NUMBER number default NULL)
return xmltype
--
-- P_INSTANCE_OF contains a REFERENCE to the ELEMENT or GLOBAL_TYPE that defines the structure of this element.
--  
as 
  V_ELEMENT_ID                NUMBER(32);
  V_ELEMENT_NAME              VARCHAR2(256);
  V_ELEMENT_TYPE              VARCHAR2(256);
  V_ELEMENT_REF               VARCHAR2(256);
  V_NS_PREFIX_MAPPINGS XMLType;
  V_DEFAULT_PREFIX            VARCHAR2(32);
  V_TARGET_PREFIX             VARCHAR2(32);
  V_ELEMENT_DEFINITION        XMLType;
begin

  select ELEMENT_ID, ELEMENT_NAME, ELEMENT_TYPE, ELEMENT_REF
    into V_ELEMENT_ID, V_ELEMENT_NAME, V_ELEMENT_TYPE, V_ELEMENT_REF
    from xmltable
         ( 
             xmlNamespaces('http://xmlns.oracle.com/xdb' as "xdb"),
            '$e/xs:element' 
            passing P_ELEMENT as "e"
            columns
            ELEMENT_ID            number(38) path '@xdb:propNumber',
            ELEMENT_NAME          varchar2(256) path '@name',
            ELEMENT_TYPE          varchar2(256) path '@type',
            ELEMENT_REF           varchar2(256) path '@ref'
         );

  V_NS_PREFIX_MAPPINGS         := getSchemaNamespaceMappings(P_XML_SCHEMA);
  V_DEFAULT_PREFIX             := getGlobalPrefixForDefaultNS(V_NS_PREFIX_MAPPINGS);
  V_TARGET_PREFIX              := getGlobalPrefixForTargetNS(P_XML_SCHEMA);

  if (V_ELEMENT_TYPE is not NULL) then
    V_ELEMENT_TYPE := convertQName(V_ELEMENT_TYPE, V_DEFAULT_PREFIX, V_NS_PREFIX_MAPPINGS);
  end if;
  
  if (V_ELEMENT_REF is not NULL) then
    V_ELEMENT_REF  := convertQName(V_ELEMENT_REF, V_DEFAULT_PREFIX, V_NS_PREFIX_MAPPINGS);
  end if;

  if (V_ELEMENT_NAME is not NULL) then
    V_ELEMENT_NAME := convertName(V_ELEMENT_NAME, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
  else
    V_ELEMENT_NAME := V_ELEMENT_REF;
  end if;
  
  if (P_PROPERTY_NUMBER is not null) then
    V_ELEMENT_ID := P_PROPERTY_NUMBER;
  end if;

  if (V_ELEMENT_TYPE is not null) then
    V_ELEMENT_DEFINITION := mapGlobalTypeDefinition(V_ELEMENT_TYPE, P_INSTANCE_OF, V_ELEMENT_NAME, V_ELEMENT_ID, P_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
  else
    if (V_ELEMENT_REF is not null) then
      V_ELEMENT_DEFINITION := mapGlobalElement(V_ELEMENT_REF, P_INSTANCE_OF, V_ELEMENT_ID,  V_ELEMENT_NAME, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
    else
      V_ELEMENT_DEFINITION := mapLocalType(P_ELEMENT, P_INSTANCE_OF, V_ELEMENT_NAME, V_ELEMENT_ID, P_XML_SCHEMA, V_DEFAULT_PREFIX, V_TARGET_PREFIX, V_NS_PREFIX_MAPPINGS);
    end if;
  end if;
  
  if (P_HEAD_ELEMENT is not null) then
    select insertChildXML
           (
             V_ELEMENT_DEFINITION,
             '/Element',
             '@subGroupHead',
             P_HEAD_ELEMENT,
             'xmlns="http://xmlns.oracle.com/xdb/pm/demo/search"'
           )
      into V_ELEMENT_DEFINITION
      from dual;
  end if;
  
  return V_ELEMENT_DEFINITION;
 
end;
--
function mapGlobalElement(P_GLOBAL_ELEMENT_NAME VARCHAR2, P_GLOBAL_ELEMENT_REF REF XMLType, P_ELEMENT_ID number, P_ELEMENT_NAME VARCHAR2, P_DEFAULT_PREFIX VARCHAR2, P_TARGET_PREFIX VARCHAR2, P_NS_PREFIX_MAPPINGS XMLType)
return XMLType
--
--  Get Definition of Global Element in specific schema. 
--  Locate Element by ID
--
--  A Global Element can be an instance of a specific global type or it can have a local complex or simple type definition.
--  A Global Element cannot be defined as a REF to another global element defined else where. 
--  A Global Element can the head of a subtitution group.
--  A Global Element can be a member of a subtitution group.
--
-- Cannot perform affinity search of current schema due to need to check if element is head of a substitution group
-- Does not work if Global Element is in XDB$RESOURCE schema or SCHEMA FOR SCHEMAS
--
as
  V_TARGET_NAMESPACE VARCHAR2(700);
  V_PREFIX           VARCHAR2(32);
  V_LOCAL_NAME       VARCHAR2(256);
  V_ELEMENT          XMLType;
  V_HEAD_ELEMENT     NUMBER(38);
  V_XML_SCHEMA       XMLType;
  V_GLOBAL_TYPE_REF  REF XMLType := NULL;
begin

  V_PREFIX            := substr(P_GLOBAL_ELEMENT_NAME,1,instr(P_GLOBAL_ELEMENT_NAME,':')-1);
  V_LOCAL_NAME        := substr(P_GLOBAL_ELEMENT_NAME,instr(P_GLOBAL_ELEMENT_NAME,':')+1);
  V_TARGET_NAMESPACE  := getNamespaceForPrefix(V_PREFIX,G_NS_PREFIX_MAPPINGS);
  
  XDB_OUTPUT.writeLogFileEntry('Serching for Global Element ' || V_LOCAL_NAME || '. Namespace ' || V_TARGET_NAMESPACE);

  select s.OBJECT_VALUE,
         XMLQuery('/xs:schema/xs:element[@name=$en]' passing s.OBJECT_VALUE, V_LOCAL_NAME as "en" returning content ),
         case when e.XMLDATA.SUBS_GROUP_REFS is not null then
           e.XMLDATA.PROPERTY.PROP_NUMBER
         else 
           null
         end HEAD_ELEMENT,
         E.XMLDATA.PROPERTY.TYPE_REF 
    into V_XML_SCHEMA, V_ELEMENT, V_HEAD_ELEMENT, V_GLOBAL_TYPE_REF             
    from XDB.XDB$SCHEMA s, XDB.XDB$ELEMENT e
     where ref(e) = P_GLOBAL_ELEMENT_REF
       and ref(s) = e.XMLDATA.PROPERTY.PARENT_SCHEMA
       and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.XDBSCHEMA_LOCATION
       and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.RESOURCE_LOCATION;

  if (V_ELEMENT is null) then
  
    -- Hack for PROPREF_REF pointing to head rather than member when REF element is member of substitution group.
  
    XDB_OUTPUT.writeLogFileEntry('Serching Substitution Group Members for ' || V_LOCAL_NAME || '. Namespace ' || V_TARGET_NAMESPACE);
  
    select s.OBJECT_VALUE,
           XMLQuery('/xs:schema/xs:element[@name=$en]' passing s.OBJECT_VALUE, V_LOCAL_NAME as "en" returning content ),
           case when sgm.XMLDATA.SUBS_GROUP_REFS is not null then
             sgm.XMLDATA.PROPERTY.PROP_NUMBER
           else 
             null
           end HEAD_ELEMENT,
           sgm.XMLDATA.PROPERTY.TYPE_REF 
      into V_XML_SCHEMA, V_ELEMENT, V_HEAD_ELEMENT, V_GLOBAL_TYPE_REF             
     from XDB.XDB$ELEMENT he, XDB.XDB$ELEMENT sgm, XDB.XDB$SCHEMA s,
          TABLE (he.XMLDATA.SUBS_GROUP_REFS) se
     where ref(he)  = P_GLOBAL_ELEMENT_REF
       and ref(sgm) = value(se)
       and sgm.XMLDATA.PROPERTY.NAME = V_LOCAL_NAME
       and ref(s)   = sgm.XMLDATA.PROPERTY.PARENT_SCHEMA;
  
  end if;
  
  V_XML_SCHEMA := V_XML_SCHEMA.createNonSchemaBasedXML();
  V_ELEMENT := V_ELEMENT.createNonSchemaBasedXML();
  
  return mapElement(V_ELEMENT, V_XML_SCHEMA, V_HEAD_ELEMENT, V_GLOBAL_TYPE_REF, P_ELEMENT_ID);
  
end;
--   
function getRootNodeMap(P_SCHEMA_URL varchar2, P_SCHEMA_OWNER varchar2 default USER, P_GLOBAL_ELEMENT varchar2)
return XMLType
--
--  Get Definition of Global Element in specific schema. 
--  Locate Element by Name given Schema URL and OWNER
--  List the immediate children of the Global Element
--
--  A Global Element can be an instance of a specific global type or it can have a local complex or simple type definition.
--  A Global Element cannot be defined as a REF to another global element defined else where. 
--  A Global Element can the head of a subtitution group.
--  A Global Element can be a member of a subtitution group.
--
as
  V_ROOT_NODE_MAP             XMLType := null;  
  V_ROOT_NODE                 XMLType;
  V_NS_PREFIX_MAPPINGS XMLType;
  
  V_XML_SCHEMA                XMLType;
  V_ELEMENT                   XMLType;
  V_HEAD_ELEMENT              NUMBER(38);
  V_XML_SCHEMA_TYPE           VARCHAR2(11);
  V_TYPE_REFERENCE            REF XMLType := null;
  V_SCHEMA_URL                VARCHAR2(1024) := P_SCHEMA_URL;
  V_SCHEMA_OWNER              VARCHAR2(128) := P_SCHEMA_OWNER;
begin
	
	XDB_OUTPUT.createLogFile(XDB_CONSTANTS.FOLDER_USER_HOME || '/xmlSchemaSearch.log');
  XDB_OUTPUT.writeLogFileEntry('getRootNodeMap() : Processing Element "' || P_GLOBAL_ELEMENT || '" in Schema "' || P_SCHEMA_URL || '". (Owner = "' || P_SCHEMA_OWNER || '").');

  if ((P_SCHEMA_URL = DBMS_XDB_CONSTANTS.SCHEMAURL_XDBSCHEMA) and (P_SCHEMA_OWNER = 'XDB')) then
    V_SCHEMA_URL   := C_XDBPM_SCHEMAURL_XMLSCHEMA;
    V_SCHEMA_OWNER := 'XDBPM';
  end if;

  if ((P_SCHEMA_URL = DBMS_XDB_CONSTANTS.SCHEMAURL_RESOURCE) and (P_SCHEMA_OWNER = 'XDB')) then
    V_SCHEMA_URL   := C_XDBPM_SCHEMAURL_XDBRESOURCE;
    V_SCHEMA_OWNER := 'XDBPM';
  end if;

  XDB_OUTPUT.writeLogFileEntry('getRootNodeMap() : Target Schema "' || P_SCHEMA_URL || '". (Owner = "' || P_SCHEMA_OWNER || '").');
  XDB_OUTPUT.flushLogFile();

  select s.OBJECT_VALUE, 
         case when bitand(to_number(s.xmldata.flags, 'xxxxxxxx'), 128) = 12  then 
           'NONE'
         else 
           case when bitand(to_number(s.xmldata.flags, 'xxxxxxxx'), 64) = 64 then  
             'RESMETADATA'
           else  
             'CONTENTS'
           end
         end HIER_TYPE,
         XMLQuery('/xs:schema/xs:element[@name=$en]' passing s.OBJECT_VALUE, P_GLOBAL_ELEMENT as "en" returning content ),
         case when e.XMLDATA.SUBS_GROUP_REFS is not null then 
           e.XMLDATA.PROPERTY.PROP_NUMBER
         else 
           NULL
         end HEAD_ELEMENT,
         E.XMLDATA.PROPERTY.TYPE_REF 
    into V_XML_SCHEMA, V_XML_SCHEMA_TYPE, V_ELEMENT, V_HEAD_ELEMENT, V_TYPE_REFERENCE
    from XDB.XDB$SCHEMA s, XDB.XDB$ELEMENT e
   where e.XMLDATA.PROPERTY.NAME = P_GLOBAL_ELEMENT
     and e.XMLDATA.PROPERTY.GLOBAL = hexToRaw('01')
     and e.XMLDATA.PROPERTY.PARENT_SCHEMA = ref(s)
     and s.XMLDATA.SCHEMA_URL = V_SCHEMA_URL
     and s.XMLDATA.SCHEMA_OWNER = V_SCHEMA_OWNER;
  V_XML_SCHEMA := V_XML_SCHEMA.createNonSchemaBasedXML();
  V_ELEMENT := V_ELEMENT.createNonSchemaBasedXML();

  V_ROOT_NODE := mapElement(V_ELEMENT, V_XML_SCHEMA, V_HEAD_ELEMENT, V_TYPE_REFERENCE);

  select xmlElement(
          "NodeMap",
          xmlAttributes( 
            'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns",
            V_XML_SCHEMA_TYPE as "schemaType"
          ),
          G_NS_PREFIX_MAPPINGS,
          V_ROOT_NODE
         )
    into V_ROOT_NODE_MAP
    from dual;
  
  XDB_OUTPUT.flushLogFile();
	  
  return V_ROOT_NODE_MAP;
end;
--  
function getChildNodeMap(P_PROPERTY_NUMBER number)
return xmltype
as
  V_ELEMENT                   XMLType;
  V_XML_SCHEMA                XMLType;
  V_NS_PREFIX_MAPPINGS XMLType;
  V_HEAD_ELEMENT              NUMBER(38);
  V_GLOBAL_ELEMENT_REF        REF XMLType := null;
  V_GLOBAL_TYPE_REF           REF XMLType := null;
  V_CHILD_NODE_MAP            XMLType;
begin

	XDB_OUTPUT.createLogFile(XDB_CONSTANTS.FOLDER_USER_HOME || '/xmlSchemaSearch.log');
  XDB_OUTPUT.writeLogFileEntry('getChildMap() : Processing Element "' || P_PROPERTY_NUMBER || '").');

  select s.OBJECT_VALUE,
         XMLQuery('declare namespace xdb = "http://xmlns.oracle.com/xdb"; /xs:schema//xs:element[@xdb:propNumber=$pn]'passing s.OBJECT_VALUE, P_PROPERTY_NUMBER as "pn" returning content ),
         case when e.XMLDATA.SUBS_GROUP_REFS is not null then
           e.XMLDATA.PROPERTY.PROP_NUMBER
         else 
           null
         end HEAD_ELEMENT,
         e.XMLDATA.PROPERTY.PROPREF_REF,
         e.XMLDATA.PROPERTY.TYPE_REF
    into V_XML_SCHEMA, V_ELEMENT, V_HEAD_ELEMENT, V_GLOBAL_ELEMENT_REF, V_GLOBAL_TYPE_REF
    from XDB.XDB$SCHEMA s, XDB.XDB$ELEMENT e
   where e.XMLDATA.PROPERTY.PROP_NUMBER = P_PROPERTY_NUMBER
     and e.XMLDATA.PROPERTY.PARENT_SCHEMA = ref(s)
    and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.XDBSCHEMA_LOCATION
    and s.XMLDATA.SCHEMA_URL != XDB_NAMESPACES.RESOURCE_LOCATION;
  V_XML_SCHEMA := V_XML_SCHEMA.createNonSchemaBasedXML();
  V_ELEMENT := V_ELEMENT.createNonSchemaBasedXML();
  
  if (V_GLOBAL_TYPE_REF is not null) then
    V_CHILD_NODE_MAP := mapElement(V_ELEMENT, V_XML_SCHEMA, V_HEAD_ELEMENT, V_GLOBAL_TYPE_REF, P_PROPERTY_NUMBER);
  else
    V_CHILD_NODE_MAP := mapElement(V_ELEMENT, V_XML_SCHEMA, V_HEAD_ELEMENT, V_GLOBAL_ELEMENT_REF, P_PROPERTY_NUMBER);
  end if;

	XDB_OUTPUT.flushLogFile();
	return V_CHILD_NODE_MAP;

end;
--
function getSubstitutionGroup(P_HEAD_ELEMENT NUMBER) 
return XMLType
as
  V_SUBSTITUTION_GROUP XMLType;
begin

	XDB_OUTPUT.createLogFile(XDB_CONSTANTS.FOLDER_USER_HOME || '/xmlSchemaSearch.log');
  XDB_OUTPUT.writeLogFileEntry('getSubstitutionGroup() : Processing Head Element "' || P_HEAD_ELEMENT || '").');

  select xmlElement
         (
           "SubGroup",
           xmlAttributes
           (
             P_HEAD_ELEMENT as "Head",
             'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns"
           ),
           (
              select xmlAgg
                     (
                        xmlElement
                        (
                          "Element",
                          xmlAttributes(sgm.XMLDATA.PROPERTY.PROP_NUMBER as "ID"),
                          XDBPM.XDBPM_XMLSCHEMA_SEARCH.getGlobalPrefixForNamespace(s.XMLDATA.TARGET_NAMESPACE) || ':' || sgm.XMLDATA.PROPERTY.NAME 
                        )
                      )
                 from XDB.XDB$ELEMENT he, XDB.XDB$ELEMENT sgm, XDB.XDB$SCHEMA s,
                      TABLE (he.XMLDATA.SUBS_GROUP_REFS) se
                where ref(sgm) = value(se)
                  and ref(s)  = sgm.XMLDATA.PROPERTY.PARENT_SCHEMA
                  and he.XMLDATA.PROPERTY.PROP_NUMBER = P_HEAD_ELEMENT
           )
         )
    into V_SUBSTITUTION_GROUP
    from DUAL;

	XDB_OUTPUT.flushLogFile();
    
  return V_SUBSTITUTION_GROUP;
  
end;
--
procedure getNamespacePrefixMappings
as
begin
  select xmlElement
         (
           "Namespaces",
           xmlagg
           (
              xmlElement
              (
                 "Namespace",
                 xmlAttributes(PREFIX as "Prefix"),
                 NAMESPACE
              )
           )
         ) 
    into G_NS_PREFIX_MAPPINGS
    from (    
           select 'ns' || rownum PREFIX, NAMESPACE
             from (                 
                    select distinct s.XMLDATA.TARGET_NAMESPACE NAMESPACE
                      from XDB.XDB$SCHEMA s
                     where s.XMLDATA.TARGET_NAMESPACE != 'http://www.w3.org/XML/1998/namespace'
                       and s.XMLDATA.TARGET_NAMESPACE != XDB_NAMESPACES.XMLSCHEMA_NAMESPACE
                       and s.XMLDATA.TARGET_NAMESPACE != XDB_NAMESPACES.ORACLE_XDB_NAMESPACE
                  )
           union all
           select 'xs' PREFIX, XDB_NAMESPACES.XMLSCHEMA_NAMESPACE NAMESPACE
             from DUAL
           union all
           select 'xdb' PREFIX, XDB_NAMESPACES.ORACLE_XDB_NAMESPACE NAMESPACE
             from DUAL
            order by NAMESPACE
         );         
end;
--
procedure loadSchemaForSchemas
as
begin
  select SCHEMA
    into G_SCHEMA_FOR_SCHEMAS
    from ALL_XML_SCHEMAS
   where OWNER = 'XDBPM'
     and SCHEMA_URL = XDBPM.XDBPM_XMLSCHEMA_SEARCH.getXMLSchemaLocation();

 G_XMLSCHEMA_NS_PREFIX_MAPPINGS  := getSchemaNamespaceMappings(G_SCHEMA_FOR_SCHEMAS);
 G_XMLSCHEMA_DEFAULT_PREFIX      := getGlobalPrefixForDefaultNS(G_XMLSCHEMA_NS_PREFIX_MAPPINGS);
 G_XMLSCHEMA_TARGET_PREFIX       := getGlobalPrefixForTargetNS(G_SCHEMA_FOR_SCHEMAS);
 
end;
--
begin
	
	XDB_OUTPUT.createLogFile(XDB_CONSTANTS.FOLDER_USER_HOME || '/xmlSchemaSearch.log');
  XDB_OUTPUT.writeLogFileEntry('Package Initialization');

  getNamespacePrefixMappings();  
  loadSchemaForSchemas();
    
  XDB_OUTPUT.flushLogFile();
  
end;
/
show errors
--
set define on
--
alter session set current_schema = SYS
/