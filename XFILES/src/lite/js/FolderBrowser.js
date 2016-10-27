
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

var uploadDialogURL

var outstandingRequestCount = 0;
var currentOperation;
var currentResourceList;
var targetFolderTree

function onPageLoaded() {	
	reloadForm = refreshCurrentFolder;
  document.getElementById("closeForm").style.display="none";
  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })
}

function reportStatus(response, namespaces, operation, status, targetURL) {

  try {
  }
  catch (e) {
    handleException("FolderBrowser.reportStatus",e,null);
  }
}

function updateFolderContents(mgr, outputWindow, module) {

  // Used when the function called returns updated folder contents...

  var soapResponse = mgr.getSoapResponse(module);
  
  var namespaces = xfilesNamespaces;
  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
  var newFolder  = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_UPDATED_RESOURCE/res:Resource",namespaces).item(0);
  var resourceXML    = importResource(newFolder);
  displayFolder(resourceXML,outputWindow,stylesheetURL);
}

function reportComplete(mgr, outputWindow, operation, targetFolder) {

  // Use when the current folder should be reloaded when the operation is complete.

  var module     = "FolderBrowser.reportComplete[" + operation + "]";

  try {
    var soapResponse = mgr.getSoapResponse(module);
 	  if (targetFolder == null) {
      refreshCurrentFolder();
    }
    else {
      doFolderJump(targetFolder)
    }
 	  showInfoMessage(operation + " operation complete.");
  }
  catch (e) {
    handleException(module,e,null);
  }
}

function processCreateFolder(mgr, outputWindow) {

  var module     = "FolderBrowser.processCreateFolder";

  try {
    updateFolderContents(mgr, outputWindow, module);
  }    
  catch (e) {
    handleException(module,e,null);
  }

}

function createFolder(newFolderPath, newFolderDescription, outputWindow) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method      =  "CREATENEWFOLDER";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR = mgr.createPostRequest();
	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processCreateFolder(mgr, outputWindow) } };

	var parameters = new Object;
	parameters["P_FOLDER_PATH-VARCHAR2-IN"]   = newFolderPath;
	parameters["P_DESCRIPTION-VARCHAR2-IN"]   = newFolderDescription;
	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;

  mgr.sendSoapRequest(parameters);

}

function createNewFolder(folderNameControl, folderDescriptionControl) {

	var folderName = document.getElementById(folderNameControl).value;
	var folderDescription = document.getElementById(folderDescriptionControl).value;

  if (isEmptyString(folderName)) {
    showUserErrorMessage("Please enter name");
    document.getElementById("newFolderName").focus();
    return
  }
  
  if (resource.selectNodes("/res:Resource/xfiles:DirectoryContents/res:Resource[res:DisplayName=\"" + folderName + "\"]",xfilesNamespaces).length > 0) {
    showUserErrorMessage("Duplicate name");
    document.getElementById("newFolderName").focus();
    return;
  }

  closeModalDialog('newFolderDialog');
  createFolder(resourceURL + "/" + folderName, folderDescription, document.getElementById("pageContent"));
  
}

function openNewFolderDialog(evt) {

  document.getElementById("newFolderName").value = "";
  document.getElementById("newFolderDescription").value = "";
  openModalDialog('newFolderDialog');

}

function processCreateWikiPage(mgr, outputWindow) {

  var module     = "FolderBrowser.processCreateWikiPage";

  try {
    updateFolderContents(mgr, outputWindow, module);
  }    
  catch (e) {
    handleException(module,e,null);
  }

}

function createWikiPage(newWikiPagePath, newWikiPageDescription, outputWindow) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method      =  "CREATENEWWIKIPAGE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);	
	var XHR = mgr.createPostRequest();
	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processCreateFolder(mgr, outputWindow) } };

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = newWikiPagePath;
	parameters["P_DESCRIPTION-VARCHAR2-IN"]   = newWikiPageDescription;
	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
		
  mgr.sendSoapRequest(parameters);
 
}

function createNewWikiPage(wikiPageName, wikiPageDescription) {

  if (isEmptyString(wikiPageName)) {
    showUserErrorMessage("Please enter name");
    document.getElementById("newWikiPageName").focus();
    return
  }
  
  if (resource.selectNodes("/res:Resource/xfiles:DirectoryContents/res:Resource[res:DisplayName=\"" + wikiPageName + "\"]",xfilesNamespaces).length > 0) {
    showUserErrorMessage("Duplicate name");
    document.getElementById("newWikiPageName").focus();
    return;
  }
  
  closeModalDialog('newWikiPageDialog');
  createWikiPage(resourceURL + "/" + wikiPageName, wikiPageDescription, document.getElementById("pageContent"));
  
}

