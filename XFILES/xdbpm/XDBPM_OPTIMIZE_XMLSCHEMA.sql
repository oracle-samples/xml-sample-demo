
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
-- XDBPM_OPTIMIZE_XMLSCHEMA should be created under XDBPM
--
alter session set current_schema = XDBPM
/
ALTER SESSION SET PLSQL_CCFLAGS = 'DEBUG:FALSE'
/
--
set define on
--
@@XDBPM_SQLTYPE_VIEWS.sql
--
create or replace TYPE XMLTYPE_REF_TABLE_T 
                    IS TABLE of REF XMLTYPE
/
show errors
--
grant execute on XMLTYPE_REF_TABLE_T to public
/
create global temporary table STORAGE_MODEL_CACHE
(
  TYPE_NAME           VARCHAR2(128),
  TYPE_OWNER          VARCHAR2(32),
  EXTENDED_DEFINITION VARCHAR2(3),
  STORAGE_MODEL       XMLType
)
ON COMMIT PRESERVE ROWS
/
grant all on STORAGE_MODEL_CACHE to public
/
create  global temporary table TYPE_SUMMARY
(
  TYPE_NAME     VARCHAR2(30),
  OWNER         VARCHAR2(30),
  COLUMN_COUNT  NUMBER,
  PRIMARY KEY (OWNER, TYPE_NAME)
)
ON COMMIT PRESERVE ROWS
/
grant all on TYPE_SUMMARY to public
/
create GLOBAL TEMPORARY TABLE REVISED_TYPE_SUMMARY
(
  TYPE_NAME     VARCHAR2(30),
  OWNER         VARCHAR2(30),
  COLUMN_COUNT  NUMBER,
  PRIMARY KEY (OWNER, TYPE_NAME)
)
ON COMMIT PRESERVE ROWS
/
grant all on REVISED_TYPE_SUMMARY to public
/
create global temporary table REVISED_TYPES
(
  OWNER                      VARCHAR2(30),
  TYPE_NAME                  VARCHAR2(30),
  TYPE_OID                   RAW(16),
  TYPECODE                   VARCHAR2(30),
  ATTRIBUTES                 NUMBER,
  METHODS                    NUMBER,
  PREDEFINED                 VARCHAR2(3),
  INCOMPLETE                 VARCHAR2(3),
  FINAL                      VARCHAR2(3),
  INSTANTIABLE               VARCHAR2(3),
  SUPERTYPE_OWNER            VARCHAR2(30),
  SUPERTYPE_NAME             VARCHAR2(30),
  LOCAL_ATTRIBUTES           NUMBER,
  LOCAL_METHODS              NUMBER,
  TYPEID                     RAW(16),
  PRIMARY KEY(OWNER,TYPE_NAME)
)
ON COMMIT PRESERVE ROWS      
/
grant all on REVISED_TYPES to public
/
create global temporary table REVISED_COLL_TYPES
(
  OWNER                      VARCHAR2(30) NOT NULL ,
  TYPE_NAME                  VARCHAR2(30) NOT NULL ,
  COLL_TYPE                  VARCHAR2(30) NOT NULL ,
  UPPER_BOUND                NUMBER,
  ELEM_TYPE_MOD              VARCHAR2(7),
  ELEM_TYPE_OWNER            VARCHAR2(30),
  ELEM_TYPE_NAME             VARCHAR2(30),
  LENGTH                     NUMBER,
  PRECISION                  NUMBER,
  SCALE                      NUMBER,
  CHARACTER_SET_NAME         VARCHAR2(44),
  ELEM_STORAGE               VARCHAR2(7),
  NULLS_STORED               VARCHAR2(3),
  CHAR_USED                  VARCHAR2(1),
  PRIMARY KEY (OWNER,TYPE_NAME)
)
ON COMMIT PRESERVE ROWS      
/
grant all on REVISED_COLL_TYPES to public
/
create GLOBAL TEMPORARY TABLE REVISED_TYPE_ATTRS
(
  OWNER                VARCHAR2(30),
  TYPE_NAME            VARCHAR2(30),
  ATTR_NAME            VARCHAR2(30),
  ATTR_TYPE_MOD        VARCHAR2(7),
  ATTR_TYPE_OWNER      VARCHAR2(30),
  ATTR_TYPE_NAME       VARCHAR2(30),
  LENGTH               NUMBER,
  PRECISION            NUMBER,
  SCALE                NUMBER,
  CHARACTER_SET_NAME   VARCHAR2(44),
  ATTR_NO              NUMBER,
  INHERITED            VARCHAR2(3),
  CHAR_USED            VARCHAR2(1),
  PRIMARY KEY (OWNER, TYPE_NAME, ATTR_NAME)
)
ON COMMIT PRESERVE ROWS
/
grant all on REVISED_TYPE_ATTRS to public
/
create index XDBPM_ATTR_TYPE_INDEX 
    on REVISED_TYPE_ATTRS (ATTR_TYPE_OWNER, ATTR_TYPE_NAME)
/
create GLOBAL TEMPORARY TABLE REVISED_CHOICE_MODEL
(
  CHOICE_REFERENCE REF XMLTYPE,
  SQLTYPE          VARCHAR2(30),
  COLUMN_COUNT     NUMBER,
  PRIMARY KEY      (SQLTYPE)
)
/
grant all on REVISED_TYPE_ATTRS to public
/
create table XDBPM_INDEX_DDL_CACHE
(
  TABLE_NAME           VARCHAR2(128),
  OWNER                VARCHAR2(32),
  INDEX_DDL            XMLType
)
/
grant all on XDBPM_INDEX_DDL_CACHE to public
/
create or replace view MISSING_TYPES
as
select * 
  from XDBPM.XDBPM_ALL_TYPES at
 where not exists
       (
          select 1 
            from TYPE_SUMMARY ts
           where nvl(ts.OWNER,'SYS') = nvl(at.OWNER,'SYS')
             and ts.TYPE_NAME = at.TYPE_NAME
       )   
/
grant all on MISSING_TYPES to public
/
create or replace view MISSING_TYPE_ATTRS
as
select ata.*
  from MISSING_TYPES mt, XDBPM.XDBPM_ALL_TYPE_ATTRS ata
 where mt.TYPE_NAME = ata.TYPE_NAME
   and mt.OWNER = ata.OWNER
   and not exists
       (
          select 1 
            from TYPE_SUMMARY ts
           where nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
             and ts.TYPE_NAME = ata.ATTR_TYPE_NAME
       )   
/
grant all on MISSING_TYPE_ATTRS to public
/
create or replace view MISSING_TYPE_HIERARCHY
as
select level TYPE_LEVEL, ata.TYPE_NAME, ata.OWNER, ATTR_NAME, ATTR_TYPE_NAME, ATTR_TYPE_OWNER
  from XDBPM.XDBPM_ALL_TYPES at, XDBPM.XDBPM_ALL_TYPE_ATTRS ata
 where at.TYPE_NAME = ata.TYPE_NAME
   and INHERITED = 'NO'
   and at.OWNER     = ata.OWNER
   and not exists
       (
          select 1 
            from TYPE_SUMMARY ts
           where nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
             and ts.TYPE_NAME = ata.ATTR_TYPE_NAME
       )   
       and not exists
       ( 
         select syn.SYNONYM_NAME, syn.OWNER
           from ALL_SYNONYMS syn, XDBPM.XDBPM_ALL_TYPES at
          where syn.TABLE_NAME  = at.TYPE_NAME
            and syn.TABLE_OWNER = at.OWNER
            and syn.SYNONYM_NAME = ata.ATTR_TYPE_NAME
            and syn.OWNER        = ata.ATTR_TYPE_OWNER
       )
       connect by SUPERTYPE_NAME = prior at.TYPE_NAME
              and SUPERTYPE_OWNER = prior at.OWNER
/
grant all on MISSING_TYPE_HIERARCHY to public
/
create or replace view BASE_TYPE_SUMMARY 
as
select ata.TYPE_NAME, ata.OWNER, ata.ATTR_NAME, ata.ATTR_TYPE_NAME, ata.ATTR_TYPE_OWNER,
       case when ts.OWNER = 'XDB' and (ts.TYPE_NAME = 'XDB$RAW_LIST_T' or ts.TYPE_NAME = 'XDB$ENUM_T')
            then ts.COLUMN_COUNT
            else case when exists (
                                    select 1 from XDBPM.XDBPM_ALL_TYPES at
                                     where at.TYPE_NAME = ts.TYPE_NAME
                                       and at.OWNER = ts.OWNER
                                       and at.FINAL = 'YES'
                                       and at.TYPECODE = 'OBJECT'
                                  )
                      then ts.COLUMN_COUNT + 2
                      else ts.COLUMN_COUNT
                 end       
       end COLUMN_COUNT
  from XDBPM.XDBPM_ALL_TYPE_ATTRS ata, TYPE_SUMMARY ts
 where ata.ATTR_TYPE_NAME = ts.TYPE_NAME
	 and nvl(ata.ATTR_TYPE_OWNER,'SYS') = nvl(ts.OWNER,'SYS')
/
grant all on BASE_TYPE_SUMMARY to public
/
create or replace view EXPANDED_TYPE_SUMMARY
as
select bts.TYPE_NAME, bts.OWNER, bts.ATTR_NAME, bts.ATTR_TYPE_NAME, bts.ATTR_TYPE_OWNER, bts.COLUMN_COUNT
  from BASE_TYPE_SUMMARY bts
union all
select at.SUPERTYPE_NAME TYPE_NAME, at.SUPERTYPE_OWNER OWNER, 'SYS$EXTENSION' ATTR_TYPE_NAME, at.TYPE_NAME ATTR_TYPE_NAME, at.OWNER ATTR_TYPE_OWNER, 
       ts.COLUMN_COUNT -
	     (
	       select sum(COLUMN_COUNT)
		       from BASE_TYPE_SUMMARY bts
		      where bts.TYPE_NAME = at.SUPERTYPE_NAME
		        and bts.OWNER = at.SUPERTYPE_OWNER
 	     )
  from XDBPM.XDBPM_ALL_TYPES at, TYPE_SUMMARY ts
 where at.TYPE_NAME = ts.TYPE_NAME
	and at.OWNER = ts.OWNER
/
grant all on EXPANDED_TYPE_SUMMARY to public
/
create or replace package XDBPM_OPTIMIZE_XMLSCHEMA
authid CURRENT_USER
as

  C_COLUMN_LIMIT constant NUMBER(3) := 975;
  
  function COLUMN_LIMIT return number deterministic;
  
  procedure generateTypeSummary; 
  function doTypeAnalysis(P_XML_SCHEMA_CONFIGURATION IN OUT XMLTYPE, P_SCHEMA_LOCATION_HINT VARCHAR2 DEFAULT NULL, P_OWNER VARCHAR2 DEFAULT USER, P_LIMIT NUMBER DEFAULT 3) return BOOLEAN;

  function createDeleteSchemaScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) return VARCHAR2;

  procedure setSchemaRegistrationOptions(
              P_LOCAL                BOOLEAN        DEFAULT TRUE  
             ,P_GENTYPES             BOOLEAN        DEFAULT TRUE  
             ,P_GENTABLES            BOOLEAN        DEFAULT TRUE 
             ,P_OWNER                VARCHAR2       DEFAULT NULL 
             ,P_ENABLE_HIERARCHY     BINARY_INTEGER DEFAULT DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE
             ,P_OPTIONS              BINARY_INTEGER DEFAULT NULL
            );
           
  procedure setRegistrationScriptOptions(
              P_DISABLE_DOM_FIDELITY   BOOLEAN        DEFAULT FALSE
            );

  function  createSchemaRegistrationScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) return VARCHAR2;
  procedure appendTableCreationScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE);
  procedure appendFileUploadScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE);
  
  -- procedure schemaRegistrationScript(P_OUTPUT_FOLDER VARCHAR2, P_XMLSCHEMA_FOLDER VARCHAR2, P_XML_SCHEMA_CONFIGURATION XMLType, P_SCHEMA_LOCATION_HINT VARCHAR2 DEFAULT NULL, P_OWNER VARCHAR2 DEFAULT USER, P_LIMIT NUMBER DEFAULT 3);
  -- procedure printSchemaRegistrationScript(P_SCRIPT_FILE VARCHAR2, P_COMMENT VARCHAR2, P_XML_SCHEMA_CONFIGURATION XMLTYPE, P_XMLSCHEMA_FOLDER VARCHAR2);
  procedure describeAnnotations(P_RESOURCE_PATH VARCHAR2, P_SCHEMA_LOCATION_HINT VARCHAR2,P_OWNER VARCHAR2 DEFAULT USER);
  
  procedure setEvent(P_EVENT VARCHAR2, P_LEVEL VARCHAR2);
               
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
--
-- Depricated in 11.1.x : ALL_XML_SCHEMAS now contains column SCHEMA_ID which can be used to get this value.
--
  function getXMLSchemaRef(P_SCHEMA_LOCATION_HINT VARCHAR2,P_OWNER VARCHAR2) return REF XMLTYPE;
--
$END
--
end XDBPM_OPTIMIZE_XMLSCHEMA;
/
show errors
--
create or replace synonym XDB_OPTIMIZE_XMLSCHEMA for XDBPM_OPTIMIZE_XMLSCHEMA
/
create or replace synonym XDB_OPTIMIZE_SCHEMA for XDBPM_OPTIMIZE_XMLSCHEMA
/
create or replace package body XDBPM_OPTIMIZE_XMLSCHEMA
as
--
  C_NEW_LINE   constant VARCHAR2(2) := CHR(10);
  C_BLANK_LINE constant VARCHAR2(4) := C_NEW_LINE || C_NEW_LINE;
--
  TYPE TABLE_LIST_ENTRY_T 
  is RECORD 
  (
    PARENT_SCHEMA          REF XMLTYPE,
    ELEMENT_NAME           VARCHAR2(2000),
    SQLTYPE                VARCHAR2(30),
    TABLE_NAME             VARCHAR2(30)
  );
--
  TYPE TABLE_LIST_T 
    is TABLE of  TABLE_LIST_ENTRY_T;
--
  G_TABLE_LIST TABLE_LIST_T;
--
  TYPE SCHEMA_ANNOTATION_T 
  IS RECORD 
  (
    SCHEMA_LOCATION_HINT      VARCHAR2(700),
    OWNER                     VARCHAR2(30),
    SCHEMA_ANNOTATIONS        CLOB,
    HAS_ANNOTATIONS           BOOLEAN,
    HAS_OUT_OF_LINE_HEADER    BOOLEAN
  );
--
  TYPE SCHEMA_ANNOTATION_LIST_T 
    IS TABLE OF SCHEMA_ANNOTATION_T;
--
  G_SCHEMA_ANNOTATION_CACHE  SCHEMA_ANNOTATION_LIST_T;
--
  TYPE EVENT_T
  is RECORD
  (
     EVENT         VARCHAR2(32),
     LEVEL         VARCHAR2(32)
  );
