set echo on
spool installMetadata.log
--
def USERNAME = &1
--
def PASSWORD = &2
--
grant connect, resource, unlimited tablespace to &USERNAME identified by &PASSWORD
/
alter user &USERNAME identified by &PASSWORD account unlock
/
quit

