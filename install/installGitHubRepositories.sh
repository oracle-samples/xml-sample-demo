#/* ================================================  
# *    
# * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# *
# * ================================================ 
# */

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
   cd xml-sample-demo
   echo "connect sys/$SYSPWD as sysdba" >> install/connect.sql
   unset http_proxy
   unset https_proxy
   unset no_proxy   
   sqlplus /nolog @install/configureDatabase $PDB $DBA $DBAPWD $HTTPPORT $DEMOUSER $DEMOPWD
   rm install/connect.sql
   export TWO_TASK=$PDB
   export ORACLE_SID=$PDB
   sqlplus $DBA/$DBAPWD @install/installXFiles $XFILES $XFILESPWD $HTTPPORT
   sqlplus $DBA/$DBAPWD @install/installMetadata $XDBEXT $XDBEXTPWD
   sh install/installXMLRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $XDBEXT $XDBEXTPWD $DEMOUSER $DEMOPWD $SERVERURL
   cd $INSTALLROOT
   cd json-in-db
   if [ -n "$ORDSHOME" ] && [ -e "$ORDSHOME/ords.war" ]
   then
     sh install/installDBJSON.sh $DBA $DBAPWD $ORDSHOME
   fi
   sh install/installJSONRepository.sh $DBA $DBAPWD $XFILES $XFILESPWD $DEMOUSER $DEMOPWD $SERVERURL
}
PDB=${1}
DBA=${2}
DBAPWD=${3}
XFILES=XFILES
XFILESPWD=${4}
XDBEXT=${5}
XDBEXTPWD=${6}
DEMOUSER=${7}
DEMOPWD=${8}
HOSTNAME=${9}
HTTPPORT=${10}
ORDSHOME=${11}
SERVERURL="http://$HOSTNAME:$HTTPPORT"
INSTALLROOT=`pwd`
rm install.log
doInstall 2>&1 | tee -a install.log
