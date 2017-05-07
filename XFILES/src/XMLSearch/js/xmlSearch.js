
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

var SearchTreeViewXSL;
var DocumentIdListXSL;
var UniqueKeyListXSL;
var ResourceListXSL;

var resource
var stylesheetURL
var resourceURL

var documentNodeMap;

var searchPrefixList = orawsvPrefixList;
    searchPrefixList['map']='http://xmlns.oracle.com/xdb/pm/demo/search';

var searchNamespaces = new namespaceManager(searchPrefixList);

function NodeMap(objectName, styleSheet, targetWindowName) {

  var self; 
  var nodeMap;          

  this.self                  = this;
  this.nodeMap               = new xmlDocument();
  this.setNodeMap            = function (newNodeMap            )   { this.nodeMap          = newNodeMap };
  this.getNodeMap            = function () { return  this.nodeMap };

  var mapLoaded;    

  this.setMapLoaded          = function (                      )   { this.mapLoaded = true; };
  this.isMapLoaded           = function (ID) { return  this.mapLoaded } ;

  var objectName;
  var styleSheet;
  var targetWindowName; 

  this.mapLoaded             = false;

  this.objectName            = objectName;
  this.styleSheet            = styleSheet;
  this.targetWindowName      = targetWindowName;

  this.setObjectName         = function (newObjectName         )   { this.objectName       = newObjectName };
  this.setStylesheet         = function (newStyleSheet         )   { this.styleSheet       = newStyleSheet };
  this.setTargetWindowName   = function (newTargetWindowName   )   { this.targetWindowName = newTargetWindowName };
  
  this.getObjectName         = function () { return  this.objectName };
  this.getStylesheet         = function () { return  this.styleSheet };
  this.getTargetWindowName   = function () { return  this.targetWindowName };
  
  var parent;          

  this.getParent             = function () { return  this.parent };
  this.setParent             = function (myParent              )   { this.parent           = myParent };
  this.hasParent             = function () { return  this.parent != null };

  var contentSchemaID;

  this.setContentSchemaID    =  function(SchemaID) { 
    this.contentSchemaID     = SchemaID; 
  };
    
  this.getContentSchemaID = function() {
    return this.contentSchemaID;
  }

  this.isContentSchema = function(ID) { 
    return (ID == this.contentSchemaID);
  };

  var metadataSchemaID;

  this.setMetadataSchemaID   = function(SchemaID) { 
    this.metadataSchemaID      = SchemaID; 
  };
  
  this.getMetadataSchemaID =  function() {
    return this.metadataSchemaID;
  }

  this.isMetadataSchema = function(ID){ 
    return (ID == this.metadataSchemaID); 
  };
  
  var contentSchema;

  this.setContentSchema = function(schema) {
    this.contentSchema       = schema; 
  };

  this.hasContentSchema     = function () { return  this.contentSchema != null };
  this.getContentSchema     = function () { return  this.contentSchema };

  this.clearContentSchema =  function() {
    document.getElementById(this.contentSchema.getTargetWindowName()).innerHTML = "";
    this.contentSchema       = null;
  };

  var metadataSchema;
 
  this.setMetadataSchema = function(schema) { 
    this.metadataSchema       = schema; 
  };

  this.hasMetadataSchema    = function () { return  this.metadataSchema != null };  
  this.getMetadataSchema    = function () { return  this.metadataSchema };  
  
  this.clearMetadataSchema = function() {
    document.getElementById(this.metadataSchema.getTargetWindowName()).innerHTML = "";
    this.metadataSchema       = null;
  };
  
}

function loadSearchTreeViewXSL() {
  SearchTreeViewXSL = loadXMLDocument('/XFILES/XMLSearch/xsl/searchTreeView.xsl');
}

function loadDocumentIdListXSL() {
  DocumentIdListXSL = loadXMLDocument('/XFILES/XMLSearch/xsl/documentIdList.xsl');
}

function loadUniqueKeyListXSL() {
  UniqueKeyListXSL = loadXMLDocument('/XFILES/XMLSearch/xsl/uniqueKeyList.xsl');
}

function loadResourceListXSL() {
  ResourceListXSL = loadXMLDocument('/XFILES/XMLSearch/xsl/resourceList.xsl');
}

function toggleQueryView() {

  var targetWindow = document.getElementById("queryWindow").parentNode.parentNode;
  if (targetWindow.style.display == "none") {
    targetWindow.style.display = "block";
    toggleQuery.innerHTML = "Hide Query";
  }
  else {
    targetWindow.style.display = "none";
    toggleQuery.innerHTML = "Show Query";
  }
  
}

function renderTreeControl(nodeMap) {

  var targetWindow = document.getElementById(nodeMap.getTargetWindowName())
  // alert(nodeMap.getStylesheet().serialize());
  documentToHTML(targetWindow,nodeMap.getNodeMap(),nodeMap.getStylesheet());
  countMatchingRows(nodeMap);
  // dumpHTML(targetWindow.innerHTML);
  return;

}

function toggleChildren(nodeMap, ID) {

  currentElement = getCurrentElement(nodeMap,ID);

  if (currentElement.getAttribute("childrenVisible") == "block") {
    currentElement.setAttribute("childrenVisible","none");
  }
  else {
    currentElement.setAttribute("childrenVisible","block");
  }    
  
  // Icon and DIV State Changes : Redraw Tree for the moment

  renderTreeControl(nodeMap);
  return;

} 

function toggleSubGroup(nodeMap, ID) {
 
  // alert ('toggleSubGroup ' + ID');

  currentElement = getCurrentElement(nodeMap,ID);
  var xmlElmnt = new xmlElement(currentElement);

  if (currentElement.getAttribute("subGroupVisible") == "block") {
    currentElement.setAttribute("subGroupVisible","none");
    subGroupElement = xmlElmnt.selectNodes("map:subGroup",searchNamespaces).item(0);
  }
  else {
    currentElement.setAttribute("subGroupVisible","block");
  }    
  
  // Icon and DIV State Changes : Redraw Tree for the moment

  renderTreeControl(nodeMap);
  return;

} 

function toggleAttrs(nodeMap, ID) {

  currentElement = getCurrentElement(nodeMap,ID);

  if (currentElement.getAttribute("attributesVisible") == "block") {
    currentElement.setAttribute("attributesVisible","none");
  }
  else {
    currentElement.setAttribute("attributesVisible","block");
  }    

  renderTreeControl(nodeMap);
  return;

} 

function toggleValue(nodeMap, ID) {

  currentElement = getCurrentElement(nodeMap,ID);

  if (currentElement.getAttribute("valueVisible") == "visible") {
    currentElement.setAttribute("valueVisible","hidden");
  }
  else {
    currentElement.setAttribute("valueVisible","visible");
  }    

  renderTreeControl(nodeMap);
  return;
} 

function toggleAttrValue(nodeMap, ID) {

  currentAttribute = getCurrentAttr(nodeMap,ID);

  if (currentAttribute.getAttribute("valueVisible") == "visible") {
    currentAttribute.setAttribute("valueVisible","hidden");
  }
  else {
    currentAttribute.setAttribute("valueVisible","visible");
  }    

  renderTreeControl(nodeMap);
  return;
} 

