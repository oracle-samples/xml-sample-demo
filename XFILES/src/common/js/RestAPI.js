
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
 

var restAPI = new RestAPI();

function RestAPI() {

  var isORDS = true;

  var schema     
  var collectionName
  var logger = new Array();
  var self = this;

	var servletRoot = '/DBJSON';
	  
  var servletPath = servletRoot + "/";

  function notConnected() {
  	
  	 if (!isORDS) {
       if (typeof schema === "undefined") {
         showErrorMessage(
           'Please Login',
           function() {
             $('#collectionTab a[href="#Connect"]').tab('show')
           }
         )
         return true;
       }
       return false;
     }
    
     return false;
     
  }
  
  this.setORDS = function() {  
  	isORDS = true;
  }
  
  this.setServletRoot = function(root) {
  	servletRoot = root;
  }
    
  this.addLogWindow = function () {

    var DIV              = document.createElement("DIV");
    document.body.insertBefore(DIV,document.body.firstElementChild);
    DIV.className        = "modal fade";
    DIV.id               = "logWindow";
    DIV.tabIndex         = "-1";
    DIV.setAttribute("role","dialog");
    DIV.setAttribute("aria-labelledby","myModalLabel");
    DIV.setAttribute("aria-hidden","true");
    
    var dialogDIV       =  document.createElement("DIV");
    DIV.appendChild(dialogDIV);
    dialogDIV.className  = "modal-dialog";
    
    var contentDIV       = document.createElement("DIV");
    dialogDIV.appendChild(contentDIV);
    contentDIV.className = "modal-content";
    
    var headerDIV        = document.createElement("DIV");
    contentDIV.appendChild(headerDIV);
    headerDIV.className  = "modal-header";
    
    var button           = document.createElement("BUTTON");
    headerDIV.appendChild(button);
    button.type          = "button";
    button.className     = "close";
    button.setAttribute("data-dismiss","modal");
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.setAttribute("aria-hidden","true");
    // SPAN.textContent  = "&times;";
    SPAN.innerHTML       = "&times;";
    
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "sr-only"
    SPAN.textContent     = "Close";
  
    var h4               = document.createElement("H4");
    headerDIV.appendChild(h4);
    h4.className         = "modal-title";
    h4.id                = "myModalLabel";
    h4.textContent       = "REST Call Log";
   
    var bodyDIV          = document.createElement("DIV");
    contentDIV.appendChild(bodyDIV);
    bodyDIV.className    = "modal-body";
    
    var tabDIV           = document.createElement("DIV");
    bodyDIV.appendChild(tabDIV);

    var ul               = document.createElement("UL");
    tabDIV.appendChild(ul);
    ul.className         = "nav nav-tabs";
    ul.setAttribute("role","tablist");
    
    var LI               = document.createElement("LI");
    ul.appendChild(LI);
    var A                = document.createElement("A");
    LI.appendChild(A);
    A.href               = "#lw_OverviewTab";
    A.textContent        = "Overview";
    A.setAttribute("role","tab");
    A.setAttribute("data-toggle","tab");
    
    var LI               = document.createElement("LI");
    ul.appendChild(LI);
    var A                = document.createElement("A");
    LI.appendChild(A);
    A.href               = "#lw_RequestTab";
    A.textContent        = "Request";
    A.setAttribute("role","tab");
    A.setAttribute("data-toggle","tab");
    
    var LI               = document.createElement("LI");
    ul.appendChild(LI);
    var A                = document.createElement("A");
    LI.appendChild(A);
    A.href               = "#lw_ResponseTab";
    A.textContent        = "Response";
    A.setAttribute("role","tab");
    A.setAttribute("data-toggle","tab");
  
    var LI               = document.createElement("LI");
    ul.appendChild(LI);
    var A                = document.createElement("A");
    LI.appendChild(A);
    A.href               = "#lw_JavascriptTab";
    A.textContent        = "JavaScript";
    A.setAttribute("role","tab");
    A.setAttribute("data-toggle","tab");
   
    var BR               = document.createElement("BR");
    bodyDIV.appendChild(BR);
  
    var tabPanesDIV      = document.createElement("DIV");
    bodyDIV.appendChild(tabPanesDIV);
    tabPanesDIV.className = "tab-content";
    
    var paneDIV          = document.createElement("DIV");
    tabPanesDIV.appendChild(paneDIV);
    paneDIV.className    = "tab-pane active";
    paneDIV.id           = "lw_OverviewTab";
   
    var formDIV          = document.createElement("DIV");
    paneDIV.appendChild(formDIV);
    formDIV.className    = "form-horizontal";
  
    var innerDIV         = document.createElement("DIV");
    formDIV.appendChild(innerDIV);
       
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for            = "lw.StartTime"
    LABEL.innerHTML      = "Time" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.StartTime"
    SPAN.className       = "uneditable-input";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.RecordNumber"
    LABEL.innerHTML     = "&nbsp;" + "Log Record" + "&nbsp;";
    LABEL.className     = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.RecordNumber"
    SPAN.className       = "uneditable-input";
    
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.RecordCount"
    LABEL.innerHTML     = "&nbsp;" + "of" + "&nbsp;";
    LABEL.className     = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.RecordCount"
    SPAN.className       = "uneditable-input";
  
    var innerDIV         = document.createElement("DIV");
    formDIV.appendChild(innerDIV);
       
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.Method"
    LABEL.innerHTML     = "Method" + "&nbsp;";
    LABEL.className     = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.Method"
    SPAN.className       = "uneditable-input";
  
    var innerDIV         = document.createElement("DIV");
    formDIV.appendChild(innerDIV);
  
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for            = "lw.URL"
    LABEL.innerHTML      = "URL" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.URL"
    SPAN.className       = "uneditable-input";
  
    var innerDIV         = document.createElement("DIV");
    formDIV.appendChild(innerDIV);
  
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for            = "lw.HttpStatus"
    LABEL.innerHTML      = "Status"  + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.HttpStatus"
    SPAN.className       = "uneditable-input";
   
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for            = "lw.ElapsedTime"
    LABEL.innerHTML      = "&nbsp;" + "Elpased Time" + "&nbsp;";
    LABEL.className      = "control-label";
  
    var SPAN             = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    SPAN.id              = "lw.ElapsedTime"
    SPAN.className       = "uneditable-input";
  
    var innerDIV         = document.createElement("DIV");
    formDIV.appendChild(innerDIV);
    
    var BR               = document.createElement("BR");
    innerDIV.appendChild(BR);
    
    var button           = document.createElement("BUTTON");
    innerDIV.appendChild(button);
    button.id            = "lw.FirstRecord"
    button.type          = "button";
    button.className     = "btn btn-default btn-med";

    button.onclick       = function(index) { return function() {self.loadLogEntry(index); return false;}; }(1);
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "glyphicon glyphicon-fast-backward";
  
    var button           = document.createElement("BUTTON");
    innerDIV.appendChild(button);
    button.id            = "lw.PrevRecord"
    button.type          = "button";
    button.className     = "btn btn-default btn-med";
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "glyphicon glyphicon-step-backward";
     
    var button           = document.createElement("BUTTON");
    innerDIV.appendChild(button);
    button.id            = "lw.NextRecord"
    button.type          = "button";
    button.className     = "btn btn-default btn-med";
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "glyphicon glyphicon-step-forward";
  
    var button           = document.createElement("BUTTON");
    innerDIV.appendChild(button);
    button.id            = "lw.LastRecord"
    button.type          = "button";
    button.className     = "btn btn-default btn-med";

    button.onclick       = function(index) { return function() {self.loadLogEntry(self.getLogRecordCount()); return false;}; }(self.getLogRecordCount());
     
    var SPAN             = document.createElement("SPAN");
    button.appendChild(SPAN);
    SPAN.className       = "glyphicon glyphicon-fast-forward";
  
    var paneDIV          = document.createElement("DIV");
    tabPanesDIV.appendChild(paneDIV);
    paneDIV.className    = "tab-pane";
    paneDIV.id           = "lw_RequestTab";
  
    var innerDIV         = document.createElement("DIV");
    paneDIV.appendChild(innerDIV);
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.RequestBody"
    LABEL.textContent   = "Request Document";
    LABEL.className     = "control-label";
    var SPAN            = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    var PRE             = document.createElement("PRE");
    SPAN.appendChild(PRE);
    PRE.className       = "pre-scrollable";
    PRE.id              = "lw.RequestBody"
     	
    var paneDIV          = document.createElement("DIV");
    tabPanesDIV.appendChild(paneDIV);
    paneDIV.className    = "tab-pane";
    paneDIV.id           = "lw_ResponseTab";
  
    var innerDIV         = document.createElement("DIV");
    paneDIV.appendChild(innerDIV);
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.ResponseText"
    LABEL.textContent   = "Response Document";
    LABEL.className     = "control-label";
    var SPAN            = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    var PRE             = document.createElement("PRE");
    SPAN.appendChild(PRE);
    PRE.className       = "pre-scrollable";
    PRE.id              = "lw.ResponseText"
    
    var paneDIV          = document.createElement("DIV");
    tabPanesDIV.appendChild(paneDIV);
    paneDIV.className    = "tab-pane";
    paneDIV.id           = "lw_JavascriptTab";
   
    var innerDIV         = document.createElement("DIV");
    paneDIV.appendChild(innerDIV);
    var LABEL            = document.createElement("LABEL");
    innerDIV.appendChild(LABEL);
    LABEL.for           = "lw.JavascriptCode"
    LABEL.textContent   = "Source Code";
    LABEL.className     = "control-label";
    var SPAN            = document.createElement("SPAN");
    innerDIV.appendChild(SPAN);
    var PRE             = document.createElement("PRE");
    SPAN.appendChild(PRE);
    PRE.className       = "pre-scrollable";
    PRE.id              = "lw.JavascriptCode"
  
    var footerDIV          = document.createElement("DIV");
    contentDIV.appendChild(footerDIV);
    footerDIV.className    = "modal-footer";

  }
  
	function doReauthentication(URL) {
		
		var authenticatedUser = null;
		try {
     	try {
  			authenticatedUser = getHttpUsername();
    		authenticatedUser = getHttpUsername();
  		} 
   		catch (e) { // Fail with 501 ?
   			authenticatedUser = getHttpUsername();
  		}; 
    	if (authenticatedUser != schema) {
        var error = new xfilesException('RestAPI.doReauthentication',7, URL, e);
        error.setDescription('User Mismatch following ReAuthentication : Expected "' + schema + '", found "' + authenticatedUser + '".');
    	  throw error;
		  }  		
    }
    catch (e) {
      var error = new xfilesException('RestAPI.doReauthentication',7, URL, e);
      error.setDescription('Exeception raised while performing ReAuthentication process for "' + schema + '".');
    	throw error;
  	}	  	
	}
	
  this.setSchema = function(newSchema) {
    schema = newSchema;
    if (isORDS) {
    	servletPath = "http://localhost:8080/ords/" +  schema.toLowerCase()  + "/soda/latest/"
    }
    else {
    	servletPath = servletRoot + "/" + schema + "/";
    } 
  }
  

  this.setCollectionName = function(newCollectionName) {
    collectionName = newCollectionName;
  }
    
  function showErrorMessage(message,url,callback) {
    var dialogOptions =     {
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
  
  this.getRandomName = function() {
  	return (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase()
  	     + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase()
         + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase() 
         + (Math.random().toString(16) + '000000').slice(2, 8).toUpperCase()
  }
  
  this.getSourceCode = function(name) {
  	return self[name].toString();
  }
  
  function expandURL(URL) {
    
    var expandedURL = "http://" + location.hostname;
    if (location.port) {
      expandedURL  = expandedURL + ":" + location.port;
    }  
    expandedURL = expandedURL + URL;
    return expandedURL;
  }
  
  function addLogEntry (className,method,URL,startTime,XHR,payload) {
    logger[logger.length] = new Array (method,URL,payload,XHR.status,XHR.statusText,XHR.responseText,startTime,new Date().getTime() - startTime.getTime(),className); 
  }
  
  this.getLogRecordCount = function() {
    return logger.length;
  }

  this.resetLogger = function() {
  	logger = new Array();
  }

  this.showRestAPILog = function(logWindowID) {
  	if (logger.length == 0) {
  		showErrorMessage("No logged operations");
  	}
  	else {
      self.loadLogEntry(logger.length);
      // document.getElementById(logWindowID).modal('show');
      $('#' + logWindowID).modal('show')    
    }
  }
  
  this.loadLogEntry = function(index) {
  
    var nextRecord = document.getElementById("lw.NextRecord")
    var prevRecord = document.getElementById("lw.PrevRecord")
    
    if (index == 1) {
      // prevRecord.firstChild.src = "/XFILES/lib/icons/prevDisabled.png"
      prevRecord.onclick= function() {return false};
    }
    else {
      // prevRecord.firstChild.src = "/XFILES/lib/icons/prevEnabled.png"
      prevRecord.onclick = function(index) { return function() {self.loadLogEntry(index); return false;}; }(index-1)
    }
    
    if (index == logger.length) {
      // nextRecord.firstChild.src = "/XFILES/lib/icons/nextDisabled.png"
      nextRecord.onclick=function() {return false};
    }
    else {
      // nextRecord.firstChild.src = "/XFILES/lib/icons/nextEnabled.png"
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
    method.textContent          = logger[logIndex][0]
    url.textContent             = expandURL(logger[logIndex][1])
    httpStatus.textContent      = logger[logIndex][3] + " [" +  logger[logIndex][4] + "]"
    startTime.textContent       = logger[logIndex][6]
    elapsedTime.textContent     = logger[logIndex][7] + "ms"

    requestBody.style.display="none";
    requestBody.innerHTML = "";
    if ((logger[logIndex][2]) && (logger[logIndex][2] != "\r\n")) {
    	try {
      	jPP.printJson(requestBody,null,JSON.parse(logger[logIndex][2]));
      }
      catch (e) {
      	requestBody.appendChild(document.createTextNode("JSON Parsing Error:"));
      	requestBody.appendChild(document.createTextNode(e.message));
      	requestBody.appendChild(document.createTextNode(logger[logIndex][2]));
      }
      requestBody.style.display="block";      
    }  
    
    responseText.style.display="none";
    responseText.innerHTML = "";
    if ((logger[logIndex][5]) && (logger[logIndex][5] != "\r\n")) {
    	try {
        jPP.printJson(responseText,null,JSON.parse(logger[logIndex][5]));
      }
      catch (e) {
        responseText.appendChild(document.createTextNode("JSON Parsing Error:"));
        responseText.appendChild(document.createTextNode(e.message));
      	responseText.appendChild(document.createTextNode(logger[logIndex][5]));
      }
      responseText.style.display="block";
    }  
    
    javaScriptCode = document.getElementById("lw.JavascriptCode");
  	javaScriptCode.innerHTML = "";
  	var sourceCode = self[logger[logIndex][8]].toString();
  	sourceCode = sourceCode.replace('function','function ' + logger[logIndex][8]);
  	javaScriptCode.appendChild(document.createTextNode(sourceCode));
  }
  
  this.processGetResponse = function(XHR,URL) {
  	
    if (XHR.status == 200) {
      try {
        var jsonObject = JSON.parse(XHR.responseText);
        return jsonObject;
      }
      catch (e) {
        showErrorMessage("RestAPI.processGetResponse: Error parsing JSON response. (" + e.message + ")",URL);
      	return null;
      }
    }
    else {
      showErrorMessage("RestAPI.processGetResponse: Operation failed. Status = " + XHR.status + " (" + XHR.statusText + ")",URL);
    	return null;
   	}
  }
  
  this.processPutResponse = function(XHR,URL) {
  	
    if (XHR.status == 201) {
    	showSuccessMessage("Document Created");
   	}
   	else if (XHR.status == 200) {
    	showSuccessMessage("Document Updated");
   	}
    else {
      showErrorMessage("RestAPI.processPutResponse: Operation failed. Status = " + XHR.status + " (" + XHR.statusText + ")",URL);
   	}

  	return XHR.status
  }

  this.processQueryResult = function (XHR,URL) {

    var jsonObject = null;
  
    if (XHR.status == 200) {
      try {
        jsonObject = JSON.parse(XHR.responseText);
        if (jsonObject.items.length > 0) {
          showSuccessMessage(jsonObject.items.length + " documents found.");
          return jsonObject;
        }
        else {
          showInformationMessage("RestAPI.processQueryResponse: No Matching documents");
          return null;
        }
      }
      catch (e) {
        showErrorMessage("RestAPI.processQueryResponse: Error parsing document list. (" + e.message + ").",URL);
        return null;    	
      }   
    }
    else {
      showErrorMessage("RestAPI.processQueryResponse: Query by Example operation failed. Status = " + XHR.status + " (" + XHR.statusText + ")",URL);
      return null;
    }  
  }
  
  this.getCollectionList = function (callback) {

    if (notConnected()) return;

    var URL = servletPath

    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("GET", URL, true);
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("getCollectionList","GET",URL,startTime,XHR);
                                 callback(XHR,URL)
                               } 
                             };
    XHR.send(null);
  }   

	this.createCollectionProperties = function (collectionName, sqlType, assignmentMethod) {
  
  var collectionSpec = new Object();

  collectionSpec.tableName = collectionName;

  collectionSpec.contentColumn = new Object();
  collectionSpec.contentColumn.name = 'JSON_DOCUMENT';
  collectionSpec.contentColumn.sqlType = sqlType;
  
  if ((collectionSpec.contentColumn.sqlType == 'CLOB') || (collectionSpec.contentColumn.sqlType == 'BLOB')) { 
    collectionSpec.contentColumn.compress = "MEDIUM";
    collectionSpec.contentColumn.cache = true;
  }

  collectionSpec.keyColumn = new Object();
  collectionSpec.keyColumn.name = 'ID'
  collectionSpec.keyColumn.sqlType = 'VARCHAR2';
  collectionSpec.keyColumn.maxLength = 64;
  collectionSpec.keyColumn.assignmentMethod = assignmentMethod;
  
  collectionSpec.creationTimeColumn = new Object();
  collectionSpec.creationTimeColumn.name = "DATE_CREATED";

  collectionSpec.lastModifiedColumn = new Object();
  collectionSpec.lastModifiedColumn.name =  "DATE_LAST_MODIFIED";
  // collectionSpec.lastModifiedColumn.index = "IDX_LAST_MODIFIED";

  collectionSpec.versionColumn = new Object();
  collectionSpec.versionColumn.name = "VERSION"; 
  collectionSpec.versionColumn.method = "SHA256";

  if (collectionSpec.contentColumn.sqlType == 'BLOB') {
  	collectionSpec.mediaTypeColumn = new Object();
    collectionSpec.mediaTypeColumn.name = "CONTENT_TYPE"; 
  }
 
  collectionSpec.readOnly = false;

  /* 
  var cpDisplay = document.getElementById("cc.Content")
  cpDisplay.innerHTML = "";
  jPP.printJson(cpDisplay,null,collectionSpec);
  */

  return collectionSpec;

  }  

  this.createCollection = function (collectionName, collectionProperties, callback) {

    if (notConnected()) return;

    var serializedPayload = null;

    if ((typeof collectionProperties === "object") & (collectionProperties != null)) {
      serializedPayload = JSON.stringify(collectionProperties);
    }
    
    var URL = servletPath + collectionName
    
    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("PUT", URL, true);
    XHR.setRequestHeader("Content-type","application/json");
    XHR.onreadystatechange= function() { 
                              if (XHR.readyState==4) { 
                                addLogEntry("createCollection","PUT",URL,startTime,XHR,serializedPayload);
  	 													  if ((XHR.status == 404) || (XHR.status == 200)) {
                               	  // ### Workaround for unexpected 501 errors that may occur following a 404 or 200 return from a PUT. ###
 		  												 	    doReauthentication(URL);
    	  											  }
                                callback(XHR,URL,collectionName) 
                              } 
                            };
    
    XHR.send(serializedPayload);
  } 
  
  this.dropCollection = function (callback) {

    if (notConnected()) return;
    
    var URL = servletPath + collectionName
    
    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("DELETE", URL, true);
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("dropCollection","DELETE",URL,startTime,XHR);
                                 callback(XHR,URL,collectionName) 
                               } 
                             };
    XHR.send(null);
  }   

  this.getCollection = function(arguments,callback) {

    if (notConnected()) return;
    
    var URL = servletPath + collectionName
    if ((typeof arguments === "string") && (arguments != "")) {
      URL = URL + "?" + arguments
    }    
    
    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("GET", URL, true);
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("getCollection","GET",URL,startTime,XHR);
                                 callback(XHR,URL)
                               } 
                             };
    XHR.send(null);
  }

  this.putDocument = function (docId,payload,callback) {
  	
    if (notConnected()) return;
     
    var URL = servletPath + collectionName + "/" + docId
    
    var startTime = new Date();
    var serializedPayload = JSON.stringify(payload);
    var XHR = new XMLHttpRequest();
    XHR.open ("PUT", URL, true);
    XHR.setRequestHeader("Content-type","application/json");
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("putDocument","PUT",URL,startTime,XHR,serializedPayload);
 		 													   if ((XHR.status == 404) || (XHR.status == 200)) {
	                               	 // ### Workaround for unexpected 501 errors that may occur following a 404 or 200 return from a PUT. ### 
 		  												 	   doReauthentication(URL);
    	  											   }
                                 callback(XHR,URL,docId);
                               } 
											     }
    XHR.send(serializedPayload);
  }
  
  this.postDocument = function (arguments,payload,callback) {

    if (notConnected()) return;
    
    var URL = servletPath + collectionName 
    if ((typeof arguments === "string") && (arguments != "")) {
      URL = URL + "?" + arguments
    }
    
    var startTime = new Date();
    var serializedPayload = JSON.stringify(payload);
    var XHR = new XMLHttpRequest();
    XHR.open ("POST", URL, true);
    XHR.setRequestHeader("Content-type","application/json");
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("postDocument","POST",URL,startTime,XHR,serializedPayload);
                                 callback(XHR,URL);
                               } 
                             };
    XHR.send(serializedPayload);
  }   
  
  this.getDocument = function(docId,callback) {
    
    if (notConnected()) return;
    
    var URL = servletPath + collectionName + "/" + docId
    
    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("GET", URL, true);
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("getDocument","GET",URL,startTime,XHR);
                                 callback(XHR,URL);
                               } 
                             };
    XHR.send(null);
  }

  this.deleteDocument = function (docId,callback) {
    
    if (notConnected()) return;
    
    var URL = servletPath + collectionName + "/" + docId
        
    var startTime = new Date();
    var XHR = new XMLHttpRequest();
    XHR.open ("DELETE", URL, true);
    XHR.onreadystatechange = function() { 
                               if (XHR.readyState==4) { 
                                 addLogEntry("deleteDocument","DELETE",URL,startTime,XHR);
                                 callback(XHR,URL);
                               } 
                             };
    XHR.send(null);
  }   
}
