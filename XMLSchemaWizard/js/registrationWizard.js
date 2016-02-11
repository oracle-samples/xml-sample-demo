
var targetFolderTree
var targetFolder = null

var schemaContainerPath; 

var rcPrefixList = { "rc"  :  "http://xmlns.oracle.com/xdb/pm/registrationConfiguration" };
var	rcNamespace = new namespaceManager(rcPrefixList)
var registrationConfiguration;


var rcNamespace;
var typeAnalysisInProgress = false;

var globalElementListXSL 


function loadGlobalElementListXSL() {
  globalElementListXSL = loadXSLDocument("/XFILES/Applications/XMLSchemaWizard/xsl/globalElementList.xsl");
}

var currentSchema;

function doNothing() {
}

var doNext = doNothing;
var doPrev = doNothing;

function reportUploadError(repositoryPath,SQLCODE,SQLERRM) {
  error = new xfilesException("XFILES.XFILES_DOCUMENT_UPLOAD.SINGLE_DOC_UPLOAD",12,repositoryPath);
  error.setDescription(SQLERRM);
  error.setNumber(SQLCODE);
  handleException('registrationWizard.submit',error,repositoryPath);
}

function onPageLoaded() {

	openModalDialog("registrationWizard");
	loadFolderTree(xfilesNamespaces,document.getElementById('treeLoading'),document.getElementById('treeControl'))
	loadGlobalElementListXSL();
	showSelectFolder();
}

