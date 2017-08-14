
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

var soapManager = new SoapManager();

function SoapManager(manager) {
	
	var wsdlCache = null;
  var logger = new Array();
  var self = this;
  
  function expandURL(URL) {
    
    var expandedURL = "http://" + location.hostname;
    if (location.port) {
      expandedURL  = expandedURL + ":" + location.port;
    }  
    expandedURL = expandedURL + URL;
    return expandedURL;
  }
  
  function showErrorMessage (message,url,callback) {
    dialogOptions =     {
      title: 'ERROR',
      message: message,
      type: BootstrapDialog.TYPE_DANGER,
      closable: false,       
      buttons:[
        {
          label: 'OK',
          action: function(dialog) {
            typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(true);
            dialog.close();
          }
        }
      ]
    }
    
    if (typeof url == "string") {
   	 dialogOptions.title = dialogOptions.title + ":" + url
    }
     
    if ( typeof callback === 'function' ) {
      dialogOptions.onhidden = callback;
    }
  
    BootstrapDialog.show(dialogOptions);
  }
  
  function showSuccessMessage(message,callback) {
  
	  var dialogOptions =     {
   		title: 'SUCCESS',
   		message: message,
   		type: BootstrapDialog.TYPE_SUCCESS,
   		closable: true
 		}

	  if ( typeof callback === 'function' ) {
	    dialogOptions.onhidden = callback;
 		}

	  BootstrapDialog.show(dialogOptions);

  }

  function showInformationMessage(message,callback) {
  
	  var dialogOptions =     {
   		title: 'INFORMATION',
   		message: message,
   		type: BootstrapDialog.TYPE_INFO,
   		closable: true
 		}

	  if ( typeof callback === 'function' ) {
	    dialogOptions.onhidden = callback;
 		}

	  BootstrapDialog.show(dialogOptions);

  }

  this.showSoapLog = function(logWindowID) {
  	if (logger.length == 0) {
  		showErrorMessage("No logged operations");
  	}
  	else {
      this.loadLogEntry(logger.length);
      openModalDialog(logWindowID);
    }
  }
  
  this.loadLogEntry = function(index) {
  
    var nextRecord = document.getElementById("lw.NextRecord")
    var prevRecord = document.getElementById("lw.PrevRecord")
    
    if (index == 1) {
      prevRecord.firstChild.src = "/XFILES/lib/icons/prevDisabled.png"
      prevRecord.onclick= function() {return false};
    }
    else {
      prevRecord.firstChild.src = "/XFILES/lib/icons/prevEnabled.png"
      prevRecord.onclick = function(index) { return function() {self.loadLogEntry(index); return false;}; }(index-1)
    }
    
    if (index == logger.length) {
      nextRecord.firstChild.src = "/XFILES/lib/icons/nextDisabled.png"
      nextRecord.onclick=function() {return false};
    }
    else {
      nextRecord.firstChild.src = "/XFILES/lib/icons/nextEnabled.png"
      nextRecord.onclick = function(index) { return function() {self.loadLogEntry(index); return false;}; }(index+1);
    }
    
    var method           = document.getElementById("lw.Method");
    var url              = document.getElementById("lw.URL");
    var logRecordNumber  = document.getElementById("lw.RecordNumber");
    var logRecordCount   = document.getElementById("lw.RecordCount");
    var requestBody      = document.getElementById("lw.RequestBody");
    var responseText     = document.getElementById("lw.ResponseText");    
    var startTime        = document.getElementById("lw.StartTime");
    var elapsedTime      = document.getElementById("lw.ElapsedTime");
    var httpStatus       = document.getElementById("lw.HttpStatus");

    var logIndex = index-1;
  
    
    logRecordNumber.textContent = index;
    logRecordCount.textContent  = logger.length;
    method.textContent          = "POST"
    // url.textContent             = expandURL(logger[logIndex][0])
    url.textContent             = logger[logIndex][0]
    startTime.textContent       = logger[logIndex][4]
    httpStatus.textContent      = logger[logIndex][5] + " [" +  logger[logIndex][6] + "]"
    elapsedTime.textContent     = logger[logIndex][7] + "ms"

    requestBody.innerHTML = "";
   	xmlPP.print(logger[logIndex][1],requestBody);

    responseText.innerHTML = "";
   	xmlPP.print(logger[logIndex][2],responseText);

    javaScriptCode = document.getElementById("lw.JavascriptCode");
  	javaScriptCode.innerHTML = "";
  	// var sourceCode = self[logger[logIndex][8]].toString();
  	// sourceCode = sourceCode.replace('function','function ' + logger[logIndex][8]);
  	// javaScriptCode.appendChild(document.createTextNode(sourceCode));
  }

  function newRequest () {
    try {
      if (window.XMLHttpRequest) {
         // If IE7, Mozilla, Safari, and so on: Use native object.
         var xhr = new XMLHttpRequest();
         return xhr;
      }
      else {
        if (window.ActiveXObject) {
          return new ActiveXObject(httpImplementation);  
        }
        else {
          var error = new xfilesException('SoapManager.newRequest',5, null, null);
          error.setDescription("Browser cannot instantiate an XMLHTTPRequest object");
          throw error;
        }      
      }
    }
    catch (e)  {  
      var error = new xfilesException('SoapManager.newRequest',3, null, e);
      throw error;
    }
  }
  
	function createRequest(method,targetURL,mode, user, pwd) {

  	asynchronousMode = true;
  	if (typeof mode != "undefined") {
    	asynchronousMode = mode;
 		}
    
    var XHR = newRequest();
    
    if ((typeof user == "undefined") || (typeof pwd == "undefined")) {
      XHR.open (method, targetURL, asynchronousMode);
    }
    else {
      XHR.open (method, targetURL, asynchronousMode, user, pwd);
    }
    // IE 10.0 : Specify we require XMLDocument not (HTML) Document objects
    if (useMSXML) {
      try { XHR.responseType =  'msxml-document'; } catch(e){}
    }
    return XHR;
  }
  
  this.addLogEntry = function(logEntry) {
  	logger.push(logEntry);
  }
  
  this.removeLogEntry = function(logEntry) {
  	for (var i = logger.length -1; i>=0;i--) {
  		if (logger[i] == logEntry) {
  			logger.splice(i,1);
  			break;
  	 	}
  	}
 	}
  
  this.getRequestXML = function() {
  	return logger[logger.length-1][1]
  }
  
  this.getResponseXML = function() {
  	return logger[logger.length-1][2]
  }

  this.getQuery = function() {
  	return logger[logger.length-1][3]
	}

  this.newRequest = function () {
  	return newRequest();
  }
  
  this.createPostRequest = function (url, async, user, pwd) {
    var XHR = createRequest("POST", url, async, user, pwd);
    return XHR;
	} 

  this.createPutRequest = function (url, async, user, pwd) {
    var XHR = createRequest("PUT", url, async, user, pwd);
    return XHR;
	} 
	 
  this.createHeadRequest = function (url, async, user, pwd) {
    var XHR = createRequest("HEAD", url, async, user, pwd);
    return XHR;
	} 

  this.createDeleteRequest = function (url, async, user, pwd) {
    var XHR = createRequest("DELETE", url ,async, user, pwd);
    return XHR;
	} 

  this.createGetRequest = function (url, async, user, pwd) {
    var XHR = createRequest("GET",url, async, user, pwd);
    return XHR;
	}
              
  this.sendSoapRequest = function (requestManager, args, xargs, queryType) {
  
    var namespace = requestManager.getServiceNamespace()
    var requestDocument = requestManager.newRequestDocument()
  
	  var serviceNamespaceList = { "tns" : namespace }
	  var serviceNamespaces = new namespaceManager(serviceNamespaceList);
	 
	  if (typeof args == "object") { 
	    for (var i in args) {
	  	  var arg = requestDocument.selectNodes('//tns:' + i, serviceNamespaces).item(0);
	  	  if (arg == null) {
          var error = new xfilesException("SoapManager.sendSoapRequest",15,requestManager.getServiceLocation(),null);
          error.setDescription("Invalid Parameter : " + i);
          error.setXML(requestDocument);
          throw error;
	  	  }
	  	  if (args[i] != null) {
	  	  	var text;
	  	    if ((typeof(args[i]) == "string") && (args[i].indexOf('<') > -1)) {
  	  	    text = requestDocument.createCDATASection(args[i]);
  	  	  }
  	  	  else {
	    	    text = requestDocument.createTextNode(args[i]);
	  	    }  	    
	  	    arg.appendChild(text);
	  	  }
	    }
    }
    
    if (typeof xargs == "object") {
	    for (var i in xargs) {
	  	  var arg = requestDocument.selectNodes('//tns:' + i, serviceNamespaces).item(0);
	  	  if (arg == null) {
          var error = new xfilesException("SoapManager.sendSoapRequest",15,requestManager.getServiceLocation(),null);
          error.setDescription("Invalid Parameter : " + i);
          error.setXML(requestDocument);
          throw error;
	  	  }
	  	  while (arg.hasChildNodes()) {
	  	  	arg.removeChild(arg.firstChild); 
	  	  }
	  	  arg.appendChild(requestDocument.importNode(xargs[i].getDocumentElement(),true));
	    }
    }
    
    // Check for executing an XQuery via ORAWSV query service
    
    if (namespace == orawsvPrefixList["orawsv"]) {
      if (queryType == "XQUERY") {
      	var arg = requestDocument.selectNodes("//tns:query_text", serviceNamespaces).item(0);
      	arg.setAttribute("type","XQUERY");
      }
      
      // Log Dynamic XQuery or SQL  
  	  var logRequestManager = self.getRequestManager("XFILES","XFILES_LOGGING","LOGQUERYSERVICE");
  	  var XHR = logRequestManager.createPostRequest(false);
  
  	  var parameters = new Object;
  	  var xparameters = new Object;
  	  xparameters["P_SOAP_REQUEST-XMLTYPE-IN"] = requestDocument;
      logRequestManager.sendSoapRequest(parameters,xparameters);
      var logResponse = logRequestManager.getSoapResponse(logRequestManager);
      /*
      */
    }
    
    requestManager.send(requestDocument); 

  }

  this.getSoapResponse = function(requestManager,callingModule) {
  
    var module     = 'SoapManager.getSoapResponse';
    var error;
  
    if (callingModule) {
      module = callingModule;
    }

    var XHR = requestManager.getXMLHttpRequest();
    
    if (XHR.status == 0) {
    	// Backend Server Crash ?
      var error = new xfilesException(module,3, null, null);
      error.setDescription('XMLHTTPRequest return code 0. Please check alert log for possible shared server crash.');
      error.setNumber(XHR.status);
      throw error;
    }
 
    if (XHR.status != 200) {
      var error = new xfilesException(module,3, null, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status);
      throw error;
    }
  
  	var tnsNamespaces = orawsvNamespaces
  	tnsNamespaces.redefinePrefix("tns",requestManager.getServiceNamespace());

    var soapResponse;

    /*
    **
    ** Check for Malformed Response documents. 
    ** IE returns an empty document (Document with no root node)
    ** Firefox and Chrome return a null XML document.
    **
    */

    if ((XHR.responseXML != null) && (XHR.responseXML.childNodes.length > 0)){   
    	soapResponse = new xmlDocument(XHR.responseXML,xmlDocument.ResponseXML,tnsNamespaces);
    }
    else {
    	if (XHR.responseText != null) {
        var error = new xfilesException(module,15,requestManager.getServiceLocation(),null);
        error.setDescription("ResponseXML is null : Possible malformed response ?");
        error.setContent(XHR.responseText);
        throw error;
      }
      else {
        var error = new xfilesException(module,15,requestManager.getServiceLocation(),null);
        error.setDescription("Soap Error : ResponseXML and ResponseText both NULL");
        error.setXML(soapResponse);
        throw error;
      }
    }
    
    var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors");
    if (nodeList.length > 0) {

    	/*
    	**
    	** Add code to check for incorrect URL : User may not be authorized for Web Services
    	** Error Code 6 will force correct display of Server Side Error Message.
    	**
    	*/
    	
      var error = new xfilesException(module,6,requestManager.getServiceLocation(),null);
      error.setDescription("Soap Fault");
      error.setXML(soapResponse);
      var nl = soapResponse.selectNodes("/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors/oraerr:OracleError[2]");
      if (nl.length > 0) {
        error.setSQLErrCode(soapResponse.selectNodes("/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors/oraerr:OracleError[2]/oraerr:ErrorNumber").item(0).firstChild.nodeValue);
        error.setSQLErrMsg(soapResponse.selectNodes("/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors/oraerr:OracleError[2]/oraerr:Message").item(0).firstChild.nodeValue);
      }
      throw error;
    }
    
    var nodeList = soapResponse.selectNodes(requestManager.getOutputXPath());
    if (nodeList.length == 1) {
      return soapResponse;
    }

    var error = new xfilesException(module,15,requestManager.getServiceLocation(),null);
    error.setDescription("Unexpected Soap Response");
    error.setXML(soapResponse);
    error.setContent(XHR.responseText);
    throw error;

  }

  this.executeSQL =  function (requestManager,query) {
  	
	  var parameters = new Object;
	  parameters["query_text"]  = query;
	  parameters["null_handling"]   = "EMPTY_TAG"
	  parameters["pretty_print"] = "true" 
	
    self.sendSoapRequest(requestManager,parameters,null,"SQL");

  }

  this.executeXQuery =  function (requestManager,query) {
  	
	  var parameters = new Object;
	  parameters["query_text"]  = query;
	  parameters["null_handling"]   = "EMPTY_TAG"
	  parameters["pretty_print"] = "true" 
	
    self.sendSoapRequest(requestManager,parameters,null,"XQUERY");

  }
  
  this.getRequestManager = function(schema, packageName, method) {
  
    if (getHttpUsername() == 'ANONYMOUS') {
      var error = new xfilesException('common.soapRequestManager',15, null, null);
      error.setDescription('Soap Services only available to Authenticated Users.');
      throw error;
    }
    else {
    	if (wsdlCache == null) {
        wsdlCache = new WsdlCache();
        logger = new Array();
      }          		
    }
  
    var wsdlDetails = wsdlCache.getWSDL(schema, packageName, method);
    return new RequestManager(self,new WSDLManager(wsdlDetails));
  }
  
  this.signOff = function() {
  	wsdlCache = null;
  	logger = null;
 	}
}