function openNewWikiPageDialog(evt) {

  document.getElementById("newWikiPageName").value = "";
  document.getElementById("newWikiPageDescription").value = "";
  
	openModalDialog('newWikiPageDialog');
}

function processCreateZipFile(response, outputWindow) {

  var module     = "FolderBrowser.processCreateZipFile";

  try {
    updateFolderContents(mgr, outputWindow,module);
  }    
  catch (e) {
    handleException(module,e,null);
  }

}

function openDeleteDialog(evt, resourceList) {

  // Open the Delete Dialog. Delete Processing will be performed by deleteResources()

  document.getElementById('deepDelete').checked = false;
	document.getElementById('forceDelete').checked = false;
  openModalDialog("deleteDialog");

}

function openFolderPicker(evt, action, resourceList, operation) {

  // Get the List of Writeable Folders

  document.getElementById("doTargetFolder").style.display="BLOCK";
  document.getElementById("doUnzipArchive").style.display="NONE";

  if (action == "COPY") {
  	document.getElementById("folderPickerDialogTitle").innerHTML="Copy : Select Target Folder"
    document.getElementById("recursiveOperationDialog").style.display="BLOCK";
    document.getElementById("unzipDuplicateAction").style.display="NONE";
  }
  
  if (action == "MOVE") {
  	document.getElementById("folderPickerDialogTitle").innerHTML="Move : Select Target Folder"
    document.getElementById("recursiveOperationDialog").style.display="NONE";
    document.getElementById("unzipDuplicateAction").style.display="NONE";
  }

  if (action == "LINK") {
  	document.getElementById("folderPickerDialogTitle").innerHTML="Link : Select Target Folder"
    document.getElementById("recursiveOperationDialog").style.display="NONE";
    document.getElementById("unzipDuplicateAction").style.display="NONE";
  }

  if (action == "UNZIP") {
	  document.getElementById("doTargetFolder").style.display="NONE";
	  document.getElementById("doUnzipArchive").style.display="BLOCK";
  	document.getElementById("folderPickerDialogTitle").innerHTML="Unzip : Select Target Folder";
    document.getElementById("recursiveOperationDialog").style.display="NONE";
    document.getElementById("unzipDuplicateAction").style.display="BLOCK";
  }

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method      =  "GETTARGETFOLDERTREE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
 	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange = function() { 
  	                         if ( XHR.readyState == 4 ) {
  	                       	   currentOperation = operation;
														   currentResourceList = resourceList;
  	                       	   var loading =  document.getElementById("treeLoading");
  													   var targetTree = document.getElementById("treeControl");
  	                       	   processFolderTreeList(mgr, xfilesNamespaces, loading, targetTree) 
  	                         } 
  	                       };
  
	var parameters = new Object;
  mgr.sendSoapRequest(parameters);

  document.getElementById("treeControl").style.display="none";
  openModalDialog('folderPickerDialog');
  document.getElementById("treeLoading").style.display="block";

}

function openPrincipleDialog(evt,resourceList) {

  // Get the List of XSLs and open the XSL Dialog.

  var sqlQuery = 
  "select USERNAME  " + "\n" +
  "  from ALL_USERS " + "\n" +
  " order by USERNAME"; 

  var userSelector = document.getElementById("principleList");

  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { loadOptionList(mgr, userSelector, userSelector, httpUsername)}};

  mgr.executeSQL(sqlQuery);  
  
  currentResourceList = resourceList;
  openModalDialog('setPrincipleDialog');

}

function openACLDialog(evt,resourceList) {

  // Get the List of ACLs and open the ACL Dialog.

  var sqlQuery = 
  "select PATH" + "\n" +
  "  from PATH_VIEW, ALL_XML_SCHEMAS " + "\n" +
  " where extractValue(res,'/Resource/SchOID') = SCHEMA_ID  " + "\n" +
  "   and OWNER = 'XDB'  " + "\n" +
  "   and SCHEMA_URL = 'http://xmlns.oracle.com/xdb/acl.xsd' " + "\n" +
  " order by PATH";
  
  var aclSelector = document.getElementById("aclList");

  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { loadOptionList(mgr, aclSelector, aclSelector, "/sys/acls/bootstrap_acl.xml")}};

  mgr.executeSQL(sqlQuery);  
  
  currentResourceList = resourceList;
  openModalDialog("setACLDialog");
}