--
  TYPE EVENT_LIST_T
    is TABLE of EVENT_T;
--  
  G_EVENT_LIST               EVENT_LIST_T;
--
  G_SCHEMA_REFERENCE_LIST    XDB.XDB$XMLTYPE_REF_LIST_T;
--
  G_LOCAL                    BOOLEAN := TRUE;
  G_GENTYPES                 BOOLEAN := TRUE;
  G_GENTABLES                BOOLEAN := TRUE;
  G_OWNER                    VARCHAR2(32) := NULL;
  G_OPTIONS                  BINARY_INTEGER :=NULL;
  G_ENABLE_HIERARCHY         BINARY_INTEGER := NULL;
--
  G_DISABLE_DOM_FIDELITY     BOOLEAN := FALSE;
  G_DISABLE_DEFAULT_TABLES   BOOLEAN := FALSE;
--  
function COLUMN_LIMIT 
return number deterministic
as
begin
	return C_COLUMN_LIMIT;
end;
--
procedure createOutputFile(P_RESOURCE_PATH VARCHAR2 DEFAULT '/public/annotateSchema.sql')
as
begin
  XDB_OUTPUT.createFile(P_RESOURCE_PATH,TRUE);
end;
--
procedure appendSchemaAnnotations(P_SCHEMA_REFERENCE REF XMLTYPE, P_CONTENT IN OUT CLOB)
as
begin
	for i in G_SCHEMA_REFERENCE_LIST.first .. G_SCHEMA_REFERENCE_LIST.last loop
	  if G_SCHEMA_REFERENCE_LIST(i) = P_SCHEMA_REFERENCE then
      DBMS_LOB.append(G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS,P_CONTENT);
      G_SCHEMA_ANNOTATION_CACHE(i).HAS_ANNOTATIONS := TRUE;
      DBMS_LOB.freeTemporary(P_CONTENT);
      P_CONTENT := NULL;
      exit;
    end if;
  end loop;
end;
--
function initializeTypeSummary
return number
as
  V_NEW_TYPE_COUNT NUMBER := 0;
begin

  execute immediate 'DELETE FROM XDBPM.REVISED_TYPE_SUMMARY';
  commit;  

  -- Cost of all native types is 1

  insert into XDBPM.REVISED_TYPE_SUMMARY 
  select DISTINCT ATTR_TYPE_NAME, nvl(ATTR_TYPE_OWNER,'SYS'), 1
    from XDBPM.REVISED_TYPE_ATTRS ata
   where not exists
         (
           select TYPE_NAME, OWNER
                  from XDBPM.REVISED_TYPES at
            where ata.ATTR_TYPE_NAME = at.TYPE_NAME
              and ata.ATTR_TYPE_OWNER = at.OWNER
          )
      and not exists
         ( 
           select syn.SYNONYM_NAME, syn.OWNER
             from ALL_SYNONYMS syn, XDBPM.REVISED_TYPES at
            where syn.TABLE_NAME  = at.TYPE_NAME
              and syn.TABLE_OWNER = at.OWNER
              and syn.SYNONYM_NAME = ata.ATTR_TYPE_NAME
              and syn.OWNER        = ata.ATTR_TYPE_OWNER
         );

  commit;

  insert into XDBPM.REVISED_TYPE_SUMMARY 
  select distinct TYPE_NAME, nvl(OWNER,'SYS'), 1
    from XDBPM.REVISED_TYPES at
   where not exists
         (
           select TYPE_NAME, OWNER
                  from XDBPM.REVISED_TYPE_ATTRS ata
            where ata.TYPE_NAME = at.TYPE_NAME
              and ata.OWNER = at.OWNER
          )
     and not exists
        (
          select COLL_TYPE, OWNER
            from XDBPM.REVISED_COLL_TYPES act
           where act.TYPE_NAME = at.TYPE_NAME
             and nvl(act.OWNER,'SYS') = nvl(at.OWNER,'SYS')
        );

  -- All collection types cost 2 COLUMN_COUNT except for the PD, XMLEXTRA and XMLNAMESPACES

  insert into XDBPM.REVISED_TYPE_SUMMARY values ('XDB$RAW_LIST_T','XDB',1);
  insert into XDBPM.REVISED_TYPE_SUMMARY values ('XDB$ENUM_T','XDB',1);

  commit;

  insert into XDBPM.REVISED_TYPE_SUMMARY
  select TYPE_NAME, nvl(OWNER,'SYS'), 2
    from XDBPM.REVISED_COLL_TYPES
   where not (OWNER = 'XDB' and TYPE_NAME = 'XDB$RAW_LIST_T');
  
  commit;
 
  select count(*) 
    into V_NEW_TYPE_COUNT 
    from XDBPM.REVISED_TYPE_SUMMARY;
 
  return V_NEW_TYPE_COUNT;

end;
-- 
function updateTypeSummary 
return number
as
  V_NEW_TYPE_COUNT NUMBER := 0;
begin

  insert into XDBPM.REVISED_TYPE_SUMMARY
  select t1.TYPE_NAME, 
         t1.OWNER, 
         sum(COLUMN_COUNT) +
         ( 
           select count(*) * 2
             from XDBPM.REVISED_TYPE_ATTRS ata, XDBPM.REVISED_TYPES at
            where ata.TYPE_NAME = t1.TYPE_NAME 
              and ata.OWNER = t1.OWNER
              and at.TYPE_NAME = ata.ATTR_TYPE_NAME
              and at.OWNER = ata.ATTR_TYPE_OWNER
              and at.FINAL = 'NO'
         ) COLUMN_COUNT
    from XDBPM.REVISED_TYPE_ATTRS ata, XDBPM.REVISED_TYPE_SUMMARY ts,
         (
           select distinct TYPE_NAME, OWNER
             from XDBPM.REVISED_TYPES at1
            where not exists
                  (
                     -- Types where all the attributes are already known..
                        select 1
                          from XDBPM.REVISED_TYPE_ATTRS ata
                         where not exists
                                   ( 
                                     select 1
                                       from XDBPM.REVISED_TYPE_SUMMARY ts
                                      where ts.TYPE_NAME = ata.ATTR_TYPE_NAME
                                        and nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
                                   )
                           and ata.TYPE_NAME = at1.TYPE_NAME
                           and ata.OWNER = at1.OWNER
                  )
              and not exists
                  (
                    select 1 
                      from XDBPM.REVISED_TYPE_SUMMARY ts
                     where at1.TYPE_NAME = ts.TYPE_NAME
                       and at1.OWNER = ts.OWNER
                  )
              and not exists
                  (
                    select 1
                      from XDBPM.REVISED_TYPES at
                     where at.SUPERTYPE_NAME = at1.TYPE_NAME
                       and at.SUPERTYPE_OWNER = at1.OWNER
                  )
         ) t1
   where ata.TYPE_NAME = t1.TYPE_NAME
     and ata.OWNER = t1.OWNER
     and ts.TYPE_NAME = ata.ATTR_TYPE_NAME
     and nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
   group by t1.TYPE_NAME, t1.OWNER;

  commit;  

  select count(*) 
    into V_NEW_TYPE_COUNT 
    from XDBPM.REVISED_TYPE_SUMMARY;
 
  return V_NEW_TYPE_COUNT;

end;
--
procedure calculateTypeSummary
--
-- Calculate the REVISED_TYPE_SUMMARY from the REVISED_TYPE_ATTS
--
as
	
  V_OLD_TYPE_COUNT NUMBER := 0;
  V_NEW_TYPE_COUNT NUMBER := 0;
  
  cursor getTypeAttributes
  is
  select t1.TYPE_NAME, 
         t1.OWNER, 
         sum(COLUMN_COUNT) +
         ( 
           select count(*) * 2
             from XDBPM.REVISED_TYPE_ATTRS ata, XDBPM.REVISED_TYPES at
            where ata.TYPE_NAME = t1.TYPE_NAME 
              and ata.OWNER = t1.OWNER
              and at.TYPE_NAME = ata.ATTR_TYPE_NAME
              and at.OWNER = ata.ATTR_TYPE_OWNER
              and at.FINAL = 'NO'
              and at.TYPECODE = 'OBJECT'
         ) COLUMN_COUNT
    from XDBPM.REVISED_TYPE_ATTRS ata, XDBPM.REVISED_TYPE_SUMMARY ts,
         (
           select distinct TYPE_NAME, OWNER
             from XDBPM.REVISED_TYPES at1
            where not exists
                  (
                     -- Types where all the attributes are already known..
                        select 1
                          from XDBPM.REVISED_TYPE_ATTRS ata
                         where not exists
                                   ( 
                                     select 1
                                       from XDBPM.REVISED_TYPE_SUMMARY ts
                                      where ts.TYPE_NAME = ata.ATTR_TYPE_NAME
                                        and nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
                                   )
                           and ata.TYPE_NAME = at1.TYPE_NAME
                           and ata.OWNER = at1.OWNER
                  )
              and not exists
                  (
                    select 1 
                      from XDBPM.REVISED_TYPE_SUMMARY ts
                     where at1.TYPE_NAME = ts.TYPE_NAME
                       and at1.OWNER = ts.OWNER
                  )
         ) t1
   where ata.TYPE_NAME = t1.TYPE_NAME
     and ata.OWNER = t1.OWNER
     and ts.TYPE_NAME = ata.ATTR_TYPE_NAME
     and nvl(ts.OWNER,'SYS') = nvl(ata.ATTR_TYPE_OWNER,'SYS')
   group by t1.TYPE_NAME, t1.OWNER;

   cursor getTypeSubtypes(C_TYPE_NAME VARCHAR2, C_OWNER VARCHAR2)
   is
   select TYPE_NAME, OWNER
     from XDBPM.REVISED_TYPES at1
    where SUPERTYPE_NAME = C_TYPE_NAME
      and SUPERTYPE_OWNER = C_OWNER;
      
  V_COLUMN_COUNT NUMBER;
  V_SUBTYPES_RESOLVED BOOLEAN;         
  
  V_ROWCOUNT NUMBER;   

begin

  V_OLD_TYPE_COUNT := 0;
  V_NEW_TYPE_COUNT := initializeTypeSummary();

  WHILE (V_OLD_TYPE_COUNT <> V_NEW_TYPE_COUNT) loop
    V_OLD_TYPE_COUNT := V_NEW_TYPE_COUNT;
    V_NEW_TYPE_COUNT := updateTypeSummary();   
  end loop;
 
  V_OLD_TYPE_COUNT := 0;

  WHILE (V_OLD_TYPE_COUNT <> V_NEW_TYPE_COUNT) loop
    V_OLD_TYPE_COUNT := V_NEW_TYPE_COUNT;

    for t in getTypeAttributes loop
      V_COLUMN_COUNT :=  t.COLUMN_COUNT;
      V_SUBTYPES_RESOLVED := TRUE;
      for st in getTypeSubtypes(T.TYPE_NAME,T.OWNER) loop
        begin
          select V_COLUMN_COUNT + (COLUMN_COUNT - t.COLUMN_COUNT) 
            into V_COLUMN_COUNT
            from XDBPM.REVISED_TYPE_SUMMARY
           where TYPE_NAME = st.TYPE_NAME
             and OWNER = st.OWNER;
        exception
          when no_data_found then
            V_SUBTYPES_RESOLVED := FALSE;
          when others then
            RAISE;
         end;
      end loop;
      if (V_SUBTYPES_RESOLVED) then
        insert into XDBPM.REVISED_TYPE_SUMMARY values (t.TYPE_NAME, nvl(t.OWNER,'SYS'), V_COLUMN_COUNT);
      end if;
    end loop;

    commit;
  
    V_NEW_TYPE_COUNT := updateTypeSummary();   
    commit;

    select count(*) 
      into V_NEW_TYPE_COUNT 
      from XDBPM.REVISED_TYPE_SUMMARY;

  end loop;

end;
--
procedure initializeTypeModel
as
begin
	execute immediate 'DELETE FROM XDBPM.REVISED_TYPES';
  execute immediate 'insert into XDBPM.REVISED_TYPES select * from XDBPM.XDBPM_ALL_TYPES';
  execute immediate 'DELETE FROM XDBPM.REVISED_COLL_TYPES';
  execute immediate 'insert into XDBPM.REVISED_COLL_TYPES select * from XDBPM.XDBPM_ALL_COLL_TYPES';
  execute immediate 'DELETE FROM XDBPM.REVISED_TYPE_ATTRS';
  execute immediate 'insert into XDBPM.REVISED_TYPE_ATTRS select * from XDBPM.XDBPM_ALL_TYPE_ATTRS';
  calculateTypeSummary();
  execute immediate 'DELETE FROM XDBPM.TYPE_SUMMARY';
  execute immediate 'insert into XDBPM.TYPE_SUMMARY select * from XDBPM.REVISED_TYPE_SUMMARY';
  commit;
 end;
--
procedure generateTypeSummary
as
begin
  initializeTypeModel();
end;
--
function getTableName(P_PARENT_SCHEMA REF XMLType, P_ELEMENT_NAME VARCHAR2, P_SQLTYPE VARCHAR2, P_OWNER VARCHAR2)
return VARCHAR2
as
--
-- Create a Unique name for this Table.
--
-- Rules are as follows
-- Name derived from element name. Name must be unqiue within the XML Schema for the ComplexType and XML Schema
--

  V_COUNTER      NUMBER(2) := 0;
  V_TABLE_NAME   VARCHAR2(30);
  V_TABLE_EXISTS NUMBER;
begin
		
	if (G_TABLE_LIST.count() > 0) then
   	for i in G_TABLE_LIST.first .. G_TABLE_LIST.last loop
   	  if ((G_TABLE_LIST(i).PARENT_SCHEMA = P_PARENT_SCHEMA) and (G_TABLE_LIST(i).ELEMENT_NAME = P_ELEMENT_NAME) and (G_TABLE_LIST(i).SQLTYPE = P_SQLTYPE)) then
   	    return G_TABLE_LIST(i).TABLE_NAME;
   	  end if;
    end loop;
  end if;
	
  G_TABLE_LIST.extend();
  G_TABLE_LIST(G_TABLE_LIST.last).PARENT_SCHEMA := P_PARENT_SCHEMA;
  G_TABLE_LIST(G_TABLE_LIST.last).ELEMENT_NAME  := P_ELEMENT_NAME;
  G_TABLE_LIST(G_TABLE_LIST.last).SQLTYPE       := P_SQLTYPE;

	V_TABLE_NAME := SUBSTR(UPPER(P_ELEMENT_NAME),1,26) || '_XML';
	
	loop
    select count(*)
      into V_TABLE_EXISTS
      from ALL_XML_TABLES
     where TABLE_NAME = V_TABLE_NAME
       and OWNER = P_OWNER;
     
    exit when V_TABLE_EXISTS = 0;

    V_COUNTER := V_COUNTER + 1;
    V_TABLE_NAME := SUBSTR(UPPER(P_ELEMENT_NAME),1,23) || '_' || LPAD(V_COUNTER,2,'0') || '_XML';
  end loop;     
     
	for i in G_TABLE_LIST.first .. G_TABLE_LIST.last loop
	  if G_TABLE_LIST(i).TABLE_NAME = V_TABLE_NAME then
	    V_COUNTER := V_COUNTER + 1;
	    V_TABLE_NAME := SUBSTR(UPPER(P_ELEMENT_NAME),1,23) || '_' || LPAD(V_COUNTER,2,'0') || '_XML';
	  end if;
  end loop;

  G_TABLE_LIST(G_TABLE_LIST.last).TABLE_NAME := V_TABLE_NAME;
  return V_TABLE_NAME;
