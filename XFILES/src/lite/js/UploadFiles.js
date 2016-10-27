
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

function onPageLoaded() {

  setDefaults();

}

function setDefaults() {
  
  document.getElementById('UTF-8').selected = true;
  document.getElementById('en-US').selected = true;
  document.getElementById('Loading').style.display = "none";
  
  var targetFolder = document.getElementById('targetFolder');
 	targetFolder.value = parent.getUploadFolderPath();
 	
  // console.log('UploadFiles.setDefaults() : Target Folder = ' + targetFolder.value);

}

function doUploadFiles() {

	var fileCollection = document.getElementsByName('FILE');

  for (var i=0; i < fileCollection.length; i++) {
  	if (fileCollection[i].value != "") {
  		document.getElementById('Loading').style.display = "block";
      document.getElementById('uploadFiles').submit();
      return;
    }
  }
  
	showInfoMessage("Please select file to be uploaded");
						
}