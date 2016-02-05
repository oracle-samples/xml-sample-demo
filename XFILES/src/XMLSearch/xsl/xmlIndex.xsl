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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/XMLSearch/xsl/common.xsl"/>
	<xsl:template name="indexSummary">
		<div class="inputFormBorder" style="width:100%">
			<input id="uploadFolder" name="uploadFolder" type="hidden"/>
			<span class="labelAndValue">
				<span class="labelRight">Table Owner</span>
				<span style="display:inline-block;width:5px"/>
				<input id="tableOwner" name="tableOwner" size="32" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<span class="labelAndValue">
				<input id="columnName" name="columnName" type="hidden"/>
				<span class="labelRight">Table Name</span>
				<span style="display:inline-block;width:5px"/>
				<input id="tableName" name="tableName" size="32" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<span class="labelAndValue">
				<span class="labelRight">Index Name</span>
				<span style="display:inline-block;width:5px"/>
				<input id="indexName" name="indexName" size="32" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<span class="labelAndValue">
				<span class="labelRight">Path Table</span>
				<span style="display:inline-block;width:5px"/>
				<input id="pathTable" name="pathTable" size="40" type="text" maxlength="32" disabled="disabled"/>
			</span>
		</div>
	</xsl:template>
		<xsl:template name="uploadFilesDialog">
			<div style="display: none;" id="uploadFilesDialog" onclick="stopBubble(event)">
				<div style="position:relative; top: 0ex">
					<div class="popupOuterEdge" style="top: -7px; right: 15px;width:856px;height:478px;">
						<div class="popupBackground">
							<div class="popupInnerEdge">
								<div class="row popupTitle">
									<xsl:text>File Upload</xsl:text>
								</div>
								<div>
									<iframe id="uploadFilesFrame" style="width:839px;height:438px;borde-styler:none;border-width:0px;margin:0px;padding:0px;" frameBorder="0">
										<xsl:attribute name="src"><xsl:value-of select="concat('/XFILES/lite/Resource.html?target=',xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath,'&amp;stylesheet=/XFILES/lite/xsl/UploadFiles.xsl')"/></xsl:attribute>
									</iframe>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:template>
	<xsl:template match="/">
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Oracle XML DB XML Index Data Guide'"/>
		</xsl:call-template>
		<xsl:call-template name="viewCurrentSQL"/>
		<xsl:call-template name="searchActions"/>
		<xsl:call-template name="uploadFilesDialog"/>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource">
					<div style="height:5px;"/>
					<xsl:call-template name="indexSummary"/>
					<div style="height:5px;"/>
					<div id="treeView" class="searchTree"/>
					<xsl:call-template name="searchRegions"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="searchFooter"/>
	</xsl:template>
</xsl:stylesheet>