function openViewerDialog(evt,resourceList) {

  // Get the List of XSLs and open the XSL Dialog.

  var sqlQuery = 
  "select PATH " + "\n" +
  "  from PATH_VIEW " + "\n" +
  " where XMLExists" + "\n" +
  "       (" + "\n" +
  "         'declare default element namespace \"http://xmlns.oracle.com/xdb/XDBResource.xsd\"; (: :)" + "\n" +
  "          $R/Resource[fn:ends-with(DisplayName,\".xsl\")]'" + "\n" +
  "          passing RES as \"R\"" + "\n" +
  "       )";

  var xslList = document.getElementById("xslList");

  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { loadOptionList(mgr, xslList, xslList)}};

  mgr.executeSQL(sqlQuery);  
  
  currentResourceList = resourceList;
  openModalDialog("setViewerDialog");

}

function openCheckInDialog(evt, resourceList) {

  // Open the Check-in Dialog. Delete Processing will be performed by checkInResources()
  currentResourceList = resourceList;
  openModalDialog("checkInDialog");
}

function createZipFile(zipFileName, zipFileDescription, resourceListXML, outputWindow) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method      =  "CREATEZIPFILE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);	
	var XHR = mgr.createPostRequest();
	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processCreateFolder(mgr, outputWindow) } };

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = zipFileName;
	parameters["P_DESCRIPTION-VARCHAR2-IN"]   = zipFileDescription;
	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;

	var xparameters = new Object;
	xparameters["P_RESOURCE_LIST-XMLTYPE-IN"] = resourceListXML
		
  mgr.sendSoapRequest(parameters,xparameters); 

}

function createNewZipFile(zipFileName, zipFileDescription) {

  if (isEmptyString(zipFileName)) {
    showUserErrorMessage("Please enter name");
    document.getElementById("newZipFileName").focus();
    return
  }
  
  if (resource.selectNodes("/res:Resource/xfiles:DirectoryContents/res:Resource[res:DisplayName=\"" + zipFileName + "\"]",xfilesNamespaces).length > 0) {
    showErrorMessage("Duplicate name");
    document.getElementById("newZipFileName").focus();
    return;
  }
  
  closeModalDialog('newZipFileDialog');
  createZipFile(resourceURL + "/" + zipFileName, zipFileName, currentResourceList, document.getElementById("pageContent"));
  
}

function openNewZipFileDialog(evt,resourceList) {

  document.getElementById("newZipFileName").value = "";
  document.getElementById("newZipFileDescription").value = "";

  currentResourceList = resourceList;
  openModalDialog('newZipFileDialog');

}

function setRSSFeed(resource,enable,actionName,deep,itemsChangedIn) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method      =  "SETRSSFEED";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), actionName, resourceURL) } };

	var parameters = new Object;
	parameters["P_FOLDER_PATH-VARCHAR2-IN"]      = resource
	parameters["P_ITEMS_CHANGED_IN-VARCHAR2-IN"] = itemsChangedIn
	parameters["P_ENABLE-BOOLEAN-IN"]            = enable 
	parameters["P_DEEP-BOOLEAN-IN"]              = deep

  mgr.sendSoapRequest(parameters);
 
}

function enableRSS(folderURL) {
  
  setRSSFeed(folderURL,booleanToNumber(true),"Enable RSS Feed",booleanToNumber(false),null);

}

function disableRSS(folderURL) {

  setRSSFeed(folderURL,booleanToNumber(false),"Disable RSS Feed",booleanToNumber(false),null);

}

function doListOperation(resourceListXML, parameters, module, actionName, targetFolder) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";

	var mgr = soapManager.getRequestManager(schema,packageName,module);
 	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) {reportComplete(mgr, document.getElementById("pageContent"), actionName, targetFolder)}};

  var xparameters = new Object;
  xparameters["P_RESOURCE_LIST-XMLTYPE-IN"]   = resourceListXML;
	
	mgr.sendSoapRequest(parameters, xparameters);
    
}

function copyResourceList(resourceListXML, targetFolder, deep, duplicatePolicy) {

  var module      = "COPYRESOURCELIST";
  var actionName = "Copy"

  try {
  	var parameters = new Object;
  	parameters["P_TARGET_FOLDER-VARCHAR2-IN"]     = targetFolder;
  	parameters["P_DEEP-BOOLEAN-IN"]               = deep;
  	parameters["P_DUPLICATE_POLICY-VARCHAR2-IN"]  = duplicatePolicy;
  	doListOperation(resourceListXML, parameters, module, actionName, targetFolder);
  }
  catch (e) {
    handleException("FolderBrowser.copyResourceList",e,null);
  }

}