function setSubtitutableItem(nodeMap, ID, control) {

  // Need to clear all selected Nodes in Element's Children and Substitution Group Siblings

  var subGroup = nodeMap.getNodeMap().selectNodes('//map:SubGroup[@ID="' + ID + '"]',searchNamespaces).item(0);
  var newElementID = control.value;
  var oldElementID = subGroup.getAttribute("SelectedMember");
  
  // alert('Set Substitutable Item ' + ID + '. Old Value = ' + newElementID + '. New Value = ' + oldElementID);
  
  subGroup.setAttribute("SelectedMember",newElementID);
  renderTreeControl(nodeMap);
  // setElementStateNoRefresh(nodeMap,oldElementID,"false");
  // setElementState(nodeMap,newElementID,"true");
}
  

function getCurrentAttr(nodeMap,ID) {

  var xpathExpression = '//map:Attr[@ID="' + ID + '"]';
  var nodeList = nodeMap.getNodeMap().selectNodes(xpathExpression,searchNamespaces);
  if (nodeList.length == 0) {
    showWarningMessage("Cannot find Node Map entry for Attribute '" + ID + "'");
  }
  currentAttribute = nodeList.item(0);

  // alert(serializeXML(currentAttribute));
  return currentAttribute
}

function hasElement(nodeMap,ID) {

  var xpathExpression = '//map:Element[@ID="' + ID + '"]';
  var nodeList = nodeMap.getNodeMap().selectNodes(xpathExpression,searchNamespaces);
  return nodeList.length > 0;

}

function getCurrentElement(nodeMap,ID) {
  
  var xpathExpression = '//map:Element[@ID="' + ID + '"]';
  var nodeList = nodeMap.getNodeMap().selectNodes(xpathExpression,searchNamespaces);
  if (nodeList.length == 0) {
    showWarningMessage("Cannot find Node Map entry for Element '" + ID + "'");
  }
  currentElement = nodeList.item(0);
  return currentElement
}

function clearValues(currentElement) {
  
  var xmlElmnt = new xmlElement(currentElement);
  var nodeList = xmlElmnt.selectNodes('.//*[@value!=""]',searchNamespaces);
  for (var i=0; i<nodeList.length;i++) {
    var childElement = nodeList.item(i);
    childElement.setAttribute("value","");
  }

}

function setParentState(nodeMap,currentElement) {

  var parentElement = currentElement.parentNode;
  parentElement.setAttribute("isSelected","true");
  if (parentElement != nodeMap.getNodeMap().getDocumentElement()) {
    setParentState(nodeMap,parentElement);
  }
}

function clearChildState(currentElement) {

  var xmlElmnt = new xmlElement(currentElement);

  var nodeList = xmlElmnt.selectNodes('.//*[@isSelected="true"]',searchNamespaces);
  for (var i=0; i<nodeList.length;i++) {
    var childElement = nodeList.item(i);
    childElement.setAttribute("isSelected","false");
  }
}

function setElementStateNoRefresh(nodeMap, ID, state) {

  var currentElement = getCurrentElement(nodeMap,ID);

  if (state == "true") {
    currentElement.setAttribute("isSelected","true");
    setParentState(nodeMap,currentElement);
  }
  else {
    currentElement.setAttribute("isSelected","false");
    clearChildState(currentElement);
    clearValues(currentElement);
  }    
}
function setElementState(nodeMap,ID,state) {

  setElementStateNoRefresh(nodeMap,ID,state);
  renderTreeControl(nodeMap);
  return;

}

function toggleElementStateNoRefresh(nodeMap,ID) {

  var currentElement = getCurrentElement(nodeMap,ID);

  if (currentElement.getAttribute("isSelected") == "true") {
    currentElement.setAttribute("isSelected","false");
    clearChildState(currentElement);
    clearValues(currentElement);
  }
  else {
    currentElement.setAttribute("isSelected","true");
    setParentState(nodeMap,currentElement);
  }    

}

function toggleElementState(nodeMap,ID) {

  toggleElementStateNoRefresh(nodeMap,ID);
  renderTreeControl(nodeMap);
  return;
} 

function toggleAttrState(nodeMap, ID) {

  var currentAttribute = getCurrentAttr(nodeMap,ID);

  if (currentAttribute.getAttribute("isSelected") == "true") {
    currentAttribute.setAttribute("isSelected","false");
  }
  else {
    currentAttribute.setAttribute("isSelected","true");
    setParentState(nodeMap,currentAttribute);
  }    

  renderTreeControl(nodeMap);
  return;
} 

function setElementValue(nodeMap,ID,newValue) {

  currentElement = getCurrentElement(nodeMap,ID);
  currentElement.setAttribute("value",newValue);
  
  if (newValue != "") {
    currentElement.setAttribute("isSelected","true");
    setParentState(nodeMap,currentElement);
   
  }
   
  renderTreeControl(nodeMap);
  return;
}  

function setAttrValue(nodeMap,ID,newValue) {

  currentAttribute = getCurrentAttr(nodeMap,ID);
  currentAttribute.setAttribute("value",newValue);

  if (newValue != "") {
    currentAttribute.setAttribute("isSelected","true");
    setParentState(nodeMap,currentElement);
  }
  
  renderTreeControl(nodeMap);
  return;
}  

function clearUniqueKey(nodeMap) {

  var nodeList = nodeMap.getNodeMap().selectNodes('/map:NodeMap//map:Element[@pathSearch="true"]',searchNamespaces);
  if (nodeList.length > 0)  {
    nodeList.item(0).setAttribute("pathSearch","false");
  }
  nodeList = nodeMap.getNodeMap().selectNodes('/map:NodeMap//map:Element[@uniqueKey="true"]',searchNamespaces);
  if (nodeList.length > 0)  {
    nodeList.item(0).setAttribute("uniqueKey","false");
  }
  nodeList = nodeMap.getNodeMap().selectNodes('/map:NodeMap//map:Attr[@uniqueKey="true"]',searchNamespaces);
  if (nodeList.length > 0)  {
    nodeList.item(0).setAttribute("uniqueKey","false");
  }
}

function setAttrUniqueKey(nodeMap, ID) {

  currentAttribute = getCurrentAttr(nodeMap,ID);
  if (currentAttribute.getAttribute("uniqueKey") == "true") {
    currentAttribute.setAttribute("uniqueKey","false");
  }
  else {
    clearUniqueKey(nodeMap);
    currentAttribute.setAttribute("uniqueKey","true");
  }

  renderTreeControl(nodeMap);
  return;
}

function setElementUniqueKey(nodeMap, ID) {

  currentElement = getCurrentElement(nodeMap,ID);
  if (currentElement.getAttribute("uniqueKey") == "true") {
    currentElement.setAttribute("uniqueKey","false");
  }
  else {
    clearUniqueKey(nodeMap);
    currentElement.setAttribute("uniqueKey","true");
  }

  renderTreeControl(nodeMap);
  return;
}