function changeStorageModel() {
	
	if (getRadioButtonValue("storageModel") == "OR") {
	  document.getElementById("tab_compileTypes").style.display="block";
	  document.getElementById("tab_analyzeTypes").style.display="block";
  }
  else {
	  document.getElementById("tab_compileTypes").style.display="none";
	  document.getElementById("tab_analyzeTypes").style.display="none";
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

function appendPaths(schemaLocationPrefix,localPath) {
	
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

function updateSchemaLocationHint() {

  document.getElementById("schemaLocationHint").value = appendPaths(document.getElementById("schemaLocationPrefix").value,document.getElementById("schemaList").value);
  registrationConfiguration.getDocumentElement().setAttribute('schemaLocationPrefix',document.getElementById("schemaLocationPrefix").value)
 
}

function executeDeleteSchemaScript(mgr) {

  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.executeDeleteSchemaScript");
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    if (resultSet.length > 0) {
      var deleteScriptPath = resultSet.item(0).firstChild.nodeValue;
      window.open('/XFILES/WebDemo/runtime.html?target=' + deleteScriptPath + '&stylesheet=/XFILES/WebDemo/xsl/runtime.xsl&includeContent=true','sqlWindow')
   	  return;
   	}
  } catch (e) {
    handleException('registrationWizard.executeDeleteSchemaScript',e,null);
  }

}

function doDeleteSchemas() {

  // Generate and run a Delete Script. Delete Schemas, Tables and Types.
  
  try {
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "CREATE_DELETE_SCHEMA_SCRIPT";
	
  	var mgr = soapManager.getRequestManager(schema,package,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { executeDeleteSchemaScript(mgr) } };
  
  	var parameters = new Object;
  	var xparameters = new Object;
  	
  	xparameters["P_XML_SCHEMA_CONFIGURATION-XMLTYPE-IN"]  = registrationConfiguration;

    mgr.sendSoapRequest(parameters,xparameters);
   
  } 
  catch (e) {
    handleException('registrationWizard.orderSchemas',e,null);
  } 
}

function selectSchema() {
	
 	showUserErrorMessage("Select the primary XML Schema. This is usually the XML schema that contains the definition of the root element");

}

function showSelectFolder() {
	
	$('#wizardSteps a[href="#wizardChooseFolder"]').tab('show')
	
}

function showRootElements() {

	$('#wizardSteps a[href="#wizardSelectElements"]').tab('show')
  // doNext = processSchemas;
  doNext = doNothing;
  document.getElementById("btnNext").style.display="block";

}

function processOrderedSchemas() {

  if (getRadioButtonValue("storageModel") == "CSX") {
	  showGenerateScripts();
  } 
  else {
	  startTypeCompilation();
  }
}


function showOrderSchemas() {
	
	$('#wizardSteps a[href="#step_orderSchemas"]').tab('show')
  doNext = processOrderedSchemas;
  document.getElementById("btnNext").style.display="block";

}
 
function showTypeCompilation() {
	
	$('#wizardSteps a[href="#step_compileTypes"]').tab('show')
  doNext = doNothing;
  document.getElementById("btnNext").style.display="none";

}

function showTypeAnalysis() {
	
	$('#wizardSteps a[href="#step_analyzeTypes"]').tab('show')
  doNext = doNothing;
  document.getElementById("btnNext").style.display="none";

}

function showGenerateScripts() {
	
	$('#wizardSteps a[href="#step_createScripts"]').tab('show')
  
  doNext = generateSchemaRegistrationScript;
  document.getElementById("btnNext").style.display="block";

}

function showSchemaRegistrationScript() {
	
  $('#wizardSteps a[href="#step_reviewScripts"]').tab('show')
  
  doNext = doNothing;
  document.getElementById("btnNext").style.display="none";

}

function getTargetNamespace(repositoryPath,schemaConfiguration) {

  var nl =  schemaConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[rc:repositoryPath=\"" + repositoryPath + "\"]/rc:targetNamespace",rcNamespace)
  return nl.item(0).firstChild.nodeValue;

}

function showFileContent(path,target) {
	
  try {

    var logFileContent = getDocumentContent(path);

    var logWindow = document.getElementById(target)
 	  while (logWindow.hasChildNodes()){
  	 	 logWindow.removeChild(logWindow.firstChild);
 	  }
     
    /*
    **
    ** var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
    ** var XHR = mgr.createPostRequest(false);
    ** mgr.executeSQL("select xdburitype('" + logFileName + "').getClob() LOGFILECONTENT from dual");    
    ** 
	  ** var soapResponse = mgr.getSoapResponse("registrationWizard.showFileContent");
    **
   	** var namespaces = xfilesNamespaces
	  ** namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    **
    ** var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET/orawsv:ROW/orawsv:LOGFILECONTENT",namespaces );
    ** var logFileContent = resultSet.item(0).firstChild.nodeValue;
    **
    */
    
    logWindow.appendChild(document.createTextNode(logFileContent));
    logWindow.parentNode.scrollTop = logWindow.parentNode.scrollHeight;
  }
  catch (e) {
   error = new xfilesException("registrationWizard.showFileContent",14,logFileName,e);
   throw error;
  }
	
}

function displayGlobalElementList(mgr) {


	try {
		
		var globalElementList = document.getElementById("globalElementList");
  
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displayGlobalElementList");
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    // showSourceCode(soapResponse);

		var container = document.getElementById("globalElementList");	
		container.innerHTML = "";

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    if (resultSet.length > 0) {
    	transformXMLtoXHTML(soapResponse,globalElementListXSL,container);
    }
    error = new xfilesException("registrationWizard.displayGlobalElementList",12,null, null);
    error.setXML(soapResponse);
    throw error;
  } 
  catch (e) {
    handleException('registrationWizard.displayGlobalElementList',e,null);
  }
  
}

function listGlobalElements(repositoryPath) {

	// showRootElements();

	// var repositoryPath = targetFolderTree.getOpenFolder();

  try {
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "GET_GLOBAL_ELEMENT_LIST";
	
	  var mgr = soapManager.getRequestManager(schema,package,method);
    var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayGlobalElementList(mgr) } };
  
	  var parameters = new Object;
  	
	  parameters["P_XML_SCHEMA_FOLDER-VARCHAR2-IN"]  = repositoryPath;
    mgr.sendSoapRequest(parameters);

  } 
  catch (e) {
    handleException('registrationWizard.listGlobalElements',e,null);
  }

}

