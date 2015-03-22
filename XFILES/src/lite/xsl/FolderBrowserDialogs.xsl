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
 * ================================================ */

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:template name="resourceActionMenu">
		<span style="display: none;" id="resourceActionMenu" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div style="position: absolute; top: -7px; right: 120px; z-index: 1000;">
					<ul class="Menu" style="width:140px;">
						<li><a class="MenuItem" href="#" onclick="doAction(event,'COPY');return false">Copy Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'MOVE');return false;">Move Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'LINK');return false;">Create Links</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'DELETE');return false;">Delete Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'LOCK');return false;">Lock Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'UNLOCK');return false;">Unlock Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'PUBLISH');return false;">Publish Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'COUNT');return false;">Count Hits</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'SETACL');return false;">Set Permissions</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'CHOWN');return false;">Change Owner</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'VIEWER');return false;">Change Viewer</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'VERSION');return false;">Version Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'CHECKOUT');return false;">Check Out Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'CHECKIN');return false;">Check In Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'ZIP');return false;">Zip Resources</a></li>
						<li><a class="MenuItem" href="#" onclick="doAction(event,'UNZIP');return false;">Unzip Resource</a></li>
					</ul>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="newFolderDialog">
		<span style="display: none;" id="newFolderDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:385px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>New Folder</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="newFolderName">Folder Name</label>
								</span>
								<span class="valueCol">
									<input id="newFolderName" name="newFolderName" size="41" maxlength="128" type="text"/>
								</span>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="newFolderDescription">Description</label>
								</span>
								<span class="valueCol">
									<textarea id="newFolderDescription" name="newFolderDescription" cols="32" rows="3"/>
								</span>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelNewFolder" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoNewFolder" src="/XFILES/lib/icons/save.png" alt="Create New Folder" border="0" width="16" height="16" onclick="createNewFolder(document.getElementById('newFolderName').value,document.getElementById('newFolderDescription').value);false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="newWikiPageDialog">
		<span style="display: none;" id="newWikiPageDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:375px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>New Wiki Page</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="newWikiPageName">Wiki Name</label>
								</span>
								<span class="valueCol">
									<input id="newWikiPageName" name="newWikiPageName" size="41" maxlength="128" type="text"/>
								</span>
							</div>
							<div class="row">
								<span class="labelCol">
									<label for="newWikiPageDescription">Description</label>
								</span>
								<span class="valueCol">
									<textarea id="newWikiPageDescription" name="newWikiPageDescription" cols="32" rows="3"/>
								</span>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelWikiPage" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoNewWikiPage" src="/XFILES/lib/icons/save.png" alt="Create New Wiki Page" border="0" width="16" height="16" onclick="createNewWikiPage(document.getElementById('newWikiPageName').value,document.getElementById('newWikiPageDescription').value);false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="newZipFileDialog">
		<span style="display: none;" id="newZipFileDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:390px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>New Zip Archive</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="newZipFileName">Archive Name</label>
								</span>
								<span class="valueCol">
									<input id="newZipFileName" name="newZipFileName" size="41" maxlength="128" type="text"/>
								</span>
							</div>
							<div class="row">
								<span class="labelCol">
									<label for="newZipFileDescription">Description</label>
								</span>
								<span class="valueCol">
									<textarea id="newZipFileDescription" name="newZipFileDescription" cols="32" rows="3"/>
								</span>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelZipOperation" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoZipOperation" src="/XFILES/lib/icons/save.png" alt="Create New Wikie Page" border="0" width="16" height="16" onclick="createNewZipFile(document.getElementById('newZipFileName').value,document.getElementById('newZipFileDescription').value);false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="deleteDialog">
		<span style="display: none;" id="deleteDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Delete Options</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignLeft">
								<input type="checkbox" id="deepDelete"/>
								<label for="deepDelete">Include Subfolders</label>
							</div>
							<div class="row alignLeft">
								<input type="checkbox" id="forceDelete"/>
								<label for="forceDelete">Ignore errors caused by invalid resources</label>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelNewWikiePage" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDeleleResources" src="/XFILES/lib/icons/accept.png" alt="Delete Resources" border="0" width="16" height="16" onclick="deleteResources(document.getElementById('deepDelete'),document.getElementById('forceDelete'));false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="deepOperationDialog">
		<span style="display: none;" id="deepOperationDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div id="deepOperationTitle" class="row popupTitle">
								<xsl:text>Deep operation dialog</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignLeft">
								<input type="checkbox" id="deepOperation"/>
								<span style="width:10px; display:inline-block;"/>
								<a href="#" class="toolTip">
									<label for="deepOperation" id="deepOperationLabel">
										<xsl:text>Include Subfolders</xsl:text>
										<span id="deepOperationHint" class="hint">Operations on a folder are applied to the folder and all files that are a direct descendant of the folder. Selecting the 'Include Subfolders' option extends the scope of the operation to include files and folders that are in-direct descendants of the target folder.</span>
									</label>
								</a>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelOperation" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoOperation" src="/XFILES/lib/icons/accept.png" alt="Apply Operation" border="0" width="16" height="16" onclick="doDeepOperation(document.getElementById('deepOperation'));false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="publishDialog">
		<span style="display: none;" id="publishDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div id="publishTitle" class="row popupTitle">
								<xsl:text>Publish Resources Dialog</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignLeft">
								<input type="checkbox" id="deepPublish"/>
								<span style="width:10px; display:inline-block;"/>
								<a href="#" class="toolTip">
									<label for="deepPublish" id="deepPublishLabel">
										<xsl:text>Include Subfolders</xsl:text>
										<span id="deepPublishHint" class="hint">Checked  : Operations on a Folder and are applied to all descendants of the folder. Unchecked : Operations on a folder are restricted to files in the selected folder. Child folders are not processed.</span>
									</label>
								</a>
							</div>
							<div class="row alignLeft">
								<input type="checkbox" id="publicPublish"/>
								<span style="width:10px; display:inline-block;"/>
								<a href="#" class="toolTip">
									<label for="publicPublish" id="publicPublishLabel">
										<xsl:text>Make Public</xsl:text>
										<span id="publicPublishHint" class="hint">Apply the bootstrap ACL to each resource making it readable by anyone including ANONYMOUS</span>
									</label>
								</a>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelOperation" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoOperation" src="/XFILES/lib/icons/accept.png" alt="Apply Operation" border="0" width="16" height="16" onclick="doPublishOperation(document.getElementById('deepPublish'),document.getElementById('publicPublish'));false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="checkInDialog">
		<span style="display: none;" id="checkInDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:368px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Check-In</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="checkInComment">Comment</label>
								</span>
								<span class="valueCol">
									<textarea id="checkInComment" name="checkInComment" cols="32" rows="3"/>
								</span>
							</div>
							<div class="row alignLeft">
								<input type="checkbox" id="deepCheckIn"/>
								<label for="deepCheckIn">Include Subfolders</label>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelCheckIn" src="/XFILES/lib/icons/cancel.png" alt="Cancel Check-In" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoCheckIn" src="/XFILES/lib/icons/accept.png" alt="Check-In Resources" border="0" width="16" height="16" onclick="checkInResources(document.getElementById('checkInComment').value,document.getElementById('deepCheckIn'));false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="setPrincipleDialog">
		<span style="display: none;" id="setPrincipleDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:275px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Change Owner</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row">
								<span class="labelCol">
									<label for="principleList">Owner</label>
								</span>
								<span class="valueCol">
									<select id="principleList" name="principleList"/>
								</span>
							</div>
							<div class="row alignLeft">
								<input type="checkbox" id="deepChown"/>
								<label for="deepChown">Include Subfolders</label>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row alignRight">
								<img id="btnCancelSetPrinciple" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoSetPrinciple" src="/XFILES/lib/icons/accept.png" alt="Change Owner" border="0" width="16" height="16" onclick="updatePrinciple(document.getElementById('principleList').value,document.getElementById('deepChown'));false"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="setACLDialog">
		<span style="display: none;" id="setACLDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div style="position: absolute; top: -7px; right: 15px; z-index: 1000; border-width:1px 1px 1px 1px; border-style: ridge;">
					<div class="popupBackground" style="width:615px;">
						<div class="row popupTitle">
							<xsl:text>Change Permissions</xsl:text>
						</div>
						<div class="row" style="height:5px;"/>
						<div id="setAclSelector" class="row">
							<span id="setAclLabel" class="labelCol">
								<label for="aclList">ACL</label>
							</span>
							<span id="setAclSelect" class="valueCol">
								<select id="aclList" name="aclList"/>
							</span>
						</div>
						<div class="row alignLeft">
							<input type="checkbox" id="deepACL"/>
							<label for="deepACL">Include Subfolders</label>
						</div>
						<div class="row" style="height:5px;"/>
						<div class="row alignRight">
							<img id="btnCancelSetACL" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
							<span style="width:10px; display:inline-block;"/>
							<img id="btnDoSetACL" src="/XFILES/lib/icons/accept.png" alt="Change ACL" border="0" width="16" height="16" onclick="updateACL(document.getElementById('aclList').value,document.getElementById('deepACL'));false"/>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="setViewerDialog">
		<span style="display: none;" id="setViewerDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div style="position: absolute; top: -7px; right: 15px; z-index: 1000; border-width:1px 1px 1px 1px; border-style: ridge;">
					<div class="popupBackground" style="width:520px;">
						<div class="row popupTitle">
							<xsl:text>Set Custom Viewer</xsl:text>
						</div>
						<div class="row" style="height:5px;"/>
						<div id="setAclSelector" class="row">
							<span id="setXSLLabel" class="labelCol">
								<label for="xslList">Stylesheet</label>
							</span>
							<span id="setXSLSelect" class="valueCol">
								<select id="xslList" name="xslList"/>
							</span>
						</div>
						<div class="row" style="height:5px;"/>
						<div class="row alignRight">
							<img id="btnCancelSetViewer" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
							<span style="width:10px; display:inline-block;"/>
							<img id="btnDoSetViewer" src="/XFILES/lib/icons/accept.png" alt="Change Viewer" border="0" width="16" height="16" onclick="updateViewer(document.getElementById('xslList').value);false"/>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="folderPickerDialog">
		<span style="display: none;" id="folderPickerDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px: left 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div class="row popupTitle" id="folderPickerTitle">
								<xsl:text>Select Folder</xsl:text>
							</div>
							<div class="row" style="height:5px;"/>
							<div class="row" style=" white-space:nowrap; text-align:left;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeControl"/>
							<div class="row" style=" white-space:nowrap; text-align:center;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeLoading">
								<div>
									<img alt="Searching" src="/XFILES/lib/images/AjaxLoading.gif"/>
								</div>
								<div>
									<xsl:text>Loading</xsl:text>
								</div>
							</div>
							<div class="row alignLeft" id="recursiveOperationDialog">
								<input type="checkbox" id="deepFolder"/>
								<label for="deepFolder">Include Subfolders</label>
							</div>
							<div id="unzipDuplicateAction">
								<div class="row alignLeft">
									<a href="#" class="toolTip">
										<xsl:text>Duplicate Processing</xsl:text>
										<span style="width:500px; height:120px; top:-100px; left:-250px; text-align:left" class="hint">
											<xsl:text>Action to be taken when a duplicate resource is detected while unzipping</xsl:text>
											<br/>
											<xsl:text>the archive : </xsl:text>
											<ul>
												<li>Skip : Skip the file in the archive and continue processing</li>
												<li>Abort : Termniate the operation</li>
												<li>Overwrite : Overwrite the resource with the archive's content</li>
												<li>Version : Create a new version the resource from the archive's content</li>
											</ul>
										</span>
									</a>
								</div>
							</div>
							<div>
								<span class="alignLeft">
									<input type="radio" class="xg" id="onDuplicateSkip" name="onDuplicateAction" value="SKIP" checked="checked"/>
									<label for="onDuplicateSkip">Skip</label>
								</span>
								<span class="alignLeft">
									<input type="radio" class="xg" id="onDuplicateRaise" name="onDuplicateAction" value="RAISE_ERROR"/>
									<label for="onDuplicateRaise">Abort</label>
								</span>
								<span class="alignLeft">
									<input type="radio" class="xg" id="onDuplicateOverwrite" name="onDuplicateAction" value="OVERWRITE"/>
									<label for="onDuplicateOverwrite">Overwrite</label>
								</span>
								<span class="alignLeft">
									<input type="radio" class="xg" id="onDuplicateVersion" name="onDuplicateAction" value="VERSION"/>
									<label for="onDuplicateVersion">Version</label>
								</span>
							</div>
						</div>
						<div class="row" style="height:5px;"/>
						<div class="row alignRight" id="doUnzipArchive">
							<img id="btnCancelUnzip" src="/XFILES/lib/icons/cancel.png" alt="Cancel" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
							<span style="width:10px; display:inline-block;"/>
							<img id="btnDoUnzip" src="/XFILES/lib/icons/accept.png" alt="Accept" border="0" width="16" height="16" onclick="doUnzipOperations(document.getElementsByName('onDuplicateAction'));false"/>
						</div>
						<div class="row alignRight" id="doTargetFolder">
							<img id="btnCancelTargetFolder" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
							<span style="width:10px; display:inline-block;"/>
							<img id="btnDoTargetFolder" src="/XFILES/lib/icons/accept.png" alt="Perform Operation" border="0" width="16" height="16" onclick="updateTargetFolder(document.getElementById('deepFolder'));false"/>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="uploadFilesDialog">
		<div style="display: none;" id="uploadFilesDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;width:856px;height:478px;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>File Upload</xsl:text>
							</div>
							<div>
								<iframe id="uploadFilesFrame" style="width:839px;height:438px;borde-styler:none;border-width:0px;margin:0px;padding:0px;" frameBorder="0">
									<!-- <xsl:attribute name="src"><xsl:value-of select="concat('/XFILES/lite/Resource.html?target=',xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath,'&amp;stylesheet=/XFILES/lite/xsl/UploadFiles.xsl')"/></xsl:attribute> -->
									<xsl:attribute name="src">/XFILES/lite/Resource.html?target=/XFILES/lite/xsl/UploadFilesStatus.html&amp;stylesheet=/XFILES/lite/xsl/UploadFiles.xsl</xsl:attribute>
								</iframe>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
