
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
-- XDBPM_HELPER should be created under XDB
--
alter session set current_schema = XDBPM
/
--
create or replace package XDBPM_RESCONFIG_UTILITIES
AUTHID DEFINER
as
  function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER) return VARCHAR2;
  -- 
  -- Return the Upload Folder for a given Resconfig
  --
  function getResConfigUsage(P_RESCONFIG_PATH VARCHAR2) return XDB.XDB$STRING_LIST_T;
  -- 
  -- List the Resources that are related to a RESCONFIG;
  -- 
  procedure deleteFolderWithResConfig(P_FOLDER_PATH VARCHAR2);
  --
  -- Performs a Recursive Delete of a Folder. Temporarily Caches any RESCONFIG documents in the hierarchy
  -- and recreates them after the other resources have been deleted.   
  --
  procedure removeInvalidReposResConfig;
  ---
end;
/
show errors
--
create or replace package body XDBPM_RESCONFIG_UTILITIES
as
procedure removeInvalidReposResConfig
as
  V_OLD_OIDLIST  VARCHAR2(4000);
  V_NEW_OIDLIST  VARCHAR2(4000);
  V_OLD_OIDCNT   NUMBER;
  V_NEW_OIDCNT   NUMBER := 0;
  V_OID          VARCHAR2(32);
  V_RESID        RAW(16);
  V_INDEX        NUMBER(4);
  V_OIDCNT_CHAR  VARCHAR2(4);
begin

   select RCLIST into V_OLD_OIDLIST from XDB.XDB$RCLIST_V;
 
   if (V_OLD_OIDLIST IS NULL)
   then
     return;
   end if;

   /* subtract 4 hex chars for version number and count */
   V_OLD_OIDCNT := (length(V_OLD_OIDLIST) - 4) / 32;
   for i IN 0 .. V_OLD_OIDCNT - 1 LOOP
     V_OID := substr(V_OLD_OIDLIST, i*32+5, 32);
     
     begin
       select RESID into V_RESID
         from RESOURCE_VIEW e
         where (sys_op_r2o(extractValue(e.RES, '/Resource/XMLRef'))) = (hextoraw(V_OID));
       V_NEW_OIDLIST := V_NEW_OIDLIST || V_OID;
       V_NEW_OIDCNT  := V_NEW_OIDCNT + 1;
     EXCEPTION
         WHEN NO_DATA_FOUND THEN
           NULL;
     end;

   END LOOP;
   
   V_OIDCNT_CHAR  := to_char(V_NEW_OIDCNT,'FM0X');
   
   V_NEW_OIDLIST := substr(V_OLD_OIDLIST,1,2) || V_OIDCNT_CHAR || V_NEW_OIDLIST;
   
   XDBPM_SYSDBA_INTERNAL.updateRootInfoRCList(V_NEW_OIDLIST);
   
end;
--
function getResConfigUsage(P_RESCONFIG_PATH VARCHAR2) return XDB.XDB$STRING_LIST_T
as
  V_PATH_LIST XDB.XDB$STRING_LIST_T;
  V_OBJECT_ID RAW(16);
begin
  select OBJECT_ID 
    into V_OBJECT_ID
    from XDB.XDB$RESCONFIG cfg, RESOURCE_VIEW
   where ref(cfg) = extractValue(res,'/Resource/XMLRef') 
     and equals_path(res,P_RESCONFIG_PATH) = 1;

  SELECT ANY_PATH
         BULK COLLECT INTO V_PATH_LIST
    from RESOURCE_VIEW rv, XDB.XDB$RESOURCE r,
         TABLE(r.XMLDATA.RCLIST.OID) rc  
   where r.XMLDATA.RCLIST is not null
     and rv.RESID = r.OBJECT_ID
     and rc.COLUMN_VALUE = V_OBJECT_ID;
   return V_PATH_LIST;
