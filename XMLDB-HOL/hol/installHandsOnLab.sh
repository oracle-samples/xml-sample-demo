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
  echo "Hands On Lab Installation Parameters: Oracle XML DB Hands on Lab : Oracle Database 12c."
  echo "\$DBA            : $DBA"
  echo "\$USER           : $USER"
  echo "\$SERVER         : $SERVER"
  echo "\$DEMOHOME       : $demohome"
  echo "\$ORACLE_HOME    : $ORACLE_HOME"
  echo "\$ORACLE_SID     : $ORACLE_SID"
  echo "\$HOL_BASE       : $HOL_BASE"
  echo "\$LABID          : $LABID"
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
  sqlplus -L $DBA/$DBAPWD@$ORACLE_SID @$demohome/hol/sql/createUser.sql $USER $USERPWD
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
  rm -rf "$HOL_BASE"
  mkdir -p "$HOL_BASE"
  mkdir -p "$HOL_BASE/sampleData"
  mkdir -p "$HOL_BASE/sql"
  mkdir -p "$HOL_BASE/sqlldr"
  mkdir -p "$HOL_BASE/install"
  mkdir -p "$HOL_BASE/manual"
  echo "Unzipping \"$demohome/setup/sampleData/2015.zip\" into \"$HOL_BASE/sampleData\""
  unzip -o -qq "$demohome/setup/sampleData/2015.zip" -d "$HOL_BASE/sampleData"
  echo "Unzip Completed"
  echo "Cloning \"$demohome/setup/clone/sql\" into \"$HOL_BASE/sql\""
  cp -r "$demohome/setup/clone/sql"/* "$HOL_BASE/sql"
  find "$HOL_BASE/sql" -type f -print0 | xargs -0   sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i
  echo "Cloning Completed"
  cp "$demohome/hol/clone/resetLab.sh" "$HOME/reset_xmldb"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOME/reset_xmldb"
  cp "$demohome/hol/clone/setupLab.sh" "$HOL_BASE/install/setupLab.sh"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/install/setupLab.sh"
  cp "$demohome/setup/clone/install/setupLab.sql" "$HOL_BASE/install/setupLab.sql"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/install/setupLab.sql"
  cp "$demohome/setup/clone/sqlldr/DATA-STAGE-2015.ctl" "$HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$HOL_BASE/install/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/install/2015.dat"
  cp "$demohome/setup/clone/sqlldr/loadPurchaseOrders.sh" "$HOL_BASE/sqlldr/loadPurchaseOrders.sh"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/sqlldr/loadPurchaseOrders.sh"
  cp "$demohome/setup/clone/sqlldr/TABLE-NAME-2015.ctl" "$HOL_BASE/sqlldr/PURCHASEORDER.ctl"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/sqlldr/PURCHASEORDER.ctl"
  cp "$demohome/setup/clone/sqlldr/2015.dat" "$HOL_BASE/sqlldr/2015.dat"
  sed -e "s|%DEMODIRECTORY%|$demohome|g" -e "s|%DEMOFOLDERNAME%|XMLDB-HOL|g" -e "s|%DEMONAME%|Oracle XML DB Hands on Lab : Oracle Database 12c|g" -e "s|%PUBLICFOLDER%|\/publishedContent|g" -e "s|%DEMOCOMMON%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%DOCLIBRARY%|\/publishedContent\/Hands-On-Labs\/XMLDB|g" -e "s|%HOMEFOLDER%|\/home\/%USER%|g" -e "s|%DEMOLOCAL%|\/home\/%USER%\/Hands-On-Labs\/XMLDB|g" -e "s|%XFILES_SCHEMA%|XFILES|g" -e "s|%DATA_STAGING_TABLE%|SAMPLE_DATASET_XMLDB_HOL|g" -e "s|%TABLE_NAME%|PURCHASEORDER|g" -e "s|%SCHEMAURL%|http:\/\/localhost:80\/publishedContent\/HOL\/xsd\/purchaseOrder.xsd|g" -e "s|%HOL_BASE%|$HOL_BASE|g" -e "s|%HOL_ROOT%|$HOME\/Desktop\/Database_Track\/XMLDB|g" -e "s|%LABID%|xmldb|g" -e "s|enableHTTPTrace|false|g" -e "s|%ORACLEHOME%|$ORACLE_HOME|g" -e "s|%TNSALIAS%|$ORACLE_SID|g" -e "s|%HOSTNAME%|$HOSTNAME|g" -e "s|%HTTPPORT%|$HTTP|g" -e "s|%FTPPORT%|$FTP|g" -e "s|%DRIVELETTER%||g" -e "s|%DBA%|$DBA|g" -e "s|%DBAPASSWORD%|$DBAPWD|g" -e "s|%USER%|$USER|g" -e "s|%PASSWORD%|$USERPWD|g" -e "s|%SERVERURL%|$SERVER|g" -e "s|%DBCONNECTION%|$USER\/$USERPWD@$ORACLE_SID|g" -e "s|%SQLPLUS%|sqlplus|g" -e "s|%SHORTCUTFOLDER%|$demohome\/$USER|g" -e "s|\$USER|$USER|g" -e "s|\$SERVER|$SERVER|g" -i "$HOL_BASE/sqlldr/2015.dat"
  cp "$HOL_BASE/sql/0.0 resetLab.sql" "$HOL_BASE/install/resetLab.sql"
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @$demohome/install/sql/grantPermissions.sql $USER
  sqlplus $USER/$USERPWD@$ORACLE_SID @$demohome/install/sql/createHomeFolder.sql
  sqlplus $DBA/$DBAPWD@$ORACLE_SID @"$HOL_BASE/install/setupLab.sql" $USER $USERPWD
  sqlplus $USER/$USERPWD@$ORACLE_SID @"$HOL_BASE/install/resetLab.sql"
  sed -e "s|\\\\|\/|g"  -i $HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl
  sqlldr -Userid=$USER/$USERPWD@$ORACLE_SID control=$HOL_BASE/install/SAMPLE_DATASET_XMLDB_HOL.ctl
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
  unzip -o -qq "$demohome/manual/manual.zip" -d "$HOL_BASE/manual"
  ln -s "$HOL_BASE/manual/manual.htm" "$HOL_BASE/manual/index.html"
  chmod +x "$HOME/reset_xmldb"
  echo "Installation Complete. See $logfilename for details."
}
DBA=${1}
DBAPWD=${2}
USER=${3}
USERPWD=${4}
SERVER=${5}
HOL_BASE="$HOME/Desktop/Database_Track/XMLDB"
LABID="xmldb"
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/hol/installHandsOnLab.log
echo "Log File : $logfilename"
if [ -f "$logfilename" ]
then
  rm $logfilename
fi
doInstall 2>&1 | tee -a $logfilename
