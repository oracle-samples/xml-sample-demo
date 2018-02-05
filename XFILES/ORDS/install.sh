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
  echo "ORDS Installation Parameters: Oracle XML DB XFiles application."
  echo "\$ORDS_ROOT      : $ORDS_ROOT"
  echo "\$USER           : $USER"
  echo "\$SERVER         : $SERVER"
  echo "\$DEMOHOME       : $demohome"
  rm -rf "$ORDS_ROOT/home/$USER/src/"
  rc=$?
  echo "DELETE "$ORDS_ROOT/home/$USER/src/" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 6
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Applications"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Applications" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/Xinha-0.96.1.zip" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/Xinha-0.96.1.zip"
  fi
  cp  "$demohome/src/Xinha-0.96.1.zip" "$ORDS_ROOT/home/$USER/src/Xinha-0.96.1.zip"
  rc=$?
  echo "COPY:"$demohome/src/Xinha-0.96.1.zip" --> "$ORDS_ROOT/home/$USER/src/Xinha-0.96.1.zip" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/famfamfam_silk_icons_v013.zip" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/famfamfam_silk_icons_v013.zip"
  fi
  cp  "$demohome/src/famfamfam_silk_icons_v013.zip" "$ORDS_ROOT/home/$USER/src/famfamfam_silk_icons_v013.zip"
  rc=$?
  echo "COPY:"$demohome/src/famfamfam_silk_icons_v013.zip" --> "$ORDS_ROOT/home/$USER/src/famfamfam_silk_icons_v013.zip" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/bootstrap3-dialog-master.zip" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/bootstrap3-dialog-master.zip"
  fi
  cp  "$demohome/src/bootstrap3-dialog-master.zip" "$ORDS_ROOT/home/$USER/src/bootstrap3-dialog-master.zip"
  rc=$?
  echo "COPY:"$demohome/src/bootstrap3-dialog-master.zip" --> "$ORDS_ROOT/home/$USER/src/bootstrap3-dialog-master.zip" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/bootstrap-3.2.0-dist.zip" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/bootstrap-3.2.0-dist.zip"
  fi
  cp  "$demohome/src/bootstrap-3.2.0-dist.zip" "$ORDS_ROOT/home/$USER/src/bootstrap-3.2.0-dist.zip"
  rc=$?
  echo "COPY:"$demohome/src/bootstrap-3.2.0-dist.zip" --> "$ORDS_ROOT/home/$USER/src/bootstrap-3.2.0-dist.zip" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/jssor.zip" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/jssor.zip"
  fi
  cp  "$demohome/src/jssor.zip" "$ORDS_ROOT/home/$USER/src/jssor.zip"
  rc=$?
  echo "COPY:"$demohome/src/jssor.zip" --> "$ORDS_ROOT/home/$USER/src/jssor.zip" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/apex/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/apex/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/apex/xsl/showTree.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/apex/xsl/showTree.xsl"
  fi
  cp  "$demohome/src/apex/xsl/showTree.xsl" "$ORDS_ROOT/home/$USER/src/apex/xsl/showTree.xsl"
  rc=$?
  echo "COPY:"$demohome/src/apex/xsl/showTree.xsl" --> "$ORDS_ROOT/home/$USER/src/apex/xsl/showTree.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/common"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/common" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/common/js"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/common/js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/common.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/common.js"
  fi
  cp  "$demohome/src/common/js/common.js" "$ORDS_ROOT/home/$USER/src/common/js/common.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/common.js" --> "$ORDS_ROOT/home/$USER/src/common/js/common.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/XMLPrettyPrint.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/XMLPrettyPrint.js"
  fi
  cp  "$demohome/src/common/js/XMLPrettyPrint.js" "$ORDS_ROOT/home/$USER/src/common/js/XMLPrettyPrint.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/XMLPrettyPrint.js" --> "$ORDS_ROOT/home/$USER/src/common/js/XMLPrettyPrint.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/jsonPrettyPrint.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/jsonPrettyPrint.js"
  fi
  cp  "$demohome/src/common/js/jsonPrettyPrint.js" "$ORDS_ROOT/home/$USER/src/common/js/jsonPrettyPrint.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/jsonPrettyPrint.js" --> "$ORDS_ROOT/home/$USER/src/common/js/jsonPrettyPrint.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/renderJSON.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/renderJSON.js"
  fi
  cp  "$demohome/src/common/js/renderJSON.js" "$ORDS_ROOT/home/$USER/src/common/js/renderJSON.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/renderJSON.js" --> "$ORDS_ROOT/home/$USER/src/common/js/renderJSON.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/xmlDocumentObject.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/xmlDocumentObject.js"
  fi
  cp  "$demohome/src/common/js/xmlDocumentObject.js" "$ORDS_ROOT/home/$USER/src/common/js/xmlDocumentObject.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/xmlDocumentObject.js" --> "$ORDS_ROOT/home/$USER/src/common/js/xmlDocumentObject.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/RestAPI.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/RestAPI.js"
  fi
  cp  "$demohome/src/common/js/RestAPI.js" "$ORDS_ROOT/home/$USER/src/common/js/RestAPI.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/RestAPI.js" --> "$ORDS_ROOT/home/$USER/src/common/js/RestAPI.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/RestUtilities.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/RestUtilities.js"
  fi
  cp  "$demohome/src/common/js/RestUtilities.js" "$ORDS_ROOT/home/$USER/src/common/js/RestUtilities.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/RestUtilities.js" --> "$ORDS_ROOT/home/$USER/src/common/js/RestUtilities.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/runtime.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/runtime.js"
  fi
  cp  "$demohome/src/common/js/runtime.js" "$ORDS_ROOT/home/$USER/src/common/js/runtime.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/runtime.js" --> "$ORDS_ROOT/home/$USER/src/common/js/runtime.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/common/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/common/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/xsl/wsdl2Request.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/xsl/wsdl2Request.xsl"
  fi
  cp  "$demohome/src/common/xsl/wsdl2Request.xsl" "$ORDS_ROOT/home/$USER/src/common/xsl/wsdl2Request.xsl"
  rc=$?
  echo "COPY:"$demohome/src/common/xsl/wsdl2Request.xsl" --> "$ORDS_ROOT/home/$USER/src/common/xsl/wsdl2Request.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/xsl/formatResponse.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/xsl/formatResponse.xsl"
  fi
  cp  "$demohome/src/common/xsl/formatResponse.xsl" "$ORDS_ROOT/home/$USER/src/common/xsl/formatResponse.xsl"
  rc=$?
  echo "COPY:"$demohome/src/common/xsl/formatResponse.xsl" --> "$ORDS_ROOT/home/$USER/src/common/xsl/formatResponse.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/xsl/formatXPlan.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/xsl/formatXPlan.xsl"
  fi
  cp  "$demohome/src/common/xsl/formatXPlan.xsl" "$ORDS_ROOT/home/$USER/src/common/xsl/formatXPlan.xsl"
  rc=$?
  echo "COPY:"$demohome/src/common/xsl/formatXPlan.xsl" --> "$ORDS_ROOT/home/$USER/src/common/xsl/formatXPlan.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/xsl/formatDescribe.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/xsl/formatDescribe.xsl"
  fi
  cp  "$demohome/src/common/xsl/formatDescribe.xsl" "$ORDS_ROOT/home/$USER/src/common/xsl/formatDescribe.xsl"
  rc=$?
  echo "COPY:"$demohome/src/common/xsl/formatDescribe.xsl" --> "$ORDS_ROOT/home/$USER/src/common/xsl/formatDescribe.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/xsl/formatDBURI.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/xsl/formatDBURI.xsl"
  fi
  cp  "$demohome/src/common/xsl/formatDBURI.xsl" "$ORDS_ROOT/home/$USER/src/common/xsl/formatDBURI.xsl"
  rc=$?
  echo "COPY:"$demohome/src/common/xsl/formatDBURI.xsl" --> "$ORDS_ROOT/home/$USER/src/common/xsl/formatDBURI.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/lite"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/lite" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/XFilesLaunchPad.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/XFilesLaunchPad.html"
  fi
  cp  "$demohome/src/lite/XFilesLaunchPad.html" "$ORDS_ROOT/home/$USER/src/lite/XFilesLaunchPad.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/XFilesLaunchPad.html" --> "$ORDS_ROOT/home/$USER/src/lite/XFilesLaunchPad.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/aboutXFiles.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/aboutXFiles.html"
  fi
  cp  "$demohome/src/lite/aboutXFiles.html" "$ORDS_ROOT/home/$USER/src/lite/aboutXFiles.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/aboutXFiles.html" --> "$ORDS_ROOT/home/$USER/src/lite/aboutXFiles.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/Folder.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/Folder.html"
  fi
  cp  "$demohome/src/lite/Folder.html" "$ORDS_ROOT/home/$USER/src/lite/Folder.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/Folder.html" --> "$ORDS_ROOT/home/$USER/src/lite/Folder.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/FolderRSS.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/FolderRSS.html"
  fi
  cp  "$demohome/src/lite/FolderRSS.html" "$ORDS_ROOT/home/$USER/src/lite/FolderRSS.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/FolderRSS.html" --> "$ORDS_ROOT/home/$USER/src/lite/FolderRSS.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/Resource.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/Resource.html"
  fi
  cp  "$demohome/src/lite/Resource.html" "$ORDS_ROOT/home/$USER/src/lite/Resource.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/Resource.html" --> "$ORDS_ROOT/home/$USER/src/lite/Resource.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/Version.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/Version.html"
  fi
  cp  "$demohome/src/lite/Version.html" "$ORDS_ROOT/home/$USER/src/lite/Version.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/Version.html" --> "$ORDS_ROOT/home/$USER/src/lite/Version.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/lite/js"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/lite/js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/folder.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/folder.js"
  fi
  cp  "$demohome/src/lite/js/folder.js" "$ORDS_ROOT/home/$USER/src/lite/js/folder.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/folder.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/folder.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/resource.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/resource.js"
  fi
  cp  "$demohome/src/lite/js/resource.js" "$ORDS_ROOT/home/$USER/src/lite/js/resource.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/resource.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/resource.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/version.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/version.js"
  fi
  cp  "$demohome/src/lite/js/version.js" "$ORDS_ROOT/home/$USER/src/lite/js/version.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/version.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/version.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/common.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/common.js"
  fi
  cp  "$demohome/src/lite/js/common.js" "$ORDS_ROOT/home/$USER/src/lite/js/common.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/common.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/common.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/dynamicCode.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/dynamicCode.js"
  fi
  cp  "$demohome/src/lite/js/dynamicCode.js" "$ORDS_ROOT/home/$USER/src/lite/js/dynamicCode.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/dynamicCode.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/dynamicCode.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/common/js/userManagement.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/common/js/userManagement.js"
  fi
  cp  "$demohome/src/common/js/userManagement.js" "$ORDS_ROOT/home/$USER/src/common/js/userManagement.js"
  rc=$?
  echo "COPY:"$demohome/src/common/js/userManagement.js" --> "$ORDS_ROOT/home/$USER/src/common/js/userManagement.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/XinhaInit.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/XinhaInit.js"
  fi
  cp  "$demohome/src/lite/js/XinhaInit.js" "$ORDS_ROOT/home/$USER/src/lite/js/XinhaInit.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/XinhaInit.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/XinhaInit.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/FolderBrowser.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/FolderBrowser.js"
  fi
  cp  "$demohome/src/lite/js/FolderBrowser.js" "$ORDS_ROOT/home/$USER/src/lite/js/FolderBrowser.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/FolderBrowser.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/FolderBrowser.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/ResourceProperties.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/ResourceProperties.js"
  fi
  cp  "$demohome/src/lite/js/ResourceProperties.js" "$ORDS_ROOT/home/$USER/src/lite/js/ResourceProperties.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/ResourceProperties.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/ResourceProperties.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/VersionHistory.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/VersionHistory.js"
  fi
  cp  "$demohome/src/lite/js/VersionHistory.js" "$ORDS_ROOT/home/$USER/src/lite/js/VersionHistory.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/VersionHistory.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/VersionHistory.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/UploadFiles.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/UploadFiles.js"
  fi
  cp  "$demohome/src/lite/js/UploadFiles.js" "$ORDS_ROOT/home/$USER/src/lite/js/UploadFiles.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/UploadFiles.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/UploadFiles.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/XFilesWiki.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/XFilesWiki.js"
  fi
  cp  "$demohome/src/lite/js/XFilesWiki.js" "$ORDS_ROOT/home/$USER/src/lite/js/XFilesWiki.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/XFilesWiki.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/XFilesWiki.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/SourceViewer.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/SourceViewer.js"
  fi
  cp  "$demohome/src/lite/js/SourceViewer.js" "$ORDS_ROOT/home/$USER/src/lite/js/SourceViewer.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/SourceViewer.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/SourceViewer.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/TableRenderer.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/TableRenderer.js"
  fi
  cp  "$demohome/src/lite/js/TableRenderer.js" "$ORDS_ROOT/home/$USER/src/lite/js/TableRenderer.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/TableRenderer.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/TableRenderer.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/XMLSchemaList.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/XMLSchemaList.js"
  fi
  cp  "$demohome/src/lite/js/XMLSchemaList.js" "$ORDS_ROOT/home/$USER/src/lite/js/XMLSchemaList.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/XMLSchemaList.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/XMLSchemaList.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/XMLIndexList.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/XMLIndexList.js"
  fi
  cp  "$demohome/src/lite/js/XMLIndexList.js" "$ORDS_ROOT/home/$USER/src/lite/js/XMLIndexList.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/XMLIndexList.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/XMLIndexList.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/onPageLoaded.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/onPageLoaded.js"
  fi
  cp  "$demohome/src/lite/js/onPageLoaded.js" "$ORDS_ROOT/home/$USER/src/lite/js/onPageLoaded.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/onPageLoaded.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/onPageLoaded.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/xfilesStatus.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/xfilesStatus.js"
  fi
  cp  "$demohome/src/lite/js/xfilesStatus.js" "$ORDS_ROOT/home/$USER/src/lite/js/xfilesStatus.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/xfilesStatus.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/xfilesStatus.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/js/fileUpload.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/js/fileUpload.js"
  fi
  cp  "$demohome/src/lite/js/fileUpload.js" "$ORDS_ROOT/home/$USER/src/lite/js/fileUpload.js"
  rc=$?
  echo "COPY:"$demohome/src/lite/js/fileUpload.js" --> "$ORDS_ROOT/home/$USER/src/lite/js/fileUpload.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/lite/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/lite/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/common.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/common.xsl"
  fi
  cp  "$demohome/src/lite/xsl/common.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/common.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/common.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/common.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/folderTree.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/folderTree.xsl"
  fi
  cp  "$demohome/src/lite/xsl/folderTree.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/folderTree.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/folderTree.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/folderTree.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowserDialogs.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowserDialogs.xsl"
  fi
  cp  "$demohome/src/lite/xsl/FolderBrowserDialogs.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowserDialogs.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/FolderBrowserDialogs.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowserDialogs.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesRSSFeed.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesRSSFeed.xsl"
  fi
  cp  "$demohome/src/lite/xsl/XFilesRSSFeed.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesRSSFeed.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XFilesRSSFeed.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesRSSFeed.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xsl"
  fi
  cp  "$demohome/src/lite/xsl/XFilesMappings.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XFilesMappings.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowser.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowser.xsl"
  fi
  cp  "$demohome/src/lite/xsl/FolderBrowser.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowser.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/FolderBrowser.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderBrowser.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderListing.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderListing.xsl"
  fi
  cp  "$demohome/src/lite/xsl/FolderListing.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderListing.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/FolderListing.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderListing.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderFileListing.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderFileListing.xsl"
  fi
  cp  "$demohome/src/lite/xsl/FolderFileListing.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderFileListing.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/FolderFileListing.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/FolderFileListing.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/ResourceProperties.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/ResourceProperties.xsl"
  fi
  cp  "$demohome/src/lite/xsl/ResourceProperties.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/ResourceProperties.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/ResourceProperties.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/ResourceProperties.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/VersionHistory.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/VersionHistory.xsl"
  fi
  cp  "$demohome/src/lite/xsl/VersionHistory.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/VersionHistory.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/VersionHistory.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/VersionHistory.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFiles.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFiles.xsl"
  fi
  cp  "$demohome/src/lite/xsl/UploadFiles.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFiles.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/UploadFiles.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFiles.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFilesStatus.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFilesStatus.html"
  fi
  cp  "$demohome/src/lite/xsl/UploadFilesStatus.html" "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFilesStatus.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/UploadFilesStatus.html" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/UploadFilesStatus.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/fileUpload.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/fileUpload.html"
  fi
  cp  "$demohome/src/lite/xsl/fileUpload.html" "$ORDS_ROOT/home/$USER/src/lite/xsl/fileUpload.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/fileUpload.html" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/fileUpload.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesWiki.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesWiki.xsl"
  fi
  cp  "$demohome/src/lite/xsl/XFilesWiki.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesWiki.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XFilesWiki.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesWiki.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/SourceViewer.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/SourceViewer.xsl"
  fi
  cp  "$demohome/src/lite/xsl/SourceViewer.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/SourceViewer.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/SourceViewer.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/SourceViewer.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/TableRenderer.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/TableRenderer.xsl"
  fi
  cp  "$demohome/src/lite/xsl/TableRenderer.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/TableRenderer.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/TableRenderer.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/TableRenderer.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLIndexList.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLIndexList.xsl"
  fi
  cp  "$demohome/src/lite/xsl/XMLIndexList.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLIndexList.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XMLIndexList.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLIndexList.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLSchemaList.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLSchemaList.xsl"
  fi
  cp  "$demohome/src/lite/xsl/XMLSchemaList.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLSchemaList.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XMLSchemaList.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XMLSchemaList.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/plainTextContent.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/plainTextContent.xsl"
  fi
  cp  "$demohome/src/lite/xsl/plainTextContent.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/plainTextContent.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/plainTextContent.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/plainTextContent.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/xfilesStatus.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/xfilesStatus.xsl"
  fi
  cp  "$demohome/src/lite/xsl/xfilesStatus.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/xfilesStatus.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/xfilesStatus.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/xfilesStatus.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/formatXFilesStatus.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/formatXFilesStatus.xsl"
  fi
  cp  "$demohome/src/lite/xsl/formatXFilesStatus.xsl" "$ORDS_ROOT/home/$USER/src/lite/xsl/formatXFilesStatus.xsl"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/formatXFilesStatus.xsl" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/formatXFilesStatus.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesIconMappings.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesIconMappings.xml"
  fi
  cp  "$demohome/src/lite/xsl/XFilesIconMappings.xml" "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesIconMappings.xml"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XFilesIconMappings.xml" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesIconMappings.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xml"
  fi
  cp  "$demohome/src/lite/xsl/XFilesMappings.xml" "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xml"
  rc=$?
  echo "COPY:"$demohome/src/lite/xsl/XFilesMappings.xml" --> "$ORDS_ROOT/home/$USER/src/lite/xsl/XFilesMappings.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/WebServices"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/WebServices" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebServices/webServices.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebServices/webServices.html"
  fi
  cp  "$demohome/src/WebServices/webServices.html" "$ORDS_ROOT/home/$USER/src/WebServices/webServices.html"
  rc=$?
  echo "COPY:"$demohome/src/WebServices/webServices.html" --> "$ORDS_ROOT/home/$USER/src/WebServices/webServices.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/WebServices/js"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/WebServices/js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapExample.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapExample.js"
  fi
  cp  "$demohome/src/WebServices/js/simpleSoapExample.js" "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapExample.js"
  rc=$?
  echo "COPY:"$demohome/src/WebServices/js/simpleSoapExample.js" --> "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapExample.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapSupport.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapSupport.js"
  fi
  cp  "$demohome/src/WebServices/js/simpleSoapSupport.js" "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapSupport.js"
  rc=$?
  echo "COPY:"$demohome/src/WebServices/js/simpleSoapSupport.js" --> "$ORDS_ROOT/home/$USER/src/WebServices/js/simpleSoapSupport.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/WebServices/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/WebServices/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebServices/xsl/webServices.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebServices/xsl/webServices.xsl"
  fi
  cp  "$demohome/src/WebServices/xsl/webServices.xsl" "$ORDS_ROOT/home/$USER/src/WebServices/xsl/webServices.xsl"
  rc=$?
  echo "COPY:"$demohome/src/WebServices/xsl/webServices.xsl" --> "$ORDS_ROOT/home/$USER/src/WebServices/xsl/webServices.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebServices/xsl/simpleInputForm.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebServices/xsl/simpleInputForm.xsl"
  fi
  cp  "$demohome/src/WebServices/xsl/simpleInputForm.xsl" "$ORDS_ROOT/home/$USER/src/WebServices/xsl/simpleInputForm.xsl"
  rc=$?
  echo "COPY:"$demohome/src/WebServices/xsl/simpleInputForm.xsl" --> "$ORDS_ROOT/home/$USER/src/WebServices/xsl/simpleInputForm.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/XMLSearch"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/XMLSearch" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlIndex.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlIndex.html"
  fi
  cp  "$demohome/src/XMLSearch/xmlIndex.html" "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlIndex.html"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xmlIndex.html" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlIndex.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlSchema.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlSchema.html"
  fi
  cp  "$demohome/src/XMLSearch/xmlSchema.html" "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlSchema.html"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xmlSchema.html" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xmlSchema.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/reposSearch.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/reposSearch.html"
  fi
  cp  "$demohome/src/XMLSearch/reposSearch.html" "$ORDS_ROOT/home/$USER/src/XMLSearch/reposSearch.html"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/reposSearch.html" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/reposSearch.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/resourceSearch.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/resourceSearch.html"
  fi
  cp  "$demohome/src/XMLSearch/resourceSearch.html" "$ORDS_ROOT/home/$USER/src/XMLSearch/resourceSearch.html"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/resourceSearch.html" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/resourceSearch.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/XMLSearch/js"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/XMLSearch/js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlIndexSearch.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlIndexSearch.js"
  fi
  cp  "$demohome/src/XMLSearch/js/xmlIndexSearch.js" "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlIndexSearch.js"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/js/xmlIndexSearch.js" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlIndexSearch.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSchemaSearch.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSchemaSearch.js"
  fi
  cp  "$demohome/src/XMLSearch/js/xmlSchemaSearch.js" "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSchemaSearch.js"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/js/xmlSchemaSearch.js" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSchemaSearch.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSearch.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSearch.js"
  fi
  cp  "$demohome/src/XMLSearch/js/xmlSearch.js" "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSearch.js"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/js/xmlSearch.js" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/js/xmlSearch.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/js/reposSearch.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/js/reposSearch.js"
  fi
  cp  "$demohome/src/XMLSearch/js/reposSearch.js" "$ORDS_ROOT/home/$USER/src/XMLSearch/js/reposSearch.js"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/js/reposSearch.js" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/js/reposSearch.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/js/resourceSearch.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/js/resourceSearch.js"
  fi
  cp  "$demohome/src/XMLSearch/js/resourceSearch.js" "$ORDS_ROOT/home/$USER/src/XMLSearch/js/resourceSearch.js"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/js/resourceSearch.js" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/js/resourceSearch.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/common.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/common.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/common.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/common.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/common.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/common.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlIndex.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlIndex.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/xmlIndex.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlIndex.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/xmlIndex.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlIndex.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlSchema.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlSchema.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/xmlSchema.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlSchema.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/xmlSchema.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/xmlSchema.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/reposSearch.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/reposSearch.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/reposSearch.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/reposSearch.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/reposSearch.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/reposSearch.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearch.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearch.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/resourceSearch.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearch.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/resourceSearch.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearch.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearchForm.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearchForm.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/resourceSearchForm.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearchForm.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/resourceSearchForm.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceSearchForm.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceList.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceList.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/resourceList.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceList.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/resourceList.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/resourceList.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/uniqueKeyList.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/uniqueKeyList.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/uniqueKeyList.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/uniqueKeyList.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/uniqueKeyList.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/uniqueKeyList.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/documentIdList.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/documentIdList.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/documentIdList.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/documentIdList.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/documentIdList.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/documentIdList.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/searchTreeView.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/searchTreeView.xsl"
  fi
  cp  "$demohome/src/XMLSearch/xsl/searchTreeView.xsl" "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/searchTreeView.xsl"
  rc=$?
  echo "COPY:"$demohome/src/XMLSearch/xsl/searchTreeView.xsl" --> "$ORDS_ROOT/home/$USER/src/XMLSearch/xsl/searchTreeView.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/WebDemo"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/WebDemo" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebDemo/runtime.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebDemo/runtime.html"
  fi
  cp  "$demohome/src/WebDemo/runtime.html" "$ORDS_ROOT/home/$USER/src/WebDemo/runtime.html"
  rc=$?
  echo "COPY:"$demohome/src/WebDemo/runtime.html" --> "$ORDS_ROOT/home/$USER/src/WebDemo/runtime.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebDemo/loader.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebDemo/loader.html"
  fi
  cp  "$demohome/src/WebDemo/loader.html" "$ORDS_ROOT/home/$USER/src/WebDemo/loader.html"
  rc=$?
  echo "COPY:"$demohome/src/WebDemo/loader.html" --> "$ORDS_ROOT/home/$USER/src/WebDemo/loader.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/WebDemo/xsl"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/WebDemo/xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/WebDemo/xsl/runtime.xsl" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/WebDemo/xsl/runtime.xsl"
  fi
  cp  "$demohome/src/WebDemo/xsl/runtime.xsl" "$ORDS_ROOT/home/$USER/src/WebDemo/xsl/runtime.xsl"
  rc=$?
  echo "COPY:"$demohome/src/WebDemo/xsl/runtime.xsl" --> "$ORDS_ROOT/home/$USER/src/WebDemo/xsl/runtime.xsl" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/xmlViewer"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/xmlViewer" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/xmlViewer/xmlViewer.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/xmlViewer/xmlViewer.html"
  fi
  cp  "$demohome/src/xmlViewer/xmlViewer.html" "$ORDS_ROOT/home/$USER/src/xmlViewer/xmlViewer.html"
  rc=$?
  echo "COPY:"$demohome/src/xmlViewer/xmlViewer.html" --> "$ORDS_ROOT/home/$USER/src/xmlViewer/xmlViewer.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/xmlViewer/js"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/xmlViewer/js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/xmlViewer/js/xmlViewer.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/xmlViewer/js/xmlViewer.js"
  fi
  cp  "$demohome/src/xmlViewer/js/xmlViewer.js" "$ORDS_ROOT/home/$USER/src/xmlViewer/js/xmlViewer.js"
  rc=$?
  echo "COPY:"$demohome/src/xmlViewer/js/xmlViewer.js" --> "$ORDS_ROOT/home/$USER/src/xmlViewer/js/xmlViewer.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/xfilesStatus"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/xfilesStatus" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/xfilesStatus/statusPage.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/xfilesStatus/statusPage.xml"
  fi
  cp  "$demohome/src/xml/statusPage.xml" "$ORDS_ROOT/home/$USER/xfilesStatus/statusPage.xml"
  rc=$?
  echo "COPY:"$demohome/src/xml/statusPage.xml" --> "$ORDS_ROOT/home/$USER/xfilesStatus/statusPage.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/lite/css"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/lite/css" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/css/XFiles.css" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/css/XFiles.css"
  fi
  cp  "$demohome/src/lite/css/XFiles.css" "$ORDS_ROOT/home/$USER/src/lite/css/XFiles.css"
  rc=$?
  echo "COPY:"$demohome/src/lite/css/XFiles.css" --> "$ORDS_ROOT/home/$USER/src/lite/css/XFiles.css" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/lite/css/ErrorDialog.html" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/lite/css/ErrorDialog.html"
  fi
  cp  "$demohome/src/lite/css/ErrorDialog.html" "$ORDS_ROOT/home/$USER/src/lite/css/ErrorDialog.html"
  rc=$?
  echo "COPY:"$demohome/src/lite/css/ErrorDialog.html" --> "$ORDS_ROOT/home/$USER/src/lite/css/ErrorDialog.html" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/acls"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/acls" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/resConfig"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/resConfig" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/acls/xfilesUserAcl.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/acls/xfilesUserAcl.xml"
  fi
  cp  "$demohome/src/acls/xfilesUserAcl.xml" "$ORDS_ROOT/home/$USER/src/acls/xfilesUserAcl.xml"
  rc=$?
  echo "COPY:"$demohome/src/acls/xfilesUserAcl.xml" --> "$ORDS_ROOT/home/$USER/src/acls/xfilesUserAcl.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/acls/denyXFilesUserAcl.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/acls/denyXFilesUserAcl.xml"
  fi
  cp  "$demohome/src/acls/denyXFilesUserAcl.xml" "$ORDS_ROOT/home/$USER/src/acls/denyXFilesUserAcl.xml"
  rc=$?
  echo "COPY:"$demohome/src/acls/denyXFilesUserAcl.xml" --> "$ORDS_ROOT/home/$USER/src/acls/denyXFilesUserAcl.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/resConfig/whoamiResConfig.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/resConfig/whoamiResConfig.xml"
  fi
  cp  "$demohome/src/resConfig/whoamiResConfig.xml" "$ORDS_ROOT/home/$USER/src/resConfig/whoamiResConfig.xml"
  rc=$?
  echo "COPY:"$demohome/src/resConfig/whoamiResConfig.xml" --> "$ORDS_ROOT/home/$USER/src/resConfig/whoamiResConfig.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/resConfig/authStatusResConfig.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/resConfig/authStatusResConfig.xml"
  fi
  cp  "$demohome/src/resConfig/authStatusResConfig.xml" "$ORDS_ROOT/home/$USER/src/resConfig/authStatusResConfig.xml"
  rc=$?
  echo "COPY:"$demohome/src/resConfig/authStatusResConfig.xml" --> "$ORDS_ROOT/home/$USER/src/resConfig/authStatusResConfig.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/resConfig/indexPageResConfig.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/resConfig/indexPageResConfig.xml"
  fi
  cp  "$demohome/src/resConfig/indexPageResConfig.xml" "$ORDS_ROOT/home/$USER/src/resConfig/indexPageResConfig.xml"
  rc=$?
  echo "COPY:"$demohome/src/resConfig/indexPageResConfig.xml" --> "$ORDS_ROOT/home/$USER/src/resConfig/indexPageResConfig.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/resConfig/pageHitsResConfig.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/resConfig/pageHitsResConfig.xml"
  fi
  cp  "$demohome/src/resConfig/pageHitsResConfig.xml" "$ORDS_ROOT/home/$USER/src/resConfig/pageHitsResConfig.xml"
  rc=$?
  echo "COPY:"$demohome/src/resConfig/pageHitsResConfig.xml" --> "$ORDS_ROOT/home/$USER/src/resConfig/pageHitsResConfig.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/resConfig/tableContentResConfig.xml" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/resConfig/tableContentResConfig.xml"
  fi
  cp  "$demohome/src/resConfig/tableContentResConfig.xml" "$ORDS_ROOT/home/$USER/src/resConfig/tableContentResConfig.xml"
  rc=$?
  echo "COPY:"$demohome/src/resConfig/tableContentResConfig.xml" --> "$ORDS_ROOT/home/$USER/src/resConfig/tableContentResConfig.xml" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/src/images"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/src/images" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.png" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.png"
  fi
  cp  "$demohome/src/images/OracleTransparent3d.png" "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.png"
  rc=$?
  echo "COPY:"$demohome/src/images/OracleTransparent3d.png" --> "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.png" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/Oracle3d.png" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/Oracle3d.png"
  fi
  cp  "$demohome/src/images/Oracle3d.png" "$ORDS_ROOT/home/$USER/src/images/Oracle3d.png"
  rc=$?
  echo "COPY:"$demohome/src/images/Oracle3d.png" --> "$ORDS_ROOT/home/$USER/src/images/Oracle3d.png" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.gif" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.gif"
  fi
  cp  "$demohome/src/images/OracleTransparent3d.gif" "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.gif"
  rc=$?
  echo "COPY:"$demohome/src/images/OracleTransparent3d.gif" --> "$ORDS_ROOT/home/$USER/src/images/OracleTransparent3d.gif" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Red.gif" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Red.gif"
  fi
  cp  "$demohome/src/images/Barber_Pole_Red.gif" "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Red.gif"
  rc=$?
  echo "COPY:"$demohome/src/images/Barber_Pole_Red.gif" --> "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Red.gif" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Blue.gif" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Blue.gif"
  fi
  cp  "$demohome/src/images/Barber_Pole_Blue.gif" "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Blue.gif"
  rc=$?
  echo "COPY:"$demohome/src/images/Barber_Pole_Blue.gif" --> "$ORDS_ROOT/home/$USER/src/images/Barber_Pole_Blue.gif" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  if [ -e "$ORDS_ROOT/home/$USER/src/images/AjaxLoading.gif" ] 
  then
    rm "$ORDS_ROOT/home/$USER/src/images/AjaxLoading.gif"
  fi
  cp  "$demohome/src/images/AjaxLoading.gif" "$ORDS_ROOT/home/$USER/src/images/AjaxLoading.gif"
  rc=$?
  echo "COPY:"$demohome/src/images/AjaxLoading.gif" --> "$ORDS_ROOT/home/$USER/src/images/AjaxLoading.gif" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks/Xinha-0.96.1"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Frameworks/Xinha-0.96.1" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks/bootstrap3-dialog-master"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Frameworks/bootstrap3-dialog-master" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks/bootstrap-3.2.0-dist"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Frameworks/bootstrap-3.2.0-dist" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  if [ -e "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1/jquery-3.3.1.min.js" ] 
  then
    rm "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1/jquery-3.3.1.min.js"
  fi
  cp  "$demohome/src/jquery-3.3.1.min.js" "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1/jquery-3.3.1.min.js"
  rc=$?
  echo "COPY:"$demohome/src/jquery-3.3.1.min.js" --> "$ORDS_ROOT/home/$USER/Frameworks/jquery-3.3.1/jquery-3.3.1.min.js" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 5
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks/jssor"
  rc=$?
  echo "MKDIR "$ORDS_ROOT/home/$USER/Frameworks/jssor" : $rc" >> $logfilename
  if [ $rc != "0" ] 
  then
    echo "Operation Failed [$rc]: Installation Aborted." >> $logfilename
    echo "Installation Failed: See $logfilename for details."
    exit 7
  fi
  mkdir -p "$ORDS_ROOT/home/$USER/icons/famfamfam"
  unzip "$ORDS_ROOT/home/$USER/src/famfamfam_silk_icons_v013.zip" -d "$ORDS_ROOT/home/$USER/icons/famfamfam" > "$ORDS_ROOT/home/$USER/icons/famfamfam_silk_icons_v013.log"
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks"
  unzip "$ORDS_ROOT/home/$USER/src/Xinha-0.96.1.zip" -d "$ORDS_ROOT/home/$USER/Frameworks" > "$ORDS_ROOT/home/$USER/Frameworks/Xinha-0.96.1.log"
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks"
  unzip "$ORDS_ROOT/home/$USER/src/bootstrap3-dialog-master.zip" -d "$ORDS_ROOT/home/$USER/Frameworks" > "$ORDS_ROOT/home/$USER/Frameworks/bootstrap3-dialog-master.log"
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks"
  unzip "$ORDS_ROOT/home/$USER/src/bootstrap-3.2.0-dist.zip" -d "$ORDS_ROOT/home/$USER/Frameworks" > "$ORDS_ROOT/home/$USER/Frameworks/bootstrap-3.2.0-dist.log"
  mkdir -p "$ORDS_ROOT/home/$USER/Frameworks"
  unzip "$ORDS_ROOT/home/$USER/src/jssor.zip" -d "$ORDS_ROOT/home/$USER/Frameworks" > "$ORDS_ROOT/home/$USER/Frameworks/jssor.log"
  shellscriptName="$demohome/XFILES_Application.sh"
  echo "Shell Script : $shellscriptName"
  echo "firefox $SERVER/XFILES"> $shellscriptName
  echo "Installation Complete. See $logfilename for details."
}
ORDS_ROOT=${1}
USER=${2}
SERVER=${3}
demohome="$(dirname "$(pwd)")"
logfilename=$demohome/ORDS/install.log
echo "Log File : $logfilename"
if [ -f "$logfilename" ]
then
  rm $logfilename
fi
doInstall 2>&1 | tee -a $logfilename
