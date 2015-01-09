
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
 * ================================================ */

var QUERY_SERVICE = 1;
var EXEC_SERVICE=2;
var DESCRIBE_SERVICE=3;
var XPLAN_SERVICE=4;

var soapRequest;
var soapResponse;
var wsdl;

var FormatDescribeXSL;
var FormatResponseXSL;
var FormatXPlanXSL;

var currentStepId;
var currentTab;
var sqlScriptUsername;

// Two flags drive plan and timing. State controlled by script of checkbox. 
// State determines whether timing is displayed and plans are captured and displayed

var steps = new Array();
var autoTraceEnabled = false;
var timingEnabled = false;


var resizeTimer;
var firstStatementId;

function stepContainer(id) {
	
	// Private methods are inner functions of the constructor
	// Private methods cannot be called by public methods
	
  function getSQLScript ( URL ) {
    sqlScriptURL = URL;
    try {
      sqlScript  = getDocumentContentImpl(sqlScriptURL).split('\n');
    } catch (e) {
      error = new xfilesException('stepContainer.getSQLScript',11, sqlScriptURL, e);
      throw error;
    }
    return sqlScript;
  }
   
  function includeSQLScript( scriptLocation, currentScript, relative ) {
  
    if (scriptLocation.toLowerCase().indexOf('.sql') < 1 ) {
      scriptLocation = scriptLocation + ".sql"
    }
    
    if (relative) { 
      scriptLocation = sqlScriptURL.substring(0,sqlScriptURL.lastIndexOf("/")+1) + scriptLocation;
    }
    
    try {
      includeScriptText = getDocumentContentImpl(scriptLocation);
    } catch (e) {
      error = new xfilesException('stepContainer.includeSQLScript',11, scriptLocation, e);
      throw error;
    }
    // alert(includeScriptText);
    includeScript = includeScriptText.split('\n');
  
    newScript = includeScript.concat(currentScript);
    // alert("includeSQLScript(" + scriptLocation + ") : includeScript.length = " + includeScript.length + ". currentScript.length = " + currentScript.length + ". newScript.length = " + newScript.length + " : " + newScript[0])
  
    return newScript;
    
  }

  function readStatement() {
  
   // Read the next statement from the scriptContent

   statementHTML = "";
   var statement = "";

   var statementStarted = false;
   var setArguments;

   var commentBlock = false;
   
   if (scriptContent.length == 0) {
     stepComplete = true;
     statementHTML = statementHTML + 'quit' + "<BR>";
     return "";
   }
   
   try {
     while (scriptContent.length > 0)
     { 
 
       nextLine = scriptContent[0];
 
       if (nextLine == '') {
         // Skip blank lines
         scriptContent.shift();
         /*
         **
         ** Corner case for script ending with a blank line..
         **
         */
			   if (scriptContent.length == 0) {
     				if (statementStarted) {
     					statementHTML = statementHTML + "/";
     			  }
     			  else {
				      statementHTML = 'quit' + "<BR>";
	   			  	statement = "";
       				stepComplete = true;
     			  }
			      return statement;
     		 }
      	 continue;
       }
       
       if (!commentBlock) {
  
         if (nextLine.substring(0,2) == "@@") {
           // alert("Include found at line " + scriptContent.length + " : " + nextLine);
           scriptContent.shift();
         	 scriptContent = includeSQLScript(nextLine.substring(2),scriptContent,true);
           continue;
         }
       
         if (nextLine.substring(0,1) == "@") {
           // alert("Include found at line " + scriptContent.length + " : " + nextLine);
           scriptContent.shift();
         	 scriptContent = includeSQLScript(nextLine.substring(1),scriptContent,false);
           continue;
         }

         if ((nextLine.substring(0,1) == "/") && (nextLine.substring(1,2) != "*"))  {
           statementHTML = statementHTML + "/";
           scriptContent.shift();
           return statement;
         }
       
         if (!statementStarted) {
  
           if ((nextLine.substring(0,5).toLowerCase() == "pause") || (nextLine.substring(0,3).toLowerCase() == "pau")) {
             // SQL*PLUS pause statement;
             executionPaused = true;
             scriptContent.shift();
   			     statement = "";
				     statementHTML = "";
             continue;
           }

           if (nextLine.substring(0,4).toLowerCase() == "quit") {
             // SQL*PLUS quit statement;
             stepComplete = true;
             statementHTML = statementHTML + 'quit';
        		 return ""; 
           }
    
           if (nextLine.substring(0,4).toLowerCase() == "exit") {
             // SQL*PLUS exit statement;
             stepComplete = true;
             statementHTML = statementHTML + 'exit';
       	  	 return "";
           }
       
         }
       }
       
       nextLineHTML = nextLine.replace(/&/g,'&amp;');
       nextLineHTML = nextLineHTML.replace(/\s/g,"&nbsp;");
       nextLineHTML = nextLineHTML.replace(/</g,"&lt;");
       nextLineHTML = nextLineHTML.replace(/>/g,"&gt;");
       nextLineHTML = nextLineHTML + "<BR/>";
       // alert(nextLineHTML);
  
       statementHTML = statementHTML + nextLineHTML;
       scriptContent.shift();
  
       // Hack for Comment Blocks eg /* ... */
  
     	 if (nextLine.substring(0,2) == "/*") {
     	 	 // Todo : Deal with Start Comment Marker not at begining of line
     	 	 commentBlock = true;
     	 	 continue;
       }

     	 if (nextLine.substring(0,2) == "*/") {
     	 	 // Todo : Deal with End Comment Marker not at begining of line
     	 	 commentBlock = false;
     	 	 continue;
       }
       
       if (commentBlock) {
       	 continue;
       }
     
       if (nextLine.substring(0,2).toLowerCase() == "--") {
         // Skip Comments
         continue;
       }
  
       if (!statementStarted) {
  
         // Skip all unsupported SQL*PLUS statements
  
  
         if (nextLine.substring(0,4).toLowerCase() == "set ") {
           // Check for set autotrace on explain or set autotrace off
           setArguments = nextLine.toLowerCase().split(" ");
           if (setArguments.length > 2) {
             if ((setArguments[1] == "autotrace") || (setArguments[1] == "autot")) {
               if (setArguments[2].substring(0,3) == "off") {
                 // alert('Autotrace Disabled');
                 setAutoTrace(false);
               }
               else {
                 if (setArguments[2].substring(0,2) == "on") {
                   // alert('Found autotrace on statement');                 
                   if (setArguments.length > 3)  {
                     if ((setArguments[3].substring(0,7) == "explain") || (setArguments[3].substring(0,4) == "expl")) {
                       // alert('Autotrace Enabled');                    
                       setAutoTrace(true);
                     }
                   }
                 }
               }
             }
             if ((setArguments[1] == "timing") || (setArguments[1] == "timi")) {
               if (setArguments[2].substring(0,3) == "off") {
                 setTiming(false);
               }
               else {
                 if (setArguments[2].substring(0,2) == "on") {
                   setTiming(true);
                 }
               }
             }
           }
           // Skip all other SQL*PLUS SET Statements
           continue;
         }
  
         if ((nextLine.substring(0,6).toLowerCase() == "spool ") || (nextLine.substring(0,4).toLowerCase() == "spo ")) {
           // Skip SQL*PLUS SPOOL Statements
           continue;
         }
  
         if ((nextLine.substring(0,5).toLowerCase() == "show ") || (nextLine.substring(0,4).toLowerCase() == "sho ")) {
           // Skip SQL*PLUS SHOW Statements
           continue;
         }
  
         if ((nextLine.substring(0,7).toLowerCase() == "column ") || (nextLine.substring(0,4).toLowerCase() == "col ")) {
           // Skip SQL*PLUS COLUMN Statements
           continue;
         }
  
         if ((nextLine.substring(0,9).toLowerCase() == "describe ") || (nextLine.substring(0,5).toLowerCase() == "desc ")) {
           // SQL*PLUS describe statement;
           statement = nextLine;
           return statement;
         }
       }
  
       statement = statement + nextLine;
       statementStarted = true;
     }
  	 stepComplete = true;
     statement = "";
     return statement;     
   }
   catch (e) {
     error = new xfilesException('stepContainer.readStatement',11, null, e);
     throw error;
   }
  }
  
  function setStatementType(statement) {
  	
  	var token;
  	var statementType;
  	
    token = statement.split(" ",1)[0].toLowerCase();
    // alert('"' + this.token  + '"');
  
    if ((token.substring(0,4) == "desc") || (token.substring(0,8) == "describe")) {
      ddlTargetList[_getSqlId()] = statement.split(" ",2)[1].toLowerCase();
      statementType = "DESCRIBE";
      return statementType;
    }
  
    if (token.substring(0,6) == "select") {
      statementType =  "SQL";
      return statementType;
    }
  
    if (token.substring(0,6) == "xquery") {
      statementType =  "XQUERY";
      return statementType;
    }
  
    if (token.substring(0,7) == "declare") {
      statementType =  "PLSQL";
      return statementType;
    }
  
    if (token.substring(0,5) == "begin") {
      statementType =  "PLSQL";
      return statementType;
    }
  
    if (token.substring(0,4) == "call") {
      statement = "begin " + statement.substring(5) + ";" + " end;"
      statementType =  "PLSQL";
      return statementType;
    }
  
    if (token.substring(0,4) == "exec") {
      statement = "begin " + statement.substring(5) + ";" + " end;"
      statementType =  "PLSQL";
      return statementType;
    }
  
    if (token.substring(0,6) == "update") {
      statementType =  "UPDATE";
      return statementType;
    }
  
    if (token.substring(0,6) == "delete") {
      statementType =  "DELETE";
      return statementType;
    }
  
    if (token.substring(0,6) == "insert") {
      statementType =  "INSERT";
      return statementType;
    }
  
    if ((token.substring(0,6) == "commit") || (token.substring(0,7) == "rollback")) {
      // Stateless Web Services cannot support Commit or Rollback. Treat as a NO-OP
      statementType =  "COMMIT";
      return statementType;
    }
  
    if (token.substring(0,6) == "create") {
      ddlTargetList[_getSqlId()] = statement.split(" ",2)[1].toLowerCase();
      if (ddlTargetList[_getSqlId()] == "or") {
        ddlTargetList[_getSqlId()] = statement.split(" ",4)[3].toLowerCase();
      }
      if ((ddlTargetList[_getSqlId()] == "unique") || (ddlTargetList[_getSqlId()] == "bitmap")) {
        ddlTargetList[_getSqlId()] = "Index"
      }
      statementType =  "CREATE";
      return statementType;
    }
  
    if (token.substring(0,6) == "purge") {
      ddlTargetList[_getSqlId()] = statement.split(" ",2)[1].toLowerCase();
      statementType =  "PURGE";
      return statementType;
    }

    if (token.substring(0,4) == "drop") {
      ddlTargetList[_getSqlId()] = statement.split(" ",2)[1].toLowerCase();
      statementType =  "DROP";
      return statementType;
    }
  
    if (token.substring(0,5) == "alter") {
      ddlTargetList[_getSqlId()] = statement.split(" ",2)[1].toLowerCase();
      statementType =  "ALTER";
      return statementType;
    }
  
    if (token.substring(0,5) == "grant") {
      statementType =  "GRANT";
      return statementType;
    }
  }
  
  function loadStatement() {
  	statementList[_getSqlId()] = readStatement()
  	statementTypeList[_getSqlId()] = setStatementType(statementList[_getSqlId()]);
  	statementExecuted[_getSqlId()] = false;
  }
  
	function _isSQLScript() {
		return action == "SQL";
  }

	function _isClientCommand() {
		return action == "OSCMD";
  }

	function _isViewer() {
		return action == "VIEW";
  }

	function _isLink() {
		return action == "HTTP";
  }

  function _getStepId() {
  	return stepId;
  }
 
  function _getSqlId() {
  	return sqlId;
  }
  
  function _getStatement() {
  	return statementList[_getSqlId()];
  }
  
  function _getStatementExecuted() {
  	return statementExecuted[_getSqlId()];
  }
  
  function _setStatementExecuted() {
  	statementExecuted[_getSqlId()] = true;
  }

  function _getStatementHTML() {
  	return statementHTML;
  }
  
  function _getStatementType() {
  	return statementTypeList[_getSqlId()];
  }

  function _getDDLTarget() {
  	return ddlTargetList[_getSqlId()];
  }

  function _isExecutionPaused() {
  	return executionPaused;
  }
  
  function _isStepComplete() { 
  	return stepComplete;
  }
  
  function _isAutoRun() {
  	return autoRun;
  }

  function _resumeExecution() {
  	executionPaused = false;
  }

  function _pauseExecution() {
  	executionPaused = true;
  }
    
  function _getDocumentContent() {
  	return documentContent;
  } 
 
  function _getContentType() {
  	return contentType;
  } 
  
  function _setStatement(newStatement) {
  	sqlId = newStatement;
  }
  
	// Ordinary vars and parameters of the constructor become the private members
  // Private members are attached to the object
  // They are accessible to private methods.	
  // They are not accessible to the outside world
  // They are not accessible to the object's own public methods. 
  
  var sqlplusStatements = new Array
	(
  "@"           ,  "COPY"        ,
  "@@"          ,  "DEFINE"      ,  "PRINT"                  ,  "SPOOL"               ,
  "/"           ,  "PROMpx"      ,  "SQLPLUS"                ,  "ACCEpx"              ,
  "START"       ,  "DISCONNECT"  ,  "RECOVER"                ,
  "REMARK"      ,  "STORE"       ,  "REPFOOTER"              ,  "TIMING"              ,
  "BREAK"       ,  "REPHEADER"   ,  "TTITLE"                 ,
  "BTITLE"      ,  "GET"         ,  "UNDEFINE"               ,  "VARIABLE"            ,
  "CLEAR"       ,  "RUN"         ,  "WHENEVER OSERROR"       ,
  "INPUT"       ,  "SAVE"        ,  "WHENEVER SQLERROR"      ,
  "COMPUTE"     ,  "SET"         ,  "CONNECT"                ,  "SHOW"
	)

	var supportedStatements = new Array
	(
  	"EXIT", "QUIT", "EXECUTE", "EXEC", "CALL", "DESCRIBE", "DESC", "PAU", "PAUSE"
	)

	var unsupportedStatements
	(
  	"A", "APPEND", "C", "CHANGE", "DEL", "L", "LIST", "ATTRIBUTE", "COLUMN", "COL", "HELP", "HO", "HOST",
  	"STARTUP", "SHUTDOWN", "ARCHIVE LOG", "PASSWORD"
	)
	
  var stepId = id;
  var action = document.getElementById('action.' + stepId).value;
  var scriptLocation;
  var scriptContent;
  var autoRun          = true;
  var stepComplete     = false;
  var executionPaused  = false;
  
  var documentURL;
  var documentContent;
  var contentType;
  
  // Declare private member "self". Set it to "this". This makes the object available to it's private methods. 
  // Workaround for an error in the ECMAScript Language Specification which causes this to be set incorrectly for inner functions
  
  var self = this;
 
  var sqlId             = 1;
  var statementList     = new Array();
  var statementExecuted = new Array();
  var statementTypeList = new Array();
  
  // ddlTargetList is Index, Table etc except for Describe where it is the name of the object being Described
  
  var ddlTargetList     = new Array();
  
  var statementHTML     = "";
  
  this.getStepId             = function() { return _getStepId() }
  this.getHTML               = function() { return _getStatementHTML() };
  this.getStatement          = function() { return _getStatement() };
  this.getStatementExecuted  = function() { return _getStatementExecuted() };
  this.setStatementExecuted  = function() { return _setStatementExecuted() };
  this.getSqlId              = function() { return _getSqlId() }
  this.getStatementId        = function() { return _getStepId() + "." + _getSqlId() }
  this.getStatementType      = function() { return _getStatementType() };
  this.getDDLTarget          = function() { return _getDDLTarget() };
  this.isStepComplete        = function() { return _isStepComplete() };
  this.isAutoRun             = function() { return _isAutoRun() };
  this.isExecutionPaused     = function() { return _isExecutionPaused() };
  this.isSQLScript           = function() { return _isSQLScript() };
  this.isViewer              = function() { return _isViewer() };
  this.isClientCommand       = function() { return _isClientCommand() };
  this.resumeExecution       = function() { _resumeExecution() };
  this.pauseExecution        = function() { _pauseExecution() };
  this.getDocumentContent    = function() { return _getDocumentContent() };
  this.getContentType        = function() { return _getContentType() };

  this.loadNextStatement = function() {
    _resumeExecution();
    _setStatement(_getSqlId() + 1);
    loadStatement()
  }
  
  this.getStepWindow = function () {
  	return document.getElementById('stepDisplay.' + _getStepId());
  }

  this.setStatement  = function (newStatementId) { _setStatement(newStatementId) };
  
  if (_isSQLScript()) {
    scriptLocation = document.getElementById('sqlScript.' + stepId).value;
    scriptContent = getSQLScript(scriptLocation);
    loadStatement();
  }

  if (_isViewer()) {
    documentURL      = document.getElementById('target.' + stepId).value;
    contentType      = document.getElementById('contentType.' + stepId).value;
    try {
      documentContent  = getDocumentContentImpl(documentURL)
    }
    catch (e) {
    	 if (contentType == "text/xml" ) {
    	 	 documentContent = '<Error># Unable to load "' + documentURL + '"</Error>';
    	 }
    	 else {
      	 documentContent = '# Unable to load "' + documentURL + '".';
       }
    }
  }

}

