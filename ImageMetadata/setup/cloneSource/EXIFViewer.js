
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

var displayName 
var resid

var originalTitle
var currentTitle

var originalDescription
var currentDescription
var descriptionUpdated = false;
var imageMetadataNamespace = 'http://xmlns.oracle.com/xdb/metadata/ImageMetadata';

function resizeImageToForm() {
	
  var maxWidth    = document.getElementById("upperSpacer").clientWidth - 300;
  var maxHeight   = maxWidth * (9/16);

  var propsHeight = document.getElementById("propertyContainer").clientHeight;
  if (propsHeight < maxHeight) {
  	maxHeight = propsHeight;
  }
  
  if (maxHeight < 480) {
  	maxHeight = 480;
  }
  
  document.getElementById("editDescriptionContainer").style.width = maxWidth;
  document.getElementById("editDescriptionContainer").style.height = maxHeight;

  if (document.getElementById("imageWidth")) {
  	var imgWidth = document.getElementById("imageWidth").value;
    var imgHeight = document.getElementById("imageHeight").value;
	
    var widthRatio  = maxWidth  / imgWidth;
    var heightRatio = maxHeight / imgHeight;

    var img = document.getElementById("image");  
    
    if (heightRatio < widthRatio) {
 	    img.width = Math.round(imgWidth * heightRatio)
    }
    else {
	    img.width = Math.round(imgHeight * widthRatio)
    } 
  }
  
  return new Array (maxWidth, maxHeight);
 
}  
  
function onPageLoaded() {

  // Initialize currentDescription and currentTitle to the current title of the Image.

  displayName = resource.selectNodes("/res:Resource/res:DisplayName/text()",xfilesNamespaces).item(0).nodeValue;
  resid = resource.selectNodes("/res:Resource/xfiles:ResourceStatus/xfiles:Resid/text()",xfilesNamespaces).item(0).nodeValue;

  var nl = resource.selectNodes("/res:Resource/img:imageMetadata/img:Title/text()",xfilesNamespaces);
  if (nl.length > 0) {
    originalTitle = nl.item(0).nodeValue;
  }
  else {
  	originalTitle = "";
  }

  currentTitle = originalTitle;
  
  var nl = resource.selectNodes("/res:Resource/img:imageMetadata/img:Description/xhtml:div",xfilesNamespaces);
  if (nl.length > 0) {
    originalDescription = new xmlDocument();
    originalDescription.appendChild(originalDescription.importNode(nl.item(0).cloneNode(true),true));
  }
  else {
    originalDescription = new xmlDocument().parse("<div xmlns=\"http://www.w3.org/1999/xhtml\"/>");
  }

  currentDescription = originalDescription;
  var viewDescription = document.getElementById("viewDescription");
  viewDescription.innerHTML = contentToHTML.toText(currentDescription);
  
  setButtonState();
  sizing = resizeImageToForm();

  editorFrame = document.getElementById("editDescriptionDialog");
  editorFrame.style.display ="block";
  editorFrame.firstChild.firstChild.style.left = ((sizing[0] + 100) * -1) + "px";
  initXinhaEXIF(sizing[0],sizing[1]);
  xinha_init();
    
}
    
function initXinhaEXIF(width,height) {
                                                                              
  // This contains the names of textareas we will make into Xinha editors
  xinha_init = xinha_init ? xinha_init : function() {
  
    /** STEP 1 ***************************************************************
    * First, what are the plugins you will be using in the editors on this
    * page.  List all the plugins you will need, even if not all the editors
    * will use all the plugins.
    *
    * The list of plugins below is a good starting point, but if you prefer
    * a must simpler editor to start with then you can use the following 
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
      'SpellChecker',
      'Stylist',
      'SuperClean',
      'TableOperations'
    ];
  
    // THIS BIT OF JAVASCRIPT LOADS THE PLUGINS, NO TOUCHING  :)
    if(!Xinha.loadPlugins(xinha_plugins, xinha_init)) return;
  
    /** STEP 2 ***************************************************************
    * Now, what are the names of the textareas you will be turning into
    * editors?
    ************************************************************************/
  
    xinha_editors = xinha_editors ? xinha_editors :
    [
      'xinhaDescriptionEditor'
    ];
  
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
    *   xinha_editors['myTextArea'].registerPlugins(['Stylist','FullScreen']);
    *   xinha_editors['anotherOne'].registerPlugins(['CSS','SuperClean']);
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
  
    xinha_editors.xinhaDescriptionEditor.config.width  = (width - 20) + "px";
    xinha_editors.xinhaDescriptionEditor.config.height = (height - 60) + "px";
    
    xinha_editors.xinhaDescriptionEditor._onGenerate = function()
    { 
      editorFrame = document.getElementById("editDescriptionDialog");
      editorFrame.style.display = "none";
      editorFrame.firstChild.firstChild.style.left = "10px";
    }
    
    /** STEP 6 ***************************************************************
    * Finally we "start" the editors, this turns the textareas into
    * Xinha editors.
    ************************************************************************/
  
    Xinha.startEditors(xinha_editors);
  
  }

}