function moveResourceList(resourceListXML, targetFolder, deep) {

  var module      = "MOVERESOURCELIST";
  var actionName = "Move";

  try {
  	var parameters = new Object;
	  parameters["P_TARGET_FOLDER-VARCHAR2-IN"]   = targetFolder;
	  doListOperation(resourceListXML, parameters, module, actionName, targetFolder);
  }
  catch (e) {
    handleException("FolderBrowser.moveResourceList",e,null);
  }
  
}

function linkResourceList(resourceListXML, targetFolder, linkType) {

  var module      = "LINKRESOURCELIST";
  var actionName = "Link";

	try {
  	var parameters = new Object;
  	parameters["P_TARGET_FOLDER-VARCHAR2-IN"]   = targetFolder;
	  parameters["P_LINK_TYPE-NUMBER-IN"]         = linkType
	  doListOperation(resourceListXML, parameters, module, actionName, targetFolder);
  }
  catch (e) {
    handleException("FolderBrowser.linkResourceList",e,null);
  }
  
}

function deleteResourceList(resourceListXML, deep, force) {

  var module      = "DELETERESOURCELIST";
  var actionName = "Delete"

  try {
	  var parameters = new Object;
  	parameters["P_FORCE-BOOLEAN-IN"]            = force; 
	  parameters["P_DEEP-BOOLEAN-IN"]             = deep;
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.deleteResourceList",e,null);
  }
   
}  

function lockResourceList(resourceListXML, deepOption) {

  var module      = "LOCKRESOURCELIST";
  var actionName = "Lock"

  try {
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.lockResourceList",e,null);
  }
   
}  

function unlockResourceList(resourceListXML, deepOption) {

  var module      = "UNLOCKRESOURCELIST";
  var actionName = "Unlock"

  try {
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption;
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.unlockResourceList",e,null);
  }
   
}  

function publishResourceList(resourceListXML, deepOption, publicOption) {

  var module      = "PUBLISHRESOURCELIST";
  var actionName = "Publish Resource"

  try {
  	var targetFolder = "/home/" + httpUsername + "/publishedContent";
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption
	  parameters["P_MAKE_PUBLIC-BOOLEAN-IN"]      = publicOption
  	doListOperation(resourceListXML, parameters, module, actionName, targetFolder );
  }
  catch (e) {
    handleException("FolderBrowser.publishResourceList",e,null);
  }
   
}  

function setAclList(resourceListXML, newACL, deep) {

  var module      = "SETACLLIST";
  var actionName = "Set ACL";

  try {
  	var parameters = new Object;
	  parameters["P_ACL_PATH-VARCHAR2-IN"]        = newACL
	  parameters["P_DEEP-BOOLEAN-IN"]             = deep;
	  doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.setAclList",e,null);
  }

}

function setViewerList(resourceListXML, newViewer, renderingMethod) {

  var module      = "SETCUSTOMVIEWERLIST";
  var actionName = "Set Viewer";

  try {
  	var parameters = new Object;
	  parameters["P_VIEWER_PATH-VARCHAR2-IN"] = newViewer
	  parameters["P_METHOD-VARCHAR2-IN"]      = renderingMethod
	  doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.setViewerList",e,null);
  }

}

function changeOwnerList(resourceListXML, newOwner, deep) {

  var module      = "CHANGEOWNERLIST";
  var actionName = "Change Owner";

  try {
  	var parameters = new Object;
	  parameters["P_NEW_OWNER-VARCHAR2-IN"]       = newOwner;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deep;
	  doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.changeOwnerList",e,null);
  }
  
}

function versionResourceList(resourceListXML, deepOption) {

  var module      = "MAKEVERSIONEDLIST";
  var actionName = "Make Versioned"

  try {
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption;
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.versionlockResourceList",e,null);
  }
   
}  

function checkOutResourceList(resourceListXML, deepOption) {

  var module      = "CHECKOUTLIST";
  var actionName = "Check Out"

  try {
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption;
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.checkOutResourceList",e,null);
  }
   
}  
function checkInResourceList(resourceListXML, comment, deepOption) {

  var module      = "CHECKINLIST";
  var actionName = "Check In"

  try {
	  var parameters = new Object;
	  parameters["P_DEEP-BOOLEAN-IN"]             = deepOption;
    parameters["P_COMMENT-VARCHAR2-IN"]         = comment
	  doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.checkInResourceList",e,null);
  }
   
}  