function setPathSearch(nodeMap, ID) {

  currentElement = getCurrentElement(nodeMap,ID);
  if (currentElement.getAttribute("pathSearch") == "true") {
    currentElement.setAttribute("pathSearch","false");
  }
  else {
    clearUniqueKey(nodeMap);
    currentElement.setAttribute("pathSearch","true");
  }

  renderTreeControl(nodeMap);
  return;
}

function assignTreeDepth(currentElement, treeDepth) {

  // Assign a Depth to each Element which has children that will need to be included in the Path Expression.
  
  var xmlElmnt = new xmlElement(currentElement);
  var elementList = xmlElmnt.selectNodes('map:Elements/map:Element[@isSelected="true"]',searchNamespaces);
  if (elementList.length > 0) {
    for (var i=0; i < elementList.length; i++) {
      assignTreeDepth(elementList.item(i),treeDepth + 1);
    }
    currentElement.setAttribute("treeDepth",treeDepth);
    return;
   }
   
   
  subGroupState = currentElement.getAttribute("subGroupVisible");
  if ((subGroupState) && (subGroupState == "block")) {
    var elementList = xmlElmnt.selectNodes('map:SubGroup/map:Element[@isSelected="true"]',searchNamespaces);
    if (elementList.length > 0) {
      for (var i=0; i < elementList.length; i++) {
        assignTreeDepth(elementList.item(i),treeDepth);
      }
      return;
    }
  }

  currentElement.setAttribute("treeDepth",treeDepth);

}

function getName(currentNode) {

  var xmlElmnt = new xmlElement(currentNode);
  
  var nameList = xmlElmnt.selectNodes("map:Name",searchNamespaces);
  if (nameList.length == 1) {
    return nameList.item(0).firstChild.nodeValue;
  }
  else {
    return currentNode.firstChild.nodeValue;
  }
}

function hasNodeValue(node) {

   if (node.getAttribute("valueVisible")) {
     if (node.getAttribute("valueVisible") == "visible") {
       return true;
     }
   }  
   return false;
}

function processAttributes(element) {

   var xmlElmnt = new xmlElement(element);
   
   var attrList = xmlElmnt.selectNodes('map:Attrs/map:Attr[@isSelected="true"]',searchNamespaces);

   var pathExpression = "";
   var attrName;
    
   for (var i=0; i < attrList.length; i++) {
     var currentAttr = attrList.item(i);
     attrName = "@" + getName(currentAttr);

     if (pathExpression != "") {
       pathExpression = pathExpression + " and "; 
     }
     
     pathExpression = pathExpression = attrName;
 
     if (hasNodeValue(currentAttr)) {
       nodeValue = currentAttr.getAttribute("value");
       if ((nodeValue.substring(0,1) == "[") && (nodeValue.substring(nodeValue.length-1) == "]")) {
         pathExpression = pathExpression + nodeValue;
       }
       else {
         pathExpression = pathExpression + '="' + nodeValue + '"';
       }
     }
   }
            
   return pathExpression

}

function userSuppliedPredicate(nodeValue) {
  // User supplied predicate (First Character of nodeValue is '[' and last Character of nodeValue is ']')
  return ((nodeValue.substring(0,1) == "[") && (nodeValue.substring(nodeValue.length-1) == "]"))
}

function addPredicateValue(baseType,nodeValue) {

  if (baseType) {
    if (baseType.substring(baseType.indexOf(':') + 1) == "string") {
      return '"' + nodeValue + '"';
    }
    return baseType + '("' + nodeValue + '")';
  }
  else {
   return '"' + nodeValue + '"';
  }
}

function processLeafElement(element) 
{

   // Process a leaf Element

   var xmlElmnt = new xmlElement(element);

   var nl = xmlElmnt.selectNodes('map:SubGroup',searchNamespaces);
   if (nl.length > 0) {
   	 var leafId = element.getAttribute("ID");
     var subGroup = new xmlElement(nl.item(0));
     var subGroupId = subGroup.getAttribute('SelectedMember');
     if (subGroupId != leafId) {
       var subGroupElement = subGroup.selectNodes('map:Element[@ID="' + subGroupId + '"]',searchNamespaces).item(0);
       return processLeafElement(subGroupElement);   
     }
   }

   attrList = xmlElmnt.selectNodes('map:Attrs/map:Attr[@isSelected="true"]',searchNamespaces);
  
   var pathExpression = "";
   var terminalExpression = "";
   var nodeName;

   if (hasNodeValue(element)) {
     var nodeValue = element.getAttribute("value");
     var baseType = element.getAttribute("BaseType");
     if (attrList.length == 0) {
       if (userSuppliedPredicate(nodeValue)) {
         pathExpression = getName(element) + nodeValue;
       }
       else {
         pathExpression = getName(element) + '=' + addPredicateValue(baseType,nodeValue);
       }
     }
     else {
       if (userSuppliedPredicate(nodeValue)) {
         pathExpression = nodeValue;
       }
       else {
         pathExpression = 'text()' + '=' + addPredicateValue(baseType,nodeValue);
       }
     }
   }
          
   for (var i=0; i <attrList.length; i++) {
     attr = attrList.item(i);
     nodeName = "@" + getName(attr);
     baseType = attr.getAttribute("BaseType")
     if (hasNodeValue(attr)) {
       if (pathExpression != "") {
         pathExpression = pathExpression + " and "; 
       }
       pathExpression = pathExpression + nodeName + '=' + addPredicateValue(baseType,attr.getAttribute("value"));
     }
     else {
       if (terminalExpression == "") {
         terminalExpression = nodeName;
       }
       else {
         if (pathExpression != "") {
           pathExpression = pathExpression + " and "; 
         }
         pathExpression = pathExpression + nodeName;
       }
     }
   }
   
   if (pathExpression != "") {
     pathExpression = "["  + pathExpression + "]"
   }

   if (terminalExpression != "") {
     pathExpression = pathExpression + "/" + terminalExpression;
   }
     
   if (attrList.length != 0) {
     pathExpression = getName(element) + pathExpression;
   }
   else {
     if (pathExpression == "") {
       pathExpression = getName(element);
     }
   }
   
   // alert('Leaf Expression = ' + pathExpression);
   return pathExpression;
}

function processElement(element) {

  var pathExpression = "";
  var xmlElmnt = new xmlElement(element);
  
  // Check to see if the current Element has subtrees that contain selected nodes. If there are no subtree this element is a leaf
    
  var branchNodes = xmlElmnt.selectNodes('map:Elements/map:Element[@treeDepth] | map:Elements/map:Element/map:SubGroup/map:Element[@treeDepth]',searchNamespaces);
  if (branchNodes.length == 0) {
    pathExpression = processLeafElement(element);
  }
  else {
    pathExpression = processAttributes(element);
    // var deepestPath = findDeepestPath(branchNodes);
    for (var i=0; i < branchNodes.length; i++) {
      if (i != 0) {
        if (pathExpression != "") {
          pathExpression = pathExpression + " and "; 
        }
        subExpression = processElement(branchNodes.item(i));
        if (subExpression.substring(0,1) == "[") {
          subExpression = subExpression.substring(1,subExpression.length - 1);
        }
        pathExpression = pathExpression + subExpression;
      }
    }
    // var subExpression = processElement(branchNodes.item(deepestPath));
    var subExpression = processElement(branchNodes.item(0));
    if (subExpression && subExpression.substring(0,1) != "[") {      
      subExpression = "/" + subExpression;
    }
    if (pathExpression != "") {
      pathExpression = "[" + pathExpression;
      if (subExpression && subExpression.substring(0,1) == "[") {
        subExpression = subExpression.substring(1);
        pathExpression = pathExpression + " and ";
      }
      else {
        pathExpression = pathExpression + "]";
      }
    }
    pathExpression = getName(element) + pathExpression;
    if (subExpression) {
      pathExpression += subExpression;
    }
  }
  
  // alert('Branch Expression = ' + pathExpression);
  return pathExpression;
}

