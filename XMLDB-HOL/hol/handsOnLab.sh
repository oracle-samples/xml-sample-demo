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
  echo "Installation Parameters for Oracle XML DB Hands on Lab : Oracle Database 12c."
  echo "\$DBA            : $DBA"
  echo "\$USER           : $USER"
  echo "\$SERVER         : $SERVER"
  echo "\$DEMOHOME       : $demohome"
  echo "\$ORACLE_HOME    : $ORACLE_HOME"
  echo "\$ORACLE_SID     : $ORACLE_SID"
  echo "\$XMLDB_HOL_BASE : $XMLDB_HOL_BASE"
  spexe=$(which sqlplus | head -1)
  echo "sqlplus      : $spexe"
  sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
  rc=$?
  echo "sqlplus $DBA:$rc"
  if [ $rc != 2 ] 
  then 
    echo "Operation Failed : Unable to connect via SQLPLUS as $DBA - Installation Aborted. See $logfilename for details."
    exit 2
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
  sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/hol/createUser.sql $USER $USERPWD
  sqlplus -L $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/verifyConnection.sql
  rc=$?
  echo "sqlplus $USER:$rc"
  if [ $rc != 2 ] 
  then 
    echo "Operation Failed : Unable to connect via SQLPLUS as $USER - Installation Aborted. See $logfilename for details."
    exit 3
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
  mkdir -p $XMLDB_HOL_BASE
  mkdir -p $XMLDB_HOL_BASE/sampleData
  mkdir -p $XMLDB_HOL_BASE/sql
  mkdir -p $XMLDB_HOL_BASE/sqlldr
  mkdir -p $XMLDB_HOL_BASE/install
  cp "$demohome/hol/clone/resetLab.sh" "$HOME/reset_XMLDB"
  chmod +x "$HOME/reset_XMLDB"
  sed -e "s|%HOLDIRECTORY%\/|$XMLDB_HOL_BASE\/|g" -i "$HOME/reset_XMLDB"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOME/reset_XMLDB"
  cp "$demohome/hol/clone/setupLab.sh" "$XMLDB_HOL_BASE/install/setupLab.sh"
  sed -e "s|%HOLDIRECTORY%\/|$XMLDB_HOL_BASE\/|g" -i "$XMLDB_HOL_BASE/install/setupLab.sh"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/install/setupLab.sh"
  cp "$demohome/setup/clone/install/setupLab.sql" "$XMLDB_HOL_BASE/install/setupLab.sql"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/install/setupLab.sql"
  cp "$demohome/setup/clone/install/createLinks.sql" "$XMLDB_HOL_BASE/install/createLinks.sql"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/install/createLinks.sql"
  echo "Unzipping \"$demohome/setup/sampleData/2015.zip\" into \"$XMLDB_HOL_BASE/sampleData\""
  unzip -o -qq "$demohome/setup/sampleData/2015.zip" -d "$XMLDB_HOL_BASE/sampleData"
  echo "Unzip Completed"
  echo "Cloning \"$demohome/setup/clone/sql\" into \"$XMLDB_HOL_BASE/sql\""
  cp -r "$demohome/setup/clone/sql"/* "$XMLDB_HOL_BASE/sql"
  find "$XMLDB_HOL_BASE/sql" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  mv "$XMLDB_HOL_BASE/sql/0.0 resetLab.sql" "$XMLDB_HOL_BASE/install/resetLab.sql"
  cp "$demohome/setup/clone/sqlldr/DATA-STAGE-2015.ctl" "$XMLDB_HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  sed -e "s|%DEMODIRECTORY%\/%USER%\/|$XMLDB_HOL_BASE\/|g" -i "$XMLDB_HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$XMLDB_HOL_BASE/install/2015.dat"
  sed -e "s|%DEMODIRECTORY%\/%USER%\/|$XMLDB_HOL_BASE\/|g" -i "$XMLDB_HOL_BASE/install/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/install/2015.dat"
  cp "$demohome/setup/clone/sqlldr/loadPurchaseOrders.sh" "$XMLDB_HOL_BASE/sqlldr/loadPurchaseOrders.sh"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/sqlldr/loadPurchaseOrders.sh"
  cp "$demohome/setup/clone/sqlldr/TABLE-NAME-2015.ctl" "$XMLDB_HOL_BASE/sqlldr/PURCHASEORDER.ctl"
  sed -e "s|%DEMODIRECTORY%\/%USER%\/|$XMLDB_HOL_BASE\/|g" -i "$XMLDB_HOL_BASE/sqlldr/PURCHASEORDER.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/sqlldr/PURCHASEORDER.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$XMLDB_HOL_BASE/sqlldr/2015.dat"
  sed -e "s|%DEMODIRECTORY%\/%USER%\/|$XMLDB_HOL_BASE\/|g" -i "$XMLDB_HOL_BASE/sqlldr/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%LAUNCHPAD%|Hands on Lab|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|enableHTTPTrace|false|g" -e "s|silentInstall|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$XMLDB_HOL_BASE/sqlldr/2015.dat"
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
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @"$XMLDB_HOL_BASE/install/setupLab.sql" $USER $USERPWD
  sqlplus $USER/$USERPWD@$ORACLE_SID @"$XMLDB_HOL_BASE/install/resetLab.sql"
  sed -e "s|\\\\|\/|g"  -i $XMLDB_HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl
  sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$XMLDB_HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @"$XMLDB_HOL_BASE/install/createLinks.sql" $USER $USERPWD
  unzip -o -qq "$demohome/manual/manual.zip" -d "$XMLDB_HOL_BASE/manual"
  ln -s "$XMLDB_HOL_BASE/manual/manual.htm" "$XMLDB_HOL_BASE/manual/index.html"
  echo "Installation Complete. See $logfilename for details."
}
DBA=${1}
DBAPWD=${2}
USER=${3}
USERPWD=${4}
SERVER=${5}
XMLDB_HOL_BASE=~/Desktop/DatabaseTrack/XMLDB
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/hol/handsOnLab.log
echo "Log File : $logfilename"
rm $logfilename
doInstall 2>&1 | tee -a $logfilename

