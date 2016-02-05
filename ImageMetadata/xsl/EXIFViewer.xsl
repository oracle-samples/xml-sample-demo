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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles" xmlns:img="http://xmlns.oracle.com/xdb/metadata/ImageMetadata" xmlns:exif="http://xmlns.oracle.com/ord/meta/exif" xmlns:ord="http://xmlns.oracle.com/ord/meta/ordimage" xmlns:xhtml="http://www.w3.org/1999/xhtml">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:include href="/XFILES/Applications/imageMetadata/xsl/EXIFCommon.xsl"/>
	<xsl:template name="editTitleDialog">
		<div class="modal fade" id="editTitleDialog" tabindex="-1" role="dialog" aria-labelledby="editTitleDialogTitle" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="editTitleDialogTitle">Edit Title</h4>
						</div>
					</div>
					<div class="modal-body">
						<div>
							<div class="form-horizontal">
								<div class="form-group">
									<input id="currentImageTitle" type="hidden"/>
									<input class="form-control" id="editImageTitle" name="editImageTitle" maxlength="128" type="text">
										<xsl:attribute name="value">
											<xsl:value-of select="img:imageMetadata/img:Title"/>
										</xsl:attribute>
									</input>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<span id="resetTitleOption" style="display:none;">
								<button id="btnResetTitle" type="button" class="btn btn-default btn-med" data-dismiss="modal" onclick="doResetEditTitle(event);return false;">
									<img src="/XFILES/lib/icons/undoSimpleText.png" alt="Restore Value" border="0" width="16" height="16"/>
								</button>
							</span>
							<button id="btnCancelTitle" type="button" class="btn btn-default btn-med" data-dismiss="modal" onclick="doCancelEditTitle(event);return false;">
								<img src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16"/>
							</button>
							<button id="btnUpdateTitle" type="button" class="btn btn-default btn-med" onclick="doSaveEditTitle(event);return false;">
								<img src="/XFILES/lib/icons/saveAndClose.png" alt="Update Image Title" border="0" width="16" height="16"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="editDescriptionDialog">
		<div style="display: none; width:1000px;" id="editDescriptionDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge">
					<div id="editDescriptionContainer" class="popupBackground">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Edit Image Description (HTML)</xsl:text>
							</div>
							<div class="row">
	  						<div style="height:5px"/>
 		  					<div align="center" id="editImageDescription">
			  					<textarea name="xinhaDescriptionEditor" id="xinhaDescriptionEditor" rows="10" cols="80"/>
				  			</div>
					  		<div style="height:5px;"/>
					  	</div>
							<div class="row" style="width:100%">
								<div style="float:right; text-align:right;" id="editDescriptionControls">
									<span id="resetDescriptionOption" style="display:none;">
										<img id="btnResetTitle" src="/XFILES/lib/icons/undoMultiLineText.png" alt="Restore Value" border="0" width="16" height="16" onclick="xinhaDescription.undoChanges();return false;"/>
										<span style="width:10px; display:inline-block;"/>
									</span>
									<img id="btnCancelDescription" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="xinhaDescription.cancel();return false;"/>
									<span style="width:10px; display:inline-block;"/>
									<img id="btnUpdateDescription" src="/XFILES/lib/icons/saveAndClose.png" alt="Update Image Description" border="0" width="16" height="16" onclick="xinhaDescription.saveChanges();return false;"/>
								</div>
							</div>
							<div style="height:5px;"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="editDescriptionDialog_BOOTSTRAP">
		<div class="modal fade" id="editDescriptionDialog" tabindex="-1" role="dialog" aria-labelledby="editDescriptionDialogTitle" aria-hidden="true">
			<div class="modal-dialog" style="width:1000px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="editDescriptionDialogTitle">Edit Image Description (HTML)</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div align="center" id="editImageDescription">
								<textarea name="xinhaDescriptionEditor" id="xinhaDescriptionEditor" rows="10" cols="64"/>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div id="editDescriptionControls">
							<span id="resetDescriptionOption" style="display:none;">
								<button id="btnResetDescription" type="button" class="btn btn-default btn-med" data-dismiss="modal" onclick="xinhaDescription.undoChanges();return false;">
									<img src="/XFILES/lib/icons/undoMultiLineText.png" alt="Restore Value" border="0" width="16" height="16"/>
								</button>
							</span>
							<button id="btnCancelDescription" type="button" class="btn btn-default btn-med" data-dismiss="modal" onclick="xinhaDescription.cancel();return false;">
								<img src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16"/>
							</button>
							<button id="btnUpdateDescription" type="button" class="btn btn-default btn-med" onclick="xinhaDescription.saveChanges();return false;">
								<img src="/XFILES/lib/icons/saveAndClose.png" alt="Update Image Title" border="0" width="16" height="16"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="Description">
		<div>
			<span class="formText14">
				<xsl:text>Description:</xsl:text>
			</span>
			<div align="left" id="viewImageDescription" style="display:block;"/>
		</div>
	</xsl:template>
	<xsl:template name="EXIFHeader">
		<div id="editTitleControls" class="blueGradient barWithIcons">
			<span id="imageTitle" class="formText14" syle="color=#FFFFF;">
				<xsl:choose>
					<xsl:when test="count(/r:Resource/img:imageMetadata/img:Title/text())> 0">
						<xsl:value-of select="/r:Resource/img:imageMetadata/img:Title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/r:Resource/r:DisplayName"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			<xsl:call-template name="XFilesSaveAndCloseOptions">
				<xsl:with-param name="saveButton" select="'true'"/>
				<xsl:with-param name="saveAndCloseButton" select="'true'"/>
			</xsl:call-template>
			<span style="float:right;display:block;">
				<span style="display:inline-block;width:21px;">
					<img id="btnEditDesc" src="/XFILES/lib/icons/editMultiLineText.png" alt="Edit Title" height="16" width="16" border="0" onclick="xinhaDescription.showEditor();return false;" data-toggle="tooltip" data-placement="top" title="Edit Image Description."/>
				</span>
			</span>
			<span style="float:right;display:block;">
				<span style="display:inline-block;width:21px;">
					<img id="btnEditTitle" src="/XFILES/lib/icons/editSimpleText.png" alt="Edit Title" height="16" width="16" border="0" onclick="doOpenEditTitle(event);return false;" data-toggle="tooltip" data-placement="top" title="Edit Image Title."/>
				</span>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/Applications/imageMetadata/js/EXIFViewer.js</span>
			<span>/XFILES/lite/js/XinhaInit.js</span>
			<span>/XFILES/Frameworks/Xinha/XinhaCore.js</span>
		</div>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'View Image'"/>
		</xsl:call-template>
		<xsl:call-template name="EXIFHeader"/>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource">
					<div id="upperSpacer" style="clear:both;height:5px;width:100%;"/>
					<xsl:call-template name="editTitleDialog"/>
					<xsl:call-template name="editDescriptionDialog"/>
					<div id="imageContainer" style="float:left;">
						<xsl:if test="substring-before(r:ContentType,'/')='image'">
							<img id="image" alt="Unavailable">
								<xsl:attribute name="src">
									<xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/>
								</xsl:attribute>
							</img>
						</xsl:if>
					</div>
					<div id="propertyContainer" style="float:right;width:280px">
						<xsl:call-template name="Properties"/>
					</div>
					<div style="clear:both;height:5px;"/>
					<xsl:call-template name="XFilesSeperator">
						<xsl:with-param name="height" select="'12px'"/>
					</xsl:call-template>
					<xsl:call-template name="Description"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
