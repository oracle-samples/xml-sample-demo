<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles" xmlns:img="http://xmlns.oracle.com/xdb/metadata/ImageMetadata" xmlns:exif="http://xmlns.oracle.com/ord/meta/exif" xmlns:ord="http://xmlns.oracle.com/ord/meta/ordimage" xmlns:xhtml="http://www.w3.org/1999/xhtml">
	<xsl:output version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:include href="/XFILES/Applications/imageMetadata/xsl/EXIFCommon.xsl"/>
	<xsl:template name="editTitleDialog">
		<div style="display: none;" id="editTitleDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: 10px; left: 10px;">
					<div class="popupBackground" style="width:520px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Edit Image Title</xsl:text>
							</div>
							<div style="height:5px"/>
							<div style="display:table-row">
								<input id="currentImageTitle" type="hidden"/>
								<span style="display:table-cell;">
									<input id="editImageTitle" name="editImageTitle" size="80" maxlength="80" type="text">
										<xsl:attribute name="value"><xsl:value-of select="img:imageMetadata/img:Title"/></xsl:attribute>
									</input>
								</span>
							</div>
							<div style="height:5px;"/>
							<div style="text-align:right;">
								<span id="resetTitleOption" style=":display:none;">
									<img id="btnResetTitle" src="/XFILES/lib/icons/undoSimpleText.png" alt="Restore Value" border="0" width="16" height="16" onclick="doResetEditTitle(event);return false;"/>
									<span style="width:10px; display:inline-block;"/>
								</span>
								<img id="btnCancelTitle" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="doCancelEditTitle(event);return false;"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnUpdateTitle" src="/XFILES/lib/icons/saveAndClose.png" alt="Update Image Title" border="0" width="16" height="16" onclick="doSaveEditTitle(event);return false;"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="editDescriptionDialog">
		<div style="display: none;" id="editDescriptionDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: 10px; left: 10px;">
					<div id="editDescriptionContainer" class="popupBackground" style="width:670px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Edit Image Description (HTML)</xsl:text>
							</div>
							<div style="height:5px"/>
							<div align="center">
								<textarea name="xinhaDescriptionEditor" id="xinhaDescriptionEditor" rows="10" cols="80"/>
							</div>
							<div style="height:5px;"/>
							<div style="text-align:right;">
								<span id="resetDescriptionOption" style="display:none;">
									<img id="btnResetTitle" src="/XFILES/lib/icons/undoMultiLineText.png" alt="Restore Value" border="0" width="16" height="16" onclick="doResetEditDescription(event);return false;"/>
									<span style="width:10px; display:inline-block;"/>
								</span>
								<img id="btnCancelDescription" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="doCancelEditDescription(event);return false;"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnUpdateDescription" src="/XFILES/lib/icons/saveAndClose.png" alt="Update Image Description" border="0" width="16" height="16" onclick="doSaveEditDescription(event);return false;"/>
							</div>
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
			<div align="left" id="viewDescription" style="display:block;"/>
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
						<img id="btnEditDesc" src="/XFILES/lib/icons/editMultiLineText.png" alt="Edit Title" height="16" width="16" border="0" onclick="javascript:doOpenEditDescription(event);return false;" data-toggle="tooltip" data-placement="top" title="Edit Image Description."/>
				</span>
			</span>
			<span style="float:right;display:block;">
				<span style="display:inline-block;width:21px;">
						<img id="btnEditTitle" src="/XFILES/lib/icons/editSimpleText.png" alt="Edit Title" height="16" width="16" border="0" onclick="javascript:doOpenEditTitle(event);return false;" data-toggle="tooltip" data-placement="top" title="Edit Image Title."/>
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
								<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
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
