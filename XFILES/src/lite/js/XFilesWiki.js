
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

var xinhaController 

function onPageLoaded() {
 
  var content
 
  var nl = resource.selectNodes("/res:Resource/res:Contents/wiki:XFilesWikiPage/xhtml:div",xfilesNamespaces);
  if (nl.length > 0) {
    content = new xmlDocument();
    content.appendChild(content.importNode(nl.item(0).cloneNode(true),true));
  }
  else {
    content = new xmlDocument().parse("<div xmlns=\"http://www.w3.org/1999/xhtml\"/>");
  }

 	xinhaController = new XinhaController("editWikiPage","viewWikiPage","viewingControls","editingControls","undoControls","saveAndCloseButtons")
  // xinhaController.loadXinha("wikiEditor","98%",screen.availHeight * 0.5) + "px";
  xinhaController.loadXinha("wikiEditor","98%","500px");
  xinhaController.hideEditor();
  xinhaController.setContent(content);

}

function processUpdate(mgr, updatedContent, closeForm) {

  try {
    var soapResponse   = mgr.getSoapResponse('XFilesWiki.processUpdate');
    showInfoMessage("Update Complete.");     
    if (closeForm) {
      closeCurrentWindow();
    }
    // contentUpdatedFlag  = false;
    xinhaController.setContent(xinhaController.getContent());
   }
  catch (e) {
    handleException('XFilesWiki.processUpdate',e,null);
  }

}

function saveChanges(closeForm) {
    
  var schema      = "XFILES";
  var packageName = "XFILES_WIKI_SERVICES";
  var method =  "UPDATEWIKIPAGE";

  var newContent = new xmlDocument().parse('<wiki:XFilesWikiPage xmlns:wiki="http://xmlns.oracle.com/xdb/xfiles/wiki" xmlns:xhtml="http://www.w3.org/1999/xhtml"/>');
  newContent.getDocumentElement().appendChild(newContent.importNode(xinhaController.getContent().getDocumentElement().cloneNode(true),true));

	var mgr = soapManager.getRequestManager(schema,packageName,method);	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { processUpdate(mgr, newContent, closeForm)}};

	var parameters = new Object;
	parameters["P_RESOURCE_PATH-VARCHAR2-IN"]   = resourceURL

	var xparameters = new Object;
	xparameters["P_CONTENTS-XMLTYPE-IN"]   = newContent;

  mgr.sendSoapRequest(parameters,xparameters); 
  
}

function doSave() {
  try {
    saveChanges(false);
  }
  catch (e) {
    handleException('XFilesWiki.doSave',e,null);
  }
}

function doSaveAndClose() {
  try {
	  saveChanges(true);
  }
  catch (e) {
    handleException('XFilesWiki.doSaveAndClose',e,null);
  }
}
	