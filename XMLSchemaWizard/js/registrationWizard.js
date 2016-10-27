
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

var targetFolderTree
var targetFolder = null

var schemaContainerPath; 

var rcPrefixList = { "rc"  :  "http://xmlns.oracle.com/xdb/pm/registrationConfiguration" };
var	rcNamespace = new namespaceManager(rcPrefixList)

var registrationConfiguration;

var rcNamespace;

var typeAnalysisInProgress = false;

var globalElementListXSL 

var missingXMLSchema

function doNothing() {
}

var doNext = doNothing;
var doPrev = doNothing;

function loadGlobalElementListXSL() {
  globalElementListXSL = loadXSLDocument("/XFILES/Applications/XMLSchemaWizard/xsl/globalElementList.xsl");
}

function showSelectFolder() {
	
	$('#wizardSteps a[href="#wizardSelectSchemas"]').tab('show')

  document.getElementById("btnNext").style.display="block";
	doNext = verifySchemaSet;
	
}

function showLocateMissingSchema(missingSchemaLocationHint) {
	
	$('#wizardSteps a[href="#step_locateSchema"]').tab('show')
  document.getElementById("missingSchemaLocation").value = missingSchemaLocationHint.substring(1,missingSchemaLocationHint.length-1)
  document.getElementById("btnNext").style.display="block";
	doNext = verifySchemaSet;
	
}
function showSchemaOrdering() {
	
	$('#wizardSteps a[href="#wizardConfigureSchemas"]').tab('show')

  document.getElementById("btnNext").style.display="block";
  doNext = showScriptOptions;

}

function showScriptOptions() {
	
	$('#wizardSteps a[href="#wizardScriptOptions"]').tab('show')

  document.getElementById("btnNext").style.display="block";
  doNext = generateScripts;

}

function showShowScripts() {
	
  $('#wizardSteps a[href="#wizardShowScript"]').tab('show')
  
  document.getElementById("btnNext").style.display="none";
  doNext = doNothing;

}

function showTypeCompilation() {
	
	$('#wizardSteps a[href="#step_compileTypes"]').tab('show')

  document.getElementById("btnNext").style.display="none";
  doNext = doNothing;

}

function showTypeAnalysis() {
	
	$('#wizardSteps a[href="#step_analyzeTypes"]').tab('show')

  document.getElementById("btnNext").style.display="none";
  doNext = doNothing;
  
}


function onPageLoaded() {

	openModalDialog("registrationWizard");
	loadFolderTree(xfilesNamespaces,document.getElementById('treeLoading'),document.getElementById('treeControl'))
	loadGlobalElementListXSL();
	showSelectFolder();
	
}

function displaySchemaList(mgr,repositoryPath) {
	
	var schemaList = document.getElementById("schemaList");
  loadOptionList(mgr, schemaList, schemaList, false, false)
    
  if (schemaList.options.length > 0) {
    document.getElementById("btnNext").style.display="block";
  }
  else {
    document.getElementById("btnNext").style.display="none";
  }
}

function listXMLSchemas(repositoryPath) {

  try {

		var pathOffset = repositoryPath.length;
		if (pathOffset > 1) {
		  pathOffset = pathOffset + 2;
		}

  	var sqlQuery = "select substr(ANY_PATH," + pathOffset + ") SCHEMA_PATH from RESOURCE_VIEW where under_path(res,'" + repositoryPath + "') = 1 and XMLExists('declare default element namespace \"http://xmlns.oracle.com/xdb/XDBResource.xsd\"; $R/Resource[ends-with(DisplayName,\".xsd\") and not(ends-with(DisplayName,\".xdb.xsd\"))]' passing RES as \"R\")";
  	 
	  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
    var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displaySchemaList(mgr,repositoryPath)}};
    mgr.executeSQL(sqlQuery);
    
  } 
  catch (e) {
    handleException('registrationWizard.listXMLSchemas',e,null);
  }
}

function resetSchemaList() {
		var schemaList = document.getElementById("schemaList");
		while (schemaList.options.length) {
			schemaList.remove(0);
	  }
}
   