function unzipResourceList(resourceListXML, targetFolder, duplicateAction) {

  var module      = "UNZIPLIST";
  var actionName = "Unzip"

  try {
	  var parameters = new Object;
	  parameters["P_FOLDER_PATH-VARCHAR2-IN"]       = targetFolder
	  parameters["P_DUPLICATE_POLICY-VARCHAR2-IN"]  = duplicateAction
	  doListOperation(resourceListXML, parameters, module, actionName, targetFolder);
  }
  catch (e) {
    handleException("FolderBrowser.unzipResourceList",e,null);
  }
   
}  

function addHitCounter(resourceListXML, deepOption) {

  var module      = "ADDPAGEHITCOUNTERLIST";
  var actionName = "Page Counter"

  try {
	  var parameters = new Object;
  	doListOperation(resourceListXML, parameters, module, actionName, null);
  }
  catch (e) {
    handleException("FolderBrowser.addHitCounter",e,null);
  }
   
}

function deleteResources() {

  try {
  	var callback = function(result) {
		  closeModalDialog('deleteDialog');
  		if (result) {
  			deleteResourceList(currentResourceList, booleanToNumber(document.getElementById('deepDelete').checked), booleanToNumber(document.getElementById('forceDelete').checked));
      }
    }
    BootstrapDialog.confirm("Delete selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.deleteResources",e,null);
  }   

}

function updateTargetFolder() {

  var targetFolder = targetFolderTree.getOpenFolder()
  if (!targetFolder) {
    showUserErrorMessage("Please select target folder");
    return;
  }
  var radioDuplicate = document.getElementsByName('onDuplicateAction');

  var duplicateAction

  for (var i=0;i<radioDuplicate.length;i++) {
    if (radioDuplicate[i].checked) {
      duplicateAction = radioDuplicate[i].value 
      break;
    }
  }

  try {
  	var callback = function(result) {
		  closeModalDialog('folderPickerDialog');
  		if (result) {
			  var deep = booleanToNumber(document.getElementById('deepFolder').checked);
  			currentOperation(currentResourceList,targetFolder,deep,duplicateAction);
      }
    }
    BootstrapDialog.confirm("Apply to selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.updateTargetFolder",e,null);
  }   

}

function doDeepOperation() {

	var deepCheckbox = document.getElementById('deepOperation');
	var deepOption = booleanToNumber(deepOption.checked);

  try {
  	var callback = function(result) {
		  closeModalDialog('deepOperationDialog');
  		if (result) {
  			currentOperation(currentResourceList,deepOption);
      }
    }
    BootstrapDialog.confirm("Apply to selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.doPublishOperation",e,null);
  }   
}

function doPublishOperation() {

  try {
  	var callback = function(result) {
			closeModalDialog('publishDialog');
  		if (result) {
				var deep = booleanToNumber(document.getElementById('deepPublish').checked);
  			var makePublic = booleanToNumber(document.getElementById('publicPublish').checked);
  			publishResourceList(currentResourceList,deep,makePublic);
      }
    }
    BootstrapDialog.confirm("Publish selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.doPublishOperation",e,null);
  }   

}

function updatePrinciple() {

  try {
  	var callback = function(result) {
		  closeModalDialog('setPrincipleDialog');
  		if (result) {
        var deep = booleanToNumber(document.getElementById('deepChown').checked);
        var newOwner = document.getElementById('principleList').value;
        changeOwnerList(currentResourceList, newOwner, deep);
      }
    }
    BootstrapDialog.confirm("Change owner of selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.updatePrinciple",e,null);
  }

}

function updateACL() {

  try {
  	var callback = function(result) {
   		closeModalDialog("setACLDialog");
  		if (result) {
  			var newACL = document.getElementById('aclList').value;
    	  var deep = booleanToNumber(document.getElementById('deepACL').checked);
  	    setAclList(currentResourceList, newACL, deep);
  	  }
  	}
    BootstrapDialog.confirm("Apply ACL to selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.updateACL",e,null);
  }

}

function updateViewer() {

  try {
  	var callback = function(result){
      closeModalDialog("setViewerDialog");
  		if (result) {
  			var viewerArguments = "";
        var newViewer = document.getElementById('xslList').value;
    	  var metadata = booleanToNumber(document.getElementById('viewerMetadata').checked);
    	  if (metadata) {
    	  	var renderingMethod = 'getFolderWithMetadata'
    	  }
  	    setViewerList(currentResourceList, newViewer, renderingMethod);
  	  }
		}  		
    BootstrapDialog.confirm("Apply Viewer to selected documents ?",callback);
  }
  catch (e) {
    handleException("FolderBrowser.updateViewer",e,null);
  }

}

