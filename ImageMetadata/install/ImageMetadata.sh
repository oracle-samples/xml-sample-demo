demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/ImageMetadata.log
echo "Log File : $logfilename"
rm $logfilename
DBA=$1
DBAPWD=$2
USER=$3
USERPWD=$4
SERVER=$5
echo "Installation Parameters for Oracle XML DB Repository Metadata and Events". > $logfilename
echo "\$DBA         : $DBA" >> $logfilename
echo "\$USER        : $USER" >> $logfilename
echo "\$SERVER      : $SERVER" >> $logfilename
echo "\$DEMOHOME    : $demohome" >> $logfilename
echo "\$ORACLE_HOME : $ORACLE_HOME" >> $logfilename
echo "\$ORACLE_SID  : $ORACLE_SID" >> $logfilename
spexe=$(which sqlplus | head -1)
echo "sqlplus      : $spexe" >> $logfilename
sqlplus -L $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/install/sql/VerifyConnection.sql
rc=$?
echo "sqlplus as sysdba:$rc" >> $logfilename
if [ $rc != 2 ] 
then 
  echo "Operation Failed : Unable to connect via SQLPLUS as sysdba - Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 1
fi
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
cp "$demohome/setup/cloneSource/imageEventConfiguration.xml" "$demohome/resConfig/imageEventConfiguration.xml"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%RESCONFIG_PATH%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/resConfig/imageEventConfiguration.xml"
cp "$demohome/setup/cloneSource/imageGalleryResConfig.xml" "$demohome/resConfig/imageGalleryResConfig.xml"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%RESCONFIG_PATH%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/resConfig/imageGalleryResConfig.xml"
cp "$demohome/setup/cloneSource/EXIFViewer.js" "$demohome/js/EXIFViewer.js"
sed -e "s|%DESKTOP%|C:\Users\Mark D Drake\Desktop|g" -e "s|%STARTMENU%|C:\Users\Mark D Drake\AppData\Roaming\Microsoft\Windows\Start Menu|g" -e "s|%WINWORD%|C:\PROGRA~2\MICROS~2\Office12\WINWORD.EXE|g" -e "s|%EXCEL%|C:\PROGRA~2\MICROS~2\Office12\EXCEL.EXE|g" -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%RESCONFIG_PATH%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/js/EXIFViewer.js"
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
echo "DELETE "$SERVER/sys/acls/acl_initialization_fix.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 6
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/sys/acls/acl_initialization_fix.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/sys/acls/acl_initialization_fix.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_folder_acl.xml" "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
echo "PUT:"$demohome/acls/categorized_image_folder_acl.xml" --> "$SERVER/sys/acls/acl_initialization_fix.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
echo "DELETE "$SERVER/sys/acls/acl_initialization_fix.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 6
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/sql/sysdbaTasks.sql $USER
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/configureXDBExtras.sql $USER
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata/sql":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageMetadataConstants.sql" "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
echo "PUT:"$demohome/sql/imageMetadataConstants.sql" --> "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageMetadataConstants.sql $USER
sqlplus $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/install/sql/remove10gR2Demo.sql
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/deleteMetadataSchema.sql $USER
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/removeEventHandler.sql XDBMETADATA /publishedContent/repositoryFeatures/xml/imageEventConfiguration.xml
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/removeRepositoryQueue.sql XDBMETADATA
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/removeEventHandler.sql $USER /home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/removeRepositoryQueue.sql $USER
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_folder_acl.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_folder_acl.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/sys/acls/categorized_image_folder_acl.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/sys/acls/categorized_image_folder_acl.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_folder_acl.xml" "$SERVER/sys/acls/categorized_image_folder_acl.xml" | head -1)
echo "PUT:"$demohome/acls/categorized_image_folder_acl.xml" --> "$SERVER/sys/acls/categorized_image_folder_acl.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_acl.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_acl.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/sys/acls/categorized_image_acl.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/sys/acls/categorized_image_acl.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_acl.xml" "$SERVER/sys/acls/categorized_image_acl.xml" | head -1)
echo "PUT:"$demohome/acls/categorized_image_acl.xml" --> "$SERVER/sys/acls/categorized_image_acl.xml":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata/xsd":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsd/imageMetadata.xsd" "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
echo "PUT:"$demohome/xsd/imageMetadata.xsd" --> "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/registerSchema.sql" "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
echo "PUT:"$demohome/sql/registerSchema.sql" --> "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/registerSchema.sql /home/$USER/imageMetadata/xsd/imageMetadata.xsd
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/patchSchemaLocation.sql $HOSTNAME /home/$USER/imageMetadata/xsd/imageMetadata.xsd
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageProcessor.sql" "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
echo "PUT:"$demohome/sql/imageProcessor.sql" --> "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageProcessor.sql $USER XFILES
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/repositoryQueue.sql" "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
echo "PUT:"$demohome/sql/repositoryQueue.sql" --> "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/repositoryQueue.sql $USER
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
echo "PUT:"$demohome/sql/imageEventManager.sql" --> "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata/resConfig":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/resConfig/imageEventConfiguration.xml" "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
echo "PUT:"$demohome/resConfig/imageEventConfiguration.xml" --> "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageEventManager.sql $USER XFILES false
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/metadataServices.sql" "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
echo "PUT:"$demohome/sql/metadataServices.sql" --> "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/metadataServices.sql $USER
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/enumerateRepositoryEvents.sql" "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
echo "PUT:"$demohome/sql/enumerateRepositoryEvents.sql" --> "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/activateImageEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
echo "PUT:"$demohome/sql/activateImageEventManager.sql" --> "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/enableEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
echo "PUT:"$demohome/sql/enableEventManager.sql" --> "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/enableEventManager.sql $USER
sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/queueManager.sql $USER
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata/xsl":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/ImageGallery.xsl" "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
echo "PUT:"$demohome/xsl/ImageGallery.xsl" --> "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/EXIFViewer.xsl" "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
echo "PUT:"$demohome/xsl/EXIFViewer.xsl" --> "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/EXIFCommon.xsl" "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
echo "PUT:"$demohome/xsl/EXIFCommon.xsl" --> "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/left-arrow-circle.png" "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png" | head -1)
echo "PUT:"$demohome/xsl/left-arrow-circle.png" --> "$SERVER/home/$USER/imageMetadata/xsl/left-arrow-circle.png":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/right-arrow-circle.png" "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png" | head -1)
echo "PUT:"$demohome/xsl/right-arrow-circle.png" --> "$SERVER/home/$USER/imageMetadata/xsl/right-arrow-circle.png":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js" | head -1)
  echo "MKCOL "$SERVER/home/$USER/imageMetadata/js":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/js/ImageGallery.js" "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
