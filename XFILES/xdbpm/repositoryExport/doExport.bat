set ORACLE_HOME=c:\oracle\product\11.2.0\dbhome_1
#set CLASSPATH=
java -cp %CD%\xdbpm.jar;%ORACLE_HOME%\lib\xmlparserv2.jar;%ORACLE_HOME%\jdbc\lib\ojdbc5.jar;%ORACLE_HOME%\jdbc\lib\ojdbc5dms.jar;%ORACLE_HOME%\rdbms\jlib\xdb.jar  com.oracle.st.xdb.pm.zip.RepositoryExport -D %1
