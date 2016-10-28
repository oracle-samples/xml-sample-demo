
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

function displayXMLDocument(XHR, url, target) {
	
	try {
	  if (XHR.getResponseHeader('content-type') == "application/vnd.oracle-csx; charset=UTF-8") {
	  	if ((XHR.responseXML != null) && (XHR.responseXML.childNodes.length == 0)) {
	  		XHR.responseXML.loadXML(XHR.responseText);
	  	}
	  }

	  var xml = new xmlDocument();
		if (XHR.responseXML != null) {
    	xml.baseDocument = XHR.responseXML; 
    }
    else {
    	xml.baseDocument = new DOMParser().parseFromString(XHR.responseText,"text/xml");
    }
    xml.sourceURL = url;
    
    var div = document.createElement("DIV");
    target.appendChild(div);
	  prettyPrintXML(xml,div);
	}
  catch (e) {
    var err = new xfilesException("xmlViewer.displayXML()",12,null,e);
    err.setDescription('Underlying exception.');
    err.toHTML(document.body);
  }
}

function init(target) {

  try {
    initAjaxServices();
    var targetURL = decodeURIComponent(getParameter("target"));
    // initAjaxServices();
    var XHR = soapManager.createGetRequest(targetURL,false);
    if (XHR.mozBackgroundRequest) {
      XHR.mozBackgroundRequest = true;
    }
    // XHR.overrideMimeType("text/xml");
    XHR.send(null);
    displayXMLDocument(XHR,targetURL,target)
 
  }
  catch (e) {
    var err = new xfilesException("xmlViewer.init()",12,null,e);
    err.setDescription('Underlying exception.');
    err.toHTML(document.body);
  }
}
