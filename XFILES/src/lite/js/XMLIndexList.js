
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */
 
"use strict";

function onPageLoaded() {
}

function processResponse(mgr) {

  try {
    var soapResponse = mgr.getSoapResponse('XMLIndexList.processResponse');
    window.location.reload( true );
  }    
  catch (e) {
    handleException('XMLIndexList.processResponse',e,null);
  }
}
  
function setDefaultValues(owner, tableName, indexName, uploadFolderPath)
{
  if (tableName.value == "") {
    uploadFolderPath.value = "";
    indexName.value = "";
  }
  else {
    if (uploadFolderPath.value == "" ) {
      uploadFolderPath.value = '/home/' + owner.value + '/upload';
    }
    if (indexName.value == "" ) {
      indexName.value = tableName.value + "_IDX";
    }
  }
}

function createXMLIndexedTable(tableName,indexName,uploadFolderPath) {

  try {
    if (isEmptyString(tableName)) {
      showUserErrorMessage('Please enter a name for the new table.');
     return;
    }

    if (isEmptyString(indexName)) {
      showUserErrorMessage('Please enter a name for the index.');
      return;
    }

    if (isEmptyString(uploadFolderPath)) {
      showUserErrorMessage('Please enter a location for the upload folder.');
      return;
    }
 
    var schema      = "XDBPM";
    var packageName = "XDBPM_TABLE_UPLOAD";
    var method =  "CREATEXMLINDEXEDTABLE";
  
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
   	var XHR = mgr.createPostRequest();
  	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processResponse(mgr) } };
    
  	var parameters = new Object;
  	parameters["P_UPLOAD_FOLDER-VARCHAR2-IN"]   = uploadFolderPath
  	parameters["P_TABLE_NAME-VARCHAR2-IN"]   = tableName
  	parameters["P_INDEX_NAME-VARCHAR2-IN"]   = indexName
    mgr.sendSoapRequest(parameters);
  }    
  catch (e) {
    handleException('XMLIndexList.createXMLIndexedTable',e,null);
  }
 
}