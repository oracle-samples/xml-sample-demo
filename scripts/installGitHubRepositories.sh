doInstall() {
   rm -rf xml-sample-demo
   if [ -f "xml-sample-demo-master.zip" ] 
   then
     rm -rf xml-sample-demo-master
     unzip -o xml-sample-demo-master.zip
     mv xml-sample-demo-master xml-sample-demo
   else
	   rm -rf oracle-xml-sample-demo-*
     curl -Lk https://github.com/oracle/xml-sample-demo/zipball/master -o xml-sample-demo-curl.zip
     unzip -o xml-sample-demo-curl.zip
     mv oracle-xml-sample-demo-* xml-sample-demo
   fi
   cd xml-sample-demo
   sqlplus $DBA/$DBAPWD @scripts/installXFiles $XFILES $XFILESPWD $HTTPPORT
   sqlplus $DBA/$DBAPWD @scripts/installMetadata $XDBEXT $XDBEXTPWD
   sh scripts/installXMLRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $XDBEXT $XDBEXTPWD $DEMOUSER $DEMOPWD $SERVERURL
   cd $INSTALLROOT
   rm -rf json-in-db
   if [ -f "json-in-db-master.zip" ] 
   then
     rm -rf json-in-db-master
     unzip -o json-in-db-master.zip
     mv json-in-db-master json-in-db
   else
	   rm -rf oracle-json-in-db-*
     curl -Lk https://github.com/oracle/json-in-db/zipball/master -o json-in-db-curl.zip
     unzip -o json-in-db-curl.zip
     mv oracle-json-in-db-* json-in-db
   fi
   cd json-in-db
   if [ -z "$ORDSROOT" ]
   then
     sh scripts/installDBJSON.sh $DBA $DBAPWD $ORDSHOME
   fi
   sh scripts/installJSONRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $DEMOUSER $DEMOPWD $SERVERURL
}
DBA=$1
DBAPWD=$2
XFILES=$3
XFILESPWD=$4
XDBEXT=$5
XDBEXTPWD=$6
DEMOUSER=$7
DEMOPWD=$8
HOSTNAME=$9
HTTPPORT=${10}
ORDSHOME=${11}
SERVERURL="$HOSTNAME:$HTTPPORT"
INSTALLROOT=`pwd`
rm install.log
doInstall 2>&1 | tee -a install.log