end;
--
procedure markOutOfLine(P_PARENT_SCHEMA REF XMLTYPE, P_PROP_NUMBER NUMBER, P_ATTR_NAME VARCHAR2, P_LOCAL_ELEMENT_NAME VARCHAR2, P_TABLE_NAME VARCHAR2)
as
  V_BUFFER        VARCHAR2(2000);
  V_PARENT_SCHEMA REF XMLType;
  cursor checkGlobalComplexTypes
  is
  --
  -- Element identified by property number is part of a global complex type.
  --
  select ct.XMLDATA.NAME COMPLEX_TYPE_NAME, ct.XMLDATA.PARENT_SCHEMA PARENT_SCHEMA
    from xdb.xdb$complex_type ct
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   where existsNode(ct.OBJECT_VALUE,'/xsd:complexType/descendant::xsd:element[@xdb:propNumber="' || P_PROP_NUMBER || '"]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1
$ELSE
   where xmlExists
  	     (
  	       'declare namespace xdb = "http://xmlns.oracle.com/xdb"; (: :)
   	        $CT/xs:complexType/descendant::xs:element[@xdb:propNumber=$PROP]'
  	        passing ct.OBJECT_VALUE as "CT", P_PROP_NUMBER as "PROP"
  	     )
$END
  	 and ct.XMLDATA.PARENT_SCHEMA = P_PARENT_SCHEMA
  	 and ct.XMLDATA.NAME is not NULL;
     
  cursor checkGlobalElements
  is
  --
  -- Element identified by property number is part of a global element
  --
  select ge.XMLDATA.PROPERTY.NAME GLOBAL_ELEMENT_NAME, ge.XMLDATA.PROPERTY.PARENT_SCHEMA PARENT_SCHEMA
    from xdb.xdb$element ge
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   where existsNode(ge.OBJECT_VALUE,'/xsd:element/descendant::xsd:element[@xdb:propNumber="' || P_PROP_NUMBER || '"]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1
$ELSE
   where xmlExists
  	     (
  	       'declare namespace xdb = "http://xmlns.oracle.com/xdb"; (: :)
   	        $ELMNT/xs:element/descendant::xs:element[@xdb:propNumber=$PROP]'
  	        passing ge.OBJECT_VALUE as "ELMNT",  P_PROP_NUMBER as "PROP"
  	     )
$END
  	 and ge.XMLDATA.PROPERTY.PARENT_SCHEMA   = P_PARENT_SCHEMA
     and ge.XMLDATA.PROPERTY.GLOBAL = HEXTORAW('01');
     
  cursor checkGlobalGroups
  is
  --
  -- Element identified by property number is part of a global group
  --
	select gd.XMLDATA.NAME GLOBAL_GROUP_NAME, gd.XMLDATA.PARENT_SCHEMA PARENT_SCHEMA
	  from xdb.xdb$GROUP_DEF gd
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
   where existsNode(gd.OBJECT_VALUE,'/xsd:group/descendant::xsd:element[@xdb:propNumber="' || P_PROP_NUMBER || '"]',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES) = 1
$ELSE
   where xmlExists
  	     (
  	       'declare namespace xdb = "http://xmlns.oracle.com/xdb"; (: :)
   	        $GRP/xs:group/descendant::xs:element[@xdb:propNumber=$PROP]'
  	        passing gd.OBJECT_VALUE as "GRP",  P_PROP_NUMBER as "PROP"
  	     )
$END
	   and gd.XMLDATA.PARENT_SCHEMA = P_PARENT_SCHEMA;
	       
	 V_GLOBAL_OBJECT_FOUND BOOLEAN := FALSE;
begin

  if (not V_GLOBAL_OBJECT_FOUND) then
    for e in checkGlobalComplexTypes loop
    	V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,''' || e.COMPLEX_TYPE_NAME || ''',';
    	V_PARENT_SCHEMA := e.PARENT_SCHEMA;
    	V_GLOBAL_OBJECT_FOUND := TRUE;
    end loop;
  end if;

  if (not V_GLOBAL_OBJECT_FOUND) then
    for e in checkGlobalElements loop
    	V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_ELEMENT,''' || e.GLOBAL_ELEMENT_NAME || ''',';
    	V_PARENT_SCHEMA := e.PARENT_SCHEMA;
    	V_GLOBAL_OBJECT_FOUND := TRUE;
    end loop;
  end if;

  if (not V_GLOBAL_OBJECT_FOUND) then
    for e in checkGlobalGroups loop
    	V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_GROUP,''' || e.GLOBAL_GROUP_NAME || ''',';
    	V_PARENT_SCHEMA := e.PARENT_SCHEMA;
    	V_GLOBAL_OBJECT_FOUND := TRUE;
    end loop;
  end if;

  if (V_GLOBAL_OBJECT_FOUND) then
  	V_BUFFER := RPAD(V_BUFFER,160,' ') || '''' || P_LOCAL_ELEMENT_NAME || ''',';
    V_BUFFER := RPAD(V_BUFFER,210,' ') || '''' || P_TABLE_NAME || ''');'; 
    V_BUFFER := V_BUFFER || C_NEW_LINE;
	  for i in G_SCHEMA_REFERENCE_LIST.first .. G_SCHEMA_REFERENCE_LIST.last loop
  	  if G_SCHEMA_REFERENCE_LIST(i) = V_PARENT_SCHEMA then
  	    if not (G_SCHEMA_ANNOTATION_CACHE(i).HAS_OUT_OF_LINE_HEADER) then
          V_BUFFER := '      -- Out-of-Line mappings for 1000 Column optimization :-'  || C_BLANK_LINE || V_BUFFER;
          G_SCHEMA_ANNOTATION_CACHE(i).HAS_ANNOTATIONS := TRUE;
  	      G_SCHEMA_ANNOTATION_CACHE(i).HAS_OUT_OF_LINE_HEADER := TRUE;
  	    end if;
        DBMS_LOB.writeAppend(G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS,LENGTH(V_BUFFER),V_BUFFER);
        exit;
      end if;
    end loop;
  end if;
end;
--
procedure makeOutOfLine(P_LOCAL_ELEMENT_NAME VARCHAR2, P_TYPE_NAME VARCHAR2, P_OWNER VARCHAR2)
as
--
-- Find all local elements of the specified name and type.
--
  V_TABLE_NAME VARCHAR2(30);  

  cursor getLocalElements
  is
  select e.XMLDATA.PROPERTY.PROP_NUMBER  PROP_NUMBER,
         e.XMLDATA.PROPERTY.PARENT_SCHEMA PARENT_SCHEMA,
         e.XMLDATA.PROPERTY.SQLNAME SQLNAME,
	       case when e.XMLDATA.PROPERTY.PROPREF_REF is null     
   		     then e.XMLDATA.PROPERTY.NAME                          
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
		       else extractValue(OBJECT_VALUE,'/xsd:element/@ref',DBMS_XDB_CONSTANTS.XDBSCHEMA_PREFIXES)
$ELSE
		       else XMLCast                                          
			          (                                                      
			            XMLQuery                                             
			            (                                                    
			              '$EL/xs:element/@ref'                              
			               passing e.OBJECT_VALUE as "EL"                     
			               returning CONTENT                                  
			            )                                                   
			            as VARCHAR2(2000)                                   
			          )              
$END			                                                 
	       end LOCAL_ELEMENT_NAME
    from xdb.xdb$element e
   where e.XMLDATA.PROPERTY.SQLTYPE     = P_TYPE_NAME
     and e.XMLDATA.PROPERTY.SQLSCHEMA   = P_OWNER
     and e.XMLDATA.PROPERTY.GLOBAL      = HEXTORAW('00')
     and e.XMLDATA.PROPERTY.SQLCOLLTYPE is null
     and (( e.XMLDATA.PROPERTY.NAME = P_LOCAL_ELEMENT_NAME) or (e.XMLDATA.PROPERTY.PROPREF_NAME.NAME = P_LOCAL_ELEMENT_NAME));

begin

	for e in getLocalElements loop
    --
    -- Get the Table Name. 
    -- Table name is generated from the local element name.
    -- The table can be shared by all local elements with the same name and type within the XML Schema.
    -- The table cannot (11.2.0.1.0 and earlier) be shared accross schemas.
    -- Use The SQL Type name rather than complex type name, since this avoids a join back to the Global Element to find the name of the complexType (which might be anonymous)
    --
    V_TABLE_NAME := getTableName(e.PARENT_SCHEMA, P_LOCAL_ELEMENT_NAME, P_TYPE_NAME, P_OWNER);
    markOutOfLine(e.PARENT_SCHEMA, e.PROP_NUMBER, e.SQLNAME, e.LOCAL_ELEMENT_NAME, V_TABLE_NAME);
    update XDBPM.REVISED_TYPE_ATTRS rta
       set ATTR_TYPE_NAME = 'XMLTYPE',
           ATTR_TYPE_OWNER = 'SYS'
     where ATTR_TYPE_NAME = P_TYPE_NAME
       and ATTR_TYPE_OWNER = P_OWNER
       and ATTR_NAME = e.SQLNAME;
  end loop;

end;
--
function findLocalElementName(P_ATTR_NAME VARCHAR2, P_ATTR_TYPE_NAME VARCHAR2, P_ATTR_TYPE_OWNER VARCHAR2)
return VARCHAR2
as
  V_LOCAL_ELEMENT_NAME VARCHAR2(256);
begin
	
  -- Find the Element Name or Reference for the first element which matches the selected SQLNAME, SQLTYPE and OWNER.

  select case when e.XMLDATA.PROPERTY.PROPREF_REF is null
              then e.XMLDATA.PROPERTY.NAME
              else e.XMLDATA.PROPERTY.PROPREF_NAME.NAME
         end LOCAL_ELEMENT_NAME
    into V_LOCAL_ELEMENT_NAME
    from xdb.xdb$element e
   where e.XMLDATA.PROPERTY.SQLNAME     = P_ATTR_NAME
     and e.XMLDATA.PROPERTY.SQLTYPE     = P_ATTR_TYPE_NAME
     and e.XMLDATA.PROPERTY.SQLSCHEMA   = P_ATTR_TYPE_OWNER
     and e.XMLDATA.PROPERTY.GLOBAL      = HEXTORAW('00')
     and e.XMLDATA.PROPERTY.SQLCOLLTYPE is null
     and rownum < 2;
     
  return V_LOCAL_ELEMENT_NAME;
end;
--      
function findCandidate(P_TYPE_NAME IN VARCHAR2, P_OWNER IN VARCHAR2, P_ATTR_NAME OUT VARCHAR2, P_ATTR_TYPE_NAME OUT VARCHAR2, P_ATTR_TYPE_OWNER OUT VARCHAR2, P_BUFFER IN OUT CLOB)
return NUMBER
--
--  Find Attribute which contributes the largest number of columns to the type hierarchy. 
--
--
-- Todo : This logic can be improved by looking for non repeating choices containing elements based on complexTypes and 
-- moving all the members of the non repeating choice out of line before working on the largest element. 
-- This is because each instance document will only contain one of the members in the choice.
-- In effect the choice contributes the sum of it's members.
-- This can probably be calculated by finding the COMPLEXTYPE for the P_TYPE_NAME (There should be only 1) and then looking for CHOICES in that type.
-- Once the choices are found calculate the same of the attributes for that choice and determine whether or not it is worth moving each member of 
-- the choice out of line. 
--
-- Todo : Consider choosing optional elements before mandatory elements.
--
-- Todo : For memory otpimization (4030 errors), as distinct from column count optimization the logic needs to be extended to consider the number of columns in the 
-- types behind collection types.
--
as
  V_COLUMN_COUNT       NUMBER; 
  V_TYPE_NAME          VARCHAR2(30);
  V_OWNER              VARCHAR2(30);
    
  -- 
  --  Fix for Phantom Types generated by Schema Registration : Add condition that the type name must map to xdb.xdb$complex_type.
  --  
    
  cursor getCandidate 
  is
  select TYPE_NAME, OWNER, ATTR_NAME, ATTR_TYPE_NAME, ATTR_TYPE_OWNER, COLUMN_COUNT
    from (
           select rt.TYPE_NAME, rt.OWNER, rta.ATTR_NAME, rta.ATTR_TYPE_NAME, rta.ATTR_TYPE_OWNER, rts.COLUMN_COUNT, MAX(COLUMN_COUNT) over () MAX_COLUMN_COUNT
             from XDBPM.REVISED_TYPES rt, XDBPM.REVISED_TYPE_ATTRS rta, XDBPM.REVISED_TYPE_SUMMARY rts, XDB.XDB$COMPLEX_TYPE ct
            where rta.type_name = rt.type_name
              and rta.owner = rt.owner
              and rts.type_name = rta.attr_type_name
              and rts.owner = nvl(rta.attr_type_owner,'SYS')
              and rt.TYPE_NAME = ct.XMLDATA.SQLTYPE
                  connect by rt.supertype_name = prior rt.type_name
                         and rt.supertype_owner = prior rt.owner
                  start with rt.type_name = P_TYPE_NAME
                         and rt.owner = P_OWNER
         )
   where COLUMN_COUNT = MAX_COLUMN_COUNT
     and ROWNUM < 2;
    
   V_BUFFER VARCHAR2(4000);
   
begin

  -- V_BUFFER := '#DEBUG -- Find Candidate : Type Name "' || P_TYPE_NAME || '"; Owner "' || P_OWNER || '"' || C_NEW_LINE;
  -- DBMS_LOB.writeAppend(P_BUFFER,LENGTH(V_BUFFER),V_BUFFER);

  for c in getCandidate loop
      P_ATTR_NAME       := c.ATTR_NAME;
      V_TYPE_NAME       := c.TYPE_NAME;
      V_OWNER           := c.OWNER;
      P_ATTR_TYPE_NAME  := c.ATTR_TYPE_NAME;
      P_ATTR_TYPE_OWNER := c.ATTR_TYPE_OWNER;
      V_COLUMN_COUNT    := c.COLUMN_COUNT;
      V_BUFFER := '--   Processing "' || P_ATTR_NAME || '" of type "' || P_ATTR_TYPE_OWNER || '"."'|| P_ATTR_TYPE_NAME || '" in type "' || V_OWNER || '"."' || V_TYPE_NAME || '". Columns = ' || V_COLUMN_COUNT || '.' || C_NEW_LINE;
      DBMS_LOB.writeAppend(P_BUFFER,LENGTH(V_BUFFER),V_BUFFER);
  end loop;

  
  if (V_COLUMN_COUNT > 1000) then
    V_COLUMN_COUNT := findCandidate(P_ATTR_TYPE_NAME, P_ATTR_TYPE_OWNER, P_ATTR_NAME, P_ATTR_TYPE_NAME, P_ATTR_TYPE_OWNER, P_BUFFER);
  end if;
  
  return V_COLUMN_COUNT;

end;
--
function optimizeTypeModel(P_TYPE_ANALYSIS_PATH VARCHAR2, P_LIMIT NUMBER DEFAULT 2)
return BOOLEAN
as
  V_TYPE_NAME               VARCHAR2(30);
  V_OWNER                   VARCHAR2(30);
  V_COLUMN_COUNT            NUMBER(4);  
  V_ATTR_NAME               VARCHAR2(30);
  V_LOCAL_ELEMENT_NAME      VARCHAR2(256);

  V_OPTIMIZATION_COMPLETE   BOOLEAN := FALSE;
  V_OPTIMIZATION_SUCCESSFUL BOOLEAN := TRUE;
  
  -- Find Type that requires More than C_COLUMN_LIMIT columns to persist. (This allows for extra hidden columns 
  -- 5 For XMLType Namespaces and Extras, PD etc
  -- 2 For Hierarchically Enabled Tables.
  -- 1 or 2 based on Final Type / Non Final Type
  
  cursor findLargeType
  is
  select TYPE_NAME, OWNER, COLUMN_COUNT
    from (
            SELECT rts.TYPE_NAME, rts.OWNER, COLUMN_COUNT, MAX(COLUMN_COUNT) over ( ) MAX_COLUMN_COUNT
              FROM XDBPM.REVISED_TYPE_SUMMARY rts
                  ,XDB.XDB$COMPLEX_TYPE ct
                  ,TABLE(G_SCHEMA_REFERENCE_LIST) sl           
             where rts.OWNER = ct.XMLDATA.SQLSCHEMA
               and rts.TYPE_NAME = ct.XMLDATA.SQLTYPE
               and ct.XMLDATA.PARENT_SCHEMA = sl.COLUMN_VALUE
               and rts.COLUMN_COUNT > XDB_OPTIMIZE_XMLSCHEMA.COLUMN_LIMIT()
         )  
   WHERE COLUMN_COUNT = MAX_COLUMN_COUNT
     and ROWNUM < 2;

  V_CONTENT CLOB;                              
  V_BUFFER  VARCHAR2(4000);
begin 
	
  initializeTypeModel();

  while (not V_OPTIMIZATION_COMPLETE) loop
    V_OPTIMIZATION_COMPLETE := TRUE;
    for t in findLargeType loop
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call); 
      V_BUFFER := '-- Type "' || t.OWNER || '"."' || t.TYPE_NAME || '" requires ' || t.COLUMN_COUNT || ' columns : Commencing Type Structure optimization -' || C_NEW_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
      V_OPTIMIZATION_COMPLETE := FALSE;
      V_COLUMN_COUNT := findCandidate(t.TYPE_NAME, t.OWNER, V_ATTR_NAME, V_TYPE_NAME, V_OWNER, V_CONTENT);   
      if (V_COLUMN_COUNT > P_LIMIT) then
        -- V_BUFFER := '#DEBUG - Find Local Element Name : Attr Name "' || V_ATTR_NAME || '"; Type Name "' || V_TYPE_NAME || '; Type Owner "' || V_OWNER || '".' || C_NEW_LINE;
        -- DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
        V_LOCAL_ELEMENT_NAME := findLocalElementName(V_ATTR_NAME, V_TYPE_NAME, V_OWNER);
        DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
        XDB_OUTPUT.writeToFile(P_TYPE_ANALYSIS_PATH,V_CONTENT);
        makeOutOfLine(V_LOCAL_ELEMENT_NAME, V_TYPE_NAME, V_OWNER); 
        calculateTypeSummary();    
      else
        V_OPTIMIZATION_COMPLETE := TRUE;
        V_OPTIMIZATION_SUCCESSFUL := FALSE;
        V_BUFFER := '--' || C_NEW_LINE 
                 || '-- Unable to optimize type model.' || C_NEW_LINE
                 || '--' || C_NEW_LINE;
        DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
        XDB_OUTPUT.writeToFile(P_TYPE_ANALYSIS_PATH,V_CONTENT);
      end if;
    end loop;
  end loop;  

  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call); 
  V_BUFFER := '--' || C_NEW_LINE 
           || '-- Optimization Complete. --' || C_NEW_LINE
           || '--' || C_NEW_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
  XDB_OUTPUT.writeToFile(P_TYPE_ANALYSIS_PATH,V_CONTENT);
          
  return V_OPTIMIZATION_SUCCESSFUL;
  
