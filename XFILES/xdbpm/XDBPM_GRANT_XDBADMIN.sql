--
set echo on
spool XDBPM_GRANT_XDBADMIN.log
--
grant XDBADMIN to package XDBPM_DBMS_XDB
/
grant XDBADMIN to package XDBPM_DBMS_XDB_VERSION
/
grant XDBADMIN to package XDBPM_DBMS_XDBRESOURCE
/
grant XDBADMIN to package XDBPM_DBMS_RESCONFIG
/
grant XDBADMIN to package XDBPM_RV_HELPER
/
grant XDBADMIN to package XDBPM_RESCONFIG_HELPER
/
grant XDBADMIN to package XDBPM_UTILITIES_INTERNAL
/
--
spool off
quit
