
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
create or replace package XDBPM_XMLINDEX_SEARCH
authid CURRENT_USER 
as
  function getRootNodeMap(pathTableName VARCHAR2, pathTableOwner VARCHAR2) return xmlType;
  function getChildNodeMap(pathid VARCHAR2, pathTableName VARCHAR2, pathTableOwner VARCHAR2) return xmlType;

  function getPathidLength(pathid RAW) return NUMBER deterministic;
  function getPathidParent(pathid RAW) return RAW deterministic;

  procedure enableIndexes;

  NO_NAMESPACE constant VARCHAR2(256) := 'http://xmlns.oracle.com/xdb/noNamespace';
   
  -- C_PATHIDPARENT_INDEX constant VARCHAR2(256) := 'STANDARD_HASH("XDBPM"."XDBPM_XMLINDEX_SEARCH"."GETPATHIDPARENT"("PATHID"))';
  C_PATHIDPARENT_INDEX constant VARCHAR2(256) := '"XDBPM"."XDBPM_XMLINDEX_SEARCH"."GETPATHIDPARENT"("PATHID")';
  C_PATHIDLENGTH_INDEX constant VARCHAR2(256) := '"XDBPM"."XDBPM_XMLINDEX_SEARCH"."GETPATHIDLENGTH"("PATHID")';

end;
/
show errors
--
create or replace synonym XDB_XMLINDEX_SEARCH for XDBPM_XMLINDEX_SEARCH
/
grant execute on XDBPM_XMLINDEX_SEARCH to public
/
create or replace package body XDBPM_XMLINDEX_SEARCH
as
--
function getPathidLength(pathid RAW)
return NUMBER deterministic 
as
begin
  return xdbpm.XDB_PATH_HELPER.getPathidLength(pathid);
end;
--
function getPathIdParent(pathid RAW)
return RAW deterministic
as 
begin
  return xdbpm.XDB_PATH_HELPER.getPathIdParent(PATHID);
end;
--
function getAttributes(parentPathId RAW, pathTableName VARCHAR2, pathTableOwner VARCHAR2) 
return xmltype
as
  attributes XMLType;
  getAttributes sys_refcursor;
  statement VARCHAR2(4096) := 
  'select /*+ INDEX(A) */
          xmlAgg
          (
            xmlElement
            (
              "Attr",
              xmlAttributes(a.PATHID as "ID"),
              case 
                when an.PREFIX is not null
                then an.PREFIX || '':'' || a.NODENAME
                else a.NODENAME
              end
           )
         ) 
    from (
           select distinct pathid,
                  nvl(SYS_PATHID_LASTNMSPC(pathid),''' || NO_NAMESPACE || ''')  NAMESPACE,
                  sys_pathid_lastname(pathid) NODENAME
             from "' || pathTableOwner || '"."' || pathTableName || '"
            where sys_pathid_is_attr(pathid) = 1 
              and sys_pathid_is_nmspc(pathid) = 0
         ) a,
         (
           select namespace, ''ns'' || rownum PREFIX
             from (
                    select distinct SYS_PATHID_LASTNMSPC(pathid) NAMESPACE
                      from "' || pathTableOwner || '"."'|| pathTableName || '"
                     where SYS_PATHID_LASTNMSPC(pathid) is not null
                       and sys_pathid_is_nmspc(pathid) = 0
                     order by SYS_PATHID_LASTNMSPC(pathid)
                  )
           union all
           select ''' || NO_NAMESPACE || ''', null
             from dual
         ) an
   where ' || C_PATHIDPARENT_INDEX || ' =  :1
     and a.NAMESPACE = an.NAMESPACE';
begin
  -- dbms_output.put_line(statement);
  open getAttributes for statement using parentPathId;
  loop
    fetch getAttributes into attributes;
    exit when getAttributes%NOTFOUND;
  end loop;
  close getAttributes;
  return attributes;
end;
--
function getChildElements(parentPathId RAW, pathTableName VARCHAR2, pathTableOwner VARCHAR2) 
return xmltype
as
  childElements XMLType;
  getChildElements sys_refcursor;
  statement VARCHAR2(4096) := 
  'select /*+ INDEX(C) */
          xmlAgg
          (
            xmlElement
            (
              "Element",
              xmlAttributes(c.PATHID as "ID"),
              case 
                when cn.PREFIX is not null
                then cn.PREFIX || '':'' || c.NODENAME
                else c.NODENAME
              end
            )
         ) 
    from (
           select distinct pathid,  
                  nvl(SYS_PATHID_LASTNMSPC(pathid),''' || NO_NAMESPACE || ''') NAMESPACE,
                  sys_pathid_lastname(pathid) NODENAME
             from "' || pathTableOwner || '"."' || pathTableName || '"
            where sys_pathid_is_attr(pathid) = 0
              and sys_pathid_is_nmspc(pathid) = 0
         ) c,
         (
           select namespace, ''ns'' || rownum PREFIX
             from (
                    select distinct SYS_PATHID_LASTNMSPC(pathid) NAMESPACE
                      from "' || pathTableOwner || '"."'|| pathTableName || '"
                     where SYS_PATHID_LASTNMSPC(pathid) is not null
                       and sys_pathid_is_nmspc(pathid) = 0
                     order by SYS_PATHID_LASTNMSPC(pathid)
                  )
           union all
           select ''' || NO_NAMESPACE || ''', null
             from dual
         ) cn
   where ' || C_PATHIDPARENT_INDEX || ' =  :1
     and c.NAMESPACE = cn.NAMESPACE';
