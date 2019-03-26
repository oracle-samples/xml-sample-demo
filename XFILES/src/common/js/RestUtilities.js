
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
 

/**
 * Generates a GUID string, according to RFC4122 standards.
 * @returns {String} The generated GUID.
 * @example af8a8416-6e18-a307-bd9c-f2c947bbb3aa
 * @author Slavik Meltser (slavik@meltser.info).
 * @link http://slavik.meltser.info/?p=142
 */

function guid() {
    function _p8(s) {
        var p = (Math.random().toString(16)+"000000000").substr(2,8);
        return s ? "-" + p.substr(0,4) + "-" + p.substr(4,4) : p ;
    }
    return _p8() + _p8(true) + _p8(true) + _p8();
}

function showErrorMessage(message,callback) {
  dialogOptions =     {
    title: 'ERROR',
    message: message,
    type: BootstrapDialog.TYPE_DANGER,
    closable: false,
    
    buttons:[
      {
        label: 'OK',
        action: function(dialog) {
          typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(true);
          dialog.close();
        }
      }
    ]
  }
  
  if ( typeof callback === 'function' ) {
    dialogOptions.onhidden = callback;
  }

  BootstrapDialog.show(dialogOptions);
}

function showSuccessMessage(message,callback) {
  
  dialogOptions =     {
    title: 'SUCCESS',
    message: message,
    type: BootstrapDialog.TYPE_SUCCESS,
    closable: true
  }

  if ( typeof callback === 'function' ) {
    dialogOptions.onhidden = callback;
  }

  BootstrapDialog.show(dialogOptions);

}

function showInformationMessage(message,callback) {
  
  dialogOptions =     {
    title: 'INFORMATION',
    message: message,
    type: BootstrapDialog.TYPE_INFO,
    closable: true
  }

  if ( typeof callback === 'function' ) {
    dialogOptions.onhidden = callback;
  }

  BootstrapDialog.show(dialogOptions);

}

function populateOptionList(optionList,optionValues,propertyName) {

  optionList.value = ""
  var i;
  for (var i=0; i<optionValues.length;i++) {
    OPTION = document.createElement("OPTION")
    optionList.appendChild(OPTION);
    var value 
    if (typeof propertyName != "undefined") {
      value = optionValues[i][propertyName]
    }
    else  {
      value = optionValues[i];
    }
    OPTION.value = value;
    OPTION.appendChild(document.createTextNode(value));
  }

  return i;  
}

function populateOptionList2(optionList,valueList,keyValue,textList,keyText) {

  optionList.value = ""
  textPath = keyText.split(".")
  var i;
  for (var i=0; i<valueList.length;i++) {
    OPTION = document.createElement("OPTION")
    optionList.appendChild(OPTION);
    var value 
    var text
    if (typeof keyValue != "undefined") {
      value = valueList[i][keyValue]
      var j;
      var obj = valueList[i];
      for (var j=0;j<textPath.length;j++) {
        obj = obj[textPath[j]];
      }
      text = obj
    }
    else  {
      value = valueList[i];
      text = textList[i];
    }
    OPTION.value = value;
    OPTION.appendChild(document.createTextNode(text));
  }

  return i;  
}

function fixIndices(keys) {
  
  var pathComponants = keys.split(".")
  for (var i = 0; i<pathComponants.length-1;i++) {
    var key = pathComponants[i];
    if (key.indexOf("[") > 0) {
      var index = key.substr(key.indexOf("["));
      pathComponants.splice(i,1,key.substr(0,key.indexOf("[")),index.substr(1,index.length-2));
    }
  }
  return pathComponants
}

function getJson(obj,path) {
	var keys = fixIndices(targetID)
         
  for (var i = 0; i<keys.length-1;i++) {
     obj = obj[keys[i]];
  }
         
  return obj[keys[keys.length-1]] 
}

function updateJson(obj,path,value) {

	var keys = fixIndices(targetID)
         
  for (var i = 0; i<keys.length-1;i++) {
     obj = obj[keys[i]];
  }
         
  obj[keys[keys.length-1]] = value

}

function renderScalarValue(obj,targetID) {

   var target = document.getElementById(targetID);
  
  if (target != null) {
    if ((target.nodeName == "SPAN") || (target.nodeName == "TD") || (target.nodeName == "STRONG")) {
      target.innerHTML = "";
      target.appendChild(document.createTextNode(obj));
     }
  }
}

function createEmptyRow(table,key,index) {
  
  // Create a new row containing a TD and a SPAN for each TH in the THEAD element. Set the ID of the TD to the ID of the TD + a subscript
  
  tableHeadings = table.tHead.children[0].children;
  TR = table.insertRow(table.rows.length);

  for (var i=0; i<tableHeadings.length;i++) {
    var TD = TR.insertCell(TR.cells.length);
    var SPAN = document.createElement("SPAN");
    TD.appendChild(SPAN);
    var id = tableHeadings[i].id
    id = id.substring(0,key.length) + "[" + index + "]" + id.substring(key.length)
    SPAN.id = id
   }
}