var domImplementation   = "Msxml2.FreeThreadedDOMDocument.6.0";  
var httpImplementation  = "Msxml2.XMLHTTP.6.0"; 
var xslImplementation   = "Msxml2.XSLTemplate.6.0"; 
var resolveExternals    = true;

// No support for earlier versions of MSXML : document.importNode() not available
  
//  var domImplementation  = "Msxml2.FreeThreadedDOMDocument"; 
//  var httpImplementation = "Msxml2.XMLHTTP";
//  var xslImplementation  = "Msxml2.XSLTemplate";
//  var resolveExternals   = true;

//  var domImplementation  = "Msxml2.FreeThreadedDOMDocument.4.0";
//  var httpImplementation = "Msxml2.XMLHTTP.4.0";
//  var xslImplementation  = "Msxml2.XSLTemplate.4.0";
//  var resolveExternals   = false;

var dialogClosers = new Array();
var xslProcessorCache = new Array();

var useMSXML = browserSupportsActiveXObjects();
// var useMSXML = !browserImplementsXSLTProcessor();
var isORDS = !isOracleRDBMS()

var timezoneOffset = 0;
var cacheResult = 0;
var includeMetadata = false;

var httpUsername = "ANONYMOUS";

var httpStateAuthenticated = 1;
var httpStateUnauthenticated = 0;
var httpStateUnauthorized = -1;
var currentHttpState = httpStateUnauthenticated;

var fixedWSDLCache

// Dynamic Functions

var handleException;
var showSourceCode;
var openDialog
var closeDialog
var openPopupDialog
var closePopupDialog
var closeCurrentForm
var reloadForm
var viewXML
var viewXSL
var viewSOAPRequest
var viewSOAPResponse

var uploadSuccessCallback;
var uploadFailedCallback;

var orawsvNamespaces;

var orawsvPrefixList = {
      'soap'   : 'http://schemas.xmlsoap.org/soap/envelope/',
      'oraerr' : 'http://xmlns.oracle.com/orawsv/faults',
      'orawsv' : 'http://xmlns.oracle.com/orawsv'
    };

var errStackXSLSource = 
'  <xsl:stylesheet version="1.0" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:oraerr="http://xmlns.oracle.com/orawsv/faults" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xdbpm="http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_HELPER">' + '\n' +
'  	<xsl:output indent="yes" method="html"/>' + '\n' +
'  	<xsl:template match="/">' + '\n' +
'  		<xsl:for-each select="//oraerr:OracleErrors[oraerr:OracleError]">' + '\n' +
'  			<xsl:for-each select="oraerr:OracleError">' + '\n' +
'  				<B>' + '\n' +
'  					<xsl:value-of select="oraerr:ErrorNumber"/>' + '\n' +
'  					<xsl:text>:</xsl:text>' + '\n' +
'  					<xsl:value-of select="oraerr:Message"/>' + '\n' +
'  				</B>' + '\n' +
'  				<xsl:if test="position() != last()">' + '\n' +
'  					<BR/>' + '\n' +
'  				</xsl:if>' + '\n' +
'  			</xsl:for-each>' + '\n' +
'  		</xsl:for-each>' + '\n' +
'  	</xsl:template>' + '\n' +
'  </xsl:stylesheet>';

var errStackXSL


var TargetTreeXSL;

function loadTargetTreeXSL() {
  TargetTreeXSL = loadXSLDocument("/XFILES/lite/xsl/folderTree.xsl");
}

function loadOracleWebServiceNamespaces() {
  orawsvNamespaces = new namespaceManager(orawsvPrefixList);
}

function htmlEncode( html ) {
    return document.createElement( 'temp' ).appendChild( document.createTextNode( html ) ).parentNode.innerHTML;
};

function initAjaxServices() {

  loadOracleWebServiceNamespaces();
  setHttpUsername();
  
}	

function isXDBHTTPServer(XHR) {
	
	var DAVServerInfo = XHR.getResponseHeader("DAV");
	if (DAVServerInfo != null) {
		if (DAVServerInfo == "1,2,<http://www.oracle.com/xdb/webdav/props>") {
			return true;
	  }
	}
	
	return false;
}

function isOracleRDBMS() {

   var XHR = soapManager.createHeadRequest("/",false);
   XHR.send();
   return isXDBHTTPServer(XHR);

}	

function browserSupportsActiveXObjects() {
	
  var result;
  try {
	  var object = new ActiveXObject(domImplementation); 
	  result = true;
	} catch (e) {
		result = false;
  }
  return result;
}


function browserImplementsXSLTProcessor() {
	
	/*
	**
	** Test if the Browser implements XSLTProcessor()
	**
	** Firefox, Chrome and Safari all provide a native XSLTProcessor object that can perform XSLT transformations on
	** Browser's native DOM Class
	**
	** IE does not provide a native XSLTProcessor object, which means IE must instantiate the MSMXL XSLT processor. 
	** The MSMXL processor cannot work with the native XMLDocument class implemented in IE 10 and later. 
	** Consequently all XML Processing in IE must be done with the MSXML classes rather than the native DOM.
	** This provides a reasonably reliable way of detecting all versions of IE upto and including IE 11.
	**
	*/ 
	
	try {
		var processor = new XSLTProcessor();
		return true;
  }
  catch (e) {
  	return false;
  }
	
}

function browserSupportsXSLInclude() {
	
	/*
	**
	** Test if the Browser Native XSLT Engine support include, import and document
	** Currently Chrome will fail this test, which means XSL processing must fall
	** back to the server in the event the client side transform fails.
	**
	*/

  xslText = '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">' 
          + '    <xsl:output method="text"/>'
          + '    <xsl:include href="/XFILES/lite/xsl/common.xsl"/>'
          + '    <xsl:template match="/">'
          + '       <xsl:for-each select="/Result">'
	        + '          <xsl:value-of select="."/>'
          + '       </xsl:for-each>'
          + '    </xsl:template>'
          + ' </xsl:stylesheet>';

  var xmlText = '<Result>Success</Result>';

	if (useMSXML) {
		/*
	  **
	  ** Browser is Internet Explorer : native XSL Transformation is supported
	  **
	  */ 
	  return true;
  }
 	else {
    var parser = new DOMParser();
    var processor = new XSLTProcessor();
    processor.importStylesheet(parser.parseFromString(xslText,"text/xml")); 
    var target = document.implementation.createDocument("","",null); 
    var result = processor.transformToFragment(parser.parseFromString(xmlText,"text/xml"),target);
    if (result != null) {
      /*
	    **
	    ** Browser is Probably Firefox : native XSL Transformation and xsl:include are supported
	    **
	    */ 
	    return true;
    }
    else {
      /*
	    **
	    ** Browser does not appear to support XSL Transformation with xsl:include. Safari and EDGE ?
	    **
	    */ 
   	}
   	return false;
  }
}

function initCommon() {
    
  tzBase = new Date().getTimezoneOffset();
  timezoneOffset = (tzBase / 60) * -1;
  handleException  = xfilesHandleException;

  createErrorDialog();      
  initAjaxServices();

  if (!browserSupportsXSLInclude()) {
  	cacheResult = 1;
  }
      
  errStackXSL   = new xmlDocument().parse(errStackXSLSource);
  
  // Check if the current session is authenticated to allow for REST/SOAP descisions when loading pages

	loadTargetTreeXSL();
   
}
   
function showErrorMessage (message,url,callback) {
  dialogOptions =     {
    title: 'ERROR',
    message: message,
    type: BootstrapDialog.TYPE_DANGER,
    closable: false,       
    buttons:[
      {
        label: 'OK',
        action: function(dialog) {
          typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(true);
          dialog.close();
        }
      }
    ]
  }
    
  if (typeof url == "string") {
 	 dialogOptions.title = dialogOptions.title + ":" + url
  }
   
  if ( typeof callback === 'function' ) {
    dialogOptions.onhidden = callback;
  }

  BootstrapDialog.show(dialogOptions);
}