begin
  -- dbms_output.put_line(statement);
  open getChildElements for statement using parentPathId;
  loop
    fetch getChildElements into childElements;
    exit when getChildElements%NOTFOUND;
  end loop;
  close getChildElements;
  return childElements;
end;
--
function getNodeMap(pathId RAW, pathTableName VARCHAR2, pathTableOwner VARCHAR2)
return xmltype
as
  nodeMap XMLType;
  getNodeMap sys_refcursor;
  statement VARCHAR2(4096) := 
  'select /*+ INDEX(E) */ xmlelement
          (
            "Element",
            xmlAttributes
            (
              ''http://xmlns.oracle.com/xdb/pm/demo/search'' as "xmlns",
              e.PATHID as "ID"
            ),
            xmlelement("Name",                            
                       case 
                         when en.PREFIX is not null
                           then en.PREFIX || '':'' || e.NODENAME
                           else e.NODENAME
                         end
                      ),
            case
              when :1 is not NULL
                then xmlelement("Attrs",:2)
              end,
            case 
              when :3 is not NULL  
                then xmlElement("Elements",:4)
              end
          )
     from (
            select distinct pathid,  
                  nvl(SYS_PATHID_LASTNMSPC(pathid),''' || NO_NAMESPACE || ''') NAMESPACE,
                  sys_pathid_lastname(pathid) NODENAME
             from "' || pathTableOwner || '"."' || pathTableName || '"
            where sys_pathid_is_attr(pathid) = 0
              and sys_pathid_is_nmspc(pathid) = 0
          ) e, 
          (
           select namespace, ''ns'' || rownum PREFIX
             from (
                    select distinct SYS_PATHID_LASTNMSPC(pathid) NAMESPACE
                      from "' || pathTableOwner || '"."'|| pathTableName || '"
                     where SYS_PATHID_LASTNMSPC(pathid) is not null
                       and sys_pathid_is_nmspc(pathid) = 0
                     order by SYS_PATHID_LASTNMSPC(pathid)
                  )
           union all
           select ''' || NO_NAMESPACE || ''', null
             from dual
          ) en
   where e.PATHID =  :5
     and e.namespace = en.namespace';
  attributes    XMLType;
  childElements XMLType;
begin
  attributes := getAttributes(pathID, pathTableName, pathTableOwner);
  childElements := getChildElements(pathId, pathTableName, pathTableOwner);
  -- dbms_output.put_line(statement);
  open getNodeMap for statement using attributes, attributes, childElements, childElements, pathId;
  loop
    fetch getNodeMap into nodeMap;
    exit when getNodeMap%NOTFOUND;
  end loop;
  close getNodeMap;
  return nodeMap;
end;
--
procedure checkIndexStatus(pathTableName VARCHAR2, pathTableOwner VARCHAR2)
as
  cursor getFunctionalIndexes 
  is
  select index_name, index_owner, COLUMN_EXPRESSION
    from ALL_IND_EXPRESSIONS
   where TABLE_NAME = pathTableName
     and TABLE_OWNER = pathTableOwner;  

  v_pidp_index_name varchar2(64);
  v_pidp_index_owner varchar2(64);
  v_pidp_index_status varchar2(64);
  
  v_pidl_index_name varchar2(64);
  v_pidl_index_owner varchar2(64);
  v_pidl_index_status varchar2(64);
  
  v_index_status varchar2(32);

begin
     
  for idx in getFunctionalIndexes loop
    if (IDX.COLUMN_EXPRESSION = C_PATHIDPARENT_INDEX) then
      v_pidp_index_name := idx.INDEX_NAME;
      v_pidp_index_owner := idx.INDEX_OWNER;
    end if;

    if (IDX.COLUMN_EXPRESSION) = C_PATHIDLENGTH_INDEX then
      v_pidl_index_name := idx.INDEX_NAME;
      v_pidl_index_owner := idx.INDEX_OWNER;
    end if;      
  end loop;
  
  if v_pidp_index_name is null then
    execute immediate 'create index "' || SUBSTR(pathTableName,1,22) || '_PIDPIDX" on "' || pathTableName || '" (' || C_PATHIDPARENT_INDEX || ')';
  else
    select FUNCIDX_STATUS
      into v_index_status
      from ALL_INDEXES
     where INDEX_NAME = v_pidp_index_name
       and OWNER = v_pidp_index_owner;
        
    if (v_index_status != 'ENABLED') then
      execute immediate 'alter index "' || v_pidp_index_owner || '"."' || v_pidp_index_name || '" enable';
    end if;
  end if;
  
  if v_pidl_index_name is null then
    execute immediate 'create index "' || SUBSTR(pathTableName,1,22) || '_PIDLIDX" on "' || pathTableName || '" (' || C_PATHIDLENGTH_INDEX || ')';
  else
    select FUNCIDX_STATUS
      into v_index_status
      from ALL_INDEXES
     where INDEX_NAME = v_pidl_index_name
       and OWNER = v_pidl_index_owner;
        
    if (v_index_status != 'ENABLED') then
      execute immediate 'alter index "' || v_pidl_index_owner || '"."' || v_pidl_index_name || '" enable';
    end if;
  end if;
         
