
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

var max
var first
var last 

function onPageLoaded() {
  loadPreviews();
}

function loadPreviews() {
  
  var residList = resource.selectNodes('//res:Resource/xfiles:ResourceStatus/xfiles:Resid',xfilesNamespaces);
  var contentTypeList = resource.selectNodes('//res:Resource/res:ContentType',xfilesNamespaces)
  var contentType;
  	
  for (var i=0; i < residList.length; i++){
    var  contentType = contentTypeList.item(i).firstChild.nodeValue;
    var RESID        = residList.item(i).firstChild.nodeValue;
    var previewArea = document.getElementById(RESID);

    var primaryContentType = contentType;
    if (contentType.indexOf('/') > 0) {
      primaryContentType = contentType.substring(0,contentType.indexOf('/'));
    }

    if (primaryContentType != "image") {
      previewContent(previewArea,RESID);
    }	  
  }
}

function processPreview(mgr, target) {

  try {
    var soapResponse = mgr.getSoapResponse('VersionHistory.processPreview');
   
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	  
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    target.innerHTML = extractText(nodeList.item(0));
    return;
  }
  catch (e) {
    handleException('VersionHistory.processPreview',e,null);
  }
}


function previewContent(target,RESID) {
  
  var path = '/sys/oid/' + RESID;

	var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "GENERATEPREVIEW";

	var mgr = soapManager.getRequestManager(schema,packageName,method);	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { processPreview(mgr, target)}};
  
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = path
	parameters["P_LINES-NUMBER-IN"] = 10
	
  mgr.sendSoapRequest(parameters);
  
}

function renderContentSOAP(RESID) {
 
  var path = '/sys/oid/' + RESID;

	var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "RENDERASXHTML";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { processXHTML(mgr)}};
  
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = path		
  mgr.sendSoapRequest(parameters);

}

function processXHTML(mgr) {

  try {
    var soapResponse = mgr.getSoapResponse('VersionHistory.processXHTML');
   
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
	  
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    contentArea = document.getElementById("previewContent")     
    contentArea.innerHTML = extractText(nodeList.item(0));
  }
  catch (e) {
    handleException('VersionHistory.processXHTML',e,null);
  }
}

function renderContent(path) {
 

	var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "RENDERASXHTML";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { processXHTML(mgr)}};
  
	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = path		
  mgr.sendSoapRequest(parameters);

}


function renderDocument(evt, RESID) {

  var path = '/sys/oid/' + RESID;
  var previewArea = document.getElementById("documentPreviewDialog");
  // renderContent(path);
  var iframe = document.getElementById("documentPreview");
  iframe.src = '/sys/servlets/XFILES/Protected/XFILES.XFILES_REST_SERVICES.RENDERDOCUMENT?P_RESOURCE_PATH=' + escape(path) + '&P_CONTENT_TYPE=text/html';
  openPopupDialog(evt,previewArea);
}

function closePreview() {
	closePopupDialog();
}

function showNext() {	  
	if (last < max) {
    document.getElementById(first).style.display="none";
	  first++;
		last++;
		document.getElementById(last).style.display="inline-block";
	}
}

function showPrev() {	  
  if (first > 1) {
 	  document.getElementById(last).style.display="none";
		first--;
		last--;
		document.getElementById(first).style.display="inline-block"
	}
}
	 