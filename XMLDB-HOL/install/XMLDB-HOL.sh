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
  echo "Installation Parameters: Oracle XML DB Hands on Lab : Oracle Database 12c."
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
  mkdir -p "$demohome/$USER/sampleData"
  mkdir -p "$demohome/$USER/sql"
  mkdir -p "$demohome/$USER/simulate"
  mkdir -p "$demohome/$USER/sqlldr"
  mkdir -p "$demohome/$USER/install"
  echo "Unzipping \"$demohome/setup/sampleData/2015.zip\" into \"$demohome/$USER/sampleData\""
  unzip -o -qq "$demohome/setup/sampleData/2015.zip" -d "$demohome/$USER/sampleData"
  echo "Unzip Completed"
  echo "Cloning \"$demohome/setup/clone/sql\" into \"$demohome/$USER/sql\""
  cp -r "$demohome/setup/clone/sql"/* "$demohome/$USER/sql"
  find "$demohome/$USER/sql" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  cp "$demohome/setup/clone/install/setupLab.sql" "$demohome/$USER/install/setupLab.sql"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/install/setupLab.sql"
  cp "$demohome/setup/clone/sqlldr/DATA-STAGE-2015.ctl" "$demohome/$USER/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$demohome/$USER/install/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/install/2015.dat"
  cp "$demohome/setup/clone/sqlldr/loadPurchaseOrders.bat" "$demohome/$USER/sqlldr/loadPurchaseOrders.bat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sqlldr/loadPurchaseOrders.bat"
  cp "$demohome/setup/clone/sqlldr/loadPurchaseOrders.sh" "$demohome/$USER/sqlldr/loadPurchaseOrders.sh"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sqlldr/loadPurchaseOrders.sh"
  cp "$demohome/setup/clone/sqlldr/TABLE-NAME-2015.ctl" "$demohome/$USER/sqlldr/PURCHASEORDER.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sqlldr/PURCHASEORDER.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$demohome/$USER/sqlldr/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/sqlldr/2015.dat"
  cp "$demohome/setup/clone/simulate/sqlldr.sql" "$demohome/$USER/simulate/sqlldr.sql"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$demohome/$USER/simulate/sqlldr.sql"
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @"$demohome/$USER/install/setupLab.sql" $USER $USERPWD
  sqlplus $USER/$USERPWD@$ORACLE_SID @"$demohome/$USER/sql/0.0 resetLab.sql"
  sed -e "s|\\\\|\/|g"  -i $demohome/$USER/install/SAMPLE_DATASET_XMLDB_HOL.ctl
  sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$demohome/$USER/install/SAMPLE_DATASET_XMLDB_HOL.ctl
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  echo "DELETE \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
  if [ $HttpStatus != "200" ] && [ $HttpStatus != "204" ] && [ $HttpStatus != "404" ] 
  then
    echo "Operation Failed: Installation Aborted. See $logfilename for details."
    exit 6
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
  echo "DELETE \"$SERVER/home/$USER/Hands-On-Labs/XMLDB\":$HttpStatus"
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/xsd/purchaseOrder.xsd" "$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/xsd/purchaseOrder.xsd\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/simulate/sqlldr.sql" "$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/simulate/sqlldr.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/setup/assets/3.1.png" "$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/assets/3.1.png\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
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
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual" | head -1)
    echo "MKCOL \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/manual/manual.zip" "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $DBA:$DBAPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/manual/manual.pdf" "$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/publishedContent/Hands-On-Labs/XMLDB/manual/manual.pdf\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs/XMLDB\":$HttpStatus"
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
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0%20resetLab.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0%20resetLab.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0 resetLab.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0 resetLab.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/0.0 resetLab.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0%20resetLab.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/0.0 resetLab.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0%20createTable.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0%20createTable.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0 createTable.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0 createTable.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.0 createTable.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0%20createTable.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.0 createTable.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1%20simpleQueries.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1%20simpleQueries.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1 simpleQueries.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1 simpleQueries.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.1 simpleQueries.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1%20simpleQueries.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.1 simpleQueries.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2%20createXMLIndex.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2%20createXMLIndex.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2 createXMLIndex.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2 createXMLIndex.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.2 createXMLIndex.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2%20createXMLIndex.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.2 createXMLIndex.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3%20indexedQueries.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3%20indexedQueries.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3 indexedQueries.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3 indexedQueries.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.3 indexedQueries.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3%20indexedQueries.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.3 indexedQueries.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4%20pathSubsettedIndex.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4%20pathSubsettedIndex.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4 pathSubsettedIndex.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4 pathSubsettedIndex.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.4 pathSubsettedIndex.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4%20pathSubsettedIndex.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.4 pathSubsettedIndex.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5%20structuredXMLIndex.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5%20structuredXMLIndex.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5 structuredXMLIndex.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5 structuredXMLIndex.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/1.5 structuredXMLIndex.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5%20structuredXMLIndex.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/1.5 structuredXMLIndex.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0%20XQuery-Update.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0%20XQuery-Update.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0 XQuery-Update.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0 XQuery-Update.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/2.0 XQuery-Update.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0%20XQuery-Update.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.0 XQuery-Update.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1%20XQuery-FTIndex.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1%20XQuery-FTIndex.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1 XQuery-FTIndex.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1 XQuery-FTIndex.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/2.1 XQuery-FTIndex.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1%20XQuery-FTIndex.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.1 XQuery-FTIndex.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2%20XQuery-FTQueries.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2%20XQuery-FTQueries.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2 XQuery-FTQueries.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2 XQuery-FTQueries.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/2.2 XQuery-FTQueries.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2%20XQuery-FTQueries.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/2.2 XQuery-FTQueries.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0%20registerSchema.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0%20registerSchema.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0 registerSchema.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0 registerSchema.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/3.0 registerSchema.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0%20registerSchema.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.0 registerSchema.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2%20createIndexes.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2%20createIndexes.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2 createIndexes.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2 createIndexes.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/3.2 createIndexes.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2%20createIndexes.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.2 createIndexes.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4%20partitionedXMLTable.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4%20partitionedXMLTable.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4 partitionedXMLTable.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4 partitionedXMLTable.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/3.4 partitionedXMLTable.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4%20partitionedXMLTable.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/3.4 partitionedXMLTable.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0%20relationalViews.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0%20relationalViews.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0 relationalViews.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0 relationalViews.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/4.0 relationalViews.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0%20relationalViews.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.0 relationalViews.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1%20relationalQueries.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1%20relationalQueries.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1 relationalQueries.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1 relationalQueries.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/4.1 relationalQueries.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1%20relationalQueries.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/4.1 relationalQueries.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0%20relational2XML_XQUERY.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0%20relational2XML_XQUERY.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0 relational2XML_XQUERY.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0 relational2XML_XQUERY.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/5.0 relational2XML_XQUERY.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0%20relational2XML_XQUERY.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.0 relational2XML_XQUERY.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1%20relational2XML_SQLXML.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1%20relational2XML_SQLXML.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1 relational2XML_SQLXML.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1 relational2XML_SQLXML.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/5.1 relational2XML_SQLXML.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1%20relational2XML_SQLXML.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.1 relational2XML_SQLXML.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2%20xmlViewRelationalData.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2%20xmlViewRelationalData.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2 xmlViewRelationalData.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2 xmlViewRelationalData.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/5.2 xmlViewRelationalData.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2%20xmlViewRelationalData.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.2 xmlViewRelationalData.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3%20xqueryOnRelationalData.sql" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3%20xqueryOnRelationalData.sql" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3 xqueryOnRelationalData.sql\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3 xqueryOnRelationalData.sql\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/$USER/sql/5.3 xqueryOnRelationalData.sql" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3%20xqueryOnRelationalData.sql" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/sql/5.3 xqueryOnRelationalData.sql\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
    exit 5
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/unzipArchive.sql /publishedContent/Hands-On-Labs/XMLDB/manual/manual.zip /publishedContent/Hands-On-Labs/XMLDB/manual /publishedContent/Hands-On-Labs/XMLDB/manual/manual.log
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i $demohome/install/configuration.xml
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml" | head -1)
  if [ $HttpStatus != "404" ] 
  then
    if [ $HttpStatus == "200" ] 
    then
      HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X DELETE --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml" | head -1)
      if [ $HttpStatus != "200" ] && [ $HttpStatus != "202" ] && [ $HttpStatus != "204" ]
      then
        echo "PUT[DELETE] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml\":$HttpStatus - Delete Operation Failed. See $logfilename for details."
        exit 5
      fi
    else
      echo "PUT[HEAD] \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml\":$HttpStatus - Operation Failed. See $logfilename for details."
      exit 5
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X PUT --write-out "%{http_code}\n"  -s --output /dev/null --upload-file "$demohome/install/configuration.xml" "$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml" | head -1)
  if [ $HttpStatus != "201" ] 
  then
    echo "PUT \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/configuration.xml\":$HttpStatus - Operation Failed: Installation Aborted. See $logfilename for details."
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
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs/XMLDB\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD --head --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/Links" | head -1)
  if [ $HttpStatus == "404" ] 
  then
    HttpStatus=$(curl --noproxy '*' --digest -u $USER:$USERPWD -X MKCOL --write-out "%{http_code}\n" -s --output /dev/null "$SERVER/home/$USER/Hands-On-Labs/XMLDB/Links" | head -1)
    echo "MKCOL \"$SERVER/home/$USER/Hands-On-Labs/XMLDB/Links\":$HttpStatus"
    if [ $HttpStatus != "201" ]
    then
      echo "Operation Failed [$HttpStatus] - Installation Aborted. See $logfilename for details."
      exit 6
    fi
  fi
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/createLink.sql /publishedContent/Hands-On-Labs/XMLDB/manual /home/$USER/Hands-On-Labs/XMLDB manual
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/createLink.sql /publishedContent/Hands-On-Labs/XMLDB/xsd /home/$USER/Hands-On-Labs/XMLDB xsd
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/publishDemo.sql /home/$USER/Hands-On-Labs/XMLDB XFILES
  shellscriptName="$demohome/Hands_on_Lab.sh"
  echo "Shell Script : $shellscriptName"
  echo "firefox $SERVER/home/$USER/Hands-On-Labs/XMLDB/index.html"> $shellscriptName
  echo "Installation Complete. See $logfilename for details."
}
DBA=${1}
DBAPWD=${2}
USER=${3}
USERPWD=${4}
SERVER=${5}
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/install/XMLDB-HOL.log
echo "Log File : $logfilename"
if [ -f "$logfilename" ]
then
  rm $logfilename
fi
doInstall 2>&1 | tee -a $logfilename
