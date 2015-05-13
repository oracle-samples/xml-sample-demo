
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

var resource;
var resourceURL;
var stylesheetURL;

// Cache the current XSL to allow local sorting without refetching the XSL.

var folderXSL;
                  
var xfilesNamespaces ;
var xfilesPrefixList = orawsvPrefixList;
    xfilesPrefixList['xfiles'] = 'http://xmlns.oracle.com/xdb/xfiles';
    xfilesPrefixList['rss']    = 'http://xmlns.oracle.com/xdb/xfiles/rss';
    xfilesPrefixList['res']    = 'http://xmlns.oracle.com/xdb/XDBResource.xsd';
    xfilesPrefixList['wiki']   = 'http://xmlns.oracle.com/xdb/xfiles/wiki';
    xfilesPrefixList['img']    = "http://xmlns.oracle.com/xdb/metadata/ImageMetadata";
    xfilesPrefixList['exif']   = "http://xmlns.oracle.com/ord/meta/exif";
    xfilesPrefixList['xhtml']  = "http://www.w3.org/1999/xhtml";
    xfilesPrefixList['acl']    = "http://xmlns.oracle.com/xdb/acl.xsd";

function loadXFilesNamespaces() {
  xfilesNamespaces = new namespaceManager(xfilesPrefixList);
}

function initXFilesCommon(target) {

  handleException  = xfilesHandleException;
  showSourceCode   = xfilesShowSourceCode;
  openDialog       = xfilesOpenDialog;
  closeDialog      = xfilesCloseDialog;
  openPopupDialog  = xfilesOpenPopupDialog;
  closePopupDialog = xfilesClosePopupDialog;
  closeCurrentForm = xfilesCloseCurrentForm;
  reloadForm       = xfilesReloadForm;
  viewXML          = xfilesViewXML;
  viewXSL          = xfilesViewXSL;
  viewSOAPRequest  = xfilesViewSOAPRequest;
  viewSOAPResponse = xfilesViewSOAPResponse;
    
  initCommon();
  loadXFilesNamespaces();
	loadFixedWSDLCache()
  
}

function showHTML(result,target) {
	
	  var nodeList = result.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:Transformation",namespaces);
    var output = new xmlDocument().parse(nodeList.item(0).firstChild.nodeValue);
    alert(output.serialize());

}

function getCacheGuid(resource) {
	
	var cacheGUID = resource.selectNodes("/res:Resource/xfiles:xfilesParameters/xfiles:cacheGUID",xfilesNamespaces).item(0)
	if (cacheGUID == null) {
    error = new xfilesException('common.getCacheGuid',12,resource.loadedFromURL, null);
    error.setDescription('Unable to locate GUID');
    throw error;
  }
  var GUID = cacheGUID.firstChild.nodeValue;
	return GUID;
}

     
function transformToHTML(target,resource,stylesheetURL) {
	 
	/*
	**
	** Only use with Resource Documents. If working with Chrome perform the transformation 
	** Server Side. 
	**
	*/
		 
	var stylesheet = loadXSLDocument(stylesheetURL);
  xmlToHTML(target,resource,stylesheet);

}

function xfilesforceLogon(event) {
	try {
		doLogon(event);   
	  reloadForm();
	}
	catch (e) {
   	if (e.rootCauseAccessDenied()) {
   		/*
   		**
   		** User cancelled the HTTP Authorization Dialog. 
   		** 
   		*/
  		abortAccessDenied('common.xfilesforceLogon',null);
    }
   	else {
      handleException('common.xfilesforceLogon',e,resourceURL);
    }
  }
}

function hasCreateResource(resourcePath) {
	
	var hasPermission = false;
	
	var targetFolder = resourcePath.substring(0,resourcePath.lastIndexOf('/')-1);
	
  var schema  = "XFILES";
  var package = "XFILES_SOAP_SERVICES";
  var method  = "GETPRIVILEGES";
	
	var mgr = soapManager.getRequestManager(schema,package,method);
  	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("lite",mgr.getServiceNamespace());
	
	var XHR = mgr.createPostRequest(false);

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = targetPath;
  mgr.sendSoapRequest(parameters);    
  
  var permissions = logRequestManager.getSoapResponse(logRequestManager);
     
  var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_PRIVILEGES/acl:privilege/acl:link",xfilesNamespaces);
	return nodeList.length == 1;

}