function renderJsonArray(array, targetID) {
  
  var table = document.getElementById(targetID);
  if ((table == null) || (table.nodeName != "TABLE")) {
    return
   }

	 while (table.rows.length > 1) {
	 	  /* Row 0 is the HEADER TR */
	 	  table.deleteRow(table.rows.length-1);
	 }
	 
   
   for (var i = 0; i < array.length; i++) {
     var member = array[i];
     var key = targetID + "[" + i + "]";
     
     if ((typeof member == "string") || (typeof member == "number") || (typeof member == "boolean")) {
       var TR = table.insertRow(table.rows.length);
       var TD = TR.insertCell(TR.cells.length)
       TD.appendChild(document.createTextNode(member));
       TD.id = key;
       continue;
    }
    
    if (typeof member == "object") {
      if (member instanceof Array) {
        /* ### Unsupported : How to process Arrays of Arrays ???? */
      }
      else {
        createEmptyRow(table,targetID,i);
        renderJSONObject(member,key);
      }
      continue;
    }  
    
    /* Infeasable */
  }
}

function renderJSONObject(json,parentKey) {
  
  for(var key in json) {
    
    var obj = json[key]
    var targetKey = key    

    if (typeof parentKey == "string") {
      targetKey = parentKey + "." + key;
    }      
    
    if ((typeof obj == "string") || (typeof obj == "number") || (typeof obj == "boolean")) {
      renderScalarValue(obj,targetKey);    
      continue;
    }

     if (typeof obj == "object") {
       if (obj instanceof Array) {
        renderJsonArray(obj,targetKey);
      }
      else {
         renderJSONObject(obj,targetKey)
       }
      continue;
    }
    
    /* Infeasable */
  }
}

function makeEditable(object,objectPath) {
  
  // Convert all the SPAN elements to INPUT elements on a form that correspond to the keys of the object.
  // Remove all data rows from any Tables. Table content is derived from Arrays.
  // User OBJECT_PATH to derive the complete JSON Path expression for each key.
  
  // Navigating an Object. Key content must be Scalar, Array or Object
  
  for (var key in object) {
    
    var id = key;
  	if (typeof objectPath == "string") {
  		id = objectPath + "." + id;
  	}

	  var formObject = document.getElementById(id);

	  if (formObject != null) {
 			if (formObject.nodeName == "SPAN") {
	      var INPUT = document.createElement("INPUT");
        if (id.lastIndexOf('.') > -1) {
          INPUT.placeholder = id.substr(id.lastIndexOf('.')+1)
        }
        else {
          INPUT.placeholder = id
        }
      	INPUT.className = "form-control";
  	    INPUT.value = formObject.textContent;

        var parent = formObject.parentNode;
        parent.removeChild(formObject);
        INPUT.id = formObject.id;
        parent.appendChild(INPUT);
      }	    

	    if (formObject.nodeName == "TABLE") {
	    	// Process the Rows. Each Row should correspond to one member of the Array.
        // First Item in Rows collection is Header..
        // If there is only a Header Row add an empty row.
        if (formObject.rows.length == 1) {
        	createEmptyRow(formObject,id,0);
        }
	    	for (var i=0; i < formObject.rows.length-1; i++) {
   		 		if (i < object[key].length) {
	        	makeEditable(object[key][i],id+"[" + i + "]");
	        }
	      }	 			 
	 	  	continue
	 		}
	 	}
	 	else {
	 		if (typeof object[key] == "object") {
	 			/* Process the Inner Object */
      	makeEditable(object[key],id);
        continue;
      }
      /* Infeasable */
    }
  }
}  
  
function makeDisplayOnly(object,objectPath,save) {
  
  // Convert all the INPUT elements to SPAN elements on a form that correspond to the keys of the object.
  // Remove all data rows from any Tables. Table content is derived from Arrays.
  // User OBJECT_PATH to derive the complete JSON Path expression for each key.
  
  // Navigating an Object. Key content must be Scalar, Array or Object
  
  for (var key in object) {
    
    var id = key;
  	if (typeof objectPath == "string") {
  		id = objectPath + "." + id;
  	}

	  var formObject = document.getElementById(id);

	  if (formObject != null) {
 			if (formObject.nodeName == "INPUT") {

        if (save === true) {     
	        object[key] = formObject.value;
        }
      
        var SPAN = document.createElement("SPAN");
        SPAN.appendChild(document.createTextNode(formObject.value));
        var parent = formObject.parentNode;
        parent.removeChild(formObject);
        SPAN.id = formObject.id;
        parent.appendChild(SPAN);
      }	    

	    if (formObject.nodeName == "TABLE") {
	    	// Process the Rows. Each Row should correspond to one member of the Array.
        // First Item in Rows collection is Header..
	    	for (var i=0; i < formObject.rows.length-1; i++) {
			 		if (i < object[key].length) {
		      	makeDisplayOnly(object[key][i],id+"[" + i + "]",save);
	        }	 			 
	 	  	}
	 	  	continue
	 		}
	 	}
	 	else {
	 		if (typeof object[key] == "object") {
	 			/* Process the Inner Object */
      	makeDisplayOnly(object[key],id,save);
        continue;
      }
      /* Infeasable */
    }
  }
}  

