
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

Rem
Rem $Header: tk_objects/tkxm/sql/dbmsxutil_otn.sql st_server_bhammers_bug-13083182/2 2011/10/17 10:32:39 bhammers Exp $
Rem
Rem dbmsxutil.sql
Rem
Rem Copyright (c) 2009, 2011, Oracle and/or its affiliates. 
Rem All rights reserved. 
Rem
Rem    NAME
Rem      dbmsxutil.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      This file will be executed an various db versions and that conditional
Rem      compilation needs to be used if a procedure should not appear in all 
Rem      versions.  
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bhammers    10/12/11 - fix sql injection bug 13083026 
Rem    bhammers    01/21/11 - bug 10094590, 10324163 
Rem    shivsriv    01/14/11 - modify ALL_XMLTYPE_COLS
Rem    bhammers    08/06/10 - add printWarnings
Rem    hxzhang     05/20/10 - exchange partition pre/post proc
Rem    shivsriv    04/12/10 - bug 9542232
Rem    shivsriv    02/11/10 - modify renameCollectionTable
Rem    bhammers    12/12/09 - incorporate change requests from MDRAKE
Rem    schakrab    05/27/09 - add OBJCOL_NAME in *_XMLTYPE_COLS
Rem    shivsriv    05/20/09 - change the procedure names
Rem    schakrab    02/27/09 - make XDB_INDEX_DDL_CACHE private
Rem    bhammers    01/13/09 - added XPath to xcolumn mapping
Rem    shivsriv    01/12/09 - added scopeXMLReferences/indexXMLRefences methods
Rem    bhammers    12/15/08 - moved implementation to prvtxutil.sql
Rem    bhammers    11/10/08 - Created 
Rem

SET SERVEROUTPUT ON

BEGIN
    $IF DBMS_DB_VERSION.VER_LE_10_1 $THEN
       DBMS_OUTPUT.PUT_LINE('This package is only working on Oracle RDBMS versions 10.2, 11.1, and 11.2.');
       RAISE_APPLICATION_ERROR(-31061, 'Unsupported Oracle RDBMS version');
    $ELSIF DBMS_DB_VERSION.VER_LE_10_2 $THEN
       DBMS_OUTPUT.PUT_LINE('INSTALLING SCRIPT FOR VERSION 10.2.');
    $ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
       DBMS_OUTPUT.PUT_LINE('INSTALLING SCRIPT FOR VERSION 11.1.');
    $ELSIF DBMS_DB_VERSION.VER_LE_11_2 $THEN
       DBMS_OUTPUT.PUT_LINE('INSTALLING SCRIPT FOR VERSION 11.2.');
    $ELSE
       DBMS_OUTPUT.PUT_LINE('This package is only working on Oracle RDBMS versions 10.2, 11.1, and 11.2.');
       RAISE_APPLICATION_ERROR(-31061, 'Unsupported Oracle RDBMS version'); 
    $END
END;
/


BEGIN
  DBMS_LOCK.SLEEP(2);
END;
/


SET ECHO ON
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100

--**************************************************
-- Create xml schema views first because some
-- pl/sql procedures need them
--**************************************************
--**************************************************
-- Create xml schema views first because some
-- pl/sql procedures need them
--**************************************************
/*
This view selects all the available namespaces
OWNER - user who owns the namespace
TARGET_NAMESPACE - the targetNamespace 
XML_SCHEMA_URL - the url of the schema
*/
create or replace view DBA_XML_SCHEMA_NAMESPACES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       s.xmldata.schema_url SCHEMA_URL
  from xdb.xdb$schema s
/
grant select on DBA_XML_SCHEMA_NAMESPACES to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_NAMESPACES for DBA_XML_SCHEMA_NAMESPACES
/

/*
This view selects all the available namespaces for the user
OWNER - user who owns the namespace
TARGET_NAMESPACE - the targetNamespace 
XML_SCHEMA_URL - the url of the schema
*/
create or replace view ALL_XML_SCHEMA_NAMESPACES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       s.xmldata.schema_url SCHEMA_URL
  from xdb.xdb$schema s, all_xml_schemas a
  where s.xmldata.schema_owner = a.owner
  and s.xmldata.schema_url = a.schema_url
/
grant select on ALL_XML_SCHEMA_NAMESPACES to public
/
create or replace public synonym ALL_XML_SCHEMA_NAMESPACES for ALL_XML_SCHEMA_NAMESPACES
/

/*
This view selects all the namaspaces for the current user
TARGET_NAMESPACE - the targetNamespace 
XML_SCHEMA_URL - the url of the schema
*/
create or replace view USER_XML_SCHEMA_NAMESPACES
as
select TARGET_NAMESPACE, SCHEMA_URL
  from DBA_XML_SCHEMA_NAMESPACES
 where OWNER = USER
/
grant select on USER_XML_SCHEMA_NAMESPACES to public
/
create or replace public synonym USER_XML_SCHEMA_NAMESPACES for USER_XML_SCHEMA_NAMESPACES
/

CREATE OR REPLACE TYPE PARENTIDARRAY is VARRAY(20) OF RAW(20);
/

CREATE OR REPLACE PACKAGE PrvtParentChild
 IS
     TYPE refCursor is REF CURSOR;
     
     Function getParentID ( elementID IN varchar2 )
       RETURN PARENTIDARRAY;

     Function sizeArray ( elementID IN varchar2 )
       RETURN NUMBER;
 END;
 /
 
CREATE OR REPLACE package body PrvtParentChild
IS

Function getParentIDFromModelID
       ( modelID IN varchar2 )
       RETURN PARENTIDARRAY
    IS
       parentElementID PARENTIDARRAY := PARENTIDARRAY();
       cur0 refCursor;
       pID RAW(200);
       sqlStmtBase varchar2(2000);
       sqlStmt varchar2(2000);
       counter number(38);
       complexID varchar2(200);
       BEGIN
    sqlStmtBase := 'from xdb.xdb$complex_type ct where ( sys_op_r2o(ct.xmldata.all_kid) =';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.choice_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.sequence_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.extension.sequence_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.extension.choice_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.extension.all_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.extension.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.restriction.sequence_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.restriction.choice_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.restriction.all_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.restriction.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
    sqlStmtBase := sqlStmtBase || ' )';

    sqlStmt := ' select count(*) ' || sqlStmtBase;
    EXECUTE IMMEDIATE sqlStmt INTO counter ;
    IF (counter <> 0) THEN
        sqlStmt := 'select ct.sys_nc_oid$ ' || sqlStmtBase;
        EXECUTE IMMEDIATE sqlStmt INTO complexID ;

        sqlStmt := ' select hextoraw(e.xmldata.property.prop_number) from xdb.xdb$element e where sys_op_r2o(e.xmldata.property.type_ref) = ';
        sqlStmt := sqlStmt || Dbms_Assert.Enquote_Literal(complexID);
        sqlStmt := sqlStmt ;
        counter := 1;
        OPEN cur0 FOR sqlStmt;
        LOOP
             FETCH cur0 INTO pID;
             EXIT WHEN cur0%NOTFOUND;
             parentElementID.extend;
             parentElementID(counter) := pID;
             counter := counter + 1;
        END LOOP;
        CLOSE cur0;
        RETURN parentElementID;
    ELSE
       RETURN NULL;
    END IF;

      
    RETURN parentElementID;
    EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
    END;  
    
Function getParentIDFromGroupID
       ( groupID IN varchar2 )
       RETURN PARENTIDARRAY
    IS
       modelID varchar2(200);
       complexID varchar2(200);
       counter number(38);
       sqlStmtBase varchar2(2000);
       sqlStmt varchar2(2000);
       seqKid boolean := FALSE;
       choiceKid boolean := FALSE;
       allKid boolean := FALSE;
       kidClause varchar2(100);
       elementID varchar2(200);
       parentElementID PARENTIDARRAY := PARENTIDARRAY();
       cur0 refCursor;
       pID RAW(200);
    BEGIN
    counter := 0;
       -- Get the reference ID from the def ID
       select count(*) INTO counter from xdb.xdb$group_ref rg, xdb.xdb$group_def dg where ref(dg) = rg.xmldata.groupref_ref and dg.sys_nc_oid$= groupID;
       IF (counter <> 0) THEN
          select rg.sys_nc_oid$ INTO elementID from xdb.xdb$group_ref rg, xdb.xdb$group_def dg where ref(dg) = rg.xmldata.groupref_ref and dg.sys_nc_oid$= groupID;
       ELSE
          RETURN NULL;
       END IF;
       -- choice
      sqlStmtBase := 'from xdb.xdb$choice_model sm, table(sm.xmldata.groups) t where sys_op_r2o(t.column_value) = ';
      sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
      sqlStmt := ' select count(*) ' || sqlStmtBase;
       EXECUTE IMMEDIATE sqlStmt INTO counter ;
       IF ( counter <> 0 ) THEN
           sqlStmt := ' select sm.sys_nc_oid$ ' || sqlStmtBase;
           EXECUTE IMMEDIATE sqlStmt INTO modelID ;
           choiceKid := TRUE;
       ELSE
      sqlStmtBase := 'from xdb.xdb$sequence_model sm, table(sm.xmldata.groups) t where sys_op_r2o(t.column_value) = ';
      sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
      sqlStmt := ' select count(*) ' || sqlStmtBase;
       EXECUTE IMMEDIATE sqlStmt INTO counter ;
          IF ( counter <> 0 ) THEN

           sqlStmt := ' select sm.sys_nc_oid$ ' || sqlStmtBase;
           EXECUTE IMMEDIATE sqlStmt INTO modelID ;
            seqKid := TRUE;
          ELSE
      sqlStmtBase := 'from xdb.xdb$all_model sm, table(sm.xmldata.groups) t where sys_op_r2o(t.column_value) = ';
      sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
      sqlStmt := ' select count(*) ' || sqlStmtBase;
            IF ( counter <> 0 ) THEN

           sqlStmt := ' select sm.sys_nc_oid$ ' || sqlStmtBase;
           EXECUTE IMMEDIATE sqlStmt INTO modelID ;
                allKid := TRUE;
            ELSE
               -- could be a direct child
    sqlStmtBase := 'from xdb.xdb$complex_type ct where ( ';
    sqlStmtBase := sqlStmtBase || '  sys_op_r2o(ct.xmldata.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.extension.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
    sqlStmtBase := sqlStmtBase || ' OR sys_op_r2o(ct.xmldata.complexcontent.restriction.group_kid) = ';
    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(elementID);
    sqlStmtBase := sqlStmtBase || ' )';

    sqlStmt := ' select count(*) ' || sqlStmtBase;
    DBMS_OUTPUT.PUT_LINE ( sqlStmt);         
    EXECUTE IMMEDIATE sqlStmt INTO counter ;
    IF (counter <> 0) THEN
        sqlStmt := 'select ct.sys_nc_oid$ ' || sqlStmtBase;
        EXECUTE IMMEDIATE sqlStmt INTO complexID ;

        sqlStmt := ' select hextoraw(e.xmldata.property.prop_number) from xdb.xdb$element e where sys_op_r2o(e.xmldata.property.type_ref) = ';
        sqlStmt := sqlStmt || Dbms_Assert.Enquote_Literal(complexID);
        sqlStmt := sqlStmt ;

        counter := 1;
        OPEN cur0 FOR sqlStmt;
        LOOP
             FETCH cur0 INTO pID;
             EXIT WHEN cur0%NOTFOUND;
             parentElementID.extend;
             parentElementID(counter) := pID;
             counter := counter + 1;
        END LOOP;
        CLOSE cur0;
        RETURN parentElementID;
    ELSE
       RETURN NULL;
    END IF;
            END IF;
        END IF;
       END IF;
       
       sqlStmtBase := '';
       WHILE TRUE
       LOOP

            IF (seqKid = TRUE) THEN kidClause := 'sequence_kids';
            ELSIF (choiceKid = TRUE) THEN kidClause := 'choice_kids';
            ELSE RETURN getParentIDFromModelID(modelID);
            END IF;
           
            counter := 0;
            sqlStmtBase := 'table(sm.xmldata.' || kidClause || ')t where sys_op_r2o(t.column_value) = ';
            sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
            sqlStmt := 'select count(*) from xdb.xdb$choice_model sm, ' || sqlStmtBase;
            EXECUTE IMMEDIATE sqlStmt INTO counter  ;
            IF (counter <> 0) THEN
              sqlStmt := 'select sm.sys_nc_oid$ from xdb.xdb$choice_model sm, ' || sqlStmtBase;
              EXECUTE IMMEDIATE sqlStmt INTO modelID ;
              choicekid := TRUE; seqKid := FALSE; allKid := FALSE;
            ELSE
              sqlStmt := 'select count(*)   from xdb.xdb$sequence_model sm, ' || sqlStmtBase;
              EXECUTE IMMEDIATE sqlStmt INTO counter;
              IF (counter <> 0) THEN
                 sqlStmt := 'select sm.sys_nc_oid$  from xdb.xdb$sequence_model sm, ' || sqlStmtBase;
                 EXECUTE IMMEDIATE sqlStmt INTO modelID ;
                 choicekid := FALSE; seqKid := TRUE; allKid := FALSE;
              ELSE
                 sqlStmt := 'select count(*)  from xdb.xdb$all_model sm, ' || sqlStmtBase;
                 EXECUTE IMMEDIATE sqlStmt INTO counter ;
                 IF (counter <> 0) THEN
                    sqlStmt := 'select sm.sys_nc_oid$   from xdb.xdb$all_model sm, ' || sqlStmtBase;
                    EXECUTE IMMEDIATE sqlStmt INTO modelID;
                    choicekid := FALSE; seqKid := FALSE; allKid := TRUE;
                 ELSE -- group
                       RETURN getParentIDFromModelID(modelID);
                 END IF;
              END IF;
           END IF;
       END LOOP;

    RETURN NULL;
    EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