var demoPrefixList = xfilesPrefixList;
    demoPrefixList['xdbpm']='http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES';

var demoNamespaces = new namespaceManager(demoPrefixList);

function loadFormatDescribeXSL() {
  FormatDescribeXSL = loadXSLDocument('/XFILES/WebDemo/xsl/formatDescribe.xsl');
}

function loadFormatXPlanXSL() {
  FormatXPlanXSL = loadXSLDocument('/XFILES/WebDemo/xsl/formatXPlan.xsl');
}

function loadFormatResponseXSL() {
  FormatResponseXSL = loadXSLDocument('/XFILES/WebDemo/xsl/formatResponse.xsl');
}


function onPageLoaded() {

  loadFormatResponseXSL();
  loadFormatDescribeXSL();
  loadFormatXPlanXSL();

  /*
  **
  **  Use isAuthenticatedUser() to determine who the HTTP session is currently connected as...
  **
  */
  
  sqlScriptUsername = getParameter('sqlUsername');
	
	setHttpUsername();	     
  showStep(1);    

}

function setAutoTrace(state) {
	
	autoTraceEnabled = state;
	
}
	
function setTiming(state) {

  timingEnabled = state;
  showTiming(currentTab);
    
}

function showTiming(statementId) {

	var timingWindow = document.getElementById("timing." + statementId);

	if (timingEnabled) {
    timingWindow.parentNode.style.display = "inline-block";
  }
  else {
    timingWindow.parentNode.style.display = "none";
  }    	

}