function qbeMakeQueryFromObject(object,objectPath) {
  
  // Create a QBE object from this object.
  
  var qbeBlock = new Object();
  
  for(var key in object) {
    
    var id = key
    if (typeof objectPath == "string") {
      id = objectPath + "." + key;
    }      

	  var formObject = document.getElementById(id);

	  if (formObject != null) {

      if ((formObject.nodeName == "INPUT") && (formObject.value != null) && (formObject.value != "")) {
	   	  qbeBlock[key] = formObject.value;
	   	  continue
	    }

      if (formObject.nodeName == "TABLE") {
      	 var subQueryBlock = qbeMakeQueryFromObject(object[key][0],id+"[0]")
         if (Object.keys(subQueryBlock).length > 0 ) {
           qbeBlock[key] = subQueryBlock
         }
	       continue;
	    }
	    
	 	}
	 	else {
	 		if (typeof object[key] == "object") {
	 			/* Process the Inner Object */
      	var subQueryBlock = qbeMakeQueryFromObject(object[key],id)
        if (Object.keys(subQueryBlock).length > 0 ) {
          qbeBlock[key] = subQueryBlock
        }
        continue;
      }
      /* Infeasable */
    }
  }
 
  return qbeBlock;

}  

function qbeExecuteQuery(object,callback) {
 
  var qbe = qbeMakeQueryFromObject(object);
  restAPI.postDocument('action=query',qbe,callback);                    

}

function resetFormObject(object,objectPath) {
  
  // Reset all the INPUT and SPAN elements on a form that correspond to the keys of the object.
  // Remove all data rows from any Tables. Table content is derived from Arrays.
  // User OBJECT_PATH to derive the complete JSON Path expression for each key.
  
  // Navigating an Object. Key content must be Null, Array or Object
  
  for (var key in object) {
    
    var id = key;
  	if (typeof objectPath == "string") {
  		id = objectPath + "." + id;
  	}

	  var formObject = document.getElementById(id);

	  if (formObject != null) {
      if (formObject.nodeName == "INPUT") {
	       formObject.value = "";
	       continue;
	    }
	    
	    if (formObject.nodeName == "SPAN") {
	      formObject.innerHTML = "";
	      continue;
	    }
	    
	    if (formObject.nodeName == "TABLE") {
	    	// Delete all the data rows in a table
			 	while (formObject.rows.length > 1) {
	 	  		/* Row 0 is the HEADER TR */
	 	  		formObject.deleteRow(formObject.rows.length-1);
	 	  	}
	 	  	continue
	 		}
	 	}
	 	else {
	 		if (typeof object[key] == "object") {
	 			/* Process the Inner Object */
      	resetFormObject(object[key],id);
        continue;
      }
      /* Infeasable */
    }
  }
}  

function processDocument(XHR,URL) {

  var jsonDocument = null;

  if (XHR.status == 200) {
    try {
    	jsonDocument = JSON.parse(XHR.responseText);
		  return jsonDocument;
    }
 	  catch (e) {
      showErrorMessage("Invalid template");
      return null;
    }
  }
  else {
    showErrorMessage("Unable to locate template " + URL);
    return;
  } 
}
    	
function getDocument(URL,callback) {
	    	
		var XHR = new XMLHttpRequest();
		XHR.open ("GET", URL, true);
		XHR.onreadystatechange = function() { 
			                         if (XHR.readyState==4) { 
		                             callback(XHR,URL);
		                           } 
		                         };
		XHR.send(null);
}

function closeModalDialog(dialogName) {
	
	$('#' + dialogName).modal('hide')  
	
} 

function initRestLogin() {

    var currentUser = getHttpUsername();
    restAPI.setSchema(currentUser);
    if (currentUser == "ANONYMOUS") {
    	document.getElementById("btn.login").style.display = "inline-block";
    	document.getElementById("btn.logout").style.display = "none";
    }
    else {
    	document.getElementById("btn.login").style.display = "none";
    	document.getElementById("btn.logout").style.display = "inline-block";
		}    	

}

function doLocalLogoff() {
	
	doLogoff();
	init();

}

function doLocalLogin(username, password) {
	
  if (isEmptyString(username.value)) {
    showErrorMessage('Enter username');
    username.focus();
    return false;
  }

  if (isEmptyString(password.value)) {
    showErrorMessage('Enter password');
    password.focus();
    return false;
  }

  try {
  
    if (validCredentials(username.value,password.value)) {
    	 closeModalDialog("connectDialog");
       showSuccessMessage(
         'Connected', 
         function() {
            init();
          }
       );
    }
    else {
      showErrorMessage('Unknown Username / Password');
      if (username.disabled) {
        password.focus();
      }
      else {
        username.focus();
      }
      return false;
    }
  } 
  catch (e) {
    handleException('schemalessDevelopment.validateCredentials',e,null);
  }
}  

function openLoginDialog() {

    $('#connectDialog').modal('show');

}	
	