function checkInResources() {

  try {
  	var callback = function(result) {
      closeModalDialog("checkInDialog");
      if (result) {
        var comment = document.getElementById('checkInComment').value;
        var deep = booleanToNumber(document.getElementById('deepCheckIn').checked);
        checkInResourceList(currentResourceList, comment, deep)
      }
		}
    BootstrapDialog.confirm("Check In selected documents ?",callback)
  }
  catch (e) {
    handleException("FolderBrowser.checkInResources",e,null);
  }
  
}

function doUnzipOperations(radioDuplicate) {

  var targetFolder = targetFolderTree.getOpenFolder()
  if (!targetFolder) {
    showUserErrorMessage("Please select target folder");
    return;
  }
  
// Mode is an array representing the state of Radio button grouping. Need to iterate over
// the array to detemine if the mode should be RAISE, OVERWRITE, VERSION, SKIP

  var duplicateAction
  for (var i=0;i<radioDuplicate.length;i++) {
    if (radioDuplicate[i].checked) {
      duplicateAction = radioDuplicate[i].value 
      break;
    }
  }

  closeModalDialog("folderPickerDialog");
  var targetFolder = targetFolderTree.getOpenFolder()
  unzipResourceList(currentResourceList,targetFolder,duplicateAction);

}
		
function doLocalSort(sortKey,sortOrder) {

  try {
    var sessionState
    sessionState = new xmlElement(resource.selectNodes("/res:Resource/xfiles:xfilesParameters",xfilesNamespaces).item(0));
    sortKeyValue = sessionState.selectNodes("xfiles:sortKey",xfilesNamespaces).item(0)
    sortKeyValue.firstChild.nodeValue = sortKey
    sortOrderValue = sessionState.selectNodes("xfiles:sortOrder",xfilesNamespaces).item(0);
    sortOrderValue.firstChild.nodeValue = sortOrder;
    if (cacheResult == 1) {
      if (isAuthenticatedUser()) {
        var transformOutput = htmlFromDocument(resource,folderXSL.sourceURL);
        appendHTML(transformOutput,document.getElementById("pageContent"),false);
      }
      else {
    	  showUserErrorMessage('[CHROME] : Sorting not enabled for unauthenticated sessions.');
      }
    }
    else {	
      xmlToHTML(document.getElementById("pageContent"),resource,folderXSL);
    }
  }
  catch (e) {
  	handleException("FolderBrowser.doLocalSort",e,null);
  }
}
  

function openDeepOperationDialog(evt,action,resourceList,operation) {

  titleBar = document.getElementById("deepOperationDialogTitle");
  
  if (action == "VERSION") {
  	titleBar.innerHTML = "Make Versioned options";
  }

  if (action == "CHECKOUT") {
  	titleBar.innerHTML = "Check-Out options";
  }

  if (action == "LOCK") {
  	titleBar.innerHTML = "Lock Options";
  }

  if (action == "UNLOCK") {
  	titleBar.innerHTML = "Unlock Options";
  }

  currentOperation = operation;
  currentResourceList = resourceList;
  openModalDialog("deepOperationDialog");  

}

function openPublishDialog(evt,action,resourceList,operation) {

  currentOperation = operation;
  currentResourceList = resourceList;
  openModalDialog("publishDialog");  

}


function validateSelection(action, index) {
  var displayName = document.getElementById("DisplayName." + index).value;
  var resid = document.getElementById("RESID." + index).value;
  if (action == "UNZIP") {
    var contentType = extractText(resource.selectNodes("/res:Resource/xfiles:DirectoryContents/res:Resource[xfiles:ResourceStatus[xfiles:Resid=\"" + resid + "\"]]/res:ContentType",xfilesNamespaces).item(0));
    if (contentType != "application/x-zip-compressed") {
      showErrorMessage("Cannot unzip " + displayName + " - Unsupported content type : " + contentType) ; 
      return false;
    }
    return true;
  }


  if (action == "LOCK") {
    if (document.getElementById("isLocked." + index).value == "true") {
      showErrorMessage("Cannot lock " + displayName + " - Resource is already locked"); 
      return false;
    }
    return true;
  }

  if (action == "UNLOCK") {
    if (document.getElementById("isLocked." + index).value != "true") {
      showErrorMessage("Cannot unlock " + displayName + " - Resource is not locked"); 
      return false;
    }
    return true;
  }

  if (action == "VERSION") {
    if (document.getElementById("isVersioned." + index).value == "true") {
      showErrorMessage("Cannot version " + displayName + " - Resource is already versioned"); 
      return false;
    }
    return true;
  }
  
  if (action == "CHECKOUT") {
    if (document.getElementById("isContainer." + index).value != "true") {
      if (document.getElementById("isVersioned." + index).value != "true") {
        showErrorMessage("Cannot Check Out "  + displayName + " - Resource is not versioned.");
        return false;
      }
      if (document.getElementById("isCheckedOut." + index).value == "true") {
        showErrorMessage("Cannot Check Out "  + displayName  + " - Resource is checked out.");
        return false;
      }
    }
    return true;    
  }
  
  if (action == "CHECKIN") {
    if (document.getElementById("isContainer." + index).value != "true") {
      if (document.getElementById("isVersioned." + index).value != "true") {
        showErrorMessage("Cannot Check In " + displayName + " - Resource is not versioned.");
        return false;
      }
      if (document.getElementById("isCheckedOut." + index).value != "true") {
        showErrorMessage("Cannot Check In " + displayName + " - Resource is not checked out.");
        return false;
      }
    }
    return true;
  }
  return true;
}