function searchCurrentFolder() {
	
	var selectedFolder = targetFolderTree.getOpenFolder();
	if (selectedFolder != null) {
		if (targetFolder != selectedFolder) {
			targetFolder = selectedFolder;
			listXMLSchemas(targetFolder);
	  }
	}
	else {
	  resetSchemaList();
  }
}

function displayUploadedSchemas(mgr,archivePath) {

  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displaySchemaList");
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    // showSourceCode(soapResponse);

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    if (resultSet.length > 0) {
    	closeModalDialog("uploadArchive");
    	var resourceCount = resultSet.item(0).firstChild.nodeValue;
    	var targetFolder = archivePath.substring(0,archivePath.lastIndexOf('.'));
      loadFolderTree(xfilesNamespaces,document.getElementById('treeLoading'),document.getElementById('treeControl'),targetFolder)
    	showInformationMessage(resourceCount + " documents successfully uploaded into \"" + targetFolder + "\"");
			searchCurrentFolder(targetFolder);
			return
    }
    var error = new xfilesException("registrationWizard.displaySchemaList",12,null, null);
    error.setDescription("Invalid Schema List Document");
    error.setXML(soapResponse);
    throw error;
  } 
  catch (e) {
    handleException('registrationWizard.displaySchemaList',e,null);
  }
}

function unzipSchemaArchive(repositoryPath) {
	
	/*
	** Unzips the Archive and returns a list of XML Schemas.
	*/
	
  try {
 
  	var schema      = "XFILES";
    var packageName = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "UNPACK_ARCHIVE";

  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayUploadedSchemas(mgr,repositoryPath) } };

  	var parameters = new Object;
  	parameters["P_ARCHIVE_PATH-VARCHAR2-IN"]  = repositoryPath;
  
    mgr.sendSoapRequest(parameters);
 
  } 
  catch (e) {
    handleException('registrationWizard.unzipSchemaArchive',e,null);
  }
}

function uploadSchemaArchive() {

  try {
    var callback = function(XHR, resourcePath) { unzipSchemaArchive( resourcePath ) }
   	uploadToFolder(targetFolderTree.getOpenFolder(),'FILE',callback);
  } 
  catch (e) {
    handleException('registrationWizard.uploadSchemas',e,null);
  }
}

function chooseSchemaArchive() {
	
  if (!targetFolderTree.isWritableFolder()) {
  	showUserErrorMessage("Please select a writeable folder.");
  	return
  }
 
  // Processing in uploadSchemaArchive
  
  openModalDialog("uploadArchive")
}

function appendPath(schemaLocationPrefix,localPath) {
	
	if (schemaLocationPrefix.length > 0) {
    if (schemaLocationPrefix.indexOf("/") != schemaLocationPrefix.length) {
  	  schemaLocationPrefix = schemaLocationPrefix + "/";
    }
  }
  
  if (localPath.indexOf("/") == 0) {
    localPath = localPath.substring(1);
  }

  return schemaLocationPrefix + localPath;

}

function populateElementList(selectControl,elementList) {

 	while (selectControl.options.length > 0){
		selectControl.remove(0)
 	}
    	
  if (elementList.length > 0) {
	  for (var i=0;i< elementList.length; i++) {
 		  option = document.createElement("option");
      selectControl.appendChild(option);  
      var tableDefinition = new xmlElement(elementList.item(i));
      var namespace = tableDefinition.selectNodes("rc:namespace",rcNamespace).item(0).firstChild.nodeValue;
      var qname = tableDefinition.selectNodes("rc:name",rcNamespace).item(0).firstChild.nodeValue;
      if (namespace != "") {
        var qname = namespace + ":" + qname;
      }
      var text = document.createTextNode(qname);
      option.appendChild(text);
      option.value = i+1;
    }
  }    
}

function fixSchemaLocationHint(schemaLocationHint, repositoryFolder, schemaLocationPrefix) {
	
	if (schemaLocationPrefix == "") {
		return schemaLocationHint
  }
  else {
    if (schemaLocationHint.indexOf(repositoryFolder) == 0) {
     	return appendPath(schemaLocationPrefix,schemaLocationHint.substring(repositoryFolder.length+1));
    }
    else {
      return schemaLocationHint;
    }
  }
}