function showExplainPlan(statementId) {
	
  var toggleResults = document.getElementById("toggleResultsPlan." + statementId);

	if (autoTraceEnabled) {
    toggleResults.parentNode.style.display = "inline-block";
    return true;
  }
  else {
    toggleResults.parentNode.style.display = "none";
    return false;
  }    	
}

function toggleResultsPlan(statementId)
{
  var results = document.getElementById("result." + statementId);
  hideSiblings(results);
  var explainPlan   = document.getElementById("explainPlan." + statementId);
  hideSiblings(explainPlan);

  var img          = document.getElementById("toggleResultsPlan." + statementId);
  
  var visibleWindow;
  
  if (results.parentNode.style.display == "none") {
  	visibleWindow = results;
    explainPlan.parentNode.style.display = "none";
    results.parentNode.style.display = "block";
    img.src = "/XFILES/lib/icons/showPlan.png";
  }
  else {
  	visibleWindow = explainPlan;
  	explainPlan.parentNode.style.display = "block";
    results.parentNode.style.display = "none";
    img.src = "/XFILES/lib/icons/showResults.png";
  }

  sizeOutputWindow(visibleWindow,statementId);
  
}  

function resizeWindow(statementNumber,regionName,iconName,expandIcon,restoreIcon) {
	
	var pane
	
	if (regionName == "outputWindow.") {
		pane = document.getElementById("result." +  statementNumber);
		if (pane.style.display == "none") {
  		pane = document.getElementById("explainPlan." + statementNumber);
    }
  }
  else {
	  pane = document.getElementById(regionName + statementNumber);
	}
  
  img = document.getElementById(iconName + statementNumber);
  if (pane.style.overflowY == 'auto') {
    pane.style.overflowY =  'visible';
  	pane.style.height = pane.scrollHeight + "px";
    img.src = '/XFILES/lib/icons/' + restoreIcon;
  }
  else {
    pane.style.overflowY =  'auto';
    // alert('Scroll : ' + pane.scrollHeight + '. Overflow : ' + pane.offsetHeight + '. Client : ' + pane.clientHeight);
   	pane.style.height = '';
   	if (pane.scrollHeight > 250) {
   		pane.style.height = "250px";
    }
    img.src = '/XFILES/lib/icons/' + expandIcon;
  }
}