function xfilesDoLogon(event) {
	try {
		doLogon(event);   
	  reloadForm();
	}
	catch (e) {
   	if (e.rootCauseAccessDenied()) {
   		/*
   		**
   		** User cancelled the HTTP Authorization Dialog. 
   		** Login Button is only displayed when logged in as ANONYMOUS
   		** Therefore ANONYMOUS access must be permitted.
   		** 
   		*/
   		getHttpUsername();
   		if (cacheResult && window.chrome) {
     	}
     	else {
     		showErrorMessage('Unable to complete Authentication process with Safari Browser : Please try Chrome or Firefox');
   	  }	
			reloadForm();
    }
   	else {
      handleException('common.xfilesDoLogon',e,resourceURL);
    }
  }
}

function xfilesDoLogoff(event) {
	try {
		doLogoff(event);   
		if (isAuthorizedUser()) {
      var target="/XFILES/lite/Folder.html?target=/";
      window.location.href = target;
    }  	
  	else {
  		xfilesforceLogon();
  	}
	}
	catch (e) {
    handleException('common.xfilesDoLogoff',e,resourceURL);
  }
}
   
function xmlTreeControl(name,tree,namespaces,XSL,target) {

   var treeName;
   var treeState; 
   var treeStateXSL;
   var targetWindow;
   var treeNamespaces;
   
   this.treeName = name;
   this.treeState = tree;
   this.treeStateXSL = XSL;
   this.targetWindow = target
   this.treeNamespaces = namespaces;
   
   var self = this;

   xmlToHTML(this.targetWindow,this.treeState,this.treeStateXSL);
   
   function toggleChildren(parent,state) {
     for (i=0 ; i < parent.childNodes.length; i++) {
       child = parent.childNodes[i];
       if (child.nodeName == 'DIV') {
         if (state == 'visible') {
           child.style.display="block";
         }
         else {
           child.style.display="none";
         }
       }
     }
   }
   
   this.showChildren = function ( id ) { 
     node = self.treeState.selectNodes('//*[@id="' + id + '"]/@children',self.treeNamespaces).item(0);
     node.value = 'visible';
     xmlToHTML(self.targetWindow,self.treeState,self.treeStateXSL);
     raiseEvent(target,"click");
   }

   this.hideChildren = function ( id ) { 
     node = self.treeState.selectNodes('//*[@id="' + id + '"]/@children',self.treeNamespaces).item(0);
     node.value = 'hidden';
     xmlToHTML(self.targetWindow,self.treeState,self.treeStateXSL);
     raiseEvent(target,"click");
   }

   this.isWritableFolder = function() {
     node = self.treeState.selectNodes('//*[@isOpen="open"]',self.treeNamespaces).item(0);
     if (!node) {
     	 return false;
     }
     else {
     	 return node.getAttribute('isWriteable') == "true";
     }
   }
   
   this.getOpenFolder = function() {
     node = self.treeState.selectNodes('//*[@isOpen="open"]',self.treeNamespaces).item(0);
     if (!node) {
       return null
     }

     var currentPath = "";
          
     if (node) {
       currentPath = "";
       while (node.parentNode.ownerDocument) {
         currentPath = '/' + node.getAttribute('name')  + currentPath;
         node = node.parentNode;
       }
     }

     if (currentPath == "") {
       currentPath = "/";
     }     
     return currentPath;
     
   }

   this.selectBranch = function ( id ) { 
     unimplementedFunction('selectBranch ' + id);
   }
   
   this.unselectBranch = function ( id ) { 
     unimplementedFunction('unselectBranch ' + id);
   }
   
   this.makeOpen = function ( id ) { 
     node = self.treeState.selectNodes('//*[@isOpen="open"]',self.treeNamespaces).item(0);
     if (node) {
       node.setAttribute('children','hidden');
       node.setAttribute('isOpen','closed');
     }

     node = self.treeState.selectNodes('//*[@id="' + id + '"]',self.treeNamespaces).item(0);
     node.setAttribute('isOpen','open');
     while (node.ownerDocument) {
       node.setAttribute('children','visible');
       node = node.parentNode;
     }
     xmlToHTML(self.targetWindow,self.treeState,self.treeStateXSL);
     raiseEvent(target,"click");

   }

   this.makeClosed = function ( id ) { 
     node = self.treeState.selectNodes('//*[@isOpen="open"]',self.treeNamespaces).item(0);
     node.setAttribute('isOpen','closed');
     xmlToHTML(self.targetWindow,self.treeState,self.treeStateXSL);
     raiseEvent(target,"click");
   }
}

