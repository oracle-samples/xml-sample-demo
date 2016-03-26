create or replace package XDBPM_CHECK_PERMISSIONS
as
  procedure setPermissions;
end;
/
show errors
--
create or replace package body XDBPM_CHECK_PERMISSIONS
as
function toVARCHAR(P_BOOLEAN BOOLEAN)
return VARCHAR2
as
begin
	if (P_BOOLEAN) then
	  return 'TRUE';
	else
	  return 'FALSE';
	end if;
end;
--
procedure setPermissions
as
  V_SYSDBA                    BOOLEAN := sys_context('USERENV','SESSION_USER') = 'SYS';
  V_SYSTEM                    BOOLEAN := sys_context('USERENV','SESSION_USER') = 'SYSTEM';
  V_DBA                       BOOLEAN := sys_context('USERENV','ISDBA') = 'TRUE';
  V_CREATE_DIRECTORY          VARCHAR2(5) := 'FALSE';

  V_PACKAGE_DEFINITION        VARCHAR2(4000);
begin  
	begin
	  select 'TRUE'
	    into V_CREATE_DIRECTORY
	    from SESSION_PRIVS
	   where PRIVILEGE = 'CREATE ANY DIRECTORY';
	exception
	  when NO_DATA_FOUND then
	    V_CREATE_DIRECTORY := 'FALSE';
	  when OTHERS then
	    RAISE;
	end;

  V_PACKAGE_DEFINITION := 'create or replace package XDBPM.XDBPM_INSTALLER_PERMISSIONS' || chr(10)
                       || 'as ' || chr(10) 
                       || '   HAS_SYSDBA             constant BOOLEAN := ' || toVARCHAR(V_SYSDBA) || ';' || chr(13)
                       || '   IS_SYSTEM              constant BOOLEAN := ' || toVARCHAR(V_SYSTEM) || ';' || chr(13) 
                       || '   HAS_DBA                constant BOOLEAN := ' || toVARCHAR(V_DBA)    || ';' || chr(13)                        
                       || '   HAS_CREATE_DIRECTORY   constant BOOLEAN := ' || V_CREATE_DIRECTORY  || ';' || chr(13) 
                       ||  'end;';
                       
  execute immediate V_PACKAGE_DEFINITION;
end;
--
end;
/
show errors
--
begin
  XDBPM_CHECK_PERMISSIONS.setPermissions();
end;
/
set serveroutput on
--
begin
$IF XDBPM.XDBPM_INSTALLER_PERMISSIONS.HAS_SYSDBA $THEN
   dbms_output.put_line('SYSDBA: TRUE');
$ELSE
   dbms_output.put_line('SYSDBA: FALSE');
$END
   
$IF XDBPM.XDBPM_INSTALLER_PERMISSIONS.IS_SYSTEM $THEN
   dbms_output.put_line('SYSTEM: TRUE');
$ELSE
   dbms_output.put_line('SYSTEM: FALSE');
$END

$IF XDBPM.XDBPM_INSTALLER_PERMISSIONS.HAS_DBA $THEN
   dbms_output.put_line('DBA: TRUE');
$ELSE
   dbms_output.put_line('DBA: FALSE');
$END

$IF XDBPM.XDBPM_INSTALLER_PERMISSIONS.HAS_CREATE_DIRECTORY $THEN
   dbms_output.put_line('CREATE DIRECTORY: TRUE');
$ELSE
   dbms_output.put_line('CREATE DIRECTORY: FALSE');
$END

end;
/
