set echo on
spool installXFiles.log
--
def USERNAME = &1
--
def PASSWORD = &2
--
def HTTPPORT = &3
--
grant connect, resource, unlimited tablespace to &USERNAME identified by &PASSWORD
/
call dbms_xdb_config.setHttpPort(&HTTPPORT)
/
alter user anonymous account unlock
/
quit