END;

Function getParentID
       ( elementID IN varchar2 )
       RETURN PARENTIDARRAY
    IS
       modelID varchar2(200);
       complexID varchar2(200);
       counter number(38);
       sqlStmtBase varchar2(2000);
       sqlStmt varchar2(2000);

       seqKid boolean := FALSE;
       choiceKid boolean := FALSE;
       allKid boolean := FALSE;
       kidClause varchar2(100);
    BEGIN
    counter := 0;
       -- choice
       select count(*) INTO counter from xdb.xdb$element e, xdb.xdb$choice_model sm, 
       table(sm.xmldata.elements)t where ref(e) = t.column_value and e.xmldata.property.prop_number = elementID ;
       IF ( counter <> 0 ) THEN
           select sm.sys_nc_oid$ INTO modelID from xdb.xdb$element e, xdb.xdb$choice_model sm, table(sm.xmldata.elements)t where 
           ref(e) = t.column_value and e.xmldata.property.prop_number =  elementID ;
           choiceKid := TRUE;
       ELSE
          -- sequence
          select count(*) INTO counter from xdb.xdb$element e, xdb.xdb$sequence_model sm, 
          table(sm.xmldata.elements)t where ref(e) = t.column_value and e.xmldata.property.prop_number = elementID ;
          IF ( counter <> 0 ) THEN
            select sm.sys_nc_oid$ INTO modelID from xdb.xdb$element e, xdb.xdb$sequence_model sm, table(sm.xmldata.elements)t where 
            ref(e) = t.column_value and e.xmldata.property.prop_number =  elementID ;
            seqKid := TRUE;
          ELSE
            -- all
            select count(*) INTO counter from xdb.xdb$element e, xdb.xdb$all_model sm, 
            table(sm.xmldata.elements)t where ref(e) = t.column_value and e.xmldata.property.prop_number =  elementID ;
            IF ( counter <> 0 ) THEN
                select sm.sys_nc_oid$ INTO modelID from xdb.xdb$element e, xdb.xdb$all_model sm, table(sm.xmldata.elements)t where 
                ref(e) = t.column_value and e.xmldata.property.prop_number =  elementID ;
                allKid := TRUE;
            ELSE
               RETURN NULL;
            END IF;
        END IF;
       END IF;

       WHILE TRUE
       LOOP
            IF (seqKid = TRUE) THEN kidClause := 'sequence_kids';
            ELSIF (choiceKid = TRUE) THEN kidClause := 'choice_kids';
            ELSE RETURN getParentIDFromModelID(modelID);
            END IF;
           
            counter := 0;
            sqlStmtBase := 'table(sm.xmldata.' || kidClause || ')t where sys_op_r2o(t.column_value) = ';
            sqlStmtBase := sqlStmtBase ||  Dbms_Assert.Enquote_Literal(modelID);   
            sqlStmt := 'select count(*) from xdb.xdb$choice_model sm, ' || sqlStmtBase;
            EXECUTE IMMEDIATE sqlStmt INTO counter  ;
            IF (counter <> 0) THEN
              sqlStmt := 'select sm.sys_nc_oid$ from xdb.xdb$choice_model sm, ' || sqlStmtBase;
              EXECUTE IMMEDIATE sqlStmt INTO modelID ;
              choicekid := TRUE; seqKid := FALSE; allKid := FALSE;
            ELSE
              sqlStmt := 'select count(*)   from xdb.xdb$sequence_model sm, ' || sqlStmtBase;
              EXECUTE IMMEDIATE sqlStmt INTO counter;
              IF (counter <> 0) THEN
                 sqlStmt := 'select sm.sys_nc_oid$  from xdb.xdb$sequence_model sm, ' || sqlStmtBase;
                 EXECUTE IMMEDIATE sqlStmt INTO modelID ;
                 choicekid := FALSE; seqKid := TRUE; allKid := FALSE;
              ELSE
                 sqlStmt := 'select count(*)  from xdb.xdb$all_model sm, ' || sqlStmtBase;
                 EXECUTE IMMEDIATE sqlStmt INTO counter ;
                 IF (counter <> 0) THEN
                    sqlStmt := 'select sm.sys_nc_oid$   from xdb.xdb$all_model sm, ' || sqlStmtBase;
                    EXECUTE IMMEDIATE sqlStmt INTO modelID;
                    choicekid := FALSE; seqKid := FALSE; allKid := TRUE;
                 ELSE -- group
                    IF (seqKid = TRUE) THEN kidClause := 'sequence_kid';
                    ELSIF (choiceKid = TRUE) THEN kidClause := 'choice_kid';
                    ELSE kidClause := 'all_kid';
                    END IF;
                    sqlStmtBase := '  from xdb.xdb$group_def sm where sys_op_r2o(sm.xmldata. ' || kidClause || ') =';
                    sqlStmtBase := sqlStmtBase || Dbms_Assert.Enquote_Literal(modelID);
                    sqlStmt := 'select count(*) ' || sqlStmtBase;
                    EXECUTE IMMEDIATE sqlStmt INTO counter ;
                    IF (counter <> 0) THEN
                       sqlStmt := 'select sm.sys_nc_oid$ ' || sqlStmtBase;
                       EXECUTE IMMEDIATE sqlStmt INTO modelID;
                       RETURN getParentIDFromGroupID(modelID);
                    ELSE
                       RETURN getParentIDFromModelID(modelID);
                    END IF;
                 END IF;
              END IF;
           END IF;
       END LOOP;

    RETURN NULL;
    EXCEPTION
    WHEN OTHERS THEN
       RETURN NULL;
END;



  Function sizeArray ( elementID IN varchar2 )
       RETURN NUMBER
  IS
   p parentidarray;
  BEGIN
    p := PrvtParentChild.getparentID(elementID);
    IF (p IS NULL) THEN
       RETURN 0;
    ELSE
       RETURN p.count;
    END IF;
  END;
END;
/

/*
This view selects all the elements.
The properties of the element are selected from the xmldata properties.
The prop number assigned to the element is used as the unique 
identifier for the element. 
This unique identifier helps us to traverse the xml document.
The query is written as union of 4 separate queries. 
The first three queries helps to select 
the children whose content model is sequence/choice/all respectively. 
The final query helps to select the root elements.
To select the parent element id, a self join is made with the 
xdb$element table. For a particular element its type can be determined by the
using the type_ref column. Every complex type stores the content model of its
children which in turn stores the references of the child element. 
For each element, its parent element id is determined by joining it 
with the content model of the parent elements.
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
TYPE_NAME - name of the type of the element
GLOBAL - is 1 if the element is global else 0.
ELEMENT - the actual xml type of the element
SQL_INLINE - xdb annotation value for sqlInline
SQL_TYPE - xdb annotation value for sqlType
SQL_SCHEMA - xdb annotation value for sqlSchema
DEFAULT_TABLE - xdb annotation value for default table
SQL_NAME - xdb annotation value for sqlName
SQL_COL_TYPE - xdb annotation value for sqlColType
MAINTAIN_DOM - xdb annotation for maintain dom
MAINTAIN_ORDER - xdb annotation for maintain order
ELEMENT_ID - unique identifier for the element.
PARENT_ELEMENT_ID - identies the parent of the element
*/
create or replace view DBA_XML_SCHEMA_ELEMENTS
as
(select s.xmldata.schema_owner AS OWNER,
       s.xmldata.schema_url AS SCHEMA_URL,
       s.xmldata.target_namespace AS TARGET_NAMESPACE, 
       (case
          when e.xmldata.property.name IS NULL 
          then
             e.xmldata.property.propref_name.name 
          else
             e.xmldata.property.name 
          end
       )AS ELEMENT_NAME, 
       (case
          when e.xmldata.property.name IS NULL 
          then
              1
          else
             0
          end
       )AS IS_REF, 
       e.xmldata.property.typename.name AS TYPE_NAME,
       e.xmldata.property.global AS GLOBAL,
       value(e) AS ELEMENT,
       e.xmldata.sql_inline AS SQL_INLINE,
       e.xmldata.property.sqltype AS SQL_TYPE,
       e.xmldata.property.sqlschema AS SQL_SCHEMA,
       e.xmldata.default_table AS DEFAULT_TABLE,
       e.xmldata.property.sqlname AS SQL_NAME,
       e.xmldata.property.sqlcolltype AS SQL_COL_TYPE,
       e.xmldata.maintain_dom AS MAINTAIN_DOM,
       e.xmldata.maintain_order AS MAINTAIN_ORDER,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       t.column_value AS PARENT_ELEMENT_ID
  from xdb.xdb$schema s, xdb.xdb$element e,  table( PrvtParentChild.getParentID(e.xmldata.property.prop_number)) t
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$  and PrvtParentChild.sizeArray(e.xmldata.property.prop_number) <> 0
 UNION ALL
 select s.xmldata.schema_owner AS OWNER,
       s.xmldata.schema_url AS SCHEMA_URL,
       s.xmldata.target_namespace AS TARGET_NAMESPACE, 
       (case
          when e.xmldata.property.name IS NULL 
          then
             e.xmldata.property.propref_name.name 
          else
             e.xmldata.property.name 
          end
       )AS ELEMENT_NAME, 
       (case
          when e.xmldata.property.name IS NULL 
          then
              1
          else
             0
          end
       )AS IS_REF, 
       e.xmldata.property.typename.name AS TYPE_NAME,
       e.xmldata.property.global AS GLOBAL,
       value(e) AS ELEMENT,
       e.xmldata.sql_inline AS SQL_INLINE,
       e.xmldata.property.sqltype AS SQL_TYPE,
       e.xmldata.property.sqlschema AS SQL_SCHEMA,
       e.xmldata.default_table AS DEFAULT_TABLE,
       e.xmldata.property.sqlname AS SQL_NAME,
       e.xmldata.property.sqlcolltype AS SQL_COL_TYPE,
       e.xmldata.maintain_dom AS MAINTAIN_DOM,
       e.xmldata.maintain_order AS MAINTAIN_ORDER,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       NULL AS PARENT_ELEMENT_ID
  from xdb.xdb$schema s, xdb.xdb$element e
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$
 and PrvtParentChild.sizeArray(e.xmldata.property.prop_number) = 0
) 
/