function populateSchemaList(selectControl,schemaList) {
	
  var schemaLocationPrefix = registrationConfiguration.getDocumentElement().getAttribute('schemaLocationPrefix')
  var repositoryFolder = document.getElementById("repositoryFolderPath").value 

 	while (selectControl.options.length > 0){
		selectControl.remove(0)
 	}
    	
  if (schemaList.length > 0) {
	  for (var i=0;i< schemaList.length; i++) {
 		  option = document.createElement("option");
      selectControl.appendChild(option);  
      var schemaLocationHint = schemaList.item(i).firstChild.nodeValue
      schemaLocationHint = fixSchemaLocationHint(schemaLocationHint, repositoryFolder, schemaLocationPrefix);
      var text = document.createTextNode(schemaLocationHint);
      option.appendChild(text);
      option.value = i+1;
    }
  }    
}

function displaySchemaOrdering(mgr,rootSchemaPath) {
		
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displaySchemaOrdering");

   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    namespaces.redefinePrefix("rc",rcNamespace.resolveNamespace("rc"));

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/rc:SchemaRegistrationConfiguration",namespaces);
    
    if (resultSet.length > 0) {

    	showSchemaOrdering();	
			registrationConfiguration = new xmlDocument();
    	registrationConfiguration.appendChild(registrationConfiguration.importNode(resultSet.item(0),true));  	

    	var selectControl = document.getElementById("orderedSchemaList");
    	var schemaList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:schemaLocationHint",rcNamespace);
    	populateSchemaList(selectControl,schemaList,"");

    	$('#schemaLocationInfo').collapse({toggle: false})

    	var selectControl = document.getElementById("generatedTableList");
    	var globalElementList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:elements/rc:element",rcNamespace);
    	populateElementList(selectControl,globalElementList);

    	return;
    }
    
    var error = new xfilesException("registrationWizard.displaySchemaOrdering",12,null, null);
    error.setDescription("Invalid Schema List Document");
    error.setXML(soapResponse);
    throw error;
  } 
  catch (e) {
  	if ((e.isServerError) && ((e.isServerError()) && (e.getSQLErrCode() == 'ORA-31001'))) {
  		var errorMsg = e.getSQLErrMsg();
  		var schemaLocation = errorMsg.substring(errorMsg.indexOf('"'));
			// showErrorMessage("Unable to resolve XML Schema : " + schemaLocation)
  	  BootstrapDialog.confirm(
  	    'Cannot resolve ' + schemaLocation + '. Would you like to search for it ?', 
  	    function(result){
          if (result) {
            showLocateMissingSchema(schemaLocation);
          }
        }
      );
	  }
	  else {
      handleException('registrationWizard.displaySchemaOrdering',e,null);
    }
  }
}

function processSchemaList(schemas) {

  var schemaList = document.getElementById("schemaList");

  for (var i=0; i<schemaList.length; i++) {
    if (schemaList.options[i].selected) {
      var schema     = schemaList.options[i].value;
      if (schemas.indexOf(schema) == -1) {
        schemas.push(schema);
      }
    }
  }
  return schemas;  
}

function verifySchemaSet() {

	/*
	** Order the schemas needed to successfully register the chosen XML Schema(s)
	**
	*/
	
	$('#wizardSteps a[href="#wizardSelectSchemas"]').tab('show')

  var repositoryFolderPath = targetFolderTree.getOpenFolder();
	
  var schemaList = [];
  schemaList = processSchemaList(schemaList);
   
  document.getElementById("repositoryFolderPath").value = repositoryFolderPath;
  
  var xmlSchemaList = new xmlDocument();
  var schemas = xmlSchemaList.createElement("schemas");
  xmlSchemaList.appendChild(schemas);
  
  for (var i=0; i<schemaList.length; i++) {
  	var schema     = xmlSchemaList.createElement("schema");
    // var schemaPath = appendPath(repositoryFolderPath,schemaList[i]);
    var schemaPath = schemaList[i];
		var text   = xmlSchemaList.createTextNode(schemaPath);
  	schema.appendChild(text);
  	schemas.appendChild(schema);
  }

  document.getElementById("btnNext").style.display="none";
   
  try {
 
  	var schema      = "XFILES";
    var packageName = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "ORDER_SCHEMA_LIST";
	
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displaySchemaOrdering(mgr,"") } };
  
  	var parameters = new Object;
  	parameters["P_XML_SCHEMA_FOLDER-VARCHAR2-IN"]  = repositoryFolderPath;
  	parameters["P_SCHEMA_LOCATION_PREFIX-VARCHAR2-IN"]  = "";
  	
  	var xParameters = new Object;
  	xParameters["P_XML_SCHEMAS-XMLTYPE-IN"]  = xmlSchemaList;

    mgr.sendSoapRequest(parameters,xParameters);
   
  } 
  catch (e) {
    handleException('registrationWizard.orderSchemas',e,null);
  }
}

