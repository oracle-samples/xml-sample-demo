
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

var sqlScriptUsername = null;
var steps = new Array();
var demoPlayer = null;

var soapFaultXSLSource = 
'  <xsl:stylesheet version="1.0" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:oraerr="http://xmlns.oracle.com/orawsv/faults" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xdbpm="http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_HELPER">' + '\n' +
'  	<xsl:output indent="yes" method="html"/>' + '\n' +
'  	<xsl:template match="/">' + '\n' +
'  		<xsl:for-each select="//oraerr:OracleErrors[oraerr:OracleError]">' + '\n' +
'  			<xsl:for-each select="oraerr:OracleError">' + '\n' +
'  				<xsl:if test="((position() > 1) or (ErrorNumber !=&quot;ORA-19202&quot;))">' + '\n' +
'	  				<B>' + '\n' +
' 	 					<xsl:value-of select="oraerr:ErrorNumber"/>' + '\n' +
'  						<xsl:text>:</xsl:text>' + '\n' +
'  						<xsl:value-of select="oraerr:Message"/>' + '\n' +
'  					</B>' + '\n' +
'     	  	<xsl:if test="position() != last()">' + '\n' +
'   	  			<BR/>' + '\n' +
'   				</xsl:if>' + '\n' +
'         </xsl:if>' + '\n' +
'  			</xsl:for-each>' + '\n' +
'  		</xsl:for-each>' + '\n' +
'  	</xsl:template>' + '\n' +
'  </xsl:stylesheet>';

var soapFaultXSL;

function SqlScript(id) {

  // Declare private member "self". Set it to "this". This makes the object available to it's private methods.
  // Workaround for an error in the ECMAScript Language Specification which causes this to be set incorrectly for inner functions

  var self = this;

  var scriptId = id;
  var autoRun          = true;
  var executionPaused  = false;
  var scriptComplete   = false;

  var autoTraceEnabled = false;
  var timingEnabled    = false;

  var sqlScript;
  var sqlScriptURL;
  var scriptLocation;
  var scriptContent;

  var commandId         = 1;
  var statementList     = new Array();
  
  var username = getHttpUsername();

  function stripOracleCopyRightNotice() {
  	
  	/* Try to avoid displaying Oracle Copyright notices when processing SQL Scripts.. */
  	
    if ((sqlScript[3].indexOf("Copyright (c)") > -1) && (sqlScript[3].indexOf("Oracle and/or its affiliates.  All rights reserved.") > -1)) {
    	while (sqlScript[0].indexOf("*/") == -1) {
  	  	sqlScript.shift();
      }
      sqlScript.shift();
      sqlScript.shift();
    }
  }

  this.getScriptId  = function() {
    return scriptId;
  }

  this.getCommandId = function () {
  	return commandId;
  }

  this.getStatementId = function() {
    return self.getScriptId() + "." + self.getCommandId();
  }

	this.setUsername = function(sqlUsername) {
		username = sqlUsername;
	}

  this.getSqlUsername = function() {
  	return username;
  }

  this.getStatement = function() {
    return statementList[self.getCommandId()].sql.trim();
  }

  function loadStatement() {
  	statementList[self.getCommandId()] = new Object();
  	statementList[self.getCommandId()].isExecutable = true;
  	statementList[self.getCommandId()].executed = false;
  	statementList[self.getCommandId()].sql = sqlProcessor.readStatement(self)
  	statementList[self.getCommandId()].type = sqlProcessor.setStatementType(self,statementList[self.getCommandId()].sql);
  }

	this.setStatementExecutable = function(state) {
    statementList[self.getCommandId()].isExecutable = state;
	}

  this.isStatementExecutable = function() {
  	return statementList[self.getCommandId()].isExecutable;
  }

	this.setStatementHTML = function(html) {
    statementList[self.getCommandId()].html = html;
	}

  this.getStatementHTML = function() {
    return statementList[self.getCommandId()].html;
  }

  this.statementExecuted  = function() {
  	return statementList[self.getCommandId()].executed;
  };

  this.setStatementExecuted = function() {
  	return statementList[self.getCommandId()].executed = true;
  };

  this.getStatementType = function() {
    return statementList[self.getCommandId()].type;
  }

  this.setDDLTarget = function(target) {
    statementList[self.getCommandId()].ddlTarget = target;
  }

  this.getDDLTarget = function() {
    return statementList[self.getCommandId()].ddlTarget;
  };

  this.getScriptContent = function() {
	  return scriptContent;
	}

  this.isScriptComplete = function() {
	  return scriptComplete;
  };

  this.setScriptComplete = function() {
    scriptComplete = true;
  }

  this.isAutoRun = function() {
    return autoRun;
  };

  this.isExecutionPaused = function() {
   	return executionPaused;
  };

  this.setTiming = function (state)  {
  	timingEnabled = state
  }

  this.isTimingEnabled = function() {
   	return timingEnabled;
  };

  this.setAutoTrace = function (state)  {
  	autoTraceEnabled = state
  }

  this.isAutoTraceEnabled = function() {
   	return autoTraceEnabled;
  };

  this.getStepWindow = function () {
  	return document.getElementById(self.getStepId() + '.scriptDisplay');
  }

  this.setCommand = function (newCommandId) {
    commandId = newCommandId;
  };

  this.pauseExecution = function() {
    executionPaused = true;
  };

  this.resumeExecution  = function() {
    executionPaused = false;
  };

  this.loadScriptFromURL = function(URL) {
    scriptContent = getSQLScript(URL);
    loadStatement();
  }

  this.setCommands = function(sqlCommands) {
    scriptContent = sqlCommands.split('\n');
    loadStatement();
  }

  function getSQLScript ( URL ) {
    sqlScriptURL = URL;
    try {
      sqlScript  = getDocumentContentImpl(sqlScriptURL).split('\n');
    } catch (e) {
      var error = new xfilesException('sqlScript.getSQLScript',11, sqlScriptURL, e);
      throw error;
    }
    stripOracleCopyRightNotice()
    return sqlScript;
  }
  
  this.getSQLScriptURL = function () {
  	return sqlScriptURL
  }

  this.loadNextStatement = function() {
    self.setCommand(self.getCommandId() + 1);
    loadStatement()
  }

}