function isAnyResouceSelected() {
	
	var currentItem = null;
	
  for (var i = 1;  currentItem = document.getElementById("itemSelected." + i); i++) {
    if (currentItem.checked) {
    	  return true;
    }
  }
  
  return false;
    
}

function openActionMenu(evt,control) {
	
	if (isAnyResouceSelected()) {

  	var dialog = document.getElementById("resourceActionMenu");
    openPopupDialog(evt, dialog)
	}
	else {
    showErrorMessage("Choose at least one resource before selecting action.");
  }

}

function doAction(evt,action) {
	closePopupDialog();
	processAction(evt,action)
}

function processAction(evt,action) {

  currentResourceList = null;
  var selectedList = new Array();

  var folderSelected = false;

	var currentItem = null;
	  
  for (var i = 1;  currentItem = document.getElementById("itemSelected." + i); i++) {
    if (currentItem.checked) {
      var itemValid = validateSelection(action,i);
      if (itemValid) {
        if (document.getElementById("isContainer." + i).value == "true") {
          folderSelected = true;
        }
        selectedList.push(document.getElementById("currentPath." + i).value);
      }
      else {
        currentItem.checked=false; 
      }
    }
  }

  if (selectedList.length == 0) {
    showErrorMessage("Selected action not valid for any of the chosen Resources.");
    return;
  }

  currentResourceList = getResourceListXML(selectedList);
  
  if (action == "COPY") {
    openFolderPicker(evt,action,currentResourceList,copyResourceList);
    return;
  }
  
  if (action == "MOVE") {
    openFolderPicker(evt,action,currentResourceList,moveResourceList);
    return;
  }

  if (action == "LINK") {
    openFolderPicker(evt,action,currentResourceList,linkResourceList);
    return;
  }

  if (action == "DELETE") {
    openDeleteDialog(evt, currentResourceList);
    return;
  }

  if (action == "LOCK") {
    if (folderSelected) {
       openDeepOperationDialog(evt,action,currentResourceList,lockResourceList)
    }
    else {
    	var callback = function(result) {
    		if (result) {
    			lockResourceList(currentResourceList,false);
    		}
    	}
      BootstrapDialog.confirm("Lock selected documents ?",callback)
    }
    return;
  }
  
  if (action == "UNLOCK") {
    if (folderSelected) {
       openDeepOperationDialog(evt,action,currentResourceList,unlockResourceList)
    }
    else {
    	var callback = function(result) {
    		if (result) {
	        unlockResourceList(currentResourceList,false);
    		}
    	}
      BootstrapDialog.confirm("Unlock selected documents ?",callback)
    }
    return;
  }

  if (action == "PUBLISH") {
    openPublishDialog(evt,action,currentResourceList,publishResourceList)
    return;
  }
     
  if (action == "SETACL") {
    openACLDialog(evt, currentResourceList);
    return;
  }

  if (action == "CHOWN") {
    openPrincipleDialog(evt, currentResourceList);
    return;
  }
  
  if (action == "VIEWER") {
    openViewerDialog(evt, currentResourceList);
    return;
  }

  if (action == "VERSION") {
    if (folderSelected) {
       openDeepOperationDialog(evt,action,currentResourceList,versionResourceList)
    }
    else {
    	var callback = function(result) {
    		if (result) {
          versionResourceList(currentResourceList,false);
    		}
    	}
      BootstrapDialog.confirm("Initiate versioning on selected documents ?",callback)
    }
    return;
  }

  if (action == "CHECKOUT") {
    if (folderSelected) {
       openDeepOperationDialog(evt,action,currentResourceList,checkOutResourceList)
    }
    else {
    	var callback = function(result) {
    		if (result) {
	        checkOutResourceList(currentResourceList,false);
    		}
    	}
      BootstrapDialog.confirm("Check out selected documents ?",callback)
    }
    return;
  }
  
  if (action == "CHECKIN") {
    openCheckInDialog(evt, currentResourceList);
    return;
  }
  
  if (action == "ZIP") {
    openNewZipFileDialog(evt, currentResourceList);
    return;
  }

  if (action == "UNZIP") {
    openFolderPicker(evt,action,currentResourceList,unzipResourceList);
    return;
  }
  
  if (action = "COUNT") {
    if (folderSelected) {
      showErrorMessage("Cannot place hit counter on Folder.");     
    }
    else {
      addHitCounter(currentResourceList,false);
    }
    return;
  }
  	

  showErrorMessage(action + " Not yet Implemented");

}