function getRepositoryPath(schemaConfiguration,index) {

  var nl = schemaConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[" + index + "]/rc:repositoryPath",rcNamespace)
  return nl.item(0).firstChild.nodeValue;

}

function getSchemaLocationHint(schemaConfiguration,index) {

  var nl = schemaConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[" + index + "]/rc:schemaLocationHint",rcNamespace)
  return nl.item(0).firstChild.nodeValue;

}

function getTargetNamespace(schemaConfiguration,index) {

  var nl = schemaConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[" + index + "]/rc:targetNamespace",rcNamespace)
  return nl.item(0).firstChild.nodeValue;

}

function setSchemaLocationHint() {
	
	 var repositoryFolder = document.getElementById("repositoryFolderPath").value

   var schemaList = document.getElementById("orderedSchemaList");
	 var absolutePath = schemaList.options[schemaList.selectedIndex].textContent;
	 var relativePath = absolutePath.substring(repositoryFolder.length);
	 var schemaLocationHint = appendPath(document.getElementById("schemaLocationPrefix").value,relativePath);
   document.getElementById("schemaLocationHint").value = schemaLocationHint;
   
}

function setSchemaLocationPrefix(targetNamespace) {

		// Enable editing of Schema Location Hint.
    // Code here to attempt to strip .xsd and XML Schema path from targetNamespace.
    
    var schemaLocationPrefix = targetNamespace

    if (schemaLocationPrefix.indexOf('.xsd') == (schemaLocationPrefix.length-4)) {
	    schemaLocationPrefix = schemaLocationPrefix.substring(0,schemaLocationPrefix.length-4);
    }

    document.getElementById("schemaLocationPrefix").value = schemaLocationPrefix
    $('#schemaLocationInfo').collapse("show")    
    setSchemaLocationHint();    

}

function updateSchemaLocationPrefix() {
	
	registrationConfiguration.getDocumentElement().setAttribute('schemaLocationPrefix',document.getElementById("schemaLocationPrefix").value)

}

function showSchemaDetails() {

	var schemaList = document.getElementById("orderedSchemaList");
	var index = schemaList.options[schemaList.selectedIndex].value
	
	var repositoryPath = getRepositoryPath(registrationConfiguration,index);
	var schemaLocationHint = getSchemaLocationHint(registrationConfiguration,index)

 	var targetNamespace = getTargetNamespace(registrationConfiguration,index);
  document.getElementById("targetNamespace").value = targetNamespace
	
	if (repositoryPath == schemaLocationHint) {
		setSchemaLocationPrefix(targetNamespace)
  }
  else {
  	$('#schemaLocationInfo').collapse("hide")
  }
	
}

function changeStorageModel() {
	
	if (getRadioButtonValue("xmlStorageModel") == "OR") {
	  document.getElementById("domFidelityOption").style.display="block";
	  document.getElementById("disableDOMFidelity").checked = false;
	  doNext = startTypeCompilation;
  }
  else {
	  document.getElementById("domFidelityOption").style.display="none";	  
	  document.getElementById("disableDOMFidelity").checked = true;
	  doNext = generateScripts;
	}	
}

function showFileContent(path,target) {
	
  try {

    var logFileContent = getDocumentContent(path);

    var logWindow = document.getElementById(target)
 	  while (logWindow.hasChildNodes()){
  	 	logWindow.removeChild(logWindow.firstChild);
 	  }
         
    logWindow.appendChild(document.createTextNode(logFileContent));
    logWindow.parentNode.scrollTop = logWindow.parentNode.scrollHeight;
  }
  catch (e) {
   var error = new xfilesException("registrationWizard.showFileContent",14,path,e);
   throw error;
  }
	
}