function generatePathExpression(nodeMap) {

  // Remove any historical Tree Depth Annotations from the Node Map

  var elementList = nodeMap.getNodeMap().selectNodes('//map:Element[@treeDepth]',searchNamespaces);
  for (var i=0; i < elementList.length; i++) {
    elementList.item(i).removeAttribute("treeDepth");
  }

  // Calculate the Tree Depth for all selected Elements in the node List.
  // Zero is the top of the Tree.

  var rootElementList = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Element[@isSelected="true"]',searchNamespaces);
  for (var i=0; i < rootElementList.length; i++) {
    assignTreeDepth(rootElementList.item(i),0);
  }

  var pathExpression = "";

  // Create a Path Expression for each branch containing one or more selected Elements

  var rootElementList = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Element[@isSelected="true"]',searchNamespaces);
  for (var i=0; i < rootElementList.length; i++) {
    // alert(nodeMap.getNodeMap().serialize(rootElementList.item(i)));
    pathExpression = pathExpression + "$d/" + processElement(rootElementList.item(i));
    if ( i < (rootElementList.length - 1)){
      pathExpression = pathExpression + " or ";
    }
  }
 
   return pathExpression;
}

function getUniqueKeyType(nodeMap) {

  var keyDefinition;
  var nodeList = nodeMap.getNodeMap().selectNodes('//map:Element[@uniqueKey="true"]',searchNamespaces);

  if (nodeList.length == 0) {
    nodeList = nodeMap.getNodeMap().selectNodes('//map:Attr[@uniqueKey="true"]',searchNamespaces);
  }
    
  if (nodeList.length == 1) {
    keyDefinition = nodeList.item(0);
  }

  return keyDefinition.getAttribute("BaseType"); 
}

function getUniqueKeyPath(nodeMap) {

  var leafName = "";
  var uniqueKeyPath = "";

  var nodeList = nodeMap.getNodeMap().selectNodes('//map:Element[@uniqueKey="true"]',searchNamespaces);
  
  if (nodeList.length == 1) {
    leafName = getName(nodeList.item(0));
  }
  else {
    nodeList = nodeMap.getNodeMap().selectNodes('//map:Attr[@uniqueKey="true"]',searchNamespaces);
    if (nodeList.length == 1) {
      leafName = "@" + getName(nodeList.item(0));  
    }
  }
  
  if (leafName != "") {
    uniqueKeyPath = leafName;
    parentNode = nodeList.item(0).parentNode;
    while (parentNode.tagName != "NodeMap") {
      parentNode = parentNode.parentNode;
      uniqueKeyPath = getName(parentNode) + "/" + uniqueKeyPath;
      parentNode = parentNode.parentNode;
    }
  }
  
  return uniqueKeyPath;
        
}

function getNamespaces(nodeMap,pathExpression) {

  var namespaceMapping = "";
  var namespaces = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Namespaces/map:Namespace',searchNamespaces);
  for (var i=0; i < namespaces.length; i++) {
    namespace = namespaces.item(i);
    if (pathExpression.indexOf( namespace.getAttribute("Prefix") + ":") > 0){
      namespaceMapping = namespaceMapping + "declare namespace " + namespace.getAttribute("Prefix") + '="' + namespace.firstChild.nodeValue + '";' + "\n" + "          ";
    }
  }	
  
  return namespaceMapping;
}

function generateXMLExistsOperator(namespaceMappings, pathExpression, tablePrefix, columnName, columnPrefix) {

   if (pathExpression != "") {
     return        "XMLExists" + "\n" + 
            "       (" + "\n" + 
            "         '" + namespaceMappings + pathExpression + "'" + "\n" + 
            "         passing " + tablePrefix + '"' + columnName + '" as "d"' + "\n" +
            "       )" + "\n";
   }
   else {
     return "";
   }
}

function generateXMLQueryOperator(namespaceMappings, uniquePath, tablePrefix, columnName, columnPrefix) {

   if (uniquePath != "") {
   	 if (uniquePath.indexOf('@') > 0) {
       return        "XMLQuery" + "\n" + 
              "       (" + "\n" + 
              "         '" + namespaceMappings + '<value>{fn:data(' + uniquePath + ")}</value>'" + "\n" + 
              "         passing " + tablePrefix + '"' + columnName + '" as "d" returning content' + "\n" +
              '       ) "uniqueId" ' + "\n";
     }
   	 else {
       return        "XMLQuery" + "\n" + 
              "       (" + "\n" + 
              "         '" + namespaceMappings + uniquePath + "'" + "\n" + 
              "         passing " + tablePrefix + '"' + columnName + '" as "d" returning content' + "\n" +
              '       ) "uniqueId" ' + "\n";
     }
   }
   else {
     return "";
   }
}

function getResourceProperties() {

  return '       XMLTable' + "\n" +                
         '       (' + "\n" +                
         '          xmlNamespaces' + "\n" +                
         '          (' + "\n" +                
         "            default 'http://xmlns.oracle.com/xdb/XDBResource.xsd'" + "\n" +               
         '          ),' + "\n" +                
         "          '$r/Resource'" + "\n" + 
         '          passing "RES" as "r"' + "\n" +                
         '          COLUMNS' + "\n" +                
         "          CONTAINER      varchar2(005) path '@Container'," + "\n" +                  
         "          DISPLAY_NAME   varchar2(128) path 'DisplayName'," + "\n" +                
         "          CONTENT_TYPE   varchar2(128) path 'ContentType'," + "\n" +                
         "          OWNER          varchar2(032) path 'Owner'," + "\n" +                
         "          LAST_MODIFIED  timestamp(6)  path 'ModificationDate'," + "\n" +                
         "          CONTENT_SIZE   number(10)    path 'ContentSize'" + "\n" +                
         "       ) r" + "\n";
         
}

function getFolderRestriction(nodeMap) {

 if (hasElement(nodeMap,'FolderRestriction')) {
   folderRestriction = getCurrentElement(nodeMap,'FolderRestriction');

   if (folderRestriction.getAttribute("isSelected") == 'true') {
     restrictionType = folderRestriction.getAttribute("value");

     if (restrictionType == "FOLDER") {
       return "under_path(RES,1,'" + resourceURL + "') = 1" + "\n";
     }

     if (restrictionType == "TREE") {
       return "under_path(RES,'" + resourceURL + "') = 1" + "\n";
     }
   }
 }
 return "";
}

