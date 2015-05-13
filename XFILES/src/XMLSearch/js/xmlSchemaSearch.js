
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


function loadXMLSchemaXSL() {
  stylesheetURL = '/XFILES/XMLSearch/xsl/xmlSchema.xsl';
}

function invokeGetRootNodeMap(nodeMap, xmlSchema, xmlSchemaOwner, globalElement) {

  var schema  = "XFILES";
  var package = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLSCHEMAROOTNODEMAP";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate)}};

	var parameters = new Object;
	parameters["P_GLOBAL_ELEMENT-VARCHAR2-IN"] = globalElement
	parameters["P_SCHEMA_OWNER-VARCHAR2-IN"]   = xmlSchemaOwner		
	parameters["P_SCHEMA_URL-VARCHAR2-IN"]     = xmlSchema
	
  mgr.sendSoapRequest(parameters);
  
}

function invokeGetChildNodeMap(nodeMap, propertyNumber) {

  var schema  = "XFILES";
  var package = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLSCHEMACHILDNODEMAP";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate)}};

	var parameters = new Object;
	parameters["P_PROPERTY_NUMBER-NUMBER-IN"]  = propertyNumber
		
  mgr.sendSoapRequest(parameters);
 
}

function invokeGetSubstitutionGroup(nodeMap, headID,id) {

  var schema  = "XFILES";
  var package = "XFILES_SEARCH_SERVICES";
  var method =  "GETSUBSTITUTIONGROUP";

	var mgr = soapManager.getRequestManager(schema,package,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate, id)}};

	var parameters = new Object;
	parameters["P_HEAD_ELEMENT-NUMBER-IN"]   = headID

  mgr.sendSoapRequest(parameters);
 
}

function expandSubstitutionGroup(nodeMap, headID, id) {
 
  // Optimization. If NodeMap size becomes an issue share the definition.. Will complicate the XSL and make it more difficult to track what the state of a particular
  // instance of the substition group.
   
  // alert('Expand Substition Group for Global Element : ' + headID);
  invokeGetSubstitutionGroup(nodeMap,headID,id);
}

function setDefaultTable(defaultTable, defaultTableSchema) {

  if (defaultTableSchema == 'XDB') {
    if (defaultTable == 'XDB$RESOURCE') {
      document.getElementById('columnName').value = 'RES';
      document.getElementById('tableName').value =  'RESOURCE_VIEW';
      document.getElementById('tableOwner').value = 'PUBLIC';
      return;
    }
    
    if (defaultTable == 'XDB$SCHEMA') {
      document.getElementById('columnName').value = 'SCHEMA';
      document.getElementById('tableName').value =  'ALL_XML_SCHEMAS';
      document.getElementById('tableOwner').value = 'PUBLIC';
      return;
    }    
  }
  
  document.getElementById('columnName').value = 'OBJECT_VALUE';
  document.getElementById('tableName').value =  defaultTable;
  document.getElementById('tableOwner').value = defaultTableSchema;

}

function findContentModel(nodeMap, ID) {

  if (ID.indexOf('.') > 0) {
    ID = ID.substring(ID.lastIndexOf('.')+1);
  }

  // alert('Expand Node : ' + id)
  invokeGetChildNodeMap(nodeMap,ID);
}

function init(target) {

  try {
    initXFilesCommon(target);
    
    loadXMLSchemaXSL();
    loadDocumentIdListXSL();
    loadUniqueKeyListXSL();
    loadResourceListXSL();

    resourceURL = '/XFILES/XMLSearch/xmlSchema.html';
    resource = getResource(resourceURL,target,stylesheetURL,false);
  }
  catch (e) {
    handleException('xmlSchemaSearch.init',e,null);
  }
}

function loadNodeMap() {

    documentNodeMap = new NodeMap( 'documentNodeMap' , loadXMLDocument('/XFILES/XMLSearch/xsl/searchTreeView.xsl'), 'treeView' );
    invokeGetRootNodeMap(documentNodeMap, document.getElementById('xmlSchema').value, document.getElementById('xmlSchemaOwner').value, document.getElementById('globalElement').value);  

}	
function populateFormFields() {

    document.getElementById('xmlSchema').value = unescape(getParameter("xmlSchema"));
    document.getElementById('xmlSchemaOwner').value = getParameter("xmlSchemaOwner");
    document.getElementById('globalElement').value = getParameter("globalElement");
  
    setDefaultTable(getParameter("defaultTable"),getParameter("defaultTableSchema"));

	 loadNodeMap();
}

function doViewXSL() {
	
	closePopupDialog();
  showSourceCode(documentNodeMap.getStylesheet());

}

function doViewXML() {
	
	closePopupDialog();
	showSourceCode(documentNodeMap.getNodeMap());
	
}

function onPageLoaded() {
  populateFormFields();
  viewXSL = doViewXSL;
  viewXML = doViewXML;
}
 

function refreshPage() {
	 loadNodeMap();
}