function processReturnCode(nodeList, step, outputTarget) {

  var rows = 0;
  
  outputTarget.innerHTML = "";

  var returnElement = nodeList.item(0);
  if (useMSXML) {
    rows = returnElement.text;
  }
  else {
  	rows = returnElement.textContent;
  }

  var ddlTarget = step.getDDLTarget();
  var statementType = step.getStatementType();
  
  var bold = document.createElement("B");
  outputTarget.appendChild(bold)
  
  // alert("processReturnCode(" + statementType + "," + rows + ")");

  if (ddlTarget) {
    firstChar = ddlTarget.substr(0,1).toUpperCase();
    ddlTarget = firstChar + ddlTarget.substr(1);
  }

  if (statementType == "PLSQL") {
    bold.appendChild(document.createTextNode("PL/SQL procedure successfully completed."));
  }

  if (statementType == "COMMIT") {
    bold.appendChild(document.createTextNode("Commit complete."));
  }

  if (statementType == "INSERT") {
    if (rows == 1) {
      bold.appendChild(document.createTextNode(rows + " row Inserted."));
    }
    else {
      bold.appendChild(document.createTextNode(rows + " rows Inserted."));
    }
  }

  if (statementType == "UPDATE") {
    if (rows == 1) {
      bold.appendChild(document.createTextNode(rows + " row Updated."));
    }
    else {
      bold.appendChild(document.createTextNode(rows + " rows Updated."));
    }
  }

  if (statementType == "DELETE") {
    if (rows == 1) {
      bold.appendChild(document.createTextNode(rows + " row Deleted."));
    }
    else {
      bold.appendChild(document.createTextNode(rows + " rows Deleted."));
    }
  }

  if (statementType == "GRANT") {
    bold.appendChild(document.createTextNode("Grant succeeded."));
  }

  if (statementType == "CREATE") {
    bold.appendChild(document.createTextNode(ddlTarget + " created."));
  }

  if (statementType == "DROP") {
    bold.appendChild(document.createTextNode(ddlTarget +  " altered."));
  }

  if (statementType == "ALTER") {
    bold.appendChild(document.createTextNode(ddlTarget +  " altered."));
  }

  if (statementType == "PURGE") {
    bold.appendChild(document.createTextNode("Recyclebin purged."));
  }
  style = outputTarget.style;
  style.height = '1.5em';
  style.overflowX = 'visible';
  style.overflowY = 'visible';
}

function displayJSON(soapResponse, namespaces, step) {

  nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[starts-with(.,'[') or starts-with(.,'{')]",namespaces);
  if (nodeList.length > 0 ) {
    // Output contains JSON ....
    var rowList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW",namespaces );
    for (var i=0; i < rowList.length; i++) {
  	  var row = new xmlElement(rowList.item(i));
   	  var colList = row.selectNodes("*",namespaces);
 	    for (var j=0; j<colList.length; j++) {
    		var col = new xmlElement(colList.item(j));
    	  if ((col.getTextValue().charAt( 0 ) == '{') || (col.getTextValue().charAt( 0 ) == '[')) {
    	    var documentLocator = "jsonValue" + "." + step.getStatementId() + "." + (i+1) + "." + (j+1);
  	    	var jsonContent;
  	      try {
  	      	jsonContent = JSON.parse(col.getTextValue());
  	      }
  	      catch (e) {
  	      	jsonContent = new Object();
          	jsonContent.Error = "Invalid JSON detected";
           	jsonContent.Content = col.getTextValue();
    	    }
    	    prettyPrintJSONColumn(jsonContent,documentLocator);
    	  }
      }
    }
  }

}

function displayXML(soapResponse, namespaces,step) {
	
  nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[*]",namespaces);
  if (nodeList.length > 0 ) {
    // Output contains XML....
    var rowList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW",namespaces );
    for (var i=0; i < rowList.length; i++) {
  	  var row = new xmlElement(rowList.item(i));
   	  var colList = row.selectNodes("*",namespaces);
 	    for (var j=0; j<colList.length; j++) {
 		    var col = new xmlElement(colList.item(j));
 		    var childList = col.selectNodes("*",namespaces);
    	  if (childList.length > 0 ) {
    		  var documentLocator = step.getStatementId() + "." + (i+1) + "." + (j+1);
     	    prettyPrintXMLColumn(col,"xmlValue." + documentLocator);
  	    }
      }
    }  
  }
}

function resetResultsWindow(statementId)
{
  var results = document.getElementById("result." + statementId);
  hideSiblings(results);
  var explainPlan = document.getElementById("explainPlan." + statementId);
  hideSiblings(explainPlan)
  
  resultsDiv = results.parentNode;
  resultsDiv.style.display = "block";
   
  explainDiv = explainPlan.parentNode;
  explainDiv.style.display = "none";

  var img          = document.getElementById("toggleResultsPlan." + statementId);
  img.src = "/XFILES/lib/icons/showPlan.png";

  var img          = document.getElementById("resizeOutput." + statementId);
  img.src = "/XFILES/lib/icons/expandOutput.png";
  
}  

function sizeOutputWindow(activeWindow,statementId) {

    var newHeight;

    newHeight=activeWindow.scrollHeight;

   	var remainingHeight = window.innerHeight  - activeWindow.offsetTop - 20;
   	if ( newHeight > remainingHeight) {
    		newHeight = remainingHeight;
  	}
    activeWindow.style.height = newHeight + "px";
 	  activeWindow.style.overflowX = 'auto';
	  activeWindow.style.overflowY = 'auto';

}