function showUserErrorMessage (message,url,callback) {
  dialogOptions =     {
    title: 'USER ERROR',
    message: message,
    type: BootstrapDialog.TYPE_DANGER,
    closable: false,       
    buttons:[
      {
        label: 'OK',
        action: function(dialog) {
          typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(true);
          dialog.close();
        }
      }
    ]
  }
    
  if (typeof url == "string") {
 	 dialogOptions.title = dialogOptions.title + ":" + url
  }
   
  if ( typeof callback === 'function' ) {
    dialogOptions.onhidden = callback;
  }

  BootstrapDialog.show(dialogOptions);
}

function showSuccessMessage(message,callback) {

 var dialogOptions =     {
 		title: 'SUCCESS',
 		message: message,
 		type: BootstrapDialog.TYPE_SUCCESS,
 		closable: true
	}

 if ( typeof callback === 'function' ) {
   dialogOptions.onhidden = callback;
	}

 BootstrapDialog.show(dialogOptions);

}

function showInformationMessage(message,callback) {
 
 var dialogOptions =     {
	title: 'INFORMATION',
 		message: message,
 		type: BootstrapDialog.TYPE_INFO,
 		closable: true
	}

  if ( typeof callback === 'function' ) {
	  dialogOptions.onhidden = callback;
  }

	BootstrapDialog.show(dialogOptions);
}


function showInfoMessage(message) {
	/* Use Bootstrap Style message */
	showInformationMessage(message);
}

function showWarningMessage(message,callback) {
 
 var dialogOptions =     {
	title: 'WARNING',
 		message: message,
 		type: BootstrapDialog.TYPE_WARNING,
 		closable: true
	}

  if ( typeof callback === 'function' ) {
	  dialogOptions.onhidden = callback;
  }

	BootstrapDialog.show(dialogOptions);
}


function unsupportedFeature(message) {
  showWarningMessage("Unsupported Feature : " + message);
}

function unimplementedFunction(message) {
	showWarningMessage("Unimplemted Function : " + message);
}

function showPageContent() {
	
  var pageLoading = document.getElementById('pageLoading');
  pageLoading.style.display="none";
  var greyLoading = document.getElementById('greyLoading');
  greyLoading.style.display="none";
  var pageContent = document.getElementById('pageContent');
  pageContent.style.display="block";

}

function setPageActive() {

  // var pageStatusIcon = document.getElementById('pageStatusIcon');
  // pageStatusIcon.src = '/XFILES/lib/icons/pageReady.png';
  showPageContent();
  onPageLoaded();

}
   
function loadScripts() {

  var head = document.getElementsByTagName('head').item(0);
  var scriptList = document.getElementById('localScriptList');
  if (scriptList) {
    var scriptEntry = scriptList.firstChild;

    while (scriptEntry) {
      var scriptLocation = scriptEntry.firstChild.nodeValue;
      script = document.createElement("script");
      script.language = 'javascript';
      script.type= 'text/javascript';
      script.defer = true; 
      var scriptContent = getDocumentContent(scriptLocation);
      script.text = scriptContent;

      // script.src == scriptLocation;

      head.appendChild(script);
  	  scriptEntry = scriptEntry.nextSibling;
  	}


  }

  setPageActive();

}

function webkitLoadXSLDocument(targetURL) {
/*
**
** Hack for Chrome not supporting include or import statements in XSL. 
** Use a REST Service to fetch the XSL. The REST Service will inline
** any INCLUDE directives in the target XSL.
**
*/

/*
**
** Hack is a non-starter since in addition to not supporting xsl:include and xsl:import Chrome does not support loading a variable via the document() function
** Revert to the standard loadXMLDocument() function and force server side transformation.
**
*/

  return loadXMLDocument(targetURL);

/*
**
**  if (!isAuthenticatedUser()) {
**  	var url = "/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.XSLINLINEINCLUDE?P_XSL_PATH=" + encodeURIComponent(targetURL);
**  }
**  else {
**  	var url = "/sys/servlets/XFILES/Protected/XFILES.XFILES_REST_SERVICES.XSLINLINEINCLUDE?P_XSL_PATH=" + encodeURIComponent(targetURL);
**  }
**
**   try {
**     var XHR = new window.XMLHttpRequest();
**     XHR.open("GET", url ,false);
**     XHR.send(null);
** 	   if (XHR.status == 200) {
**       var result = new xmlDocument(XHR.responseXML,xmlDocument.ResponseXML);
**       result.sourceURL = targetURL;
**       return result;
**     }
**     else {
**       var error = new xfilesException('common.webkitLoadXSLDocument',8, url, null);
**  	   error.setDescription('Error generating in-lined XSL for WebKit based Browser : HTTP Status = ' + XHR.status + " (" + XHR.statusText + ")");
**    	 throw error;
**     }
**   }
**   catch (e) {
**       var error = new xfilesException('common.webkitLoadXSLDocument',8, url, null);
**  	   error.setDescription('Error generating in-lined XSL for WebKit based Browser.');
**    	 throw error;
**   }
**
*/ 
}

function loadXSLDocument(targetURL) {
	
  try {
    if (!window.chrome) {
   	  return loadXMLDocument(targetURL);
   	}
   	else {
   		return webkitLoadXSLDocument(targetURL);
    }
  }
  catch (e) { 
    var error = new xfilesException('common.loadXSLDocument',7, targetURL, e);
    throw error;
  }

}

function loadXMLDocument(targetURL) {

  // doc.load directly from the repository.
    
  try {
    return new xmlDocument().load(targetURL);
  }
  catch (e) { 
    var error = new xfilesException('common.loadXMLDocument',7, targetURL, e);
    throw error;
  }
 
}

function getXMLDocument(targetURL) {

  try {
    targetURL = targetURL.replace(/\\/g,"/");
    var XHR = soapManager.createGetRequest(targetURL);
    XHR.send(null);
    if (XHR.status != 200) {
      var error = new xfilesException('common.getXMLDocument',3, targetURL, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status);
      throw error;
    }
    return new xmlDocument(XHR.responseXML,xmlDocument.ResponseXML);
  }
  catch (e) {  
    var error = new xfilesException('common.getXMLDocument',7, targetURL, e);
    throw error;
  }
}

function deleteXMLDocument(targetURL) {
  try {
    targetURL = targetURL.replace(/\\/g,"/");
    var XHR = soapManager.createDeleteRequest(targetURL,false);
    XHR.send(null);
    if ((XHR.status != 201) && (XHR.status != 204) && (XHR.status != 207) && (XHR.status != 404)) {
      var error = new xfilesException('common.getXMLDocument',3,targetURL, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status);
      throw error;
    }
    return;
  }
  catch (e)  {  
    var error = new xfilesException('common.deleteXMLDocument',7, targetURL, e);
    throw error;
  }
}

function getResourceXML(resourceURL, includeContent) {

  try {
  	var schema          = "XFILES";
    var packageName = "XFILES_SOAP_SERVICES";
    var method;

    if (includeContent) {
	    method =  "GETRESOURCEWITHCONTENT";
	  }
    else {
	    method =  "GETRESOURCE";
  	}
	
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
   	var XHR = mgr.createPostRequest(false);

	  var parameters = new Object;
  	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resourceURL
		parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset 
    parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  		
    mgr.sendSoapRequest(parameters);    

    var soapResponse = mgr.getSoapResponse('common.getResourceXML()');

	  var namespaces = orawsvNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_RESOURCE/res:Resource",namespaces);
    if (nodeList.length == 1) {
      var resource = new xmlDocument();
      var node = resource.appendChild(resource.importNode(nodeList.item(0),true))
      resource.sourceURL = resourceURL;
      return resource;
    }
     
    var error = new xfilesException('common.getResourceXML',12,resourceURL,null);
    error.setDescription("Invalid Resource Document."); 
    error.setXML(soapResponse);
    throw error;
  }
  catch (e) {
    var error = new xfilesException('common.getResourceXML',7,resourceURL,e);
    error.setDescription("Unable to load Document");
    throw error;
  }
}

function getDocumentContentImpl ( targetURL ) {

  targetURL = targetURL.replace(/\\/g,"/");
  var XHR = soapManager.createGetRequest(targetURL,false);
  XHR.send(null);
  if (XHR.status != 200) {
    var error = new xfilesException('common.getDocumentContentImpl',3,targetURL,null);
    error.setDescription(XHR.statusText);
    error.setNumber(XHR.status);
    throw error;
  }
  return XHR.responseText;
}


function getDocumentContent ( targetURL ) {
  try {
    return getDocumentContentImpl(targetURL);
  }
  catch (e) {
    var error = new xfilesException('common.getDocumentContent',7, targetURL, e);
    throw error;
  }
}

function concatentateTextNodes(result) {
	
	// FF appears to chop the result up into 4K chunks
	// Cannot use an XMLSerializer() : Formatting is lost
	
	var text = "";
  var textNode = result.firstChild;
  while (textNode) {
    text += textNode.nodeValue;
    textNode = textNode.nextSibling
  }
  return text;
  
}

function loadOption(optionList, optionDefinition, initialValue) {
	
	
	/*
	** 
	** The select clause should return a rowset consisting of either a a single column which will act as name, value and id, 
	** or a triple consisting of columns called NAME, VALUE, ID
	**
	** In Firefox or Mozilla we need to remove text Nodes from the result set before processing it..
	*/
  
  for (var i=optionDefinition.childNodes.length; i > 0; i--) {
    if (optionDefinition.childNodes[i-1].nodeType == nodeTypeText) {
    	optionDefinition.removeChild(optionDefinition.childNodes[i-1]);
    }
	}
	
	if (optionDefinition.firstChild) {
		
		var value
		var id
		var name
	
    child = optionDefinition.firstChild;
 
    if (optionDefinition.childNodes.length == 1) {
			value    = child.firstChild.nodeValue
			id       = child.firstChild.nodeValue
			name     = child.firstChild.nodeValue
    }
    else {
    	while (child) {
    		if (child.nodeType == nodeTypeElement) {
      		if (child.nodeName=="NAME") {
      			name = child.firstChild.nodeValue;
          }
    	  	if (child.nodeName=="VALUE") {
    		  	value = child.firstChild.nodeValue;
          }
    		  if (child.nodeName=="ID") {
    		  	id = child.firstChild.nodeValue;
          }
        }
			  child = child.nextSibling;
			}
			if (!value) {
				value = name;
		  }
		  if (!id) {
		  	id = value;
		  }
		}

    option = document.createElement("option");
    optionList.appendChild(option);       

    var text = document.createTextNode(name);
    option.appendChild(text);
    width = name.length
    
    option.value = value;
    option.id    = id;
    
    if (option.value == initialValue) {
    	option.selected = "selected";
    }
    
    return width
  }
  else {
  	return 0
  }
}

