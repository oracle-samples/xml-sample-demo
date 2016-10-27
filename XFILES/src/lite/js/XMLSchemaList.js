
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

var dummy // Declaring a variable seems to help IE load the script correctly

function onPageLoaded() {
}

function xmlSchemaSearch(schemaOwner, schemaLocationHint, targetTableInfo) {
    
  target = '/XFILES/XMLSearch/xmlSchema.html';
  var strings = targetTableInfo.split('"');
  target = target + '?tableOwner='         + strings[1];
  target = target + '&tableName='          + strings[3];
  target = target + '&columnName='         + 'OBJECT_VALUE';
  target = target + '&schemaOwner='        + schemaOwner.value;
  target = target + '&schemaLocationHint=' + schemaLocationHint.value;
  target = target + '&elementName='        + strings[5]
  
  window.location.href = target

}

function xmlSchemaObjectSearch(tableOwner, tableName, columnName, schemaOwner, schemaLocationHint, elementName) {
    
  target = '/XFILES/XMLSearch/xmlSchema.html';
  target = target + '?tableOwner='         + tableOwner;
  target = target + '&tableName='          + tableName;
  target = target + '&columnName='         + columnName;
  target = target + '&schemaOwner='        + schemaOwner;
  target = target + '&schemaLocationHint=' + schemaLocationHint;
  target = target + '&elementName='        + elementName;
  
  window.location.href = target

}