exception
  when OTHERS then
    if (V_CONTENT is NULL) then
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call); 
    end if;    
    V_BUFFER := '--' || C_NEW_LINE 
           	 || '-- Error Detected During Optimization. --' || C_NEW_LINE
           	 || '--' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_STACK() || C_BLANK_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_BUFFER := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() || C_BLANK_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    XDB_OUTPUT.writeToFile(P_TYPE_ANALYSIS_PATH,V_CONTENT);
    RAISE;
  
end;
--
procedure addDependentSchemas(P_SCHEMA_LOCATION_HINT VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER, P_SCHEMA_LOCATION_LIST IN OUT XDB.XDB$STRING_LIST_T)
as
  V_SCHEMA_COUNT NUMBER;
  cursor getSchemaLocations
  is
  select distinct L.SCHEMA_LOCATION
    from xdb.xdb$schema sc, table(sc.XMLDATA.INCLUDES) l
   where sc.XMLDATA.SCHEMA_URL = P_SCHEMA_LOCATION_HINT
     and not exists
         ( 
           select 1
             from TABLE(P_SCHEMA_LOCATION_LIST) k
            where l.SCHEMA_LOCATION = k.COLUMN_VALUE
         )
  union all
  select distinct L.SCHEMA_LOCATION
    from xdb.xdb$schema sc, table(sc.XMLDATA.IMPORTS) l
   where sc.XMLDATA.SCHEMA_URL = P_SCHEMA_LOCATION_HINT
     and not exists
         ( 
           select 1
             from TABLE(P_SCHEMA_LOCATION_LIST) k
            where l.SCHEMA_LOCATION = k.COLUMN_VALUE
         );

begin
	V_SCHEMA_COUNT := P_SCHEMA_LOCATION_LIST.last;
  for sc in getSchemaLocations loop
    P_SCHEMA_LOCATION_LIST.extend();
    P_SCHEMA_LOCATION_LIST(P_SCHEMA_LOCATION_LIST.last) := sc.SCHEMA_LOCATION;
  end loop;

  if (P_SCHEMA_LOCATION_LIST.last > V_SCHEMA_COUNT) then
    for i in V_SCHEMA_COUNT + 1 .. P_SCHEMA_LOCATION_LIST.last loop
      addDependentSchemas(P_SCHEMA_LOCATION_LIST(i), P_OWNER, P_SCHEMA_LOCATION_LIST);
    end loop;
  end if;
end;
--	
function loadSchemaAnnotationCache(P_SCHEMA_LOCATION_LIST XDB.XDB$STRING_LIST_T)
return SCHEMA_ANNOTATION_LIST_T
as
  V_SCHEMA_ANNOTATION_CACHE SCHEMA_ANNOTATION_LIST_T := SCHEMA_ANNOTATION_LIST_T();
  V_CONTENT CLOB;
  
  cursor getSchemas 
  is
  SELECT SCHEMA_URL, OWNER, 
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
				 XDB_OPTIMIZE_XMLSCHEMA.getXMLSchemaRef(SCHEMA_URL,OWNER) SCHEMA_REFERENCE
$ELSE				 
         MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) SCHEMA_REFERENCE
$END         
    from ALL_XML_SCHEMAS
        ,TABLE(P_SCHEMA_LOCATION_LIST) sl
   where SCHEMA_URL = sl.COLUMN_VALUE;
begin
  G_SCHEMA_REFERENCE_LIST := XDB.XDB$XMLTYPE_REF_LIST_T();
	for s in getSchemas loop
    G_SCHEMA_REFERENCE_LIST.extend();
    G_SCHEMA_REFERENCE_LIST(G_SCHEMA_REFERENCE_LIST.last) := s.SCHEMA_REFERENCE;

    V_SCHEMA_ANNOTATION_CACHE.extend();
    DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);

    V_SCHEMA_ANNOTATION_CACHE(V_SCHEMA_ANNOTATION_CACHE.last).SCHEMA_LOCATION_HINT   := s.SCHEMA_URL;
    V_SCHEMA_ANNOTATION_CACHE(V_SCHEMA_ANNOTATION_CACHE.last).OWNER                  := s.OWNER;
    
    V_SCHEMA_ANNOTATION_CACHE(V_SCHEMA_ANNOTATION_CACHE.last).SCHEMA_ANNOTATIONS     := V_CONTENT;
    V_SCHEMA_ANNOTATION_CACHE(V_SCHEMA_ANNOTATION_CACHE.last).HAS_ANNOTATIONS        := FALSE;
    V_SCHEMA_ANNOTATION_CACHE(V_SCHEMA_ANNOTATION_CACHE.last).HAS_OUT_OF_LINE_HEADER := FALSE;
  end loop;
  
  return V_SCHEMA_ANNOTATION_CACHE;
  
end;
--
function getDefaultTableList
return TABLE_LIST_T
as
  V_TABLE_LIST TABLE_LIST_T := TABLE_LIST_T(); 
  
  cursor getDefaultTables 
  is
  select e.XMLDATA.DEFAULT_TABLE TABLE_NAME, 
         e.XMLDATA.PROPERTY.PARENT_SCHEMA PARENT_SCHEMA, 
         e.XMLDATA.PROPERTY.NAME ELEMENT_NAME, 
         e.XMLDATA.PROPERTY.SQLTYPE SQLTYPE
	  from XDB.XDB$ELEMENT e
        ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
   where e.XMLDATA.PROPERTY.PARENT_SCHEMA = sl.COLUMN_VALUE
     and e.XMLDATA.PROPERTY.GLOBAL        = HEXTORAW('00')
     and e.XMLDATA.DEFAULT_TABLE is not NULL;
 
begin
	for t in getDefaultTables loop
    V_TABLE_LIST.extend();
    V_TABLE_LIST(V_TABLE_LIST.last).PARENT_SCHEMA := t.PARENT_SCHEMA;
    V_TABLE_LIST(V_TABLE_LIST.last).ELEMENT_NAME  := t.ELEMENT_NAME;
    V_TABLE_LIST(V_TABLE_LIST.last).SQLTYPE       := t.SQLTYPE;
    V_TABLE_LIST(V_TABLE_LIST.last).TABLE_NAME    := t.TABLE_NAME;
  end loop;
  
  return V_TABLE_LIST;