function loadOptions(selectControl,optionList,resultSet,initialValue,addEmptyOption) {

   selectControl.disabled = true;
   optionList.innerHTML = "";
   var width = 0;
   
	 if (addEmptyOption) {
     var option = document.createElement("option");
     option.value     = "";
     option.id        = "";
     if (initialValue == null) {
       option.selected  = "selected";
     }
     optionList.appendChild(option);      
   }
   
 	 if (resultSet.length > 0) {
 		
     
     for (var i = 0; i < resultSet.length; i++) {
       var optionDefinition = resultSet.item(i);
       optionWidth = loadOption(optionList,optionDefinition,initialValue);
       if (width < optionWidth) {
         width = optionWidth;
       }
     }
     
     selectControl.width = width;
     selectControl.disabled = false;
     
   }
}

function loadOptionList(mgr,selectControl,optionList,initialValue,addEmptyOption,allowEmptyList) {
	
	if (typeof addEmptyOption != "boolean") {
		addEmptyOption = true;
	}
	
	if (typeof allowEmptyList != "boolean") {
		allowEmptyList = true;
  }
	
	if (typeof initialValue == "undefiend") {
		initialValue = null;
  }
  	
	try {
    var soapResponse = mgr.getSoapResponse('common.loadOptionList()');  
    var namespaces = orawsvNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET/orawsv:ROW",namespaces );
    
    if ((resultSet.length == 0) && (!allowEmptyList)) {
      var error = new xfilesException("common.loadOptionList",12,null, null);
      error.setDescription("Invalid Option List Document Receieved");
      error.setXML(soapResponse);
      throw error;
    }
    
    loadOptions(selectControl, optionList, resultSet,initialValue,addEmptyOption);

  } 
  catch (e) {
    handleException('common.loadOptionList',e,null);
  }
   
}

function convertSQLToHTML(statement) {

  statementHTML = statement;
  statementHTML = statementHTML.replace(/&/g,'&amp;');
  statementHTML = statementHTML.replace(/</g,"&lt;");
  statementHTML = statementHTML.replace(/>/g,"&gt;");
  // statementHTML = statementHTML.replace(/"/g,"&quot;");
  statementHTML = statementHTML.replace(/(\r\n|\r|\n)/g, "<br/>");
  statementHTML = statementHTML.replace(/\s/g,"&nbsp;");
  statementHTML = statementHTML + "<BR/>";
  return statementHTML;
}



function prettyPrintXML(xml, target) {
   
   if (typeof target == "string") {
     xmlPP.print(xml, document.getElementById(target));
   }
   else {
   	 xmlPP.print(xml,target);
   }

}

function prettyPrintXMLElement(xml, target) {
	
  if (typeof target == "string") {
    xmlPP.printXMLElement(xml, document.getElementById(target));
  }
  else {
    xmlPP.printXMLElement(xml,target);
  }

}

function prettyPrintXMLColumn(xml, target) {
	
	// Use when printing an XML column in a result set.
	// Swallows the tag that generated from the column name
	
  if (typeof target == "string") {
    xmlPP.printXMLColumn(xml, document.getElementById(target));
  }
  else {
    xmlPP.printXMLColumn(xml,target);
  }

}
	
function prettyPrintJSONColumn(json, target) {
	
	// Use when printing an XML column in a result set.
	// Swallows the tag that generated from the column name
	
  if (typeof target == "string") {
    jPP.printJson(document.getElementById(target),null,json);
  }
  else {
    jPP.printJson(target,null,json);
  }

}

function prettyPrintXMLFragment(xml, target) {
   
   if (typeof target == "string") {
     xmlPP.printFragment(xml, document.getElementById(target));
   }
   else {
   	 xmlPP.printFragment(xml,target);
   }

}

function prettyPrintRootFragment(xml, target) {
   
   if (typeof target == "string") {
     xmlPP.printRootFragment(xml, document.getElementById(target));
   }
   else {
   	 xmlPP.printRootFragment(xml,target);
   }

}
  
function appendHTML (html,target,appendMode) {

  /*
  **
  ** Display the html by appending it to the targetNode.
  **
  ** The appendMode parameter controls wether or not the html replaces the current content of the target
  **
  ** In IE the html is always a string so it appended to the innerHTML property of the target node.
  **
  ** In Firefox and Chrome check the type of the generated html.
  ** If the html is an instance of string display it by appending it to innerHTML property of the target node.
  ** If the html is an instance of document fragment display it by invoking the appendChild() method of the target node.
  **
  */
  
  if ((!appendMode) || (appendMode == false)) {
    target.innerHTML = "";
  }
   
  if (useMSXML) {   
   	try {
       target.innerHTML = target.innerHTML + html;
    }
    catch (e) {
      var error = new xfilesException('common.appendHTML',10,xml.sourceURL,e);
      error.setDescription("Error while appending to innerHTML of " + htmlContent.nodeName + " to " + target.nodeName + ".");
      throw error;   
    }
  }
  else {
  // Manage errors related to appending invalid HTML with FireFox
    try {
    	if (typeof html === "string") {
       target.innerHTML = target.innerHTML + html;
      }
      else {
        target.appendChild(html);
      }
    }
    catch (e) {
      var error = new xfilesException('common.appendHTML',10,null,e);
      if (e.name == 'NS_ERROR_DOM_HIERARCHY_REQUEST_ERR') {
        error.setDescription("NS_ERROR_DOM_HIERARCHY_REQUEST_ERR : Cannot append instance of " + html.nodeName + " to " + target.nodeName + ".");
      }
      else {
        error.setDescription("Generic Error while appending instance of " + html.nodeName + " to " + target.nodeName + ".");
      }
      throw error;   
    }
  }
}

function remoteTransformContent(resourceURL,xslPath) {

  // Server-Side XSL Transformation of the content XML document. 
  // Using REST enables server side based XSL transformation for anonymous users.
  // Output is not necessarily well formed XML
  
  try {
      
    var restURL = '/sys/servlets/XFILES/';
  	if (isAuthenticatedUser()) {
      restURL += 'Protected/';
    }
    else {
    	restURL += 'RestService/';
    }
    restURL += 'XFILES.XFILES_REST_SERVICES.TRANSFORMCONTENTTOHTML?P_RESOURCE_PATH=' + encodeURIComponent( resourceURL ) + '&P_XSL_PATH=' + encodeURIComponent(xslPath)

 		var XHR = soapManager.createGetRequest(restURL,false);
 	  XHR.mozBackgroundRequest = true;
    XHR.send(null);
  	if (XHR.status != 200) {
      var error = new xfilesException('common.remoteTransformContent',8, restURL, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.statusText);
      throw error;
    }
    return XHR.responseText;
  }
  catch (e) {
    var error = new xfilesException('common.remoteTransformContent',10, resource.sourceURL, e);
    throw error;    
  }
}

function remoteTransformCache(guid,xslPath) {

  // Server-Side XSL Transformation of a document that has been cached on the server
  // Using REST enables server side based XSL transformation for anonymous users.
  // Output is not necessarily well formed XML
  
  // Legacy : htmlFromCache
  
  try {
      
    var restURL = '/sys/servlets/XFILES/';
  	if (isAuthenticatedUser()) {
      restURL += 'Protected/';
    }
    else {
    	restURL += 'RestService/';
    }
    restURL += 'XFILES.XFILES_REST_SERVICES.TRANSFORMCACHETOHTML?P_GUID=' + encodeURIComponent( guid ) + '&P_XSL_PATH=' + encodeURIComponent(xslPath)

 		var XHR = soapManager.createGetRequest(restURL,false);
 	  XHR.mozBackgroundRequest = true;
    XHR.send(null);
  	if (XHR.status != 200) {
      var error = new xfilesException('common.remoteTransformCache',8, restURL, null);
      error.setDescription(XHR.statusText);
      error.setNumber(XHR.status); 
      throw error;
    }
    return XHR.responseText;
  }
  catch (e) {
    var error = new xfilesException('common.remoteTransformCache',10, resource.sourceURL, e);
    throw error;    
  }
}

function remoteTransformXMLTypeToXHTML(xml,xslPath) {

  // Server-Side XSL Transformation of an document that is not available on the server
  // Result of the transformation is expected to be a valid XML document 
  // Output of transformation is expected to be well formed XML
  // Ouptut is returned as text node. 

  // Use SOAP since we need to send the document to be transformed.
  // Since this requires a POST operation it cannot be enabled for anonynous since POST operations
  // are not supported for anonymous users.

  try {
     
	  if (isAuthenticatedUser()) {
      var schema          = "XFILES";
      var packageName = "XFILES_SOAP_SERVICES";
      var method      =  "TRANSFORMDOCUMENT1";
  
    	var mgr = soapManager.getRequestManager(schema,packageName,method);
     	var XHR = mgr.createPostRequest(false);

  	  var parameters = new Object
    	parameters["P_XSL_PATH-VARCHAR2-IN"]   = xslPath;
 
    	var xparameters = new Object;
  	  xparameters["P_XML_DOCUMENT-XMLTYPE-IN"]   = xml
  		
      mgr.sendSoapRequest(parameters,xparameters);   
 
      var soapResponse = mgr.getSoapResponse('common.remoteTransformXMLType');
 
   	  var namespaces = xfilesNamespaces
  	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  	
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:XMLTRANSFORM",namespaces);
      return nodeList.item(0).firstChild.nodeValue;
      // return nodeList.item(0).firstChild.nextSibling;
    }
    else {
      var error = new xfilesException('common.remoteTransformXMLType',9, xslPath, e);
      error.setDescription('Remote XSL Transformation only supported for authenticated users.');
      throw error;
    }
  }
  catch (e) {  
    var error = new xfilesException('common.transformClientXML',9, xslPath, e);
    error.setDescription('Error invoking remote XSL Transformation via SOAP.');
    throw error;
  }

}


function transformToXHTML(xml,xsl) {
	
	/*
	**
	** Attempt a browser based transformation using the supplied XML and XSL.
	** 
	** If the browser based transformation fails attempt a server based transformation.
	** The most common cause for failure is Chrome when the XSL makes use of the include directive
	**
	** If the XML comes from an XML DB Resource check to see if the resource has been cached. 
	** Documents fetched using the XFILES_REPOSITORY_SERVICES package etc can be cached 
	** on the server at the request of the client. Caching of Resource documents is typically 
	** enabled in environments where browser based transformation is not reliable.
	**
	** If the Resource document has been cached pass the GUID to the cached Resource to the server
	** If the Resource document was not cached pass the URL of the Resource to the server.
	**
	** If the XML was generated on the client or by DBNWS services then pass the entire XML to the server.
  **
  */
  
  var html
  
  try {
    html = xml.transformToHTML(xsl);
  }
  catch (e) {
  	if ((e.rootCauseBrowserXSL) && (e.rootCauseBrowserXSL())) {
      if (xml.isContent()) {
      	// Document is content of an XDB Resource
				html = remoteTransformContent(xml.sourceURL,xsl.sourceURL)
		  }
		  else {
		  	if (xml.isCached()) {
		  		html = remoteTransformCache(xml.getGUID(),xsl.sourceURL)
		    }
		  	else {
		  		html = remoteTransformXMLTypeToXHTML(xml,xsl.sourceURL)
		    }
		  }
  	}	  
	  else {
      var error = new xfilesException('common.transformToXHTML',9,xml.sourceURL,e);
      error.setDescription('Error generating HTML via XSL transformation');
      throw error;
    }
  }
  
  return html;
  
}