function displaySchemaList(mgr,repositoryPath) {
	
	var schemaList = document.getElementById("schemaList");
  loadOptionList(mgr, schemaList, schemaList, false, false)
    
  if (schemaList.options.length > 0) {
	  listGlobalElements(repositoryPath);
    document.getElementById("btnNext").style.display="block";
  }
  else {
    doNext = doNothing
	  // schemaList.style.display = "none";
    document.getElementById("btnNext").style.display="none";
    // document.getElementById("schemaListContainer").style.display="none";
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
	
  doNext = orderSchemas;   
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
    error = new xfilesException("registrationWizard.displaySchemaList",12,null, null);
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
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "UNPACK_ARCHIVE";

  	var mgr = soapManager.getRequestManager(schema,package,method);
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
 
  // Processing will Continue in uploadSchemaArchive
  
  openModalDialog("uploadArchive")
 
}

function populateSchemaList(selectControl,schemaList,schemaLocationPrefix) {

 	while (selectControl.options.length > 0){
		selectControl.remove(0)
 	}
    	
  if (schemaList.length > 0) {
	  for (var i=0;i< schemaList.length; i++) {
 		  option = document.createElement("option");
      selectControl.appendChild(option);  
      var schemaLocationHint = appendPaths(schemaLocationPrefix,schemaList.item(i).firstChild.nodeValue);
      var text = document.createTextNode(schemaLocationHint);
      option.appendChild(text);
      option.value = schemaLocationHint;
    }
  }    
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
      var qname = tableDefinition.selectNodes("rc:globalElement",rcNamespace).item(0).firstChild.nodeValue;
      if (namespace != "") {
        var qname = namespace + ":" + qname;
      }
      var text = document.createTextNode(qname);
      option.appendChild(text);
      option.value = i+1;
    }
  }    
}

function displaySchemaOrdering(mgr,rootSchemaPath) {
	
	showOrderSchemas();
		
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displaySchemaOrdering");

   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    namespaces.redefinePrefix("rc",rcNamespace.resolveNamespace("rc"));

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/rc:SchemaRegistrationConfiguration",namespaces);
    
    if (resultSet.length > 0) {
    	
			registrationConfiguration = new xmlDocument();
    	registrationConfiguration.appendChild(registrationConfiguration.importNode(resultSet.item(0),true));  	

      if (rootSchemaPath != "") {
		    var targetNamespace = getTargetNamespace(rootSchemaPath,registrationConfiguration);
  	    document.getElementById("targetNamespace").value = targetNamespace

     	  var schemaLocationPrefix = targetNamespace
	       // Code here to attempt to strip .xsd and XML Schema path from targetNamespace.
	      if (schemaLocationPrefix.indexOf('.xsd') == (schemaLocationPrefix.length-4)) {
		      schemaLocationPrefix = schemaLocationPrefix.substring(0,schemaLocationPrefix.length-4);
        }
        document.getElementById("schemaLocationPrefix").value = schemaLocationPrefix

        updateSchemaLocationHint();
      }

    	var selectControl = document.getElementById("orderedSchemaList");
    	var schemaList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:schemaLocationHint",rcNamespace);
    	populateSchemaList(selectControl,schemaList,"");

    	var selectControl = document.getElementById("globalElementList");
    	var globalElementList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:Table",rcNamespace);
    	populateElementList(selectControl,globalElementList);

    	return;
    }
    
    error = new xfilesException("registrationWizard.displaySchemaOrdering",12,null, null);
    error.setDescription("Invalid Schema List Document");
    error.setXML(soapResponse);
    throw error;
  } 
  catch (e) {
    handleException('registrationWizard.displaySchemaOrdering',e,null);
  }

}

function orderSchemas() {

	/*
	** Orders the schemas needed to successfully register the Selected Schema.
	**
	*/

  var rootSchema = document.getElementById("schemaList").value;
  var repositoryFolderPath = targetFolderTree.getOpenFolder();
  document.getElementById("repositoryFolderPath").value = repositoryFolderPath
  
  var rootSchemaPath = "";
  if (rootSchema != "") {
  	rootSchemaPath = appendPaths(repositoryFolderPath,rootSchema);
  }
  
  try {
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "ORDER_SCHEMAS";
	
  	var mgr = soapManager.getRequestManager(schema,package,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displaySchemaOrdering(mgr,rootSchemaPath) } };
  
  	var parameters = new Object;
  	
  	parameters["P_XML_SCHEMA_FOLDER-VARCHAR2-IN"]  = repositoryFolderPath;
  	parameters["P_ROOT_XML_SCHEMA-VARCHAR2-IN"]  = rootSchema;
  	parameters["P_SCHEMA_LOCATION_PREFIX-VARCHAR2-IN"]  = "";
    mgr.sendSoapRequest(parameters);
   
  } 
  catch (e) {
    handleException('registrationWizard.orderSchemas',e,null);
  }
}

