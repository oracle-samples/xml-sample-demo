
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

var dummy // Declaring a variable seems to help IE load the script correctly

function onPageLoaded() {
  updatePickLists();
}

function updatePickLists() {

  if (resource.selectNodes('/res:Resource[@Container="false"]',xfilesNamespaces).length > 0) {
    target = resource.selectNodes('/res:Resource/res:CharacterSet',xfilesNamespaces).item(0).firstChild.nodeValue;
    if (document.getElementById(target)) {
      document.getElementById(target).selected='selected';
    }
    target = resource.selectNodes('/res:Resource/res:Language',xfilesNamespaces).item(0).firstChild.nodeValue
    if (document.getElementById(target)) {
      document.getElementById(target).selected='selected';
    }
  }

}

function processUpdate(mgr, outputWindow, closeFormWhenFinished) {

  try {
    soapResponse = mgr.getSoapResponse('ResourceProperties.processUpdate');

   	var namespaces = xfilesNamespaces
	  namespaces.redefinePrefix("tns",mgr.getServiceNamespace());
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:P_UPDATED_RESOURCE/res:Resource",namespaces);
    if (nodeList.length == 1) {
      showInfoMessage('Resource Updated');
      if (closeFormWhenFinished) {
        closeCurrentWindow();
      }
      resource = importResource(nodeList.item(0));
      displayResource(resource,outputWindow,stylesheetURL);
      return;
    }
    
    var error = new xfilesException('ResourceProperties.processUpdate',12, resourceURL, null);
    error.setDescription("Invalid Update Properties Document Receieved :  " + soapResponse.serialize());
    throw error;
  }
  catch (e) {
    handleException('ResourceProperties.processUpdate',e,null);
  }

}

function doSave() {
  saveChanges(false);
}

function doSaveAndClose() {
  saveChanges(true);
}

function updateProperties(resourceURL, closeFormWhenFinished, newValues, outputWindow) {

  var schema      = "XFILES";
  var packageName = "XFILES_SOAP_SERVICES";
  var method =  "UPDATEPROPERTIES";

	var mgr = soapManager.getRequestManager(schema,packageName,method);
	var XHR = mgr.createPostRequest();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processUpdate(mgr, outputWindow, closeFormWhenFinished)}};

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"] = resourceURL
	parameters["P_TIMEZONE_OFFSET-NUMBER-IN"] = timezoneOffset 
  parameters["P_CACHE_RESULT-NUMBER-IN"] = cacheResult;

	var xparameters = new Object;
	xparameters["P_NEW_VALUES-XMLTYPE-IN"] = newValues
		
  mgr.sendSoapRequest(parameters,xparameters); 
    
}

function saveChanges(closeFormWhenFinished) {

  var modification = new xmlDocument();
  var root = modification.createElement("ResourceUpdate");
  modification.appendChild(root);
  
  isContainer = resource.selectNodes('/res:Resource[@Container="true"]',xfilesNamespaces).length > 0;
  
  var newDisplayName   = document.getElementById('DisplayName').value;
  
  if (!isContainer) {
    var newAuthor        = document.getElementById('Author').value;
  }
  
  var newComment       = document.getElementById('Comment').value;

  var newCharacterSet;
  var newLanguage;     
  
  if (!isContainer) {
    newCharacterSet  = document.getElementById('CharacterSet').value;
     newLanguage      = document.getElementById('Language').value;
  }
  
  var oldDisplayName   = resource.selectNodes('/res:Resource/res:DisplayName',xfilesNamespaces).item(0).firstChild.nodeValue;

  var oldAuthor;
  var oldAuthorList  = resource.selectNodes('/res:Resource/res:Author',xfilesNamespaces);
  if (oldAuthorList.length > 0) {
    oldAuthor = oldAuthorList.item(0).firstChild.nodeValue;
  }

  var oldComment
  var oldCommentList = resource.selectNodes('/res:Resource/res:Comment',xfilesNamespaces);
  if (oldCommentList.length > 0) {
    oldCommennt = oldCommentList.item(0).firstChild.nodeValue;
  }
 
  var oldCharacterSet  = resource.selectNodes('/res:Resource/res:CharacterSet',xfilesNamespaces).item(0).firstChild.nodeValue;
  var oldLanguage      = resource.selectNodes('/res:Resource/res:Language',xfilesNamespaces).item(0).firstChild.nodeValue;

  if (oldDisplayName != newDisplayName) {
    var displayName = modification.createElement("DisplayName");
    var text        = modification.createTextNode(newDisplayName);
    displayName.appendChild(text);
    root.appendChild(displayName);
    var updateLinkName   = document.getElementById('RenameLink').checked;
    if (updateLinkName) {
      displayName.setAttribute('renameLinks','true');
    }
  }  
  
  if ((newAuthor) && (oldAuthor != newAuthor )) {
    var author = modification.createElement("Author");
    var text   = modification.createTextNode(newAuthor);
    author.appendChild(text);
    root.appendChild(author);
  }  

  if ((newComment) && (oldComment != newComment)) {
    var comment = modification.createElement("Comment");
    var text   = modification.createTextNode(newComment);
    comment.appendChild(text);
    root.appendChild(comment);
  }  

  if (oldCharacterSet != newCharacterSet) {
    var characterSet = modification.createElement("CharacterSet");
    var text   = modification.createTextNode(newCharacterSet);
    characterSet.appendChild(text);
    root.appendChild(characterSet);
  }  

  if (oldLanguage != newLanguage) {
    var language = modification.createElement("Language");
    var text   = modification.createTextNode(newLanguage);
    language.appendChild(text);
    root.appendChild(language);
  }  
 
  updateProperties(resourceURL, closeFormWhenFinished, modification, document.getElementById('pageContent'));

}

function doPreviewDocument(event) {
	openModalDialog("documentPreviewDialog");
}