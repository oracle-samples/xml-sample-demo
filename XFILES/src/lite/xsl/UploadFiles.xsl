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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="uploadFileRow">
		<tr class="noBorder">
			<td class="withBorder">
				<select class="inputField" name="DUPLICATE_POLICY" title="Action if target already exists">
					<option selected="selected" value="VERSION">Create New Version</option>
					<option value="RAISE">Raise Error</option>
					<option value="OVERWRITE">Allow Overwrite</option>
				</select>
			</td>
			<td class="withBorder">
				<input class="inputField" name="FILE" title="Source" type="file"/>
			</td>
			<td class="withBorder">
				<input class="inputField" name="RESOURCE_NAME" title="Target File Name" size="30" type="text" maxlength="200"/>
			</td>
			<td class="withBorder">
				<input class="inputField" name="DESCRIPTION" title="Description" size="30" type="text"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="addLangAndCharset">
		<div>
			<div class="alignLeft" style="font-weight:bold;">Use the options below allow to specify the Language and Character Set of the files being uploaded.</div>
			<div class="alignLeft" style="font-weight:bold;">These settings are used for subsequent content searching purposes.</div>
		</div>
		<div>
			<div style="width=60%;float:left;display:table-cell">
				<div style="width:100%">
					<table style="border:0px; margin:0px; padding :0px">
						<tbody>
							<tr>
								<td class="tdLabel">
									<label for="lang">Document Language</label>
								</td>
								<td class="tdValue">
									<select id="lang" name="LANGUAGE">
										<xsl:call-template name="XFilesLanguageOptions"/>
									</select>
								</td>
							</tr>
							<tr>
								<td class="tdLabel">
									<label for="charset">Character Set</label>
								</td>
								<td class="tdValue">
									<select id="charset" name="CHARACTER_SET">
										<xsl:call-template name="XFilesCharacterSetOptions"/>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<div style="float:right;vertical-align:top;text-align:right;display:inline-block;margin-right:10px;" id="Loading">
				<div style="text-align:center">
					<img alt="Loading" src="/XFILES/lib/images/AjaxLoading.gif"/>
				</div>
				<div>
					<xsl:text>Uploading</xsl:text>
				</div>
			</div>
			<div style="clear:both"/>
		</div>
	</xsl:template>
	<xsl:template name="addUploadFields">
		<table class="withBorder defaultFont" summary="">
			<tbody>
				<tr class="tableHeader">
					<th class="alignLeft blueGradient">Duplicate Policy</th>
					<th class="alignLeft blueGradient">File</th>
					<th class="alignLeft blueGradient">Rename (optional)</th>
					<th class="alignLeft blueGradient">Description (optional)</th>
				</tr>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
				<xsl:call-template name="uploadFileRow"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="addFileUploadDialog">
		<div style="height:5px;"/>
		<div>
			<div class="alignLeft" style="font-weight:bold;">Select the files to be uploaded.</div>
			<div class="alignLeft" style="font-weight:bold;">Use the 'rename' field to specify an alternative file name for the target folder</div>
		</div>
		<div style="height:5px;"/>
		<xsl:call-template name="addUploadFields"/>
		<div style="height:5px;"/>
		<xsl:call-template name="addLangAndCharset"/>
		<div style="height:5px;"/>
	</xsl:template>
	<xsl:template name="parameters">
		<input id="targetFolder" name="TARGET_FOLDER" type="hidden">
			<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath"/></xsl:attribute>
		</input>
		<input type="hidden" id="onSuccess" name="ON_SUCCESS_REDIRECT" value="/XFILES/lite/xsl/UploadFilesStatus.html"/>
		<input type="hidden" id="onFailure" name="ON_FAILURE_REDIRECT" value="/XFILES/lite/xsl/UploadFilesStatus.html"/>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/UploadFiles.js</span>
		</div>
		<xsl:call-template name="genericErrorDialog"/>		
			<div class="modal-content">
				<div class="modal-header">
					<div>
						<button type="button" class="close" data-dismiss="modal" onclick="parent.closeUploadFilesDialog();return false;"><span aria-hidden="true">&#215;</span><span class="sr-only">Close</span></button>
						<h4 class="modal-title text-left" id="uploadFilesDialogTitle">UploadFiles</h4>
					</div>
				</div>
				<div class="modal-body">
					<div class="form-horizontal" style="padding-left:20px; padding-right:20px;">
						<div class="form-group">
							<input type="hidden" id="status" value="%STATUS%" name="STATUS"/>
							<input type="hidden" id="errorCode" value="%ERROR_CODE%" name="ERROR_CODE"/>
							<input type="hidden" id="errorMessage" value="%ERROR_MESSAGE%" name="ERROR_MESSAGE"/>
							<input type="hidden" id="repositoryPath" value="%REPOSITORY_PATH%" name="REPOSITORY_PATH"/>
							<form id="uploadFiles" name="uploadFiles" style="margin:0px" enctype="multipart/form-data" method="POST" action="/sys/servlets/XFILES/FileUpload/XFILES.XFILES_DOCUMENT_UPLOAD.UPLOAD">
								<xsl:call-template name="parameters"/>
								<xsl:call-template name="addFileUploadDialog"/>
							</form>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<div>
						<button id="btnCancelIUploadFiles" type="button" class="btn btn-default btn-med" data-dismiss="modal" onclick="parent.closeUploadFilesDialog();return false;">
							<span class="glyphicon glyphicon-ban-circle"></span>
						</button>
						<button id="btnDoUploadFiles" type="button" class="btn btn-default btn-med"  onclick="doUploadFiles();">
							<span class="glyphicon glyphicon-save"></span>
						</button>
					</div>
				</div>
			</div>
	</xsl:template>
</xsl:stylesheet>


