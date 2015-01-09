export CLASSPATH=./xdbpm.jar:$ORACLE_HOME/lib/xmlparserv2.jar:$ORACLE_HOME/jdbc/lib/ojdbc6.jar:$ORACLE_HOME/jdbc/lib/ojdbc6dms.jar:$ORACLE_HOME/rdbms/jlib/xdb.jar
java -Xmx256M com.oracle.st.xdb.pm.zip.RepositoryImport -D $1