function displayResponse(mgr, step) {

  var outputTarget;
  try {
    var soapResponse = mgr.getSoapResponse("runtime.displayResponse");  
  }
  catch (e) {
  	if (e.getErrorCode() == 6) {
      outputTarget = getOutputTarget("result.",step.getStatementId(),soapResponse);
      var executeButton = document.getElementById('statementExecute.' + target);
      executeButton.style.display = "inline-block";
      executeButton.src = "/XFILES/lib/icons/executeSQL.png";
	    executeButton.disabled = false;
      xmlToHTML(outputTarget,e.xml,errStackXSL)
      resetResultsWindow(step.getStatementId());
      sizeOutputWindow(outputTarget,step.getStatementId());
	    step.pauseExecution();
      return false;
 	  }
    else {
      error = new xfilesException("runtime.displayResponse",11,null,e);
	    error.setDescription("Unexpected Runtime Error.");
      throw error;
    }
  }
  
  var namespaces = xfilesNamespaces; 
  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
  if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv") {
    outputTarget = getOutputTarget("result.",step.getStatementId(),soapResponse);
    // Push the Statement ID into the SOAP RESPONSE so that XML areas have unqiue id's
    soapResponse.getDocumentElement().setAttribute('statementId',step.getStatementId());
    xmlToHTML(outputTarget,soapResponse,FormatResponseXSL,false);
    displayXML(soapResponse, namespaces, step)
    displayJSON(soapResponse, namespaces, step)
    resetResultsWindow(step.getStatementId());
    sizeOutputWindow(outputTarget,step.getStatementId());
    return true;
  }
      
  if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/EXECUTESQL") {
    outputTarget = getOutputTarget("result.",step.getStatementId(),soapResponse);
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    processReturnCode(nodeList,step,outputTarget);
    resetResultsWindow(step.getStatementId());
    sizeOutputWindow(outputTarget,step.getStatementId());
    return true;
  }

  if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/DESCRIBE") {
    outputTarget = getOutputTarget("result.",step.getStatementId(),soapResponse);
    var rowsetNode = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:ROWSET",namespaces).item(0);
    rowsetNode.setAttribute('statementId',step.getStatementId());
    xmlToHTML(outputTarget,soapResponse,FormatDescribeXSL,false);
  
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN//tns:SCHEMA_DEFINITION/*",namespaces);
    if (nodeList.length > 0) {
      var xmlArea = document.getElementById('xmlValue.' + step.getStatementId());
      prettyPrintXMLElement(new xmlElement(nodeList.item(0)),xmlArea);
    }
    
    resetResultsWindow(step.getStatementId());
    sizeOutputWindow(outputTarget,step.getStatementId()); 
    return true;
  }
 
  if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/EXPLAINPLAN") {
    outputTarget = getOutputTarget("explainPlan.",step.getStatementId(),soapResponse);
    xmlToHTML(outputTarget,soapResponse,FormatXPlanXSL,false);
    resetResultsWindow(step.getStatementId());
    sizeOutputWindow(outputTarget,step.getStatementId());
    return true;
  }

  error = new xfilesException("runtime.displayResponse",11,null,e);
  error.setDescription("Unexpected Soap Response Error.");
  error.setXML(soapResponse);
  throw error;
}

function calculateElapsedTime(startTime, endTime, statementId) {

  var elapsedTimeMS =  endTime.getTime() - startTime.getTime();
  var timing = document.getElementById("timing." + statementId) ;
  timing.innerHTML = "Elapsed : " + elapsedTimeMS + "ms";
 
}

function processResponse(mgr, step, serviceType, requestDate) {

  try {
    var responseDate = new Date();
  
   	var success = displayResponse(mgr,step);
  
    var elapsedTimeMS =  responseDate.getTime() - requestDate.getTime();
    calculateElapsedTime(requestDate,responseDate,step.getStatementId());
    showTiming(step.getStatementId());
  
    if ((serviceType == QUERY_SERVICE) && (showExplainPlan(step.getStatementId()))) {
    	invokeWSXPlan(step);
    }
    else {
      loadNextStatement(step,success);
    }
  } 
  catch (e) {
    handleException('runtime.processResponse',e,null);
  }
}

function invokeWSXPlan(step) {

  var statementBody = 	step.getStatement()

	// Explain Plan for XQuery operation requires the use of select * from XMLTABLE(XQUERY);
    	
 	if (step.getStatementType() == "XQUERY") {
 		statementBody = "select * from XMLTABLE('" + statementBody + "')"
  }
	
	var statementXML = new xmlDocument().parse('<statement/>')
  var text = statementXML.createTextNode(statementBody);
  statementXML.getDocumentElement().appendChild(text);
  
  var schema  = "XFILES";
  var package = "XFILES_WEBDEMO_SERVICES";
  var method =  "EXPLAINPLAN";

	var mgr = soapManager.getRequestManager(schema,package,method);	
	var ajaxControl = mgr.createPostRequest();
  var requestdate = new Date();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) {  processResponse(mgr, step, XPLAN_SERVICE, requestdate)}};
  
	var parameters = new Object;

	var xparameters = new Object;
	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML
		
  mgr.sendSoapRequest(parameters,xparameters); 
  
}

function invokeWSDescribe(step) {

  var ownerName = document.getElementById('demonstrationUsername').value
  var text = step.getStatement();
  var objectName = text.split(" ",2)[1];
  objectName = objectName.replace( /^\s+/g, "" );// strip leading
  objectName = objectName.replace( /\s+$/g, "" );// strip trailing
  if (objectName.indexOf('"') == 0) {
  	objectName = objectName.substring(1,objectName.length-1);
  }
  
  var schema  = "XFILES";
  var package = "XFILES_WEBDEMO_SERVICES";
  var method =  "DESCRIBE";

	var mgr = soapManager.getRequestManager(schema,package,method);
 	var ajaxControl = mgr.createPostRequest();
  var requestdate = new Date();
	ajaxControl.onreadystatechange = function() { if( ajaxControl.readyState==4 ) { processResponse(mgr, step, DESCRIBE_SERVICE, requestdate)}};
  
	var parameters = new Object;
	parameters["P_OBJECT_NAME-VARCHAR2-IN"]   = objectName
	parameters["P_OWNER-VARCHAR2-IN"]   = ownerName
	
  mgr.sendSoapRequest(parameters);

}

function invokeWSHelper(step) {

	var statementXML = new xmlDocument().parse('<statement/>')
  var text = statementXML.createTextNode(step.getStatement());
  statementXML.getDocumentElement().appendChild(text);
  
  var schema  = "XFILES";
  var package = "XFILES_WEBDEMO_SERVICES";
  var method =  "EXECUTESQL";

	var mgr = soapManager.getRequestManager(schema,package,method);
  var ajaxControl = mgr.createPostRequest();
  var requestdate = new Date();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) {  processResponse(mgr, step, EXEC_SERVICE, requestdate)}};

	var parameters = new Object;

	var xparameters = new Object;
	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML
		
  mgr.sendSoapRequest(parameters,xparameters); 
   
}

function invokeORAWSV(step) {

  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var requestdate = new Date();  
  var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) {  processResponse(mgr, step, QUERY_SERVICE, requestdate)}};
  
  if (step.getStatementType() == "XQUERY") {
    mgr.executeXQuery(step.getStatement());
  }
  else {
    mgr.executeSQL(step.getStatement());
  }

}
function loadViewer(step) {

	var currentStatement = step.getStatementId();

  var statementPane = document.createElement("TR");
  statementPane.id = "Statement." + currentStatement;
  
  cell       = document.createElement("TD")
  statementPane.appendChild(cell);
 
  statementRegion = document.createElement("DIV")
  cell.appendChild(statementRegion);
  statementRegion.id = "statementWindow." + currentStatement;
  
  var sourceArea = null;
  
  if (step.getContentType() == "text/plain") {  
    sourceArea = document.createElement("TEXTAREA");
    sourceArea.readOnly = true;
    sourceArea.id = "statementArea." + currentStatement;
  }
  
  if (step.getContentType() == "text/xml") {

    sourceArea = document.createElement("PRE");
    statementArea.id = "statementArea." + currentStatement;

    style = statementArea.style;
    style.marginBottom    = '5px';
    style.paddingRight    = '5px';
    style.paddingLeft     = '5px';
    style.paddingBottom   = '5px';
    style.paddingTop      = '5px';
    style.whiteSpace      = 'pre';
    style.color           = '#000000';
    style.backgroundColor = '#efefff';
    style.fontWeight      = 'bold';
    style.overflowX       = 'auto';
    style.overflowY       = 'auto';
     
    prettyPrintXML(new xmlDocument().parse(step.getDocumentContent()),sourceArea);

  }
  
  statementRegion.appendChild(sourceArea);

  sourceArea.value = step.getDocumentContent();
  var statementWindow = step.getStepWindow();
  statementWindow.appendChild(statementPane);
  
}

