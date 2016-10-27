
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

const nodeTypeElement   =  1;
const nodeTypeAttribute =  2;
const nodeTypeText      =  3;
const nodeTypeCData     =  4;
const nodeTypeEntityRef =  5;
const nodeTypeEntity    =  6;
const nodeTypePI        =  7;
const nodeTypeComment   =  8;
const nodeTypeDocument  =  9;
const nodeTypeDTD       = 10;
const nodeTypeDocFrag   = 11;
const nodeTypeNotation  = 12;

function namespaceManager(namespaces) {

  const className = "XMLDocumentObject.namespaceManager";

  var ns = namespaces
  var nsList = rebuildNamespaceList();
  
  function rebuildNamespaceList() {
    var nsList = ""
    for (var x in ns) {
     nsList += "xmlns:" + x + "=\"" + ns[x] + "\" ";       
    }
    return nsList;
  }  
  
  this.resolveNamespace = function (prefix) { return ns[prefix] || null };
  this.getNamespaces = function () { return nsList };
  this.redefinePrefix = function (prefix, namespace) { ns[prefix] = namespace; nsList = rebuildNamespaceList(); }
  this.getClassName = function() { return className};
}

function xsltProcessor( xsl, target) {

  var   self = this;
  const className = "XMLDocumentObject.xsltProcessor";
 

  var processor;
  var engine;
  var target;
  
  var stylesheet;
  
  try {
     self.target = target;
     self.stylesheet = xsl;
     if (useMSXML) {
      self.processor = new ActiveXObject(xslImplementation);
      self.processor.stylesheet = xsl.baseDocument;
      self.engine = self.processor.createProcessor();
    }
    else {
      if (document.implementation  && document.implementation.createDocument)  {
        self.processor = new XSLTProcessor();
        self.processor.importStylesheet(xsl.baseDocument); 
      }
      else {
        var error = new xfilesException(className,9, self.stylesheet.sourceURL, null);
        error.setDescription('Browser does not support an XSLT Processor');
        throw error;
      }
    }
  }
  catch (e) {  
    var error = new xfilesException(className,9, self.stylesheet.sourceURL, e);
    error.setDescription('Error Instantiating XSLT Processor');
    throw error;
  }
    
  function gecko2xml(node) {
    try {
    	/*
    	**
    	** XSLT Transformation in Chrome seems to require 'document' rather than a child of document as the 2nd argument
    	**
    	*/ 
      // return self.processor.transformToFragment(node,self.target);
      return self.processor.transformToFragment(node,document);
    }
    catch (e) {  
      var error = new xfilesException(className + '.gecko2xml',9, self.stylesheet.sourceURL, e);
      error.setDescription('[GECKO]Error in processor.transformToFragment().');
      throw error;
    }
  }
  
  function gecko2document(node) {
    try {
    	var transformationResult = self.processor.transformToDocument(node);
      if (transformationResult == null) {
	      var error = new xfilesException(className + '.gecko2document',9, self.stylesheet.sourceURL, null);
  	    error.setDescription('Transformation resulted in empty document.');
  	    error.setXML(self.stylesheet);
    	  throw error;
      }
      return transformationResult;
    }
    catch (e) {  
      var error = new xfilesException(className + '.gecko2document',9, self.stylesheet.sourceURL, e);
      error.setDescription('[GECKO]Error in processor.transformToDocument().');
      throw error;
    }
  }

  function gecko2text(node,xsl) {
    return new XMLSerializer().serializeToString(gecko2xml(node));
  }
  
  function microsoft2xml(node) {
      var docFragment = target.createDocumentFragment();
      node.transformNodeToObject(xsl.baseDocument, docFragment);
      return docFragment;
  }
  
  function microsoft2text(node) {
    self.engine.input = node;
    self.engine.transform();
    return self.engine.output;
  }
  
  this.nodeToXML = function(node) {
    if (useMSXML) {
      return microsoft2xml(node) 
    }
    else {
      return gecko2xml(node);
    }
  }
  
  this.toXML = function(xml) {
  	var result = self.nodeToXML(xml.baseDocument);
  	if (result == null) {
  		/*
  		**
  		** Remote transform not an option at this point.
  		**
  		*/
      
      // return remoteTransform(xml);
      
      var error = new xfilesException('xsltProcessor.toXML',8, self.stylesheet.sourceURL, null);
      error.setDescription('Your browser does not appear to implement client-side XSL Transformation correctly. For Chrome or Safari see "http://code.google.com/p/chromium/issues/detail?id=8441"');
      throw error;
    }
  	return result;
  }
   
  this.nodeToText = function(node) {
    if (useMSXML) {
      return microsoft2text(node);
    }
    else {
      return gecko2text(node);
    }
  }
  
  this.toText = function(xml) {
  	return self.nodeToText(xml.baseDocument);
  }

  this.nodeToDocument = function(node) {
    if (useMSXML) {
  		return new xmlDocument().parse(microsoft2text(node));
  	}
  	else {
  		return new xmlDocument(gecko2document(node))
    }
  }

  this.toDocument = function(xml) {
  	return self.nodeToDocument(xml.baseDocument);
  }

  /*
  **
  ** New Methods for Transformation
  **
  */
       
  this.transformToHTML = function(node) {
  	
  /*
  **
  ** Generate HTML from XML. Return as Native DOM object which can be appended to HTML Page.
  **
  */
   
    try {
      if (useMSXML) {
        
        /*
        **
        ** Cannot use this method as it doesn't seem to allow load Java Script functions to be loaded correctly.
        ** Return text that can be applied to innerHTML property of target object
        **
        */

        // var docFragment = document.createDocumentFragment();
        // node.transformNodeToObject(xsl.baseDocument, docFragment);
        // return docFragment;    	

				self.engine.input = node.baseDocument;
        self.engine.transform();
        return self.engine.output;

  	  }
  	  else {
  	  	var result
  	  	result = this.processor.transformToFragment(node.baseDocument,document);
  		  if (result == null) {
          // Transformation Failed - Chrome Transform slipped through the cracks ?
          var error = new xfilesException(className + '.transformToHTML',17, self.stylesheet.sourceURL, null);
          error.setDescription('Browser XSL Transformation Failure');
          throw error;     			 
			  }
        return result;			
      }
    }
    catch (e) {
      var error = new xfilesException(className + '.transformToHTML',9, self.stylesheet.sourceURL, e);
      throw error;   
    }
	}  	
  
  this.getClassName = function() { return className};
}

