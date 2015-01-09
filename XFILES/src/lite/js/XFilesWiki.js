
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

var contentUpdatedFlag;
var originalContent
var currentContent

function onPageLoaded() {
 
  contentUpdatedFlag = false;

  setViewingMode(false);
 
  var nl = resource.selectNodes("/res:Resource/res:Contents/wiki:XFilesWikiPage/xhtml:div",xfilesNamespaces);
  if (nl.length > 0) {
    originalContent = new xmlDocument();
    originalContent.appendChild(originalContent.importNode(nl.item(0).cloneNode(true),true));
  }
  else {
    originalContent = new xmlDocument().parse("<div xmlns=\"http://www.w3.org/1999/xhtml\"/>");
  }

  currentContent = originalContent; 
  var viewContent = document.getElementById("viewContent");
  viewContent.innerHTML = contentToHTML.toText(currentContent);
  
  editorFrame = document.getElementById("editContent");
  editorFrame.style.display ="block";
  editorFrame.style.position ="absolute";
  editorFrame.style.left = "-2000px";

  loadXinhaWiki();
  xinha_init();
}

function loadXinhaWiki() {

  xinha_init    = null;
                                                                              
  xinha_editors = null;
  xinha_config  = null;
  xinha_plugins = null;

  xinha_init = xinha_init ? xinha_init : function()
  {

    /** STEP 1 ***************************************************************
    * First, specify the textareas that shall be turned into Xinhas. 
    * For each one add the respective id to the xinha_editors array.
    * I you want add more than on textarea, keep in mind that these 
    * values are comma seperated BUT there is no comma after the last value.
    * If you are going to use this configuration on several pages with different
    * textarea ids, you can add them all. The ones that are not found on the
    * current page will just be skipped.
    ************************************************************************/
    
    xinha_editors = xinha_editors ? xinha_editors :
    [
      'xinhaWiki'
    ];
  
   
    /** STEP 2 ***************************************************************
    * Now, what are the plugins you will be using in the editors on this
    * page.  List all the plugins you will need, even if not all the editors
    * will use all the plugins.
    *
    * The list of plugins below is a good starting point, but if you prefer
    * a simpler editor to start with then you can use the following 
    * 
    * xinha_plugins = xinha_plugins ? xinha_plugins : [ ];
    *
    * which will load no extra plugins at all.
    ************************************************************************/
  
    xinha_plugins = xinha_plugins ? xinha_plugins :
    [
      'CharacterMap',
      'ContextMenu',
      'ListType',
      'Stylist',
      'SuperClean',
      'TableOperations'
    ];
    
    // THIS BIT OF JAVASCRIPT LOADS THE PLUGINS, NO TOUCHING  :)
    if(!Xinha.loadPlugins(xinha_plugins, xinha_init)) return;
  
    /** STEP 3 ***************************************************************
     * We create a default configuration to be used by all the editors.
     * If you wish to configure some of the editors differently this will be
     * done in step 5.
     *
     * If you want to modify the default config you might do something like this.
     *
     *   xinha_config = new Xinha.Config();
     *   xinha_config.width  = '640px';
     *   xinha_config.height = '420px';
     *
     *************************************************************************/
  
     xinha_config = xinha_config ? xinha_config() : new Xinha.Config();
     
     // To adjust the styling inside the editor, we can load an external stylesheet like this
     // NOTE : YOU MUST GIVE AN ABSOLUTE URL
    
     xinha_config.pageStyleSheets = [ _editor_url + "examples/full_example.css" ];
    
    /** STEP 4 ***************************************************************
    * We first create editors for the textareas.
    *
    * You can do this in two ways, either
    *
    *   xinha_editors   = Xinha.makeEditors(xinha_editors, xinha_config, xinha_plugins);
    *
    * if you want all the editor objects to use the same set of plugins, OR;
    *
    *   xinha_editors = Xinha.makeEditors(xinha_editors, xinha_config);
    *   xinha_editors.myTextArea.registerPlugins(['Stylist']);
    *   xinha_editors.anotherOne.registerPlugins(['CSS','SuperClean']);
    *
    * if you want to use a different set of plugins for one or more of the
    * editors.
    ************************************************************************/
  
    xinha_editors   = Xinha.makeEditors(xinha_editors, xinha_config, xinha_plugins);
  
    /** STEP 5 ***************************************************************
    * If you want to change the configuration variables of any of the
    * editors,  this is the place to do that, for example you might want to
    * change the width and height of one of the editors, like this...
    *
    *   xinha_editors.myTextArea.config.width  = '640px';
    *   xinha_editors.myTextArea.config.height = '480px';
    *
    ************************************************************************/
    
    xinha_editors.xinhaWiki.config.width  = "100%";
    xinha_editors.xinhaWiki.config.height = screen.availHeight * 0.5
  
    xinha_editors.xinhaWiki._onGenerate = function()
    { 
      editorFrame = document.getElementById("editContent");
      editorFrame.style.display = "none";
		  editorFrame.style.position = "";
      editorFrame.style.left = "";
    }
    
    /** STEP 6 ***************************************************************
     * Finally we "start" the editors, this turns the textareas into
     * Xinha editors.
     ************************************************************************/
  
    Xinha.startEditors(xinha_editors);
  }
}

