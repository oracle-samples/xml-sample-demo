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
logfilename=$demohome/install/NVPAIR.log
echo "Log File : $logfilename"
rm $logfilename
DBA=$1
DBAPWD=$2
USER=$3
USERPWD=$4
SERVER=$5
echo "Installation Parameters for Name Value Pair Optimization". > $logfilename
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
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 2
fi
sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
rc=$?
echo "sqlplus $USER:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as $USER - Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
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
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    else
      echo "Operation Failed- Installation Aborted." >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  fi
  exit 4
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/xdbconfig.xml | head -1)
echo "GET:$SERVER/xdbconfig.xml:$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] 
then
  if [ $HttpStatus == "401" ] 
    then
      echo "Unable to establish HTTP connection as '$USER'. Please note username is case sensitive with Digest Authentication">> $logfilename
      echo "Unable to establish HTTP connection as '$USER'. Please note username is case sensitive with Digest Authentication"
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    else
      echo "Operation Failed- Installation Aborted." >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  fi
  exit 4
fi
mkdir -p $demohome/$USER
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs" | head -1)
echo "DELETE "$SERVER/publishedContent/demonstrations/NVPairs":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 6
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
echo "DELETE "$SERVER/home/$USER/demonstrations/NVPairs":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 6
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
  echo "MKCOL "$SERVER/publishedContent":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/NVPairs":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
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
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
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
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/NVPairs":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
  echo "MKCOL "$SERVER/publishedContent":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/NVPairs":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs/xsd" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs/xsd" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/NVPairs/xsd":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsd/NVPairXMLSchema.xsd" "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd" | head -1)
echo "PUT:"$demohome/xsd/NVPairXMLSchema.xsd" --> "$SERVER/publishedContent/demonstrations/NVPairs/xsd/NVPairXMLSchema.xsd":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
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
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/NVPairs":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/NVPairs/sql":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/reset.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql" | head -1)
echo "PUT:"$demohome/setup/reset.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/reset.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/registerSchema.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql" | head -1)
echo "PUT:"$demohome/sql/registerSchema.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/registerSchema.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/describeObjects.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql" | head -1)
echo "PUT:"$demohome/sql/describeObjects.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/describeObjects.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/showSampleData.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql" | head -1)
echo "PUT:"$demohome/sql/showSampleData.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/showSampleData.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/createDepartmentView.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql" | head -1)
echo "PUT:"$demohome/sql/createDepartmentView.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/createDepartmentView.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/createEmployeeView.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql" | head -1)
echo "PUT:"$demohome/sql/createEmployeeView.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/createEmployeeView.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/createIndexes.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql" | head -1)
echo "PUT:"$demohome/sql/createIndexes.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/createIndexes.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/createStructuredIndex.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql" | head -1)
echo "PUT:"$demohome/sql/createStructuredIndex.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/createStructuredIndex.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/indexOptimizedDepartmentView.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql" | head -1)
echo "PUT:"$demohome/sql/indexOptimizedDepartmentView.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedDepartmentView.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/indexOptimizedEmployeeView.sql" "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql" | head -1)
echo "PUT:"$demohome/sql/indexOptimizedEmployeeView.sql" --> "$SERVER/home/$USER/demonstrations/NVPairs/sql/indexOptimizedEmployeeView.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
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
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/NVPairs":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/manual" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/manual" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/NVPairs/manual":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed [$HttpStatus] - Installation Aborted." >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 6
	 fi
fi
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|NVPAIR|g" -e "s|%DEMONAME%|Name Value Pair Optimization|g" -e "s|%LAUNCHPAD%|Name Value Pair Optimization|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\NV Pair Optimization|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/NVPairs|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/NVPairs|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i $demohome/install/configuration.xml
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/install/configuration.xml" "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml" | head -1)
echo "PUT:"$demohome/install/configuration.xml" --> "$SERVER/home/$USER/demonstrations/NVPairs/configuration.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "InstallationFailed [$HttpStatus]: See $logfilename for details."
  exit 5
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishDemo.sql /home/$USER/demonstrations/NVPairs XFILES
shellscriptName="$demohome/Name_Value_Pair_Optimization.sh"
echo "Shell Script : $shellscriptName" >> $logfilename
echo "Shell Script : $shellscriptName"
echo "firefox $SERVER/home/$USER/demonstrations/NVPairs/index.html"> $shellscriptName
echo "Installation Complete" >> $logfilename
echo "Installation Complete: See $logfilename for details."