function doSearch(searchType,searchTerms) {

  var action = searchType.value;
  var criteria = searchTerms.value;
   
  if (!isAuthenticatedUser()) {
  	showUserErrorMessage("Search restricted to authenticated users - please log in.");
  	return;
  }
  
  if ((action == 'FOLDER') || (action == 'TREE') || (action == 'ROOT')) {
  	 if (isEmptyString(criteria)) {
  	 	 showErrorMessage('Enter Search Criteria');
  	 	 return;
  	 }
     window.location='/XFILES/XMLSearch/reposSearch.html?target=' + escape(resourceURL) + '&searchType=' + action + '&searchTerms=' + escape(criteria);   
  }
 
  if (action == 'ADV') {
     window.location='/XFILES/XMLSearch/resourceSearch.html?target=' + escape(resourceURL) + '&searchTerms=' + escape(criteria);   
  }
  
  if (action == 'XSD') {
     window.location='/XFILES/lite/Resource.html?target=' + ('/XFILES/XMLSearch/xmlSchema/xmlSchemaList.xml') + '&stylesheet=' + escape('/XFILES/lite/xsl/XMLSchemaList.xsl') + '&includeContent=true';   
  }
  
  if (action == 'XIDX') {
     window.location='/XFILES/lite/Resource.html?target=' + ('/XFILES/XMLSearch/xmlIndex/xmlIndexList.xml') + '&stylesheet=' + escape('/XFILES/lite/xsl/XMLIndexList.xsl')  + '&includeContent=true';   
  }

}

function toggleSearchTerms(searchType,searchTerms) {

  var action = searchType.value;

  if ((action == 'FOLDER') || (action == 'TREE') || (action == 'ROOT') ) {
   	searchTerms.disabled = false;
  }
  else {
   	searchTerms.disabled = true;
  }	
}

function abortAccessDenied(module,e) {
	
	div = document.getElementById("greyLoading");
	if (div != null) {
		div.style.display="none";
	}
	
	div = document.getElementById("pageLoading");
	if (div != null) {
		div.style.display="none";
	}

	div = document.getElementById("pageContent");
	if (div != null) {
		div.style.display="none";
	}

  errorWindow = document.getElementById("fatalError");
  errorMessage = 'Application unavailable. Access Denied for user : "' + httpUsername + "\". Please contact your administrator for further information."
  if (errorWindow != null) {
  	error = new xfilesException(module,12,null,e);
    error.setDescription(errorMessage);
    exceptionToHTML(error,errorWindow);
  }
  else {
  	alert(errorMessage);
 	}
}

function displayResource(resource, outputWindow, stylesheetURL) {

  resourceURL = resource.selectNodes("/res:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath",xfilesNamespaces).item(0).nodeValue;
  transformToHTML(outputWindow,resource,stylesheetURL);
  loadScripts();

}

function importResource(resource) {

  var newResource = new xmlDocument();
  var node = newResource.appendChild(newResource.importNode(resource,true));
  return newResource;

}

function processResourceREST(newResource, outputWindow, stylesheetURL) {

  try {
  	newResource.checkParsing();
	  resource = newResource;
  	displayResource(resource,outputWindow,stylesheetURL);
  }
  catch (e) {
    handleException('common.processResourceREST',e,resourceURL);
  }
  
}

function processResourceSOAP(mgr, outputWindow, stylesheetURL) {

  try {
    var soapResponse = mgr.getSoapResponse("common.processResourceSOAP");
    
    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
    var newResource = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_RESOURCE/res:Resource",namespaces).item(0);
    resource = importResource(newResource);
    displayResource(resource,outputWindow,stylesheetURL);
  }
  catch (e) {
    handleException('common.processResourceSOAP',e,resourceURL);
  }

}