function isAllDocuments(nodeMap) {

 if (hasElement(nodeMap,'FolderRestriction')) {
   folderRestriction = getCurrentElement(nodeMap,'FolderRestriction');

   if (folderRestriction.getAttribute("isSelected") == 'true') {
     restrictionType = folderRestriction.getAttribute("value");
     if (restrictionType == "REPOSITORY") {
       return true;
     }
   }
 }
 return false;
}

function getFullTextClause(nodeMap) {

  if (hasElement(nodeMap,'FullTextSearch')) {
    fullText = getCurrentElement(nodeMap,'FullTextSearch'); 
    if ((fullText.getAttribute("isSelected") == 'true') && (fullText.getAttribute("value") != "")) {
      return 'contains("' + document.getElementById('columnName').value + '",' + "'" + fullText.getAttribute("value") + "',1) > 0" + "\n"; 
    }
  }
  
  return "";

}

function getTableName(nodeMap, Elnum) {

  var nodeList = nodeMap.getNodeMap().selectNodes('//map:GlobalElement[@ElNum="' + Elnum + '"]',searchNamespaces);
  var globalElement = nodeList.item(0);
  return ', "' + globalElement.getAttribute("defaultTableSchema") + '"."' + globalElement.getAttribute("defaultTable"); 
 
}

function getMetadataTable(nodeMap) {

  var globalElement = nodeMap.getMetadataSchema().getNodeMap().selectNodes('/map:NodeMap/map:Element',searchNamespaces).item(0);
  return getTableName(nodeMap,globalElement.getAttribute("ID")) + '" md';

}  

function getDefaultTable(nodeMap) {

  var globalElement = nodeMap.getContentSchema().getNodeMap().selectNodes('/map:NodeMap/map:Element',searchNamespaces).item(0);
  return getTableName(nodeMap,globalElement.getAttribute("ID")) + '" ct';

}  

function getMetadataTableJoin(nodeMap) {

  return "md.RESID = rv.RESID" + "\n"; 

}

function getDefaultTableJoin(nodeMap) {

  return "ref(ct) = extractValue(RES,'/Resource/XMLRef')" + "\n";

}

function showSQLQuery(sqlQuery,target) {

  target.innerHTML = convertSQLToHTML(sqlQuery);
  
}

function getXMLExistsOperator(nodeMap, tablePrefix, columnName, prefix) {

  var pathExpression    = generatePathExpression(nodeMap);
  var namespaceMapping  = getNamespaces(nodeMap,pathExpression);
  return generateXMLExistsOperator(namespaceMapping, pathExpression, tablePrefix, columnName, prefix);
}

function countMatchingRows(nodeMap) {

  var results = document.getElementById('resultWindow');
  var query = document.getElementById('queryWindow');

  if (nodeMap.hasParent()) {
    // alert(nodeMap.getObjectName() + ". Loading " + nodeMap.getParent().getObjectName());
    countMatchingRows(nodeMap.getParent());
    return;
  }
  
  // alert("Processing " + nodeMap.getObjectName());

  var sqlQuery = ""
  var xmlExistsOperator = getXMLExistsOperator(nodeMap, "", document.getElementById('columnName').value, 'd');

  var folderRestriction = getFolderRestriction(nodeMap);
  var fullTextClause    = getFullTextClause(nodeMap);

  var resourceViewAlias  = "";
  var metadataTableList  = "";
  var metadataTableJoin  = "";
  var metadataTableQuery = "";
    
  if ((nodeMap.hasMetadataSchema()) && (nodeMap.getMetadataSchema().isMapLoaded())) {
    resourceViewAlias  = " rv";
    metadataTableList  = getMetadataTable(nodeMap);
    metadataTableJoin  = getMetadataTableJoin(nodeMap);
    metadataTableQuery = getXMLExistsOperator(nodeMap.getMetadataSchema(),'md.','OBJECT_VALUE','d');
  }
  
  var defaultTableList  = "";
  var defaultTableJoin  = "";
  var defaultTableQuery = "";
  
  if ((nodeMap.hasContentSchema()) && (nodeMap.getContentSchema().isMapLoaded())) {
    defaultTableList  = getDefaultTable(nodeMap);
    defaultTableJoin  = getDefaultTableJoin(nodeMap);
    defaultTableQuery = getXMLExistsOperator(nodeMap.getContentSchema(),'ct.','OBJECT_VALUE','d');
  }
      
  if ((xmlExistsOperator != "") || (folderRestriction != "") || (fullTextClause != "") || (defaultTableQuery != "") || (metadataTableQuery != "")) {
    operator = ' where ';
    sqlQuery = 'select count(*) COUNT ' + "\n" + 
               '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + resourceViewAlias + metadataTableList + defaultTableList + "\n";
  
    if (xmlExistsOperator != "") {
      sqlQuery = sqlQuery + operator + xmlExistsOperator;
      operator = '   and ';
    }
    
    if (folderRestriction != "") {
      sqlQuery = sqlQuery + operator + folderRestriction;
      operator = '   and ';
    }
  
    if (fullTextClause != "") {
      sqlQuery = sqlQuery + operator + fullTextClause;
      operator = '   and ';
    }

    if (metadataTableQuery != "") {
      sqlQuery = sqlQuery + operator + metadataTableQuery;
      operator = '   and ';
    }

    if (metadataTableJoin != "") {
      sqlQuery = sqlQuery + operator + metadataTableJoin;
      operator = '   and ';
    }

    if (defaultTableQuery != "") {
      sqlQuery = sqlQuery + operator + defaultTableQuery;
      operator = '   and ';
    }

    if (defaultTableJoin != "") {
      sqlQuery = sqlQuery + operator + defaultTableJoin;
      operator = '   and ';
    }

  }
  else {
    results.innerHTML = "";
    query.innerHTML = "";
  }
  
  if (sqlQuery == "") {
    if (isAllDocuments(nodeMap)) {
      sqlQuery = "select count(*) COUNT from RESOURCE_VIEW";
    }
  }

  if (sqlQuery != "") {
    invokeExecuteSQLStatement(nodeMap, sqlQuery, results);   
    showSQLQuery(sqlQuery,query);  
  }
}

function getSearchType(nodeMap) {

  var keyNodeList = nodeMap.getNodeMap().selectNodes('//*[@uniqueKey="true"]',searchNamespaces);
  
  if (keyNodeList.length > 0) {
    if (keyNodeList.item(0).parentNode.tagName == "NodeMap") {
      // Root Element is marked as Unique Key
      return "DOCID"
    }
    else {
      return "UNIQUE"
    }
  }
  else {
    if (nodeMap.getNodeMap().getDocumentElement().getAttribute('schemaType') == "RESVIEW") {
      return "RESVIEW"
    };
 
    if (nodeMap.getNodeMap().getDocumentElement().getAttribute('schemaType') == "XMLSCHEMA") {
      return "XMLSCHEMA"
    };

    if (nodeMap.getNodeMap().getDocumentElement().getAttribute('schemaType') == "RESMETADATA") {
      return "RESID"
    };
    
    return "XMLREF";
  }
}