function displayRegistrationScript(mgr) {

  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displayRegistrationScript");
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    if (resultSet.length > 0) {
		  showShowScripts();
      var registrationScriptPath = resultSet.item(0).firstChild.nodeValue;
      showFileContent(registrationScriptPath,'registrationScript');
   	  return;
   	}
  } catch (e) {
    handleException('registrationWizard.displayRegistrationScript',e,null);
  }

}

function generateScripts() {

  /*
  ** FUNCTION CREATE_SCRIPT RETURNS VARCHAR2
  ** Argument Name                  Type                    In/Out Default?
  ** ------------------------------ ----------------------- ------ --------
  ** P_XML_SCHEMA_CONFIGURATION     XMLTYPE                 IN
  ** P_BINARY_XML                   BOOLEAN                 IN     DEFAULT
  ** P_LOCAL                        BOOLEAN                 IN     DEFAULT
  ** P_DISABLE_DOM_FIDELITY         BOOLEAN                 IN     DEFAULT
  ** P_REPOSITORY_USAGE             VARCHAR2								IN     DEFAULT
  ** P_GENERATE_TABLES              BOOLEAN                 IN     DEFAULT  
  **
  */

  document.getElementById("btnNext").style.display="none";
  
  try {
 
  	var schema      = "XFILES";
    var packageName = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "CREATE_SCRIPT";
	
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayRegistrationScript(mgr) } };
  
  	var parameters = new Object;
  	parameters["P_BINARY_XML-BOOLEAN-IN"]            = booleanToNumber(getRadioButtonValue("xmlStorageModel") == "CSX");
  	parameters["P_LOCAL-BOOLEAN-IN"]                 = booleanToNumber(getRadioButtonValue("schemaScope") == "LOCAL");
  	parameters["P_REPOSITORY_USAGE-VARCHAR2-IN"]     = getRadioButtonValue("repositoryUsage");
  	parameters["P_DISABLE_DOM_FIDELITY-BOOLEAN-IN"]  = booleanToNumber(document.getElementById("disableDOMFidelity").checked);
  	parameters["P_DELETE_SCHEMAS-BOOLEAN-IN"]        = booleanToNumber(document.getElementById("deleteSchemas").checked);
  	parameters["P_CREATE_TABLES-BOOLEAN-IN"]         = booleanToNumber(document.getElementById("createTables").checked);
  	parameters["P_LOAD_INSTANCES-BOOLEAN-IN"]        = booleanToNumber(document.getElementById("loadInstances").checked);

  	var xparameters = new Object;  	
  	xparameters["P_XML_SCHEMA_CONFIGURATION-XMLTYPE-IN"]  = registrationConfiguration;

    mgr.sendSoapRequest(parameters,xparameters);
   
  } 
  catch (e) {
    handleException('registrationWizard.startTypeAnalysis',e,null);
  }
		
}

function executeScript() {

  var nl =  registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:FileNames/rc:scriptFilename",rcNamespace)
  var registrationScriptPath = nl.item(0).firstChild.nodeValue;
  window.open('/XFILES/WebDemo/runtime.html?target=' + registrationScriptPath + '&stylesheet=/XFILES/WebDemo/xsl/runtime.xsl&includeContent=true','sqlWindow')

}

function checkRegisterSchema(mgr, index, currentOption) {
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.checkRegisterSchema");
   	var targetList = document.getElementById("registeredSchemaList");
   	targetList.add(currentOption);
    document.getElementById("currentSchema").value = "";
    processSchema(index+1);
  } 
  catch (e) {
    handleException('registrationWizard.checkRegisterSchema',e,null);
  }

}