grant select on DBA_XML_SCHEMA_ELEMENTS to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_ELEMENTS for DBA_XML_SCHEMA_ELEMENTS
/

/*
This view selects all the elements accessible to the current user.
The properties of the element are selected from the xmldata properties.
The prop number assigned to the element is used as the unique identifier 
for the element. 
This unique identifier helps us to traverse the xml document.
The query is written as union of 4 separate queries. 
The first three queries helps to select the children whose content model is 
sequence/choice/all respectively. 
The final query helps to select the root elements.
To select the parent element id, a self join is made with the 
xdb$element table.For a particular element its type can be determined by the
using the type_ref column. Every complex type stores the content model of its 
children which in turn stores the references of the child element. 
For each element, its parent element id is determined by joining it with 
the content model of the parent elements.
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
TYPE_NAME - name of the type of the element
GLOBAL - is 1 if the element is global else 0.
ELEMENT - the actual xml type of the element
SQL_INLINE - xdb annotation value for sqlInline
SQL_TYPE - xdb annotation value for sqlType
SQL_SCHEMA - xdb annotation value for sqlSchema
DEFAULT_TABLE - xdb annotation value for default table
SQL_NAME - xdb annotation value for sqlName
SQL_COL_TYPE - xdb annotation value for sqlColType
MAINTAIN_DOM - xdb annotation for maintain dom
MAINTAIN_ORDER - xdb annotation for maintain order
ELEMENT_ID - unique identifier for the element.
PARENT_ELEMENT_ID - identies the parent of the element
*/
create or replace view ALL_XML_SCHEMA_ELEMENTS
as
(select s.xmldata.schema_owner AS OWNER,
       s.xmldata.schema_url AS SCHEMA_URL,
       s.xmldata.target_namespace AS TARGET_NAMESPACE, 
       (case
          when e.xmldata.property.name IS NULL 
          then
             e.xmldata.property.propref_name.name 
          else
             e.xmldata.property.name 
          end
       )AS ELEMENT_NAME, 
       (case
          when e.xmldata.property.name IS NULL 
          then
              1
          else
             0
          end
       )AS IS_REF, 
       e.xmldata.property.typename.name AS TYPE_NAME,
       e.xmldata.property.global AS GLOBAL,
       value(e) AS ELEMENT,
       e.xmldata.sql_inline AS SQL_INLINE,
       e.xmldata.property.sqltype AS SQL_TYPE,
       e.xmldata.property.sqlschema AS SQL_SCHEMA,
       e.xmldata.default_table AS DEFAULT_TABLE,
       e.xmldata.property.sqlname AS SQL_NAME,
       e.xmldata.property.sqlcolltype AS SQL_COL_TYPE,
       e.xmldata.maintain_dom AS MAINTAIN_DOM,
       e.xmldata.maintain_order AS MAINTAIN_ORDER,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       t.column_value AS PARENT_ELEMENT_ID
  from xdb.xdb$schema s, xdb.xdb$element e, all_xml_schemas a, 
       table( PrvtParentChild.getParentID(e.xmldata.property.prop_number)) t
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$ and
       s.xmldata.schema_owner = a.owner and 
       s.xmldata.schema_url = a.schema_url and
       PrvtParentChild.sizeArray(e.xmldata.property.prop_number) <> 0
UNION ALL
select s.xmldata.schema_owner AS OWNER,
       s.xmldata.schema_url AS SCHEMA_URL,
       s.xmldata.target_namespace AS TARGET_NAMESPACE, 
       (case
          when e.xmldata.property.name IS NULL 
          then
             e.xmldata.property.propref_name.name 
          else
             e.xmldata.property.name 
          end
       )AS ELEMENT_NAME, 
       (case
          when e.xmldata.property.name IS NULL 
          then
              1
          else
             0
          end
       )AS IS_REF, 
       e.xmldata.property.typename.name AS TYPE_NAME,
       e.xmldata.property.global AS GLOBAL,
       value(e) AS ELEMENT,
       e.xmldata.sql_inline AS SQL_INLINE,
       e.xmldata.property.sqltype AS SQL_TYPE,
       e.xmldata.property.sqlschema AS SQL_SCHEMA,
       e.xmldata.default_table AS DEFAULT_TABLE,
       e.xmldata.property.sqlname AS SQL_NAME,
       e.xmldata.property.sqlcolltype AS SQL_COL_TYPE,
       e.xmldata.maintain_dom AS MAINTAIN_DOM,
       e.xmldata.maintain_order AS MAINTAIN_ORDER,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       NULL AS PARENT_ELEMENT_ID
  from xdb.xdb$schema s, xdb.xdb$element e, all_xml_schemas a
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$ and
       s.xmldata.schema_owner = a.owner and 
       s.xmldata.schema_url = a.schema_url and
       PrvtParentChild.sizeArray(e.xmldata.property.prop_number) = 0
) 
/
grant select on ALL_XML_SCHEMA_ELEMENTS to public
/
create or replace public synonym ALL_XML_SCHEMA_ELEMENTS for ALL_XML_SCHEMA_ELEMENTS
/


/*
This view selects all the  elements for the current user
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
TYPE_NAME - name of the type of the element
GLOBAL - is 1 if the element is global else 0.
ELEMENT - the actual xml type of the element
SQL_INLINE - xdb annotation value for sqlInline
SQL_TYPE - xdb annotation value for sqlType
SQL_SCHEMA - xdb annotation value for sqlSchema
DEFAULT_TABLE - xdb annotation value for default table
SQL_NAME - xdb annotation value for sqlName
SQL_COL_TYPE - xdb annotation value for sqlColType
MAINTAIN_DOM - xdb annotation for maintain dom
MAINTAIN_ORDER - xdb annotation for maintain order
ELEMENT_ID - unique identifier for the element.
PARENT_ELEMENT_ID - identies the parent of the element
*/
create or replace view USER_XML_SCHEMA_ELEMENTS
as
select SCHEMA_URL, TARGET_NAMESPACE, ELEMENT_NAME,IS_REF, TYPE_NAME, GLOBAL, 
       ELEMENT, SQL_INLINE,SQL_TYPE, SQL_SCHEMA, DEFAULT_TABLE, SQL_NAME, 
SQL_COL_TYPE,MAINTAIN_DOM,MAINTAIN_ORDER,ELEMENT_ID,PARENT_ELEMENT_ID
  from DBA_XML_SCHEMA_ELEMENTS
 where OWNER = USER
/
grant select on USER_XML_SCHEMA_ELEMENTS to public
/
create or replace public synonym USER_XML_SCHEMA_ELEMENTS for USER_XML_SCHEMA_ELEMENTS 
/


/*
This view selects all members of the substitution group
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
HEAD_OWNER - the user who owns the head element for the current element
HEAD_SCHEMA_URL - the url of schema within which the head element exists
HEAD_TARGET_NAMESPACE - the namespace of the head element
HEAD_ELEMENT_NAME - name of the head element
HEAD_ELEMENT - the actual xml type of the head element
*/
create or replace view DBA_XML_SCHEMA_SUBSTGRP_MBRS
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       e.xmldata.property.name ELEMENT_NAME, 
       value(e) ELEMENT,
       hs.xmldata.schema_owner HEAD_OWNER,
       hs.xmldata.schema_url HEAD_SCHEMA_URL,
       hs.xmldata.target_namespace HEAD_TARGET_NAMESPACE, 
       he.xmldata.property.name HEAD_ELEMENT_NAME, 
       value(he) HEAD_ELEMENT
  from xdb.xdb$schema s, xdb.xdb$schema hs, xdb.xdb$element e, 
       xdb.xdb$element he
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$
   and e.xmldata.property.global = hexToRaw('01')
   and he.sys_nc_oid$ = sys_op_r2o(e.xmldata.HEAD_ELEM_REF)
   and sys_op_r2o(he.xmldata.property.parent_schema) = hs.sys_nc_oid$;
/
grant select on DBA_XML_SCHEMA_SUBSTGRP_MBRS to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_SUBSTGRP_MBRS 
    for DBA_XML_SCHEMA_SUBSTGRP_MBRS
/

/*
This view selects all members of the substitution group 
accessible to the current user
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
HEAD_OWNER - the user who owns the head element for the current element
HEAD_SCHEMA_URL - the url of schema within which the head element exists
HEAD_TARGET_NAMESPACE - the namespace of the head element
HEAD_ELEMENT_NAME - name of the head element
HEAD_ELEMENT - the actual xml type of the head element
*/
create or replace view ALL_XML_SCHEMA_SUBSTGRP_MBRS
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       e.xmldata.property.name ELEMENT_NAME, 
       value(e) ELEMENT,
       hs.xmldata.schema_owner HEAD_OWNER,
       hs.xmldata.schema_url HEAD_SCHEMA_URL,
       hs.xmldata.target_namespace HEAD_TARGET_NAMESPACE, 
       he.xmldata.property.name HEAD_ELEMENT_NAME, 
       value(he) HEAD_ELEMENT
  from xdb.xdb$schema s, xdb.xdb$schema hs, xdb.xdb$element e, 
       xdb.xdb$element he, 
all_xml_schemas a
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$
   and s.xmldata.schema_owner = a.owner 
   and s.xmldata.schema_url = a.schema_url
   and e.xmldata.property.global = hexToRaw('01')
   and he.sys_nc_oid$ = sys_op_r2o(e.xmldata.HEAD_ELEM_REF)
   and sys_op_r2o(he.xmldata.property.parent_schema) = hs.sys_nc_oid$;
/
grant select on ALL_XML_SCHEMA_SUBSTGRP_MBRS to public
/
create or replace public synonym ALL_XML_SCHEMA_SUBSTGRP_MBRS 
    for ALL_XML_SCHEMA_SUBSTGRP_MBRS
/


/*
This view selects all members of the substitution group for the current user
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
HEAD_OWNER - the user who owns the head element for the current element
HEAD_SCHEMA_URL - the url of schema within which the head element exists
HEAD_TARGET_NAMESPACE - the namespace of the head element
HEAD_ELEMENT_NAME - name of the head element
HEAD_ELEMENT - the actual xml type of the head element
*/
create or replace view USER_XML_SCHEMA_SUBSTGRP_MBRS
as
select SCHEMA_URL, TARGET_NAMESPACE, ELEMENT_NAME, ELEMENT, HEAD_OWNER, 
       HEAD_SCHEMA_URL, HEAD_TARGET_NAMESPACE, HEAD_ELEMENT_NAME, 
       HEAD_ELEMENT
  from DBA_XML_SCHEMA_SUBSTGRP_MBRS
  where OWNER = USER  