function transformXMLtoXHTML(xml,xsl,target,appendMode) {

	/*
	**
	** Transformation the XML using the XSL and append to the target element. 
	** Assume the output of any server based transformation operations will always be valid XHTML.
	**
  */

  // Called from legacy functions
  //    xmlToHTML(target,xml,xsl,appendMode)
  //    documentToXML(target,xml,xsl,appendMode)
  //    contentAsHTML(target,xml,xsl,appendMode)
  
  var html

  try {
    html = transformToXHTML(xml,xsl) 
  }
  catch (e) {
    var error = new xfilesException('common.transformXMLtoXHTML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML via XSL transformation');
    throw error;
  }

  try {
    appendHTML(html,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.transformXMLtoXHTML',9,xml.sourceURL,e);
    error.setDescription('Error appending HTML to target');
    throw error;
  }
}  

function xmlToHTML(target,xml,xsl,appendMode) {
	
	// Legacy entry point
  
  try {
	  transformXMLtoXHTML(xml,xsl,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.xmlToHTML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML');
    throw error;
  }
}
  
function documentToXML(target,xml,xsl,appendMode) {
	
	// Legacy entry point
  
  try {
	  transformXMLtoXHTML(xml,xsl,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.documentToXML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML');
    throw error;
  }
}

function contentAsHTML(target,xml,xsl,appendMode) {
	
	// Legacy entry point
  
  try {
	  transformXMLtoXHTML(xml,xsl,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.contentAsHTML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML');
    throw error;
  }
}
  
function remoteTransformXMLTypeToHTML(xml,xslPath) {

  // Server-Side XSL Transformation of an document that is not available on the server
  // Result of the transformation may not be a valid XML document 
  // Result is returned as a CDATA section,


  // Use SOAP since we need to send the document to be transformed.
  // Since this requires a POST operation it cannot be enabled for anonynous since POST operations
  // are not supported for anonymous users.

  try {
     
	  if (isAuthenticatedUser()) {
      var schema          = "XFILES";
      var packageName = "XFILES_SOAP_SERVICES";
      var method      =  "TRANSFORMDOCUMENTTOHTML1";
  
    	var mgr = soapManager.getRequestManager(schema,packageName,method);
     	var XHR = mgr.createPostRequest(false);
  
  	  var parameters = new Object
    	parameters["P_XSL_PATH-VARCHAR2-IN"]   = xslPath;
  
    	var xparameters = new Object;
  	  xparameters["P_XML_DOCUMENT-XMLTYPE-IN"]   = xml
  		
      mgr.sendSoapRequest(parameters,xparameters);   
  
      var soapResponse = mgr.getSoapResponse('common.remoteXML2HTML');
  
   	  var namespaces = xfilesNamespaces
  	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  	
      nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:output",namespaces);

      /*
      **
      ** Cannot get rid of the CDATA section via DOM traversal 
      **
      ** return nodeList.item(0).firstChild.firstChild.nodeValue;
      **
      ** Get rid of it using String Manipulation
      **
      */
      
      var cdataSection = nodeList.item(0).firstChild.nodeValue;
      return cdataSection.substring(9,cdataSection.length-4);
    }
    else {
      var error = new xfilesException('common.transformClientXMLRemote2',9, xslPath, e);
      error.setDescription('Remote XSL Transformation only supported for authenticated users.');
      throw error;
    }
  }
  catch (e) {  
    var error = new xfilesException('common.transformClientXMLRemote2',9, xslPath, e);
    error.setDescription('Error invoking remote XSL Transformation via SOAP.');
    throw error;
  }
}

function transformToHTML(xml,xsl) {
	
	/*
	**
	** Attempt a browser based transformation using the supplied XML and XSL.
	** 
	** If the browser based transformation fails attempt a server based transformation.
	** The most common cause for failure is Chrome when the XSL makes use of the include directive
	**
	** If the XML comes from an XML DB Resource check to see if the resource has been cached. 
	** Documents fetched using the XFILES_REPOSITORY_SERVICES package etc can be cached 
	** on the server at the request of the client. Caching of Resource documents is typically 
	** enabled in environments where browser based transformation is not reliable.
	**
	** If the Resource document has been cached pass the GUID to the cached Resource to the server
	** If the Resource document was not cached pass the URL of the Resource to the server.
	**
	** If the XML was generated on the client or by DBNWS services then pass the entire XML to the server.
  **
  */
  
  var html
  
  try {
    html = xml.transformToHTML(xsl);
  }
  catch (e) {
  	if ((e.rootCauseBrowserXSL) && (e.rootCauseBrowserXSL()))  {
      html = remoteTransformXMLTypeToHTML(xml,xsl.sourceURL);
  	}	  
	  else {
      var error = new xfilesException('common.transformToHTML',9,xml.sourceURL,e);
      error.setDescription('Error generating HTML via XSL transformation');
      throw error;
    }
  }
  
  return html;
  
}

function transformXMLtoHTML(xml,xsl,target,appendMode) {

	/*
	**
	** Transformation the XML using the XSL and append to the target element. 
	** Use when the output of any server based transformation operations will not be valid XHTML.
	**
  */

  // Called from legacy functions
  //    documentToHTML(target,xml,xsl,appendMode)
  
  var html

  try {
    html = transformToHTML(xml,xsl) 
  }
  catch (e) {
    var error = new xfilesException('common.transformXMLtoHTML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML via XSL transformation');
    throw error;
  }

  try {
    appendHTML(html,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.transformXMLtoHTML',9,xml.sourceURL,e);
    error.setDescription('Error appending HTML to target');
    throw error;
  }
}  

function documentToHTML(target,xml,xsl,appendMode) {
	
	// Legacy entry point
  
  
  try {
	  transformXMLtoHTML(xml,xsl,target,appendMode);
  }
  catch (e) {
    var error = new xfilesException('common.contentAsHTML',9,xml.sourceURL,e);
    error.setDescription('Error generating HTML');
    throw error;
  }
}

function getParameter( name )
{
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var tmpURL = window.location.href;
  var results = regex.exec( tmpURL );
  if( results == null )
    return "";
  else
    return results[1];
}

/*
**
** Clashes with JQuery Function of the same name. Does not appear to be
** used in current code base. 
**

document.getElementsByClassName = function(clsName){
    var retVal = new Array();
    var elements = document.getElementsByTagName("*");
    for(var i = 0;i < elements.length;i++){
        if(elements[i].className.indexOf(" ") >= 0){
            var classes = elements[i].className.split(" ");
            for(var j = 0;j < classes.length;j++){
                if(classes[j] == clsName)
                    retVal.push(elements[i]);
            }
        }
        else if(elements[i].className == clsName)
            retVal.push(elements[i]);
    }
    return retVal;
}
*/

// This code was written by Tyler Akins and has been placed in the
// public domain.  It would be nice if you left this header intact.
// Base64 code from Tyler Akins -- http://rumkin.com

var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

function encode64(input) {
   var output = "";
   var chr1, chr2, chr3;
   var enc1, enc2, enc3, enc4;
   var i = 0;

   do {
      chr1 = input.charCodeAt(i++);
      chr2 = input.charCodeAt(i++);
      chr3 = input.charCodeAt(i++);

      enc1 = chr1 >> 2;
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
      enc4 = chr3 & 63;

      if (isNaN(chr2)) {
         enc3 = enc4 = 64;
      } else if (isNaN(chr3)) {
         enc4 = 64;
      }

      output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) + 
         keyStr.charAt(enc3) + keyStr.charAt(enc4);
   } while (i < input.length);
   
   return output;
}

function decode64(input) {
   var output = "";
   var chr1, chr2, chr3;
   var enc1, enc2, enc3, enc4;
   var i = 0;

   // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
   input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

   do {
      enc1 = keyStr.indexOf(input.charAt(i++));
      enc2 = keyStr.indexOf(input.charAt(i++));
      enc3 = keyStr.indexOf(input.charAt(i++));
      enc4 = keyStr.indexOf(input.charAt(i++));

      chr1 = (enc1 << 2) | (enc2 >> 4);
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
      chr3 = ((enc3 & 3) << 6) | enc4;

      output = output + String.fromCharCode(chr1);

      if (enc3 != 64) {
         output = output + String.fromCharCode(chr2);
      }
      if (enc4 != 64) {
         output = output + String.fromCharCode(chr3);
      }
   } while (i < input.length);

   return output;
}
    
function closeWindow() {
  window.open('','_parent','');
  window.close();
}

function sendRestRequest(XHR) {
   XHR.send(null);
}
  
function stopBubble(evt) {
  evt = (evt) ? evt : ((window.event) ? window.event : "")
  evt.cancelBubble=true;
}


function doOnClick() {
  closePopupDialog();
}

function reportSuccess(mgr, message) {

  var successMessage = 'Operation Successful';
  if (typeof message != "undefined") {
    successMessage = message;
  }

  try {
    var soapResponse = mgr.getSoapResponse('common.reportSuccess()');
    showInfoMessage(successMessage);
    closePopupDialog();
  }
  catch (e) {
    var error = new xfilesException('common.reportSuccess',12, null, e);
    throw error;
  }

} 

function raiseEvent(target,eventName) {
  
  if(document.dispatchEvent) { // W3C
      var oEvent = document.createEvent( "MouseEvents" );
      oEvent.initMouseEvent(eventName, true, true,window, 1, 1, 1, 1, 1, false, false, false, false, 0, target);
      target.dispatchEvent( oEvent );
    }
  else if(document.fireEvent) { // IE
    target.fireEvent("on" + eventName);
  }    
}

var resizeImage = function(img, maxh, maxw) {
  var ratio = maxh/maxw;
  if (img.height/img.width > ratio){
     // height is the problem
    if (img.height > maxh){
      img.width = Math.round(img.width*(maxh/img.height));
      img.height = maxh;
    }
  } else {
    // width is the problem
    if (img.width > maxh){
      img.height = Math.round(img.height*(maxw/img.width));
      img.width = maxw;
    }
  } 
}

function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
  	do {
	 		curleft += obj.offsetLeft;
			curtop += obj.offsetTop;
    } while (obj = obj.offsetParent);

	  return [curleft,curtop];
	}
}

function getEventTarget(event) {
	
	var target;

	if (event.target) {
		target = event.target;
	}
	else {
		if (event.srcElement) {
			target = event.srcElement;
     	if (target.nodeType == 3) {
		    target = target.parentNode;
      }
    }
  }
  
  return target;
}

function setActiveTab(tab) {
	var tabset = tab.parentNode.getElementsByTagName("SPAN");
	for (var i=0; i < tabset.length; i++) {
		if (tabset[i].className == "activeTab") {
			tabset[i].className = "inactiveTab";
	  }
	}
	 tab.className = "activeTab";
}

function setDialogCloser(newDialogCloser) {

  closePopupDialog();
  dialogClosers.push(newDialogCloser);

}

function lpadZeros(Num, Zs) {
return(("00000000000000000000" + Num).slice(-Zs));
}

function rpadZeros(Num, Zs) {
  return((Num + "00000000000000000000").slice(0,Zs));
}

function getTimestampXML() {

  var now = new Date();
  return lpadZeros(now.getUTCFullYear(),4) + "-" + lpadZeros(now.getUTCMonth()+ 1,2) + "-" + lpadZeros(now.getUTCDate(),2) + "T" + lpadZeros(now.getUTCHours(),2) + ":" +  lpadZeros(now.getUTCMinutes(),2) + ":" + lpadZeros(now.getUTCSeconds(),2) + "." + rpadZeros(now.getUTCMilliseconds(),6) + "Z"
	
}

function getRadioButtonValue(radioName) {
	
	var buttons = document.getElementsByName(radioName);
	for (var i=0; i < buttons.length; i++) {
		if (buttons.item(i).checked) {
			return buttons.item(i).value;
		}
  }
   return "";

}

function makeLocal(url) {
  	
	var a = document.createElement("A");
	a.href = url;
	if ((a.hostname != location.hostname) || (a.protocol != location.protocol) || (a.port != location.port)) {
		url = a.pathname;
	  if (url.substring(0,1) != "/") {
	  	// Internet Explorer
	    url = "/" + url;
	  } 
    if ((a.search != "") && (a.search != null)) {
  	  url = url + a.search
    }
    url;
  }
  return url
}

function makeRemote(url) {
  	
  return location.protocol + "//" + location.hostname + ":" + location.port + url;

}


function hideSiblings(me,display){
	
	if (me != null) {
	
  	if (typeof display != "string") {
  		display = "block";
  	}
  	
  	for (var i=0; i < me.parentNode.childNodes.length; i++) {
  		if (me.parentNode.childNodes[i].nodeName == me.nodeName) {
  		  me.parentNode.childNodes[i].style.display = "none";
  		}
  	}
    me.style.display = display;   
  }
}
 
function booleanToNumber(booleanValue) {
	if (booleanValue) {
		return 1
  }
  else {
  	return 0
  }
}

function isEmptyString(value) {

  var emptyStringRegExp = /^[\s]*$/;	
  
  if (typeof value != "undefined") {
  	if (value != null) {
  		if (value != "") {
  			return emptyStringRegExp.test(value)
  		}
    }
  }
  
  return true;
  
}

function clearContents(parent) {

  // Remove existing content from page content area.	
	var nodes = parent.childNodes;
	for(i=0; i<nodes.length; i++) {
    parent.removeChild(nodes[i]);
  }
  
}
	
function xfilesException(module,id,target,exception) {

	this.xfilesErrorCodes = {
     '1' : 'ACCESS-DENIED',
     '2' : 'XML-PARSE',
     '3' : 'AJAX',
     '4' : 'NOT-FOUND',
     '5' : 'XMLHTTP',
     '6' : 'SERVER',
     '7' : 'XML-LOAD',
     '8' : 'XML-IMPL',
     '9' : 'XSL-IMPL',
    '10' : 'XSL-GECKO',
    '11' : 'WEB-DEMO',
    '12' : 'XFILES-APP',
    '13' : 'TIMEOUT',
    '14' : 'HTTP',
    '15' : 'SOAP-SVC-MGR',
    '16' : 'REST',
    '17' : 'BROWSER_XSL_ERROR'
    
  };
  
  var module;
  var id;
  var target;
  var exception;

  var description;
  
  var name;
  var number;
  var fileName;
  var lineNumber;

  var xml;
  var text;
  var element;
  var content;
    
  this.module = module;
  this.id = id;
  this.target = unescape(target);
  this.exception = exception;
  
  this.description = null;
  this.name        = null;
  this.number      = null;
  this.fileName    = null;
  this.lineNumber  = null;
  this.xml         = null;
  this.content     = null;
  this.sqlErrCode  = null;
  this.sqlErrMsg   = null;
  
  this.setDescription = function ( description )   { this.description = description };
  this.setNumber      = function ( number )        { this.number = number };
  this.setXML         = function ( xml )           { this.xml = xml };
  this.setContent     = function ( content )       { this.content = content };
  this.setSQLErrCode  = function ( sqlErrCode )    { this.sqlErrCode = sqlErrCode };
  this.setSQLErrMsg   = function ( sqlErrMsg )     { this.sqlErrMsg = sqlErrMsg };
  	
  this.isServerError = function() { return this.id == 6 };
  	
  if (exception) {
    if (useMSXML) {
      if ((exception.description) && (exception.description != null)) { this.description = exception.description };
      if ((exception.name)        && (exception.name != null))        { this.name = exception.name };
      if ((exception.number)      && (exception.number != null))      { this.number = exception.number };
    }
    else {
      if ((exception.message)  && (exception.message != null))  { this.description = exception.message };
      if ((exception.fileName) && (exception.filename != null)) { this.fileName = exception.fileName };
      if ((exception.message)  && (exception.message != null))  { this.lineNumber = exception.lineNumber };
    }
  }
  
  this.getErrorType = function() { 
  	return this.xfilesErrorCodes[this.id]; 
  };
  
  this.getErrorCode = function() { 
  	return this.id;
  };

  this.rootCauseAccessDenied = function() {
  	if (this.getBaseException().getErrorCode) {
  	  return (this.getBaseException().getErrorCode() == 1);
  	}
  }
  
  this.rootCauseBrowserXSL = function() {
  	if (this.getBaseException().getErrorCode) {
  	  return (this.getBaseException().getErrorCode() == 17);
  	}
 	}
 	
 	this.getSQLErrCode = function () {
 	  return this.sqlErrCode
 	}
 	
 	this.getSQLErrMsg = function() {
 		return this.sqlErrMsg
  }

  this.getBaseException = function () {
  	
  	var e = this;
	  while (e.exception) {
		  e = e.exception;
  	}
	  return e;
  }

  this.toHTML = function(parent) {
   	exceptionToHTML(this,parent);
  }

	this.toXML = function (targetNode) {
  	
  	/*
  	**
  	** Cast the current exception object as XML 
  	**
  	*/
 
 	  var targetDocument;
 	  var target;
    	
  	if (typeof targetNode == "undefined") {
  	  targetDocument = new xmlDocument();
    	target = targetDocument.createElement("XFilesException")
    	targetDocument.appendChild(target);
  	}
  	else {
  		targetDocument = targetNode.ownerDocument;
  		target = targetNode;
    }
    
  	for (var i in this) {
      
      if (this[i] == null) {
        continue;
      }

			if (i == "xfilesErrorCodes") {
  			// Do not serialize XFILES Error Codes Array
				continue;
			}

    	if (typeof this[i] == "function") {
    		continue
    	}
    	
  		if (typeof this[i] == "object") {
  			  			
  			if ((i == "exception") && (this[i] != null)) {
  				// Test for 'id' property. The embedded exception is an xfilesException object
  				if (this.exception.id) {
    		  	var innerException = targetDocument.createElement("XFilesException");
     		    target.appendChild(innerException);
    		    this.exception.toXML(innerException);
    		  }
    		  else {
    		  	// The embedded exception is a 'native' exception object
    		  	var innerException = targetDocument.createElement("NativeException");
     		    target.appendChild(innerException);
          	for (var i in this.exception) {
          		// Avoid Firefox Error with location attribute of native exception.
          		if (i != "location") { 
    	          var element = targetDocument.createElement(i);
     	          innerException.appendChild(element);
    	          var text = targetDocument.createTextNode(this.exception[i]);
    	          element.appendChild(text);
     	        }
    		    }
    		  }
   		    continue;
        }

   		  if ((i == "xml") && (this[i] != null)){
          var embeddedXML = targetDocument.createElement("SoapResponse");
 		      target.appendChild(embeddedXML);
 		      try {
	  	      embeddedXML.appendChild(targetDocument.importNode(this.xml.baseDocument.documentElement,true));
	  	    }
	  	    catch (e) {
	  	      if (useMSXML) {
              if (e.number == -2147467259) {
                // Print and Parse to avoid MSFT incompatible MSXML implementations
				        correctedVersion = new ActiveXObject(domImplementation); 
       				  correctedVersion.loadXML(this.xml.baseDocument.xml);                
                embeddedXML.appendChild(targetDocument.importNode(correctedVersion.documentElement,true))
              }
              else {
                var error = new xfilesException('xfileException.toXML()',8,null,e);
                error.setDescription("[MSXML] Import Node Error");
                error.setContent(this.xml.baseDocument.xml);
                throw error;
              }
            }
            else {
              var error = new xfilesException('xfileException.toXML()',8,null,e);
              error.setDescription("[GECKO] Import Node Error");
              error.setContent(this.xml.baseDocument.xml);
              throw error;
            } 
	  	    }  
  		  	continue;
  		  }

  	    var element = targetDocument.createElement(i);
  	    target.appendChild(element);
  	    var text = targetDocument.createTextNode(this[i]);
  	    element.appendChild(text);
  	    continue;
    	}
 	    var element = targetDocument.createElement(i);
	    target.appendChild(element);
	    var text = targetDocument.createTextNode(this[i]);
	    element.appendChild(text);
    }

    
    if (typeof targetNode == "undefined") {
      return targetDocument;
    }
        
  }
  
}

function openModalDialog(dialogName) {

  $('#' + dialogName).modal('show');
  
}

function closeModalDialog(dialogName) {

  // Loop to force closure ?

  while (($('#' + dialogName).data('bs.modal') || {}).isShown) {
    $('#' + dialogName).modal('hide');
  }
  
}

var xfilesHandleException = function(module, e, target) {
	
  try {
  	
  	if (!document.getElementById('genericErrorDialog')) {
			createErrorDialog();
    }

  	var xml = new xmlDocument();
  	var clientError = xml.createElement("XFilesClientException");
  	xml.appendChild(clientError);

  	var timestampElement = xml.createElement("Timestamps");
  	clientError.appendChild(timestampElement);
  	var initElement = xml.createElement("Init");
    timestampElement.appendChild(initElement);
    var text = xml.createTextNode(getTimestampXML());
    initElement.appendChild(text);
      
    var navigatorElement = xml.createElement("Browser");
  	clientError.appendChild(navigatorElement);

  	var nameElement = xml.createElement("Name");
  	navigatorElement.appendChild(nameElement);
    var text = xml.createTextNode(navigator.appName);
    nameElement.appendChild(text);

  	var versionElement = xml.createElement("Version");
  	navigatorElement.appendChild(versionElement);
    var text = xml.createTextNode(navigator.appVersion);
    versionElement.appendChild(text);
 
  	var versionElement = xml.createElement("CookieEnabled");
  	navigatorElement.appendChild(versionElement);
    var text = xml.createTextNode(navigator.cookieEnabled);
    versionElement.appendChild(text);

  	var versionElement = xml.createElement("Platform");
  	navigatorElement.appendChild(versionElement);
    var text = xml.createTextNode(navigator.platform);
    versionElement.appendChild(text);

  	var versionElement = xml.createElement("UserAgent");
  	navigatorElement.appendChild(versionElement);
    var text = xml.createTextNode(navigator.userAgent);
    versionElement.appendChild(text);

  	var userElement = xml.createElement("User");
  	clientError.appendChild(userElement);
  	text = xml.createTextNode(httpUsername);
  	userElement.appendChild(text);

  	var moduleElement = xml.createElement("Module");
  	clientError.appendChild(moduleElement);
  	text = xml.createTextNode(module);
  	moduleElement.appendChild(text);

  	if ((typeof target != "undefined") && (target != null)) {
  		var targetElement = xml.createElement("TargetURL");
  		text = xml.createTextNode(target);
  		targetElement.appendChild(text);
  		clientError.appendChild(targetElement);
    }
    
  	if (e.id) {
    	var exception = xml.createElement("XFilesException")
    	clientError.appendChild(exception);
  	  e.toXML(exception);
  	}
  	else {
    	var exception = xml.createElement("NativeException")
    	clientError.appendChild(exception);
     	for (var i in e) {
    	  element = xml.createElement(i);
    	  text = xml.createTextNode(e[i]);
    	  element.appendChild(text);
     	  exception.appendChild(element);
    	}
    }
 
    if (useMSXML) {

      if (e.number == -2147024891 ) { 
        // Access Denied : (e.description.indexOf("Access is denied.") == 0
        e = new xfilesException(module,1,target,e);
      }  

      if (e.number == 12152) {
        e = new xfilesException(module,13,target,e);
      }

    }
  
    document.getElementById('errorType').style.display = "none";
    document.getElementById('errorTarget').style.display = "none";
    document.getElementById('errorTraceClient').style.display = "none";
    document.getElementById('errorTraceServer').style.display = "none";

  	document.getElementById('errorModule').style.display = "block";
	  document.getElementById('errorModuleText').innerHTML = module;
	
  	if (document.getElementById('pageContent')) {
   	  showPageContent();
    }
   
    openModalDialog('genericErrorDialog');

    if (e.id) {
  	  
    	// WebService error - Message is a SQL Stack Trace in XML
  
    	document.getElementById('errorType').style.display = "block";
    	document.getElementById('errorTypeText').innerHTML = e.id  + ' [' +  e.getErrorType() + ']';
   
      if ((e.target) && (e.target != null)) {
    	  document.getElementById('errorTarget').style.display = "block";
      	document.getElementById('errorTargetText').innerHTML = e.target;
      }
    
    	if (e.id == 6) {
        if (e.xml) {
        	document.getElementById('errorTraceServer').style.display = "block";
        	transformXMLtoXHTML(e.xml,errStackXSL,document.getElementById('errorTraceServerText'));
      	}
      }
      else {
	  		document.getElementById('errorTraceClient').style.display = "block";
	  		traceArea = document.getElementById('errorTraceClientText');
	  		traceArea.innerHTML = "";
	  		e.toHTML(traceArea);
      }
    }
    else {
      if ((e.URL) && (e.target != URL)) {
       	document.getElementById('errorTarget').style.display = "block";
    	  document.getElementById('errorTargetText').innerHTML = e.URL;
      }
  		document.getElementById('errorTraceClient').style.display = "block";
  		traceArea = document.getElementById('errorTraceClientText');
	 		traceArea.innerHTML = "";
			exceptionToHTML(e,traceArea);
    }

    try {
  
      // Use Rest Service to Write Log Record. URL depends on whether or not we are current connected as an authenticated user.
 
    	setHttpUsername();
  
    	if (isAuthenticatedUser()) {
 
	    	var schema          = "XFILES";
        var packageName = "XFILES_SOAP_SERVICES";
        var method      = "WRITELOGRECORD";

       	var mgr = soapManager.getRequestManager(schema,packageName,method);
        var XHR = mgr.createPostRequest(false);
 
        var parameters  = new Object;
	      var xparameters = new Object;
        xparameters["P_LOG_RECORD-XMLTYPE-IN"]   = xml;
        mgr.sendSoapRequest(parameters,xparameters);    
        var soapResponse = mgr.getSoapResponse('common.xfilesHandleException()');
      }
      else {
  
   	    var encodedLogRecord = encodeURIComponent(xml.serialize());
    	
   	    /* 
    	  **
    	  ** Do not submit URL larger than 2K via REST
    	  **
    	  */
  	
      	if (encodedLogRecord.length < 2048) {
          var restURL = '/sys/servlets/XFILES/RestService/XFILES.XFILES_REST_SERVICES.WRITELOGRECORD?LOG_RECORD=' + encodedLogRecord;
    
          var XHR = soapManager.createGetRequest(restURL,false);
          XHR.send(null);
          if (XHR.status != 200) {
            var error = new xfilesException('common.xfilesHandleException',16, restURL, null);
            error.setDescription(XHR.statusText);
            error.setNumber(XHR.status);
            throw error;
          }
        }
        else {
      	  // showWarningMessage("Cannot Write Log Entry via Rest (length = " + encodedLogRecord.length);
      	  alert("Cannot Write Log Entry via Rest (length = " + encodedLogRecord.length);
    	   
    	    /*
      	  **
    	    ** Code to Chunk or Reduce the size of the LOG RECORD
    	    **
    	    */
      	}
		  }
		}
    catch (le) {
      var err = new xfilesException('common.xfilesHandleException',12,null,le);
      err.setDescription('Fatal Error Logging Exception.');
      throw err;
    }  
  }
  catch (ie) {
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
    var err = new xfilesException('common.xfilesHandleException',12,null,ie);
    err.setDescription('Fatal Error in Exception Handler.');
    err.toHTML(document.getElementById('fatalError'));
    err = new xfilesException(module,12,null,e);
    err.setDescription('Underlying exception.');
    err.toHTML(document.getElementById('fatalError'));
    return;
  }
  
}

function exceptionToHTML (e,parent) {

  // Convert an xfilesException or a Native exception to HTML

  var wrapper = document.createElement("span");
  parent.appendChild(wrapper);
  wrapper.style.padding="10px";
  wrapper.style.display="block";

  if (e.module) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Module      : " + e.module;
  }  

  if (e.id) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Error Type  : " + e.id  + " [" +  e.getErrorType() + "]";
  }  

  if (e.description) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Description : " + e.description;
  }

  if (e.target) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Target URL  : " + e.target;
  }

  if (e.message) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Error       : " + e.message;
  }

  if (e.number) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Number      : " + e.number;
  }

  if (e.id == 13) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);  	
  	span.style.display="block";
  	span.innerHTML = "Information : " + "Possible Server Crash. Please check database Alert Log for more information.";
  }

  if (e.id == 3 && e.number == 502) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);  	
  	span.style.display="block";
  	span.innerHTML = "Information : " + "Possible Server Crash. Please check database Alert Log for more information.";
  }

  if (e.id == 3 && e.number == 12109) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);  	
  	span.style.display="block";
  	span.innerHTML = "Information : " + "Possible Server Crash. Please check database Alert Log for more information.";
  }

  if (e.name) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Name        : " + e.name;
  }

  if (e.fileName) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "File       : " + e.fileName;
  }
     
  if (e.lineNumber) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
  	span.innerHTML = "Line Number : " + e.lineNumber;
  }
  
  if (e.exception) {
  	span = document.createElement("span");
  	wrapper.appendChild(span);
  	span.style.display="block";
    exceptionToHTML(e.exception,span);
  }

  if (e.id == 6) {
  	if (e.xml) {
     	pre = document.createElement("pre");
    	wrapper.appendChild(pre);
     	transformXMLtoXHTML(e.xml,errStackXSL,pre);
    }
  }
  else {
  	if (e.xml) {
     	pre = document.createElement("pre");
    	wrapper.appendChild(pre);
    	prettyPrintXML(e.xml, pre) 
  	}
  }
 
  if (e.content) {
   	pre = document.createElement("pre");
  	wrapper.appendChild(pre);
  	pre.innerHTML = htmlEncode(e.content);
  }   
}