function getResourceREST(resourceURL, outputWindow, stylesheetURL, includeContent) {

  var restURL;
  var resource = new xmlDocument();
   
  if (includeContent) {
    restURL = '/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.GETRESOURCEWITHCONTENT?P_RESOURCE_PATH=' + encodeURIComponent(resourceURL)  + '&P_TIMEZONE_OFFSET=' + timezoneOffset + '&P_CACHE_RESULT=' + cacheResult;
  }
  else {
    restURL = '/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.GETRESOURCE?P_RESOURCE_PATH=' + encodeURIComponent(resourceURL)  + '&P_TIMEZONE_OFFSET=' + timezoneOffset + '&P_CACHE_RESULT=' + cacheResult;
  }
    
  resource.setOnLoad( function() {processResourceREST(resource, outputWindow, stylesheetURL)} );
  resource.load(restURL,true);

}


function getResourceSOAP(resourceURL, outputWindow, stylesheetURL, includeContent) {

  var schema  = "XFILES";
  var package = "XFILES_SOAP_SERVICES";
  var method;

  if (includeContent) {
	  method =  "GETRESOURCEWITHCONTENT";
	}
  else {
	  method =  "GETRESOURCE";
	}
	
	var mgr = soapManager.getRequestManager(schema,package,method);
  	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("lite",mgr.getServiceNamespace());
	
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResourceSOAP(mgr, outputWindow, stylesheetURL) } };

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resourceURL;
  parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  mgr.sendSoapRequest(parameters);    
     
}

function getResource(resourceURL, outputWindow, stylesheetURL, includeContent) {

  if (!isAuthenticatedUser()) {
    getResourceREST(resourceURL,outputWindow,stylesheetURL,includeContent);
  }
  else {
    getResourceSOAP(resourceURL,outputWindow,stylesheetURL,includeContent);
  }
}

function displayFolder(resource, outputWindow, stylesheetURL) {

  includeMetadata = false;
  
  // showSourceCode(resource);
  resourceURL = resource.selectNodes("/res:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath",xfilesNamespaces).item(0).nodeValue;

  var rssEnabled = (resource.selectNodes("/res:Resource/rss:enableRSS",xfilesNamespaces).length > 0);
  if (rssEnabled) {
  	// RSS Feed is enabled for this folder. Check if the HTML Page contains the rss Link
    var rssLinkPresent = document.getElementById('rssEnabled');
    if (! rssLinkPresent) {
    	// Redirect to the ENABLERSSICON servlet. Servlet regenerates the HTML Page with the RSS Link and sends it back to browser. <HEAD> element must contain an element as follows : <link id="enableRSSIcon"/>
    	var doAuthentication = getParameter("forceAuthentication");
    	if ((!doAuthentication) || (doAuthentication.toLowerCase != "true")) {
    		doAuthentication = "false";
      }
      if (isAuthenticatedUser()) {
        window.location.href = "/sys/servlets/XFILES/Protected/XFILES.XFILES_REST_SERVICES.ENABLERSSICON?P_RESOURCE_PATH=" + encodeURIComponent(resourceURL) + "&P_TEMPLATE_PATH=" + encodeURIComponent("/XFILES/lite/FolderRSS.html") + "&P_STYLESHEET_PATH=" + escape(stylesheetURL) + "&P_FORCE_AUTHENTICATION=" + doAuthentication;
      }
      else {
        window.location.href = "/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.ENABLERSSICON?P_RESOURCE_PATH=" + encodeURIComponent(resourceURL) + "&P_TEMPLATE_PATH=" + encodeURIComponent("/XFILES/lite/FolderRSS.html") + "&P_STYLESHEET_PATH=" + escape(stylesheetURL) + "&P_FORCE_AUTHENTICATION=" + doAuthentication;
      }
      return;
    }
  }

  // Cache folderXSL to enable local sorting.

	folderXSL = loadXSLDocument(stylesheetURL);
  transformToHTML(outputWindow,resource,stylesheetURL);
  loadScripts();
  
}

function processFolderREST(newResource, outputWindow, stylesheetURL) {

  try {
  	newResource.checkParsing();
    resource = newResource;
    displayFolder(resource,outputWindow,stylesheetURL);
  }
  catch (e) {
  	if ((e.rootCauseAccessDenied) && (e.rootCauseAccessDenied())) {
  		abortAccessDenied('common.processFolderREST',e);
    }
    else {
      handleException('common.processFolderREST',e,newResource.loadedFromURL);
    }
  }

}