/
grant select on USER_XML_SCHEMA_SUBSTGRP_MBRS to public
/
create or replace public synonym USER_XML_SCHEMA_SUBSTGRP_MBRS 
    for USER_XML_SCHEMA_SUBSTGRP_MBRS
/

/*
This view selects the heads of all the substitution groups
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
*/
create or replace view DBA_XML_SCHEMA_SUBSTGRP_HEAD
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       e.xmldata.property.name ELEMENT_NAME, 
       value(e) ELEMENT
  from xdb.xdb$schema s, xdb.xdb$element e
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$
   and e.xmldata.property.global = hexToRaw('01')
   and ref(e) in ( select distinct se.xmldata.HEAD_ELEM_REF 
 from xdb.xdb$element se where 
se.xmldata.HEAD_ELEM_REF is not null)
/
grant select on DBA_XML_SCHEMA_SUBSTGRP_HEAD to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_SUBSTGRP_HEAD 
    for DBA_XML_SCHEMA_SUBSTGRP_HEAD
/

/*
This view selects the heads of all the substitution groups 
accessible to the current user
OWNER - the user who owns the element
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
*/
create or replace view ALL_XML_SCHEMA_SUBSTGRP_HEAD
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       e.xmldata.property.name ELEMENT_NAME, 
       value(e) ELEMENT
  from xdb.xdb$schema s, xdb.xdb$element e, all_xml_schemas a
 where sys_op_r2o(e.xmldata.property.parent_schema) = s.sys_nc_oid$
   and s.xmldata.schema_owner = a.owner 
   and s.xmldata.schema_url = a.schema_url
   and e.xmldata.property.global = hexToRaw('01')
   and e.sys_nc_oid$ in ( select distinct sys_op_r2o
                         (se.xmldata.HEAD_ELEM_REF)
                          from xdb.xdb$element se 
                          where  se.xmldata.HEAD_ELEM_REF is not null)
/
grant select on ALL_XML_SCHEMA_SUBSTGRP_HEAD to public
/
create or replace public synonym ALL_XML_SCHEMA_SUBSTGRP_HEAD 
    for ALL_XML_SCHEMA_SUBSTGRP_HEAD
/

/*
This view selects the heads of all the substitution groups 
for the current user
XML_SCHEMA_URL - the url of schema within which the element exists
TARGET_NAMESPACE - the namespace of the element
ELEMENT_NAME - name of the element
ELEMENT - the actual xml type of the element
*/
create or replace view USER_XML_SCHEMA_SUBSTGRP_HEAD
as
select SCHEMA_URL, TARGET_NAMESPACE, ELEMENT_NAME, ELEMENT
  from DBA_XML_SCHEMA_SUBSTGRP_HEAD
  where OWNER = USER  
/
grant select on USER_XML_SCHEMA_SUBSTGRP_HEAD to public
/
create or replace public synonym USER_XML_SCHEMA_SUBSTGRP_HEAD 
    for USER_XML_SCHEMA_SUBSTGRP_HEAD
/

/*
This view selects all complex type.
The properties are derived from xmldata properties. 
The xdb annotations for the complex type are derived from the
complex type using xpath. The base type for the element can be 
either NULL/Complex Type/Simple Type. The case 
expression is used to select the appropriate value for the same.
OWNER - the user who owns the type
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
COMPLEX_TYPE_NAME - name of the complex type
COMPLEX_TYPE - the actual xmltype of the type
BASE_NAME - Name of the base type to which the complex type refers
MAINTAIN_DOM - xdb annotation for maintainDOM
MAINTAIN_ORDER - xdb annotation for maintainOrder
SQL_TYPE - xdb annotation for sqlType
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/
create or replace view DBA_XML_SCHEMA_COMPLEX_TYPES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       ct.xmldata.name COMPLEX_TYPE_NAME, 
       value(ct) COMPLEX_TYPE,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select st.xmldata.name 
                  from  xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st)  ) 
        else
                ( select ctb.xmldata.name 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb)  )   
        end ) BASE_NAME,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select s.xmldata.schema_url 
                  from  xdb.xdb$simple_type st, xdb.xdb$schema s 
                  where ct.xmldata.BASE_TYPE = ref(st)  
                  and sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$) 
        else
                ( select s.xmldata.schema_url 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb,
                       xdb.xdb$schema s 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb) and
                        sys_op_r2o(ctb.xmldata.parent_schema)  = s.sys_nc_oid$ )   
        end ) BASE_SCHEMA_URL,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select s.xmldata.target_namespace 
                  from  xdb.xdb$simple_type st, xdb.xdb$schema s 
                  where ct.xmldata.BASE_TYPE = ref(st)  
                  and sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$) 
        else
                ( select s.xmldata.target_namespace 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb,
                       xdb.xdb$schema s 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb) and
                        sys_op_r2o(ctb.xmldata.parent_schema)  = s.sys_nc_oid$ )   
        end ) BASE_TARGET_NAMESPACE,
       ct.xmldata.maintain_dom MAINTAIN_DOM,
       ct.xmldata.sqltype SQL_TYPE,
       ct.xmldata.SQLSCHEMA SQL_SCHEMA
  from xdb.xdb$schema s, xdb.xdb$complex_type ct
 where sys_op_r2o(ct.xmldata.parent_schema)  = s.sys_nc_oid$
/
grant select on DBA_XML_SCHEMA_COMPLEX_TYPES to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_COMPLEX_TYPES 
    for DBA_XML_SCHEMA_COMPLEX_TYPES
/

/*
This view selects all complex type accessible to the current user.
The properties are derived from xmldata properties. 
The xdb annotations for the complex type 
are derived from the complex type using xpath.
The base type for the element can be either NULL/Complex Type/Simple Type.
The case expression is used to select the appropriate value for the same.
OWNER - the user who owns the type
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
COMPLEX_TYPE_NAME - name of the complex type
COMPLEX_TYPE - the actual xmltype of the type
BASE_NAME - Name of the base type to which the complex type refers
MAINTAIN_DOM - xdb annotation for maintainDOM
MAINTAIN_ORDER - xdb annotation for maintainOrder
SQL_TYPE - xdb annotation for sqlType
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/
create or replace view ALL_XML_SCHEMA_COMPLEX_TYPES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       ct.xmldata.name COMPLEX_TYPE_NAME, 
       value(ct) COMPLEX_TYPE,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select st.xmldata.name 
                  from  xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st)  ) 
        else
                ( select ctb.xmldata.name 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb)  )   
        end ) BASE_NAME,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select s.xmldata.schema_url 
                  from  xdb.xdb$simple_type st, xdb.xdb$schema s 
                  where ct.xmldata.BASE_TYPE = ref(st)  
                  and sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$) 
        else
                ( select s.xmldata.schema_url 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb,
                       xdb.xdb$schema s 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb) and
                        sys_op_r2o(ctb.xmldata.parent_schema)  = s.sys_nc_oid$ )   
        end ) BASE_SCHEMA_URL,
        (case 
        when 
                ct.xmldata.BASE_TYPE IS NULL then NULL 
        when 
                ( select count(1) 
                  from xdb.xdb$simple_type st 
                  where ct.xmldata.BASE_TYPE = ref(st) ) != 0
        then
                ( select s.xmldata.target_namespace 
                  from  xdb.xdb$simple_type st, xdb.xdb$schema s 
                  where ct.xmldata.BASE_TYPE = ref(st)  
                  and sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$) 
        else
                ( select s.xmldata.target_namespace 
                  from xdb.xdb$complex_type ctm, 
                       xdb.xdb$complex_type ctb,
                       xdb.xdb$schema s 
                  where ref(ct)  = ref(ctm) 
                        and ctm.xmldata.BASE_TYPE = ref(ctb) and
                        sys_op_r2o(ctb.xmldata.parent_schema)  = s.sys_nc_oid$ )   
        end ) BASE_TARGET_NAMESPACE,
       ct.xmldata.maintain_dom MAINTAIN_DOM,
       ct.xmldata.sqltype SQL_TYPE,
       ct.xmldata.SQLSCHEMA SQL_SCHEMA
  from xdb.xdb$schema s, xdb.xdb$complex_type ct,all_xml_schemas a
 where sys_op_r2o(ct.xmldata.parent_schema)  = s.sys_nc_oid$ and
       s.xmldata.schema_owner = a.owner and
       s.xmldata.schema_url = a.schema_url
/
grant select on ALL_XML_SCHEMA_COMPLEX_TYPES to public
/
create or replace public synonym ALL_XML_SCHEMA_COMPLEX_TYPES 
    for ALL_XML_SCHEMA_COMPLEX_TYPES
/

/*
This view selects all complex type for the current user
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
COMPLEX_TYPE_NAME - name of the complex type
COMPLEX_TYPE - the actual xmltype of the type
BASE_NAME - Name of the base type to which the complex type refers
MAINTAIN_DOM - xdb annotation for maintainDOM
MAINTAIN_ORDER - xdb annotation for maintainOrder
SQL_TYPE - xdb annotation for sqlType
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/
create or replace view USER_XML_SCHEMA_COMPLEX_TYPES
as
select SCHEMA_URL, TARGET_NAMESPACE, COMPLEX_TYPE_NAME, COMPLEX_TYPE,
       BASE_NAME, BASE_SCHEMA_URL, BASE_TARGET_NAMESPACE, MAINTAIN_DOM, SQL_TYPE, SQL_SCHEMA
  from DBA_XML_SCHEMA_COMPLEX_TYPES
  where OWNER = USER 
/
grant select on USER_XML_SCHEMA_COMPLEX_TYPES to public
/
create or replace public synonym USER_XML_SCHEMA_COMPLEX_TYPES 
    for USER_XML_SCHEMA_COMPLEX_TYPES
/

/*
This view selects all simple type.
The properties of the simple element are derived from xmldata properties.
The xdb annotations are derived from the simple type using xpath.
OWNER - the user who owns the type
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
SIMPLE_TYPE_NAME - name of the simple type
SIMPLE_TYPE - the actual xmltype of the type
MAINTAIN_DOM - xdb annotation for maintainDOM
SQL_TYPE - xdb annotation for sqlType (not available on 10.2)
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/

/* NOTE, For 10.2: View does not contain the column SQLTYPE.*/
DECLARE 
  stmt VARCHAR2(4000);
BEGIN
 
  stmt := '
  create or replace view DBA_XML_SCHEMA_SIMPLE_TYPES
  as
  select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       st.xmldata.name SIMPLE_TYPE_NAME, 
       value(st) SIMPLE_TYPE
    from xdb.xdb$schema s, xdb.xdb$simple_type st
   where sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$';
   
   execute immediate (stmt);
   exception when others then raise;


END;
/

grant select on DBA_XML_SCHEMA_SIMPLE_TYPES to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_SIMPLE_TYPES 
    for DBA_XML_SCHEMA_SIMPLE_TYPES
/




/*
This view selects all simple type accessible to the current user.
The properties of the simple element are derived from xmldata properties.
The xdb annotations are derived from the simple type using xpath.
OWNER - the user who owns the type
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
SIMPLE_TYPE_NAME - name of the simple type
SIMPLE_TYPE - the actual xmltype of the type
MAINTAIN_DOM - xdb annotation for maintainDOM
SQL_TYPE - xdb annotation for sqlType
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/

/* NOTE, For 10.2: View does not contain the column SQLTYPE.*/
DECLARE 
  stmt VARCHAR2(4000);
