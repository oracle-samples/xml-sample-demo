DBA=$1
DBAPWD=$2
XFILES=$3
XFILESPWD=$4
DEMOUSER=$5
DEMOPWD=$6
SERVER=$7
HTTPPORT=$8
XDBEXT=$9
XDBEXTPWD=${10}
SERVERURL="$SERVER:$HTTPPORT"
rm -rf oracle-xml-sample-demo-*
curl -Lk https://github.com/oracle/xml-sample-demo/zipball/master -o xml-sample-demo.zip
unzip -o xml-sample-demo.zip
cd oracle-xml-sample-demo*
sqlplus $DBA/$DBAPWD @scripts/installXFiles $XFILES $XFILESPWD $HTTPPORT
sqlplus $DBA/$DBAPWD @scripts/installMetadata $XDBEXT $XDBEXTPWD
sh scripts/installXMLRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $XDBEXT $XDBEXTPWD $DEMOUSER $DEMOPWD $SERVERURL
curl -Lk https://github.com/oracle/json-in-db/zipball/master -o json-in-db.zip
rm -rf oracle-json-in-db-*
unzip -o json-in-db.zip
cd oracle-json-in-db*
sh scripts/installJSONRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $XDBEXT $XDBEXTPWD $DEMOUSER $DEMOPWD $SERVERURL
