
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
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

  // Initialize currentDescription and currentTitle to the current title and description of the Image.

  sizing = resizeImageToForm();

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

 	xinhaDescription = new XinhaController("editImageDescription","viewImageDescription","viewingControls","editDescriptionControls","resetDescriptionOption","saveAndCloseButtons")
  xinhaDescription.loadXinha("xinhaDescriptionEditor","960px",(sizing[1]*0.8)+"px");
 	xinhaDescription.setDialogName("editDescriptionDialog");
  xinhaDescription.hideEditor();
  xinhaDescription.setContent(originalDescription);
    
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
	closeModalDialog("editTitleDialog");
}

function doResetEditTitle(evt) {
	closeModalDialog("editTitleDialog");
	currentTitle = originalTitle;
	showTitle();
	setButtonState();
} 

function doSaveEditTitle(evt) {
	closeModalDialog("editTitleDialog")
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
	openModalDialog("editTitleDialog");

}

function processUpdate(mgr,updatedTitle,updatedDescription,closeForm) {
	
	try {
    var soapResponse = mgr.getSoapResponse('EXIFViewer.processUpdate');
    showInfoMessage("Image Updated.");       
    if (closeForm) {
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

function saveChanges(closeForm) {

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
    newDescription.getDocumentElement().appendChild(newDescription.importNode(xinhaDescription.getContent().getDocumentElement().cloneNode(true),true));
    xinhaDescription.setContent(xinhaDescription.getContent());

    var schema  = "XDBEXT";
    var package = "METADATA_SERVICES";
    var method =  "UPDATEIMAGEMETADATA";
  
  	var mgr = soapManager.getRequestManager(schema,package,method);  	
  	var XHR = mgr.createPostRequest();
    XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processUpdate(mgr, currentTitle, currentDescription, closeForm) } };
  
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

