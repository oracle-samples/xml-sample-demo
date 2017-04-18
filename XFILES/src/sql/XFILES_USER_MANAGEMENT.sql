
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
create or replace package XFILES_USER_SERVICES
AUTHID CURRENT_USER
as
  procedure RESETUSEROPTIONS(P_NEW_PASSWORD VARCHAR2 DEFAULT NULL,P_RESET_HOME_FOLDER BOOLEAN DEFAULT FALSE, P_RECREATE_HOME_PAGE BOOLEAN DEFAULT FALSE, P_RESET_PUBLIC_FOLDER BOOLEAN DEFAULT FALSE, P_RECREATE_PUBLIC_PAGE BOOLEAN DEFAULT FALSE);
  function  GETUSERPRIVILEGES return XMLType;
end;
/
show errors
--
create or replace package body XFILES_USER_SERVICES
as
procedure writeLogRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/&XFILES_SCHEMA/XFILES_USER_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/&XFILES_SCHEMA/XFILES_USER_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--

--
procedure resetHomePage
as
  V_FOLDER_PATH   VARCHAR(1024) := XDB_CONSTANTS.FOLDER_HOME || '/' || USER;
begin
  -- Create a dummy index.html for the user's public folder and apply the XFILES_REDIRECT ResConfig to dynamically generate the correct content.
  XDB_REPOSITORY_SERVICES.createIndexPage(V_FOLDER_PATH);
end;
--
procedure resetPublicPage
as
  V_FOLDER_PATH   VARCHAR(1024) := XDB_CONSTANTS.FOLDER_HOME || '/' || USER || XDB_CONSTANTS.FOLDER_PUBLIC;
begin
  -- Create a dummy index.html for the user's public folder and apply the XFILES_INDEX_PAGE ResConfig to dynamically generate the correct content.
  XDB_REPOSITORY_SERVICES.createIndexPage(V_FOLDER_PATH);
end;
--
procedure RESETUSEROPTIONS(P_NEW_PASSWORD VARCHAR2 DEFAULT NULL,P_RESET_HOME_FOLDER BOOLEAN DEFAULT FALSE, P_RECREATE_HOME_PAGE BOOLEAN DEFAULT FALSE, P_RESET_PUBLIC_FOLDER BOOLEAN DEFAULT FALSE, P_RECREATE_PUBLIC_PAGE BOOLEAN DEFAULT FALSE)
as
  V_STACK_TRACE        XMLType;
  V_PARAMETERS         XMLType;
  V_INIT               TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STATEMENT          VARCHAR2(4000) := null;

  V_RESET_HOME_FOLDER    VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_RESET_HOME_FOLDER);
  V_RECREATE_HOME_PAGE   VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_RECREATE_HOME_PAGE);
  V_RESET_PUBLIC_FOLDER  VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_RESET_PUBLIC_FOLDER);
  V_RECREATE_PUBLIC_PAGE VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_RECREATE_PUBLIC_PAGE);