end;
--
function getNamespacePrefixMappings(pathTableName VARCHAR2, pathTableOwner VARCHAR2)
return xmlType
as
   namespaceMappings xmlType;
   getNamespaceMappings SYS_REFCURSOR;
   statement VARCHAR2(4096) := 
   'select xmlElement
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
      from (
             select namespace, ''ns'' || rownum PREFIX
               from (
                      select distinct SYS_PATHID_LASTNMSPC(pathid) NAMESPACE
                        from "' || pathTableOwner || '"."'|| pathTableName || '"
                       where SYS_PATHID_LASTNMSPC(pathid) is not null
                         and sys_pathid_is_nmspc(pathid) = 0
                       order by SYS_PATHID_LASTNMSPC(pathid)
                    )
           )';
begin
  -- dbms_output.put_line(statement);
  open getNamespaceMappings for statement;
  loop 
    fetch getNamespaceMappings into namespaceMappings;
    exit when getNamespaceMappings%NOTFOUND;
  end loop;
  close getNamespaceMappings;
  return namespaceMappings;
end;
--
function getRootNodeMap(pathTableName VARCHAR2, pathTableOwner VARCHAR2)
return xmlType
is
  rootNodeMap xmlType := null;
  rootNode xmltype;
  rootPathID RAW(16);
  
  statement VARCHAR2(4096) :=  
'select distinct PATHID 
   from "' || pathTableOwner || '"."'|| pathTableName || '" 
  where ' || C_PATHIDLENGTH_INDEX || ' = 1';

  getRootElementList sys_refcursor;
  
  namespacePrefixes xmlType;
  
begin
  checkIndexStatus(pathTableName, pathTableOwner);
  
  open getRootElementList for statement;

  loop
    fetch getRootElementList into ROOTPATHID;
    exit when getRootElementList%NOTFOUND;
    rootNode := getNodeMap(ROOTPATHID,pathTableName,pathTableOwner);
    -- dbms_output.put_line(rootNode.getClobVal());
    select xmlconcat(rootNodeMap,rootNode)
      into rootNodeMap
      from dual;
  end loop;

  close getRootElementList;

  namespacePrefixes := getNamespacePrefixMappings(pathTableName, pathTableOwner);

  select xmlElement
         (
            "NodeMap",
            xmlAttributes(
              'http://xmlns.oracle.com/xdb/pm/demo/search' as "xmlns",
              TABLE_NAME as "table",
              TABLE_OWNER as "owner",
              PATH_TABLE_NAME as "pathTable"
            ),
            namespacePrefixes,
            rootNodeMap
         )
    into rootNodeMap
    from ALL_XML_INDEXES
   where PATH_TABLE_NAME = pathTableName
     and TABLE_OWNER = pathTableOwner;

  return rootNodeMap;
end;
--
function getChildNodeMap(pathId VARCHAR2, pathTableName VARCHAR2, pathTableOwner VARCHAR2)
return xmltype
as
begin
  return getNodeMap(hexToRaw(pathId), pathTableName, pathTableOwner);
end;
--
procedure enableIndexes
as
  cursor getFunctionalIndexes 
  is
  select aie.INDEX_NAME, aie.INDEX_OWNER, aie.COLUMN_EXPRESSION 
    from ALL_IND_EXPRESSIONS aie, ALL_INDEXES ai
   where aie.INDEX_NAME = ai.INDEX_NAME
     and aie.INDEX_OWNER = ai.OWNER
     and FUNCIDX_STATUS = 'DISABLED';
  -- where COLUMN_EXPRESSION = C_PATHIDPARENT_INDEX
  --    or COLUMN_EXPRESSION = C_PATHIDLENGTH_INDEX;

begin
     
  for idx in getFunctionalIndexes loop
    if (idx.COLUMN_EXPRESSION = C_PATHIDPARENT_INDEX)
      or
       (idx.COLUMN_EXPRESSION = C_PATHIDLENGTH_INDEX)
    then
      dbms_output.put_line('Enabling Index "' || idx.INDEX_OWNER || '"."' || idx.INDEX_NAME || '"');
      execute immediate 'alter index "' || idx.INDEX_OWNER || '"."' || idx.INDEX_NAME || '" enable';
    end if;
  end loop;
           
end;  
--
end;
/
show errors
--
set define on
--
alter session set current_schema = SYS
/