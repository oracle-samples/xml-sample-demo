
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
-- XDBPM_XMLINDEX_SEARCH should be created under XDBPM
--
alter session set current_schema = XDBPM
/
set define off
--
create or replace package XDBPM_XML_CONVERSIONS
as
/*
**
** Process Attributes
** For Each Attribute
**    Case
**      CollectonType 
**      		Add Cast/Multiset
**      		ProcessObjectType
**      ObjectType
**         ProcessObjectType  
**      ScalarType
**         Add to AttrList and ColumnList
**         
**      
** Process ObjectType
**   Add ObjectConstructor
** 
*/
  function getStatement(P_XML XMLTYPE, P_SCHEMA VARCHAR2, P_TYPE_NAME VARCHAR2) return CLOB;
  function stripNamespace(P_XML XMLTYPE) return XMLTYPE;
end;
/
show errors
--
create or replace synonym XDB_XML_CONVERSIONS for XDBPM_XML_CONVERSIONS
/
grant execute on XDBPM_XML_CONVERSIONS to public
/
create or replace package BODY XDBPM_XML_CONVERSIONS
as
--
  C_NEWLINE constant VARCHAR2(2) := chr(10) || chr(13);
  C_BLANK   constant VARCHAR2(1) := ' ';
  
  G_ID      NUMBER(6) := 0;
  
function doubleQuote(P_SCHEMA VARCHAR2,P_IDENTIFIER VARCHAR2) 
return VARCHAR2
as
begin
	return '"' || P_SCHEMA || '"."' || P_IDENTIFIER || '"';
end;
--
function doubleQuote(P_IDENTIFIER VARCHAR2) 
return VARCHAR2
as
begin
	return '"' || P_IDENTIFIER || '"';
end;
--
function singleQuote(P_IDENTIFIER VARCHAR2) 
return VARCHAR2
as
begin
	return '''' || P_IDENTIFIER || '''';
end;
-- 
function appendXPathExpression(P_PATH_PREFIX VARCHAR2,P_NEWITEM VARCHAR2) 
return VARCHAR2
as
begin
	if P_PATH_PREFIX is null then
	  return P_NEWITEM;
	else
	  return P_PATH_PREFIX || '/' || P_NEWITEM;
	end if;
end;
--
function makeUniqueName(P_NAME VARCHAR2)
return VARCHAR2
as
begin
	G_ID := G_ID + 1;
	if LENGTH(P_NAME) < 25 then
	  return P_NAME || '_' || lpad(G_ID,6,'0');
	else
	  return LTRIM(P_NAME,25) || '_' || lpad(G_ID,6,'0');
	end if;
end;
--
function addXMLTableOperator(P_ROW_PATTERN VARCHAR2,P_XML_NAME VARCHAR2,P_COLUMN_PATTERN CLOB,P_INDENT NUMBER)
return CLOB
as 
  V_CONSTRUCTOR    CLOB;
begin
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT)   || 'FROM';
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT+2) || 'XMLTABLE(';
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT+4) || singleQuote('/' || P_ROW_PATTERN);
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT+4) || 'passing ' || doubleQuote(P_XML_NAME);
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT+4) || 'COLUMNS';
  V_CONSTRUCTOR := V_CONSTRUCTOR || P_COLUMN_PATTERN;
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT+2) || ')';
  return V_CONSTRUCTOR;
end;
--
function addObjectConstructor(P_SCHEMA VARCHAR2, P_TYPE_NAME VARCHAR2, P_COLUMN_PREFIX VARCHAR2, P_COLUMN_PATTERN OUT CLOB, P_INDENT NUMBER)
return CLOB;
--
function addCollectionConstructor(P_SCHEMA VARCHAR2, P_TYPE_NAME VARCHAR2, P_XML_NAME VARCHAR2, P_BASE_TYPE_NAME IN OUT VARCHAR2, P_INDENT NUMBER)
return CLOB
/*
**
** CAST(
**   MULTISET(
**     select
**       "SCHEMA"."BASE_TYPE_NAME"(
**       )
**       from 
**         XMLTABLE(
**           '/BASE_TYPE_NAME'
**           PASSING "P_XML_NAME"
**           COLUMNS
**         )
**
** Note : returns base type name for use in the ROW Pattern for the collection.
*/
as
  cursor getCollectionType
  is
  select ELEM_TYPE_OWNER, ELEM_TYPE_NAME
    from ALL_COLL_TYPES
   where OWNER = P_SCHEMA and TYPE_NAME = P_TYPE_NAME;
  
  V_BASE_TYPE_OWNER VARCHAR2(32);
  V_BASE_TYPE_NAME  VARCHAR2(32);

  V_CONSTRUCTOR     CLOB;
  V_COLUMN_PATTERN  CLOB;  