function executeQuery(nodeMap) {
 
  // Document Identifiers

  // UNIQUE : Unique Element / Attribute 
  // DOCID : Document ID ( OBJECT_ID )
  // XMLREF : ANY_PATH on XMLREF 
  // RESID : ANY_PATH on RESID (Must be RESMETADATA Schema)

  var sqlQuery = "";
  var uniqueKeyPath = "";
  var searchType = "";
  
  var results = document.getElementById('resultWindow');
  var query = document.getElementById('queryWindow');
  
  searchType = getSearchType(nodeMap);
  
  if (searchType == "UNIQUE") {
    uniqueKeyPath = "$d/" + getUniqueKeyPath(nodeMap);
  }
  
  // alert(searchType);
  
  var pathExpression    = generatePathExpression(nodeMap);
  var folderRestriction = getFolderRestriction(nodeMap);
  var fullTextClause    = getFullTextClause(nodeMap);

  var namespaceMapping  = getNamespaces(nodeMap,pathExpression);
  var xmlExistsOperator = generateXMLExistsOperator(namespaceMapping, pathExpression, "", document.getElementById('columnName').value, 'd');

  var namespaceMapping  = getNamespaces(nodeMap,uniqueKeyPath);
  var xmlQueryOperator  = generateXMLQueryOperator(namespaceMapping, uniqueKeyPath, "", document.getElementById('columnName').value, 'd');
  
  var metadataTableList  = "";
  var metadataTableJoin  = "";
  var metadataTableQuery = "";
    
  if ((nodeMap.hasMetadataSchema()) && (nodeMap.getMetadataSchema().isMapLoaded())) {
    metadataTableList  = getMetadataTable(nodeMap);
    metadataTableJoin  = getMetadataTableJoin(nodeMap);
    metadataTableQuery = getXMLExistsOperator(nodeMap.getMetadataSchema(),'md.','OBJECT_VALUE','d');
  }
  
  var defaultTableList  = "";
  var defaultTableJoin  = "";
  var defaultTableQuery = "";
  
  if ((nodeMap.hasContentSchema()) && (nodeMap.getContentSchema().isMapLoaded())) {
    defaultTableList  = getDefaultTable(nodeMap);
    defaultTableJoin  = getDefaultTableJoin(nodeMap);
    defaultTableQuery = getXMLExistsOperator(nodeMap.getContentSchema(),'ct.','OBJECT_VALUE','d');
  }
   
  operator = ' where ';
 
  if (searchType == "UNIQUE") {
    sqlQuery = 'select ' + xmlQueryOperator + "\n" + 
               '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + "\n";
  }
          

  if (searchType == "RESVIEW") {
    sqlQuery = 'select ANY_PATH "resourcePath", r.*';
    
    if (fullTextClause != "") {
      sqlQuery = sqlQuery + ', score(1) RANK' 
    } 

    sqlQuery = sqlQuery + "\n" +
               '  from "PUBLIC"."RESOURCE_VIEW" rv' + metadataTableList + defaultTableList + "," +  "\n" +
               getResourceProperties();
  }

  if (searchType == "XMLSCHEMA") {
    sqlQuery = 'select SCHEMA_URL "schemaLocationHint"' + "\n" + 
               '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + "\n";
   } 

  if (searchType == "DOCID") {
    sqlQuery = 'select OBJECT_ID "docId"' + "\n" + 
               '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + "\n";
  } 

  if (searchType == "XMLREF") {
    sqlQuery = 'select ANY_PATH "resourcePath", r.*' + "\n" + 
               '  from "PUBLIC"."RESOURCE_VIEW" rv, "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '" x,' + "\n" +
               getResourceProperties() +     
               " where extractValue(res,'/Resource/XMLRef') = ref(x)" + "\n";
    operator = '   and ';
  }

  if (searchType == "RESID") {
    sqlQuery = 'select ANY_PATH "resourcePath", r.*' + "\n" + 
               '  from "PUBLIC"."RESOURCE_VIEW" rv, "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '" m,' + "\n" +
               getResourceProperties() +     
               ' where m.RESID = rv.RESID' + "\n";
    operator = '   and ';
  } 

  if (pathExpression != "") {
    sqlQuery = sqlQuery + operator + xmlExistsOperator + "\n";
    operator = '   and ';
  }
  
  if (folderRestriction != "") {
    sqlQuery = sqlQuery + operator + folderRestriction;
    operator = '   and ';
  }
  
  if (fullTextClause != "") {
    sqlQuery = sqlQuery + operator + fullTextClause;
    operator = '   and ';
  }
  
  if (metadataTableQuery != "") {
    sqlQuery = sqlQuery + operator + metadataTableQuery;
    operator = '   and ';
  }

  if (metadataTableJoin != "") {
    sqlQuery = sqlQuery + operator + metadataTableJoin;
    operator = '   and ';
  }

  if (defaultTableQuery != "") {
    sqlQuery = sqlQuery + operator + defaultTableQuery;
    operator = '   and ';
  }

  if (defaultTableJoin != "") {
    sqlQuery = sqlQuery + operator + defaultTableJoin;
    operator = '   and ';
  }

  if (fullTextClause != "") {
    sqlQuery = sqlQuery + "  order by score(1) desc" + "\n"
  }  
  
  invokeExecuteSQLStatement(nodeMap, sqlQuery, results);   
  showSQLQuery(sqlQuery,query);

}

function fetchDocument(nodeMap, searchType, uniqueID) {
  

  var sqlQuery = "";

  var results        = document.getElementById('resultWindow');
  var query          = document.getElementById('queryWindow');
  var documentWindow = document.getElementById("documentWindow");
     

  if (searchType == 'RESPATH') {
    var selectedResource = getResourceXML(uniqueID,false);
    prettyPrintXML(selectedResource,documentWindow);
    
  }
  else {
    if (searchType == 'UNIQUE') {
     
      var uniqueKeyPath     = getUniqueKeyPath(nodeMap);
      var baseType          = getUniqueKeyType(nodeMap);
      
      var parentPath        = "/" + uniqueKeyPath.substring(0,uniqueKeyPath.lastIndexOf("/"));
      var targetNode        = uniqueKeyPath.substring(uniqueKeyPath.lastIndexOf("/")+1);
      pathExpression        = "$d" + parentPath + "[" + targetNode + '=' + addPredicateValue(baseType,uniqueID)  + ']';
  
      var namespaceMapping  = getNamespaces(nodeMap, pathExpression);
      var xmlExistsOperator = generateXMLExistsOperator(namespaceMapping, pathExpression, "", document.getElementById('columnName').value, 'd');
  
      sqlQuery = 'select "' + document.getElementById('columnName').value + '"' + "\n" +
                 '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + "\n" +
                 ' where ' + xmlExistsOperator + "\n";
    }
    
    if (searchType == 'DOCID') {
      sqlQuery = 'select "' + document.getElementById('columnName').value + '"' + "\n" +
                 '  from "' + document.getElementById('tableOwner').value + '"."' + document.getElementById('tableName').value + '"' + "\n" +
                 " where OBJECT_ID = '" + uniqueID + "'" + "\n";
    }
      
    invokeExecuteSQLStatement(nodeMap, sqlQuery, documentWindow);   
    showSQLQuery(sqlQuery,query);
  }
}