BEGIN
  
   stmt := '
  create or replace view ALL_XML_SCHEMA_SIMPLE_TYPES
  as
   select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       st.xmldata.name SIMPLE_TYPE_NAME, 
       value(st) SIMPLE_TYPE
    from xdb.xdb$schema s, xdb.xdb$simple_type st, all_xml_schemas a
   where sys_op_r2o(st.xmldata.parent_schema)  = s.sys_nc_oid$ and
       s.xmldata.schema_owner = a.owner and
       s.xmldata.schema_url = a.schema_url';

   execute immediate (stmt);
   exception when others then raise;


END;
/


grant select on ALL_XML_SCHEMA_SIMPLE_TYPES to public
/
create or replace public synonym ALL_XML_SCHEMA_SIMPLE_TYPES 
    for ALL_XML_SCHEMA_SIMPLE_TYPES
/



/*
This view selects all simple type for current user
XML_SCHEMA_URL - the url of schema within which the type exists
TARGET_NAMESPACE - the namespace of the type
SIMPLE_TYPE_NAME - name of the simple type
SIMPLE_TYPE - the actual xmltype of the type
MAINTAIN_DOM - xdb annotation for maintainDOM
SQL_TYPE - xdb annotation for sqlType
SQL_SCHEMA - xdb annotation for sqlSchema
DEFAULT_TABLE - xdb annotation for defaultTable
SQL_NAME - xdb annotation for sqlName
SQL_COL_TYPE - xdb annotation for sqlColType
STORE_VARRAY_AS_TABLE - xdb annotation for storeVarrayAsTable
*/

/* NOTE, For 10.2: View does not contain the column SQLTYPE.*/

DECLARE 
  stmt VARCHAR2(4000);
BEGIN
 
    stmt := '
     create or replace view USER_XML_SCHEMA_SIMPLE_TYPES
     as
     select SCHEMA_URL, TARGET_NAMESPACE, SIMPLE_TYPE_NAME, SIMPLE_TYPE
     from DBA_XML_SCHEMA_SIMPLE_TYPES
     where OWNER = USER';

  execute immediate (stmt);
  exception when others then raise;


END;
/

grant select on USER_XML_SCHEMA_SIMPLE_TYPES to public
/
create or replace public synonym USER_XML_SCHEMA_SIMPLE_TYPES 
    for USER_XML_SCHEMA_SIMPLE_TYPES
/


/*
This view selects all the  attributes. 
The properties are derived from xmldata properties. 
The element id is the unique identifier used to identify 
the element to which the attribute belongs. The element id relates to the 
dba_user_elements. This helps in traversing the xml document.
OWNER - the user who owns the attribute
XML_SCHEMA_URL - the url of schema within which the attribute exists
TARGET_NAMESPACE - the namespace of the attribute
ATTRIBUTE_NAME - name of the attribute
TYPE_NAME - name of type of the attribute
GLOBAL - is 1 if attribute is global else 0.
ATTRIBUTE - actual xmltype for the attribute
ELEMENT_ID - element id of the element to which the attribute belongs
*/
create or replace view DBA_XML_SCHEMA_ATTRIBUTES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.simplecont.restriction.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.simplecont.extension.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
             ( select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       NULL AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
   from xdb.xdb$schema s, xdb.xdb$attribute a 
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       ( 
         (
	   ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t)
           AND
           ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.extension.attributes)t)
           AND
           ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.restriction.attributes)t)
	 )
         OR
         (
           (
             ref(a)  IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t)
             OR
             ref(a) IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.extension.attributes)t)
             OR
             ref(a) IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.restriction.attributes)t)
           )
           and (select ref(ct) from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t,table(ct.xmldata.simplecont.extension.attributes)t1,table(ct.xmldata.simplecont.restriction.attributes)t2 where
	     ref(a)  = t.column_value
             OR
             ref(a) = t1.column_value
             OR
             ref(a) = t2.column_value
	   ) NOT IN ( select e.xmldata.property.type_ref from xdb.xdb$element e)
         )
       )
/
grant select on DBA_XML_SCHEMA_ATTRIBUTES to select_catalog_role
/
create or replace public synonym DBA_XML_SCHEMA_ATTRIBUTES for DBA_XML_SCHEMA_ATTRIBUTES
/

/*
This view selects all the  attributes accessible to the current user. 
The properties are derived from xmldata properties. 
The element id is the unique identifier used to identify the element 
to which the attribute belongs. The element id relates to the 
dba_user_elements. This helps in traversing the xml document.
OWNER - the user who owns the attribute
XML_SCHEMA_URL - the url of schema within which the attribute exists
TARGET_NAMESPACE - the namespace of the attribute
ATTRIBUTE_NAME - name of the attribute
TYPE_NAME - name of type of the attribute
GLOBAL - is 1 if attribute is global else 0.
ATTRIBUTE - actual xmltype for the attribute
ELEMENT_ID - element id of the element to which the attribute belongs
*/
create or replace view ALL_XML_SCHEMA_ATTRIBUTES
as
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a,  all_xml_schemas al, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       s.xmldata.schema_owner = al.owner and
       s.xmldata.schema_url = al.schema_url and
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a,  all_xml_schemas al, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.simplecont.restriction.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       s.xmldata.schema_owner = al.owner and
       s.xmldata.schema_url = al.schema_url and
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       hextoraw(e.xmldata.property.prop_number) AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
  from xdb.xdb$schema s, xdb.xdb$attribute a,  all_xml_schemas al, 
       xdb.xdb$element e, xdb.xdb$complex_type ct, 
       table(ct.xmldata.simplecont.extension.attributes) att
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       s.xmldata.schema_owner = al.owner and
       s.xmldata.schema_url = al.schema_url and
       ref(ct) = e.xmldata.property.type_ref and
       att.column_value = ref(a)
UNION ALL
select s.xmldata.schema_owner OWNER,
       s.xmldata.schema_url SCHEMA_URL,
       s.xmldata.target_namespace TARGET_NAMESPACE, 
       (case
          when a.xmldata.name IS NULL 
          then
             a.xmldata.propref_name.name 
          else
             a.xmldata.name 
          end
       )AS ATTRIBUTE_NAME, 
       (case
          when a.xmldata.name IS NULL 
          then
             1
          else
             0
          end
       )AS IS_REF, 
       (case
          when a.xmldata.typename.name IS NULL 
          then
              (select a1.xmldata.typename.name from xdb.xdb$attribute a1 where ref(a1)=a.xmldata.propref_ref)
          else
             a.xmldata.typename.name 
          end
       )AS TYPE_NAME,
       a.xmldata.global GLOBAL,
       value(a) ATTRIBUTE,
       NULL AS ELEMENT_ID,
       a.xmldata.sqltype AS SQL_TYPE, 
       a.xmldata.sqlname AS SQL_NAME
   from xdb.xdb$schema s, xdb.xdb$attribute a,  all_xml_schemas al 
 where  sys_op_r2o(a.xmldata.parent_schema) = s.sys_nc_oid$ and 
       s.xmldata.schema_owner = al.owner and
       s.xmldata.schema_url = al.schema_url and
       ( 
         (
	   ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t)
           AND
           ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.extension.attributes)t)
           AND
           ref(a) NOT IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.restriction.attributes)t)
	 )
         OR
         (
           (
             ref(a)  IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t)
             OR
             ref(a) IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.extension.attributes)t)
             OR
             ref(a) IN (select t.column_value from xdb.xdb$complex_type ct,table(ct.xmldata.simplecont.restriction.attributes)t)
           )
           and (select ref(ct) from xdb.xdb$complex_type ct,table(ct.xmldata.attributes)t,table(ct.xmldata.simplecont.extension.attributes)t1,table(ct.xmldata.simplecont.restriction.attributes)t2 where
	     ref(a)  = t.column_value
             OR
             ref(a) = t1.column_value
             OR
             ref(a) = t2.column_value
	   ) NOT IN ( select e.xmldata.property.type_ref from xdb.xdb$element e)
         )
       )
/
grant select on ALL_XML_SCHEMA_ATTRIBUTES to public
/
create or replace public synonym ALL_XML_SCHEMA_ATTRIBUTES for ALL_XML_SCHEMA_ATTRIBUTES
/

/*
This view selects all the attributes for the current user
XML_SCHEMA_URL - the url of schema within which the attribute exists
TARGET_NAMESPACE - the namespace of the attribute
ATTRIBUTE_NAME - name of the attribute
TYPE_NAME - name of type of the attribute
GLOBAL - is 1 if attribute is global else 0.
ATTRIBUTE - actual xmltype for the attribute
ELEMENT_ID - element id of the element to which the attribute belongs
*/
create or replace view USER_XML_SCHEMA_ATTRIBUTES
as
select SCHEMA_URL, TARGET_NAMESPACE, ATTRIBUTE_NAME, IS_REF,TYPE_NAME, 
       GLOBAL,ATTRIBUTE, ELEMENT_ID, SQL_TYPE, SQL_NAME
from DBA_XML_SCHEMA_ATTRIBUTES
 where OWNER = USER
/
grant select on USER_XML_SCHEMA_ATTRIBUTES to public
/
create or replace public synonym USER_XML_SCHEMA_ATTRIBUTES for USER_XML_SCHEMA_ATTRIBUTES
/

/*
This view gives all the out of line tables connected to a 
given root table for the same schema.
--Note, this will give the root_table also as a part of table_name.
ROOT_TABLE_NAME  Name of the root table
ROOT_TABLE_OWNER  Owner of the root table.
TABLE_NAME  Name of out of line table.
TABLE_OWNER  Owner of the out of line table.
*/

create or replace view DBA_XML_OUT_OF_LINE_TABLES
as
select d.xmlschema as SCHEMA_URL, --schema URL  
       d.schema_owner as SCHEMA_OWNER,  --schema owner 
       d.table_name as TABLE_NAME, --out of line table name 
       d.owner as TABLE_OWNER --out of line table owner
from   DBA_XML_TABLES d, sys.obj$ o, sys.opqtype$ op, sys.user$ u
where
o.owner# = u.user# and
d.table_name = o.name and
d.owner = u.name and
o.obj# = op.obj# and
bitand(op.flags,32) = 32
/
grant select on DBA_XML_OUT_OF_LINE_TABLES  to select_catalog_role
/
create or replace public synonym DBA_XML_OUT_OF_LINE_TABLES 
    for DBA_XML_OUT_OF_LINE_TABLES
/

/*
This view gives all the out of line tables connected to a 
given root table for the same schema.
--Note, this will give the root_table also as a part of table_name.
ROOT_TABLE_NAME  Name of the root table
ROOT_TABLE_OWNER  Owner of the root table.
TABLE_NAME  Name of out of line table.
TABLE_OWNER  Owner of the out of line table.
*/
create or replace view ALL_XML_OUT_OF_LINE_TABLES
as
select d.xmlschema as SCHEMA_URL, --schema URL  
       d.schema_owner as SCHEMA_OWNER,  --schema owner 
       d.table_name as TABLE_NAME, --out of line table name 
       d.owner as TABLE_OWNER --out of line table owner
from   ALL_XML_TABLES d, sys.obj$ o, sys.opqtype$ op, sys.user$ u
where
o.owner# = u.user# and
d.table_name = o.name and
d.owner = u.name and
o.obj# = op.obj# and
bitand(op.flags,32) = 32
/