end;
--
procedure enforceDomFidelity
--
--  Enforce DOM Fidelity for the following use-cases
--  
--  #1. ComplexType contains an element that is the head of a substitution group
-- 
--  #2. ComplexType contains an element that is defined as Mixed Text
--
--  #3. ComplexType contains an element that contains a repeating choice.
--
--  #4. ComplexType contains a choice ... - This is need until the bug about printing in Schema Defined order is fixed. 
--
as
--
  cursor getComplexTypes
  is
  select  distinct SCHEMA_ID, NAME, XPATH, PREFIX
    from (  
           select MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) SCHEMA_ID, NAME, SUBSTR(XPATH,11) XPATH, PREFIX
             from XMLTABLE(
                    'declare namespace functx = "http://www.functx.com"; 
         						 declare namespace xdbpm = "http://xmlns.oracle.com/xdb/xdbpm"; 
         						 
                     declare function functx:index-of-node ( $nodes as node()* , $nodeToFind as node() ) as xs:integer* {
                       for $seq in (1 to count($nodes))
                       return $seq[$nodes[$seq] is $nodeToFind]
                     };
                     
                     declare function functx:path-to-node-with-pos ( $node as node()? ) as xs:string {     
                       string-join
                       (
                         for $ancestor in $node/ancestor-or-self::*
                           let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
                           return concat
                                  (
                                    name($ancestor),
                
                                    if (count($sibsOfSameName) <= 1) then 
                                      ''''
                                    else 
                                      concat
                                      (
                                        ''['',
                                        functx:index-of-node($sibsOfSameName,$ancestor),
                                        '']''
                                      )
                                  ),
                         ''/''
                       )
                     };
                                          
                     declare function xdbpm:substitutable-elements ( $schemaList as  node() * ) as xs:string* {           
                       let $subGroupHeadList := for $e in $schemaList/SCHEMA/xs:schema/xs:element[@substitutionGroup]
                                                  return xdbpm:qname-to-string($e/@substitutionGroup,$e)
                       let $subGroupHeadList := fn:distinct-values($subGroupHeadList)
                       return $subGroupHeadList
                     }; 
                     
                     declare function xdbpm:qname-to-string ( $qname as xs:string, $context as node() ) as xs:string { 
                       let $qn := fn:resolve-QName( $qname, $context)
                       return concat(fn:namespace-uri-from-QName($qn),":",fn:local-name-from-QName($qn))
                     }; 
                                          
         						 declare function xdbpm:getComplexType ( $schemaList as node()* , $targetNamespace as xs:string, $typename as xs:string ) as node() {  
                       let $ct := if (fn:empty($targetNamespace)  or ($targetNamespace="")) then
                                    $schemaList/SCHEMA/xs:schema[not(@targetNamespace)]/xs:complexType[@name=$typename]
                                  else
                                    $schemaList/SCHEMA/xs:schema[@targetNamespace=$targetNamespace]/xs:complexType[@name=$typename] 
                       return $ct
                     };                         
                                            
                     declare function xdbpm:getParentType($schemaList as node()*, $extension as node()) as node() {
                       let $qn := fn:resolve-QName( $extension/@base, $extension)
                       return xdbpm:getComplexType($schemaList,fn:namespace-uri-from-QName($qn),fn:local-name-from-QName($qn))
                     };

                     declare function xdbpm:processComplexType($schemaList as node()*, $complexType as node()) as node() {                               
                       if ($complexType[not(xs:complexContent/xs:extension[not(@base="xs:anyType")])]) then
                         if ($complexType/@name) then
                           <Result>
                             <SCHEMA_ID>{fn:root($complexType)/ROW/SCHEMA_ID/text()}</SCHEMA_ID>
                             <NAME>{fn:data($complexType/@name)}</NAME>
           								 </Result> 
                         else
                           <Result>
                             <SCHEMA_ID>{fn:root($complexType)/ROW/SCHEMA_ID/text()}</SCHEMA_ID>
                             <XPATH>{functx:path-to-node-with-pos($complexType)}</XPATH>
                             <PREFIX>{fn:prefix-from-QName(fn:node-name(fn:root($complexType)/ROW/SCHEMA/xs:schema))}</PREFIX>
             		      	   </Result> 
                       else
                         <Result>
    								     { 
     								       xdbpm:processComplexType ( $schemaList, xdbpm:getParentType($schemaList,$complexType/xs:complexContent/xs:extension))/*
     								     }
                         </Result>                       
                     };

                     let $schemaList := fn:collection("oradb:/PUBLIC/ALL_XML_SCHEMAS")/ROW
                     let $subGroupHeaders := xdbpm:substitutable-elements ( $schemaList)
                     
                     for $schema in $schemaList
                       for $ct in $schema/SCHEMA/xs:schema//xs:complexType
                         return if ($ct[@mixed="true"]) then
                                  xdbpm:processComplexType($schemaList,$ct)
                                else
                                  if ($ct[descendant::xs:choice[@maxOccurs="unbounded" or @maxOccurs > 1]]) then
                                    xdbpm:processComplexType($schemaList,$ct)
                                  else
(:                                    
                                    if ($ct[descendant::xs:choice]) then
                                      xdbpm:processComplexType($schemaList,$ct)
                                    else 
:)                                
                                      for $e in $ct//xs:element[@ref]
                                      where xdbpm:qname-to-string($e/@ref,$e) = $subGroupHeaders
                                      return xdbpm:processComplexType($schemaList,$ct)'
                     COLUMNS
                     SCHEMA_ID        RAW(16),
                     NAME       VARCHAR2(256),
                     XPATH      VARCHAR2(700),
                     PREFIX     VARCHAR2(32)
                  )
         ) sg,
   TABLE (G_SCHEMA_REFERENCE_LIST) sl
   where sg.SCHEMA_ID = sl.COLUMN_VALUE
   order by sg.SCHEMA_ID;

  V_PREV_SCHEMA REF XMLTYPE;
  V_BUFFER      VARCHAR2(4000);
  V_CONTENT     CLOB;   
begin
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- DOM Fidelity enabled due to presence of mixed text, substitution group heads, or repeating choice structures in complex type defintion :-'  || C_BLANK_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_PREV_SCHEMA := NULL;
  for p in getComplexTypes loop
    if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> p.SCHEMA_ID) then
       DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
       appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
       DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
       V_BUFFER := '  -- DOM Fidelity enabled due to presence of mixed text, substitution group heads, or repeating choice structures in complex type defintion :-'  || C_BLANK_LINE;
       DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
	   end if;
	   if (p.NAME is not NULL) then
  	   V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.enableMaintainDOM(V_XML_SCHEMA,''' || p.NAME || ''',TRUE);' || C_BLANK_LINE;
  	 else
  	   -- 
  	   -- Normalize XML Schema prefix to 'xsd:'
  	   --
  	   if (p.PREFIX is not null) then
  	     V_BUFFER := '  XDB_EDIT_XMLSCHEMA.setMaintainDOM(V_XML_SCHEMA,''' || replace(p.XPATH,'/' || p.PREFIX || ':','/xsd:') || ''',''true'');' || C_BLANK_LINE;
  	   else
  	     V_BUFFER := '  XDB_EDIT_XMLSCHEMA.setMaintainDOM(V_XML_SCHEMA,''' || replace(p.XPATH,'/','/xsd:') || ''',''true'');' || C_BLANK_LINE;
  	   end if;
  	 end if;
     DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
     V_PREV_SCHEMA := p.SCHEMA_ID;
  end loop;

  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;

  if (V_CONTENT is not NULL) then
    DBMS_LOB.freeTemporary(V_CONTENT);
  end if;
       
end;
--
procedure addOutOfLineStorage(P_PARENT_SCHEMA REF XMLTYPE DEFAULT NULL)
--
-- Capture existing Out of Line Mappings 
--
as
  V_CONTENT     CLOB;
  V_BUFFER      VARCHAR2(1024);
  V_PREV_SCHEMA REF XMLType;
 
  cursor complexTypeMappings
  is
  select XSD_TYPE_NAME, 
         case 
            WHEN XSD_ELEMENT_NAME is NULL
            THEN XSD_ELEMENT_REF
            ELSE XSD_ELEMENT_NAME
         end XSD_ELEMENT_NAME,
         XDB_DEFAULT_TABLE,
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
				 P_PARENT_SCHEMA PARENT_SCHEMA
$ELSE         
         MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) PARENT_SCHEMA
$END
    from ALL_XML_SCHEMAS sc
        ,XMLTABLE(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:schema/xsd:complexType[descendant::xsd:element[@xdb:defaultTable]]'
           passing SCHEMA
           columns
           XSD_TYPE_NAME VARCHAR2(2000) path '@name',
           ELEMENT_LIST  XMLTYPE        path 'descendant::xsd:element[@xdb:defaultTable]'
         )
        ,XMLTable(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:element'
           passing ELEMENT_LIST
           columns
           XSD_ELEMENT_NAME  VARCHAR2(2000) path '@name',
           XSD_ELEMENT_REF   VARCHAR2(2000) path '@ref',
           XDB_DEFAULT_TABLE VARCHAR2(30)  path '@xdb:defaultTable'
         )
        ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
	where P_PARENT_SCHEMA = sl.COLUMN_VALUE
$ELSE         
   where MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) = sl.COLUMN_VALUE
$END
   order by PARENT_SCHEMA, XDB_DEFAULT_TABLE, XSD_TYPE_NAME;
   
  cursor globalElementMappings
  is
  select XSD_GLOBAL_ELEMENT_NAME, 
         case 
            WHEN XSD_ELEMENT_NAME is NULL
            THEN XSD_ELEMENT_REF
            ELSE XSD_ELEMENT_NAME
         end XSD_ELEMENT_NAME,
         XDB_DEFAULT_TABLE,
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
				 P_PARENT_XMLSCHEMA PARENT_SCHEMA
$ELSE         
         MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) PARENT_SCHEMA
$END
    from ALL_XML_SCHEMAS sc
        ,XMLTABLE(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:schema/xsd:element[descendant::xsd:element[@xdb:defaultTable]]'
           passing SCHEMA
           columns
           XSD_GLOBAL_ELEMENT_NAME VARCHAR2(2000) path '@name',
           ELEMENT_LIST            XMLTYPE       path 'descendant::xsd:element[@xdb:defaultTable]'
         )
        ,XMLTable(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:element'
           passing ELEMENT_LIST
           columns
           XSD_ELEMENT_NAME  VARCHAR2(2000) path '@name',
           XSD_ELEMENT_REF   VARCHAR2(2000) path '@ref',
           XDB_DEFAULT_TABLE VARCHAR2(30)  path '@xdb:defaultTable'
         )
        ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
	where P_PARENT_SCHEMA = sl.COLUMN_VALUE
$ELSE         
   where MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) = sl.COLUMN_VALUE
$END
   order by PARENT_SCHEMA, XDB_DEFAULT_TABLE, XSD_ELEMENT_NAME;

  cursor groupMappings
  is
  select XSD_GROUP_NAME, 
         case 
            WHEN XSD_ELEMENT_NAME is NULL
            THEN XSD_ELEMENT_REF
            ELSE XSD_ELEMENT_NAME
         end XSD_ELEMENT_NAME,
         XDB_DEFAULT_TABLE,
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
				 P_PARENT_SCHEMA = PARENT_SCHEMA
$ELSE         
         MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) PARENT_SCHEMA
$END
    from ALL_XML_SCHEMAS sc
        ,XMLTABLE(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:schema/xsd:group[descendant::xsd:element[@xdb:defaultTable]]'
           passing SCHEMA
           columns
           XSD_GROUP_NAME VARCHAR2(2000) path '@name',
           ELEMENT_LIST   XMLTYPE       path 'descendant::xsd:element[@xdb:defaultTable]'
         )
        ,XMLTable(
           xmlNamespaces(
             'http://www.w3.org/2001/XMLSchema' as "xsd",
             'http://xmlns.oracle.com/xdb' as "xdb"
           ),
           '/xsd:element'
           passing ELEMENT_LIST
           columns
           XSD_ELEMENT_NAME  VARCHAR2(2000) path '@name',
           XSD_ELEMENT_REF   VARCHAR2(2000) path '@ref',
           XDB_DEFAULT_TABLE VARCHAR2(30)  path '@xdb:defaultTable'
         )
        ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
	where P_PARENT_SCHEMA = sl.COLUMN_VALUE
$ELSE         
   where MAKE_REF(XDB.XDB$SCHEMA,SCHEMA_ID) = sl.COLUMN_VALUE
$END
   order by PARENT_SCHEMA, XDB_DEFAULT_TABLE, XSD_GROUP_NAME;

begin
  
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- Out-of-Line mappings for global complex types :-'  || C_BLANK_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_PREV_SCHEMA := NULL;
	for ct in complexTypeMappings loop
	  if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> ct.PARENT_SCHEMA) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_BUFFER := '  -- Out-of-Line mappings for global complex types :-'  || C_BLANK_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
	  end if;
	  V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_COMPLEX_TYPE,''' || ct.XSD_TYPE_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,160,' ');
	  V_BUFFER := V_BUFFER || '''' || ct.XSD_ELEMENT_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,210,' ');
	  V_BUFFER := V_BUFFER || '''' || ct.XDB_DEFAULT_TABLE || ''');' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_PREV_SCHEMA := ct.PARENT_SCHEMA;
  end loop;

  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;
  
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- Out-of-Line mappings for global elements :-'  || C_BLANK_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_PREV_SCHEMA := NULL;
	for ge in globalElementMappings loop
	  if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> ge.PARENT_SCHEMA) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_BUFFER := '  -- Out-of-Line mappings for global elements :-'  || C_BLANK_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
	  end if;
	  V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_ELEMENT,''' || ge.XSD_GLOBAL_ELEMENT_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,160,' ');
	  V_BUFFER := V_BUFFER || '''' || ge.XSD_ELEMENT_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,210,' ');
	  V_BUFFER := V_BUFFER || '''' || ge.XDB_DEFAULT_TABLE || ''');' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_PREV_SCHEMA := ge.PARENT_SCHEMA;
  end loop;

  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;

  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- Out-of-Line mappings for global groups :-'  || C_BLANK_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_PREV_SCHEMA := NULL;
	for g in groupMappings loop
	  if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> g.PARENT_SCHEMA) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_BUFFER := '  -- Out-of-Line mappings for global groups :-'  || C_BLANK_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
	  end if;
	  V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setOutOfLine(V_XML_SCHEMA,DBMS_XDB_CONSTANTS.XSD_GROUP,''' || g.XSD_GROUP_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,160,' ');
	  V_BUFFER := V_BUFFER || '''' || g.XSD_ELEMENT_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,210,' ');
	  V_BUFFER := V_BUFFER || '''' || g.XDB_DEFAULT_TABLE || ''');' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_PREV_SCHEMA := g.PARENT_SCHEMA;
  end loop;

  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;

  if (V_CONTENT is not NULL) then
    DBMS_LOB.freeTemporary(V_CONTENT);
  end if;
    
end;
--
procedure addGlobalTypeNames(P_REUSE_GENERATED_NAMES BOOLEAN DEFAULT FALSE)
--
-- Capture existing Type Mapping for the Global Elements and ComplexTypes
--
as
  V_LIMIT                 NUMBER;
  V_CONTENT               CLOB;
  V_BUFFER                VARCHAR2(1024);
  V_PREV_SYSTEM_GENERATED NUMBER;
  V_PREV_SCHEMA REF       XMLType;
  
  cursor complexTypeMappings
  is
  select COMPLEX_TYPE_NAME, SQL_TYPE, PARENT_SCHEMA, SYSTEM_GENERATED
    from (
           select case when regexp_like(ct.XMLDATA.SQLTYPE,'[0-9]{3}_T$')
                       then 1
                       else 0
                  end                      SYSTEM_GENERATED,
                  ct.XMLDATA.NAME          COMPLEX_TYPE_NAME, 
                  ct.XMLDATA.SQLTYPE       SQL_TYPE, 
                  ct.XMLDATA.PARENT_SCHEMA PARENT_SCHEMA
             from XDB.XDB$COMPLEX_TYPE ct
                 ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
            where ct.XMLDATA.PARENT_SCHEMA  = sl.COLUMN_VALUE
              and ct.XMLDATA.NAME is not NULL
         )
   where SYSTEM_GENERATED < V_LIMIT
   order by PARENT_SCHEMA, SYSTEM_GENERATED, COMPLEX_TYPE_NAME;
  
  cursor globalElementMappings
  is
  select ELEMENT_NAME, SQL_TYPE, PARENT_SCHEMA, SYSTEM_GENERATED
    from (
           select case when regexp_like(e.XMLDATA.PROPERTY.SQLTYPE,'[0-9]{3}_T$')
                       then 1
                       else 0
                  end                              SYSTEM_GENERATED,
                  e.XMLDATA.PROPERTY.NAME          ELEMENT_NAME, 
                  e.XMLDATA.PROPERTY.SQLTYPE       SQL_TYPE, 
                  e.XMLDATA.PROPERTY.PARENT_SCHEMA PARENT_SCHEMA
             from XDB.XDB$ELEMENT e
                 ,TABLE(G_SCHEMA_REFERENCE_LIST) sl
            where e.XMLDATA.PROPERTY.PARENT_SCHEMA = sl.COLUMN_VALUE
              and e.XMLDATA.PROPERTY.TYPENAME is NULL
              and e.XMLDATA.PROPERTY.SQLTYPE <> 'VARCHAR2' -- Default mapping for Elements with no specific type attribute.
              and e.XMLDATA.PROPERTY.GLOBAL = HEXTORAW('01')
          )
   where SYSTEM_GENERATED < V_LIMIT
   order by PARENT_SCHEMA, SYSTEM_GENERATED, ELEMENT_NAME;