function startTypeCompilation() {
	
  var selectControl = document.getElementById("unregisteredSchemaList");
  var schemaList = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation/rc:schemaLocationHint",rcNamespace);
  var schemaLocationPrefix = document.getElementById("schemaLocationPrefix").value
  populateSchemaList(selectControl,schemaList,schemaLocationPrefix);
  showTypeCompilation();  
	registerSchema(1);

}

function checkRegisterSchema(mgr, index, currentOption) {
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.checkRegisterSchema");
   	var targetList = document.getElementById("registeredSchemaList");
   	targetList.add(currentOption);
    document.getElementById("currentSchema").value = "";
    registerSchema(index);
  } 
  catch (e) {
    handleException('registrationWizard.checkRegisterSchema',e,null);
  }

}

function registerSchema(index) {
	
  try {
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
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
    
    var schemaSettings = registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:SchemaInformation[" + index + "]",rcNamespace);
    
    if (schemaSettings.length > 0) {
      var sourceList         = document.getElementById("unregisteredSchemaList");
      var targetList         = document.getElementById("registeredSchemaList");
      var disableDomFidelity = document.getElementById("disableDOMFidelity").checked;

      currentOption = sourceList.options[0];
      sourceList.remove(0);
      document.getElementById("currentSchema").value = currentOption.value;
    
    	var schemaSettings = new xmlElement(schemaSettings.item(0));      
      var repositoryPath = schemaSettings.selectNodes("rc:repositoryPath",rcNamespace).item(0).firstChild.nodeValue;
      var force          = schemaSettings.selectNodes("rc:force",rcNamespace).item(0).firstChild.nodeValue;
        
    	var mgr = soapManager.getRequestManager(schema,package,method);   	
  	  var XHR = mgr.createPostRequest();  	  
      XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { checkRegisterSchema(mgr, index + 1, currentOption ) } };

    	var parameters = new Object;
  	  parameters["P_SCHEMA_LOCATION_HINT-VARCHAR2-IN"]  = currentOption.value;
     	parameters["P_SCHEMA_PATH-VARCHAR2-IN"]  = repositoryPath
    	parameters["P_FORCE-BOOLEAN-IN"]  = booleanToNumber(force);
    	parameters["P_OWNER-VARCHAR2-IN"]  = httpUsername;
    	parameters["P_DISABLE_DOM_FIDELITY-BOOLEAN-IN"]  = booleanToNumber(disableDomFidelity);
    	
    	var xparameters = new Object;
    	
      mgr.sendSoapRequest(parameters,xparameters);
    }
    else {
      startTypeAnalysis();
    } 
  } 
  catch (e) {
    handleException('registrationWizard.registerSchema',e,null);
  }
}

function showTypeAnalysisLog(logFileName) {

   showFileContent(logFilePath,'typeAnalysisLog');

}

function updateTypeAnalysisLog(logFilePath) {
	
  showTypeAnalysisLog(logFilePath);
	
  if (typeAnalysisInProgress) {
	  setTimeout(function(){updateTypeAnalysisLog(logFilePath)},5000);
  }
}

function displayTypeAnalyis(mgr,logFilePath) {

  typeAnalysisInProgress = false;
  doNext = showGenerateScripts;
  document.getElementById("btnNext").style.display="block";
     
  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.validateTypeAnalysis");

   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    namespaces.redefinePrefix("rc",rcNamespace.resolveNamespace("rc"));

    resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_XML_SCHEMA_CONFIG/rc:SchemaRegistrationConfiguration",namespaces);
    
    if (resultSet.length > 0) {
 			registrationConfiguration = new xmlDocument();
    	registrationConfiguration.appendChild(registrationConfiguration.importNode(resultSet.item(0),true));  	
      showTypeAnalysisLog(logFilePath);      
      showGenerateScripts();
    }
    else {
      error = new xfilesException("registrationWizard.validateTypeAnalysis",12,null, null);
      error.setDescription("Type Analysis Failure");
      error.setXML(soapResponse);
      throw error;
    }
  } 
  catch (e) {
    handleException('registrationWizard.validateTypeAnalysis',e,null);
  }
	
}

