
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

var xinha_init    = null;
                                                                              
var xinha_editors = null;
var xinha_config  = null;
var xinha_plugins = null;

var _editor_url  = "/XFILES/Frameworks/Xinha/";  // (preferably absolute) URL (including trailing slash) where Xinha is installed 
var _editor_lang = "en";                         // And the language we need to use in the editor.

function XinhaController (editorControl, htmlControl, viewerControls, editorControls, undoControls, saveControls) {

  var self = this;
  
  var originalContent;
  var savedContent;

  var contentLoaded    = false;
  var contentModified  = false;

  var editor;
  var dialogName          = null;
  var bootstrapDialog     = false;
  
  var editorContainer     = document.getElementById(editorControl);
  var htmlContainer       = document.getElementById(htmlControl);
   
  var viewerControlList = [];
  var editorControlList = [];
  var undoControlList   = [];
  var saveControlList   = [];
  
  var editorWidth
  var editorHeight
                   
  var contentToHTMLSource  = 
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xhtml="http://www.w3.org/1999/xhtml">' + '\n' +
  ' <xsl:output method="html"/>' + '\n' + 
  '	<xsl:template match="/">' + '\n' +
  '		<xsl:for-each select="xhtml:*/node()">' + '\n' +
  '			<xsl:copy-of select="."/>' + '\n' +
  '		</xsl:for-each>' + '\n' +
  '</xsl:template></xsl:stylesheet>';

  var contentToHTML = new xsltProcessor(new xmlDocument().parse(contentToHTMLSource),document);
    
  function getControlList(controls) {

    var controlList = [];
    if (controls != null) {
      if (( typeof controls === 'string' ) && (controls != "")) {
        controlList = [controls];
      }
      else if (Object.prototype.toString.call( controls ) === '[object Array]') {
    	  controlList = controls
    	}
      for (var i=0; i < controlList.length; i++) {
      	var control = document.getElementById(controlList[i]);
      	if (control != null) {
      	  controlList[i] = document.getElementById(controlList[i]);
      	}
      	else {
      		console.log('XinhaController.getControlList: Unable to find control "' + controlList[i] + '".');
      		controlList.splice(i,1);
      	}
      }
    }
    return controlList;
  }	  

		/*
		** var tmpDisplay  = editorContainer.style.display  
		** var tmpPosition = editorContainer.style.position 
		** var tmpLeft     = editorContainer.style.left         
  	** 
  	** editorContainer.style.display   = "block";
    ** editorContainer.style.position  = "absolute";
    ** editorContainer.style.left      = "-2000px";
    **
    */

    /*
    **
  	** editorContainer.style.display   = tmpDisplay  
    ** editorContainer.style.position  = tmpPosition 
    ** editorContainer.style.left      = tmpLeft     
    **
    */
    
  function fixEditorSize() {
  	
  	// Hack for the case where the editor and status bar have height / width of "0px"
  	
  	editor.sizeEditor();
    
    var xinhaIFrame = editor._iframe;
  	if (xinhaIFrame.style.width == "0px") {
  		xinhaIFrame.style.width = editorWidth;
    }
    
  	if (xinhaIFrame.style.height == "0px") {
  		xinhaIFrame.style.height = editorHeight;
    }
     
    var statusBar = xinhaIFrame.parentElement.parentElement.nextSibling.nextSibling.firstChild.firstChild;
    if (statusBar.style.width == "0px") {
    	statusBar.style.width = "100%";
    } 
    
  }  
      	
  function toggleControls(controlList,state) {
  	
  	for (var i=0; i < controlList.length; i++) {
   	  controlList[i].style.display = state; 	
    }
  }
  
  function getControlLists(viewerControls,editorControls,undoControls,saveControls) {
  
  	viewerControlList = getControlList(viewerControls);
  	editorControlList = getControlList(editorControls);
  	undoControlList   = getControlList(undoControls);
  	saveControlList   = getControlList(saveControls);
    
  }
  
  function loadXinhaEditor(editorName,editorWidth,editorHeight) {
  
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
        editorName
      ];
    
     
      /** STEP 2 ***************************************************************
      * Now, what are the plugins you will be using in the editors on this
      * page.  List all the plugins you will need, even if not all the editors
      * will use all the plugins.
      *
      * The list of plugins below is a good starting point
      * 
      *     xinha_plugins = xinha_plugins ? xinha_plugins :
      *     [
      *       'CharacterMap',
      *       'ContextMenu',
      *       'ListType',
      *       'SpellChecker',
      *       'Stylist',
      *       'SuperClean',
      *       'TableOperations'
      *     ];
      *     
      *,If you prefer a much simpler editor to start with then you can use 
      * the following :
      *
      * xinha_plugins = xinha_plugins ? xinha_plugins : [ ];
      *
      * which will load no extra plugins at all.
      ************************************************************************/
     
  		xinha_plugins = xinha_plugins ? xinha_plugins : [ ];
      
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
       // xinha_config.statusBar = false;
      
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
      
      xinha_editors[editorName].config.width  = editorWidth
      xinha_editors[editorName].config.height = editorHeight
    
      xinha_editors[editorName]._onGenerate = function() {
      }
      
      /** STEP 6 ***************************************************************
       * Finally we "start" the editors, this turns the textareas into
       * Xinha editors.
       ************************************************************************/
    
      Xinha.startEditors(xinha_editors);
    }            
  
  }

  this.loadXinha = function(editorName,width,height) {
     
    editorWidth = width;
    editorHeight = height;
     
 	  loadXinhaEditor(editorName,editorWidth,editorHeight);
 	  xinha_init();

 	  editor = xinha_editors[editorName];
 	}

	this.setDialogName = function(name) {
    dialogName = name;
    // var className = document.getElementById(name).className;
    // console.log("className = " + className);
    bootstrapDialog  = document.getElementById(name).className.match(/(?:^|\s)modal(?!\S)/);
    if (bootstrapDialog) {
      // Disable FullScreen when using a Bootstrap Modal Dialog.. It causes extreme wierdness.
      editor.config.hideSomeButtons(" popupeditor ")
      $('#' + name).on('shown.bs.modal', function () {
        self.startEditor();
      })
    }
  }
		
  this.setContent = function(content) {

    originalContent = content;
    savedContent = content;
  	htmlContainer.innerHTML =  contentToHTML.toText(content);
  	
  }
  
  function closePopupDialog(name) {
  	document.getElementById(name).style.display = "none";
  }
    
  function openPopupDialog(name) {
  	document.getElementById(name).style.display = "block";
  }

  this.hideEditor = function() {

    toggleControls(viewerControlList,"inline-block");

    if (dialogName != null) {
    	if (bootstrapDialog) {
			  closeModalDialog(dialogName);
			}
			else {
				closePopupDialog(dialogName);
		  }
		}
	  else {
    	htmlContainer.style.display = "inline-block";
    	editorContainer.style.display = "none";
      toggleControls(editorControlList,"none");
  	} 
		  	
    if (contentModified) {
      toggleControls(saveControlList,"inline-block");
    }
    else {
      toggleControls(saveControlList,"none");
    }    	
    
  }
  
  function loadContent(content) {

    editor.setHTML(editor.inwardHtml(contentToHTML.toText(content)));
    contentLoaded = true;
 
  }
  
  this.startEditor  = function () {
    editor.focusEditor();
    editor.activateEditor();      	
    if (!contentLoaded) {
      loadContent(originalContent);
    }
    fixEditorSize();
  }
  	
  this.showEditor = function() {
  
    toggleControls(viewerControlList,"none");
    toggleControls(saveControlList,"none");
 
    if (contentModified) {
    	toggleControls(undoControlList,"inline-block");
    }
    else { 
      toggleControls(undoControlList,"none");
    }

    toggleControls(editorControlList,"inline-block");

    if (dialogName != null) {
    	if (bootstrapDialog) {
      	openModalDialog(dialogName);
			}
			else {
				openPopupDialog(dialogName);
        self.startEditor();
		  }
    }	
    else {
    	htmlContainer.style.display = "none";
     	editorContainer.style.display = "block";
      self.startEditor();
    }
  }
  
  this.cancel = function() {

  // Undo any changes in this editing session
  // Switch from EDIT mode to VIEW mode. 
  // Reset the content of the editor. The content of the viewer panel and the ContentUpdated flag remain unchanged.

    try {
      this.hideEditor();
      editor.setHTML(editor.inwardHtml(contentToHTML.toText(savedContent)));          	
    }
    catch (e) {
      handleException('XinhaController.cancelEdit',e,null);
    }
  }

  this.undoChanges = function() {

  // Undo all changes made since the document was opened / saved to disk.
  // Switch from EDIT mode to VIEW mode. 
  // Reset the content of the editor, the content of Viewer Panel and the ContentUpdated flag

    try {
      contentModified = false;
    	this.hideEditor();
    	htmlContainer.innerHTML = contentToHTML.toText(originalContent);
      editor.setHTML(editor.inwardHtml(contentToHTML.toText(originalContent)));          	
    }
    catch (e) {
      handleException('XinhaController.undoChanges',e,null);
    }
   
  }

  this.saveChanges = function() {

  // Save changes made in this editing session
  // Switch from EDIT mode to VIEW mode. 
  // Update the HTML version and set the contentUpdated flag. The content of the editor remains unchanged.

    contentModified = true;
  	this.hideEditor();
    savedContent = xinhaToDiv(editor);
  	htmlContainer.innerHTML = contentToHTML.toText(savedContent);;
  } 
  
  this.getContent = function() {
  	
  	return savedContent;

  }

  function xinhaToDiv(editor) {
  
    // Assume the content of a xinhaDescriptionEditor.getHTML()is always valid XHTML Fragment can that be manageded as the child of an XHTML Body Element..
    // ? Need to replace &nbsp in XHTML ? then 
    var xinhaContent = editor.outwardHtml(editor.getHTML());
    xinhaContent = xinhaContent.replace( /\&nbsp/gi, "&#160" )
    xinhaContent = xinhaContent.replace( /class=" htmtableborders" style=" htmtableborders"/gi, "class=\" htmtableborders\" " )
    var xhtmlBody = new xmlDocument().parse("<div xmlns=\"http://www.w3.org/1999/xhtml\">" +  xinhaContent + "</div>");
    return xhtmlBody;
    
  }
  
  function textAreaToDiv(textArea) {
  
    // Assume the content of a xinhaDescriptionEditor.getHTML()is always valid XHTML Fragment can that be managed as the child of an XHTML Body Element..
    // ? Need to replace &nbsp in XHTML ?
    
    var xhtmlBody = new xmlDocument().parse("<div xmlns=\"http://www.w3.org/1999/xhtml\">" + textArea.innerHTML.replace( /\&nbsp/gi, "&#160" ) + "</div>");
    return xhtmlBody;
    
  } 
    
  getControlLists(viewerControls, editorControls, undoControls, saveControls);
   
}

