
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

var ResourceSearchXSL;
var documentNodeMap;
var metadataNodeMap;
var contentNodeMap;
var resourceURL;

function loadResourceSearchXSL() {
  stylesheetURL = '/XFILES/XMLSearch/xsl/resourceSearch.xsl';
}

function loadResourceSearchFormXSL() {
  SearchTreeViewXSL = loadXMLDocument('/XFILES/XMLSearch/xsl/resourceSearchForm.xsl');
}

function setValue(currentElement,newValue) {

  currentElement.setAttribute("value",newValue);
  if (newValue) {
    currentElement.setAttribute("valueVisible","visible");
  }
  else {
    currentElement.setAttribute("valueVisible","hidden");
  }

}

function toggleParentState(nodeMap,currentElement) {

  var state = currentElement.getAttribute("isSelected");
  var parentElement = currentElement.parentNode;
  if (state == "true") {
    parentElement.setAttribute("isSelected","true");
  }
  else {
  	var nl = parentElement.childNodes;
  	for (var i=0; i < nl.length; i++) {
  		var child = nl.item(i);
  		if (child.getAttribute("isSelected") == "true") {
  			return;
  	  }
  	}
    parentElement.setAttribute("isSelected",state);
  }

  if (parentElement != nodeMap.getNodeMap().getDocumentElement()) {
    toggleParentState(nodeMap,parentElement);
  }

}

function toggleFieldStateByLabel(nodeMap,label) {
  
  var target = document.getElementById(label.htmlFor);
  var currentElement = getCurrentElement(nodeMap,target.id);
  setValue(currentElement,target.value);

  var child = document.getElementById(target.id + ".CHILD");
  if (child) {
    currentElement.setAttribute("childValue",child.value);
  }

  toggleElementStateNoRefresh(nodeMap,target.id);

  if (currentElement.getAttribute("isSelected") == "true") {
    // Item has been enabled. Check to see if we enabling a Schema
    checkForSchemaUpdate(nodeMap,target.id)
  }
  else {
    // Item has been disabled. Check to see if we disabling a Schema
    checkForSchemaReset(nodeMap,target.id)    
  }

  toggleParentState(nodeMap,currentElement);
  renderTreeControl(nodeMap);  
   
}

function setFieldValue(nodeMap,target) {

  var currentElement = getCurrentElement(nodeMap,target.id);
  setValue(currentElement,target.value);
  renderTreeControl(nodeMap);
  checkForSchemaUpdate(nodeMap,target.id);    

}


function setParentValue(nodeMap,target) {
	
	/*
	**
	** The Parent value (xmlSchema) has changed.
	** Set the Child Value to "" and render the Nodemap.
	** This which will set select the first Global Element for the chosen XML Schema when the Node Map is Rendered.
	** Once the node map is rendered set the childValue to the value of the child 
	**
	*/

  var currentElement = getCurrentElement(nodeMap,target.id);
  currentElement.setAttribute("childValue","");
  setValue(currentElement,target.value);
  
  renderTreeControl(nodeMap);

  var child = document.getElementById(target.id + ".CHILD");
  if (child) {
    currentElement.setAttribute("childValue",child.value);
  }

  checkForSchemaUpdate(nodeMap,target.id);    

}

function setChildValue(nodeMap,target) {

  var currentElement = getCurrentElement(nodeMap,target.id);
  var child = document.getElementById(target.id + ".CHILD");
  currentElement.setAttribute("childValue",child.value);
  renderTreeControl(nodeMap);
  checkForSchemaUpdate(nodeMap,target.id);    

}

function checkForSchemaUpdate(nodeMap,id) {

  if (nodeMap.isContentSchema(id)) {
    reloadContentSchema(nodeMap,id);
    return;
  }
  
 if (nodeMap.isMetadataSchema(id)) {
    setMetadataSchema(nodeMap,id);
    return;
  }

}

function checkForSchemaReset(nodeMap,id) {

 if (nodeMap.isContentSchema(id)) {
   nodeMap.clearContentSchema();
   return;
 }

 if (nodeMap.isMetadataSchema(id)) {
   nodeMap.clearMetadataSchema();
   return;
 }

}

function checkSchemaState(nodeMap,currentElement) {

  if (currentElement.getAttribute("isSelected") == "true") {
    checkForSchemaUpdate(nodeMap,currentElement.getAttribute("ID"));
  }
  else {
    checkForSchemaReset(nodeMap,currentElement.getAttribute("ID"));
  }

}

function invokeResourceSearch(nodeMap) {

  var schema      = "XFILES";
  var packageName = "XFILES_SEARCH_SERVICES";
  var method =  "GETREPOSITORYNODEMAP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
 	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate)}};

	var parameters = new Object;
  mgr.sendSoapRequest(parameters);

}