function startTypeAnalysis() {
	
  showTypeAnalysis();

	var schemaLocationHint = document.getElementById("schemaLocationHint").value;
	var schemaName = getSchemaName(schemaLocationHint);

	var logFilePath = registrationConfiguration.getDocumentElement().getAttribute("typeOptimization");
	
  try {
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
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
    
  	var mgr = soapManager.getRequestManager(schema,package,method);
  	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayTypeAnalyis(mgr, logFilePath) } };

  	var parameters = new Object;
  	parameters["P_SCHEMA_LOCATION_HINT-VARCHAR2-IN"]  = document.getElementById("schemaLocationHint").value;
  	parameters["P_OWNER-VARCHAR2-IN"]  = httpUsername;
 
  	var xparameters = new Object;
  	xparameters["P_XML_SCHEMA_CONFIG-XMLTYPE-INOUT"]  = registrationConfiguration;
 
    mgr.sendSoapRequest(parameters,xparameters);
    typeAnalysisInProgress = true;   
    setTimeout(function(){updateTypeAnalysisLog(logFilePath)},5000);
  } 
  catch (e) {
    handleException('registrationWizard.startTypeAnalysis',e,null);
  }
		
}


function executeRegisterSchemaScript() {

  var nl =  registrationConfiguration.selectNodes("/rc:SchemaRegistrationConfiguration/rc:FileNames/rc:registrationScriptFile",rcNamespace)
  var registrationScriptPath = nl.item(0).firstChild.nodeValue;
  window.open('/XFILES/WebDemo/runtime.html?target=' + registrationScriptPath + '&stylesheet=/XFILES/WebDemo/xsl/runtime.xsl&includeContent=true','sqlWindow')

}

function displayRegistrationScript(mgr) {

  try {
   	var soapResponse = mgr.getSoapResponse("registrationWizard.displayRegistrationScript");
   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    var resultSet = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN",namespaces);
    if (resultSet.length > 0) {
      var registrationScriptPath = resultSet.item(0).firstChild.nodeValue;
      showFileContent(registrationScriptPath,'registrationScript');
   	  return;
   	}
  } catch (e) {
    handleException('registrationWizard.displayRegistrationScript',e,null);
  }

}
  
function generateSchemaRegistrationScript() {

  /*
  ** FUNCTION CREATE_REGISTER_SCHEMA_SCRIPT RETURNS VARCHAR2
  ** Argument Name                  Type                    In/Out Default?
  ** ------------------------------ ----------------------- ------ --------
  ** P_XML_SCHEMA_CONFIGURATION     XMLTYPE                 IN
  ** P_BINARY_XML                   BOOLEAN                 IN     DEFAULT
  ** P_LOCAL                        BOOLEAN                 IN     DEFAULT
  ** P_DISABLE_DOM_FIDELITY         BOOLEAN                 IN     DEFAULT
  ** P_GENERATE_TABLES              BOOLEAN                 IN     DEFAULT  **
  */
  
  showSchemaRegistrationScript();

  try {
 
  	var schema  = "XFILES";
    var package = "XFILES_XMLSCHEMA_WIZARD";
    var method =  "CREATE_REGISTER_SCHEMA_SCRIPT";
	
  	var mgr = soapManager.getRequestManager(schema,package,method);
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { displayRegistrationScript(mgr) } };
  
  	var parameters = new Object;
  	parameters["P_BINARY_XML-BOOLEAN-IN"]            = booleanToNumber(getRadioButtonValue("storageModel") == "CSX");
  	parameters["P_LOCAL-BOOLEAN-IN"]                 = booleanToNumber(getRadioButtonValue("localSchema") == "LOCAL");
  	parameters["P_DISABLE_DOM_FIDELITY-BOOLEAN-IN"]  = booleanToNumber(document.getElementById("disableDOMFidelity").checked);
  	parameters["P_GENERATE_TABLES-BOOLEAN-IN"]       = booleanToNumber(document.getElementById("generateTables").checked);
  	var xparameters = new Object;
  	
  	xparameters["P_XML_SCHEMA_CONFIGURATION-XMLTYPE-IN"]  = registrationConfiguration;

    mgr.sendSoapRequest(parameters,xparameters);
   
  } 
  catch (e) {
    handleException('registrationWizard.startTypeAnalysis',e,null);
  }
		
}