function generateIcons(stepId,statementId) {
	  
	  
	  var actions = document.getElementById("actions." + stepId);
	  var action  = document.createElement("span");
    actions.appendChild(action);
    action.id = "actions." + statementId;
    action.style.whitespace = "nowrap";
    action.style.marginBottom    = '0px';
        
    hideSiblings(action,"inline-block");

    var span = document.createElement("span");
    action.appendChild(span);
    span.style.display="inline-block";
   
    img = document.createElement("img");
    span.appendChild(img);
    img.onclick = function(){executeStatement(statementId); return false;};
    img.id      = "statementExecute." + statementId;
    img.src     = "/XFILES/lib/icons/executeSQL.png";
    img.alt     = "Execute Statement";
    img.align   = "absmiddle";
    img.width   = 16;
    img.height  = 16;
    img.border  = 0;
 
    var spacer = document.createElement("span");
    span.appendChild(spacer);
    spacer.style.display="inline-block";
    spacer.style.width="5px";
    
    span = document.createElement("span");
    action.appendChild(span);
    span.style.display="none";
   
    img = document.createElement("img");
    span.appendChild(img);
    img.onclick = function(){resizeWindow(statementId,'statement.','resizeStatement.','expandCodeView.png','restoreCodeView.png'); return false;};
    img.id      ="resizeStatement." + statementId;
		img.src     = "/XFILES/lib/icons/expandCodeView.png";
    img.alt     = "Toggle SQL Window Size";
    img.align   = "absmiddle";
    img.width   = 16;
    img.height  = 16;
    img.border  = 0;
 
    spacer = document.createElement("span");
    span.appendChild(spacer);
    spacer.style.display="inline-block";
    spacer.style.width="5px";    
    
    span = document.createElement("span");
    action.appendChild(span);
    span.style.display="none";
   
    img = document.createElement("img");
    span.appendChild(img);
    img.onclick = function(){resizeWindow(statementId,'outputWindow.','resizeOutput.','expandOutput.png','restoreOutput.png'); return false;};
    img.id      = "resizeOutput." + statementId;
    img.src     = "/XFILES/lib/icons/expandOutput.png";
    img.alt     = "Toggle Output Window Size";
    img.align   = "absmiddle";
    img.width   = 16;
    img.height  = 16;
    img.border  = 0;
 
    spacer = document.createElement("span");
    span.appendChild(spacer);
    spacer.style.display="inline-block";
    spacer.style.width="5px";

    span = document.createElement("span");
    action.appendChild(span);
    span.style.display="none";
   
    img = document.createElement("img");
    span.appendChild(img);
    img.onclick = function(){toggleResultsPlan(statementId); return false;};
    img.id      = "toggleResultsPlan." + statementId;
    img.src     = "/XFILES/lib/icons/showPlan.png";
    img.alt     = "Toggle Explain Plan";
    img.align   = "absmiddle";
    img.width   = 16;
    img.height  = 16;
    img.border  = 0;

    spacer = document.createElement("span");
    span.appendChild(spacer);
    spacer.style.display="inline-block";
    spacer.style.width="5px";
 
}

function showSQLStatement(step)
{
  var anchor;
  var img;
  var style

  var stepWindow       = step.getStepWindow();
	var currentStatement = step.getStatementId();
    
  if (!step.isStepComplete()) {
  	
  	// Create a the Source Code Tab
  	
  	var tabs        = document.getElementById("tabSet." + step.getStepId());
    var statements  = document.getElementById("statement." + step.getStepId());
    var results     = document.getElementById("result." + step.getStepId());
    var plans       = document.getElementById("explainPlan." + step.getStepId()); 
    var timings     = document.getElementById("timing." + step.getStepId()); 

    var autoTraceOption = document.getElementById("doExplainPlan." + step.getStepId());
    if ((step.getStatementType() == "SQL") || (step.getStatementType() == "XQUERY")) {
    	autoTraceOption.style.display="inline-block";
      var doAutoTrace = document.getElementById("toggleExplainPlan." + step.getStepId());
    	doAutoTrace.checked = autoTraceEnabled;
    }
    else {
    	autoTraceOption.style.display="none";
    }
    
    var doTiming = document.getElementById("toggleTiming." + step.getStepId());
    doTiming.checked = timingEnabled;

    var tab = document.createElement("SPAN");
  	tabs.appendChild(tab);
		setActiveTab(tab);
    tab.id = "tab." + currentStatement;
    currentTab = currentStatement;
		tab.onclick = function(){switchTab(currentStatement); return false;};
   	tab.innerHTML = "Statement " + step.getSqlId();
  	
    var statement        = document.createElement("PRE");    
    statements.appendChild(statement);
    hideSiblings(statement)
    statement.id         = "statement." + currentStatement;
    statement.className  = "sourceCodeRegion";

    var result = document.createElement("PRE");
    results.appendChild(result);
    hideSiblings(result);
    result.id            = "result." + currentStatement;
    result.style.display = "none";
    result.className     = "resultsRegion";

    generateIcons(step.getStepId(),step.getStatementId());    
   
    var plan             = document.createElement("PRE");
    plans.appendChild(plan);
    hideSiblings(plan);
    plan.id              = "explainPlan." + currentStatement;
    plan.className       = "explainPlanRegion";

    var timing           = document.createElement("PRE");
    timings.appendChild(timing);
    hideSiblings(timing);
    timing.id            = "timing." + currentStatement;
    timing.className     = "timingDisplay";
    timing.innerHTML     = "Elapsed : ---";
    showTiming(currentTab)
    
    statement.innerHTML = step.getHTML();
    var lineCount = statement.getElementsByTagName("BR").length;
    if (lineCount > 20) {
      statement.style.height     = '20em';
      statement.style.overflowY  = 'auto';
	    document.getElementById("resizeStatement." + currentStatement).parentNode.style.display="inline-block";
    }
    
  }

}

function runCurrentStatement(step) {

/*
**
** Run the current statement in the current Step.
**
*/

  // Disable the Execute button while the step is executed.
  		
  var executeButton = document.getElementById("statementExecute." + step.getStatementId());
  executeButton.style.display = "none";
  executeButton.disabled = true;

  if ((step.getStatementType() == "SQL") || (step.getStatementType() == "XQUERY")) {
    invokeORAWSV(step);
  }
  else {
    if (step.getStatementType() == "DESCRIBE") {
      invokeWSDescribe(step);
    }
    else {
      invokeWSHelper(step);
    }
  }
  	
}

function showStatement(step) {

  if (step.isClientCommand()) {
    return;
  }
  
  if ( step.isViewer() ) {
  	 return;
  }

  if (step.isSQLScript()) {
    showSQLStatement(step);
    return;
  }
  
}