end;
--
procedure deleteFolderWithResConfig(P_FOLDER_PATH VARCHAR2)
as
  TYPE RESCONFIG_PATH_RECORD_T
    is RECORD
       (
         PERMANENT_PATH   VARCHAR2(700),
         TEMPORARY_PATH   VARCHAR2(700)
       );
 
  TYPE RESCONFIG_PATH_TABLE_T
    is TABLE of RESCONFIG_PATH_RECORD_T;
 
  V_RESCONFIG_PATH_CACHE RESCONFIG_PATH_TABLE_T := RESCONFIG_PATH_TABLE_T();
 
  V_RESCONFIG_NAME   VARCHAR2(700);
  V_RESCONFIG_FOLDER VARCHAR2(700);

  V_PERMANENT_PATH   VARCHAR2(700);
  V_TEMPORARY_FOLDER VARCHAR2(700) := '/public/temp-' || to_char(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF');

  V_RESULT BOOLEAN;
  cursor getResConfigDocuments 
  is
  select ANY_PATH, RESID
    from RESOURCE_VIEW, XDB.XDB$RESCONFIG rc
   where ref(rc) = extractValue(res,'/Resource/XMLRef')
     and under_path(res,P_FOLDER_PATH) = 1;

begin

	V_RESULT := DBMS_XDB.createFolder(V_TEMPORARY_FOLDER);
  
  -- Create temporary Hard Links to any RESCONFIG documents, so that the delete of /home/XDBPM can succeed.
  
	for rc in getResConfigDocuments loop
	  DBMS_XDB.renameResource(rc.ANY_PATH,V_TEMPORARY_FOLDER,rc.RESID);

	  V_RESCONFIG_PATH_CACHE.extend();
	  V_RESCONFIG_PATH_CACHE(V_RESCONFIG_PATH_CACHE.last).PERMANENT_PATH := rc.ANY_PATH;
	  V_RESCONFIG_PATH_CACHE(V_RESCONFIG_PATH_CACHE.last).TEMPORARY_PATH := V_TEMPORARY_FOLDER || '/' || rc.RESID;

	end loop;

  DBMS_XDB.deleteResource(P_FOLDER_PATH,DBMS_XDB.DELETE_RECURSIVE);
  
  for i in V_RESCONFIG_PATH_CACHE.first .. V_RESCONFIG_PATH_CACHE.last loop
    V_PERMANENT_PATH := V_RESCONFIG_PATH_CACHE(i).PERMANENT_PATH;
    V_RESCONFIG_FOLDER := substr(V_PERMANENT_PATH,1,instr(V_PERMANENT_PATH,'/',-1)-1);
    V_RESCONFIG_NAME := substr(V_PERMANENT_PATH,instr(V_PERMANENT_PATH,'/',-1)+1);
    XDB_UTILITIES.mkdir(V_RESCONFIG_FOLDER,TRUE);
	  DBMS_XDB.renameResource(V_RESCONFIG_PATH_CACHE(i).TEMPORARY_PATH,V_RESCONFIG_FOLDER,V_RESCONFIG_NAME);
  end loop;    
  
  DBMS_XDB.deleteResource(V_TEMPORARY_FOLDER);
  
  commit;
end;
--
function getUploadFolderPath(P_TABLE_NAME VARCHAR2, P_OWNER VARCHAR2 DEFAULT USER)
return VARCHAR2
as
begin
	return XDBPM.XDBPM_RESCONFIG_HELPER.getUploadFolderPath(P_TABLE_NAME, P_OWNER);
end;
--
end;
/
show errors
--
set define on
--
-- PATH UTILTIES PACKAGE - Per Ravi Murthy
--
create or replace package XDBPM_PATH_HELPER
AUTHID DEFINER
as

  procedure getNextPathComp(pathid RAW, curridx integer, nextcomp out RAW, nextidx out integer);
  function getPathidParent(pathid RAW) return RAW deterministic;
  function getPathidLength(pathid RAW) return NUMBER deterministic;
  
end XDBPM_PATH_HELPER;
/
--
show errors 
--
set define on
--
create or replace package body XDBPM_PATH_HELPER
as
--
procedure getNextPathComp(pathid RAW, curridx integer, nextcomp out RAW, nextidx out integer)
as 
  pathcomp_len integer;
begin
  pathcomp_len := to_NUMBER(utl_RAW.substr(pathid,curridx,1));
  nextcomp := utl_RAW.substr(pathid, curridx+1, pathcomp_len);
  nextidx := curridx + 1 + pathcomp_len;
end;
--
function getPathidLength(pathid RAW)
return NUMBER 
deterministic 
is 
  pathRAW RAW(2000);
  pathRAW_len NUMBER;
  ncomp NUMBER;
  curridx NUMBER;
  pathcomp RAW(8);
begin
  select path into pathRAW from &PATHTABLENAME
  where id = pathid;

  if (pathRAW is null) then 
    return null;
  end if;
  
  curridx := 1;
  ncomp := 0;
  pathRAW_len := utl_RAW.length(pathRAW);
  loop 
    getNextPathComp(pathRAW, curridx, pathcomp, curridx);
    ncomp := ncomp + 1;
    exit when (curridx > pathRAW_len);
  end loop;
  
  return ncomp;
end;
--
function getPathidParent(pathid RAW)
return RAW 
deterministic 
is 
  pathRAW RAW(2000);
  pathRAW_len NUMBER;
  curridx NUMBER;
  previdx NUMBER;
  pathcomp RAW(8);
  retpathRAW RAW(2000);
  retpathid RAW(8);
begin
  select path into pathRAW from &PATHTABLENAME
  where id = pathid;

  if (pathRAW is null) then 
    return null;
  end if;

  curridx := 1;
  pathRAW_len := utl_RAW.length(pathRAW);
  loop 
    previdx := curridx;
    getNextPathComp(pathRAW, curridx, pathcomp, curridx);
    exit when (curridx > pathRAW_len);
  end loop;

  if (previdx = 1) then 
    return null;
  end if;
  retpathRAW := utl_RAW.substr(pathRAW, 1, previdx-1);

  select id into retpathid from &PATHTABLENAME
  where path = retpathRAW;

  return retpathid;
end;
--
end;
/
--
show errors
--
alter session set current_schema = SYS
/