function createNodeMap(rootNodeMap,nodeMap){

  // Make the nodemap the root of the document and set it as the NodeMap for this NodeMap Object.
  // The nodeMap will contain an empty document at this point.
  
  rootNodeMap = nodeMap.getNodeMap().importNode(rootNodeMap,true);
  var rootElement = nodeMap.getNodeMap().appendChild(rootNodeMap);
   
  rootElement.setAttribute("nodeMapName",nodeMap.getObjectName());
  rootElement.setAttribute("nodeMapWindow","'" + nodeMap.getTargetWindowName() + "'");

  if (nodeMap.hasParent()) {
    rootElement.setAttribute("isChildNodeMap","true");
  }

  nodeMap.setMapLoaded();
  
  var nodeList = nodeMap.getNodeMap().selectNodes('/map:NodeMap/map:Element',searchNamespaces);
  
  for (var i=0; i < nodeList.length; i++) {
    currentElement = nodeList.item(i);

    if (nodeMap.hasParent()) {
      currentElement.setAttribute("isSelected","true");
    }
    else {
      currentElement.setAttribute("isSelected","false");
    }
    
    ID = currentElement.getAttribute('ID');
    
    currentElement.setAttribute("valueVisible","hidden");
    currentElement.setAttribute("value","");
    currentElement.setAttribute("attributesVisible","block");
    currentElement.setAttribute("childrenVisible","block");  
    
    var xmlElmnt = new xmlElement(currentElement);
    var attrList = xmlElmnt.selectNodes('map:Attrs/map:Attr',searchNamespaces);
    for (var j=0; j < attrList.length; j++) {
      childElement = attrList.item(j);
      attrID = childElement.getAttribute('ID');
      childElement.setAttribute('ID',ID + '.' + attrID);
      childElement.setAttribute("isSelected","false");
      childElement.setAttribute("valueVisible","hidden");
      childElement.setAttribute("value","");
      childElement.setAttribute("uniqueKey","false");
    }

    var elementList = xmlElmnt.selectNodes('map:Elements/map:Element',searchNamespaces);
    for (var j=0; j < elementList.length; j++) {
      childElement = elementList.item(j);
      elementID = childElement.getAttribute('ID');
      childElement.setAttribute('ID',ID + '.' + elementID);
    }

  }
}

function expandNodeMap(nodeMap, childNodeMap) {

  // alert(serializeXML(childNodeMap))

  ID = childNodeMap.getAttribute('ID');
  
  // Expand all unexpanded Elements for this ID
  
  // currentElement = getCurrentElement(nodeMap,ID);
  var matchingElementList = nodeMap.getNodeMap().selectNodes("//map:Element[substring(@ID,string-length(@ID)-string-length('" + ID + "')+1,string-length('" + ID + "')) = '" + ID + "' and not(map:Name)]",searchNamespaces);  

  for (var i=0; i < matchingElementList.length; i++) {
    currentElement = matchingElementList.item(i);
    // alert('Processing ' + currentElement.getAttribute('ID'));
  
    // Preserve current state of isSelected when expanding Element

    var isSelected = "false";
    if (currentElement.getAttribute("isSelected")) {
      isSelected = currentElement.getAttribute("isSelected");
    }
    
    childNodeMap.setAttribute("isSelected",isSelected);
    childNodeMap.setAttribute("value","");
    childNodeMap.setAttribute("valueVisible","hidden");
    childNodeMap.setAttribute("attributesVisible","block");
    childNodeMap.setAttribute("childrenVisible","block");

    cloneNodeMap = childNodeMap.cloneNode(true);
    ID = currentElement.getAttribute('ID');
    cloneNodeMap.setAttribute('ID',ID);
    currentElement.parentNode.replaceChild(cloneNodeMap,currentElement);

    var xmlElmnt = new xmlElement(cloneNodeMap);

    var attrList = xmlElmnt.selectNodes('map:Attrs/map:Attr',searchNamespaces);
    for (var j=0; j < attrList.length; j++) {
      childElement = attrList.item(j);
      attrID = childElement.getAttribute('ID');
      childElement.setAttribute('ID',ID + '.' + attrID);
      childElement.setAttribute("isSelected","false");
      childElement.setAttribute("value","");
      childElement.setAttribute("valueVisible","hidden");
      childElement.setAttribute("uniqueKey","false");
    }

    var elementList = xmlElmnt.selectNodes('map:Elements/map:Element',searchNamespaces);
    for (var j=0; j < elementList.length; j++) {
      childElement = elementList.item(j);
      elementID = childElement.getAttribute('ID');
      childElement.setAttribute('ID',ID + '.' + elementID);
    }
  }
}

function expandSubstitionGroup(nodeMap, childNodeMap) {

  // alert(serializeXML(childNodeMap))

  headElementID = childNodeMap.getAttribute('Head');
  var matchingElementList = nodeMap.getNodeMap().selectNodes("//map:Element[@subGroupHead='" + headElementID + "' and not(map:SubGroup)]",searchNamespaces);

  for (var i=0; i < matchingElementList.length; i++) {
    currentElement = matchingElementList.item(i);
    ID = currentElement.getAttribute('ID');

    // alert('Processing ' + ID);

    subGroupElement = childNodeMap.cloneNode(true);
    var xmlElmnt = new xmlElement(subGroupElement);
    
    subGroupElement.setAttribute("ID",ID);
    subGroupElement.setAttribute("SelectedMember",ID);
  
    var elementList = xmlElmnt.selectNodes('map:Element',searchNamespaces);
    for (var j=0; j < elementList.length; j++) {
      childElement = elementList.item(j);
      elementID = childElement.getAttribute('ID');
      childElement.setAttribute('ID',ID + '.' + elementID);
    }

    currentElement.appendChild(subGroupElement);
  }
}

function displayRowCount(nodeMap, result, outputTarget, elapsedTime) {

  var rowCount = result.firstChild.nodeValue; 
  outputTarget.innerHTML = "<b>Rows : " + rowCount + ". (Elapsed Time  : " + elapsedTime + "  ms).</b>";
  
  var executeButton = document.getElementById("executeQuery");

  // Enable or Disable Execute Query  
  
  var keyNodeList = nodeMap.getNodeMap().selectNodes('//*[@uniqueKey="true"]',searchNamespaces);
  var pathNodeList = nodeMap.getNodeMap().selectNodes('//*[@pathSearch="true"]',searchNamespaces);
  
  if ( ( rowCount == 0 ) || ( (keyNodeList.length == 0) && (pathNodeList.length == 0) ) ) {
    executeButton.style.display="none";
  }
  else {
    executeButton.style.display="block";
  }
      
  return;
}

function displayDocumentIdList(nodeMap,soapResponse,rowset,outputTarget,elapsedTime) {

  rowset.setAttribute("TableName",document.getElementById('tableName').value);
  rowset.setAttribute("TableOwner", document.getElementById('tableOwner').value);
  rowset.setAttribute("nodeMapName",nodeMap.getNodeMap().getDocumentElement().getAttribute("nodeMapName"));

  transformXMLtoHTML(soapResponse,DocumentIdListXSL,outputTarget)
  return;
   
}