function DemonstrationStep(id) {

  // Declare private member "self". Set it to "this". This makes the object available to it's private methods.
  // Workaround for an error in the ECMAScript Language Specification which causes this to be set incorrectly for inner functions

  var self = this;

  var stepId;
  var commandId;

  var action

  var sqlScript;
  var documentURL;
  var documentContent;
  var contentType;
  var windowName;

	this.isClientCommand = function() {
		return action == "OSCMD";
  }

	this.isSQLScript = function () {
		return action == "SQL";
  }

	this.isViewer = function () {
		return action == "VIEW";
  }

	this.isLink = function () {
		return action == "HTTP";
  }

  this.getStepId = function() {
    return stepId;
  }

  this.getDocumentURL = function() {
    return documentURL;
  }

  this.getContentType = function() {
    return contentType;
  }

  this.getWindowName = function() {
    return windowName;
  }

  this.getSQLScript = function() {
  	return sqlScript;
  }

  this.setAutoTrace = function (state) {
  	sqlScript.setAutoTrace(state);
 	}

  this.setTiming = function (state) {
  	sqlScript.setTiming(state);
 	}

  this.runSQLCommand = function(commandId) {
  	sqlScript.setCommand(commandId);
  	sqlScript.resumeExecution();
  	sqlProcessor.runSQLCommand(sqlScript);
  }
  
  function initialize(id) {

    stepId = id
    action = document.getElementById(stepId + '.action').value;

    if (self.isSQLScript()) {
      var scriptLocation = document.getElementById(stepId + '.sqlScript').value;
      sqlScript = new SqlScript(id);
      sqlScript.loadScriptFromURL(scriptLocation);
    }
    else if (self.isViewer()) {
    	var locationInfo   = document.getElementById(stepId + '.target')
      documentURL   = makeLocal(locationInfo.value);
      locationInfo.value = makeRemote(documentURL);
      contentType   = document.getElementById(stepId + '.contentType').value;
    }
    else if (self.isLink()) {
    	documentURL   = makeLocal(document.getElementById(stepId + '.link').value);
    	var locationInfo   = document.getElementById(stepId + '.target')
      if (locationInfo != null) {   
        locationInfo.value = makeRemote(documentURL);
      }
      contentType = "text/html";
      windowName  = document.getElementById(stepId + '.windowName')
    }
  }

  initialize(id);

}