function xmlNodeList(nl) {

  const  className = "XMLDocumentObject.xmlNodeList"
  var innerNodeList;
  var length;
  
  if (useMSXML) {
  	innerNodeList = nl
  }
  else {
    innerNodeList = new Array();
    var node = nl.iterateNext(); 
    while (node) {
       innerNodeList.push(node);
       node = nl.iterateNext();
    }
  }

  this.length = innerNodeList.length;
  this.item = function (index) { return innerNodeList[index]};
  
  this.getClassName = function() { return className};

}

function xmlElement(element) {
  
  var   self = this;
  const className = "XMLDocumentObject.xmlElement";

  var baseElement;

  this.baseElement = element;
  
  this.selectNodes = function(xpath, nsResolver) {
    if (useMSXML) {
      self.baseElement.ownerDocument.setProperty("SelectionNamespaces", nsResolver.getNamespaces());
      return new xmlNodeList(self.baseElement.selectNodes(xpath));
    }
    else {
      return new xmlNodeList(self.baseElement.ownerDocument.evaluate(xpath ,self.baseElement, nsResolver.resolveNamespace ,XPathResult.ORDERED_NODE_ITERATOR_TYPE , null));
    }
  }

  this.serialize = function () {
     
    if (useMSXML) {
        return self.baseElement.xml;
    }
    else {
      return new XMLSerializer().serializeToString(self.baseElement);
    }
  }
  
  this.getAttribute = function(attrName) {
    return self.baseElement.getAttribute(attrName);
  }

  this.getTextValue = function () {
  	if (useMSXML) {
  	  return self.baseElement.text;
  	}
  	else {
  	  return self.baseElement.textContent;
    }
  }

  this.getElementsByTagName = function (elementName) {
  	return self.baseElement.getElementsByTagName(elementName);
  } 

  this.getClassName = function() { return className};
}