function displayUniqueKeyList(nodeMap,soapResponse,rowset,outputTarget,elapsedTime) {

  var uniqueKeyPath = getUniqueKeyPath(nodeMap);
  var baseType = getUniqueKeyType(nodeMap);

  var parentPath = "/" + uniqueKeyPath.substring(0,uniqueKeyPath.lastIndexOf("/"));
  var targetNode = uniqueKeyPath.substring(uniqueKeyPath.lastIndexOf("/")+1);
  rowset.setAttribute("ParentPath",parentPath);
  rowset.setAttribute("TargetNode",targetNode);
  if (baseType) {
    rowset.setAttribute("BaseType",baseType);
  }
  rowset.setAttribute("TableName",document.getElementById('tableName').value);
  rowset.setAttribute("TableOwner", document.getElementById('tableOwner').value);
  rowset.setAttribute("nodeMapName",nodeMap.getObjectName());

  transformXMLtoHTML(soapResponse,UniqueKeyListXSL,outputTarget)
  return;
    
}

function displayResourceList(nodeMap,soapResponse,rowset,outputTarget,elapsedTime) {

  rowset.setAttribute("nodeMapName",nodeMap.getObjectName());
  transformXMLtoHTML(soapResponse,ResourceListXSL,outputTarget)

}

function displayDocument(document) {

    var targetDocument = new xmlDocument();
    root = targetDocument.importNode(document,true);
    targetDocument.appendChild(root);
    showSourceCode(targetDocument);

}

function processResponse(mgr, nodeMap, requestDate, id) {

  try {
    var responseDate = new Date();
    var elapsedTimeMS =  responseDate.getTime() - requestDate.getTime();

    var soapResponse = mgr.getSoapResponse("xmlSearch.processResponse");

    document.getElementById('searching').style.display="none";
    document.getElementById('searchResults').style.display="block";
  
    var namespaces = xfilesNamespaces;
    namespaces.redefinePrefix("tns",mgr.getServiceNamespace());

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETXMLINDEXROOTNODEMAP") {
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:NodeMap",namespaces);
      createNodeMap(nodeList.item(0),nodeMap);
      renderTreeControl(nodeMap);
      return;
    }

    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETXMLSCHEMAROOTNODEMAP") {
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:NodeMap",namespaces);
      createNodeMap(nodeList.item(0),nodeMap);
      renderTreeControl(nodeMap);
      return;
    }
    
    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETREPOSITORYNODEMAP") {
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:NodeMap",namespaces);
      createNodeMap(nodeList.item(0),nodeMap);
      setSchemaIDs(nodeMap);
      renderTreeControl(nodeMap);
      return;
    }
        
    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETXMLINDEXCHILDNODEMAP") {
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:Element",namespaces);
      childNodeMap = nodeMap.getNodeMap().importNode(nodeList.item(0),true);
      expandNodeMap(nodeMap,childNodeMap);
      renderTreeControl(nodeMap);
      return;
    }
    
    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETXMLSCHEMACHILDNODEMAP") {
	    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:Element",namespaces);
      childNodeMap = nodeMap.getNodeMap().importNode(nodeList.item(0),true);
      expandNodeMap(nodeMap,childNodeMap);
      renderTreeControl(nodeMap);
      return;
    }
    
    if (mgr.getServiceNamespace() == "http://xmlns.oracle.com/orawsv/XFILES/XFILES_SEARCH_SERVICES/GETSUBSTITUTIONGROUP") {
      var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/tns:RETURN/map:SubGroup",namespaces);
      childNodeMap = nodeMap.getNodeMap().importNode(nodeList.item(0),true);
      expandSubstitionGroup(nodeMap,childNodeMap);
      toggleSubGroup(nodeMap,id)
      renderTreeControl(nodeMap);
      return;
    }
    	
    var outputTarget = document.getElementById("resultWindow");
    
    var nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET/orawsv:ROW/orawsv:COUNT",namespaces);
    if (nodeList.length > 0) {
      result = nodeList.item(0);
      displayRowCount(nodeMap, result, outputTarget, elapsedTimeMS);
      return;
    }
    
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET[orawsv:ROW/orawsv:resourcePath]",namespaces);
    if (nodeList.length > 0) {
      displayResourceList(nodeMap,soapResponse,nodeList.item(0),outputTarget,elapsedTimeMS);
      return;
    }
    
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET[orawsv:ROW/orawsv:docId]",namespaces);
    if (nodeList.length > 0) {
      displayDocumentIdList(nodeMap,soapResponse,nodeList.item(0),outputTarget,elapsedTimeMS)
      return;
    }
    
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET[orawsv:ROW/orawsv:uniqueId]",namespaces);
    if (nodeList.length > 0) {
      displayUniqueKeyList(nodeMap,soapResponse,nodeList.item(0),outputTarget,elapsedTimeMS)
      return;
    }
    
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET/orawsv:ROW/orawsv:" + document.getElementById('columnName').value + "/*",namespaces);
    if (nodeList.length > 0) {
      displayDocument(nodeList.item(0))
      return;
    }
    
    nodeList = soapResponse.selectNodes(mgr.getOutputXPath() + "/orawsv:ROWSET[not(orawsv:ROW)]",namespaces);
    if (nodeList.length > 0) {
      outputTarget.innerHTML = "<B>0 Rows selected.</B>";
      return;
    }
  }
  catch (e) {
    handleException('xmlSearch.processResponse',e,null);
  }
}

function invokeExecuteSQLStatement(nodeMap, sqlStatement, outputWindow) {

  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var XHR = mgr.createPostRequest();
  var requestDate = new Date();
  XHR.onreadystatechange=function() { if( XHR.readyState==4 ) { processResponse(mgr, nodeMap, requestDate) } };
  mgr.executeSQL(sqlStatement);
 
}

function viewNodeMap(nodeMap) {

  try {
    var searchResultsXML = new xmlDocument();
    rootElement = searchResultsXML.createElement("SearchResults");
    searchResultsXML.appendChild(rootElement);
    rootElement.appendChild(searchResultsXML.importNode(nodeMap.getNodeMap().getDocumentElement(),true));  
 
    if (nodeMap.hasContentSchema()) {
      rootElement.appendChild(searchResultsXML.importNode(nodeMap.getContentSchema().getNodeMap().getDocumentElement(),true));  
    }

    if (nodeMap.hasMetadataSchema()) {
      rootElement.appendChild(searchResultsXML.importNode(nodeMap.getMetadataSchema().getNodeMap().getDocumentElement(),true));  
    }
  
    showSourceCode(searchResultsXML);
  }
  catch (e) {
    handleException('xmlSearch.viewNodeMap',e,null);
  }

}

function viewNodeMapXSL(nodeMap) {

  try {
    showSourceCode(nodeMap.getStylesheet());
  }
  catch (e) {
    handleException('xmlSearch.viewNodeMapXSL',e,null);
  }
}