function getRandomId() {

	return "ID" + "-"
	     + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase() + "-"
	     + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase() + "-"
       + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase() + "-"
       + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase()

}

function createPopupDialog(dialogID,dialogTitle) {

    var labelId = getRandomId();

    var DIV              = document.createElement("DIV");
    document.body.insertBefore(DIV,document.body.firstElementChild);
    DIV.className        = "modal fade";
    DIV.id               = dialogID;
    DIV.tabIndex         = "-1";
    DIV.setAttribute("role","dialog");
    DIV.setAttribute("aria-labelledby",labelId);
    DIV.setAttribute("aria-hidden","true");
    
    var dialogDIV       =  document.createElement("DIV");
    DIV.appendChild(dialogDIV);
    dialogDIV.className  = "modal-dialog";
    
    var contentDIV       = document.createElement("DIV");
    dialogDIV.appendChild(contentDIV);
    contentDIV.className = "modal-content";
    
    var headerDIV        = document.createElement("DIV");
    contentDIV.appendChild(headerDIV);
    headerDIV.className  = "modal-header alert-danger";
    
    var button           = document.createElement("BUTTON");
    headerDIV.appendChild(button);
    button.type          = "button";
    button.className     = "close";
    button.setAttribute("data-dismiss","modal");
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.setAttribute("aria-hidden","true");
    SPAN.innerHTML       = "&times;";
    
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "sr-only"
    SPAN.textContent     = "Close";
  
    var h4               = document.createElement("H4");
    headerDIV.appendChild(h4);
    h4.className         = "modal-title";
    h4.id                = labelId;
    h4.textContent       = dialogTitle;
   
    var bodyDIV          = document.createElement("DIV");
    contentDIV.appendChild(bodyDIV);
    bodyDIV.className    = "modal-body";
      
    var footerDIV          = document.createElement("DIV");
    contentDIV.appendChild(footerDIV);
    footerDIV.className    = "modal-footer";
    
    return new Array (DIV,headerDIV,bodyDIV,footerDIV)

}

