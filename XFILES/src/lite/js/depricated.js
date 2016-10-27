
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

function showSourceCodeEPG(xml) {

  xmlText = xml.serialize();
  if (xmlText.length > 32000) {

    var windowURL = 'about:blank';
    var sourceCodeDocument;

    if (!sourceCodeWindow) {
	    sourceCodeWindow = window.open(windowURL,'sourceCodeViewer','scrollbars=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=no');
    }
  
    try {
  	  sourceCodeDocument = sourceCodeWindow.document;  
  	  sourceCodeDocument.domain  = this.document.domain;
      sourceCodeDocument.firstChild.firstChild.nextSibling.innerHTML ="";
    }
    catch (e) {
      if (sourceCodeDocument) {
      	sourceCodeWindow.close();
      }
 	    sourceCodeWindow = window.open(windowURL,'sourceCodeViewer','scrollbars=yes, toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=no');
  	  sourceCodeDocument = sourceCodeWindow.document;  
      sourceCodeDocument.firstChild.firstChild.nextSibling.innerHTML ="";
    }  
  
    var HTML = document.createElement('HTML');
    HTML.appendChild(document.createElement('HEAD'));
    var BODY = document.createElement('BODY');
    HTML.appendChild(BODY);
    var DIV = document.createElement("DIV");
    Printer.printToHTML(xml,DIV);
    BODY.appendChild(DIV);
  
    htmlText = HTML.innerHTML;
    HTML = null;
    htmlText = htmlText.replace(/class=openClose/g,'class="openClose" onclick="toggleShowChildren(this);return false"');
  
    sourceCodeDocument.open();
    sourceCodeDocument.write(htmlText);
    sourceCodeDocument.close();
    HTML = null;    

    // top.window.blur();
  }
  else {
	  document.getElementById("SOURCECODE").value=xmlText;                                                                                    
    document.getElementById("viewSourceCode").submit();      
    sourceCodeWindow = window.open('','sourceCodeViewer');

  }                                                                           

  sourceCodeWindow.focus();

}

function copyResource(targetFolder, resource, deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "COPYRESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
 	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Copy")}};
  outstandingRequestCount++;

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_TARGET_FOLDER-VARCHAR2-IN"]   = targetFolder;
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)

  mgr.sendSoapRequest(parameters);
  
}

function moveResource(targetFolder,resource) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "MOVERESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_TARGET_FOLDER-VARCHAR2-IN"]   = targetFolder;
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Move")}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}

function linkResource(targetFolder,resource,linkType) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "LINKRESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_TARGET_FOLDER-VARCHAR2-IN"]   = targetFolder;
	parameters["P_LINK_TYPE-NUMBER-IN"]         = linkType
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Link")}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}

function deleteResource(resource,deep,force) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "DELETERESOURCE";
  
	var mgr = soapManager.getRequestManager(schema,packageName,method);	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Delete")}};

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource
	parameters["P_FORCE-BOOLEAN-IN"]            = booleanToNumber(force) 
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
    
}

function lockResource(resource,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "LOCKRESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Lock")}};
  
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}
   
function unlockResource(resource,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "UNLOCKRESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Unlock")}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}
    
function publishResource(resource,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "PUBLISHRESOURCE";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
	// ToDo: Should redirect to published Folder...
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Publish")}};
  
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
    
}

function setAcl(resource,acl,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "SETACL";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource
	parameters["P_ACL_PATH-VARCHAR2-IN"]        = acl
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Set Acl")}};  
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
  
}

function setPrinciple(resource,owner,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "CHANGEOWNER";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_NEW_OWNER-VARCHAR2-IN"]       = owner;
	parameters["P_DEEP-BOOLEAN-IN"]             = booleanToNumber(deep)
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Change Owner")}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}

function makeVersioned(resource,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "MAKEVERSIONED";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = deep;
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Make Versioned", resourceURL)}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);

}
    
function checkOut(resource,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "CHECKOUT";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = deep;
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Check Out")}};
  
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
  
}
    
function checkIn(resource,comment,deep) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "CHECKIN";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resource;
	parameters["P_DEEP-BOOLEAN-IN"]             = deep;
	parameters["P_COMMENT-VARCHAR2-IN"]         = comment
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Check In")}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
  
}

function unzipResource(targetFolder,zipFile,duplicateAction) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "UNZIP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]     = zipFile
	parameters["P_FOLDER_PATH-VARCHAR2-IN"]       = targetFolder
	parameters["P_DUPLICATE_ACTION-VARCHAR2-IN>"] = duplicateAction
	
	var namespaces = xfilesNamespaces
	namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { reportComplete(mgr, document.getElementById("pageContent"), "Unzip" )}};
  outstandingRequestCount++;
  mgr.sendSoapRequest(parameters);
}

