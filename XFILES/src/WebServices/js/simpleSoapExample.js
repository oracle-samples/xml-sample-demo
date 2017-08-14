
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

var currentWSDL;
var queryServiceWSDL;

var WebServicesXSL;
var TableFormatterXSL
var SimpleInputFormXSL

function displayWSDL(response) {

  currentWSDL = new xmlDocument(response.responseXML);
	prettyPrintXML(currentWSDL,'d_wsdl');

}
  
function displayRequest(request) {

	prettyPrintXML(request,'d_request');

}

function checkSuccess(soapResponse) {

  var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/soap:Fault",orawsvNamespaces );
  if (nodeList.length > 0 ) {
  	return false;
	}
  
  return true;
 
}

function displayResults(mgr) {

  try {	
  	var soapResponse = mgr.getSoapResponse('simpleSoapExamples.displayResults');
	  prettyPrintXML(soapResponse,'d_response');
	  if (checkSuccess(soapResponse)) {
  	  formatResults(soapResponse,'d_results');
	    showResults();
  	}
	  else {
		  showResponse();
    }
  } 
  catch (e) {
    handleException('simpleSoapExample.displayResults',e,null);
  }

}

function displayResponse(mgr) {
	
	try {	
    var soapResponse = mgr.getSoapResponse('simpleSoapExamples.displayResponse');
	  prettyPrintXML(soapResponse,'d_response');
	  showResponse();
  } 
  catch (e) {
    handleException('simpleSoapExample.displayResults',e,null);
  }

}

function invokeQuery(SQLQUERY) {

  try {
    var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
    var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayResults(mgr)}};
    mgr.executeSQL(SQLQUERY.value);
    displayRequest(soapManager.getRequestXML());
  } 
  catch (e) {
    handleException('simpleSoapExample.invokeQuery',e,null);
  }
  
}

function callWS(form) {  

  var schema     = null;
  var packageName = null;
  var method = null;
  
  try {
    schema  = document.getElementById("ownerList").value;
    
    if (document.getElementById("procedureList").value == "") {
    	packageName = document.getElementById("packageList").value;
    	method = document.getElementById("methodList").value;
    }
    else {
    	packageName = document.getElementById("procedureList").value;
    }
  
    document.getElementById('d_results').innerHTML = "";
	
  
    var mgr = soapManager.getRequestManager(schema,packageName,method);  	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayResponse(mgr)}};

	  parameters = new Object;
	  xparameters = new Object;
	  
    for ( i=4; i<form.elements.length-1; i++)
    {
    	parameters[form.elements[i].name] = form.elements[i].value;
    }

    mgr.sendSoapRequest(parameters,xparameters);   
    displayRequest(soapManager.getRequestXML());
  } 
  catch (e) {
    handleException('simpleSoapExample.callWS',e,null);
  }

}

function generateFormFromWSDL(response) {

   currentWSDL = new xmlDocument(response.responseXML);  
   prettyPrintXML(currentWSDL,'d_wsdl');
   transformXMLtoHTML(currentWSDL,SimpleInputFormXSL,document.getElementById('d_inputForm'))

}

function getTargetWSDL(url) {

  var XHR = soapManager.createGetRequest(url);
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { generateFormFromWSDL(XHR)}};
  XHR.send();
}

function loadWebServicesXSL() {
  WebServicesXSL = loadXSLDocument("/XFILES/WebServices/xsl/webServices.xsl");
}

function loadSimpleInputFormXSL() {
  SimpleInputFormXSL = loadXSLDocument("/XFILES/WebServices/xsl/simpleInputForm.xsl");
}

function loadTableFormatterXSL() {
  TableFormatterXSL = loadXSLDocument("/XFILES/common/xsl/formatResponse.xsl");
}

function loadQueryServiceWSDL() {
  queryServiceWSDL = loadXMLDocument("/orawsv?wsdl");
}

function onPageLoaded() {

  showQuery();
  
  document.getElementById("ownerList").disabled = true;
  document.getElementById("procedureList").disabled = true;
  document.getElementById("packageList").disabled = true;
  document.getElementById("methodList").disabled = true;


  prettyPrintXML(queryServiceWSDL,'d_wsdl');
  getOwnerList();
  viewXML = doViewXML;
}

function init(target) {

  var resourceXML
  
  try { 
    initXFilesCommon();
    loadWebServicesXSL();
    loadTableFormatterXSL();
    loadSimpleInputFormXSL();
    loadQueryServiceWSDL();
    loadOracleWebServiceNamespaces();
  
    resourceXML = getResourceXML("/XFILES/WebServices");
    transformXMLtoHTML(resourceXML,WebServicesXSL,target)

	  setPageActive();
  } 
  catch (e) {
    handleException('simpleSoapExample.init',e,null);
  }
 
}

function doViewXML() {
	
	closePopupDialog();
	showSourceCode(currentWSDL);
	
}