function loadNextStatement(step,success) {
	
  // If the step is not re-runnable change the ICON for the current statement to StopDisabled and disable the control.

	rerunnableStep = document.getElementById('isRerunnable.' + step.getStepId());
	executeButton = document.getElementById("statementExecute." + step.getStatementId());
	if (success && !rerunnableStep) {
    executeButton.style.display = "none";
	  executeButton.disabled = true;
	}
	else {
    executeButton.style.display = "inline-block";
    executeButton.src = "/XFILES/lib/icons/executeSQL.png";
	  executeButton.disabled = false;
	}

  // If this step has already been executed do not autorun the next step

  if (step.getStatementExecuted()) {
    return;
  }
  
  step.setStatementExecuted();

	if (step.isStepComplete()) {
		return;
	}
	
	step.loadNextStatement();
  showStatement(step);
  
  if ((!step.isStepComplete()) && (!step.isExecutionPaused())) {
    runCurrentStatement(step);
  }
  else {
  	switchTab(firstStatementId);
  }
  	
}

function initializeStep(stepId) {
  
  // Create and display a step.

  var step = new stepContainer(stepId);
  steps[stepId] = step;
  showStatement(step);

}

function validateCredentialsOnEnter(e,username,password) {
  var keynum
  var keychar
  var numcheck
  
  // alert('Password Key Down Event');
  
  if (window.event) { 
    // Internet Explorer
    keynum = e.keyCode 
  }
  else {
    if (e.which) {
      // Netscape/Firefox/Opera
      keynum = e.which
    }
  }
  
  if (keynum == 13) {
    // Enter Key
    validateCredentials(username,password)
  }
  else {
    return true;
  }
}

function validateCredentials(username,password) {

  if (isEmptyString(username.value)) {
  	showUserErrorMessage("Enter username");
  	username.focus();
  	return false;
  }

  if (isEmptyString(password.value)) {
  	showUserErrorMessage("Enter password");
  	password.focus();
  	return false;
  }

  try {
	
    if (validCredentials(username.value,password.value)) {
      closePopupDialog();
    	showStep(currentStepId);
    }
    else {
      showUserErrorMessage("Invalid Username / Password : Please Try Again");
      if (username.disabled) {
        password.focus();
      }
      else {
        username.focus();
      }
      return false;
    }
  } 
  catch (e) {
    handleException('webDemo.validateCredentials',e,null);
  }
}  

function setUsernamePassword(targetUser) {

  var username = document.getElementById('demonstrationUsername');
  username.value = targetUser;
  username.disabled = true;   
  
  var password =document.getElementById('demonstrationPassword');
  password.value = 'XXXXXXX';
  password.disabled = true;

}

function authenticateUser(targetUser) {

  // clearAuthenticationCache();  
  
  // Show SQL Authentication Dialog
  
  openPopupDialog(null,"sqlAuthentication");
  var username = document.getElementById('sqlUsername');
  var password = document.getElementById('sqlPassword');

  if (targetUser) {
    username.value = targetUser;
    username.disabled = true;   
  }
  else {
    username.value = '';
    username.disabled = false;   
  }

  password.value = '';
  
  if (username.disabled) {
    password.focus();
  }
  else {
    username.focus();
  }
}

function isCorrectUser(stepId) {
	
	/*
	**
	** Ensure that the current session is authenticated as the target user for the step before proceeding..
	** Note httpUsername is set to the current authenticated user or anonymous when entering the page.
	**
	*/
		
  currentStepId = stepId;

  if (document.getElementById('targetUser.' + stepId)) {
    var targetUsername = document.getElementById('targetUser.' + stepId).value;
  
    if (targetUsername == httpUsername) {
  	  setUsernamePassword(targetUsername);
  	  return true;
    }
  
    // Current httpUsername is not the correct user for this step.
    authenticateUser(targetUsername);
    // Processing will continue once the user is correctly authenticated.
    return false;
  }
  else  {
  	if (sqlScriptUsername) {
  		if (sqlScriptUsername == httpUsername) {
     	  setUsernamePassword(sqlScriptUsername);
  	    return true;
  	  }
  	  else {
        authenticateUser(sqlScriptUsername);
  	    return false;
  	  }
  	}
  	else {
	    // No username specified in URL when running a sql script file directly.
  	  if (httpUsername != 'ANONYMOUS') {
  		  // Run the script as the current authenticated HTTP User.
     	  setUsernamePassword(httpUsername);
  	    return true;
      }
      else {
      	// ANONYMOUS is not allowed to run scripts...
  	    authenticateUser();
  		  return false;
  		}
    }
  }
}

function resizeDisplayWindow() {

  resizeTimer = 0;
  var displayWindow = document.getElementById('stepDisplay.' + currentStepId);
  displayWindow.style.height = (document.documentElement.clientHeight - 200) + "px";

  var screenshot = document.getElementById('stepScreenshot.' + currentStepId);
  if (screenshot) {
	  screenshot.style.height = displayWindow.style.height;
	  screenshot.style.width = document.documentElement.clientWidth - 90;
  }
}

function showStep(stepId) {

  /*
  **
  ** Get the step location, description and targetUser
  **
  ** If the current user is the user required to run the step make the outputArea for the step visible
  ** and, for a SQL based step, load the first statement.
  **
  */

  currentStepId = stepId;
  document.getElementById('Step.' + stepId).style.display = "block";

  resizeDisplayWindow();
  window.onresize = function(){if (resizeTimer) clearTimeout(resizeTimer); resizeTimer = setTimeout(resizeDisplayWindow, 250);};

  if (isCorrectUser(stepId)) {

    var displayWindow = document.getElementById('stepDisplay.' + stepId);
    displayWindow.style.display = "block";

    if (steps[stepId] == null) {
      initializeStep(stepId);  
    }
  }

}	

function executeStatement(target) {
	
	try {
  	executeButton = document.getElementById('statementExecute.' + target);
  	
    if (executeButton.disabled) {
  	  return;
  	}
  	
    var x = target.split('.')
    var stepId = parseInt(x[0]);
    var statementId = parseInt(x[1]);
  
    if (isCorrectUser(stepId)) {
  
      executeButton.disabled = true;
      executeButton.style.display = "none";
      
      firstStatementId = target;
     
      var step = steps[stepId];  
      step.setStatement(statementId);
      step.resumeExecution();
      runCurrentStatement(step);
    }
  }
  catch (e) {
    handleException('runtime.executeStatement',e,null);
  }
}

function removeChildren(collection) {
	
  	while(collection.hasChildNodes()) {
     collection.removeChild(collection.firstChild);
   }
}

function resetStep(stepId) {

  steps[stepId] = null;
  var outputArea = document.getElementById("stepDisplay." + stepId);
  if (outputArea) {
  	
  	tabs          = document.getElementById("tabSet." + stepId);
    statements    = document.getElementById("statement." + stepId);
    results       = document.getElementById("result." + stepId);
    actions       = document.getElementById("actions." + stepId); 
    plans         = document.getElementById("explainPlan." +stepId); 
    timings       = document.getElementById("timing." + stepId); 

    removeChildren(tabs);
    removeChildren(statements);
    removeChildren(results);
    removeChildren(actions);
    removeChildren(plans);
    removeChildren(plans);

  }
  
  showStep(stepId);

}