function processFolderSOAP(mgr, outputWindow, stylesheetURL) {

  try {
    var soapResponse = mgr.getSoapResponse("common.processFolderSOAP");
    
    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
    var newResource = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_FOLDER/res:Resource",namespaces).item(0);
    resource = importResource(newResource);
    displayFolder(resource,outputWindow,stylesheetURL);
  
  }    
  catch (e) {
   handleException('common.processFolderSOAP',e,resourceURL);
  }
}

function showFolderREST(folderURL, outputWindow, stylesheetURL) {

  // alert('getFolderRest(' + folderURL + ')');
  
  var resource = new xmlDocument();
  resource.setOnLoad( function() {processFolderREST(resource, outputWindow, stylesheetURL)} );
  resource.load('/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.GETFOLDERLISTING?P_FOLDER_PATH=' + encodeURIComponent(folderURL)  + '&P_INCLUDE_EXTENDED_METADATA=' + booleanToNumber(includeMetadata) + '&P_TIMEZONE_OFFSET=' + timezoneOffset + '&P_CACHE_RESULT=' + cacheResult,true);
  
}

function showFolderSOAP(folderURL, outputWindow, stylesheetURL) {


  var schema  = "XFILES";
  var package = "XFILES_SOAP_SERVICES";
  var method =  "GETFOLDERLISTING";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processFolderSOAP(mgr, outputWindow, stylesheetURL) } };

	var parameters = new Object;
	parameters["P_FOLDER_PATH-VARCHAR2-IN"]   = folderURL;
  parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  
  if (includeMetadata) {
    parameters["P_INCLUDE_METADATA-VARCHAR2-IN"] = 'TRUE'
  }
  else {
    parameters["P_INCLUDE_METADATA-VARCHAR2-IN"] = 'FALSE'
  }
  
	mgr.sendSoapRequest(parameters);

}

function showFolder(folderURL, outputWindow, stylesheetURL) {

  try {
    if (!isAuthenticatedUser()) {
      showFolderREST(folderURL,outputWindow,stylesheetURL);
    }
    else {
      showFolderSOAP(folderURL,outputWindow,stylesheetURL);
    }
  }
  catch (e) {
    error = new xfilesException('common.showFolder',12, folderURL, e);
    throw error;
  }
}

function getFolderWithMetadata(newFolderPath,newStylesheetURL) {
	
	includeMetadata = true
	doFolderJump(newFolderPath,newStylesheetURL)
	
}
    
function doFolderJump(newFolderPath,newStylesheetURL) {

  stylesheetURL = '/XFILES/lite/xsl/FolderBrowser.xsl';
  
  if ((typeof newStylesheetURL == "string") && ( newStylesheetURL != "")) {
    stylesheetURL = newStylesheetURL
  }

  // If the current Page is RSS enabled we must do the jump via a reload to ensure the Browser's RSS Icon registers the change of location / RSS status

  var rssEnabled = (resource.selectNodes("/res:Resource/rss:enableRSS",xfilesNamespaces).length > 0);
  if (rssEnabled)	{
  	window.location.href = "/XFILES/lite/Folder.html?target=" + escape(newFolderPath) + "&stylesheet="+ escape(stylesheetURL);
  }
  else {
	  resourceURL = newFolderPath
	  showFolder(resourceURL,document.getElementById('pageContent'),stylesheetURL,false);
	}
}

function displayVersionHistory(resource, outputWindow, stylesheetURL) {

  resourceURL = resource.selectNodes("/res:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath",xfilesNamespaces).item(0).nodeValue;
  transformToHTML(outputWindow,resource,stylesheetURL);
  loadScripts();
  
}

function processVersionHistoryREST(newResource, outputWindow, stylesheetURL) {
	
  try {
  	newResource.checkParsing();
    resource = newResource;
    displayVersionHistory(resource,outputWindow,stylesheetURL);
  }
  catch (e) {
    handleException('common.processVersionHistoryREST',e,resourceURL);
  }
  
}

function processVersionHistorySOAP(mgr, outputWindow, stylesheetURL) {

  try {
    var soapResponse = mgr.getSoapResponse("common.processVersionHistorySOAP");
    
    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
    var newResource = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_RESOURCE/res:Resource",namespaces).item(0);
    resource = importResource(newResource);
    displayVersionHistory(resource,outputWindow,stylesheetURL);
  }
  catch (e) {
    handleException('common.processVersionHistorySOAP',e,resourceURL);
  }

}

