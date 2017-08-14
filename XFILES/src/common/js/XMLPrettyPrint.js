
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

var xmlPP = new XMLPrettyPrinter();

function XMLPrettyPrinter() {

  var innerHTML
  var self = this;
  
  function unimplementedCopy(targetNode) {

    var node;
    var text;
    var unimplemented =  document.createElement("UnimplementedNode");
 
    node = document.createElement("nodeType");
    unimplemented.appendChild(node);
    text = document.createTextNode(targetNode.nodeType);
    node.appendChild(text);

    node = document.createElement("nodeName");
    unimplemented.appendChild(node);
    text = document.createTextNode(targetNode.nodeName);
    node.appendChild(text);

    node = document.createElement("nodeValue");
    unimplemented.appendChild(node);
    text = document.createTextNode(targetNode.nodeValue);
    node.appendChild(text);
 
    return unimplemented;
  }

  function hasChildElements(elementNode) {
  
    var childNode;
 
    childNode = elementNode.firstChild;
    while (childNode) {
    	if (childNode.nodeType == 1) {
    		return true;
      }
      childNode = childNode.nextSibling;
    }
    return false;	
  }

  function isInsignificantWhitespace(textNode) {

    var regex = /^\s*$/;
 
    if ('isElementContentWhitespace' in textNode) {
      return textNode.isElementContentWhitespace;
    }
    else {
      return regex.test(textNode.nodeValue);
    }
  }
  
  function hasTextNodes(elementNode) {
  
    var childNode;
 
    childNode = elementNode.firstChild;
    while (childNode) {
    	if ((childNode.nodeType == 3) && (!isInsignificantWhitespace(childNode))) {
    		return true;
      }
      childNode = childNode.nextSibling;
    }
    return false;	
  }

  function copyAttributes(elementNode,openTagContainer,parentNamespaces) {
 
    var  attr;
    var  span;
    var  text;
    var  nameClass;
    var  valueClass;
    var  myNamespaces = new Array();
       
    var	nodeMap = elementNode.attributes;
    
    for (var i=0; i < nodeMap.length; i++ ) {

      attr = nodeMap.item(i);
   
      if (((attr.namespaceURI == 'http://www.w3.org/2000/xmlns/')) && ((attr.nodeName == 'xmlns') || (attr.prefix == 'xmlns'))) {
        myNamespaces[attr.name] = attr.nodeValue;  	
      	if (parentNamespaces[attr.name] == attr.nodeValue) {
      	  continue;
      	}
    	  nameClass = 'nmspcName';
    	}
    	else {
    		 nameClass = 'attrName';
    	}
    	
      text = document.createTextNode(' ');
      openTagContainer.appendChild(text);
          
      span = document.createElement('span');
      openTagContainer.appendChild(span);
      span.className = nameClass;
      text = document.createTextNode(attr.nodeName);
      span.appendChild(text);
      
      span = document.createElement('span');
      openTagContainer.appendChild(span);
      span.className = 'attrFixed';
      text = document.createTextNode('="');
      span.appendChild(text);
      
 	    span = document.createElement('span');
      openTagContainer.appendChild(span);
      span.className = 'attrValue';
      text = document.createTextNode(attr.value);
      span.appendChild(text);
     
 	    span = document.createElement('span');
      openTagContainer.appendChild(span);
      span.className = 'attrFixed';
      text = document.createTextNode('"');
      span.appendChild(text);
      
    }
    return myNamespaces;
  }

  function copyPi(piNode) {
  	
  	var span;
  	var text;
  	var piDefinition;

    piDefinition = document.createElement('div');
    piDefinition.className = "simpleContent";
  	
    span = document.createElement('span');
    piDefinition.appendChild(span);
    span.className = 'piFixed';
    text = document.createTextNode('<?');
    span.appendChild(text)
      
    span = document.createElement('span');
    piDefinition.appendChild(span);
    span.className = 'piName';
    text = document.createTextNode(piNode.nodeName);
    span.appendChild(text)
  
    text = document.createTextNode(' ');
    piDefinition.appendChild(text);
  
    span = document.createElement('span');
    piDefinition.appendChild(span);
    span.className = 'piValue';
    text = document.createTextNode(piNode.nodeValue);
    span.appendChild(text);
    
    span = document.createElement('span');
    piDefinition.appendChild(span);
    span.className = 'piFixed';
    text = document.createTextNode('?>');
    span.appendChild(text)
    
    return piDefinition;
  }
  
  function copyComment(commentNode) {
  	
  	var span;
  	var text;
  	var commentDefinition;

    commentDefinition = document.createElement('div');
    commentDefinition.className = "simpleContent";

    span = document.createElement('span');
    commentDefinition.appendChild(span);
    span.className = 'commentFixed';
    text = document.createTextNode('<!--');
    span.appendChild(text)
        
    span = document.createElement('span');
    commentDefinition.appendChild(span);
    span.className = 'commentValue';
    text = document.createTextNode(commentNode.nodeValue);
    span.appendChild(text);
    
    span = document.createElement('span');
    commentDefinition.appendChild(span);
    span.className = 'commentFixed';
    text = document.createTextNode('-->');
    span.appendChild(text)
    
    return commentDefinition;
  }
  
  function copyCData(cdataNode) {
  	
  	var span;
  	var text;
  	var cdataDefinition;
  	var spanName;
  	var spanContent;
  	var lineContainer;
  	var cdataContent;

    var cdataSection = document.createElement('DIV');
    var collapsedCDATA = document.createElement('SPAN');
    cdataSection.appendChild(collapsedCDATA);
    collapsedCDATA.className = "complexContent";
  	collapsedCDATA.style.display = "none";

    addToggleControl(collapsedCDATA,'/XFILES/lib/icons/xml_hidden_children.png','Show Text');

    span = document.createElement('span');
    collapsedCDATA.appendChild(span);
    span.className = 'cdataFixed';
    span.appendChild(document.createTextNode('<![CDATA['))

   	var collapsedContent = document.createElement("SPAN");
  	collapsedCDATA.appendChild(collapsedContent);
   	collapsedContent.className = 'textValue';
  	collapsedContent.appendChild(document.createTextNode(" ... "));

    span = document.createElement('SPAN');
    collapsedCDATA.appendChild(span);
    span.className = 'cdataFixed  complexContent';
    span.appendChild(document.createTextNode(']]>'))
 
    var expandedCDATA = document.createElement('SPAN');
    cdataSection.appendChild(expandedCDATA);
    expandedCDATA.className = "complexContent";
    expandedCDATA.style.display = "block";

    addToggleControl(expandedCDATA,'/XFILES/lib/icons/xml_visible_children.png','Hide Text');

    span = document.createElement('SPAN');
    expandedCDATA.appendChild(span);
    span.className = 'cdataFixed';
    span.appendChild(document.createTextNode('<![CDATA['))

    cdataContent = document.createElement('DIV');
    expandedCDATA.appendChild(cdataContent);

    indent = document.createElement('DIV');
    cdataContent.appendChild(indent);
    indent.className="indentChildren";
    
    pre = document.createElement('PRE');
    indent.appendChild(pre);
    pre.className = "cdata";
        
    var lines = cdataNode.data.split('\n');
    for (var i=0; i<lines.length; i++) {
    	var textContent = lines[i];
    	var text = document.createTextNode(textContent);
      pre.appendChild(text);
      var br = document.createElement('br');
      pre.appendChild(br);;
    }
    
    var indent = document.createElement("SPAN");
    expandedCDATA.appendChild(indent);
    indent.className = "complexContent";
    
    span = document.createElement('SPAN');
    indent.appendChild(span);
    span.className = 'cdataFixed  complexContent';
    span.appendChild(document.createTextNode(']]>'))
 
    
    return cdataSection;
  }
  
  function copyTextNode(textNode) {
  	
    var span = document.createElement('span');
    span.className = 'textValue';
    
    var content = textNode.data.split('\n');
    if (content.length == 1) {
      var text = document.createTextNode(textNode.data);
      span.appendChild(text);
    }
    else {
      for (var i = 0; i < content.length-1; i++) {
        if (content[i].length > 0) {
          var text = document.createTextNode(content[i]);
          span.appendChild(text);
        }
      	var br = document.createElement("br");
        span.appendChild(br);
      }
      var i = content.length - 1
      if (content[i].length > 0) {
        var text = document.createTextNode(content[i]);
        span.appendChild(text);
      }
    }
    return span;    	
  }
  
  function addOpenElement(elementNode, target, parentNamespaces) {
  
    var span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntFixed';
    span.appendChild(document.createTextNode('<'));
      
    span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntName';
    span.appendChild(document.createTextNode(elementNode.nodeName))
  
    var myNamespaces = copyAttributes(elementNode,target,parentNamespaces);
    
    span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntFixed';

    if (elementNode.hasChildNodes()) {
      span.appendChild(document.createTextNode('>'));
    }
    else {
      span.appendChild(document.createTextNode('/>'));
    }
    
    return myNamespaces;
  }

  function addCloseElement(elementNode, target) {
  	
    var span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntFixed';
    span.appendChild(document.createTextNode('</'))
      
    span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntName';
    span.appendChild(document.createTextNode(elementNode.nodeName))
 
    span = document.createElement('span');
    target.appendChild(span);
    span.className = 'elmntFixed';
    span.appendChild(document.createTextNode('>'));
    
  }
  
  function addToggleControl(target,iconPath, hint) { 
      var toggleControl = document.createElement('a');
      target.appendChild(toggleControl);
      toggleControl.className = 'openClose';
      toggleControl.href = '#';
      toggleControl.title = hint
      
      if (toggleControl.addEventListener) {
  	    toggleControl.addEventListener("click", self.toggleShowChildren, false);
	    }
      else {
 	      toggleControl.attachEvent("onclick", self.toggleShowChildren);
      }
      var img = document.createElement("IMG");
      toggleControl.appendChild(img);
      img.style.display="block";
      img.src = iconPath;
      img.style.height="16px";
      img.style.width="16px";
      img.style.border="0px";
  }
  
  function copyElement(elementNode, isMixedContent, parentNamespaces) {

    
    var elementContainer;
    var expandedElement
    var collapsedElement

    var containerType;
    var isArray
    var size

    var span;
    var text;
    var childNode;
    var containerType;
     	
    var mixedContent   = hasTextNodes(elementNode) && hasChildElements(elementNode) || isMixedContent;
    var simpleContent  = !hasChildElements(elementNode);
 
    if (mixedContent) {
      containerType     = 'span';
    }
    else {
    	containerType     = 'div';
    }
    
    elementContainer = document.createElement(containerType);
    
    expandedElement = document.createElement(containerType);
    elementContainer.appendChild(expandedElement);
    expandedElement.className = "simpleContent";
    expandedElement.style.display = "inline-block";

    if(!simpleContent && !mixedContent)  {
      expandedElement.className = "complexContent";
      expandedElement.style.display = "block";
    	// Add a collapsed object before the open object
    	collapsedElement = document.createElement("SPAN");
      elementContainer.insertBefore(collapsedElement,expandedElement);
      collapsedElement.className = "complexContent";
    	collapsedElement.style.display = "none";
      addToggleControl(collapsedElement,'/XFILES/lib/icons/xml_hidden_children.png','Show Children');
      addOpenElement(elementNode, collapsedElement,parentNamespaces);
    	var collapsedContent = document.createElement("SPAN");
    	collapsedElement.appendChild(collapsedContent);
    	collapsedContent.className = 'textValue';
    	collapsedContent.appendChild(document.createTextNode(" ... "));
    	addCloseElement(elementNode,collapsedContent);
      addToggleControl(expandedElement,'/XFILES/lib/icons/xml_visible_children.png','Hide Children');
    }

    var myNamespaces = addOpenElement(elementNode, expandedElement, parentNamespaces);
          	        
    // ProcessContent 
    
  	var contentObject = expandedElement;
  	
    if (elementNode.hasChildNodes()) {

      if (!simpleContent && !mixedContent) {
      	// Add Div to Indent Content
    	  var indent = document.createElement("DIV")
    	  contentObject.appendChild(indent);
    	  contentObject = indent;
        contentObject.className = 'indentChildren';
      }
    
      childNode = elementNode.firstChild;
      while (childNode) {
      	if ((childNode.nodeType != 3) || (simpleContent) || (mixedContent)) {
      		// Skip text nodes unless processing simple or mixed content
      	  copyNode(childNode,contentObject,mixedContent,myNamespaces);
      	}
      	childNode = childNode.nextSibling;
      }
    }
    
    if (!simpleContent) {
      var indent = document.createElement("DIV");
      expandedElement.appendChild(indent);
      indent.className = "complexContent";
    	addCloseElement(elementNode,indent);
    }
    else {
    	addCloseElement(elementNode,expandedElement);
    }
          	
    return elementContainer;

  }

  function copyDocument (doc) {
  	
  	var documentDefinition = document.createElement("div");

	  var childNode = doc.firstChild;
    while (childNode) {
  	  copyNode(childNode,documentDefinition,false,new Array());
    	childNode = childNode.nextSibling;
  	}
  	return documentDefinition;
  }

  function copyNode(node, target, isMixedContent, parentNamespaces) {

    switch (node.nodeType) {
      case nodeTypeElement : // Element
        var element = copyElement(node, isMixedContent, parentNamespaces)
        target.appendChild(element);
        return element;
      case nodeTypeAttribute : // Attribute - Illegal document structure...
        break;
      case nodeTypeText : // Text
        var text = copyTextNode(node);
        target.appendChild(text);
        return text;
      case nodeTypeCData : // CDATA
        var cdata = copyCData(node)
        target.appendChild(cdata);
        return cdata;
      case  nodeTypeEntityRef : // EntityRef
        break;
      case  nodeTypeEntity : // Entity
        break;
      case  nodeTypePI : // PI
        var pi = copyPi(node);
        target.appendChild(pi);
        return pi;
      case  nodeTypeComment : // Comment
        var comment = copyComment(node);
        target.appendChild(comment);
        return comment;
      case  nodeTypeDocument : // Document 
        var doc = copyDocument(node)
        target.appendChild(doc);
        return doc;
      case nodeTypeDTD : // Document Type DTD
        break;
      case nodeTypeDocFrag : // DocumentFragment
        break;
      case nodeTypeNotation : // Notation
        break;
    }
    
    // Copy and print the unsupported node type to the output document.
  
    var nodeDefinition;
    var childNode;
   
    nodeDefinition = unimplementedCopy(node);
    target.appendChild(nodeDefinition);
  
    childNode = node.firstChild;
    while (childNode) {
      copyNode(childNode,nodeDefinition,false,parentNamespacecs)
      childNode = childNode.nextSibling;
    }

  }

  this.addToggleChildrenScript = function () {
  	
  	
  	var script = 'function toggleShowChildren(target) {                                          ' + "\n" +
  	             '                                                                               ' + "\n" +
  	             '  var collapsingDiv;                                                           ' + "\n" +
  	             '  if (target.parentElement) {                                                  ' + "\n" +
  	             '    collapsingDiv = target.parentElement.parentElement.firstChild.nextSibling; ' + "\n" +
  	             '  }                                                                            ' + "\n" +
  	             '  else {                                                                       ' + "\n" +
  	             '    collapsingDiv = target.parentNode.parentNode.firstChild.nextSibling;       ' + "\n" +
  	             '  }                                                                            ' + "\n" +
  	             '                                                                               ' + "\n" +
  	             '  while (collapsingDiv.nodeType != 1) {                                        ' + "\n" +
  	             '    collapsingDiv = collapsingDiv.nextSibling;                                 ' + "\n" +
  	             '  }                                                                            ' + "\n" +
  	             '                                                                               ' + "\n" +
/*
  	             '  if (target.innerHTML == "-") {                                               ' + "\n" +
  	             '  	target.innerHTML = "+";                                                    ' + "\n" +
  	             '  	collapsingDiv.style.display = "none";                                      ' + "\n" +
  	             '  }                                                                            ' + "\n" + 
  	             '  else {                                                                       ' + "\n" + 
  	             '  	target.innerHTML = "-";                                                    ' + "\n" + 
  	             '  	collapsingDiv.style.display = "block";                                     ' + "\n" + 
  	             '  }                                                                            ' + "\n" + 
*/
  	             '  if (target.firstChild.style.display == "block") {                            ' + "\n" +
  	             '  	target.firstChild.style.display = "none";                                  ' + "\n" + 
  	             '    target.firstChild.nextSibling.style.display = "block"                      ' + "\n" +
  	             '  	collapsingDiv.style.display = "none";                                      ' + "\n" +
  	             '  }                                                                            ' + "\n" + 
  	             '  else {                                                                       ' + "\n" + 
  	             '  	target.firstChild.style.display = "block";                                 ' + "\n" + 
  	             '    target.firstChild.nextSibling.style.display = "none"                       ' + "\n" +
  	             '  	collapsingDiv.style.display = "block";                                     ' + "\n" + 
  	             '  }                                                                            ' + "\n" + 
  	             '                                                                               ' + "\n" + 
  	             '  return false;                                                                ' + "\n" + 
  	             '                                                                               ' + "\n" + 
  	             '}';
  	
  	
  	scriptElement = document.createElement("script");
    script.type= 'text/javascript'; 
  	scriptElement.text = script;
  	return scriptElement;
  	
  }
  
  this.toggleShowChildren = function (event) {
 
    var anchorElement;
    var collapsedView;
    var expandedView;
    
    if (window.event) { 
    	event = window.event; 
    }
    
    if  (event.srcElement) {
    	anchorElement = event.srcElement.parentNode;
    	collapsedView = anchorElement.parentElement.parentElement.firstChild;
      expandedView = collapsedView.nextSibling;;
    }
    else {
    	anchorElement = event.target.parentNode;
    	collapsedView = anchorElement.parentElement.parentElement.firstChild;
    	expandedView = collapsedView.nextSibling;;
    }

    if (collapsedView.style.display == "block") {                                 
  		collapsedView.style.display = "none";                                       
  	  expandedView .style.display = "block"                           
  	}                                                                           
  	else {                                                                      
  		collapsedView.style.display = "block";                                    
  		expandedView.style.display = "none";                                    
  	}           	
  	
  	if (event.preventDefault) {
  		event.preventDefault();
  		event.stopPropagation();
  	}
		else {
			event.returnResult = false;
			event.cancelBubble = true;
		}
		
		anchorElement.focus();
		return false;
  }
       
  function processSiblingElements(node,target) {

    while (node) {
      copyNode(node, target, false, new Array());
      if (node.nextElementSibling) {
        node = node.nextElementSibling;
      }
      else {
      	node = node.nextElement;
      }
    }
  }
  
  this.print = function (xml, target) {
  		
    innerHTML = false;
    target.innerHTML = "";

    var node = xml.baseDocument;
    processSiblingElements(node,target);

  }

  this.printXMLColumn = function (xml, target, expand) {
  	
  	// Used when the document to be printed has been returned as the child of another element.
  	// Typically required when the document to be printed is embedded in a SOAP response

    var node = xml.baseElement;
    if (node.firstElementChild) {
      node = node.firstElementChild;
    }
    else {
      	node = node.firstChild;
    }
    processSiblingElements(node,target);

  }

  this.printXMLElement = function (xml, target, expand) {
  	
    var node = xml.baseElement;
    processSiblingElements(node,target);

  }

  this.printToHTML = function (xml, target) {
  	
    // Used when the content will be written to a popup via innerHTML
    // Add Explicit Java Script for OpenClose and use onlick attribute 

    innerHTML = true;
    target.innerHTML = "";

    var div = document.createElement('div');
    target.appendChild(div);
    div.appendChild(addToggleChildrenScript());
    
    var node = xml.baseDocument;
    if (node.nodeType == 9) {
    	node = node.firstChild;
    }
    processSiblingElements(node,div);

  }

  this.expandXML = function(node,target,div) {
    var element =  copyElement(node, false, new Array()) 
    target.replaceChild(element,div);
  }
  
  function rootElementOnly(elementNode,target) {

    var elementDefinition;
    var openTagContainer;
    var childrenToggle;
    var containerType     = 'div';
     	     
    elementDefinition = document.createElement(containerType);
    openTagContainer = elementDefinition;
     	
  	// Add a +/- Control 
    	
    openTagContainer = document.createElement(containerType);
    elementDefinition.appendChild(openTagContainer);
    childrenToggle = document.createElement('a');
    openTagContainer.appendChild(childrenToggle);
    childrenToggle.className = 'openClose';
    childrenToggle.href = '#';
    // childrenToggle.onlick = function(){expandXML(); return false;};
    if (childrenToggle.addEventListener) {
	    childrenToggle.addEventListener("click", function() { xmlPP.expandXML(elementNode,target,elementDefinition)}, false);
	  }
    else {
 	    childrenToggle.attachEvent("onclick",  function() { xmlPP.expandXML(elementNode,target,elementDefinition) });
    }
    
    text = document.createTextNode('+');
    childrenToggle.appendChild(text);
    // text = document.createTextNode(' ');
    // childrenToggle.appendChild(text);

    span = document.createElement('span');
    openTagContainer.appendChild(span);
    span.className = 'elmntFixed';
    text = document.createTextNode('<');
    span.appendChild(text)
      
    span = document.createElement('span');
    openTagContainer.appendChild(span);
    span.className = 'elmntName';
    text = document.createTextNode(elementNode.nodeName);
    span.appendChild(text)
  
    span = document.createElement('span');
    openTagContainer.appendChild(span);
    span.className = 'elmntFixed';

    text = document.createTextNode('/>');
    span.appendChild(text)          
    return elementDefinition;

  }


  function processRootElement(node,target) {
  	
  // Prints the Root Element(s), along with any root level comments or processing instructions
  
    var temp = node;
    var isComplexContent = false;
    
    while (temp) {
    	if ((temp.nodeType == 1) && hasChildElements(temp)) {
    		isComplexType = true;
    		break;
      }
      temp = temp.nextSibling;
    }	
  
    while (node) {
   
      switch (node.nodeType) {
        case nodeTypeElement : // Element
          element = rootElementOnly(node,target)
          target.appendChild(element);
          break;
        case nodeTypePI : // PI
          var pi = copyPi(node);
          if (isComplexContent) {
            pi.className = "simpleContent";
          }
          target.appendChild(pi);
          break;
        case nodeTypeComment : // Comment
          var comment = copyComment(node)
          if (isComplexContent) {
            comment.className = "simpleContent";
          }
          target.appendChild(comment);
          break;
      }
      node = node.nextSibling;
    }

  }

  this.printRootFragment = function (xml, target) {
  	
  	// Used when the document to be printed has been returned as the child of another element.
  	// Typically required when the document to be printed is embedded in a SOAP response
  		
    innerHTML = false;
    target.innerHTML = "";

    var div = document.createElement('div');
    target.appendChild(div);

    var node;

    if (xml.getClassName() == 'XMLDocumentObject.xmlDocument') {
      node = xml.baseDocument;
    }

    if (xml.getClassName() == 'XMLDocumentObject.xmlElement') {
      node = xml.baseElement;
    }

  	node = node.firstChild;
    processRootElement(node,div);
  }

  this.printRoot = function (xml, target) {
  		
    innerHTML = false;
    target.innerHTML = "";

    var div = document.createElement('div');
    target.appendChild(div);

    var node = xml.baseDocument;
    if (node.nodeType == 9) {
    	node = node.firstChild;
    }
    processRootElement(node,div);
  }
  
}