begin
  
  if P_REUSE_GENERATED_NAMES then
    -- Include System Generated Names in the list
    V_LIMIT := 2;  
  else
    -- Exclude System Generated Names in the list
    V_LIMIT := 1;
  end if;
  
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- SQLType names for global complex types :-'  || C_NEW_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
  
  V_PREV_SCHEMA := NULL;
  V_PREV_SYSTEM_GENERATED := -1;
	for ct in complexTypeMappings loop
	  if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> ct.PARENT_SCHEMA) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_BUFFER := '  -- SQLType names for global complex types :-'  || C_NEW_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
      V_PREV_SYSTEM_GENERATED := -1;
	  end if;
	  if (V_PREV_SYSTEM_GENERATED <> ct.SYSTEM_GENERATED) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    V_PREV_SYSTEM_GENERATED := ct.SYSTEM_GENERATED;
	  end if;
	  V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XML_SCHEMA,''' || ct.COMPLEX_TYPE_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,120,' ');
	  V_BUFFER := V_BUFFER || '''' || ct.SQL_TYPE || ''');' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_PREV_SCHEMA := ct.PARENT_SCHEMA;
  end loop;
  
  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;
  
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER := '  -- SQLType names for global elements based on local complex types :-'  || C_NEW_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

  V_PREV_SCHEMA := NULL;
  V_PREV_SYSTEM_GENERATED := -1;
	for ge in globalElementMappings loop
	  if (V_PREV_SCHEMA is not NULL and V_PREV_SCHEMA <> ge.PARENT_SCHEMA) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_BUFFER := '      -- SQLType names for global elements based on local complex types :-'  || C_NEW_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);	    
      V_PREV_SYSTEM_GENERATED := -1;
	  end if;
	  if (V_PREV_SYSTEM_GENERATED <> ge.SYSTEM_GENERATED) then
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
	    V_PREV_SYSTEM_GENERATED := ge.SYSTEM_GENERATED;
	  end if;
	  V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.setSQLType(V_XML_SCHEMA,''' ||  ge.ELEMENT_NAME || ''',';
	  V_BUFFER := RPAD(V_BUFFER,120,' ');
	  V_BUFFER := V_BUFFER || '''' || ge.SQL_TYPE || ''');' || C_NEW_LINE;
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    V_PREV_SCHEMA := ge.PARENT_SCHEMA;
  end loop;
  
  if (V_PREV_SCHEMA is not null) then
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);
    appendSchemaAnnotations(V_PREV_SCHEMA,V_CONTENT);
  end if;
  
  if (V_CONTENT is not NULL) then
    DBMS_LOB.freeTemporary(V_CONTENT);
  end if;
    
end;
--
procedure printSchemaList(P_RESOURCE_PATH VARCHAR2, P_SCHEMA_LOCATION_LIST XDB.XDB$STRING_LIST_T, P_TARGET_PATH VARCHAR2)
as
  V_BUFFER  VARCHAR2(32000);
  V_CONTENT CLOB;
begin

  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);

  if ((P_SCHEMA_LOCATION_LIST is NULL) or (P_SCHEMA_LOCATION_LIST.count() = 0)) then

    if (instr(P_TARGET_PATH,'.xsd',-1) = (LENGTH(P_TARGET_PATH)-4)) then
      V_BUFFER := '-- Unable to locate XML Schema "' || P_TARGET_PATH || '"'  || C_NEW_LINE;
    else
      V_BUFFER := '-- Unable to locate any XML Schemas in folder "' || P_TARGET_PATH || '" '  || C_NEW_LINE;
    end if;

    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    
  else
  
    V_BUFFER := '-- Processing the following XML Schemas :- ' || C_NEW_LINE
             || '-- ' || C_NEW_LINE;
  
    DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

    for i in P_SCHEMA_LOCATION_LIST.first + 1 .. P_SCHEMA_LOCATION_LIST.last loop
       V_BUFFER := '--    ' || P_SCHEMA_LOCATION_LIST(i)  || C_NEW_LINE;
       DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
    end loop;
     	
  end if;

  XDB_OUTPUT.writeToFile(P_RESOURCE_PATH,V_CONTENT);
 
end;
--
function getSchemaLocationList(P_SCHEMA_LOCATION_HINT VARCHAR2)
return XDB.XDB$STRING_LIST_T
as
  --
  -- Get the complete list of dependant schemas for the target XML Schema.
  -- 
  V_SCHEMA_EXISTS NUMBER;
  V_SCHEMA_LOCATION_LIST XDB.XDB$STRING_LIST_T := XDB.XDB$STRING_LIST_T();
  
  V_FIRST_SCHEMA binary_integer;
  V_LAST_SCHEMA  binary_integer;
begin
	
  V_FIRST_SCHEMA := 1;
  V_SCHEMA_LOCATION_LIST.extend();
  V_SCHEMA_LOCATION_LIST(V_SCHEMA_LOCATION_LIST.last) := P_SCHEMA_LOCATION_HINT;
    
  loop
    V_LAST_SCHEMA := V_SCHEMA_LOCATION_LIST.last;
    for x in V_FIRST_SCHEMA .. V_LAST_SCHEMA loop
      addDependentSchemas(V_SCHEMA_LOCATION_LIST(x), USER, V_SCHEMA_LOCATION_LIST);
    end loop;  
    
    V_FIRST_SCHEMA := V_LAST_SCHEMA + 1;
    exit when (V_FIRST_SCHEMA > V_SCHEMA_LOCATION_LIST.last);
  end loop;
    
  return V_SCHEMA_LOCATION_LIST;

end;
--
procedure addAnnotations(P_XML_SCHEMA_CONFIGURATION IN OUT XMLTYPE)
as
  V_ANNOTATIONS   XMLType;
  V_BUFFER        VARCHAR2(4000);
  V_NAMESPACE_URI VARCHAR2(1024);
begin

$IF $$DEBUG $THEN
   XDB_OUTPUT.writeTraceFileEntry('P_XML_SCHEMA_CONFIGURATION',TRUE);
   XDB_OUTPUT.writeTraceFileEntry(P_XML_SCHEMA_CONFIGURATION,TRUE);
$END

	select XMLCast(XMLQuery('for $i in fn:namespace-uri($XML/*) return $i' passing P_XML_SCHEMA_CONFIGURATION as "XML" returning content) as VARCHAR2(1024))
	  into V_NAMESPACE_URI
	  from DUAL;

  -- V_NAMESPACE_URI := P_XML_SCHEMA_CONFIGURATION.getNamespace();
    
$IF $$DEBUG $THEN
  XDB_OUTPUT.writeTraceFileEntry('V_NAMESPACE_URI',TRUE);
  XDB_OUTPUT.writeTraceFileEntry(V_NAMESPACE_URI,TRUE);
$END
	  
	for i in G_SCHEMA_ANNOTATION_CACHE.first .. G_SCHEMA_ANNOTATION_CACHE.last loop
    if G_SCHEMA_ANNOTATION_CACHE(i).HAS_ANNOTATIONS then

$IF $$DEBUG $THEN
      XDB_OUTPUT.writeTraceFileEntry('G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS',TRUE);
      XDB_OUTPUT.writeTraceFileEntry(G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS,TRUE);
$END

  		select  XMLElement
               (
                 "rc:Annotations",
                 xmlattributes(V_NAMESPACE_URI as "xmlns:rc"),
                 G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS
               )
        into V_ANNOTATIONS 
        from dual;
        
$IF $$DEBUG $THEN
      XDB_OUTPUT.writeTraceFileEntry('V_ANNOTATIONS',TRUE);
      XDB_OUTPUT.writeTraceFileEntry(V_ANNOTATIONS,TRUE);
      XDB_OUTPUT.writeTraceFileEntry('G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_LOCATION_HINT',TRUE);
      XDB_OUTPUT.writeTraceFileEntry(G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_LOCATION_HINT,TRUE);
$END              
      select insertChildXML
             (
               P_XML_SCHEMA_CONFIGURATION,
               '/rc:RegistrationList/rc:Schema[rc:SchemaLocationHint="' || G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_LOCATION_HINT || '"]',
               'rc:Annotations',
               V_ANNOTATIONS,
               'xmlns:rc="' || V_NAMESPACE_URI || '"'
             )
        into P_XML_SCHEMA_CONFIGURATION
        from DUAL;
    end if;
  end loop;  
end;
--
function getFileName(P_PATH VARCHAR2)
return VARCHAR2
as
  V_FILENAME VARCHAR2(4000);
begin
  V_FILENAME := P_PATH;
  V_FILENAME := substr(V_FILENAME,1,instr(V_FILENAME,'.',-1)-1);
	
  if instr(V_FILENAME,'/',-1) > 1 then
	  V_FILENAME := substr(V_FILENAME,instr(V_FILENAME,'/',-1)+1);
	end if;
	
	return V_FILENAME;
end;
--
function doTypeAnalysis(P_XML_SCHEMA_CONFIGURATION IN OUT XMLTYPE, P_SCHEMA_LOCATION_HINT VARCHAR2 DEFAULT NULL, P_OWNER VARCHAR2 DEFAULT USER, P_LIMIT NUMBER DEFAULT 3)
return BOOLEAN
as
  V_OPTIMIZATION_SUCCESSFUL        BOOLEAN := FALSE;     

  V_PARENT_XMLSCHEMA REF           XMLTYPE := NULL;
  V_SCHEMA_LOCATION_LIST           XDB.XDB$STRING_LIST_T;
  
  V_CONFIGURATION_FILENAME         VARCHAR2(700);
  V_TYPE_OPTIMIZATION_FILENAME     VARCHAR2(700);
  
  V_TARGET                         VARCHAR2(700);
  V_COMMENT                        VARCHAR2(32000);
begin

  V_TARGET 	                    := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@target','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_CONFIGURATION_FILENAME      := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationConfigurationFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_TYPE_OPTIMIZATION_FILENAME  := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/typeOptimizationTraceFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
		
  createOutputFile(V_TYPE_OPTIMIZATION_FILENAME);  
  		
	V_COMMENT := '--' ||  C_NEW_LINE 
	          || '-- Type analysis log for "' || V_TARGET || '"' || C_NEW_LINE 
	          || '--' || C_NEW_LINE
            || '-- Initiating Object-Relational type model optimization for "' || V_TARGET || '"' || C_NEW_LINE 
	          || '--' || C_NEW_LINE;

  XDB_OUTPUT.writeToFile(V_TYPE_OPTIMIZATION_FILENAME,V_COMMENT);
   
	          
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
	V_PARENT_XMLSCHEMA := XDBPM_ANALYZE_XMLSCHEMA.getXMLSchemaRef(P_SCHEMA_LOCATION_HINT,P_OWNER) PARENT_SCHEMA
$END
  
 	V_SCHEMA_LOCATION_LIST    := getSchemaLocationList(P_SCHEMA_LOCATION_HINT);

	printSchemaList(V_TYPE_OPTIMIZATION_FILENAME, V_SCHEMA_LOCATION_LIST, V_TARGET);  

  if (V_SCHEMA_LOCATION_LIST is not null) then
	  G_TABLE_LIST              := getDefaultTableList();
  	G_SCHEMA_ANNOTATION_CACHE := loadSchemaAnnotationCache(V_SCHEMA_LOCATION_LIST);
    enforceDomFidelity();
    addGlobalTypeNames(TRUE);
    addOutOfLineStorage(V_PARENT_XMLSCHEMA);
    V_OPTIMIZATION_SUCCESSFUL := optimizeTypeModel(V_TYPE_OPTIMIZATION_FILENAME,P_LIMIT);
    if (V_OPTIMIZATION_SUCCESSFUL) then
      addAnnotations(P_XML_SCHEMA_CONFIGURATION);
    end if;
  end if;
  
  $IF $$DEBUG $THEN
    XDB_OUTPUT.flushTraceFile();
  $END

  return V_OPTIMIZATION_SUCCESSFUL;
end;	
--
function generateRegistrationScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) 
return CLOB
as
  V_BUFFER     VARCHAR2(32000);
  V_SCRIPT     CLOB;
  V_RESULT     BOOLEAN;
   
  cursor getSchemas 
  is
  select * 
    from XMLTable
         (
           xmlNamespaces
           (
              default 'http://xmlns.oracle.com/xdb/pm/registrationConfiguration'
           ),
           '/SchemaRegistrationConfiguration/SchemaInformation'
           passing P_XML_SCHEMA_CONFIGURATION
           columns
           SCHEMA_LOCATION_HINT VARCHAR2(700) PATH 'schemaLocationHint',
           REPOSITORY_PATH      VARCHAR2(700) PATH 'repositoryPath',
           FORCE_OPTION         VARCHAR2(5)   PATH 'force',
           ANNOTATIONS          CLOB          PATH 'annotations'
         );

  V_EVENTS                   VARCHAR2(32000);
  V_OPTIONS                  VARCHAR2(64);
  V_ENABLE_HIERARCHY_OPTION  VARCHAR2(64);
  
  V_LOCATION_PREFIX          VARCHAR2(700);
  V_SCHEMA_LOCATION_HINT     VARCHAR2(700);