function xmlDocument(doc,docType,docNamespaces) {

  var   self = this;
  const className = "XMLDocumentObject.xmlDocument";

  const MicrosoftDOM  = 1; // Microsoft FreeThreadedDOM ActiveX object
  const NativeDOM     = 2; // Firefox Native DOM
  const ResponseXML   = 3; // responseXML from XMLHTTP object
  
  const sourceLoad = 1 
  const sourceParse = 2
  const sourceConstructor = 3

  var baseDocument;
  var documentType;
  var documentSource;
  
  var innerNode = null;
  var documentNamespaces;
  var sourceURL;
  var onReadyStateChange;
  
  var resourcePrefixList = {
        'res'    : 'http://xmlns.oracle.com/xdb/XDBResource.xsd',
        'xfiles' : 'http://xmlns.oracle.com/xdb/xfiles'
      };

  var resourceNamespaces = new namespaceManager(resourcePrefixList);
    
  function createNewDocument() {

    self.documentSource = sourceConstructor;

    try {
      //code for Internet Explorer
      if (useMSXML) {
        self.baseDocument = new ActiveXObject(domImplementation); 
        self.documentType = MicrosoftDOM;
      }
      // code for gecko, Firefox, etc.
      else {
        if (document.implementation && document.implementation.createDocument) {
          self.baseDocument  = document.implementation.createDocument("","",null); 
          self.baseDocument.preserveWhiteSpace=false;
          self.documentType = NativeDOM;
        }
        else {
          var error = new xfilesException('xmlDocumentObject.newxmlDocument.createNewDocument',8, null, null);
          error.setDescription('Browser cannot instantiate an XML Document object');
          throw error;
        }  
      }
    }
    catch (e) {  
      var error = new xfilesException(className + '.createNewDocument',9, null, e);
      error.setDescription('Error Instantiating XML Document');
      throw error;
    }
  }
   
  if (doc) {
    if (!useMSXML) {
    	stripInsignificantWhitespace(doc.documentElement);
    }
    self.baseDocument        = doc;
    self.documentType        = docType;
    self.documentNamespaces  = docNamespaces;
    self.documentSource      = this.sourceConstructor;
  }
  else {
    createNewDocument();
  }

  function checkParsing(module, xml) {

    if (xml == null) {
      var error = new xfilesException(self.getClassName() || '.checkParsing',4, self.sourceURL, null);
      error.setDescription('XML is null');
      throw error;
    }

    if (useMSXML) {
      if (xml.parseError.errorCode != 0) {
      	var error
      	if (xml.parseError.errorCode == -2147024891) {
      		// Access Denied
          error = new xfilesException(module,1,self.sourceURL, null);
        }
        else {
        	// Other Parsing Errors
          error = new xfilesException(module,2,self.sourceURL, null);
        }
        error.setDescription("[MSXML]XML Parsing error : " + xml.parseError.reason);
        error.setNumber(xml.parseError.errorCode);
        throw error;          
      }
    }
    else {
      if (xml.documentElement) {
        var root = xml.documentElement;
        if (root.nodeName == 'parsererror')  {
          var error = new xfilesException(self.getClassName() || '.checkParsing',2,self.sourceURL, null);
	        error.setDescription("[GECKO]XML Parsing Error");
          error.setXML(new xmlDocument(xml));
          throw error;
        }
      }
      else {
        var error = new xfilesException(self.getClassName() || '.checkParsing',4, self.sourceURL, null);
        error.setDescription('Unable to load Document');
        throw error;
      }
    }   
  }
  
  function msftConvertImplementation(incorrectVersion) {
     try {
       correctedVersion = new ActiveXObject(domImplementation); 
       correctedVersion.loadXML(incorrectVersion.xml);
       checkParsing('xmlDocument.msftConvertImplementation',correctedVersion);
       return correctedVersion.documentElement;
     }
     catch (e) {
       var error = new xfilesException(className + '.msftConvertImplementation',8, self.sourceURL, e);
       throw error;
     }
  }
  
  function stripInsignificantWhitespace(element) {
  	
  	if ((typeof element == "undefined") || (element == null)) {
  		if ((typeof self.baseDocument.documentElement == "undefined") || (self.baseDocument.documentElement == null)) {
  			return
  		}
  		else {
  		  element = baseDocument.documentElement;
  		}
    }
  
    // If XML:SPACE is preserve assume we are doing whitespace preservation for the entire branch. 
    //
    // TODO : How do we do check for the correct namespace in MSXML ("http://www.w3.org/XML/1998/namespace")
  
    if (element.getAttribute("space") == "preserve") {
  	  return;
    }
  
    var nl = element.childNodes;
    
    // Check to see if the current node has a text node containng significant text (eg not just whitespace).
    // If it does we assume mixed text or simple content and we're done with this branch.
    
    for (var i=0; i<nl.length;i++) {
  	  var node = nl.item(i);
    	if ((node.nodeType == nodeTypeText) && (!node.isElementContentWhitespace)) {
    		return
      }
    }

    // Strip all insignificant whitespace from the node and check any child elements.

    var node = element.firstChild;
    while (node) {
    	if ((node.nodeType == nodeTypeText) && (node.isElementContentWhitespace)) {
    		var nextNode = node.nextSibling
  	 		element.removeChild(node);
  	 		node = nextNode;
   			continue;
  	 	}
    	if (node.nodeType == nodeTypeElement) {
    		stripInsignificantWhitespace(node);
    		node = node.nextSibling;
        continue;
      }
      node = node.nextSibling;
    }

  }
  
  function getProcessorFromCache(url) {
    var processor = xslProcessorCache[url];
   	return processor;
  }
  
  function getXSLProcessor(stylesheet,target) {

  	var processor;
  	var xsl;
  	var url;

    try {
  		if (typeof stylesheet == "object") {
    	  if (stylesheet.getClassName) {
   		    if (stylesheet.getClassName() == "XMLDocumentObject.xsltProcessor") {
        	  processor = stylesheet;
          }
          else {
         	  if (stylesheet.getClassName() == "XMLDocumentObject.xmlDocument") {
         	  	xsl = stylesheet;
         	  	url = xsl.sourceURL;
         	  	processor = getProcessorFromCache(url,target);
  	        }
  	        else {
              var error = new xfilesException(self.getClassName() || '.getXSLProcessor',8, self.sourceURL, null);
              error.setDescription('Cannot instantiate XSL Processor from ' + stylesheet.getClassName());
              throw error;
            }
  	      }
  	    }
  	    else {  	  	
          var error = new xfilesException(self.getClassName() || '.getXSLProcessor',8, self.sourceURL, null);
          error.setDescription('Cannot instantiate XSL Processor from ' + typeof stylesheet);
          throw error;
  			}
  		}			
  		else {
  			if (typeof stylesheet == "string") {
  				url = stylesheet;
     	  	processor = getProcessorFromCache(stylesheet,target);
     	  }
     	  if (processor == null) {
     	  	xsl = loadXSLDocument(stylesheet);
     	 	}
     	}
      if (processor == null) {
    		processor = new xsltProcessor(xsl,target);
  	  	xslProcessorCache[url] = processor;
   	  }
	  
	    return processor;		
	  }
    catch (e)	{
      var error = new xfilesException(self.getClassName() || '.getXSLProcessor',8, self.sourceURL, e);
      error.setDescription('Cannot instantiate XSL Processor from ' + typeof xsl);
      throw error;
    }
  	
  }
  
  this.isContent = function () {
  	return (self.documentSource == self.sourceLoad);
  }
  
  this.isCached = function() {
    return (self.selectNodes("/res:Resource/xfiles:xfilesParameters/xfiles:cacheGUID",resourceNamespaces).length == 1)
  }
  
  this.getGUID = function() {
    return self.selectNodes("/res:Resource/xfiles:xfilesParameters/xfiles:cacheGUID",resourceNamespaces).item(0).firstChild.nodeValue;
  }
  
  this.setNamespaceManager = function ( documentNamespaces ) {
    self.documentNamespaces = documentNamespaces;
  }
    
  this.serialize = function (node) {
     
    if (node) {
      if (useMSXML) {
        return node.xml;
      }
      else {
        return new XMLSerializer().serializeToString(node);
      }
    }
    else {
      if (self.baseDocument) {
        return self.serialize(self.baseDocument)
      }
      else {
        var error = new xfilesException(className + '.serialize',8, self.sourceURL, null);
        error.setDescription('Cannont Serialize emtpy Document');
        throw error;
      }
    }
  }

  this.checkParsing = function () {
  	checkParsing(className + ".load",self.baseDocument);
  }

  function xhrLoad(url, asynchronousMode, cached) {
  	
  	// Implement XML.load function for Chrome / Safari ?
  	
	  var XHR = soapManager.createGetRequest(url,asynchronousMode);
	  
	  if (!cached) {
		  XHR.setRequestHeader("Cache-Control", "no-cache");
      XHR.setRequestHeader("Pragma", "no-cache");
      XHR.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 1970 00:00:00 GMT");
    }
	 
	  XHR.mozBackgroundRequest = true;
	  if (asynchronousMode) {
	    XHR.onreadystatechange = function () { 
	    	if (XHR.readyState==4) {
    		  var onLoadFunction = self.baseDocument.onload;
    		  if (XHR.status != 200) {
    		  	self.baseDocument = document.implementation.createDocument("","",null); 
    		  	var parserError = self.baseDocument.createElement('parsererror');
    		  	self.baseDocument.appendChild(parserError);
    		  	var httpStatus = self.baseDocument.createElement('httpStatus');
    		  	httpStatus.appendChild(self.baseDocument.createTextNode(XHR.status));
    		  	var httpStatusText = self.baseDocument.createElement('httpStatus');
    		  	httpStatusText.appendChild(self.baseDocument.createTextNode(XHR.statusText));
    		  	var responseText = self.baseDocument.createElement("responseText")
    		  	responseText.appendChild(self.baseDocument.createCDATASection(XHR.responseText));
    		  	parserError.appendChild(httpStatus);
    		  	parserError.appendChild(httpStatusText);
    		  	parserError.appendChild(responseText);
    		  }
    		  else {
        		if ((XHR.responseXML == null) && (XHR.responseText == "")) {
        		  if (cached) {
    					  xhrLoad(url,asynchronousMode,false)
    					  return
    					}
    					else {
        	      var error = new xfilesException(className + '.xhrLoad[ASYNC]',7, url, null);
                error.setDescription('[CHROME]Empty Content : HTTP Status = ' + XHR.status + " (" + XHR.statusText + ")");
                throw error;
    				  }
    				}
    				else {
          		if (XHR.responseXML != null) {
          		  self.baseDocument = XHR.responseXML; 
          		}
        	  	else {
        		    self.baseDocument = new DOMParser().parseFromString(XHR.responseText,"text/xml");
        		  }
        		}
            		if ((XHR.responseXML == null) && (XHR.responseText == "") && (cached)) {
      	      xhrLoad(url, asynchronousMode, false);
	          }
 	    		  if (XHR.responseXML != null) {
 	    		    self.baseDocument = XHR.responseXML; 
 	    		  }
      		  else {
      		 	  self.baseDocument = new DOMParser().parseFromString(XHR.responseText,"text/xml");
      		  }
    	  	}
  	  	  onLoadFunction(); 
	    	}
	    };
	  }
	  
    XHR.send(null);
    
    if (!asynchronousMode) {
    	if (XHR.status == 200) {
    		if ((XHR.responseXML == null) && (XHR.responseText == "")) {
    		  if (cached) {
					  xhrLoad(url,asynchronousMode,false)
					  return
					}
					else {
    	      var error = new xfilesException(className + '.xhrLoad[SYNC]',7, url, null);
            error.setDescription('[CHROME]Empty Content : HTTP Status = ' + XHR.status + " (" + XHR.statusText + ")");
            throw error;
				  }
				}
				else {
      		if (XHR.responseXML != null) {
      		  self.baseDocument = XHR.responseXML; 
      		}
    	  	else {
    		    self.baseDocument = new DOMParser().parseFromString(XHR.responseText,"text/xml");
    		  }
    		}
      }
      else {
	      var error = new xfilesException(className + '.xhrLoad[SYNC]',7, url, null);
        error.setDescription('[CHROME]Error Loading Document : HTTP Status = ' + XHR.status + " (" + XHR.statusText + ")");
        throw error;
      }
    }
    
    return true;
    
  }

  this.load = function(url, mode) {

    self.sourceURL = url;
    self.documentType = sourceLoad;

    try {
      
      var asynchronousMode = false;
      if (typeof mode != "undefined") {
        asynchronousMode = mode;
      }

      self.baseDocument.async = asynchronousMode;
      self.baseDocument.resolveExternals = resolveExternals;   
      self.baseDocument.validateOnParse = false;
      
      if (useMSXML) {
        self.baseDocument.setProperty("AllowDocumentFunction",true);
      }
      
      // Beware Mozilla load() implementation will prompt for user/passord if unauthorized.
      
      // Check for Webkit browsers not supporting load...
      
      var result;
      
      if (useMSXML) {
      	try {
          result = self.baseDocument.load(url);
        }
        catch (e) {
    	    var error = new xfilesException(className + '.load',7, url, e);
	        error.setDescription('[MSXML]Error Loading Document via XMLDOM.load()');
  	      throw error;
  	    }
      }
      else {
        if (self.baseDocument.load) {
        	try {
            result = self.baseDocument.load(url);
          }
          catch (e) {
      	    var error = new xfilesException(className + '.load',7, url, e);
	          error.setDescription('[GECKO]Error Loading Document via XMLDOM.load()');
    	      throw error;
    	    }
        }
        else {
        	try {
            result = xhrLoad(url, asynchronousMode, false);
          }
          catch (e) {
    	      var error = new xfilesException(className + '.load',7, url, e);
            error.setDescription('[CHROME]Error Loading Document via XMLHTTPRequest()');
  	        throw error;
    	    }
        }
      }
      
      if (result) {
        if (!asynchronousMode) {
  		    if (!useMSXML) {
    	      stripInsignificantWhitespace(self.baseDocument.documentElement);
      	  }
        	checkParsing(className + '.load[SYNC]',self.baseDocument);
        }
        return self;
      }
      else {
      	var parseError = null;
        if (useMSXML) {
          parseError = new xfilesException(className + '.load',7, url, null)
          parseError.setDescription = '[MSXML]:parseError (' + self.baseDocument.parseError.reason + ')';
          parseError.setNumber = self.baseDocument.parseError.errorCode
        }
	      var error = new xfilesException(className + '.load',7, url, parseError);
  	    error.setDescription('Error Loading Document');
    	  throw error;
      }
      
    }
    catch (e) {
      var error = new xfilesException(className + '.load',7, url, e);
      /* 
      ** if (useMSXML) {
      **   parseError.setDescription('[MSXML]:parseError (' + self.baseDocument.parseError.reason + ')');
      **   parseError.setNumber(self.baseDocument.parseError.errorCode)
      ** }
      ** else {
      **   error.setDescription('Error Loading Document');
      ** }
      */
      throw error;
    }

  }

  this.setOnLoad = function ( onLoadFunction ) {
  
    if (useMSXML) {
      self.baseDocument.onreadystatechange = function () { if (self.baseDocument.readyState==4) { onLoadFunction() }} ;
    }
    else {
      self.baseDocument.onload = function () { onLoadFunction(); };
    }
  }
  
  this.setOnReadyStateChange = function ( onReadyStateChangeFunction ) {
  
    if (useMSXML) {
      self.baseDocument.onreadystatechange = onReadyStateChangeFunction;
    }
    else {
      var error = new xfilesException(className + '.setOnReadyStateChange',8, self.sourceURL, null);
      error.setDescription("[GECKO]onReadyStateFunction not implemented. Use onLoad() instead");
      throw error
    }
  }

  this.getReadyState = function () {

    if (useMSXML) {
      return self.baseDocument.readyState;
    }
    else {
      return 4;
    }
  }
  
  this.parse = function(xmlContent) {

    self.documentSource = sourceParse
    self.sourceURL = 'text/xml';
    
    try {
      if (useMSXML) {
        self.baseDocument.async = false;
        self.baseDocument.loadXML(xmlContent);
        self.documentType = MicrosoftDOM
      }
      else {
        var oParser = new DOMParser();
        self.baseDocument = oParser.parseFromString(xmlContent,"text/xml");
        self.documentType = NativeDOM;
        stripInsignificantWhitespace(self.baseDocument.documentElement);
      }
      checkParsing(className + '.parse',self.baseDocument);
    }
    catch (e) {  
      var error = new xfilesException(className + '.parse',8, self.sourceURL, e);
      error.setDescription("Parsing Error");
      error.setContent(xmlContent);
      throw error
    }
    return this;
  }
  
  this.getStatus = function () {
    return self.baseDocument.parseError.errorCode;
  }

  this.save = function (URL) {
    XHR = getXMLHTTPRequest();
    targetURL = URL.replace(/\\/g,"/");
    // alert(URL)
    XHR.open ("PUT", URL, false);                                 
    XHR.send(self.baseDocument);
    showInfoMessage('Content saved to ' + URL);
  }

  this.importNode = function ( node, deep ) {
    try {
      return self.baseDocument.importNode(node,deep);
    }
    catch (e) {
      if (useMSXML) {
        if (e.number == -2147467259) {
          // Print and Parse to avoid MSFT incompatible MSXML implementations
          return self.baseDocument.importNode(msftConvertImplementation(node),deep);
        }
        else {
          var error = new xfilesException(className + '.importNode',8, self.sourceURL, e);
          error.setDescription("[MSXML]Import Node Error");
          error.setXML(node);
          throw error;
        }
      } 
      else {
        var error = new xfilesException(className + '.importNode',8, self.sourceURL, e);
        error.setDescription("[GECKO]Import Node Error");
        error.setXML(node);
        throw error;
      }
    }
  }
  
  this.appendChild = function ( node ) {
    try {
      return self.baseDocument.appendChild ( node );
    }
    catch (e) {
      var error;
      if (useMSXML) {
        error = new xfilesException(className + '.appendChild',8, self.sourceURL, e);
        error.setDescription("[MSXML]Append Child Error");
        error.setXML(node);
      }
      else {
        error = new xfilesException(className + '.appendNode',8, self.sourceURL, e);
        if (e.name == 'NS_ERROR_DOM_HIERARCHY_REQUEST_ERR') {
          error.setDescription("[GECKO]NS_ERROR_DOM_HIERARCHY_REQUEST_ERR : Cannot append instance of " + node + "[" + node.nodeName + "] to " + self.baseDocument + "[" + self.baseDocument.nodeName + "].");
        }
        else {
	        error.setDescription("[MSXML]Append Child Error");
	      }
      }
      throw error;   
    }
  }

  this.setAttribute = function (name, value, namespace ) {
    if (typeof namespace == "undefined") {
      self.baseDocument.setAttribute(name, value) ;
    }
  }

  this.getAttribute = function (name, namespace ) {
    if (typeof namespace == "undefined") {
      return self.baseDocument.getAttribute(value) ;
    }
  }
  
  this.createNode = function ( nodeType, name, namespace) {
    if (useMSXML) {
      return self.baseDocument.createNode( nodeType, name, namespace);
    }
    else {
      if (nodeType == nodeTypeElement) { // Element 
        if (namespace) {
          return self.baseDocument.createElementNS(namespace,name);
        }
        else {
          return self.baseDocument.createElement(name);
        }
      }
      if (nodeType == nodeTypeAttribute) { // Attribute 
        if (namespace) {
          return self.baseDocument.createAttributeNS(namespace,name);
        }
        else {
          return self.baseDocument.createAttribute(name);
        }
      }

    if (nodeType == nodeTypeText) { // Text 
        return self.baseDocument.createTextNode(name);
      }

    if (nodeType == nodeTypeAttribute) { // Attribute 
        if (namespace) {
          return self.baseDocument.createAttributeNS(namespace,name);
        }
        else {
          return self.baseDocument.createAttribute(name);
        }
      }
      var error = new xfilesException(className + '.createNode',8, self.sourceURL, null);
      error.setDescription("[GECKO]CreateNode for nodeType " + nodeType + " not (yet) implemented.");
      throw error;
    }
  }

  this.createElement = function (name, namespace) {
    return self.createNode(nodeTypeElement, name, namespace);
  }
  
  this.createAttribute = function (name, namespace) {
    return self.createNode(nodeTypeAttribute, name, namespace);
  }

  this.createTextNode = function (data) {
    return self.baseDocument.createTextNode(data) ;
  }

  this.createCDATASection = function (data) {
    return self.baseDocument.createCDATASection(data) ;
  }

  this.createDocumentFragment = function() {
  	return self.baseDocument.createDocumentFragment();
  }
 
  this.selectNodes = function (xpath, namespaces, node) {

    var nsResolver = namespaces;
    if (!nsResolver) {
      nsResolver = self.documentNamespaces;
    }

    if (!node) {
      node = self.baseDocument;
    }
    
    // console.log(self.serialize(node));
    // console.log(self.documentNamespaces.getNamespaces());
    // console.log(xpath);

    if (useMSXML) {
      if (node.ownerDocument) {
        node.ownerDocument.setProperty("SelectionNamespaces", nsResolver.getNamespaces());
      }
      else {
        node.setProperty("SelectionNamespaces", nsResolver.getNamespaces());
      }
      // alert(node.selectNodes(xpath).length);
      return node.selectNodes(xpath);
    }
    else {
    	var xpathResult = null;
      if (node.ownerDocument) {
        xpathResult = node.ownerDocument.evaluate(xpath ,node, nsResolver.resolveNamespace ,XPathResult.ORDERED_NODE_ITERATOR_TYPE , null);
      }
      else {
        xpathResult = node.evaluate(xpath ,node, nsResolver.resolveNamespace ,XPathResult.ORDERED_NODE_ITERATOR_TYPE , null);
      }    
      return new xmlNodeList(xpathResult);
    }
  }     
  
  this.getDocumentElement = function () {
    return self.baseDocument.documentElement;
  }

  this.getFirstChild = function () {
  	return self.baseDocument.firstChild;
  }
  
  this.transformToNode = function ( xsl, target ) {

  	/*
  	**
  	** Target should be document when generating HTML and the target XML document when generating XML
  	**
  	*/ 

  	if (typeof target == "undefined") {
  	  target = this;
    }

    var processor = getXSLProcessor(xsl,target);
    return processor.toXML(this);    
  }
  
  this.transformToDocument = function ( xsl ) {
    // Create a new XML document, avoiding transformNodeToObject raising "It is an error to mix objects from different versions of msxml"
  	// by using a print and parse approach
    var processor = getXSLProcessor(xsl);
    return processor.toDocument(this);    
  }  	
  
  this.transformToText = function ( xsl ) {
    var processor = getXSLProcessor(xsl);
    return processor.toText(this);    
  }
  
  this.transformToHTML = function ( xsl ) {
  	try {
      var processor = getXSLProcessor(xsl);
      return processor.transformToHTML(this);   
    }
    catch (e) {
  	  var error = new xfilesException(className + '.transformToHTML',9, self.sourceURL, e);         
 	    throw error;                                                                      
    }
  } 

  this.getClassName = function() { return className};
  
}

function extractText(node) {

    if (useMSXML) {
      return node.firstChild.text
    }
    else {
      // alert(node.textContent);
      return node.textContent;
    }
}
