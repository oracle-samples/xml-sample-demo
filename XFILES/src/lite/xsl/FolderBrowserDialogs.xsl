<?xml version="1.0" encoding="UTF-8"?>
<!--

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

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:template name="resourceActionMenu">
		<span style="display: none;" id="resourceActionMenu" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div style="position: absolute; top: -7px; right: 120px; z-index: 1000;">
					<ul class="Menu" style="width:140px;">
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'COPY');return false">Copy Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'MOVE');return false;">Move Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'LINK');return false;">Create Links</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'DELETE');return false;">Delete Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'LOCK');return false;">Lock Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'UNLOCK');return false;">Unlock Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'PUBLISH');return false;">Publish Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'COUNT');return false;">Count Hits</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'SETACL');return false;">Set Permissions</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'CHOWN');return false;">Change Owner</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'VIEWER');return false;">Change Viewer</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'VERSION');return false;">Version Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'CHECKOUT');return false;">Check Out Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'CHECKIN');return false;">Check In Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'ZIP');return false;">Zip Resources</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="doAction(event,'UNZIP');return false;">Unzip Resource</a>
						</li>
					</ul>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="manualLoginDialog">
    <div class="modal fade" id="dialog_ManualLogin" tabindex="-1" role="dialog" aria-labelledby="title_manualLoginDialog" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">								
          <div class="modal-header">
          	<div>
            	<span class="h4 modal-title" id="title_manualLoginDialog">Manual Login</span>
  			</div>
  	      </div>
          <div class="modal-body">
			<div class="form-horizontal">
  	      	<div class="form-group">
  	      		<label for="loginUsername" class="col-sm-2">Username</label>
  	      		<div class="col-sm-4">
		    		      <input id="loginUsername"  type="text" class="form-control" name="loginUsername"/>
  	      		</div>
  	      	</div>
  	      	<div class="form-group">
  	      		<label for="loginPassword" class="col-sm-2">Password</label>
  	      		<div class="col-sm-4">
		    		      <input id="loginPassword"  type="password" class="form-control" name="loginPassword"/>
  	      		</div>
  	      	</div>
  	      </div>	        	
          </div>
          <div class="modal-footer">
  					<button id="btn_cancelLogin" type="button" class="btn btn-default btn-med" data-dismiss="modal">
  						<span class="glyphicon glyphicon-ban-circle"></span>
  					</button>
  					<button id= "btn_doLogin" type="button" class="btn btn-default btn-med"
					        onclick="doManualAuthentication('loginUsername','loginPassword')">
  						<span class="glyphicon glyphicon-search"></span>
  					</button>
          </div>
        </div>
      </div>
    </div>
	</xsl:template>
	<xsl:template name="newFolderDialog">
		<div class="modal fade" id="newFolderDialog" tabindex="-1" role="dialog" aria-labelledby="newFolderDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="newFolderDialogTitle">Create Folder</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newFolderName">Name</label>
								<div class="col-sm-10">
									<input class="form-control" type="text" id="newFolderName" name="newFolderName" size="41" maxlength="128"/>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newFolderDescription">Description</label>
								<div class="col-sm-10">
									<textarea class="form-control" cols="32" rows="3" id="newFolderDescription" name="newFolderDescription"/>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelNewFolder" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoNewFolder" type="button" class="btn btn-default btn-med" onclick="createNewFolder('newFolderName','newFolderDescription');false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="newWikiPageDialog">
		<div class="modal fade" id="newWikiPageDialog" tabindex="-1" role="dialog" aria-labelledby="newWikiPageDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="newWikiPageDialogTitle">Create Wiki Page</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newWikiPageName">Name</label>
								<div class="col-sm-10">
									<input class="form-control" type="text" id="newWikiPageName" name="newWikiPageName" size="41" maxlength="128"/>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newWikiPageDescription">Description</label>
								<div class="col-sm-10">
									<textarea class="form-control" cols="32" rows="3" id="newWikiPageDescription" name="newWikiPageDescription"/>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelNewWikiPage" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoNewWikiPage" type="button" class="btn btn-default btn-med" onclick="createNewWikiPage(document.getElementById('newWikiPageName').value,document.getElementById('newWikiPageDescription').value);false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="newZipFileDialog">
		<div class="modal fade" id="newZipFileDialog" tabindex="-1" role="dialog" aria-labelledby="newZipFileDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="newZipFileDialogTitle">Create Zip Archive</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newZipFileName">Name</label>
								<div class="col-sm-10">
									<input class="form-control" type="text" id="newZipFileName" name="newZipFileName" size="41" maxlength="128"/>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newZipFileDescription">Description</label>
								<div class="col-sm-10">
									<textarea class="form-control" cols="32" rows="3" id="newZipFileDescription" name="newZipFileDescription"/>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelZipOperation" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoZipOperation" type="button" class="btn btn-default btn-med" onclick="createNewZipFile(document.getElementById('newZipFileName').value,document.getElementById('newZipFileDescription').value);false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="deleteDialog">
		<div class="modal fade" id="deleteDialog" tabindex="-1" role="dialog" aria-labelledby="deleteDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="deleteDialogTitle">Set Delete Options</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepDelete" data-toggle="tooltip" data-placement="top" title="Operations on a folder are applied to the folder and all files that are a direct descendant of the folder."/> Include Subfolders
							</label>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="forceDelete" data-toggle="tooltip" data-placement="top" title="When possible, ignore errors encountered while deleting resources"/> Ignore Errors
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelDeleleResources" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDeleleResources" type="button" class="btn btn-default btn-med" onclick="deleteResources();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="deepOperationDialog">
		<div class="modal fade" id="deepOperationDialog" tabindex="-1" role="dialog" aria-labelledby="deepOperationDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="deepOperationDialogTitle">Set Options</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepOperation" data-toggle="tooltip" data-placement="top" title="Operations on a folder are applied to the folder and all files that are a direct descendant of the folder."/> Include Subfolders
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelDeepOperation" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoDeepOperation" type="button" class="btn btn-default btn-med" onclick="doDeepOperation();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="publishDialog">
		<div class="modal fade" id="publishDialog" tabindex="-1" role="dialog" aria-labelledby="publishDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="publishDialogTitle">Publish Resource Options</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepPublish" data-toggle="tooltip" data-placement="top" title="When checked operations on a Folder and are applied to all descendants of the folder otheriwise operations on a folder are restricted to files in the selected folder and descendant folders are ignored."/> Include Subfolders
							</label>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="publicPublish" data-toggle="tooltip" data-placement="top" title="Apply the bootstrap ACL to each resource making it readable by anyone including ANONYMOUS."/> Include Subfolders
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelPublish" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoPublish" type="button" class="btn btn-default btn-med" onclick="doPublishOperation();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="checkInDialog">
		<div class="modal fade" id="checkInDialog" tabindex="-1" role="dialog" aria-labelledby="checkInDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="checkInDialogTitle">Check-In</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="checkInComment">Comments</label>
								<div class="col-sm-10">
									<textarea class="form-control" cols="32" rows="3" id="checkInComment" name="checkInComment"/>
								</div>
							</div>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepCheckIn"/> Include Subfolders
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelCheckIn" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoCheckIn" type="button" class="btn btn-default btn-med" onclick="checkInResources();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="setPrincipleDialog">
		<div class="modal fade" id="setPrincipleDialog" tabindex="-1" role="dialog" aria-labelledby="setPrincipleDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="setPrincipleDialogTitle">Change Owner</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="principleList">Owner</label>
								<div class="col-sm-10">
									<select class="form-control" id="principleList" name="principleList"/>
								</div>
							</div>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepChown"/> Include Subfolders
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelSetPrinciple" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoSetPrinciple" type="button" class="btn btn-default btn-med" onclick="updatePrinciple();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="setACLDialog">
		<div class="modal fade" id="setACLDialog" tabindex="-1" role="dialog" aria-labelledby="setACLDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="setACLDialogTitle">Change Owner</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="aclList">ACL</label>
								<div class="col-sm-10">
									<select class="form-control" id="aclList" name="aclList"/>
								</div>
							</div>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="deepACL"/> Include Subfolders
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelSetACL" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoSetACL" type="button" class="btn btn-default btn-med" onclick="updateACL();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="setViewerDialog">
		<div class="modal fade" id="setViewerDialog" tabindex="-1" role="dialog" aria-labelledby="setViewerDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="setViewerDialogTitle">Set Custom Viewer</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="xslList">Stylesheet</label>
								<div class="col-sm-10">
									<select class="form-control" id="xslList" name="xslList"/>
								</div>
							</div>
						</div>
						<div class="checkbox">
							<label>
								<input type="checkbox" id="viewerMetadata"/> Include Metadata
							</label>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelSetViewer" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoSetViewer" type="button" class="btn btn-default btn-med" onclick="updateViewer();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="folderPickerDialog">
		<div class="modal fade" id="folderPickerDialog" tabindex="-1" role="dialog" aria-labelledby="folderPickerDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="folderPickerDialogTitle">Select Folder</h4>
						</div>
					</div>
					<div class="modal-body">
						<div style=" white-space:nowrap; text-align:left;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeControl"/>
						<div style=" white-space:nowrap; text-align:center;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeLoading">
							<div>
								<img alt="Searching" src="/XFILES/lib/images/AjaxLoading.gif"/>
							</div>
							<div>
								<xsl:text>Loading</xsl:text>
							</div>
						</div>
						<div class="checkbox" id="recursiveOperationDialog">
							<label>
								<input type="checkbox" id="deepFolder"/> Include Subfolders
							</label>
						</div>
						<div id="unzipDuplicateAction">
							<div class="form group">
								<p>
									<xsl:text>Duplicate Processing</xsl:text>
								</p>
								<ul data-toggle="tooltip" data-placement="top" title="Action to be taken when a duplicate resource is detected while unzipping the archive.">
									<li>Skip : Skip the file in the archive and continue processing</li>
									<li>Abort : Termniate the operation</li>
									<li>Overwrite : Overwrite the resource with the archive's content</li>
									<li>Version : Create a new version the resource from the archive's content</li>
								</ul>
							</div>
						</div>
						<div class="radio">
							<label class="col-sm-2 control-label" for="onDuplicateSkip">
								<input type="radio" id="onDuplicateSkip" name="onDuplicateAction" value="SKIP" checked="checked"/>Skip</label>
							<label class="col-sm-2 control-label" for="onDuplicateRaise">
								<input type="radio" id="onDuplicateRaise" name="onDuplicateAction" value="RAISE_ERROR"/>Abort</label>
							<label class="col-sm-2 control-label" for="onDuplicateOverwrite">
								<input type="radio" id="onDuplicateOverwrite" name="onDuplicateAction" value="OVERWRITE"/>Overwrite</label>
							<label class="col-sm-2 control-label" for="onDuplicateVersion">
								<input type="radio" id="onDuplicateVersion" name="onDuplicateAction" value="VERSION"/>Version</label>
						</div>
					</div>
					<div class="modal-footer">
						<div id="doUnzipArchive">
							<button id="btnCancelUnzip" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoUnzip" type="button" class="btn btn-default btn-med" onclick="doUnzipOperations(document.getElementsByName('onDuplicateAction'));false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
						<div id="doTargetFolder">
							<button id="btnCancelTargetFolder" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnDoTargetFolder" type="button" class="btn btn-default btn-med" onclick="updateTargetFolder();false">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="uploadFilesDialog">
		<div class="modal fade" id="uploadFilesDialog" tabindex="-1" role="dialog" aria-labelledby="uploadFilesDialogTitle" aria-hidden="true">
			<div class="modal-dialog" style="width:875px;height:596px">
				<iframe id="uploadFilesFrame" style="width:875px;height:596px;borde-styler:none;border-width:0px;margin:0px;padding:0px;backgroundColor:transparent;" allowTransparency="true" frameBorder="0" scrolling="no">
					<xsl:attribute name="src">/XFILES/lite/Resource.html?target=/XFILES/lite/xsl/UploadFilesStatus.html&amp;stylesheet=/XFILES/lite/xsl/UploadFiles.xsl</xsl:attribute>
				</iframe>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