echo "PUT:"$demohome/js/ImageGallery.js" --> "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/js/EXIFViewer.js" "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
echo "PUT:"$demohome/js/EXIFViewer.js" --> "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js":$HttpStatus" >> $logfilename
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
HttpStatus=$(curl --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/categorization" | head -1)
if [ $HttpStatus == "404" ] 
then
  HttpStatus=$(curl --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/categorization" | head -1)
  echo "MKCOL "$SERVER/publishedContent/categorization":$HttpStatus" >> $logfilename
  if [ $HttpStatus != "201" ]
  then
    echo "Operation Failed - Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
	 fi
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/enableImageGallery.sql $USER
HttpStatus=$(curl --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml" | head -1)
if [ $HttpStatus != "404" ] 
then
  if [ $HttpStatus == "200" ] 
  then
    HttpStatus=$(curl --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml" | head -1)
    if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ]
    then
      echo "DELETE(PUT) "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml":$HttpStatus - Operation Failed" >> $logfilename
      echo "Installation Failed: See $logfilename for details."
      exit 5
    fi
  else
    echo "HEAD(PUT) "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml":$HttpStatus - Operation Failed" >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
fi
HttpStatus=$(curl --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/resConfig/imageGalleryResConfig.xml" "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml" | head -1)
echo "PUT:"$demohome/resConfig/imageGalleryResConfig.xml" --> "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml":$HttpStatus" >> $logfilename
if [ $HttpStatus != "201" ] 
then
  echo "Operation Failed: Installation Aborted." >> $logfilename
  echo "Installation Failed: See $logfilename for details."
  exit 5
fi
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/createImageCategoryFolders.sql $USER
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishAppFolder.sql $USER imageMetadata XFILES
sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/disableUser.sql $USER
echo "Installation Complete" >> $logfilename
echo "Installation Complete: See $logfilename for details."