function getVersionHistorySOAP(resourceURL, outputWindow, stylesheetURL) {

  var schema  = "XFILES";
  var package = "XFILES_SOAP_SERVICES";
  var method =  "GETVERSIONHISTORY";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processVersionHistorySOAP(mgr, outputWindow, stylesheetURL) } };

  var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = resourceURL;
	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  mgr.sendSoapRequest(parameters);

}

function getVersionHistoryREST(resourceURL, outputWindow, stylesheetURL) {

  var resource = new xmlDocument();
  resource.setOnload( function() {processVersionHistoryREST(resource, outputWindow, stylesheetURL)} );
  resource.load('/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.GETVERSIONHISTORY?P_FOLDER_PATH=' + encodeURIComponent(resourceURL)  + '&P_TIMEZONE_OFFSET=' + timezoneOffset + '&P_CACHE_RESULT=' + cacheResult,true);
  
}

function getVersionHistory(resourceURL, outputWindow, stylesheetURL) {

  if (!isAuthenticatedUser()) {
    getVersionHistoryREST(resourceURL,outputWindow,stylesheetURL);
  }
  else {
    getVersionHistorySOAP(resourceURL,outputWindow,stylesheetURL);
  }
}

function showAboutXFiles(evt) {
	
	openModalDialog("aboutXFilesDialog");
	
}

function doShowHomeFolder(evt,user) {
	
  if (document.getElementById("folderListing")) {
    doFolderJump('/home/' + user);
  }
  else {
    window.location = "/XFILES/lite/Folder.html?target=" + escape("/home/" + user);
  }
}

function xfilesHelpMenu(evt) {
	var dialog = document.getElementById("xfilesHelpMenu");
  openPopupDialog(evt, dialog)

}
     	
function closeCurrentWindow(currentURL) {
	showParentFolder(currentURL);
}

function showParentFolder(currentURL) {
  
  var targetURL 
 
  if (typeof currentURL == "undefined") {
    targetURL = resourceURL;
  } 
  else {
   targetURL = currentURL;
  }
 
  if (resourceURL.lastIndexOf("/") == 0) {
    targetURL = "/";
  }
  else {
    targetURL = targetURL.substring(0,targetURL.lastIndexOf("/"));
  }
 
  window.location = "/XFILES/lite/Folder.html?target=" + escape(targetURL);
}

function isErrorDialogOpen() {
	
	errorDialog = document.getElementById("genericErrorDialog");
	if (errorDialog) {
		return errorDialog.style.display != "none";
	}
	
	return false;

}

var xfilesCloseCurrentForm = function() {
	history.back();
}

var xfilesViewXML = function () {
	closePopupDialog();
  showSourceCode(resource);
}

var xfilesViewXSL = function () {
	closePopupDialog();
  showSourceCode(loadXMLDocument(stylesheetURL));
}

var xfilesViewSOAPRequest = function () {

	closePopupDialog();
	var requestXML = soapManager.getRequestXML();
	if (requestXML == null) {
		showWarningMessage("Request object not available");		
  }
	else {
    showSourceCode(requestXML);
	}

}

var xfilesViewSOAPResponse = function () {

	closePopupDialog();
	var responseXML = soapManager.getResponseXML();
	if (responseXML == null) {
 		showWarningMessage("Response object not yet available");		
  }
	else {
 	  showSourceCode(responseXML);
  }
}

var xfilesShowSourceCode = function (xml) {
	
	var xmlOutputArea = document.getElementById('xmlWindow');
	xmlOutputArea.innerHTML = "";
	xmlPP.print(xml,xmlOutputArea);
	openModalDialog('currentXML');
    	
}	

var xfilesOpenDialog = function (dialog) {
	
	if (typeof dialog == "string") {
		dialog = document.getElementById(dialog)
	}
		
	dialog.style.display = "block";

}


var xfilesCloseDialog = function (dialog) {
	
	if (typeof dialog == "string") {
		dialog = document.getElementById(dialog)
	} 
	
	dialog.style.display = "none";

}

var xfilesOpenPopupDialog = function (evt, dialog, dialogCloser) {
	
	if (typeof dialog == "string") {
		dialog = document.getElementById(dialog)
	}

  if ((!dialogCloser) || (typeof dialogCloser != "function")) {
    dialogCloser = function() {dialog.style.display="none";}
  }

	setDialogCloser(dialogCloser);
  dialog.style.display = "block";

  stopBubble(evt);
	
}