function setViewingMode(contentUpdated) {

  document.getElementById("viewContent").style.display="block";
  document.getElementById("editContent").style.display="none";	
  document.getElementById("wikiEditingControls").style.display="none";
  document.getElementById("wikiViewingControls").style.display="block";
  
	if (contentUpdated) {
		document.getElementById("saveAndCloseButtons").style.display="block";
	}
	else {
		document.getElementById("saveAndCloseButtons").style.display="none";
  }
    
}

function setEditingMode(contentUpdated) {

  document.getElementById("viewContent").style.display="none";
  document.getElementById("editContent").style.display="block";	
  document.getElementById("wikiViewingControls").style.display="none";
  document.getElementById("saveAndCloseButtons").style.display="none";

  document.getElementById("wikiEditingControls").style.display="block";

  if (contentUpdated) {
		document.getElementById("undoEditingOption").style.display="inline-block";
  }
  else { 
		document.getElementById("undoEditingOption").style.display="none";
  }

  var editor = xinha_editors.xinhaWiki;
  editor.setHTML(editor.inwardHtml(contentToHTML.toText(currentContent)));
  editor.focusEditor();
  editor.activateEditor();    

}
     
function doCancelEdits() {

// Switch from EDIT mode to VIEW mode. Do not update the content of the ViewerPanel or the ContentUpdated flag.

  try {
    setViewingMode(contentUpdatedFlag);
  }
  catch (e) {
    handleException('XFilesWiki.doCancelEdits',e,null);
  }
 
}

function doRevertToSaved() {

// Undo all changes
// Switch from EDIT mode to VIEW mode. Reset the content of the Viewer Panel. Reset the ContentUpdated flag.

  try {
    var viewer         = document.getElementById("viewContent");
    contentUpdatedFlag = "false";
    currentContent     = originalContent;
    viewer.innerHTML   = contentToHTML.toText(currentContent);
    setViewingMode(contentUpdatedFlag);
  }
  catch (e) {
    handleException('XFilesWiki.doRevertToSaved',e,null);
  }
   
}

function doSaveEdits() {

// Save changes
// Switch from EDIT mode to VIEW mode. Update the content of the Viewer Panel. Set the ContentUpdated flag.

  try {
    var editor               = xinha_editors.xinhaWiki;
    var viewer               = document.getElementById('viewContent');
  
    contentUpdatedFlag = true;
    currentContent = xinhaToDiv(editor);
  	viewer.innerHTML = contentToHTML.toText(currentContent);
    setViewingMode(contentUpdatedFlag);
    }
  catch (e) {
    handleException('XFilesWiki.doSaveEdits',e,null);
  }

}

function processUpdate(mgr, updatedContent, closeFormWhenFinished) {

  try {
    var soapResponse   = mgr.getSoapResponse('XFilesWiki.processUpdate');
    showInfoMessage("Update Complete.");     
    if (closeFormWhenFinished) {
      closeCurrentWindow();
    }
    contentUpdatedFlag  = false;
    originalContent = updatedContent;
   }
  catch (e) {
    handleException('XFilesWiki.processUpdate',e,null);
  }

}

function saveChanges(closeFormWhenFinished) {
    
  var schema  = "XFILES";
  var package = "XFILES_WIKI_SERVICES";
  var method =  "UPDATEWIKIPAGE";

  var newContent = new xmlDocument().parse('<wiki:XFilesWikiPage xmlns:wiki="http://xmlns.oracle.com/xdb/xfiles/wiki" xmlns:xhtml="http://www.w3.org/1999/xhtml"/>');
  newContent.getDocumentElement().appendChild(newContent.importNode(currentContent.getDocumentElement().cloneNode(true),true));

	var mgr = soapManager.getRequestManager(schema,package,method);	
	var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { processUpdate(mgr, newContent, closeFormWhenFinished)}};

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
	