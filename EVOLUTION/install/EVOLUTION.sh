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
  echo "Installation Parameters: XML Schema Evolution using Oracle XML DB."
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
  mkdir -p "$demohome/$USER"
  mkdir -p "$demohome/$USER/xsd"
  mkdir -p "$demohome/$USER/sql"
  mkdir -p "$demohome/$USER/sampleData"
  mkdir -p "$demohome/$USER/sampleData/xml"
  cp -r "$demohome/setup/xml"/* "$demohome/$USER/sampleData/xml"
  echo "Unzipping \"$demohome/setup/sampleData.zip\" into \"$demohome/$USER/sampleData/xml\""
  unzip -o -qq "$demohome/setup/sampleData.zip" -d "$demohome/$USER/sampleData/xml"
  echo "Unzip Completed"
  echo "Cloning \"$demohome/setup/sql\" into \"$demohome/$USER/sql\""
  cp -r "$demohome/setup/sql"/* "$demohome/$USER/sql"
  find "$demohome/$USER/sql" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|EVOLUTION|g" -e "s|%DEMONAME%|XML Schema Evolution using Oracle XML DB|g" -e "s|%LAUNCHPAD%|XML Schema Evolution|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XMLDB\/evolution|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XMLDB\/evolution|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/purchaseOrder.xsd|g" -e "s|%SCHEMAURL2%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/shipmentDetails.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_EVOLVE|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  echo "Cloning \"$demohome/$USER/sampleData/xml\" into \"$demohome/$USER/sampleData/xml\""
  find "$demohome/$USER/sampleData/xml" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|EVOLUTION|g" -e "s|%DEMONAME%|XML Schema Evolution using Oracle XML DB|g" -e "s|%LAUNCHPAD%|XML Schema Evolution|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XMLDB\/evolution|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XMLDB\/evolution|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/purchaseOrder.xsd|g" -e "s|%SCHEMAURL2%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/shipmentDetails.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_EVOLVE|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  echo "Cloning \"$demohome/setup/sqlldr\" into \"$demohome/$USER/sampleData\""
  cp -r "$demohome/setup/sqlldr"/* "$demohome/$USER/sampleData"
  find "$demohome/$USER/sampleData" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|EVOLUTION|g" -e "s|%DEMONAME%|XML Schema Evolution using Oracle XML DB|g" -e "s|%LAUNCHPAD%|XML Schema Evolution|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XMLDB\/evolution|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XMLDB\/evolution|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/purchaseOrder.xsd|g" -e "s|%SCHEMAURL2%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/shipmentDetails.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_EVOLVE|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  echo "Cloning \"$demohome/setup/xsd\" into \"$demohome/$USER/xsd\""
  cp -r "$demohome/setup/xsd"/* "$demohome/$USER/xsd"
  find "$demohome/$USER/xsd" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|EVOLUTION|g" -e "s|%DEMONAME%|XML Schema Evolution using Oracle XML DB|g" -e "s|%LAUNCHPAD%|XML Schema Evolution|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XMLDB\/evolution|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XMLDB\/evolution|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/purchaseOrder.xsd|g" -e "s|%SCHEMAURL2%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/shipmentDetails.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_EVOLVE|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/$USER/sql/setup.sql
  sed -e "s|\\\\|\/|g"  -i $demohome/$USER/sampleData/sampleData.ctl
  sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$demohome/$USER/sampleData/sampleData.ctl
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/executeAndQuit.sql $demohome/$USER/sql/resetDemo.sql
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  echo "DELETE \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
  if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
  then
    echo "Operation Failed: Installation Aborted. See $logfilename for details."
    exit 6
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution" | head -1)
  echo "DELETE \"$SERVER/home/$USER/demonstrations/XMLDB/evolution\":$HttpStatus"
  if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
  then
    echo "Operation Failed: Installation Aborted. See $logfilename for details."
    exit 6
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/assets/2.1.png" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/assets/2.1.png\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.xsd" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/xsd/shipmentDetails.xsd" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/shipmentDetails.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.v2.xsd" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v2.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.v3.xsd" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsd/purchaseOrder.v3.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/transform.v3.xsl" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xsl/transform.v3.xsl\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/xml/PurchaseOrderWithShipment.v1.xml" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v1.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/xml/PurchaseOrderWithShipment.v2.xml" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrderWithShipment.v2.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/xml/PurchaseOrder.v2.xml" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v2.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sampleData/xml/PurchaseOrder.v3.xml" "$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/demonstrations/XMLDB/evolution/xml/PurchaseOrder.v3.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
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
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations/XMLDB/evolution\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/resetDemo.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/resetDemo.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/registerSchema.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerSchema.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/registerExtension.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/registerExtension.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/inplaceEvolution.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/inplaceEvolution.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/copyBasedEvolution1.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution1.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/copyBasedEvolution2.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/copyBasedEvolution2.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/insertDocument1.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument1.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/insertDocument2.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument2.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/insertDocument3.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument3.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/insertDocument4.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/insertDocument4.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/addDateCreated.sql" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/sql/addDateCreated.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|EVOLUTION|g" -e "s|%DEMONAME%|XML Schema Evolution using Oracle XML DB|g" -e "s|%LAUNCHPAD%|XML Schema Evolution|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/demonstrations\/XMLDB\/evolution|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/demonstrations\/XMLDB\/evolution|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%XFILES_ROOT%|XFILES|g" -e "s|%SCHEMAURL%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/purchaseOrder.xsd|g" -e "s|%SCHEMAURL2%|%SERVERURL%\/publishedContent\/demonstrations\/XMLDB\/evolution\/xsd\/shipmentDetails.xsd|g" -e "s|%TABLE1%|PURCHASEORDER|g" -e "s|%ROOT_TYPE%|PURCHASEORDER_T|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_EVOLVE|g" -e "s|protocol|HTTP|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i $demohome/install/configuration.xml
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/install/configuration.xml" "$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/demonstrations/XMLDB/evolution/configuration.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishDemo.sql /home/$USER/demonstrations/XMLDB/evolution XFILES
  shellscriptName="$demohome/XML_Schema_Evolution.sh"
  echo "Shell Script : $shellscriptName"
  echo "firefox $SERVER/home/$USER/demonstrations/XMLDB/evolution/index.html"> $shellscriptName
  echo "Installation Complete. See $logfilename for details."
}
DBA=${1}
DBAPWD=${2}
USER=${3}
USERPWD=${4}
SERVER=${5}
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/EVOLUTION.log
echo "Log File : $logfilename"
if [ -f "$logfilename" ]
then
  rm $logfilename
fi
doInstall 2>&1 | tee -a $logfilename
