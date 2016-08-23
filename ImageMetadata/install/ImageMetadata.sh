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
doInstall() {
  echo "Installation Parameters: Oracle XML DB Repository Metadata and Events."
  echo "\$DBA            : $DBA"
  echo "\$USER           : $USER"
  echo "\$SERVER         : $SERVER"
  echo "\$DEMOHOME       : $demohome"
  echo "\$ORACLE_HOME    : $ORACLE_HOME"
  echo "\$ORACLE_SID     : $ORACLE_SID"
  spexe=$(which sqlplus | head -1)
  echo "sqlplus      : $spexe"
  unset http_proxy
  unset https_proxy
  unset no_proxy
  sqlplus -L $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/install/sql/verifyConnection.sql
  rc=$?
  echo "sqlplus as sysdba:$rc"
  if [ $rc != 2 ] 
  then 
    echo "Operation Failed : Unable to connect via SQLPLUS as sysdba - Installation Aborted. See $logfilename for details."
    exit 1
  fi
  sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
  rc=$?
  echo "sqlplus $DBA:$rc"
  if [ $rc != 2 ] 
  then 
    echo "Operation Failed : Unable to connect via SQLPLUS as $DBA - Installation Aborted. See $logfilename for details."
    exit 2
  fi
  sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
  rc=$?
  echo "sqlplus $USER:$rc"
  if [ $rc != 2 ] 
  then 
    echo "Operation Failed : Unable to connect via SQLPLUS as $USER - Installation Aborted. See $logfilename for details."
    exit 3
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/xdbconfig.xml | head -1)
  echo "GET:$SERVER/xdbconfig.xml:$HttpStatus"
  if [ $HttpStatus != "200" ] 
  then
    if [ $HttpStatus == "401" ] 
      then
        echo "Unable to establish HTTP connection as '$DBA'. Please note username is case sensitive with Digest Authentication"
        echo "Installation Failed: See $logfilename for details."
      else
        echo "Operation Failed- Installation Aborted. See $logfilename for details."
    fi
    exit 4
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X GET --write-out "%{http_code}\n" -s --output /dev/null $SERVER/public | head -1)
  echo "GET:$SERVER/public:$HttpStatus"
  if [ $HttpStatus != "200" ] 
  then
    if [ $HttpStatus == "401" ] 
      then
        echo "Unable to establish HTTP connection as '$USER'. Please note username is case sensitive with Digest Authentication"
        echo "Installation Failed: See $logfilename for details."
      else
        echo "Operation Failed- Installation Aborted. See $logfilename for details."
    fi
    exit 4
  fi
  cp "$demohome/setup/cloneSource/imageEventConfiguration.xml" "$demohome/resConfig/imageEventConfiguration.xml"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%EVENT_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%GALLERY_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageGalleryConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/resConfig/imageEventConfiguration.xml"
  cp "$demohome/setup/cloneSource/imageGalleryConfiguration.xml" "$demohome/resConfig/imageGalleryConfiguration.xml"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%EVENT_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%GALLERY_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageGalleryConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/resConfig/imageGalleryConfiguration.xml"
  cp "$demohome/setup/cloneSource/EXIFViewer.js" "$demohome/js/EXIFViewer.js"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|ImageMetadata|g" -e "s|%DEMONAME%|Oracle XML DB Repository Metadata and Events|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%BASEFOLDER%|\/home\/%USER%\/imageMetadata|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%SCHEMAURL%|http:\/\/xmlns.oracle.com\/xdb\/extras\/imageMetadata.xsd|g" -e "s|%EVENT_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageEventConfiguration.xml|g" -e "s|%GALLERY_RESCONFIG%|\/home\/%USER%\/imageMetadata\/resConfig\/imageGalleryConfiguration.xml|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%DEBUG%|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/js/EXIFViewer.js"
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
  echo "DELETE \"$SERVER/sys/acls/acl_initialization_fix.xml\":$HttpStatus"
  if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
  then
    echo "Operation Failed: Installation Aborted. See $logfilename for details."
    exit 6
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/sys/acls/acl_initialization_fix.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/sys/acls/acl_initialization_fix.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_folder_acl.xml" "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/sys/acls/acl_initialization_fix.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/acl_initialization_fix.xml" | head -1)
  echo "DELETE \"$SERVER/sys/acls/acl_initialization_fix.xml\":$HttpStatus"
  if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
  then
    echo "Operation Failed: Installation Aborted. See $logfilename for details."
    exit 6
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/sql/sysdbaTasks.sql $USER
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/configureXDBExtras.sql $USER
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
    echo "MKCOL \"$SERVER/home\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
    echo "MKCOL \"$SERVER/home/$USER\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata/sql\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageMetadataConstants.sql" "$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/imageMetadataConstants.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageMetadataConstants.sql $USER /home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml /home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml
  sqlplus $DBA/$DBAPWD@$ORACLE_SID as sysdba @$demohome/deinstall/sql/remove10gR2Demo.sql
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/deleteMetadataSchema.sql $USER
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeEventHandler.sql XDBMETADATA /publishedContent/repositoryFeatures/xml/imageEventConfiguration.xml
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeRepositoryQueue.sql XDBMETADATA
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeEventHandler.sql XDBMETADATA /home/$USER/imageMetadata/resConfig/imageGalleryResConfig.xml
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeEventHandler.sql $USER /home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeEventHandler.sql $USER /home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/deinstall/sql/removeRepositoryQueue.sql $USER
  skipOperation=false
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_folder_acl.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      skipOperation=true
    else
      echo "PUT[HEAD] \"$SERVER/sys/acls/categorized_image_folder_acl.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  if [ $skipOperation == "false" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_folder_acl.xml" "$SERVER/sys/acls/categorized_image_folder_acl.xml" | head -1)
    if [ $HttpStatus != "201" ] 
    then
      echo "PUT \"$SERVER/sys/acls/categorized_image_folder_acl.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
      exit 5
    fi
    echo "PUT:"$demohome/acls/categorized_image_folder_acl.xml" --> \"$SERVER/sys/acls/categorized_image_folder_acl.xml\":$HttpStatus"
  else
    echo "PUT:"$demohome/acls/categorized_image_folder_acl.xml" --> \"$SERVER/sys/acls/categorized_image_folder_acl.xml\": Operation Skipped, - document exists."
  fi
  skipOperation=false
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/sys/acls/categorized_image_acl.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      skipOperation=true
    else
      echo "PUT[HEAD] \"$SERVER/sys/acls/categorized_image_acl.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  if [ $skipOperation == "false" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/acls/categorized_image_acl.xml" "$SERVER/sys/acls/categorized_image_acl.xml" | head -1)
    if [ $HttpStatus != "201" ] 
    then
      echo "PUT \"$SERVER/sys/acls/categorized_image_acl.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
      exit 5
    fi
    echo "PUT:"$demohome/acls/categorized_image_acl.xml" --> \"$SERVER/sys/acls/categorized_image_acl.xml\":$HttpStatus"
  else
    echo "PUT:"$demohome/acls/categorized_image_acl.xml" --> \"$SERVER/sys/acls/categorized_image_acl.xml\": Operation Skipped, - document exists."
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
    echo "MKCOL \"$SERVER/home\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
    echo "MKCOL \"$SERVER/home/$USER\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata/xsd\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsd/imageMetadata.xsd" "$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/xsd/imageMetadata.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/registerSchema.sql" "$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/registerSchema.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/registerSchema.sql /home/$USER/imageMetadata/xsd/imageMetadata.xsd
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/patchSchemaLocation.sql $HOSTNAME /home/$USER/imageMetadata/xsd/imageMetadata.xsd
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageProcessor.sql" "$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/imageProcessor.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageProcessor.sql $USER XFILES
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/repositoryQueue.sql" "$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/repositoryQueue.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/repositoryQueue.sql $USER
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/imageEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/imageEventManager.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
    echo "MKCOL \"$SERVER/home\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
    echo "MKCOL \"$SERVER/home/$USER\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata/resConfig\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/resConfig/imageEventConfiguration.xml" "$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/resConfig/imageEventConfiguration.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/imageEventManager.sql $USER XFILES false
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/metadataServices.sql" "$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/metadataServices.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/metadataServices.sql $USER
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/enumerateRepositoryEvents.sql" "$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/enumerateRepositoryEvents.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/activateImageEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/activateImageEventManager.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/sql/enableEventManager.sql" "$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/sql/enableEventManager.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/enableEventManager.sql $USER
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/sql/queueManager.sql $USER
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
    echo "MKCOL \"$SERVER/home\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
    echo "MKCOL \"$SERVER/home/$USER\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata/xsl\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/ImageGallery.xsl" "$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/xsl/ImageGallery.xsl\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/EXIFViewer.xsl" "$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/xsl/EXIFViewer.xsl\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/xsl/EXIFCommon.xsl" "$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/xsl/EXIFCommon.xsl\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home" | head -1)
    echo "MKCOL \"$SERVER/home\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER" | head -1)
    echo "MKCOL \"$SERVER/home/$USER\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/imageMetadata/js\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/js/ImageGallery.js\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/js/ImageGallery.js\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/js/ImageGallery.js" "$SERVER/home/$USER/imageMetadata/js/ImageGallery.js" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/js/ImageGallery.js\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/js/EXIFViewer.js" "$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/js/EXIFViewer.js\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent" | head -1)
    echo "MKCOL \"$SERVER/publishedContent\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/categorization" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/categorization" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/categorization\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/enableImageGallery.sql $USER
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/resConfig/imageGalleryConfiguration.xml" "$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/imageMetadata/resConfig/imageGalleryConfiguration.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/createImageCategoryFolders.sql $USER
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishAppFolder.sql /home/$USER/imageMetadata XFILES_CONSTANTS.ACL_XFILES_USERS
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/sql/lockUser.sql $USER
  echo "Installation Complete. See $logfilename for details."
}
DBA=${1}
DBAPWD=${2}
USER=${3}
USERPWD=${4}
SERVER=${5}
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/ImageMetadata.log
echo "Log File : $logfilename"
if [ -f "$logfilename" ]
then
  rm $logfilename
fi
doInstall 2>&1 | tee -a $logfilename