begin
  select xmlConcat
         (
           xmlElement("User",sys_context('USERENV', 'CURRENT_USER')),
           case
             when P_NEW_PASSWORD is not null
                  then xmlElement("newPassword",null)
           end,
           case
             when V_RESET_HOME_FOLDER = 'TRUE'
                  then xmlElement("resetHomeFolder",null)
           end,
           case
             when V_RECREATE_HOME_PAGE = 'TRUE'
                  then xmlElement("recreateHomePage",null)
           end,
           case
             when V_RESET_PUBLIC_FOLDER = 'TRUE'
                  then xmlElement("resetHomeFolder",null)
           end,
           case
             when V_RECREATE_PUBLIC_PAGE = 'TRUE'
                  then xmlElement("recreateHomePage",null)
           end
         )
    into V_PARAMETERS
    from dual;

  if (P_NEW_PASSWORD is not NULL) then
    V_STATEMENT := 'alter user "' || USER || '" identified by ' || DBMS_ASSERT.ENQUOTE_NAME(P_NEW_PASSWORD,false);
    execute immediate V_STATEMENT;
  end if;

  if (P_RESET_HOME_FOLDER) then
    xdb_utilities.createHomeFolder();
    resetHomePage();
  end if;

  if (P_RECREATE_HOME_PAGE) then
    resetHomePage();
  end if;

  if (P_RESET_PUBLIC_FOLDER) then
    xdb_utilities.createPublicFolder();
    resetPublicPage();
  end if;

  if (P_RECREATE_PUBLIC_PAGE) then
    resetPublicPage();
  end if;

  writeLogRecord('RESETUSEROPTIONS',V_INIT,V_PARAMETERS);
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('RESETUSEROPTIONS',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
--
function getUserPrivileges
return XMLType
as
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  V_HAS_CREATE_USER          NUMBER := 0;
  V_HAS_DBA                  NUMBER := 0;
  V_HAS_XDBADMIN             NUMBER := 0;
  V_HAS_XFILES_ADMINISTRATOR NUMBER := 0;
  V_HAS_GRANT_OPTION         NUMBER := 0;
  V_USER_PRIVILEGES          XMLType;


  cursor getSystemPrivileges
  is
  select PRIVILEGE
    from ROLE_SYS_PRIVS
    where PRIVILEGE in ('CREATE USER')
  union all
  select PRIVILEGE
    from USER_SYS_PRIVS
    where PRIVILEGE in ('CREATE USER');

  cursor getGrantedRoles
  is
  select GRANTED_ROLE,  ADMIN_OPTION
    from ROLE_ROLE_PRIVS
    where GRANTED_ROLE in ('DBA','XDBADMIN','XFILES_ADMINISTRATOR')
  union all
  select GRANTED_ROLE, ADMIN_OPTION
    from USER_ROLE_PRIVS
   where GRANTED_ROLE  in ('DBA','XDBADMIN','XFILES_ADMINISTRATOR');
begin
  select xmlConcat
         (
           xmlElement("User",sys_context('USERENV', 'CURRENT_USER')),
           xmlElement("Password")
         )
    into V_PARAMETERS
    from dual;

  for p in getSystemPrivileges loop
    if p.PRIVILEGE = 'CREATE USER' then
      V_HAS_CREATE_USER := 1;
    end if;
  end loop;

  for p in getGrantedRoles loop
    if p.GRANTED_ROLE = 'DBA' then
      V_HAS_DBA := 1;
    end if;
    if p.GRANTED_ROLE = 'XDBADMIN' then
      V_HAS_XDBADMIN := 1;
    end if;
    if p.GRANTED_ROLE = 'XFILES_ADMINISTRATOR' then
      V_HAS_XFILES_ADMINISTRATOR := 1;
      if p.ADMIN_OPTION = 'YES' then
        V_HAS_GRANT_OPTION := 1;
      end if;
    end if;
  end loop;

  select XMLElement
         (
           "UserPrivileges",
           XMLElement("createUser",V_HAS_CREATE_USER),
           XMLElement("dba",V_HAS_CREATE_USER),
           XMLElement("xdbAdmin",V_HAS_CREATE_USER),
           XMLElement("xfilesAdmin",xmlAttributes(V_HAS_GRANT_OPTION as "withGrant"),V_HAS_XFILES_ADMINISTRATOR),
           XMLElement
           (
             "userList",
             (
               select XMLAgg
                      (
                        XMLElement("user",username)
                      )
                 from ALL_USERS
             )
           )
         )
    into V_USER_PRIVILEGES
    from dual;

  writeLogRecord('GETUSERPRIVILEGES',V_INIT,V_PARAMETERS);
  return V_USER_PRIVILEGES;
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('GETUSERPRIVILEGES',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
--
end;
/
show errors
--
create or replace package XFILES_ADMIN_SERVICES
AUTHID CURRENT_USER
as
  procedure CREATEXFILESUSER(P_PRINCIPLE_NAME VARCHAR2,P_PASSWORD VARCHAR2);
  procedure REVOKEXFILES(P_PRINCIPLE_NAME VARCHAR2);
  procedure GRANTXFILESUSER(P_PRINCIPLE_NAME VARCHAR2);
  procedure GRANTXFILESADMINISTRATOR(P_PRINCIPLE_NAME VARCHAR2);
end;
/
show errors
--
create or replace package body XFILES_ADMIN_SERVICES
as
procedure writeLogRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)
as
begin
  XFILES_LOGGING.writeLogRecord('/orawsv/&XFILES_SCHEMA/XFILES_ADMIN_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS);
end;
--
procedure writeErrorRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)
as
begin
  XFILES_LOGGING.writeErrorRecord('/orawsv/&XFILES_SCHEMA/XFILES_ADMIN_SERVICES/',P_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);
end;
--
procedure REVOKEXFILES(P_PRINCIPLE_NAME VARCHAR2)
as
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  role_not_granted exception;
  PRAGMA EXCEPTION_INIT( role_not_granted , -01951 );
begin

  select xmlConcat
         (
           xmlElement("xfilesAdministrator",USER),
           xmlElement("User",P_PRINCIPLE_NAME)
         )
    into V_PARAMETERS
    from dual;

	begin
		execute immediate 'REVOKE XFILES_ADMINISTRATOR from ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
	exception
	  when role_not_granted then
	    null;
	end;
	begin
		execute immediate 'REVOKE XFILES_USER from ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
	exception
	  when role_not_granted then
	    null;
	end;

  writeLogRecord('REVOKEXFILES',V_INIT,V_PARAMETERS);
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('REVOKEXFILES',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
--
procedure GRANTXFILESUSER(P_PRINCIPLE_NAME  VARCHAR2)
as
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  role_not_granted exception;
  PRAGMA EXCEPTION_INIT( role_not_granted , -01951 );
begin

  select xmlConcat
         (
           xmlElement("xfilesAdministrator",USER),
           xmlElement("User",P_PRINCIPLE_NAME)
         )
    into V_PARAMETERS
    from dual;

	begin
		execute immediate 'REVOKE XFILES_ADMINISTRATOR from ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
	exception
	  when role_not_granted then
	    null;
	end;
  execute immediate 'GRANT XFILES_USER to ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
  writeLogRecord('GRANTXFILESUSER',V_INIT,V_PARAMETERS);
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('GRANTXFILESUSER',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
-- 
procedure GRANTXFILESADMINISTRATOR(P_PRINCIPLE_NAME  VARCHAR2)
as
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;

  role_not_granted exception;
  PRAGMA EXCEPTION_INIT( role_not_granted , -01951 );
begin

  select xmlConcat
         (
           xmlElement("xfilesAdministrator",USER),
           xmlElement("User",P_PRINCIPLE_NAME)
         )
    into V_PARAMETERS
    from dual;

	begin
		execute immediate 'REVOKE XFILES_USER from ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
	exception
	  when role_not_granted then
	    null;
	end;

  execute immediate 'GRANT XFILES_ADMINISTRATOR to ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
  writeLogRecord('GRANTXFILESADMINISTRATOR',V_INIT,V_PARAMETERS);
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('GRANTXFILESADMINISTRATOR',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
--
procedure CREATEXFILESUSER(P_PRINCIPLE_NAME VARCHAR2, P_PASSWORD VARCHAR2)
as
  V_STACK_TRACE       XMLType;
  V_PARAMETERS        XMLType;
  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  V_STATEMENT         VARCHAR2(4000) :=null;
  V_USER_EXISTS       BOOLEAN := FALSE;

  cursor checkUser 
  is
  select USERNAME
    from ALL_USERS
   where USERNAME = P_PRINCIPLE_NAME;

begin
  select xmlConcat
         (
           xmlElement("Administrator",USER),
           xmlElement("NewUser",P_PRINCIPLE_NAME),
           xmlElement("Password")
         )
    into V_PARAMETERS
    from dual;

  V_STATEMENT := 'create user ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false) || ' identified by ' || DBMS_ASSERT.ENQUOTE_NAME(P_PASSWORD,false) || ' account unlock';
  for u in checkUser loop
    V_STATEMENT := 'alter user ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false) || ' identified by ' || DBMS_ASSERT.ENQUOTE_NAME(P_PASSWORD,false) || ' account unlock';
  end loop;

  execute immediate V_STATEMENT;
  execute immediate 'grant connect to ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);
  execute immediate 'grant XFILES_USER to ' || DBMS_ASSERT.ENQUOTE_NAME(P_PRINCIPLE_NAME,false);

  writeLogRecord('CREATEUSER',V_INIT,V_PARAMETERS);
exception
  when others then
    V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();
    rollback;
    writeErrorRecord('CREATEUSER',V_INIT,V_PARAMETERS,V_STACK_TRACE);
    raise;
end;
--
end;
/
show errors
--