begin

  for e in getCollectionType loop
    V_BASE_TYPE_OWNER := e.ELEM_TYPE_OWNER;
    V_BASE_TYPE_NAME  := e.ELEM_TYPE_NAME;
    P_BASE_TYPE_NAME  := V_BASE_TYPE_NAME;
  end loop;

  V_CONSTRUCTOR := rpad(C_NEWLINE,P_INDENT) || 'CAST(';
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT + 2) || 'MULTISET(';
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT + 4) || 'select ';
 
  V_CONSTRUCTOR := V_CONSTRUCTOR || addObjectConstructor(
                                      P_SCHEMA          => V_BASE_TYPE_OWNER,
                                      P_TYPE_NAME       => V_BASE_TYPE_NAME,
                                      P_COLUMN_PREFIX   => NULL,
                                      P_COLUMN_PATTERN  => V_COLUMN_PATTERN,
                                      P_INDENT          => P_INDENT + 6);
 
  V_CONSTRUCTOR := V_CONSTRUCTOR || addXMLTableOperator(
                                      P_ROW_PATTERN    => V_BASE_TYPE_NAME,
                                      P_XML_NAME       => P_XML_NAME,
                                      P_COLUMN_PATTERN => V_COLUMN_PATTERN,
                                      P_INDENT         => P_INDENT + 6);
  
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT + 2) || ') as ' || doubleQuote(P_SCHEMA,P_TYPE_NAME);
  V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT) || ')';
  return V_CONSTRUCTOR;

end;
-- 
function addObjectConstructor(P_SCHEMA VARCHAR2, P_TYPE_NAME VARCHAR2, P_COLUMN_PREFIX VARCHAR2, P_COLUMN_PATTERN OUT CLOB, P_INDENT NUMBER)
return CLOB
as
  cursor getTypeAttrs 
  is
  select ATTR_NAME, ATTR_TYPE_OWNER, ATTR_TYPE_NAME,  LENGTH, TYPECODE
    from ALL_TYPE_ATTRS ata
    LEFT OUTER JOIN ALL_TYPES at
      on ata.ATTR_TYPE_OWNER = at.OWNER
     and ata.ATTR_TYPE_NAME  = at.TYPE_NAME
   where ata.OWNER = P_SCHEMA and ata.TYPE_NAME = P_TYPE_NAME
   order by ATTR_NO;
   
  V_CONSTRUCTOR      CLOB;
  V_COLUMNS_CLAUSE   CLOB;
  V_COLUMN_PATTERN   VARCHAR2(32000);
  MULTIPLE_ATTRS     BOOLEAN := FALSE;
  V_XPATH_EXPRESSION VARCHAR2(32000);
  V_BASE_OBJECT_TYPE VARCHAR2(32);
  V_ATTR_TYPE        VARCHAR2(64);
  V_UNIQUE_NAME      VARCHAR2(32);
