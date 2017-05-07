
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

// Generic dummy node map required to allow common fetchDocument function()

var nodeMap
var searchType
var searchTerms

function loadReposSearchXSL() {
	stylesheetURL = '/XFILES/XMLSearch/xsl/reposSearch.xsl';
}

function repositorySearch(searchType, searchTerms) {

  var targetFolder;
  
  if (searchType == "ROOT") {
    targetFolder = "/"
  }
  else {
    targetFolder = resourceURL;
  }
 
  var sqlQuery = 'select ANY_PATH "resourcePath", score(1) RANK, r.*' + "\n" + 
             '  from "PUBLIC"."RESOURCE_VIEW",' + "\n" +
             getResourceProperties() +   
             '  where under_path (RES,';

  if (searchType == 'FOLDER') {
    sqlQuery = sqlQuery + "1,";
  }
    
  sqlQuery = sqlQuery + "'" + targetFolder + "') = 1 " + "\n" +
             "    and contains(RES,'" + searchTerms + "',1) > 0 " + "\n" +
             "  order by score(1) desc";
             
  var resultWindow = document.getElementById('resultWindow');             
  invokeExecuteSQLStatement(documentNodeMap, sqlQuery, resultWindow);   
  showSQLQuery(sqlQuery,document.getElementById('queryWindow'));

}

function init(target) {

  try {
    initXFilesCommon(target);
    loadReposSearchXSL();
    loadSearchTreeViewXSL();
    loadResourceListXSL();
    xfilesNamespaces = new namespaceManager(xfilesPrefixList);
  
    resourceURL  =   unescape(getParameter("target"));
    searchType   = getParameter("searchType");
    searchTerms  =  unescape(getParameter("searchTerms"));

    getResource(resourceURL,target,stylesheetURL);
  }
  catch (e) {
    handleException('reposSearch.init',e,null);
  }
}

function populateFormFields() {

  documentNodeMap = new NodeMap( "nodeMap" ,  loadXMLDocument('/XFILES/XMLSearch/xsl/resourceList.xsl'), 'resultWindow' );;
  document.getElementById("searchType").selectedValue=searchType;  
  document.getElementById("btnShowNodeMap").style.display = "none";
  repositorySearch(searchType,searchTerms);
  
}

function doViewXSL() {
	
	closePopupDialog();
  showSourceCode(documentNodeMap.getStylesheet());

}

function onPageLoaded() {
  populateFormFields();
  viewXSL = doViewXSL;
  document.getElementById("xmlIndexOptions").style.display = "none";
  document.getElementById("btnShowNodeMap").style.display = "none";
}