var xfilesClosePopupDialog = function() {
   
  var dialogCloser = dialogClosers.pop();
  if (typeof dialogCloser == "function") {
    dialogCloser();
    dialogCloser = null;
  }

}

var xfilesReloadForm = function() {

  if (useMSXML) {
  	 window.location.reload(false);
  }
  else {
  	window.location.reload();
  }
}

function loadFixedWSDLCache() {
	
	fixedWSDLCache = new Array()
	
	WSDL = '<definitions name="CREATEXFILESUSER"'
       + '    targetNamespace="http://xmlns.oracle.com/orawsv/XFILES/XFILES_ADMIN_SERVICES/CREATEXFILESUSER"'
       + '    xmlns="http://schemas.xmlsoap.org/wsdl/"'
       + '    xmlns:tns="http://xmlns.oracle.com/orawsv/XFILES/XFILES_ADMIN_SERVICES/CREATEXFILESUSER"'
       + '    xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
       + '    xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/">'
       + '  <types>'
       + '    <xsd:schema targetNamespace="http://xmlns.oracle.com/orawsv/XFILES/XFILES_ADMIN_SERVICES/CREATEXFILESUSER"'
       + '     elementFormDefault="qualified">'
       + '      <xsd:element name="CREATEXFILESUSERInput">'
       + '        <xsd:complexType>'
       + '            <xsd:sequence>'
       + '              <xsd:element name="P_PASSWORD-VARCHAR2-IN" type="xsd:string"/>'
       + '              <xsd:element name="P_PRINCIPLE_NAME-VARCHAR2-IN" type="xsd:string"/>'
       + '            </xsd:sequence>'
       + '          </xsd:complexType>'
       + '      </xsd:element>'
       + '      <xsd:element name="CREATEXFILESUSEROutput">'
       + '        <xsd:complexType>'
       + '            <xsd:sequence>'
       + '            </xsd:sequence>'
       + '          </xsd:complexType>'
       + '      </xsd:element>'
       + '   </xsd:schema>'
       + '  </types>'
       + '  <message name="CREATEXFILESUSERInputMessage">'
       + '    <part name="parameters" element="tns:CREATEXFILESUSERInput"/>'
       + '  </message>'
       + '  <message name="CREATEXFILESUSEROutputMessage">'
       + '    <part name="parameters" element="tns:CREATEXFILESUSEROutput"/>'
       + '  </message>'
       + '  <portType name="CREATEXFILESUSERPortType">'
       + '  <operation name="CREATEXFILESUSER">'
       + '      <input message="tns:CREATEXFILESUSERInputMessage"/>'
       + '      <output message="tns:CREATEXFILESUSEROutputMessage"/>'
       + '    </operation>'
       + '  </portType>'
       + '  <binding name="CREATEXFILESUSERBinding"'
       + '           type="tns:CREATEXFILESUSERPortType">'
       + '    <soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>'
       + '    <operation name="CREATEXFILESUSER">'
       + '      <soap:operation soapAction="CREATEXFILESUSER"/>'
       + '      <input>'
       + '        <soap:body parts="parameters" use="literal"/>'
       + '      </input>'
       + '      <output>'
       + '        <soap:body parts="parameters" use="literal"/>'
       + '      </output>'
       + '    </operation>'
       + '  </binding>'
       + '  <service name="CREATEXFILESUSERService">'
       + '    <documentation>Oracle Web Service</documentation>'
       + '    <port name="CREATEXFILESUSERPort" binding="tns:CREATEXFILESUSERBinding">'
       + '       <soap:address location="http://xmldb.us.oracle.com:9000/orawsv/XFILES/XFILES_ADMIN_SERVICES/CREATEXFILESUSER"/>'
       + '     </port>'
       + '  </service>'
       + '</definitions>';
       
  fixedWSDLCache["XFILES.XFILES_ADMIN_SERVICES.CREATEXFILESUSER"] = new xmlDocument().parse(WSDL);
  
  // soapManager.setWSDLCacheEntry("XFILES.XFILES_ADMIN_SERVICES.CREATEXFILESUSER",new xmlDocument().parse(WSDL));

}