begin
  V_CONSTRUCTOR    := RPAD(C_NEWLINE,P_INDENT) || doubleQuote(P_SCHEMA,P_TYPE_NAME) || '(';
  P_COLUMN_PATTERN := '';

  for attr in getTypeAttrs loop

    if MULTIPLE_ATTRS then
      V_CONSTRUCTOR    := V_CONSTRUCTOR    || ','; 
      P_COLUMN_PATTERN := P_COLUMN_PATTERN || ',';
    end if;

    V_XPATH_EXPRESSION := appendXPathExpression(P_COLUMN_PREFIX,attr.ATTR_NAME);
    
    if attr.TYPECODE = 'COLLECTION' then
      V_UNIQUE_NAME := makeUniqueName(attr.ATTR_NAME);
      
      V_CONSTRUCTOR := V_CONSTRUCTOR 
                    || addCollectionConstructor(
                         P_SCHEMA         => attr.ATTR_TYPE_OWNER, 
                         P_TYPE_NAME      => attr.ATTR_TYPE_NAME, 
                         P_XML_NAME       => V_UNIQUE_NAME, 
                         P_BASE_TYPE_NAME => V_BASE_OBJECT_TYPE, 
                         P_INDENT         => P_INDENT + 2
                       );

      V_COLUMN_PATTERN  := rpad(C_NEWLINE,P_INDENT + 7) 
                        || rpad(doubleQuote(V_UNIQUE_NAME),36) 
                        || rpad('XMLTYPE',36) 
                        || 'PATH ' || singleQuote(appendXpathExpression(V_XPATH_EXPRESSION,V_BASE_OBJECT_TYPE));
    end if;

    if attr.TYPECODE = 'OBJECT' then
      V_CONSTRUCTOR := V_CONSTRUCTOR || addObjectConstructor(attr.ATTR_TYPE_OWNER, attr.ATTR_TYPE_NAME, V_XPATH_EXPRESSION, V_COLUMN_PATTERN , P_INDENT + 2);
    end if;
    
    if attr.TYPECODE is NULL then
      V_UNIQUE_NAME := makeUniqueName(attr.ATTR_NAME);
      V_ATTR_TYPE := attr.ATTR_TYPE_NAME;
      if (attr.LENGTH is not NULL) then
        V_ATTR_TYPE := V_ATTR_TYPE || '(' || attr.LENGTH || ')';
      end if;
      V_CONSTRUCTOR := V_CONSTRUCTOR || rpad(C_NEWLINE,P_INDENT + 2) || doubleQuote(V_UNIQUE_NAME);
      V_COLUMN_PATTERN  := rpad(C_NEWLINE,P_INDENT + 5) 
                        || rpad(doubleQuote(V_UNIQUE_NAME),36) 
                        || rpad(V_ATTR_TYPE,36) 
                        || 'PATH ' || singleQuote(V_XPATH_EXPRESSION);
    end if;

    P_COLUMN_PATTERN := P_COLUMN_PATTERN || V_COLUMN_PATTERN;
    MULTIPLE_ATTRS := TRUE;
  end loop;  
  
  V_CONSTRUCTOR   := V_CONSTRUCTOR || RPAD(C_NEWLINE,P_INDENT) || ')';
  return V_CONSTRUCTOR;
end;
--
function stripNamespace(P_XML XMLTYPE) 
return XMLTYPE
as
  V_XML XMLTYPE;
begin
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
  select P_XML.TRANSFORM(XMLTYPE(
'<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="@*|text()|processing-instruction()|comment()">
     <xsl:copy>
       <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
     </xsl:copy>
   </xsl:template>
   <xsl:template match="*">
     <xsl:element name="{local-name(.)}">
       <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
     </xsl:element>
   </xsl:template>
</xsl:stylesheet>'))
   into V_XML
   from DUAL;
$ELSE
	select XMLQUERY(
	         'declare function local:strip-ns($e as element()) as element() { 
	            element {local-name($e) } {
                for $i in $e/(@*|node())
                  return typeswitch ($i)
                           case element() return local:strip-ns($i)
                          default return $i
              }
            };
            local:strip-ns(*)'
	         passing P_XML
	         returning CONTENT
	       )
	  into V_XML
	  from DUAL;
$END	  
	return V_XML;
end;
--	
function getStatement(P_XML XMLTYPE,P_SCHEMA VARCHAR2, P_TYPE_NAME VARCHAR2) 
return CLOB
/*
**
** Assumes all nodes are in noNamespaceNamespace.
**
** ToDo : Root element name and namespace (Currently use wildcard for Root Element)
**
** ToDo : Sort out Precision and other Scalar Data Type modifications..
**
** ToDo : Mapping XMLType ?
**
*/
as
  V_IS_COLLECTION_TYPE NUMBER(1);
  V_STATEMENT CLOB;
  V_COLUMN_PATTERN CLOB;
begin
	G_ID := 0;
  V_STATEMENT := 'select';

  V_STATEMENT := V_STATEMENT 
              || addObjectConstructor(
                   P_SCHEMA         => P_SCHEMA,
                   P_TYPE_NAME      => P_TYPE_NAME,
                   P_COLUMN_PREFIX  => NULL,
                   P_COLUMN_PATTERN => V_COLUMN_PATTERN,
                   P_INDENT         => 4
                 );
     
  /*
  **
  ** For some reason the original implementation of toObject doesn't seem to care about the name of the first element... 
  **
  */
     
  if (instr(V_COLUMN_PATTERN,2,'/') > 0 ) then
    V_COLUMN_PATTERN := '/*' || SUBSTR(V_COLUMN_PATTERN,INSTR(V_COLUMN_PATTERN,2,'/'));
  else
    V_COLUMN_PATTERN := '/*';
  end if;
     
  V_STATEMENT := V_STATEMENT 
              || addXMLTableOperator(
                   P_ROW_PATTERN    => '/',
                   P_XML_NAME       => 'XML', 
                   P_COLUMN_PATTERN => V_COLUMN_PATTERN,
                   P_INDENT         => 4
                 );
    
	return V_STATEMENT;
end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
