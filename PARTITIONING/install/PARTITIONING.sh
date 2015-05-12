demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/PARTITIONING.log
echo "Log File : $logfilename"
rm $logfilename
DBA=$1
DBAPWD=$2
USER=$3
USERPWD=$4
SERVER=$5
echo "Installation Parameters for Partitioning XML Storage using Oracle XML DB". > $logfilename
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
  echo "Installation Failed: See $logfilename for details."
  exit 2
fi
sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
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
mkdir -p $demohome/$USER/xsd
mkdir -p $demohome/$USER/sql
mkdir -p $demohome/$USER/sqlldr
mkdir -p $demohome/$USER/sampleData
mkdir -p $demohome/$USER/sampleData/xml
echo "Unzipping \"$demohome/setup/sampleData.zip\" into \"$demohome/$USER/sampleData/xml\""
unzip -o -qq "$demohome/setup/sampleData.zip" -d "$demohome/$USER/sampleData/xml"
echo "Unzip Completed"
echo "Cloning \"$demohome/setup/sql\" into \"$demohome/$USER/sql\""
cp -r "$demohome/setup/sql"/* "$demohome/$USER/sql"
find "$demohome/$USER/sql" -type f -print0 | xargs -0 sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
echo "Cloning Completed"
echo "Cloning \"$demohome/$USER/sampleData/xml\" into \"$demohome/$USER/sampleData/xml\""
find "$demohome/$USER/sampleData/xml" -type f -print0 | xargs -0 sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
echo "Cloning Completed"
cp "$demohome/setup/sqlldr/sampleData.ctl" "$demohome/$USER/sqlldr/sampleData.ctl"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sqlldr/sampleData.ctl"
cp "$demohome/setup/xml/PurchaseOrder.xml" "$demohome/$USER/sampleData/xml/PurchaseOrder.xml"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sampleData/xml/PurchaseOrder.xml"
cp "$demohome/setup/sqlldr/loadPurchaseOrders.ctl" "$demohome/$USER/sampleData/loadPurchaseOrders.ctl"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sampleData/loadPurchaseOrders.ctl"
cp "$demohome/setup/sqlldr/purchaseOrderFiles.dat" "$demohome/$USER/sampleData/purchaseOrderFiles.dat"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sampleData/purchaseOrderFiles.dat"
cp "$demohome/setup/sqlldr/loadPurchaseOrders.bat" "$demohome/$USER/loadPurchaseOrders.bat"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/loadPurchaseOrders.bat"
cp "$demohome/setup/sqlldr/loadPurchaseOrders.log.txt" "$demohome/$USER/sampleData/loadPurchaseOrders.log"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sampleData/loadPurchaseOrders.log"
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/$USER/sql/setup.sql
sed -e "s|\\\\|\/|g"  -i $demohome/$USER/sqlldr/sampleData.ctl
sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$demohome/$USER/sqlldr/sampleData.ctl
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/executeAndQuit.sql $demohome/$USER/sql/resetDemo.sql
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
echo "DELETE "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/assets" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/assets" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning/assets":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/assets/2.1.png" "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png" | head -1)
echo "PUT:"$demohome/setup/assets/2.1.png" --> "$SERVER/publishedContent/demonstrations/partitioning/assets/2.1.png":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning/xsd":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.xsd" "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd" | head -1)
echo "PUT:"$demohome/setup/xsd/purchaseOrder.xsd" --> "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.xsd":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.v2.xsd" "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd" | head -1)
echo "PUT:"$demohome/setup/xsd/purchaseOrder.v2.xsd" --> "$SERVER/publishedContent/demonstrations/partitioning/xsd/purchaseOrder.v2.xsd":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xml" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xml" | head -1)
  echo "MKCOL "$SERVER/publishedContent/demonstrations/partitioning/xml":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/xml/PurchaseOrder.xml" "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml" | head -1)
echo "PUT:"$demohome/$USER/sampleData/xml/PurchaseOrder.xml" --> "$SERVER/publishedContent/demonstrations/partitioning/xml/PurchaseOrder.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
echo "DELETE "$SERVER/home/$USER/demonstrations/partitioning":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 6
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/partitioning":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/partitioning":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/partitioning/sql":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/resetDemo.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/resetDemo.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/resetDemo.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/simulateSQLLDR.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/simulateSQLLDR.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/simulateSQLLDR.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/registerSchema.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/registerSchema.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/registerSchema.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/rowsByPartition.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/rowsByPartition.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/rowsByPartition.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/simpleQueries.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/simpleQueries.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/simpleQueries.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/createIndexes.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/createIndexes.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/createIndexes.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/runQueries1.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/runQueries1.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries1.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/runQueries2.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/runQueries2.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/runQueries2.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/insertDocument.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/insertDocument.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/insertDocument.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/inplaceEvolution.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/inplaceEvolution.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/inplaceEvolution.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/addPartition.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/addPartition.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/addPartition.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/dropPartition.sql" "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql" | head -1)
echo "PUT:"$demohome/$USER/sql/dropPartition.sql" --> "$SERVER/home/$USER/demonstrations/partitioning/sql/dropPartition.sql":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/partitioning":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/Links" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/Links" | head -1)
  echo "MKCOL "$SERVER/home/$USER/demonstrations/partitioning/Links":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/loadPurchaseOrders.ctl" "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl" | head -1)
echo "PUT:"$demohome/$USER/sampleData/loadPurchaseOrders.ctl" --> "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.ctl":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/loadPurchaseOrders.log" "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log" | head -1)
echo "PUT:"$demohome/$USER/sampleData/loadPurchaseOrders.log" --> "$SERVER/home/$USER/demonstrations/partitioning/loadPurchaseOrders.log":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|PARTITIONING|g" -e "s|%DEMONAME%|Partitioning XML Storage using Oracle XML DB|g" -e "s|%LAUNCHPAD%|Partitioning XML|g" -e "s|%LAUNCHPADFOLDER%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu\Oracle XML DB Demonstrations|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/partitioning|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/partitioning|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/partitioning\/xsd\/purchaseOrder.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_PARTN|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i $demohome/install/configuration.xml
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/install/configuration.xml" "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml" | head -1)
echo "PUT:"$demohome/install/configuration.xml" --> "$SERVER/home/$USER/demonstrations/partitioning/configuration.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishDemo.sql /home/$USER/demonstrations/partitioning XFILES
shellscriptName="$demohome/Partitioning XML.sh"
echo "Shell Script : $shellscriptName" >> $logfilename
echo "Shell Script : $shellscriptName"
echo "firefox $SERVER/home/$USER/demonstrations/partitioning/index.html"> $shellscriptName
echo "Installation Complete" >> $logfilename
echo "Installation Complete: See $logfilename for details."