function showTitle() {

  if (currentTitle == "")	{
  	document.getElementById("imageTitle").innerHTML = displayName
  }
  else {
  	document.getElementById("imageTitle").innerHTML = currentTitle
  }
  	
}

function setButtonState() {
	
	if (titleUpdated() || descriptionUpdated) {
  	document.getElementById("saveAndCloseButtons").style.display = "inline-block";
  }
  else {
  	document.getElementById("saveAndCloseButtons").style.display = "none";
  }
		
}

function titleUpdated() {
  return currentTitle != originalTitle;
} 

function doCancelEditTitle(evt) {
	closePopupDialog();
}

function doResetEditTitle(evt) {
	closePopupDialog();
	currentTitle = originalTitle;
	showTitle();
	setButtonState();
} 

function doSaveEditTitle(evt) {
	closePopupDialog()
	currentTitle = document.getElementById("editImageTitle").value;  		
	showTitle();
	setButtonState();
}

function doOpenEditTitle(evt) {

  if (titleUpdated()) {
  	document.getElementById("resetTitleOption").style.display = "inline-block";
  }
  else {
  	document.getElementById("resetTitleOption").style.display = "none";
  }

	document.getElementById("editImageTitle").value = currentTitle;  		
	openPopupDialog(evt,"editTitleDialog");

}

function doCancelEditDescription(evt) {

	closePopupDialog();
	setButtonState();
}

function doResetEditDescription(evt) {

  descriptionUpdated = false;
  currentDescription = originalDescription;  
  veiwer = document.getElementById("viewDescription");
  viewer.innerHTML = contentToHTML.toText(currentDescription);  
	closePopupDialog();
	setButtonState();

} 

function doSaveEditDescription(evt) {

  descriptionUpdated = true;
	var editor = xinha_editors.xinhaDescriptionEditor;	
  var viewer = document.getElementById("viewDescription");

  currentDescription = xinhaToDiv(editor);
	viewer.innerHTML = contentToHTML.toText(currentDescription);
	closePopupDialog()
	setButtonState();
}

function doOpenEditDescription(evt) {

  if (descriptionUpdated) {
  	document.getElementById("resetDescriptionOption").style.display = "inline-block";
  }
  else {
  	document.getElementById("resetDescriptionOption").style.display = "none";
  }

	openPopupDialog(evt,"editDescriptionDialog");

	var editor = xinha_editors.xinhaDescriptionEditor;	
	editor.setHTML(editor.inwardHtml(contentToHTML.toText(currentDescription)));
  editor.activateEditor();    
  editor.focusEditor();

}

function processUpdate(mgr,updatedTitle,updatedDescription,closeFormWhenFinished) {
	
	try {
    var soapResponse = mgr.getSoapResponse('EXIFViewer.processUpdate');
    showInfoMessage("Image Updated.");       
    if (closeFormWhenFinished) {
      closeCurrentWindow();
    }

    descriptionUpdated  = false;
    originalTitle       = updatedTitle;
    originalDescription = updatedDescription;
    setButtonState();
  }
  catch (e) {
    handleException('EXIFViewer.processUpdate',e,resourceURL);
  }

}

function saveChanges(closeFormWhenFinished) {

  try {
    var newTitle = new xmlDocument().parse('<img:Title xmlns:img="' + imageMetadataNamespace + '"/>');
    var text;
    if (titleUpdated()) {
    	text = newTitle.createTextNode(currentTitle);
    }
    else {
    	text = newTitle.createTextNode(originalTitle);
    }
    newTitle.getDocumentElement().appendChild(text);
    
	  var newDescription = new xmlDocument().parse('<img:Description xmlns:img="' + imageMetadataNamespace + '" xmlns:xhtml="http://www.w3.org/1999/xhtml"/>');
    newDescription.getDocumentElement().appendChild(newDescription.importNode(currentDescription.getDocumentElement().cloneNode(true),true));

    var schema      = "%USER%";
    var packageName = "METADATA_SERVICES";
    var method =  "UPDATEIMAGEMETADATA";
  
  	var mgr = soapManager.getRequestManager(schema,packageName,method);  	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processUpdate(mgr, currentTitle, currentDescription, closeFormWhenFinished) } };
  
  	var parameters = new Object;
  	parameters["P_RESID-VARCHAR2-IN"] = resid
  
  	var xparameters = new Object;
  	xparameters["P_TITLE-XMLTYPE-IN"] = newTitle;
  	xparameters["P_DESCRIPTION-XMLTYPE-IN"] = newDescription;
  		
    mgr.sendSoapRequest(parameters,xparameters); 
  }
  catch (e) {
    handleException('EXIFViewer.saveChanges',e,resourceURL);
  }

}

function doSave() {
  saveChanges(false);
}

function doSaveAndClose() {
  saveChanges(true);
}
