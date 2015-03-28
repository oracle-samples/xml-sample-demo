demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/XQUERY.log
echo "Log File : $logfilename"
rm $logfilename
DBA=$1
DBAPWD=$2
USER=$3
USERPWD=$4
SERVER=$5
echo "Installation Parameters for Using XQuery in Oracle XML DB". > $logfilename
echo "\$DBA         : $DBA" >> $logfilename
echo "\$USER        : $USER" >> $logfilename
echo "\$SERVER      : $SERVER" >> $logfilename
echo "\$DEMOHOME    : $demohome" >> $logfilename
echo "\$ORACLE_HOME : $ORACLE_HOME" >> $logfilename
echo "\$ORACLE_SID  : $ORACLE_SID" >> $logfilename
spexe=$(which sqlplus | head -1)
echo "sqlplus      : $spexe" >> $logfilename
sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/VerifyConnection.sql
rc=$?
echo "sqlplus $DBA:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as $DBA - Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 2
fi
sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/VerifyConnection.sql
rc=$?
echo "sqlplus $USER:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as $USER - Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 3
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/xdbconfig.xml | head -1)
echo "GET:$SERVER/xdbconfig.xml:$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] 
then
  echo "Operation Failed - Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 4
fi
mkdir -p $demohome/$USER
mkdir -p $demohome/$USER/sql
mkdir -p $demohome/$USER/sampleData
mkdir -p $demohome/$USER/sampleData/xml
echo "Unzipping \"$demohome/setup/sampleData.zip\" into \"$demohome/$USER/sampleData/xml\""
unzip -qq "$demohome/setup/sampleData.zip" -d "$demohome/$USER/sampleData/xml"
echo "Unzip Completed"
echo "Cloning \"$demohome/setup/sql\" into \"$demohome/$USER/sql\""
cp -r "$demohome/setup/sql"/* "$demohome/$USER/sql"
find "$demohome/$USER/sql" -type f -print0 | xargs -0 sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XQUERY|g" -e "s|%DEMONAME%|Using XQuery in Oracle XML DB|g" -e "s|%LAUNCHPAD%|XQuery Demonstraton|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XQuery|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XQuery|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XQuery\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XQUERY|g" -e "s|%XMLVIEW1%|DEPARTMENT_XML|g" -e "s|%VIEW1%|PURCHASEORDER_MASTER_VIEW|g" -e "s|%VIEW2%|PURCHASEORDER_DETAIL_VIEW|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
echo "Cloning Completed"
echo "Cloning \"$demohome/setup/sqlldr\" into \"$demohome/$USER/sampleData\""
cp -r "$demohome/setup/sqlldr"/* "$demohome/$USER/sampleData"
find "$demohome/$USER/sampleData" -type f -print0 | xargs -0 sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XQUERY|g" -e "s|%DEMONAME%|Using XQuery in Oracle XML DB|g" -e "s|%LAUNCHPAD%|XQuery Demonstraton|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XQuery|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XQuery|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XQuery\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XQUERY|g" -e "s|%XMLVIEW1%|DEPARTMENT_XML|g" -e "s|%VIEW1%|PURCHASEORDER_MASTER_VIEW|g" -e "s|%VIEW2%|PURCHASEORDER_DETAIL_VIEW|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
echo "Cloning Completed"
echo "Cloning \"$demohome/$USER/sampleData/xml\" into \"$demohome/$USER/sampleData/xml\""
find "$demohome/$USER/sampleData/xml" -type f -print0 | xargs -0 sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XQUERY|g" -e "s|%DEMONAME%|Using XQuery in Oracle XML DB|g" -e "s|%LAUNCHPAD%|XQuery Demonstraton|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XQuery|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XQuery|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XQuery\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XQUERY|g" -e "s|%XMLVIEW1%|DEPARTMENT_XML|g" -e "s|%VIEW1%|PURCHASEORDER_MASTER_VIEW|g" -e "s|%VIEW2%|PURCHASEORDER_DETAIL_VIEW|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
echo "Cloning Completed"
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/$USER/sql/setup.sql
sed -e "s|\\\\|\/|g"  -i $demohome/$USER/sampleData/sampleData.ctl
sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$demohome/$USER/sampleData/sampleData.ctl
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/Install/sql/executeAndQuit.sql $demohome/$USER/sql/resetDemo.sql
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery" | head -1)
echo "DELETE "$SERVER/publishedContent/demonstrations/XQuery":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 6
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery" | head -1)
echo "DELETE "$SERVER/home/$USER/demonstrations/XQuery":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 6
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
  echo "MKCOL "$SERVER/publishedContent":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/XQuery":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
  echo "MKCOL "$SERVER/publishedContent":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/XQuery":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery/xsd" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery/xsd" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/XQuery/xsd":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.xsd" "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd" | head -1)
echo "PUT:"$demohome/setup/xsd/purchaseOrder.xsd" --> "$SERVER/publishedContent/demonstrations/XQuery/xsd/purchaseOrder.xsd":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/XQuery":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  echo "MKCOL "$SERVER/home":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  echo "MKCOL "$SERVER/home/$USER":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/XQuery":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/XQuery/sql":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/resetDemo.sql" "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/resetDemo.sql" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/resetDemo.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/registerSchema.sql" "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/registerSchema.sql" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/registerSchema.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/simpleExpressions.xqy" "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy" | head -1)
echo "PUT:"$demohome/$USER/sql/simpleExpressions.xqy" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/simpleExpressions.xqy":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/relationalExpressions.xqy" "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy" | head -1)
echo "PUT:"$demohome/$USER/sql/relationalExpressions.xqy" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/relationalExpressions.xqy":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/createXMLView.sql" "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/createXMLView.sql" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/createXMLView.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/xmlViewExpressions.xqy" "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy" | head -1)
echo "PUT:"$demohome/$USER/sql/xmlViewExpressions.xqy" --> "$SERVER/home/$USER/demonstrations/XQuery/sql/xmlViewExpressions.xqy":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XQUERY|g" -e "s|%DEMONAME%|Using XQuery in Oracle XML DB|g" -e "s|%LAUNCHPAD%|XQuery Demonstraton|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XQuery|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XQuery|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XQuery\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XQUERY|g" -e "s|%XMLVIEW1%|DEPARTMENT_XML|g" -e "s|%VIEW1%|PURCHASEORDER_MASTER_VIEW|g" -e "s|%VIEW2%|PURCHASEORDER_DETAIL_VIEW|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i $demohome/install/configuration.xml
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/install/configuration.xml" "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml" | head -1)
echo "PUT:"$demohome/install/configuration.xml" --> "$SERVER/home/$USER/demonstrations/XQuery/configuration.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishDemo.sql /home/$USER/demonstrations/XQuery XFILES
shellscriptName="$demohome/XQuery Demonstraton.sh"
echo "Shell Script : $shellscriptName" >> $logfilename
echo "Shell Script : $shellscriptName"
echo "firefox $SERVER/home/$USER/demonstrations/XQuery/index.html"> $shellscriptName
echo "Installation Complete" >> $logfilename
echo "Installation Complete: See $logfilename for details."