function showNextStep(stepId) {

	try {
		var targetStep = stepId + 1;
    document.getElementById('sqlAuthentication').style.display = "none";
	  document.getElementById('Step.' + stepId).style.display = "none";
    document.getElementById('stepDisplay.' + stepId).style.display = "none";
    showStep(targetStep);
  }
  catch (e) {
    error = new xfilesException("runtime.showNextStep",11,null,e);
    handleException('runtime.showNextStep',error,null);
  }
  
}

function showPreviousStep(stepId) {

  try {
  	var targetStep = stepId - 1;
    document.getElementById('sqlAuthentication').style.display = "none";
	  document.getElementById('Step.' + stepId).style.display = "none";
    document.getElementById('stepDisplay.' + stepId).style.display = "none";
    showStep(targetStep);
  }
  catch (e) {
    error = new xfilesException("runtime.showPreviousStep",11,null,e);
    handleException('runtime.showPreviousStep',error,null);
  }

}
function getOutputTarget(name,statementId,response) {

	var outputTargetName = name + statementId;
  var outputTarget = document.getElementById(outputTargetName); 

  if (!outputTarget) {
    error = new xfilesException("runtime.getOutputTarget",11,null,null);
	  error.setDescription("Unable to locate output area [" +  outputTargetName + "]");
    error.setXML(response)	     
    throw error;
  }
  
  return outputTarget;

}
   
function completeSimulation(mgr, stepId) {

  try {
    document.getElementById("simulate."+ stepId).src = "/XFILES/lib/icons/simulationComplete.png";
    var soapResponse = mgr.getSoapResponse("webDemo.completeSimulation");
   	showInfoMessage("Simulation Complete.");
  }
  catch (e) {
    error = new xfilesException("runtime.completeSimulation",11,null,e);
    handleException('runtime.completeSimulation',error,null);
  }
}

function simulateStep(stepId, script) {

  try {
    var simulation = document.getElementById("simulate."+ stepId);
    
    if (simulation.disabled) {
    	return;
    }
    
    simulation.disabled = true;
    simulation.src = "/XFILES/lib/icons/simulationRunning.png";
  
    var sqlScript = getDocumentContentImpl(script);

  	var statementXML = new xmlDocument().parse('<statement/>')
    var text = statementXML.createTextNode(sqlScript);
    statementXML.getDocumentElement().appendChild(text);
    
    var schema  = "XFILES";
    var package = "XFILES_WEBDEMO_SERVICES";
    var method =  "EXECUTESQL";
  
  	var mgr = soapManager.getRequestManager(schema,package,method);
  	var ajaxControl = mgr.createPostRequest(); 
    ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) {  completeSimulation(mgr, stepId)}};

  	var parameters = new Object;
  
  	var xparameters = new Object;
  	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML
  		
    mgr.sendSoapRequest(parameters,xparameters); 
    
  }
  catch (e) {
    handleException('runtime.simulateStep',e,null);
  }
  
}

function switchTab(statementId) {
	
	  currentTab    = statementId;
		var tab       = document.getElementById("tab." + statementId);
    var statement = document.getElementById("statement." + statementId);
    var actions   = document.getElementById("actions." + statementId);
    var result    = document.getElementById("result." + statementId);
    var plan      = document.getElementById("explainPlan." + statementId); 
    var timing    = document.getElementById("timing." + statementId); 

    setActiveTab(tab);
    hideSiblings(statement);
    hideSiblings(actions,"inline-block");
    hideSiblings(result);
    hideSiblings(plan);
    hideSiblings(timing,"inline-block");
   
    var toggleResultsControl = document.getElementById("toggleResultsPlan." + statementId);
    if (toggleResultsControl.style.display != "none") {
      if (result.parentNode.style.display != "none") {
		    toggleResultsControl.src = "/XFILES/lib/icons/showPlan.png";
		  }
      else {
		    toggleResultsControl.src = "/XFILES/lib/icons/showResults.png";
      } 
    }  
     
}  

function loadIFrameXML(iFrameId,targetURL,contentType) {
	var iFrame = document.getElementById(iFrameId)
	if ((contentType == "text/xml") || (contentType == "application/xml")) {
	  iFrame.src = "/XFILES/xmlViewer/xmlViewer.html?target=" + encodeURIComponent(targetURL);	
	  return;
	}
	
	if ((contentType == "text/plain") || (contentType == "text/html")) {
		iFrame.src = targetURL
	  return;
	}
}

function showFolderListing(mgr, outputWindow, stylesheetURL) {

  try {
    var soapResponse = mgr.getSoapResponse("runtime.showFolderListing");
    
    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
  
    var newResource = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_FOLDER/res:Resource",namespaces).item(0);
    resource = importResource(newResource);
	  folderXSL = loadXSLDocument(stylesheetURL);
    transformToHTML(outputWindow,resource,stylesheetURL);
    outputWindow.style.display = "block";
    
    var newHeight;
    outputWindow.style.height = "1px";
    newHeight=outputWindow.scrollHeight;
    
    if (newHeight == 0) {
    	outputWindow.style.display="none";
    }
    else {
    	// Set Height to Zero and Display - needed to get offsetTop
    	outputWindow.style.height = "0px";
    	outputWindow.style.display = "block";
    	var remainingHeight = window.innerHeight  - outputWindow.offsetTop - 20;
    	if (newHeight > remainingHeight) {
    		newHeight = remainingHeight;
    	}
      outputWindow.style.height = (newHeight) + "px";
    }
  
  }    
  catch (e) {
   handleException('runtime.showFolderListing',e,resourceURL);
  }
} 

function showFolderContent(screenshot,target,folderURL) {
  
  var img = document.getElementById(screenshot);
  img.style.display = "none";

  var outputWindow = document.getElementById(target);

  var schema  = "XFILES";
  var package = "XFILES_SOAP_SERVICES";
  var method =  "GETFOLDERLISTING";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { showFolderListing(mgr, outputWindow, '/XFILES/lite/xsl/FolderListing.xsl') } };

	var parameters = new Object;
	parameters["P_FOLDER_PATH-VARCHAR2-IN"]   = folderURL;
  parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
  parameters["P_INCLUDE_METADATA-VARCHAR2-IN"] = includeMetadata;
	mgr.sendSoapRequest(parameters);

}

function resizeIFrame(iFrame) {
 
    var newHeight;
    var newWidth;

    iFrame.style.height = "1px";
    iFrame.style.display = "block";

    newHeight=iFrame.contentWindow.document.body.scrollHeight;
    // newWidth=iFrame.contentWindow.document.body.scrollWidth;

    if (newHeight == 0) {
    	iFrame.style.display="none";
    }
    else {
    	// Set Height to Zero and Display - needed to get offsetTop
    	iFrame.style.height = "0px";
    	iFrame.style.display = "block";
    	var remainingHeight = window.innerHeight  - iFrame.offsetTop - 20;
    	if (newHeight > remainingHeight) {
    		newHeight = remainingHeight;
    	}
      iFrame.style.height = (newHeight) + "px";
      // iFrame.style.width = (neWidth) + "px";
    }
}