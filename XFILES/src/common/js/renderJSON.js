
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

var jRenderer = new jsonRenderer();

function jsonRenderer() {
  
  this.editable = false;
  
  this.addContent = function(cell,scalarValue,name) {
   	if (this.editable) {
    	var input = document.createElement("INPUT");
    	input.value = scalarValue
    	if (typeof name != "undefined") {
    	  input.name = name
    	}
    	cell.appendChild(input);
    }
  	else  {
	    cell.appendChild(document.createTextNode(scalarValue));
	  }
  }

  this.addTable = function(parent) {

  	var table = document.createElement("SPAN");
    parent.appendChild(table);
    table.style.display="table";
    
    return table;
    
  }
	
  this.addHeader = function(table) {
  	
  	var header = document.createElement("SPAN");
    table.appendChild(header);
    header.style.display="table-row";
    
    return header;
  }

  this.addRow = function(table) {
  	
  	var row = document.createElement("SPAN");
    table.appendChild(row);
    row.style.display="table-row";
    
    return row;
  }
  
  this.addCell = function(row) {
      cell = document.createElement("SPAN");
    	row.appendChild(cell);
    	cell.style.display="table-cell";
  	  cell.style.paddingRight="20px";
  	  
  	  return cell; 	  
  }

	this.checkProperty = function (propertyName,propertyList,header) {
	     
    if (!(propertyName in propertyList)) {
   	  columnNumber = Object.keys(propertyList).length;
	    propertyList[propertyName] = columnNumber;
	    var cell = this.addCell(header);
	   	cell.appendChild(document.createTextNode(propertyName));
	  }

    return propertyList
  }	
  
  this.renderInnerObject = function(propertyName,jsonObject,propertyList,container) {

    var header
    var row
    var cell
    var columnNumber

		header = container.firstChild;
	  row = container.childNodes[container.childNodes.length-1];
  	
  	propertyList = this.checkProperty(propertyName,propertyList,header);
    columnNumber = propertyList[propertyName];
    
    for (var i=row.childNodes.length; i < columnNumber+1; i++) {
    	 cell = this.addCell(row);
	  }
	  
	  cell = row.childNodes[columnNumber];

    if (jsonProperty == null) {
  	  // cell.appendChild(document.createTextNode(jsonProperty));
  	  this.addContent(cell,jsonProperty,propertyName)
    }
    else if ((typeof jsonProperty == "string") || (typeof jsonProperty == "number") || (typeof jsonProperty == "boolean")) {
  	  // cell.appendChild(document.createTextNode(jsonProperty));
  	  this.addContent(cell,jsonProperty,propertyName)
  	}
  	else if (jsonProperty instanceof Array) {
  		this.renderArray(jsonProperty,cell);
    }
    else {
    	this.renderObject(jsonProperty,cell);
    }
      
    return propertyList;

  }  	
  	
	this.renderObject = function(jsonObject, parent) {
		
		 // Object has name and value

		 // Value can be scalar or object
		 
		var table   = this.addTable(parent)
		var header  = this.addHeader(table);
		var row     = this.addRow(table);

    var propertyList = new Array()

	  for ( var property in jsonObject) {
	  	jsonProperty = jsonObject[property]
      propertyList = this.renderInnerObject(property,jsonProperty,propertyList,table)
    } 
		
		return propertyList
	}
	
	this.renderObjectRow = function(jsonObject, table, propertyList) {
		
	  for ( var property in jsonObject) {
	  	jsonProperty = jsonObject[property]
      propertyList = this.renderInnerObject(property,jsonProperty,propertyList,table)
    } 
		
		return propertyList
	}
	
	this.printObjectArray = function(jsonArray,parent) {
		
    var table       = this.addTable(parent);
    var header      = this.addHeader(table);
    var emptyCell   = this.addCell(header);
    
    // Outer Loop over set of Items
    // Each item consists of a object with a single property
    
    var propertyList = new Array()
    propertyList[""] = "";
    
  	for (var i=0; i<jsonArray.length; i++) {
      // Loop for 1 one property to get the property Name
      var row         = this.addRow(table);
      var jsonItem    = jsonArray[i];
  	  for ( var property in jsonItem) {
  	  	// Print the innner object into the table..
  	  	cell = this.addCell(row);
  	  	cell.appendChild(document.createTextNode(property));
	    	var innerObject = jsonItem[property] 
	    	propertyList	= this.renderObjectRow(innerObject, table, propertyList)
	    }	
	  }

  }

  this.renderArray = function(jsonArray,parent) {

    /*
    **
    ** Check for special case :
    **
    ** Array contains a set of objects
    ** Each object consists of a single NV Pair
    ** The Value is itself an object
    ** 
    **
    */ 
    
  	for (var i=0; i<jsonArray.length; i++) {
      var jsonItem    = jsonArray[i];
  		if (typeof jsonItem != "object") {
  			break;
  	  }
  	  if (Object.keys(jsonItem).length > 1) {
  	  	break
  	  }
  	  return this.printObjectArray(jsonArray,parent);
  	}
  	
    var table       = this.addTable(parent);
    var header      = this.addHeader(table);
    // var emptyCell   = this.addCell(header);
 
  	var propertyList = new Array();

  	for (var i=0; i<jsonArray.length; i++) {
      var row         = this.addRow(table);
      var jsonItem    = jsonArray[i];

      if ((typeof jsonItem == "string") || (typeof jsonItem == "number") || (typeof jsonItem == "boolean")) {
      	var cell = this.addCell(row);
    	  // cell.appendChild(document.createTextNode(jsonItem));
    	  this.addContent(cell,jsonItem);
    	}
    	else {
    		if (typeof jsonItem == "object") {
      	  if (jsonItem instanceof Array) {
          	var cell = this.addCell(row);
      		  this.renderArray(jsonItem,cell)
  		    }
  	      else {
  	        propertyList = this.renderObjectRow(jsonItem,table,propertyList)
  	      }
  	    }
  	  }
    }    	
  }
  
  this.renderJsonObject = function (target,jsonObject) {
  	
    // JsonObject must be either an Object(N:V Pair) or an Array
    
    this.editable = false;
  	
  	if (typeof jsonObject == "object") {
     	if (jsonObject instanceof Array) {
        this.renderArray(jsonObject,target);
  		}
  	  else {
  	    columnList = this.renderObject(jsonObject,target)
  	  }
  	}
  	else {
      alert('Invalid top-level object: "' || typeof jsonItem + '"');
  	}
  }

  this.renderJsonInput = function (target,jsonObject) {
  	
    // JsonObject must be either an Object(N:V Pair) or an Array

    this.editable = true;
  	
  	if (typeof jsonObject == "object") {
     	if (jsonObject instanceof Array) {
        this.renderArray(jsonObject,target);
  		}
  	  else {
  	    columnList = this.renderObject(jsonObject,target)
  	  }
  	}
  	else {
      alert('Invalid top-level object: "' || typeof jsonItem + '"');
  	}
  }
}