begin
	
  V_OPTIONS := '0';

  V_LOCATION_PREFIX := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@schemaLocationPrefix','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration').getStringVal();

  if (LENGTH(V_LOCATION_PREFIX) > 0) then
    if (INSTR(V_LOCATION_PREFIX,'/',-1) <> LENGTH(V_LOCATION_PREFIX)) then
      V_LOCATION_PREFIX := V_LOCATION_PREFIX || '/';
    end if;
  end if;

  if (G_OPTIONS is not NULL) then
    V_OPTIONS := G_OPTIONS;
    if (G_OPTIONS = DBMS_XMLSCHEMA.REGISTER_NODOCID) then
      V_OPTIONS := 'DBMS_XMLSCHEMA.REGISTER_NODOCID';
    end if;
			$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
			$ELSE   
    	if (G_OPTIONS = DBMS_XMLSCHEMA.REGISTER_BINARYXML) then
        V_OPTIONS := 'DBMS_XMLSCHEMA.REGISTER_BINARYXML';
      end if;
      if (G_OPTIONS = DBMS_XMLSCHEMA.REGISTER_NT_AS_IOT) then
        V_OPTIONS := 'DBMS_XMLSCHEMA.REGISTER_NT_AS_IOT';
    end if;
    $END
  end if;

  V_ENABLE_HIERARCHY_OPTION := 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE';

		if (G_ENABLE_HIERARCHY is not NULL) then
    V_ENABLE_HIERARCHY_OPTION := 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_INVALID';
    if (G_ENABLE_HIERARCHY = DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE) then
  	  V_ENABLE_HIERARCHY_OPTION := 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE';
    end if;
    if (G_ENABLE_HIERARCHY = DBMS_XMLSCHEMA.ENABLE_HIERARCHY_CONTENTS) then
     V_ENABLE_HIERARCHY_OPTION := 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_CONTENTS';
    end if;
    if (G_ENABLE_HIERARCHY = DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA) then
	      V_ENABLE_HIERARCHY_OPTION := 'DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA';
    end if;
  end if;

  V_EVENTS := '--'  || C_NEW_LINE;
  
  if (G_EVENT_LIST.count() > 0) then
    for i in G_EVENT_LIST.first .. G_EVENT_LIST.last loop
      V_EVENTS := V_EVENTS || 'alter session set events ''' || G_EVENT_LIST(i).EVENT || ' trace name context forever, level ' || G_EVENT_LIST(i).LEVEL || '''' || C_NEW_LINE;
      V_EVENTS := V_EVENTS || '/'  || C_NEW_LINE;
      V_EVENTS := V_EVENTS || '--' || C_NEW_LINE;
    end loop;
  end if;
           
  V_SCRIPT := V_EVENTS;

  -- V_BUFFER := 'begin' || C_NEW_LINE
	--          || '  XDB_EDIT_XMLSCHEMA.getGroupDefinitions(''' || P_XMLSCHEMA_FOLDER || ''');' || C_NEW_LINE
  --          || 'end;' || C_NEW_LINE
  --          || '/' || C_BLANK_LINE;

  -- DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  for s in getSchemas() loop
 	
 	  V_SCHEMA_LOCATION_HINT := V_LOCATION_PREFIX || s.SCHEMA_LOCATION_HINT;
 	
    V_BUFFER := 'declare' || C_NEW_LINE
             || '  V_XML_SCHEMA_PATH        VARCHAR2(700) := ''' || s.REPOSITORY_PATH || ''';' || C_NEW_LINE
             || '  V_NEW_SCHEMA_PATH        VARCHAR2(700) := ''' || replace(s.REPOSITORY_PATH,'.xsd','.xdb.xsd') || ''';' || C_NEW_LINE
             || '  V_XML_SCHEMA             XMLType       := xdburitype(V_XML_SCHEMA_PATH).getXML(); ' || C_NEW_LINE
             || '  V_SCHEMA_LOCATION_HINT   VARCHAR2(700) := ''' || V_SCHEMA_LOCATION_HINT || '''; ' || C_NEW_LINE
             || 'begin' || C_NEW_LINE
						 || '  DBMS_XMLSCHEMA_ANNOTATE.printWarnings(FALSE);' || C_BLANK_LINE
 --          || '  -- XDB_EDIT_XMLSCHEMA.expandRepeatingGroups(V_XML_SCHEMA);' || C_BLANK_LINE
             || '  -- XDB_EDIT_XMLSCHEMA.expandAllGroups(V_XML_SCHEMA);' || C_BLANK_LINE
             || '  XDB_EDIT_XMLSCHEMA.removeAppInfo(V_XML_SCHEMA);' || C_NEW_LINE
             || '  XDB_EDIT_XMLSCHEMA.fixRelativeURLs(V_XML_SCHEMA,V_SCHEMA_LOCATION_HINT);' || C_BLANK_LINE;
    
    DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

    if (G_OPTIONS <> DBMS_XMLSCHEMA.REGISTER_BINARYXML) then
      V_BUFFER := '  XDB_EDIT_XMLSCHEMA.mapAnyToClob(V_XML_SCHEMA);' || C_NEW_LINE
               || '  XDB_EDIT_XMLSCHEMA.applySQLTypeMappings(V_XML_SCHEMA);' || C_BLANK_LINE;
      DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
    end if;
    
    if (G_DISABLE_DEFAULT_TABLES) then
      V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.disableDefaultTableCreation(V_XML_SCHEMA);' || C_BLANK_LINE;
      DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
    end if;
  
    if (G_DISABLE_DOM_FIDELITY) then
      V_BUFFER := '  DBMS_XMLSCHEMA_ANNOTATE.disableMaintainDom(V_XML_SCHEMA,FALSE);' || C_BLANK_LINE;
      DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
    end if;

    if (s.ANNOTATIONS is not NULL) then
      DBMS_LOB.APPEND(V_SCRIPT,s.ANNOTATIONS);
    end if;
    
    V_BUFFER := '  XDB_EDIT_XMLSCHEMA.saveAnnotatedSchema(V_NEW_SCHEMA_PATH, V_XML_SCHEMA);' || C_BLANK_LINE
             || '  commit;' || C_BLANK_LINE 
             || 'end;' || C_NEW_LINE
             || '/' || C_NEW_LINE
             || 'declare' || C_NEW_LINE
             || '  V_XML_SCHEMA_PATH        VARCHAR2(700) := ''' || replace(s.REPOSITORY_PATH,'.xsd','.xdb.xsd') || ''';' || C_NEW_LINE
             || '  V_XML_SCHEMA             XMLType       := xdburitype(V_XML_SCHEMA_PATH).getXML(); ' || C_NEW_LINE
             || '  V_SCHEMA_LOCATION_HINT   VARCHAR2(700) := ''' || V_SCHEMA_LOCATION_HINT || '''; ' || C_NEW_LINE
             || '  V_REGISTRATION_TIMESTAMP TIMESTAMP; ' || C_NEW_LINE
             || 'begin' || C_NEW_LINE
             || '  V_REGISTRATION_TIMESTAMP := SYSTIMESTAMP; ' || C_BLANK_LINE
             || '  DBMS_XMLSCHEMA.registerSchema(' || C_NEW_LINE
             || '    SCHEMAURL       => V_SCHEMA_LOCATION_HINT' || C_NEW_LINE
             || '   ,SCHEMADOC       => V_XML_SCHEMA' || C_NEW_LINE
             || '   ,LOCAL           => '   || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(G_LOCAL) || C_NEW_LINE
             || '   ,GENTYPES        => '   || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(G_GENTYPES) || C_NEW_LINE
             || '   ,GENTABLES       => '   || XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(G_GENTABLES) || C_NEW_LINE
             || '   ,FORCE           => '   || UPPER(s.FORCE_OPTION) || C_NEW_LINE
             || '   ,OWNER           => ''' || G_OWNER || '''' || C_NEW_LINE
             || '   ,ENABLEHIERARCHY => '   || V_ENABLE_HIERARCHY_OPTION || C_NEW_LINE
             || '   ,OPTIONS         => '   || V_OPTIONS || C_NEW_LINE
             ||'  );' || C_BLANK_LINE;
             
    DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

    if (G_OPTIONS <> DBMS_XMLSCHEMA.REGISTER_BINARYXML) then
      V_BUFFER :='  XDB_ANALYZE_SCHEMA.deleteOrphanTypes(V_REGISTRATION_TIMESTAMP);' || C_BLANK_LINE;
      DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
    end if;
    
   V_BUFFER := 'end;' || C_NEW_LINE
            || '/' || C_NEW_LINE;

  DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  end loop;
  
  return V_SCRIPT;
end;
--
function createSchemaRegistrationScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) 
return VARCHAR2
as
  pragma                         autonomous_transaction;
  V_SCRIPT                       CLOB;
  V_TARGET                       VARCHAR2(700);
  V_CONFIGURATION_FILENAME       VARCHAR2(700);
  V_REGISTRATION_SCRIPT_FILENAME VARCHAR2(700);
  V_COMMENT                      VARCHAR2(32000); 
  V_SPOOL_FILENAME               VARCHAR2(700);
begin

  V_TARGET 	                      := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@target','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_CONFIGURATION_FILENAME        := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationConfigurationFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_REGISTRATION_SCRIPT_FILENAME  := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationScriptFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
		
	V_SPOOL_FILENAME := getFileName(V_REGISTRATION_SCRIPT_FILENAME);
	V_SPOOL_FILENAME := substr(V_SPOOL_FILENAME,1,instr(V_SPOOL_FILENAME,'.',-1));
		
	V_COMMENT := 'set echo on' || C_NEW_LINE 
	          || 'spool ' || V_SPOOL_FILENAME || '.log' || C_NEW_LINE 
						|| '--' || C_NEW_LINE 
	          || '-- Schema Registration Script for "' || V_TARGET || '"' || C_NEW_LINE 
	          || '--' || C_NEW_LINE;

 	V_SCRIPT := V_COMMENT;
 	DBMS_LOB.APPEND(V_SCRIPT,generateRegistrationScript(P_XML_SCHEMA_CONFIGURATION));
  XDB_UTILITIES.uploadResource(V_REGISTRATION_SCRIPT_FILENAME,V_SCRIPT,XDB_CONSTANTS.VERSION);
  XDB_UTILITIES.uploadResource(V_CONFIGURATION_FILENAME,P_XML_SCHEMA_CONFIGURATION,XDB_CONSTANTS.VERSION);
  commit;
  
  return V_REGISTRATION_SCRIPT_FILENAME;
end;
--
procedure createSchemaRegistrationScript(P_RESOURCE_PATH VARCHAR2)
as
  V_CONTENT CLOB;
  V_BUFFER  VARCHAR2(4000);
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
  
begin
	for i in G_SCHEMA_ANNOTATION_CACHE.first .. G_SCHEMA_ANNOTATION_CACHE.last loop
    if G_SCHEMA_ANNOTATION_CACHE(i).HAS_ANNOTATIONS then
      DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
      V_SCHEMA_LOCATION_HINT := G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_LOCATION_HINT;
      
      V_BUFFER := ' -- Annotations for "' || V_SCHEMA_LOCATION_HINT || '" --' ||  C_BLANK_LINE
               || '  if (V_SCHEMA_LOCATION_HINT = ''' || V_SCHEMA_LOCATION_HINT || ''') THEN ' || C_BLANK_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);

      DBMS_LOB.append(V_CONTENT,G_SCHEMA_ANNOTATION_CACHE(i).SCHEMA_ANNOTATIONS);
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(C_NEW_LINE),C_NEW_LINE);

      V_BUFFER :=  '  end if;' || C_BLANK_LINE;
      DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
      
      XDB_OUTPUT.writeToFile(P_RESOURCE_PATH,V_CONTENT);
    end if;
  end loop;
  
  DBMS_LOB.createTemporary(V_CONTENT,TRUE,DBMS_LOB.call);
  V_BUFFER :=  '-- End of Script --' || C_BLANK_LINE;
  DBMS_LOB.writeAppend(V_CONTENT,LENGTH(V_BUFFER),V_BUFFER);
  XDB_OUTPUT.writeToFile(P_RESOURCE_PATH,V_CONTENT);
end;
--
procedure describeAnnotations(P_RESOURCE_PATH VARCHAR2, P_SCHEMA_LOCATION_HINT VARCHAR2,P_OWNER VARCHAR2 DEFAULT USER)
as
  V_REUSE_GENERATED_NAMES BOOLEAN := TRUE;
  
  V_SCHEMA_LOCATION_LIST XDB.XDB$STRING_LIST_T;
  V_PARENT_XMLSCHEMA REF XMLTYPE := NULL;
begin

$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
	V_PARENT_XMLSCHEMA := XDB_OPTIMIZE_XMLSCHEMA.getXMLSchemaRef(P_SCHEMA_LOCATION_HINT,P_OWNER) PARENT_SCHEMA
$END

	V_SCHEMA_LOCATION_LIST    := getSchemaLocationList(P_SCHEMA_LOCATION_HINT);

  createOutputFile(P_RESOURCE_PATH);  
	printSchemaList(P_RESOURCE_PATH, V_SCHEMA_LOCATION_LIST, P_SCHEMA_LOCATION_HINT);
	    
  if (V_SCHEMA_LOCATION_LIST is not null) then G_TABLE_LIST              := 
    getDefaultTableList(); 
    G_SCHEMA_ANNOTATION_CACHE := loadSchemaAnnotationCache(V_SCHEMA_LOCATION_LIST); 
    addGlobalTypeNames(TRUE); 
    addOutOfLineStorage(V_PARENT_XMLSCHEMA); 
    createSchemaRegistrationScript(P_RESOURCE_PATH); 
  end if;

end;	
--
procedure setSchemaRegistrationOptions(
           P_LOCAL                BOOLEAN        DEFAULT TRUE,  
           P_GENTYPES             BOOLEAN        DEFAULT TRUE,  
           P_GENTABLES            BOOLEAN        DEFAULT TRUE, 
           P_OWNER                VARCHAR2       DEFAULT NULL, 
           P_ENABLE_HIERARCHY     BINARY_INTEGER DEFAULT DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE,
           P_OPTIONS              BINARY_INTEGER DEFAULT NULL
        )
as
begin
	G_LOCAL            := P_LOCAL;
	G_GENTYPES         := P_GENTYPES;
	G_GENTABLES        := P_GENTABLES;
	G_OWNER            := P_OWNER;
	G_ENABLE_HIERARCHY := P_ENABLE_HIERARCHY;
	G_OPTIONS          := P_OPTIONS;
end;
--
procedure setRegistrationScriptOptions(
           P_DISABLE_DOM_FIDELITY   BOOLEAN        DEFAULT FALSE
        )
as
begin
	G_DISABLE_DOM_FIDELITY   := P_DISABLE_DOM_FIDELITY;
end;
--
procedure setEvent(P_EVENT VARCHAR2, P_LEVEL VARCHAR2) 
as
begin
	G_EVENT_LIST.extend();
	G_EVENT_LIST(G_EVENT_LIST.last).EVENT := P_EVENT;
	G_EVENT_LIST(G_EVENT_LIST.last).LEVEL := P_LEVEL;
end;
--
$IF DBMS_DB_VERSION.VER_LE_10_2 $THEN
--
function getXMLSchemaREF(P_SCHEMA_LOCATION_HINT VARCHAR2,P_OWNER VARCHAR2) 
return REF XMLTYPE
as
  V_SCHEMA_REF REF XMLTYPE;
begin
	select ref(s)
	  into V_SCHEMA_REF
	  from XDB.XDB$SCHEMA s
	 where s.XMLDATA.SCHEMA_URL = P_SCHEMA_LOCATION_HINT
	   and s.XMLDATA.SCHEMA_OWNER = P_OWNER;
	 return V_SCHEMA_REF;
end;
--
$END
--
function generateDeleteSchemaScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) 
return CLOB
as
  V_BUFFER               VARCHAR2(32000);
  V_SCRIPT               CLOB;
  V_RESULT               BOOLEAN;
  V_LOCATION_PREFIX      VARCHAR2(700);
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
  V_LOCAL_PATH           VARCHAR2(700);
  
  cursor getSchemas 
  is
  select * 
    from XMLTable
         (
           xmlNamespaces
           (
              default 'http://xmlns.oracle.com/xdb/pm/registrationConfiguration'
           ),
           '/SchemaRegistrationConfiguration/SchemaInformation'
           passing P_XML_SCHEMA_CONFIGURATION
           columns
           SCHEMA_INDEX         FOR ORDINALITY,
           SCHEMA_LOCATION_HINT VARCHAR2(700) PATH 'schemaLocationHint'
         )
   ORDER BY SCHEMA_INDEX DESC;
begin

 	DBMS_LOB.createTemporary(V_SCRIPT,FALSE,DBMS_LOB.CALL);
 
  V_LOCATION_PREFIX := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@schemaLocationPrefix','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration').getStringVal();

  if (LENGTH(V_LOCATION_PREFIX) > 0) then
    if (INSTR(V_LOCATION_PREFIX,'/',-1) <> LENGTH(V_LOCATION_PREFIX)) then
      V_LOCATION_PREFIX := V_LOCATION_PREFIX || '/';
    end if;
  end if;
	
  for s in getSchemas() loop

    V_LOCAL_PATH := s.SCHEMA_LOCATION_HINT;
    if (INSTR(V_LOCAL_PATH,'/') = 1) THEN
	    V_LOCAL_PATH := SUBSTR(V_LOCAL_PATH,2);
    end if;
 
	  V_SCHEMA_LOCATION_HINT := V_LOCATION_PREFIX || s.SCHEMA_LOCATION_HINT;

 		V_BUFFER := 'declare' || C_NEW_LINE
 		         || '  V_SCHEMA_LOCATION_HINT VARCHAR2(700) := ''' || V_LOCATION_PREFIX || V_LOCAL_PATH || '''; ' || C_NEW_LINE
 		         || '  V_XML_SCHEMA            XMLTYPE;' || C_NEW_LINE || C_NEW_LINE
 		         || 'begin' || C_NEW_LINE
 		         || '  select SCHEMA' || C_NEW_LINE
 		         || '    into V_XML_SCHEMA' || C_NEW_LINE
             || '    from USER_XML_SCHEMAS' || C_NEW_LINE
             || '   where SCHEMA_URL = V_SCHEMA_LOCATION_HINT;' || C_NEW_LINE  || C_NEW_LINE
             || '  DBMS_XMLSCHEMA.deleteSchema(V_SCHEMA_LOCATION_HINT,4);' || C_NEW_LINE || C_NEW_LINE
             || '  XDB_XMLSCHEMA_UTILITIES.cleanXMLSchemaArtifacts(V_XML_SCHEMA); ' || C_NEW_LINE || C_NEW_LINE
             || 'end;' || C_NEW_LINE
             || '/' || C_NEW_LINE;

    DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  end loop;
  
  return V_SCRIPT;

end;
--
procedure appendScript(P_SCRIPT_PATH VARCHAR2,P_ADDITIONAL_CONTENT CLOB) 
as
  V_SCRIPT_CONTENT       CLOB;
begin
  select xdburitype(P_SCRIPT_PATH).getClob()
	  into V_SCRIPT_CONTENT 
	  from dual;

  DBMS_LOB.append(V_SCRIPT_CONTENT, P_ADDITIONAL_CONTENT);
  XDB_UTILITIES.uploadResource(P_SCRIPT_PATH,V_SCRIPT_CONTENT,XDB_CONSTANTS.version);  
  commit;
end;
--
procedure appendTableCreationScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE)
as
--
  pragma autonomous_transaction;

  TYPE T_XML_TABLE_LIST 
       IS TABLE OF VARCHAR2(32) 
       INDEX BY VARCHAR2(32);
       
  V_XML_TABLE_LIST  T_XML_TABLE_LIST;

  V_NEW_TABLE_NAME  VARCHAR2(32);
  V_COUNTER         NUMBER(2);
  
  V_BUFFER               VARCHAR2(32000);
  V_SCRIPT               CLOB;           
  V_SCRIPT_FILE          VARCHAR2(700);
  V_TARGET               VARCHAR2(700);
  V_LOCATION_PREFIX      VARCHAR2(700);
  V_SCHEMA_LOCATION_HINT VARCHAR2(700);
  
  V_SCOPE_XMLREFERENCES VARCHAR2(4000)
     := '--' || C_NEW_LINE 
     || 'begin' || C_NEW_LINE
     || '  DBMS_XMLSTORAGE_MANAGE.SCOPEXMLREFERENCES();' || C_NEW_LINE
     || 'end;' || C_NEW_LINE
     || '/' || C_NEW_LINE
     || '--' || C_NEW_LINE
     || 'select IS_SCOPED, COUNT(*)' || C_NEW_LINE   
     || '  from user_refs' || C_NEW_LINE   
     || ' group by IS_SCOPED' || C_NEW_LINE   
     || '/' || C_NEW_LINE
     || 'select table_name, column_name' || C_NEW_LINE   
     || '  from USER_REFS' || C_NEW_LINE   
     || ' where IS_SCOPED = ''''NO''' || C_NEW_LINE   
     || '/' || C_NEW_LINE ;
  
  cursor getGlobalElements
  is
  select SCHEMA_URL, ELEMENT
    from XMLTable(
           xmlNamespaces(
              'http://xmlns.oracle.com/xdb/pm/registrationConfiguration' as "rc"
           ),
           '$CONFIG/rc:SchemaRegistrationConfiguration/rc:Table'
            passing P_XML_SCHEMA_CONFIGURATION as "CONFIG"
            COLUMNS 
              SCHEMA_URL   VARCHAR2(700) path 'rc:schemaLocationHint',
              ELEMENT      VARCHAR2(256) path 'rc:globalElement'
         );
  
  cursor getXMLTables
  is
  select TABLE_NAME 
	  from USER_XML_TABLES;
           
  V_STORAGE_CLAUSE VARCHAR2(128);