function registerSchema(schemaSettings, index) {
	
  try {
 
  	var schema      = "XFILES";
    var packageName = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "REGISTER_SCHEMA";
    
    /*
    **
    PROCEDURE REGISTER_SCHMEA
    Argument Name                  Type                    In/Out Default?
    ------------------------------ ----------------------- ------ --------
    P_SCHEMA_LOCATION_HINT         VARCHAR2                IN
    P_SCHEMA_PATH                  VARCHAR2                IN
    P_FORCE                        BOOLEAN                 IN     DEFAULT
    P_OWNER                        VARCHAR2                IN     DEFAULT
    P_DISABLE_DOM_FIDELITY         BOOLEAN                 IN     DEFAULT
    P_TYPE_MAPPINGS                XMLTYPE                 IN     DEFAULT
    **
    */
    
    var sourceList         = document.getElementById("unregisteredSchemaList");
    var targetList         = document.getElementById("registeredSchemaList");
    var disableDomFidelity = document.getElementById("disableDOMFidelity").checked;

    currentOption = sourceList.options[0];
    sourceList.remove(0);
    document.getElementById("currentSchema").value = currentOption.textContent;
    
    var repositoryPath = schemaSettings.selectNodes("rc:repositoryPath",rcNamespace).item(0).firstChild.nodeValue;
    var force          = schemaSettings.selectNodes("rc:force",rcNamespace).item(0).firstChild.nodeValue;
        
  	var mgr = soapManager.getRequestManager(schema,packageName,method);   	
	  var XHR = mgr.createPostRequest();  	  
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { checkRegisterSchema(mgr, index, currentOption ) } };

  	var parameters = new Object;
	  parameters["P_SCHEMA_LOCATION_HINT-VARCHAR2-IN"]  = currentOption.textContent;
   	parameters["P_SCHEMA_PATH-VARCHAR2-IN"]  = repositoryPath
  	parameters["P_FORCE-BOOLEAN-IN"]  = booleanToNumber(force);
  	parameters["P_OWNER-VARCHAR2-IN"]  = httpUsername;
  	parameters["P_DISABLE_DOM_FIDELITY-BOOLEAN-IN"]  = booleanToNumber(disableDomFidelity);
    	
  	var xparameters = new Object;
    	
    mgr.sendSoapRequest(parameters,xparameters);
  } 
  catch (e) {
    handleException('registrationWizard.registerSchema',e,null);
  }
}

function processSchema(index) {
	
  try {     
    var schemaSettings = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[" + index + "]",rcNamespace);
    if (schemaSettings.length > 0) {
	  	schemaSettings = new xmlElement(schemaSettings.item(0));      
    	registerSchema(schemaSettings, index);
    }
    else {
      startTypeAnalysis();
    } 
  } 
  catch (e) {
    handleException('registrationWizard.processSchema',e,null);
  }
}

function startTypeCompilation() {
	
  var selectControl = document.getElementById("unregisteredSchemaList");
  var schemaList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:schemaLocationHint",rcNamespace);
  var schemaLocationPrefix = document.getElementById("schemaLocationPrefix").value
  populateSchemaList(selectControl,schemaList,schemaLocationPrefix);
  showTypeCompilation();  
	processSchema(1);

}

function updateTypeAnalysisLog(logFilePath,finished) {
	
  showFileContent(logFilePath,'typeAnalysisLog');
  
  if (finished) {
  	typeAnalysisInProgress = false;
  }
	
  if (typeAnalysisInProgress) {
	  setTimeout(function(){updateTypeAnalysisLog(logFilePath,false)},5000);
  }
  else {
	  doNext = generateScripts;
  	document.getElementById("btnNext").style.display="block";
  }
}

function displayTypeAnalyis(mgr,logFilePath) {

  updateTypeAnalysisLog(logFilePath,true);      
     
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.validateTypeAnalysis");

   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    namespaces.redefinePrefix("rc",rcNamespace.resolveNamespace("rc"));

    resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_XML_SCHEMA_CONFIG/rc:SchemaRegistrationConfiguration",namespaces);
    
    if (resultSet.length > 0) {
 			registrationConfiguration = new xmlDocument();
    	registrationConfiguration.appendChild(registrationConfiguration.importNode(resultSet.item(0),true));  	
    }
    else {
      var error = new xfilesException("registrationWizard.validateTypeAnalysis",12,null, null);
      error.setDescription("Type Analysis Failure");
      error.setXML(soapResponse);
      throw error;
    }
  } 
  catch (e) {
    handleException('registrationWizard.validateTypeAnalysis',e,null);
  }
	
}