function DemonstrationPlayer() {


  // Declare private member "self". Set it to "this". This makes the object available to it's private methods.
  // Workaround for an error in the ECMAScript Language Specification which causes this to be set incorrectly for inner functions

  var self = this;

	var steps = new Array();

	var firstStatementId = null;

  function generateIcons(stepId,statementId, executable) {

  	  var actions = document.getElementById(stepId + ".actions");
  	  var action  = document.createElement("span");
      actions.appendChild(action);
      action.id = statementId + ".actions";
      action.style.whitespace = "nowrap";
      action.style.marginBottom    = '0px';

      hideSiblings(action,"inline-block");


      if (executable) {
        var span = document.createElement("span");
        action.appendChild(span);
        span.style.display="inline-block";
      
        var img = document.createElement("img");
        span.appendChild(img);
        img.onclick = function(){demoPlayer.executeStatement(statementId); return false;};
        img.id      = statementId + ".statementExecute";
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
      }
      
      span = document.createElement("span");
      action.appendChild(span);
      span.style.display="none";

      img = document.createElement("img");
      span.appendChild(img);
      img.onclick = function(){demoPlayer.resizePanel(statementId,'.statement','.resizeStatement','expandCodeView.png','restoreCodeView.png'); return false;};
      img.id      = statementId + ".resizeStatement";
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
      img.onclick = function(){demoPlayer.resizePanel(statementId,'.outputWindow','.resizeOutput','expandOutput.png','restoreOutput.png'); return false;};
      img.id      = statementId + ".resizeOutput";
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
      img.onclick = function(){demoPlayer.toggleResultsPanel(statementId); return false;};
      img.id      = statementId + ".toggleResultsPanel";
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
  
  function setViewer(step) {
    var iFrameID = step.getStepId() + ".iFrame"
    loadIFrame(iFrameID,step.getDocumentURL(),step.getContentType());
  }

  function setStatementTab (step) {

    var anchor;
    var img;
    var style
    var stepId      = step.getStepId();
    var sqlScript   = step.getSQLScript();
  	var statementId = sqlScript.getStatementId();

    if (document.getElementById(statementId + ".tab") == null) {

    	// Create a the Source Code Tab

    	var tabs            = document.getElementById(stepId + ".tabSet");
      var statements      = document.getElementById(stepId + ".statement");
      var results         = document.getElementById(stepId + ".result");
      var plans           = document.getElementById(stepId + ".explainPlan");
      var timings         = document.getElementById(stepId + ".timing");
      var autoTraceOption = document.getElementById(stepId + ".doExplainPlan");

      if ((sqlScript.getStatementType() == "SQL") || (sqlScript.getStatementType() == "XQUERY")) {
      	autoTraceOption.style.display="inline-block";
        var doAutoTrace = document.getElementById(stepId + ".toggleExplainPlan");
      	doAutoTrace.checked = sqlScript.isAutoTraceEnabled();
      }
      else {
      	autoTraceOption.style.display="none";
      }

      var doTiming = document.getElementById(stepId + ".toggleTiming");
      doTiming.checked = sqlScript.isTimingEnabled();

      var tab = document.createElement("SPAN");
    	tabs.appendChild(tab);
  		setActiveTab(tab);
      tab.id = statementId + ".tab";
      var currentTab = statementId;
  		tab.onclick = function(){demoPlayer.switchTab(statementId); return false;};
     	tab.innerHTML = "Statement " + sqlScript.getCommandId();

      var statement        = document.createElement("PRE");
      statements.appendChild(statement);
      hideSiblings(statement)
      statement.id         = statementId + ".statement";
      statement.className  = "sourceCodeRegion";

      var result = document.createElement("PRE");
      results.appendChild(result);
      hideSiblings(result);
      result.id            = statementId + ".result";
      result.style.display = "none";
      result.className     = "resultsRegion";

      generateIcons(stepId,statementId,sqlScript.isStatementExecutable());

      var plan             = document.createElement("PRE");
      plans.appendChild(plan);
      hideSiblings(plan);
      plan.id              = statementId + ".explainPlan";
      plan.className       = "explainPlanRegion";

      var timing           = document.createElement("PRE");
      timings.appendChild(timing);
      hideSiblings(timing);
      timing.id            = statementId + ".timing";
      timing.className     = "timingDisplay";
      timing.innerHTML     = "Elapsed : ---";
      self.toggleTiming(currentTab,sqlScript.isTimingEnabled())

      statement.innerHTML = sqlScript.getStatementHTML();
      var lineCount = statement.getElementsByTagName("BR").length;
      if (lineCount > 20) {
        statement.style.height     = '20em';
        statement.style.overflowY  = 'auto';
  	    document.getElementById(statementId + ".resizeStatement").parentNode.style.display="inline-block";
      }
    }
  }

  this.resizePanel = function(statementNumber,regionName,iconName,expandIcon,restoreIcon) {

  	var pane

  	if (regionName == ".outputWindow") {
  		pane = document.getElementById(statementNumber + ".result");
  		if (pane.style.display == "none") {
    		pane = document.getElementById(statementNumber + ".explainPlan");
      }
    }
    else {
  	  pane = document.getElementById(statementNumber + regionName);
  	}

    var img = document.getElementById(statementNumber + iconName);
    if (pane.style.overflowY == 'auto') {
      pane.style.overflowY =  'visible';
    	pane.style.height = pane.scrollHeight + "px";
      img.src = '/XFILES/lib/icons/' + restoreIcon;
    }
    else {
      pane.style.overflowY =  'auto';
      // console.log('Scroll : ' + pane.scrollHeight + '. Overflow : ' + pane.offsetHeight + '. Client : ' + pane.clientHeight);
     	pane.style.height = '';
     	if (pane.scrollHeight > 250) {
     		pane.style.height = "250px";
      }
      img.src = '/XFILES/lib/icons/' + expandIcon;
    }
  }

  function displayStep(step) {

    if (step.isClientCommand()) {
      return;
    }

    if ( step.isViewer() ) {
     	setViewer(step)    
      return;
    }

    if (step.isSQLScript()) {
      setStatementTab(step);
      return;
    }
  }

  function resizeDisplayWindow(stepId) {

    resizeTimer = 0;
    var displayWindow = document.getElementById(stepId + '.stepDisplay');
    displayWindow.style.height = (document.documentElement.clientHeight - 200) + "px";

    var screenshot = document.getElementById(stepId + '.stepScreenshot');
    if (screenshot) {
  	  screenshot.style.height = displayWindow.style.height;
  	  screenshot.style.width = document.documentElement.clientWidth - 90;
    }
  }

  function initializeStep(stepId) {

    // Create and display a step.

    var step = new DemonstrationStep(stepId);
    steps[stepId] = step;
  }

  this.showStep = function(stepId) {

    /*
    **
    ** Get the step location, description and targetUser
    **
    ** If the current user is the user required to run the step make the outputArea for the step visible
    ** and, for a SQL based step, load the first statement.
    **
    */

    document.getElementById(stepId + '.Step').style.display = "block";

    // ### resizeDisplayWindow(stepId);
    // ### window.onresize = function(){if (resizeTimer) clearTimeout(resizeTimer); resizeTimer = setTimeout(resizeDisplayWindow, 250);};

    if (isCorrectUser(stepId)) {

      var displayWindow = document.getElementById(stepId + '.stepDisplay');
      displayWindow.style.display = "block";

      if (steps[stepId] == null) {
        initializeStep(stepId);
      }
      displayStep(steps[stepId]);
    }

  }

  this.showNextStep = function(stepId) {

  	try {
  		var targetStep = stepId + 1;
      document.getElementById('sqlAuthentication').style.display = "none";
  	  document.getElementById(stepId + '.Step' ).style.display = "none";
      document.getElementById(stepId + '.stepDisplay').style.display = "none";
      self.showStep(targetStep);
    }
    catch (e) {
      var error = new xfilesException("DemoPlayer.showNextStep",11,null,e);
      handleException('DemoPlayer.showNextStep',error,null);
    }
  }

  this.showPreviousStep = function(stepId) {

    try {
    	var targetStep = stepId - 1;
      document.getElementById('sqlAuthentication').style.display = "none";
  	  document.getElementById(stepId + '.Step' ).style.display = "none";
      document.getElementById(stepId + '.stepDisplay').style.display = "none";
      self.showStep(targetStep);
    }
    catch (e) {
      var error = new xfilesException("DemoPlayer.showPreviousStep",11,null,e);
      handleException('DemoPlayer.showPreviousStep',error,null);
    }
  }

  function setUsernamePassword(targetUser) {

    var username = document.getElementById('demonstrationUsername');
    username.value = targetUser;
    username.disabled = true;

    var password = document.getElementById('demonstrationPassword');
    password.value = 'XXXXXXX';
    password.disabled = true;

  }

  function isCorrectUser(stepId) {

  	/*
  	**
  	** Ensure that the current session is authenticated as the target user for the step before proceeding..
  	** Note httpUsername is set to the current authenticated user or anonymous when entering the page.
  	**
  	*/

    var currentStepId = stepId;

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

  this.executeStatement = function(statementId) {

  	try {
    	var executeButton = document.getElementById( statementId + '.statementExecute');
      if (executeButton.disabled) {
    	  return;
    	}
    	
      var x = statementId.split('.')
      var stepId = parseInt(x[0]);
      var commandId = parseInt(x[1]);

      if (isCorrectUser(stepId)) {

        executeButton.disabled = true;
        executeButton.style.display = "none";

        var step = steps[stepId];

        if (firstStatementId == null) {
        	firstStatementId = statementId;
        }

        step.runSQLCommand(commandId);
      }
    }
    catch (e) {
      handleException('DemoPlayer.executeStatement',e,null);
    }
  }

  this.switchTab = function (statementId) {

	  var currentTab = statementId;
		var tab        = document.getElementById(statementId + ".tab");
    var statement  = document.getElementById(statementId + ".statement");
    var actions    = document.getElementById(statementId + ".actions");
    var result     = document.getElementById(statementId + ".result");
    var plan       = document.getElementById(statementId + ".explainPlan");
    var timing     = document.getElementById(statementId + ".timing");

    setActiveTab(tab);
    hideSiblings(statement);
    hideSiblings(actions,"inline-block");
    hideSiblings(result);
    hideSiblings(plan);
    hideSiblings(timing,"inline-block");

    var toggleResultsControl = document.getElementById(statementId + ".toggleResultsPanel");
    if (toggleResultsControl.style.display != "none") {
      if (result.parentNode.style.display != "none") {
		    toggleResultsControl.src = "/XFILES/lib/icons/showPlan.png";
		  }
      else {
		    toggleResultsControl.src = "/XFILES/lib/icons/showResults.png";
      }
    }
  }

  this.loadNextCommand = function (sqlScript) {

    // If this step has already been executed do not autorun the next step (Re-runnable Mode)

    if (sqlScript.statementExecuted()) {
      return;
    }

	  if (sqlScript.isScriptComplete()) {
	  	return;
	  }

		// Mark the Current Statement as Executed.

    sqlScript.setStatementExecuted();
	  sqlScript.loadNextStatement();

  	var step = steps[sqlScript.getScriptId()];
    setStatementTab(step);

    if ((!sqlScript.isScriptComplete()) && (!sqlScript.isExecutionPaused())) {
      self.executeStatement(sqlScript.getStatementId());
    }
    else {	  
    	self.switchTab(firstStatementId);
    	firstStatementId = null;
    }
  }

  this.openLink = function(stepId) {

  	var step = steps[stepId];

  	if (step.getWindowName() == step.getStepId() + ".iFrame") {
  	  setViewer(step);
  	}
  	else {
  	  window.open(step.getDocumentURL(),step.getWindowName());
  	}
  }

  this.resizeIFrame = function(iFrame) {

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

	this.reloadIFrame = function(stepId) {
		var step = steps[stepId]
		var iFrameID = step.getStepId() + ".iFrame"
    loadIFrame(iFrameID,step.getDocumentURL(),step.getContentType());
  }

  function loadIFrame(iFrameId,targetURL,contentType) {
  	
  	var iFrame = document.getElementById(iFrameId)
  	
  	if ((contentType == "text/xml") || (contentType == "application/xml")) {
      iFrame.src = "/XFILES/xmlViewer/xmlViewer.html?target=" + encodeURIComponent(targetURL)
  	  return;
  	}

  	if ((contentType == "text/plain") || (contentType == "text/html")) {
  		iFrame.src = targetURL;
  	  return
  	}

  }

  this.setAutoTrace = function (state,scriptId) {

		var step = steps[scriptId];
		step.setAutoTrace(state);

	}

	this.setTiming = function (state,scriptId) {

		var step = steps[scriptId];
		step.setTiming(state);

	}

  this.displayTiming = function(statementId, elapsedTimeMS) {  
    var timing = document.getElementById(statementId + ".timing" ) ;
    timing.innerHTML = "Elapsed : " + elapsedTimeMS + "ms";
  }

  this.toggleTiming = function (statementId,timingEnabled) {

  	var timingWindow = document.getElementById(statementId + ".timing");

  	if (timingEnabled) {
      timingWindow.parentNode.style.display = "inline-block";
    }
    else {
      timingWindow.parentNode.style.display = "none";
    }
  }  

  function sizePanel(panel,statementId) {
   
    var newHeight;
   
    newHeight=panel.scrollHeight;
   
   	var remainingHeight = window.innerHeight  - panel.offsetTop - 20;
   	if ( newHeight > remainingHeight) {
   		newHeight = remainingHeight;
   	}
    panel.style.height = newHeight + "px";
    panel.style.overflowX = 'auto';
    panel.style.overflowY = 'auto';
   
  }
   
  this.toggleResultsPanel = function(statementId)
  {
    var results = document.getElementById(statementId + ".result");
    hideSiblings(results);
    var explainPlan   = document.getElementById(statementId + ".explainPlan");
    hideSiblings(explainPlan);

    var img = document.getElementById(statementId + ".toggleResultsPanel");

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

    sizePanel(visibleWindow,statementId);

  }

  function toggleExplainPlan(statementId,autoTraceEnabled) {

    var toggleResults = document.getElementById(statementId + ".toggleResultsPanel");

  	if (autoTraceEnabled) {
      toggleResults.parentNode.style.display = "inline-block";
    }
    else {
      toggleResults.parentNode.style.display = "none";
    }
  }
  
  function getOutputTarget(name,statementId,response) {

  	var outputTargetName = statementId + name;
    var outputTarget = document.getElementById(outputTargetName);

    if (!outputTarget) {
      var error = new xfilesException("DemoPlayer.getOutputTarget",11,null,null);
  	  error.setDescription("Unable to locate output area [" +  outputTargetName + "]");
      error.setXML(response)
      throw error;
    }
    return outputTarget;
  }
 
  this.getResultsPanel = function(statementId,response) {
    return getOutputTarget(".result",statementId,response);  
  }

  this.getXPlanPanel = function(statementId,response) {
    return getOutputTarget(".explainPlan",statementId,response);  
  }
    
  this.resetResultsPanel = function(statementId,panel,enableAutoTrace) {	

    var results = document.getElementById(statementId + ".result");
    hideSiblings(results);
    var resultsDiv = results.parentNode;
    resultsDiv.style.display = "block";

    var explainPlan = document.getElementById(statementId + ".explainPlan");
    hideSiblings(explainPlan)
    var explainDiv = explainPlan.parentNode;
    explainDiv.style.display = "none";

    var img = document.getElementById(statementId + ".toggleResultsPanel");
    img.src = "/XFILES/lib/icons/showPlan.png";
    
    if (enableAutoTrace) {
    	img.parentNode.style.display = "inline-block";
    }
    else {
    	img.parentNode.style.display = "none";
    }	
 
    var img = document.getElementById(statementId + ".resizeOutput");
    img.src = "/XFILES/lib/icons/expandOutput.png";
 
    sizePanel(panel,statementId);
  }
  
  this.enableExecuteButton = function (statementId) {
  
    var executeButton = document.getElementById(statementId + '.statementExecute');
    executeButton.style.display = "inline-block";
    // executeButton.src = "/XFILES/lib/icons/executeSQL.png";
    executeButton.disabled = false;
  } 

  this.disableExecuteButton = function (statementId) {
  
    var executeButton = document.getElementById(statementId + '.statementExecute');
    executeButton.style.display = "inline-block";
    // executeButton.src = "/XFILES/lib/icons/executeSQL.png";
    executeButton.disabled = true;
  } 

  this.setExecutableState = function(result,scriptId,statementId) {

    // If the step is not re-runnable change the ICON for the current statement to StopDisabled and disable the control.

	  var rerunnableStep = document.getElementById(scriptId + ".isRerunnable");
	  var executeButton = document.getElementById(statementId + ".statementExecute");
	  if (result && !rerunnableStep) {
      executeButton.style.display = "none";
	    executeButton.disabled = true;
	  }
	  else {
      executeButton.style.display = "inline-block";
      // executeButton.src = "/XFILES/lib/icons/executeSQL.png";
	    executeButton.disabled = false;
	  }
	}
    
  function removeChildren(collection) {
  	
    	while(collection.hasChildNodes()) {
       collection.removeChild(collection.firstChild);
     }
  }
   
  this.resetStep = function(stepId) {
  
    steps[stepId] = null;
    var outputArea = document.getElementById(stepId + ".stepDisplay");
    if (outputArea) {
    	
    	tabs          = document.getElementById(stepId + ".tabSet");
      statements    = document.getElementById(stepId + ".statement");
      results       = document.getElementById(stepId + ".result");
      actions       = document.getElementById(stepId + ".actions"); 
      plans         = document.getElementById(stepId + ".explainPlan"); 
      timings       = document.getElementById(stepId + ".timing"); 
  
      removeChildren(tabs);
      removeChildren(statements);
      removeChildren(results);
      removeChildren(actions);
      removeChildren(plans);
      removeChildren(plans);
  
    }
    
    showStep(stepId);
  
  }
  
  function completeSimulation(mgr, stepId) {
  
    try {
      document.getElementById(stepId + ".simulate").src = "/XFILES/lib/icons/simulationComplete.png";
      var soapResponse = mgr.getSoapResponse("DemoPlayer.completeSimulation");
     	showInfoMessage("Simulation Complete.");
    }
    catch (e) {
      var error = new xfilesException("DemoPlayer.completeSimulation",11,null,e);c
      handleException('DemoPlayer.completeSimulation',error,null);
    }
  }
    
	this.simulateStep = function(stepId, script) {

    try {
      var simulation = document.getElementById(stepId + ".simulate");
      
      if (simulation.disabled) {
      	return;
      }
      
      simulation.disabled = true;
      simulation.src = "/XFILES/lib/icons/simulationRunning.png";
    
      var sqlScript = getDocumentContentImpl(script);
  
    	var statementXML = new xmlDocument().parse('<statement/>')
      var text = statementXML.createTextNode(sqlScript);
      statementXML.getDocumentElement().appendChild(text);
    
    	var mgr = soapManager.getRequestManager("XFILES","XFILES_WEBDEMO_SERVICES","EXECUTESQL");
    	var XHR = mgr.createPostRequest(); 
      XHR.onreadystatechange=function() { if( XHR.readyState==4 ) {  completeSimulation(mgr, stepId)}};
  
    	var parameters = new Object;
    
    	var xparameters = new Object;
    	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML
    		
      mgr.sendSoapRequest(parameters,xparameters); 
      
    }
    catch (e) {
      handleException('DemoPlayer.simulateStep',e,null);
    }
    
  }  
  
  function showFolderListing(mgr, outputWindow, stylesheetURL) {

    try {
      var soapResponse = mgr.getSoapResponse("DemoPlayer.showFolderListing");
      
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
     handleException('DemoPlayer.showFolderListing',e,resourceURL);
    }
  } 

  this.showFolderContent = function(screenshot,target,folderURL) {
    
    var img = document.getElementById(screenshot);
    img.style.display = "none";
  
    var outputWindow = document.getElementById(target);
    
  	var mgr = soapManager.getRequestManager("XFILES","XFILES_SOAP_SERVICES","GETFOLDERLISTING");
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { showFolderListing(mgr, outputWindow, '/XFILES/lite/xsl/FolderListing.xsl') } };
  
  	var parameters = new Object;
  	parameters["P_FOLDER_PATH-VARCHAR2-IN"]   = folderURL;
    parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset;
    parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;
    parameters["P_INCLUDE_METADATA-VARCHAR2-IN"] = includeMetadata;
  	mgr.sendSoapRequest(parameters);
  
  }

}

var sqlProcessor = new SqlProcessor();

function SqlProcessor() {

  var QUERY_SERVICE    = 1;
  var EXEC_SERVICE     = 2;
  var DESCRIBE_SERVICE = 3;
  var XPLAN_SERVICE    = 4;

	// Ordinary vars and parameters of the constructor become the private members
  // Private members are attached to the object
  // They are accessible to private methods.
  // They are not accessible to the outside world
  // They are not accessible to the object's own public methods.

  var sqlplusStatements = new Array(
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

	var supportedStatements = new Array(
  	"EXIT", "QUIT", "EXECUTE", "EXEC", "CALL", "DESCRIBE", "DESC", "PAU", "PAUSE"
	)

	var unsupportedStatements = new Array(
  	"A", "APPEND", "C", "CHANGE", "DEL", "L", "LIST", "ATTRIBUTE", "COLUMN", "COL", "HELP", "HO", "HOST",
  	"STARTUP", "SHUTDOWN", "ARCHIVE LOG", "PASSWORD"
	)
  var self = this;
  var timingEnabled = false;

  var FormatDescribeXSL;
  var FormatResponseXSL;
  var FormatXPlanXSL;

  function initialize() {
  	
  	soapFaultXSL   = new xmlDocument().parse(soapFaultXSLSource);

		loadFormatDescribeXSL();
  	loadFormatXPlanXSL();
  	loadFormatResponseXSL();
  }

  function includeSQLScript( scriptLocation, currentScript, relative, sqlScriptURL ) {

    if (scriptLocation.toLowerCase().indexOf('.sql') < 1 ) {
      scriptLocation = scriptLocation + ".sql"
    }

    if (relative) {
      scriptLocation = sqlScriptURL.substring(0,sqlScriptURL.lastIndexOf("/")+1) + scriptLocation;
    }

    var includeScriptText = "";
 
    try {
      includeScriptText = getDocumentContentImpl(scriptLocation);
    } catch (e) {
      var error = new xfilesException('sqlScript.includeSQLScript',11, scriptLocation, e);
      throw error;
    }
    // console.log(includeScriptText);
    var includeScript = includeScriptText.split('\n');

    var newScript = includeScript.concat(currentScript);
    // console.log("includeSQLScript(" + scriptLocation + ") : includeScript.length = " + includeScript.length + ". currentScript.length = " + currentScript.length + ". newScript.length = " + newScript.length + " : " + newScript[0])

    return newScript;

  }

  this.readStatement = function(sqlScript) {

   // Read the next statement from the scriptContent

   var statementHTML = "";
   var statement = "";

   var statementStarted = false;
   var setArguments;

   var commentBlock = false;
   var scriptContent = sqlScript.getScriptContent();

   if (scriptContent.length == 0) {
     statementHTML = statementHTML + 'quit' + "<BR>";
     sqlScript.setStatementExecutable(false);
     sqlScript.setStatementHTML(statementHTML);
     sqlScript.setScriptComplete()
     return "";
   }

   try {
     while (scriptContent.length > 0) {

       var nextLine = scriptContent[0];

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
				      sqlScript.setStatementExecutable(false);
	   			  	statement = "";
     			  }
				    sqlScript.setStatementHTML(statementHTML);
     				sqlScript.setScriptComplete()
			      return statement;
     		 }
      	 continue;
       }

       if (!commentBlock) {

         if (nextLine.substring(0,2) == "@@") {
           // console.log("Include found at line " + scriptContent.length + " : " + nextLine);
           scriptContent.shift();
         	 scriptContent = includeSQLScript(nextLine.substring(2),scriptContent,true, sqlScript.getSQLScriptURL());
           continue;
         }

         if (nextLine.substring(0,1) == "@") {
           // console.log("Include found at line " + scriptContent.length + " : " + nextLine);
           scriptContent.shift();
         	 scriptContent = includeSQLScript(nextLine.substring(1),scriptContent,false);
           continue;
         }

         if ((nextLine.substring(0,1) == "/") && (nextLine.substring(1,2) != "*"))  {
           statementHTML = statementHTML + "/";
           scriptContent.shift();
			     sqlScript.setStatementHTML(statementHTML);
           return statement;
         }

         if (!statementStarted) {

           if ((nextLine.substring(0,5).toLowerCase() == "pause") || (nextLine.substring(0,3).toLowerCase() == "pau")) {
             // SQL*PLUS pause statement;
             sqlScript.pauseExecution();
             scriptContent.shift();
   			     statement = "";
				     statementHTML = "";
             continue;
           }

           if ((nextLine.substring(0,4).toLowerCase() == "quit") || (nextLine.substring(0,4).toLowerCase() == "exit")) {
             // SQL*PLUS quit or exit statement;
             statementHTML = statementHTML + nextLine.substring(0,4).toLowerCase();
				     sqlScript.setStatementHTML(statementHTML);
				     sqlScript.setStatementExecutable(false);
             sqlScript.setStatementExecuted()
             sqlScript.setScriptComplete()
        		 return "";
           }

         }
       }

       var nextLineHTML = nextLine.replace(/&/g,'&amp;');
       nextLineHTML = nextLineHTML.replace(/\s/g,"&nbsp;");
       nextLineHTML = nextLineHTML.replace(/</g,"&lt;");
       nextLineHTML = nextLineHTML.replace(/>/g,"&gt;");
       nextLineHTML = nextLineHTML + "<BR/>";
       // console.log(nextLineHTML);

       statementHTML = statementHTML + nextLineHTML;
       scriptContent.shift();

       // Hack for Comment Blocks eg /* ... */

     	 if (nextLine.substring(0,2) == "/*") {
     	 	 // Todo : Deal with Start Comment Marker not at begining of line
     	 	 // Todo : When dealing with the above make sure not to trip over Hints...
     	 	 commentBlock = true;
     	 	 continue;
       }

     	 if (commentBlock && (nextLine.indexOf("*/") > -1)) {
     	 	 // Todo : Deal with Code following End Comment.
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

				 // Skip Blank lines 

         if (nextLine.substring(0,1) == "\r") {
         	 // Todo : Empty Lines ? Eg only containing whitespace..
					 continue;
				 }
         // Skip all unsupported SQL*PLUS statements

         	;

         if (nextLine.substring(0,4).toLowerCase() == "set ") {
           // Check for set autotrace on explain or set autotrace off
           setArguments = nextLine.toLowerCase().split(" ");
           if (setArguments.length > 2) {
             if ((setArguments[1] == "autotrace") || (setArguments[1] == "autot")) {
               if (setArguments[2].substring(0,3) == "off") {
                 // console.log('Autotrace Disabled');
                 sqlScript.setAutoTrace(false);
               }
               else {
                 if (setArguments[2].substring(0,2) == "on") {
                   // console.log('Found autotrace on statement');
                   if (setArguments.length > 3)  {
                     if ((setArguments[3].substring(0,7) == "explain") || (setArguments[3].substring(0,4) == "expl")) {
                       // console.log('Autotrace Enabled');
                       sqlScript.setAutoTrace(true);
                     }
                   }
                 }
               }
             }
             if ((setArguments[1] == "timing") || (setArguments[1] == "timi")) {
               if (setArguments[2].substring(0,3) == "off") {
                 sqlScript.setTiming(false);
               }
               else {
                 if (setArguments[2].substring(0,2) == "on") {
                   sqlScript.setTiming(true);
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
  		     sqlScript.setStatementHTML(statementHTML);
           return statement;
         }
       }

       statement = statement + nextLine + "\r\n";
       statementStarted = true;
     }
     statement = "";
  	 sqlScript.setScriptComplete();
     sqlScript.setStatementHTML(statementHTML);
     return statement;
   }
   catch (e) {
     var error = new xfilesException('SqlProcessor.readStatement',11, null, e);
     throw error;
   }
  }

  this.setStatementType= function(sqlScript,statement) {

  	var token;
  	var statementType;

    token = statement.split(" ",1)[0].toLowerCase().trim();
    
    if (token.substring(0,6) == "select") {
      statementType =  "SQL";
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

    if ((token.substring(0,6) == "commit") || (token.substring(0,8) == "rollback")) {
      // Stateless Web Services cannot support Commit or Rollback. Treat as a NO-OP
      statementType =  "COMMIT";
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

    if (token.substring(0,6) == "create") {
    	var ddlTarget = statement.split(" ",2)[1].toLowerCase();
      if (ddlTarget == "or") {
        ddlTarget = statement.split(" ",4)[3].toLowerCase();
      }
      if ((ddlTarget == "unique") || (ddlTarget== "bitmap")) {
        ddlTarget= "Index"
      }
      sqlScript.setDDLTarget(ddlTarget);
      statementType =  "CREATE";
      return statementType;
    }

    if (token.substring(0,6) == "purge") {
      sqlScript.setDDLTarget(statement.split(" ",2)[1].toLowerCase());
      statementType =  "CREATE";statementType =  "PURGE";
      return statementType;
    }

    if (token.substring(0,4) == "drop") {
      sqlScript.setDDLTarget(statement.split(" ",2)[1].toLowerCase());
      statementType =  "CREATE";statementType =  "DROP";
      return statementType;
    }

    if (token.substring(0,5) == "alter") {
      sqlScript.setDDLTarget(statement.split(" ",2)[1].toLowerCase());
      statementType =  "CREATE";statementType =  "ALTER";
      return statementType;
    }

    if (token.substring(0,5) == "grant") {
      statementType =  "GRANT";
      return statementType;
    }

    if ((token.substring(0,4) == "desc") || (token.substring(0,8) == "describe")) {
      sqlScript.setDDLTarget(statement.split(" ",2)[1].toLowerCase());
      statementType = "DESCRIBE";
      return statementType;
    }

  }

  function loadFormatDescribeXSL() {
    FormatDescribeXSL = loadXSLDocument('/XFILES/common/xsl/formatDescribe.xsl');
  }

  function loadFormatXPlanXSL() {
    FormatXPlanXSL = loadXSLDocument('/XFILES/common/xsl/formatXPlan.xsl');
  }

  function loadFormatResponseXSL() {
    FormatResponseXSL = loadXSLDocument('/XFILES/common/xsl/formatResponse.xsl');
  }

	this.runSQLCommand = function(sqlScript) {

		/*
		**
		** Run the current statement in the current Step.
		**
		*/

	  if ((sqlScript.getStatementType() == "SQL") || (sqlScript.getStatementType() == "XQUERY")) {
    	invokeORAWSV(sqlScript);
  	}
  	else {
    	if (sqlScript.getStatementType() == "DESCRIBE") {
      	invokeWSDescribe(sqlScript);
    	}
    	else {
      	invokeWSHelper(sqlScript);
    	}
  	}
  }

  function processReturnCode(nodeList, sqlScript, outputTarget) {

    var rows = 0;

    outputTarget.innerHTML = "";

    var returnElement = nodeList.item(0);
    if (useMSXML) {
      rows = returnElement.text;
    }
    else {
    	rows = returnElement.textContent;
    }

    var ddlTarget = sqlScript.getDDLTarget();
    var statementType = sqlScript.getStatementType();

    var bold = document.createElement("B");
    outputTarget.appendChild(bold)

    // console.log("processReturnCode(" + statementType + "," + rows + ")");

    if (ddlTarget) {
      var firstChar = ddlTarget.substr(0,1).toUpperCase();
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
  }

  function displayJSON(soapResponse, namespaces, sqlScript) {

    var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[starts-with(.,'[') or starts-with(.,'{')]",namespaces);
    if (nodeList.length > 0 ) {
      // Output contains JSON ....
      var rowList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW",namespaces );
      for (var i=0; i < rowList.length; i++) {
    	  var row = new xmlElement(rowList.item(i));
     	  var colList = row.selectNodes("*",namespaces);
   	    for (var j=0; j<colList.length; j++) {
      		var col = new xmlElement(colList.item(j));
      	  if ((col.getTextValue().charAt( 0 ) == '{') || (col.getTextValue().charAt( 0 ) == '[')) {
      	    var documentLocator = "jsonValue" + "." + sqlScript.getStatementId() + "." + (i+1) + "." + (j+1);
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
  
  function displayXML(soapResponse, namespaces, sqlScript) {

    var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[*]",namespaces);
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
      		  var documentLocator = sqlScript.getStatementId() + "." + (i+1) + "." + (j+1);
       	    prettyPrintXMLColumn(col,"xmlValue." + documentLocator);
    	    }
        }
      }
    }
  }
  
  function displayResponse(mgr, sqlScript) {

    var outputTarget;
    try {
      var soapResponse = mgr.getSoapResponse("sqlProcessor.displayResponse");
    }
    catch (e) {
    	if (e.getErrorCode() == 6) {
				outputTarget = demoPlayer.getResultsPanel(sqlScript.getStatementId(),soapResponse);
				demoPlayer.enableExecuteButton(sqlScript.getStatementId())
        xmlToHTML(outputTarget,e.xml,soapFaultXSL)
	      demoPlayer.resetResultsPanel(sqlScript.getStatementId(),outputTarget,false);
  	    sqlScript.pauseExecution();
        return false;
   	  }
      else {
        var error = new xfilesException("sqlProcessor.displayResponse",11,null,e);
  	    error.setDescription("Unexpected sqlProcessor Error.");
        throw error;
      }
    }

    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv") {
      // Push the Statement ID into the SOAP RESPONSE so that XML areas have unqiue id's
      soapResponse.getDocumentElement().setAttribute('statementId',sqlScript.getStatementId());
      outputTarget = demoPlayer.getResultsPanel(sqlScript.getStatementId(),soapResponse);
      xmlToHTML(outputTarget,soapResponse,FormatResponseXSL,false);
      displayXML(soapResponse, namespaces, sqlScript)
      displayJSON(soapResponse, namespaces, sqlScript)
      demoPlayer.resetResultsPanel(sqlScript.getStatementId(),outputTarget,false);
      return true;
    }

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/EXECUTESQL") {
      outputTarget = demoPlayer.getResultsPanel(sqlScript.getStatementId(),soapResponse);
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
      processReturnCode(nodeList,sqlScript,outputTarget);
      demoPlayer.resetResultsPanel(sqlScript.getStatementId(),outputTarget,false);
      return true;
    }

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/DESCRIBE") {
      outputTarget = demoPlayer.getResultsPanel(sqlScript.getStatementId(),soapResponse);
      var rowsetNode = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/tns:ROWSET",namespaces).item(0);
      rowsetNode.setAttribute('statementId',sqlScript.getStatementId());
      xmlToHTML(outputTarget,soapResponse,FormatDescribeXSL,false);

      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN//tns:SCHEMA_DEFINITION/*",namespaces);
      if (nodeList.length > 0) {
        var xmlArea = document.getElementById('xmlValue.' + sqlScript.getStatementId());
        prettyPrintXMLElement(new xmlElement(nodeList.item(0)),xmlArea);
      }
      demoPlayer.resetResultsPanel(sqlScript.getStatementId(),outputTarget,false);
      return true;
    }

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/EXPLAINPLAN") {
      outputTarget = demoPlayer.getXPlanPanel(sqlScript.getStatementId(),soapResponse);
      xmlToHTML(outputTarget,soapResponse,FormatXPlanXSL,false);
      demoPlayer.resetResultsPanel(sqlScript.getStatementId(),outputTarget,true);
      return true;
    }

    var error = new xfilesException("sqlProcessor.displayResponse",11,null,e);
    error.setDescription("Unexpected Soap Response Error.");
    error.setXML(soapResponse);
    throw error;
  }

  function calculateElapsedTime(startTime, endTime, statementId) {

    var elapsedTimeMS =  endTime.getTime() - startTime.getTime();
    demoPlayer.displayTiming(statementId,elapsedTimeMS)

  }

  function processResponse(mgr, sqlScript, serviceType, requestDate) {

    try {
      var responseDate = new Date();

     	var success = displayResponse(mgr,sqlScript);
      demoPlayer.setExecutableState(success,sqlScript.getScriptId(),sqlScript.getStatementId());
      
      var elapsedTimeMS =  responseDate.getTime() - requestDate.getTime();
      calculateElapsedTime(requestDate,responseDate,sqlScript.getStatementId());
      demoPlayer.toggleTiming(sqlScript.getStatementId(),sqlScript.isTimingEnabled());

    	if (serviceType == DESCRIBE_SERVICE) {
    		// ### Hack for Describe Crashing Backend Server ###
    		var workaround = getHttpUsername();
    	}

      if (serviceType == QUERY_SERVICE) {
      	if ((success) && (sqlScript.isAutoTraceEnabled())) {
	      	invokeWSXPlan(sqlScript);
	      }
	      else {
          demoPlayer.loadNextCommand(sqlScript);
        }
      }
      else {
        demoPlayer.loadNextCommand(sqlScript);
      }
    }
    catch (e) {
      handleException('sqlProcessor.processResponse',e,null);
    }
  }

  function invokeWSXPlan(sqlScript){

		var mgr = soapManager.getRequestManager("XFILES","XFILES_WEBDEMO_SERVICES","EXPLAINPLAN");

    var statementBody = 	sqlScript.getStatement()

  	// Explain Plan for XQuery operation requires the use of select * from XMLTABLE(XQUERY);

   	if (sqlScript.getStatementType() == "XQUERY") {
   		statementBody = "select * from XMLTABLE('" + statementBody + "')"
    }

  	var statementXML = new xmlDocument().parse('<statement/>')
    var text = statementXML.createTextNode(statementBody);
    statementXML.getDocumentElement().appendChild(text);

  	var XHR = mgr.createPostRequest();
    var requestdate = new Date();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) {  processResponse(mgr, sqlScript, XPLAN_SERVICE, requestdate)}};

  	var parameters = new Object;

  	var xparameters = new Object;
  	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML

    mgr.sendSoapRequest(parameters,xparameters);

  }

  function invokeWSDescribe(sqlScript) {

		var mgr = soapManager.getRequestManager("XFILES","XFILES_WEBDEMO_SERVICES","DESCRIBE");

    var ownerName = sqlScript.getSqlUsername();
    var text = sqlScript.getStatement();
    var objectName = text.split(" ",2)[1];
    objectName = objectName.replace( /^\s+/g, "" );// strip leading
    objectName = objectName.replace( /\s+$/g, "" );// strip trailing
    if (objectName.indexOf('"') == 0) {
    	objectName = objectName.substring(1,objectName.length-1);
    }
    if (objectName.indexOf(".") > 0) {
    	// SCHEMA.OBJECT_NAME or SCHEMA"."OBJECT_NAME
    	ownerName = objectName.substring(0,objectName.indexOf("."));
     	objectName = objectName.substring(objectName.indexOf(".")+1);
     	if (objectName.indexOf('"') == 0) {
    	  ownerName = ownerName.substring(0,objectName.length-1);
    	  objectName = objectName.substring(1);
    	}
    }

   	var XHR = mgr.createPostRequest();
    var requestdate = new Date();
  	XHR.onreadystatechange = function() { if( XHR.readyState==4 ) { processResponse(mgr, sqlScript, DESCRIBE_SERVICE, requestdate)}};

  	var parameters = new Object;
  	parameters["P_OBJECT_NAME-VARCHAR2-IN"]   = objectName
  	parameters["P_OWNER-VARCHAR2-IN"]   = ownerName

    mgr.sendSoapRequest(parameters);

  }

  function invokeWSHelper(sqlScript){

		var mgr = soapManager.getRequestManager("XFILES","XFILES_WEBDEMO_SERVICES","EXECUTESQL");

  	var statementXML = new xmlDocument().parse('<statement/>')
    var text = statementXML.createTextNode(sqlScript.getStatement());
    statementXML.getDocumentElement().appendChild(text);

  	var parameters = new Object;
  	var xparameters = new Object;
  	xparameters["P_STATEMENT-XMLTYPE-IN"] = statementXML

    var XHR = mgr.createPostRequest();
    var requestdate = new Date();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) {  processResponse(mgr, sqlScript, EXEC_SERVICE, requestdate)}};

    mgr.sendSoapRequest(parameters,xparameters);

  }

  function invokeORAWSV(sqlScript){

    var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");

    var XHR = mgr.createPostRequest();
    var requestdate = new Date();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) {  processResponse(mgr, sqlScript, QUERY_SERVICE, requestdate)}};

    if (sqlScript.getStatementType() == "XQUERY") {
      mgr.executeXQuery(sqlScript.getStatement());
    }
    else {
      mgr.executeSQL(sqlScript.getStatement());
    }

  }

	initialize()

}

function onPageLoaded() {

  /*
  **
  **  Use isAuthenticatedUser() to determine who the HTTP session is currently connected as...
  **
  */

  sqlScriptUsername = getParameter('sqlUsername');

	setHttpUsername();
	// patchHref(document.getElementsByName("A"));
  demoPlayer = new DemonstrationPlayer();
  demoPlayer.showStep(1);

}