begin

  V_TARGET 	        := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@target','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_SCRIPT_FILE     := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationScriptFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
  V_LOCATION_PREFIX := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@schemaLocationPrefix','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration').getStringVal();

  if (LENGTH(V_LOCATION_PREFIX) > 0) then
    if (INSTR(V_LOCATION_PREFIX,'/',-1) <> LENGTH(V_LOCATION_PREFIX)) then
      V_LOCATION_PREFIX := V_LOCATION_PREFIX || '/';
    end if;
  end if;
	
	V_SCRIPT := '--' ||  C_NEW_LINE 
	         || '-- Table creation Script for "' || V_TARGET || '"' || C_NEW_LINE 
	         || '--' || C_NEW_LINE;

  V_BUFFER := 'select TABLE_NAME' || C_NEW_LINE
           || '  from USER_XML_TABLES' || C_NEW_LINE
           || ' order by TABLE_NAME'|| C_NEW_LINE
           || '/' || C_NEW_LINE;

  DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  if (G_OPTIONS = DBMS_XMLSCHEMA.REGISTER_BINARYXML) then
    V_STORAGE_CLAUSE := 'SECUREFILE BINARY XML';
  else
    V_STORAGE_CLAUSE := 'OBJECT RELATIONAL';
  end if;
	
	for t in getXMLTables loop
	  V_XML_TABLE_LIST(t.TABLE_NAME) := t.TABLE_NAME;
  end loop;
      
  for t in getGlobalElements loop
    V_NEW_TABLE_NAME := UPPER(SUBSTR(t.ELEMENT,1,24)) || '_TABLE';

	  V_SCHEMA_LOCATION_HINT := t.SCHEMA_URL;
    if (INSTR(V_SCHEMA_LOCATION_HINT,'/') = 1) THEN
	    V_SCHEMA_LOCATION_HINT := SUBSTR(V_SCHEMA_LOCATION_HINT,2);
    end if;
 
	  V_SCHEMA_LOCATION_HINT := V_LOCATION_PREFIX || V_SCHEMA_LOCATION_HINT;

    V_COUNTER := 0;    
    while (V_XML_TABLE_LIST.exists(V_NEW_TABLE_NAME)) loop
	    V_COUNTER := V_COUNTER + 1;
	    V_NEW_TABLE_NAME := SUBSTR(UPPER(t.ELEMENT),1,21) || '_' || LPAD(V_COUNTER,2,'0') || '_TABLE';
	  end loop;

    V_XML_TABLE_LIST(V_NEW_TABLE_NAME) := V_NEW_TABLE_NAME;
    
    V_BUFFER := 'CREATE TABLE "' || V_NEW_TABLE_NAME || '" of XMLTYPE'  || C_NEW_LINE
             || 'XMLTYPE STORE AS ' || V_STORAGE_CLAUSE  || C_NEW_LINE
             || 'XMLSCHEMA "' || V_SCHEMA_LOCATION_HINT || '" ELEMENT "' || t.ELEMENT || '"' || C_NEW_LINE
             || '/'||  C_BLANK_LINE;
             
    DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  end loop;
  
  V_BUFFER := 'select TABLE_NAME' || C_NEW_LINE
           || '  from USER_XML_TABLES' || C_NEW_LINE
           || ' order by TABLE_NAME'|| C_NEW_LINE
           || '/' || C_NEW_LINE;

  DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  if (G_OPTIONS != DBMS_XMLSCHEMA.REGISTER_BINARYXML) then
    DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_SCOPE_XMLREFERENCES),V_SCOPE_XMLREFERENCES);
  end if;
  
  appendScript(V_SCRIPT_FILE,V_SCRIPT);
  
end;          
--
procedure appendFileUploadScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE)
as
--
  pragma autonomous_transaction;

  V_CREATE_IGNORE_LIST VARCHAR2(4000)
    := 'declare' ||  C_NEW_LINE
    || '  V_FILELIST_PATH VARCHAR2(700) := ''%IGNORE_FILES_PATH%'';' ||  C_NEW_LINE
    || '  V_RESULT BOOLEAN;' ||  C_NEW_LINE 
    || 'begin' ||  C_NEW_LINE 
    || '  if not (DBMS_XDB.existsResource()) then'||  C_NEW_LINE 
    || '    V_RESULT := DBMS_XDB.createResource(V_FILELIST_PATH,XMLType(''<Files/>''));' ||  C_NEW_LINE
    || '    commit;' ||  C_NEW_LINE
    || '  end if;' ||  C_NEW_LINE
    || 'end;' ||  C_NEW_LINE
    || '/' ||  C_NEW_LINE;

  V_FIELD_SIZES             VARCHAR2(4000)
    := 'column PATH                 FORMAT A64' || C_NEW_LINE 
    || 'column OWNER                FORMAT A16' || C_NEW_LINE 
    || 'column TABLE_NAME           FORMAT A32' || C_NEW_LINE 
    || 'column ELEMENT              FORMAT A32' || C_NEW_LINE 
    || 'column NAMESPACE            FORMAT A64' || C_NEW_LINE 
    || 'column SCHEMA_LOCATION_HINT FORMAT A64' || C_NEW_LINE 
    || 'column SCHEMA_URL           FORMAT A64' || C_NEW_LINE;

  V_PROCESS_INSTANCE_DOCUMENTS VARCHAR2(4000) 
    := 'select *' || C_NEW_LINE 
    || '  from TABLE(' || C_NEW_LINE 
    || '         XDB_REGISTRATION_HELPER.getInstanceDocuments(''%FOLDER_PATH%'')' || C_NEW_LINE 
    || '        )' || C_NEW_LINE 
    || '/' || C_NEW_LINE
    || 'call XDB_REGISTRATION_HELPER.loadInstanceDocuments(''%FOLDER_PATH%'',''%LOGFILE_NAME%'')' || C_NEW_LINE
    || '/' || C_NEW_LINE
    || 'set long 1000000 pages 0 lines 256 trimspool on' || C_NEW_LINE
	  || 'column log format A250' || C_NEW_LINE
    || 'select xdburitype(''%FOLDER_PATH%/%LOGFILE_NAME%'').getClob() LOG' || C_NEW_LINE
    || ' from DUAL' || C_NEW_LINE
    || '/' || C_NEW_LINE;
                       
  V_TARGET                   VARCHAR2(700);
  V_SCRIPT_FILE              VARCHAR2(700);
                             
  V_BUFFER                   VARCHAR2(32000);
  V_SCRIPT                   CLOB;           
                             
  V_IGNORE_FILES_PATH        VARCHAR2(700);
  V_FOLDER_PATH              VARCHAR2(700);
  V_LOGFILE_NAME             VARCHAR2(700);
  
  V_STORAGE_CLAUSE           VARCHAR2(128);
  V_INSTANCE_UPLOAD_FILENAME VARCHAR2(700);
begin

  V_TARGET 	                 := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@target','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_SCRIPT_FILE              := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationScriptFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
  V_INSTANCE_UPLOAD_FILENAME := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/instanceUploadLog/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();

	
	V_FOLDER_PATH := substr(V_INSTANCE_UPLOAD_FILENAME,1,instr(V_INSTANCE_UPLOAD_FILENAME,'/',-1)-1);
	V_LOGFILE_NAME  := substr(V_INSTANCE_UPLOAD_FILENAME,instr(V_INSTANCE_UPLOAD_FILENAME,'/',-1)+1);
	
	V_SCRIPT := '--' ||  C_NEW_LINE 
	          || '-- File Upload Script for "' || V_TARGET || '"' || C_NEW_LINE 
	          || '--' || C_NEW_LINE;
	          
	-- V_BUFFER := replace(V_CREATE_IGNORE_LIST,'%IGNORE_LIST_PATH%',V_IGNORE_FILES_PATH);
  -- DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);
  
	V_BUFFER := V_FIELD_SIZES;
  DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

	V_BUFFER := replace(V_PROCESS_INSTANCE_DOCUMENTS,'%FOLDER_PATH%',V_FOLDER_PATH);
	V_BUFFER := replace(V_BUFFER,'%LOGFILE_NAME%',V_LOGFILE_NAME);
  DBMS_LOB.WRITEAPPEND(V_SCRIPT,LENGTH(V_BUFFER),V_BUFFER);

  appendScript(V_SCRIPT_FILE,V_SCRIPT);  
 
end;          
--
function createDeleteSchemaScript(P_XML_SCHEMA_CONFIGURATION XMLTYPE) 
return VARCHAR2
as
  pragma                       autonomous_transaction;
  V_SCRIPT                     CLOB;
  V_TARGET                     VARCHAR2(700);
  V_CONFIGURATION_FILENAME     VARCHAR2(700);
  V_DELETE_SCRIPT_FILENAME     VARCHAR2(700);
  V_COMMENT                    VARCHAR2(32000); 
begin

  V_TARGET 	                := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/@target','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_CONFIGURATION_FILENAME  := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/registrationConfigurationFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
	V_DELETE_SCRIPT_FILENAME  := P_XML_SCHEMA_CONFIGURATION.extract('/SchemaRegistrationConfiguration/FileNames/deleteScriptFile/text()','xmlns="http://xmlns.oracle.com/xdb/pm/registrationConfiguration' ).getStringVal();
		
	V_COMMENT := '--' ||  C_NEW_LINE 
	          || '-- Schema Deletion Script for "' || V_TARGET || '"' || C_NEW_LINE 
	          || '--' || C_NEW_LINE;

 	V_SCRIPT := V_COMMENT;
 	DBMS_LOB.APPEND(V_SCRIPT,generateDeleteSchemaScript(P_XML_SCHEMA_CONFIGURATION));
  XDB_UTILITIES.uploadResource(V_DELETE_SCRIPT_FILENAME,V_SCRIPT,XDB_CONSTANTS.VERSION);
  commit;
  
  return V_DELETE_SCRIPT_FILENAME;
end;
--
begin
	G_EVENT_LIST := EVENT_LIST_T();
  $IF $$DEBUG $THEN
    XDB_OUTPUT.createTraceFile('/public/XDB_OPTIMIZE_XMLSCHEMA_' || to_char(SYSTIMESTAMP,'YYYY-MM-DD"T"HH24.MI.SSTZHTZM') || '.log');
  $END
end XDBPM_OPTIMIZE_XMLSCHEMA;
/
show errors
--
grant execute on XDBPM_OPTIMIZE_XMLSCHEMA to public
/