function toggleSelect(currentState) {
	if (currentState) {
		select_all()
	}
	else {
		deselect_all()
  }
}

function select_all() {

	var currentItem = null;
	
	for (var i = 1;  currentItem = document.getElementById("itemSelected." + i); i++) {
     document.getElementById("itemSelected." + i).checked=true;
  }
}

function deselect_all() {
   for (var i = 1;  currentItem = document.getElementById("itemSelected." + i); i++) {
    document.getElementById("itemSelected." + i).checked=false;
  }
}

function getResourceListXML(resourceList) {
	
  var resourceListXML = new xmlDocument();
  var resourceListRoot = resourceListXML.createElement("ResourceList");
  resourceListXML.appendChild(resourceListRoot);
  for (var i=0; i <resourceList.length; i++) {
    var resourceEntry = resourceListXML.createElement("Resource");
    var textNode = resourceListXML.createTextNode(resourceList[i]);
    resourceEntry.appendChild(textNode);
    resourceListRoot.appendChild(resourceEntry);
  }    

  return resourceListXML;
}

function getUploadFolderPath() {

  return resourceURL

}

function openUploadFilesDialog(evt) {

  // var uploadFrame = document.getElementById('uploadFilesFrame');
  // var targetFolder = uploadFrame.contentWindow.document.getElementById('targetFolder');
  // targetFolder.value = resourceURL;
  // showInfoMessage('Target Folder = ' + uploadFrame.contentWindow.document.getElementById('targetFolder').value);

  openModalDialog('uploadFilesDialog');
}


function closeUploadFilesDialog() {
  closeModalDialog("uploadFilesDialog")
}


function doUploadComplete(status,errorCode,errorMessage,resourcePath) {

  closeModalDialog("uploadFilesDialog")
  var uploadFrame = document.getElementById('uploadFilesFrame');
  uploadFrame.src = '/XFILES/lite/Resource.html?target=/XFILES/lite/xsl/UploadFilesStatus.html&stylesheet=/XFILES/lite/xsl/UploadFiles.xsl';
	// reloadUploadFrame();
	if (status == 201) {
		// Upload succeeded Reload current page.
    refreshCurrentFolder();
  }
  else {
  	var error = new xfilesException("XFILES.XFILES_DOCUMENT_UPLOAD.UPLOAD",12,resourcePath);
    error.setDescription(errorMessage);
    error.setNumber(errorCode);
    handleException("uploadFiles.submit",error,resourcePath);
  }
}

function repositionPopupWindow(dialogName,treeName) {
	
	// popupWindow = document.getElementById(dialogName);
	// treeControl = document.getElementById(treeName);
	// popupWindow.firstChild.firstChild.style.left = ((treeControl.offsetWidth + 10) * -1) + "px";

}

function refreshCurrentFolder() {
	showFolder(resourceURL,document.getElementById('pageContent'),stylesheetURL,false);
} 

function processCreateIndexPage(mgr, outputWindow) {

  var module     = "FolderBrowser.processCreateIndexPage";

  try {
    updateFolderContents(mgr, outputWindow, module);
  }    
  catch (e) {
    handleException(module,e,null);
  }

}

function createIndexPage(event) {

  var module     = "FolderBrowser.createIndexPage";
  var outputWindow = document.getElementById("pageContent");
  try {

    var schema      = "XFILES";
    var packageName = "XFILES_SOAP_SERVICES";
    var method      =  "CREATEINDEXPAGE";
  
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	var XHR = mgr.createPostRequest();
  	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processCreateIndexPage(mgr, outputWindow) } };
  
  	var parameters = new Object;
  	parameters["P_FOLDER_PATH-VARCHAR2-IN"]   = resourceURL;
  	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
    parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  
    mgr.sendSoapRequest(parameters);
  
  }    
  catch (e) {
    handleException(module,e,null);
  }
}
