
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

function loadXMLIndexXSL() {
  stylesheetURL = '/XFILES/XMLSearch/xsl/xmlIndex.xsl';
}

function invokeGetRootNodeMap(nodeMap, pathTable, pathTableOwner) {

  var schema      = "XFILES";
  var packageName = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLINDEXROOTNODEMAP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);    		
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate) } };

	var parameters = new Object;
	parameters["P_PATH_TABLE_OWNER-VARCHAR2-IN"]  = pathTableOwner
	parameters["P_PATH_TABLE_NAME-VARCHAR2-IN"]   = pathTable
		
  mgr.sendSoapRequest(parameters);

}

function invokeGetChildNodeMap(nodeMap, pathID, pathTable, pathTableOwner) {

  var schema      = "XFILES";
  var packageName = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLINDEXCHILDNODEMAP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate) } };

	var parameters = new Object;
	parameters["P_PATH_TABLE_OWNER-VARCHAR2-IN"]   = pathTableOwner
	parameters["P_PATH_TABLE_NAME-VARCHAR2-IN"]    = pathTable
	parameters["P_PATHID-VARCHAR2-IN"]             = pathID
		
  mgr.sendSoapRequest(parameters);
}

function uploadFiles(targetFolder) {
  window.open('/XFILES/lite/Resource.html?target=' + targetFolder + '&stylesheet=/XFILES/lite/xsl/UploadFiles.xsl','FileUpload','');
}

function findContentModel(nodeMap, ID) {

  if (ID.indexOf('.') > 0) {
    ID = ID.substring(ID.lastIndexOf('.')+1);
  }
  
  invokeGetChildNodeMap(nodeMap, ID, document.getElementById('pathTable').value, document.getElementById('tableOwner').value);
}

function init(target) {

  try {
    initXFilesCommon(target);

    loadXMLIndexXSL();
    loadSearchTreeViewXSL();
    loadDocumentIdListXSL();
    loadUniqueKeyListXSL();
    loadResourceListXSL();

    resourceURL = '/XFILES/XMLSearch/xmlIndex.html'
    resource = getResource(resourceURL,target,stylesheetURL,false);
  }
  catch (e) {
    handleException('xmlIndexSearch.init',e,null);
  }
}

function populateFormFields() {

    document.getElementById("tableOwner").value = getParameter("owner");
    document.getElementById("tableName").value = getParameter("table");
    document.getElementById("columnName").value = "OBJECT_VALUE";
    document.getElementById("indexName").value = getParameter("indexName");
    document.getElementById("pathTable").value = getParameter("pathTable");
    document.getElementById("uploadFolder").value = getParameter("uploadFolder");
  
    document.getElementById("xmlIndexOptions").style.display = "inline-block"; 

    uploadOption = document.getElementById("btnUploadFiles")
    if (document.getElementById("uploadFolder").value != "") {
      uploadOption.style.display = "inline-block";
    }
    else {
      uploadOption.style.display = "none";
    }

    loadNodeMap();
}

function loadNodeMap() {
	
    documentNodeMap = new NodeMap( 'documentNodeMap' , loadXMLDocument('/XFILES/XMLSearch/xsl/searchTreeView.xsl'), 'treeView' );
    invokeGetRootNodeMap(documentNodeMap, document.getElementById('pathTable').value, document.getElementById('tableOwner').value);  

}

function doViewXSL() {
	
	closePopupDialog();
  showSourceCode(documentNodeMap.getStylesheet());

}

function doViewXML() {
	
	closePopupDialog();
	showSourceCode(documentNodeMap.getNodeMap());
	
}

function onPageLoaded() {
  populateFormFields();
  viewXSL = doViewXSL;
  viewXML = doViewXML;
}


function getUploadFolderPath() {
	
	return document.getElementById("uploadFolder").value;

}

function openUploadFilesDialog(evt) {

  var dialog = document.getElementById("uploadFilesDialog");
  // var uploadFrame =  document.getElementById("uploadFilesFrame");
  // uploadFrame.contentDocument.getElementById("targetFolder").value = document.getElementById("uploadFolder").value;
  openModalDialog(dialog)

}

function doUploadComplete(reloadUploadFrame,status,errorCode,errorMessage,resourcePath) {

	reloadUploadFrame();
	if (status == 201) {
		// Upload succeeded Reload current page.
		closePopupDialog();
    refreshPage();
  }
  else {
  	var error = new xfilesException("XFILES.XFILES_DOCUMENT_UPLOAD.UPLOAD",12,resourcePath);
    error.setDescription(errorMessage);
    error.setNumber(errorCode);
    handleException("uploadFiles.submit",error,resourcePath);
  }
}

function refreshPage() {
	 loadNodeMap();
}