function findContentModel(nodeMap, ID) {

  // alert('Expand Node : ' + id)
  
  if (ID.indexOf('.') > 0) {
    ID = ID.substring(ID.lastIndexOf('.')+1);
  }

  invokeGetChildNodeMap(nodeMap,ID);

}

function invokeGetChildNodeMap(nodeMap, propertyNumber) {

  var schema      = "XFILES";
  var packageName = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLSCHEMACHILDNODEMAP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate)}};

	var parameters = new Object;
	parameters["P_PROPERTY_NUMBER-NUMBER-IN"]   = propertyNumber
  
  mgr.sendSoapRequest(parameters);

}
	
function getDocumentNodeMap() {

  return documentNodeMap;

}

function invokeGetRootNodeMap(nodeMap, xmlSchema, xmlSchemaOwner, globalElement) {

  var schema      = "XFILES";
  var packageName = "XFILES_SEARCH_SERVICES";
  var method =  "GETXMLSCHEMAROOTNODEMAP";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR  = mgr.createPostRequest();
  var requestDate  = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate)}};

	var parameters = new Object;
	parameters["P_GLOBAL_ELEMENT-VARCHAR2-IN"]   = globalElement
	parameters["P_SCHEMA_OWNER-VARCHAR2-IN"]     = xmlSchemaOwner		
	parameters["P_SCHEMA_URL-VARCHAR2-IN"]       = xmlSchema

  mgr.sendSoapRequest(parameters);
}

function reloadContentSchema(nodeMap,id) {

  var schOID = getCurrentElement(nodeMap,id).getAttribute("value");
  var globalElementName = getCurrentElement(nodeMap,id).getAttribute("childValue");

  contentNodeMap = new NodeMap( 'contentNodeMap' , loadXMLDocument('/XFILES/XMLSearch/xsl/searchTreeView.xsl'), 'contentSchemaWindow' );
  contentNodeMap.setParent(nodeMap);
  nodeMap.setContentSchema(contentNodeMap);

  var schema     = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Schemas/map:Schema[@SCHOID="' + schOID + '"]',searchNamespaces).item(0);
  invokeGetRootNodeMap(contentNodeMap, schema.getAttribute("Location"), schema.getAttribute("Owner"), globalElementName);  

}

function setMetadataSchema(nodeMap,id) {

  var schOID = getCurrentElement(nodeMap,id).getAttribute("value");
  var globalElementName = getCurrentElement(nodeMap,id).getAttribute("childValue");
  
  metadataNodeMap = new NodeMap( 'metadataNodeMap' , loadXMLDocument('/XFILES/XMLSearch/xsl/searchTreeView.xsl'), 'metadataSchemaWindow' );
  metadataNodeMap.setParent(nodeMap);
  nodeMap.setMetadataSchema(metadataNodeMap);

  var schema     = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Schemas/map:Schema[@SCHOID="' + schOID + '"]',searchNamespaces).item(0);
  invokeGetRootNodeMap(metadataNodeMap, schema.getAttribute("Location"), schema.getAttribute("Owner"), globalElementName);  

}

function init(target) {

  try {
    initXFilesCommon(target);
    loadResourceSearchXSL();
    loadResourceSearchFormXSL();
    loadResourceListXSL();

    searchTerms  =  unescape(getParameter("searchTerms"));
  
    resourceURL  =   unescape(getParameter("target"));
    resource = getResource(resourceURL,target,stylesheetURL,false);
  }
  catch (e) {
    handleException('resourceSearch.init',e,null);
  }
}

function setSchemaIDs(nodeMap) {

  // Get the ID of the Elements in the node map associated with the Content Schema and the Metadata schema. This will be used to identify
  // when an operation has resulted in a change to the Content or Metadata Schema that means it needs to be reloaded.

  var contentSchema =  nodeMap.getNodeMap().selectNodes("//map:Element[substring-after(map:Name,':')='SchOID']",searchNamespaces).item(0);
  nodeMap.setContentSchemaID(contentSchema.getAttribute("ID"));
  nodeMap.setMetadataSchemaID('MetadataSchema');
 
}

function populateFormFields() {

  document.getElementById('columnName').value = 'RES';
  document.getElementById('tableName').value =  'RESOURCE_VIEW';
  document.getElementById('tableOwner').value = 'PUBLIC';
     
  documentNodeMap = new NodeMap( 'documentNodeMap' , loadXMLDocument('/XFILES/XMLSearch/xsl/resourceSearchForm.xsl'), 'treeView' );
  invokeResourceSearch(documentNodeMap);  

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
  document.getElementById("xmlIndexOptions").style.display = "none";
  viewXSL = doViewXSL;
  viewXML = doViewXML;
}
 