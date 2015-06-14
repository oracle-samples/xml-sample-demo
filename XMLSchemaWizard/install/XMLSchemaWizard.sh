#/* ================================================  
# *    
# * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# *
# * ================================================ 
# */
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/XMLSchemaWizard.log
echo "Log File : $logfilename"
rm $logfilename
DBA=$1
DBAPWD=$2
USER=$3
USERPWD=$4
SERVER=$5
echo "Installation Parameters for Oracle XML DB XML Schema Registration Wizard". > $logfilename
echo "\$DBA         : $DBA" >> $logfilename
echo "\$USER        : $USER" >> $logfilename
echo "\$SERVER      : $SERVER" >> $logfilename
echo "\$DEMOHOME    : $demohome" >> $logfilename
echo "\$ORACLE_HOME : $ORACLE_HOME" >> $logfilename
echo "\$ORACLE_SID  : $ORACLE_SID" >> $logfilename
spexe=$(which sqlplus | head -1)
echo "sqlplus      : $spexe" >> $logfilename
sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
rc=$?
echo "sqlplus $DBA:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as $DBA - Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 2
fi
sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
rc=$?
echo "sqlplus $USER:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as $USER - Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 3
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/xdbconfig.xml | head -1)
echo "GET:$SERVER/xdbconfig.xml:$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] 
then
  if [ $HttpStatus == "401" ] 
    then
      echo "Unable to establish HTTP connection as '$DBA'. Please note username is case sensitive with Digest Authentication">> $logfilename
      echo "Unable to establish HTTP connection as '$DBA'. Please note username is case sensitive with Digest Authentication"
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    else
      echo "Operation Failed- Installation Aborted." >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  fi
  exit 4
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/public | head -1)
echo "GET:$SERVER/public:$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] 
then
  if [ $HttpStatus == "401" ] 
    then
      echo "Unable to establish HTTP connection as '$USER'. Please note username is case sensitive with Digest Authentication">> $logfilename
      echo "Unable to establish HTTP connection as '$USER'. Please note username is case sensitive with Digest Authentication"
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    else
      echo "Operation Failed- Installation Aborted." >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  fi
  exit 4
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/js" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/js" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard/js":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql" | head -1)
  echo "MKCOL "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/registrationWizard.html" "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html" | head -1)
echo "PUT:"$demohome/registrationWizard.html" --> "$SERVER/home/$USER/Applications/XMLSchemaWizard/registrationWizard.html":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/registrationWizard.xsl" "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl" | head -1)
echo "PUT:"$demohome/xsl/registrationWizard.xsl" --> "$SERVER/home/$USER/Applications/XMLSchemaWizard/xsl/registrationWizard.xsl":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/js/registrationWizard.js" "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js" | head -1)
echo "PUT:"$demohome/js/registrationWizard.js" --> "$SERVER/home/$USER/Applications/XMLSchemaWizard/js/registrationWizard.js":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/XFILES_XMLSCHEMA_WIZARD.sql" "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql" | head -1)
echo "PUT:"$demohome/sql/XFILES_XMLSCHEMA_WIZARD.sql" --> "$SERVER/home/$USER/Applications/XMLSchemaWizard/sql/XFILES_XMLSCHEMA_WIZARD.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/XFILES_XMLSCHEMA_WIZARD.sql
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/PUBLISH_XMLSCHEMA_WIZARD.sql
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/publishAppFolder.sql XMLSchemaWizard XFILES_CONSTANTS.ACL_XFILES_USERS
shellscriptName="$demohome/XML_Schema_Registration_Wizard.sh"
echo "Shell Script : $shellscriptName" >> $logfilename
echo "Shell Script : $shellscriptName"
echo "firefox $SERVER/XFILES/Applications/XMLSchemaWizard/registrationWizard.html"> $shellscriptName
echo "Installation Complete" >> $logfilename
echo "Installation Complete: See $logfilename for details."
