
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

function formatResults(soapResponse, target) {

   xmlToHTML(document.getElementById(target),soapResponse,TableFormatterXSL);
   var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[*]",orawsvNamespaces );
   if (nodeList.length > 0 ) {
     // Output contains XML....
     var rowList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW",orawsvNamespaces );
     for (var i=0; i < rowList.length; i++) {
    	 var row = new xmlElement(rowList.item(i));
    	 var colList = row.selectNodes("*",orawsvNamespaces);
    	 for (var j=0; j<colList.length; j++) {
    		 var col = new xmlElement(colList.item(j));
    		 var childList = col.selectNodes("*",orawsvNamespaces);
    		 if (childList.length > 0 ) {
    		   var documentLocator = (i+1) + "." + (j+1);
    	     prettyPrintRootFragment(col,"xmlValue" + "." + documentLocator);
    	   }
       }
     }
   }

   var nodeList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW/*[starts-with(.,'[') or starts-with(.,'{')]",orawsvNamespaces );
   if (nodeList.length > 0 ) {
     // Output contains JSON....
     var rowList = soapResponse.selectNodes("/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/orawsv:ROW",orawsvNamespaces );
     for (var i=0; i < rowList.length; i++) {
    	 var row = new xmlElement(rowList.item(i));
    	 var colList = row.selectNodes("*",orawsvNamespaces);
    	 for (var j=0; j<colList.length; j++) {
    		 var col = new xmlElement(colList.item(j));
    	   if ((col.getTextValue().charAt( 0 ) == '{') || (col.getTextValue().charAt( 0 ) == '[')) {
    	   	 var documentLocator = (i+1) + "." + (j+1);
    	     prettyPrintJSONColumn(JSON.parse(col.getTextValue()),"jsonValue" + "." + documentLocator);
    	   }
       }
     }
   }
   
}

function getOwnerList() {

  var SQLQuery = 
  'select distinct OWNER ' + '\n' + 
  '  from ALL_OBJECTS ' + '\n' + 
  ' where object_type in (\'PACKAGE\',\'PROCEDURE\',\'FUNCTION\')' + '\n' +
  ' order by OWNER';
  
  var selectControl = document.getElementById('ownerList');
  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { loadOptionList(mgr, selectControl, selectControl)}};
  mgr.executeSQL(SQLQuery);
  
}

function loadObjectLists() {

   // If the Owner is changed clear all other lists and reset the input form area. 
 
  var ownerList = document.getElementById("ownerList");

	document.getElementById('procedureList').disabled = true;
	document.getElementById('procedureList').width = 5;
  document.getElementById('procedureList').innerHTML = "";  
	document.getElementById('packageList').disabled = true;
	document.getElementById('packageList').width = 5;
	document.getElementById('packageList').innerHTML = "";
  document.getElementById('methodList').disabled = true;
  document.getElementById('methodList').width = 5;
	document.getElementById('methodList').innerHTML = "";

  document.getElementById("d_inputForm").innerHTML = "";
		
	if (ownerList.selectedIndex == 0) {
	  getOwnerList();
  }
  else {
  	var owner = ownerList.value;	
  	getProcedureList(owner);
	  getPackageList(owner);
  }
		
}

function getProcedureList(owner) {

  var SQLQuery = 
  'select distinct OBJECT_NAME ' + '\n' + 
  '  from ALL_OBJECTS ' + '\n' + 
  ' where object_type in (\'PROCEDURE\',\'FUNCTION\')' + '\n' +
  '   and owner = \'' + owner + '\'' + '\n' +
  ' order by OBJECT_NAME';
                          
  var selectControl = document.getElementById('procedureList');
  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { loadOptionList(mgr, selectControl, selectControl)}};
  mgr.executeSQL(SQLQuery);
}

function getPackageList(owner) {

  var SQLQuery = 
  'select distinct OBJECT_NAME ' + '\n' + 
  '  from ALL_OBJECTS ' + '\n' + 
  ' where object_type = \'PACKAGE\' ' + '\n' +
  '   and owner = \'' + owner + '\'' + '\n' +
  ' order by OBJECT_NAME';
                          
  var selectControl = document.getElementById('packageList');
  var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
  var ajaxControl = mgr.createPostRequest();
  ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { loadOptionList(mgr, selectControl, selectControl)}};
  mgr.executeSQL(SQLQuery);
  
}


function getProcedureWSDL() {

  // Procedure Selected : Get the WSDL for the Procedure
  
	var ownerList = document.getElementById("ownerList");	
	var procedureList = document.getElementById("procedureList");
  var packageList = document.getElementById("packageList")
	var methodList = document.getElementById("methodList");

	if (!packageList.disabled) {
	  packageList.selectedIndex = 0;
 	  methodList.disabled = true;
	}

 	document.getElementById("d_inputForm").innerHTML = "";
	document.getElementById('methodList').innerHTML = ""; 
	
	if (procedureList.selectedIndex > 0) {
  	var owner = ownerList.value;	
    var procedure = procedureList.value;	
    var url = "/orawsv/" + owner + "/" + procedure + '?wsdl';
    getTargetWSDL(url);
  }

}

function loadMethodList() {


  // Package Selected : Get the Methods for the package
  
	var ownerList = document.getElementById("ownerList");		
	var procedureList = document.getElementById("procedureList");
    var packageList = document.getElementById("packageList")
	var methodList = document.getElementById("methodList");
 	methodList.disabled = true;

	document.getElementById('methodList').innerHTML = ""; 
 	document.getElementById("d_inputForm").innerHTML = "";
		
	if (packageList.selectedIndex > 0) {
  	if (!procedureList.disabled) {
	    procedureList.selectedIndex = 0;
	  }
	
	var owner = ownerList.value;	
    var packageName = packageList.value;	

    var SQLQuery = 
    'select distinct PROCEDURE_NAME ' + '\n' + 
    '  from ALL_PROCEDURES ' + '\n' + 
    ' where object_name = \'' + packageName + '\'' + '\n' +
    '   and owner = \'' + owner + '\'' + '\n' +
    '   and PROCEDURE_NAME is not NULL' + '\n' +
    ' order by PROCEDURE_NAME';
                          
    var selectControl = document.getElementById('methodList');
    var mgr = soapManager.getRequestManager("XDB","ORAWSV","SQL");
    var ajaxControl = mgr.createPostRequest();
    ajaxControl.onreadystatechange=function() { if( ajaxControl.readyState==4 ) { loadOptionList(mgr, selectControl, selectControl)}};
    mgr.executeSQL(SQLQuery);
  }
    
}


function getMethodWSDL(owner,packageName,method) {
	
	var ownerList = document.getElementById("ownerList");		
  var packageList = document.getElementById("packageList")
	var methodList = document.getElementById("methodList");

 	document.getElementById("d_inputForm").innerHTML = "";

	if (methodList.selectedIndex > 0) {
		var owner = ownerList.value;	
    var packageName = packageList.value;	
    var method = methodList.value;			
    var url = "/orawsv/" + owner + "/" + package + "/" + method + '?wsdl';
    getTargetWSDL(url);
  }
}

function showForm(query,procedure,results,wsdl,request,response,execute) {

   var div_query     = document.getElementById('d_query');
   var div_procedure = document.getElementById('d_procedure');
   var div_results   = document.getElementById('d_results');
   var div_wsdl      = document.getElementById('d_wsdl');
   var div_request   = document.getElementById('d_request');
   var div_response  = document.getElementById('d_response');
   var div_execute   = document.getElementById('d_execute');
	 
   var t_query     = document.getElementById('tab_query');
   var t_procedure = document.getElementById('tab_procedure');
   var t_results   = document.getElementById('tab_results');
   var t_wsdl      = document.getElementById('tab_wsdl');
   var t_request   = document.getElementById('tab_request');
   var t_response  = document.getElementById('tab_response');

	 div_query.style.display     = query;
	 div_procedure.style.display = procedure;
	 div_results.style.display   = results;
	 div_wsdl.style.display      = wsdl;
	 div_request.style.display   = request;
	 div_response.style.display  = response;
	 div_execute.style.display   = execute;

   t_query.className  = 'inactiveTab';
   t_procedure.className  = 'inactiveTab';
   t_results.className  = 'inactiveTab';
   t_wsdl.className  = 'inactiveTab';
   t_request.className  = 'inactiveTab';
   t_response.className  = 'inactiveTab';
	 
   if (query == 'block') {
     t_query.className  = 'activeTab';
   }
   if (procedure == 'block') {
     t_procedure.className  = 'activeTab';
   }
   if (results == 'block') {
     t_results.className  = 'activeTab';
   }
   if (wsdl == 'block') {
     t_wsdl.className  = 'activeTab';
   }
   if (request == 'block') {
     t_request.className  = 'activeTab';
   }
   if (response == 'block') {
     t_response.className  = 'activeTab';
   }

}

function showQuery() {

   showForm('block','none','none','none','none','none','block');
   prettyPrintXML(queryServiceWSDL,'d_wsdl');
   stylesheetURL = "/XFILES/WebDemo/xsl/formatResponse.xsl";

}

function showProcedure() {

   showForm('none','block','none','none','none','none','none');
   stylesheetURL = "/XFILES/WebServices/xsl/simpleInputForm.xsl";

}

function showResults() {
	
   showForm('none','none','block','none','none','none','none');

}

function showWSDL() {
	
   showForm('none','none','none','block','none','none','none');

}

function showRequest() {

   showForm('none','none','none','none','block','none','none');

}

function showResponse() {

   showForm('none','none','none','none','none','block','none');

}