grant select on ALL_XML_OUT_OF_LINE_TABLES  to public
/
create or replace public synonym ALL_XML_OUT_OF_LINE_TABLES 
    for ALL_XML_OUT_OF_LINE_TABLES
/ 

/*
This view gives all the out of line tables connected to a given 
root table for the same schema where table owner is the current user.
ROOT_TABLE_NAME  Name of the root table
ROOT_TABLE_OWNER  Owner of the root table.
TABLE_NAME  Name of out of line table.
*/
create or replace view USER_XML_OUT_OF_LINE_TABLES
as
select SCHEMA_URL, --schema URL  
       SCHEMA_OWNER,  --schema owner 
       TABLE_NAME --out of line table name 
from DBA_XML_OUT_OF_LINE_TABLES
where
TABLE_OWNER = USER
/
grant select on USER_XML_OUT_OF_LINE_TABLES  to public
/
create or replace public synonym USER_XML_OUT_OF_LINE_TABLES 
    for USER_XML_OUT_OF_LINE_TABLES
/

-- this view gets all the xmltype columns for all the relational tables

--we only allow users owning the schema & tables to enable/disable
--indexes in them. So, the definition for ALL_XMLTYPE_COLS below holds good.
create or replace view DBA_XMLTYPE_COLS
as
(select s.sys_nc_oid$ as SCHEMA_ID,
       s.xmldata.schema_url as SCHEMA_URL, --schema URL for the column
       c.name as COL_NAME,  --name of the relational column
       (select c1.name from sys.col$ c1 where c1.intcol# = op.objcol and
        c1.obj# = op.obj#) QUALIFIED_COL_NAME,
       o.name as TABLE_NAME, --name of the parent table
       u.name as TABLE_OWNER --parent table owner
from xdb.xdb$schema s, sys.opqtype$ op, sys.col$ c, sys.obj$ o, sys.user$ u, dba_tables a
where o.type# = 2 and
o.obj# = op.obj# and
o.obj# = c.obj# and
op.schemaoid = s.sys_nc_oid$ and
o.owner# = u.user# and
c.intcol# = op.intcol# and
o.name = a.table_name and
u.name = a.owner
UNION
  select NULL as SCHEMA_ID,
       NULL as SCHEMA_URL, --schema URL for the column
       c.name as COL_NAME,  --name of the relational column
       (select c1.name from sys.col$ c1 where c1.intcol# = op.objcol and
        c1.obj# = op.obj#) QUALIFIED_COL_NAME,
       o.name as TABLE_NAME, --name of the parent table
       u.name as TABLE_OWNER --parent table owner
from  sys.opqtype$ op, sys.col$ c, sys.obj$ o, sys.user$ u, dba_tables a
where o.type# = 2 and
o.obj# = op.obj# and
o.obj# = c.obj# and
c.intcol# = op.intcol# and
o.owner# = u.user# and
o.name = a.table_name and
u.name = a.owner and
op.schemaoid IS NULL);
/

grant select on  DBA_XMLTYPE_COLS to select_catalog_role
/
create or replace public synonym  DBA_XMLTYPE_COLS for  DBA_XMLTYPE_COLS
/


create or replace view ALL_XMLTYPE_COLS
as
((select s.sys_nc_oid$ as SCHEMA_ID,
       s.xmldata.schema_url as SCHEMA_URL, --schema URL for the column
       c.name as COL_NAME,  --name of the relational column
       (select c1.name from sys.col$ c1 where c1.intcol# = op.objcol and
        c1.obj# = op.obj#) QUALIFIED_COL_NAME,
       o.name as TABLE_NAME, --name of the parent table
       u.name as TABLE_OWNER --parent table owner
from xdb.xdb$schema s, sys.opqtype$ op, sys.col$ c, sys.obj$ o, sys.user$ u,
     all_tables a
where o.type# = 2 and
o.obj# = op.obj# and
o.obj# = c.obj# and
op.schemaoid = s.sys_nc_oid$ and
o.owner# = u.user# and
c.intcol# = op.intcol# and
o.name = a.table_name and
u.name = a.owner)
UNION
(select NULL as SCHEMA_ID,
       NULL as SCHEMA_URL, --schema URL for the column
       c.name as COL_NAME,  --name of the relational column
       (select c1.name from sys.col$ c1 where c1.intcol# = op.objcol and
        c1.obj# = op.obj#) QUALIFIED_COL_NAME,
       o.name as TABLE_NAME, --name of the parent table
       u.name as TABLE_OWNER --parent table owner
from sys.opqtype$ op, sys.col$ c, sys.obj$ o, sys.user$ u,
     all_tables a
where o.type# = 2 and
o.obj# = op.obj# and
o.obj# = c.obj# and
o.owner# = u.user# and
c.intcol# = op.intcol# and
o.name = a.table_name and
u.name = a.owner and op.schemaoid IS NULL));
/
grant select on ALL_XMLTYPE_COLS to public
/
create or replace public synonym ALL_XMLTYPE_COLS for ALL_XMLTYPE_COLS
/

create or replace view USER_XMLTYPE_COLS
as
select  SCHEMA_ID, SCHEMA_URL, COL_NAME, QUALIFIED_COL_NAME, TABLE_NAME
from DBA_XMLTYPE_COLS
where TABLE_OWNER = USER;
grant select on USER_XMLTYPE_COLS to public
/
create or replace public synonym USER_XMLTYPE_COLS for USER_XMLTYPE_COLS
/


/*
This view selects all the tables and their corresponding nested tables.
OWNER  owner of the table
TABLE_NAME  Name of the table
NESTED_TABLE_NAME  Name of the nested table.
*/
create or replace view DBA_XML_NESTED_TABLES
as
select x.OWNER,
       x.TABLE_NAME,
       NESTED_TABLE_NAME
  from DBA_XML_TABLES x,
       (
         select TABLE_NAME NESTED_TABLE_NAME, 
                connect_by_root PARENT_TABLE_NAME PARENT_TABLE_NAME, OWNER
           from DBA_NESTED_TABLES nt
                connect by prior TABLE_NAME = PARENT_TABLE_NAME
                       and OWNER = OWNER
       ) nt
 where x.TABLE_NAME = nt.PARENT_TABLE_NAME
   and x.OWNER = nt.OWNER
/
grant select on DBA_XML_NESTED_TABLES to select_catalog_role
/
create or replace public synonym DBA_XML_NESTED_TABLES for 
        DBA_XML_NESTED_TABLES
/

create or replace view ALL_XML_NESTED_TABLES
as
select x.OWNER,
       x.TABLE_NAME,
       NESTED_TABLE_NAME
  from ALL_XML_TABLES x,
       (
         select TABLE_NAME NESTED_TABLE_NAME, 
                connect_by_root PARENT_TABLE_NAME PARENT_TABLE_NAME, OWNER
           from ALL_NESTED_TABLES nt
                connect by prior TABLE_NAME = PARENT_TABLE_NAME
                       and OWNER = OWNER
       ) nt
 where x.TABLE_NAME = nt.PARENT_TABLE_NAME
   and x.OWNER = nt.OWNER
/
grant select on ALL_XML_NESTED_TABLES to public
/
create or replace public synonym ALL_XML_NESTED_TABLES for 
        ALL_XML_NESTED_TABLES
/

create or replace view USER_XML_NESTED_TABLES
as
select TABLE_NAME,
       NESTED_TABLE_NAME
  from DBA_XML_NESTED_TABLES
 where OWNER = USER
/
grant select on USER_XML_NESTED_TABLES to public
/
create or replace public synonym USER_XML_NESTED_TABLES
    for USER_XML_NESTED_TABLES
/
--*********************************************************
-- end of view definitions
--*********************************************************

-- CREATE Constants package 
-- *******************************************************************
CREATE OR REPLACE PACKAGE XDB.DBMS_XDB_CONSTANTS authid CURRENT_USER AS 

  C_UTF8_ENCODING              constant VARCHAR2(32)  
                  := 'AL32UTF8';
  C_WIN1252_ENCODING           constant VARCHAR2(32)  
                  := 'WE8MSWIN1252';
  C_ISOLATIN1_ENCODING         constant VARCHAR2(32)  
                  := 'WE8ISO8859P1';
  C_DEFAULT_ENCODING           constant VARCHAR2(32)  
                  := C_UTF8_ENCODING;
  C_ORACLE_NAMESPACE           constant VARCHAR2(128) 
                  := 'http://xmlns.oracle.com';
  C_ORACLE_XDB_NAMESPACE       constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/xdb';
  C_XDBSCHEMA_NAMESPACE        constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/XDBSchema.xsd';
  C_RESOURCE_NAMESPACE         constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/XDBResource.xsd';
  C_ACL_NAMESPACE              constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/acl.xsd';
  C_XMLSCHEMA_NAMESPACE        constant VARCHAR2(128) 
                  := 'http://www.w3.org/2001/XMLSchema';
  C_XMLINSTANCE_NAMESPACE      constant VARCHAR2(128) 
                  := 'http://www.w3.org/2001/XMLSchema-instance';
  C_RESOURCE_PREFIX_R          constant VARCHAR2(128) 
                  := 'xmlns:r="'   || C_RESOURCE_NAMESPACE    || '"';
  C_ACL_PREFIX_ACL             constant VARCHAR2(128) 
                  := 'xmlns:acl="' || C_ACL_NAMESPACE         || '"';
  C_XDBSCHEMA_PREFIX_XDB       constant VARCHAR2(128) 
                  := 'xmlns:xdb="' || C_ORACLE_XDB_NAMESPACE  || '"';
  C_XMLSCHEMA_PREFIX_XSD       constant VARCHAR2(128) 
                  := 'xmlns:xsd="' || C_XMLSCHEMA_NAMESPACE   || '"';
  C_XMLINSTANCE_PREFIX_XSI     constant VARCHAR2(128) 
                  := 'xmlns:xsi="' || C_XMLINSTANCE_NAMESPACE || '"';  
  C_XDBSCHEMA_LOCATION         constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/XDBSchema.xsd';
  C_XDBCONFIG_LOCATION         constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE ||  'xdbconfig.xsd';
  C_ACL_LOCATION               constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/acl.xsd';
  C_RESOURCE_LOCATION          constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/XDBResource.xsd';
  C_BINARY_CONTENT             constant VARCHAR2(128) 
                  := C_XDBSCHEMA_LOCATION  || '#binary';
  C_TEXT_CONTENT               constant VARCHAR2(128) 
                  := C_XDBSCHEMA_LOCATION  || '#text';
  C_ACL_CONTENT                constant VARCHAR2(128) 
                  := C_ACL_LOCATION     || '#acl';    
  C_XDBSCHEMA_PREFIXES         constant VARCHAR2(256) 
                  := C_XMLSCHEMA_PREFIX_XSD || ' ' || C_XDBSCHEMA_PREFIX_XDB;
  C_EXIF_NAMESPACE             constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/meta/exif';
  C_IPTC_NAMESPACE             constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/ord/meta/iptc';
  C_DICOM_NAMESPACE            constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/ord/meta/dicomImage';
  C_ORDIMAGE_NAMESPACE         constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/ord/meta/ordimage';
  C_XMP_NAMESPACE              constant VARCHAR2(128) 
                  := C_ORACLE_NAMESPACE || '/ord/meta/xmp';
  C_XDBCONFIG_NAMESPACE        constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE ||  'xdbconfig.xsd';
  C_EXIF_PREFIX_EXIF           constant VARCHAR2(128) 
                  := 'xmlns:exif="'  || C_EXIF_NAMESPACE     || '"';
  C_IPTC_PREFIX_IPTC           constant VARCHAR2(128) 
                  := 'xmlns:iptc="'  || C_IPTC_NAMESPACE     || '"';
  C_DICOM_PREFIX_DICOM         constant VARCHAR2(128) 
                  := 'xmlns:dicom="' || C_DICOM_NAMESPACE    || '"';
  C_ORDIMAGE_PREFIX_ORD        constant VARCHAR2(128) 
                  := 'xmlns:ord="'   || C_ORDIMAGE_NAMESPACE || '"';
  C_XMP_PREFIX_XMP             constant VARCHAR2(128) 
                  := 'xmlns:xmp="'   || C_XMP_NAMESPACE      || '"';
  C_RESOURCE_CONFIG_NAMESPACE  constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/XDBResConfig.xsd';
  C_XMLDIFF_NAMESPACE          constant VARCHAR2(128) 
                  := C_ORACLE_XDB_NAMESPACE || '/xdiff.xsd';
  C_RESOURCE_CONFIG_PREFIX_RC  constant VARCHAR2(128) 
                  := 'xmlns:rc="' || C_RESOURCE_CONFIG_NAMESPACE || '"';
  C_XMLDIFF_PREFIX_XD          constant VARCHAR2(128) 
                  := 'xmlns:xd="' || C_XMLDIFF_NAMESPACE        || '"';
  C_NSPREFIX_XDBCONFIG_CFG     constant VARCHAR2(128) 
                  := 'xmlns:cfg="' || C_XDBCONFIG_NAMESPACE        || '"';

  C_GROUP        constant VARCHAR2(32) := 'group';      
  C_ELEMENT      constant VARCHAR2(32) := 'element';     
  C_ATTRIBUTE    constant VARCHAR2(32) := 'attribute';
  C_COMPLEX_TYPE constant VARCHAR2(32) := 'complexType';

function ENCODING_UTF8        return varchar2 deterministic;
--        returns 'AL32UTF8'

function ENCODING_ISOLATIN1        return varchar2 deterministic;
--        returns 'WE8ISO8859P1'

function ENCODING_WIN1252     return varchar2 deterministic;
--        returns 'WE8MSWIN1252'

function ENCODING_DEFAULT     return varchar2 deterministic;
--        returns 'AL32UTF8'

function NAMESPACE_ORACLE_XDB        return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb'

function NAMESPACE_RESOURCE          return varchar2 deterministic;
--        returns ' http://xmlns.oracle.com/xdb/XDBResource.xsd

function NAMESPACE_XDBSCHEMA          return varchar2 deterministic;
--        returns ' http://xmlns.oracle.com/xdb/XDBSchema.xsd

function NAMESPACE_ACL               return varchar2 deterministic;
--          returns ' http://xmlns.oracle.com/xdb/acl.xsd'

function NAMESPACE_ORACLE         return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com'

function NAMESPACE_XMLSCHEMA         return varchar2 deterministic;
--        returns 'http://www.w3.org/2001/XMLSchema'

function NAMESPACE_XMLINSTANCE       return varchar2 deterministic;
--        returns 'http://www.w3.org/2001/XMLSchema-instance'

function NAMESPACE_RESOURCE_CONFIG   return varchar2 deterministic;
--           returns 'http://xmlns.oracle.com/xdb/XDBResConfig.xsd'

function NAMESPACE_XMLDIFF           return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/xdiff.xsd'

function NAMESPACE_XDBCONFIG          return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/xdbconfig.xsd'

function SCHEMAURL_XDBCONFIG          return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/xdbconfig.xsd'

function NSPREFIX_RESOURCE_R         return varchar2 deterministic;
--        returns 'xmlns:r="http://xmlns.oracle.com/XDBResource.xsd"'

function NSPREFIX_ACL_ACL              return varchar2 deterministic;
--        returns 'xmlns:acl= 'http://xmlns.oracle.com/acl.xsd"'

function NSPREFIX_XDB_XDB        return varchar2 deterministic;
--        returns 'xmlns:xdb= “http://xmlns.oracle.com/xdb" '

function NSPREFIX_XMLSCHEMA_XSD        return varchar2 deterministic;
--        returns 'xmlns:xsd="http://www.w3.org/2001/XMLSchema"'

function NSPREFIX_XMLINSTANCE_XSI      return varchar2 deterministic;
--        returns 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '

function NSPREFIX_RESCONFIG_RC   return varchar2 deterministic;
--        returns 'xmlns:rc="' || NAMESPACE_RESOURCE_CONFIG

function NSPREFIX_XMLDIFF_XD           return varchar2 deterministic;
--        returns  xmlns:xd="' || NAMESPACE_XMLDIFF

function NSPREFIX_XDBCONFIG_CFG        return varchar2 deterministic;
--        returns xmlns:cfg="http://xmlns.oracle.com/xdb/xdbconfig.xsd"

function SCHEMAURL_XDBSCHEMA          return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/XDBSchema.xsd';

function SCHEMAURL_ACL                return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/acl.xsd';

function SCHEMAURL_RESOURCE           return varchar2 deterministic;
--        returns 'http://xmlns.oracle.com/xdb/XDBResource.xsd';

function SCHEMAELEM_RESCONTENT_BINARY              return varchar2 deterministic;
--        returns SCHEMAURL_XDBSCHEMA || '#binary'

function SCHEMAELEM_RESCONTENT_TEXT                return varchar2 deterministic;
--        returns SCHEMAURL_XDBSCHEMA || '#text'

function SCHEMAELEM_RES_ACL                 return varchar2 deterministic;
--        returns SCHEMAURL_XDBSCHEMA || '#acl'

function XSD_GROUP             return VARCHAR2 deterministic;
--        returns 'group'

function XSD_ELEMENT           return VARCHAR2 deterministic;
--        returns 'element' 

function XSD_ATTRIBUTE         return VARCHAR2 deterministic;
--        returns 'attribute'

function XSD_COMPLEX_TYPE      return VARCHAR2 deterministic;
--        returns 'complexType'

function XDBSCHEMA_PREFIXES  return VARCHAR2 deterministic;
--        returns  DBMS_XDB_CONSTANTS.PREFIX_DEF_XDB || ' ' || 
--                 DBMS_XDB_CONSTANTS.PREFIX_DEF_XMLSCHEMA

END DBMS_XDB_CONSTANTS;
/
SHOW ERRORS;

grant execute on XDB.DBMS_XDB_CONSTANTS to public;



 -- *******************************************************************
CREATE OR REPLACE PACKAGE XDB.DBMS_XMLSCHEMA_ANNOTATE authid CURRENT_USER AS
  
  procedure printWarnings(value in BOOLEAN default TRUE);


  procedure addXDBNamespace(xmlschema in out XMLType);
  -- Adds the XDB namespace that is required for xdb annotation. 
  -- This procedure is called implicitly by any other procedure that adds a 
  -- schema annotation. Without further annotations the xdb namespace 
  -- annotations does not make sense, therefore this procedure might mostly 
  -- be called by other annotations procedures and not by the user directly.
  -- The procedure gets an XML Schema as XMLType, performs the annotation and
  -- returns it.

  procedure setDefaultTable(xmlschema in out XMLType,  
                            globalElementName VARCHAR2, 
                            tableName VARCHAR2,  
                            overwrite BOOLEAN default TRUE);
  -- Sets the name of the default table for a given global element that is 
  -- specified by its name

  procedure removeDefaultTable(xmlschema in out XMLType, 
                              globalElementName VARCHAR2);
  -- Removes the default table attribute for the given element. 
  -- After calling this
  -- function system generated table names will be used. The procedure will
  -- always overwrite.

  procedure setTableProps(xmlschema in out XMLType, 
                          globalElementName VARCHAR2, 
                          tableProps VARCHAR2, 
                          overwrite BOOLEAN default TRUE);
  -- Specifies the TABLE storage clause that is appended to the default 
  -- CREATE TABLE statement.

  procedure removeTableProps(xmlschema in out XMLType, 
                            globalElementName VARCHAR2);
  -- removes the table storage props.

  procedure setTableProps(xmlschema in out XMLType, 
                          globalObject VARCHAR2, 
                          globalObjectName VARCHAR2, 
                          localElementName VARCHAR2, 
                          tableProps VARCHAR2, 
                          overwrite BOOLEAN default TRUE);
  -- Specifies the TABLE storage clause that is appended to the 
  -- default CREATE TABLE statement.

  procedure removeTableProps(xmlschema in out XMLType, 
                          globalObject VARCHAR2, 
                          globalObjectName VARCHAR2, 
                          localElementName VARCHAR2);
  -- Removes the TABLE storage clause that is appended to the 
  -- default CREATE TABLE statement.

  procedure disableDefaultTableCreation(xmlschema in out XMLType, 
                                         globalElementName VARCHAR2);
  -- Add a default table attribute with an empty value to the 
  -- top level element with the specified name. 
  -- No table will be created for that element. 
  -- The procedure will always overwrite.


  procedure disableDefaultTableCreation(xmlschema in out XMLType);
  -- Add a default table attribute with an empty value to ALL top level 
  -- elements that have no defined default table name. 
  -- The procedure will never overwrite existing annotations since this 
  -- would lead to no table creation at all.  
  -- This is the way to prevent XDB from creating many and unused tables 
  -- for elements that are no root elements of 
  -- instance documents.
 /* TODO This function
  * This functions should test that at least one default table with a given
  * name exists. If no default table name is assigned calling this
  * disableTopLevelTableCreation would lead to no table creation at all. */

  procedure enableDefaultTableCreation(xmlschema in out XMLType, 
                                        globalElementName VARCHAR2);
  -- Enables the creation of top level tables by removing the empty default 
  -- table name annotation.

  procedure enableDefaultTableCreation(xmlschema in out XMLType);
  -- Enables the creation of ALL top level tables by removing the empty 
  -- default table name annotation.
 
  procedure setSQLName (xmlschema in out XMLType, 
                        globalObject VARCHAR2, 
                        globalObjectName VARCHAR2, 
                        localObject VARCHAR2, 
                        localObjectName VARCHAR2, 
                        sqlName VARCHAR2, 
                        overwrite BOOLEAN default TRUE);
  -- assigns a sqlname to an element

  procedure removeSQLName (xmlschema in out XMLType, 
                           globalObject VARCHAR2, 
                           globalObjectName VARCHAR2, 
                           localObject VARCHAR2, 
                           localObjectName VARCHAR2);
  -- removes a sqlname from a global element

  procedure setSQLType (xmlschema in out XMLType, 
                        globalElementName VARCHAR2, 
                        sqlType VARCHAR2, 
                        overwrite BOOLEAN default TRUE);
  -- assigns a sqltype to a global element

  procedure removeSQLType (xmlschema in out XMLType, 
                           globalElementName VARCHAR2);
  -- removes a sqltype from a global element

  procedure setSQLType(xmlschema in out XMLType, 
                       globalObject VARCHAR2, 
                       globalObjectName VARCHAR2, 
                       localObject VARCHAR2, 
                       localObjectName VARCHAR2, 
                       sqlType VARCHAR2, 
                       overwrite BOOLEAN default TRUE);
  -- assigns a sqltype inside a complex type (local)

  procedure removeSQLType    (xmlschema in out XMLType, 
                              globalObject VARCHAR2, 
                              globalObjectName VARCHAR2, 
                              localObject VARCHAR2, 
                              localObjectName VARCHAR2);
  -- removes a sqltype inside a complex type (local)
                                 
  procedure setSQLTypeMapping(xmlschema in out XMLType, 
                              schemaTypeName VARCHAR2, 
                              sqlTypeName VARCHAR2, 
                              overwrite BOOLEAN default TRUE);
  -- defines a mapping of schema type and sqltype. 
  -- The addSQLType procedure do not have to be called on all instances of 
  -- the schema type instead the schema is traversed and the 
  -- sqltype is assigned automatically.

  procedure removeSQLTypeMapping(xmlschema in out XMLType, 
                                 schemaTypeName VARCHAR2);
  -- removes the sqltype mapping for the given schema type. 

  procedure setTimeStampWithTimeZone(xmlschema in out xmlType, 
                                     overwrite BOOLEAN default TRUE);
  -- sets the TimeStampWithTimeZone datatype to dateTime typed element.

  procedure removeTimeStampWithTimeZone(xmlschema in out xmlType);
  -- removes the TimeStampWithTimeZone datatype to dateTime typed element.

  procedure setAnyStorage (xmlschema in out XMLType, 
                           complexTypeName VARCHAR2, 
                           sqlTypeName VARCHAR2, 
                           overwrite BOOLEAN default TRUE);
  -- sets the sqltype of any

  procedure removeAnyStorage (xmlschema in out XMLType, 
                              complexTypeName VARCHAR2);
  -- removes the sqltype of any

  procedure setSQLCollType(xmlschema in out XMLType, 
                           elementName VARCHAR2, 
                           sqlCollType VARCHAR2, 
                           overwrite BOOLEAN default TRUE);
  -- sets the name of the SQL collection type that corresponds 
  -- to this XML element

  procedure removeSQLCollType(xmlschema in out XMLType, 
                              elementName VARCHAR2);
  -- removes the sql collection type

  procedure setSQLCollType(xmlschema in out XMLType, 
                           globalObject VARCHAR2, 
                           globalObjectName VARCHAR2, 
                           localElementName VARCHAR2, 
                           sqlCollType VARCHAR2, 
                           overwrite BOOLEAN default TRUE );
  -- Name of the SQL collection type that corresponds to this 
  -- XML element. inside a complex type.

  procedure removeSQLCollType(xmlschema in out XMLType, 
                              globalObject VARCHAR2, 
                              globalObjectName VARCHAR2, 
                              localElementName VARCHAR2);
  -- removes the sql collection type

  procedure disableMaintainDom(xmlschema in out XMLType, 
                               overwrite BOOLEAN default TRUE);
  -- sets dom fidelity to FALSE to ALL complex types irregardless 
  -- of their names

  procedure enableMaintainDom(xmlschema in out XMLType, 
                              overwrite BOOLEAN default TRUE);
  -- sets dom fidelity to TRUE to ALL complex types irregardless 
  -- of their names

  procedure disableMaintainDom(xmlschema in out XMLType, 
                               complexTypeName VARCHAR2, 
                               overwrite BOOLEAN default TRUE);
  -- sets the dom fidelity attribute for the given complex type name to FALSE.

  procedure enableMaintainDom(xmlschema in out XMLType, 
                              complexTypeName VARCHAR2, 
                              overwrite BOOLEAN default TRUE);
  -- sets the dom fidelity attribute for the given complex type name to TRUE

  procedure removeMaintainDom(xmlschema in out XMLType);
  -- removes all maintain dom annotations from given schema  

  procedure setOutOfLine(xmlschema in out XMLType, 
                          elementName VARCHAR2, 
                          elementType VARCHAR2, 
                          defaultTableName VARCHAR2, 
                          overwrite BOOLEAN default TRUE);
  -- set the sqlInline attribute to false and forces the out of line storage
  -- for the element specified by its name.

  procedure removeOutOfLine(xmlschema in out XMLType, 
                            elementName VARCHAR2, 
                            elementType VARCHAR2);
  -- removes the sqlInline attribute for the element specified by its name.

  procedure setOutOfLine (xmlschema in out XMLType, 
                           globalObject VARCHAR2, 
                           globalObjectName VARCHAR2, 
                           localElementName VARCHAR2, 
                           defaultTableName VARCHAR2, 
                           overwrite BOOLEAN default TRUE);
  -- set the sqlInline attribute to false and forces the out of line storage 
  -- for the element specified by its   local and global name  

  procedure removeOutOfLine (xmlschema in out XMLType, 
                             globalObject VARCHAR2, 
                             globalObjectName VARCHAR2, 
                             localElementName VARCHAR2);
  -- removes the sqlInline attribute for the element specified by its 
  -- global and local name

  procedure setOutOfLine(xmlschema in out XMLType, 
                          reference VARCHAR2, 
                          defaultTableName VARCHAR2, 
                          overwrite BOOLEAN default TRUE);
  -- sets the default table name and sqlinline attribute for all references 
  -- to a particular global Element

  procedure removeOutOfLine(xmlschema in out XMLType, reference VARCHAR2);
  -- removes the the sqlInline attribute for the global element

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
-- NOOP
$ELSE

  function getSchemaAnnotations(xmlschema xmlType) return XMLType;
  --  creates a diff of the annotated xml schema and the 
  --  non-annotated  xml schema.
  --  This diff can be used to apply all annotation again on a 
  --  non-annotated schema. 
  --  A user calls this function to save all annotations in one document.

  procedure setSchemaAnnotations(xmlschema in out xmlType, annotations XMLTYPE);
  -- Will take the annotations 
  -- (diff result from call to 'getSchemaAnnotations' 
  -- and will patch in provided XML schema.

$END --DBMS_DB_VERSION.VER_LE_10_1


END DBMS_XMLSCHEMA_ANNOTATE;
/
SHOW ERRORS;

grant execute on XDB.DBMS_XMLSCHEMA_ANNOTATE to public;
--**************************************************


-- Create type required for dbms_manage_xmlstorage
-- **************************************************
create or replace TYPE XDB.XMLTYPE_REF_TABLE_T IS TABLE of REF XMLTYPE
/
grant execute on XDB.XMLTYPE_REF_TABLE_T to public
/
--**************************************************


-- Create package dbms_manage_xmlstorage
-- **************************************************
CREATE OR REPLACE PACKAGE XDB.DBMS_XMLSTORAGE_MANAGE authid CURRENT_USER AS 
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   procedure renameCollectionTable (owner_name varchar2 default user,
                                   tab_name varchar2,
                                   col_name varchar2 default NULL,
                                   xpath varchar2,
                                   collection_table_name varchar2);
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
    procedure renameCollectionTable (owner_name varchar2 default user,
                                   tab_name varchar2,
                                   col_name varchar2 default NULL,
                                   xpath varchar2,
                                   collection_table_name varchar2);
$ELSE --11.2
  procedure renameCollectionTable (owner_name varchar2 default user,
                                   tab_name varchar2,
                                   col_name varchar2 default NULL,
                                   xpath varchar2,
                                   collection_table_name varchar2,
                                   namespaces IN VARCHAR2 default NULL);
$END

  -- Renames a collection table from the system generated name 
  -- to the given table name.
  -- This function is called AFTER registering the xml schema.
  -- NOTE: Since there is no direct schema annotation for this purpose 
  -- this post registration 
  -- function has to be used. Because all other functions are used before 
  -- registration this 
  -- function breaks the consistency. In addition, this is the only case 
  -- where we encourage the 
  -- user/dba to change a table/type name after registration. 
  -- Since one goal of the schema annotation is to enable more readable 
  -- query execution plans   
  -- we recommend to derive the name of a collection table by its 
  -- corresponding collection type name. 
  -- Since we have an annotation for collection type we should use this one
  -- when creating the collection 
  -- table. This might make the renameCollectionTable obsolete.


  procedure scopeXMLReferences;
  -- Will scope all XML references. Scoped REF types require 
  -- less storage space and allow more 
  -- efficient access than unscoped REF types.
  -- Note: This procedure does not need to be exposed 
  -- to customer if called automatically from 
  -- schema registration code. 
  -- In this case we will either move the procedure into a prvt package 
  -- or call the body of scopeXMLReferences from schema registration code 
  -- directly so that the 
  -- procedure would not be published at all.

  procedure indexXMLReferences( owner_name VARCHAR2 default user,
                             table_name VARCHAR2,
                             column_name VARCHAR2 default NULL,
                             index_name VARCHAR2);
  -- This procedure creates unique indexes on the ref columns
  -- of the given XML type tables or XML type column of a given table. 
  -- In case of an XML type table the column name does not 
  -- have to be specified. 
  -- The index_name will be used to name the index- since multiple ref 
  -- columns could be affected the table name gets a iterator concatenated 
  -- at the end. 
  -- For instance if two ref columns are getting indexed they will be named 
  -- index_name_1 and index_name_2.
  -- The procdure indexXMLReferences will not recursively index refs in child
  -- tables of the table that this procedure is called on. 
  -- If this is desired we recommend to call the 
  -- procedure from within a loop  over the 
  -- DBA|ALL|USER_ XML_OUT_OF_LINE_TABLES or 
  -- DBA|ALL|USER_ XML_NESTED_TABLES view. 
  -- The index_name could then be created from the current 
  -- value of a view's column.
  -- Indexed refs lead to higher performance when joins between the 
  -- child table and base table 
  -- occur in the query plan. If the selectivity of the child table 
  -- is higher than the join of one 
  -- row in the child table with the base table leads to a full table 
  -- scan of the base table if no indexes are present. 
  -- This is the exact motivation for indexing the refs in the base table. 
  -- If the base table has a higher selectivity than the child table there 
  -- is no need to index the refs.
  -- Indexing the refs makes only sense if the refs are scoped. 

  -- ** Bulkload functionality
procedure  disableIndexesAndConstraints(owner_name varchar2 default user,
                                        table_name varchar2,
                                        column_name varchar2 default NULL,
                                        clear Boolean default FALSE);


  -- This procedure will be used to drop the indexes and disable 
  -- the constraints for both xmltype 
  -- table (no P_COL_NAME) and xmltype columns. 
  -- For xmltype tables, the user needs to pass the xmltype-table 
  -- name on which the bulk load operation is to be performed. 
  -- For xmltype columns, the user needs to pass 
  -- the relational table_name and the corresponding xmltype column name.

procedure enableIndexesAndConstraints(owner_name varchar2 default user,
                                      table_name varchar2,
                                      column_name varchar2 default NULL);
 

  -- This procedure will rebuild all indexes and enable the constraints 
  -- on the P_TABLE_NAME including its 
  -- child and out of line tables. 
  -- When P_COL_NAME is passed, it does the same for this xmltype column.

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   -- noop
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
   -- noop
$ELSE --11.2
-- routine to disable constraints before exchange partition
procedure  ExchangePreProc(owner_name varchar2 default user,
                           table_name varchar2);
-- routine to enable constraints after exchange partition
procedure  ExchangePostProc(owner_name varchar2 default user,
                           table_name varchar2);
$END

 -- XPath to Tab/Col Mapping
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   -- noop
$ELSIF DBMS_DB_VERSION.VER_LE_11_1 $THEN
   -- noop
$ELSE --11.2
  function xpath2TabColMapping(owner_name VARCHAR2 default user,
                               table_name IN VARCHAR2,     
                               column_name IN VARCHAR2 default NULL,
                               xpath IN VARCHAR2,
                               namespaces IN VARCHAR2 default NULL) RETURN XMLTYPE;  
$END

END DBMS_XMLSTORAGE_MANAGE;
/
SHOW ERRORS;

grant execute on XDB.DBMS_XMLSTORAGE_MANAGE to public;