function getSchemaName(schemaLocationHint) {

	var schemaName = schemaLocationHint;
	var offset = schemaLocationHint.lastIndexOf('.xsd');
	if (offset > -1) {
		 schemaName = schemaName.substring(0,offset);
	}
	var offset = schemaLocationHint.lastIndexOf('/');
	if (offset > -1) {
		 schemaName = schemaName.substring(offset+1);
	}
  return schemaName;
}

function startTypeAnalysis() {
	
  showTypeAnalysis();

	var schemaLocationHint = document.getElementById("schemaLocationHint").value;
	var schemaName = getSchemaName(schemaLocationHint);

  var nl =  registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:FileNames/rc:typeOptimizationLogFile",rcNamespace)
  var logFilePath = nl.item(0).firstChild.nodeValue;
	
  try {
 
  	var schema      = "XFILES";
    var packageName = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "DO_TYPE_ANALYSIS";
    
    /*
    **
    ** FUNCTION DO_TYPE_ANALYSIS RETURNS BOOLEAN
    ** Argument Name                  Type                    In/Out Default?
    ** ------------------------------ ----------------------- ------ --------
    ** P_XML_SCHEMA_CONFIG            XMLTYPE                 IN/OUT
    ** P_SCHEMA_LOCATION_HINT         VARCHAR2                IN
    ** P_OWNER                        VARCHAR2                IN     DEFAULT
    **
    */
    
  	var mgr = soapManager.getRequestManager(schema,packageName,method);
  	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayTypeAnalyis(mgr, logFilePath) } };

  	var parameters = new Object;
  	parameters["P_SCHEMA_LOCATION_HINT-VARCHAR2-IN"]  = document.getElementById("schemaLocationHint").value;
  	parameters["P_OWNER-VARCHAR2-IN"]  = httpUsername;
 
  	var xparameters = new Object;
  	xparameters["P_XML_SCHEMA_CONFIG-XMLTYPE-INOUT"]  = registrationConfiguration;
 
    mgr.sendSoapRequest(parameters,xparameters);
    typeAnalysisInProgress = true;
 	  setTimeout(function(){updateTypeAnalysisLog(logFilePath,false)},5000);
  } 
  catch (e) {
    handleException('registrationWizard.startTypeAnalysis',e,null);
  }
		
}

function loadSchemaLocationHint() {
	
	try {
  	missingXMLSchema = new xmlDocument();
	  missingXMLSchema.load(document.getElementById("missingSchemaLocation").value);
    prettyPrintXML(missingXMLSchema,document.getElementById('viewXMLSchema'));
  }
  catch (e) {
    handleException('registrationWizard.loadSchemaLocationHint',e,null);
	}  	
  	
}

function displayLocalFile(XHR) {
	
 try {
  	missingXMLSchema = new xmlDocument(XHR.responseXML);
    prettyPrintXML(missingXMLSchema,document.getElementById('viewXMLSchema')); 		
  } 
  catch (e) {
    handleException('registrationWizard.displayLocalFile',e,null);
  }

}

function viewLocalFile() {

  try {
  	loadLocalXMLFile("localFile",displayLocalFile);
  }
  catch (e) {
    handleException('registrationWizard.viewLocalFile',e,null);
	}  	
}

function saveXMLSchema() {
	
	var repositoryFolderPath = targetFolderTree.getOpenFolder();
	var schemaName = document.getElementById("missingSchemaLocation").value
	if (schemaName.indexOf('/') > 0) {
		schemaName = schemaName.substring(schemaName.lastIndexOf('/')+1);
	}
  if (schemaName.lastIndexOf('.xsd') != (schemaName.length-4)) {
	  schemaName = schemaName + '.xsd';
	}
	
  try {
  	var XHR = new XMLHttpRequest();
    var URL = appendPath(repositoryFolderPath,schemaName);
    XHR.open ("PUT", URL, true);
    XHR.setRequestHeader("Content-type","text/xml");
    XHR.onreadystatechange= function() { 
                              if (XHR.readyState==4) { 
                              	verifySchemaSet();
                              } 
                            };
    XHR.send(missingXMLSchema.serialize());
  }
  catch (e) {
    handleException('registrationWizard.saveXMLSchema',e,null);
	}   	 
}