function createErrorDialog() {

    popupDialog = createPopupDialog("genericErrorDialog","Error");
  
    var errorDetailDIV          = document.createElement("DIV");
    popupDialog[2].appendChild(errorDetailDIV);
    errorDetailDIV.className    = "form-horizontal";
    
    var innerDIV         =  document.createElement("DIV");
    errorDetailDIV.appendChild(innerDIV);
    innerDIV.id          = "errorModule";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.htmlFor        = "errorModuleText"
    LABEL.innerHTML      = "Module" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "errorModuleText"
    SPAN.className       = "uneditable-input";
    
    var innerDIV         =  document.createElement("DIV");
    errorDetailDIV.appendChild(innerDIV);
    innerDIV.id          = "errorType";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.htmlFor        = "errorTypeText"
    LABEL.innerHTML      = "Type" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "errorTypeText"
    SPAN.className       = "uneditable-input";
    
    var innerDIV         =  document.createElement("DIV");
    errorDetailDIV.appendChild(innerDIV);
    innerDIV.id          = "errorTarget";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.htmlFor        = "errorTargetText"
    LABEL.innerHTML      = "Target" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "errorTargetText"
    SPAN.className       = "uneditable-input";

    var innerDIV         =  document.createElement("DIV");
    errorDetailDIV.appendChild(innerDIV);
    innerDIV.id          = "errorTraceServer";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.htmlFor        = "errorTraceServerText"
    LABEL.innerHTML      = "Server Trace" + "&nbsp;";
    LABEL.className      = "control-label";

    var SPAN            = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    var PRE             = document.createElement("PRE");
    SPAN.appendChild(PRE);
    PRE.className       = "pre-scrollable";
    PRE.id              = "errorTraceServerText"
    
    var innerDIV         =  document.createElement("DIV");
    errorDetailDIV.appendChild(innerDIV);
    innerDIV.id          = "errorTraceClient";

    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.htmlFor        = "errorTraceClientText"
    LABEL.innerHTML      = "Client Trace" + "&nbsp;";
    LABEL.className      = "control-label";

    var SPAN            = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    var PRE             = document.createElement("PRE");
    SPAN.appendChild(PRE);
    PRE.className       = "pre-scrollable";
    PRE.id              = "errorTraceClientText"
}

function WsdlCache() {

  var wsdlCache = new Array()
  var requestXSL;
  
  var prefixList = {
      "soap"   : "http://schemas.xmlsoap.org/wsdl/soap/",
      "env"    : "http://schemas.xmlsoap.org/soap/envelope/",
      "wsdl"   : "http://schemas.xmlsoap.org/wsdl/",
      'xsd'    : "http://www.w3.org/2001/XMLSchema",
      'orawsv' : "http://xmlns.oracle.com/orawsv"
  }
  
  var namespaces = new namespaceManager(prefixList);

	initialize();

  this.setWSDLCacheEntry = function (key,wsdl) {
    wsdlCache[key] = wsdl;
  }
  
	function initialize() {
    requestXSL = loadXSLDocument('/XFILES/common/xsl/wsdl2Request.xsl'); 
    loadSQLService();
  }

  function loadSQLService() {

    var target = "XDB.ORAWSV.SQL";
    var wsdlURL = '/orawsv?wsdl';
    
    try {
      var wsdl = loadXMLDocument(wsdlURL);
    }
    catch (e) {
    	cause = e.getBaseException();
    	if (cause.number = -2147024891) {
    		doLogoff();
        var error = new xfilesException('SoapManager.loadSQLService',15, wsdlURL, null);
        error.setDescription('Error instantiating SOAP SERVICE MANAGER : Ensure user has been granted XFILES_USER or XFILES_ADMINISTRATOR');
        throw error;    	
      }
      else {
        var error = new xfilesException('SoapManager.loadSQLService',15, wsdlURL, null);
        error.setDescription('Unexpected Error ecnountered instantiating SOAP SERVICE MANAGER');
        throw error;    	
      }
    }

    var soapErrors = wsdl.selectNodes('/env:Envelope/env:Body/env:Fault',namespaces);
    if (soapErrors.length > 0) {
        var error = new xfilesException('SoapManager.loadSQLService',15, wsdlURL, null);
        error.setDescription('Error Fetching WSDL : Ensure user has been granted XFILES_USER or XFILES_ADMINISTRATOR');
        error.setXML(wsdl);
        throw error;    	
    }

    var requestDocument = wsdl.transformToDocument(requestXSL);     
    var namespace = wsdl.selectNodes("/wsdl:definitions/wsdl:types/xsd:schema/@targetNamespace",namespaces).item(0).nodeValue; 
    var url = wsdl.selectNodes("/wsdl:definitions/wsdl:service/wsdl:port/soap:address/@location",namespaces).item(0).nodeValue;
    var messageName = wsdl.selectNodes("/wsdl:definitions/wsdl:portType/wsdl:operation/wsdl:output/@message",namespaces).item(0).nodeValue;
    var elementName = wsdl.selectNodes("/wsdl:definitions/wsdl:message[@name=substring-after(\"" + messageName +"\",\":\")]/wsdl:part/@element",namespaces).item(0).nodeValue;
    wsdlCache[target] = new Array(url,namespace,requestDocument,elementName);    

    target = "XDB.ORAWSV.XQUERY";
    requestDocument = wsdl.transformToDocument(requestXSL);    
    requestDocument.selectNodes("/env:Envelope/env:Body/orawsv:query/orawsv:query_text",namespaces).item(0).setAttribute("type","XQUERY");
    wsdlCache[target] = new Array(url,namespace,requestDocument,elementName);    
  }
 
  function loadwsdlCache(schema, packageName, method) {

    var target;
    var wsdlURL; 
    
    if (method == null) {
  	  target = (schema + "." + packageName3);
      wsdlURL = "/orawsv/" + schema + "/" + packageName + "?wsdl";
    }
    else {
  	  target = (schema + "." + packageName + "." + method);
      var wsdlURL = "/orawsv/" + schema + "/" + packageName + "/" + method + "?wsdl";
  	}

    var wsdl = loadXMLDocument(wsdlURL);    

    var soapErrors = wsdl.selectNodes('/env:Envelope/env:Body/env:Fault',namespaces);
    if (soapErrors.length > 0) {
        var error = new xfilesException('SoapManager.loadwsdlCache',15, wsdlURL, null);
        error.setDescription('Error Fetching WSDL');
        error.setXML(wsdl);
        throw error;    	
    }

    var requestDocument = wsdl.transformToDocument(requestXSL);    
    var namespace = wsdl.selectNodes("/wsdl:definitions/wsdl:types/xsd:schema/@targetNamespace",namespaces).item(0).nodeValue; 
    var url = wsdl.selectNodes("/wsdl:definitions/wsdl:service/wsdl:port/soap:address/@location",namespaces).item(0).nodeValue;
    var messageName = wsdl.selectNodes("/wsdl:definitions/wsdl:portType/wsdl:operation/wsdl:output/@message",namespaces).item(0).nodeValue;
    var elementName = wsdl.selectNodes("/wsdl:definitions/wsdl:message[@name=substring-after(\"" + messageName +"\",\":\")]/wsdl:part/@element",namespaces).item(0).nodeValue;
    wsdlCache[target] = new Array(url,namespace,requestDocument,elementName);    
  }
  
  this.getWSDL = function (schema, packageName, method) {
	  
		if (method == null) {
    	target = schema + "." + packageName;
	  }
    else {
    	target = schema + "." + packageName + "." + method;
    }

  	if (!wsdlCache[target]) {
  		loadwsdlCache(schema, packageName, method);
  	}
  	return wsdlCache[target];
  }

}  

function WSDLManager(wsdl) {

  var wsdlDetails = wsdl;
  
  this.getServiceNamespace = function() {
	  return wsdlDetails[1];
  }
  
  this.getServiceLocation = function() {
	  return wsdlDetails[0];
  }
  
  this.newRequestDocument = function() {
    var requestDocument = wsdlDetails[2];
    requestClone = new xmlDocument();
    requestClone.appendChild(requestClone.importNode(requestDocument.getDocumentElement().cloneNode(true),true));
    return requestClone;
  }

  this.getOutputXPath = function() {
    return "/soap:Envelope/soap:Body/" + wsdlDetails[3];
  }
    
}

function RequestManager(manager,wsdl) {

  var soapManager = manager;
  var wsdlManager = wsdl;
  var logEntry = new Array();
  var self = this;
  var XHR;
  
  soapManager.addLogEntry(logEntry);
  
  function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  }
  
  this.createPostRequest = function(mode) {
  	var URL = wsdlManager.getServiceLocation()
  	logEntry[0] = URL
   	XHR = manager.createPostRequest(URL,mode);
		XHR.setRequestHeader ('SOAPAction',wsdl.getServiceLocation());
    XHR.setRequestHeader ('Content-Type', 'text/xml; charset=utf-8');
    return XHR;
  }
  
  this.sendSoapRequest = function (args, xargs, queryType) {
    return manager.sendSoapRequest(self,args,xargs,queryType);
  }
  
  this.getSoapResponse = function(callingModule) {
  	logEntry[7] = new Date().getTime() - logEntry[4].getTime();
  	logEntry[5] = XHR.status
  	logEntry[6] = XHR.statusText
  	var responseDocument = manager.getSoapResponse(self,callingModule);
  	logEntry[2] = responseDocument;
  	
  	if ((endsWith(logEntry[0],'/XFILES/XFILES_LOGGING/LOGQUERYSERVICE')) && (logEntry[5] == 200)) {
  		soapManager.removeLogEntry(logEntry);
    }
    return responseDocument;
  }
  
  this.executeXQuery = function (query) {
  	logEntry[3] = query;
    return manager.executeXQuery(self,query);
  }

  this.executeSQL = function (query) {
    logEntry[3] = query;
    return manager.executeSQL(self,query);
  }

  this.getXMLHttpRequest = function () {
  	return XHR;
  }
  
  this.getServiceNamespace = function() {
  	return wsdlManager.getServiceNamespace();
  }

  this.getServiceLocation = function() {
	  return wsdlManager.getServiceLocation();
  }

  this.newRequestDocument = function() {
  	return wsdlManager.newRequestDocument();
  }

  this.getOutputXPath = function() {
  	return wsdlManager.getOutputXPath();
  }
  
	this.send = function(requestDocument) { 
		logEntry[1] = requestDocument;
		logEntry[4] = new Date();
    XHR.send(requestDocument.baseDocument);
  }

}
  
// Enable stacked Bootstrap Modals.

$(document)  
  .on('show.bs.modal', '.modal', function(event) {
	// Appears to duplicate 'this' in the DOM tree.
    $(this).appendTo($('body'));
  })
  .on('shown.bs.modal', '.modal.in', function(event) {
	var targetId = this.id;
	duplicateDialog = document.getElementById(targetId);
	// If the id identifies a node with a different parent remove the duplicate from the DOM tree.
	if (!(this.parentNode.id == duplicateDialog.parentNode.id)) {
	  duplicateDialog.parentNode.removeChild(duplicateDialog);
	}
    setModalsAndBackdropsOrder();
  })
  .on('hidden.bs.modal', '.modal', function(event) {
    setModalsAndBackdropsOrder();
  });

function setModalsAndBackdropsOrder() {  
	try {
    var modalZIndex = 1040;
    $('.modal.in').each(function(index) {
      var $modal = $(this);
      modalZIndex++;
      $modal.css('zIndex', modalZIndex);
      $modal.next('.modal-backdrop.in').addClass('hidden').css('zIndex', modalZIndex - 1);
    });
    $('.modal.in:visible:last').focus().next('.modal-backdrop.in').removeClass('hidden');
  } catch (e) {
  	console.log(e);
  }
}